Return-Path: <kvm+bounces-19527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CEE25905F37
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 01:31:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5379A1F22579
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 23:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F0E12D74B;
	Wed, 12 Jun 2024 23:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vPnpl7Og"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE28112CDA8
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 23:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718235099; cv=none; b=VyhgIqxyGtYlDcIinfZhdSewblT3pbpM3YkbNyMIhCQE+oSf2S9PPpuPF1pcJnwJvZ5FOx4TrRSpkEuceHyX/7iatYxrsTg06F5USIgrI9V3r56ze603nO5v4IPl4NBY8xTwDivMb1pT0D8n02LhCkChmGBP2ur/nJE5PUvhGZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718235099; c=relaxed/simple;
	bh=4SDKp1waJzXqdTd/ActDvagt62Ph9uX2CozVVnbthGw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WB+SezXtlqJSavL6qKhW/tsAa8wEi/LiB8e9jcPGF2PDn9A873w+o+UQFYVOEKA+apOU+P+mcdbklrWD0FQVDgws8+zLwxeHRyf3Ay4QFvtHdm2zPeDLA1cO650KkK1794kWZRo6FCHsjgaHyz54lYeA0F5/YynDi/b9RriynCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vPnpl7Og; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c2d6e09e62so282197a91.2
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 16:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718235097; x=1718839897; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L/SyTTg+Pb2L8jVOL9JfQwGKpPzI3PRlHDd/+KWWSxs=;
        b=vPnpl7OgTw3m1W9f7qd8zuFbhpnIj+Jd34ThUJ7cL7UUofqkzRWLXa51Txwe4/fgxL
         PLzlDOasbRE+NzMuzxMsbsjUmjMh6HEYZPereLw5PaVNb8BVZzMrebU+Q81WpBJq7CPt
         GqouZtMhHxB7yb43W4Zs/RcZMGIN1WXLa5N6v64RhHdchIZvE9y2s3HQzP+2zejVkIsE
         D/qFO96+CjbH0nAd0oZsiCShLpItkPvCrABUdqVUmHILxr55EOKKcRgURxnQ8zF+0vYP
         xqjDo2Whtgb7BT4Tsq/V0HUpLKSHFphdLrYRrTmQTYmOXlENmugklXmS1yPBJ5Re6sh1
         IF3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718235097; x=1718839897;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L/SyTTg+Pb2L8jVOL9JfQwGKpPzI3PRlHDd/+KWWSxs=;
        b=hGKBgUKHA9xJhhHidDvA+3suSwFZvYWygWz6J6iNumZ/AZnZV4yTLdGjDTeTd1lXH2
         s36qZ3sses6o0W1j2Ng0FJ+S4mfq/IXpCKftmsEVE2vwaG7hyenuj7UwkkOE7suDHwLx
         nIutAScjx4MVu79ruIZCJKNQV4WUM09eqfQTC8H8rBgizYTKTOcvyeoM2Bu6BdbHWmHM
         a9SVAn7Sh0+i3txpkKWbTtlkPQFmaE9WQbE04Kn+wDTbtrEr450xozkw091WQNFnL9cy
         HfOv+WH9zfIoQgUzJu1BLFzNY/sYPmcGo9dSqm7jFQa73qMSBoczg/TNwLn1bOqWOnVq
         YESg==
X-Forwarded-Encrypted: i=1; AJvYcCX62Zz+maGDexK/MMFT24Wlc7EIMDR4soA5tcEV7JDWxuM4XKzRjHZ3QOCmxs/1Xq6jBG1+NliaDBZ6clMI4VG9P6xl
X-Gm-Message-State: AOJu0YyuGtBg7wn5UlFdQVwmVR+OdkhnhtVpXDTln/c78cJQ6AUzUgOl
	BOxMFoZ0EcY4beje+ubjsdCCINjUFBEk6ud29RX6sKfxToGsfqYwHp4zH0IN2O8Nt/3LrjD4HQA
	Gjg==
