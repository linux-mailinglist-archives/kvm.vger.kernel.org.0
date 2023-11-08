Return-Path: <kvm+bounces-1169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AF8C7E551E
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:22:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBE3B1C20DE6
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A2E4171CC;
	Wed,  8 Nov 2023 11:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="R0A3p8uD"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9140016400;
	Wed,  8 Nov 2023 11:21:52 +0000 (UTC)
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FD91BF3;
	Wed,  8 Nov 2023 03:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442512; x=1730978512;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oGmQSWddAE8KqMq8lmVDTRLTnkN/hdaUFRsiDOi+ttg=;
  b=R0A3p8uD3LsJkr+hknwGV/eFTPcdmhtskkROAvqShaRGrh3/7kuIY6J5
   E1ayrjy8yPpJDtg5MnX8hQfU94cr+Tn/JzSv3TLHJKJPtXnt4Vb6yc0uE
   RlmSPbWY/jS/ePgDiCUEHdcPNwDldtVccxL7H3IWSVm+B6ChCt736aqRr
   8=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="361603061"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:21:50 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com (Postfix) with ESMTPS id 9FEC448ED2;
	Wed,  8 Nov 2023 11:21:46 +0000 (UTC)
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:61983]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.4.34:2525] with esmtp (Farcaster)
 id 93cbfb2a-c5dc-4a75-bf0d-dbebc073ea77; Wed, 8 Nov 2023 11:21:45 +0000 (UTC)
X-Farcaster-Flow-ID: 93cbfb2a-c5dc-4a75-bf0d-dbebc073ea77
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:21:39 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:21:34 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 16/33] KVM: x86/mmu: Expose R/W/X flags during memory fault exits
Date: Wed, 8 Nov 2023 11:17:49 +0000
Message-ID: <20231108111806.92604-17-nsaenz@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231108111806.92604-1-nsaenz@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D043UWA003.ant.amazon.com (10.13.139.31) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Include the fault's read, write and execute status when exiting to
user-space.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/kvm/mmu/mmu.c   | 4 ++--
 include/linux/kvm_host.h | 9 +++++++--
 include/uapi/linux/kvm.h | 6 ++++++
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4e02d506cc25..feca077c0210 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4300,8 +4300,8 @@ static inline u8 kvm_max_level_for_order(int order)
 static void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 					      struct kvm_page_fault *fault)
 {
-	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
-				      PAGE_SIZE, fault->write, fault->exec,
+	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT, PAGE_SIZE,
+				      fault->write, fault->exec, fault->user,
 				      fault->is_private);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 71e1e8cf8936..631fd532c97a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2367,14 +2367,19 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
 static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 						 gpa_t gpa, gpa_t size,
 						 bool is_write, bool is_exec,
-						 bool is_private)
+						 bool is_read, bool is_private)
 {
 	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
 	vcpu->run->memory_fault.gpa = gpa;
 	vcpu->run->memory_fault.size = size;
 
-	/* RWX flags are not (yet) defined or communicated to userspace. */
 	vcpu->run->memory_fault.flags = 0;
+	if (is_read)
+		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_READ;
+	if (is_write)
+		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_WRITE;
+	if (is_exec)
+		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_EXECUTE;
 	if (is_private)
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 03f5c08fd7aa..0ddffb8b0c99 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -533,7 +533,13 @@ struct kvm_run {
 		} notify;
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
+#define KVM_MEMORY_EXIT_FLAG_READ	(1ULL << 0)
+#define KVM_MEMORY_EXIT_FLAG_WRITE	(1ULL << 1)
+#define KVM_MEMORY_EXIT_FLAG_EXECUTE	(1ULL << 2)
 #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
+#define KVM_MEMORY_EXIT_NO_ACCESS                            \
+	(KVM_MEMORY_EXIT_FLAG_NR | KVM_MEMORY_EXIT_FLAG_NW | \
+	 KVM_MEMORY_EXIT_FLAG_NX)
 			__u64 flags;
 			__u64 gpa;
 			__u64 size;
-- 
2.40.1


