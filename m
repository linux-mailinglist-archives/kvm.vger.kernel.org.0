Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E930450B4C1
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 12:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446450AbiDVKPJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 06:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446446AbiDVKPI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 06:15:08 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24A1D53A7E
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 03:12:15 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E819C1477;
        Fri, 22 Apr 2022 03:12:14 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A195D3F766;
        Fri, 22 Apr 2022 03:12:13 -0700 (PDT)
Date:   Fri, 22 Apr 2022 11:12:09 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com
Subject: Re: [PATCH kvmtool 2/5] virtio: Sanitize config accesses
Message-ID: <YmJ/ebYEP7tcrxem@monolith.localdoman>
References: <20220303231050.2146621-1-martin.b.radev@gmail.com>
 <20220303231050.2146621-3-martin.b.radev@gmail.com>
 <YjHgCrYF20UhtwWc@monolith.localdoman>
 <YkDK7L4vU/DpGmCN@sisu-ThinkPad-E14-Gen-2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkDK7L4vU/DpGmCN@sisu-ThinkPad-E14-Gen-2>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Sun, Mar 27, 2022 at 11:37:00PM +0300, Martin Radev wrote:
> 
> Thank you for the review.
> Answers are inline.
> Here are the two patches:
> 
> int to u32 patch:
> 
> From ddedd3a59b41d97e07deac59af177b360cc04b20 Mon Sep 17 00:00:00 2001
> From: Martin Radev <martin.b.radev@gmail.com>
> Date: Thu, 24 Mar 2022 23:24:57 +0200
> Subject: [PATCH kvmtool 3/6] virtio: Use u32 instead of int in pci_data_in/out
> 
> The PCI access size type is changed from a signed type
> to an unsigned type since the size is never expected to
> be negative, and the type also matches the type in the
> signature of virtio_pci__io_mmio_callback.
> This change simplifies size checking in the next patch.
> 
> Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
> ---
>  virtio/pci.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/virtio/pci.c b/virtio/pci.c
> index 2777d1c..bcb205a 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -116,7 +116,7 @@ static inline bool virtio_pci__msix_enabled(struct virtio_pci *vpci)
>  }
>  
>  static bool virtio_pci__specific_data_in(struct kvm *kvm, struct virtio_device *vdev,
> -					 void *data, int size, unsigned long offset)
> +					 void *data, u32 size, unsigned long offset)
>  {
>  	u32 config_offset;
>  	struct virtio_pci *vpci = vdev->virtio;
> @@ -146,7 +146,7 @@ static bool virtio_pci__specific_data_in(struct kvm *kvm, struct virtio_device *
>  }
>  
>  static bool virtio_pci__data_in(struct kvm_cpu *vcpu, struct virtio_device *vdev,
> -				unsigned long offset, void *data, int size)
> +				unsigned long offset, void *data, u32 size)
>  {
>  	bool ret = true;
>  	struct virtio_pci *vpci;
> @@ -211,7 +211,7 @@ static void update_msix_map(struct virtio_pci *vpci,
>  }
>  
>  static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device *vdev,
> -					  void *data, int size, unsigned long offset)
> +					  void *data, u32 size, unsigned long offset)
>  {
>  	struct virtio_pci *vpci = vdev->virtio;
>  	u32 config_offset, vec;
> @@ -285,7 +285,7 @@ static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device
>  }
>  
>  static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vdev,
> -				 unsigned long offset, void *data, int size)
> +				 unsigned long offset, void *data, u32 size)
>  {
>  	bool ret = true;
>  	struct virtio_pci *vpci;
> -- 
> 2.25.1

That looks good to me. Please send it as a separate patch in the next
version of the series.

> 
> Original patch but with comments addressed:

If you change the patch, the new version should be sent as a new series.
The version of the series should be reflected in the subject of each patch.
For example, this series should have been v2, which means the prefix for
the patches should have been: PATCH v2 kvmtool [..]. This can be
accomplished with git format-patch directly, by using the command line
argument --subject-prefix="PATCH v2 kvmtool". The next iteration of the
series will be v3, and so on.

This is done to make it easier for everyone to keep track of the latest
version of a patch set. It's also easier to review and test a new version
of a patch when it is standalone than when it is attached to an email
containing several other things.

For example, you've attached two patches to this email, which can cause
confusion about the order of the patches. This can be easily avoided by
sending the changes in a separate series.

I'll reply to your comments below.

> On Wed, Mar 16, 2022 at 01:04:08PM +0000, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Fri, Mar 04, 2022 at 01:10:47AM +0200, Martin Radev wrote:
> > > The handling of VIRTIO_PCI_O_CONFIG is prone to buffer access overflows.
> > > This patch sanitizes this operation by using the newly added virtio op
> > > get_config_size. Any access which goes beyond the config structure's
> > > size is prevented and a failure is returned.
> > > 
> > > Additionally, PCI accesses which span more than a single byte are prevented
> > > and a warning is printed because the implementation does not currently
> > > support the behavior correctly.
> > > 
> > > Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
> > > ---
> > >  include/kvm/virtio-9p.h |  1 +
> > >  include/kvm/virtio.h    |  1 +
> > >  virtio/9p.c             | 25 ++++++++++++++++++++-----
> > >  virtio/balloon.c        |  8 ++++++++
> > >  virtio/blk.c            |  8 ++++++++
> > >  virtio/console.c        |  8 ++++++++
> > >  virtio/mmio.c           | 24 ++++++++++++++++++++----
> > >  virtio/net.c            |  8 ++++++++
> > >  virtio/pci.c            | 38 ++++++++++++++++++++++++++++++++++++++
> > >  virtio/rng.c            |  6 ++++++
> > >  virtio/scsi.c           |  8 ++++++++
> > >  virtio/vsock.c          |  8 ++++++++
> > >  12 files changed, 134 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/include/kvm/virtio-9p.h b/include/kvm/virtio-9p.h
> > > index 3ea7698..77c5062 100644
> > > --- a/include/kvm/virtio-9p.h
> > > +++ b/include/kvm/virtio-9p.h
> > > @@ -44,6 +44,7 @@ struct p9_dev {
> > >  	struct virtio_device	vdev;
> > >  	struct rb_root		fids;
> > >  
> > > +	size_t config_size;
> > >  	struct virtio_9p_config	*config;
> > >  	u32			features;
> > >  
> > > diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
> > > index 3a311f5..3880e74 100644
> > > --- a/include/kvm/virtio.h
> > > +++ b/include/kvm/virtio.h
> > > @@ -184,6 +184,7 @@ struct virtio_device {
> > >  
> > >  struct virtio_ops {
> > >  	u8 *(*get_config)(struct kvm *kvm, void *dev);
> > > +	size_t (*get_config_size)(struct kvm *kvm, void *dev);
> > >  	u32 (*get_host_features)(struct kvm *kvm, void *dev);
> > >  	void (*set_guest_features)(struct kvm *kvm, void *dev, u32 features);
> > >  	int (*get_vq_count)(struct kvm *kvm, void *dev);
> > > diff --git a/virtio/9p.c b/virtio/9p.c
> > > index b78f2b3..6074f3a 100644
> > > --- a/virtio/9p.c
> > > +++ b/virtio/9p.c
> > > @@ -1375,6 +1375,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
> > >  	return ((u8 *)(p9dev->config));
> > >  }
> > >  
> > > +static size_t get_config_size(struct kvm *kvm, void *dev)
> > > +{
> > > +	struct p9_dev *p9dev = dev;
> > > +
> > > +	return p9dev->config_size;
> > > +}
> > > +
> > >  static u32 get_host_features(struct kvm *kvm, void *dev)
> > >  {
> > >  	return 1 << VIRTIO_9P_MOUNT_TAG;
> > > @@ -1469,6 +1476,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
> > >  
> > >  struct virtio_ops p9_dev_virtio_ops = {
> > >  	.get_config		= get_config,
> > > +	.get_config_size	= get_config_size,
> > >  	.get_host_features	= get_host_features,
> > >  	.set_guest_features	= set_guest_features,
> > >  	.init_vq		= init_vq,
> > > @@ -1568,7 +1576,9 @@ virtio_dev_init(virtio_9p__init);
> > >  int virtio_9p__register(struct kvm *kvm, const char *root, const char *tag_name)
> > >  {
> > >  	struct p9_dev *p9dev;
> > > -	int err = 0;
> > > +	size_t tag_name_length;
> > 
> > I think it would be better to name the variable tag_len, the same name as
> > the corresponding field in struct virtio_9p_config. As a bonus, it's also
> > shorter. But this is personal preference in the end, so I leave it up to
> > you to decide which works better.
> > 
> Done.
> 
> > > +	size_t config_size;
> > > +	int err;
> > >  
> > >  	p9dev = calloc(1, sizeof(*p9dev));
> > >  	if (!p9dev)
> > > @@ -1577,29 +1587,34 @@ int virtio_9p__register(struct kvm *kvm, const char *root, const char *tag_name)
> > >  	if (!tag_name)
> > >  		tag_name = VIRTIO_9P_DEFAULT_TAG;
> > >  
> > > -	p9dev->config = calloc(1, sizeof(*p9dev->config) + strlen(tag_name) + 1);
> > > +	tag_name_length = strlen(tag_name);
> > > +	/* The tag_name zero byte is intentionally excluded */
> > 
> > If this is indeed a bug (the comment from virtio_9p_config seems to suggest
> > it is, but I couldn't find the 9p spec), the bug is that the config size is
> > computed incorrectly, which is a different bug than a guest being able to
> > write outside of the config region for the device. As such, it should be
> > fixed in a separate patch.
> > 
> I couldn't find information about how large the configuration size is and
> whether the 0 byte is included. QEMU explicitly excludes it.
> See https://elixir.bootlin.com/qemu/latest/source/hw/9pfs/virtio-9p-device.c#L218
> I think this is almost surely the correct way considering the tag length
> is also part of the config.

I think I haven't managed to make myself clear. I agree that the NUL
terminating byte shouldn't be taken into account when calculating the
config size. What I was referring to is the fact that there two different
bugs here:

1. The config size is calculated incorrectly in the existing code:

p9dev->config = calloc(1, sizeof(*p9dev->config) + strlen(tag_name) + 1);

The code shouldn't add that one byte to the size, which presumably
represent the NUL terminating byte from the tag_name string.

2. The code doesn't check for overflow.

Your patch tries to fix both bugs in one go. What I was suggesting is to
write a standalone patch that fixes bug #1, and keep this patch that adds
the overflow check, minus the fix for #1. This makes everything cleaner,
easier to review and test, and easier to diagnose and fix or revert if the
fix turns out to be wrong.

Thanks,
Alex