X-Google-Smtp-Source: AGHT+IFF6ktwP1UGkcUZHB0WhdUhwnLGJBuZ/L5no7UNOMPx0KJvnv6kZJUd9YOHzqFhW28idnkubVIueTQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:62c9:b0:2c2:c65f:52dc with SMTP id
 98e67ed59e1d1-2c4a770e8f6mr9058a91.6.1718235096779; Wed, 12 Jun 2024 16:31:36
 -0700 (PDT)
Date: Wed, 12 Jun 2024 16:31:35 -0700
In-Reply-To: <Zj7f+JWbVfIBIK8h@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240207172646.3981-1-xin3.li@intel.com> <20240207172646.3981-13-xin3.li@intel.com>
 <ZjBiLDJ4SdQ0p5xm@chao-email> <SA1PR11MB6734740F9B6085E0997A4179A8E72@SA1PR11MB6734.namprd11.prod.outlook.com>
 <Zj7f+JWbVfIBIK8h@chao-email>
Message-ID: <Zmov1x2KFtoMN3Vm@google.com>
Subject: Re: [PATCH v2 12/25] KVM: VMX: Handle FRED event data
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Xin3 Li <xin3.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "shuah@kernel.org" <shuah@kernel.org>, 
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	Ravi V Shankar <ravi.v.shankar@intel.com>, "xin@zytor.com" <xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, May 11, 2024, Chao Gao wrote:
> On Fri, May 10, 2024 at 05:36:03PM +0800, Li, Xin3 wrote:
> >> >+               if (kvm_is_fred_enabled(vcpu)) {
> >> >+                       u64 event_data = 0;
> >> >+
> >> >+                       if (is_debug(intr_info))
> >> >+                               /*
> >> >+                                * Compared to DR6, FRED #DB event data saved on
> >> >+                                * the stack frame have bits 4 ~ 11 and 16 ~ 31
> >> >+                                * inverted, i.e.,
> >> >+                                *   fred_db_event_data = dr6 ^ 0xFFFF0FF0UL
> >> >+                                */
> >> >+                               event_data = vcpu->arch.dr6 ^ DR6_RESERVED;
> >> >+                       else if (is_page_fault(intr_info))
> >> >+                               event_data = vcpu->arch.cr2;
> >> >+                       else if (is_nm_fault(intr_info))
> >> >+                               event_data =
> >> >+ to_vmx(vcpu)->fred_xfd_event_data;
> >> >+
> >> 
> >> IMO, deriving an event_data from CR2/DR6 is a little short-sighted because the
> >> event_data and CR2/DR6 __can__ be different, e.g., L1 VMM __can__ set CR2 to A
> >> and event_data field to B (!=A) when injecting #PF.
> >
> >VMM should guarantee a FRED guest _sees_ consistent values in CR6/DR6
> >and event data. If not it's just a VMM bug that we need to fix.
> 
> I don't get why VMM should.
> 
> I know the hardware will guarantee this. And likely KVM will also do this.
> but I don't think it is necessary for KVM to assume L1 VMM will guarantee
> this. because as long as L2 guest is enlightened to read event_data from stack
> only, the ABI between L1 VMM and L2 guest can be: CR2/DR6 may be out of sync
> with the event_data. I am not saying it is good that L1 VMM deviates from the
> real hardware behavior. But how L1 VMM defines this ABI with L2 has nothing to
> do with KVM as L0. KVM shouldn't make assumptions on that.

Right, but in that case the propagation of event_data would be from vmcs12 =>
vmcs02, which is handled by prepare_vmcs02_early().

For this flow, it specifically handles exception injection from _L0 KVM_, in which
case KVM should always follow the architectural behavior.

Ahh, but the code in with __vmx_complete_interrupts() is wrong.  Overwriting
vcpu->arch.{dr6,cr2} is wrong, because theres no telling what was in vmcs02.
And even if vmcs02 holds DR6/CR2 values, those might be L2 values, i.e. shouldn't
clobber the vCPU state.

It's not clear to me that we need to do anything new for FRED in
__vmx_complete_interrupts().  The relevant VMCS fields should already hold the
correct values, there's no reason to clobber vCPU state.  The reason KVM grabs
things like instruction length and error code is because that information is
visible to other aspects of injection, e.g. to adjust RIP and pushed the error
code on the stack.

