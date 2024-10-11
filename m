Return-Path: <kvm+bounces-28657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 265BA99AE32
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 23:45:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B104E2883A1
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 21:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F2181E1308;
	Fri, 11 Oct 2024 21:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="thBO0AqZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7DE1D1E6D
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 21:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728683066; cv=none; b=NEpTj7uj11rAWFHRcrhuSEV4wcrzgRTP1qbA4vb0v+VFRSnr+6IFlFZloINM071CD6vxxZphb6E9uAkK22mIMEjDOvRS2UsooX/u2+0oOSpCfcEFCueyI8h+LFwgiThryHF+XU0C/i+38L3Pbq972jsqWQQKHbPETFEyRoDOOUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728683066; c=relaxed/simple;
	bh=FySfe5RrrfJjXgO8V1GOxagEYmAWMeDCEI02fIbT6Cw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MzwFJAJCSi0KkBBDfym5QJLZzW7CYD46MMXzOg/O6jMcsu+Eg+hg+sX0pGK5qQ/gyvAfXDcpAJ2ds1IbXgjODxbBK244XnCT6REq/a96n5kZoxCnl3Om3SraN6idlkJDrTMEY1+Hv1xLLQ5sGFB7a9Vsi9grDwah2OJW4Gh7tc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=thBO0AqZ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e00c8adf9so2583094b3a.1
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 14:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728683064; x=1729287864; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7BzS7UcNh/RHQXZP7p5KB3mv/Z/fAaS/j1ugPEdV3OM=;
        b=thBO0AqZixu8eZvOJmX5bvBHP9WbwaqQA/Uxkoug4WgUBceCYLl4Zx0K+hg2gZ3Gd/
         tijqR6j2CONVIS2B8Z0ra4Qc0ByF0Vlm/7OFikECd2KpQGzPub4vCfEaAXjLFAYrE2FB
         F1DABWAXkFxQuCFx1uBJJl+mbvxsGdP/VA2FfgBIPCfi1j5IouUmdkEd31g0WMEBflpz
         PKFDKb21s1mT++tOyXyXP+Hftn1xpTY0BavRFBu67j1jnFaIfyiugOsCgQOFosytExTU
         CLAZUx5FtFx3nhAKP00/LvWDu97x9oIJz5AKtALKapZupV+7Bu4F/WYzCwjiua602ABv
         3dOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728683064; x=1729287864;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7BzS7UcNh/RHQXZP7p5KB3mv/Z/fAaS/j1ugPEdV3OM=;
        b=da55RndZG6+a7zpEkJ5Hi0u3+WebIs2QS+nuXn7L+54E3mLqrWLtiS9XswcvPCcCrV
         ia4FzdRo5SahC9mWGpXvpimO9XYadFizZDBWXI6zYQterWrsx00liw+pCYxrWa8QPl6Y
         cHwIUXZA+91unHbccxE/HWXV1b3Yda4TKrhmh+1J3NrjacB3HSRkowiivNQsOAAV4rZs
         GXbuXHEjj5DYHpGy6Cv25QN48KsACf8fGbswpjxQlaGIkkUP0OlOwPO0V4Ie8YPEPgcC
         tPiuwbDWtvnanNOikFzVlOBhtTodP3deJwXzS7WfENuEwgX87GHAu23DCXVj5tVtTIOd
         kfng==
X-Gm-Message-State: AOJu0YxBa8mlzrU0LKaiq1Ro3i5gJvktzK+vQcFsYak7z0VEnk4blokW
	1ZKtIzG8eLaJg6l1VhR3Fq9zlHCFOg3HGb0wrz1zQLHPf0bkC8i7TDoZaEtlLahBF11INnnmtSc
	hmI9lIUG4shUWvbC+AUz9OTvbivnRBwyL1wFRMgfIc5vbOQAoYwLUnuvsNDsnR2u1yD5oKwXFy4
	/OwkmJRvMmfB1jWrKv0xG2mMoH9HUikcqScp5A3do=
X-Google-Smtp-Source: AGHT+IHiuMA0lbrxoSV6pFu0qHQjNnerRePAfG3XsNaL0Dp4l+zOxesosad5IkpAuo20QGe5tFe367ODjHjpUw==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:f3:525d:ac13:60e1])
 (user=jmattson job=sendgmr) by 2002:a05:6a00:91c1:b0:71d:fe0f:c875 with SMTP
 id d2e1a72fcca58-71e3810af0cmr7016b3a.6.1728683063059; Fri, 11 Oct 2024
 14:44:23 -0700 (PDT)
Date: Fri, 11 Oct 2024 14:43:52 -0700
In-Reply-To: <20241011214353.1625057-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011214353.1625057-1-jmattson@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241011214353.1625057-4-jmattson@google.com>
Subject: [PATCH v5 3/4] KVM: x86: Advertise AMD_IBPB_RET to userspace
From: Jim Mattson <jmattson@google.com>
To: kvm@vger.kernel.org
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	jpoimboe@kernel.org, kai.huang@intel.com, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, pawan.kumar.gupta@linux.intel.com, pbonzini@redhat.com, 
	sandipan.das@amd.com, seanjc@google.com, tglx@linutronix.de, x86@kernel.org, 
	Jim Mattson <jmattson@google.com>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

This is an inherent feature of IA32_PRED_CMD[0], so it is trivially
virtualizable (as long as IA32_PRED_CMD[0] is virtualized).

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 41786b834b16..53112669be00 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -755,7 +755,7 @@ void kvm_set_cpu_caps(void)
 		F(CLZERO) | F(XSAVEERPTR) |
 		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
 		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
-		F(AMD_PSFD)
+		F(AMD_PSFD) | F(AMD_IBPB_RET)
 	);
 
 	/*
-- 
2.47.0.rc1.288.g06298d1525-goog


