Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6D24E461A
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 19:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238630AbiCVShQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 14:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236874AbiCVShO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 14:37:14 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7B43CFD3
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 11:35:46 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id h10-20020a92c26a000000b002c845c2b3d3so1530446ild.11
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 11:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tnmr6FcY2JLhce32y9oAbKJR7f3jp9JaOpVAL3BoK3A=;
        b=GxSnt/O3uM4E7Ryuar3lRQb3ZogNtuTF21itlU478JfimK/CQKTWdC9abGJl5jGsFh
         vsCpeMIIxraZrqRAwjKKOTB0V//WU8dg4cRVKC5Q0oAggoKE61LbaN2rbGZvkGP8/uOI
         j74qp5vzLIA/wwHG8BgfrxsjGVbP6uB+Zf/aYbxfEVInJprXmyWl37BtVnmB2T3XX6u1
         1rCCQ1bgNVvEq9m2lW4tSlCy3pGPNhFI7/hNOXDvATOYcr4EOtfhnIbMlmth4ZA3l6pq
         8WyopLOxPV6FWc3VIk5u2CKXW37WMVKpQ+2nVJy6NA9Y65KSYa++PFSfzbm7x68qpJ47
         G89g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tnmr6FcY2JLhce32y9oAbKJR7f3jp9JaOpVAL3BoK3A=;
        b=IaZOYuxyazbFcJGwFXfINHdWVssEzgX/9Tcd2icMnxGu/dVHPy3LPvEVvItpSm4v/w
         Qzjncd4IAGcBMhLUvP5ewHD7g7tlrL28C8ZmUoMJFJ+ntdbGz4wTBB2JdNqSVyq6kwNt
         Y8aSxjgta0z7TortQb4YLmomds5GK5sTKoS/Syle7D0LofxrnOt852rgWto8yXVwnMgr
         iQTLNTB5/0lk1cSU0iIlb/z9XsyEr3FB18j7mkdXC5C/62CaX8wLJCTYR7gf0ze6fEMc
         fbPL6fYt5DUtvGppG3Gcq35CKA+gusMy4rJXpU/vJHnbMzO4Bijly3nsPdEi0EEVO4mv
         XTYQ==
X-Gm-Message-State: AOAM531n8YQfEkeBBO4fiA8jbeML5CvpxrmEGRkP37LGSQ9ENGCygAvY
        GYLI8eUK4uInm8elikhJRBAGMsw8fJs=
X-Google-Smtp-Source: ABdhPJyqOQMpygQKbMQI+YxY6NGJvNzmxA9fxDwQQ/eBULRiqPtajRMzQcxcfqJ1BaMG0pno7t9pgoH7orM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:3e13:b0:321:446d:2977 with SMTP id
 co19-20020a0566383e1300b00321446d2977mr5465994jab.178.1647974146089; Tue, 22
 Mar 2022 11:35:46 -0700 (PDT)
Date:   Tue, 22 Mar 2022 18:35:37 +0000
In-Reply-To: <20220322183538.2757758-1-oupton@google.com>
Message-Id: <20220322183538.2757758-3-oupton@google.com>
Mime-Version: 1.0
References: <20220322183538.2757758-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 2/3] KVM: arm64: Actually prevent SMC64 SYSTEM_RESET2 from AArch32
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Oliver Upton <oupton@google.com>
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

The SMCCC does not allow the SMC64 calling convention to be used from
AArch32. While KVM checks to see if the calling convention is allowed in
PSCI_1_0_FN_PSCI_FEATURES, it does not actually prevent calls to
unadvertised PSCI v1.0+ functions.

Hoist the check to see if the requested function is allowed into
kvm_psci_call(), thereby preventing SMC64 calls from AArch32 for all
PSCI versions.

Fixes: d43583b890e7 ("KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest")
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index cd3ee947485f..d24ccc77500b 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -232,10 +232,6 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 	unsigned long val;
 	int ret = 1;
 
-	val = kvm_psci_check_allowed_function(vcpu, psci_fn);
-	if (val)
-		goto out;
-
 	switch (psci_fn) {
 	case PSCI_0_2_FN_PSCI_VERSION:
 		/*
@@ -303,7 +299,6 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 		break;
 	}
 
-out:
 	smccc_set_retval(vcpu, val, 0, 0, 0);
 	return ret;
 }
@@ -423,6 +418,15 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
  */
 int kvm_psci_call(struct kvm_vcpu *vcpu)
 {
+	u32 psci_fn = smccc_get_function(vcpu);
+	unsigned long val;
+
+	val = kvm_psci_check_allowed_function(vcpu, psci_fn);
+	if (val) {
+		smccc_set_retval(vcpu, val, 0, 0, 0);
+		return 1;
+	}
+
 	switch (kvm_psci_version(vcpu)) {
 	case KVM_ARM_PSCI_1_1:
 		return kvm_psci_1_x_call(vcpu, 1);
-- 
2.35.1.894.gb6a874cedc-goog

