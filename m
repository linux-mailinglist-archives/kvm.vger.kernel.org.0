Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE4A67F64B
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 09:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbjA1I3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 03:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjA1I3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 03:29:00 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CF31A94C
        for <kvm@vger.kernel.org>; Sat, 28 Jan 2023 00:28:58 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id nn18-20020a17090b38d200b0022bfb584987so6804981pjb.2
        for <kvm@vger.kernel.org>; Sat, 28 Jan 2023 00:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vEMGTnRapKJbFGDqzXqULLCIpjEAFBsGqGounWes3mM=;
        b=CiUkIqEVNKU4zMoYEnIth2esN6DjwehosPZnvfdBNZaBVx+QIsqSnb3XvpVSzMgsdA
         7c72VuAIcEoOuRPCWuZ8j7yx+vYMh7cSh5FrQ2AbmPttlPlVBV2vedTUlTvi0RkA9j7Q
         046kTqEXm82CcyvN6KGlyjfQ7uWP8JzCIk57lJnYQ0Ac3BwUxo2xChEt9biru1mBy+Wx
         R4Otzlvp3tFec2XLKM6Rt2JfqIgBcBjKwAltFg60PoB2xeKyGxn5dvZFu79dcIlz68lR
         mufhx/r1w29hnGKk0bzPQn02jwh3RO794lXFoSOU8IkkOLHqexgFW8bn4TrYlykkmfII
         KvKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vEMGTnRapKJbFGDqzXqULLCIpjEAFBsGqGounWes3mM=;
        b=qQQLUvEpT2VBYJuFZvD+vAA86++36v/px/SZI9ni2QpcoIYT7b2opwQZggiK/nZ5PA
         eKrGIdxI7n++gWTz4fHOqggCKi69iHoiH7brLaDLZm1yNjh2sozxseVnW2PjgdnAF02F
         zCNqBqL4T8AmHwQ352fLQanYf2QnPFy56U3x2JZl58KqHUSrstD2kUgIqJXH5cJjAq4w
         cEf6jJUHs9155iC+tqTWfIO5Gn5u1YpHr+AD4vqffu6C16SJ4gti7N7sQmo1IfwA0Fo1
         jemH2epICRMqTaKOScw4+AuaMjjey3B6udRcOi6EhxqAVjClOQriT7vPHVjiq6T/WgjZ
         SIyA==
X-Gm-Message-State: AFqh2koOi9szLV35z6G2D6vkVpsh8WeA6S2gbmd9C0jmupw3QOizKtrF
        +naG/xAFDzR/BS1jGpKSKJubsA==
X-Google-Smtp-Source: AMrXdXufuuGP073H4Ffvdyu2Q6+4TGFlFg7nACE5QW5Se0OmVk2fD/f44o6Ry2CP/Ca95S5QsoROhA==
X-Received: by 2002:a05:6a21:339a:b0:b6:4270:6dfc with SMTP id yy26-20020a056a21339a00b000b642706dfcmr56156319pzb.6.1674894537513;
        Sat, 28 Jan 2023 00:28:57 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id i67-20020a639d46000000b004cc95c9bd97sm3477807pgd.35.2023.01.28.00.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 00:28:57 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v3 1/2] RISC-V: KVM: Fix privilege mode setting in kvm_riscv_vcpu_trap_redirect()
Date:   Sat, 28 Jan 2023 13:58:46 +0530
Message-Id: <20230128082847.3055316-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
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

The kvm_riscv_vcpu_trap_redirect() should set guest privilege mode
to supervisor mode because guest traps/interrupts are always handled
in virtual supervisor mode.

Fixes: 9f7013265112 ("RISC-V: KVM: Handle MMIO exits for VCPU")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_exit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index c9f741ab26f5..af7c4bc07929 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -160,6 +160,9 @@ void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
 
 	/* Set Guest PC to Guest exception vector */
 	vcpu->arch.guest_context.sepc = csr_read(CSR_VSTVEC);
+
+	/* Set Guest privilege mode to supervisor */
+	vcpu->arch.guest_context.sstatus |= SR_SPP;
 }
 
 /*
-- 
2.34.1

