Return-Path: <kvm+bounces-38371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D5E5A38475
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 14:22:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5A9F3B83F6
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 13:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7579223707;
	Mon, 17 Feb 2025 13:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="VPswdQiJ";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="n4ep0YIv"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E19921D59C;
	Mon, 17 Feb 2025 13:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739798047; cv=none; b=RMRUQyxcrGYgsTtxVsHw9oE5DIiFi3aJvyOp/wRPqUA48PMQuP0f2mPk/v8Y/ADAiQhFPaafB7jZQVqKyUwTqHHs2KBLvSfo3lpCIx4ICYtdr6i1367asGAOzRgP3sKlGcIOqd46PFimN3929IXg4fI5mk70gJ9ZWIx2gtq6aDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739798047; c=relaxed/simple;
	bh=2kmL+BAnB7NS9Aj5OTlzQFbWqgfPJHvvgrPLBdrYbMM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AF+d144NwIHoulMlWOKDZxfgNAR6YV36oZoLah5N64N7YUdqLTABnDLgI39jF+wTeHLHNqm97WzoOYQHR8Sy/HwpvSyyg1r1zQq7pWyc5n6GbMarYLVJko6ubc3aM+7v7ZsCc6YtkvUiHvYaCAJQAz5553o2NQcPdsOMoat8D1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=VPswdQiJ; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=n4ep0YIv; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1739798043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eowjROTbOgPyyFnSOZ84+8sTVh+30CEdQtc0/iXaL/A=;
	b=VPswdQiJn6zLKFZKExO3U/OUI8Ol3rUDCRpWtuO1rUWiXw03StpP6We6x5OQhu59mOuIZt
	+YSbw+OkDC8dDDgSBawWrnLCmM/eT6MG5hlInsF8zigGg0wXIxkGjVr17CKVeCs+Lyqv+D
	GioGtRjanPu+AANjVZjK134oYYe/NPgjrxPuCQsZZ7kRykpxjYr5GhHLuY7MMOU4XxJ3jr
	a1qOlayxZWniWTuX9Tc8SHWY0onUa8xbhdL3T0vxx18oqxM6nxnMPQGMqIX84AN10AhW/C
	ERNy2HUttWtjbI+rj83j4rtHxS3AHSGCm3wiTW+nUhUAeReSX336lShNMj8YTw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1739798043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eowjROTbOgPyyFnSOZ84+8sTVh+30CEdQtc0/iXaL/A=;
	b=n4ep0YIvYzJZ8wC/05O76sdzh9N+1qx3vjmG4pKNYlJ/vHlQyVNl9+vkXp81ZuRzsHMnW/
	qR0tpIrW2QL5x/Cw==
Date: Mon, 17 Feb 2025 14:13:56 +0100
Subject: [PATCH 1/2] KVM: s390: Don't use %pK through tracepoints
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250217-restricted-pointers-s390-v1-1-0e4ace75d8aa@linutronix.de>
References: <20250217-restricted-pointers-s390-v1-0-0e4ace75d8aa@linutronix.de>
In-Reply-To: <20250217-restricted-pointers-s390-v1-0-0e4ace75d8aa@linutronix.de>
To: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 David Hildenbrand <david@redhat.com>, Heiko Carstens <hca@linux.ibm.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1739798042; l=1259;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=2kmL+BAnB7NS9Aj5OTlzQFbWqgfPJHvvgrPLBdrYbMM=;
 b=JqkYSqiiUVpveHKAjrDtCbWpu6IutmECi86bmUSncWZUo/vp4oNR6YBRscrDNu0jJCHosiBgi
 Oj+X/m3vqQ6DdqZG/4WQFt85k7bBxogupt4X40iySvYGMGmo0dnb25A
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

Restricted pointers ("%pK") are not meant to be used through TP_format().
It can unintentionally expose security sensitive, raw pointer values.

Use regular pointer formatting instead.

Link: https://lore.kernel.org/lkml/20250113171731-dc10e3c1-da64-4af0-b767-7c7070468023@linutronix.de/
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/s390/kvm/trace-s390.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/trace-s390.h b/arch/s390/kvm/trace-s390.h
index 9ac92dbf680dbbe7703dd63945968b1cda46cf13..9e28f165c114caab99857ed3b53edc6ed5045dfa 100644
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
2.48.1


