Return-Path: <kvm+bounces-59604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C0D4BC2D80
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 00:17:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7E1DA4F8782
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 22:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C5F272E41;
	Tue,  7 Oct 2025 22:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dfcjkn+F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132BE26D4F6
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 22:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875293; cv=none; b=uSiSseuFCP6h+gFBDAWUxsI2BtLpxKFLW4WfztGBeo+FAIDPbSVNw7sz84ow3OIoFA8GPca3+6qVALj4cKWJT05L7WB7qKTvNydzp+0gAn5/f2IJ/F1Nq7UB/kHBd+h71+adfbUUQf8wJsu4g/v0SpwPpqESeBrT14Qcy8FCYUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875293; c=relaxed/simple;
	bh=5cUK2vsz2aeKXQeo1630DELsLZCEu5/ef8gHUAuGDsQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VBkmRqXJ8ukPdyL58Ln7nQ/s90gJ+MF/6IpLegA7vlTboQU2v6v3YiL8Wlb2boUSvAXMJpGA2wY3r6ccIVeyamjMClR1v8AOyEweBkOfMpB8avvolos9mwMHJtigBbYRZotQjn6/iMOQguoheKJ9hlGNh0agBNDPZEFu8Mp/mI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dfcjkn+F; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77f5e6a324fso10757818b3a.0
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 15:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875291; x=1760480091; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rE2tP6gNwSGYC+ytU0WdagFGaT6zZ0FH31dgxqOixoc=;
        b=dfcjkn+F7j6cCOfVolJ5HJ7VuCv3sVn70G4xOjfEE1+rkNQxt0D7v9CoQftuhFiG3j
         cN6QsPA0HlNc4Uz74tcP+qomSGRfAF+F5HrTNfcTn9V57CgBqG3E2NuEHUrDUctYNAG2
         /ZPFDg5BYR3mBDh9C6nwBDn8hSsRrZdSjLSvh3cncdulbmE/zAKBKDaYVoPAfm/w/ucD
         5Kh3LsZ/LhJQAERUd1NUDY3Zf/UPgKYou+7xOBjrZ/uwAkIXfa5r8gybpupa+0ix21DE
         vPSjT2AcSn5GQpbColTUyVhkdvb0gzY+FozzOHutpOjb1Qipas4XxILBf8Xd6oCaEelW
         3qDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875291; x=1760480091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rE2tP6gNwSGYC+ytU0WdagFGaT6zZ0FH31dgxqOixoc=;
        b=qUW8UDfRjOuy/FDIvmATQSJMTk6WePqUA3xC2G17oLtykqNdyC9Rl3/X/mQO5BDTA2
         GU2d07rQqPeEXkH8YHRd0luLJ3GsXWzYrw5HZsPjDC2mSWm/9S8JUjfkHh0zPtrbrfqK
         THrixAl59hil0F1sxoMfEbKTH45SgxhAz+e82Z6eCbQdWw/+p1V+TQmNyAf1sOVxJt7U
         DCmDlM4ultNYG+UvAdbDoK3fZmnqObS0BdSZVOvUYnvJ2c4SHMyQXfhwgdpJB8fZlWj1
         +v/cHjnVFFF2x5qCs/Cgqeb+iaUASZiov8bNV44dg1Dg7sgT6AVxspAz/7ovpHbB4N+R
         f2pg==
X-Forwarded-Encrypted: i=1; AJvYcCWN4DIZ1XayJ8YwFHvUJOUcFhRvlJX+nSTei4+jN9D7NDSeyuAZ+qwGNsDv75asQ96VdNA=@vger.kernel.org
X-Gm-Message-State: AOJu0YysoR07IuFbzZ+8b/2D4nkxRDq7ZcVYfl5CJe9PoZxASMbztzT3
	hV+m5bkTE5I7oDNY42681C+TkRuYj0KCoO1asyb2jRuwSVd8/xomgEz47AUaaRoe5AlTmr0wRNU
	wlZ5QqA==
X-Google-Smtp-Source: AGHT+IHT/CfaeIxGRmxefyc3Lic0lFv3xjNb/u7y6hJFRFl3s3gaiIHFCNdvEBNOqVG5LYVtjeYwLccHX/o=
X-Received: from pgkh14.prod.google.com ([2002:a63:e14e:0:b0:b4e:4eb5:3895])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:914c:b0:32b:7220:8536
 with SMTP id adf61e73a8af0-32da8138b18mr1530904637.16.1759875291520; Tue, 07
 Oct 2025 15:14:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:16 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-9-seanjc@google.com>
