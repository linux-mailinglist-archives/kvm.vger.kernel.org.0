Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E002502FA6
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 22:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351551AbiDOUS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 16:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345497AbiDOUSX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 16:18:23 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA463B3C7
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 13:15:54 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id j16-20020a056e02219000b002cbe5b76195so3229459ila.9
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 13:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2P7U2NEtS/Cp/THuiM6rLt3ESGgtGBw6Gg5JS/l1HlE=;
        b=ktBA0tSikHczq2jsT5qtlGoVcRRU+LeKZjJ4u0/Zq1rulIc8BvdmnVgI0WiHuM+qRv
         IKEb/rfSST/LULx3nOen8bgTVSQ1vMXRm/7ZmVq/+8bqRLrdjEIMjoZRFwWwqwl/eYxG
         7gybCPxoHtIJ6o3GMGHupHt9SLK/3X1jRQEvZxvxw7FL/DogcdJN3cgCWChiUesr/coD
         skyQba57JxMoOatXugBj6ve0CY5s/QYWEjC0BlxoecWgrjDsNaaFVb+N+YkghcQztTJE
         Uk9m6uqtAMQjO4juQbkA3pOXRy6ocC70oUNUdwfp0UQh/9aN6i60uDkLKYwyrhWTDwNB
         Nu8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2P7U2NEtS/Cp/THuiM6rLt3ESGgtGBw6Gg5JS/l1HlE=;
        b=iapEnNFiPkB70JjXdeJeR9lfY5Vnmjwno9mN1ac9BovYs0DLBsaj3HOaFPzycCaaEp
         5LkNRS7PDZ3PFL1kq/d1djSXSp2a094w3vcYtrgyvVR1ls7DQaf0NC1QapE0m7PrJptX
         A/q6gSRx+k4KxWTLghoinwg2AISa0nr1YE3GdyjRkIQA+hdTrZMPfyZylRuW1bspEHVy
         bspyFFYuzoPBIQ9hCAbPEEht6tLtMgHGQH1YK71EByKrz33hCCu2WlJnxWllDdF2viv2
         /iP8FxcL5YK3YeHCB6IRndRjk6qfyspkRTAOvtbvpqmETmRwXwSfkmTD5LFx7USYo1lL
         79aQ==
X-Gm-Message-State: AOAM533kfyTVex9m1HIcMFivrh0PvxYNZxLbQOXCH24VWH6oZ3VfXQxx
        2xKiHdL0Ix1dkyVJJ75bEcOo6JgIDgO+uDcvHDTa6QgQCI9g9s5H6MsOYHoujZieZlOI5TYBUsd
        xtcFnqRR/+e79Y9aYENoA5tmOEksypS2xLn95IA+dtv+ZunP4Di1EH8OIJQ==
X-Google-Smtp-Source: ABdhPJwWIM2QCoyFORiOq2O8Zlc32BElm/bMDJiqc7MA80gnPY6pSE62MySlc2E0fRwLbbKogCZV6wuIsGs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1607:b0:2cb:e6f7:a7bb with SMTP id
 t7-20020a056e02160700b002cbe6f7a7bbmr200350ilu.12.1650053753741; Fri, 15 Apr
 2022 13:15:53 -0700 (PDT)
Date:   Fri, 15 Apr 2022 20:15:42 +0000
In-Reply-To: <20220415201542.1496582-1-oupton@google.com>
Message-Id: <20220415201542.1496582-6-oupton@google.com>
Mime-Version: 1.0
References: <20220415201542.1496582-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH 5/5] KVM: Hoist debugfs_dentry init to kvm_create_vm_debugfs() (again)
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, maz@kernel.org,
        kvmarm@vger.kernel.org, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since KVM now sanely handles debugfs init/destroy w.r.t. the VM, it is
safe to hoist kvm_create_vm_debugfs() back into kvm_create_vm(). The
author of this commit remains bitter for having been burned by the old
wreck in commit a44a4cc1c969 ("KVM: Don't create VM debugfs files
outside of the VM directory").

Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 54793de42d14..61e727c15c1a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -958,6 +958,12 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 	snprintf(kvm->stats_id, sizeof(kvm->stats_id),
 			"kvm-%d", task_pid_nr(current));
 
+	/*
+	 * Force subsequent debugfs file creations to fail if the VM directory
+	 * is not created.
+	 */
+	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
+
 	if (!debugfs_initialized())
 		return 0;
 
@@ -1079,12 +1085,6 @@ static struct kvm *kvm_create_vm(unsigned long type, int fd)
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
-	/*
-	 * Force subsequent debugfs file creations to fail if the VM directory
-	 * is not created (by kvm_create_vm_debugfs()).
-	 */
-	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
-
 	if (init_srcu_struct(&kvm->srcu))
 		goto out_err_no_srcu;
 	if (init_srcu_struct(&kvm->irq_srcu))
-- 
2.36.0.rc0.470.gd361397f0d-goog

