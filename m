Return-Path: <kvm+bounces-60190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A77BE4DBB
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:32:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23C8A189009B
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42FDE3321B3;
	Thu, 16 Oct 2025 17:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W8UznR1s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7509332B9AE
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760635825; cv=none; b=uCoE2NR1YjcPznBx++pkMZ99h8uRz3bFFLyAcOFd+Kd9iUVs1cE3W3G8fKyK7S+O0QajSz5SP5rP7yWvx/BytfT8h+gWh4B82fVyrzrvEIAWMysugYI2hkzhDlflA4nYIpnfW4WT7IAfB/xlyRjpjPrEFLV5NTI/5BtMOL7WO9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760635825; c=relaxed/simple;
	bh=8C+X/IvyOMQj2EfSKyEewXjgv9lSdGrRpTIjpP5mSJs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hS1AcWWDpihmahbOusarAIZjXu3UUOwfAZt6S61IaHsp2kcNOeskxXl7YyYziQdCjaaES5nVo/dlN6NHYypWM3ZzJknWaYZmSWSEoaJCrov2tMHyhMkoskLwpTn/ehMFuHhz+xuhWFJu1NgiIwhjvDQwH7F1JOvlxzw2SuqQHFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W8UznR1s; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33428befc5bso1485333a91.0
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 10:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760635823; x=1761240623; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5qioThwKzTdEOA2iQtf0mEQ8EB9wa3wHPmXpieC/maY=;
        b=W8UznR1sToo8SHaDo85vBxqYEgjoJMJ0ckDx1Z4lAyf+IzYGr/gCvgPnckiOE67fF8
         ZzoiLUW73KHVxLo+087kjguydDUvvI/tahFSFboOrUcIe1Fd8G3YMgRvQDS+4sZapYYi
         PwwpP4kM+jKeMHynOz7N9alkOtuaEAEUBXbCRHp1HnT3gJ+Pp913+onWdLq0kJcSJl+7
         BYuSlKbvnm85YTnqThODaZchdM8bT1sUJfy+JOe7QfvDw60VS5Bju+jpgF5vg2z+gr8h
         sR/YIySDcSKfhPqcOksHKv5p/MDSy3pynbegHLWeaTrTuDcie63pI2ADsePhvx0HRZbq
         Hy5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760635823; x=1761240623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5qioThwKzTdEOA2iQtf0mEQ8EB9wa3wHPmXpieC/maY=;
        b=ByUba6G4Br2YgIKFU+CfD3bWG8ZG6rVMsxV1oSR9DzV/XZ4S4vaZk4J43lnBojlcLo
         LHNWuabGqRzpuln8PXLSYdQmfhpD8DIVKXrYrKNJFUhICNPg9tN6XPGdoXUQbrBjhXov
         ZDU9kMOVFZk86DoDn9Qafl1Srvce0DLUHX5Pv066SZhJr7mCaBAsnkmsOIEmsVpU7JFw
         uN7vj0X3AniGxmLeXpLR9v5/5V+BUW2EMPh+YW+0y2J5q6g0ncCHNeh9M6CzztWFOpJ6
         fmbNVSSYZm4vPCdNYxGYhGNT8XDZzfxP0etonrLXPZ2+ugxYcuUC6kCV+sMphxXfmqNz
         OAhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUL3E+4SUKgod/UN3h4KyrPCYIzCThlGAhWy1v3uKYufQCXdhOjgRV5iKxJ5Uexh39VEpM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXNDDjeNGvyyZK4xk/Nyoqn1te073zz4WvrjlM1+PSiqJOPVdx
	EUHNw3x2MqBQUaDo8m1+H+TsWvgjvIznQHItJfO9s1W7JSHbEWfDHVmwCL2ZEpYjzAjh5PI8Zn4
	fGWaJUA==
X-Google-Smtp-Source: AGHT+IGu6Gv62gHarqlsw6wLj2w/nvBHJ7QIrylwkT9SXX+HODiDsrpt8+G++14FgxRfd28ER/ycNwYRJBE=
X-Received: from pjbgj21.prod.google.com ([2002:a17:90b:1095:b0:33b:b662:ae3a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e43:b0:32e:a4d:41cb
 with SMTP id 98e67ed59e1d1-33bcf85ada9mr634774a91.1.1760635822818; Thu, 16
 Oct 2025 10:30:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 10:28:49 -0700
In-Reply-To: <20251016172853.52451-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016172853.52451-9-seanjc@google.com>
Subject: [PATCH v13 08/12] KVM: selftests: Add additional equivalents to
 libnuma APIs in KVM's numaif.h
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

Add APIs for all syscalls defined in the kernel's mm/mempolicy.c to match
those that would be provided by linking to libnuma.  Opportunistically use
the recently inroduced KVM_SYSCALL_DEFINE() builders to take care of the
boilerplate, and to fix a flaw where the two existing wrappers would
generate multiple symbols if numaif.h were to be included multiple times.

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>
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
2.51.0.858.gf9c4a03a3a-goog


