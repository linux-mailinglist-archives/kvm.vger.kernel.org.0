Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D810C5C055E
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 19:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiIURgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 13:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiIURgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 13:36:10 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEE4A2A8B
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:36:08 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-33dc888dc62so57487217b3.4
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=s6QFMlEt4rpo0Hr0B2Mg5ed+0kOUCmHtnPtKeQ4gfJs=;
        b=g8iLnCm6jB9cLBwUrxXEpli9TfE+x2hLxI06XC7MnVpwe2yp+Ei/YjoH49BQMkPS05
         pH55ry9SiaQ4+w0IBATnI5kFAnnKqDrrqRM0bJlrkUR/tDRUpfqD6yXA1HQQTOdE64EI
         NZrGbhCr/jYYuBJctr8cDBYE7RdzcH7rT1vFUlKIaGp5bmLgFeWaASyXMsCUXdT4OjyO
         wyUgkO1J2No3PS3AZy+S4WOp4ZtH958o/KzpwW9/0UueC2G091owolHBavek/yQufVXk
         PY9tMumxSzUyVgfcFsl5UXf5UqeRDth39lY9TSj/EkXZx50XWuTQtE53/+fm7670mzky
         1aCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=s6QFMlEt4rpo0Hr0B2Mg5ed+0kOUCmHtnPtKeQ4gfJs=;
        b=eGCOCDIQfkrs3nJqZz46j+LWPdL7phAj2ZnNBdLrgWIZ0qyCVf54ipM1qN3rLk85FI
         Bdp/GTXFvs8XlIQSk0ynOW8oqeC8LqgdP62VwdDa4KU7Hkh/Qtweshhtq3DL2xbME6UI
         0AttgtPeNdlTuY2JThtuM48OXpjmSOqaP0BJfMu7fDgFSXJa2qFkiuR9wAglDzXzjUcP
         gXjfRC8elJNXVU4KJ3RKJJ5DemeH7NOFskpWDcMm0IO4fdzunfFwg8SIZQUTlu2q33DW
         KLB1Eea8teBHcM0DA2jBizexGW1Atp1ohsWuGAR59EkaPbvR8hpG9BsiqIANJylyBA5F
         WNdQ==
X-Gm-Message-State: ACrzQf3k+tvLX6sKMTcntS4zL36oJLJLOLeG+AbBN3qcppJNF6NzI29L
        D/pkcS96rKEfPdxZvgwV6rSxhjcA+qijKQ==
X-Google-Smtp-Source: AMsMyM4z/wX8rpVvwJHkpKCWMq1zV6f4cPYJXEyP3bZBEHeIXeTRsPjSP0wwr6FGk63doiaY4v+xMEdupk7AYQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:5484:0:b0:6b0:2e41:7659 with SMTP id
 i126-20020a255484000000b006b02e417659mr26131403ybb.339.1663781767985; Wed, 21
 Sep 2022 10:36:07 -0700 (PDT)
Date:   Wed, 21 Sep 2022 10:35:45 -0700
In-Reply-To: <20220921173546.2674386-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220921173546.2674386-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220921173546.2674386-10-dmatlack@google.com>
Subject: [PATCH v3 09/10] KVM: x86/mmu: Stop needlessly making MMU pages
 available for TDP MMU faults
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Peter Xu <peterx@redhat.com>
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

Stop calling make_mmu_pages_available() when handling TDP MMU faults.
The TDP MMU does not participate in the "available MMU pages" tracking
and limiting so calling this function is unnecessary work when handling
TDP MMU faults.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b36f351138f7..4ad70fa371df 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4343,10 +4343,6 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 	if (is_page_fault_stale(vcpu, fault))
 		goto out_unlock;
 
-	r = make_mmu_pages_available(vcpu);
-	if (r)
-		goto out_unlock;
-
 	r = kvm_tdp_mmu_map(vcpu, fault);
 
 out_unlock:
-- 
2.37.3.998.g577e59143f-goog

