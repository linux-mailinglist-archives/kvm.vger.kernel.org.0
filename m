Return-Path: <kvm+bounces-21198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C75792BAEC
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 15:23:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 575EE2830B3
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 13:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FABB17623E;
	Tue,  9 Jul 2024 13:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="PlwmWrIi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADE215F3E7;
	Tue,  9 Jul 2024 13:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.190.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720531290; cv=none; b=DpgWZ6qwG2zR6TtIZqMhzQ8weRxTONnehx5wpqcorjsi+c6+zAuf3Zn/VN6B13zCHr9dSN6tgicOA2Li7DOkeO6YCQyG2BP1ErHHjXNpi+M+4EYeD/vaiTLwpLWaMNlliao1g6LChBQBzozH3eaLiM5SnEqKSQt/E+2CkSRBSMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720531290; c=relaxed/simple;
	bh=V11/sfRjwHrSFGwa38UBGzs+K1mzWvLoZ6p6GzApERs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A5Oj735/97Lt9kLdhkIXEYqn7NBm1EkAmTmNd1i5dsxaNpzECNrx+IP9rKXYH9XAEPo1oZ7K61kmsHkfxhgLxZRHAq/VVVXcuyahMcYjdY7zXOF2bIjJg1ihdJgz0ZHM/S+X2wJ1ioU0uGu/+F0x+kJxrr2QREAnmH3uLdR8OBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=PlwmWrIi; arc=none smtp.client-ip=207.171.190.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1720531287; x=1752067287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zs9pi34/tgrMwAZ4z/XLHKURo1LH266GsNUebv4yq5Y=;
  b=PlwmWrIiBE+IVPEi67xgHs9KoDET7GLIOHr6V70yGpa0nuwRMOjv9/j/
   gM8D/sZeij5p+PRz1AgcA1RbCdi123ZtYs7VgXAcNYLtqaCYQzOib3iUn
   h/eqFNp5BtjZiXs7XZ+NJQf+zWHEcdLSg+HDSOoBGxgl6OtNLjHZdiJAD
   Q=;
X-IronPort-AV: E=Sophos;i="6.09,195,1716249600"; 
   d="scan'208";a="355121480"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 13:21:21 +0000
Received: from EX19MTAUEA001.ant.amazon.com [10.0.0.204:8257]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.59.218:2525] with esmtp (Farcaster)
 id f29e8f74-c847-4100-b6a1-572dc2245bb7; Tue, 9 Jul 2024 13:21:19 +0000 (UTC)
X-Farcaster-Flow-ID: f29e8f74-c847-4100-b6a1-572dc2245bb7
Received: from EX19D008UEA002.ant.amazon.com (10.252.134.125) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 9 Jul 2024 13:21:17 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D008UEA002.ant.amazon.com (10.252.134.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 9 Jul 2024 13:21:17 +0000
Received: from ua2d7e1a6107c5b.ant.amazon.com (172.19.88.180) by
 mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34
 via Frontend Transport; Tue, 9 Jul 2024 13:21:14 +0000
From: Patrick Roy <roypat@amazon.co.uk>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <akpm@linux-foundation.org>,
	<dwmw@amazon.co.uk>, <rppt@kernel.org>, <david@redhat.com>
CC: Patrick Roy <roypat@amazon.co.uk>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <willy@infradead.org>, <graf@amazon.com>,
	<derekmn@amazon.com>, <kalyazin@amazon.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <dmatlack@google.com>,
	<tabba@google.com>, <chao.p.peng@linux.intel.com>, <xmarcalx@amazon.co.uk>
Subject: [RFC PATCH 7/8] mm: secretmem: use AS_INACCESSIBLE to prohibit GUP
Date: Tue, 9 Jul 2024 14:20:35 +0100
Message-ID: <20240709132041.3625501-8-roypat@amazon.co.uk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709132041.3625501-1-roypat@amazon.co.uk>
References: <20240709132041.3625501-1-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

Inside of vma_is_secretmem and secretmem_mapping, instead of checking
whether a vm_area_struct/address_space has the secretmem ops structure
attached to it, check whether the address_space has the AS_INACCESSIBLE
bit set. Then set the AS_INACCESSIBLE flag for secretmem's
address_space.

This means that get_user_pages and friends are disables for all
adress_spaces that set AS_INACCESIBLE. The AS_INACCESSIBLE flag was
introduced in commit c72ceafbd12c ("mm: Introduce AS_INACCESSIBLE for
encrypted/confidential memory") specifically for guest_memfd to indicate
that no reads and writes should ever be done to guest_memfd
address_spaces. Disallowing gup seems like a reasonable semantic
extension, and means that potential future mmaps of guest_memfd cannot
be GUP'd.

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 include/linux/secretmem.h | 13 +++++++++++--
 mm/secretmem.c            |  6 +-----
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/secretmem.h b/include/linux/secretmem.h
index e918f96881f5..886c8f7eb63e 100644
--- a/include/linux/secretmem.h
+++ b/include/linux/secretmem.h
@@ -8,10 +8,19 @@ extern const struct address_space_operations secretmem_aops;
 
 static inline bool secretmem_mapping(struct address_space *mapping)
 {
-	return mapping->a_ops == &secretmem_aops;
+	return mapping->flags & AS_INACCESSIBLE;
+}
+
+static inline bool vma_is_secretmem(struct vm_area_struct *vma)
+{
+	struct file *file = vma->vm_file;
+
+	if (!file)
+		return false;
+
+	return secretmem_mapping(file->f_inode->i_mapping);
 }
 
-bool vma_is_secretmem(struct vm_area_struct *vma);
 bool secretmem_active(void);
 
 #else
diff --git a/mm/secretmem.c b/mm/secretmem.c
index 3afb5ad701e1..fd03a84a1cb5 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -136,11 +136,6 @@ static int secretmem_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
-bool vma_is_secretmem(struct vm_area_struct *vma)
-{
-	return vma->vm_ops == &secretmem_vm_ops;
-}
-
 static const struct file_operations secretmem_fops = {
 	.release	= secretmem_release,
 	.mmap		= secretmem_mmap,
@@ -218,6 +213,7 @@ static struct file *secretmem_file_create(unsigned long flags)
 
 	inode->i_op = &secretmem_iops;
 	inode->i_mapping->a_ops = &secretmem_aops;
+	inode->i_mapping->flags |= AS_INACCESSIBLE;
 
 	/* pretend we are a normal file with zero size */
 	inode->i_mode |= S_IFREG;
-- 
2.45.2


