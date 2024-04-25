Return-Path: <kvm+bounces-15931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FF468B243E
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:42:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D493DB25272
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 14:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66CB714A604;
	Thu, 25 Apr 2024 14:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x4Wwt5C6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DF61494BB
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 14:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714056127; cv=none; b=DuYhZvtjZ4xGG5JicH+osOUF4aJzjCv66YQRNwtFvrYuivIbaFUwsMAjx9ffbQjnk265ltjzsD3hVTCfA63f1+6YhCcW3qiVjDYWPAoYpSsdkAsf7K/XwPjEmYkAO1TU7RxKcd56gNh500IK0qi3qwzaKXIDFYN2KhczNB+MEoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714056127; c=relaxed/simple;
	bh=2HTb1/D2zJKsTz0x8dg2JPZ7AoAiGX0TfTBOVZ7lUok=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PzN+LZUWT6kBj0oT+4VPb6IC7WiftppBpHDl4as3l8GH58c6Z7q/Es++6e2NANXiXv6C3oANUafEELUk+Jg6pLmA13xmURJS8PGK6brgBpiUwcqU7acxu7c+zTFdlTi0ty35ro6d8bSygn1J5k2H42rQI+pqoREPLlz05WACpaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x4Wwt5C6; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de5823bd7eeso2353028276.0
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 07:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714056125; x=1714660925; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lDWCaTYULwF8F3zi592tmuoj8LcUAihXwO8QYVH28dw=;
        b=x4Wwt5C6hHRlcYDRs995liII8ZAoKfJ/K+N8bnJmVXX2igKQ7cMdCugkF51lNBM9Op
         P6hjJKUzNHAb9hkUtPhOWcFZHYjm97E3EZ+J6bJrLpKmgg4mQ5uJrHN4IQwHGbNpvxEP
         S2JwivEI1xD1IuUD422B+FRmrHvRpNFUWuWK03UBJA1l70O9wYS+WByYZGStRykVZh2/
         9EzKxkpElQH1Qd367hEAjELuWkofggcE7SgC6WEeQZGMK9d3fIRJBT+tT2xfSpeVj1aA
         FDmQ9TN2CzewaSN/aAzpySL4zYwCk+KlJpscn6sbBp2Mi8qR9u1KuOWCmi+u2OsSuM7I
         Gx3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714056125; x=1714660925;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lDWCaTYULwF8F3zi592tmuoj8LcUAihXwO8QYVH28dw=;
        b=Z5M8cHTLa7OZ/f6yBz+IipIYsoexH3yjzGhTWMpG2/g/7BwUvDUzlYHKS0/79cwCUB
         FeJPNHHC30SB8DvpR/B6X9DTRCXfEA7JpAnKc3KqHrNtbNodw+cx9bpzZ/kSqiFN15sx
         SeeYy8KTWqMwUV8SOmZrj83oswGYms8OLlRv4p4T9DcjgZWSsSiL2oEKt8qpBjt7aDuW
         vEImDmTNhtbgEYZBPH4wi+3YardZc0R7pSXsHzGb/dAFEGslSeIAH9ln0SwtjS4TtTVK
         DiE1bwb948O6LqzWgWExqM7tbzMFTjLGYUEhgkh+s6lQ2z9H74+HzLO9Io8dY2YuSQAc
         9m3g==
X-Forwarded-Encrypted: i=1; AJvYcCU5aqxxij4ebEkeLiG9AAZFk50LGKC9QxxaM/GalxoxI2jCkH5aKfgHXQC+uQHDk1xlgLSxXT2hp/zKEB8M4HzGmUwf
X-Gm-Message-State: AOJu0YwGUWy//y68x1PjTVrNa2HqbO9dnwQXhFJ1E4lIdTBKRDrRx+wN
	5P7lOMgqFm9+N9nz1i7KEKv8RILHwpyt5i802RJmbTiFo1fSFe891wXrXV7m8x6leUlAJNHq+dk
	toA==
X-Google-Smtp-Source: AGHT+IF/g7wUX2d++6yDgZVRNlO+BsKqxODd8ENXt8KXPp295gAemRTfNn6a6plk1Xwk4cOuJTp3H44r+mI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:c12:b0:de4:6624:b763 with SMTP id
 fs18-20020a0569020c1200b00de46624b763mr945449ybb.0.1714056125345; Thu, 25 Apr
 2024 07:42:05 -0700 (PDT)
