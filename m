Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49775BF11D
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiITXb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiITXbp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:31:45 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330B76CD38
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:44 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-34d2a92912dso31063047b3.14
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=ii5+t2J1kdVlIL2oCH8a9ZWauh1L3o8t5CyE0vSQ86k=;
        b=X6jyBR8gbiSDrjF7c2UmvI5Mtcb5y5B97vdgUoLZpQ5be0M3KnBrz2gC5R1m9HqyVu
         AaakNuinnj1/DuqFzzRKVqPAT0CXticUWJuipURkSnLSvd7p/HCiL8i/xZ1/yxG/Ny1Q
         kdqDlguKfpCOEkWrBNNhQapSe85/q53mMoTVEaggmp6Rw2O8jVKdAdoY4enM0SH/te7o
         VbhZ9WsfoE5HcHUWGeqdhV0bIU1loNWRsEbSWfd22WzuUSnkyjqSZgL0oyXdPak3JcdM
         TNNUesUfySYM9im5kaC4LdY5UcYoc6HFHB1PcxOzGJGfa29ORiHeoDDYrc3R15dWzOp3
         ITlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=ii5+t2J1kdVlIL2oCH8a9ZWauh1L3o8t5CyE0vSQ86k=;
        b=rUVMZS46gxP9UdplxFn1JJFeSB0bDg58S1BBoVyy9HN5O1y4Lt0TDj/Rpr9FnylDkH
         Z6nNFuRbI+qpmgnkx8eXDrUlr35sgZ9Mm6s6MDJjma5Pb25L9tIZtscwUZg7lLPMSrBX
         s/q4i1LeXvHuuH4+o65GK9U+ug8j3wri+y/u+v+Le1FuVJOeK+rAepS390DhyVY9d9yB
         2WDAIXWwxI+lGn9QzBQxTBr7V3gy0UtWgCHZzrfQTMIvfhE91Hj/Mx/wtePfZSg/Lwfq
         2bs8LwWcf+Gj9EdifkMb6yhp2GsMZdAKiRnrejZ156+aCiDf24xTAmuGsWl0kIJHu6BH
         TDww==
X-Gm-Message-State: ACrzQf04NCYtvZVCtTHsYKuq9Ngvlvtx/LOS2l4xiHIbxIa5Zh0/LiGU
        aM7D9vFr40al6ZeAWsNkn8XaRQb/tic=
X-Google-Smtp-Source: AMsMyM5aqFW6j2Vta21H0hUIHt8J/uBmwFMbLr8ZsZ6TK90bt9AX+Kc6P+Mp8Hrzi9XZH20nMTE5Qr8OoSE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:c4b:0:b0:6ae:ca4a:59e5 with SMTP id
 d11-20020a5b0c4b000000b006aeca4a59e5mr21501052ybr.246.1663716703528; Tue, 20
 Sep 2022 16:31:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:10 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-5-seanjc@google.com>
Subject: [PATCH v3 04/28] KVM: SVM: Process ICR on AVIC IPI delivery failure
 due to invalid target
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

Emulate ICR writes on AVIC IPI failures due to invalid targets using the
same logic as failures due to invalid types.  AVIC acceleration fails if
_any_ of the targets are invalid, and crucially VM-Exits before sending
IPIs to targets that _are_ valid.  In logical mode, the destination is a
bitmap, i.e. a single IPI can target multiple logical IDs.  Doing nothing
causes KVM to drop IPIs if at least one target is valid and at least one
target is invalid.

Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
Cc: stable@vger.kernel.org
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 712330b80891..3b2c88b168ba 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -502,14 +502,18 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 	trace_kvm_avic_incomplete_ipi(vcpu->vcpu_id, icrh, icrl, id, index);
 
 	switch (id) {
+	case AVIC_IPI_FAILURE_INVALID_TARGET:
 	case AVIC_IPI_FAILURE_INVALID_INT_TYPE:
 		/*
 		 * Emulate IPIs that are not handled by AVIC hardware, which
-		 * only virtualizes Fixed, Edge-Triggered INTRs.  The exit is
-		 * a trap, e.g. ICR holds the correct value and RIP has been
-		 * advanced, KVM is responsible only for emulating the IPI.
-		 * Sadly, hardware may sometimes leave the BUSY flag set, in
-		 * which case KVM needs to emulate the ICR write as well in
+		 * only virtualizes Fixed, Edge-Triggered INTRs, and falls over
+		 * if _any_ targets are invalid, e.g. if the logical mode mask
+		 * is a superset of running vCPUs.
+		 *
+		 * The exit is a trap, e.g. ICR holds the correct value and RIP
+		 * has been advanced, KVM is responsible only for emulating the
+		 * IPI.  Sadly, hardware may sometimes leave the BUSY flag set,
+		 * in which case KVM needs to emulate the ICR write as well in
 		 * order to clear the BUSY flag.
 		 */
 		if (icrl & APIC_ICR_BUSY)
@@ -525,8 +529,6 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 		 */
 		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh, index);
 		break;
-	case AVIC_IPI_FAILURE_INVALID_TARGET:
-		break;
 	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
 		WARN_ONCE(1, "Invalid backing page\n");
 		break;
-- 
2.37.3.968.ga6b4b080e4-goog

