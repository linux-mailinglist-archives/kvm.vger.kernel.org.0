Return-Path: <kvm+bounces-45272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BB4CBAA7C32
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 00:35:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DD8B1BC4ABC
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 22:35:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40F7A21ABB8;
	Fri,  2 May 2025 22:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ij9ysuqP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFC128F1
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 22:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746225301; cv=none; b=O6zeHNsRFFzPihNSDJKIm+A6S07fQaZ4uVt3wT+xpk3330kbnC0Bs7zbn4G9JfoSOiM7wHtFy/2wYVS5ETrEH05EHyCPR38NcvnAxVZRCwMQmhhFCSVXtrTh3fsBJkLgppKOkPM6h8CHj5dtgaHt7T6Lmk8fsUkeowWGp5PZmU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746225301; c=relaxed/simple;
	bh=jfXsnIIu2VwY0c7zeFjxjocJ4orROMa5yuTcrfzPiZw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=X8sZw0anO4QmQG+KKVR3eKrib279dPmwuIqk50h9/lBRwJGtCv9tpeHDAfSPcC+YANp+HGE7aNqsQ9r3Jlf75KmqqKt67R3rGSbkMPQRgvVjEW33kAEJF0WDik87LWef0cFZ99repQknBqUQdgw9D8rV3sCcaL6wepkuYLC2MGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ij9ysuqP; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30828f9af10so3644267a91.3
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 15:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746225299; x=1746830099; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KWVFcVyteM0rANhl8jUHaWIPAf+EazchM+HNHio5hZg=;
        b=Ij9ysuqPhaKQa2iqJtaujgY5AWGr9mG9/RTExbyKQ0eJ0d3ovcCfADgLlxCslrqOds
         b2VdApiZbH6rBR6AtIQetA74oDYJeH+RhBsJFy7216duL7WQX29T99x6cO70Jf5ddfpz
         9GvXUApTKWAiP7arRTuEkz+fxqmivFWAS5uFubwY5g2flcfHG38ift1wH3rRGFrxNSzV
         Nm7wreS3yu5tHdJKTTgj/JFhWJyPvsFF8vLJKcV4sgqgdMGtB52BtqdrsZvjJxUTb6vj
         QrxMuPgGOZvN4jeoXtLLN8EPRBN/7oVo8N2HRVOQjufzuLtkTSGBUkggR1r46omVJQ/y
         KgAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746225299; x=1746830099;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KWVFcVyteM0rANhl8jUHaWIPAf+EazchM+HNHio5hZg=;
        b=N0v4v2qHW16YzzPHgUFeM6UC1/w6+ZoGdmBxhEUxNaMp5CMVVVSOag3yrnkS9psHbn
         rw6j7tP8tzOV3gyIJOvHoD98BsQZgkcW+4MmhkWVQu2dH/zvC7kpTg99uqmdJDhZgNe0
         R6CocW6M4+1PtPiwOVng9wjl0D8VFKK8CNIMzK15P6eiFW2UhsBCiOziqboE91yXrhk6
         LDT4yY6K2z/K27Bcz06BRglKJTqt/DbkF8NdimEp/LsC7bONW9ruT2Zfe/pp9aXeB/Dk
         8GUqIpNhYMXKnuajXkL0UXdxYMDQsyyEnhpyyUxGTiNYQrxjeYfnGsiH59AoY34WSDhi
         08pA==
X-Gm-Message-State: AOJu0YzvWEQasZOE3ppclSK2sQ5TzRqU9HNFa3In9P/NJvdqKlIG2u3M
	RGf5lyrPulIxeOoUErOW3DT7CmZZYc54r9JzsR3FondgO8LRRLAQAdAZ2ViCy0oUBJx2viQo2c4
	Dgg==
