Return-Path: <kvm+bounces-32007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47BDA9D10C6
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 13:42:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88B88B260E3
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 12:42:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67FD319CC2A;
	Mon, 18 Nov 2024 12:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="uMUpSHMT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76E6190468;
	Mon, 18 Nov 2024 12:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731933658; cv=none; b=YbBh1Hxodj/Dr+6e1175rpe5Unsyum+O6msolZVkKhaCp1sy9uHsVAKM6oo1cL6iEa3fwmpH28BIE9P5yT5xHRJrmUuXJlZtvAJ63ElxrRbLMuEzPtk7bKuZYWSZAOMhasMxyWLmVH0wn8p7xahYMG6SOJk7O+mPRiZWGDuW66c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731933658; c=relaxed/simple;
	bh=ue9FtTHkIf0O26WBxVlWInbp9GnN2JW/zSBON5bdtt0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ixdcmEjumbf9GymoOalZZbrIzIq07pcgzE0cJY5Na7U8kQDOVbZDRHtnE0I5rJViYevxo2KLAhTTMUGmyvj+mLrTVrFG36OGVpbMdX6R00X6XDOrYYJ9O8OFGaaU6oq1rCgiy65O1AHf69qE+D9SXLyPX1JyYiO2antXLWTlzoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=uMUpSHMT; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1731933657; x=1763469657;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ykhv5KGCLiLl2yV3bclkR2RpJ6v/6kUiGVl7nYaMM3g=;
  b=uMUpSHMTVmJvYsx0cMbPY9MmkWrzot6kb2zerrtlWul53wSGAB9dqzBI
   cCzkxk+SkzTPNVARCNA80kM+tcV7THMoRh9Z6xZ538MKTIkOBBUEZZKic
   n5aTFt2V37mItxzGasObjeiAm7amy9jPtmkfiSf+qBNY9oKm8tVk+3i/u
   k=;
X-IronPort-AV: E=Sophos;i="6.12,164,1728950400"; 
   d="scan'208";a="148483206"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 12:40:55 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:58933]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.38.94:2525] with esmtp (Farcaster)
 id 1b0522d1-c98b-42f4-917e-56c1a88600cf; Mon, 18 Nov 2024 12:40:55 +0000 (UTC)
