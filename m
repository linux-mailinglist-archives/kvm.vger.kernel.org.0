Return-Path: <kvm+bounces-11429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33C7C876E88
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 02:28:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B5A3284E8F
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 01:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95D382E84B;
	Sat,  9 Mar 2024 01:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2xOjhaAf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505D429D0C
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 01:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709947658; cv=none; b=ZrNHX7C69+VJ9drIFaGaucWXWOHiPKhAl14FkkyC+/O+8fCht7w6ZMSxoT16UOG9BRRQ8ea0Dxq3ObylNW9DAjJ+CiRe+r7AJnOPTclT1kvMhE/X7mzE9L7czWebeJEencG7jdXHLlie+xwdua5TFpno2ispx2o1d8wLOvUOsRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709947658; c=relaxed/simple;
	bh=kUoFvFEil2iu64BSiHLlDTpL8qYLtqcLQvQtmS8GmB0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jRb8M5XOXKtC0ZyrDZNK66+G5tH0Xqbf8xdK/bU4hSmyhZCJRGZ6Rl43UIpv4lvdK8+M+WX+gWpaJP2Knt7rG9iiiEKlBZLs1bHbZtbUq4LhddSKybnTg6a+J24EzLpOUcbYluMVILvuSMGfuxHd4sSQ0wda83pgL6BxoYsuQqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2xOjhaAf; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-609f2920b53so38121367b3.0
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 17:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709947656; x=1710552456; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Md5c39yBFZ+eeG7bGl1mI/mZMLWg13mNVu69FRgG8aI=;
        b=2xOjhaAfc1z1Jw/3GgwXy6hXA9G8W6WqKHzO546huC1nyOJFICpAIeDDE8qDFJ3hjm
         etArolfgYj7yHgFMlq4zmV83FaR2bZz62S+xNCb1UfRM9m1p3P0OyE3cf+FFYLsxcQQP
         lvZFhblrh5gq5ACOTjdjb9KswJTUqbGhCr8XIqti7c/fVRcCdvPK1k7TGEpnEo+m4/O9
         kTWlWsUzFSK6UNgq4+huVg07RD5kc2fVQeBGbUCKR1Bk0cG9LTAeW4ha1ccvHwy7YwSo
         rD1kOis9e3N+t5WqR6UTKXjSRKSZhDo53GirVfH4W43K1HLfC5FlE+cmTCHntea3hlKo
         uuhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709947656; x=1710552456;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Md5c39yBFZ+eeG7bGl1mI/mZMLWg13mNVu69FRgG8aI=;
        b=dow74s/Eg+IT/w1NSJFI6B+ajjOpiuQT/c6RzJrRlFAi6nSJeXhzSGSR1IAukZkavp
         tBXh6F0aWD/PGj7av3ttWw8wF6rVyAqcrXnu7jgrlGThDEHTsMvlrISEFriQUrjfYkIC
         fQW0KQnYnoI3TLKJI+iS/SrT1vkk9OpTmVl18esy8iC4RmMgVKYdmvKYp20k3NxUKn/k
         5GJjGdyf7MW9C9WSQxffZzNNq+Ns7emDXnQCeykzie+fG0LVM0ve4/o7CU3AbDtQtJ9W
         MYngHnvMWUwkyar1YoalNEdjFMg+rUEduyQCdfad2LHYOaNmIspFI2LYbmUEfSpLtZrO
         /HoQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaVlX+0V+kMaLTCY6QzVlJEI9iFXZh2Qkqv7nPwp1VBj7HA0FioxdybJA9qMcHTJqoBtR4wXuWnvSpfS/hYzvMNMiI
X-Gm-Message-State: AOJu0YwPo5Ul1eGDeES/IcSBpcHC7UjuQcZOHHpU4Ero9v2EdV9zkFJE
	tIaoCW7ReMdQ7nkD7rHjKW3hXWDh3hQaVp+IVYXboRC9zS4wv+VVl+wz4KpnDLny2lWnaZyWZW/
	JBA==
X-Google-Smtp-Source: AGHT+IEQBKUUFqxmrGlfhL/slMpOGh3HPM1r8v1t/uJ9PxnoA13LOPBkXNE4KXZ/Gn2H3jPcL40LDG7/Sv8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d84f:0:b0:609:e1f:5a42 with SMTP id
 a76-20020a0dd84f000000b006090e1f5a42mr178693ywe.2.1709947656474; Fri, 08 Mar
 2024 17:27:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 17:27:19 -0800
In-Reply-To: <20240309012725.1409949-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309012725.1409949-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240309012725.1409949-4-seanjc@google.com>
Subject: [PATCH v6 3/9] KVM: x86: Stuff vCPU's PAT with default value at
 RESET, not creation
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>, Xin Li <xin3.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move the stuffing of the vCPU's PAT to the architectural "default" value
from kvm_arch_vcpu_create() to kvm_vcpu_reset(), guarded by !init_event,
to better capture that the default value is the value "Following Power-up
or Reset".  E.g. setting PAT only during creation would break if KVM were
to expose a RESET ioctl() to userspace (which is unlikely, but that's not
a good reason to have unintuitive code).

No functional change.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 66c4381460dc..eac97b1b8379 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12134,8 +12134,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
 	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
-	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
-
 	kvm_async_pf_hash_reset(vcpu);
 
 	vcpu->arch.perf_capabilities = kvm_caps.supported_perf_cap;
@@ -12302,6 +12300,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (!init_event) {
 		vcpu->arch.smbase = 0x30000;
 
+		vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
+
 		vcpu->arch.msr_misc_features_enables = 0;
 		vcpu->arch.ia32_misc_enable_msr = MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL |
 						  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL;
-- 
2.44.0.278.ge034bb2e1d-goog


