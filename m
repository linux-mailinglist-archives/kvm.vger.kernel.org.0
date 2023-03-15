Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0206BA50E
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 03:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjCOCSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 22:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbjCOCSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 22:18:07 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE33BE1B7
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:05 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id w14-20020a25ac0e000000b00b369c36c165so11624220ybi.6
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678846685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F0Mb5w0ZCF8Y3aayRysDLjn/DNgIzbtfOXDWe3H9Orw=;
        b=onNUU+LqXD/kfgHXV7HsW6g3sUblWEfqaPYUGPiATDPjKj12rg+7nlz69F304YkiUQ
         vj6CPyyxDWJyK0eF9VZMpNlsDBDLIIYL/08XYkWoMyyC/1PSyyqwaSJtjzhF+wp2kqJM
         F19Z3HdWDZ30vN9FFic+lGcvLeEcniGdyVcdcu4XiUjkyjZoWa2gawqh+wR2TshCEHiB
         z0qiXeR0iyPGLwiVTTXjJt/nTHdZme03PALBlh8lx6EQx7tfo/VHd8hK9KRROIPzaTlo
         37YXFAhA4Pe5q3MtXZ91/lwqSQLYxoTssMDt2HigIyQxJzf8o11Wr8sag++4HAjlZd0u
         gURQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678846685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F0Mb5w0ZCF8Y3aayRysDLjn/DNgIzbtfOXDWe3H9Orw=;
        b=wfh2vOvXR01eXoMoAivRDU86vP+bff+m+Z5+x5gW9e4IVfKP3EzQ6QI90IvWjw+kod
         tV9mRM31D5nNzZuE7dY0Pgw9RYm6WVPFt2FnVCGVsvkZ2QLFcC3HN8Jo33Go+4sV29t1
         14bJsAi7XD26sYM1z1eDhu/boSq8jBfMkMfuDNLykYIBLQgtuZUSB1D/DJX9or26rFAJ
         BYH5fqyphdLhY3oUrc/6QMU7JCTt/bBNaRY8SHEt74wpZlW5sMlh7/frstdIJEzVSsHt
         WjJoiCUgiacxDmiFuQdnQrVsWbTEeOnQmr2nl/aCWoIy8V7zG2XIDddKRzKEIWQuwngq
         EH/w==
X-Gm-Message-State: AO0yUKXzV3qwr/Y0widHb+4hLfKlKU5cnFId4kHh4RpJ0Ov1inOATUXO
        L31d3ijvi1yAmLbCYZnuDDhFz10/Cv6gsg==
X-Google-Smtp-Source: AK7set98+f39ohth03C+Fyu6+B0Kpd5LRFCya2w5WV/rKIQHdL4gASrczEpM9VjlLMw//lBMgNLg0fhMxux3tQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:ed06:0:b0:540:e6c5:5118 with SMTP id
 k6-20020a81ed06000000b00540e6c55118mr10158746ywm.2.1678846685481; Tue, 14 Mar
 2023 19:18:05 -0700 (PDT)
Date:   Wed, 15 Mar 2023 02:17:29 +0000
In-Reply-To: <20230315021738.1151386-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315021738.1151386-6-amoorthy@google.com>
Subject: [WIP Patch v2 05/14] KVM: x86: Implement memory fault exit for direct_map
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com
Cc:     jthoughton@google.com, kvm@vger.kernel.org,
        Anish Moorthy <amoorthy@google.com>
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

TODO: The return value of this function is ignored in
kvm_arch_async_page_ready. Make sure that the side effects of
memory_fault_exit_or_efault are acceptable there.
---
 arch/x86/kvm/mmu/mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8ebe542c565f..0b02e2c360c08 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3193,7 +3193,10 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	}
 
 	if (WARN_ON_ONCE(it.level != fault->goal_level))
-		return -EFAULT;
+		return kvm_memfault_exit_or_efault(
+			vcpu, fault->gfn * PAGE_SIZE,
+			KVM_PAGES_PER_HPAGE(fault->goal_level),
+			KVM_MEMFAULT_REASON_UNKNOWN);
 
 	ret = mmu_set_spte(vcpu, fault->slot, it.sptep, ACC_ALL,
 			   base_gfn, fault->pfn, fault);
-- 
2.40.0.rc1.284.g88254d51c5-goog

