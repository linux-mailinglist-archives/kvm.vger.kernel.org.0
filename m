Return-Path: <kvm+bounces-57483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96868B55A4A
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:35:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9679586E6A
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4E142E8E04;
	Fri, 12 Sep 2025 23:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3mhunu8T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAF02900A8
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719478; cv=none; b=LFC19GZUuLFF/jjPofk1SFYy57hCpgbdJcYWnaEQyldMX3IMxz19xBYQ1uow0Ortq2TSVit9wFQvelJegyhzWC2SqZGEUCP2FZ2kb+W3zPpX7X6/0YK76wC/kW8JdAnM8mx41U3fFHm2NZOxSOomLzLNH5qGv7mA20AmzYDf0e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719478; c=relaxed/simple;
	bh=40dl71ECyFWFXfkSw+70ZDfPeD3+mlVMScAldWN2Rms=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SJerejL9mBTWdOiUfBcueiisnv0gTdQGCXURpy27A+qg+W14kYaqVNz1ABex5+fzJNweFPv5zeIIquY3VvVinMZUTAROMbOdG7XRjqZ8e7LxSkduLtLgg1aMgNe2KOGhk2DQtjosxyDqbaN6loM/9oCMusYnoVn6VhT0dxu4b+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3mhunu8T; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b54b37ba2d9so650794a12.0
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719476; x=1758324276; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4jmux4W5u0jC39lKwSsyN7sb7Ko3HpaGxf4gpZSmOsw=;
        b=3mhunu8T2K3siQmPTFmrVSrev6pslT/F3yvUHmeWNTVnF+I/bYXxpSHqsGYoMEhbXW
         W0Iv09YZJFzlK/jKRMSVgsMBvwQvtSlP4qCzacMBQLfmuuiJCL/wCx+rjNX8XmK/roBI
         6oz75xQDRexEMbfowNYhr3bEt4zDtLzsEDLvzTePpiQ0EpT8nQbHZlsk+kzpegbKqH5c
         dpSr0gJEpsCq+zBUhMCZwJ+8dMFj59hu5FFnx253bfTaCWLEz1DD7PZBweVSdMdaEaxk
         HLy8QRg2W+iGyQauZM3iFVCrnErKPyleTm37aFVasuG2G2MOBNRSsVP62HqFxcp1dOKW
         lNcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719476; x=1758324276;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4jmux4W5u0jC39lKwSsyN7sb7Ko3HpaGxf4gpZSmOsw=;
        b=aqwwE0Lm/JSuiFCty0uPIfPMMADmSV2NKqwpwFedLjoiLVH6vtEesy5OV1KfKFI5T1
         yt0NMsMB/H8rauu20SFhEmCuToaK0J/rPHI9CQF4/1tGDicyoTp0RDAKmovueSeb3flU
         nqQggYPlUz92h5O0DGYOwH2Gqkt0GQ75tD02l/Oi0kur4B6cmJgZ/DgD1soPGvCzj+oJ
         IsrzHTObpRbNaic5bLUAqEsKWJYfuaUSXx6XOc1dNi2X9cIYTeja4D4/xTVQJONfHJge
         NdE3xLu3ObeyfY6XPEQ/aZWG43r/fikPhqy8nEreiMizrhR5e/ZmD9xhiqKA4C3KJGrw
         Acyw==
X-Gm-Message-State: AOJu0Ywka4zqYRVHVblpaq8V4v7kBbNXMy8bEgLfSyfAK1PSpP5ptjoz
	CR4GRpwiPTUaA+NsjkoyeoznCc25vxwzgI3tB2avYxkkDmLx3iMjP7dLolnIVcMUxEW37aI/T5A
	RoSjXeQ==
X-Google-Smtp-Source: AGHT+IEncGKDA7ljh7ysYahjwxo7KpSwFokIz76a6WA8PrjcR8wVa/sRAtW8DiyFrY9OVvNiumSd5nTV54I=
X-Received: from pjbsk9.prod.google.com ([2002:a17:90b:2dc9:b0:32d:bbf6:4b50])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e750:b0:24d:34:b9e7
 with SMTP id d9443c01a7336-25bae8f39c5mr90704225ad.29.1757719476420; Fri, 12
 Sep 2025 16:24:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:23:18 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-41-seanjc@google.com>
Subject: [PATCH v15 40/41] KVM: selftests: Verify MSRs are (not) in
 save/restore list when (un)supported
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Add a check in the MSRs test to verify that KVM's reported support for
MSRs with feature bits is consistent between KVM's MSR save/restore lists
and KVM's supported CPUID.

To deal with Intel's wonderful decision to bundle IBT and SHSTK under CET,
track the "second" feature to avoid false failures when running on a CPU
with only one of IBT or SHSTK.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/msrs_test.c | 22 ++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/selftests/kvm/x86/msrs_test.c
index 6a956cfe0c65..442409e40da0 100644
--- a/tools/testing/selftests/kvm/x86/msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
@@ -392,12 +392,32 @@ static void test_msrs(void)
 	}
 
 	for (idx = 0; idx < ARRAY_SIZE(__msrs); idx++) {
-		if (msrs[idx].is_kvm_defined) {
+		struct kvm_msr *msr = &msrs[idx];
+
+		if (msr->is_kvm_defined) {
 			for (i = 0; i < NR_VCPUS; i++)
 				host_test_kvm_reg(vcpus[i]);
 			continue;
 		}
 
+		/*
+		 * Verify KVM_GET_SUPPORTED_CPUID and KVM_GET_MSR_INDEX_LIST
+		 * are consistent with respect to MSRs whose existence is
+		 * enumerated via CPUID.  Note, using LM as a dummy feature
+		 * is a-ok here as well, as all MSRs that abuse LM should be
+		 * unconditionally reported in the save/restore list (and
+		 * selftests are 64-bit only).  Note #2, skip the check for
+		 * FS/GS.base MSRs, as they aren't reported in the save/restore
+		 * list since their state is managed via SREGS.
+		 */
+		TEST_ASSERT(msr->index == MSR_FS_BASE || msr->index == MSR_GS_BASE ||
+			    kvm_msr_is_in_save_restore_list(msr->index) ==
+			    (kvm_cpu_has(msr->feature) || kvm_cpu_has(msr->feature2)),
+			    "%s %s save/restore list, but %s according to CPUID", msr->name,
+			    kvm_msr_is_in_save_restore_list(msr->index) ? "is" : "isn't",
+			    (kvm_cpu_has(msr->feature) || kvm_cpu_has(msr->feature2)) ?
+			    "supported" : "unsupported");
+
 		sync_global_to_guest(vm, idx);
 
 		vcpus_run(vcpus, NR_VCPUS);
-- 
2.51.0.384.g4c02a37b29-goog


