Return-Path: <kvm+bounces-39414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D753A46F4A
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 00:18:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 720FB7A7EA3
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 23:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5668B2702BF;
	Wed, 26 Feb 2025 23:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZNR+sn03"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0E82702A7
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 23:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740611893; cv=none; b=CkpTQNQM4FG8gFOm0GeQuC03duhYKhvtd1ySBUozKFLVQ6v0yJY1a3InCeD/RfeWwCkfyxTXLDT77nCitE+ZexTHiXMWl/PxDQHQJuHiu/GachuVg1h5DzKlxwD++Q1DWAsJZWaMGhTfYMmGCJWOADm2TUNFxo8IEZbTxAV9NrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740611893; c=relaxed/simple;
	bh=Qkm5BIKtbAFKIKjExrny2u3LarGMU+GBVzkWBeN5zS8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=pZUnzt9bi7csnUHj9Hu6jO8H5PEu2CY3HMsoBbD0sqE0V8kTtTLJKB5xHi4MEzvz//8dySohJRRus0Ah2DaVNPO7j0uBbZ4w8fWJAMnRATRitSw0t2VGdzp2NOXXsvTbH1n7ZeR2JPbJAo2e1Q8X+C0biDXfhvVrYtxuSt1VZIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZNR+sn03; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe86c01e2bso722846a91.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 15:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740611891; x=1741216691; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OApIGFxNkhYuZ7jMdFGNMK6W71TWPZaSxPmKfEXurdM=;
        b=ZNR+sn03iCrYTR1zv+ibh3WUhe6Sp3kdvfzBAZR1GkZ/S1x5/SJqTaPQ1DP4Eza6uN
         rLAhukLBfD3ECeAXTIN/RnIXXEUyFZeEqtgZEYsCUGebnzxEIU+g7RqOocOB4jhmT6ZV
         N8huwKYLjgRwzoyvaYsthxOS/n8U9+nIauFZSdORYm7g/9g/CJr0qfp97O3GNrBVaEIl
         y3CZS5bNRiBtwu41YG8Tth0dQJUbZvN7JhsDipgM8lqQlmVyXjCcLvcTOSQNi1sb/KrG
         blhcLbSR0s/JTKggHam1dy2aH9AQ9c+rR3DkJ+ManGgtHybIjo1I1MtXZjzqwLFt/c/c
         rjtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740611891; x=1741216691;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OApIGFxNkhYuZ7jMdFGNMK6W71TWPZaSxPmKfEXurdM=;
        b=uHhpfrAXfa2EKxcX77FPGfl0Qe6EOPNfYu1HPAVBThaoyUisZcWwqPINN6EBnC/dE4
         6okxghyUZBDEwqPn+CXe2yF2BW719HyFK68Emi0mfaSNptFaS+EcfqVHMlpcFWYo/cGz
         +VRY0gLs7kGwFeBMwA8il+NkY/RX5JilUmc6/c9xDLqFAZP7lgBB6z9wDkU0Cp4btlFA
         eoBiA3R9fL3XVfYfbLfphatkZobDQsXaczmlPQJsXv1DXhjTXdKDBuwMt9yH1RCl7drR
         zSsSTXE/TLJAM4jjZ7Lp7Mzdkw3s+TJYbue+a5q4cJZ45xBHYVHkbChUzGPiA0meShrS
         rVKA==
X-Gm-Message-State: AOJu0YyM04a68NVi8XAg69XfOaL+R3VBqhLFpMl6/3DoQhhm1Y3aTPjO
	/0J2wuv8j5wngC8H3rHAAt/u7cEUPnDquH+XrNzbpsbCEe1KxJtveYk1MkXqwKWKKuC3alXFHmG
	ypQ==
X-Google-Smtp-Source: AGHT+IGhzRlzNfLfem0QIlPUfzfjHMql18Hl3vIG1JGEHOibbS5iEQ41pW7nqNdJBFPxetvvTbfh6soGDVg=
X-Received: from pfjf17.prod.google.com ([2002:a05:6a00:22d1:b0:732:2df9:b513])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:190e:b0:730:87b2:e839
 with SMTP id d2e1a72fcca58-73426d8ff83mr41869311b3a.21.1740611891375; Wed, 26
 Feb 2025 15:18:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 15:18:09 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250226231809.3183093-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Relax assertion on HLT exits if CPU supports
 Idle HLT
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

If the CPU supports Idle HLT, which elides HLT VM-Exits if the vCPU has an
unmasked pending IRQ or NMI, relax the xAPIC IPI test's assertion on the
number of HLT exits to only require that the number of exits is less than
or equal to the number of HLT instructions that were executed.  I.e. don't
fail the test if Idle HLT does what it's supposed to do.

Note, unfortunately there's no way to determine if *KVM* supports Idle HLT,
as this_cpu_has() checks raw CPU support, and kvm_cpu_has() checks what can
be exposed to L1, i.e. the latter would check if KVM supports nested Idle
HLT.  But, since the assert is purely bonus coverage, checking for CPU
support is good enough.

Cc: Manali Shukla <Manali.Shukla@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86/processor.h |  1 +
 tools/testing/selftests/kvm/x86/xapic_ipi_test.c    | 13 ++++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 61578f038aff..32ab6ca7ec32 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -200,6 +200,7 @@ struct kvm_x86_cpu_feature {
 #define X86_FEATURE_PAUSEFILTER         KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 10)
 #define X86_FEATURE_PFTHRESHOLD         KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 12)
 #define	X86_FEATURE_VGIF		KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 16)
+#define X86_FEATURE_IDLE_HLT		KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 30)
 #define X86_FEATURE_SEV			KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 1)
 #define X86_FEATURE_SEV_ES		KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 3)
 #define	X86_FEATURE_PERFMON_V2		KVM_X86_CPU_FEATURE(0x80000022, 0, EAX, 0)
diff --git a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
index b255c7fbe519..35cb9de54a82 100644
--- a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
@@ -466,7 +466,18 @@ int main(int argc, char *argv[])
 	cancel_join_vcpu_thread(threads[0], params[0].vcpu);
 	cancel_join_vcpu_thread(threads[1], params[1].vcpu);
 
-	TEST_ASSERT_EQ(data->hlt_count, vcpu_get_stat(params[0].vcpu, halt_exits));
+	/*
+	 * If the host support Idle HLT, i.e. KVM *might* be using Idle HLT,
+	 * then the number of HLT exits may be less than the number of HLTs
+	 * that were executed, as Idle HLT elides the exit if the vCPU has an
+	 * unmasked, pending IRQ (or NMI).
+	 */
+	if (this_cpu_has(X86_FEATURE_IDLE_HLT))
+		TEST_ASSERT(data->hlt_count >= vcpu_get_stat(params[0].vcpu, halt_exits),
+			    "HLT insns = %lu, HLT exits = %lu",
+			    data->hlt_count, vcpu_get_stat(params[0].vcpu, halt_exits));
+	else
+		TEST_ASSERT_EQ(data->hlt_count, vcpu_get_stat(params[0].vcpu, halt_exits));
 
 	fprintf(stderr,
 		"Test successful after running for %d seconds.\n"

base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.48.1.711.g2feabab25a-goog


