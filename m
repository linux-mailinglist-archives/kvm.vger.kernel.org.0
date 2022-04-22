Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A7D50B549
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 12:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446724AbiDVKjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 06:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446651AbiDVKjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 06:39:41 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26435E025
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 03:36:49 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E10631576;
        Fri, 22 Apr 2022 03:36:48 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C22783F766;
        Fri, 22 Apr 2022 03:36:47 -0700 (PDT)
Date:   Fri, 22 Apr 2022 11:36:47 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com
Subject: Re: [PATCH kvmtool 5/5] mmio: Sanitize addr and len
Message-ID: <YmKFKt42czKtEU9Z@monolith.localdoman>
References: <20220303231050.2146621-1-martin.b.radev@gmail.com>
 <20220303231050.2146621-6-martin.b.radev@gmail.com>
 <YjIEyxwAPw2c2fdM@monolith.localdoman>
 <YkDQbtdFvZteTByI@sisu-ThinkPad-E14-Gen-2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkDQbtdFvZteTByI@sisu-ThinkPad-E14-Gen-2>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Mon, Mar 28, 2022 at 12:00:30AM +0300, Martin Radev wrote:
> Thanks Alex.
> 
> I needed to make a small update to the patch as you recommented in one
> of the other emails. I still kept the reviewed by line with your name.

That's quite fine, please send it in a new iteration of the series.

Thanks,
Alex

> 
> From 090f373c0bc868cc4551620568d47b21b6ac044a Mon Sep 17 00:00:00 2001
> From: Martin Radev <martin.b.radev@gmail.com>
> Date: Mon, 17 Jan 2022 23:17:25 +0200
> Subject: [PATCH kvmtool 2/6] mmio: Sanitize addr and len
> 
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
> +
>  	for (i = 0; i < len; i++) {
>  		if (is_write)
>  			vdev->ops->get_config(vmmio->kvm, vmmio->dev)[addr + i] =
> -- 
> 2.25.1
> 
> On Wed, Mar 16, 2022 at 03:39:55PM +0000, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Fri, Mar 04, 2022 at 01:10:50AM +0200, Martin Radev wrote:
> > > This patch verifies that adding the addr and length arguments
> > > from an MMIO op do not overflow. This is necessary because the
> > > arguments are controlled by the VM. The length may be set to
> > > an arbitrary value by using the rep prefix.
> > > 
> > > Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
> > 
> > The patch looks correct to me:
> > 
> > Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > 
> > Thanks,
> > Alex
> > 
> > > ---
> > >  mmio.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/mmio.c b/mmio.c
> > > index a6dd3aa..5a114e9 100644
> > > --- a/mmio.c
> > > +++ b/mmio.c
> > > @@ -32,6 +32,10 @@ static struct mmio_mapping *mmio_search(struct rb_root *root, u64 addr, u64 len)
> > >  {
> > >  	struct rb_int_node *node;
> > >  
> > > +	/* If len is zero or if there's an overflow, the MMIO op is invalid. */
> > > +	if (addr + len <= addr)
> > > +		return NULL;
> > > +
> > >  	node = rb_int_search_range(root, addr, addr + len);
> > >  	if (node == NULL)
> > >  		return NULL;
> > > -- 
> > > 2.25.1
> > > 