X-Farcaster-Flow-ID: 1b0522d1-c98b-42f4-917e-56c1a88600cf
Received: from EX19D003UWC001.ant.amazon.com (10.13.138.144) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 18 Nov 2024 12:40:48 +0000
Received: from EX19MTAUWC002.ant.amazon.com (10.250.64.143) by
 EX19D003UWC001.ant.amazon.com (10.13.138.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Mon, 18 Nov 2024 12:40:48 +0000
Received: from email-imr-corp-prod-pdx-all-2c-619df93b.us-west-2.amazon.com
 (10.25.36.210) by mail-relay.amazon.com (10.250.64.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Mon, 18 Nov 2024 12:40:48 +0000
Received: from dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com (dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com [172.19.103.116])
	by email-imr-corp-prod-pdx-all-2c-619df93b.us-west-2.amazon.com (Postfix) with ESMTPS id A5766404F6;
	Mon, 18 Nov 2024 12:40:44 +0000 (UTC)
From: Nikita Kalyazin <kalyazin@amazon.com>
To: <pbonzini@redhat.com>, <seanjc@google.com>, <corbet@lwn.net>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <rostedt@goodmis.org>,
	<mhiramat@kernel.org>, <mathieu.desnoyers@efficios.com>,
	<kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
CC: <jthoughton@google.com>, <david@redhat.com>, <peterx@redhat.com>,
	<oleg@redhat.com>, <vkuznets@redhat.com>, <gshan@redhat.com>,
	<graf@amazon.de>, <jgowans@amazon.com>, <roypat@amazon.co.uk>,
	<derekmn@amazon.com>, <nsaenz@amazon.es>, <xmarcalx@amazon.com>,
	<kalyazin@amazon.com>
Subject: [RFC PATCH 4/6] KVM: trace events: add type argument to async pf
Date: Mon, 18 Nov 2024 12:39:46 +0000
Message-ID: <20241118123948.4796-5-kalyazin@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20241118123948.4796-1-kalyazin@amazon.com>
References: <20241118123948.4796-1-kalyazin@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

With async PF user being added, in order to reuse existing tracepoint
definitions and distinguish async PF user from kernel, a new int
argument `type` is being added that can be either 0 ("kernel") or 1
("user").

For now all of the users of these tracepoints supply 0 ("kernel") as
async PF user are not yet implemented.  In the next commits when they
are implemented, the tracepoints user will set this to 1 ("user") as
necessary.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
---
 arch/x86/kvm/mmu/mmu.c     |  4 +--
 arch/x86/kvm/x86.c         |  4 +--
 include/trace/events/kvm.h | 50 ++++++++++++++++++++++++--------------
 virt/kvm/async_pf.c        |  2 +-
 4 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f0dbc3c68e5c..004e068cabae 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4395,9 +4395,9 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
 
 	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
-		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
+		trace_kvm_try_async_get_page(fault->addr, fault->gfn, 0);
 		if (kvm_find_async_pf_gfn(vcpu, fault->gfn)) {
-			trace_kvm_async_pf_repeated_fault(fault->addr, fault->gfn);
+			trace_kvm_async_pf_repeated_fault(fault->addr, fault->gfn, 0);
 			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
 			return RET_PF_RETRY;
 		} else if (kvm_arch_setup_async_pf(vcpu, fault)) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 800493739043..0a04de5dbada 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13408,7 +13408,7 @@ bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 {
 	struct x86_exception fault;
 
-	trace_kvm_async_pf_not_present(work->arch.token, work->cr2_or_gpa);
+	trace_kvm_async_pf_not_present(work->arch.token, work->cr2_or_gpa, 0);
 	kvm_add_async_pf_gfn(vcpu, work->arch.gfn);
 
 	if (kvm_can_deliver_async_pf(vcpu) &&
@@ -13447,7 +13447,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 		work->arch.token = ~0; /* broadcast wakeup */
 	else
 		kvm_del_async_pf_gfn(vcpu, work->arch.gfn);
-	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
+	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa, 0);
 
 	if ((work->wakeup_all || work->notpresent_injected) &&
 	    kvm_pv_async_pf_enabled(vcpu) &&
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 74e40d5d4af4..a7731b62863b 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -256,90 +256,104 @@ TRACE_EVENT(kvm_fpu,
 );
 
 #ifdef CONFIG_KVM_ASYNC_PF
+#define kvm_async_pf_type_symbol	\
+	{0, "kernel"},		\
+	{1, "user"}
+
 DECLARE_EVENT_CLASS(kvm_async_get_page_class,
 
-	TP_PROTO(u64 gva, u64 gfn),
+	TP_PROTO(u64 gva, u64 gfn, int type),
 
-	TP_ARGS(gva, gfn),
+	TP_ARGS(gva, gfn, type),
 
 	TP_STRUCT__entry(
 		__field(__u64, gva)
 		__field(u64, gfn)
+		__field(int, type)
 	),
 
 	TP_fast_assign(
 		__entry->gva = gva;
 		__entry->gfn = gfn;
+		__entry->type = type;
 	),
 
-	TP_printk("gva = %#llx, gfn = %#llx", __entry->gva, __entry->gfn)
+	TP_printk("gva = %#llx, gfn = %#llx, type = %s", __entry->gva,
+		__entry->gfn, __print_symbolic(__entry->type,
+		kvm_async_pf_type_symbol))
 );
 
 DEFINE_EVENT(kvm_async_get_page_class, kvm_try_async_get_page,
 
-	TP_PROTO(u64 gva, u64 gfn),
+	TP_PROTO(u64 gva, u64 gfn, int type),
 
-	TP_ARGS(gva, gfn)
+	TP_ARGS(gva, gfn, type)
 );
 
 DEFINE_EVENT(kvm_async_get_page_class, kvm_async_pf_repeated_fault,
 
-	TP_PROTO(u64 gva, u64 gfn),
+	TP_PROTO(u64 gva, u64 gfn, int type),
 
-	TP_ARGS(gva, gfn)
+	TP_ARGS(gva, gfn, type)
 );
 
 DECLARE_EVENT_CLASS(kvm_async_pf_nopresent_ready,
 
-	TP_PROTO(u64 token, u64 gva),
+	TP_PROTO(u64 token, u64 gva, int type),
 
-	TP_ARGS(token, gva),
+	TP_ARGS(token, gva, type),
 
 	TP_STRUCT__entry(
 		__field(__u64, token)
 		__field(__u64, gva)
+		__field(int, type)
 	),
 
 	TP_fast_assign(
 		__entry->token = token;
 		__entry->gva = gva;
+		__entry->type = type;
 	),
 
-	TP_printk("token %#llx gva %#llx", __entry->token, __entry->gva)
+	TP_printk("token %#llx gva %#llx type %s", __entry->token, __entry->gva,
+		__print_symbolic(__entry->type, kvm_async_pf_type_symbol))
 
 );
 
 DEFINE_EVENT(kvm_async_pf_nopresent_ready, kvm_async_pf_not_present,
 
-	TP_PROTO(u64 token, u64 gva),
+	TP_PROTO(u64 token, u64 gva, int type),
 
-	TP_ARGS(token, gva)
+	TP_ARGS(token, gva, type)
 );
 
 DEFINE_EVENT(kvm_async_pf_nopresent_ready, kvm_async_pf_ready,
 
-	TP_PROTO(u64 token, u64 gva),
+	TP_PROTO(u64 token, u64 gva, int type),
 
-	TP_ARGS(token, gva)
+	TP_ARGS(token, gva, type)
 );
 
 TRACE_EVENT(
 	kvm_async_pf_completed,
-	TP_PROTO(unsigned long address, u64 gva),
-	TP_ARGS(address, gva),
+	TP_PROTO(unsigned long address, u64 gva, int type),
+	TP_ARGS(address, gva, type),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, address)
 		__field(u64, gva)
+		__field(int, type)
 		),
 
 	TP_fast_assign(
 		__entry->address = address;
 		__entry->gva = gva;
+		__entry->type = type;
 		),
 
-	TP_printk("gva %#llx address %#lx",  __entry->gva,
-		  __entry->address)
+	TP_printk("gva %#llx address %#lx type %s",  __entry->gva,
+		  __entry->address, __print_symbolic(__entry->type,
+		  kvm_async_pf_type_symbol))
 );
 
 #endif
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 99a63bad0306..77c689a9b585 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -92,7 +92,7 @@ static void async_pf_execute(struct work_struct *work)
 	if (!IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC) && first)
 		kvm_arch_async_page_present_queued(vcpu);
 
-	trace_kvm_async_pf_completed(addr, cr2_or_gpa);
+	trace_kvm_async_pf_completed(addr, cr2_or_gpa, 0);
 
 	__kvm_vcpu_wake_up(vcpu);
 }
-- 
2.40.1


