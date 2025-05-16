Return-Path: <kvm+bounces-46896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22808ABA558
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:38:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D744A3B09C8
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F272728467F;
	Fri, 16 May 2025 21:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="38f3hyRU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC64283C90
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747431355; cv=none; b=GIu29NVucNbEQhaSHIkBstcn7bh0XCPUBoWGdYa9BkB0rhTH3WpJ/EmOR79foaaPicFKzEwqfb5sy0b+g5mZkgAke14J1/WMz99WZnmGSgHkxWuyGlY/C55lAhxTBQ3KUJ0y3Lj0mvgbGpdP5AqmEwLsl7RdlkN9Ey6Nbk4fOxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747431355; c=relaxed/simple;
	bh=Vec1LaJROunpusnyM0UhIbnSVhckBolPI8kAYzzwmlU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XcAt9xbEyDwyYXVoQSjtwVlbHWx2ugRcXCLJZ9KzbY6Kw2Pta7K9eJ5koCFV9vzuOTgbaFSOupF4oNnmvzmFF2xCF5keeQPB0Ux6jd3NlUlrPSaBXxn3lttq5Zp4Z2kwMbIA1Od+pZhIr/xctUcY/lxP0M8F1G3EC9GkWiEyaWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=38f3hyRU; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26e0fee459so1429055a12.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747431353; x=1748036153; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4V663rFh0jkdB7SoksoChtdcIhj8HRg19/fZOy64aqQ=;
        b=38f3hyRUKv5Hktv2viVfMUFkesdhOkdcANjFyEK6njt3zMH4WSUnpREpUUYVAbb8Jt
         WQruqwkqTdDzb/YqclByShZ9gjUfPzQMXhAf9mjiYrxfS4PaNuTN2gF0aLQMXp0sjsOY
         sJPyiHpHDtlb7iVqwDv+N6DS/Z8juz1N/69lip4E70NgvQtB/X6DO6eaGoHtyQI457Al
         n6Pw1C7xa9L2lz4G0sZmlXZi0cO/Zm9TLNTNCZD1HPASBHp82WUyO46hClub/uI3p9Yl
         6QMnQ6MiTBvmIopqDn/YLIUrdLr/AgGkz96rcR2QIJD05iCbOu7k82D/uFV7houkpn9I
         9hLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747431353; x=1748036153;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4V663rFh0jkdB7SoksoChtdcIhj8HRg19/fZOy64aqQ=;
        b=ao9i13e6h84flsGxMewQ7rfUNkV3Rc1DTV2e1YaqefR6hEEn7VjoY5lH0d2IQKxR2j
         sJnosTzsoNx9kY8kid83suLzewJ4S8/fUvm94RuQ4VcKSZ4aNjxIFq6lMuFcUO4Dp4f9
         q7jkL1lbGoLEnSA0CBRjF7xqBHTsiadBzlW8D5i5Y640EOiBh09Z+lYnZFSG/hVgDdEf
         MCi/sREClu1yGNefXTAVrsVESAhbOXsV2SmNG1R2OkmI9QTnA9gXj1M84DT8KlEQ7r2J
         EzfMX/d7gXIeRBqCiP0lCKGK2dbpmIkrhLgYDl+YxCBcYA/r2IdL1UeG07ze6/JUmdXx
         kvwA==
X-Gm-Message-State: AOJu0YxbzdPUVlQxxgq8KLmbCrKJ9zoJXfABcPv6sv7+hpz/IUnF6/qs
	ytTOOcFXAd+h9z2ShQxD56EEHsrToCkyJkj9Fec6WXk2kP/hYjOQ/eMmeTX8vyXx/SHaLw+8Tev
	3BWLVhA==
X-Google-Smtp-Source: AGHT+IHTShpa0P01pbMtjz7mDDMOXo31hETLUMs1wvsmqDIdr8kGVg9NIsmrYu0AlJiKZALyAjJyizqyiqw=
X-Received: from pjbrs6.prod.google.com ([2002:a17:90b:2b86:b0:2fc:d77:541])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d50:b0:2fa:3174:e344
 with SMTP id 98e67ed59e1d1-30e4dbb700bmr12723672a91.14.1747431353067; Fri, 16
 May 2025 14:35:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:35:40 -0700
In-Reply-To: <20250516213540.2546077-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516213540.2546077-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516213540.2546077-7-seanjc@google.com>
Subject: [PATCH v3 6/6] KVM: Assert that slots_lock is held when resetting
 per-vCPU dirty rings
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	James Houghton <jthoughton@google.com>, Sean Christopherson <seanjc@google.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

Assert that slots_lock is held in kvm_dirty_ring_reset() and add a comment
to explain _why_ slots needs to be held for the duration of the reset.

Link: https://lore.kernel.org/all/aCSns6Q5oTkdXUEe@google.com
Suggested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/dirty_ring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 54734025658a..1ba02a06378c 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -122,6 +122,14 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
 	unsigned long mask = 0;
 	struct kvm_dirty_gfn *entry;
 
+	/*
+	 * Ensure concurrent calls to KVM_RESET_DIRTY_RINGS are serialized,
+	 * e.g. so that KVM fully resets all entries processed by a given call
+	 * before returning to userspace.  Holding slots_lock also protects
+	 * the various memslot accesses.
+	 */
+	lockdep_assert_held(&kvm->slots_lock);
+
 	while (likely((*nr_entries_reset) < INT_MAX)) {
 		if (signal_pending(current))
 			return -EINTR;
-- 
2.49.0.1112.g889b7c5bd8-goog


