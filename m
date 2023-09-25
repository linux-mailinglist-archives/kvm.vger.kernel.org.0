Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D137E7AD95A
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 15:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbjIYNkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 09:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbjIYNkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 09:40:00 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF858192
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 06:39:53 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1c44c0f9138so44150855ad.2
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 06:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1695649193; x=1696253993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aiGfuZzpdgt2mtsTil9OGkblf0k2xd+WLhVWfEwORCk=;
        b=Mtu8skHnKMZ1tDeS8xWQ+k9fraQqEy15mdC4zQ0Me5H0qxj7R501Jk2vzha461+grv
         ILXGp1b3QGaI6oEAngel0mv79laEExmctmmY9C6SJU3LSIk3MXv7PvBiGyucD49PFPyC
         eMUQBgN0XoYp1oAc4OfTsvNX7OLvvJ3DNPgRgy+2nZ7UG2/s3bsK21G8CMwZ32U2nkTC
         LkVs0KGwdibQFB/k6uFrPr8IHK9G3i32+SEkOcU1d5/a6l2XVW4YpkJTvvMMSIJM4aOT
         UpjPO9EhtROsZD7eaM21Xmsv88kmCYkVWRzrXvnowBo3XabRKldn/isyE/lIZ6fu6zFm
         3IuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695649193; x=1696253993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aiGfuZzpdgt2mtsTil9OGkblf0k2xd+WLhVWfEwORCk=;
        b=gN2q8Pseht9iFOIaEY2c1LdR5PU3tg3qJsstf6/8zICGvrHuz4+emgliPhuS1xmCVf
         ACZlAXZx6z+eOumNIGm8zmqvwGCS7TRTejYi4uPWpI8QKSyL5dhiMkG7X+6/V2DDX8JD
         bShz6tWcSAoHtwfC5IaZ9e5kyO8FiDDWER3ytFEwRc+Six0RbjlPjVFOO9KhXtXbqj6H
         h+Mduqo6RboGgV7gCFspeRNIcwSJkobpvtrjcsGBetUBi4nEHbVYUN6qSNaPDU8zARL9
         h2FvILGqkVVyuJ6ikdSp2jSZQOEN1eNmeKeVBPe1fjTUySQ3F5xRcvcnwM/10sESnRC9
         1z2Q==
X-Gm-Message-State: AOJu0YxCl5fXPwnEYYwnd59SmGduvizl1vs4Ia4avvWdfOr031O7V/88
        UFhri2id5p5ievf3mDoFgdPtzw==
X-Google-Smtp-Source: AGHT+IFAFl3LL8p0HXHNpJm36GoHz0drDmeIuMdA9JnKQikzt531c8bL68ncefHeUvtNOSQlgomJjg==
X-Received: by 2002:a17:903:24c:b0:1bf:6ad7:2286 with SMTP id j12-20020a170903024c00b001bf6ad72286mr6241708plh.43.1695649193249;
        Mon, 25 Sep 2023 06:39:53 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id p11-20020a170902eacb00b001c625d6ffccsm969433pld.129.2023.09.25.06.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 06:39:52 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Conor Dooley <conor@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shuah Khan <shuah@kernel.org>
Cc:     Andrew Jones <ajones@ventanamicro.com>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        devicetree@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 6/9] RISC-V: KVM: Allow Zicond extension for Guest/VM
Date:   Mon, 25 Sep 2023 19:08:56 +0530
Message-Id: <20230925133859.1735879-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230925133859.1735879-1-apatel@ventanamicro.com>
References: <20230925133859.1735879-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We extend the KVM ISA extension ONE_REG interface to allow KVM
user space to detect and enable Zicond extension for Guest/VM.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu_onereg.c      | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index e030c12c7dfc..35ceb38a4eff 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -139,6 +139,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZIHPM,
 	KVM_RISCV_ISA_EXT_SMSTATEEN,
 	KVM_RISCV_ISA_EXT_XVENTANACONDOPS,
+	KVM_RISCV_ISA_EXT_ZICOND,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 17a847a1114b..d3ca4969c985 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -47,6 +47,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(ZICBOM),
 	KVM_ISA_EXT_ARR(ZICBOZ),
 	KVM_ISA_EXT_ARR(ZICNTR),
+	KVM_ISA_EXT_ARR(ZICOND),
 	KVM_ISA_EXT_ARR(ZICSR),
 	KVM_ISA_EXT_ARR(ZIFENCEI),
 	KVM_ISA_EXT_ARR(ZIHINTPAUSE),
@@ -95,6 +96,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_ZBB:
 	case KVM_RISCV_ISA_EXT_ZBS:
 	case KVM_RISCV_ISA_EXT_ZICNTR:
+	case KVM_RISCV_ISA_EXT_ZICOND:
 	case KVM_RISCV_ISA_EXT_ZICSR:
 	case KVM_RISCV_ISA_EXT_ZIFENCEI:
 	case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
-- 
2.34.1

