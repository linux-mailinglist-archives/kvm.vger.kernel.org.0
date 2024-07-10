Return-Path: <kvm+bounces-21378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF46992DCD9
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 01:43:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E14041C223FC
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E939B15ECED;
	Wed, 10 Jul 2024 23:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rt39n1a/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f73.google.com (mail-ua1-f73.google.com [209.85.222.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D0515A87C
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 23:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654964; cv=none; b=Qy7QWBZI0OvXzJ1JfdSVLf90jez2ayUKHCvRV1vd+fBDyLTPFkIeetkkeeEtrT+ZJN5LDpW3TCYlU8NeFets9bKM/uyM8njt8UWnJxSfX3LHglfGQMYHFcBAeJa17VDbbPUlaEdPPLjIqUWPi9nkniXlYvFQxgU6wTrZrIxnMW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654964; c=relaxed/simple;
	bh=3Qf2g5mWL+5xmgWA+ouxgQR+hBm6JQ6o96+DWwhG9sw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cJQIu1xB695GqWpEit5dAjnY9l65uHsf8dRqiluFYXGuQ5VxsI1OooDf856XeWqudlnc2O4P5ofVxZlaRTyJ0+RMRPehbwkgJP+0mnUgPEeX+wv05KktZkHkYSF/1k7IVLMOxbDhX6ksITvyC/ERPY0T9KDZ/Z7H3sFY/169B+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rt39n1a/; arc=none smtp.client-ip=209.85.222.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-ua1-f73.google.com with SMTP id a1e0cc1a2514c-80fe896d0e4so84796241.3
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 16:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654962; x=1721259762; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6BWcXKAsCbgqy4w2nNCeUW6tFbXjuDYwJZkZfwSoSpo=;
        b=rt39n1a/jCW7i9o7gJNi2GZa8fssrydnZa9nAtRUhhf9FCdc24COshDrTp9lCmXX++
         cTJ6tUWD6D29mCRi/SjJdk2weJJZzId7/Jb7a638bzmHkASEbrim4Du4IX8O1ldfEUrC
         X2D8ZDbs5ngCo4Tbyx/8NDU906CZ2b0PHv5PFJeA2VY4K8iDd40JmRpMp78DjsUebw2/
         7AhXU0Q5R4WvK+4GZwuQRalJLAwbNOBo4d9eqyDpQEhYTlgpodDMUwEcLY8vpHich0Wi
         qt2iJw18xtapVp6MeeL+XXVuwyFhIKuxErgUbt7k0ulskNyxZr5nqrhhZkf9TKriL5vs
         GHKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654962; x=1721259762;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6BWcXKAsCbgqy4w2nNCeUW6tFbXjuDYwJZkZfwSoSpo=;
        b=Jku8QC77jjtxKrc7uL5EdZMgX7ll0v3r4okGjzce3h3w6h73FVQMDKZteMpAeEQ14B
         QPUDnnRt+TmhiX5QmY5NLlbTY1T+A56pGQdmuUScF+rj8zinbkJE+3AjP65hvrcmimna
         j0o0UcyBD7/eqmtmjlS9A0ARYkURFDmfWEhe/rFlBe86Jz/Il6bpwMH6fUVX+vjTp0Ob
         EG0dPiWn0yBie3v7vbVDil5Hb6E3ZNrVtYIRUqzgnQQX8iZk/SsoHYhPEQeDk+U/4oU6
         DmF/lz2hGw1xmYk6r49o49iVQQRQvT/wU5lN2uq0m77L/zOkpccPLgeudlwahwsPqXQU
         Xzaw==
X-Forwarded-Encrypted: i=1; AJvYcCVPEEgCx50yh8uZ3Rvj4XZR07OFVtM3pND6noAyp/QyPBtIA4ie3cAHqi4G2LODyxi7FbOF3Xow+30mrrz0oOaY0z8s
X-Gm-Message-State: AOJu0Yy+X+gxsdx4Yy+7wugipSDPJLiZ1c9Xzywbdfm4EjQPm05uiv2c
	2EWCYaGdXu5gRvTRv1P86oCvagTqBppuOt8yD50EEa5npynk4j0AOOjQ2Q9OHIDjYlTc5UGXqRc
	LgVOEioEeL3YVszweMQ==
X-Google-Smtp-Source: AGHT+IEs5vUQHQ0lGxrPeXnI8U3zg0scUB3VU7/qVip/3trOIT/81ZfcXpykTilnpI2xQFZASFVWimG+3mGsVHMv
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6130:2b07:b0:810:2714:60fd with
 SMTP id a1e0cc1a2514c-81076dc9388mr47870241.1.1720654962027; Wed, 10 Jul 2024
 16:42:42 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:08 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-5-jthoughton@google.com>
Subject: [RFC PATCH 04/18] KVM: Fail __gfn_to_hva_many for userfault gfns.
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

Add gfn_has_userfault() that (1) checks that KVM Userfault is enabled,
and (2) that our particular gfn is a userfault gfn.

Check gfn_has_userfault() as part of __gfn_to_hva_many to prevent
gfn->hva translations for userfault gfns.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/kvm_host.h | 12 ++++++++++++
 virt/kvm/kvm_main.c      |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c1eb59a3141b..4cca896fb44a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -140,6 +140,7 @@ static inline bool is_noslot_pfn(kvm_pfn_t pfn)
 
 #define KVM_HVA_ERR_BAD		(PAGE_OFFSET)
 #define KVM_HVA_ERR_RO_BAD	(PAGE_OFFSET + PAGE_SIZE)
+#define KVM_HVA_ERR_USERFAULT	(PAGE_OFFSET + 2 * PAGE_SIZE)
 
 static inline bool kvm_is_error_hva(unsigned long addr)
 {
@@ -2493,4 +2494,15 @@ static inline bool kvm_userfault_enabled(struct kvm *kvm)
 #endif
 }
 
+static inline bool gfn_has_userfault(struct kvm *kvm, gfn_t gfn)
+{
+#ifdef CONFIG_KVM_USERFAULT
+	return kvm_userfault_enabled(kvm) &&
+		(kvm_get_memory_attributes(kvm, gfn) &
+		 KVM_MEMORY_ATTRIBUTE_USERFAULT);
+#else
+	return false;
+#endif
+}
+
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ffa452a13672..758deb90a050 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2686,6 +2686,9 @@ static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slot, gfn_t
 	if (memslot_is_readonly(slot) && write)
 		return KVM_HVA_ERR_RO_BAD;
 
+	if (gfn_has_userfault(slot->kvm, gfn))
+		return KVM_HVA_ERR_USERFAULT;
+
 	if (nr_pages)
 		*nr_pages = slot->npages - (gfn - slot->base_gfn);
 
-- 
2.45.2.993.g49e7a77208-goog


