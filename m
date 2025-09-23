Return-Path: <kvm+bounces-58583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 083E5B96E6A
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 19:03:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E19D5188DE8C
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A071B2737FB;
	Tue, 23 Sep 2025 17:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E4CcZL9s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5564114AD20
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 17:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758646980; cv=none; b=rDn6w5iSdcLRLDQ6l6i907GdydA+OrTofETjevUvZZJFTy+9dbMwborieiN2EkgEhxdWCRpNY5F+JA2VzyaSSol0UHXTSzzHhs1367OM6TMySMAf7iSUYHTiA+8Lm9k7CHXHwdKq6sv7vaiVdmXTNZaOB0WAurJDgYNz5JK9rz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758646980; c=relaxed/simple;
	bh=GIlHRf5XTE0COSH//hN6Zg+nEBdSq3ma/xn77n3FOg8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T4Ov3Zcl71OVYdwt2GZe8onZZA1RUBj5AsNRfDrgy40ESIcGdFb3lFmqVZTN27+yZv4PqWr/YEk9EMfc5D0bGR6e/lJUNPafMlecsb2CVIGFA04GbUZ3aIAdiE9ltxvx83KynX6ySwSfZOtPRNYEOkGXNUDOAc4tjCdSIZyxsPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E4CcZL9s; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b55443b4110so58098a12.1
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 10:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758646978; x=1759251778; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JXBGihq8A78t9Z1IiEI/Iicy+K3MCt/5X5iumq5Le3w=;
        b=E4CcZL9sygo3ZPDaX03CmzmdJgtrlguLOMFeqz38vx7dlpDjAIjJsiO8+ir2YRK8FN
         72fpCqANBuc1Tu1NWyFcWAKS3HmxryYspXXf9gkkU5Q/crrUrhZmW/OPOrzepqbVhfQn
         35wCemIWWqtJFAbIt2BGqeu1NTlOhi9lfja9LCn7I2Ba4pT2sfefMZ7KtUqEtspaqD7A
         p7lTd7LcW6+NTJtuTJgE44Lxdb2p4nOPKDKo50NC4mrunHIm6p3o18bDywaN4om3b3rC
         XjbU/ePIPPZhF/c5yoUUI3xHseCaI+AUQ/x7NT/p6XULeB/Mzn2/+3qiTnW11l2jV1ic
         dZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758646978; x=1759251778;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JXBGihq8A78t9Z1IiEI/Iicy+K3MCt/5X5iumq5Le3w=;
        b=XmGQb0z/9tXLnaAHBzL+YRn7JAGsQOHWMqvBn5RMhA8zLoV56WSwmjX5v0x8O3fNCW
         JD9tmyWBY1nmrcj3gOcg2l5uMuM0pyHOWhOvl9KvRT5JAdDq/e51nR1YpaXXx3dnY2ZQ
         mau/4voQ8CuMouZZcbQ7H5PRG7y76DM4v+8s38H6iZEaM7CRfyM7toh3e2fm2muQVHD4
         UDxCyngQ2Uw7wXO0P6t541NuBcYGeXdEtcykUDZdnKJkSOrAaG4W5WCUVOg1MSQXftQi
         jwReh2fMdX5RaGjzsOrdSb93ruI/aEioJnWNp257SbHqL7koSkM050anUCZQPoA/BKKe
         U+QQ==
X-Forwarded-Encrypted: i=1; AJvYcCVztPVv0MlhHBZX/Hx8IYDJWWobjDBdvm0mlm2YMXf/btUAmjU0aUaBLlTWKFXQNlOG2WU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkM4K/d4iVoaSjEvXM4aeVpL830nKkFSPpksg5s7/SxRr/m0Hs
	MLVW8mc3bPPusPH8hKxy+1DyQQ9r5ZTyMPbCxD+k8rRoJBzDiW//jRTAbjSlnR6tuZqo3nXp+xB
	1s5oswQ==
X-Google-Smtp-Source: AGHT+IH4Kskgmch7JegC5v+NUo5paOR/XhwhXs3EqsmT9/QyBt92yY6pX0mhWpbs9SQZBDrzTmU7nahdad8=
X-Received: from pgbds10.prod.google.com ([2002:a05:6a02:430a:b0:b47:34d0:d386])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a111:b0:240:1e4a:64cc
 with SMTP id adf61e73a8af0-2d10f57e829mr4372465637.12.1758646978582; Tue, 23
 Sep 2025 10:02:58 -0700 (PDT)
Date: Tue, 23 Sep 2025 10:02:57 -0700
In-Reply-To: <aNJCNMGLIIVlyC/p@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com> <20250919223258.1604852-51-seanjc@google.com>
 <aNJCNMGLIIVlyC/p@intel.com>
