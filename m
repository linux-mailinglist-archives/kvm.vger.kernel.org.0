Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19B37BED61
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 23:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378717AbjJIV30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 17:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378727AbjJIV3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 17:29:24 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC165A9
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 14:29:22 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c62ce4b431so40871015ad.2
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 14:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696886962; x=1697491762; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bYkvhBthhHqIlQG5LO3kogv7cSVxxNevxV9LcQnZMPA=;
        b=rFYxNkk9qBXjJBvBs+kYp2Ta1CjsEtXbIyjVgdqBaXOpgQc4NN/J98TdGfl2jD0/un
         nAVwwYtR4y5Tv0HZPi7ns1azUjlRkdA4ZdxRD+MzaPsN+kPGiBg1ZY9vgw+dOF5G8F5+
         4hrAMG749yzkGYpBDW1PwrowN4SRJDrL+EWigl+FU//7GnfXDRBXO2BpNYBWEYCBlVjT
         fBPIubJ4WUqbfWRlE95SxuqBb76FmfHHVOt8MIomSEuHt0Dc6/KRKEkne5rS38TH0fOp
         H7YzYlPhMk8E9Kr8YQ9VcIK9kferNJeItfXK0EOJx+Uq1cIOZhu3Uyne8V7ujeu5jwxy
         dIeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696886962; x=1697491762;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bYkvhBthhHqIlQG5LO3kogv7cSVxxNevxV9LcQnZMPA=;
        b=GDxA3lrQGj+GE/Y2es4R0rerxIjK6NJjzyXl62NSoqJ+HmSocEc6+mJIe5tU5wPsE9
         yAd6GWLHYGS4zC+gUQEGEVyIFNT5KMNJ4ovul4lb3qBIB4EriVhoKZqgmJB3w9YjRrhA
         jMAZod8VqQnzUL1oQFvZ+Fi58CgNBkyohKv3ykuyyr8wlnfE1EKcUGy8T3eFR32AAiqQ
         CeNhIeqmMAJo2Cj6WehAGiIH5S93SFJ5JsLfFAzKpaQAjWHEI2VaXjeb2Lhul689yInc
         czzoOZsp2j49fHueGh13aBi+LuBXX4DJlGlv9ubwcVC9nJCJDL/T+SsqnS28hBGp9K7f
         L8wQ==
X-Gm-Message-State: AOJu0Yw92GYjLQoNEWLUYcSQhoQN/78RY2ufOMbRiElxHTyMeEMOL3X9
        SKoh4csMmkxIhYzFvITVoAzLLwpBI0I=
X-Google-Smtp-Source: AGHT+IGZpWvOoc8BX66UE4VBkl6KxlHJlAQkh6Xvg8C6hwcONGyuAe8Zf6gbKb/YTmJVDrE6kAnwwxYGlLo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c8:b0:1c1:fc5c:b32e with SMTP id
 o8-20020a170902d4c800b001c1fc5cb32emr276837plg.10.1696886962172; Mon, 09 Oct
 2023 14:29:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  9 Oct 2023 14:29:19 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <20231009212919.221810-1-seanjc@google.com>
Subject: [PATCH] KVM: SVM: Don't intercept IRET when injecting NMI and vNMI is enabled
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When vNMI is enabled, rely entirely on hardware to correctly handle NMI
blocking, i.e. don't intercept IRET to detect when NMIs are no longer
blocked.  KVM already correctly ignores svm->nmi_masked when vNMI is
enabled, so the effect of the bug is essentially an unnecessary VM-Exit.

Note, per the APM, hardware sets the BLOCKING flag when software directly
directly injects an NMI:

  If Event Injection is used to inject an NMI when NMI Virtualization is
  enabled, VMRUN sets V_NMI_MASK in the guest state.

Fixes: fa4c027a7956 ("KVM: x86: Add support for SVM's Virtual NMI")
Link: https://lore.kernel.org/all/ZOdnuDZUd4mevCqe@google.como
Cc: Santosh Shukla <santosh.shukla@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Santosh, can you verify that I didn't break vNMI?  I don't have access to the
right hardware.  Thanks!

 arch/x86/kvm/svm/svm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b7472ad183b9..4f22d12b5d60 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3569,8 +3569,15 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 	if (svm->nmi_l1_to_l2)
 		return;
 
-	svm->nmi_masked = true;
-	svm_set_iret_intercept(svm);
+	/*
+	 * No need to manually track NMI masking when vNMI is enabled, hardware
+	 * automatically sets V_NMI_BLOCKING_MASK as appropriate, including the
+	 * case where software directly injects an NMI.
+	 */
+	if (!is_vnmi_enabled(svm)) {
+		svm->nmi_masked = true;
+		svm_set_iret_intercept(svm);
+	}
 	++vcpu->stat.nmi_injections;
 }
 

base-commit: 86701e115030e020a052216baa942e8547e0b487
-- 
2.42.0.609.gbb76f46606-goog

