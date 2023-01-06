Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2341965F8CC
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbjAFBOB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236846AbjAFBNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:13:40 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BEF72D24
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:13:38 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id pi14-20020a17090b1e4e00b0021d20da7a51so2105432pjb.2
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 17:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dY73TyImmD0wCqNL26nvzhCHfX8vBgtKvyMOXbN+v1I=;
        b=B861zubBIjRS4M7hrE2P/lP1yiAP6O9QSDe8ztqdzZ75i+UmjMLuMJpNqdL1Elk8v/
         RAAfOXEHLS8mwZoF3qdVZsbOy4/D5cBa1NaNov3OMq4WhgX+YWKDc18ZxIck79I1eX76
         1S9Dd/6XPyWvlMNYGUn+0Bxbfx7NM3Bb8F2MkBes6HJ441yQNZ9yJnSAr6SZrWwUMgF0
         F6fMSah5f8GauF6VTpl4lM81mhmTu8PAsbyUeUc8I9prYkJWnHInHrRzbBeahfU3Lci8
         NUNUa/xmwowTdGQxAb69BtM7JoxrsfzEZIYUinrzK/gKYn1gTY4gK8xbr8v0C/Ggak2O
         zMHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dY73TyImmD0wCqNL26nvzhCHfX8vBgtKvyMOXbN+v1I=;
        b=o/ksA5ZTAfntre7btfdSh0sXe5RGsYj6Q6zTSPsaEeYmpeNXCrAjnzM5wXMRElN5QG
         avpo80IpDeAxVlhegB2DC9ThOFNIivsSjbu4aipAuag/rZ90WjgAYHl3n/S/k4AchlmH
         0T+ZkMAfA6oHHppW7k1GviJRG97vwa1rSCaLqg2xY2WI5RVOgXZzpPtFRumTCTIYE6f/
         hQODv//4k4GkEdQ3Q9mIe79yV4l8WqQTQoN3S0CGVNrWrYh/G7UUMefaoOCldQW2bmEL
         iIM6Zb5eg1uOPZvqkTPt2VhFrD6BnZ4xV8Mmj0CpNrcJuLw+hLOkMUQakO0b6acXdD28
         AArg==
X-Gm-Message-State: AFqh2kpMf11gPePCj2BCBQ5STG8YYOMgYt8dWg8YtRso7T45Caf75ox1
        owve9+FkAM+ekvecaxwnonT9yMr+DVo=
X-Google-Smtp-Source: AMrXdXvXUwoPtx1VGD8IrsXsf3RNGjmLaGKsP+ZxpWSG6SVLX4nROauFHzf5Vp7o4I738ZRKSXgckNPWa9E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:999c:0:b0:582:74a2:1e4e with SMTP id
 k28-20020aa7999c000000b0058274a21e4emr1235081pfh.26.1672967617919; Thu, 05
 Jan 2023 17:13:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  6 Jan 2023 01:12:47 +0000
In-Reply-To: <20230106011306.85230-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230106011306.85230-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106011306.85230-15-seanjc@google.com>
Subject: [PATCH v5 14/33] Revert "KVM: SVM: Use target APIC ID to complete
 x2AVIC IRQs when possible"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>,
        Greg Edwards <gedwards@ddn.com>
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

Due to a likely mismerge of patches, KVM ended up with a superfluous
commit to "enable" AVIC's fast path for x2AVIC mode.  Even worse, the
superfluous commit has several bugs and creates a nasty local shadow
variable.

Rather than fix the bugs piece-by-piece[*] to achieve the same end
result, revert the patch wholesale.

Opportunistically add a comment documenting the x2AVIC dependencies.

This reverts commit 8c9e639da435874fb845c4d296ce55664071ea7a.

[*] https://lore.kernel.org/all/YxEP7ZBRIuFWhnYJ@google.com

Fixes: 8c9e639da435 ("KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible")
Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 0f67fd34ef99..e4b5f8b14882 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -378,7 +378,17 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 
 		logid_index = cluster + __ffs(bitmap);
 
-		if (!apic_x2apic_mode(source)) {
+		if (apic_x2apic_mode(source)) {
+			/*
+			 * For x2APIC, the logical APIC ID is a read-only value
+			 * that is derived from the x2APIC ID, thus the x2APIC
+			 * ID can be found by reversing the calculation (done
+			 * above).  Note, bits 31:20 of the x2APIC ID are not
+			 * propagated to the logical ID, but KVM limits the
+			 * x2APIC ID limited to KVM_MAX_VCPU_IDS.
+			 */
+			l1_physical_id = logid_index;
+		} else {
 			u32 *avic_logical_id_table =
 				page_address(kvm_svm->avic_logical_id_table_page);
 
@@ -393,23 +403,6 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 
 			l1_physical_id = logid_entry &
 					 AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK;
-		} else {
-			/*
-			 * For x2APIC logical mode, cannot leverage the index.
-			 * Instead, calculate physical ID from logical ID in ICRH.
-			 */
-			int cluster = (icrh & 0xffff0000) >> 16;
-			int apic = ffs(icrh & 0xffff) - 1;
-
-			/*
-			 * If the x2APIC logical ID sub-field (i.e. icrh[15:0])
-			 * contains anything but a single bit, we cannot use the
-			 * fast path, because it is limited to a single vCPU.
-			 */
-			if (apic < 0 || icrh != (1 << apic))
-				return -EINVAL;
-
-			l1_physical_id = (cluster << 4) + apic;
 		}
 	}
 
-- 
2.39.0.314.g84b9a713c41-goog

