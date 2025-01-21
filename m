Return-Path: <kvm+bounces-36128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFEB2A18149
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:44:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C97533AB20F
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 15:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6BE11F4727;
	Tue, 21 Jan 2025 15:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CT8RILUC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751C01F426C
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 15:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737474246; cv=none; b=MCxRfmnbyI8jjfkaj0RN3zjn/n3JlpdOsyElHR5TO1HFnGgPFN9uZVlKhFqJuyDE+u5S19yNow/PFWMPZb4G2jsmCiSAa0yQcVR2roJHbPki38/UyfazZnpYOVNAyXO4WncE/oKkxLqsE+iFcoxEGrR06x3ikMsNEyaYxKc/R8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737474246; c=relaxed/simple;
	bh=b+4csRbUueKF3ZX5iYLlhjnU3JM4B8To8fnyX3tA6AI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l0m6TET8702vw2nRvmg5CvCGaQ4sczRZqqXBvwtQ9x3Gvz1Wgr0EMlx5tS+bHPHNJSo591X5cVe3UOtZrbYbPoBonVxhCwGsU96hf/jHIIqOhIKlIWxKAIS2VAhAUDJM8t2mfeUjO/JuvHiTUIXBR81gVitEC1tbsDQbxALiiqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CT8RILUC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2163a2a1ec2so177724375ad.1
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 07:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737474244; x=1738079044; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8PCljT+D66JwBF6N6v2y7VFSXya1XW/aQ2CIHDg3OVo=;
        b=CT8RILUCZUb8tEIE+xM33bRi+7Ojn8B6ZDQL0LPFHDGM8kvjbaKVs4hAlv6Fk9GFV4
         sucoktB19WzZrxpYAUE3nEM/aBuEyCn/QO/RfrS/N7qYyS/Ve8+NYu9QTO1MT/NA4ytC
         grdjEkrdVPn+xKjO4YlbEaU23iDhPwGNJe0XpCQUBAVs3TXH1ldPD+EBvt/TNnEQx8re
         eGJ0Ybj2VcOhUaHFPLcrQHl/1pWKCYN4FxYx2nzKXj+yMNoGZTzsiYGjYMvKc5ePTNVK
         r5snwZJhf/EVWIsPmVPgrtTksqbnIeeJYMaRmVQpNiumo8mekO4XKN3TAETvXvKvg0aJ
         H6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737474244; x=1738079044;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8PCljT+D66JwBF6N6v2y7VFSXya1XW/aQ2CIHDg3OVo=;
        b=At2paTSMD6+YtTIhdEVM6muSq2kbETZi6a1FdiXDqHDGe9NKppUlc1TmM8vw8kXfKm
         iGj9qOWpaRC2yBLpG8f0/7qXwpfBCZ0wq2WGNpjz+lUMOVwOnK6boFKQpJJMBzO469uu
         R77qXXO7e4akSkuWcSSi0KrwVU2gnPfidLNn1qFArw6uYZJpp5wEK7qkam7fTw7ytsa3
         CcHkz56fH+4+S3xV1kTZd5SAtrP+VdEDfnwQRrjX/U/e0j85WHbHI77nThAnzKtIqaVA
         Db1MD60Ksw4i9yMHJUK4HlwX2s3auDKpAMwL+Lz3SxmPUA474+vOMGGZdJMUECyEEBJG
         pBjA==
X-Forwarded-Encrypted: i=1; AJvYcCV/HuYeed7SfIdCG+tXQ421p574gkPywJILiCK/YUANs1FJM+H67oFH0RU/SGnBLEvdBeU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwGEPXZnDI9PQl1vTYZ+NKoLam/JH/LVOH8g4QW3lK0iowiXGo
	z3MPEFQ7LTRfFwcBNRWt2ci/PwRq2PDE+OWUumR/notdlMfQas4pnQL42znzbWQd/J9SBPPiBt6
	U/w==
X-Google-Smtp-Source: AGHT+IGQtRScZKc0wjEnvD9y0eY8uhqqwlzVAD9VF6BQL99yX3piQEk1sKLlVMHK/Wj6xBuVEenSHPxEJfU=
X-Received: from pfbmb8.prod.google.com ([2002:a05:6a00:7608:b0:725:ec78:5008])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:788b:b0:1e1:9bea:659e
 with SMTP id adf61e73a8af0-1eb215d4c46mr28702196637.35.1737474243736; Tue, 21
 Jan 2025 07:44:03 -0800 (PST)
Date: Tue, 21 Jan 2025 07:44:02 -0800
In-Reply-To: <8734hd8rrx.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118005552.2626804-1-seanjc@google.com> <20250118005552.2626804-10-seanjc@google.com>
 <8734hd8rrx.fsf@redhat.com>
Message-ID: <Z4_AwrFFsKg2VgYW@google.com>
Subject: Re: [PATCH 09/10] KVM: x86: Setup Hyper-V TSC page before Xen PV
 clocks (during clock update)
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>, 
	Paul Durrant <paul@xen.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 20, 2025, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > When updating paravirtual clocks, setup the Hyper-V TSC page before
> > Xen PV clocks.  This will allow dropping xen_pvclock_tsc_unstable in favor
> > of simply clearing PVCLOCK_TSC_STABLE_BIT in the reference flags.
> >
> > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/x86.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 9eabd70891dd..c68e7f7ba69d 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3280,6 +3280,8 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
> >  		hv_clock.flags &= ~PVCLOCK_GUEST_STOPPED;
> >  	}
> >  
> > +	kvm_hv_setup_tsc_page(v->kvm, &hv_clock);
> > +
> >  #ifdef CONFIG_KVM_XEN
> >  	if (vcpu->xen.vcpu_info_cache.active)
> >  		kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->xen.vcpu_info_cache,
> > @@ -3289,7 +3291,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
> >  		kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->xen.vcpu_time_info_cache, 0,
> >  					xen_pvclock_tsc_unstable);
> >  #endif
> > -	kvm_hv_setup_tsc_page(v->kvm, &hv_clock);
> >  	return 0;
> >  }
> 
> "No functional change detected".
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> (What I'm wondering is if (from mostly theoretical PoV) it's OK to pass
> *some* of the PV clocks as stable and some as unstable to the same
> guest, i.e. if it would make sense to disable Hyper-V TSC page when
> KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE too.

I think it's ok to keep the Hyper-V TSC page in this case.  It's not that the Xen
PV clock is truly unstable, it's that some guests get tripped up by the STABLE
flag.  A guest that can't handle the STABLE flag has bigger problems than the
existence of a completely unrelated clock that is implied to be stable.

> I don't know if anyone combines Xen and Hyper-V emulation capabilities for
> the same guest on KVM though.)

That someone would have to be quite "brave" :-D

