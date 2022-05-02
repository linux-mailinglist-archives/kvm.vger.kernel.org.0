Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069C451753B
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 18:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353113AbiEBRCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 13:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350851AbiEBRCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 13:02:09 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCFB6148
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 09:58:40 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id v8-20020a170902b7c800b0015e927ee201so1671356plz.12
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 09:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=bPx4uFSnc14yK8QTU/QEz0rdJyrogPiWttuTKlYBjBw=;
        b=Qwbi3YniGcw+A+s7IOlUFx7dzRTqP2JZQYXQBah7k5tLMg/Mjq5gKYiLjvhOJJSqmn
         +7UPgTqf/omglpT3nftLpmilF/NwSTftkx9l64Eh8XmCA4YR9WJVtrvxjrLnrrhKFzSm
         NtmkEyQuiMcN/zzRyiSebm22aIsD1kV44OOG132zJ/Bnn4LCTNhAGyA2iZeledgKRKg2
         C9p5VrvrjbNMQaefgRfQ1P6780BOJbB/K18QQeESeVPovL6eX/PSVcr+YyMtGOeg1BRd
         Urv2vr9FHcTbhHZdr9wbZZ4P6GzQ1lDRILuojWGgHAxffEQ4uRDcQvxC6sll+5O8Qu1o
         9n3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=bPx4uFSnc14yK8QTU/QEz0rdJyrogPiWttuTKlYBjBw=;
        b=yF9zlcwa/Uag3gfiE+6HNVVrkbp67VL2d/xzAeU0GsaYlXIihT+sF9jvfelUk5h6+6
         EAIlZSp5xsddn+6DmOS32GrMyKtMXxHYDaC318Inx5qCySWNq0vzrVwPTltSz64c2fPS
         WaDbVutnClXQBcmu2DU0Zsw2O4xAotMIfTFjC0RdinQR949IXTIop2wilYfFFRJQsp9X
         vMlo499IiVOfmuaC6tEdYS7nbBFdDcmbn/FYvVLHXcmh8tRohwDDrsC4A16yahorEOxV
         1yaZI5FByEnAVLwNmtnZYXI6HFQZTiJ/QkupM3EqgxxmjRLobtYQRlffo7aYymCnFm+A
         nRog==
X-Gm-Message-State: AOAM531qv3ETnu/p3047I9yXRnr3zwj3xMMtQpK9gWJNy870l6a8/EFI
        0jQMdEuXXhhkIefUguBK+Uc/vh3s31sH6TInO21fHj/IGztUXABPNSG7JEODjRGVA2Ddzi4nvMG
        nsrmsEnVRlqP0+DC73u4L30APVS/Pc3tnmMEvTJ6gUoD/U3KeLcz2vFp1MA==
X-Google-Smtp-Source: ABdhPJzjhh/6LjTaauro8zl2Yor4TiNpnia0tJxk7Gu6fIKG7L7M+LcVnTGo4t8ZQ8KWcpmRpBCQXVMkO30=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:a504:c712:edfe:ed97])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:1d8f:b0:50d:cbc5:ff90 with SMTP id
 z15-20020a056a001d8f00b0050dcbc5ff90mr11545687pfw.50.1651510719447; Mon, 02
 May 2022 09:58:39 -0700 (PDT)
Date:   Mon,  2 May 2022 09:58:07 -0700
Message-Id: <20220502165807.529624-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v4] KVM: SEV: Mark nested locking of vcpu->lock
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        John Sperbeck <jsperbeck@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Hillf Danton <hdanton@sina.com>, linux-kernel@vger.kernel.org
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

svm_vm_migrate_from() uses sev_lock_vcpus_for_migration() to lock all
source and target vcpu->locks. Unfortunately there is an 8 subclass
limit, so a new subclass cannot be used for each vCPU. Instead maintain
ownership of the first vcpu's mutex.dep_map using a role specific
subclass: source vs target. Release the other vcpu's mutex.dep_maps.

Fixes: b56639318bb2b ("KVM: SEV: Add support for SEV intra host migration")
Reported-by: John Sperbeck<jsperbeck@google.com>
Suggested-by: David Rientjes <rientjes@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Peter Gonda <pgonda@google.com>

---

V4
 * Due to 8 subclass limit keep dep_map on only the first vcpu and
   release the others.

V3
 * Updated signature to enum to self-document argument.
 * Updated comment as Seanjc@ suggested.

Tested by running sev_migrate_tests with lockdep enabled. Before we see
a warning from sev_lock_vcpus_for_migration(). After we get no warnings.

---
 arch/x86/kvm/svm/sev.c | 46 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75fa6dd268f0..0239def64eaa 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1591,24 +1591,55 @@ static void sev_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
 	atomic_set_release(&src_sev->migration_in_progress, 0);
 }
 
+/*
+ * To suppress lockdep false positives, subclass all vCPU mutex locks by
+ * assigning even numbers to the source vCPUs and odd numbers to destination
+ * vCPUs based on the vCPU's index.
+ */
+enum sev_migration_role {
+	SEV_MIGRATION_SOURCE = 0,
+	SEV_MIGRATION_TARGET,
+	SEV_NR_MIGRATION_ROLES,
+};
 
-static int sev_lock_vcpus_for_migration(struct kvm *kvm)
+static int sev_lock_vcpus_for_migration(struct kvm *kvm,
+					enum sev_migration_role role)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long i, j;
+	bool first = true;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (mutex_lock_killable(&vcpu->mutex))
+		if (mutex_lock_killable_nested(&vcpu->mutex, role))
 			goto out_unlock;
+
+		if (first) {
+			/*
+			 * Reset the role to one that avoids colliding with
+			 * the role used for the first vcpu mutex.
+			 */
+			role = SEV_NR_MIGRATION_ROLES;
+			first = false;
+		} else {
+			mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
+		}
 	}
 
 	return 0;
 
 out_unlock:
+
+	first = true;
 	kvm_for_each_vcpu(j, vcpu, kvm) {
 		if (i == j)
 			break;
 
+		if (first)
+			first = false;
+		else
+			mutex_acquire(&vcpu->mutex.dep_map, role, 0, _THIS_IP_);
+
+
 		mutex_unlock(&vcpu->mutex);
 	}
 	return -EINTR;
@@ -1618,8 +1649,15 @@ static void sev_unlock_vcpus_for_migration(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
+	bool first = true;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (first)
+			first = false;
+		else
+			mutex_acquire(&vcpu->mutex.dep_map,
+				      SEV_NR_MIGRATION_ROLES, 0, _THIS_IP_);
+
 		mutex_unlock(&vcpu->mutex);
 	}
 }
@@ -1745,10 +1783,10 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 		charged = true;
 	}
 
-	ret = sev_lock_vcpus_for_migration(kvm);
+	ret = sev_lock_vcpus_for_migration(kvm, SEV_MIGRATION_SOURCE);
 	if (ret)
 		goto out_dst_cgroup;
-	ret = sev_lock_vcpus_for_migration(source_kvm);
+	ret = sev_lock_vcpus_for_migration(source_kvm, SEV_MIGRATION_TARGET);
 	if (ret)
 		goto out_dst_vcpu;
 
-- 
2.36.0.464.gb9c8b46e94-goog

