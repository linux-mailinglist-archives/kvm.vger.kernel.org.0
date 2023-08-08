Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD4B774F2A
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 01:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbjHHXO3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 19:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjHHXN6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 19:13:58 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732831FEF
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 16:13:48 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d4b1c8f2d91so4178841276.0
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 16:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691536427; x=1692141227;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DdFQXc9QjMOj4pMVD7mddwddfJwM0E/FVNI1wIxPkhk=;
        b=GGya4r79Fypy7MpijHUr6lRrKbN2KwgnqmepmFHyoEm6JOw0RI4BnR26D52ypMST14
         qMrhS6uMP+X/P+04iY+CFJYP/yfNgW/oQiRxmX4L8KUMTb9SHE2leuL53nL+lEy8UfWN
         H6Gme/iQnweVgHOIz203N5vFFXqVCtC2ViqgYkIHf1XrsCct05bcsmV1KcRfn0mKeymj
         ESMAAwstxX9ujJZpbixig2EzSNSrlwlq3HWLXEyApK1JC0D3VIjPeG/oYEmpo68kYHS8
         /95jhR/N+ADW8Wt9ABI0Q1X51ZWQY4WgE96INI5uDk8QgBXuW/N36eA7E8a9TtSBew8R
         8+sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691536427; x=1692141227;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DdFQXc9QjMOj4pMVD7mddwddfJwM0E/FVNI1wIxPkhk=;
        b=S1YyYyl8WYluoan94M020QUDvDP4qq50QO3ont5n9MgB4xqjDTaDAksJk72IeUyUjh
         6i4N+OptHtYDGTQ6PlULXoMt+2K8GmCZ/+iaHnhs21yqd/VV4xr/Ldq2qyxfHXPU3Phr
         sOmBi93omr9xXX4dgg5ThNVK4dku14Kqp8XIwzaWS0+bs1QKp2/SUnGE5AFe0oHyR1JY
         PH6ZKMU49oRPURanYI87F8K/TW0bkamdR69V3s22HqoV5Iu/indxPGuTAg/E5rSMNGxT
         Y6+CnMbGBav/+ehttXS6T7VizCfHDyRAEMoGvEGr2qhygx7lufDjcOrJWr/VhyYlobRm
         DnKQ==
X-Gm-Message-State: AOJu0Yx/FZXMw35fVb43XcJgMU2NNdMrsdNt4xoL9xkTPsnjcOguMrdU
        Y8gwUmCXDkR5tigwrB4WZBpBnNoVWV08
X-Google-Smtp-Source: AGHT+IHtVpA0B67cdmlCLqrTRdBRqOLFjvFy7tyIxoiuO5XwsAt9fDPTNialdcxuGgrd+oEKUp81U6/MqqgQ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:ac09:0:b0:d0c:1f08:5fef with SMTP id
 w9-20020a25ac09000000b00d0c1f085fefmr19514ybi.12.1691536427532; Tue, 08 Aug
 2023 16:13:47 -0700 (PDT)
Date:   Tue,  8 Aug 2023 23:13:28 +0000
In-Reply-To: <20230808231330.3855936-1-rananta@google.com>
Mime-Version: 1.0
References: <20230808231330.3855936-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230808231330.3855936-13-rananta@google.com>
Subject: [PATCH v8 12/14] KVM: arm64: Flush only the memslot after write-protect
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
index 294078ce16349..95ca2b86aa2cd 100644
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

