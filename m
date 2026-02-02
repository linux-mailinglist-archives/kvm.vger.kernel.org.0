Return-Path: <kvm+bounces-69945-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oP+tG0cpgWkwEgMAu9opvQ
	(envelope-from <kvm+bounces-69945-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:46:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A0040D26BC
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:46:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 17C22303CBE3
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:36:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E948E388861;
	Mon,  2 Feb 2026 22:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WZlkgRE2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE15395DBA
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071474; cv=none; b=RQvZ9D1jVbtmhv/weftTQz6QlVKBCn+pezNbS1if61N/EVGkY74Ai4bMB+/0qrZn+ao503SedsZrL/2ql4rP7jYPC8X68fh2wtQBmq7TV8MvvbKt5STYpuekFvb9yypviB4hNFUe2o8ajWOejlluNgCCpDFPQzCbytr0Aa+fnUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071474; c=relaxed/simple;
	bh=rhPa7e2nbHKPgcSIpSn/eTrXn9i9fhs462e3RBGjlu0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JHbHOIc+WJumKVaWqlteQkvtA4/C3kt5OKW+ukFzYXhEhLdNxqKMsAAKmx1wKQCaKTJn0PuoYrsRnk+vkD3LtuzeLKocL2h4kJBRcKGCCSpkH/MgH3JVjVNATACIMcCrBUuiNpYuDFdEOzg1MbTdgP7y33QayzGvvDQAzS8NA10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WZlkgRE2; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a784b2234dso137638625ad.1
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071471; x=1770676271; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+LasQi9MZpEXca97c2GcW0Xzf1pgBMgUd5URnFGTxTw=;
        b=WZlkgRE2RoL0usg+N0Dw6kSr0bsUsZF66bu/tmlIXch61TL0vpMH6l3jUkD3om6XeY
         falyvd9BwE3ihvPt6JeunSiFVSdxbu2hxJEHfFo96ZnvUlut2UjcSgqFZCA42eWt5Qrc
         Qh/DVrMMf2MobIcQxMJDa1O7EaVtXDnYB70Ac3cr0xQnLrDDkjyOa/m1Dw0ao3lxy/0k
         KN3h1cNqvLqT2EylIXSAlppNkWJUBPOxikvK6HVF2UGFn1k90R2AstiewidRb61A4RIK
         94oesHS+Q8yCA6x+B+wpWQ/WYWATkurZljY6H0gz6j4n8ikzZYSp6HUFUkzh6cxIFNI5
         Fb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071471; x=1770676271;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+LasQi9MZpEXca97c2GcW0Xzf1pgBMgUd5URnFGTxTw=;
        b=UE31GFnyGTxUUtfkiMLQXL4D1rNSG/T4NVFY7Yx4aZ6F/NnBcat8VziBs4ixZAekwg
         cUsaMGcbqlblHV0hrgswcfQwiN67gwdS0UrRvr55xacU1BMIjQmTY6pPbXb7tpdpMzFg
         REdBMv7fd9uJUzynwFp6/xTU3dnZtY9Su/mYTEcOUSwkKvS77Vc4RrHJQKfD7LaUZpdY
         GWFSBFf7TK6SvgHfJ0uehscAEiZ5hwZcPrRBN7Wnc6sq+6VfNrBdBLDNtmGYtamCEIHL
         c+9Urq2yLnQJKXBiGLXGeyRqT9Lgedqt3sKihRqEE1DPvv8TR5BIGoe1qSkewP6g7+wC
         dKVw==
X-Gm-Message-State: AOJu0Yx8yDEmA76WpvuqENShFSZ9uKnp6atMSnIGXg47J6aEWJa0Gs3J
	d16ZCVt8TQOoeI+yC0TKeIuqzK7MBEKLHSBYnkUbptYwz51kWiHoLJZ8mnPte//+rY/IiXHWDOA
	8TzXS+txc9fV/a4+GYQ2Rvap5fgzYYhmj9bsGbWB+pPSCiefbtjYUdJnYrqJRW8EWJkXSnFHuud
	fsuMsDJ57EZGkQuVdxmaXqNWLRE8ntLzYzwNzr/JL4pmKZ+MSAl9OD4a6PMhI=
X-Received: from pltg6.prod.google.com ([2002:a17:902:6b46:b0:29f:101f:a1d7])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2389:b0:29e:e925:1abb with SMTP id d9443c01a7336-2a8d96e3de3mr134547405ad.27.1770071471269;
 Mon, 02 Feb 2026 14:31:11 -0800 (PST)
Date: Mon,  2 Feb 2026 14:30:08 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <106c16f75862ed98989f1ae8ebaa06ecbc4a39d9.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 30/37] KVM: selftests: Provide function to look up
 guest_memfd details from gpa
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chao.p.peng@linux.intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, 
	ira.weiny@intel.com, jgg@nvidia.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, maobibo@loongson.cn, mathieu.desnoyers@efficios.com, 
	maz@kernel.org, mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, prsampat@amd.com, qperret@google.com, 
	ricarkol@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com, shuah@kernel.org, 
	steven.price@arm.com, tabba@google.com, tglx@linutronix.de, 
	vannapurve@google.com, vbabka@suse.cz, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-69945-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_GT_50(0.00)[51];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A0040D26BC
