Return-Path: <kvm+bounces-28812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DEC699D79B
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 21:40:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 45DF51F230D7
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 19:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8B411CEAD1;
	Mon, 14 Oct 2024 19:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oKA+srqN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DE01CB330
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 19:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728934816; cv=none; b=PLZgBCLUsL+Ss3BsFGcmlzVEtnKHnpVSp0iLb14RD9QfL52jTE+kykDobWvZy0zhZLHedjeIe2H1F1FxFvpxhSDbyacfg0mZHPEvM2sDIOqsltOtVmjOP1xjdZLKO6zsY5o/+gSBrvxi3NnpjxLTxv1Wtdd3vo9OBS6QEFm87Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728934816; c=relaxed/simple;
	bh=8UlFUDMW5VTEW1JOagcwIb4P9KBMnhM47q+PGuy2TQg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t2rrNaor5S5Am8LxcX7mXuGUuONxFqGbsezs5YSTfP0rtyBOExvgXlkfEapDhnjmHM6sAlbjIzTetGJmoINQaSJ8KHM8yDXVe/xCCguyRuUyFHhbii53r4HPw+6qlNkkwipXzQora0KNOQG0Yq4zJsJf6PGNxXWDLzAvwGqOGEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oKA+srqN; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e370d76c15so29087657b3.2
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 12:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728934813; x=1729539613; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aNvP+xKsd/SNtLPYM7rhsr5LITn25Gjd7fO4ZucOjz8=;
        b=oKA+srqNeTwFNNedDMLzN8YmIYlX+sbLltfo7H0V4TUfM2Smg55Thx9TAWQrUsucn1
         o3IM2Mv+UyeSpvcVp0hpskCBsuXh+099leI5xQNDSgEX4aO3/JgyznWm+yrc9/nuVOlO
         P/CW5hIiN4yuca8W1v+Tv2C0zslRd7oZMMTbh7acibM/yY15k3GPI2KCxbu1aNHdPkg0
         xHBqwWcyEthJaH+8ZygmQIVZMHzTq+93tSq29seUrlVPDs0EEYl0RnfVsT32ibY6P4S5
         oVTBBV2w8Yq5d5mkaVC5AqFnI/i/9nkrckBS6MVGu8n0Jh6MofFCxWwkqmFv//CrYEBT
         Y/tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728934813; x=1729539613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aNvP+xKsd/SNtLPYM7rhsr5LITn25Gjd7fO4ZucOjz8=;
        b=Od146WamYhLcgfNHqcdKz6qmRUJrk2ipxxBWxVlM6THNfl7omHn9vKM6cxJx+cbaAd
         WQVDUJ/FvawPjIquMzfHxJsNajXc57WD+x4psYlAvhReZvuK+nt5xke9gWPbxaFqHglf
         P7SCDFz6ZK9zH1MVHg/5heB/ghGGYnzF5B9iiOOUlK+d5P9LUSBndm0IUPEy0BDXomKi
         Xpxvd3CeuMkVdFuKIXXGvID2kskdiSPVb9ybLXvPY6uW9fBhSFMzzuveCk0ZM7nHntE0
         VGwoTDVz/36d3/ZZQRZR6nLGbBFlNy2R7t2HlNcnJ837Iy32kgEluHoxZTFlHbb+VuJv
         +anQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQZDaAMueXFTL0xUpr409fhAd/622B5bbYSLCaWIOdk6v9IwwGjP4JHnbYganYC2M6swQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YymXNsuuUPCbohg49rnz/26nWYvHOmtl/L+YLSqrDM09tj7taN2
	qRJyxW0gVm7OfpuyRqPs7UVMlU8ilYk1DvnDNspVSXJIGk5ATQ9m57RdGn7hbc6+eYhF0hguY4S
	dXQ==
X-Google-Smtp-Source: AGHT+IFNAe0j0iW5CkhnIRBKFr2QTlyeGoZ/Bq8VIyc0IMwXAoxeBKGj3yLGpydnM9aldsdbJePbO/xT5ls=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4c07:b0:6e3:8562:ffa with SMTP id
 00721157ae682-6e385621623mr599917b3.5.1728934813608; Mon, 14 Oct 2024
 12:40:13 -0700 (PDT)
