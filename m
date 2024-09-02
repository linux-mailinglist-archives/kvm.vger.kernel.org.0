Return-Path: <kvm+bounces-25659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0220F9681A7
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 10:24:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF7572829FE
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 08:24:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D51A81862AE;
	Mon,  2 Sep 2024 08:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GxZ53TBI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E442E183092
	for <kvm@vger.kernel.org>; Mon,  2 Sep 2024 08:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725265448; cv=none; b=P+NDzBspFCvctmYuOKj2L38X9Y/n6QgR+uliVJr1ax874qr1vKnGUdWYdDpWuWE5g16aTr9b3QpmoXtIxO+iZaSo88KEY+WCleUMfiGuVW18+oU8kLUg896m2H9kCUM9FWXqwdrvXLu6q1a5BSeiJCNcNiLbbkmyX4ROJaXP5Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725265448; c=relaxed/simple;
	bh=mZRrDh8uuKRsFRJ76qarUXgzkV9FOvu93vZjcmsedWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FS7vuY9kCUwe8B+dP1OrSsihMdXhWSEWUmlmJLza+Ax8KBVb5t/kkZXPf+k0JqbgiZCqpWXtYpAMJVkBS6dxzt1UDl16yDdtST13e3x/Ll2pdtpxKOHEE0c/EM53n9GafiyNWZ1ia4y43zXQh30jQzzjLGkjZMjoqp/wtwyLRyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GxZ53TBI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725265444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k+0fISnzt5wuQd1CIsLkBQW6Py4x2XcKBx/mXvJpRkU=;
	b=GxZ53TBIi89D3JCQrN4tbun3w2yQIx5ATlwWAAyR1g0k00sMP7wpPqmWovhRzNONgQ2NqA
	nOnMLuqBzNmR3eZ5Z5LuHtn187Surrm/HoTj0sHEcYcXnEjBwCyXEfnQn/aGy8AhHXXDN/
	azCghwTZd9d2dgJS12pCJzMGUIlgQWg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-Tye3jLkHN06lTCJ1PNjL4g-1; Mon,
 02 Sep 2024 04:24:01 -0400
X-MC-Unique: Tye3jLkHN06lTCJ1PNjL4g-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DEB5F1955D57;
	Mon,  2 Sep 2024 08:23:59 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.193.45])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 194341955F1B;
	Mon,  2 Sep 2024 08:23:59 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id C61CF1800639; Mon,  2 Sep 2024 10:23:56 +0200 (CEST)
Date: Mon, 2 Sep 2024 10:23:56 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, rcu@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Yiwei Zhang <zzyiwei@google.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Josh Triplett <josh@joshtriplett.org>, Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
Message-ID: <fjlo4brtf32dciwubnrmqa3h3yzjxuv3t6sxpz4tsi6mj6xelx@bb66nmwxw3m2>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-6-seanjc@google.com>
 <877cbyuzdn.fsf@redhat.com>
 <vuwlkftomgsnzsywjyxw6rcnycg3bve3o53svvxg3vd6xpok7o@k4ktmx5tqtmz>
 <871q26unq8.fsf@redhat.com>
 <ZtHOr-kCqvCdUc_A@google.com>
 <87seumt89u.fsf@redhat.com>
 <87plpqt6uh.fsf@redhat.com>
 <ZtHvjzBFUbG3fcMc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtHvjzBFUbG3fcMc@google.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

> > > Yes? :-) As Gerd described, video memory is "mapped into userspace so
> > > the wayland / X11 display server can software-render into the buffer"
> > > and it seems that wayland gets something unexpected in this memory and
> > > crashes. 
> > 
> > Also, I don't know if it helps or not, but out of two hunks in
> > 377b2f359d1f, it is the vmx_get_mt_mask() one which brings the
> > issue. I.e. the following is enough to fix things:
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index f18c2d8c7476..733a0c45d1a6 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7659,13 +7659,11 @@ u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> >  
> >         /*
> >          * Force WB and ignore guest PAT if the VM does NOT have a non-coherent
> > -        * device attached and the CPU doesn't support self-snoop.  Letting the
> > -        * guest control memory types on Intel CPUs without self-snoop may
> > -        * result in unexpected behavior, and so KVM's (historical) ABI is to
> > -        * trust the guest to behave only as a last resort.
> > +        * device attached.  Letting the guest control memory types on Intel
> > +        * CPUs may result in unexpected behavior, and so KVM's ABI is to trust
> > +        * the guest to behave only as a last resort.
> >          */
> > -       if (!static_cpu_has(X86_FEATURE_SELFSNOOP) &&
> > -           !kvm_arch_has_noncoherent_dma(vcpu->kvm))
> > +       if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
> >                 return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
> >  
> >         return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT);
> 
> Hmm, that suggests the guest kernel maps the buffer as WC.  And looking at the
> bochs driver, IIUC, the kernel mappings via ioremap() are UC-, not WC.  So it
> could be that userspace doesn't play nice with WC, but could it also be that the
> QEMU backend doesn't play nice with WC (on Intel)?
> 
> Given that this is a purely synthetic device, is there any reason to use UC or WC?

Well, sharing code with other (real hardware) drivers is pretty much the
only reason.  DRM has a set of helper functions to manage vram in pci
memory bars (see drm_gem_vram_helper.c, drm_gem_ttm_helper.c).

> I.e. can the bochs driver configure its VRAM buffers to be WB?  It doesn't look
> super easy (the DRM/TTM code has so. many. layers), but it appears doable.  Since
> the device only exists in VMs, it's possible the bochs driver has never run on
> Intel CPUs with WC memtype.

Thomas Zimmermann <tzimmermann@suse.de> (Cc'ed) has a drm patch series
in flight which switches the bochs driver to a shadow buffer model, i.e.
all the buffers visible to fbcon and userspace live in main memory.
Display updates are handled via in-kernel memcpy from shadow to vram.
The pci memory bar becomes an bochs driver implementation detail not
visible outside the driver.  This should give the bochs driver the
freedom to map vram with whatever attributes work best with kvm, without
needing drm changes outside the driver.

Of course all this does not help much with current distro kernels broken
by this patch ...

take care,
  Gerd


