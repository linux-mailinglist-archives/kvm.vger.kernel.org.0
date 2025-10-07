Return-Path: <kvm+bounces-59609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C915BC2DC5
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 00:24:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 15DCA4E6D91
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 22:24:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C31E258CCB;
	Tue,  7 Oct 2025 22:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MiXN+BvG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84B225742C
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 22:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875842; cv=none; b=HSCwcRxLtDBiC5xklG3bPMmUzllfFZuzSZxJCu+kE2Og+HNk18Hk9cCV3LZUIHQGiPERl48Enj9nPjKEc9O4UHPVHIiaGurubg5H+8ZAaN6zJHTywcvKIrmbn/URkWBMaLp32Qw85YaHthI4zvnXOusHovT1qogaKziwLm5Olzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875842; c=relaxed/simple;
	bh=iTs5oVgRFI5i7Id7pBmKWAvJOIiaSNf/FcvJpYTbgXc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IqArYWzkdhgGLSfCLParjC3tuvFuwgCkKzyrzVs8C1T/hJ1lfn1JBjNIrcJEI9OVX3ORZMiRBGux/iULbU0Bf4V4jgXAz+wnJTjXf6GQR9kZsLityHKcMPA8KhGpqADliGU9RdlYvNbYsu7E7m1gC4TxuVKOGDA+9S+3ggVvjUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MiXN+BvG; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-269af520712so74322695ad.2
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 15:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875840; x=1760480640; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KzhA3wq+r3uRjE3qvTCw8lzfD+9cuHGzBHwE0Qeo1M4=;
        b=MiXN+BvGJ6+5PY4ZOzYQQjAdDZoFseQEqTn4wp8N1FO24WGUyH06CdwOTE/LaaPMJh
         n5x793lws6sTP1MxezEZA0oZee2GYqRibvVYIlue6N9Oi9kcH7H+Zf1eBFZwjpvqYYre
         S/B9ftMwUMzMj8EX797hN3494bxzXUK/Sj4IIP5SiqczslQDZcjAY/LP8DY9IQKMULCa
         pRX8unmXD6q7F+BGQTHBNBkY+lPC8NzfplNJo3G70r/0dMvhjD9gOdEd1ZqjZpdbyUhC
         GNeWR1U2X8mlUQ8oIElzUmqQB5BoRA/VbVZdRwfk1i1N858uYNnLag5pU56d+aMNCU/5
         syaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875840; x=1760480640;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KzhA3wq+r3uRjE3qvTCw8lzfD+9cuHGzBHwE0Qeo1M4=;
        b=YSGAv6Xco6J4NnTxbI4txUl9AN/jbHVILQl8EhGvmmICQtFSXiNboq5yCCZ1Uf7KWh
         qDWEvOrGKYvZYijvNMjJAQbjxR4ltUd+IdNeWEjevwCSzhUhInpNLdkLcELz0fREeBm3
         L0Qo2yd2dPjRIv9m0Egg2wXZ+vpHjzxCwsmkeXTTfJZx4c01p7SsF0ldiLx4xI2UAzTf
         Jtn3UGFyAF6+OhAHy4WURjMsi2Q4a05fo6Eng934ScMt1cua7gbG8ZEIw9F1ZBEgWEGP
         m8PStW0n+fAvtXtECLvkEVVaQvlWX+lH+IYHmTx9v3YiM+1Udwlglh8Mw4tpNloH91My
         sRxQ==
X-Gm-Message-State: AOJu0YxD2F1PP1CFVp3YVyPA/zKwN06GiSuboBM4uTN+0wsRD4nzERth
	tiPWfaCl7Ftf90LHoxV8Jy19QzNk0Pa+Rl/AIy48Yy68ZSfUJ70A4AsgGWtKB8jgNR5NwRawdWg
	uzX8Mfw==
