Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7217786C6
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 06:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbjHKEwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 00:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbjHKEwF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 00:52:05 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B794330D0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:51:48 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5734d919156so19831017b3.3
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691729508; x=1692334308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P6qPiqYiGdEy+ALMWmUClgOJtf7MJwHf5G0engyYFuk=;
        b=qrcaMEcSpq+ULmZt9JgV/iXS5+x9ZwEslbJLOWWZHpe9tEaJ28kJ0dsZTFh+wHaZVY
         z/+PWbhe4kPyyucCymXKpbVkBUvDdebb4moSiMcKue6hrkGuTyTFlQ2SS1ZDAmF+7o2K
         JIqhRUzm+nxJK7sCky9lN7UwOaQ9GwOZduGzIbm/TwSEScjePA4FFoYCus4bBKN6ke8D
         wf+zv3/75Th+zNlJ44hzGeBSVubCWPJjE5lDfkpmjoMYIWdYXie5RHK61lA9sT3xtR4j
         o2HtqwDGpSxcDAOl6CF9D9EeEbTPBni26ZJIeebSWG7wMNG4nNsXFqjiD04Lfm8rlpNh
         SVOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691729508; x=1692334308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P6qPiqYiGdEy+ALMWmUClgOJtf7MJwHf5G0engyYFuk=;
        b=kDYfCl0+G6i/DlMKZGD39LCrRjktaEdUBNCbJknC0gmDXJc6GSRENtU7U3snTZxriK
         mzo7p5UuB1wpsQbsp8MrqIb+7OOCMduN9T1A0rzSYVAjkR3+5uAB78QZYnDKVGQtJK7D
         0HL92KaCXxYI+DVGl5XmNNX+6wQmkQcWTNrz84smh4/AUfC20qe87UCrN3212Y6hvhWS
         nUPGrABTRRFPFwgyzTKJ4DDe3L4ERk42IpaRrgTtfuorV3jyBf9lVvv1znCNjuggLIVJ
         uLt4M0hdjphDpUzz3CVvlsf02JBRFHxkk0BTN2CTkL6TAdndv1diuqyFcrFJaZa1T9T4
         Q9cg==
X-Gm-Message-State: AOJu0YzTeZuqEG4eP3lvUalOYGup2ykkb+Tk9XurSd7fMuezEYPatDmS
        EWqP0Srl394X+Dj0O/QRwifoNG+o3UYY
X-Google-Smtp-Source: AGHT+IGXV3TrUe7VdEmoyRMybbrBwXMmeig9Hy139aV3xPrm/bppO8Uhrj80L5wM2TEVNSyoFL3mzf/IgjNd
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:b71b:0:b0:589:bfc5:d80b with SMTP id
 v27-20020a81b71b000000b00589bfc5d80bmr14055ywh.2.1691729508012; Thu, 10 Aug
 2023 21:51:48 -0700 (PDT)
Date:   Fri, 11 Aug 2023 04:51:25 +0000
In-Reply-To: <20230811045127.3308641-1-rananta@google.com>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230811045127.3308641-13-rananta@google.com>
Subject: [PATCH v9 12/14] KVM: arm64: Flush only the memslot after write-protect
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After write-protecting the region, currently KVM invalidates
the entire TLB entries using kvm_flush_remote_tlbs(). Instead,
scope the invalidation only to the targeted memslot. If
supported, the architecture would use the range-based TLBI
instructions to flush the memslot or else fallback to flushing
all of the TLBs.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 702f8715f9fe7..6f44896936b47 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1083,7 +1083,7 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	write_lock(&kvm->mmu_lock);
 	stage2_wp_range(&kvm->arch.mmu, start, end);
 	write_unlock(&kvm->mmu_lock);
-	kvm_flush_remote_tlbs(kvm);
+	kvm_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
 /**
-- 
2.41.0.640.ga95def55d0-goog

