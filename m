Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E7D4C5296
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240817AbiBZASK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240915AbiBZAR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:17:28 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8324922A256
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:32 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id j3-20020a170902da8300b0014fdd4e979cso3522059plx.17
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=YcD14cPLYHRqCUN9XMqsA1N9iI/pU6jOe1s6Rx79mLg=;
        b=g2WIVIjucKcc3FeIMYEg1JqP8sH7orBfOFiRQ1HLRZYZiypl1HiH1GM7aL3Mn0jfc3
         Zfk2B0RPCqztAdRLIp61/bnAGdzjSAuoGODazTgygTETjUDBQLRTAppOIA6z7Zt/nCyf
         T4JO0+PjzV1XHbQAqzIn/57gBeaUkfrDWwsyxOvG5bvcUcRIfq4oqmHxE/b087WnJgRi
         vAprnAM5+Gwdv4cPPtbCt72aVuIkMLh/p0OneGBIQL6DCwxl5BWu8bLBjQ278loJa+1e
         ORLiFR6OU0prTd2CtEi8zG1iwoxdGN3cs/S5KYMLoE4j3sPu2SihnHhoI+rwZZp20oIH
         VlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=YcD14cPLYHRqCUN9XMqsA1N9iI/pU6jOe1s6Rx79mLg=;
        b=70jIf7rmw/siMqieWuKK16ei6xxnv4WzZB80gnMiVNQ0JcaDPf/d9FSL4oTc4xql5s
         YgPZl6vN0jMpJPz/agkUZjzeC+ZthgxWg90RrfuhdjlHoeHeJlqGVdmCOLZS3ulhf5HY
         ixlbT9td4i2VCUkfeep2FwWKhZJOBfg+Llz5FCA4iyOGWRuKr7lnx0b0aby+5m5B2NEg
         UFJm+vk4kpz3JomtnUoURjaGYV8YJ9Jx3O5YbMpRfXaP/ELkZKbss/U4SBMtWgIXBeAc
         SDxIqcrJ1KCUcG6sO8HezrVG5H/U+53F/tyxHHwuvzAYKoPJ5u+tlD4K8rsp4Rf7phWW
         RLNw==
X-Gm-Message-State: AOAM5309KZL+eXOgMsqgW2KzHtIVc9CMTErylM6qah/oGqtm0mAKRfkj
        D2ayE/mn+zkl3QyW0zJlOVZus7VQBbU=
X-Google-Smtp-Source: ABdhPJyHiBIYgUmO1kHJu6ywpURyknS4uCXFRG4yfpCyMmM+FKVa0coTEtdb7K6OSSSwzo4ko7n3RPKzjxc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:90d5:0:b0:4e1:307c:d94a with SMTP id
 k21-20020aa790d5000000b004e1307cd94amr10184465pfk.38.1645834591703; Fri, 25
 Feb 2022 16:16:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:36 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-19-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 18/28] KVM: x86/mmu: Do remote TLB flush before dropping
 RCU in TDP MMU resched
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
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

When yielding in the TDP MMU iterator, service any pending TLB flush
before dropping RCU protections in anticipation of using the caller's RCU
"lock" as a proxy for vCPUs in the guest.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 42803d5dbbf9..ef594af246f5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -730,11 +730,11 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
 		return false;
 
 	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
-		rcu_read_unlock();
-
 		if (flush)
 			kvm_flush_remote_tlbs(kvm);
 
+		rcu_read_unlock();
+
 		if (shared)
 			cond_resched_rwlock_read(&kvm->mmu_lock);
 		else
-- 
2.35.1.574.g5d30c73bfb-goog

