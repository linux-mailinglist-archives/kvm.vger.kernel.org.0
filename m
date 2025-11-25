Return-Path: <kvm+bounces-64512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF593C85BD7
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 16:20:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 414553A64EC
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 15:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D65327204;
	Tue, 25 Nov 2025 15:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f8ndho5k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C3E27F749
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 15:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764084026; cv=none; b=TtI2CW4cYS35L1jLb+PxWpEpObOjn78baAGEdEuC/+UKJM6Ev5hz9KmSTpXxP6zRFOQpe69ev92b8XwvZuevWjxl4ciyaH6Ko7pBcQDnQuH1WUWDb2231C4LiQjnSTXetuihKHok+IC0wGFOZhmIki4ETvx7TzEHAP8LNEshqzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764084026; c=relaxed/simple;
	bh=sI4HCKJda5b9d2psm9+q1j5lLfI2fqHAPPVmjjarW70=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MymZwbIqQw+n1iluQND5c4KZU3LVGt96yl7xW7pbShbz1w3XD2M4FbpF0LG1+1n3+KOo5j+3u0dxPur8xaAr7x+nwux5huZw2yptEySdpjDV+FuK0Rjn/R8kxVos0qvNUbSWiP1A2PUX4YsO9Z3zQNO339KdPxWJK37WzWfFslM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f8ndho5k; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-3d70c5bb455so1990245fac.1
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 07:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764084024; x=1764688824; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=en6Dg213KqRZYBQye7KKLPcwmXBy+WOvv0lS6QzCGzA=;
        b=f8ndho5kh/W5LS1xSr+8yc55c7bfNzVRDXt6Y+fwBLJrmPpnkX+WXqMO6mNEEmGMLD
         35zEqeOw9Z8F8WD3W/Pur/UzfsCwEv0mrChs2MQNZ0ofN8KLgBOuiYm2ycF2aGp0AcVd
         OOp9UCIYYk159kWGL7bpAlha3TtUogKDNoSSgEHkScof927s5X3fPXg0d7oUGa2oUbPB
         lDitDXwer+A5+anzpsRRYP3TNMOSpDDEEWRpAEf5XaV1dMz/pF+vqdao71UGJBJFBSIh
         q1qGjOnS05U6Kw4bKYy81JffvkEJAw6+5vd6jKUK4sWn/vZKlu/5LvzWHY6xsvyQuxRb
         w1qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764084024; x=1764688824;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=en6Dg213KqRZYBQye7KKLPcwmXBy+WOvv0lS6QzCGzA=;
        b=Lfn1NT4sUv9ZeO3sHeC9FJbh3cthPoNtMCEChQ3g9gA2SSRN4YdDQBwAO2WMHkOf7v
         HYvGZ7deDXI97q0u3iGAUVGLTGWLBI6gbruMsK5v+wGjn59vp7fJZ1LQ8BNN1p0g7axx
         kYvJN762Kyj5nx7WYEClEGUYQ1/cPP0s/cv5hKMEESS7VRhNxvNLme3OPYw/lRQJX3vB
         htYeFx1ZP8tk0VuOf/iyfXiw1YpgReKSe8YE26fY6TF2+aOvcuXJqoM5Q5h7JFr80W4N
         E83PVDb5AzQmraBeXgXgtOIAYHvftO7nCIBpd8K78RT66jNknRomH29ySmImhg9AUQ+L
         +1yQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXDD4RsQgd4KLK0KL/Snp8JWouHL2t0c9p4jMQpupdTuOmQpkYsN3Iod1dMVuMRfvQQXU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw4RZMcOlht9wwo6D4WjCwuN5r8rgJ/tT1E8hK8Dj+0ZvZxsyI
	yO8Gb516X3xGlbWOyF7SntsUkFQfLZ6oJeQR7MCeyYV8IBQLGtMIkIIc
X-Gm-Gg: ASbGncvLjw4RgYDzd/V2vSnhVk4Vff8Z2bpTOqgIl2CgEyFOwp7q3OnIzrI0JvNakoZ
	ka7tNT57TTQ+e0PUurv4BQxWJ+2ijtUK/CI/udX9Zury0YSFVPKAKVdfNCK83zUbodIPsW18Rud
	qm/zE/shcRDKDbQFVHToh9Dk4DZUE+eg5XL1KVMeB7KUnM+7OfnuqgFVPY7YYvj2q4jVHmq04s4
	UYwh4e/gv5Ib5uMa+XkIOHjwcwSG+O20HEnCYT7YSniRko1phkxnA131nyOKoz7l7TU70OsfAtF
	W8l0EhKuHYP/hapqJlmmdfDUIHUYUJc+qpis1JfPvxa/dcjwhMykbzEqkAAZDlHOstDirwIHZ6p
	JId/m/8mlkQHsE6/MCuJoZEi+/DUloqcrgeoVVFPSwt1aY89yxvqy5Dhoy77hQtF9N0nJ6dljiv
	cq0LWZjXnIYlV7bM32ykEm
X-Google-Smtp-Source: AGHT+IGoWKfbvem5paqLoEc9h9aY1mi6gDphs+AhjWenTqHAx53j0KtFb4aSEieGekn4PkjUmdlu7g==
X-Received: by 2002:a05:6808:1982:b0:450:92f9:1ba1 with SMTP id 5614622812f47-45112d9402cmr6741949b6e.67.1764084024071;
        Tue, 25 Nov 2025 07:20:24 -0800 (PST)
Received: from SyzRHEL1.fyre.ibm.com ([170.225.223.18])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65782a6de78sm4239085eaf.8.2025.11.25.07.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 07:20:23 -0800 (PST)
From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com
Cc: bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Subject: [PATCH] KVM: x86: Fix potential NULL dereference in amd_pmu_refresh()
Date: Tue, 25 Nov 2025 07:20:13 -0800
Message-ID: <20251125152013.433803-1-chelsyratnawat2001@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_find_cpuid_entry_index() can return NULL if the guest CPUID
entry is missing, but amd_pmu_refresh() was dereferencing the pointer
without checking. This could cause a kernel crash.

Add a NULL check and fallback to AMD64_NUM_COUNTERS_CORE if the
entry is missing.

Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
---
 arch/x86/kvm/svm/pmu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index bc062285fbf5..aa8313fa98c9 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -178,6 +178,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	union cpuid_0x80000022_ebx ebx;
+	struct kvm_cpuid_entry2 *entry;
 
 	pmu->version = 1;
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_PERFMON_V2)) {
@@ -188,8 +189,13 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 		 */
 		BUILD_BUG_ON(x86_feature_cpuid(X86_FEATURE_PERFMON_V2).function != 0x80000022 ||
 			     x86_feature_cpuid(X86_FEATURE_PERFMON_V2).index);
-		ebx.full = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0)->ebx;
-		pmu->nr_arch_gp_counters = ebx.split.num_core_pmc;
+		entry = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0);
+		if (!entry) {
+			pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;
+		} else {
+			ebx.full = entry->ebx;
+			pmu->nr_arch_gp_counters = ebx.split.num_core_pmc;
+		}
 	} else if (guest_cpu_cap_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;
 	} else {
-- 
2.47.3


