Return-Path: <kvm+bounces-26577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D83E2975BE9
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 22:43:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 092421C2253A
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 20:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624791BBBE7;
	Wed, 11 Sep 2024 20:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M5Buc2WV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0895A14EC51
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 20:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087349; cv=none; b=B5JEjKzWuysiC/FSVdqN8jRs2oC7AHr3oaTrDTar5KVQ6HUBnc9CLBtgAh9DOueDIUlYpwl0dsqaU5TRdfR0/3vRarLXX4G8AXVF0ruAr75Qyb3B5nTo/lAB9/8JoSOwPNEDUeDL31R16/rZM6N3rN/wA2vNYwESc/MwgRCkGlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087349; c=relaxed/simple;
	bh=5YqUPUoGyBdt/adqoIWM9Cz9Mw8TIzoRKb4sIV2JQsY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U5oj9j4XmwEscwtYysYfJ0N4jY4xgNtpO0pMbmj4Zz/mkYS7OYNf3cXRqhIQdu0jRthr6/2KD0cuTca9s2X9s09kFnetmrPKFy/9H/H6Iasvwsis7w28H5xFSguyDzIA78xtv0bb5TKauVSMwsOxfv9J5JeYT+/mHHualiqXFJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M5Buc2WV; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d475205628so9695677b3.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 13:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087347; x=1726692147; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=I5+MRLsHgDUkEu/213kX3+YnOYKTSZyhH328nXdj8ZY=;
        b=M5Buc2WVlk8e8Byq0f1pKc11vk92mD2Th/jlLX2bkc9zn1UzmyQprM0u29bPGEnAyI
         2T4SbATWqORpkvljvhjhB4x/dAhKNvlwA+qApjNYxXsaDFVPFG3d9DVC0mGVLdvZIYON
         xQccq4LzOH2IJ3knTlaM6+b+LqWB3PtNvclgkouQgVq8E8l7ksjk0pFSkydplJCX9i4X
         eqyUQRXwtVrisMfK9Fw1o3E1i+hys6I62vBJhOIT7MRho7xdqjRBUHUsdXUXlwoIQ6Gf
         Kb78xZ5bEnH7skodzil77RzZ0fuzo3RUe7ZNHN9SwBlnFN/mwkRqKgMyF6iOn7p18lTI
         4k2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087347; x=1726692147;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I5+MRLsHgDUkEu/213kX3+YnOYKTSZyhH328nXdj8ZY=;
        b=ioO4vGwMCAHm8VQS6oN6Go10AgIO/jSxZhG5Ot9Ln+darfx/Xokr/WhVxtRUpcPFZx
         9p1mb0bXDn9If0cVDG9NFr7kFGGNzk2hEbufqsicYCDgPbzKCnaVCO8JQLnslW8F60NL
         nOJ7IewJad/5pSkE9FMhJfp0T7iaq4h5EXTt7kCj85WZd6f4PjgypcTYsNpFc90PC1DO
         fWmpuGi1dPIP5UmNpPAC6Da9/z0dswxstn2YapVlC6bhaHOBa1fZQekYxFKs1ELr4XuM
         ifoYj7mJaPVqdXj83JzL3WOQIsZxSpTU/ELz7U/bFHv7gDAtpgBAGV0y6pMGsVEgjhzV
         0jIA==
X-Forwarded-Encrypted: i=1; AJvYcCVEUJF+wsVIuT4sD5w5MM9GFWQDmXoJ/Vqk00bZj2m+7SH8kpPS9P/2Qd0DM4uaHXlsLAc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8bqOqyVRHK94lU+REaBzcDiL8bdRY+1iNO5gNgZ9VVfEG98vX
	eHpR4qvB0M2uyVbqt+C2bwmDEkxL86AD6H0Eu7iUP4B7ZgVhuJvEwrijKlKYqTnKNuvMgGyU/1+
	9Qw==
X-Google-Smtp-Source: AGHT+IHjCnU+25WZuBONT4gBCIxwCF19WEi2vWiBq4GXfH9hGN5Xz3FJR6dlFxBZ6NyYinSbokZ9vN2oU0w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4983:b0:62f:1f63:ae4f with SMTP id
 00721157ae682-6dbb6abce79mr220417b3.1.1726087346868; Wed, 11 Sep 2024
 13:42:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:48 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-4-seanjc@google.com>
Subject: [PATCH v2 03/13] KVM: selftests: Fudge around an apparent gcc bug in
 arm64's PMU test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Use u64_replace_bits() instead of u64p_replace_bits() to set PMCR.N in
