Return-Path: <kvm+bounces-42052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 266E5A71F48
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:39:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C8AF16AC3D
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4908B26159A;
	Wed, 26 Mar 2025 19:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o+IDUV+l"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018E125F7A0
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743017823; cv=none; b=grDAlZsBU59Ps5NjVZGjmcF0KKS7U6wvpl0Ywz9Ugky6SHulNjiCYYO04KKnLu8dMey5ff9qili7RxCli8o5arybPWjCp8Nac3PcXBlfEbi63b5OvzqMUoW/0UJdy300QWrAcdTY5eCiw8jtkKPxzMFzN3wOKepmZPKM9EV7RpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743017823; c=relaxed/simple;
	bh=mpkqTiXhsmrMOyk9yfUfCJO+bVXBugBwgWilo/r1Evk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iaKONl1CwFlFepIhtQi9lqvcBUAXJoAY8A1vDe9YxfMx/yA/CfWsaQymclA9pN7w3WnvENAiM+FyO+bA9LHQDVcWveHq72yz9B2kqoybbFxye36AYy9StU5k3QAO/XwC2kdbPT19XMuDF8t1XnXHijhAe73zt9vWbUuIhcWZX4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o+IDUV+l; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743017820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yirgN4Is7JOXz8zXxwuHrhDe68dVeA7KMSnZ7zH2SVM=;
	b=o+IDUV+lHPSiww9h0xHOYgt/gJ8ON29CgcamVzN21E+m4vfYQmI/LLQTXRc4ZDKPWP8M+2
	VNT3SdcAgmq7uB1EDZ/U0M+0Za4rPbdLQj8vJW1HK9kVOnjiahR8uA57TCl9PaMcx6/sE0
	+Q+In3AvxTelVREKeOFim1IK9oZQN6o=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [RFC PATCH 07/24] KVM: SEV: Track ASID->vCPU on vCPU load
Date: Wed, 26 Mar 2025 19:36:02 +0000
Message-ID: <20250326193619.3714986-8-yosry.ahmed@linux.dev>
In-Reply-To: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Check for changes in the ASID to vCPU mapping on vCPU load instead of
doing it on vCPU run. This should be sufficient and more efficient, and
is needed to allow generalizing the tracking and making it more
expensive.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/sev.c | 13 ++++---------
 arch/x86/kvm/svm/svm.c | 13 +++++++++++++
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ddb4d5b211ed7..3ef0dfdbb34d2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -224,7 +224,7 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 	return ret;
 }
 
-static unsigned int sev_get_asid(struct kvm *kvm)
+unsigned int sev_get_asid(struct kvm *kvm)
 {
 	return to_kvm_sev_info(kvm)->asid;
 }
@@ -3453,7 +3453,6 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 
 int pre_sev_run(struct vcpu_svm *svm, int cpu)
 {
-	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
 	struct kvm *kvm = svm->vcpu.kvm;
 	unsigned int asid = sev_get_asid(kvm);
 
@@ -3469,16 +3468,12 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu)
 	svm->asid = asid;
 
 	/*
-	 * Flush guest TLB:
-	 *
-	 * 1) when different vCPU for the same ASID is to be run on the same host CPU.
-	 * 2) or this VMCB was executed on different host CPU in previous VMRUNs.
+	 * Flush guest TLB if the VMCB was executed on a differet host CPU in
+	 * previous VMRUNs.
 	 */
-	if (sd->sev_vcpus[asid] == &svm->vcpu &&
-	    svm->vcpu.arch.last_vmentry_cpu == cpu)
+	if (svm->vcpu.arch.last_vmentry_cpu == cpu)
 		return 0;
 
-	sd->sev_vcpus[asid] = &svm->vcpu;
 	vmcb_set_flush_asid(svm->vmcb);
 	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 	return 0;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1156ca97fd798..e6e380411fbec 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1554,6 +1554,7 @@ static void svm_prepare_host_switch(struct kvm_vcpu *vcpu)
 
 static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
+	unsigned int asid;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
 
@@ -1568,6 +1569,18 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_vcpu_load(vcpu, cpu);
+
+	if (sev_guest(vcpu->kvm)) {
+		/*
+		 * Flush the TLB when a different vCPU using the same ASID is
+		 * run on the same CPU.
+		 */
+		asid = sev_get_asid(vcpu->kvm);
+		if (sd->sev_vcpus[asid] != vcpu) {
+			sd->sev_vcpus[asid] = vcpu;
+			kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+		}
+	}
 }
 
 static void svm_vcpu_put(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4ea6c61c3b048..ca38a233fa24c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -768,6 +768,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
+unsigned int sev_get_asid(struct kvm *kvm);
 
 #ifdef CONFIG_KVM_AMD_SEV
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp);
-- 
2.49.0.395.g12beb8f557-goog


