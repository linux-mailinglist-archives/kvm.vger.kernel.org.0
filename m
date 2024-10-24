Return-Path: <kvm+bounces-29615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 63FE09AE199
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 11:56:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B14A1F21C17
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:56:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 120E11C07DF;
	Thu, 24 Oct 2024 09:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Uu5C/MiG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BCC1B3939;
	Thu, 24 Oct 2024 09:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729763736; cv=none; b=SsCPnsDI01CpKO00vMKHFeT+uJr249TZK1Utq3q4uWkiXSEOQhI2BykeyjpgeQQCP4oiEAyy9DA5W8Zo8Ys0jCxJT+kC0pLvUUT/+WCUs+jdwQDhbz9BYGgjelapCWbX/gjsgxxZYMNiWJAgXYWjP0WKsIYv7EmPmK0TeXId7Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729763736; c=relaxed/simple;
	bh=i5vK9aLmsT0GGDyg7WEDIE5qnmQKXG3tKt7ZzyssSAs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QXrf06shuDdecr6gwQAOwyeH06LIG8b7FSAWxo2MXLlwGSvUbFEsjgp223YgCXNxwVn0oDu2JR5GjaqoTpnHCE/vL54Jt/FnqaQqPg1wbgIVUgdLOAXywY93ay4dpKTkutfEI6pcSajHUi2r/MS+Dh21s7FsBuE2WNmpEsLSr8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=Uu5C/MiG; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1729763730; x=1761299730;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HXXzFn3jpMW6RTAoikwJEYClFQzi+J2nHDJ1RTMwPhs=;
  b=Uu5C/MiG7gAh/Hd3Jf9tmHGovTdeqSgFAbXWn3jx2xt4k593ZpAaBuHK
   V9mqvZgBsVI+OoqAbxS7nC47+X9OeBmJtCi8IacT5Qn+TYYDKSDSAgRNX
   jhTZqp6yCaS9KF2+4+DALSeUhSxYgL6szAEqRrbfDqzZm00dJ/Ixhe4PQ
   Y=;
X-IronPort-AV: E=Sophos;i="6.11,228,1725321600"; 
   d="scan'208";a="140248274"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 09:55:28 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.38.20:19110]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.32.104:2525] with esmtp (Farcaster)
 id 79e479ff-e6f5-4772-9796-14113ad03430; Thu, 24 Oct 2024 09:55:28 +0000 (UTC)
X-Farcaster-Flow-ID: 79e479ff-e6f5-4772-9796-14113ad03430
Received: from EX19D020UWA002.ant.amazon.com (10.13.138.222) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 24 Oct 2024 09:55:24 +0000
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19D020UWA002.ant.amazon.com (10.13.138.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 24 Oct 2024 09:55:23 +0000
Received: from email-imr-corp-prod-pdx-all-2c-d1311ce8.us-west-2.amazon.com
 (10.25.36.214) by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Thu, 24 Oct 2024 09:55:23 +0000
Received: from dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com (dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com [172.19.103.116])
	by email-imr-corp-prod-pdx-all-2c-d1311ce8.us-west-2.amazon.com (Postfix) with ESMTPS id BDF2140617;
	Thu, 24 Oct 2024 09:55:21 +0000 (UTC)
From: Nikita Kalyazin <kalyazin@amazon.com>
To: <pbonzini@redhat.com>, <corbet@lwn.net>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jthoughton@google.com>, <brijesh.singh@amd.com>, <michael.roth@amd.com>,
	<graf@amazon.de>, <jgowans@amazon.com>, <roypat@amazon.co.uk>,
	<derekmn@amazon.com>, <nsaenz@amazon.es>, <xmarcalx@amazon.com>,
	<kalyazin@amazon.com>
Subject: [PATCH 4/4] KVM: document KVM_GUEST_MEMFD_POPULATE ioctl
Date: Thu, 24 Oct 2024 09:54:29 +0000
Message-ID: <20241024095429.54052-5-kalyazin@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20241024095429.54052-1-kalyazin@amazon.com>
References: <20241024095429.54052-1-kalyazin@amazon.com>
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
 Documentation/virt/kvm/api.rst | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e32471977d0a..f192dab41bad 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6442,6 +6442,30 @@ the capability to be present.
 
 `flags` must currently be zero.
 
+4.144 KVM_GUEST_MEMFD_POPULATE
+----------------------------
+
+:Capability: KVM_CAP_GUEST_MEMFD
+:Architectures: none
+:Type: vm ioctl
+:Parameters: struct kvm_guest_memfd_populate(in)
+:Returns: 0 if all requested pages populated, < 0 on error
+
+KVM_GUEST_MEMFD_POPULATE populates guest_memfd with data provided by userspace.
+
+::
+
+  struct kvm_guest_memfd_populate {
+  __u64 gpa;
+  __u64 size;
+  void __user *from;
+  __u64 flags;
+  };
+
+A gfn can only be populated once.  If a gfn is attempted to get populated
+multiple times without prior calls to fallocate(PUNCH_HOLE), subsequent calls
+will return EEXIST.
+If the `from` pointer is NULL, the pages are cleared.
 
 5. The kvm_run structure
 ========================
-- 
2.40.1


