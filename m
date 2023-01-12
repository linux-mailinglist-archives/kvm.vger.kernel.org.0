Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C7566743B
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 15:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbjALOEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 09:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234751AbjALODn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 09:03:43 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6D6532AD
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 06:03:40 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id z1-20020a17090a66c100b00226f05b9595so5866295pjl.0
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 06:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=41mwjRtAV9Ps8+RICLlcEu1Jp8E7xzwVnsOTMb697U8=;
        b=Cx9wgXiG3yGJIP13AxtRLpEyPm0oHQsEnGUEH13SkW0zvi6xNemz4LlDlYS9AOoc6E
         3CHh1eoF1q5fDipXLRzUd5Ecg06hisNoF/bGEbx5ujjl5KvD1iOskHMzb/dkc63SsYQy
         H5mzf4RXtvetFCoBGo/S/MSYHSTLohsQ7hvwjGUGq37fBrZZlw+bEyB9p5P6s4s1lxa4
         uyXKOhwk5Y5EVjbGWtYFn5aNcpmNCQG1BOL2WjHYGCW43O32Pv4blj6GahAXGHgQwKGR
         6w0BzQUpAycWFRh1dU5nk3k6mkW0qLJkvte40xai5RWIQi1R81H+MT6k9LUmDVe3gvdF
         8k9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=41mwjRtAV9Ps8+RICLlcEu1Jp8E7xzwVnsOTMb697U8=;
        b=J5dPV8sFM5IapkpRO5AVvq/LqUIg0goMd/5L/ruggT9RJf/ip77P6SW9iBor1fc6Af
         gktPWs4vpsIDUx/S6aE9Axly3ZAw6Tt86CwniKoJ3UgSCYKaHC/buqqvhjMoi6m5lnb8
         U4wNhbLrgJdq1I9jSyV8r8+xq3haRtLxHTVpBgh9j2xjhetDvEjHWQ621MTVs6Z6xKOh
         wYpyFYdO4x8Al2zViR1N7D7jHYejABoWVF4WiIEh/UBA4QVRNr9kmI87/pM7FVwfrpMh
         ZNsIYk3ynXR6jbNUw2kYbzv1do11dSIZVoauFARdRIwv1Q0XWA/k93Ry+shVKX4lceOL
         Lr3w==
X-Gm-Message-State: AFqh2kp+6/7Ryz0tBPueXjgLSSiZpEy8pkZnhsGG+IOr3bFQF6PAG/Mh
        D4FjhodWrb7iCeD6F1JHRpjdcQ==
X-Google-Smtp-Source: AMrXdXuoqF9O/2Eth/euiEsYL9iZeQ5f5ihqzpJRnRU6lFfvKPaGgzYrAJ6y+uWOnFZ67on7TXRK/g==
X-Received: by 2002:a17:902:8543:b0:192:9454:7b32 with SMTP id d3-20020a170902854300b0019294547b32mr48252741plo.40.1673532219874;
        Thu, 12 Jan 2023 06:03:39 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902cecb00b001925016e34bsm12351455plg.79.2023.01.12.06.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 06:03:39 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 3/7] RISC-V: KVM: Drop the _MASK suffix from hgatp.VMID mask defines
Date:   Thu, 12 Jan 2023 19:33:00 +0530
Message-Id: <20230112140304.1830648-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112140304.1830648-1-apatel@ventanamicro.com>
References: <20230112140304.1830648-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The hgatp.VMID mask defines are used before shifting when extracting
VMID value from hgatp CSR value so based on the convention followed
in the other parts of asm/csr.h, the hgatp.VMID mask defines should
not have a _MASK suffix.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/csr.h | 8 ++++----
 arch/riscv/kvm/mmu.c         | 3 +--
 arch/riscv/kvm/vmid.c        | 4 ++--
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index d608dac4b19f..36d580528f90 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -131,12 +131,12 @@
 
 #define HGATP32_MODE_SHIFT	31
 #define HGATP32_VMID_SHIFT	22
-#define HGATP32_VMID_MASK	_AC(0x1FC00000, UL)
+#define HGATP32_VMID		_AC(0x1FC00000, UL)
 #define HGATP32_PPN		_AC(0x003FFFFF, UL)
 
 #define HGATP64_MODE_SHIFT	60
 #define HGATP64_VMID_SHIFT	44
-#define HGATP64_VMID_MASK	_AC(0x03FFF00000000000, UL)
+#define HGATP64_VMID		_AC(0x03FFF00000000000, UL)
 #define HGATP64_PPN		_AC(0x00000FFFFFFFFFFF, UL)
 
 #define HGATP_PAGE_SHIFT	12
@@ -144,12 +144,12 @@
 #ifdef CONFIG_64BIT
 #define HGATP_PPN		HGATP64_PPN
 #define HGATP_VMID_SHIFT	HGATP64_VMID_SHIFT
-#define HGATP_VMID_MASK		HGATP64_VMID_MASK
+#define HGATP_VMID		HGATP64_VMID
 #define HGATP_MODE_SHIFT	HGATP64_MODE_SHIFT
 #else
 #define HGATP_PPN		HGATP32_PPN
 #define HGATP_VMID_SHIFT	HGATP32_VMID_SHIFT
-#define HGATP_VMID_MASK		HGATP32_VMID_MASK
+#define HGATP_VMID		HGATP32_VMID
 #define HGATP_MODE_SHIFT	HGATP32_MODE_SHIFT
 #endif
 
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 34b57e0be2ef..034746638fa6 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -748,8 +748,7 @@ void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu)
 	unsigned long hgatp = gstage_mode;
 	struct kvm_arch *k = &vcpu->kvm->arch;
 
-	hgatp |= (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) &
-		 HGATP_VMID_MASK;
+	hgatp |= (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) & HGATP_VMID;
 	hgatp |= (k->pgd_phys >> PAGE_SHIFT) & HGATP_PPN;
 
 	csr_write(CSR_HGATP, hgatp);
diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index 6cd93995fb65..6f4d4979a759 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -26,9 +26,9 @@ void kvm_riscv_gstage_vmid_detect(void)
 
 	/* Figure-out number of VMID bits in HW */
 	old = csr_read(CSR_HGATP);
-	csr_write(CSR_HGATP, old | HGATP_VMID_MASK);
+	csr_write(CSR_HGATP, old | HGATP_VMID);
 	vmid_bits = csr_read(CSR_HGATP);
-	vmid_bits = (vmid_bits & HGATP_VMID_MASK) >> HGATP_VMID_SHIFT;
+	vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
 	vmid_bits = fls_long(vmid_bits);
 	csr_write(CSR_HGATP, old);
 
-- 
2.34.1