X-Google-Smtp-Source: AGHT+IF80pgQ+j2xTDzPXwHebe4UI50ZVfwHe6IkhFUfpDgyVqGJc1Jvql34RQu3S0D0rnfWmpMDMB/HWeQ=
X-Received: from pjuj6.prod.google.com ([2002:a17:90a:d006:b0:2fc:d77:541])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d648:b0:2ff:53a4:74f0
 with SMTP id 98e67ed59e1d1-30a4e6aa8d7mr7031771a91.29.1746225299268; Fri, 02
 May 2025 15:34:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 May 2025 15:34:56 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <20250502223456.887618-1-seanjc@google.com>
Subject: [PATCH] KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=> 1 VM count transitions
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Larabel <Michael@michaellarabel.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"

Set the magic BP_SPEC_REDUCE bit to mitigate SRSO when running VMs if and
only if KVM has at least one active VM.  Leaving the bit set at all times
unfortunately degrades performance by a wee bit more than expected.

Use a dedicated spinlock and counter instead of hooking virtualization
enablement, as changing the behavior of kvm.enable_virt_at_load based on
SRSO_BP_SPEC_REDUCE is painful, and has its own drawbacks, e.g. could
result in performance issues for flows that are sensitive to VM creation
latency.

Similarly, don't bother optimizing the 1=>N and N=>1 transitions, e.g. by
using atomic_inc_return() to avoid taking the spinlock, as ensuring that
BP_SPEC_REDUCE is guaranteed to be set before KVM_RUN is non-trivial.  KVM
already serializes VM creation against kvm_lock (to add the VM to vm_list),
and the spinlock will only be held for a handful of cycles for the 1<=>N
cases.  I.e. the complexity needed to ensure correctness outweighs the
marginal benefits of eliding the lock.  See the Link for details.

Link: https://lore.kernel.org/all/aBOnzNCngyS_pQIW@google.com
Fixes: 8442df2b49ed ("x86/bugs: KVM: Add support for SRSO_MSR_FIX")
Reported-by: Michael Larabel <Michael@michaellarabel.com>
Closes: https://www.phoronix.com/review/linux-615-amd-regression
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 43 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cc1c721ba067..364959fd1040 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -607,9 +607,6 @@ static void svm_disable_virtualization_cpu(void)
 	kvm_cpu_svm_disable();
 
 	amd_pmu_disable_virt();
-
-	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
-		msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
 }
 
 static int svm_enable_virtualization_cpu(void)
@@ -687,9 +684,6 @@ static int svm_enable_virtualization_cpu(void)
 		rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, msr_hi);
 	}
 
-	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
-		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
-
 	return 0;
 }
 
@@ -5032,10 +5026,46 @@ static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	sev_vcpu_deliver_sipi_vector(vcpu, vector);
 }
 
+#ifdef CONFIG_CPU_MITIGATIONS
+static DEFINE_SPINLOCK(srso_lock);
+static int srso_nr_vms;
+
+static void svm_toggle_srso_spec_reduce(void *set)
+{
+	if (set)
+		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
+	else
+		msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
+}
+
+static void svm_srso_add_remove_vm(int count)
+{
+	bool set;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
+		return;
+
+	guard(spinlock)(&srso_lock);
+
+	set = !srso_nr_vms;
+	srso_nr_vms += count;
+
+	WARN_ON_ONCE(srso_nr_vms < 0);
+	if (!set && srso_nr_vms)
+		return;
+
+	on_each_cpu(svm_toggle_srso_spec_reduce, (void *)set, 1);
+}
+#else
+static void svm_srso_add_remove_vm(int count) { }
+#endif
+
 static void svm_vm_destroy(struct kvm *kvm)
 {
 	avic_vm_destroy(kvm);
 	sev_vm_destroy(kvm);
+
+	svm_srso_add_remove_vm(-1);
 }
 
 static int svm_vm_init(struct kvm *kvm)
@@ -5061,6 +5091,7 @@ static int svm_vm_init(struct kvm *kvm)
 			return ret;
 	}
 
+	svm_srso_add_remove_vm(1);
 	return 0;
 }
 

base-commit: 45eb29140e68ffe8e93a5471006858a018480a45
-- 
2.49.0.906.g1f30a19c02-goog


