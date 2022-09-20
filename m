Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45F85BF149
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbiITXd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiITXdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:33:05 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16C178BD1
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:18 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id n10-20020a170902e54a00b001782663dcaeso2622116plf.18
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=OkHaILPvf1HA3nSnkTLahu7Ca4yPvuSnba/nduwob0E=;
        b=JH7dhQqG5zTordzAfDTjeeBqvOVulWkZMQkCj92ds5fDKJctEQpS1Sv3CkJnu1WTt/
         waumob7YC3YkW2No77geghKOYxno/ivyNgL6wfn0SiPGQikVvno2hyg+pIS0sS3D04yz
         YgCEq7sc+VX23Z0Y6bqT5ifVv9YSLKz0ncyH+ljSBH+GuihbAiJ/87bSM7UIiZe9nQlT
         vVJkhzpeopjaiYzSkDy1GFFxK1K2ir73Oro948CDDvtt3TAiafJh4oovyc6b1lvmDHnK
         IcrsgJ0OqqOPfJP0FwYuJv0+AND6N5/loC4otkORzVStY8tIeD7cscocVY9jojhQ8fXs
         5qlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=OkHaILPvf1HA3nSnkTLahu7Ca4yPvuSnba/nduwob0E=;
        b=Euy8C8RKPXgxeMA8OYOeyB4ZDGZ02Ndl6VRaaUKm7up7AdECU/SiqoSrShNchBD+Hv
         /1soh8qjONnP85M6iYl6QnJLVVYOF482l6HXOZywno/n2zaUuofuLFkBln6FR9SNdgyo
         8a3r/kXSwqes5i3s1gUnfcRDPYV4yXRy8WxVNgxprgEwfo+jOriKDpBf7H1V1Fstk54t
         wlQHZH6DP0xLCKDCS11ZCp+zhRfzVHYd7jzdvfJzf7iuv+o+/EYxbYmhX+DlOjQhrHDH
         6aBpW5CUGplziXxDp+LSQg9+F8dUPMWgOf12MC/sL+26luLyMiDbYRplrr4HFWWW5s3Q
         6G6g==
X-Gm-Message-State: ACrzQf2bY6IArenhWYH3MBh57WOvz81hQfkDwoSN2ZJbD0amks300fG/
        r9L+zgRCYVaoyHIGU5LZ4v639o05gnI=
X-Google-Smtp-Source: AMsMyM4R7AbZyJkDw21beG1HAE7KQ6sHhNkRMrKQLrpn+MKOwqmcxuUPKFb961xEmvUyQ/9ccIM+ko3AEnc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:230f:b0:53e:2c2c:5c03 with SMTP id
 h15-20020a056a00230f00b0053e2c2c5c03mr25714349pfh.11.1663716737387; Tue, 20
 Sep 2022 16:32:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:30 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-25-seanjc@google.com>
Subject: [PATCH v3 24/28] KVM: SVM: Update svm->ldr_reg cache even if LDR is "bad"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

Update SVM's cache of the LDR even if the new value is "bad".  Leaving
stale information in the cache can result in KVM missing updates and/or
invalidating the wrong entry, e.g. if avic_invalidate_logical_id_entry()
is triggered after a different vCPU has "claimed" the old LDR.

Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 2b640c73f447..4b6fc9d64f4d 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -539,23 +539,24 @@ static u32 *avic_get_logical_id_entry(struct kvm_vcpu *vcpu, u32 ldr, bool flat)
 	return &logical_apic_id_table[index];
 }
 
-static int avic_ldr_write(struct kvm_vcpu *vcpu, u8 g_physical_id, u32 ldr)
+static void avic_ldr_write(struct kvm_vcpu *vcpu, u8 g_physical_id, u32 ldr)
 {
 	bool flat;
 	u32 *entry, new_entry;
 
+	if (!ldr)
+		return;
+
 	flat = kvm_lapic_get_reg(vcpu->arch.apic, APIC_DFR) == APIC_DFR_FLAT;
 	entry = avic_get_logical_id_entry(vcpu, ldr, flat);
 	if (!entry)
-		return -EINVAL;
+		return;
 
 	new_entry = READ_ONCE(*entry);
 	new_entry &= ~AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK;
 	new_entry |= (g_physical_id & AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK);
 	new_entry |= AVIC_LOGICAL_ID_ENTRY_VALID_MASK;
 	WRITE_ONCE(*entry, new_entry);
-
-	return 0;
 }
 
 static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
@@ -575,7 +576,6 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
 
 static void avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 {
-	int ret = 0;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
 	u32 id = kvm_xapic_id(vcpu->arch.apic);
@@ -589,11 +589,8 @@ static void avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 
 	avic_invalidate_logical_id_entry(vcpu);
 
-	if (ldr)
-		ret = avic_ldr_write(vcpu, id, ldr);
-
-	if (!ret)
-		svm->ldr_reg = ldr;
+	svm->ldr_reg = ldr;
+	avic_ldr_write(vcpu, id, ldr);
 }
 
 static void avic_handle_dfr_update(struct kvm_vcpu *vcpu)
-- 
2.37.3.968.ga6b4b080e4-goog

