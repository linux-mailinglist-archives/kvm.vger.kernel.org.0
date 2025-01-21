Return-Path: <kvm+bounces-36177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0986DA18543
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 19:32:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 784B1166FCE
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 18:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5101F7569;
	Tue, 21 Jan 2025 18:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hG2D/EHm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8540B199924
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 18:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737484351; cv=none; b=IT7cYbOMSP42oTRdm4tkaqSi/fzsLsZaMAjIFB+GdTWLr1xp8h4/XRQTDEeliFlZh64gkA37xDBeZewvCD+cvzWM0sVh0tbOWMFMLc7pmkanLu11nP3KAkkIdA5sFyhLwq1sx4D24jlXgd8GPTtFxhvSf/H7ZvGQo4edFANT/rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737484351; c=relaxed/simple;
	bh=zVmJ0DTK7BV3eY3kKyWz2gCSv3criWpnxVPhyeP+nkM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IEpDuRiopHcOJTJXHDklP2SXTxu9G9pwBNvbgfJsfXbB3YOl0T9xBJZ4YUaJP2nV+6mYmsxpStY6Mb+xlnWgH9tdQIFZIv8nS3sGrsq+RDHM1MFntV36+kIMHQPR4YjS2Kpy6MsNUCEeHJ/f2uh7rM9vkRIn03kZYFcFiEiyf1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hG2D/EHm; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2163c2f32fdso181791055ad.2
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 10:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737484349; x=1738089149; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KBtMJLbql+eUPSQBrP2LFciWVcwLXXsk304JsV6DEe8=;
        b=hG2D/EHmWxedLYZoVqZXGt2PInLPpwWWAQLjxhMTxzZjdOUbInK4qd3LeeA8228z2a
         JHg7T88zKFTiBVHOvD1HQ8DJPZ7wXMZqBr764Lef++fKDfCEJUn6HilE5BQvNlaQ0dcl
         YdbBiImh4y+25SJG3NKBl87oJFotIZ2umOX48WxFHmmJ9YFnQa0e5N/AFDZBvGpSlT67
         moh8yqggtpzv+KevyIc9biSAXowYHRwIRXGR5xROASRmuKZNZlGD7mwYfcX/o4YJL8UE
         UlvJukqOT13AkiYGoZ9rQNbWPuiFzHKJD3MBPvcBPetvmrSzr5yUzyKT9IUAZAAYBQzx
         NDrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737484349; x=1738089149;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KBtMJLbql+eUPSQBrP2LFciWVcwLXXsk304JsV6DEe8=;
        b=b22par46ehYoaRk9jMxAZ4YPGtXPzsUVwOKIjeu0e50a/Vk3By8Nd+qlhChoKWA9HH
         024UWmm3VTF3WxgIZWF6hVm65Fb680A2nBNFyGQYAOT2h6/httj3g6dmGb3YCIXdF6M5
         iy1PyzfxxyI7wMyP42+NWKcSMB5l/s1gkMd6S0dJLdx9dZDQhVGZtDFW4LhiPA6KuoUG
         lu9wHDEtApC4vxz/V8WYEIqwhXlwSHBMzEFFYUVNH19ahwsP+xR/zJDZ+9jYwB42D7Np
         MYj6H2anI0G8BdMmpv6/rA3yWw/n+n9LPQcs4FtyeTB+6Zn8rVeDsSHmBli0yv8Er3WZ
         RZjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaxGGYLTPdf+X1Q3EoehCXBv97uQwLxmc63IayS44lnh30ayqco/34vel6Wap5IzaLjWQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuXTrGMgR5PQX/b6FgHAaE9cxghBogeLNy1zUf/zAo6cKTylOv
	jYeaJyX+VCvn8KlluvIxqysW5BLwoRq7CYxfYXKCW5iSCNZ+ZY/galpp48UGB7ctynVPPcOyOWJ
	yUQ==
