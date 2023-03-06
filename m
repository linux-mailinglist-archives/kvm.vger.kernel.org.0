Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA5F6ACD71
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 20:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCFTC2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 14:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjCFTC0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 14:02:26 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D211B1FD7
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 11:02:06 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536a4eba107so112204147b3.19
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 11:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678129326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hy1Buh0DyhAQ1dsWc1I6Y0GrKiZLM4ytS70wq/2qiU0=;
        b=Letr5LRp7bS0YmkVINmE83RF8//+0ihwPomgSJZC4+dkD9sFUFEL35AQoxcfPpIbXW
         Y1mVJA34aQ9Fn9+jBPkAovdeUPbAGsum3MVzw575zB3u4rfwK4ZVePdw3VSiVo2j9C9v
         3XnoKl7fEhlmtkQ5DdG9/UhFj+tyVjNmSih/iYAuSQ6xwOtYmbjOYgHRAkzFRXa92dze
         ZQvrRjBbIKvFglVzBDH4EAw30eROHuzuIjsYKsJXNnWsAQHIog+eYwButoAe0B9OxSD2
         pOTz7b2aOyFjFOUOaTEw5+7DJRfnksutj0fbq9nxtjgFb7SGFFpwHZTOmxj6KpssL5px
         NozA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678129326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hy1Buh0DyhAQ1dsWc1I6Y0GrKiZLM4ytS70wq/2qiU0=;
        b=Hu85VNoJsa3BgUdVm+jEuSA6cnlvg/3kb30pT3RuSTkM2Pnl0Y38jel0aSmlpV/iWe
         JneGIstCFFBkdeZunhqnzhe8z4Vd6jLHLCuglQLtUYzHiVjO7ql+NoDxTkQO/3DZZ2XW
         gPzpMGvDu1F3vfY0xAmyPdr7ZWfGkcsnsbZUXX9xmatX02HYBsj88+O1gAQJpxiLJoah
         frniQqAf+nYaK2vlpvxsBTqVXO1oGEs3kqbDlXqv+HcIFmKSiyjYF/4747rDyrQpQ4GY
         3pIb6lu0xboQhrRhEkRxvBKlTWmkAYLn2oGkxpUiPHPHnVhyyUTIbPbEHCHGwVpwstjY
         m0vA==
X-Gm-Message-State: AO0yUKVewjKMMEhSuvbh7anIP0DOh6HjZEuaDgejeNK8QCIAT7x51gEU
        OWd0m5gZCEolEHqjKK41IAQ9EV4y7P34Iw==
X-Google-Smtp-Source: AK7set9e2oV5ajrE5TnGPzkyECRcuaio2KGOJRsM0L6WhO9k90cawVld9W/AAFXa4Ih5X3b9O+P88E69HqyVhg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:b667:0:b0:534:d71f:14e6 with SMTP id
 h39-20020a81b667000000b00534d71f14e6mr7365447ywk.9.1678129326079; Mon, 06 Mar
 2023 11:02:06 -0800 (PST)
Date:   Mon,  6 Mar 2023 11:01:56 -0800
In-Reply-To: <20230306190156.434452-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230306190156.434452-1-dmatlack@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230306190156.434452-5-dmatlack@google.com>
Subject: [PATCH v2 4/4] KVM: x86: Drop union for pages_{4k,2m,1g} stats
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        David Matlack <dmatlack@google.com>,
        Sathvika Vasireddy <sv@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the union for the pages_{4k,2m,1g} stats. The union is no longer
necessary now that KVM supports choosing a custom name for stats.

Eliminating the union also would allow future commits to more easily
move pages[] into common code, e.g. if KVM ever gains support for a
common page table code.

An alternative would be to drop pages[] and have kvm_update_page_stats()
update pages_{4k,2m,1g} directly. But that's not a good direction to go
in since other architectures use other page sizes.

No functional change intended.

Link: https://lore.kernel.org/kvm/20221208193857.4090582-1-dmatlack@google.com/
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h | 9 +--------
 arch/x86/kvm/x86.c              | 6 +++---
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 808c292ad3f4..a59e41355ef4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1473,14 +1473,7 @@ struct kvm_vm_stat {
 	u64 mmu_recycled;
 	u64 mmu_cache_miss;
 	u64 mmu_unsync;
-	union {
-		struct {
-			atomic64_t pages_4k;
-			atomic64_t pages_2m;
-			atomic64_t pages_1g;
-		};
-		atomic64_t pages[KVM_NR_PAGE_SIZES];
-	};
+	atomic64_t pages[KVM_NR_PAGE_SIZES];
 	u64 nx_lpage_splits;
 	u64 max_mmu_page_hash_collisions;
 	u64 max_mmu_rmap_size;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 072f5ba83170..101ad6b7e7b6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -240,9 +240,9 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_STAT(VM, CUMULATIVE, NONE, mmu_recycled),
 	KVM_STAT(VM, CUMULATIVE, NONE, mmu_cache_miss),
 	KVM_STAT(VM, INSTANT, NONE, mmu_unsync),
-	KVM_STAT(VM, INSTANT, NONE, pages_4k),
-	KVM_STAT(VM, INSTANT, NONE, pages_2m),
-	KVM_STAT(VM, INSTANT, NONE, pages_1g),
+	__KVM_STAT(VM, INSTANT, NONE, pages[PG_LEVEL_4K - 1], "pages_4k"),
+	__KVM_STAT(VM, INSTANT, NONE, pages[PG_LEVEL_2M - 1], "pages_2m"),
+	__KVM_STAT(VM, INSTANT, NONE, pages[PG_LEVEL_1G - 1], "pages_1g"),
 	KVM_STAT(VM, INSTANT, NONE, nx_lpage_splits),
 	KVM_STAT(VM, PEAK, NONE, max_mmu_rmap_size),
 	KVM_STAT(VM, PEAK, NONE, max_mmu_page_hash_collisions)
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

