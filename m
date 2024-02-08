Return-Path: <kvm+bounces-8377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D68E84EA19
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 22:09:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12FEA1F2EED7
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 21:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEAD14F1EC;
	Thu,  8 Feb 2024 21:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PlXMCfLc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8284D48799
	for <kvm@vger.kernel.org>; Thu,  8 Feb 2024 21:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707426527; cv=none; b=X6k4l7MXXyUKU6jH9HQ/A+6va4Lfx7E+/lqouneEJ1An1Isy4PAukj2pkRRc3cUyUxAfDtfCuMk2iBz3RIqWIYWtTbzMe+kPouzcWojRjkGPfAGgPcacUdXcg4ZKftrrLDZ8cvOaqwa7clMO3jgLZCcHI9ZZ/ikAI+/jMHujI54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707426527; c=relaxed/simple;
	bh=NJd5ro/Dk6gqk+wousDZO3e2YpebOtIF9SpkKM9kPs8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JYzzV74Gc5r6ujLyuHnJNhnhFmIK3conBgxsHjmnEN5af3cUfTvujhBfT/7kMM4M0ZScEV/jtb2+7nn8/g4ObNH2wLZVOpD6tvDu0zje5Lj2BXnfyB6A8cYxHMfJ7hCSWfshh4w8qKvgOjCQcnhMEkP62ygKgcDL8fV3ILUxLFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PlXMCfLc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707426523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n6Lom6fJfEX98E0m960fMPaVVmvrlkRK2vpWlXZeIZM=;
	b=PlXMCfLcRmeTfGFnM2nzZmp9itXNZWF4/+w78+1k8gVf2VoX8U0n8tszzl61r1Iao8/X/f
	dMJomwleoa1ZjO425uyomR6w/NMkrcDexIwWFMDWCGqo1guGcQGVy4kGvzJnt/Cra4Z00T
	XkIcAnhqAKGuFI5+SPrGYBMcwEJiiRk=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-BmH7sSTSNZuA_yAtRG8A8Q-1; Thu, 08 Feb 2024 16:08:40 -0500
X-MC-Unique: BmH7sSTSNZuA_yAtRG8A8Q-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7c02ed38aa5so14896839f.3
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 13:08:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707426519; x=1708031319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n6Lom6fJfEX98E0m960fMPaVVmvrlkRK2vpWlXZeIZM=;
        b=RLNnAHrLWRgWcEcpi2SALjg1thwQ+XMg5wsPmOyBlY5OJj12tZo/g5pvQ7EKk6M8/K
         C9Eql70E1AVhNx8B0Q1iQbpTbHdQbxgyBFpY3gH+/8jAEKM4flba4j+y0JB4/Jx+7M8F
         EAFhEuRSVtTcZ0+m290uYdrcoNiKbbG+Tqq1z6XRIbcSE6Fds18X5yAWJHiMK8EbN9TI
         VHZF2KiGwgW1eNM7KR/MC4M0zGtQtgj7Uqky3LWKPRcMHIv3X8MOg/kAXHATuGH9Fbuv
         NNGVe76hwgG0UWKs2kStXCCQoPaRuWwSph692XwV39Swxf1lYCreOt4h0ANfQ0FfohWv
         x8tw==
X-Forwarded-Encrypted: i=1; AJvYcCV6Ajb3DZlZcThaCYHWh7AjjeB3ZRNrZKhNNxwDV7Plwp209WPyTeRkchmS2EFrlpd/Sfv99Y40vqX5iQSKa2rsDc56
X-Gm-Message-State: AOJu0YyNNUM6xrKRAaRMKUvehFpQH5WSNzTfHbyvPKSeoEjRmu4NitC2
	vLrO7KvBvme1ix/x0ErF7efW3abMq3Od77TXLEQOCRfJeL9/H2nWaaKKUAOL8oWi4zOb8G+9NmY
	XCqgf8sc1e1Iz9afdCXAMCg2pjimBsq0gaQyinwnQiwdAW7OUrQ==
