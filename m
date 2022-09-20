Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D680C5BF126
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbiITXcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiITXcH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:32:07 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F914786DA
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:57 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id v9-20020a17090a4ec900b00200bba6b0a1so1994838pjl.5
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=qGYDlw3EvdizUpemXeSoCeVsNs+yYIOG67hOKnUatms=;
        b=l7Lp5U5v/vd1ssIDwUNHnPXb9ZW/u+uQ0NJ5j+WkMA0ReEnXJ+qo0JZHET5P3xvlOl
         Fg+Q4rtb4+WKEbaCyFcEv8dJA/Hx3JBHATOB5eaXsxR9ios9ARXSYIi2/oieY81tyHLW
         zKaYeYPwP6GZABws7HiWrYOq4Ts0HKt6MOgHBuXYF5RAe4ZnugBVo59OwNRytjzjD8NH
         hpftrXpsncCCu80m98C/hHmL5jdQNxTf94xvD8NHs/vLWBsJeg9eOsSm/SuWgSMJsoQS
         iJmH94vInfEtxRfgRYqcC+UHb73fkeAy5qnzplKXHqtJTGD8eEyv+zsOxxT4j9B/5ZRD
         0E/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=qGYDlw3EvdizUpemXeSoCeVsNs+yYIOG67hOKnUatms=;
        b=BPeV5c7XpsWAQloLtSTF2NBt/feOCmgLke4RXcXh/BYvNwU9RnwunsNvb22C/yhohj
         yRreuSI/EXmIDWm3GCMa3ADXt27NkspLJ+OIX1zHcOv4pEAVUcBhCawEG7mjo4tOAMnr
         M2sjPBsN/NSd8ZyuNdQAm57TIRU2jTYklZFYlOTLHimVDcv5O6H2gwnUoX0hitmol+9s
         p4ZkfAGt0WtHB69DJT5yREAn0hq+ZjrVSYfOkp2ItYElZrCCnBg7TDB6sAF7Lflk0yqe
         FVUOzDeYaHIrhkc7rKTqoOLbHsm0uBua7MgWEMfQAfD7qMtrczSwVr0xEGtJ8ZxYnG4u
         K5vg==
X-Gm-Message-State: ACrzQf1HxMIPJHoucjqyXarDsLSUfayiLtMx34/x/aaYowj7HhLCvTFY
        AqAGQThG9foY0VMDKtJdewOggEJp8z8=
X-Google-Smtp-Source: AMsMyM4HNsJhYXHtBeAivKQvQTgv1IMYBwgEUlW7HSP+ZZQ3yIcOmiXAv64JsNyCa9P0thlXWKFzid9coy8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1181:b0:203:ae0e:6a21 with SMTP id
 gk1-20020a17090b118100b00203ae0e6a21mr405142pjb.0.1663716715884; Tue, 20 Sep
 2022 16:31:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:17 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-12-seanjc@google.com>
Subject: [PATCH v3 11/28] KVM: SVM: Fix x2APIC Logical ID calculation for avic_kick_target_vcpus_fast
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

For X2APIC ID in cluster mode, the logical ID is bit [15:0].

Fixes: 603ccef42ce9 ("KVM: x86: SVM: fix avic_kick_target_vcpus_fast")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index e9aab8ecce83..e35e9363e7ff 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -356,7 +356,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 
 		if (apic_x2apic_mode(source)) {
 			/* 16 bit dest mask, 16 bit cluster id */
-			bitmap = dest & 0xFFFF0000;
+			bitmap = dest & 0xFFFF;
 			cluster = (dest >> 16) << 4;
 		} else if (kvm_lapic_get_reg(source, APIC_DFR) == APIC_DFR_FLAT) {
 			/* 8 bit dest mask*/
-- 
2.37.3.968.ga6b4b080e4-goog

