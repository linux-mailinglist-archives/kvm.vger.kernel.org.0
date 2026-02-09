Return-Path: <kvm+bounces-70609-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cDR7A5wIimluFQAAu9opvQ
	(envelope-from <kvm+bounces-70609-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 17:17:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C1E3E1126E3
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 17:17:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2E24B301ABAC
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 16:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21E333815E5;
	Mon,  9 Feb 2026 16:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S7Swxfqq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453C437BE6A
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 16:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770653846; cv=none; b=jjpxN5Uu4TXj7CfnRuwbdaaIn0R00JMOWM6cVGN6cUJH9NyEPAU2q4wYdGBMAbbhY/O8oaGBOrmbVMzTAZnrh98SHkJgAsjDDhIoj7xjboSyKY73mGwoZKrT9x1LVfUqsSRRiRlhWjAirspbq5YoHFemh1xXBkjgUBGSDSLcUgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770653846; c=relaxed/simple;
	bh=QLn9UJBSWT6jlcMbbaZa68IHkR+F3SHMyeahLxtfE60=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iIjmlG5PrSuH4dGYoBjH46g7SgRjR2i0CiHxARQy0Ycytl2slRO0HhWjDkVlV46szUOQRQSZKMxRhI2zw79IuxfZuLA7PDzEVgru8EI0Nesq1WTmToKmKPXsztIQKmgj0yHnTUq4acDCKHOKKEBFaT3V9+8h5fljniTJzRdcR/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S7Swxfqq; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2aad1bb5058so20811075ad.0
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 08:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770653845; x=1771258645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fYDQcjBg2vU5GI5xW0lALxWdgLiVRXFArD5ZQ3GcGuo=;
        b=S7SwxfqqMrxKSQQtGTaXq87sQn+2KFaEZvosOmlT8RgUIPnma/+CXHWaWlZFuHyMVc
         hc6DrjZpl7SSjLKxT8DGz4u8MeHq8wBQ7USoGO4UJWy8xqGwrnMHrAxkrL6JDKnK7JLl
         WzxFHf9bhSpM56nwotucL/+pcH1Y7TdzKzNDp5xyRJSzrrKMgapqs8JzSH1ikcS9DNcM
         JbtDZBOBdN/K+1pTiaxesS1ALO6tpKtq4YbjnqMcfM2rYkDayaXlAp0dGOndtWHvn6nE
         rmUrLfvDv6+l+O1uKhYwdSRY4EQ1QErEIJThIY7gxe3QoC0BT0k0fU7h3p1PctTHjry5
         mB6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770653845; x=1771258645;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fYDQcjBg2vU5GI5xW0lALxWdgLiVRXFArD5ZQ3GcGuo=;
        b=qO/Y3ZoKgXTKg0kN1haJGfiQspvEj474FsmuoU7sLUNAq51SqW9OD8DoNw/kJEp6K9
         cQ4cRkR821OVnfQWDuCJm9B10RaFpwd8fOE6BBuFGieVmz0hURfhxN2K0+Lft04zGHZs
         dycKNJlvp1JClgVq7gOYoB323F44FGkcUyKLsWi5KSnTiN69ItiwC+vA49f7tE6JAbeR
         tPnYii+orNE1Y3hbp7B79Z3bclYxKKYYsMrrjwa9NiSr5JXg9jWNUQwhgQIRR0mb28Mg
         JlqXH4stH0U+DyG4vfgNcJlnas/LDV3LwQvzQZyUlgT1GKcuCW7B1NF3QlHmyGh8q1pb
         fFOQ==
X-Gm-Message-State: AOJu0YwP7js/ROWMJcJQJL2h4tgsMskRkOt4TXntMKQ/KVeorZZwibNT
	WjPrIeGKFmlpUXQLOB6qe3HjgYsc6XWbGk82V9m9APZHf73YFGn79hoMjXTgnQ==
X-Gm-Gg: AZuq6aK93t0dvOxaU6Otw7QygpmhoUVDVsqxUwE3LmWWjfmSuyDM8TGnlWpT6k8puTC
	U1KW8iVam/TrHuTDMinysAJY/KA9Z6UlZTS8l8xDj7nb+Sktgt9n4Lew/Fa3vVAx0fO24n0eOdE
	QmJURXKB9GbYV3pdmGUUekQtgh5LaApgjzPTV1N9iNzKl5ZFvY+uV5MN6f87QlQIsI9Lw6nende
	mV1kNApjnycxDPnsWgAcIjYS0I9OYRakMqQyA3N9RJq7Ef3lsZ1s1bUlbeQv/Z5pFuWJ9AdyNJh
	4H2P+K8eNNYpKnel/rF9NTDt20v5c17JFwFeIHUoKAzuyM79mZjKn24sIBDv24ul7zZUufe0OKF
	C1HzToiwiV7hW7qrrPU4t8t3itpwBRvalLi6qcgbD6j9s22+gMwkyurv6H7KjFxgB7UPC0ruc2K
	hw+UukCQqZ8shDZRuYOQM6EtieCOkCOPeKrQWa5g==
X-Received: by 2002:a17:902:e54f:b0:2a9:6165:6e87 with SMTP id d9443c01a7336-2a96165754dmr82914955ad.59.1770653845268;
        Mon, 09 Feb 2026 08:17:25 -0800 (PST)
Received: from acer-nitro-anv15-41.. ([27.7.91.133])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a95bff42f7sm91648125ad.68.2026.02.09.08.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 08:17:24 -0800 (PST)
From: "shaikh.kamal" <shaikhkamal2012@gmail.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: "shaikh.kamal" <shaikhkamal2012@gmail.com>
Subject: [PATCH] KVM: mmu_notifier: make mn_invalidate_lock non-sleeping for non-blocking invalidations
Date: Mon,  9 Feb 2026 21:45:27 +0530
Message-ID: <20260209161527.31978-1-shaikhkamal2012@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70609-lists,kvm=lfdr.de];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shaikhkamal2012@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C1E3E1126E3
X-Rspamd-Action: no action

