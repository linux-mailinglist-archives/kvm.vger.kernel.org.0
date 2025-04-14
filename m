Return-Path: <kvm+bounces-43244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C38EEA883C5
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 16:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2FD957A7658
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 14:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DBB82820DB;
	Mon, 14 Apr 2025 13:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J03RGJEy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEF02DE46A;
	Mon, 14 Apr 2025 13:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744637546; cv=none; b=A1geZFAbDIqB/nUFUawhLGcKz2UErKlatnMa1xeifCvYcN2ioYbdMZcIK5Ikb/s5QiQ03h0q5+3xs5RE1EsxSQ1CWnnxLartpVVwRV0G+FC04339wt0juHoMPRGvKv5hVcKspGUU3kq+iPdT+d/igiyt84UEPC21M0rkioKMiOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744637546; c=relaxed/simple;
	bh=9J/z5T0JY/xcwsk6SXFTA+zsyiZ/gs3asCJyO6IhBN4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=XSxxdAtNhVH2hkaC+Qd4q1XICTeBE42sNMOY35Aaq3Jwh1KsgKSBwhtjb+lY1OcB4wuuWLF503wkiY5uBWTstvM5K1kexqNPkJEOPGesMdadHdGpcTRuCfPj697EFOeHBnSDaGbN628xWn/4kQLQM6wBeODVAKO5Ym4w6PwKSxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J03RGJEy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E31C4CEE2;
	Mon, 14 Apr 2025 13:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744637546;
	bh=9J/z5T0JY/xcwsk6SXFTA+zsyiZ/gs3asCJyO6IhBN4=;
	h=From:To:Cc:Subject:Date:From;
	b=J03RGJEyomZjf/3It0L+Clx2tw3375in/HQxmp5az86CVy6TrJ8YjjVfV0AmEtlAz
	 rjtNG8AWN7Kdv0vTw891A6e67jSc7xyp4a3JO5sg6PhoZEQZNDGevW5bAjFtQD+5uo
	 fe/1wnPpZ1uRXl6MJac1pv5IXJUY5DMYAZGlX/EOXEHiqn7VyHOdf0qSv0SEoB32p9
	 0buFeAP/vglvgqVY8vQnbZU1eULAYGFtclBoMiZfRZNJg3BUJZZJGSSug8YYO9T6U9
	 s2MbHGdbo70WCZXLJ202Uvns1v0jzbA//rC60F8c2Sh4iRrEtzl/aUCKhGJqSJV7Pn
	 /n5ebItL6rE+A==
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
Subject: [PATCH AUTOSEL 5.4 1/5] KVM: s390: Don't use %pK through tracepoints
Date: Mon, 14 Apr 2025 09:32:19 -0400
Message-Id: <20250414133223.681195-1-sashal@kernel.org>
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
X-stable-base: Linux 5.4.292
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


