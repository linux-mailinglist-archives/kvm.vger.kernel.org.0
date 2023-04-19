Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157C16E8490
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbjDSWSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbjDSWST (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:18:19 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE5765BF
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:18:02 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1a69f686345so4526475ad.2
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942682; x=1684534682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gRHTy1c+Pl7OVrg4l834g5VjRWcSWQwGhgEvJAPkg+w=;
        b=kmEcD4YfOAFXGG17QX3KsyUFIzwyUfrsKZ1wYGSvZgqODlY6mzST437Sn9HGEmF2e4
         2a2a47FJD8fRdSNkrzKWkWk+t1hYBGWo5RKv/QKbDEChEI7DPntySLvvhVENeLXEvAzZ
         Yi9hf+mn4OFq02nwK3TFnSe2tJbzQbrAKkpWS2zkyUDSsMGzPeY61HsFbh3a25B058l+
         uUA1pt3+Fbza1RQ2lPxN0ghz2+DhS82u09mOfYSZt3cX82Z63iV2DNRddUax6jZ/SlYZ
         5R7VI8q/CylWQy7dmPwpqmG5M0g3aSf6g2QGsKHX2ECmbls1SK5jLS9FX181LfzlvClk
         L9rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942682; x=1684534682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gRHTy1c+Pl7OVrg4l834g5VjRWcSWQwGhgEvJAPkg+w=;
        b=XerWSFEO3BoGkZa2K2jw9WZpAdyuKER/EGrqpXSRIfIHHhkTPZyGo6t/wZkluOAUUB
         LBBbK/gdEZPBGvgRIqZCKGz9kuQ57sV1n/7BM9n4UzPVHF8BYUSIOmdORUHsvnneJFj3
         0f0890NsVNN+e7so+E1M992RwrQBMvBemQWvPjtb+auXA7KI924JquOIIh0VzByj309r
         zk1RQ2awVrnpBU1/IKT57nCP6bbCoAdWQ2xG9wQnQa30/PqOOzFBzQBJOKSBNo0ctw79
         RSvz9XJHupFvcBPD+cb8J5X/qFoBtW3JDypeAW5GdNHKhtm1AV0lJqLq5CacZ9adc6YV
         54AQ==
X-Gm-Message-State: AAQBX9dZSIja4joDbPWEzNmyE+vgARZh/ran0Iw6EyPUI3W+pi7xDhXf
        OiQOMXXLYE/qyHH1Wnn8+00SOA==
X-Google-Smtp-Source: AKy350YWY4zn6DitmSoPXPvjQSlrg5vxaeh3mQBYR6TvOk3ni0Mxh3KE27JFZrBKZBdZgegUV17R1Q==
X-Received: by 2002:a17:902:ec8b:b0:1a9:23b7:9182 with SMTP id x11-20020a170902ec8b00b001a923b79182mr2673903plg.27.1681942682652;
        Wed, 19 Apr 2023 15:18:02 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:18:02 -0700 (PDT)
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
Subject: [RFC 15/48] RISC-V: KVM: Add a helper function to trigger fence ops
Date:   Wed, 19 Apr 2023 15:16:43 -0700
Message-Id: <20230419221716.3603068-16-atishp@rivosinc.com>
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

When Cove is enabled in RISC-V, the TLB shootdown happens in co-ordination
with TSM. The host must not issue hfence directly. It relies on TSM
to do that instead. It just needs to initiate the process and make
sure that all the running vcpus exit the guest mode. As a result, it
traps to TSM and TSM issues hfence on behalf of the host.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_cove.h |  2 ++
 arch/riscv/kvm/cove.c             | 36 +++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_cove.h b/arch/riscv/include/asm/kvm_cove.h
index 4ea1df1..fc8633d 100644
--- a/arch/riscv/include/asm/kvm_cove.h
+++ b/arch/riscv/include/asm/kvm_cove.h
@@ -130,6 +130,8 @@ void kvm_riscv_cove_vcpu_switchto(struct kvm_vcpu *vcpu, struct kvm_cpu_trap *tr
 int kvm_riscv_cove_vm_measure_pages(struct kvm *kvm, struct kvm_riscv_cove_measure_region *mr);
 int kvm_riscv_cove_vm_add_memreg(struct kvm *kvm, unsigned long gpa, unsigned long size);
 int kvm_riscv_cove_gstage_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hva);
+/* Fence related function */
+int kvm_riscv_cove_tvm_fence(struct kvm_vcpu *vcpu);
 #else
 static inline bool kvm_riscv_cove_enabled(void) {return false; };
 static inline int kvm_riscv_cove_init(void) { return -1; }
diff --git a/arch/riscv/kvm/cove.c b/arch/riscv/kvm/cove.c
index 5b4d9ba..4efcae3 100644
--- a/arch/riscv/kvm/cove.c
+++ b/arch/riscv/kvm/cove.c
@@ -78,6 +78,42 @@ static int kvm_riscv_cove_fence(void)
 	return rc;
 }
 
+int kvm_riscv_cove_tvm_fence(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_cove_tvm_context *tvmc = kvm->arch.tvmc;
+	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
+	unsigned long i;
+	struct kvm_vcpu *temp_vcpu;
+	int ret;
+
+	if (!tvmc)
+		return -EINVAL;
+
+	spin_lock(&tvmc->tvm_fence_lock);
+	ret = sbi_covh_tvm_initiate_fence(tvmc->tvm_guest_id);
+	if (ret) {
+		spin_unlock(&tvmc->tvm_fence_lock);
+		return ret;
+	}
+
+	bitmap_clear(vcpu_mask, 0, KVM_MAX_VCPUS);
+	kvm_for_each_vcpu(i, temp_vcpu, kvm) {
+		if (temp_vcpu != vcpu)
+			bitmap_set(vcpu_mask, i, 1);
+	}
+
+	/*
+	 * The host just needs to make sure that the running vcpus exit the
+	 * guest mode and traps into TSM so that it can issue hfence.
+	 */
+	kvm_make_vcpus_request_mask(kvm, KVM_REQ_OUTSIDE_GUEST_MODE, vcpu_mask);
+	spin_unlock(&tvmc->tvm_fence_lock);
+
+	return 0;
+}
+
+
 static int cove_convert_pages(unsigned long phys_addr, unsigned long npages, bool fence)
 {
 	int rc;
-- 
2.25.1

