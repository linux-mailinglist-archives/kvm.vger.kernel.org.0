Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441AD6EF049
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 10:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240083AbjDZIcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 04:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239788AbjDZIca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 04:32:30 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649E13AB0;
        Wed, 26 Apr 2023 01:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1682497949; x=1714033949;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0iMjOB5JdJg/MykZ3p5xH1eehG9iZBRm7jiw5T8R1hQ=;
  b=soB+lMKoARApxY0xEdHtWX/EoZOkbcQh8Yayr84JlifKasoDzsF9PpzO
   SD6F4lXrQ9LA30ZK1e16WSma/nmZyn/3Szx6YoJ88/yar+Xc1/LIgFR6P
   keyYFu25fctQSVwTQjbSVw4eZZ5VV10ShUXyDOeTd+d2yHLUdiOAM3uBs
   w=;
X-IronPort-AV: E=Sophos;i="5.99,227,1677542400"; 
   d="scan'208";a="1126070119"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 08:32:12 +0000
Received: from EX19MTAUEB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com (Postfix) with ESMTPS id 02011415A4;
        Wed, 26 Apr 2023 08:32:11 +0000 (UTC)
Received: from EX19D008UEC002.ant.amazon.com (10.252.135.242) by
 EX19MTAUEB002.ant.amazon.com (10.252.135.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 26 Apr 2023 08:32:11 +0000
Received: from EX19MTAUEA001.ant.amazon.com (10.252.134.203) by
 EX19D008UEC002.ant.amazon.com (10.252.135.242) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 26 Apr 2023 08:32:11 +0000
Received: from dev-dsk-abusse-1c-9fba1bbe.eu-west-1.amazon.com (10.13.253.110)
 by mail-relay.amazon.com (10.252.134.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26 via Frontend Transport; Wed, 26 Apr 2023 08:32:10 +0000
From:   Anselm Busse <abusse@amazon.com>
CC:     <dwmw@amazon.co.uk>, <hborghor@amazon.de>, <sironi@amazon.de>,
        "Anselm Busse" <abusse@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: x86: Add a vCPU stat for #AC exceptions
Date:   Wed, 26 Apr 2023 08:26:01 +0000
Message-ID: <20230426082601.85372-1-abusse@amazon.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds a KVM vCPU stat that reflects the number of #AC
exceptions caused by a guest. This improves the identification and
debugging of issues that are possibly caused by guests triggering
split-locks and allows more insides compared to the current situation
of having only a warning printed when an #AC exception is raised.

Signed-off-by: Anselm Busse <abusse@amazon.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx/vmx.c          | 2 ++
 arch/x86/kvm/x86.c              | 1 +
 3 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 808c292ad3f4..b4ab719fbc69 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1523,6 +1523,7 @@ struct kvm_vcpu_stat {
 	u64 preemption_other;
 	u64 guest_mode;
 	u64 notify_window_exits;
+	u64 split_lock_exceptions;
 };
 
 struct x86_instruction_info;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d2d6e1b6c788..8f48fd8ddead 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5309,6 +5309,8 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		kvm_run->debug.arch.exception = ex_no;
 		break;
 	case AC_VECTOR:
+		vmx->vcpu.stat.split_lock_exceptions++;
+
 		if (vmx_guest_inject_ac(vcpu)) {
 			kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
 			return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3d852ce84920..416a1ed6c423 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -297,6 +297,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, preemption_other),
 	STATS_DESC_IBOOLEAN(VCPU, guest_mode),
 	STATS_DESC_COUNTER(VCPU, notify_window_exits),
+	STATS_DESC_COUNTER(VCPU, split_lock_exceptions),
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
-- 
2.39.2




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



