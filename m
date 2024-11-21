Return-Path: <kvm+bounces-32306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 17F819D5324
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 20:03:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 849A5B290C6
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 19:03:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF0461E2311;
	Thu, 21 Nov 2024 18:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j9JoyGno"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841A11E2853
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 18:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732215233; cv=none; b=daSdsBcUM8kOEBurqIvq64sCrqy1MW00h5Bce7BsESQCS+B4dbVBT9J9uoiWRtM3ngBHjbxpxAWzAuGwoGaU2s7j32rp/JJKywn8FH6b/i1tsUFZHJBQYaL2Ijy753R31jpyO6i4T586WYw8OX1lGzP9Pn1ene6CD0OoUK4+k4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732215233; c=relaxed/simple;
	bh=cg2iyp4+CvEy683WYX+ECsqwzXyjhokH3kRioPhRAhA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bjVoQXn1m+w3C9h6yD+9+dHX3cAt1hD2CyJWzyiodM+wvJmz500P9sAasAu2iTxO7407skfqQa8PK0DTnAQ2cdZ53kvjtNd4GMip/4y33J01N1g8AsRFwVj8+OA4GN1wDNdWqpwt7EKnb574aKa83LaJdjwrISd9EberWNBes54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j9JoyGno; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e35e9d36da3so2130655276.1
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 10:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732215230; x=1732820030; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=umjqRaPxMOMBPCY2bbDeorL7OH9qU4LVOhrbwYAX8Gs=;
        b=j9JoyGnokUtEHz3lfzkhbspaGKCa+33sm0MVSbCDRr0sBQBSR+grVb6mYQDOGsT93f
         SOx9ViDC28yPoPUAQiNWP/NHAPKgOWxO9kCQ61n7uyeltW42CWGpdbTB+2bOK6r0O/54
         O7d6PUgJflGfGf7l2FSbL5+nZ2rG2vHNOxgQCpy/HEKvs5KjDCvVpAouEf6pNEk36pdy
         NEkeyXWCmQ1WdZmV/YhWg674h4UEqJEFPEhAYFaZL9C67LLyFmAE3eqcjdbWvHDymwZ7
         soYq20UQisXLuW4e2dHtz/MIf8wTdYNCV1pzB9enM8ecQOXxF0bxvXKUsI9iz0d2Hx+b
         iLbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732215230; x=1732820030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=umjqRaPxMOMBPCY2bbDeorL7OH9qU4LVOhrbwYAX8Gs=;
        b=B1D9BO6WMxeoICaYjkn7vKEUqd5cCEf5WckSYYkacLpGbq5r6INki72mOq3CAXuhzh
         JeAr/wGrJmoqCr9KTqvgSCIQkxduQxaIqohw8hoDO3gfYp8ecioi/PVx4H5qhrSCqvbs
         uSUk+jwZgF1++BkWoHT5xIrxbyyaSavtKZLs2QuUTNwe7vTdktYf4KeTcj/xKbjmpebd
         0HtefDUqY+aELvdhR53fD1GDarhj9U2aJXaNxL2Xn+WzKDMI+9Wfu+G/8plaNSLl9h6Q
         xqGkMD5Ubc1ia827Pn2SJUVbMtewzDhh2l5PC2ljx05Bu+NzKTty8ygTZQaaHScjuyWX
         FyCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqPPtk30jX5xsvDvo2mxd8r0U13IeGScvQ8jszaXJmK4rfdAf8pQp8ouycZzKAfN5SV7I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzH+5EyK/xI3VM3SEtaip154/W0UQWqZJOVGoqKot+oYLQiPWm3
	mujVjT5xDAC/rxHTNxMmV38TFRZmR/Ymky4dgjwUGrSJayaScP+N2ZW2siajCiqW+VEbq2LyDSr
	YLDGsPQ==
