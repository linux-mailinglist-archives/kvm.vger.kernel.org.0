Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1766FE3CB
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 20:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235905AbjEJSQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 14:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235765AbjEJSQe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 14:16:34 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37E77698;
        Wed, 10 May 2023 11:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683742588; x=1715278588;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=41i3jbGmoeeWlkvCpeZNVgWkZ+MKgPaHFhCZx7gtgyU=;
  b=fVg7YxnAui0yFNMkbLLsjWcqqFsvZSzEADDAdwTebmWyqfOI41hvfLFH
   wSGGEtTz+BF22txM6Z5njJZcAOTQlsE/hGxUIoGoWMc0mlPn4AOssV+rw
   OIDCkwS16aMCgm4+NlC+ZzFFKQ86JE7IUL6AnbRbAI5GLKrJf/15EDm2m
   E=;
X-IronPort-AV: E=Sophos;i="5.99,265,1677542400"; 
   d="scan'208";a="283772039"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 18:16:26 +0000
Received: from EX19MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com (Postfix) with ESMTPS id 9B56081A1E;
        Wed, 10 May 2023 18:16:23 +0000 (UTC)
Received: from EX19D002UWC004.ant.amazon.com (10.13.138.186) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 10 May 2023 18:16:18 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D002UWC004.ant.amazon.com (10.13.138.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 10 May 2023 18:16:17 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP
 Server id 15.2.1118.26 via Frontend Transport; Wed, 10 May 2023 18:16:17
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 7146A4622; Wed, 10 May 2023 18:16:17 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     <lee@kernel.org>, <seanjc@google.com>, <kvm@vger.kernel.org>,
        <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
        <pbonzini@redhat.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>,
        "Rishabh Bhatnagar" <risbhat@amazon.com>,
        Allen Pais <apais@linux.microsoft.com>
Subject: [PATCH 9/9] KVM: x86: move guest_pv_has out of user_access section
Date:   Wed, 10 May 2023 18:15:47 +0000
Message-ID: <20230510181547.22451-10-risbhat@amazon.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230510181547.22451-1-risbhat@amazon.com>
References: <20230510181547.22451-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 3e067fd8503d6205aa0c1c8f48f6b209c592d19c upstream.

When UBSAN is enabled, the code emitted for the call to guest_pv_has
includes a call to __ubsan_handle_load_invalid_value.  objtool
complains that this call happens with UACCESS enabled; to avoid
the warning, pull the calls to user_access_begin into both arms
of the "if" statement, after the check for guest_pv_has.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
Tested-by: Allen Pais <apais@linux.microsoft.com>
Acked-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8461aa63c251..5fbae8cc0697 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3049,9 +3049,6 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	}
 
 	st = (struct kvm_steal_time __user *)ghc->hva;
-	if (!user_access_begin(st, sizeof(*st)))
-		return;
-
 	/*
 	 * Doing a TLB flush here, on the guest's behalf, can avoid
 	 * expensive IPIs.
@@ -3060,6 +3057,9 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 		u8 st_preempted = 0;
 		int err = -EFAULT;
 
+		if (!user_access_begin(st, sizeof(*st)))
+			return;
+
 		asm volatile("1: xchgb %0, %2\n"
 			     "xor %1, %1\n"
 			     "2:\n"
@@ -3082,6 +3082,9 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 		if (!user_access_begin(st, sizeof(*st)))
 			goto dirty;
 	} else {
+		if (!user_access_begin(st, sizeof(*st)))
+			return;
+
 		unsafe_put_user(0, &st->preempted, out);
 		vcpu->arch.st.preempted = 0;
 	}
-- 
2.39.2

