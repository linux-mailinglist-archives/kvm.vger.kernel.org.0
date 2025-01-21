Return-Path: <kvm+bounces-36163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AE98A18293
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 18:09:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0849188BC47
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9770F1F4E48;
	Tue, 21 Jan 2025 17:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hL/ZjOH2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5871D1B394B
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 17:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737479386; cv=none; b=PNI4DyFc42LOSZ87HjCwGPW1lc8hnQSU89QV5dt43i4FaKXZ5dhoYmiYb6REPbsEhnlnLeHmWr+7F0pgTN4uy5OEo7z2n2VibBhwEChMYaHt3NTUx2GS2ad/1d5Mj0wfAXaB6R5nj3mRlSgzrDrxzfB7z1pI6CzGgzBSpuBmr6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737479386; c=relaxed/simple;
	bh=joEnkS+Yavjx5oVEMhN2c8f7HsMyLQgz95VavZRtXhA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ajGVuPwG93ZZk0PNyro8d2ibwpxPY7yfCPtW4ZuFZvtP9gzNdj5NVngJ8vWjbD6wOdIZ78vUm/pRCwdhL9pVZDXkksPNg/s2WsfnM26nFLTbKGAZoSC2jwj1YoxOF3d+OpKrcmcMdQscTqOLMf4AwWhEkoitSwC7p1/cE0/GVk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hL/ZjOH2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9e4c5343so16929521a91.0
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 09:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737479384; x=1738084184; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kTIPaVwvdE66u8GfvZeKYzxAZfj8jr5wdUjQPFYH2IU=;
        b=hL/ZjOH2XcI++UwbELh7aBrNVNxxofkBDYQza7tbd8lLjCsgQ2bQKMy7SNs8z2x4cs
         Cwj/1tj0cItL7BiiMRAFxUlb8OrcA3/a196Zx1GErCbGbelsxbo5kTOUzFBwVS2+dQUW
         32MpdiFvY2KpzNJWDKAsAYUZKzZK8kh1PrqkgcdAP1+HhV0TZzyRKOu+jNyY0ms9Q5qk
         UCPjVPFJpxmlevK8SJCtYK2SN7bAo5CxFFOSjkld+xu6UzBQtTqPKHvssf8wz3Dw01Qj
         lbBs/tY0WFTErqvHvEaPRrIA1DbfObe30xsu3VJ2cCM2BtFYakjGc+dz780JltTaeBvu
         K1fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737479384; x=1738084184;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kTIPaVwvdE66u8GfvZeKYzxAZfj8jr5wdUjQPFYH2IU=;
        b=hpl2L9hLsev4LKMnZjJiFREIB1YNB9NfmW/34HDqth+RQsX/w4JNpNivQ+d+6hq8f9
         5kjayobXMUDLtn5dbaixVyZdxQRwi6JF3l6V/XC3VJBbRZWZvNtLrZYfIKRRK06FlTPI
         l+IQqjmMSVvOTsUEK1kpIjx1BlcbFNJBTmtxGX2pwoAD+ToUI+xlo4PF+iywzi/qozrE
         NqzQWiXUNuIC/cl/ux6rY8TDxmEdRzfS0N2HKmLACBfWfnjkonAATDwND9U8gwSYyERq
         oPYFLG+HkqPBjycISwchU8RuK9yoeFJwN5tKD4NpB5YLotT0KHDjGUAHN0A4dMdWcRCs
         CO5w==
X-Forwarded-Encrypted: i=1; AJvYcCVxIezErGwJuTfjzq6Pz1m7wF8JUX/7HI0rCY7HZHOusJUe/+JlBPH+/pChF+5udAY6Ubk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLUipAAKogHlUQ0SyXRZNZckSGOv4ZH0ka77BuGguD8Oq4ZXL+
	aNmOs8mXsNTjDqJfUqqtYHCEJYGdVQvYxiKTTmHDaWW09nAMldYgVQe/M16OsH3V5/vH0ozu8dV
	LgQ==
