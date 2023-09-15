Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549047A18D3
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 10:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbjIOI3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 04:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbjIOI3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 04:29:38 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF54F2D58
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 01:27:23 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1c39a4f14bcso17101625ad.3
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 01:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1694766443; x=1695371243; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vCzI3E8aO188t/F32/cMXTqfHUINrJvH0Tp5qCpKPJc=;
        b=RnH9JHz283ZLJuYD7ZhBVFWdfOoi++hgmVADdJMIxV5KzeRtPWg/XZG7HdZcrEVy/f
         B6lRJK1W2bqTQ+GkbXUq7vYOjMpbQg7v1z28MORLOuD1aySToktuGpTNC5G2u7hIfk4R
         0Qv+D0HUuz7T3+cba1wm/SSb0oB6SUm9KCP00C5MAzxbWEkMNXuRiG1HzTeq34mltysg
         A99HEHQZqfoau7pvL7et5jdj7aCpzkBQpUm73B7VYJjIh/5jA0Sihc7qKYpNip4mDP6Z
         7pdcden5gWRB7lq4V6ZW8q5li4rU11VMIM5t3y/yxRekXQ2dEASmsaov0fVG8h69gbLE
         ydtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694766443; x=1695371243;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vCzI3E8aO188t/F32/cMXTqfHUINrJvH0Tp5qCpKPJc=;
        b=knWiqs+z5dBnJVPOq3P/wgUIW6cg1B71+ac9Nq5j1d7pp1FZwSO/cNascYDnCl0zOr
         wUmSO382gbFQDjYujpw9hwWQdTXAh4a6Kp8iPcu6+Ppq5Z7/bzgffZgn/2EhUiz8vuTG
         OBVisHjyTC6i/JOHvQBtkTlEZ8v0ftSdHIjtpmSD4UKWti5POr5Q+7fy4PA3D3gpTMNt
         aDJ57zcYaBsOzHxDTMcybavsNSHF68+ABQ0crq7fS7dOBqCuySR+5+Ue8PCz0fpPcmlE
         T5scOnr/SnAx962hJAQgB9pP6vqMhkyZvMV/CeJyqP0hpK0sCyBUsLVzkgBGmdeIZ9FJ
         uJhw==
X-Gm-Message-State: AOJu0YyN5b6EgOdhrJCDXa03d/v6PVV2EawGDevdXCDqwuzJZUzdIrFx
        E2LkXhjbP2TNUhJ321WHCGzxLQ==
X-Google-Smtp-Source: AGHT+IH1wq43BqO+fEUmA+uIVRiNalmd9lYZ4iknzz4/CvLaHWfCEV+kAVOQ50zw87BzU2Q8qcJyUg==
X-Received: by 2002:a17:902:6848:b0:1c0:e091:6a08 with SMTP id f8-20020a170902684800b001c0e0916a08mr847355pln.69.1694766443167;
        Fri, 15 Sep 2023 01:27:23 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id f4-20020a170902ab8400b001c0af36dd64sm2912806plr.162.2023.09.15.01.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 01:27:22 -0700 (PDT)
From:   Yong-Xuan Wang <yongxuan.wang@sifive.com>
To:     linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org
Cc:     greentime.hu@sifive.com, vincent.chen@sifive.com, tjytimi@163.com,
        alex@ghiti.fr, Yong-Xuan Wang <yongxuan.wang@sifive.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] RISC-V: KVM: Add Svadu Extension Support for Guest/VM
Date:   Fri, 15 Sep 2023 08:26:58 +0000
Message-Id: <20230915082701.3643-3-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230915082701.3643-1-yongxuan.wang@sifive.com>
References: <20230915082701.3643-1-yongxuan.wang@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We extend the KVM ISA extension ONE_REG interface to allow VMM
tools  to detect and enable Svadu extension for Guest/VM.

Also set the HADE bit in henvcfg CSR if Svadu extension is
available for Guest/VM.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu.c             | 3 +++
 arch/riscv/kvm/vcpu_onereg.c      | 1 +
 3 files changed, 5 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 992c5e407104..3c7a6c762d0f 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -131,6 +131,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZICSR,
 	KVM_RISCV_ISA_EXT_ZIFENCEI,
 	KVM_RISCV_ISA_EXT_ZIHPM,
+	KVM_RISCV_ISA_EXT_SVADU,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 82229db1ce73..91b92a1f4e33 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -487,6 +487,9 @@ static void kvm_riscv_vcpu_update_config(const unsigned long *isa)
 	if (riscv_isa_extension_available(isa, ZICBOZ))
 		henvcfg |= ENVCFG_CBZE;
 
+	if (riscv_isa_extension_available(isa, SVADU))
+		henvcfg |= ENVCFG_HADE;
+
 	csr_write(CSR_HENVCFG, henvcfg);
 #ifdef CONFIG_32BIT
 	csr_write(CSR_HENVCFGH, henvcfg >> 32);
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 1b7e9fa265cb..211915dad677 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -36,6 +36,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	/* Multi letter extensions (alphabetically sorted) */
 	KVM_ISA_EXT_ARR(SSAIA),
 	KVM_ISA_EXT_ARR(SSTC),
+	KVM_ISA_EXT_ARR(SVADU),
 	KVM_ISA_EXT_ARR(SVINVAL),
 	KVM_ISA_EXT_ARR(SVNAPOT),
 	KVM_ISA_EXT_ARR(SVPBMT),
-- 
2.17.1

