Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83815FE408
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 23:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiJMVOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 17:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiJMVNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 17:13:48 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE9615F932
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:37 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id z24-20020a17090abd9800b0020d43dcc8c3so3952941pjr.9
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KzUT48wWdLM0GS1tdTWfSztOOLtqUcKTy+x0XSoy+nI=;
        b=LAIF/INbrCyeNVmFPXN31HCop+C55GkbkQAdu31lDBBbZyldCtI0Px2ohWMAfko3KW
         uVEBsbeNeIm6wfrNw+BitE0+3ZthLtt1vR3aukCaqBncbky/tOjkYitGzEU/RREjqImn
         hNJk0xArg74UBFBv05kP+Q9K9H/DCM+rZR9+Y0GSZ1f7WSSO5MCataZWJQJP6gVoeyva
         XEmpj3/onwVh9sKK9UobbuZyl45dLQw9emPpIpgz+tSFes72O1tgf52Qz8HXgOqmrpG9
         e1n2sxd8mZ9WtlaDl9RWbBtusVAVAYOLf3HYpuExEvu3NpzpSYi+pcFPezLh1Oy7FBDl
         a6tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KzUT48wWdLM0GS1tdTWfSztOOLtqUcKTy+x0XSoy+nI=;
        b=i07u8D+UepVc1SRpLeksDl/VP+7ZfRLPAjnza5AmJwYV8eckv6av/dk5L1EAMw63l+
         Q2zLTt5lJuzC37TV46xvzqvyK2EloKWs+jH29o+jgotBZGenQ0V+qiVV9yorHnlPRtRk
         Pmv5kXGvyYFWN7/DKWolVc7jXDlIppm3V3WPVbwPbZntzzItnj1rPFxo7Guz2U9hEhr5
         XIKOT5/dKTSvbNQvDmxmlo3U7J0xKm9idEeKaORAlIkKrFNqXY1Ed54ow4mufwVyj8XK
         gdVXt7DzgxCu2Si9ser/9w3t6rjUDMAfQROFV0kFuINza6k/ALmKYjViy7/LDoHp4cKG
         RNGA==
X-Gm-Message-State: ACrzQf3JFSF5jjfYSOafQ1g6cnLbfkXlXKn3Twkd+1behnJVhj0Ea23A
        pWOy999Rn7cTJ8CuZBC1PL6g2x90Qeo=
X-Google-Smtp-Source: AMsMyM5JBoOUAGVdNSV/5FiKvoxtt7Vpe+BjQGnE06c6G75bcw8EQpovg1arsWEkH694SxjG+GG67OVQYrA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d88a:b0:17f:713b:c753 with SMTP id
 b10-20020a170902d88a00b0017f713bc753mr1567056plz.37.1665695579062; Thu, 13
 Oct 2022 14:12:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 13 Oct 2022 21:12:30 +0000
In-Reply-To: <20221013211234.1318131-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221013211234.1318131-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221013211234.1318131-13-seanjc@google.com>
Subject: [PATCH v2 12/16] KVM: Do not partially reinitialize gfn=>pfn cache
 during activation
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw2@infradead.org>
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

Don't partially reinitialize a gfn=>pfn cache when activating the cache,
and instead assert that the cache is not valid during activation.  Bug
the VM if the assertion fails, as use-after-free and/or data corruption
is all but guaranteed if KVM ends up with a valid-but-inactive cache.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 62b47feed36c..2d5b417e50ac 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -342,6 +342,9 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
 	gpc->vcpu = vcpu;
 	gpc->usage = usage;
 	gpc->len = len;
+	gpc->pfn = KVM_PFN_ERR_FAULT;
+	gpc->uhva = KVM_HVA_ERR_BAD;
+
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_init);
 
@@ -350,10 +353,8 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
 	struct kvm *kvm = gpc->kvm;
 
 	if (!gpc->active) {
-		gpc->khva = NULL;
-		gpc->pfn = KVM_PFN_ERR_FAULT;
-		gpc->uhva = KVM_HVA_ERR_BAD;
-		gpc->valid = false;
+		if (KVM_BUG_ON(gpc->valid, kvm))
+			return -EIO;
 
 		spin_lock(&kvm->gpc_lock);
 		list_add(&gpc->list, &kvm->gpc_list);
-- 
2.38.0.413.g74048e4d9e-goog

