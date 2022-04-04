Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E7E4F1BBC
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381104AbiDDVWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380366AbiDDTsF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 15:48:05 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C047631230
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 12:46:08 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id p3-20020a056a0026c300b004fe25be54ffso419744pfw.11
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 12:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=pT/6Qdmm3tGb7HLrr7GqjKevauNrm0C8oEo/kdSI0ug=;
        b=DX180veywuwX26kBGb4IS3QvBU35h9XvsRIASvum61dFNYnZS7OLefgyf3qPP6lGa4
         XxRYSgT9bKas8WCz2qeYHpQgwwHAvjjwMV/0RkSxZZDuGBbLyCWfeG2wsJNDLl8Q0mOw
         xnWozmkr/vUAQX1nIDMRbYoIXIDdxhBtPqaE9y91l1qaKqWp1k6cIXnK5YT738jdyKGv
         TNpopmpt42kRQfuoCfxV7Az+dss4alEDWfSv07wkZcFASxV4k0ByUOxrNcpLR3mf35hi
         Y8DfkY9vRnLwM9bVRvbJih55QTFyzYqcAKzs2z4cuYO+exrc0fD59Y/+lIajydhE/0vH
         2PwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=pT/6Qdmm3tGb7HLrr7GqjKevauNrm0C8oEo/kdSI0ug=;
        b=f4C6ZhyvnyWO0OSHa1ywtupM0ObAM2+SNN4lZNTqk6XdWEZfhxBAC6FcQAgL+w4LOQ
         uY62NvW6yGGkIiXEOxP+NfV7qLpjs/BwwV0grbhea0b4+fIvbXaBld8cSx65KCbVgdri
         gbdEjUpG5llNbMpH8SToJKTJUVlVuoo2DLlMA6GQspkiVexTVM7XgMUBULcfUbS45g46
         FJAs0IgTkymq0MUxo2xpTKUThfwDxDNHvxvFnkTmlmlwUfGrEKLePyVbkgYjGCU2refc
         SXz12Uh3twvkl7Oa0Ns+tXrfEM9w/heKw88Y+v/V3dNrU8ippQbr21uM3RZZYiEvFu9N
         Wafw==
X-Gm-Message-State: AOAM530N/sODfQqP7ZrVREJEumf5Xkev5YrwsU+PaMnel6qrOZEBkRmS
        UQM0oqJofKb6t/4NHXBNa6HnPT/VMulfr4RZhuphqWscG+EPpMxZAT/0va6P/3PNGNXJO4cteli
        MR0ixuVjynGOzogpcdh/7VEFKODAyoqjQs0OHjdOpRquXYRYr4n34YUgUyw==
X-Google-Smtp-Source: ABdhPJwfcqk6KaaBz0Oi+OSkD69vCvSBFe18Kal7m0AgXBWa7DktPfr3Jda+1wNf7qEamm9U33+gjllt6Hs=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:805:a056:1a51:2b9e])
 (user=pgonda job=sendgmr) by 2002:a17:902:f54c:b0:154:6794:ab18 with SMTP id
 h12-20020a170902f54c00b001546794ab18mr1280283plf.118.1649101568063; Mon, 04
 Apr 2022 12:46:08 -0700 (PDT)
Date:   Mon,  4 Apr 2022 12:46:05 -0700
Message-Id: <20220404194605.1569855-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH] KVM: SEV: Mark nested locking of vcpu->lock
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        John Sperbeck <jsperbeck@google.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
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

svm_vm_migrate_from() uses sev_lock_vcpus_for_migration() to lock all
source and target vcpu->locks. Mark the nested subclasses to avoid false
positives from lockdep.

Fixes: b56639318bb2b ("KVM: SEV: Add support for SEV intra host migration")
Reported-by: John Sperbeck<jsperbeck@google.com>
Suggested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---

Tested by running sev_migrate_tests with lockdep enabled. Before we see
a warning from sev_lock_vcpus_for_migration(). After we get no warnings.

---
 arch/x86/kvm/svm/sev.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75fa6dd268f0..8f77421c1c4b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1591,15 +1591,16 @@ static void sev_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
 	atomic_set_release(&src_sev->migration_in_progress, 0);
 }
 
-
-static int sev_lock_vcpus_for_migration(struct kvm *kvm)
+static int sev_lock_vcpus_for_migration(struct kvm *kvm, unsigned int *subclass)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long i, j;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (mutex_lock_killable(&vcpu->mutex))
+		if (mutex_lock_killable_nested(&vcpu->mutex, *subclass))
 			goto out_unlock;
+
+		++(*subclass);
 	}
 
 	return 0;
@@ -1717,6 +1718,7 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	struct kvm *source_kvm;
 	bool charged = false;
 	int ret;
+	unsigned int vcpu_mutex_subclass = 0;
 
 	source_kvm_file = fget(source_fd);
 	if (!file_is_kvm(source_kvm_file)) {
@@ -1745,10 +1747,10 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 		charged = true;
 	}
 
-	ret = sev_lock_vcpus_for_migration(kvm);
+	ret = sev_lock_vcpus_for_migration(kvm, &vcpu_mutex_subclass);
 	if (ret)
 		goto out_dst_cgroup;
-	ret = sev_lock_vcpus_for_migration(source_kvm);
+	ret = sev_lock_vcpus_for_migration(source_kvm, &vcpu_mutex_subclass);
 	if (ret)
 		goto out_dst_vcpu;
 
-- 
2.35.1.1094.g7c7d902a7c-goog

