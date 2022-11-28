Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B128963AD73
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 17:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbiK1QPl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 11:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232681AbiK1QPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 11:15:16 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8A124BDC
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 08:15:08 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id j12so10617143plj.5
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 08:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F1jSlqGdECL73YnDzNqagg9psRJkFm1roQJKa2djZKM=;
        b=L6a6o+4S9rBnv86Payvu0dzLCpF3lYvbi9NgJKV1CXCbWK/dyxbBu12WF2ZSV1keFB
         Be5L4CQlc7zjqpjF6lzrgrLKhGpxAdOBzvySlGKafYVqSgKttpVsj1iLemVo1nzzntgN
         adrM1WO3AfzgiuPqku8d6jS/TcuLI6wFqlCiL2toC0f0oEceRHbBRVpTlDsES0hjt864
         fHMJji5dsKGR0hIfMjMzZqqaTDbprry/wE7FcXdxWIZLl63ov42CGsb46Ec2kk6xA0wh
         211lCV2nNEEp/sQsDC2VVRnSPgg4aUVEnoUBcPgJcRATQeaiDIrVZv2n+d5zzrYJVl9H
         Qi/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F1jSlqGdECL73YnDzNqagg9psRJkFm1roQJKa2djZKM=;
        b=RtEIznJDvMiRiZn919cwfZp6EpY0u1ixuHOQ6SZnxrtpeOUCuIB+RhCTFq5LhqUip8
         QCqKtFg2/3PtnSY/6eoqRTSxKz18OdUJtGcFAbIq1+ZT0fUuu/k/Ctj5GBiaeNDkiq22
         zY/UYYo81YMwDnPlqBTA7dm60N0GdeSyo+k3phEpHoN8uijwBmHOnKFN7S6M27tOwZCY
         rQDxBEFUHbq/4AyCiDhB6/SrR8QpUDETV4IZmDwLs0kR5xEWlfbmFNM/aqdcpCI1ctb3
         7DoCdUHU1zABc5v3ai4krd7C/PyLP0GF86JeahQtza9Pc9TA+e1hqhe596M/avqtTUdN
         /84g==
X-Gm-Message-State: ANoB5pkF5cpIGZuyDFMQjKXPjnV1q7AWceOrJEKWv979Y9Iig6I1rAb3
        l7ueb+0XEx+vgEHo21yEX8X3zA==
X-Google-Smtp-Source: AA0mqf44Bf/aZc5leADbIBCjjLqyV0qnD7yKtTFR/swOhVKlth1mxLaJYewfn3xuWt7GGhaAU1AJZg==
X-Received: by 2002:a17:90a:5801:b0:218:90b5:d1f2 with SMTP id h1-20020a17090a580100b0021890b5d1f2mr46721362pji.142.1669652108111;
        Mon, 28 Nov 2022 08:15:08 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([171.76.85.0])
        by smtp.gmail.com with ESMTPSA id k145-20020a628497000000b0056246403534sm8210805pfd.88.2022.11.28.08.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 08:15:07 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 8/9] RISC-V: KVM: Add ONE_REG interface for mvendorid, marchid, and mimpid
Date:   Mon, 28 Nov 2022 21:44:23 +0530
Message-Id: <20221128161424.608889-9-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221128161424.608889-1-apatel@ventanamicro.com>
References: <20221128161424.608889-1-apatel@ventanamicro.com>
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

We add ONE_REG interface for VCPU mvendorid, marchid, and mimpid
so that KVM user-space can change this details to support migration
across heterogeneous hosts.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/uapi/asm/kvm.h |  3 +++
 arch/riscv/kvm/vcpu.c             | 27 +++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 8985ff234c01..92af6f3f057c 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -49,6 +49,9 @@ struct kvm_sregs {
 struct kvm_riscv_config {
 	unsigned long isa;
 	unsigned long zicbom_block_size;
+	unsigned long mvendorid;
+	unsigned long marchid;
+	unsigned long mimpid;
 };
 
 /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 312a8a926867..7c08567097f0 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -276,6 +276,15 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 		reg_val = riscv_cbom_block_size;
 		break;
+	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
+		reg_val = vcpu->arch.mvendorid;
+		break;
+	case KVM_REG_RISCV_CONFIG_REG(marchid):
+		reg_val = vcpu->arch.marchid;
+		break;
+	case KVM_REG_RISCV_CONFIG_REG(mimpid):
+		reg_val = vcpu->arch.mimpid;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -338,6 +347,24 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
 		return -EOPNOTSUPP;
+	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
+		if (!vcpu->arch.ran_atleast_once)
+			vcpu->arch.mvendorid = reg_val;
+		else
+			return -EBUSY;
+		break;
+	case KVM_REG_RISCV_CONFIG_REG(marchid):
+		if (!vcpu->arch.ran_atleast_once)
+			vcpu->arch.marchid = reg_val;
+		else
+			return -EBUSY;
+		break;
+	case KVM_REG_RISCV_CONFIG_REG(mimpid):
+		if (!vcpu->arch.ran_atleast_once)
+			vcpu->arch.mimpid = reg_val;
+		else
+			return -EBUSY;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.34.1