X-Received: by 2002:a6b:5b14:0:b0:7c3:f542:66d5 with SMTP id v20-20020a6b5b14000000b007c3f54266d5mr1049998ioh.4.1707426519212;
        Thu, 08 Feb 2024 13:08:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFZQ2zdMK0ogtlSgUF6h1GEGSod27Nz77anah68mxU9CUZ87LOYvVB84P/FMytNVpRB3ljpww==
X-Received: by 2002:a6b:5b14:0:b0:7c3:f542:66d5 with SMTP id v20-20020a6b5b14000000b007c3f54266d5mr1049975ioh.4.1707426518924;
        Thu, 08 Feb 2024 13:08:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW38rfROHn9z/eBTCsfQUaiaXUIqanljDwgob2akrCPyr+WOFBAFABd+odnSrd6cPEvclnjvROBSHS110I8o6p9P/wPhNFNLMzz9GGLdVTYdaxQg5pja5pGlpI2ajqQrYPVS4+BjWWqhw/sXlmmRuDVf/JAqowZMOBkG2pi5xgyEEVMWCpRB/b9NakJUVwT4CnVKSx4HZX/E/I6pMhBAQhVkFNQx4hLFRxBSAJxwxEpLfrZ58LeLu89A1LQKQlNKYasInlDHIK3VpaPkW0jNm1X3g6axL+QO1yWhWYO0Q65brwkOY68iiT9tcaLBF1UWQx3qZfUuA==
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id m7-20020a02c887000000b00470f2874365sm46817jao.137.2024.02.08.13.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 13:08:38 -0800 (PST)
Date: Thu, 8 Feb 2024 14:08:36 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <kvm@vger.kernel.org>, <dave.jiang@intel.com>, <ashok.raj@intel.com>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 15/17] vfio/pci: Let enable and disable of interrupt
 types use same signature
Message-ID: <20240208140836.76a212d3.alex.williamson@redhat.com>
In-Reply-To: <63ba0079-a035-4595-a40e-8c063b4a59eb@intel.com>
References: <cover.1706849424.git.reinette.chatre@intel.com>
	<bf87e46c249941ebbfacb20ee9ff92e8efd2a595.1706849424.git.reinette.chatre@intel.com>
	<20240205153542.0883e2ff.alex.williamson@redhat.com>
	<5784cc9b-697a-40fa-99b0-b75530f51214@intel.com>
	<20240206150341.798bb9fe.alex.williamson@redhat.com>
	<ce617344-ab6e-49f3-adbd-47be9fb87bf9@intel.com>
	<20240206161934.684237d3.alex.williamson@redhat.com>
	<63ba0079-a035-4595-a40e-8c063b4a59eb@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 7 Feb 2024 15:30:15 -0800
Reinette Chatre <reinette.chatre@intel.com> wrote:

