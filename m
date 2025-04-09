Return-Path: <kvm+bounces-42976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9DFCA81A9A
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 03:42:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 905C41B831D0
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 01:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A30194A45;
	Wed,  9 Apr 2025 01:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IRMilrGf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF1A1519A2
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 01:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744162922; cv=none; b=ol9kJDilZjI/jYrP0lh+UyhyKDy1wig9m/nK10IjUHeSesa0ddUIlFz7q3/Yh1Ye7HGAWSLy1wnJXpB5CqnhKCHmlbFHz9D/RqebF+D43gA87P3pGJpGIMrsuDoyMZ45kjNVsbAz0zxcrFTqsKjqEiJYWtrSW7QrtSZp3eY3Hzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744162922; c=relaxed/simple;
	bh=Mmr+9lhJqZZzoEoO+XRdi5Oquv1oYt27Mf+xN8Jv0bs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OE2f72FCkqdKC9qVGOdN/6EVqLi9pfIHIRwP4iVRjSgw2BxpYsSLR8uoRMnPd4E9sz7Yza4jOV6ZjN2L9jpmv2Oqm/n+Svc/OS3wb8PwmDj3INw7/1/llvEIUmm3uF22bcgDnNLMut/FlVmB88sx1qtfdj7cQFNuRX/y9HDs++k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IRMilrGf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744162919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LhiIhuo/fjhkoyOs0BBqrbek6FZF30QwERtnCpHBTlw=;
	b=IRMilrGfzS1Johw4ZC1AbMh/OzIVNDfJ3M/yRTUEaAcTn0J4nM3OpKsrc1oxO7PkRD4D5X
	HFmV6tIpSW0Mo+e79hQCqao/coH9o8pkBa9jxJazfKCkvl126pkz+wczMXG4YYh8unQGiC
	NyzMMpoPq9zm3JA4qSv8mqATWT8XY8c=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-173-bshH0SpeOH-i_bIS38j1zQ-1; Tue,
 08 Apr 2025 21:41:57 -0400
X-MC-Unique: bshH0SpeOH-i_bIS38j1zQ-1
X-Mimecast-MFC-AGG-ID: bshH0SpeOH-i_bIS38j1zQ_1744162914
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 077561956080;
	Wed,  9 Apr 2025 01:41:52 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.191])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8497F180174E;
	Wed,  9 Apr 2025 01:41:45 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvm-riscv@lists.infradead.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jing Zhang <jingzhangos@google.com>,
	Waiman Long <longman@redhat.com>,
	x86@kernel.org,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	Borislav Petkov <bp@alien8.de>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Sebastian Ott <sebott@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Will Deacon <will@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	linux-riscv@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v2 1/4] locking/mutex: implement mutex_trylock_nested
Date: Tue,  8 Apr 2025 21:41:33 -0400
Message-Id: <20250409014136.2816971-2-mlevitsk@redhat.com>
In-Reply-To: <20250409014136.2816971-1-mlevitsk@redhat.com>
References: <20250409014136.2816971-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Allow to specify the lockdep subclass in mutex_trylock
instead of hardcoding it to 0.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 include/linux/mutex.h  |  8 ++++++++
 kernel/locking/mutex.c | 14 +++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 2143d05116be..ea568d6c4c68 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -193,7 +193,15 @@ extern void mutex_lock_io(struct mutex *lock);
  *
  * Returns 1 if the mutex has been acquired successfully, and 0 on contention.
  */
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+extern int mutex_trylock_nested(struct mutex *lock, unsigned int subclass);
+#define mutex_trylock(lock) mutex_trylock_nested(lock, 0)
+#else
 extern int mutex_trylock(struct mutex *lock);
+#define mutex_trylock_nested(lock, subclass) mutex_trylock(lock)
+#endif
+
 extern void mutex_unlock(struct mutex *lock);
 
 extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 555e2b3a665a..5e3078865f2b 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -1062,6 +1062,7 @@ __ww_mutex_lock_interruptible_slowpath(struct ww_mutex *lock,
 
 #endif
 
+#ifndef CONFIG_DEBUG_LOCK_ALLOC
 /**
  * mutex_trylock - try to acquire the mutex, without waiting
  * @lock: the mutex to be acquired
@@ -1077,18 +1078,25 @@ __ww_mutex_lock_interruptible_slowpath(struct ww_mutex *lock,
  * mutex must be released by the same task that acquired it.
  */
 int __sched mutex_trylock(struct mutex *lock)
+{
+	MUTEX_WARN_ON(lock->magic != lock);
+	return __mutex_trylock(lock);
+}
+EXPORT_SYMBOL(mutex_trylock);
+#else
+int __sched mutex_trylock_nested(struct mutex *lock, unsigned int subclass)
 {
 	bool locked;
 
 	MUTEX_WARN_ON(lock->magic != lock);
-
 	locked = __mutex_trylock(lock);
 	if (locked)
-		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		mutex_acquire(&lock->dep_map, subclass, 1, _RET_IP_);
 
 	return locked;
 }
-EXPORT_SYMBOL(mutex_trylock);
+EXPORT_SYMBOL(mutex_trylock_nested);
+#endif
 
 #ifndef CONFIG_DEBUG_LOCK_ALLOC
 int __sched
-- 
2.26.3


