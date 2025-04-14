Return-Path: <kvm+bounces-43239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A48F6A88342
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 15:53:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57C371888760
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 13:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2DBB2C0AED;
	Mon, 14 Apr 2025 13:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+ZA/MO/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECE82C0319;
	Mon, 14 Apr 2025 13:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744637400; cv=none; b=pbi0TKzSUZar7qEiOOPjXjaAYuBuDmw1Py9l24r0uOvPBAIvw3vHr+nz2Eoa4gC3NTnNi2GJyBM3UB45XdK450PyQwRpifjum6cPaCM7unrQQnSOJ3YC4tmHfnE2sHTu09BI7W50nXyYh/Tt4cpm+Tx+/XHoOin16CnyDZtSWzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744637400; c=relaxed/simple;
	bh=9J/z5T0JY/xcwsk6SXFTA+zsyiZ/gs3asCJyO6IhBN4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=ud4aZTe4dPpbEE7gClS22r0kBzTpiRiIs7b9yAzcGTEyjWlDU/KHk02TGcti2RRmXemWkchpSmNs+JaAjFfFEM6Oo0bzNXQGizlmyM9EP36oo+xb2KbNtoMVD+iA3Mi07EM+8Jm1B46GYjOc+zE7cTRMbDbMN+gg9EK6uLFPxUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+ZA/MO/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005E1C4CEE2;
	Mon, 14 Apr 2025 13:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744637400;
	bh=9J/z5T0JY/xcwsk6SXFTA+zsyiZ/gs3asCJyO6IhBN4=;
	h=From:To:Cc:Subject:Date:From;
	b=X+ZA/MO/6pO3VZKIoY/rjL1w0VrNTYq6gu+NjqK8kpc8XxPr3dkU5Owgguif21Egj
	 48P3QvjBe/3ZNnBnc4KT55VFpn2PhseKas70t5kD8ul0l7WBVjbJ1TUYWpp2nGho+D
	 /pD/kIN3FlHoI1cL9uFHRzjQ1ejPLtb4e9GP4MeuTlakcDDb4hJmIyHw+2ijdNUNZA
	 xwpi8M8jIG11FP/OVTVuqQlDeYXdNZjqORRcmbZOiuFkKE+K8DHdG/Nnq49JdCxmY1
	 dqwAwIG9GQs26j3cEvO4XJSgYic1xBibwxSbQvOmHjiYzQq38Ud7Pm/xoSMsjAzgnr
	 36UX7cj/gQDpA==
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
Subject: [PATCH AUTOSEL 6.6 01/24] KVM: s390: Don't use %pK through tracepoints
Date: Mon, 14 Apr 2025 09:29:34 -0400
Message-Id: <20250414132957.680250-1-sashal@kernel.org>
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
X-stable-base: Linux 6.6.87
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


