Return-Path: <kvm+bounces-32004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B5EF9D10B6
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 13:40:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4813B1F23145
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 12:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CB6819ABB6;
	Mon, 18 Nov 2024 12:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="U8VwvxEt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEEE13A86A;
	Mon, 18 Nov 2024 12:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.190.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731933621; cv=none; b=qPLQm35TbchZka0YqO1rFxu16x0ucGIYKdzZMBLcRgzw55nKNpFbx6hdUWxSipqJMkdzmkALtnpbcumeaa2/CN0Goc6/M5aoPK80x5172EzepEYIWSN2kZ9SG6c2l7gHTeAwXVnTKE5DOqmwAu5o6/lxBDU9PwMoi3fq6MBcsZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731933621; c=relaxed/simple;
	bh=kNxZvO8y36K4Ep7rrKtJA4RxlL2dmtI+1okxTDd2da4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HZCShcwMynAvvJCx3vGQyXjq7IsroQBrjqk9dBtEp4qsqlWzF+IXkGCjLQR4QJBY2aYjbE91zk1gh0gWDE5vZUxLQ1zuC4gyz9aITFDpHQv0ihWQC6dvKUq4bK1VJWw0547HBTt09/0y6PUHBShbK7NBh72R6uGxFzt8dbVm95c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=U8VwvxEt; arc=none smtp.client-ip=207.171.190.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1731933620; x=1763469620;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FSBrb5cqWO2WFHJzPfcnCvsF7cALuKZ15nU4s+5TVuI=;
  b=U8VwvxEtcvCEoMpVKTnn9gLQXtSesqkpexipjuJYzNbAwg5i32vN2MO2
   F14MxglZ8qK0HI9y70jGvHRGnYWEWM3dSrmL6FRVwW9Wm7dbDeIOX2X3x
   PrA9F53jFJjPpENUBbFrlsDkqcSztdEQsmY8b2tRk7fi9sGi1FGOcufm6
   o=;
X-IronPort-AV: E=Sophos;i="6.12,164,1728950400"; 
   d="scan'208";a="386239130"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 12:40:13 +0000
Received: from EX19MTAUWB001.ant.amazon.com [10.0.7.35:2984]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.61.54:2525] with esmtp (Farcaster)
 id 76537f13-6d29-4dbc-bfeb-5cd5a39fcb19; Mon, 18 Nov 2024 12:40:12 +0000 (UTC)
X-Farcaster-Flow-ID: 76537f13-6d29-4dbc-bfeb-5cd5a39fcb19
Received: from EX19D003UWB003.ant.amazon.com (10.13.138.116) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 18 Nov 2024 12:40:06 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D003UWB003.ant.amazon.com (10.13.138.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Mon, 18 Nov 2024 12:40:06 +0000
Received: from email-imr-corp-prod-iad-all-1a-8c151b82.us-east-1.amazon.com
 (10.124.125.2) by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Mon, 18 Nov 2024 12:40:06 +0000
Received: from dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com (dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com [172.19.103.116])
	by email-imr-corp-prod-iad-all-1a-8c151b82.us-east-1.amazon.com (Postfix) with ESMTPS id D72314041B;
	Mon, 18 Nov 2024 12:40:03 +0000 (UTC)
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
Subject: [RFC PATCH 1/6] Documentation: KVM: add userfault KVM exit flag
Date: Mon, 18 Nov 2024 12:39:43 +0000
Message-ID: <20241118123948.4796-2-kalyazin@amazon.com>
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

Update KVM documentation to reflect the change made in [1]:
add KVM_MEMORY_EXIT_FLAG_USERFAULT flag to struct memory_fault.

[1] https://lore.kernel.org/lkml/20240710234222.2333120-7-jthoughton@google.com/

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
---
 Documentation/virt/kvm/api.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 26a98fea718c..ffe9a2d0e525 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6996,6 +6996,7 @@ spec refer, https://github.com/riscv/riscv-sbi-doc.
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
   #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
+  #define KVM_MEMORY_EXIT_FLAG_USERFAULT  (1ULL << 4)
 			__u64 flags;
 			__u64 gpa;
 			__u64 size;
@@ -7009,6 +7010,8 @@ describes properties of the faulting access that are likely pertinent:
  - KVM_MEMORY_EXIT_FLAG_PRIVATE - When set, indicates the memory fault occurred
    on a private memory access.  When clear, indicates the fault occurred on a
    shared access.
+ - KVM_MEMORY_EXIT_FLAG_USERFAULT - When set, indicates the memory fault
+   occurred, because the vCPU attempted to access a gfn marked as userfault.
 
 Note!  KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in that it
 accompanies a return code of '-1', not '0'!  errno will always be set to EFAULT
-- 
2.40.1


