Return-Path: <kvm+bounces-26307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7275E973D46
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:32:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 936431C21548
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:32:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA721A38CE;
	Tue, 10 Sep 2024 16:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="Tkf1jH9e"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76B516C684;
	Tue, 10 Sep 2024 16:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985879; cv=none; b=mroDCstz6lnTrvDXTES7ke+uAn8c9lTR4K4TQvzJD36e6u89i78Lz/L2DKurXo3+b9wniHX2vstgZECrGAyhV7kCbi/AUD+UU4/EwYwQQWfUe8uCSa2dG2VQZrFV6u8ZdZ0AJ6EFBFo/gpnnA8fRj53TPy+ydWln+vRlYpplBX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985879; c=relaxed/simple;
	bh=mxJU2TzVkIfcGGJro+cv+6yOzAahJ5oXQEU80AyRFq8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qsdSAFgWR1TloPAlvx5lypO6N9x+DJj0AA4e654cI4SaBuVxxR6qPcXM7hGNaqGcgmHvIhmAYXtwKUjWPcvLARTOty02t1dNGatRg3JGeHbUa12N/G0jL2dk8EmWpqqq9rEM4uvjzRdy+gw17ex1gCIk3/f8ktxEXAeJm/lkBI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=Tkf1jH9e; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1725985877; x=1757521877;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v5e1Lttypa2CCeJrmZUnbjUqOb8jI+6pZUoDp94zyOM=;
  b=Tkf1jH9ejSX0KEEilAQPnWXaU+tMTvtl3FiAdNPhDHg+tl9nzU9DY00P
   mkpYYyN2cKbIAVvucggKCHLKpMgngmHt2A8ZgCnJbEMZFmHDTbuBa8nCf
   N2K0mGWNVBE0P6UsfT9Bj4EFmQtvSx25J62BtdC6unUnHONp3qc0ORtSA
   A=;
X-IronPort-AV: E=Sophos;i="6.10,217,1719878400"; 
   d="scan'208";a="124612846"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 16:31:09 +0000
Received: from EX19MTAUEA002.ant.amazon.com [10.0.29.78:9542]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.42.209:2525] with esmtp (Farcaster)
 id 7c6ae1ed-f922-4596-94d5-b5debded213c; Tue, 10 Sep 2024 16:31:08 +0000 (UTC)
X-Farcaster-Flow-ID: 7c6ae1ed-f922-4596-94d5-b5debded213c
Received: from EX19D008UEC004.ant.amazon.com (10.252.135.170) by
 EX19MTAUEA002.ant.amazon.com (10.252.134.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:31:03 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D008UEC004.ant.amazon.com (10.252.135.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:31:02 +0000
Received: from ua2d7e1a6107c5b.home (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.254) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Tue, 10 Sep 2024 16:30:58 +0000
From: Patrick Roy <roypat@amazon.co.uk>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <rostedt@goodmis.org>,
	<mhiramat@kernel.org>, <mathieu.desnoyers@efficios.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <quic_eberman@quicinc.com>,
	<dwmw@amazon.com>, <david@redhat.com>, <tabba@google.com>, <rppt@kernel.org>,
	<linux-mm@kvack.org>, <dmatlack@google.com>
CC: Patrick Roy <roypat@amazon.co.uk>, <graf@amazon.com>,
	<jgowans@amazon.com>, <derekmn@amazon.com>, <kalyazin@amazon.com>,
	<xmarcalx@amazon.com>
Subject: [RFC PATCH v2 03/10] kvm: gmem: Add KVM_GMEM_GET_PFN_LOCKED
Date: Tue, 10 Sep 2024 17:30:29 +0100
Message-ID: <20240910163038.1298452-4-roypat@amazon.co.uk>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910163038.1298452-1-roypat@amazon.co.uk>
References: <20240910163038.1298452-1-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

Allow kvm_gmem_get_pfn to return with the folio lock held by adding a
KVM_GMEM_GET_PFN_LOCKED option to `flags`.

When accessing the content of gmem folios, the lock must be held until
kvm_gmem_put_pfn, to avoid concurrent direct map modifications of the
same folio causing use-after-free-like problems. However,
kvm_gmem_get_pfn so far unconditionally drops the folio lock, making it
currently impossible to use the KVM_GMEM_GET_PFN_SHARED flag safely.

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/guest_memfd.c   | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8a2975674de4b..cd28eb34aaeb1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2433,6 +2433,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
 
 #define KVM_GMEM_GET_PFN_SHARED         BIT(0)
+#define KVM_GMEM_GET_PFN_LOCKED         BIT(1)
 #define KVM_GMEM_GET_PFN_PREPARE        BIT(31)  /* internal */
 
 #ifdef CONFIG_KVM_PRIVATE_MEM
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 492b04f4e5c18..f637abc6045ba 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -670,7 +670,8 @@ static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 
 	r = 0;
 
-	folio_unlock(folio);
+	if (!(flags & KVM_GMEM_GET_PFN_LOCKED))
+		folio_unlock(folio);
 
 	return r;
 }
@@ -680,7 +681,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 {
 	struct file *file = kvm_gmem_get_file(slot);
 	int r;
-	int valid_flags = KVM_GMEM_GET_PFN_SHARED;
+	int valid_flags = KVM_GMEM_GET_PFN_SHARED | KVM_GMEM_GET_PFN_LOCKED;
 
 	if ((flags & valid_flags) != flags)
 		return -EINVAL;
-- 
2.46.0


