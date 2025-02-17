Return-Path: <kvm+bounces-38370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C819BA38448
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 14:15:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C704A7A142C
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 13:14:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4484022331C;
	Mon, 17 Feb 2025 13:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="DGRCHdDl";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="sE590qr1"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA9921D58E;
	Mon, 17 Feb 2025 13:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739798046; cv=none; b=kMCtxEhH3FNzjGbRJxHFc8+rymBRPa4Vc4VWQ+fh0GpVdrQVVcQHfNJTfctPZxK2VFot0IZaBK/bYUmMVRwZmXe9KMdeRLLzcVWkKyIfjDX1DzicqSvWvByeKwdQBptq52tSro+7Qun4UPIXKFymXvaAqFDcEuFThRPW+5CFVg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739798046; c=relaxed/simple;
	bh=T3j+AYNu9upsSFRF5dhT7V0Vi97Ed+N9htp0EsDIQJM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=DVBwGQqUdmzVnSYNZ3xpdPO1Ce8F4VauKAR6nTA8ztxIoGhtwkRfieWN4FAX92tsal5ALKgYe6z5GNh31wWK9B6IxsoeIddIcJRQ/IIYd87XT/LCd3Z5UQ+oTVa1hH0vAokzkEMmooYp5gMEcL45zSOyyekRViDDzavLmzdtezU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=DGRCHdDl; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=sE590qr1; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1739798042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8Fmtlx2EnEL7LBpnjLPYYhL0crulD1yNwRs5P9WAM/0=;
	b=DGRCHdDlnrIwpt2GOdp5wboYwtxMEZ/iN/eHHWYhtiMXN+Bo5BiLMhYVFokOaj7t8tbRcf
	PRqklElLoBReM7bQgST7jWvHPCXDzPIxyXm1vxWxAe19JqtpAs4hL7UcCzHx2WuDcxflZr
	Y/klFFC7DJy+EXFwo6i3T0NM9HbIe2+JSstHedjsftGnvypDXf4VzkFfKQ9p2AF0I69T32
	ePXgwvWGpIv07hXp/w1KUILDGzDqv+nm1azL2knO/ycLAv9JZH9rk/x7BWkFLe2K6Ng1hs
	/SDWLtTPJf+C4/fQnRkw82El8JmQFGyMSWLfdSHPmsPM0qIcLXt1Df1s1G8G6Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1739798042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8Fmtlx2EnEL7LBpnjLPYYhL0crulD1yNwRs5P9WAM/0=;
	b=sE590qr1pRljibC0euLNnkODpzZE2nlryOOk/bxo08kdW5v5r8wyu67BWNLLH9Qdp3EjaE
	hgkdj2oaWY4dEXCg==
Subject: [PATCH 0/2] KVM: s390: Don't use %pK through debug printing or
 tracepoints
Date: Mon, 17 Feb 2025 14:13:55 +0100
Message-Id: <20250217-restricted-pointers-s390-v1-0-0e4ace75d8aa@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIABM2s2cC/x3MywqDQAxG4VeRrBsYZ6gSX6V04eVvzWaUZCiC+
 O4OXX6Lc05ymMJpaE4y/NR1yxXto6F5HfMXrEs1xRCfIbY9G7yYzgUL75vmAnP2JIETJE1dP4p
 IRzXfDR89/uvX+7puRiNlp2oAAAA=
X-Change-ID: 20250217-restricted-pointers-s390-3e93b67a9996
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1739798042; l=956;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=T3j+AYNu9upsSFRF5dhT7V0Vi97Ed+N9htp0EsDIQJM=;
 b=dqogSa5t7A9u/cS3WyJYvfjprx1m0h+qPLyEIyiOXCNTkVMAcLQxEhswSLmmKOlYeH1zP8Zo8
 2sCGR1Es68ZAuHyERqQZ9j69EyMeZjq4s/2Sz/TcTKFz/diVktBwrZM
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

Restricted pointers ("%pK") are only meant to be used when directly
printing to a file from task context.
Otherwise it can unintentionally expose security sensitive, raw pointer values.

Use regular pointer formatting instead.

Link: https://lore.kernel.org/lkml/20250113171731-dc10e3c1-da64-4af0-b767-7c7070468023@linutronix.de/

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
Thomas Weißschuh (2):
      KVM: s390: Don't use %pK through tracepoints
      KVM: s390: Don't use %pK through debug printing

 arch/s390/kvm/intercept.c  |  2 +-
 arch/s390/kvm/interrupt.c  |  8 ++++----
 arch/s390/kvm/kvm-s390.c   | 10 +++++-----
 arch/s390/kvm/trace-s390.h |  4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)
---
base-commit: 0ad2507d5d93f39619fc42372c347d6006b64319
change-id: 20250217-restricted-pointers-s390-3e93b67a9996

Best regards,
-- 
Thomas Weißschuh <thomas.weissschuh@linutronix.de>


