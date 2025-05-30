Return-Path: <kvm+bounces-48082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98B00AC8970
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 09:52:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C6473BB708
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 07:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E9D721578F;
	Fri, 30 May 2025 07:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XCqzLqhB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324F1211A00
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 07:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748591511; cv=none; b=qePVax2GDoYP4Os31Vqb3fkynDuTtbO6XEFP6jYH6Sjw8XUrCwgN0IGv5l5Dl/t5KaRw7XmvFPh0vx2Hix/47G7NHEfuXX9KAfxz/OiXNtgaVhDbtoObDSwW+NTnA8AEw8MgRjHEFu62+Xh3Lhg2QnvOnVXCH5bKt07aVve8Cys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748591511; c=relaxed/simple;
	bh=heeIOL6qrwWqY0Nmtg7onezs8AdPiDAwyThpEMRCb9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WSTxqGNJplmRBS5z0BKciU/o/2eaNypHC6lPx1GuOFmYuVnGSZ3euk3wMcue3dvx1CnDxWa312h5zQbJvvoMnk4zGlENdSSKKh/fvwdWqXSob8z6DQm868QIF9MduIEJ61hqNsOjevE3oP2WY2h8Dg/ySu6h2w5TzKBZXlKSuuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XCqzLqhB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748591509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9DYj1nT/97zCT+d8x1OHPDM3aXSO963AXfenW8dTS4c=;
	b=XCqzLqhB/jrx0tPdqIjFUsMmyyIR2RjT8h8J6yGjM4tsK5Z+9rlrQv3TxCWn6i3dREOhxx
	lsicvzO8HThzuoaimSKlaPaEsS9DSFYroH4jLbZoyAcM2q1uBUCMrAUlt4LsCA9SvtAI9q
	GJZHlQb35TBHcfhs/k0n+3yiq1g7j64=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-I-xfwfSWNeijiu42a9oRiA-1; Fri,
 30 May 2025 03:51:45 -0400
X-MC-Unique: I-xfwfSWNeijiu42a9oRiA-1
X-Mimecast-MFC-AGG-ID: I-xfwfSWNeijiu42a9oRiA_1748591504
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 80080180045B;
	Fri, 30 May 2025 07:51:44 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2D87E19560B7;
	Fri, 30 May 2025 07:51:37 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] rtmutex_api: remove definition of mutex_lock_killable_nested
Date: Fri, 30 May 2025 03:51:36 -0400
Message-ID: <20250530075136.11842-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Commit fb49f07ba1d9 ("locking/mutex: implement mutex_lock_killable_nest_lock")
removed the "extern" declaration of mutex_lock_killable_nested from
include/linux/mutex.h, and replaced it with a macro since it could be
treated as a special case of _mutex_lock_killable.  It also removed a
definition of the function in kernel/locking/mutex.c.

However, it left the definition in place in kernel/locking/rtmutex_api.c,
which causes a failure when building with CONFIG_RT_MUTEXES=y.  Drop it as
well now.

Fixes: fb49f07ba1d9 ("locking/mutex: implement mutex_lock_killable_nest_lock")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 kernel/locking/rtmutex_api.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/kernel/locking/rtmutex_api.c b/kernel/locking/rtmutex_api.c
index 191e4720e546..0c26b52dd417 100644
--- a/kernel/locking/rtmutex_api.c
+++ b/kernel/locking/rtmutex_api.c
@@ -544,13 +544,6 @@ int __sched mutex_lock_interruptible_nested(struct mutex *lock,
 }
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
 
-int __sched mutex_lock_killable_nested(struct mutex *lock,
-					    unsigned int subclass)
-{
-	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, NULL, _RET_IP_);
-}
-EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
-
 void __sched mutex_lock_io_nested(struct mutex *lock, unsigned int subclass)
 {
 	int token;
-- 
2.43.5


