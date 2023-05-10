Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A0B6FE3BE
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 20:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbjEJSQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 14:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbjEJSQY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 14:16:24 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DB96A64;
        Wed, 10 May 2023 11:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683742581; x=1715278581;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X6rpPl3EZZnNDi/C9ULSOELL1+rnvyzEV/CbzP5prfs=;
  b=N/Vu3C2uvY4zj/SYuclrRZuiW7h6MCloNxwzcG8PVvtfV2JHVWen9jCL
   ZCk1NV8VHtoAIe0eYcCbyV7TiLcTDMmQ5mn9EEzOyraeju53lJsAsr6/h
   qqyiab0Uhp1dhIijYeLkhjy4kbAAkMhv578it3JU450eQMQYZfedbER0v
   s=;
X-IronPort-AV: E=Sophos;i="5.99,265,1677542400"; 
   d="scan'208";a="212881557"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 18:16:20 +0000
Received: from EX19MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id C7B9EC062F;
        Wed, 10 May 2023 18:16:19 +0000 (UTC)
Received: from EX19D002UWA002.ant.amazon.com (10.13.138.246) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 10 May 2023 18:16:18 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D002UWA002.ant.amazon.com (10.13.138.246) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 10 May 2023 18:16:18 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP
 Server id 15.2.1118.26 via Frontend Transport; Wed, 10 May 2023 18:16:17
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 60D73461D; Wed, 10 May 2023 18:16:17 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     <lee@kernel.org>, <seanjc@google.com>, <kvm@vger.kernel.org>,
        <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
        <pbonzini@redhat.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        Rishabh Bhatnagar <risbhat@amazon.com>,
        Allen Pais <apais@linux.microsoft.com>
Subject: [PATCH 4/9] KVM: x86: Remove obsolete disabling of page faults in kvm_arch_vcpu_put()
Date:   Wed, 10 May 2023 18:15:42 +0000
Message-ID: <20230510181547.22451-5-risbhat@amazon.com>
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

From: Sean Christopherson <seanjc@google.com>

commit 19979fba9bfaeab427a8e106d915f0627c952828 upstream.

Remove the disabling of page faults across kvm_steal_time_set_preempted()
as KVM now accesses the steal time struct (shared with the guest) via a
cached mapping (see commit b043138246a4, "x86/KVM: Make sure
KVM_VCPU_FLUSH_TLB flag is not missed".)  The cache lookup is flagged as
atomic, thus it would be a bug if KVM tried to resolve a new pfn, i.e.
we want the splat that would be reached via might_fault().

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210123000334.3123628-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
Tested-by: Allen Pais <apais@linux.microsoft.com>
Acked-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b0379ff4b743..4e77233880b7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4127,15 +4127,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	if (vcpu->preempted)
 		vcpu->arch.preempted_in_kernel = !kvm_x86_ops.get_cpl(vcpu);
 
-	/*
-	 * Disable page faults because we're in atomic context here.
-	 * kvm_write_guest_offset_cached() would call might_fault()
-	 * that relies on pagefault_disable() to tell if there's a
-	 * bug. NOTE: the write to guest memory may not go through if
-	 * during postcopy live migration or if there's heavy guest
-	 * paging.
-	 */
-	pagefault_disable();
 	/*
 	 * kvm_memslots() will be called by
 	 * kvm_write_guest_offset_cached() so take the srcu lock.
@@ -4143,7 +4134,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_steal_time_set_preempted(vcpu);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-	pagefault_enable();
 	kvm_x86_ops.vcpu_put(vcpu);
 	vcpu->arch.last_host_tsc = rdtsc();
 	/*
-- 
2.39.2

