Return-Path: <kvm+bounces-66622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AF3B0CDAC48
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:35:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C0456300AC58
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 22:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AA822EF64F;
	Tue, 23 Dec 2025 22:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="V+2cTvC8";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="m3pZxsss"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA75D242D9B;
	Tue, 23 Dec 2025 22:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766529344; cv=none; b=ZVyGRB1cPCF9V9F8ADqOy6l+UZ8dm8zWzPKipJUjH4Yt0ZyCY9MhusIFP883MhJTQYPSTn7THgSt2XLuaiONKWzFnrmgvub1vtUmWPDRZKa3/o/ESr6YMUQw9evBFppY7X9NdLNKcHjUPF6U1IJAWULyhn4O2cShMKIpVm1oTZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766529344; c=relaxed/simple;
	bh=Yha2eNxOeh/UGStstJ9BB+Fx8iYVdLFItYWc4v2BjTk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZTEc4ZoGglmptbNgtr3aztZ6zgMvhePiwNuyFTqFeewGeIVWVwi6S0rBvKSxc5bo+RVsWufXIG8uYiW/cmahYZodxlIkOjcNh0jTYsOEV/eV/OSCURT9u+EJPMPsFwnfhicE45DYnVxBfoL4XM90BM3GdgMuWnBbnlqkoJAPhRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=V+2cTvC8; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=m3pZxsss; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 00F3514000D0;
	Tue, 23 Dec 2025 17:35:39 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 23 Dec 2025 17:35:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1766529338;
	 x=1766615738; bh=6eOINA65dqP6wa4IDSRn6QH6C2QbsmcVXw+dlu8Du1k=; b=
	V+2cTvC88glaJYVX00NeTJIJPuqly7d3Jck0wA0Sv2VP43xpep7VRLjYmk3fm80e
	I9uC8YxE5SQP0yQWydULTUUxA6Pd5vcf2isS85HQu9H6OYCquA2Id5cl6BKxeK6V
	fA6yTBebUp5DnRiVOE1U0eNKN15a5jLQxt5OZmjiTLXj1EVopz26LFKpM9A52h3+
	JpMI4fEZ0hys/lAT8VFpIpTaDBcClWXkaeS+XlWklkkMBf4vxZ5/vfRLx23GJKlM
	UZQTGvwK+QHWSxHzJhmd7ZfmJWTepe0rHNNrTOQNiMOZcRLmpwknoNG8YGCr8jXX
	bCQ+JUeWwQ20HIlKA/sHSQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1766529338; x=
	1766615738; bh=6eOINA65dqP6wa4IDSRn6QH6C2QbsmcVXw+dlu8Du1k=; b=m
	3pZxsssDABxKwwCN+P8Qqwah/Xgdvmqn+AVWWU1afVbgKuJ5MuHYO9EGvJ8IbZnl
	SXrwGj3wEPxIxoD+bmWP9OiruGb6+/sSUOoNYWHw7/jVe40lGjoOxTTnEakgV1gr
	zbQSlyYo2G6B0Tx1S7smGMve4AHuANogfUJYrc7oo25LC8t6T1zk6RI+qXAjcH/L
	+6LeIrunFyTAhxZQ3fire2tOLy0pGVq4NFAQAPIzScsLsyyNKaEtbSiYiFQcQ3z1
	nECc69sEPsjDc2Catd0ARAHJ1wRoX66SOXDvfNzwSf2gCkwfHMwDOQXD3+3CLECZ
	5e2EijLHBABVpzw7obziA==
X-ME-Sender: <xms:OhlLaVCTqqWC5RjXNqhui0rMvJHcqF_vVBfXsOv_s0dnvWUHLUIuOQ>
    <xme:OhlLae_mUEb6nlGB5o2g3ixVaPZm2jYQe4VuX_qdz7sF8a0zibUa5BGMnkqjR5XKG
    _m8T0G9xfnu5pjQx4XxrT6QqYTYQbYL9OfZx4zr6B0KlZjuQcuBUg>
