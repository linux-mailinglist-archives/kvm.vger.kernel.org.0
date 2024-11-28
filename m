Return-Path: <kvm+bounces-32684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 843E49DB107
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:43:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4518F281578
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:43:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE690136349;
	Thu, 28 Nov 2024 01:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0Bl9grH4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012301BC065
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757732; cv=none; b=RZmGS5mrVL3GMqM01KYXXbqB4gqwNt3hQ8/qQM5ivXk9Ontez+s9Fy/Aiz6cjLsDVuwWeC7ZDiNR3bkDMHMLaWcQvrpXYcRfgKySMM1abDPT3LVYrDBRFL9zaqx/Ndf4ZJxjFeqdcTgkQsKstt3IioVKu64aBKgu50wsiA+TbmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757732; c=relaxed/simple;
	bh=BOHi8A/5hb/uwqJQxiyLaa5+Aw1vNkUaQHewXa+IN4g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mWh1ii0fiHMQu355Bmj/F3koND1bkDYOCrXEa49LChZtLsqTZPIePjJz36JUp+5+jnW+10AHtPBNOv1Uabaj2HCSzQjT/6Q2tyHeYo0V949CQHQzb/Id0qcCPLGokU1f3EZ2BwGE3tVhrkRKuN7z1d2mIumTcBu+AiNIREychfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0Bl9grH4; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea41a5bfe7so382320a91.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757729; x=1733362529; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=e4Pxe3blf9Y2K2ZdQ0svEc3rVQZBDN07Z0zGnrD9RNo=;
        b=0Bl9grH4YNcLs/dya1GuMGZrqv8AhOWUGUNIx73ybvuiRodJ/bi1DETbVHYogZf3fI
         MA9crns+zRWkCxng/Fn911ujByfjPhjpSmqVQNO5QhHRnChCqp1EsgqxEPGEG3BUWMDS
         3rcVDL8J3gC/VjUIK3kmlNxxpmSbG8umiLSU7XSQe6vNrcU6UVYWhtvE6Q0RhsbvPvWn
         eWsyWNgBLSXfCLd9anDS78tUSA+HCJ2jWqa7IOoGwxtCdEWBqvuH23rPWKpLF6cub2h+
         R+OY8vSyQOthbA+jBwsWmkDhTtXkDhkb5ZafelqYtYogc7PfxA+kFauRM4+YRqq0mpqe
         Kcdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757729; x=1733362529;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e4Pxe3blf9Y2K2ZdQ0svEc3rVQZBDN07Z0zGnrD9RNo=;
        b=UuzPVfPV6vV1T2DePqnlIraVtM3jBmR2XK6RPFK1RT+VqQj+htFIb/6w/9aS+HRiE2
         v5vOso7Qach2bSxbzozGi1M25yqZ7+8WkAJnidh7t43736gEdBzlIgzwCAkx2igxWtjm
         W9WjpvBi12+a4PyEFujk1lKiEfF5GuDu3/98ZpkCSFvmzwwTNyx2725/8xo+p20L0MjB
         1Xmf38BRi8U+63UvaYtLVJYI2/FA7EF7L1syhaLQgSkTF1udNw2cUVLAfUHL8u/gaWUj
         BgFPwr1EwGEBr/dvr3V0BFS6czylBsGDeu/9n16MaMZkB1F7aJohlBWeUWDS6V3oHtOp
         +Lmw==
X-Gm-Message-State: AOJu0Yy0wskvSU7hrYO4tBAa0g+ZHu6ssfpRptn6vqSlYAQMMI/Zrbuu
	uXM7PMGkks00fdtjkeWt8T7SLSUDJ5XiSaKIPStnkZy3MDzvmbs6/GXvtcABZgEwdu/Ms30G+UR
	0Cw==
X-Google-Smtp-Source: AGHT+IEnvoM381gdCbGWtUi0oTubctHex7MPrIE2lhUB8O05uWg05gWZ4NuG6KJ+kdgPCwTpqiqPkelQPuw=
X-Received: from pjbee11.prod.google.com ([2002:a17:90a:fc4b:b0:2da:ac73:93dd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b51:b0:2ea:88d4:a0cb
 with SMTP id 98e67ed59e1d1-2ee08eb2f50mr7301304a91.16.1732757729231; Wed, 27
 Nov 2024 17:35:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:00 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-34-seanjc@google.com>
Subject: [PATCH v3 33/57] KVM: x86: Remove unnecessary caching of KVM's PV
 CPUID base
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Now that KVM only searches for KVM's PV CPUID base when userspace sets
guest CPUID, drop the cache and simply do the search every time.

Practically speaking, this is a nop except for situations where userspace
sets CPUID _after_ running the vCPU, which is anything but a hot path,
e.g. QEMU does so only when hotplugging a vCPU.  And on the flip side,
caching guest CPUID information, especially information that is used to
query/modify _other_ CPUID state, is inherently dangerous as it's all too
easy to use stale information, i.e. KVM should only cache CPUID state when
the performance and/or programming benefits justify it.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/cpuid.c            | 34 ++++++++-------------------------
 2 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e159e44a6a1b..f076df9f18be 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -854,7 +854,6 @@ struct kvm_vcpu_arch {
 
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 *cpuid_entries;
-	struct kvm_hypervisor_cpuid kvm_cpuid;
 	bool is_amd_compatible;
 
 	/*
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3ba0e6a67823..b402b9f59cbb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -168,12 +168,7 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
 
 	/*
 	 * Apply runtime CPUID updates to the incoming CPUID entries to avoid
-	 * false positives due mismatches on KVM-owned feature flags.  Note,
-	 * runtime CPUID updates may consume other CPUID-driven vCPU state,
-	 * e.g. KVM or Xen CPUID bases.  Updating runtime state before full
-	 * CPUID processing is functionally correct only because any change in
-	 * CPUID is disallowed, i.e. using stale data is ok because the below
-	 * checks will reject the change.
+	 * false positives due mismatches on KVM-owned feature flags.
 	 *
 	 * Note!  @e2 and @nent track the _old_ CPUID entries!
 	 */
@@ -231,28 +226,16 @@ static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcp
 					  vcpu->arch.cpuid_nent, sig);
 }
 
-static struct kvm_cpuid_entry2 *__kvm_find_kvm_cpuid_features(struct kvm_cpuid_entry2 *entries,
-							      int nent, u32 kvm_cpuid_base)
-{
-	return cpuid_entry2_find(entries, nent, kvm_cpuid_base | KVM_CPUID_FEATURES,
-				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
-}
-
-static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu)
-{
-	u32 base = vcpu->arch.kvm_cpuid.base;
-
-	if (!base)
-		return NULL;
-
-	return __kvm_find_kvm_cpuid_features(vcpu->arch.cpuid_entries,
-					     vcpu->arch.cpuid_nent, base);
-}
-
 static u32 kvm_apply_cpuid_pv_features_quirk(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpuid_entry2 *best = kvm_find_kvm_cpuid_features(vcpu);
+	struct kvm_hypervisor_cpuid kvm_cpuid;
+	struct kvm_cpuid_entry2 *best;
 
+	kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
+	if (!kvm_cpuid.base)
+		return 0;
+
+	best = kvm_find_cpuid_entry(vcpu, kvm_cpuid.base | KVM_CPUID_FEATURES);
 	if (!best)
 		return 0;
 
@@ -483,7 +466,6 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	if (r)
 		goto err;
 
-	vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
 #ifdef CONFIG_KVM_XEN
 	vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
 #endif
-- 
2.47.0.338.g60cca15819-goog


