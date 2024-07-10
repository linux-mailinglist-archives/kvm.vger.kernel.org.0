Return-Path: <kvm+bounces-21387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD1E192DCF6
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 01:46:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82500282CB1
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFE01168492;
	Wed, 10 Jul 2024 23:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e6NELnNh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E981316A95E
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 23:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654973; cv=none; b=UCUqDbJR3AnAyeipGF7MnG4s9S3wzLR7FMvKQLH9t+vYUN6HuCEG2cm8iaAKapW1tLFnNTZtVWINIKAusT74IrbUXaa9Q6PqR6pgsiqukXpC/lWwgQIwvvnLDw/T7Ts2x3Xsloo12OgczPI46NWF0xjrnKdocrjSaTgiJvEBMXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654973; c=relaxed/simple;
	bh=u+awbVx9aoPKS0xGDQreI8aQ8m7YRSIdZYPdiuLJprA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=twkceT7Zsz5mp5W9q7QyF59f/5U5J2/gdSwe8UkCNULmJF+ULtokkqSP7caR5QrIZQU/2hZGZNBw1jMRycz0A0XyRVmjb6/X1zXofOpwZvuGt/rHyhz0tUOg9QyxanxjPnPGRR31yrDPUWXpe915/ybteilQUu9qRgElNCOvmRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e6NELnNh; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-653b4b01872so5683667b3.1
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 16:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654971; x=1721259771; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QcajhSgtnKDY4bKjbf4ZVWmvqiJNI58ACmEJvGd9BEA=;
        b=e6NELnNh7DbSwWwtHHEldQJH7sr8xKLGh90dcELCZM/kGuCX6P9o53v/cw1f2kDu4b
         ZfUSQ5xYn+DP5swZ5BsTWD6leZ5xcV3edNNxeM56kih9lKIfKzuPMfP3AplfhTZ9M8xc
         XTsgy54wbezX6YiaA+3FcTyEcZeCmbgBvIOcU0jp4srrEoMRIwPtWUxHGsYwKfOnYPS+
         u0qdLlyKasM4cdWBA8wdzKKFlq2uFHP7KRZwiKwXohYbP9I2jJRtDhy/aOjnn/KOtWRz
         okVqjQr+kEPPOVxGWZWhninG8zhSy92CU8wHG+ifGpWL2auqJsCVBRwFH2XKk1+ife46
         JpzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654971; x=1721259771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QcajhSgtnKDY4bKjbf4ZVWmvqiJNI58ACmEJvGd9BEA=;
        b=wNhSWtHnggy6HFVmeublaCvv9NLyhDEr+1FR/WD/txgBsEymFG52ZCrQqbcbBIWW7d
         47isHF/nMrhIKbjC4M/5of/DiZsnsGHriMi7FWfbyZhvL7px16Fr0ynH+8RzkaerGVNn
         5XXtDMMogLAcQNfl+4OsVBZLXdiHQhMkRceXb5h9IH4A7NJnrnhZL9x3RMFMc5NVBo2C
         g05RZofCCMtPq0juccGE+Ogyv79mbmaekbhg1f2w5CjNb/c6evcmA4e1aUHeNkLavhXM
         F/IYn+gxBARAhhXy5eJEJJPqV2PzejS56dR1edMpKwwT/frl9f4OhJXEJYsQZxr6Skdr
         P/AA==
X-Forwarded-Encrypted: i=1; AJvYcCWE/ZPnUo1p+riNlUwxuZt7lOxSiK3zNFCu+59dH1zPOwJCGqec3tcnSHyQKEqroYTmHNhGlMCFM+Zjbpt92o/EMS+q
X-Gm-Message-State: AOJu0YykO0jth7JtpEKUyRLYphyjWnsVmu4pKs6fLEwIiGofIpPqiNGY
	SvqGdfsB2QBZoH66wmU5lDrNKSQ4MWOB3/7TnJpvVFvb9fhLwkPODeLS6qsc9AG5pIzbdUrjYYy
	Al5eYyTwqq/W7FxqJbg==
X-Google-Smtp-Source: AGHT+IEC/EQtrNezpt+9blgHEpHxd1YhFnUWh0/2vBf3Usnz5Irc0nFTjIjjYgCU/UmvBPArza1QUIUaWp5gpwOj
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:6d0d:b0:61c:89a4:dd5f with
 SMTP id 00721157ae682-658ebabc90amr1126767b3.0.1720654970940; Wed, 10 Jul
 2024 16:42:50 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:17 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-14-jthoughton@google.com>
Subject: [RFC PATCH 13/18] KVM: Add atomic parameter to __gfn_to_hva_many
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Atomic translations cannot wait for userspace to resolve a userfault.
Add an atomic parameter for later use with KVM Userfault.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 virt/kvm/kvm_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 77eb9f0de02d..4ac018cac704 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2679,7 +2679,7 @@ static bool memslot_is_readonly(const struct kvm_memory_slot *slot)
 }
 
 static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slot, gfn_t gfn,
-				       gfn_t *nr_pages, bool write)
+				       gfn_t *nr_pages, bool write, bool atomic)
 {
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return KVM_HVA_ERR_BAD;
@@ -2699,7 +2699,7 @@ static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slot, gfn_t
 static unsigned long gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
 				     gfn_t *nr_pages)
 {
-	return __gfn_to_hva_many(slot, gfn, nr_pages, true);
+	return __gfn_to_hva_many(slot, gfn, nr_pages, true, false);
 }
 
 unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot,
@@ -2732,7 +2732,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_hva);
 unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot,
 				      gfn_t gfn, bool *writable)
 {
-	unsigned long hva = __gfn_to_hva_many(slot, gfn, NULL, false);
+	unsigned long hva = __gfn_to_hva_many(slot, gfn, NULL, false, false);
 
 	if (!kvm_is_error_hva(hva) && writable)
 		*writable = !memslot_is_readonly(slot);
@@ -3002,7 +3002,8 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool interruptible, bool *async,
 			       bool write_fault, bool *writable, hva_t *hva)
 {
-	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
+	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault,
+					       atomic);
 
 	if (hva)
 		*hva = addr;
@@ -3074,7 +3075,7 @@ int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
 	unsigned long addr;
 	gfn_t entry = 0;
 
-	addr = gfn_to_hva_many(slot, gfn, &entry);
+	addr = __gfn_to_hva_many(slot, gfn, &entry, true, true);
 	if (kvm_is_error_hva(addr))
 		return -1;
 
-- 
2.45.2.993.g49e7a77208-goog


