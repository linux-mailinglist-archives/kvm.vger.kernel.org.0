Return-Path: <kvm+bounces-9908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AA77867919
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:53:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D545B1F239A0
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:53:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDA2813B2B3;
	Mon, 26 Feb 2024 14:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aKsId2Gs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806A213B29C;
	Mon, 26 Feb 2024 14:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958227; cv=none; b=WhW7qYrt152b87Uhm6bH9eq1ohdSXmiQpv4/m8Umw4XvBidlSj+LMSKxnT3kofmEhmLcwEG5+nhDzp0uVj13aPhHwmSy52AzU3lrzZP7YYT+KciFSScoBcOi3OuHesQylMZbdmKL3Q4QqhFvr7GaL86oStuX7+Kt7sc9g5SLPVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958227; c=relaxed/simple;
	bh=8YaAHnt0AiEYAzbERIaHQQ44YFwc8NdXJM54PxTApI0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F724fmq7JWRFYvExTxOq6duP80Ue7zwK6VcKoF6CQcJzB8AD1949nEqV0bz/9R92p+TQu61KIXLAXi7V2GLCa5zRFI07hK/nBGUuxO0fRBb5mBECrXIWwiM7cKet9bAkc0c1KyRKK0hyxGNSSV6oxF9CkcBAVurkLYtg/jIxYRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aKsId2Gs; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6e54451edc6so10405b3a.1;
        Mon, 26 Feb 2024 06:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958224; x=1709563024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h+dxYsygiG51aGauEBa8dsdGiX2H9H8gIcL8GbhB21k=;
        b=aKsId2Gsr9e8pFkRotuG6bpVriIyAbkkoniIDKGk6P4tdW925U1noPGghJJPvezqC6
         PzWw8c6PbMfx+hIcLeDnMUFt/LyV2VZJyYze3wf4cADsTIpQyCztQeGzNPC41yUBKgz3
         N3cmOU0bynH6Ns6TGWmrfvcDug0kQXXKBHrqkFO+9XAwwRABo7p16zDfagk3+hDRayX9
         23ICBkMU6ZWu7o/Eeah6v7o5rOYg6lqGnpEKcrXZIdC0z9+V0zkT5yOHcWX3Mma8S4nM
         TZU3Oc1mKMI+mpI2ZkbAPs+zTE2QriQSsorkRD6Xs7vuNysCXGFTW/D8rzdRHbNVEu5k
         mJ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958224; x=1709563024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h+dxYsygiG51aGauEBa8dsdGiX2H9H8gIcL8GbhB21k=;
        b=ltoAzF2DVB4cq8GT/VPoTfIATdGKasPboATewXvrwsgtuDeyGajc7KH0z9/R/cZfpT
         LcT3Ck/G/fxRcXO0me/7mbzY8/vUHdrmQqrRrzf36C5PqtZeOFICE9vJ7C1qQK9aEOLI
         N02EVckT5li6dApDm+wxoFFvWapMOmeRvI8ICoEeeeQXOd+fUPgonamewK4IfBw8M9dV
         6cWp/ICZl4i6ugUPgqu8Q6KTYJ8sbOBjteBi2W5s2jCPZZI5r2bVhFhF+KbNg5CxRt36
         9rrX2iW/NeLLBcIP+BMa681F4A0P5g8J2kSQS0xd53aw1VssToh3zcSL5zlUbPgWss9u
         kHXg==
X-Forwarded-Encrypted: i=1; AJvYcCUJZRkTkIT+/t3ADKXd1f73WGwAFQDw47gbMulUwP5KvU3BTUzwtIl0fHVHu4oa2cjd/uIswvv7wbLlBNT9LocszM0Z
X-Gm-Message-State: AOJu0YyiNl4cCHDQxk8v3sx+QN0ELD5EWMYqpEw0xLw3xzfxwFw6rgrH
	aSFjFwDV7eMJVkZtpB5AJAm27Y32uoi1McrX83Onzs71Fa1KV//PCtNcZSHt
