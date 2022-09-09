Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2893D5B3483
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 11:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbiIIJvl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 05:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbiIIJvZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 05:51:25 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED67C59E7
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 02:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1662717037; x=1694253037;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9UeS6jOOBLEZxNcIS4bLIOSsYgu3lQHgS+uKe/NBl1A=;
  b=h/tGEGGvawrZ3GwYRqLUlGYKerdPGiDcS28N74Y0kNbJYWpLcvIQoixN
   bc4CEbkmZQbR+JLBqkQh4SgaFdVeCfvpojKJ6f5bGYKQc7XfiZr4RJNqi
   LCUmsDsKhG+xNVISU3z1k5j+7ahX2UB0poh0dldQ9BJ8TFzYAIYZceTJb
   g=;
X-IronPort-AV: E=Sophos;i="5.93,302,1654560000"; 
   d="scan'208";a="128419224"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-26daedd8.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 09:50:19 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-26daedd8.us-east-1.amazon.com (Postfix) with ESMTPS id 4CAE6E1275;
        Fri,  9 Sep 2022 09:50:18 +0000 (UTC)
Received: from EX19D008UEA002.ant.amazon.com (10.252.134.125) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 9 Sep 2022 09:50:17 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX19D008UEA002.ant.amazon.com (10.252.134.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 9 Sep 2022 09:50:17 +0000
Received: from dev-dsk-metikaya-1c-d447d167.eu-west-1.amazon.com
 (10.13.250.103) by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP
 Server (TLS) id 15.0.1497.38 via Frontend Transport; Fri, 9 Sep 2022 09:50:16
 +0000
From:   Metin Kaya <metikaya@amazon.co.uk>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC:     <x86@kernel.org>, <bp@alien8.de>, <dwmw@amazon.co.uk>,
        <seanjc@google.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <dave.hansen@linux.intel.com>, <joao.m.martins@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>
Subject: [PATCH 2/2] KVM: x86: Introduce kvm_gfn_to_hva_cache_valid()
Date:   Fri, 9 Sep 2022 09:50:06 +0000
Message-ID: <20220909095006.65440-2-metikaya@amazon.co.uk>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220909095006.65440-1-metikaya@amazon.co.uk>
References: <20220909095006.65440-1-metikaya@amazon.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It simplifies validation of gfn_to_hva_cache to make it less error prone
per the discussion at
https://lore.kernel.org/all/4e29402770a7a254a1ea8ca8165af641ed0832ed.camel@infradead.org.

Signed-off-by: Metin Kaya <metikaya@amazon.co.uk>
---
 arch/x86/kvm/x86.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 43a6a7efc6ec..07d368dc69ad 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3425,11 +3425,22 @@ void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_service_local_tlb_flush_requests);
 
+static inline bool kvm_gfn_to_hva_cache_valid(struct kvm *kvm,
+					      struct gfn_to_hva_cache *ghc,
+					      gpa_t gpa)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+
+	return !unlikely(slots->generation != ghc->generation ||
+			 gpa != ghc->gpa ||
+			 kvm_is_error_hva(ghc->hva) ||
+			 !ghc->memslot);
+}
+
 static void record_steal_time(struct kvm_vcpu *vcpu)
 {
 	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
 	struct kvm_steal_time __user *st;
-	struct kvm_memslots *slots;
 	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
 	u64 steal;
 	u32 version;
@@ -3445,11 +3456,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(current->mm != vcpu->kvm->mm))
 		return;
 
-	slots = kvm_memslots(vcpu->kvm);
-
-	if (unlikely(slots->generation != ghc->generation ||
-		     gpa != ghc->gpa ||
-		     kvm_is_error_hva(ghc->hva) || !ghc->memslot)) {
+	if (!kvm_gfn_to_hva_cache_valid(vcpu->kvm, ghc, gpa)) {
 		/* We rely on the fact that it fits in a single page. */
 		BUILD_BUG_ON((sizeof(*st) - 1) & KVM_STEAL_VALID_BITS);
 
@@ -4729,7 +4736,6 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 {
 	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
 	struct kvm_steal_time __user *st;
-	struct kvm_memslots *slots;
 	static const u8 preempted = KVM_VCPU_PREEMPTED;
 	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
 
@@ -4756,11 +4762,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	if (unlikely(current->mm != vcpu->kvm->mm))
 		return;
 
-	slots = kvm_memslots(vcpu->kvm);
-
-	if (unlikely(slots->generation != ghc->generation ||
-		     gpa != ghc->gpa ||
-		     kvm_is_error_hva(ghc->hva) || !ghc->memslot))
+	if (!kvm_gfn_to_hva_cache_valid(vcpu->kvm, ghc, gpa))
 		return;
 
 	st = (struct kvm_steal_time __user *)ghc->hva;
-- 
2.37.1

