Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 182FA15373D
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 19:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgBESHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 13:07:15 -0500
Received: from foss.arm.com ([217.140.110.172]:50606 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbgBESHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 13:07:15 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD18C1FB;
        Wed,  5 Feb 2020 10:07:14 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 751523F52E;
        Wed,  5 Feb 2020 10:07:12 -0800 (PST)
Subject: Re: [PATCH kvmtool 03/16] virtio/scsi: Allow the use of multiple
 banks
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, julien.grall@arm.com, andre.przywara@arm.com
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
 <1569245722-23375-4-git-send-email-alexandru.elisei@arm.com>
From:   Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
Message-ID: <6da71eed-326d-c93d-43ad-9bf37309cc2d@arm.com>
Date:   Wed, 5 Feb 2020 18:07:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <1569245722-23375-4-git-send-email-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/2019 14:35, Alexandru Elisei wrote:
> From: Julien Grall <julien.grall@arm.com>
> 
> At the moment, virtio scsi registers only one bank starting at 0. On some
> architectures (like on x86, for example), this may not be true and the
> guest may have multiple memory regions.
> 
> Register all the memory regions to vhost by browsing kvm->mem_banks. The
> code is based on the virtio_net__vhost_init implementation.
> 
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   virtio/scsi.c | 21 +++++++++++++--------
>   1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/virtio/scsi.c b/virtio/scsi.c
> index a72bb2a9a206..63fc4f4635a2 100644
> --- a/virtio/scsi.c
> +++ b/virtio/scsi.c
> @@ -190,24 +190,29 @@ static struct virtio_ops scsi_dev_virtio_ops = {
>   
>   static void virtio_scsi_vhost_init(struct kvm *kvm, struct scsi_dev *sdev)
>   {
> +	struct kvm_mem_bank *bank;
>   	struct vhost_memory *mem;
>   	u64 features;
> -	int r;
> +	int r, i;
>   
>   	sdev->vhost_fd = open("/dev/vhost-scsi", O_RDWR);
>   	if (sdev->vhost_fd < 0)
>   		die_perror("Failed openning vhost-scsi device");
>   
> -	mem = calloc(1, sizeof(*mem) + sizeof(struct vhost_memory_region));
> +	mem = calloc(1, sizeof(*mem) + kvm->mem_slots * sizeof(struct vhost_memory_region));
>   	if (mem == NULL)
>   		die("Failed allocating memory for vhost memory map");
>   
> -	mem->nregions = 1;
> -	mem->regions[0] = (struct vhost_memory_region) {
> -		.guest_phys_addr	= 0,
> -		.memory_size		= kvm->ram_size,
> -		.userspace_addr		= (unsigned long)kvm->ram_start,
> -	};
> +	i = 0;
> +	list_for_each_entry(bank, &kvm->mem_banks, list) {
> +		mem->regions[i] = (struct vhost_memory_region) {
> +			.guest_phys_addr	= bank->guest_phys_addr,
> +			.memory_size		= bank->size,
> +			.userspace_addr		= (unsigned long)bank->host_addr,
> +		};
> +		i++;
> +	}
> +	mem->nregions = i;
>   

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
