Return-Path: <kvm+bounces-60191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 600CBBE4DBE
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:32:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 144275E0DC6
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF94C3321D8;
	Thu, 16 Oct 2025 17:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SdXBealk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367AE32D0DB
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760635826; cv=none; b=MMhuxInbNTxNrlGr0imQVev9IN2TyMU4PgoExCwJTjG2+v+OFrYE8Pevu3FhDBlHcMKrxopTca818rK8yvrhXdZC+CkdYpAZI1KH9Fjr1Dw8s5kEobH7hGvzRVDxxx7sJdl0zZzrnMfgGAAr2sfyxyYyIz5IiRF0llZ47UmZNb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760635826; c=relaxed/simple;
	bh=heky2zXel5Gf2tCzEvHsxs+55wiRGUenTfJxQBBGyvI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PH6DqyIWbTq23AZTRQgazwmEzMoUNbHfOM+WLtlCKY41l8X+ADplDUQJhX0KnPLdTC6BigTxKuLY5rz4CkVqndYwDNNp06vNjGNPifuts2xiBcUo+iHhwvtHdy0XdhoGE1NkmH2aLNnnpAs1nGcp0poAPZDBtXpqxkQv3ZUj6Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SdXBealk; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-339d5dbf58aso2344983a91.3
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 10:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760635825; x=1761240625; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4u4q+H5ARYkVWCNl+U6142GnGsl0yn3w8dvhjLsaut8=;
        b=SdXBealk2hEUqVlZStWmwwHFv9+5P4Hkg+ir2PA2EVr1Ar5nzevrZcueNTJSof7Sx9
         cGQFpEd9/cTlgXUavObe0S/uwr/WM/H3kTkzH/Hvqlhkd9TqBxN0+UbFq+rpmWVJicSa
         kCQ/4Z06dkBfcGW/IJQM2067DACxDPtiYsPejF00gbVKFoFvQpojAxrG3QRHhwwobjcq
         n8UIMG0YuQRO4+mioVzCozsI45QDQjPdt43GtLRC9HmJz2S1iAK40aySUYYVJfiAZf34
         HQn/6Zpi0lqY25Il5teX0KlhjbWu0nP9h4VpUgLdzlgjJHxeW+jCMnam3oaYWb1zCxSb
         /9AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760635825; x=1761240625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4u4q+H5ARYkVWCNl+U6142GnGsl0yn3w8dvhjLsaut8=;
        b=k+oqmR8bldm8CzJ8dZMd6Sk9sMV+nVDMm8WNzjA78ceaP1mxCGt5GG+hedk2oB4Rpn
         7W7zQ5HKVgyL0Jn2OSkH/0VnMuumBtJaG+tkWBPZNK0T3Nkzw0C3gjGYce4F2kH7rTu6
         P/4M0b04qdshi24E6Icz7xl+4AgX3ObC/l/migcxWI6mUd2yGpA9mwlGNcZwmAPtQ372
         bLRPyFyX0AE52agUFBn2y5evhoJ8PCQ7Q3ShxTyZBP586+c5fChyCyd5vtgfxjr9jKK/
         vaxCSXI+XbpQguZ2I2yZw1lAj/5S5TConsfwCZZ1mMvnRiY3rX6iJywR0QLA/p7ObWba
         56bA==
X-Forwarded-Encrypted: i=1; AJvYcCXD3HeQ7cJP+hNAGnwkmCmhG/HRJBS9oycg8p8bym4bXfeHUbuel5CTpfs306Ttf6hBY0s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9T8+4HsEP9VWeCb4FFeUygYJV3VjOC1T4Gv4uduzGxBMyf9yD
	wHUoRF0lmaC618FYVAveqv06tdwoRpZYybZ81QCs/elGJdDs2+Nv9nX10IUQx36VvwBV8KGLcV1
	tkDZNyQ==
X-Google-Smtp-Source: AGHT+IFjz6Aq3RDvBNfXfc7PgYrCrCMU7f2p0qSK1iEGyybs/z37dRTZt+Dzr1VQ+adtly8KdiPZ7TtQHj0=
X-Received: from pjbnc11.prod.google.com ([2002:a17:90b:37cb:b0:33b:caf7:2442])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c88:b0:32e:1b03:6e12
 with SMTP id 98e67ed59e1d1-33bcf88aaa6mr718301a91.13.1760635824646; Thu, 16
 Oct 2025 10:30:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 10:28:50 -0700
In-Reply-To: <20251016172853.52451-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016172853.52451-10-seanjc@google.com>
Subject: [PATCH v13 09/12] KVM: selftests: Use proper uAPI headers to pick up
 mempolicy.h definitions
From: Sean Christopherson <seanjc@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Drop the KVM's re-definitions of MPOL_xxx flags in numaif.h as they are
defined by the already-included, kernel-provided mempolicy.h.  The only
reason the duplicate definitions don't cause compiler warnings is because
they are identical, but only on x86-64!  The syscall numbers in particular
are subtly x86_64-specific, i.e. will cause problems if/when numaif.h is
used outsize of x86.

Opportunistically clean up the file comment as the license information is
covered by the SPDX header, the path is superfluous, and as above the
comment about the contents is flat out wrong.

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
2.51.0.858.gf9c4a03a3a-goog