X-ME-Received: <xmr:OhlLaUEhLE7IZEspOoltuHN0qTGjyoh5CQB0UEFDsycBwFncClvXEn5B>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeiuddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkjghfgggtgfesthejredttd
    dtvdenucfhrhhomheptehlvgigucghihhllhhirghmshhonhcuoegrlhgvgiesshhhrgii
    sghothdrohhrgheqnecuggftrfgrthhtvghrnhepteetudelgeekieegudegleeuvdffge
    ehleeivddtfeektdekkeehffehudethffhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhgpdhnsggprh
    gtphhtthhopeegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehguhhojhhinhhh
    uhhirdhlihgrmhessgihthgvuggrnhgtvgdrtghomhdprhgtphhtthhopehkvhhmsehvgh
    gvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehv
    ghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqphgtihesvhhgvg
    hrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:OhlLaUN1ww9xUOS-FB2liymC88_63DToA2DcaEc4-uGX7X8ic1aXwQ>
    <xmx:OhlLaWeyaSiIj_iz8X82cCNi0Pa0tAI76AThGK591KKpGy_wIrWlZw>
    <xmx:OhlLaRuq3nnED5zAx8VJb_vJ3CS_G5QvIwOlQCjeA-JcuGAb7C4kuw>
    <xmx:OhlLaXlsnGAUncMrMvr9igpR8USlqzhAiWzClVDuLm5KgWv4-jvs5g>
    <xmx:OhlLaaGLHo2JpD32oUQzEYvs7KcvC9zj_6M709fnwBAvKNB_UnZV28Wv>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Dec 2025 17:35:38 -0500 (EST)
Date: Tue, 23 Dec 2025 15:35:34 -0700
From: Alex Williamson <alex@shazbot.org>
To: "Jinhui Guo" <guojinhui.liam@bytedance.com>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [RESEND PATCH] vfio/pci: Skip hot reset on Link-Down
Message-ID: <20251223153534.0968cc15.alex@shazbot.org>
In-Reply-To: <20251215123029.2746-1-guojinhui.liam@bytedance.com>
References: <20251215123029.2746-1-guojinhui.liam@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Dec 2025 20:30:29 +0800
"Jinhui Guo" <guojinhui.liam@bytedance.com> wrote:

> On hot-pluggable ports, simultaneous surprise removal of multiple
> PCIe endpoints whether by pulling the card, powering it off, or
> dropping the link can trigger a system deadlock.

I think this only identifies one small aspect of the problems with
surprise removal and vfio-pci.  It's not just the release path of the
device that can trigger a reset, there are various user accessible
paths as well, ex. the vfio reset and hot-reset ioctls.  I think those
can trigger this same deadlock.

Beyond reset, CPU and DMA mappings to the device are still present after
a surprise removal.  The latter can really only be revoked using the
new dma-buf support for MMIO regions.

I think we should take a more comprehensive look at enabling vfio-pci to
support surprise removal beyond this one case where a cooperative guest
promptly released the device and encountered a deadlock.

In doing so, I think we're going to see several more cases where we
should test for a disconnected device before reset, some of those may
suggest that PCI-core is actually the better place for the test rather
than the leaf caller.  Thanks,

Alex

