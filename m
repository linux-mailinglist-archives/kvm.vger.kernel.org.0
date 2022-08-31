Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792395A72D2
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbiHaAiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbiHaAhe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:37:34 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850C7ABF25
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:36:15 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l9-20020a252509000000b00695eb4f1422so985008ybl.13
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=mC7usvSs3qaM/1NjRUjnPt+Y8usO4FtgvRtSkKXmhAg=;
        b=UjASSDAxTG4PE1j3D0JlQ0/fdhz4Hk48LTfPjtmcsIEHn2woxsrAql9G7dVL6V/Mjw
         32JZ0PjptfKpCTHBOMjdUtEi0Wubx6ju2M5wFAeZwxyp4mRCJwYPOayd7xwJfjxVWPaO
         Ib9mZir94VBaEEMnw4ZIijzxODYF8bxr3U8UUqEm9pvNXNmhC8mBmOYuWwTxeliPCoWM
         i2mq9WA8ijvCJQeK494hAX0pVi/Eq4ZALx1a+5KapA6N4UAQQ4naz3Kd4OkH2SbCQcT2
         w30EL8JvpniYrH2eee5HmU5YIfGtik9oWGxzlN2qJGLku1+QIW5+8iGDfTzz2FUzrq3L
         vZuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=mC7usvSs3qaM/1NjRUjnPt+Y8usO4FtgvRtSkKXmhAg=;
        b=3etNMUTIG4rfMUOfeYfbJBM4c+QVSqwIdw2mqzFbujw94Xg3SzAA21T1rUJHCMVQ0o
         jsQTy+C0sJLvyqKBXjqHviQs/c3eYlAFCK8mWh3QQaIPPEuVhPPfUCNwaurlkaXtFr2G
         t5UGPdOIgWegiRfgUuWy8k2Xx0mECQT2HZKCYg9lmSrgT1NOIA6xvPfd0l9XBepAHZR9
         mXYMMH8xUzUjKKyzdLtmmDqCK2EKBXg+BL9PT8OFEi2ZDMQmPxOy/29V+cmScDTEQLyQ
         pJsGOHvhb/dm8earMknZoRRbIlWsS5wgRDrSO/g7oGyqRMeRMXFxApCIjCFLyLAiRrmk
         EB+Q==
X-Gm-Message-State: ACgBeo2i1iGv63JWhJ2WaKvmHCmVL2QBbG242Z4kAlVJ7w+TxZQ3Q2Ce
        xs9Q8wKHrsMBFPYUFzyXdGT5zockLjw=
X-Google-Smtp-Source: AA6agR6pODNwn0E6mm4IQc6Uil8iSxn+UpHt2TrVO6ngOsFdoeXGC83cnibjIXnoJytq16bQaCNEDEuvN9Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:54c4:0:b0:329:d0e1:cfcf with SMTP id
 i187-20020a8154c4000000b00329d0e1cfcfmr16162287ywb.451.1661906134392; Tue, 30
 Aug 2022 17:35:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:35:02 +0000
In-Reply-To: <20220831003506.4117148-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831003506.4117148-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831003506.4117148-16-seanjc@google.com>
Subject: [PATCH 15/19] KVM: x86: Explicitly skip optimized logical map setup
 if vCPU's LDR==0
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly skip the optimized map setup if the vCPU's LDR is '0', i.e. if
the vCPU will never response to logical mode interrupts.  KVM already
skips setup in this case, but relies on kvm_apic_map_get_logical_dest()
to generate mask==0.  KVM still needs the mask=0 check as a non-zero LDR
can yield mask==0 depending on the mode, but explicitly handling the LDR
will make it simpler to clean up the logical mode tracking in the future.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c224b5c7cd92..8209caffe3ab 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -318,10 +318,12 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 			continue;
 
 		ldr = kvm_lapic_get_reg(apic, APIC_LDR);
+		if (!ldr)
+			continue;
 
 		if (apic_x2apic_mode(apic)) {
 			new->mode |= KVM_APIC_MODE_X2APIC;
-		} else if (ldr) {
+		} else {
 			ldr = GET_APIC_LOGICAL_ID(ldr);
 			if (kvm_lapic_get_reg(apic, APIC_DFR) == APIC_DFR_FLAT)
 				new->mode |= KVM_APIC_MODE_XAPIC_FLAT;
-- 
2.37.2.672.g94769d06f0-goog