X-Google-Smtp-Source: AGHT+IF4OCEZJFmMPMviijl3yGOrjNcy7E8v6oBWvvHaH9EDSCrEI/ACp3ji29GenWVxL6k1nUVRJg==
X-Received: by 2002:a05:6a20:438f:b0:1a0:f096:5022 with SMTP id i15-20020a056a20438f00b001a0f0965022mr8595562pzl.46.1708958224431;
        Mon, 26 Feb 2024 06:37:04 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id p11-20020a170902eacb00b001d706e373a9sm4001330pld.292.2024.02.26.06.37.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:37:04 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 45/73] KVM: x86/PVM: Add dummy PMU related callbacks
Date: Mon, 26 Feb 2024 22:36:02 +0800
Message-Id: <20240226143630.33643-46-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Currently, PMU virtualization is not implemented, so dummy PMU related
callbacks are added to make PVM work. In the future, the existing code
in pmu_intel.c and pmu_amd.c will be reused to implement PMU
virtualization for PVM.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 72 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index f2cd1a1c199d..e6464095d40b 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -21,6 +21,7 @@
 #include "cpuid.h"
 #include "lapic.h"
 #include "mmu.h"
+#include "pmu.h"
 #include "trace.h"
 #include "x86.h"
 #include "pvm.h"
@@ -2701,6 +2702,76 @@ static void hardware_unsetup(void)
 {
 }
 
+//====== start of dummy pmu ===========
+//TODO: split kvm-pmu-intel.ko & kvm-pmu-amd.ko from kvm-intel.ko & kvm-amd.ko.
+static bool dummy_pmu_hw_event_available(struct kvm_pmc *pmc)
+{
+	return true;
+}
+
+static struct kvm_pmc *dummy_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
+{
+	return NULL;
+}
+
+static struct kvm_pmc *dummy_pmu_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
+						  unsigned int idx, u64 *mask)
+{
+	return NULL;
+}
+
+static bool dummy_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
+{
+	return false;
+}
+
+static struct kvm_pmc *dummy_pmu_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
+{
+	return NULL;
+}
+
+static bool dummy_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
+{
+	return 0;
+}
+
+static int dummy_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	return 1;
+}
+
+static int dummy_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	return 1;
+}
+
+static void dummy_pmu_refresh(struct kvm_vcpu *vcpu)
+{
+}
+
+static void dummy_pmu_init(struct kvm_vcpu *vcpu)
+{
+}
+
+static void dummy_pmu_reset(struct kvm_vcpu *vcpu)
+{
+}
+
+struct kvm_pmu_ops dummy_pmu_ops = {
+	.hw_event_available = dummy_pmu_hw_event_available,
+	.pmc_idx_to_pmc = dummy_pmc_idx_to_pmc,
+	.rdpmc_ecx_to_pmc = dummy_pmu_rdpmc_ecx_to_pmc,
+	.msr_idx_to_pmc = dummy_pmu_msr_idx_to_pmc,
+	.is_valid_rdpmc_ecx = dummy_pmu_is_valid_rdpmc_ecx,
+	.is_valid_msr = dummy_pmu_is_valid_msr,
+	.get_msr = dummy_pmu_get_msr,
+	.set_msr = dummy_pmu_set_msr,
+	.refresh = dummy_pmu_refresh,
+	.init = dummy_pmu_init,
+	.reset = dummy_pmu_reset,
+};
+//========== end of dummy pmu =============
+
 struct kvm_x86_nested_ops pvm_nested_ops = {};
 
 static struct kvm_x86_ops pvm_x86_ops __initdata = {
@@ -2811,6 +2882,7 @@ static struct kvm_x86_init_ops pvm_init_ops __initdata = {
 	.hardware_setup = hardware_setup,
 
 	.runtime_ops = &pvm_x86_ops,
+	.pmu_ops = &dummy_pmu_ops,
 };
 
 static void pvm_exit(void)
-- 
2.19.1.6.gb485710b


