Return-Path: <kvm+bounces-43242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ADAD4A883B4
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 16:04:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 239A116581B
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 13:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF162DA100;
	Mon, 14 Apr 2025 13:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q69N8OxM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D02B2DA0F1;
	Mon, 14 Apr 2025 13:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744637489; cv=none; b=CBJBULU+sZYTSfqlbG4C0xFqcqZ1SPJRJhaRE7gfHfSABXiSax2DG1FtJ7xqm1aLHkRdJR2OuYjyiBJkrONw9yxktDIrUQ+h6Rg5cadHOWbIXODtTkWBJVOhvpxKrVkisUtxoCpX/wxbhvKhzg0NbC1bm2MbUzNF97TbecRh5/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744637489; c=relaxed/simple;
	bh=9J/z5T0JY/xcwsk6SXFTA+zsyiZ/gs3asCJyO6IhBN4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=oxvfrkuVuotFRLjZjP1/O7qzqESlGripsHKhxDYaA/hbl/knnvBrdJqzgUHPlxEFz8ONmhTRGfzDOalcvQKgL+Ipb4lcOOJ6mf6QDBuOC/YycP7fxDV6PMEoN2BxwSxvBwEIu+u4HOwZiJMe1HyzwysI8BepjkH1olmmfcYuJpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q69N8OxM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A12C4CEE9;
	Mon, 14 Apr 2025 13:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744637489;
	bh=9J/z5T0JY/xcwsk6SXFTA+zsyiZ/gs3asCJyO6IhBN4=;
	h=From:To:Cc:Subject:Date:From;
	b=q69N8OxMGC6IqrI1hs6JxTtGs6GZwO3HUAFb9Lkhw93vRJrRMXWDgIQ46Vr7I0CxR
	 qSfWZXVH2oyXwping3PdkpTl2OD5VjFm4Va2rsqWkd47SlUv0piFogN4/TwYcdvIdb
	 PQcyeH0z+Ppj0nKLkzGc1Pd9C5FNEvPBhdiwCgm6rO1NCWdqfW+uYvOXNmMk0mLl5g
	 iPu7VwcEk65PJj8v90fm5MhkfY/rKnCen8QMI9+VJJVvStUZgKG79HPNI1Nab3KQXB
	 AL6Cfrkw12j0jJyvBR5It605q/RaFVAopVuhzkZfUAis0kN+13UzFJ1J0Dho/S+4Oi
	 ywLQn4vKHKboQ==
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
Subject: [PATCH AUTOSEL 5.15 01/15] KVM: s390: Don't use %pK through tracepoints
Date: Mon, 14 Apr 2025 09:31:11 -0400
Message-Id: <20250414133126.680846-1-sashal@kernel.org>
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
X-stable-base: Linux 5.15.180
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
index 6f0209d45164f..9c5f546a2e1a3 100644
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


