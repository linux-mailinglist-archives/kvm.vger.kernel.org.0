Return-Path: <kvm+bounces-63269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1010C5F47F
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:52:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED9263B0911
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39D023491EB;
	Fri, 14 Nov 2025 20:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mjiFPhJT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A8F284672
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153490; cv=none; b=sSrpFOkgXgcGYyRs82hPdia2dncJVQ4MvinYUcLqnKB0DRAhbfUY0X2V/fumdEggMXuFSqPZxP2CI1sHJ8c0Vr3T8lpLOKRKZqlMmYH/Ujg6yACS97Kcpe5t2mWxxzNiWi3oPQDG5HdyYMjeiEJ4PJSDfkJeibbXws5S9d/xERU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153490; c=relaxed/simple;
	bh=XCrHqD9GjTPNn92L/8S5s1AW95ZGtOTnAD8PpkaGoTE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SGvIIo6qeRdI5OxVTseBLABXVFi8EuopEl6C1ZApzT3jxVkzpeSWbNhoDIftT7y0clS88LsYkewsDy7wmYWeQW31zLaODY9jk0PkWogY0jZCgv1ngjlnlmluJhDExvrB9jceSfcX3Panz47/Ib9mocXksSBamSjTFyj3TRi7xzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mjiFPhJT; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2956f09f382so21759865ad.1
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153488; x=1763758288; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kc6z8GEEtUED4OVhB6yMpknBzIAKKVnLcxWzRC5HWSM=;
        b=mjiFPhJTp9z+Oz97WJoHxW10u0Cp+dKR1ynKcuRQLQOj/OMYloQQNY2kACGFRJsyb8
         OHFjSbOa8IUj6xE/3erBVKkGdIcwFfrbNrhj7t6cqXd7U+kz3QDa1EIzHh72pMMIjQhA
         YBaTfmVfJb0cv8s8WaMJPqRZn1RgH43HHQP8dYUDJhBb7sjGVB16ZT1CLRhEK0Gx+yfz
         xek28jEHKAqqDuBBZU7muBpRyg/5cz2v/pMCjMb2sENsFDS8yQIY+xq9DAjuHlqknpof
         baEZ+GaWQ+z7rACwvbOy9ItiMtfPXcXRuFvr4KClYUp7F+O2jY0xuYbr2dhoyakCWjgD
         hMaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153488; x=1763758288;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kc6z8GEEtUED4OVhB6yMpknBzIAKKVnLcxWzRC5HWSM=;
        b=OacCkrIoFPaSqzPnub1Qst1dDv3JZz9d96HA+M2UydYD4DwvQyq793AqDTJgJOPSXH
         U5eZ/Fwzazi9ayTnkE71LArThSPLoDfvtJjVDSAM6wAKeoRjHNBifoUYSqlJAb38r//r
         lLR7j+t/jCogijXxfVVtlU4410SAp9sqH5QX70jeZg5Dl4ICkGMJS4A+9S+fE8K1s9e/
         7uS9oEMqT3ID8rpLThN3xuLrZlbVLJcJOFXo0bP2VeDs82VmeoLEUZdb4j1AUZ+Yh8zD
         p4t7Qkz/6gTG3hkC9I2hLDZTFs1zdErtXRPg8i8adRnoYJCfhWZ0Jy6/HzndSgfSNwqz
         PxTA==
X-Gm-Message-State: AOJu0YzUic665ARsAV1qDxawaw0WcH+uS7iaAKUWoXeU7EM0/AxX+mbL
	O5L6sc116VyVXhBKV4ba3qB2klMfIuyTNFXw6lwZIrm30jqvSFE8XnHgWPaWYj/H7mzUIwWX3Q5
	cYlQDAA==
X-Google-Smtp-Source: AGHT+IETogoZY3/mWU0x93YMSh1/8m88+p2DiqaO1OKIhXP8dc9wx7N8DPW/NISvw4+HLLNZjWIuKKzoYnY=
X-Received: from pllw9.prod.google.com ([2002:a17:902:7b89:b0:295:5d05:b2b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ced0:b0:283:f19a:bffe
 with SMTP id d9443c01a7336-29867eeb17bmr55375415ad.7.1763153488335; Fri, 14
 Nov 2025 12:51:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:50:55 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-14-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 13/18] x86: Avoid top-most page for vmalloc
 on x86-64
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Mathias Krause <minipli@grsecurity.net>

The x86-64 implementation of setup_mmu() doesn't initialize 'vfree_top'
and leaves it at its zero-value. This isn't wrong per se, however, it
leads to odd configurations when the first vmalloc/vmap page gets
allocated. It'll be the very last page in the virtual address space --
which is an interesting corner case -- but its boundary will probably
wrap. It does so, for CET's shadow stack, at least, which loads the
shadow stack pointer with the base address of the mapped page plus its
size, i.e. 0xffffffff_fffff000 + 4096, which wraps to 0x0.

The CPU seems to handle such configurations just fine. However, it feels
odd to set the shadow stack pointer to "NULL".

To avoid the wrapping, ignore the top most page by initializing
'vfree_top' to just one page below.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/vm.c |  2 ++
 x86/lam.c    | 10 +++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 90f73fbb..27e7bb40 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -191,6 +191,8 @@ void *setup_mmu(phys_addr_t end_of_memory, void *opt_mask)
         end_of_memory = (1ul << 32);  /* map mmio 1:1 */
 
     setup_mmu_range(cr3, 0, end_of_memory);
+    /* skip the last page for out-of-bound and wrap-around reasons */
+    init_alloc_vpage((void *)(~(PAGE_SIZE - 1)));
 #else
     setup_mmu_range(cr3, 0, (2ul << 30));
     setup_mmu_range(cr3, 3ul << 30, (1ul << 30));
diff --git a/x86/lam.c b/x86/lam.c
index 1af6c5fd..87efc5dd 100644
--- a/x86/lam.c
+++ b/x86/lam.c
@@ -197,11 +197,11 @@ static void test_lam_sup(void)
 	int vector;
 
 	/*
-	 * KUT initializes vfree_top to 0 for X86_64, and each virtual address
-	 * allocation decreases the size from vfree_top. It's guaranteed that
-	 * the return value of alloc_vpage() is considered as kernel mode
-	 * address and canonical since only a small amount of virtual address
-	 * range is allocated in this test.
+	 * KUT initializes vfree_top to -PAGE_SIZE for X86_64, and each virtual
+	 * address allocation decreases the size from vfree_top. It's
+	 * guaranteed that the return value of alloc_vpage() is considered as
+	 * kernel mode address and canonical since only a small amount of
+	 * virtual address range is allocated in this test.
 	 */
 	vaddr = alloc_vpage();
 	vaddr_mmio = alloc_vpage();
-- 
2.52.0.rc1.455.g30608eb744-goog


