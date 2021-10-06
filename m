Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3161E4240F4
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 17:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239204AbhJFPNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 11:13:32 -0400
Received: from foss.arm.com ([217.140.110.172]:35736 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239159AbhJFPNY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Oct 2021 11:13:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 066A16D;
        Wed,  6 Oct 2021 08:11:32 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B68C3F66F;
        Wed,  6 Oct 2021 08:11:31 -0700 (PDT)
Date:   Wed, 6 Oct 2021 16:11:28 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, jean-philippe@linaro.org
Subject: Re: [PATCH v1 kvmtool 6/7] vfio/pci: Print an error when offset is
 outside of the MSIX table or PBA
Message-ID: <20211006161128.4855aafa@donnerap.cambridge.arm.com>
In-Reply-To: <20210913154413.14322-7-alexandru.elisei@arm.com>
References: <20210913154413.14322-1-alexandru.elisei@arm.com>
        <20210913154413.14322-7-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Sep 2021 16:44:12 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Now that we keep track of the real size of MSIX table and PBA, print an
> error when the guest tries to write to an offset which is not inside the
> correct regions.

What is the actual purpose of this message? Is there anything the user can
do about it? Shouldn't we either abort the guest or inject an error
condition back into KVM or the guest instead?

Cheers,
Andre

> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  vfio/pci.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/vfio/pci.c b/vfio/pci.c
> index 7781868..a6d0408 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -249,6 +249,11 @@ static void vfio_pci_msix_pba_access(struct kvm_cpu
> *vcpu, u64 addr, u8 *data, u64 offset = addr - pba->guest_phys_addr;
>  	struct vfio_device *vdev = container_of(pdev, struct
> vfio_device, pci); 
> +	if (offset >= pba->size) {
> +		vfio_dev_err(vdev, "access outside of the MSIX PBA");
> +		return;
> +	}
> +
>  	if (is_write)
>  		return;
>  
> @@ -269,6 +274,10 @@ static void vfio_pci_msix_table_access(struct
> kvm_cpu *vcpu, u64 addr, u8 *data, struct vfio_device *vdev =
> container_of(pdev, struct vfio_device, pci); 
>  	u64 offset = addr - pdev->msix_table.guest_phys_addr;
> +	if (offset >= pdev->msix_table.size) {
> +		vfio_dev_err(vdev, "access outside of the MSI-X table");
> +		return;
> +	}
>  
>  	size_t vector = offset / PCI_MSIX_ENTRY_SIZE;
>  	off_t field = offset % PCI_MSIX_ENTRY_SIZE;

