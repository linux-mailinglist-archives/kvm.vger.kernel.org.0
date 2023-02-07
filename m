Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C728968D35B
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 10:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbjBGJ5B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 04:57:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjBGJ4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 04:56:38 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70283755B
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 01:56:35 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id v23so15123222plo.1
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 01:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=16iMGPpvEnuS3c0dPnPwj+7kUcc1R6qNdww8oitMdu0=;
        b=zHrBCSuS7vuO+wfhPSy2R5mWkU98Ej4EbPIAJYMtSwYNE30RsbPiI+ZFGYmu4Oh+eu
         77Q25J5zQOyPpTHhgUjRAyyI5bBkU6cFvu3C+0xrs9wbB92eXwLU8O8brG/hGDgX8OjH
         osDZX8HSyVZcMPP3MFU31U0bjQOA3PFMcEAaWiuoJL1aYSmLFsVKV+egZJgSSMqBFFA5
         VJhWU+0UmEyci/qbuEpkE38+5UXioseArWBvqUoJqDEgQOHi/Z7bOASwjcQayR/50chH
         952IJrB5nYxEuTSp8MH074s6vMkfHodrGe0rGpXr+aumBVb2SXStE+Cl5deQRecnJBDp
         XfAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=16iMGPpvEnuS3c0dPnPwj+7kUcc1R6qNdww8oitMdu0=;
        b=Jt6v99axVZassy2fRm6boghn7IJDc02d3ZNfkSSgsiU811Fd63bNE3R7Sm/zNyhZoK
         S9QrWx3sPMjyS+B9LHu2KCdVVI3QnhorkX0b5wwrFVsIvUyls2bhWOx+UclwpRLrcxwk
         zKOf4cNd6cjG1f3YcAwxouGY34hoJVG3hydnUpXneAbn7pCdXO5PfB4Af934HnfvV84J
         0xCv+ZQ+2PDCa4fnqMYutyDwtdkq8CP+WFrmJ3Y4zcVfJVUA/mo9Bs4EYC+YrhNAd639
         IMV+p0Mt1/Ml9/xUeA/mThqYkZrXSH/YiVyDZp05f4sClVXm1YZCbVuH7OLCuXcM79F5
         AWxQ==
X-Gm-Message-State: AO0yUKUsunsFr06Qm6cIRi+orlxRZxDPIWOVmsWqZ6bqt2tQJZPVttJ2
        xoH9b1zFNn6OGmonNZiAKlRFpFcASOPGbuCq
X-Google-Smtp-Source: AK7set+CURig+ktH3WlV7EnqzFklFbVOAZwjjFNFVrszT7hj2WkS9Lx/69A8CjK1ABaYaHx6Rftt6g==
X-Received: by 2002:a17:902:f2cc:b0:199:2932:6175 with SMTP id h12-20020a170902f2cc00b0019929326175mr1993161plc.20.1675763794923;
        Tue, 07 Feb 2023 01:56:34 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id w8-20020a1709027b8800b0019602b2c00csm4030598pll.175.2023.02.07.01.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 01:56:34 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Subject: [PATCH v6 8/8] RISC-V: KVM: Increment firmware pmu events
Date:   Tue,  7 Feb 2023 01:55:29 -0800
Message-Id: <20230207095529.1787260-9-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230207095529.1787260-1-atishp@rivosinc.com>
References: <20230207095529.1787260-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM supports firmware events now. Invoke the firmware event increment
function from appropriate places.

Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/tlb.c              | 4 ++++
 arch/riscv/kvm/vcpu_sbi_replace.c | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
index 309d79b..b797f7c 100644
--- a/arch/riscv/kvm/tlb.c
+++ b/arch/riscv/kvm/tlb.c
@@ -181,6 +181,7 @@ void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
 
 void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu)
 {
+	kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_FENCE_I_RCVD);
 	local_flush_icache_all();
 }
 
@@ -264,15 +265,18 @@ void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu)
 						d.addr, d.size, d.order);
 			break;
 		case KVM_RISCV_HFENCE_VVMA_ASID_GVA:
+			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
 			kvm_riscv_local_hfence_vvma_asid_gva(
 						READ_ONCE(v->vmid), d.asid,
 						d.addr, d.size, d.order);
 			break;
 		case KVM_RISCV_HFENCE_VVMA_ASID_ALL:
+			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
 			kvm_riscv_local_hfence_vvma_asid_all(
 						READ_ONCE(v->vmid), d.asid);
 			break;
 		case KVM_RISCV_HFENCE_VVMA_GVA:
+			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_RCVD);
 			kvm_riscv_local_hfence_vvma_gva(
 						READ_ONCE(v->vmid),
 						d.addr, d.size, d.order);
diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 38fa4c0..7c4d5d3 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -11,6 +11,7 @@
 #include <linux/kvm_host.h>
 #include <asm/sbi.h>
 #include <asm/kvm_vcpu_timer.h>
+#include <asm/kvm_vcpu_pmu.h>
 #include <asm/kvm_vcpu_sbi.h>
 
 static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
@@ -24,6 +25,7 @@ static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		return 0;
 	}
 
+	kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_SET_TIMER);
 #if __riscv_xlen == 32
 	next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
 #else
@@ -55,6 +57,7 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		return 0;
 	}
 
+	kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_IPI_SENT);
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
 		if (hbase != -1UL) {
 			if (tmp->vcpu_id < hbase)
@@ -65,6 +68,7 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		ret = kvm_riscv_vcpu_set_interrupt(tmp, IRQ_VS_SOFT);
 		if (ret < 0)
 			break;
+		kvm_riscv_vcpu_pmu_incr_fw(tmp, SBI_PMU_FW_IPI_RCVD);
 	}
 
 	return ret;
@@ -87,6 +91,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 	switch (funcid) {
 	case SBI_EXT_RFENCE_REMOTE_FENCE_I:
 		kvm_riscv_fence_i(vcpu->kvm, hbase, hmask);
+		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_FENCE_I_SENT);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
 		if (cp->a2 == 0 && cp->a3 == 0)
@@ -94,6 +99,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 		else
 			kvm_riscv_hfence_vvma_gva(vcpu->kvm, hbase, hmask,
 						  cp->a2, cp->a3, PAGE_SHIFT);
+		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_SENT);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
 		if (cp->a2 == 0 && cp->a3 == 0)
@@ -104,6 +110,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 						       hbase, hmask,
 						       cp->a2, cp->a3,
 						       PAGE_SHIFT, cp->a4);
+		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_SENT);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA:
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA_VMID:
-- 
2.25.1

