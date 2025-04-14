Return-Path: <kvm+bounces-43237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C315EA882BD
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 15:43:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34D027A40F0
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 13:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51CD72957B7;
	Mon, 14 Apr 2025 13:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eI9m/UHt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1CE2957A5;
	Mon, 14 Apr 2025 13:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744637331; cv=none; b=HMu7sq8SOQHey5/6XeKLIKLUy3cceEwobYc/01yDaFytkaMKniGy4YybCnFaqgxBtL2WPcHnFtTtxRiwg7tGbHoQ9j74kvRXMYjxqIL8vt/E9cA1KAa4u1UPnWlCnvXud7ySqhePY/pKBT9kzaELMPFh6xQYO5tV0BlKORg85eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744637331; c=relaxed/simple;
	bh=oH1eW4mjfFf+HBxbIxg/zlJ2VSYoPk4kQzYqfN4r4wE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=LvOrMkURNeUr1bUrZSCNXK7RPaNztPhD/Wytcb516dUghFAXE/TeYn9PTet6eOdWckxhZA6vaeTV6t8lcok8pqNghMh+OVeSML48T+HjKrgIEIbUxuz399ooBXYI3qGA4wat0B9CAD2NNLXp7kMDJsdqgNN7huuVJaiWS04kfbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eI9m/UHt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB51C4CEE9;
	Mon, 14 Apr 2025 13:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744637331;
	bh=oH1eW4mjfFf+HBxbIxg/zlJ2VSYoPk4kQzYqfN4r4wE=;
	h=From:To:Cc:Subject:Date:From;
	b=eI9m/UHtmYjfS+DFRI6C19yjC3RbNN178ELcSv2IpGjCEb6Jt/yvWJ2kxIZz5dyys
	 ARv7x5T5iDIZ9VuDTaO3vWxQLfCo/DNjNct71MwFh7etieHOgiNxVc+G2q2yF4SjQx
	 jfiVGGca9Fd0qqLy2PGPzehlmRa34aPYk4WUWREEr4nFBQ4XWZXAc0MDAt8Cvvm53Y
	 8bBVCUTjY6qCxSR4+CwbsgmZvlvF7WTgiejD2IbJqTeiC8OcZbx2UgPw1KQdDO+K4/
	 U47p5uI2pqkGVbgxvrsap5xYQjmmzttMJk5yUxfPcon2z5mylrixFjmlX33tr0cli0
	 VuYAzwLwHxQRQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Michael Mueller <mimu@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	borntraeger@linux.ibm.com,
	imbrenda@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 01/30] KVM: s390: Don't use %pK through tracepoints
Date: Mon, 14 Apr 2025 09:28:18 -0400
Message-Id: <20250414132848.679855-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.23
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 6c9567e0850be2f0f94ab64fa6512413fd1a1eb1 ]

Restricted pointers ("%pK") are not meant to be used through TP_format().
It can unintentionally expose security sensitive, raw pointer values.

Use regular pointer formatting instead.

Link: https://lore.kernel.org/lkml/20250113171731-dc10e3c1-da64-4af0-b767-7c7070468023@linutronix.de/
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Michael Mueller <mimu@linux.ibm.com>
Link: https://lore.kernel.org/r/20250217-restricted-pointers-s390-v1-1-0e4ace75d8aa@linutronix.de
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20250217-restricted-pointers-s390-v1-1-0e4ace75d8aa@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/trace-s390.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/trace-s390.h b/arch/s390/kvm/trace-s390.h
index 9ac92dbf680db..9e28f165c114c 100644
--- a/arch/s390/kvm/trace-s390.h
+++ b/arch/s390/kvm/trace-s390.h
@@ -56,7 +56,7 @@ TRACE_EVENT(kvm_s390_create_vcpu,
 		    __entry->sie_block = sie_block;
 		    ),
 
-	    TP_printk("create cpu %d at 0x%pK, sie block at 0x%pK",
+	    TP_printk("create cpu %d at 0x%p, sie block at 0x%p",
 		      __entry->id, __entry->vcpu, __entry->sie_block)
 	);
 
@@ -255,7 +255,7 @@ TRACE_EVENT(kvm_s390_enable_css,
 		    __entry->kvm = kvm;
 		    ),
 
-	    TP_printk("enabling channel I/O support (kvm @ %pK)\n",
+	    TP_printk("enabling channel I/O support (kvm @ %p)\n",
 		      __entry->kvm)
 	);
 
-- 
2.39.5


