Return-Path: <kvm+bounces-32006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3A3E9D10C3
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 13:42:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89DE5281044
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 12:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF1181A00EE;
	Mon, 18 Nov 2024 12:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="LyIJRSgx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833F61993BD;
	Mon, 18 Nov 2024 12:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731933647; cv=none; b=O+P4JZ9v/h17QTcUGz0LMjn7TARUPTsDImILYPb5d+f87Y/vF7Xl3NI/K3z5VLUSd8ULtunDketMNjcRAXC3eYAL7XEejSnLPPddCfUJWsxg0bO8G3yHnOVAXKt7r+3I/zgAxxhgStXJAtfEccCo054PGQoIwb1HP22V5z3Uczc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731933647; c=relaxed/simple;
	bh=rSjbVcPNeeTOu8BHYNJH8D9bjIrU9iD0wGsLBvrxgus=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UGT4/+N9fOF032utyyT1ghb1/5DeIf6Na6YZyqTDhS3vqUIM61Uv1tR8VDah+C7PTIjDcBlqMK5zO9WR2V7LrrO884hkfyxMC1AqDPYjBW0iNYWhni9f/m6jrKXyeGMAJPdjO/oJApDKj/hu7A7QXjrcbrWzss6COUl3p6giuK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=LyIJRSgx; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1731933646; x=1763469646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hb+cZM45a1mlq40ZkxximZXO4dH+zx+4/vCBLQqDL2Q=;
  b=LyIJRSgxYrcPXB4A3iDLA9ICnv+L4FGncviP7nDkTiMCW7HZosobO5X7
   yyM0xV0ClDX2RuQ1SsCLp3JRQtur1AV2KcQBr3oV4wF3gwxqtcWgO/CfM
   ygQbarkQbFaeaRBVux+ezZu1x7EE3VjtYw7YLK+bWUhyx/fbzKkSwZXIW
   4=;
X-IronPort-AV: E=Sophos;i="6.12,164,1728950400"; 
   d="scan'208";a="776563597"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 12:40:38 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.7.35:23454]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.38.94:2525] with esmtp (Farcaster)
 id 74afcfd0-b984-403f-96b8-cd8a7b317bca; Mon, 18 Nov 2024 12:40:37 +0000 (UTC)
X-Farcaster-Flow-ID: 74afcfd0-b984-403f-96b8-cd8a7b317bca
Received: from EX19D003UWB004.ant.amazon.com (10.13.138.24) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 18 Nov 2024 12:40:34 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D003UWB004.ant.amazon.com (10.13.138.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Mon, 18 Nov 2024 12:40:34 +0000
Received: from email-imr-corp-prod-iad-all-1b-1323ce6b.us-east-1.amazon.com
 (10.25.36.214) by mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Mon, 18 Nov 2024 12:40:34 +0000
Received: from dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com (dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com [172.19.103.116])
	by email-imr-corp-prod-iad-all-1b-1323ce6b.us-east-1.amazon.com (Postfix) with ESMTPS id 70E6F403FE;
	Mon, 18 Nov 2024 12:40:31 +0000 (UTC)
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
Subject: [RFC PATCH 3/6] KVM: x86: add async ioctl support
Date: Mon, 18 Nov 2024 12:39:45 +0000
Message-ID: <20241118123948.4796-4-kalyazin@amazon.com>
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

x86 has not had support for async ioctls.
This patch adds an arch implementation, but does not add any of the
ioctls just yet.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
---
 arch/x86/kvm/Kconfig | 1 +
 arch/x86/kvm/x86.c   | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ebd1ec6600bc..191dfba3e27a 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -46,6 +46,7 @@ config KVM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_WERROR if WERROR
 	select KVM_USERFAULT
+	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ba0ad76f53bc..800493739043 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13619,6 +13619,12 @@ void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 }
 #endif
 
+long kvm_arch_vcpu_async_ioctl(struct file *filp,
+			       unsigned int ioctl, unsigned long arg)
+{
+	return -ENOIOCTLCMD;
+}
+
 int kvm_spec_ctrl_test_value(u64 value)
 {
 	/*
-- 
2.40.1


