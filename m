Return-Path: <kvm+bounces-43233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 05023A881EF
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 15:28:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5FF3F7AA97D
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 13:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 583DF2749E9;
	Mon, 14 Apr 2025 13:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ClTieWqt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F43E2749D8;
	Mon, 14 Apr 2025 13:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744637175; cv=none; b=LHGolu9SIWyFlHUSOvE8cZE/lMjnMpzTYdCwptdErLv/lyNy38FtuWHxK2mB37/vZq8IvxKarChbG/cz3ni2lxJ6fS0gpsUP2JwdrDL/D0qdsyKV9X/RUIlRkrQ/nZsNT6mkJ/MexV5XDTU7+Mxzx8GYSGZOi0RulXHhVZnNqZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744637175; c=relaxed/simple;
	bh=oH1eW4mjfFf+HBxbIxg/zlJ2VSYoPk4kQzYqfN4r4wE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=bpjXJOCkTcbuJ+hnAz6RrFxs5FaZhFYD9gw0awBIjZHejNtL2mkIVowxGrBNg12YhnhexeCZgoWNHy+/+pJHy0aqkihbuDwVC1oJhUFb+3w2eEJgzRpc3+YBAqSNl1txY49GCqe+g2nEicljg/t3i5wJaKq/LG9jThCwfWwhHR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ClTieWqt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2518FC4CEEC;
	Mon, 14 Apr 2025 13:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744637173;
	bh=oH1eW4mjfFf+HBxbIxg/zlJ2VSYoPk4kQzYqfN4r4wE=;
	h=From:To:Cc:Subject:Date:From;
	b=ClTieWqtxrqxGiA2/SNzASWD2Tclqd7aiV982K6NpEi0Snv+kj3y4ciSSV/GORODF
	 sKKlaa+IygV7Veqrrx4HCcyjNsXdSGy5R+9VrC+m4D1++4nJg3kHkWpB40MAxNkwgb
	 g0VeqM33NzokF6cF3kg25EzJqz6kj53f2u98i0qhLtITBY0rJsmPTVDtJ+5GYW1F2p
	 QynCMlfWparhqwiaY0xNuTtLT7oCRaF1Pnxol9ojXe2miX9cU1OIo5g/LKdNP8GMwp
	 HQs5MpuWbunk5xSNPlquQthD0F2WXvPVOp4HXXdxxDQDW2asHGZNNQygBtaC7JjHWE
	 lefScQC4urKqQ==
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
Subject: [PATCH AUTOSEL 6.14 01/34] KVM: s390: Don't use %pK through tracepoints
Date: Mon, 14 Apr 2025 09:25:37 -0400
Message-Id: <20250414132610.677644-1-sashal@kernel.org>
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
X-stable-base: Linux 6.14.2
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