X-Google-Smtp-Source: AGHT+IE4QVI1fKmkMmpPcyCsJDlUuuYAQPHzGkfjzS/K0R0jvy8kCbAQh/LA65MWrxF7bbEW5Xy/CB+i7ro=
X-Received: from pjbgl14.prod.google.com ([2002:a17:90b:120e:b0:32e:e4e6:ecfe])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:fa7:b0:275:f156:965c
 with SMTP id d9443c01a7336-2902741e441mr15340135ad.52.1759875840026; Tue, 07
 Oct 2025 15:24:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:23:56 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007222356.348349-1-seanjc@google.com>
Subject: [PATCH] KVM: guest_memfd: Define a CLASS to get+put guest_memfd file
 from a memslot
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a CLASS to handle getting and putting a guest_memfd file given a
memslot to reduce the amount of related boilerplate, and more importantly
to minimize the chances of forgetting to put the file (thankfully the bug
that prompted this didn't escape initial testing).

Define a CLASS instead of using __free(fput) as _free() comes with subtle
caveats related to FILO ordering (objects are freed in the order in which
they are declared), and the recommended solution/workaround (declare file
pointers exactly when they are initialized) is visually jarring relative
to KVM's (and the kernel's) overall strict adherence to not mixing
declarations and code.  E.g. the use in kvm_gmem_populate() would be:

	slot = gfn_to_memslot(kvm, start_gfn);
	if (!kvm_slot_has_gmem(slot))
		return -EINVAL;

	struct file *file __free(fput) = kvm_gmem_get_file(slot;
	if (!file)
		return -EFAULT;

	filemap_invalidate_lock(file->f_mapping);

Note, using CLASS() still declares variables in the middle of code, but
the syntactic sugar obfuscates the declaration, i.e. hides the anomaly to
a large extent.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 94bafd6c558c..130244e46326 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -307,6 +307,9 @@ static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
 	return get_file_active(&slot->gmem.file);
 }
 
+DEFINE_CLASS(gmem_get_file, struct file *, if (_T) fput(_T),
+	     kvm_gmem_get_file(slot), struct kvm_memory_slot *slot);
+
 static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
@@ -605,13 +608,12 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	unsigned long start = slot->gmem.pgoff;
 	unsigned long end = start + slot->npages;
 	struct kvm_gmem *gmem;
-	struct file *file;
 
 	/*
 	 * Nothing to do if the underlying file was already closed (or is being
 	 * closed right now), kvm_gmem_release() invalidates all bindings.
 	 */
-	file = kvm_gmem_get_file(slot);
+	CLASS(gmem_get_file, file)(slot);
 	if (!file)
 		return;
 
@@ -626,8 +628,6 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	 */
 	WRITE_ONCE(slot->gmem.file, NULL);
 	filemap_invalidate_unlock(file->f_mapping);
-
-	fput(file);
 }
 
 /* Returns a locked folio on success.  */
@@ -674,19 +674,17 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     int *max_order)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
-	struct file *file = kvm_gmem_get_file(slot);
 	struct folio *folio;
 	bool is_prepared = false;
 	int r = 0;
 
+	CLASS(gmem_get_file, file)(slot);
 	if (!file)
 		return -EFAULT;
 
 	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
-	if (IS_ERR(folio)) {
-		r = PTR_ERR(folio);
-		goto out;
-	}
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
 
 	if (!is_prepared)
 		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
@@ -698,8 +696,6 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	else
 		folio_put(folio);
 
-out:
-	fput(file);
 	return r;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
@@ -708,7 +704,6 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
 {
-	struct file *file;
 	struct kvm_memory_slot *slot;
 	void __user *p;
 
@@ -724,7 +719,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	if (!kvm_slot_has_gmem(slot))
 		return -EINVAL;
 
-	file = kvm_gmem_get_file(slot);
+	CLASS(gmem_get_file, file)(slot);
 	if (!file)
 		return -EFAULT;
 
@@ -782,7 +777,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 
 	filemap_invalidate_unlock(file->f_mapping);
 
-	fput(file);
 	return ret && !i ? ret : i;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);

base-commit: 6b36119b94d0b2bb8cea9d512017efafd461d6ac
-- 
2.51.0.710.ga91ca5db03-goog


