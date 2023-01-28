Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1926F67F58A
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 08:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbjA1H2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 02:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbjA1H2K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 02:28:10 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4B345F47
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 23:28:01 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id k18so7067575pll.5
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 23:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pw95MQk4sL9FSIPsY1+7zF6OQPrfNBcJ8svOzlGbLXs=;
        b=jL3raJ3xxkCRnYv7QuZHM+clZq2vwOYN9zGjV+DrEFaSk7H94B5Gov5D/0murmm0wW
         iUsqjmJ2BpC4mcz1mNEreyPaDCnl1ZbJRPpWDD4ZVBaIDh+k2L/aiCv8BEUifLGplPUE
         wVpOfiimSf9cHmFJSOpnoJnjb+mBV/io96We1ppknUXABkp5wsGm53pTNCI05XnFQtpd
         8C7mHdgEZ3daadVjTn9743dyaAkRjNtzOnrMndEDEmQYiL1r/Pe4vj6mRBrpc3WuiCbP
         nb8GQ62vOma3L+7OfT8B0dzI3BqZhrcHixOmpDdm8uZyp4dkeE5mOZkPEpdePfgTf3HW
         Ny7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pw95MQk4sL9FSIPsY1+7zF6OQPrfNBcJ8svOzlGbLXs=;
        b=NU9NmBNCc+SbTUYP+R13JNSdGQDVeye70JF29OJNVJcLOi7gmZCh8yj9DcTIYpc445
         RWuiAT8KErF3VqfIiJ28lUwRJ04KBC66xij56mz5I8hxt+IGYZ2fWcCBjMqPoTgu7wQa
         vOjDsDZf/eMyWDyM3n89QF9CfJbluLdf77uyKk25o2E58ugoQl9fzokZD0mxIiTa9T3L
         oEKcDvRDfYKj7UZ4dnrMXaifYs8pdqdetVnQiToC01D+VaHryABObv+mIzVbZGHbMJRI
         GiP5kiaDH/X81EXpeqR2VJZV4O/QbBfhLs2qmzlCRFycEfppXYihsX6SuICIlKPWJeU7
         gwIg==
X-Gm-Message-State: AFqh2koFiMQ6HGcUB8sI5pMeUY588AHFQNrG6OmnmkPlXIHf6AR/W4pm
        dq9GY3x+I9FIJsNRcHWB2vcvFv7Hrs/RB1O6
X-Google-Smtp-Source: AMrXdXtulo+lTOI8OKr7E2ZX8E5oNn2lC9UNaWbb3c7VwiNOKwdWw5VqDkQJ3LdBm8bmviaYWX2c0Q==
X-Received: by 2002:a17:902:f70e:b0:193:3845:de53 with SMTP id h14-20020a170902f70e00b001933845de53mr49205851plo.39.1674890881027;
        Fri, 27 Jan 2023 23:28:01 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id jh19-20020a170903329300b00194ac38bc86sm753132plb.131.2023.01.27.23.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 23:28:00 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 3/7] RISC-V: KVM: Drop the _MASK suffix from hgatp.VMID mask defines
Date:   Sat, 28 Jan 2023 12:57:33 +0530
Message-Id: <20230128072737.2995881-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230128072737.2995881-1-apatel@ventanamicro.com>
References: <20230128072737.2995881-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The hgatp.VMID mask defines are used before shifting when extracting
VMID value from hgatp CSR value so based on the convention followed
in the other parts of asm/csr.h, the hgatp.VMID mask defines should
not have a _MASK suffix.

While we are here, let's use GENMASK() for hgatp.VMID and hgatp.PPN.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/csr.h | 12 ++++++------
 arch/riscv/kvm/mmu.c         |  3 +--
 arch/riscv/kvm/vmid.c        |  4 ++--
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 3c8d68152bce..3176355cf4e9 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -131,25 +131,25 @@
 
 #define HGATP32_MODE_SHIFT	31
 #define HGATP32_VMID_SHIFT	22
-#define HGATP32_VMID_MASK	_AC(0x1FC00000, UL)
-#define HGATP32_PPN		_AC(0x003FFFFF, UL)
+#define HGATP32_VMID		GENMASK(28, 22)
+#define HGATP32_PPN		GENMASK(21, 0)
 
 #define HGATP64_MODE_SHIFT	60
 #define HGATP64_VMID_SHIFT	44
-#define HGATP64_VMID_MASK	_AC(0x03FFF00000000000, UL)
-#define HGATP64_PPN		_AC(0x00000FFFFFFFFFFF, UL)
+#define HGATP64_VMID		GENMASK(57, 44)
+#define HGATP64_PPN		GENMASK(43, 0)
 
 #define HGATP_PAGE_SHIFT	12
 
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
index dbc4ca060174..829a7065ae01 100644
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

