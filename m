Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D565F17B5
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 02:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiJAA7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 20:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbiJAA7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 20:59:36 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC66D1AF924
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:25 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id l72-20020a63914b000000b00434ac6f8214so3703242pge.13
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=eHH9N5KGHEqvEJkVzA/2lRA7fGLp5p5N5cp+MpeWrmU=;
        b=oES2VGRX/fcHEWvWSMYz/FdTQ0OKgPYd4v+iN4OFWl1IvhmYESW3NBjbNFaIdJ/bc0
         epzv5I5/opNN4plUCwp/qYOtZv1DfDMXAZxiZyRZhrM7APaIVeu9uz5PhZzZiCld620J
         eyD8edykEHEnVYOFR8IuQaIveJekH4MhThfWDLI0ic9yXoOAHw233lq/UhVlKdQLCn/K
         mwqm0aU5pMBfaWIQjD8u6tcGNVwl+KBwWFIEh9j4+F06yIQZ0DhcO49ZsIOMeYMSt+9M
         59SWBXBkw97W1ZYknJpjSCFRrGzI2F0iek+X/4zV9nIcUaidiL1ZOqlNGALmqxy930Ky
         uieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=eHH9N5KGHEqvEJkVzA/2lRA7fGLp5p5N5cp+MpeWrmU=;
        b=KoHKzjqLzJP4yJ+9XXTEomA2V1+bJviWz87k80lYh0xgI4S2+t6gT6LBW54XCoBc8E
         iPbWazCsfqapiDY1FfODdfYd9WQEh24CXU30Vje5hNGidpv7CxdR7lO8/tX4BTsybiOt
         HE5Ci5a7xTtYk+YQfIL25fT4WYQLE0zUcwKYq4UShP0IfVlD1pr+fF5W0Zuj4QHaOTBV
         d+cwOaKzILzQ1p6z2BfwGFWjRkfuxuG5XOCZ28zkn6mWrMe7Bki7EQGi88cT71KJeL5G
         UZKlGelaH5syaFhigPa6H3/+aZMgbxOLqz0UyD+aUDAoIXg4IHdXzzySl+SZS0jsEdbK
         RzvQ==
X-Gm-Message-State: ACrzQf1v5GaBPkXjgl/XaGNBqSspAg7reR0tPIeW7F4h2JnNbDN4u7OI
        DrZ6k+7TOG25k7DKkxPRqzXt2Fi/xmc=
X-Google-Smtp-Source: AMsMyM6DwQfJMtryfb4tmACAzG5TUNWBuDoHaHgLRZczqgpN6QW9JK4bBXHGK5ix9mIsnS/ZONNBqmP68/w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4d2:b0:17d:d70:8045 with SMTP id
 o18-20020a170902d4d200b0017d0d708045mr3380998plg.73.1664585965378; Fri, 30
 Sep 2022 17:59:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:58:47 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-5-seanjc@google.com>
Subject: [PATCH v4 04/32] KVM: SVM: Process ICR on AVIC IPI delivery failure
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
2.38.0.rc1.362.ged0d419d3c-goog

