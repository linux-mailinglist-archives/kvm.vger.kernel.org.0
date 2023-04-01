Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719D96D3037
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 13:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjDAL2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 07:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjDAL2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 07:28:07 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3FB25561
        for <kvm@vger.kernel.org>; Sat,  1 Apr 2023 04:27:50 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id d13so23124363pjh.0
        for <kvm@vger.kernel.org>; Sat, 01 Apr 2023 04:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680348462; x=1682940462;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V9h16YuAEUK1wvL2RNBHCcwpte7Y1FwWRsmABLjps+c=;
        b=PGIwXlXrzX91EGrukJM1qAYYCcMIfBb3wXtKHu6+fISpFF6RjKrQ20HM+dKW28CSkX
         iKmubwFsJtVjc82a3/yKsT7EJI6YSkEby9CR1Gu/wr5/xSQLvTCve1Df6Xk1DTqfyL3S
         q7EubEeoKYuNmwpXskbDU6gG4ohF+9a5SmUnR8zH1YXpCFEI4u/tBEivbogaFZvwvOL7
         4UY5jBvhaMx3l1VaZM+KeSLuVzCEIRwFpAdVKKoyNY6viYAmZNOzyyydDuuJds592QI5
         liA3f/uCd48q2H5oWJzBmjcpiYiTK8JH8C7Uq6N0ewf2yNUPWhM39VWhKmvgFSW6U+ju
         x1AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680348462; x=1682940462;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V9h16YuAEUK1wvL2RNBHCcwpte7Y1FwWRsmABLjps+c=;
        b=zdmsI6xci3wjapccQMylvuwjLo5+bmG3ChPomyxBas9x+MQB1vZSXnHatRcUyguMtM
         54ef9WeE2GY3i06tO4pVXszp/Nl5uhg1jajL/oti8Rk6SWyNWMTCwiWwNE9KcO5gvMK2
         QQSetGbqVG6VW+yVxP6+Hy4l5V9jZ4DYKdmBsh4n1yxciYwYml7+Dc/ZLOv7Rvd+leOn
         P10YO/lb6mS+U550ZYrNLBX8PE/H7SRU+2GRFG8jCCRa3KWiT4VuBDR977hzQM7wY/+0
         57eYMMlSVUbP9kPOBXxMsSckJYPUJCdA8jFDYh++mmrtSSVWL7eCx1nFgjI7mARVjtgK
         7vQQ==
X-Gm-Message-State: AO0yUKUJmqqWpbpIEbA8GoM3Lx9fnNm+j5gBQP+VT4wLe9eMR4hHIu1p
        SRz9GO5O/MfzGtvlPUDEEzi1vke2MehzzzKk5TI=
X-Google-Smtp-Source: AKy350Yb2xF/pvwiHbx7wPM935xs42zQ6oSDlOhbgGDoGjfTqsYizXN99mKtJQc8tkFQPxI9LxR9KA==
X-Received: by 2002:a17:90b:2243:b0:23f:7176:df32 with SMTP id hk3-20020a17090b224300b0023f7176df32mr32788883pjb.40.1680348462342;
        Sat, 01 Apr 2023 04:27:42 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id j8-20020a17090a738800b0023b4d4ca3a9sm2915991pjg.50.2023.04.01.04.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 04:27:41 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH] RISC-V: KVM: Allow Zbb extension for Guest/VM
Date:   Sat,  1 Apr 2023 16:57:30 +0530
Message-Id: <20230401112730.2105240-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We extend the KVM ISA extension ONE_REG interface to allow KVM
user space to detect and enable Zbb extension for Guest/VM.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu.c             | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index d8ead5952ed9..47a7c3958229 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -106,6 +106,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_SVINVAL,
 	KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
 	KVM_RISCV_ISA_EXT_ZICBOM,
+	KVM_RISCV_ISA_EXT_ZBB,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 3112697cb12d..02b49cb94561 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -61,6 +61,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(SSTC),
 	KVM_ISA_EXT_ARR(SVINVAL),
 	KVM_ISA_EXT_ARR(SVPBMT),
+	KVM_ISA_EXT_ARR(ZBB),
 	KVM_ISA_EXT_ARR(ZIHINTPAUSE),
 	KVM_ISA_EXT_ARR(ZICBOM),
 };
@@ -99,6 +100,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_SSTC:
 	case KVM_RISCV_ISA_EXT_SVINVAL:
 	case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
+	case KVM_RISCV_ISA_EXT_ZBB:
 		return false;
 	default:
 		break;
-- 
2.34.1