> Hi Alex,
> 
> On 2/6/2024 3:19 PM, Alex Williamson wrote:
> > On Tue, 6 Feb 2024 14:22:04 -0800
> > Reinette Chatre <reinette.chatre@intel.com> wrote:  
> >> On 2/6/2024 2:03 PM, Alex Williamson wrote:  
> >>> On Tue, 6 Feb 2024 13:46:37 -0800
> >>> Reinette Chatre <reinette.chatre@intel.com> wrote:  
> >>>> On 2/5/2024 2:35 PM, Alex Williamson wrote:    
> >>>>> On Thu,  1 Feb 2024 20:57:09 -0800
> >>>>> Reinette Chatre <reinette.chatre@intel.com> wrote:      
> >>>>
> >>>> ..
> >>>>    
> >>>>>> @@ -715,13 +724,13 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
> >>>>>>  		if (is_intx(vdev))
> >>>>>>  			return vfio_irq_set_block(vdev, start, count, fds, index);
> >>>>>>  
> >>>>>> -		ret = vfio_intx_enable(vdev);
> >>>>>> +		ret = vfio_intx_enable(vdev, start, count, index);      
> >>>>>
> >>>>> Please trace what happens when a user calls SET_IRQS to setup a trigger
> >>>>> eventfd with start = 0, count = 1, followed by any other combination of
> >>>>> start and count values once is_intx() is true.  vfio_intx_enable()
> >>>>> cannot be the only place we bounds check the user, all of the INTx
> >>>>> callbacks should be an error or nop if vector != 0.  Thanks,
> >>>>>       
> >>>>
> >>>> Thank you very much for catching this. I plan to add the vector
> >>>> check to the device_name() and request_interrupt() callbacks. I do
> >>>> not think it is necessary to add the vector check to disable() since
> >>>> it does not operate on a range and from what I can tell it depends on
> >>>> a successful enable() that already contains the vector check. Similar,
> >>>> free_interrupt() requires a successful request_interrupt() (that will
> >>>> have vector check in next version).
> >>>> send_eventfd() requires a valid interrupt context that is only
> >>>> possible if enable() or request_interrupt() succeeded.    
> >>>
> >>> Sounds reasonable.
> >>>     
> >>>> If user space creates an eventfd with start = 0 and count = 1
> >>>> and then attempts to trigger the eventfd using another combination then
> >>>> the changes in this series will result in a nop while the current
> >>>> implementation will result in -EINVAL. Is this acceptable?    
> >>>
> >>> I think by nop, you mean the ioctl returns success.  Was the call a
> >>> success?  Thanks,    
> >>
> >> Yes, I mean the ioctl returns success without taking any
> >> action (nop).
> >>
> >> It is not obvious to me how to interpret "success" because from what I
> >> understand current INTx and MSI/MSI-x are behaving differently when
> >> considering this flow. If I understand correctly, INTx will return
> >> an error if user space attempts to trigger an eventfd that has not
> >> been set up while MSI and MSI-x will return 0.
> >>
> >> I can restore existing INTx behavior by adding more logic and a return
> >> code to the send_eventfd() callback so that the different interrupt types
> >> can maintain their existing behavior.  
> > 
> > Ah yes, I see the dilemma now.  INTx always checked start/count were
> > valid but MSI/X plowed through regardless, and with this series we've
> > standardized the loop around the MSI/X flow.
> > 
> > Tricky, but probably doesn't really matter.  Unless we break someone.
> > 
> > I can ignore that INTx can be masked and signaling a masked vector
> > doesn't do anything, but signaling an unconfigured vector feels like an
> > error condition and trying to create verbiage in the uAPI header to
> > weasel out of that error and unconditionally return success makes me
> > cringe.
> > 
> > What if we did this:
> > 
> >         uint8_t *bools = data;
> > 	...
> >         for (i = start; i < start + count; i++) {
> >                 if ((flags & VFIO_IRQ_SET_DATA_NONE) ||
> >                     ((flags & VFIO_IRQ_SET_DATA_BOOL) && bools[i - start])) {
> >                         ctx = vfio_irq_ctx_get(vdev, i);
> >                         if (!ctx || !ctx->trigger)
> >                                 return -EINVAL;
> >                         intr_ops[index].send_eventfd(vdev, ctx);
> >                 }
> >         }
> >   
> 
> This looks good. Thank you very much. Will do.
> 
> I studied the code more and have one more observation related to this portion
> of the flow:
> From what I can tell this change makes the INTx code more robust. If I
> understand current implementation correctly it seems possible to enable
> INTx but not have interrupt allocated. In this case the interrupt context
> (ctx) will exist but ctx->trigger will be NULL. Current
> vfio_pci_set_intx_trigger()->vfio_send_intx_eventfd() only checks if
> ctx is valid. It looks like it may call eventfd_signal(NULL) where
> pointer is dereferenced.
> 
> If this is correct then I think a separate fix that can easily be
> backported may be needed. Something like:

Good find.  I think it's a bit more complicated though.  There are
several paths to vfio_send_intx_eventfd:

 - vfio_intx_handler

	This can only be called between request_irq() and free_irq()
	where trigger is always valid.  igate is not held.

 - vfio_pci_intx_unmask

	Callers hold igate, additional test of ctx->trigger makes this
	safe.

 - vfio_pci_set_intx_trigger

	Same as above.

 - Through unmask eventfd (virqfd)

	Here be dragons.

