Return-Path: <kvm+bounces-21377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A76392DCD8
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 01:43:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B888C286AD2
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA3215E5BB;
	Wed, 10 Jul 2024 23:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z6xVYPuY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83B2158D82
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 23:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654963; cv=none; b=SPjP3oixJuRRV/u2AA5LB9V49wMCSpjFavjCCe8DbI6xSuDuZyvH2ezDWiV+PJTbgApl4gD1P8+WTlYI1n1XD26lbNFekzV1S3pNS0mhD/1m0UiW0GYB88nTAxK4rObjFOUnAyS5xY6lmLA217LtsQTU3gOrEKXhSHNtO5g+TxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654963; c=relaxed/simple;
	bh=IdpdyzI/6CbiUVqWLoyfJDrAPLlE8GztB50eBsdtlK8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nB5PUJ4jny1zf1a5VyFpXzYC6ihFeoZIJ+H0mfPycqionFezcOTZN17xubokQWFnJJqAK31FGmcop3b3N+tb1IvLQgMyohBlAd231qOISbxAngFSMaqeXQTiCz1ULG5aqsA1vyCJpSWjSSFHG5+PugBOmuGQafpKWykClOVd7Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z6xVYPuY; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0561513c21so1392349276.0
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 16:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654961; x=1721259761; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jsFdXvbgPwi63ncubEeloKTN1KDlxflVjQmCEhWWdzo=;
        b=z6xVYPuY9u9DnW1D08N6UbeW4WZ3lUpA0I54oa32ZS+jwfhopM+OARVmeh/DzyA0Ez
         KFaZFARK1UBLXqQSP/uJ6HN/yKtjRP2WDCGu5y984nR1Gx5xnC6ILzS92NJGzSzYKLd6
         zC0HT4uFaPdIOPkpumTOqIAc8bth+T1YosTp3WusDi9xffnpvMU/xKFnELAx2SzUH2cO
         4kf1NAuphTdbP5Y8p4TkC2xEpSPiJV184S33CjBr24Zobjdu+vOVnP92S2c8LlpmcAF6
         8zF5+zlQ2FwaxxHQo6UXUB2lYiS8pS7FsWlUVBqSTBU0+pfGWJg8yjGtG+M5WnsBXw/q
         XAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654961; x=1721259761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jsFdXvbgPwi63ncubEeloKTN1KDlxflVjQmCEhWWdzo=;
        b=Bn5XZsH8pRQkLswK2gU/bRfJfJsOyYGLziHrKuEB+GaQab/lqpo25DkngqlPbmAXYJ
         6lUJyy7PbzXK+tclriZV5BvDiwKeZptnRp/J2A3WR/7Kkk+8JbzHnDzqdJZadnwRCl2S
         VCNdw7e6f3FL//aeTJspAmo0q163tPMqc4GFtByLFIHd48d7RgF9fR05Yyxe9F8tryu6
         tcPYrXumM5CehX/IBCN4MEA0ftrMXsd4eJAbU8NY5gm8xtOKgFyuki6Hi1XBHjSzEatS
         hBmO36o1ww7S374po5hViINIhRXJUSLWjijv0SdVJ1RZTFJRp3CInxP0P9KRtOn5Tya5
         hbkQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8x4fUsroheUuUUmfjDBCcSaJNTyluz/ukWu+doXKULy/A65bMPPwoe9gFkgFNl1qG+VRcEWHZC7xnJyXoYben+5sh
X-Gm-Message-State: AOJu0YwOMjeZXgCjbzUzkpRIe2sahcZ0ypdTDw6wVUnDd6JxnzvcaM4r
	bZA3tiVxR7nmnykY46jeGA54gK7oEa8mCdV4019spv59srtYwxm/0YDjiXSMWxdSRrA2DaX70XZ
	8WZTxSLo2ZhWK2cgfhw==
X-Google-Smtp-Source: AGHT+IG3Vk6X5wTdtR4KaDZB2edBlrlcDT80/rqBxWjm1e2N+7Y128jb+W0Gi/uqye/vInLab8G3pghPeGswAEHn
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:2309:b0:e05:6532:aa4b with
 SMTP id 3f1490d57ef6-e05780396ccmr53350276.2.1720654960837; Wed, 10 Jul 2024
 16:42:40 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:07 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-4-jthoughton@google.com>
Subject: [RFC PATCH 03/18] KVM: Put struct kvm pointer in memslot
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

Because a gfn having userfault enabled is tied to a struct kvm, we need
a pointer to it. We could pass the kvm pointer around in the routines we
need it, but that is a lot of churn, and there isn't much of a downside
to simply storing the pointer in the memslot.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/kvm_host.h | 2 ++
 virt/kvm/kvm_main.c      | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f0d4db2d64af..c1eb59a3141b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -596,6 +596,8 @@ struct kvm_memory_slot {
 		pgoff_t pgoff;
 	} gmem;
 #endif
+
+	struct kvm *kvm;
 };
 
 static inline bool kvm_slot_can_be_private(const struct kvm_memory_slot *slot)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fb7972e61439..ffa452a13672 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1769,6 +1769,7 @@ static void kvm_copy_memslot(struct kvm_memory_slot *dest,
 	dest->flags = src->flags;
 	dest->id = src->id;
 	dest->as_id = src->as_id;
+	dest->kvm = src->kvm;
 }
 
 static void kvm_invalidate_memslot(struct kvm *kvm,
@@ -2078,6 +2079,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	new->npages = npages;
 	new->flags = mem->flags;
 	new->userspace_addr = mem->userspace_addr;
+	new->kvm = kvm;
 	if (mem->flags & KVM_MEM_GUEST_MEMFD) {
 		r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
 		if (r)
-- 
2.45.2.993.g49e7a77208-goog