Date: Thu, 25 Apr 2024 07:42:03 -0700
In-Reply-To: <64cc46778ccc93e28ec8d39b3b4e31842154f382.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309012725.1409949-1-seanjc@google.com> <20240309012725.1409949-9-seanjc@google.com>
 <ZfRtSKcXTI/lAQxE@intel.com> <ZfSLRrf1CtJEGZw2@google.com>
 <1e063b73-0f9a-4956-9634-2552e6e63ee1@intel.com> <ZgyBckwbrijACeB1@google.com>
 <ZilmVN0gbFlpnHO9@google.com> <64cc46778ccc93e28ec8d39b3b4e31842154f382.camel@intel.com>
Message-ID: <Zipru9eB9oDOOuxf@google.com>
Subject: Re: [PATCH v6 8/9] KVM: VMX: Open code VMX preemption timer rate mask
 in its accessor
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, "luto@kernel.org" <luto@kernel.org>, Xin3 Li <xin3.li@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	Zhao1 Liu <zhao1.liu@intel.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Shan Kang <shan.kang@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 25, 2024, Kai Huang wrote:
> On Wed, 2024-04-24 at 13:06 -0700, Sean Christopherson wrote:
> > > > static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
> > > > {
> > > > 	return (vmx_basic & GENMASK_ULL(53, 50)) >>
> > > > 		VMX_BASIC_MEM_TYPE_SHIFT;
> > > > }
> > > > 
> > > > looks not intuitive than original patch.
> > > 
> > > Yeah, agreed, that's taking the worst of both worlds.  I'll update patch 5 to drop
> > > VMX_BASIC_MEM_TYPE_SHIFT when effectively "moving" it into vmx_basic_vmcs_mem_type().
> > 
> > Drat.  Finally getting back to this, dropping VMX_BASIC_MEM_TYPE_SHIFT doesn't
> > work because it's used by nested_vmx_setup_basic(), as is VMX_BASIC_VMCS_SIZE_SHIFT,
> > which is presumably why past me kept them around.
> > 
> > I'm leaning towards keeping things as proposed in this series.  I don't see us
> > gaining a third copy, or even a third user, i.e. I don't think we are creating a
> > future problem by open coding the shift in vmx_basic_vmcs_mem_type().  And IMO
> > code like this
> > 
> > 	return (vmx_basic & VMX_BASIC_MEM_TYPE_MASK) >>
> > 	       VMX_BASIC_MEM_TYPE_SHIFT;
> > 
> > is an unnecessary obfuscation when there is literally one user (the accessor).
> > 
> > Another idea would be to delete VMX_BASIC_MEM_TYPE_SHIFT and VMX_BASIC_VMCS_SIZE_SHIFT,
> > and either open code the values or use local const variables, but that also seems
> > like a net negative, e.g. splits the effective definitions over too many locations.
> 
> Alternatively, we can add macros like below to <asm/vmx.h> close to
> vmx_basic_vmcs_size() etc, so it's straightforward to see.
> 
> +#define VMX_BSAIC_VMCS12_SIZE	((u64)VMCS12_SIZE << 32)
> +#define VMX_BASIC_MEM_TYPE_WB	(MEM_TYPE_WB << 50)

Hmm, it's a bit hard to see it's specifically VMCS12 size, and given that prior
to this series, VMX_BASIC_MEM_TYPE_WB = 6, I'm hesitant to re-introduce/redefine
that macro with a different value.

What if we add a helper in vmx.h to encode the VMCS info?  Then the #defines for
the shifts can go away because the open coded shifts are colocated and more
obviously related.  E.g.

  static inline u64 vmx_basic_encode_vmcs_info(u32 revision, u16 size, u8 memtype)
  {
	return revision | ((u64)size << 32) | ((u64)memtype << 50);
  }


and

  static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
  {
	/*
	 * This MSR reports some information about VMX support. We
	 * should return information about the VMX we emulate for the
	 * guest, and the VMCS structure we give it - not about the
	 * VMX support of the underlying hardware.
	 */
	msrs->basic = vmx_basic_encode_vmcs_info(VMCS12_REVISION, VMCS12_SIZE,
						 X86_MEMTYPE_WB);

	msrs->basic |= VMX_BASIC_TRUE_CTLS
	if (cpu_has_vmx_basic_inout())
		msrs->basic |= VMX_BASIC_INOUT;
  }

