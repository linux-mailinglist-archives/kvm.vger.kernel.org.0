Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C066A5ABBBA
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbiICAXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiICAXD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:23:03 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25477F63D7
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:03 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q7-20020a63e947000000b004297f1e1f86so1876787pgj.12
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=PIDwOUCtBewPHDMb4tVnQLyazdcuUyhDknKis4oP5e8=;
        b=b26qyh04/+cVHoGaCuXAqwfdfxKioKFeVh+lEW/sxDvmCTO3oJmQMLOMgwljALZBsD
         FkreDci/td/b1kRcO0MrT91dOY0G2C7HdUrjl3OuGNSQNupfaqWxDJ1yqXRCs7ZSrQMK
         0pJc/1N94lJJtFkXyrDq5C5+VgB/hFB3pyO2vh6Ke/KEijK7zzdp/upEqeBhKF56MwKE
         NZoLhOnkS1Uk2aT34zv2+SYjCHz4SPgYrJfFkrmrRT/SX9Lnp5aAt0vN7/pAukCI/sMW
         GvtL2RswZWw+4y3y55nOthTlNDXetxJviFpHoNwQkcO5cLiocnE6UYkq08ei5lETSpTa
         UzEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=PIDwOUCtBewPHDMb4tVnQLyazdcuUyhDknKis4oP5e8=;
        b=pXVWIVHvZyRhb/YAUbV0wEJ5LDBKMbDL+56ts9qZR4QD7kfWXkE20xZfr4yY3gHEeE
         vDrlTx2o+KwU0Nhyp8XeoSctZlxLv7vnuiFAQM9Lrl5Hq1a0X+Z2OcC5IAR8BGDto5lB
         rGA2HOwlVwps8/DdfWRXRfo5aGhOq7rL2M16mev4hmLpoJ9N10uVYU/cgcIZZkZLPXSh
         VdlordlAICoKqfEmgtJELVu71A33JHC/KNrnQBV5d/jpBZJb5p+bxtQWAEHPPnbzjV3b
         0YQiB49qdWjNemvWzYvmBV2Xx1Ilcmv9oWIzdWt7LoG3dARFPzcnmQNDJuaGw+GjIF8R
         wHTw==
X-Gm-Message-State: ACgBeo3pOQU8YZJTCNFup2c30WJvWKU5u6+nH/MJezaDL5FuKiSJ1UPI
        RVRB+2z3MXEaKqApGpF41OZBOtzVakw=
X-Google-Smtp-Source: AA6agR6zXdocaWASgpB6k/UriiG0R/4kTiatkYonZzlVvfDKIy93ifjp7qYZTXf0H124KMizSG68UQdKvQg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:b519:0:b0:537:9723:5cf2 with SMTP id
 y25-20020a62b519000000b0053797235cf2mr39060596pfe.15.1662164582631; Fri, 02
 Sep 2022 17:23:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:33 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-3-seanjc@google.com>
Subject: [PATCH v2 02/23] KVM: SVM: Flush the "current" TLB when activating AVIC
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

Flush the TLB when activating AVIC as the CPU can insert into the TLB
while AVIC is "locally" disabled.  KVM doesn't treat "APIC hardware
disabled" as VM-wide AVIC inhibition, and so when a vCPU has its APIC
hardware disabled, AVIC is not guaranteed to be inhibited.  As a result,
KVM may create a valid NPT mapping for the APIC base, which the CPU can
cache as a non-AVIC translation.

Note, Intel handles this in vmx_set_virtual_apic_mode().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6919dee69f18..4fbef2af1efc 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -86,6 +86,12 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 		/* Disabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, false);
 	} else {
+		/*
+		 * Flush the TLB, the guest may have inserted a non-APIC
+		 * mappings into the TLB while AVIC was disabled.
+		 */
+		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
+
 		/* For xAVIC and hybrid-xAVIC modes */
 		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 		/* Enabling MSR intercept for x2APIC registers */
-- 
2.37.2.789.g6183377224-goog

