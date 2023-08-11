Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DED7786C4
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 06:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjHKEwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 00:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbjHKEwF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 00:52:05 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E616F30C5
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:51:47 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-58419550c3aso20136307b3.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691729507; x=1692334307;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oLpltBl1pXuOSkpdQMGZFCQJKBJp7Al35vzbWbo573Q=;
        b=ABgFIwVolq/6ag26A1K+kK7FXdPo3peqsgbFXc8qiwvbhPI3bZRUdLezxZ8tQik92l
         T+iaoKDZaDOv6IfoUeiWPTwxhMI85ie6LyPMFxNj8XDmursgFf3en60dEzF4dqf3h+RK
         WWx7VeXuvcWe37vd84r2WsEbYnf4b0bMiMo48syBpgvZj3Mksg0RwjMn5w1l5qhHm9a0
         rzrR9Pv0NaqoQijOdbcWJVVU6XHeWI2Lcm9tCQY3XKwKjOaLQmbXEehuzJJrIwVg3DQc
         UD1yUHkb20HLZXzkBKX91nLMJ4OeAFKhFEZgnnRUJwp6sPgDeXUVCPtkFFCTN0I7E6Kc
         DCjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691729507; x=1692334307;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oLpltBl1pXuOSkpdQMGZFCQJKBJp7Al35vzbWbo573Q=;
        b=h3tJUoah9iX+qTdYh4yks6bArswGRCamOyu00QclBWP1unenHBxrDbT9ofSJJW7VuI
         9PRJ2uiVybaHcczasv6ZfAR+sn4dtlZ5bFyXbNx+0VrqoCyMks+u+gWA1b2Z7o5IlZzV
         blD6E+HnPYm0u3lTWEprgZzOVOW5GYlS2pOUMN5PH1YJ8eaS35YfpFT6E7rfk96q/HfK
         Ak8FYipUe7re6yaNJpxU7ypUzVUev42vb0yBYpj+cxglKrVwXXWjLMb2iPnL0XVaqKdZ
         N6BEciaD+AMi493jVdol0WFMU1WWc3KHwr6vK09xkYAPYvUle4LcCnbYe6OEIwdf6GDP
         6WJw==
X-Gm-Message-State: AOJu0YyDNlVsfq8MfEYEXutDIA1tNct+1EdruTEm+1mxMkDbHEd+eay1
        CMyBwMPObXFVwsMQsNTHexylaBtlvhLx
X-Google-Smtp-Source: AGHT+IEO0sAyUJ6vzJq2dvhSW/1XhcAzkAPBREyGCgte4h6OEGCasNix0f17CE/S4vT/rvUZ3pDeQps2/zyR
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:ad51:0:b0:583:a8dc:1165 with SMTP id
 l17-20020a81ad51000000b00583a8dc1165mr13228ywk.10.1691729507118; Thu, 10 Aug
 2023 21:51:47 -0700 (PDT)
Date:   Fri, 11 Aug 2023 04:51:24 +0000
In-Reply-To: <20230811045127.3308641-1-rananta@google.com>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230811045127.3308641-12-rananta@google.com>
Subject: [PATCH v9 11/14] KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
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
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        David Matlack <dmatlack@google.com>,
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement kvm_arch_flush_remote_tlbs_range() for arm64
to invalidate the given range in the TLB.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/mmu.c              | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 20f2ba149c70c..8f2d99eaab036 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1113,6 +1113,8 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+
 static inline bool kvm_vm_is_protected(struct kvm *kvm)
 {
 	return false;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0ac721fa27f18..702f8715f9fe7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -172,6 +172,14 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 	return 0;
 }
 
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
+				      gfn_t gfn, u64 nr_pages)
+{
+	kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
+				gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT);
+	return 0;
+}
+
 static bool kvm_is_device_pfn(unsigned long pfn)
 {
 	return !pfn_is_map_memory(pfn);
-- 
2.41.0.640.ga95def55d0-goog

