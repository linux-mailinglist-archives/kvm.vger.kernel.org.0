Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2256E8499
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbjDSWTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbjDSWSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:18:31 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B92900F
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:18:12 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-63b62d2f729so351421b3a.1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942685; x=1684534685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ojiAvkB2QjgGX0WuePfTk5AH+Ftof3ihRnPYCRhXfys=;
        b=GI5HHNoDfnv7Xt2dXdQVsSPXXrf8xeXQpNWlFXZorCsInUO+7v9NY0aJ61Wq3Jrs8E
         kGQwH76ph9khKWrUeXzvPLglMXDgMZIIY54cSF/xDKTI2B+6z40RBNIFJsJyIqLBi2Tp
         /4IjX7V/Nl9JV0ZKRW6w1rRtjDB7U9hS1o72B3bA9f1kQsnaasLnan0u04D8EJ66o/lT
         QRUjYtEUOZzmooLboK7oxd2ALtGFHtLnXQq0cGS3gCSZ9ykQyEYPx3B41T0RJmlLxBu3
         0pGJgbLQ8aYagsnC8EaV+V6QeE9vVfhTJFm18qhaheSKMiu2Zw5f5PQymgLHdTXWDrLv
         QNiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942685; x=1684534685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ojiAvkB2QjgGX0WuePfTk5AH+Ftof3ihRnPYCRhXfys=;
        b=ZiIO5qo7/qXj7k0M7QhwO3ANxsscAVo+DRh7Gnr/rdNUimOGo5KEXDe/jkpTEW2OpK
         lQole1XRh4vAz6cQCda0mGeRFrlRqfTDNpGpw9Q+OIqUAXwbGDUTruLaUi5kPmX+Ww5s
         Uf0nCj7mTmu72pLczRwEHS/9EgrGgJ+J6ejwaLtX9ZLgl9o/oqYDQQj3JoUzj9RDErD1
         iaUpzec/VL2mre1mctL5U/fAMA89qreh1Ai7KQLBIrIK2cLYuMABuJ2x3LSJqzG+4Xj2
         mZwGW+FnLsGFOEas1vn35FXbhLpTTQfCIYu24+mTHVJfL2zak9sqFcadihAQfyTuR9P4
         Jt/A==
X-Gm-Message-State: AAQBX9dX0R4qWzkZhxE3tPG9QZ6Iq8/lslbBZWG5dMmfZN+LAn9dIhZd
        hkwpnCC039CUdSCji5PI+HO1FQ==
X-Google-Smtp-Source: AKy350aUmxK/wzp1xvJIpKWslK3gwGr/UxzJX5snN5ZgZlPl8MyALzkERpVzHjZpOuQ6botaKIIVqg==
X-Received: by 2002:a17:903:22c1:b0:1a1:c3eb:afd with SMTP id y1-20020a17090322c100b001a1c3eb0afdmr7315223plg.65.1681942684832;
        Wed, 19 Apr 2023 15:18:04 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:18:04 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC 16/48] RISC-V: KVM: Skip most VCPU requests for TVMs
Date:   Wed, 19 Apr 2023 15:16:44 -0700
Message-Id: <20230419221716.3603068-17-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419221716.3603068-1-atishp@rivosinc.com>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, KVM manages TLB shootdown, hgatp updates and
fence.i through vcpu requests.

TLB shootdown for the TVMs happens in co-ordination with TSM.
The fence.i & hgatp updates are directly managed by the TSM.
There is no need to issue these requests directly for TVMs.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index c53bf98..3b600c6 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -22,6 +22,7 @@
 #include <asm/kvm_nacl.h>
 #include <asm/hwcap.h>
 #include <asm/sbi.h>
+#include <asm/kvm_cove.h>
 
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
@@ -1078,6 +1079,15 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_riscv_reset_vcpu(vcpu);
 
+		if (is_cove_vcpu(vcpu)) {
+			/*
+			 * KVM doesn't need to do anything special here
+			 * as the TSM is expected track the tlb version and issue
+			 * hfence when vcpu is scheduled again.
+			 */
+			return;
+		}
+
 		if (kvm_check_request(KVM_REQ_UPDATE_HGATP, vcpu))
 			kvm_riscv_gstage_update_hgatp(vcpu);
 
-- 
2.25.1

