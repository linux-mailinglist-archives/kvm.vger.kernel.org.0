Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2C37D9FE0
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 20:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346376AbjJ0SWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 14:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbjJ0SWt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 14:22:49 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC701A7
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 11:22:34 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5af9ad9341fso10343357b3.2
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 11:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698430953; x=1699035753; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QjG+iTAl+MysAoCDX0shLrWGCG7e9aCGlo9+qs2tVnE=;
        b=GboxU9hFYFXO5qn1IjUEXGWAanotm5uv6d1ExTIDSU+CqAkB5bQGwMOPxnCJiJ2RcF
         rskBiwmzeF4LFtGn05KtzZc75mc7Fgb1tJROrIoWu5x8TpL0w3dPacXbh1tFP2rkx4wi
         aKr41d8xZlA/twTU1EYsPqhC92vHOhoVPRVkM2QUSKue3+CrrAY+LR1b8XsZ7NhNdzkP
         RuAIuodjVsYyG9G7SKhfxPO9w9gLQaacaqP/LkACm2yD8+oEK0Mnymy6Sytll2Bz4HnH
         kxkLvjPS6LQTMuXn5GOk95y+c5bBGTJXGiDyVCQoyuvspd3vv8mBveA59LuCK6aL+udl
         bA9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698430953; x=1699035753;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QjG+iTAl+MysAoCDX0shLrWGCG7e9aCGlo9+qs2tVnE=;
        b=vVRopL29Us9NQ3MJPlFjG4Wb2R3OdY5CLzvlV3dXDiewtzK06ysfgAm8/0teTAEcZt
         wYPjaKVg1+kpxeyViKcbXgjYwTrw6IQ2inE7NlxVE4zjxLcmDv9LrP1WS2kQ2dv1HmLY
         s3RAJ6T1vUbN9bw9oM2khIrJ8KXyedK3sH0kwZBKhFTomSb/Tw9J+ANkLPZ8xF06zpno
         MCfZ98w8Cka0ngt0ycoF3ri5DYn4ZlZL00Lli0DTLuGZeOOmB992PTQnvaxtT07wrVYG
         +LJLK3rZWaeu2SMUIo75m9AmO3/fyU6cLslS+Itpg+IzMIHO6vRoZkUJpncPxeWcCRqJ
         8zCQ==
X-Gm-Message-State: AOJu0YyGeVNv9P3ZxZ4DIS2GNMgXQ9Na+ECx8eIsO3K7Zatt0BTOkHyl
        HACLL4IaQD2TT6S8POM0phJljRZiSKo=
X-Google-Smtp-Source: AGHT+IFjdgmBdyxBQ0zr6Phdzdc3NhfRHFKE/+Wea1IZiVOT7T4IBQHOPkTpo2hU6PU86u42a7hH74NJYwo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1083:b0:da0:567d:f819 with SMTP id
 v3-20020a056902108300b00da0567df819mr78680ybu.10.1698430953673; Fri, 27 Oct
 2023 11:22:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Oct 2023 11:21:46 -0700
In-Reply-To: <20231027182217.3615211-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027182217.3615211-5-seanjc@google.com>
Subject: [PATCH v13 04/35] KVM: WARN if there are dangling MMU invalidations
 at VM destruction
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Anish Moorthy <amoorthy@google.com>,
        David Matlack <dmatlack@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
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

Add an assertion that there are no in-progress MMU invalidations when a
VM is being destroyed, with the exception of the scenario where KVM
unregisters its MMU notifier between an .invalidate_range_start() call and
the corresponding .invalidate_range_end().

KVM can't detect unpaired calls from the mmu_notifier due to the above
exception waiver, but the assertion can detect KVM bugs, e.g. such as the
bug that *almost* escaped initial guest_memfd development.

Link: https://lore.kernel.org/all/e397d30c-c6af-e68f-d18e-b4e3739c5389@linux.intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1a577a25de47..4dba682586ee 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1356,9 +1356,16 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	 * No threads can be waiting in kvm_swap_active_memslots() as the
 	 * last reference on KVM has been dropped, but freeing
 	 * memslots would deadlock without this manual intervention.
+	 *
+	 * If the count isn't unbalanced, i.e. KVM did NOT unregister its MMU
+	 * notifier between a start() and end(), then there shouldn't be any
+	 * in-progress invalidations.
 	 */
 	WARN_ON(rcuwait_active(&kvm->mn_memslots_update_rcuwait));
-	kvm->mn_active_invalidate_count = 0;
+	if (kvm->mn_active_invalidate_count)
+		kvm->mn_active_invalidate_count = 0;
+	else
+		WARN_ON(kvm->mmu_invalidate_in_progress);
 #else
 	kvm_flush_shadow_all(kvm);
 #endif
-- 
2.42.0.820.g83a721a137-goog

