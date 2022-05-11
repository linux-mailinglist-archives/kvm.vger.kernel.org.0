Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7497523B76
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 19:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345514AbiEKR0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 13:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345524AbiEKR0D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 13:26:03 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 167AC15A12
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 10:26:01 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E601B1042;
        Wed, 11 May 2022 10:26:00 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B9B03F73D;
        Wed, 11 May 2022 10:26:00 -0700 (PDT)
Date:   Wed, 11 May 2022 18:26:05 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     kvm@vger.kernel.org, will@kernel.org
Subject: Re: [PATCH v3 kvmtool 2/6] mmio: Sanitize addr and len
Message-ID: <YnvxXqWASRcrOoMZ@monolith.localdoman>
References: <20220509203940.754644-1-martin.b.radev@gmail.com>
 <20220509203940.754644-3-martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509203940.754644-3-martin.b.radev@gmail.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Martin,

On Mon, May 09, 2022 at 11:39:36PM +0300, Martin Radev wrote:
> This patch verifies that adding the addr and length arguments
> from an MMIO op do not overflow. This is necessary because the
> arguments are controlled by the VM. The length may be set to
> an arbitrary value by using the rep prefix.
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
> ---
>  mmio.c        | 4 ++++
>  virtio/mmio.c | 6 ++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/mmio.c b/mmio.c
> index a6dd3aa..5a114e9 100644
> --- a/mmio.c
> +++ b/mmio.c
> @@ -32,6 +32,10 @@ static struct mmio_mapping *mmio_search(struct rb_root *root, u64 addr, u64 len)
>  {
>  	struct rb_int_node *node;
>  
> +	/* If len is zero or if there's an overflow, the MMIO op is invalid. */
> +	if (addr + len <= addr)
> +		return NULL;
> +
>  	node = rb_int_search_range(root, addr, addr + len);
>  	if (node == NULL)
>  		return NULL;
> diff --git a/virtio/mmio.c b/virtio/mmio.c
> index 875a288..979fa8c 100644
> --- a/virtio/mmio.c
> +++ b/virtio/mmio.c
> @@ -105,6 +105,12 @@ static void virtio_mmio_device_specific(struct kvm_cpu *vcpu,
>  	struct virtio_mmio *vmmio = vdev->virtio;
>  	u32 i;
>  
> +	/* Check for wrap-around and zero length. */
> +	if (addr + len <= addr) {
> +		WARN_ONCE(1, "addr (%llu) + length (%u) wraps-around.\n", addr, len);
> +		return;
> +	}

This is _NOT_ needed.

When a VCPU exits with exit_reason set to KVM_EXIT_MMIO, kvmtool searches
for the virtio-mmio callback (which ends up calling
virtio_mmio_device_specific) in kvm_cpu__emulate_mmio() ->
kvm__emulate_mmio() -> mmio_search(), which already contains the overflow
check. The virtio_mmio_device_specific() checks above is redundant.

Please remove the above 5 lines of code.

Thanks,
Alex

> +
>  	for (i = 0; i < len; i++) {
>  		if (is_write)
>  			vdev->ops->get_config(vmmio->kvm, vmmio->dev)[addr + i] =
> -- 
> 2.25.1
> 
