Return-Path: <kvm+bounces-68093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A2C23D217BB
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 23:02:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C6ECB30B6016
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 22:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3B8D3A9003;
	Wed, 14 Jan 2026 22:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hSW5Vy+S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25293A89A8
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 21:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768427984; cv=none; b=K+90dTVZxB/xALiJLdVOJFBEOFHQ5jXs0EhEuTLfK9UXmJit97twd02uAqZiKl/jNXqCmK4TJU2t5gbhtub95q9xdnrd5uIVW2aD39fi90Xt8NDZSgsP63t0nlrdYQXclO12NriR3anyml32o9qSc9euFpshf2fpK4hjB5Ixnac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768427984; c=relaxed/simple;
	bh=tO0znVmDXAymHNCdzPnVwtYP7QD1kxrOykARoYLTeBE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IyWT8PCu+elsqCMTQ8M78qOZ8SLYp8zDkXnVfRvnHQKy0wjMxydE5glSSiiher4hm3iT0IBrFF0cXPfWrrhDVHbNW1bPboB18F2ujNxbDeYZxfYCrKKXkq3stM/a/vmAJ0fG+IWm5ZKaWlvmT7Z+hQNwD1LNrYEeuyMv5PqqTgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hSW5Vy+S; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c6e05af3bso150828a91.3
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 13:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768427965; x=1769032765; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wc5IYW1fIu5cyAHFpaj29f0bgcaP13LBp3YapifQT5w=;
        b=hSW5Vy+SGhQcYxbEd5IwbQss4zcbV4g2hELRx9Isus+w4SC0+K55AFsf5LThNPaD0z
         iX0qvcGmeRXiOJHpd0TW7z1fwfq5SfuIRL6IAQGWkzrkXFg++BDcf65CDgRNUQ13HqO/
         Ucr/ZIMFRzYZwT+qn1DZpZAekxqBeeV/NLKibGnhHihyKDKUNxvs2+2pSTVoI6e3Oxuu
         HJVB2ASDVT69USBw4+bEkh1ThVcyILL8IXhEyzD1tgkNsx2EZQC4qtjS1fk+LMe/3e7R
         /OIouO1efH52uxgwQxriWCIRsWnwj+8vUwGNZdL5tNVyvn4y5ATbVkpFPmKnxpDZToX2
         xQNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768427965; x=1769032765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wc5IYW1fIu5cyAHFpaj29f0bgcaP13LBp3YapifQT5w=;
        b=Mxij+Z3Dkh973R5E5m7/7bceQLJ5+7KwMvt5/qQ4Pv0FWoyyhM7nK9sJ5Xct9qB2De
         gx24YGxGzI3tQKoQh9gqh6AhAPp4FydrQpzjxAx3HkxZKGZ3vOGeBvRLHzf4Nv2Jmmi9
         +sgPamhWUr5mnlO0r+t76/yA4WbWZ4TACYOIYjTUoMQ3R9K2qazJ2n/qu2LMM9N154Eg
         miCEULrPcaqvWh5Ja9e2LtX9HrrG+E6ze37t0g/W6x3ubxMxYa3vZcpntR/VR/44Bul/
         XGR1LWfxpNQwUkK6HfKHULiU8p3GGsN1lB2v7ZeRpg4mRFOWClAuYuHhrwyrwU+LA+WN
         0F7g==
X-Forwarded-Encrypted: i=1; AJvYcCU5vpGKNRVAVlwbFCJ9QbWzYDKn60wiseyN29UdANCpNJCif0d627rB99yrPUihFXI9xvg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWW+BgIYQZN12vvAXuM35zE6nZ1FFtRFmkWrLgvT2ZboJoHoHI
	8VNYsekDD2/C+QUlRkapq+Rb8ngFcRfOPMuyF+Jqk9p86XXrfUostWmWExIeEXC9QSV8z95PrDn
	YAiJnGQ==
X-Received: from pjbga22.prod.google.com ([2002:a17:90b:396:b0:34c:9f0b:fd7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:6d0:b0:341:6164:c27d
 with SMTP id 98e67ed59e1d1-35109091a6cmr3714526a91.3.1768427965337; Wed, 14
 Jan 2026 13:59:25 -0800 (PST)
Date: Wed, 14 Jan 2026 13:59:24 -0800
In-Reply-To: <jf2zfqo6jrrcdkdatztiijmf7tgkho7bks4q4oaegiqpeflrkj@7blq6f5ck2hf>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250901051656.209083-1-manali.shukla@amd.com>
 <20250901052146.209158-1-manali.shukla@amd.com> <jf2zfqo6jrrcdkdatztiijmf7tgkho7bks4q4oaegiqpeflrkj@7blq6f5ck2hf>
Message-ID: <aWgRvCdPsAFHRwcU@google.com>
Subject: Re: [PATCH v2 03/12] KVM: Add KVM_GET_EXT_LAPIC and KVM_SET_EXT_LAPIC
 for extapic
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org, 
	pbonzini@redhat.com, nikunj@amd.com, bp@alien8.de, peterz@infradead.org, 
	mingo@redhat.com, mizhang@google.com, thomas.lendacky@amd.com, 
	ravi.bangoria@amd.com, Sandipan.Das@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 16, 2025, Naveen N Rao wrote:
> On Mon, Sep 01, 2025 at 10:51:46AM +0530, Manali Shukla wrote:
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 6aa40ee05a4a..0653718a4f04 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -2048,6 +2048,18 @@ error.
> >  Reads the Local APIC registers and copies them into the input argument.  The
> >  data format and layout are the same as documented in the architecture manual.
> >  
> > +::
> > +
> > +  #define KVM_APIC_EXT_REG_SIZE 0x540

As discussed in PUCK, just go the full 0x1000 bytes, and do:

#define KVM_GET_LAPIC2            _IOR(KVMIO,  0x8e, struct kvm_lapic_state2)
#define KVM_SET_LAPIC2            _IOW(KVMIO,  0x8f, struct kvm_lapic_state2)

> > +  struct kvm_ext_lapic_state {
> > +	__DECLARE_FLEX_ARRAY(__u8, regs);
> > +  };
> > +
> > +Applications should use KVM_GET_EXT_LAPIC ioctl if extended APIC is
> > +enabled. KVM_GET_EXT_LAPIC reads Local APIC registers with extended
> > +APIC register space located at offsets 400h-530h and copies them into input
> > +argument.
> 
> I suppose the reason for using a flex array was for addressing review 
> comments on the previous version -- to make the new APIs extensible so 
> that they can accommodate any future changes to the extended APIC 
> register space.
> 
> I wonder if it would be better to introduce a KVM extension, say 
> KVM_CAP_EXT_LAPIC (along the lines of KVM_CAP_PMU_CAPABILITY).

Please figure out a different name than "ext_lapic".  Verbatim from the SDM
(minus a closing parenthesis)

  the xAPIC architecture) is an extension of the APIC architecture

and

  EXTENDED XAPIC (X2APIC)
  The x2APIC architecture extends the xAPIC architecture

There's zero chance I'm going to remember which "extended" we're talking about. 

KVM_CAP_X2APIC_API further muddies the waters, so maybe something absurd and
arbitrary like KVM_CAP_LAPIC2?  The capability doesn't have to strictly follow
the naming of the underlying feature(s) it supports.

