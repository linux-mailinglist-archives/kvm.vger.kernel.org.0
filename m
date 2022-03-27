Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCA854E8A11
	for <lists+kvm@lfdr.de>; Sun, 27 Mar 2022 22:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbiC0UhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 16:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiC0UhO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 16:37:14 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A6D31934
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 13:35:35 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id n17-20020a17090ac69100b001c77ebd900fso7825682pjt.8
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 13:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=9l3gztPA4wtuBVPjKquVrCus2mQqcSAyx1f1VGo4bsk=;
        b=oyq8RWbljF3omcA3hH4gl/L3//Z1KwCgKNtZKKmr98wWG1RuwkUKS/XdAnKJG8JsW9
         bD5KSS9AFJnAtVH6kw/oA48qhbFDm5kTMmjT1uKToo+N1yyudSZFs4BNiDXint0Mx73O
         ZU7VmCKVYVz6+Z2fTDlPy5qAYBTZBF4cPePEXEYUD89Uzljw4MSmRAjv/FcDg2cpz3i0
         xGdlW79SqpPEWU7bXGSBXQL3T/29TdQX52yiKIGvTYEiFTUsfOsaO2Z1e9vp+x0gLgUC
         B/gC4fXNfb1fhZ7tvojY6SNvK+4BBOsMjE0HZqTJNO6LdOFcHfFB9NGLQWDrrHA/E9nc
         yKpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=9l3gztPA4wtuBVPjKquVrCus2mQqcSAyx1f1VGo4bsk=;
        b=eP+9yV9sqf1/f9984z5aONG1jQ6HhRFfp3YxxGv1F7DM4WvtmXX3xNtmmA07uaBEW/
         QYIZmGVyoXucoe7JlGllFCU72rv0PyDwTLUoNlBQzGq4fXxMIDdxK8sb6YUpXdszffBx
         Xk1h7zl05iHXVdHM51+wuqzIlEGhDsV7maV3dbxEZqXz7tLkdzFSHqMl1AcNLZ0DCSRb
         UrrBXSHLEckfNvLyTuIs01FH0XnYYUUQa9guKS8wurWCMjrEudqDKOh8VXoZ3c7HVfLL
         iRMLERNoOfPvtLHHQ2eG4DzZrII5pkF6TS2b6EqQgocsJ8L4CM+1dSk699+8r2r8kgCP
         DP2A==
X-Gm-Message-State: AOAM530IJy9uZpT5w67wBJrM4OX0lN9vvbSDFLYitfQuxXHjOmD39ytj
        xNP4531qMU57igV2rWXYwg7rtVxEbt1/
X-Google-Smtp-Source: ABdhPJyqtVod/LCY2erleBb/XsReu0oEcBeFmOcQvYIZY4Wzd1rzn/8G672H1CuGzyv4BJ2I4oS0n/YmwyaG
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:90a:d681:b0:1be:e3e5:3e6e with SMTP id
 x1-20020a17090ad68100b001bee3e53e6emr36730653pju.122.1648413334619; Sun, 27
 Mar 2022 13:35:34 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Sun, 27 Mar 2022 20:35:32 +0000
Message-Id: <20220327203532.407821-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH] KVM: x86/mmu: add lockdep check before lookup_address_in_mm()
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a lockdep check before invoking lookup_address_in_mm().
lookup_address_in_mm() walks all levels of host page table without
accquiring any lock. This is usually unsafe unless we are walking the
kernel addresses (check other usage cases of lookup_address_in_mm and
lookup_address_in_pgd).

Walking host page table (especially guest addresses) usually requires
holding two types of locks: 1) mmu_lock in mm or the lock that protects
the reverse maps of host memory in range; 2) lock for the leaf paging
structures.

One exception case is when we take the mmu_lock of the secondary mmu.
Holding mmu_lock of KVM MMU in either read mode or write mode prevents host
level entities from modifying the host page table concurrently. This is
because all of them will have to invoke KVM mmu_notifier first before doing
the actual work. Since KVM mmu_notifier invalidation operations always take
the mmu write lock, we are safe if we hold the mmu lock here.

Note: this means that KVM cannot allow concurrent multiple mmu_notifier
invalidation callbacks by using KVM mmu read lock. Since, otherwise, any
host level entity can cause race conditions with this one. Walking host
page table here may get us stale information or may trigger NULL ptr
dereference that is hard to reproduce.

Having a lockdep check here will prevent or at least warn future
development that directly walks host page table simply in a KVM ioctl
function. In addition, it provides a record for any future development on
KVM mmu_notifier.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Ben Gardon <bgardon@google.com>
Cc: David Matlack <dmatlack@google.com>

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1361eb4599b4..342aa184c0a2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2820,6 +2820,24 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	 */
 	hva = __gfn_to_hva_memslot(slot, gfn);
 
+	/*
+	 * lookup_address_in_mm() walks all levels of host page table without
+	 * accquiring any lock. This is not safe when KVM does not take the
+	 * mmu_lock. Holding mmu_lock in either read mode or write mode prevents
+	 * host level entities from modifying the host page table. This is
+	 * because all of them will have to invoke KVM mmu_notifier first before
+	 * doing the actual work. Since KVM mmu_notifier invalidation operations
+	 * always take the mmu write lock, we are safe if we hold the mmu lock
+	 * here.
+	 *
+	 * Note: this means that KVM cannot allow concurrent multiple
+	 * mmu_notifier invalidation callbacks by using KVM mmu read lock.
+	 * Otherwise, any host level entity can cause race conditions with this
+	 * one. Walking host page table here may get us stale information or may
+	 * trigger NULL ptr dereference that is hard to reproduce.
+	 */
+	lockdep_is_held(kvm->mmu_lock);
+
 	pte = lookup_address_in_mm(kvm->mm, hva, &level);
 	if (unlikely(!pte))
 		return PG_LEVEL_4K;
-- 
2.35.1.1021.g381101b075-goog

