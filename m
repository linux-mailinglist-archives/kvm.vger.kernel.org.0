Return-Path: <kvm+bounces-23714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DCC8A94D43E
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:11:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AAD1FB23FF6
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 210FF19AD4F;
	Fri,  9 Aug 2024 16:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c45B0Sr3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50441990C3
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723219775; cv=none; b=tUZH0obe+/SXTm9pGK9nRhfvrJg6kWHbWavnQYOoeGlHRvNQZLEdJUx8lk2niaccv/YJWSXMXCv6LkETOo5RlTnkqL3B0aNBnFDh7/iz1j1F70HQGrM6ldpQhr4su8Kcystg5i0pq93gnLGedRaOj+hqA2n0P7FDJd8HtcBmLwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723219775; c=relaxed/simple;
	bh=NRE6RSln8yk8W4KIRztpuy77GMwMRMzE4sT6CQJcyFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3/pndqueJyD0WpV3hw8XaV7/q2ST1HS7+s10aN/MKV6z7pYlisz1/Vk9uPoos/rPHmWA5bYloa5KHyNKafvOWZRQ0oYwzpH7SkAX2aOpyvbnzUxaApPUIvfCWEXwFJZk4/g87cewflMH+34KRg+XwPtA/g5NXIArV/FQbgL6Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c45B0Sr3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723219772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GAUMBfy0kdSy8bea6Q2/adQQTYYkrWuiUWfctkd/rW8=;
	b=c45B0Sr3yazNTZNhbIwtCuU7Ramq6snK4CcOpNVf1lQ5CTjMIK5jQWCW6ZJV3AxHh+dpT8
	210JM1/828YOAGynPsiCJ22reBHXB9VKdQyMG4KuqkTk278gUwQhm4g8LtbBkivUY9lNDV
	M9RL4suMguN+XyCweQsVBwbTDd5J//Y=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-8_PQV3YGOneoMhEncp45Pg-1; Fri, 09 Aug 2024 12:09:31 -0400
X-MC-Unique: 8_PQV3YGOneoMhEncp45Pg-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4519ec19cb6so810431cf.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:09:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723219771; x=1723824571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GAUMBfy0kdSy8bea6Q2/adQQTYYkrWuiUWfctkd/rW8=;
        b=rq/ijOqFj2E5ZO95GTbednU/WVEeMLqe5sniv4sooULu9SBRk3dc/cfkg5SWB02mYb
         wrbncWwc82bb9Yq7P0z9xIFMDrt6kd+/vHHzYej3ER4Sswjy+q+FgMjvDLFyGKb2gz4w
         l1Bp0a10bVfgDCfoPyYpuZYg01qREO40Q1NBT+FBzR8kIuz3IQItWl+3rbVfKnA/ivKt
         SWSv+W6rQF+xa/x8Nmdhz5XKsbn+fnF8G5KHmc0X1o1SJ01yeOOiYmUlM63vh9iYdMMh
         ZrK3AJJRUozwUIQiT9dpMIzDTBZXWcwcKUU6n75Z+CznVjx43UcxfN/KBGdF5NVa2vQ3
         TrgA==
X-Forwarded-Encrypted: i=1; AJvYcCWfupfv+uCahPhYQX243fPWECdz+qDKDVcYhGlfzgPl1vIw8Ortpp653P8AzABXyg4rDK2J8oUGUltyQN3yGRml43v4
X-Gm-Message-State: AOJu0YxjB4An2r+Oufytyy/B8GoCo4J48jI8aRNr0AUQJjoQ4jVXx1QK
	4uD2YjDghv6f8CbcDGSAb2HUfHhYIrTwIuhTHM4ZTzG82hwcJFHFLJP5TaO1WYyRLTTs/d9pyXz
	fJrUfjekBRUjRy7nCIevQvH93wO1jAABg/yUdzdFny1T7NxaaBA==
X-Received: by 2002:a05:622a:180e:b0:44e:d016:ef7 with SMTP id d75a77b69052e-45312652444mr12909311cf.7.1723219771015;
        Fri, 09 Aug 2024 09:09:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2AJ498flXqsf/RjsZizkWR5q4LBdwGhozxnqN6XMiL4rwNH8ESKXDSym68P6o8cpdHObfXw==
X-Received: by 2002:a05:622a:180e:b0:44e:d016:ef7 with SMTP id d75a77b69052e-45312652444mr12908941cf.7.1723219770588;
        Fri, 09 Aug 2024 09:09:30 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c870016csm22526741cf.19.2024.08.09.09.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 09:09:30 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	peterx@redhat.com,
	Will Deacon <will@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 07/19] mm/fork: Accept huge pfnmap entries
Date: Fri,  9 Aug 2024 12:08:57 -0400
Message-ID: <20240809160909.1023470-8-peterx@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240809160909.1023470-1-peterx@redhat.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Teach the fork code to properly copy pfnmaps for pmd/pud levels.  Pud is
much easier, the write bit needs to be persisted though for writable and
shared pud mappings like PFNMAP ones, otherwise a follow up write in either
parent or child process will trigger a write fault.

Do the same for pmd level.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/huge_memory.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6568586b21ab..015c9468eed5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1375,6 +1375,22 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	pgtable_t pgtable = NULL;
 	int ret = -ENOMEM;
 
+	pmd = pmdp_get_lockless(src_pmd);
+	if (unlikely(pmd_special(pmd))) {
+		dst_ptl = pmd_lock(dst_mm, dst_pmd);
+		src_ptl = pmd_lockptr(src_mm, src_pmd);
+		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
+		/*
+		 * No need to recheck the pmd, it can't change with write
+		 * mmap lock held here.
+		 */
+		if (is_cow_mapping(src_vma->vm_flags) && pmd_write(pmd)) {
+			pmdp_set_wrprotect(src_mm, addr, src_pmd);
+			pmd = pmd_wrprotect(pmd);
+		}
+		goto set_pmd;
+	}
+
 	/* Skip if can be re-fill on fault */
 	if (!vma_is_anonymous(dst_vma))
 		return 0;
@@ -1456,7 +1472,9 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
 	if (!userfaultfd_wp(dst_vma))
 		pmd = pmd_clear_uffd_wp(pmd);
-	pmd = pmd_mkold(pmd_wrprotect(pmd));
+	pmd = pmd_wrprotect(pmd);
+set_pmd:
+	pmd = pmd_mkold(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 
 	ret = 0;
@@ -1502,8 +1520,11 @@ int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	 * TODO: once we support anonymous pages, use
 	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
 	 */
-	pudp_set_wrprotect(src_mm, addr, src_pud);
-	pud = pud_mkold(pud_wrprotect(pud));
+	if (is_cow_mapping(vma->vm_flags) && pud_write(pud)) {
+		pudp_set_wrprotect(src_mm, addr, src_pud);
+		pud = pud_wrprotect(pud);
+	}
+	pud = pud_mkold(pud);
 	set_pud_at(dst_mm, addr, dst_pud, pud);
 
 	ret = 0;
-- 
2.45.0