Subject: [PATCH v12 08/12] KVM: selftests: Add additional equivalents to
 libnuma APIs in KVM's numaif.h
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Add APIs for all syscalls defined in the kernel's mm/mempolicy.c to match
those that would be provided by linking to libnuma.  Opportunistically use
the recently inroduced KVM_SYSCALL_DEFINE() builders to take care of the
boilderplate, and to fix a flaw where the two existing wrappers would
generate multiple symbols if numaif.h were to be included multiple times.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/numaif.h  | 36 +++++++++++--------
 .../selftests/kvm/x86/xapic_ipi_test.c        |  5 ++-
 2 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/numaif.h b/tools/testing/selftests/kvm/include/numaif.h
index b020547403fd..aaa4ac174890 100644
--- a/tools/testing/selftests/kvm/include/numaif.h
+++ b/tools/testing/selftests/kvm/include/numaif.h
@@ -13,23 +13,29 @@
 #ifndef SELFTEST_KVM_NUMAIF_H
 #define SELFTEST_KVM_NUMAIF_H
 
-#define __NR_get_mempolicy 239
-#define __NR_migrate_pages 256
+#include <linux/mempolicy.h>
 
-/* System calls */
-long get_mempolicy(int *policy, const unsigned long *nmask,
-		   unsigned long maxnode, void *addr, int flags)
-{
-	return syscall(__NR_get_mempolicy, policy, nmask,
-		       maxnode, addr, flags);
-}
+#include "kvm_syscalls.h"
 
-long migrate_pages(int pid, unsigned long maxnode,
-		   const unsigned long *frommask,
-		   const unsigned long *tomask)
-{
-	return syscall(__NR_migrate_pages, pid, maxnode, frommask, tomask);
-}
+KVM_SYSCALL_DEFINE(get_mempolicy, 5, int *, policy, const unsigned long *, nmask,
+		   unsigned long, maxnode, void *, addr, int, flags);
+
+KVM_SYSCALL_DEFINE(set_mempolicy, 3, int, mode, const unsigned long *, nmask,
+		   unsigned long, maxnode);
+
+KVM_SYSCALL_DEFINE(set_mempolicy_home_node, 4, unsigned long, start,
+		   unsigned long, len, unsigned long, home_node,
+		   unsigned long, flags);
+
+KVM_SYSCALL_DEFINE(migrate_pages, 4, int, pid, unsigned long, maxnode,
+		   const unsigned long *, frommask, const unsigned long *, tomask);
+
+KVM_SYSCALL_DEFINE(move_pages, 6, int, pid, unsigned long, count, void *, pages,
+		   const int *, nodes, int *, status, int, flags);
+
+KVM_SYSCALL_DEFINE(mbind, 6, void *, addr, unsigned long, size, int, mode,
+		   const unsigned long *, nodemask, unsigned long, maxnode,
+		   unsigned int, flags);
 
 /* Policies */
 #define MPOL_DEFAULT	 0
diff --git a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
index 35cb9de54a82..ae4a4b6c05ca 100644
--- a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
@@ -256,7 +256,7 @@ void do_migrations(struct test_data_page *data, int run_secs, int delay_usecs,
 	int nodes = 0;
 	time_t start_time, last_update, now;
 	time_t interval_secs = 1;
-	int i, r;
+	int i;
 	int from, to;
 	unsigned long bit;
 	uint64_t hlt_count;
@@ -267,9 +267,8 @@ void do_migrations(struct test_data_page *data, int run_secs, int delay_usecs,
 		delay_usecs);
 
 	/* Get set of first 64 numa nodes available */
-	r = get_mempolicy(NULL, &nodemask, sizeof(nodemask) * 8,
+	kvm_get_mempolicy(NULL, &nodemask, sizeof(nodemask) * 8,
 			  0, MPOL_F_MEMS_ALLOWED);
-	TEST_ASSERT(r == 0, "get_mempolicy failed errno=%d", errno);
 
 	fprintf(stderr, "Numa nodes found amongst first %lu possible nodes "
 		"(each 1-bit indicates node is present): %#lx\n",
-- 
2.51.0.710.ga91ca5db03-goog


