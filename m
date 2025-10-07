Return-Path: <kvm+bounces-59605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DDFBBC2D89
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 00:17:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D6E884F3189
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 22:16:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7671B2749D5;
	Tue,  7 Oct 2025 22:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vcMV4QfK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DE52701B1
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 22:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875295; cv=none; b=rmIfUAOylK8MhGQnZNwzmd8RJx8pBkE1jE1wCw7FCd0JiS5WxSRci0tL4rgrXpR7061g/eVaGrkm784htx2rEkjwcktVniGWLa6ssQjm2pJ9ko4eazd1hqTK0eh5wp0J7T4MQvf3bmi9hQp2hHSe+NmlgvUi2tw70bTx0XxG+5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875295; c=relaxed/simple;
	bh=iKrUI9LQBOh4k9pZFLc/fEW3XuLEnIsg8figDKSsXGA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RULYVdSnwY7iMMQc1hT7fEKu9LKXBT5JIiIu3pWZWsMWl910ylP5et4O+6sp2WFkKaaTuZPozZPLAtChJ8wfNQ9zhH6xydqsMGKRWsj6KBQsEgvW13P9p1kCQl1nj40cUhb3q64qkAJBKTQ13VFS+HwYzXAezwVANqmzdydAGFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vcMV4QfK; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eb2b284e4so10433427a91.1
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 15:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875293; x=1760480093; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=efPtgGQoMr4oubNxAv1qKprX0Kma5wbATW1PH+6tg30=;
        b=vcMV4QfKo2kxGdvra5XBptOVM9oPG/9lY8hsuCunTcIXK4MUZAu5JEFSZs9gszv2lQ
         Eo/x0Z9n6CLvh2ncOutm63mC7BK3QndH2EpEPGpQTuzMFoNn9/WhYG4K/0DV9H/7Vrku
         bvtwUzG13cKkiF5Tvcm+qg6fJu3w3tSfxFirnb1l+GRjRWlzfb5EAkul2nZWXoRs9F8Q
         SCgOKu1nZEc3Qc9FN13xyeeV+6l5bvrjOzaBuz/swpRfUTYWaipxBpd9E2AxgQJ6uxe7
         FaQOyYq3Ip0PFVChFzHtr1YnE28covXBwzWiAE83v4f/G313dZ3KF/IxfpPjyCtisPQX
         CI6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875293; x=1760480093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=efPtgGQoMr4oubNxAv1qKprX0Kma5wbATW1PH+6tg30=;
        b=Qt8sAR5tTsr7jMuZSq7h6IT5ueD9CRihnyvhV4JUDBT2x/AObuPiLIRmPsf4ZZsnfQ
         oNjD082KaaIKyGTBPK8VIhkiihCdRusjBLWnHD3m5wVEgOR0QKUPg3mxXPnBbdhqSpjh
         gBYDgjH86ZadT2DSsc7eSnwqkbqdYbgdzFEKvAolebCzSE6///YNiN+OI5blAe/7GfUA
         Atryge5dDo/2p4dxe8YmoaxTr8x+TuKPFCK9KYN+GDiaXvOq2148a/KnDRRzRbJQxeIX
         kDCQg9u6GZeENK8oM1sBW/LVE7R4dQUQ4yLT43H3W7naWpvlxOUNfm3CCKT3Qkf2g8ZD
         xLTA==
X-Forwarded-Encrypted: i=1; AJvYcCXPdqVXrTGNPDpS1NfF21TBDS6RgiTDzRzoo42apuaHfjGJZu49EAzpszuQdGwVcONdT+Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyROKPdNjkK0Uz35sFzaeWarKY39cvF23z9kkny4VJkKNIp7hG+
	tfaqVcEJlVBh0VQ5ysp60CtITL5F6KRSAJgSRztIPcC6iaENh7/G8piptcOnZlMtgVU7DbeLlyu
	kix8xjg==
X-Google-Smtp-Source: AGHT+IFTaBPktlqVR37VqVA9cZzZZ/8OTio3uAd9mQ94N7kdyxx902DDy6/7iqhCbZbcOwfgNKOb2jtvL6Q=
X-Received: from pjbsn6.prod.google.com ([2002:a17:90b:2e86:b0:32b:61c4:e48b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1806:b0:32d:db5b:7636
 with SMTP id 98e67ed59e1d1-33b513cdaf5mr1179313a91.27.1759875293062; Tue, 07
 Oct 2025 15:14:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:17 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-10-seanjc@google.com>
Subject: [PATCH v12 09/12] KVM: selftests: Use proper uAPI headers to pick up
 mempolicy.h definitions
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Include mempolicy.h in KVM's numaif.h to pick up the kernel-provided NUMA
definitions, and drop selftests' definitions, which are _mostly_
equivalent.  The syscall numbers in particular are subtly x86_64-specific,
i.e. will cause problems if/when numaif.h is used outsize of x86.

Opportunistically clean up the file comment and make the syscall wrappers
static inline so that including the header multiple times won't lead to
weirdness (currently numaif.h is included by exactly one header).

Fixes: 346b59f220a2 ("KVM: selftests: Add missing header file needed by xAPIC IPI tests")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/numaif.h | 32 +-------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/numaif.h b/tools/testing/selftests/kvm/include/numaif.h
index aaa4ac174890..1554003c40a1 100644
--- a/tools/testing/selftests/kvm/include/numaif.h
+++ b/tools/testing/selftests/kvm/include/numaif.h
@@ -1,14 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * tools/testing/selftests/kvm/include/numaif.h
- *
- * Copyright (C) 2020, Google LLC.
- *
- * This work is licensed under the terms of the GNU GPL, version 2.
- *
- * Header file that provides access to NUMA API functions not explicitly
- * exported to user space.
- */
+/* Copyright (C) 2020, Google LLC. */
 
 #ifndef SELFTEST_KVM_NUMAIF_H
 #define SELFTEST_KVM_NUMAIF_H
@@ -37,25 +28,4 @@ KVM_SYSCALL_DEFINE(mbind, 6, void *, addr, unsigned long, size, int, mode,
 		   const unsigned long *, nodemask, unsigned long, maxnode,
 		   unsigned int, flags);
 
-/* Policies */
-#define MPOL_DEFAULT	 0
-#define MPOL_PREFERRED	 1
-#define MPOL_BIND	 2
-#define MPOL_INTERLEAVE	 3
-
-#define MPOL_MAX MPOL_INTERLEAVE
-
-/* Flags for get_mem_policy */
-#define MPOL_F_NODE	    (1<<0)  /* return next il node or node of address */
-				    /* Warning: MPOL_F_NODE is unsupported and
-				     * subject to change. Don't use.
-				     */
-#define MPOL_F_ADDR	    (1<<1)  /* look up vma using address */
-#define MPOL_F_MEMS_ALLOWED (1<<2)  /* query nodes allowed in cpuset */
-
-/* Flags for mbind */
-#define MPOL_MF_STRICT	     (1<<0) /* Verify existing pages in the mapping */
-#define MPOL_MF_MOVE	     (1<<1) /* Move pages owned by this process to conform to mapping */
-#define MPOL_MF_MOVE_ALL     (1<<2) /* Move every page to conform to mapping */
-
 #endif /* SELFTEST_KVM_NUMAIF_H */
-- 
2.51.0.710.ga91ca5db03-goog


