Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBF154A1AA
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 23:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348713AbiFMVms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 17:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240307AbiFMVmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 17:42:47 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD2360F7
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 14:42:46 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id y2-20020a655b42000000b0040014afa54cso3921939pgr.21
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 14:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=RVy85ULONsPMosb1NmFt3NRY87u30o0irh/ZWjWjAQQ=;
        b=SEpiP60SyyDEf/Tnm3zpDuQbs8gKvGqZQWxGmHhqNnIx2TWH/CkGAZ9qantBF7CRk6
         a+mFjO2HObwDwvtZzU62OBzinGjx0MP01SfwVdRTRSFOoyxBVLH29eEbdeRYE423f9xF
         Kl7aaN0WWWwrEbZ7SzaEYVhle5y6gfBRLn2dRSuMQwWAIbtMaDQaJqEINEK1YclQi3Pq
         gwdYCsX72hMjPUGj7PQXWFrDRhuhvPK47GWICbL/v/nmgRvnjGnJuKVSx2r4BxQkgEno
         NMC7vp5Op6Ui4qJahNYCLavsZN7o7hfmv147En8DCOyi82LSOxm6QHeXQnKRAFt/NOHi
         n0Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=RVy85ULONsPMosb1NmFt3NRY87u30o0irh/ZWjWjAQQ=;
        b=n7xmqYontuBaoCFxUDuOec6VTBV1EhzfihmYPj4+GBQapy/lHukMn3DBI053uSJDZa
         5iqUp52Llv6Tj+j15bsCRkEPRHzurJRObPA6aW7Xa9e6SkaUGAxoHhY26lkm6he1SmEn
         JUSrvmoGZKdVdBik54ZQJ7+YdLlC7Oahz/EKaZCuboj7F9/nBzWIRRodUt2JeXZp4cvk
         eVdvM6XVWXphLxNE3jbu9iaZF+S8bj5ogyPyhIE/LaSH8fpcgBH5npDn8hGFsTqywake
         QL8HNKJjLC4CYLVDwPqwfb7EDWHrlnK6XMTC3GMiMidMk/csRQ3oYrrZuhh2ArjKBlAJ
         7hwA==
X-Gm-Message-State: AJIora9WyPJRRVQC7aThg2JP/at9XTZT2w50e1areTuhlh9GtB57o2sd
        DDIJsNn0CHQ626FvqJsLDSi0uBl0KeU=
X-Google-Smtp-Source: AGRyM1urKA7NScvmeBtxVRmnJcZPpHOq5ewz3AmNrW84SUP+NUFAo6x/+herBNp05LNlC6l+fSWyWo0gPnY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:178f:b0:1e3:3ba:c185 with SMTP id
 q15-20020a17090a178f00b001e303bac185mr47660pja.1.1655156565067; Mon, 13 Jun
 2022 14:42:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 13 Jun 2022 21:42:37 +0000
Message-Id: <20220613214237.2538266-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH] KVM: SVM: Hide SEV migration lockdep goo behind CONFIG_DEBUG_LOCK_ALLOC
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Tom Rix <trix@redhat.com>,
        kvm@vger.kernel.org, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>
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

Wrap the manipulation of @role and the manual mutex_{release,acquire}()
invocations in CONFIG_PROVE_LOCKING=y to squash a clang-15 warning.  When
building with -Wunused-but-set-parameter and CONFIG_DEBUG_LOCK_ALLOC=n,
clang-15 seees there's no usage of @role in mutex_lock_killable_nested()
and yells.  PROVE_LOCKING selects DEBUG_LOCK_ALLOC, and the only reason
KVM manipulates @role is to make PROVE_LOCKING happy.

To avoid true ugliness, use "i" and "j" to detect the first pass in the
loops; the "idx" field that's used by kvm_for_each_vcpu() is guaranteed
to be '0' on the first pass as it's simply the first entry in the vCPUs
XArray, which is fully KVM controlled.  kvm_for_each_vcpu() passes '0'
for xa_for_each_range()'s "start", and xa_for_each_range() will not enter
the loop if there's no entry at '0'.

Fixes: 0c2c7c069285 ("KVM: SEV: Mark nested locking of vcpu->lock")
Reported-by: kernel test robot <lkp@intel.com>
Cc: Peter Gonda <pgonda@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Compile tested only, still haven't figured out why SEV is busted on our
test systems with upstream kernels.  I also haven't verified this squashes
the clang-15 warning, so a thumbs up on that end would be helpful.

 arch/x86/kvm/svm/sev.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 51fd985cf21d..309bcdb2f929 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1606,38 +1606,35 @@ static int sev_lock_vcpus_for_migration(struct kvm *kvm,
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long i, j;
-	bool first = true;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (mutex_lock_killable_nested(&vcpu->mutex, role))
 			goto out_unlock;
 
-		if (first) {
+#ifdef CONFIG_PROVE_LOCKING
+		if (!i)
 			/*
 			 * Reset the role to one that avoids colliding with
 			 * the role used for the first vcpu mutex.
 			 */
 			role = SEV_NR_MIGRATION_ROLES;
-			first = false;
-		} else {
+		else
 			mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
-		}
+#endif
 	}
 
 	return 0;
 
 out_unlock:
 
-	first = true;
 	kvm_for_each_vcpu(j, vcpu, kvm) {
 		if (i == j)
 			break;
 
-		if (first)
-			first = false;
-		else
+#ifdef CONFIG_PROVE_LOCKING
+		if (j)
 			mutex_acquire(&vcpu->mutex.dep_map, role, 0, _THIS_IP_);
-
+#endif
 
 		mutex_unlock(&vcpu->mutex);
 	}

base-commit: 8baacf67c76c560fed954ac972b63e6e59a6fba0
-- 
2.36.1.476.g0c4daa206d-goog

