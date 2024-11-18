Return-Path: <kvm+bounces-32005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 311379D10BD
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 13:41:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6C231F23260
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 12:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5578E19D092;
	Mon, 18 Nov 2024 12:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="jyjJyROy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E4513A86A;
	Mon, 18 Nov 2024 12:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.48.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731933630; cv=none; b=m4gyRBU7rt3hkHPuA2YSetyJh29vpLqrmV0dkXIeuwTzdK+mc+UOEzQ47/If/QIoyGp7jf195oIOc1HQ0oK2TILv7tk3yzBg726FTZDUPRHhRDiK/fK2SJu3VVugCS4XvWHSdDKSTyXP+jY6wquOoQs2MtaFOhm8v7g5x0u68U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731933630; c=relaxed/simple;
	bh=+ITA0+YbY97k84dSG63wbtwvOGu1ISlsjpfi46Kayj0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TeiCrIPW8OcmmywqVyRvqTcevZV1fARLaxikuI446VphYcnEwo94sRs2fbKVzQNul0vZpFKMS+tmYayn13UnbPqs28puJF9JJGXNC/FymzCYY59b6bfcrRiRC0MYZADGPPg/y+5q8PbaSoTgHWYSDd9vX3MlixUhSW2FwJEQB3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=jyjJyROy; arc=none smtp.client-ip=52.95.48.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1731933629; x=1763469629;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YWnZNG4OqnCj1+mc3lzFOp31d7iLjWz4EGzgiOgOzEg=;
  b=jyjJyROyjTI29TeVNYY1T3vwGL5ESsRFw3y3oDYvr0GbS+2aCyi7j21U
   ozhtf4/rcbdvJVYQOLLplBn0hSwwdoGhJfRJxUa/AYA9npcN6kjYDOcD2
   kWISwUoOeQrJtILt2jMAFtqcfZetBtMkqwnBRq8D0LZS3KqYoRYN1v8Wy
   Q=;
X-IronPort-AV: E=Sophos;i="6.12,164,1728950400"; 
   d="scan'208";a="440822515"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.124.125.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 12:40:25 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.38.20:37285]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.52.223:2525] with esmtp (Farcaster)
 id 4fa2831c-e969-4c66-9129-1fa566249239; Mon, 18 Nov 2024 12:40:23 +0000 (UTC)
X-Farcaster-Flow-ID: 4fa2831c-e969-4c66-9129-1fa566249239
Received: from EX19D003UWC002.ant.amazon.com (10.13.138.169) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 18 Nov 2024 12:40:21 +0000
Received: from EX19MTAUWA002.ant.amazon.com (10.250.64.202) by
 EX19D003UWC002.ant.amazon.com (10.13.138.169) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Mon, 18 Nov 2024 12:40:20 +0000
Received: from email-imr-corp-prod-pdx-all-2b-f5cd2367.us-west-2.amazon.com
 (10.25.36.210) by mail-relay.amazon.com (10.250.64.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Mon, 18 Nov 2024 12:40:20 +0000
Received: from dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com (dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com [172.19.103.116])
	by email-imr-corp-prod-pdx-all-2b-f5cd2367.us-west-2.amazon.com (Postfix) with ESMTPS id 1C58DC0319;
	Mon, 18 Nov 2024 12:40:16 +0000 (UTC)
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
Subject: [RFC PATCH 2/6] Documentation: KVM: add async pf user doc
Date: Mon, 18 Nov 2024 12:39:44 +0000
Message-ID: <20241118123948.4796-3-kalyazin@amazon.com>
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

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
---
 Documentation/virt/kvm/api.rst | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ffe9a2d0e525..b30f9989f5c1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6352,6 +6352,32 @@ a single guest_memfd file, but the bound ranges must not overlap).
 
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
+4.143 KVM_ASYNC_PF_USER_READY
+----------------------------
+
+:Capability: KVM_CAP_USERFAULT
+:Architectures: x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_async_pf_user_ready(in)
+:Returns: 0 on success, <0 on error
+
+KVM_ASYNC_PF_USER_READY notifies the kernel that the fault corresponding to the
+'token' has been resolved by the userspace. The ioctl is supposed to be used by
+the userspace when processing an async PF in response to a VM exit with the
+KVM_MEMORY_EXIT_FLAG_ASYNC_PF_USER flag set. The 'token' must match the value
+supplied by the kernel in 'async_pf_user_token' field of the
+struct memory_fault. When handling the ioctl, the kernel will inject the
+'page present' event in the guest and wake the vcpu up if it is halted, like it
+would do when completing a regular (kernel) async PF.
+
+::
+
+  struct kvm_async_pf_user_ready {
+  __u32 token;
+  };
+
+This is an asynchronous vcpu ioctl and can be invoked from any thread.
+
 5. The kvm_run structure
 ========================
 
@@ -6997,9 +7023,11 @@ spec refer, https://github.com/riscv/riscv-sbi-doc.
 		struct {
   #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
   #define KVM_MEMORY_EXIT_FLAG_USERFAULT  (1ULL << 4)
+  #define KVM_MEMORY_EXIT_FLAG_ASYNC_PF_USER (1ULL << 5)
 			__u64 flags;
 			__u64 gpa;
 			__u64 size;
+			__u32 async_pf_user_token;
 		} memory_fault;
 
 KVM_EXIT_MEMORY_FAULT indicates the vCPU has encountered a memory fault that
@@ -7012,6 +7040,10 @@ describes properties of the faulting access that are likely pertinent:
    shared access.
  - KVM_MEMORY_EXIT_FLAG_USERFAULT - When set, indicates the memory fault
    occurred, because the vCPU attempted to access a gfn marked as userfault.
+ - KVM_MEMORY_EXIT_FLAG_ASYNC_PF_USER - When set, indicates the memory fault can
+   be processed asynchronously and 'async_pf_user_token' contains the token to
+   be used when notifying KVM of the completion via the KVM_ASYNC_PF_USER_READY
+   ioctl.
 
 Note!  KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in that it
 accompanies a return code of '-1', not '0'!  errno will always be set to EFAULT
-- 
2.40.1


