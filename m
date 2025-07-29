Return-Path: <kvm+bounces-53660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61378B15292
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 20:20:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4965D189CF35
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 18:20:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFB5423A9B0;
	Tue, 29 Jul 2025 18:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kzdKmxk8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4AF23535A
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 18:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753813186; cv=none; b=amI8RmJEuHG6U4MZJsfs3PV47tUoicLTFYyF1hPXy0Vj7xQBWpTUl+b28GVkJ1QKoAyJTJBEC+6EeQrnIfe6HYmmEnrDsDmFzpX16Zl71D4qGGVc90GAmHKTGImX/DoHocdneufx5zMfxsCqYiSy0Bh/7m+y/0Y+5355nUKVnuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753813186; c=relaxed/simple;
	bh=Zl7KLWafk74sQL+8j6ytR4kxPDeV/QUPEgtH+rTuR6I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eiLoQBrtz5QXbE6nsjrOpYFPzB9ecgnOO9uOnPdkO1dXUHKI0C9geXtJzhvuJnqZxM9rNgEypfni2xx+6hnv5TDTeK9IHNDSxf4Mskhtrzvbf2EEQeGOZVfg04PWOkFXSQyvg3obhoLovL1PVLMy4gUcKzRzzRSpH8Bdn5LtAy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kzdKmxk8; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31c38d4063so4456606a12.3
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 11:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753813184; x=1754417984; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wn3gJxWA3uJgeB3JDV1mVkQm4z7b+VZjhC6w+XYIxiA=;
        b=kzdKmxk8tSA7DBr9QUp/GkWWJL22OhWDEbKgyO60D2RBtMCy6KBcc4JgvmuZcpWQTj
         jElkLmcmdz1OHKrX4x6AbvSXBAnvRhK+fVFi82KWd2sxZxcAm/qqq+ITXmt0M/xljV33
         D0woaLvIqpz6rWSzw5h4oIAO5DQ2mI9mPrfaCwHB1Fz1hDjkY+W9UOMK0DmIKHdsld3e
         9wCL9B023KbAGN+NbUvR4mg/7ly3+RDx3+wgYKa+IkDZJCiYZFa2/RHY1IFa8LcKoAEI
         EgDHcEuL02952wLtduOBOh6Bcl7JGZVKCTyMBBZHs5shNvQZIp7GIjt1tZPwV1/OuvhK
         QOpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753813184; x=1754417984;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wn3gJxWA3uJgeB3JDV1mVkQm4z7b+VZjhC6w+XYIxiA=;
        b=Htyn28qEhXI0ZGDYWwaV8RnUBdgxarp6pRgZdBMyjZxUP4d/vSLwanYpQpnbyghlRF
         Gj7XOB6YpScAr/PUu/SaXWRKjcrcFjqEvPO7pLyl21gSqK5UdBrluRH0eRc1vMsq99CQ
         /+sagNX6/lAd/687H4o9ZDZWZoy80lKfGQNrkbTAEIBHpwK7YJAtYpGcN6ZZ9gkPRdLx
         ZYqG6x2Y2DNpqPmv7F+6ibGzADAqFWTcZPGws5xsPbuRiziesW1LeV3lMUQ/vbVhEpvm
         VBmuAQ5m/e2wFZa4lMdJnSlHRefz4Hbm/0VGqPC0h/Y/piPrqZSGZ34XqI2MEKvq+MVh
         rsNA==
X-Forwarded-Encrypted: i=1; AJvYcCUeaotgmX9VQX5vCt4sXAPxmFP4xCqgxOKQl1sUyL5jJurUsRaBcP0XRRArAp6fmpLxkTo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzdy7ehfht8Bwcrt6z4n+pKY3DyuLMkvPh5qiTS2hYNfqvvZuVF
	1VAnj+26CZMYA2BHHMc6uEBvtZKrwCubodnpEX9pIvGiTNnNrGdR11RnIykxeObBpJny6dsYk9x
	7+exHfw==