mmu_notifier_invalidate_range_start() may be invoked via
mmu_notifier_invalidate_range_start_nonblock(), e.g. from oom_reaper(),
where sleeping is explicitly forbidden.

KVM's mmu_notifier invalidate_range_start currently takes
mn_invalidate_lock using spin_lock(). On PREEMPT_RT, spin_lock() maps
to rt_mutex and may sleep, triggering:

  BUG: sleeping function called from invalid context

This violates the MMU notifier contract regardless of PREEMPT_RT; RT
kernels merely make the issue deterministic.

Fix by converting mn_invalidate_lock to a raw spinlock so that
invalidate_range_start() remains non-sleeping while preserving the
existing serialization between invalidate_range_start() and
invalidate_range_end().

Signed-off-by: shaikh.kamal <shaikhkamal2012@gmail.com>
---
 include/linux/kvm_host.h |  2 +-
 virt/kvm/kvm_main.c      | 18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d93f75b05ae2..77a6d4833eda 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -797,7 +797,7 @@ struct kvm {
 	atomic_t nr_memslots_dirty_logging;
 
 	/* Used to wait for completion of MMU notifiers.  */
-	spinlock_t mn_invalidate_lock;
+	raw_spinlock_t mn_invalidate_lock;
 	unsigned long mn_active_invalidate_count;
 	struct rcuwait mn_memslots_update_rcuwait;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5fcd401a5897..7a9c33f01a37 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -747,9 +747,9 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 *
 	 * Pairs with the decrement in range_end().
 	 */
-	spin_lock(&kvm->mn_invalidate_lock);
+	raw_spin_lock(&kvm->mn_invalidate_lock);
 	kvm->mn_active_invalidate_count++;
-	spin_unlock(&kvm->mn_invalidate_lock);
+	raw_spin_unlock(&kvm->mn_invalidate_lock);
 
 	/*
 	 * Invalidate pfn caches _before_ invalidating the secondary MMUs, i.e.
@@ -817,11 +817,11 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 	kvm_handle_hva_range(kvm, &hva_range);
 
 	/* Pairs with the increment in range_start(). */
-	spin_lock(&kvm->mn_invalidate_lock);
+	raw_spin_lock(&kvm->mn_invalidate_lock);
 	if (!WARN_ON_ONCE(!kvm->mn_active_invalidate_count))
 		--kvm->mn_active_invalidate_count;
 	wake = !kvm->mn_active_invalidate_count;
-	spin_unlock(&kvm->mn_invalidate_lock);
+	raw_spin_unlock(&kvm->mn_invalidate_lock);
 
 	/*
 	 * There can only be one waiter, since the wait happens under
@@ -1129,7 +1129,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	mutex_init(&kvm->irq_lock);
 	mutex_init(&kvm->slots_lock);
 	mutex_init(&kvm->slots_arch_lock);
-	spin_lock_init(&kvm->mn_invalidate_lock);
+	raw_spin_lock_init(&kvm->mn_invalidate_lock);
 	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
 	xa_init(&kvm->vcpu_array);
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
@@ -1635,17 +1635,17 @@ static void kvm_swap_active_memslots(struct kvm *kvm, int as_id)
 	 * progress, otherwise the locking in invalidate_range_start and
 	 * invalidate_range_end will be unbalanced.
 	 */
-	spin_lock(&kvm->mn_invalidate_lock);
+	raw_spin_lock(&kvm->mn_invalidate_lock);
 	prepare_to_rcuwait(&kvm->mn_memslots_update_rcuwait);
 	while (kvm->mn_active_invalidate_count) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		spin_unlock(&kvm->mn_invalidate_lock);
+		raw_spin_unlock(&kvm->mn_invalidate_lock);
 		schedule();
-		spin_lock(&kvm->mn_invalidate_lock);
+		raw_spin_lock(&kvm->mn_invalidate_lock);
 	}
 	finish_rcuwait(&kvm->mn_memslots_update_rcuwait);
 	rcu_assign_pointer(kvm->memslots[as_id], slots);
-	spin_unlock(&kvm->mn_invalidate_lock);
+	raw_spin_unlock(&kvm->mn_invalidate_lock);
 
 	/*
 	 * Acquired in kvm_set_memslot. Must be released before synchronize
-- 
2.43.0