X-Google-Smtp-Source: AGHT+IG4i7fOAFePg97UFWHvr+E2Z6FO0kC5FD9Us3UIujj+wD5TBePM+4bKH0fL2aTTdEKp0RfkKSC8TCCi
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a25:ba4c:0:b0:e38:10a7:808e with SMTP id
 3f1490d57ef6-e38f889f2ddmr1276.0.1732215230445; Thu, 21 Nov 2024 10:53:50
 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu, 21 Nov 2024 18:53:11 +0000
In-Reply-To: <20241121185315.3416855-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241121185315.3416855-20-mizhang@google.com>
Subject: [RFC PATCH 19/22] KVM: x86: Allow host and guest access to IA32_[AM]PERF
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

Implement MSR read/write handlers for IA32_APERF and IA32_MPERF to
support both host and guest access:

- Host userspace access via KVM_[GS]ET_MSRS only reads/writes the
  snapshot values in vcpu->arch.aperfmperf
- Guest writes update both the hardware MSRs (via set_guest_[am]perf)
  and the snapshots
- For host-initiated writes of IA32_MPERF, record the current TSC to
  establish a new baseline for background cycle accumulation
- Guest reads don't reach these handlers as they access the MSRs directly

Add both MSRs to msrs_to_save_base[] to ensure they are properly
serialized during vCPU state save/restore operations.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cd1f1ae86f83f..4394ecb291401 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -334,6 +334,7 @@ static const u32 msrs_to_save_base[] = {
 	MSR_IA32_UMWAIT_CONTROL,
 
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
+	MSR_IA32_APERF, MSR_IA32_MPERF,
 };
 
 static const u32 msrs_to_save_pmu[] = {
@@ -4151,6 +4152,26 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vcpu->arch.msr_misc_features_enables = data;
 		break;
+	case MSR_IA32_APERF:
+		if ((data || !msr_info->host_initiated) &&
+		    !guest_can_use(vcpu, X86_FEATURE_APERFMPERF))
+			return 1;
+
+		vcpu->arch.aperfmperf.guest_aperf = data;
+		if (unlikely(!msr_info->host_initiated))
+			set_guest_aperf(data);
+		break;
+	case MSR_IA32_MPERF:
+		if ((data || !msr_info->host_initiated) &&
+		    !guest_can_use(vcpu, X86_FEATURE_APERFMPERF))
+			return 1;
+
+		vcpu->arch.aperfmperf.guest_mperf = data;
+		if (likely(msr_info->host_initiated))
+			vcpu->arch.aperfmperf.host_tsc = rdtsc();
+		else
+			set_guest_mperf(data);
+		break;
 #ifdef CONFIG_X86_64
 	case MSR_IA32_XFD:
 		if (!msr_info->host_initiated &&
@@ -4524,6 +4545,22 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vcpu->arch.guest_fpu.xfd_err;
 		break;
 #endif
+	case MSR_IA32_APERF:
+		/* Guest read access should never reach here. */
+		if (!msr_info->host_initiated)
+			return 1;
+
+		msr_info->data = vcpu->arch.aperfmperf.guest_aperf;
+		break;
+	case MSR_IA32_MPERF:
+		/* Guest read access should never reach here. */
+		if (!msr_info->host_initiated)
+			return 1;
+
+		if (vcpu->arch.mp_state != KVM_MP_STATE_HALTED)
+			kvm_accumulate_background_guest_mperf(vcpu);
+		msr_info->data = vcpu->arch.aperfmperf.guest_mperf;
+		break;
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
@@ -7535,6 +7572,11 @@ static void kvm_probe_msr_to_save(u32 msr_index)
 		if (!(kvm_get_arch_capabilities() & ARCH_CAP_TSX_CTRL_MSR))
 			return;
 		break;
+	case MSR_IA32_APERF:
+	case MSR_IA32_MPERF:
+		if (!kvm_cpu_cap_has(KVM_X86_FEATURE_APERFMPERF))
+			return;
+		break;
 	default:
 		break;
 	}
-- 
2.47.0.371.ga323438b13-goog


