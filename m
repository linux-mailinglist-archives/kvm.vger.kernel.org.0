Return-Path: <kvm+bounces-63234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 807AFC5EA20
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 18:46:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 389C9383194
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 16:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D1B3370F7;
	Fri, 14 Nov 2025 16:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BRh4zlpJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7D4334C22
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 16:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763138406; cv=none; b=dIWQsvkoz5joEznEq0HByheAKH1kW8VcI0Bc/DwyOndMcfvmygM+53O2V4Y1uex2rxsTTey3r+PcCY83Go6gK9GH5IAZHTBc5+dG5+xEx8SZnuRXcaX2FMoAadle7K/Q/naTbslu6nuSDetM9ZJUqimldJfATesPcpDP0NigM5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763138406; c=relaxed/simple;
	bh=0q1LSTNcWfhRhxo9wwTNWh/KOxbev5bnQ/8Wdz5tUuc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ipA80qB/BfX4HdTph5Nawh7Da/3PfJXn0ddnlse/btIvN0nLzggxWfa2AhhYgNdydV8OnKACjVdL2G+/ZnXekKXWqlEXyVrK1wI+46A6Kzymuh3CLWy1RBBqguhlKk/6zNKLtLAivuGOFY6PrlAghglp0cACvhW5gYdjvggLyh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BRh4zlpJ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29555415c09so28734915ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 08:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763138404; x=1763743204; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KTMohZMjF0LmDk1TElNZL5EIXiLhl+OzBkAAJL2pM6g=;
        b=BRh4zlpJopspjWt6Vg+B0nyV00QWz0NKlvl+yTS9I1lY2E6wqTP2VrDJrjr9PXoqFx
         rTmQCuQaIqTFcPMR9Roce2REf0Y1VVjamgISEcQ/P3Bic6aES02FSJlJUa68iQzbYOmh
         WtGbezadAnt/7NGXtVqboqDVLzBJWGouceGc5QSrLWYvf/6OV+t3HhcaRPTvJ/Wvc6lV
         MbJ3UwENrv3cEnNp/qlX/1jnWeAgVYw3cUoGbAmeIBQ8Trfn7eTfGu3L5Le3mBFAEkqa
         5Aw9tZAalPbRFi/XXEvg0JCtQRahpUGzrNaKd3Ye7h3rDXjmMXIJJ/gzdRzLAHtDLvvD
         oYwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763138404; x=1763743204;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KTMohZMjF0LmDk1TElNZL5EIXiLhl+OzBkAAJL2pM6g=;
        b=WfUcP6rwjT4Y3uCuSHTj0EOGQO0nKnyF+CyFsYVW1jCblND/2P0nPF5A/Vs7WLxVKB
         PwPXGJke4kAn8e2BoZjRSoNpMzm8vjgAbBo/ALCRX/npKWES8lVzr6Eb+n5fBqOjMhET
         B0pl/ZRwEeUzJR9yy6GTZJBD1sbK0hwIEBQC7YjwEh1VXIW4l0l4awceF/G0cMmAmNPC
         0pGggelteVGIecwaIlyjeUfglJM+1GRf4gdSLiWnvhXVlNm1gv35NzJQHHEO79ZlMFOu
         S0M5DmOAN1w8H+QNN9OKnRSva481ei7O0CmalgzIBCFMizmvrC8NCrfw6SP+SGmwl6Vh
         Mypg==
X-Gm-Message-State: AOJu0Yydv8oOyd6IFfh3HJMPBkoGDJaAcus/YzloGYQy0jw6esWCFpCE
	Xn67ChtdSzUoZTKvB0Cx5bw/H2o2W40eor1hGaofjniXdBZsXcpJ3rsccZwFe+WiiRHq66vLKMO
	FcJsr3w==
