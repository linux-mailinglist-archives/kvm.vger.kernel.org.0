Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFF167B43D
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 15:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbjAYOXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 09:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234742AbjAYOXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 09:23:14 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648715976E
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:22:39 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id be8so5119498plb.7
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ygAltSAzjcTzQzob9WHeiImoKkO6d8yPGnZwCSBnOD0=;
        b=nVURTT3B2wHERxfqwlBVCOc2+IBuRDAPVjeILDQPCQTW7e/QB4UP3y5HqYQ5YMxkNW
         nHdpnyZeID8ofnHxw1uBiK4cO5GXNAvmGu9f4XtHJPvvWI6a1RgZAfbxXTGJkQL6v7Zj
         PBVLlK1BbipdoGSRQynPZSZie0S/UtuI27e+BBtGOUgzyCZo/hDJaXXfsAmr+rfqGh3N
         EvMX8doXZ31nYMrfbMgP0dWbQVsytAaovBIiboLNkSr5yY+GQd/Qtu/n1Q/4cE1K88yk
         6DUVfwPVfbS3ALbsHVg8c+JRBnRTIjLSmvvkxrwFpKy+g9TBsOVDdrnZL1ZnlIqRn+iF
         sPXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ygAltSAzjcTzQzob9WHeiImoKkO6d8yPGnZwCSBnOD0=;
        b=mr6fJeW54tJDrUE6Imnmouxd8AnaRXc22aYTU83nBSfnw05EB/sGWehkTTpLUvrUMX
         CN6JLWowXC/VdHkESBbWYZAVpDguuw0/PpahxffY5Q5ZmTwEm9lOTkqX6i2QV+PNoMp8
         Af0W6m1TFcIEnpxIf9dQQ6SNyTeVNbG0I2ftu6ul7se96ONSxeDjaMP6AhMLz8MBbjU5
         Td4QdHCneLzQCIerG2E7saDVZ+tJ78TNmceT6D3EJkjEanK8EAmbIdz4KniyqBn1AwO9
         oZrDd0KMAfAvjnKuKDJxxbmzue8hOfyzXSYq/Y9yvh5dHXZWVQAbLlLzGGFE19UaHUUg
         JneQ==
X-Gm-Message-State: AFqh2kphMr6qFmRi1Q0JORbnyQodV7HAWBwYDfks6Mr3MzDnLM8XLS+b
        qQkjgeUcLJVttCk9wcUVWuWffA==
X-Google-Smtp-Source: AMrXdXtC5AvDTqpA7Ocpig2XQZRfE1nIdra66UQn8nW9ojTwzxqd4hLbKbmeaTIto4SHnPJxqQ2c7A==
X-Received: by 2002:a05:6a20:4295:b0:b8:9c66:cd64 with SMTP id o21-20020a056a20429500b000b89c66cd64mr42336929pzj.14.1674656558873;
        Wed, 25 Jan 2023 06:22:38 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id bu11-20020a63294b000000b004a3510effa5sm3203520pgb.65.2023.01.25.06.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:22:38 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v13 18/19] riscv: kvm: redirect illegal instruction traps to guests
Date:   Wed, 25 Jan 2023 14:20:55 +0000
Message-Id: <20230125142056.18356-19-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230125142056.18356-1-andy.chiu@sifive.com>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Running below m-mode, an illegal instruction trap where m-mode could not
handle would be redirected back to s-mode. However, kvm running in hs-mode
terminates the vs-mode software when it receive such exception code.
Instead, it should redirect the trap back to vs-mode, and let vs-mode trap
handler decide the next step.

Besides, hs-mode should run transparently to vs-mode. So terminating
guest OS breaks assumption for the kernel running in vs-mode.

We use first-use trap to enable Vector for user space processes. This
means that the user process running in u- or vu- mode will take an
illegal instruction trap for the first time using V. Then the s- or vs-
mode kernel would allocate V for the process. Thus, we must redirect the
trap back to vs-mode in order to get the first-use trap working for guest
OSes here.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 arch/riscv/kvm/vcpu_exit.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index c9f741ab26f5..2a02cb750892 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -162,6 +162,16 @@ void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
 	vcpu->arch.guest_context.sepc = csr_read(CSR_VSTVEC);
 }
 
+static int vcpu_trap_redirect_vs(struct kvm_vcpu *vcpu,
+				 struct kvm_cpu_trap *trap)
+{
+	/* set up trap handler and trap info when it gets back to vs */
+	kvm_riscv_vcpu_trap_redirect(vcpu, trap);
+	/* return to s-mode by setting vcpu's SPP */
+	vcpu->arch.guest_context.sstatus |= SR_SPP;
+	return 1;
+}
+
 /*
  * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
  * proper exit to userspace.
@@ -179,6 +189,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	ret = -EFAULT;
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	switch (trap->scause) {
+	case EXC_INST_ILLEGAL:
+		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
+			ret = vcpu_trap_redirect_vs(vcpu, trap);
+		break;
 	case EXC_VIRTUAL_INST_FAULT:
 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
 			ret = kvm_riscv_vcpu_virtual_insn(vcpu, run, trap);
@@ -206,6 +220,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			vcpu->arch.guest_context.hstatus);
 		kvm_err("SCAUSE=0x%lx STVAL=0x%lx HTVAL=0x%lx HTINST=0x%lx\n",
 			trap->scause, trap->stval, trap->htval, trap->htinst);
+		asm volatile ("ebreak\n\t");
 	}
 
 	return ret;
-- 
2.17.1

