Return-Path: <kvm+bounces-22873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AAFD4944276
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:04:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5598F1F23B58
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D97D14F9D0;
	Thu,  1 Aug 2024 05:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZPKktfGx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7C414F11C
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488427; cv=none; b=l9QJOpe5LLYEd72JoP0Yrbm/baf+DUjQE1xB04msm/IiLm83UpSRawuo31pxD4nINZZzeshiE5oGPNtjJ2A3XG2bgMWaxlHDdIKHldX4ECjLLyAeTFWLCoy2UHguadkiGTol+iZom3MB6PwL9pZLj1nGTI2DhOzdBOZbVVFdQTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488427; c=relaxed/simple;
	bh=j5z07mEw1a3NzUvM+YcPKrlrEYXrkrfP13gxBdsC9Rk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ct3ayd67FHIpvNwN/93QjmCpawCSZlgTD57Ei/Sx57Kt4c70KlCbYk3Xdnw6JUZF6xF06wzU6c2l6ZfOKweqTdmVZrcKzz088MloVOURdq+W3+3jcXnS70sRds5hURQhFyfyAskYTD4p+Eo8qhPgzIcPMbwenHzpI/aGyslhznk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZPKktfGx; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc5e651bcdso66728645ad.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488425; x=1723093225; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QyXLIC3s5xW9HET961595nlV4jFaPkV2bjM57q/oowA=;
        b=ZPKktfGxFUa2qUunpQv0cglRuGMAYox53WU4Lowx4dezbcbhxB/cr38l4BYdOHB3X+
         SoNf2gRQALjhZrgFKCLQ/jDDF40SDKVpH91ns54VMJJFUN3wk7yVBM2Zd/9duIVEiofh
         PDa9zeZ7xWlnIEaxvW3gdA+kvZrupXbqbTJhXPRXUBF7b+Ohf+xQOBmATPwebJvFByEQ
         MPtuNNUYCntY8Mv/FlQp/UoBToSZNiRWfB4wBJXXcfryqXTFphMcXwWGbpRZR+Ne2Gxp
         /2HRn619xsBHweYBxW9daKPHRxBzsoTCRrCj7516u5xWRH+VKMqGJcJg2dUWdsTNAKR2
         c7bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488425; x=1723093225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QyXLIC3s5xW9HET961595nlV4jFaPkV2bjM57q/oowA=;
        b=VsewlajiW+xi2FsOUK2xja+hlIS8J7h0vjCrPnVuupEKfhFLXxBmC2Em7owaDiVnwJ
         0azB2ccLOpciHCPc+OaEsiUmvJkZvlfbftGuDErKus9+tMKyFIY2L0paZSi//39RTZ2M
         XFeDAkWPYNYV7XmeVht+uFQC955+19zPNKN3S20BXbJ4Ilwo1wwm6RfUEHfV3i8zp3nc
         mKoPJuBtDmUKZAoecppP7XQtlECiD5yg/k204aOMwZb7VMwzFBReBNP48HMXEYIQr0Vt
         gEf2hzei+4f8jCO8DA9a9/S6hf2hUtYbRIsPDrMRvxpWYV5hxVzjnMG8JM0g2W6WwBTq
         tBfA==
X-Forwarded-Encrypted: i=1; AJvYcCU8Ql0ZhVE4U7bP1Z4bPgij3yX5UjRPjEe/DEW+hVE9nx8LRR2ejDRfmNDwhzkbXtT6yH4/oju6KZkgosdZCkT4UAv8
X-Gm-Message-State: AOJu0Yx01H9RDiw8D8QOlIQIXnkIskR/zkyur0s7Slg9RKZHuv2BnUfE
	EqBqLNUIND7qcb+cXLppY9hOoP0q6HNOEpXpyX1kBf/EVRFWdgwMZ+LPukc7fz+lay43DP+6vyf
	gMj4Z1g==
X-Google-Smtp-Source: AGHT+IFUTtpDpvZf3y7902GI7QcnK8JU6POP1tL8roTadbEKEqyAuifvYwcGL1fDLnEiYOD61Y5kOcwkmt4+
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a17:903:1d1:b0:1ff:458e:8e01 with SMTP id
 d9443c01a7336-1ff4cc7e37amr1485355ad.0.1722488425316; Wed, 31 Jul 2024
 22:00:25 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:49 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-41-mizhang@google.com>
Subject: [RFC PATCH v3 40/58] KVM: x86/pmu: Grab x86 core PMU for passthrough
 PMU VM
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
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
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/x86.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6db4dc496d2b..dd6d2c334d90 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6690,8 +6690,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
@@ -12637,6 +12640,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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
@@ -12785,6 +12796,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
 		mutex_unlock(&kvm->slots_lock);
 	}
+	if (kvm->arch.enable_passthrough_pmu)
+		perf_put_mediated_pmu();
 	kvm_unload_vcpu_mmus(kvm);
 	static_call_cond(kvm_x86_vm_destroy)(kvm);
 	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
-- 
2.46.0.rc1.232.g9752f9e123-goog