Date: Mon, 14 Oct 2024 12:40:12 -0700
In-Reply-To: <Zw1rnEONZ8iJQvMQ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009181742.1128779-1-seanjc@google.com> <20241009181742.1128779-6-seanjc@google.com>
 <d09669af3cc7758c740f9860f7f1f2ab5998eb3d.camel@intel.com> <Zw1rnEONZ8iJQvMQ@google.com>
Message-ID: <Zw1znGMufMEL-cuw@google.com>
Subject: Re: [PATCH 5/7] KVM: x86: Move kvm_set_apic_base() implementation to
 lapic.c (from x86.c)
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 14, 2024, Sean Christopherson wrote:
> On Mon, Oct 14, 2024, Kai Huang wrote:
> > On Wed, 2024-10-09 at 11:17 -0700, Sean Christopherson wrote:
> > > Move kvm_set_apic_base() to lapic.c so that the bulk of KVM's local APIC
> > > code resides in lapic.c, regardless of whether or not KVM is emulating the
> > > local APIC in-kernel.  This will also allow making various helpers visible
> > > only to lapic.c.
> > > 
> > > No functional change intended.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/lapic.c | 21 +++++++++++++++++++++
> > >  arch/x86/kvm/x86.c   | 21 ---------------------
> > >  2 files changed, 21 insertions(+), 21 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index fe30f465611f..6239cfd89aad 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -2628,6 +2628,27 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
> > >  	}
> > >  }
> > >  
> > > +int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > > +{
> > > +	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
> > > +	enum lapic_mode new_mode = kvm_apic_mode(msr_info->data);
> > > +	u64 reserved_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu) | 0x2ff |
> > > +		(guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) ? 0 : X2APIC_ENABLE);
> > > +
> > > +	if ((msr_info->data & reserved_bits) != 0 || new_mode == LAPIC_MODE_INVALID)
> > > +		return 1;
> > > +	if (!msr_info->host_initiated) {
> > > +		if (old_mode == LAPIC_MODE_X2APIC && new_mode == LAPIC_MODE_XAPIC)
> > > +			return 1;
> > > +		if (old_mode == LAPIC_MODE_DISABLED && new_mode == LAPIC_MODE_X2APIC)
> > > +			return 1;
> > > +	}
> > > +
> > > +	kvm_lapic_set_base(vcpu, msr_info->data);
> > > +	kvm_recalculate_apic_map(vcpu->kvm);
> > > +	return 0;
> > > +}
> > 
> > Nit:
> > 
> > It is a little bit weird to use 'struct msr_data *msr_info' as function
> > parameter if kvm_set_apic_base() is in lapic.c.  Maybe we can change to take
> > apic_base and host_initialized directly.
> > 
> > A side gain is we can get rid of using the 'struct msr_data apic_base_msr' local
> > variable in __set_sregs_common() when calling kvm_apic_set_base():
> 
> Ooh, nice.  I agree, it'd be better to pass in separate parameters.
> 
> Gah, and looking at this with fresh eyes reminded me why I even started poking at
> this code in the first place.  Patch 1's changelog does a poor job of calling it
> out,

Duh, because patch 1 doesn't change any of that.  KVM already skips setting the
map DIRTY if neither MSR_IA32_APICBASE_ENABLE nor X2APIC_ENABLE is toggled.  So
it's really just the (IIRC, rare) collision with an already-dirty map that's nice
to avoid.

> but the main impetus for this series was to avoid kvm_recalculate_apic_map()
> when doing KVM_SET_SREGS without modifying APIC_BASE.  That's _mostly_ handled by
> patch 1, but it doesn't completely fix things because if the map is already DIRTY,
> then KVM will unnecessarily fall into kvm_recalculate_apic_map()'s slow path, even
> though some other vCPU/task is responsible for refreshing the calculation.
> 
> I'll send a v2 with your suggested change, a better changelog for patch 1, and
> another patch at the end to short-circuit kvm_apic_set_base() (not just the inner
> helper) if the new value is the same as the old value.
> 
> Thanks Kai!
> 
> > static int __set_sregs_common(...)
> > {
> >         struct msr_data apic_base_msr;
> > 	...
> > 
> >         apic_base_msr.data = sregs->apic_base;
> >         apic_base_msr.host_initiated = true;
> >         if (kvm_set_apic_base(vcpu, &apic_base_msr))
> >                 return -EINVAL;
> > 	...
> > }
> > 

