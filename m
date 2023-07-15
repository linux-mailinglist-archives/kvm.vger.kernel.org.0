Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62AB07545CE
	for <lists+kvm@lfdr.de>; Sat, 15 Jul 2023 02:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbjGOAyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 20:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjGOAyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 20:54:23 -0400
Received: from mail-oo1-xc4a.google.com (mail-oo1-xc4a.google.com [IPv6:2607:f8b0:4864:20::c4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85D53AA9
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 17:54:19 -0700 (PDT)
Received: by mail-oo1-xc4a.google.com with SMTP id 006d021491bc7-55e16833517so3327575eaf.1
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 17:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689382459; x=1689987259;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E8/SKuTbF1S2hgzgftCz+xbv+GwRa24E0ShAGUklW+4=;
        b=hrja88/7wxXiKsBqU4+BG+pM3MGM1S9DOyuubBS6zRCvIJ5eqNbAcqAnTdgYLBUU+G
         Xw+Q5KoogRXe6+j6MLR2KwqS39EPOItOND2hac4t/iid35aWJyaibOjPEAQmdMwYmjfh
         VzbdHI6TI0GOlWQpr7ND4xoMQoOV3vp6+LinZ0mxaFOfj8s73O11srFhZJK0pIAlsFoL
         P4nRJGXix8N2JZo0MJURuNa3SeLrZLgRbyyEKe5e1sT6jjEyyH20skLSiG1kT2BH+lWW
         M2jwktjB/uvksSymt5eF0yyQ/JrIKi5z5nYd8WpKGE+ItYKnNyJygjYrNRNPHTh4T2bz
         A4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689382459; x=1689987259;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E8/SKuTbF1S2hgzgftCz+xbv+GwRa24E0ShAGUklW+4=;
        b=C/GO/96Cksxz5exJHL8CvS6Ev/Ftsm7BEVankae4cSy4h/FWxW/ZNnae0oZ41woBmg
         lY31nS7Eofc4SzclsE7d/rM1YEHaqfsNevpiROYEVEGYuhVTnAZAHwq9OeU1XuTlJKMg
         nvopxE+hYY0A4GH5p+GO8rG3Ow9S8CP2OY2ThENQTogBlq3dFmCcph0HESkJ5xA9JbSB
         EvjT66iXd3quZpCUcLbO7h//wR6BEiEL0iezcUVnUGENIw4nChbDtSf6EGGfgGCwRPOT
         aUyMZM7Zg5WZ4sdgOcYj2eZVMl6xPeMsrotbNj+mRLjzPpKIzR7xTLK0/8qFub2LuMm3
         WARg==
X-Gm-Message-State: ABy/qLa3MHzsLIrSOvqDRFxBQ9ecdrz277iy8pDfe4gAnynawpNK/fZi
        g/iuap+xqNCufa/Fqk4JGBVvnmODQS4D
X-Google-Smtp-Source: APBJJlGuVOPdQOdSPn66tc6hZHiX5voXQ8Bd1Pq3KdWw9uZBWmzdkmlscTzl3Cyfs81jovCUQVWibJUVXGKq
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a4a:5213:0:b0:55e:38ef:109b with SMTP id
 d19-20020a4a5213000000b0055e38ef109bmr445620oob.1.1689382459192; Fri, 14 Jul
 2023 17:54:19 -0700 (PDT)
Date:   Sat, 15 Jul 2023 00:54:02 +0000
In-Reply-To: <20230715005405.3689586-1-rananta@google.com>
Mime-Version: 1.0
References: <20230715005405.3689586-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.455.g037347b96a-goog
Message-ID: <20230715005405.3689586-9-rananta@google.com>
Subject: [PATCH v6 08/11] KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement kvm_arch_flush_remote_tlbs_range() for arm64
to invalidate the given range in the TLB.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/kvm/mmu.c              | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7281222f24ef..52d3ed918893 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1114,6 +1114,9 @@ struct kvm *kvm_arch_alloc_vm(void);
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
 int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
+
 static inline bool kvm_vm_is_protected(struct kvm *kvm)
 {
 	return false;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0ac721fa27f1..387f2215fde7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -172,6 +172,13 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 	return 0;
 }
 
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
+{
+	kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
+				start_gfn << PAGE_SHIFT, pages << PAGE_SHIFT);
+	return 0;
+}
+
 static bool kvm_is_device_pfn(unsigned long pfn)
 {
 	return !pfn_is_map_memory(pfn);
-- 
2.41.0.455.g037347b96a-goog

