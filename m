Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5D06E84BF
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbjDSWVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbjDSWVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:21:04 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F3D93F7
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:19:46 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1a682eee3baso4404765ad.0
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942723; x=1684534723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQCEa95xde61G0+g1spWAS5gSK9slN4MB0K1b9QrdE8=;
        b=Ynw03ruOG3PNfgG00HUUd7HJCh15VY3aEZKHBX+JvWIZqAaPdtZJFMNC9sQ+7tdyNf
         gQij1krIXgqHn6c3FKneR90d+ObOiz01SLEvx89Co8mtqMDidl42AKlK9b8IeRrjhkVj
         wFMRWmBw0WyiUKSEW2tAX/U5AjDnycCzdvc7/5XQe2CDXdqSpATkNcRDmxBB2iAZSbfO
         Qe8Etb6nnDF5lWA9UfVwL0EYoHqQHL5jKdNdyJEbe8jXSsaw1PcWzy6qONpwtJLTmV1a
         iWDDSsLQLNxRbxPSgzzxgbkJX9sxpOs3jDYDbGE18ziPonHZ9Lw5ZRGoMLwBsGOpngcC
         aTQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942723; x=1684534723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CQCEa95xde61G0+g1spWAS5gSK9slN4MB0K1b9QrdE8=;
        b=kqlnpOhDvZ0GIinJ4ihVTTLJZZo9SZfT0SV3QpMgPSJSx7Bic7B6ybF0DB2eCFPFbW
         wLR3q6/t2f+scx+qIhKBnyrScf98tbzgtqe/JlrtCfYkT2xP7h9KSklz4cW+DLHlgP0S
         NLWi/txfzgU5n8XCKUY699ytiwfJiKidUGE3vASUeIWX/UgAvWWhB8tUKmRIwJvTKTAx
         F6di+mkhRGlnclNOPR509DEMSULwg9vzg8e91+Q8L9a6zw0Wx5mk3N6DKlQm9sqRAhB7
         sz0JkWgCDs8ErFGFORJUJAbxeZ8sqPUHrJcujOf17lP3T6I9ZR8V56fJ25cJMDo9NEDI
         swew==
X-Gm-Message-State: AAQBX9c/ierpaNPAsDuRvzTZMknQoFOrbh3B5jZTe/m0r/WaT6cucIMU
        3P8cZuqknvg8p+166e9zGJpvNw==
X-Google-Smtp-Source: AKy350a8Ym8XHInuF0mFeXBc2+oA8kajjJCNeYyHi0F4HD8cqx1mngs6rpkeTwZ7fiAYwBWCbSvEDg==
X-Received: by 2002:a17:902:ba89:b0:1a9:2693:2e29 with SMTP id k9-20020a170902ba8900b001a926932e29mr1536823pls.42.1681942722916;
        Wed, 19 Apr 2023 15:18:42 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:18:42 -0700 (PDT)
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
Subject: [RFC 33/48] RISC-V: KVM: Hookup TVM VCPU init/destroy
Date:   Wed, 19 Apr 2023 15:17:01 -0700
Message-Id: <20230419221716.3603068-34-atishp@rivosinc.com>
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

The TVM VCPU create function requires the vcpu id which is generated
after the arch_create_vcpu returns. Thus, TVM vcpu init can not be
invoked from the arch_create_vcpu. Invoke it in post create for now.
However, post create doesn't return any error which is problematic
as vcpu creation can fail from TSM side.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 65f87e1..005c7c9 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -218,6 +218,17 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
+	int rc;
+	/*
+	 * TODO: Ideally it should be invoked in vcpu_create. but vcpu_idx
+	 * is allocated after returning create_vcpu. Find a better place to do it
+	 */
+	if (unlikely(is_cove_vcpu(vcpu))) {
+		rc = kvm_riscv_cove_vcpu_init(vcpu);
+		if (rc)
+			pr_err("%s: cove vcpu init failed %d\n", __func__, rc);
+	}
+
 	/**
 	 * vcpu with id 0 is the designated boot cpu.
 	 * Keep all vcpus with non-zero id in power-off state so that
@@ -237,6 +248,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 	kvm_riscv_vcpu_pmu_deinit(vcpu);
 
+	if (unlikely(is_cove_vcpu(vcpu)))
+		kvm_riscv_cove_vcpu_destroy(vcpu);
+
 	/* Free unused pages pre-allocated for G-stage page table mappings */
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
 }
-- 
2.25.1

