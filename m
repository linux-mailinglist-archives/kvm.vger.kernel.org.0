Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745FE7AAD48
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 10:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbjIVI5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 04:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbjIVI5d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 04:57:33 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9669198
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 01:57:27 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-274b45fa7a2so1275231a91.0
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 01:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1695373047; x=1695977847; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vCzI3E8aO188t/F32/cMXTqfHUINrJvH0Tp5qCpKPJc=;
        b=JDhVh2x3NxpylYsDhJdLsAp3CzW6s5mi8kQj6JB7hm7I5ZawlOyTd7dUlmAmoZHV+K
         6qc8hCZ3H+4u3PXDPXmTlkWHfaik3rQObfBRKNdcG8V/uKMWSFGNaToVEgVmipfamI4S
         XFgmFuAJ7JU7JLcXKHs++3Bhl9bAksT+bERZyI2r4XXYXGEfYTueh0zpfYqaSYnSdPOv
         Z5pRM0YMN58Zklgxyir/q9gsTWQRlBjjmw9Vh8hW7KgtXITMVyrlQK1RUgLVztog21z3
         MTpo7s+/i6NNzv4vZ7yZBrVipXYSr5W9CiTqV17vvX27a/Y/SMiadvQt89K57qihwGvY
         idRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695373047; x=1695977847;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vCzI3E8aO188t/F32/cMXTqfHUINrJvH0Tp5qCpKPJc=;
        b=o5/6AsYKh/rW2TotR7CbgygsrUYCfYwjiqn/BMgU6tzyCCBCJLQSRfHbeJ74Enlwby
         gptX57qyTWbtjdQPpnHxeoBCKF/YU8KTSGyrByGl+ckueZ0ifpZ3vsWS9DkfqDZdIz/f
         2GZSgG7i0hxTOHXZyEbF+A8YwVu+qmklG8JP3QxxR+xqyoMEXHgRQ5Vvp0iywVn2Svom
         0Lwuv3dTc9INQj8gFj3flVriz/C1tWuB5pxEkKak0SA48ypOgJWs0vIy/8e2aBrDn0DH
         FA0rUgMsBK1v+VQ3pndMZd4X92iGMYkros3MW4Yi37SQDstvm3v2THWKVECy9VulnsJi
         QWHA==
X-Gm-Message-State: AOJu0Yz5iGMVkNh926rBZjC5U36EmFHGotA9ao8YdI+qx/aHw1fgWc8X
        iLS3QlNT6WLrdF1dHhWc6qyOuw==
X-Google-Smtp-Source: AGHT+IGDUKE6sMJpErXb0g3YaZiHZpkET1mM+9eSCn6hTWCw/a2PztVDthPTlrRDuo5MMtmRLuJFaQ==
X-Received: by 2002:a17:90a:7066:b0:269:3cdb:4edf with SMTP id f93-20020a17090a706600b002693cdb4edfmr7843278pjk.16.1695373047171;
        Fri, 22 Sep 2023 01:57:27 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id t15-20020a17090a024f00b00256b67208b1sm4815024pje.56.2023.09.22.01.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 01:57:26 -0700 (PDT)
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
Subject: [PATCH v2 3/3] RISC-V: KVM: Add Svadu Extension Support for Guest/VM
Date:   Fri, 22 Sep 2023 08:56:49 +0000
Message-Id: <20230922085701.3164-4-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230922085701.3164-1-yongxuan.wang@sifive.com>
References: <20230922085701.3164-1-yongxuan.wang@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
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

