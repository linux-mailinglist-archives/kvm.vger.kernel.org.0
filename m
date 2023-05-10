Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858456FE3BC
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 20:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbjEJSQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 14:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjEJSQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 14:16:21 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8715FEF;
        Wed, 10 May 2023 11:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683742580; x=1715278580;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5Ds7mSqwag+N+EQuUEK2PDr8cfDEE8mIZ1PGiViQ7cw=;
  b=gij9VWQs3iFWGYa+DPtqT8WlUfp00/+8aALoM8BM93iDDaDYJ/aLvUhp
   bNt9k+JzB7BptIVfVge36gik1Z3UHJstw7xJBmR3rN0QrzL3r4piVrZia
   rmPhnrOvGbAiRCEEOx7ffoagW8NSSxjdSIU4zXosh22DgSg107ZZ5/v9a
   g=;
X-IronPort-AV: E=Sophos;i="5.99,265,1677542400"; 
   d="scan'208";a="337789830"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 18:16:19 +0000
Received: from EX19MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id 6DE1CC062F;
        Wed, 10 May 2023 18:16:18 +0000 (UTC)
Received: from EX19D002UWA004.ant.amazon.com (10.13.138.230) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 10 May 2023 18:16:18 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D002UWA004.ant.amazon.com (10.13.138.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 10 May 2023 18:16:17 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP
 Server id 15.2.1118.26 via Frontend Transport; Wed, 10 May 2023 18:16:17
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 566CFF00; Wed, 10 May 2023 18:16:17 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     <lee@kernel.org>, <seanjc@google.com>, <kvm@vger.kernel.org>,
        <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
        <pbonzini@redhat.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Rishabh Bhatnagar <risbhat@amazon.com>,
        Allen Pais <apais@linux.microsoft.com>
Subject: [PATCH 1/9] KVM: x86: Ensure PV TLB flush tracepoint reflects KVM behavior
Date:   Wed, 10 May 2023 18:15:39 +0000
Message-ID: <20230510181547.22451-2-risbhat@amazon.com>
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

From: Lai Jiangshan <laijs@linux.alibaba.com>

commit af3511ff7fa2107d6410831f3d71030f5e8d2b25 upstream.

In record_steal_time(), st->preempted is read twice, and
trace_kvm_pv_tlb_flush() might output result inconsistent if
kvm_vcpu_flush_tlb_guest() see a different st->preempted later.

It is a very trivial problem and hardly has actual harm and can be
avoided by reseting and reading st->preempted in atomic way via xchg().

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>

Message-Id: <20210531174628.10265-1-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
Tested-by: Allen Pais <apais@linux.microsoft.com>
Acked-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0ccc8d1b972c..60bf007f4118 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3039,9 +3039,11 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	 * expensive IPIs.
 	 */
 	if (guest_pv_has(vcpu, KVM_FEATURE_PV_TLB_FLUSH)) {
+		u8 st_preempted = xchg(&st->preempted, 0);
+
 		trace_kvm_pv_tlb_flush(vcpu->vcpu_id,
-				       st->preempted & KVM_VCPU_FLUSH_TLB);
-		if (xchg(&st->preempted, 0) & KVM_VCPU_FLUSH_TLB)
+				       st_preempted & KVM_VCPU_FLUSH_TLB);
+		if (st_preempted & KVM_VCPU_FLUSH_TLB)
 			kvm_vcpu_flush_tlb_guest(vcpu);
 	} else {
 		st->preempted = 0;
-- 
2.39.2