X-Google-Smtp-Source: AGHT+IHEpLXvt767w0GL4NtfNvD307U11Z/kcZVZLSuSK0JImdMWtTujcBTE1fUybj6KQU1bt7BHRbDk8u4=
X-Received: from pjxx5.prod.google.com ([2002:a17:90b:58c5:b0:312:15b:e5d1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7d2:b0:311:c1ec:7d0a
 with SMTP id 98e67ed59e1d1-31f5de47ef7mr544335a91.25.1753813183765; Tue, 29
 Jul 2025 11:19:43 -0700 (PDT)
Date: Tue, 29 Jul 2025 11:19:42 -0700
In-Reply-To: <aIgZjW2PZEdR/DYr@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250704085027.182163-1-chao.gao@intel.com> <20250704085027.182163-2-chao.gao@intel.com>
 <5591ecc4-2383-4804-b3f0-0dcef692e8f6@zytor.com> <aIgZjW2PZEdR/DYr@intel.com>
Message-ID: <aIkQvhGhRKisonmh@google.com>
Subject: Re: [PATCH v11 01/23] KVM: x86: Rename kvm_{g,s}et_msr()* to show
 that they emulate guest accesses
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Xin Li <xin@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, pbonzini@redhat.com, dave.hansen@intel.com, 
	rick.p.edgecombe@intel.com, mlevitsk@redhat.com, john.allen@amd.com, 
	weijiang.yang@intel.com, minipli@grsecurity.net, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 29, 2025, Chao Gao wrote:
> On Mon, Jul 28, 2025 at 03:31:41PM -0700, Xin Li wrote:
> >>   	/* Set L1 segment info according to Intel SDM
> >>   	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
> >> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >> index 7543dac7ae70..11d84075cd14 100644
> >> --- a/arch/x86/kvm/x86.c
> >> +++ b/arch/x86/kvm/x86.c
> >> @@ -1929,33 +1929,35 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
> >>   				 __kvm_get_msr);
> >>   }
> >> -int kvm_get_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 *data)
> >> +int kvm_emulate_msr_read_with_filter(struct kvm_vcpu *vcpu, u32 index,
> >> +				     u64 *data)
> >
> >I think the extra new line doesn't improve readability, but it's the
> >maintainer's call.
> >
> 
> Sure. Seems "let it poke out" is Sean's preference. I saw he made similar
> requests several times. e.g.,

Depends on the situation.  I'd probably mentally flip a coin in this case.

But what I'd actually do here is choose names that are (a) less verbose and (b)
capture the relationship between the APIs.  Instead of:

  int kvm_emulate_msr_read_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 *data);
  int kvm_emulate_msr_write_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 data);
  int kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
  int kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data);

rename to:

  int kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
  int kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data);
  int __kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
  int __kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data);

And then we can do a follow-up patch to solidify the relationship:

--
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 11:13:48 -0700
Subject: [PATCH] KVM: x86: Use double-underscore read/write MSR helpers as
 appropriate

Use the double-underscore helpers for emulating MSR reads and writes in
he no-underscore versions to better capture the relationship between the
two sets of APIs (the double-underscore versions don't honor userspace MSR
filters).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 09b106a5afdf..65c787bcfe8b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1932,11 +1932,24 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
 				 __kvm_get_msr);
 }
 
+int __kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data)
+{
+	return kvm_get_msr_ignored_check(vcpu, index, data, false);
+}
+EXPORT_SYMBOL_GPL(__kvm_emulate_msr_read);
+
+int __kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data)
+{
+	return kvm_set_msr_ignored_check(vcpu, index, data, false);
+}
+EXPORT_SYMBOL_GPL(__kvm_emulate_msr_write);
+
 int kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data)
 {
 	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ))
 		return KVM_MSR_RET_FILTERED;
-	return kvm_get_msr_ignored_check(vcpu, index, data, false);
+
+	return __kvm_emulate_msr_read(vcpu, index, data);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_msr_read);
 
@@ -1944,21 +1957,11 @@ int kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data)
 {
 	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_WRITE))
 		return KVM_MSR_RET_FILTERED;
-	return kvm_set_msr_ignored_check(vcpu, index, data, false);
+
+	return __kvm_emulate_msr_write(vcpu, index, data);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_msr_write);
 
-int __kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data)
-{
-	return kvm_get_msr_ignored_check(vcpu, index, data, false);
-}
-EXPORT_SYMBOL_GPL(__kvm_emulate_msr_read);
-
-int __kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data)
-{
-	return kvm_set_msr_ignored_check(vcpu, index, data, false);
-}
-EXPORT_SYMBOL_GPL(__kvm_emulate_msr_write);
 
 static void complete_userspace_rdmsr(struct kvm_vcpu *vcpu)
 {

base-commit: 1877e7b0749cbaa2d2ba4056eeda93adb373f7d4
--

