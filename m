Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B06D4EA884
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 09:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiC2HbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 03:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbiC2HbR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 03:31:17 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525D515A22
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 00:29:32 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n18so16854509plg.5
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 00:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ppNdA/FhRD9g5++0K+Ya9WXyfU57mPy49sftAdzbp8w=;
        b=gcxsu0qkGm5afdR5CecI5Kj8Oz6i3fcQWabAOBtFVeKspQqMZnaPQbPXsIka/7QqWP
         9OQkwOZjEs6rHriQ+9z/OPi20q/Ls2Pux0FjbNwIgCvCXXYtnsgC8xiERCIKs3aauJZq
         2SkeykXVA4WYN1kV0ltpa77beaHtqiG9ZyqBK7s8kixX9iZxBVWaN9lKrwl2GqZmtUiU
         PjadOpN8iLSAn/qFU3U+L3zUGR+Q1cix9aqfgtreFrCpzQbxt772CqygJoxK1ysRSwVr
         h1bYIcV2FfMvpzAAkgIhlfwE/JWw3yyDlBi1bjfO7AdG8Ajtx8PEIbh/4N7Bjshf2yVa
         pheg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ppNdA/FhRD9g5++0K+Ya9WXyfU57mPy49sftAdzbp8w=;
        b=ugV437k2SOX7WhwAYhEhmqq6Att1YURoG51NXxiPvPQKma58rqxZRAL8jxHdveFmxN
         WfpJwyVrhmfs9SWDOG+an0MKaeAcxFQ+m8wI5Rp4LXva04D7hcbiQM9+X67Yw84xFKuM
         p86IgZew3/F9TaBe7JQcq+hnE4kxSsIpnbBlcm5RLmPlHZP3OItfVGXPedYZLQMyv5Df
         2iwavwglkK3M8vj/CU+6/T7dLmX3sMnpPnEkQ2FAiTQtsZNGVKao1kK/EO+pHeK/aOOT
         zMBX4kJl5e5nOU2hEvSvYxTzTZGGY5RH/Givgl9kDh7nNw7R4OmBBkmPCA2LHqCbbbjz
         zZNw==
X-Gm-Message-State: AOAM530/ToJlMOQd1MeTITfV+2C8D0KvMIeF5Dr/nQrw5pZ9Hdgt+RF2
        gminKyhPHR7KrhQ6x1ZEjz4L1w==
X-Google-Smtp-Source: ABdhPJy2ncza1YsBMMpe2gT2oc1Mdzb1vOn0BTJCkEqLNqVWhS3Cu0hZ6v8Sf5pye4QquhPixMb92w==
X-Received: by 2002:a17:90b:4b83:b0:1c9:6d37:38b7 with SMTP id lr3-20020a17090b4b8300b001c96d3738b7mr3124696pjb.21.1648538972341;
        Tue, 29 Mar 2022 00:29:32 -0700 (PDT)
Received: from localhost.localdomain ([122.171.166.231])
        by smtp.gmail.com with ESMTPSA id z6-20020a056a00240600b004e17ab23340sm19440564pfh.177.2022.03.29.00.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 00:29:31 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 1/3] KVM: selftests: riscv: Set PTE A and D bits in VS-stage page table
Date:   Tue, 29 Mar 2022 12:59:09 +0530
Message-Id: <20220329072911.1692766-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220329072911.1692766-1-apatel@ventanamicro.com>
References: <20220329072911.1692766-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Supporting hardware updates of PTE A and D bits is optional for any
RISC-V implementation so current software strategy is to always set
these bits in both G-stage (hypervisor) and VS-stage (guest kernel).

If PTE A and D bits are not set by software (hypervisor or guest)
then RISC-V implementations not supporting hardware updates of these
bits will cause traps even for perfectly valid PTEs.

Based on above explanation, the VS-stage page table created by various
KVM selftest applications is not correct because PTE A and D bits are
not set. This patch fixes VS-stage page table programming of PTE A and
D bits for KVM selftests.

Fixes: 3e06cdf10520 ("KVM: selftests: Add initial support for RISC-V
64-bit")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 tools/testing/selftests/kvm/include/riscv/processor.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tools/testing/selftests/kvm/include/riscv/processor.h
index dc284c6bdbc3..eca5c622efd2 100644
--- a/tools/testing/selftests/kvm/include/riscv/processor.h
+++ b/tools/testing/selftests/kvm/include/riscv/processor.h
@@ -101,7 +101,9 @@ static inline void set_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id,
 #define PGTBL_PTE_WRITE_SHIFT			2
 #define PGTBL_PTE_READ_MASK			0x0000000000000002ULL
 #define PGTBL_PTE_READ_SHIFT			1
-#define PGTBL_PTE_PERM_MASK			(PGTBL_PTE_EXECUTE_MASK | \
+#define PGTBL_PTE_PERM_MASK			(PGTBL_PTE_ACCESSED_MASK | \
+						 PGTBL_PTE_DIRTY_MASK | \
+						 PGTBL_PTE_EXECUTE_MASK | \
 						 PGTBL_PTE_WRITE_MASK | \
 						 PGTBL_PTE_READ_MASK)
 #define PGTBL_PTE_VALID_MASK			0x0000000000000001ULL
-- 
2.25.1

