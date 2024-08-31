Return-Path: <kvm+bounces-25590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7983B966D44
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:17:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 282621F246EC
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9530208AD;
	Sat, 31 Aug 2024 00:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="if74Vmvq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C191CAA6
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063355; cv=none; b=Xu5gp7y/Zy0IUZ1rBS00vbrZaSXhhxvbo+XIUNDGFq9n3A9Qe6O9r56qUiOAd0rN0vQrB2K8m5PBNYeJP2oV9FyI13IYamsoqthmz/eL0GHmu5iBf02np89/6QgLZYg10P99FkNzQCQUiO1rkGEDwiQVbWq/9FUazVpozyNfl9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063355; c=relaxed/simple;
	bh=qX4frsSxKTQ6bojkC/e3dE7oNpANxrfnXEYYdQProQY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BvZz+/CzQVDNnMoezz5DwE6P4+oYoA5nZ9BVNDlrlUVP2tyicoaqHRN2ntuSh37uCrSMJu6UfFKfQ33FeCx6qskpowlBztBa0XDOcbJ97TO0q5mLO2vQMfZ7ujEks7yK6dMsr4NvSpTYHMmVIcLn2J2tobkAVNO9ZGD73G8BdPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=if74Vmvq; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71420354182so2720670b3a.1
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063353; x=1725668153; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=24VCpIEq4+Q+YXItNAgkyUyFi45YkZe3g1wKHaUykVY=;
        b=if74VmvqYni3eqNvaUmGHTJjg4PCvPPWMu3qF84E0YRUB6IwZ85rCzgNA5cSk2+1uN
         iqL2y7Vo40yuzfVazV2EJSZV3hFZrjUp5GilEw+am5A38qMmLh7WgnovBW1Htf1rwWd/
         GzXegY51lL52fkRRvXif14JmIshL/LxgcFhU4DD+OuVXcLAnu0suFjbe4ohkcMbtap6n
         T2+Ywv20Wn7dwS+xz4adxjbn7lK0Emm1G9L1ZHBSh6L0TbsJOnOhknl3k0ow/d8lbc4X
         0qU+V/bl4LVPGwnsjiSl1YUsUxnyJPsP+FU7dr8a9IfsN+piuzYhQzCw0uQk8fQ9gzxq
         ppdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063353; x=1725668153;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=24VCpIEq4+Q+YXItNAgkyUyFi45YkZe3g1wKHaUykVY=;
        b=m3yjnkOWvjWdHyrLr9O1UspyKni0jDvbB9BAlCCh9bkh/kcE6SfGX/ErxyCZr2nPNw
         onudHHHA68KsZ7jEoFz3SqS8Qzy0tnacsnQa9WoilXL7/yHsCJrbOGAwgXprv0rA0KTa
         h8RsdoWcV5osQan44FA4wWPN4/Ma/QhdtCXL0vexT/htq0QLa4NMsIYXNJy8ClpT7x4p
         pac43Fd3dq7hK7/7DJx0l49YmdTCVBhNUaqC2qiyd1JGjB9uZ0ocuHjWKoCBPX4O79HM
         gdYnRTp+zkZBKLRDGgl0uf8+eBv9Uch63gl143qIp1LdGYGwjuFpzIF+E20/51cN+pKL
         0Tmg==
X-Gm-Message-State: AOJu0Yw7pCaFYlOCgpPpTGNtYsIbBgSFz7YoEfyvErs20a39qC+QgFFh
	RZxG/dtCgmHq/OR1zBbkU4lsPTMe1ShM1aOmLFnHMxNs9CVpTl5PQMp7/RjY/Xw1oCB/sB3polz
	2uQ==
X-Google-Smtp-Source: AGHT+IEmNWc2IOu0f8CgmpJdBNIqSgvzCJlTfxhTsRLfVh/+amYRW9Ejbsh1qT3edScYRLUIfkgLKFvBqKo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:91d7:b0:714:200c:39a2 with SMTP id
 d2e1a72fcca58-717307a3102mr7424b3a.6.1725063352881; Fri, 30 Aug 2024 17:15:52
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Aug 2024 17:15:21 -0700
In-Reply-To: <20240831001538.336683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240831001538.336683-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240831001538.336683-7-seanjc@google.com>
Subject: [PATCH v2 06/22] KVM: x86: Get RIP from vCPU state when storing it to last_retry_eip
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Read RIP from vCPU state instead of pulling it from the emulation context
when filling last_retry_eip, which is part of the anti-infinite-loop
protection used when unprotecting and retrying instructions that hit a
write-protected gfn.

This will allow reusing the anti-infinite-loop protection in flows that
never make it into the emulator.

No functional change intended, as ctxt->eip is set to kvm_rip_read() in
init_emulate_ctxt(), and EMULTYPE_PF emulation is mutually exclusive with
EMULTYPE_NO_DECODE and EMULTYPE_SKIP, i.e. always goes through
x86_decode_emulated_instruction() and hasn't advanced ctxt->eip (yet).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c4cb6c6d605b..a1f0f4dede55 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8967,7 +8967,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	if (!kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa)))
 		return false;
 
-	vcpu->arch.last_retry_eip = ctxt->eip;
+	vcpu->arch.last_retry_eip = kvm_rip_read(vcpu);
 	vcpu->arch.last_retry_addr = cr2_or_gpa;
 	return true;
 }
-- 
2.46.0.469.g59c65b2a67-goog


