Return-Path: <kvm+bounces-43235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B632DA88276
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 15:36:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B588F188699C
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 13:35:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC8482798E6;
	Mon, 14 Apr 2025 13:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N5HeCQ6F"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E919828A1F3;
	Mon, 14 Apr 2025 13:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744637253; cv=none; b=C/n9ytXrlxnyG7KKxtolxiL6zsY9sZluCnYNy8mAZs3+jzHYTHcPcVf7UrlrzeMgWsuXFT7i9oLPGqU1qgZ1ukn7670e7de2OifPQhMxPynQltatT+yN0s1CIJ5RgCAVnApuklbuhD+brnLw0qEQYXoQSrZ4N4GLIXj+wfILAY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744637253; c=relaxed/simple;
	bh=oH1eW4mjfFf+HBxbIxg/zlJ2VSYoPk4kQzYqfN4r4wE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=GLsvDKTs2WGqkmwvnaULJgA2azYDZMgesbjnoWjuxpNsqPTMGpWYe+fxKF2I6lnlP2aKjdsajTVxAumQLmOMXc9CLXA7/4i/FoXNp7sT4iSF1yZxW4bNZRZegq4S9rrO+NTPJetTHpjFh2SDSp2RIK3L+sMHTM9NpkB/w9m2/4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N5HeCQ6F; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B90C4CEE2;
	Mon, 14 Apr 2025 13:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744637252;
	bh=oH1eW4mjfFf+HBxbIxg/zlJ2VSYoPk4kQzYqfN4r4wE=;
	h=From:To:Cc:Subject:Date:From;
	b=N5HeCQ6FZcrXHPvMQQFxZSzvT4PI0w0sSNCGWhlDIC2PtjOfcSyL1soT4/oB17j1X
	 DCeGhUMY4J034DTmyYdXgQ+4mi9Qdgo0Uo/7Fyi4CBFG/0lmAnvmyZCnQFFCy0mhY2
	 snR6B5+K8QLxHX2I4mOCnmfSgw0sUBwwj/xe98zrPoV5PsPYbEjmyMLpidT1jTnetp
	 LsTo08EI+GRIWRFfQfnIsv/voeowhrksNysHXXLfKCva/GdTjeyl5r1sxWRyP77pA6
	 qrDIfEv3J3gm6HUmTRLvovZCWs4H46KMC5S3Z/ItMpul5zJIak90+LmjE4sbV1abgu
	 E+TpFWn/bRIvw==
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
Subject: [PATCH AUTOSEL 6.13 01/34] KVM: s390: Don't use %pK through tracepoints
Date: Mon, 14 Apr 2025 09:26:55 -0400
Message-Id: <20250414132729.679254-1-sashal@kernel.org>
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
X-stable-base: Linux 6.13.11
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