> Example: two PCIe endpoints are bound to vfio-pci and opened by
> the same process (fdA for device A, fdB for device B).
> 
> 1. A PCIe-fault brings B's link down, then A's.
> 2. The PCI core starts removing B:
>    - pciehp_unconfigure_device() takes pci_rescan_remove_lock
>    - vfio-pci's remove routine waits for fdB to be closed
> 3. While B is stuck, the core removes A:
>    - pciehp_ist() takes the read side of reset_lock A
>    - It blocks on pci_rescan_remove_lock already held by B
> 4. Killing the process closes fdA first (because it was opened first).
>    vfio_pci_core_close_device() tries to hot-reset A, so it needs
>    the write side of reset_lock A.
> 5. The write request sleeps until the read lock from step 3 is
>    released, but that reader is itself waiting for B's lock
>    -> deadlock.  
> 
> The stuck thread's backtrace is as follows:
>   /proc/1909/stack
>     [<0>] vfio_unregister_group_dev+0x99/0xf0 [vfio]
>     [<0>] vfio_pci_core_unregister_device+0x19/0xb0 [vfio_pci_core]
>     [<0>] vfio_pci_remove+0x15/0x20 [vfio_pci]
>     [<0>] pci_device_remove+0x3e/0xb0
>     [<0>] device_release_driver_internal+0x19b/0x200
>     [<0>] pci_stop_bus_device+0x6d/0x90
>     [<0>] pci_stop_and_remove_bus_device+0xe/0x20
>     [<0>] pciehp_unconfigure_device+0x8c/0x150
>     [<0>] pciehp_disable_slot+0x68/0x140
>     [<0>] pciehp_handle_presence_or_link_change+0x246/0x4c0
>     [<0>] pciehp_ist+0x244/0x280
>     [<0>] irq_thread_fn+0x1f/0x60
>     [<0>] irq_thread+0x1ac/0x290
>     [<0>] kthread+0xfa/0x240
>     [<0>] ret_from_fork+0x209/0x260
>     [<0>] ret_from_fork_asm+0x1a/0x30
>   /proc/1910/stack
>     [<0>] pciehp_unconfigure_device+0x43/0x150
>     [<0>] pciehp_disable_slot+0x68/0x140
>     [<0>] pciehp_handle_presence_or_link_change+0x246/0x4c0
>     [<0>] pciehp_ist+0x244/0x280
>     [<0>] irq_thread_fn+0x1f/0x60
>     [<0>] irq_thread+0x1ac/0x290
>     [<0>] kthread+0xfa/0x240
>     [<0>] ret_from_fork+0x209/0x260
>     [<0>] ret_from_fork_asm+0x1a/0x30
>   /proc/6765/stack
>     [<0>] pciehp_reset_slot+0x2c/0x70
>     [<0>] pci_reset_hotplug_slot+0x3e/0x60
>     [<0>] pci_reset_bus_function+0xcd/0x180
>     [<0>] cxl_reset_bus_function+0xc8/0x110
>     [<0>] __pci_reset_function_locked+0x4f/0xd0
>     [<0>] vfio_pci_core_disable+0x381/0x400 [vfio_pci_core]
>     [<0>] vfio_pci_core_close_device+0x63/0xd0 [vfio_pci_core]
>     [<0>] vfio_df_close+0x48/0x80 [vfio]
>     [<0>] vfio_df_group_close+0x32/0x70 [vfio]
>     [<0>] vfio_device_fops_release+0x1d/0x40 [vfio]
>     [<0>] __fput+0xe6/0x2b0
>     [<0>] task_work_run+0x58/0x90
>     [<0>] do_exit+0x29b/0xa80
>     [<0>] do_group_exit+0x2c/0x80
>     [<0>] get_signal+0x8f9/0x900
>     [<0>] arch_do_signal_or_restart+0x29/0x210
>     [<0>] exit_to_user_mode_loop+0x8e/0x4f0
>     [<0>] do_syscall_64+0x262/0x630
>     [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> The deadlock blocks PCI operations (lspci, sysfs removal, unplug, etc.) and
> sends system load soaring as PCI-related work stalls, preventing the system
> from isolating the fault.
> 
> The ctrl->reset_lock was added by commit 5b3f7b7d062b ("PCI: pciehp:
> Avoid slot access during reset") to serialize threads that perform or
> observe a bus reset, including pciehp_ist() and pciehp_reset_slot().
> 
> When a PCIe device is surprise-removed (card pulled or link fault)
> and generates a link-down event, pciehp_ist() handles it first; only
> later, after the device has already vanished, does vfio_pci_core_disable()
> invoke pciehp_reset_slot() - because it must take ctrl->reset_lock.
> Thus the hot reset (FLR, slot, or bus) is performed after the device
> is gone, which is pointless.
> 
> For surprise removal, the device state is set to
> pci_channel_io_perm_failure in pciehp_unconfigure_device(), indicating
> the device is already gone (disconnected).
> 
> pciehp_ist()
>   pciehp_handle_presence_or_link_change()
>     pciehp_disable_slot()
>       remove_board()
>         pciehp_unconfigure_device(presence) {
> 	  if (!presence)
> 	      pci_walk_bus(parent, pci_dev_set_disconnected, NULL);
> 	}
> 
> Commit 39714fd73c6b ("PCI: Make pci_dev_is_disconnected() helper public for
> other drivers") adds pci_dev_is_disconnected() to let drivers check whether
> a device is gone.
> 
> Fix the deadlock by using pci_dev_is_disconnected() in
> vfio_pci_core_disable() to detect a gone PCIe device and skip the hot
> reset.
> 
> Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
> ---
> 
> Hi, alex
> 
> Sorry for the noise.
> I've just resent the patch to expand the commit message; no code changes.
> I hope the additional context helps the review.
> 
> Best Regards,
> Jinhui
> 
>  drivers/vfio/pci/vfio_pci_core.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 3a11e6f450f7..f42051552dd4 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -678,6 +678,16 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  		if (!vdev->reset_works)
>  			goto out;
>  
> +		/*
> +		 * Skip hot reset on Link-Down. This avoids the reset_lock
> +		 * deadlock in pciehp_reset_slot() when multiple PCIe devices
> +		 * go down at the same time.
> +		 */
> +		if (pci_dev_is_disconnected(pdev)) {
> +			vdev->needs_reset = false;
> +			goto out;
> +		}
> +
>  		pci_save_state(pdev);
>  	}
>  