In the virqfd case, a write to the eventfd calls virqfd_wakeup() where
we'll call the handler, vfio_pci_intx_unmask_handler(), and based on
the result schedule the thread, vfio_send_intx_eventfd().  Both of
these look suspicious.  They're not called under igate, so testing
ctx->trigger doesn't resolve the race.

I think an option is to wrap the virqfd entry points in igate where we
can then do something similar to your suggestion.  I don't think we
want to WARN_ON(!ctx->trigger) because that's then a user reachable
condition.  Instead we can just quietly follow the same exit paths.

I think that means we end up with something like this:

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 237beac83809..ace7e1dbc607 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -92,12 +92,21 @@ static void vfio_send_intx_eventfd(void *opaque, void *unused)
 		struct vfio_pci_irq_ctx *ctx;
 
 		ctx = vfio_irq_ctx_get(vdev, 0);
-		if (WARN_ON_ONCE(!ctx))
+		if (WARN_ON_ONCE(!ctx) || !ctx->trigger)
 			return;
 		eventfd_signal(ctx->trigger);
 	}
 }
 
+static void vfio_send_intx_eventfd_virqfd(void *opaque, void *unused)
+{
+	struct vfio_pci_core_device *vdev = opaque;
+
+	mutex_lock(&vdev->igate);
+	vfio_send_intx_eventfd(opaque, unused);
+	mutex_unlock(&vdev->igate);
+}
+
 /* Returns true if the INTx vfio_pci_irq_ctx.masked value is changed. */
 bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 {
@@ -170,7 +179,7 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 	}
 
 	ctx = vfio_irq_ctx_get(vdev, 0);
-	if (WARN_ON_ONCE(!ctx))
+	if (WARN_ON_ONCE(!ctx) || !ctx->trigger)
 		goto out_unlock;
 
 	if (ctx->masked && !vdev->virq_disabled) {
@@ -194,6 +203,18 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 	return ret;
 }
 
+static int vfio_pci_intx_unmask_handler_virqfd(void *opaque, void *unused)
+{
+	struct vfio_pci_core_device *vdev = opaque;
+	int ret;
+
+	mutex_lock(&vdev->igate);
+	ret = vfio_pci_intx_unmask_handler(opaque, unused);
+	mutex_unlock(&vdev->igate);
+
+	return ret;
+}
+
 void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
 {
 	if (vfio_pci_intx_unmask_handler(vdev, NULL) > 0)
@@ -572,10 +593,10 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
 		if (WARN_ON_ONCE(!ctx))
 			return -EINVAL;
 		if (fd >= 0)
-			return vfio_virqfd_enable((void *) vdev,
-						  vfio_pci_intx_unmask_handler,
-						  vfio_send_intx_eventfd, NULL,
-						  &ctx->unmask, fd);
+			return vfio_virqfd_enable((void *)vdev,
+					vfio_pci_intx_unmask_handler_virqfd,
+					vfio_send_intx_eventfd_virqfd, NULL,
+					&ctx->unmask, fd);
 
 		vfio_virqfd_disable(&ctx->unmask);
 	}


WDYT?
 
> > And we note the behavior change for MSI/X in the commit log and if
> > someone shouts that we broke them, we can make that an -errno or
> > continue based on is_intx().  Sound ok?  Thanks,  
> 
> I'll be sure to highlight the impact on MSI/MSI-x. Please do expect this
> in the final patch "vfio/pci: Remove duplicate interrupt management flow"
> though since that is where the different flows are merged.
> 
> I am not familiar with how all user space interacts with this flow and if/how
> this may break things. I did look at Qemu code and I was not able to find
> where it intentionally triggers MSI/MSI-x interrupts, I could only find it
> for INTx.

Being able to trigger the interrupt via ioctl is more of a diagnostic
feature, not typically used in production.
 
> If this does break things I would like to also consider moving the
> different behavior into the interrupt type's respective send_eventfd()
> callback instead of adding interrupt type specific code (like
> is_intx()) into the shared flow.

Sure, we can pick the best option in the slim (imo) chance the change
affects anyone.  Thanks,

Alex