Message-ID: <aNLSwWM98jzs8NZh@google.com>
Subject: Re: [PATCH v16 50/51] KVM: selftests: Verify MSRs are (not) in
 save/restore list when (un)supported
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 23, 2025, Chao Gao wrote:
> On Fri, Sep 19, 2025 at 03:32:57PM -0700, Sean Christopherson wrote:
> >Add a check in the MSRs test to verify that KVM's reported support for
> >MSRs with feature bits is consistent between KVM's MSR save/restore lists
> >and KVM's supported CPUID.
> >
> 
> >To deal with Intel's wonderful decision to bundle IBT and SHSTK under CET,
> >track the "second" feature to avoid false failures when running on a CPU
> >with only one of IBT or SHSTK.
> 
> is this paragraph related to this patch? the tracking is done in a previous
> patch instead of this patch. So maybe just drop this paragraph.
> 
> >
> >Signed-off-by: Sean Christopherson <seanjc@google.com>
> >---
> > tools/testing/selftests/kvm/x86/msrs_test.c | 22 ++++++++++++++++++++-
> > 1 file changed, 21 insertions(+), 1 deletion(-)
> >
> >diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/selftests/kvm/x86/msrs_test.c
> >index 7c6d846e42dd..91dc66bfdac2 100644
> >--- a/tools/testing/selftests/kvm/x86/msrs_test.c
> >+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
> >@@ -437,12 +437,32 @@ static void test_msrs(void)
> > 	}
> > 
> > 	for (idx = 0; idx < ARRAY_SIZE(__msrs); idx++) {
> >-		if (msrs[idx].is_kvm_defined) {
> >+		struct kvm_msr *msr = &msrs[idx];
> >+
> >+		if (msr->is_kvm_defined) {
> > 			for (i = 0; i < NR_VCPUS; i++)
> > 				host_test_kvm_reg(vcpus[i]);
> > 			continue;
> > 		}
> > 
> >+		/*
> >+		 * Verify KVM_GET_SUPPORTED_CPUID and KVM_GET_MSR_INDEX_LIST
> >+		 * are consistent with respect to MSRs whose existence is
> >+		 * enumerated via CPUID.  Note, using LM as a dummy feature
> >+		 * is a-ok here as well, as all MSRs that abuse LM should be
> >+		 * unconditionally reported in the save/restore list (and
> 
> I am not sure why LM is mentioned here. Is it a leftover from one of your
> previous attempts?

Yeah, at one point I was using LM as the NONE feature.  I'll delete the entire
sentence.

> 
> >+		 * selftests are 64-bit only).  Note #2, skip the check for
> >+		 * FS/GS.base MSRs, as they aren't reported in the save/restore
> >+		 * list since their state is managed via SREGS.
> >+		 */
> >+		TEST_ASSERT(msr->index == MSR_FS_BASE || msr->index == MSR_GS_BASE ||
> >+			    kvm_msr_is_in_save_restore_list(msr->index) ==
> >+			    (kvm_cpu_has(msr->feature) || kvm_cpu_has(msr->feature2)),
> >+			    "%s %s save/restore list, but %s according to CPUID", msr->name,
> 
> 				  ^ an "in" is missing here.

Heh, I had added this in a local version when debugging, but forgot to push the
fix.  Added now. 

diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/selftests/kvm/x86/msrs_test.c
index c2ab75e5d9ea..40d918aedce6 100644
--- a/tools/testing/selftests/kvm/x86/msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
@@ -455,17 +455,14 @@ static void test_msrs(void)
                /*
                 * Verify KVM_GET_SUPPORTED_CPUID and KVM_GET_MSR_INDEX_LIST
                 * are consistent with respect to MSRs whose existence is
-                * enumerated via CPUID.  Note, using LM as a dummy feature
-                * is a-ok here as well, as all MSRs that abuse LM should be
-                * unconditionally reported in the save/restore list (and
-                * selftests are 64-bit only).  Note #2, skip the check for
-                * FS/GS.base MSRs, as they aren't reported in the save/restore
-                * list since their state is managed via SREGS.
+                * enumerated via CPUID.  Skip the check for FS/GS.base MSRs,
+                * as they aren't reported in the save/restore list since their
+                * state is managed via SREGS.
                 */
                TEST_ASSERT(msr->index == MSR_FS_BASE || msr->index == MSR_GS_BASE ||
                            kvm_msr_is_in_save_restore_list(msr->index) ==
                            (kvm_cpu_has(msr->feature) || kvm_cpu_has(msr->feature2)),
-                           "%s %s save/restore list, but %s according to CPUID", msr->name,
+                           "%s %s in save/restore list, but %s according to CPUID", msr->name,
                            kvm_msr_is_in_save_restore_list(msr->index) ? "is" : "isn't",
                            (kvm_cpu_has(msr->feature) || kvm_cpu_has(msr->feature2)) ?
                            "supported" : "unsupported");