X-Rspamd-Action: no action

Introduce a new helper, kvm_gpa_to_guest_memfd(), to find the
guest_memfd-related details of a memory region that contains a given guest
physical address (GPA).

The function returns the file descriptor for the memfd, the offset into
the file that corresponds to the GPA, and the number of bytes remaining
in the region from that GPA.

kvm_gpa_to_guest_memfd() was factored out from vm_guest_mem_fallocate();
refactor vm_guest_mem_fallocate() to use the new helper.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  3 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 34 ++++++++++++-------
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index e767f9a99a7b..b370b70442e8 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -404,6 +404,9 @@ static inline void vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
 	vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
 }
 
+int kvm_gpa_to_guest_memfd(struct kvm_vm *vm, vm_paddr_t gpa, off_t *fd_offset,
+			   uint64_t *nr_bytes);
+
 /*
  * KVM_SET_MEMORY_ATTRIBUTES overwrites _all_ attributes.  These flows need
  * significant enhancements to support multiple attributes.
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 4f464ad8dffd..61adfd7e623c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1258,27 +1258,19 @@ void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t base, uint64_t size,
 			    bool punch_hole)
 {
 	const int mode = FALLOC_FL_KEEP_SIZE | (punch_hole ? FALLOC_FL_PUNCH_HOLE : 0);
-	struct userspace_mem_region *region;
 	uint64_t end = base + size;
 	uint64_t gpa, len;
 	off_t fd_offset;
-	int ret;
+	int fd, ret;
 
 	for (gpa = base; gpa < end; gpa += len) {
-		uint64_t offset;
-
-		region = userspace_mem_region_find(vm, gpa, gpa);
-		TEST_ASSERT(region && region->region.flags & KVM_MEM_GUEST_MEMFD,
-			    "Private memory region not found for GPA 0x%lx", gpa);
+		fd = kvm_gpa_to_guest_memfd(vm, gpa, &fd_offset, &len);
+		len = min(end - gpa, len);
 
-		offset = gpa - region->region.guest_phys_addr;
-		fd_offset = region->region.guest_memfd_offset + offset;
-		len = min_t(uint64_t, end - gpa, region->region.memory_size - offset);
-
-		ret = fallocate(region->region.guest_memfd, mode, fd_offset, len);
+		ret = fallocate(fd, mode, fd_offset, len);
 		TEST_ASSERT(!ret, "fallocate() failed to %s at %lx (len = %lu), fd = %d, mode = %x, offset = %lx",
 			    punch_hole ? "punch hole" : "allocate", gpa, len,
-			    region->region.guest_memfd, mode, fd_offset);
+			    fd, mode, fd_offset);
 	}
 }
 
@@ -1684,6 +1676,22 @@ void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa)
 	return (void *) ((uintptr_t) region->host_alias + offset);
 }
 
+int kvm_gpa_to_guest_memfd(struct kvm_vm *vm, vm_paddr_t gpa, off_t *fd_offset,
+			   uint64_t *nr_bytes)
+{
+	struct userspace_mem_region *region;
+	vm_paddr_t gpa_offset;
+
+	region = userspace_mem_region_find(vm, gpa, gpa);
+	TEST_ASSERT(region && region->region.flags & KVM_MEM_GUEST_MEMFD,
+		    "guest_memfd memory region not found for GPA 0x%lx", gpa);
+
+	gpa_offset = gpa - region->region.guest_phys_addr;
+	*fd_offset = region->region.guest_memfd_offset + gpa_offset;
+	*nr_bytes = region->region.memory_size - gpa_offset;
+	return region->region.guest_memfd;
+}
+
 /* Create an interrupt controller chip for the specified VM. */
 void vm_create_irqchip(struct kvm_vm *vm)
 {
-- 
2.53.0.rc1.225.gd81095ad13-goog