X-Google-Smtp-Source: AGHT+IEVg2+55ehZPSbRnoql1bzyggGQpBBSHWR6pLtqveXC5L+JzJIrU9M7bu3d4x/fsGhxyIxVvEVIJ7U=
X-Received: from pfbcd16.prod.google.com ([2002:a05:6a00:4210:b0:727:3c81:f42a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d8e:b0:1ea:ddd1:2fb6
 with SMTP id adf61e73a8af0-1eb2158170dmr34558526637.30.1737484348885; Tue, 21
 Jan 2025 10:32:28 -0800 (PST)
Date: Tue, 21 Jan 2025 10:32:27 -0800
In-Reply-To: <4f788368-b8da-4e22-8028-b609975806a0@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118005552.2626804-1-seanjc@google.com> <20250118005552.2626804-5-seanjc@google.com>
 <f80fc36f-dd58-4934-9bc0-8e91352a36b2@xen.org> <Z4_U16jb7IbVdlLi@google.com> <4f788368-b8da-4e22-8028-b609975806a0@xen.org>
Message-ID: <Z4_oO1dccyhzwHUX@google.com>
Subject: Re: [PATCH 04/10] KVM: x86: Set PVCLOCK_GUEST_STOPPED only for
 kvmclock, not for Xen PV clock
From: Sean Christopherson <seanjc@google.com>
To: paul@xen.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 21, 2025, Paul Durrant wrote:
> On 21/01/2025 17:09, Sean Christopherson wrote:
> > On Tue, Jan 21, 2025, Paul Durrant wrote:
> > > > ---
> > > >    arch/x86/kvm/x86.c | 20 ++++++++++++++------
> > > >    1 file changed, 14 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index d8ee37dd2b57..3c4d210e8a9e 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -3150,11 +3150,6 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
> > > >    	/* retain PVCLOCK_GUEST_STOPPED if set in guest copy */
> > > >    	vcpu->hv_clock.flags |= (guest_hv_clock->flags & PVCLOCK_GUEST_STOPPED);
> > > > -	if (vcpu->pvclock_set_guest_stopped_request) {
> > > > -		vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
> > > > -		vcpu->pvclock_set_guest_stopped_request = false;
> > > > -	}
> > > > -
> > > >    	memcpy(guest_hv_clock, &vcpu->hv_clock, sizeof(*guest_hv_clock));
> > > >    	if (force_tsc_unstable)
> > > > @@ -3264,8 +3259,21 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
> > > >    	if (use_master_clock)
> > > >    		vcpu->hv_clock.flags |= PVCLOCK_TSC_STABLE_BIT;
> > > > -	if (vcpu->pv_time.active)
> > > > +	if (vcpu->pv_time.active) {
> > > > +		/*
> > > > +		 * GUEST_STOPPED is only supported by kvmclock, and KVM's
> > > > +		 * historic behavior is to only process the request if kvmclock
> > > > +		 * is active/enabled.
> > > > +		 */
> > > > +		if (vcpu->pvclock_set_guest_stopped_request) {
> > > > +			vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
> > > > +			vcpu->pvclock_set_guest_stopped_request = false;
> > > > +		}
> > > >    		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0, false);
> > > > +
> > > > +		vcpu->hv_clock.flags &= ~PVCLOCK_GUEST_STOPPED;
> > > 
> > > Is this intentional? The line above your change in kvm_setup_guest_pvclock()
> > > clearly keeps the flag enabled if it already set and, without this patch, I
> > > don't see anything clearing it.
> > 
> > Oh, I see what you're getting at.  Hrm.  Yes, clearing the flag is intentional,
> > otherwise the patch wouldn't do what it claims to do (set PVCLOCK_GUEST_STOPPED
> > only for kvmclock).
> > 
> > Swapping the order of this patch and the next patch ("don't bleed ...") doesn't
> > break the cycle because that would result in PVCLOCK_GUEST_STOPPED only being
> > applied to the first active clock (kvmclock).
> > 
> > The only way I can think of to fully isolate the changes would be to split this
> > into two patches: (4a) hoist pvclock_set_guest_stopped_request processing into
> > kvm_guest_time_update() and (4b) apply it only to kvmclock, and then make the
> > ordering 4a, 5, 4b, i.e. "hoist", "don't bleed", "only kvmclock".
> > 
> > 4a would be quite ugly, because to avoid introducing a functional change, it
> > would need to be:
> > 
> > 	if (vcpu->pv_time.active || vcpu->xen.vcpu_info_cache.active ||
> > 	    vcpu->xen.vcpu_time_info_cache.active) {
> > 		vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
> > 		vcpu->pvclock_set_guest_stopped_request = false;
> > 	}
> > 
> > But it's not the worst intermediate code, so I'm not opposed to going that
> > route.
> > 
> 
> What about putting this change after patch 7. Then you could take a local
> copy of hv_clock in which you could set PVCLOCK_GUEST_STOPPED and so avoid
> bleeding the flag that way?

But to preserve the current behavior of setting PVCLOCK_GUEST_STOPPED for all
clocks, processing pvclock_set_guest_stopped_request needs to be moved out of
kvm_setup_guest_pvclock() before said helper can make a copy of the reference.