arm64's vPMU counter access test to fudge around what appears to be a gcc
bug.  With the recent change to have vcpu_get_reg() return a value in lieu
of an out-param, some versions of gcc completely ignore the operation
performed by set_pmcr_n(), i.e. ignore the output param.

The issue is most easily observed by making set_pmcr_n() noinline and
wrapping the call with printf(), e.g. sans comments, for this code:

  printf("orig = %lx, next = %lx, want = %lu\n", pmcr_orig, pmcr, pmcr_n);
  set_pmcr_n(&pmcr, pmcr_n);
  printf("orig = %lx, next = %lx, want = %lu\n", pmcr_orig, pmcr, pmcr_n);

gcc-13 generates:

 0000000000401c90 <set_pmcr_n>:
  401c90:       f9400002        ldr     x2, [x0]
  401c94:       b3751022        bfi     x2, x1, #11, #5
  401c98:       f9000002        str     x2, [x0]
  401c9c:       d65f03c0        ret

 0000000000402660 <test_create_vpmu_vm_with_pmcr_n>:
  402724:       aa1403e3        mov     x3, x20
  402728:       aa1503e2        mov     x2, x21
  40272c:       aa1603e0        mov     x0, x22
  402730:       aa1503e1        mov     x1, x21
  402734:       940060ff        bl      41ab30 <_IO_printf>
  402738:       aa1403e1        mov     x1, x20
  40273c:       910183e0        add     x0, sp, #0x60
  402740:       97fffd54        bl      401c90 <set_pmcr_n>
  402744:       aa1403e3        mov     x3, x20
  402748:       aa1503e2        mov     x2, x21
  40274c:       aa1503e1        mov     x1, x21
  402750:       aa1603e0        mov     x0, x22
  402754:       940060f7        bl      41ab30 <_IO_printf>

with the value stored in [sp + 0x60] ignored by both printf() above and
in the test proper, resulting in a false failure due to vcpu_set_reg()
simply storing the original value, not the intended value.

  $ ./vpmu_counter_access
  Random seed: 0x6b8b4567
  orig = 3040, next = 3040, want = 0
  orig = 3040, next = 3040, want = 0
  ==== Test Assertion Failure ====
    aarch64/vpmu_counter_access.c:505: pmcr_n == get_pmcr_n(pmcr)
    pid=71578 tid=71578 errno=9 - Bad file descriptor
       1	0x400673: run_access_test at vpmu_counter_access.c:522
       2	 (inlined by) main at vpmu_counter_access.c:643
       3	0x4132d7: __libc_start_call_main at libc-start.o:0
       4	0x413653: __libc_start_main at ??:0
       5	0x40106f: _start at ??:0
    Failed to update PMCR.N to 0 (received: 6)

Somewhat bizarrely, gcc-11 also exhibits the same behavior, but only if
set_pmcr_n() is marked noinline, whereas gcc-13 fails even if set_pmcr_n()
is inlined in its sole caller.

All signs point to this being a gcc bug, as clang doesn't exhibit the same
issue, the code generated by u64p_replace_bits() is correct, and the error
is somewhat transient, e.g. varies between gcc versions and depends on
surrounding code.

For now, work around the issue to unblock the vcpu_get_reg() cleanup, and
because arguably using u64_replace_bits() makes the code a wee bit more
intuitive.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index 30d9c9e7ae35..74da8252b884 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -45,11 +45,6 @@ static uint64_t get_pmcr_n(uint64_t pmcr)
 	return FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
 }
 
-static void set_pmcr_n(uint64_t *pmcr, uint64_t pmcr_n)
-{
-	u64p_replace_bits((__u64 *) pmcr, pmcr_n, ARMV8_PMU_PMCR_N);
-}
-
 static uint64_t get_counters_mask(uint64_t n)
 {
 	uint64_t mask = BIT(ARMV8_PMU_CYCLE_IDX);
@@ -484,13 +479,12 @@ static void test_create_vpmu_vm_with_pmcr_n(uint64_t pmcr_n, bool expect_fail)
 	vcpu = vpmu_vm.vcpu;
 
 	pmcr_orig = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0));
-	pmcr = pmcr_orig;
 
 	/*
 	 * Setting a larger value of PMCR.N should not modify the field, and
 	 * return a success.
 	 */
-	set_pmcr_n(&pmcr, pmcr_n);
+	pmcr = u64_replace_bits(pmcr_orig, pmcr_n, ARMV8_PMU_PMCR_N);
 	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
 	pmcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0));
 
-- 
2.46.0.598.g6f2099f65c-goog


