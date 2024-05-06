Return-Path: <kvm+bounces-16649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 207838BC6F1
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:35:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAF12281748
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4132214388A;
	Mon,  6 May 2024 05:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e0KN4Cqv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35034143877
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973499; cv=none; b=tG8idRoS9IelH3klSJC+TGnffRWzQnlGooqxsQpVBcNS2sLaaIStB5ukH6Mv7LxqvXR8KAAarqyYkaqyTTLI9aBa5yjhiHSrodD/hGcLz5H0wZisshPWe6oTFzKGJzGMpa186ORuxnZ8A8S80qV7zRMdW2R/C0XWu3zi0qAgOfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973499; c=relaxed/simple;
	bh=H5VJU3psCYgp/k2Nle2Kr0rBKad98Mrlue8egGTIFsU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=umpG71k8N9aC8QB7JAChPsTTLsCOyhagHVG3C+98mKSZ0fhB9H7ArP0J7OoB2tNZ3HHhxnRSh46AJLxgBUTNR6JxrejSJbPsI1GzCnjloEQMTO9RFUJdCWoLbJh+hD75HuCc1zp4F1I/LHFmJz7aXIxxUSZ7ZaA2weu0ZkE7JZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e0KN4Cqv; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6f3efd63657so1620752b3a.2
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973498; x=1715578298; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/ZpxXAlW3ogmdgJpT5++xDXNSobWCTXr0d0WIX/XGXw=;
        b=e0KN4Cqvdfe8sjpm5irEjDZmU5ryhJPIgy/VRheKTjMTN3KsGGDyq6FdHqCwTJdSVM
         iNFJ9ubOSfhqlvgTOClndEx/FT/u9mP083R0+oLawk67u9eTZZ/RDD9JYwfpB9e6eKOQ
         PkgFGl0b5LyQhEPhuEyRz2lo2iRVQGhWfz7FV36rhWakEKnapLPTWYIrfTnSR/HiMjyf
         HHhmosbRy0m1HR0FoRWWucGP1LpyNDJTxdR9gfauzX6RY/rVdrtfmRYc8s5mvSpdbr1M
         4i4IovrEDNVNWCVVSfdRE8f7iOUy+nOyWejP4Boasinl4YNevT8qnhtQ+Jkcz8Yfpglp
         Kmbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973498; x=1715578298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/ZpxXAlW3ogmdgJpT5++xDXNSobWCTXr0d0WIX/XGXw=;
        b=w6QxNE2I6IspiRmCxBkCpoqAvCkxXniTj6aoeCiEYHp0vqcpiPpfYtXUH7nV6ULAEB
         h7oTwdhmIkEN5q6tDgUGnEDu5O0N/l3ZDwYyGhkhHbgp9tBpeaoYUdb32NpK7wA03cCO
         BQkQ4ZHbT2jb8Oep3AOBTY6ov5L41bgRagGL54bv5iQjh5T/1M44LHE7hn56eJf34muL
         pB+rvLUlDMlZm1XTEQ5EiUMus+q9fpZmbPMs9F7DbsX51dtzR3Drhe2EFym8Xe7w7ud9
         FKwRyyAlnygHi0AQwFtOEup5QdG3KqAYDOSkLSpXl3KQm5626XXP2iHGRf8Yua8L5dLn
         D/5A==
X-Forwarded-Encrypted: i=1; AJvYcCXLsFhrf59YtkHOvNvcBbsO7hynpYSN///ThDTFwcwTZjDBEkca3aCLz/k01m5oc2D9oD/z3N7/DQ9tfC2F38TVzO+B
X-Gm-Message-State: AOJu0YxQd1Sg8r/2LWGe40kylKiUJQOko/JueyG36IwbGP7XUxfNPSul
	oOhtZpNz+bmyMxj0bpf3rTJVERArgtjJe1M0cgT6lER0Ymu0jme/Uy1OULFxLDvTIvOUeEp5wXd
	AN90E7Q==
X-Google-Smtp-Source: AGHT+IFY5Z+Xd5c64hltPgv/1tFfWjyX318kJSm2zQaG/hAuq4r+2oqUmZbl/Z7OBEZ7ma7yhcutpgz4qrkT
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6a00:a19:b0:6ec:f5b8:58cc with SMTP id
 p25-20020a056a000a1900b006ecf5b858ccmr320432pfh.6.1714973497691; Sun, 05 May
 2024 22:31:37 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:30:02 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-38-mizhang@google.com>
Subject: [PATCH v2 37/54] KVM: x86/pmu: Grab x86 core PMU for passthrough PMU VM
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, maobibo <maobibo@loongson.cn>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Xiong Zhang <xiong.y.zhang@linux.intel.com>

When passthrough PMU is enabled by kvm and perf, KVM call
perf_get_mediated_pmu() to exclusive own x86 core PMU at VM creation, KVM
call perf_put_mediated_pmu() to return x86 core PMU to host perf at VM
destroy.

When perf_get_mediated_pmu() fail, the host has system wide perf events
without exclude_guest = 1 which must be disabled to enable VM with
passthrough PMU.

Once VM with passthrough PMU starts, perf will refuse to create system wide
perf event without exclude_guest = 1 until the vm is closed.

Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
---
 arch/x86/kvm/x86.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db395c00955f..3152587eca5b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6674,8 +6674,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (!kvm->created_vcpus) {
 			kvm->arch.enable_pmu = !(cap->args[0] & KVM_PMU_CAP_DISABLE);
 			/* Disable passthrough PMU if enable_pmu is false. */
-			if (!kvm->arch.enable_pmu)
+			if (!kvm->arch.enable_pmu) {
+				if (kvm->arch.enable_passthrough_pmu)
+					perf_put_mediated_pmu();
 				kvm->arch.enable_passthrough_pmu = false;
+			}
 			r = 0;
 		}
 		mutex_unlock(&kvm->lock);
@@ -12578,6 +12581,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.guest_can_read_msr_platform_info = true;
 	kvm->arch.enable_pmu = enable_pmu;
 	kvm->arch.enable_passthrough_pmu = enable_passthrough_pmu;
+	if (kvm->arch.enable_passthrough_pmu) {
+		ret = perf_get_mediated_pmu();
+		if (ret < 0) {
+			kvm_err("failed to enable mediated passthrough pmu, please disable system wide perf events\n");
+			goto out_uninit_mmu;
+		}
+	}
+
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
@@ -12726,6 +12737,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
 		mutex_unlock(&kvm->slots_lock);
 	}
+	if (kvm->arch.enable_passthrough_pmu)
+		perf_put_mediated_pmu();
 	kvm_unload_vcpu_mmus(kvm);
 	static_call_cond(kvm_x86_vm_destroy)(kvm);
 	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