X-Google-Smtp-Source: AGHT+IGA7G1A0VmYSd0Eo9Xq1AOJbGmNJ/+oU6KUlAGTk5vw5hoj9x9MGGqCLYmTDTDqmV0H8SYZbnqUSqQ=
X-Received: from pjwo13.prod.google.com ([2002:a17:90a:d24d:b0:33b:c211:1fa9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f647:b0:298:42ba:c422
 with SMTP id d9443c01a7336-2986a73303amr42123035ad.31.1763138404137; Fri, 14
 Nov 2025 08:40:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 08:40:01 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114164001.1791718-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Use GUEST_ASSERT_EQ() to check exit codes in
 Hyper-V SVM test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Use GUEST_ASSERT_EQ() instead of GUEST_ASSERT(x == SVM_EXIT_<code>) in the
Hyper-V SVM test so that the test prints the actual vs. expected values on
failure.  E.g. instead of printing:

  vmcb->control.exit_code == SVM_EXIT_VMMCALL

print:

 0x7c != 0x81 (vmcb->control.exit_code != SVM_EXIT_VMMCALL)

Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86/hyperv_svm_test.c  | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
index 0ddb63229bcb..7fb988df5f55 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
@@ -94,7 +94,7 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
 
 	GUEST_SYNC(2);
 	run_guest(vmcb, svm->vmcb_gpa);
-	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
+	GUEST_ASSERT_EQ(vmcb->control.exit_code,  SVM_EXIT_VMMCALL);
 	GUEST_SYNC(4);
 	vmcb->save.rip += 3;
 
@@ -102,13 +102,13 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
 	vmcb->control.intercept |= 1ULL << INTERCEPT_MSR_PROT;
 	__set_bit(2 * (MSR_FS_BASE & 0x1fff), svm->msr + 0x800);
 	run_guest(vmcb, svm->vmcb_gpa);
-	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
+	GUEST_ASSERT_EQ(vmcb->control.exit_code,  SVM_EXIT_MSR);
 	vmcb->save.rip += 2; /* rdmsr */
 
 	/* Enable enlightened MSR bitmap */
 	hve->hv_enlightenments_control.msr_bitmap = 1;
 	run_guest(vmcb, svm->vmcb_gpa);
-	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
+	GUEST_ASSERT_EQ(vmcb->control.exit_code,  SVM_EXIT_MSR);
 	vmcb->save.rip += 2; /* rdmsr */
 
 	/* Intercept RDMSR 0xc0000101 without telling KVM about it */
@@ -117,13 +117,13 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
 	vmcb->control.clean |= HV_VMCB_NESTED_ENLIGHTENMENTS;
 	run_guest(vmcb, svm->vmcb_gpa);
 	/* Make sure we don't see SVM_EXIT_MSR here so eMSR bitmap works */
-	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
+	GUEST_ASSERT_EQ(vmcb->control.exit_code,  SVM_EXIT_VMMCALL);
 	vmcb->save.rip += 3; /* vmcall */
 
 	/* Now tell KVM we've changed MSR-Bitmap */
 	vmcb->control.clean &= ~HV_VMCB_NESTED_ENLIGHTENMENTS;
 	run_guest(vmcb, svm->vmcb_gpa);
-	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
+	GUEST_ASSERT_EQ(vmcb->control.exit_code,  SVM_EXIT_MSR);
 	vmcb->save.rip += 2; /* rdmsr */
 
 
@@ -132,16 +132,16 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
 	 * no VMCALL exit expected.
 	 */
 	run_guest(vmcb, svm->vmcb_gpa);
-	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
+	GUEST_ASSERT_EQ(vmcb->control.exit_code,  SVM_EXIT_MSR);
 	vmcb->save.rip += 2; /* rdmsr */
 	/* Enable synthetic vmexit */
 	*(u32 *)(hv_pages->partition_assist) = 1;
 	run_guest(vmcb, svm->vmcb_gpa);
-	GUEST_ASSERT(vmcb->control.exit_code == HV_SVM_EXITCODE_ENL);
+	GUEST_ASSERT_EQ(vmcb->control.exit_code,  HV_SVM_EXITCODE_ENL);
 	GUEST_ASSERT(vmcb->control.exit_info_1 == HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH);
 
 	run_guest(vmcb, svm->vmcb_gpa);
-	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
+	GUEST_ASSERT_EQ(vmcb->control.exit_code,  SVM_EXIT_VMMCALL);
 	GUEST_SYNC(6);
 
 	GUEST_DONE();

base-commit: 16ec4fb4ac95d878b879192d280db2baeec43272
-- 
2.52.0.rc1.455.g30608eb744-goog