X-Google-Smtp-Source: AGHT+IFXhtO/oCrGt8i6oaoAkVXwlRYFse6HqXBKv3/vHJ+bchQ+wvlklzU0zw/eC2aVXwFU/rrZhmvXx58=
X-Received: from pfar2.prod.google.com ([2002:a05:6a00:a902:b0:728:b8e3:993f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2184:b0:725:ef4b:de33
 with SMTP id d2e1a72fcca58-72daf88b1b9mr27723623b3a.0.1737479384623; Tue, 21
 Jan 2025 09:09:44 -0800 (PST)
Date: Tue, 21 Jan 2025 09:09:43 -0800
In-Reply-To: <f80fc36f-dd58-4934-9bc0-8e91352a36b2@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118005552.2626804-1-seanjc@google.com> <20250118005552.2626804-5-seanjc@google.com>
 <f80fc36f-dd58-4934-9bc0-8e91352a36b2@xen.org>
Message-ID: <Z4_U16jb7IbVdlLi@google.com>
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
> > ---
> >   arch/x86/kvm/x86.c | 20 ++++++++++++++------
> >   1 file changed, 14 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index d8ee37dd2b57..3c4d210e8a9e 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3150,11 +3150,6 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
> >   	/* retain PVCLOCK_GUEST_STOPPED if set in guest copy */
> >   	vcpu->hv_clock.flags |= (guest_hv_clock->flags & PVCLOCK_GUEST_STOPPED);
> > -	if (vcpu->pvclock_set_guest_stopped_request) {
> > -		vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
> > -		vcpu->pvclock_set_guest_stopped_request = false;
> > -	}
> > -
> >   	memcpy(guest_hv_clock, &vcpu->hv_clock, sizeof(*guest_hv_clock));
> >   	if (force_tsc_unstable)
> > @@ -3264,8 +3259,21 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
> >   	if (use_master_clock)
> >   		vcpu->hv_clock.flags |= PVCLOCK_TSC_STABLE_BIT;
> > -	if (vcpu->pv_time.active)
> > +	if (vcpu->pv_time.active) {
> > +		/*
> > +		 * GUEST_STOPPED is only supported by kvmclock, and KVM's
> > +		 * historic behavior is to only process the request if kvmclock
> > +		 * is active/enabled.
> > +		 */
> > +		if (vcpu->pvclock_set_guest_stopped_request) {
> > +			vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
> > +			vcpu->pvclock_set_guest_stopped_request = false;
> > +		}
> >   		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0, false);
> > +
> > +		vcpu->hv_clock.flags &= ~PVCLOCK_GUEST_STOPPED;
> 
> Is this intentional? The line above your change in kvm_setup_guest_pvclock()
> clearly keeps the flag enabled if it already set and, without this patch, I
> don't see anything clearing it.

Oh, I see what you're getting at.  Hrm.  Yes, clearing the flag is intentional,
otherwise the patch wouldn't do what it claims to do (set PVCLOCK_GUEST_STOPPED
only for kvmclock).

Swapping the order of this patch and the next patch ("don't bleed ...") doesn't
break the cycle because that would result in PVCLOCK_GUEST_STOPPED only being
applied to the first active clock (kvmclock).

The only way I can think of to fully isolate the changes would be to split this
into two patches: (4a) hoist pvclock_set_guest_stopped_request processing into
kvm_guest_time_update() and (4b) apply it only to kvmclock, and then make the
ordering 4a, 5, 4b, i.e. "hoist", "don't bleed", "only kvmclock".

4a would be quite ugly, because to avoid introducing a functional change, it
would need to be:

	if (vcpu->pv_time.active || vcpu->xen.vcpu_info_cache.active ||
	    vcpu->xen.vcpu_time_info_cache.active) {
		vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
		vcpu->pvclock_set_guest_stopped_request = false;
	}

But it's not the worst intermediate code, so I'm not opposed to going that
route.

> > +	}
> > +
> >   #ifdef CONFIG_KVM_XEN
> >   	if (vcpu->xen.vcpu_info_cache.active)
> >   		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_info_cache,
> 

