Return-Path: <kvm+bounces-69928-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AAnzNXAmgWnsEQMAu9opvQ
	(envelope-from <kvm+bounces-69928-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:34:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DA5ED2380
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:34:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 29DC43032C43
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 199BC38F92D;
	Mon,  2 Feb 2026 22:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c00v0SW5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0A538F22C
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071446; cv=none; b=PY9LsL91SAj2bWfSIKRg+88/kAUg7mfxaVHjDrD3+/Jeb8qvxdK2NFa14Jbsi8fJaqAvpgrFwCuXVRuzrB4mbSmemVwabvaHCIRrQSSIJtrOxCbWpfpBuFizIulrl1kLFakmT67ujcZrfBjRTytJxHCHHVNo4pGzyLaJmpBObeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071446; c=relaxed/simple;
	bh=v5zqw3J3IglSQwBpLaHg9p2oKkGbYtk6WvDSBU6dC+c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MeAGkrNF/zTdWzhY7ZmBk+sEb84HYfZsdu1lQxhzAkyMFoacnCjQt0dm2N+hsXiZ+QLBAkjWoL1PqJoyb/y2pD7jqA7hMXeGu1gXsj6QwZcSYcjv0I3grk8oIUzoSEkiblQFj549xTZBpPbuyp8IOg+lURUQJeuEHMMJGPX0wH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c00v0SW5; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c5d6193daso11761160a91.1
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071444; x=1770676244; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mmtmfbbvXxKteucNld5iLbNSkR9VsVAFECPjDufbIRI=;
        b=c00v0SW5dP26VMtaU8tp2abdNsaqInGoR8gRlgH2KWdDEoTaT+AX14b5HmxbqPEsDj
         DJJTe2UpIDUotW4ftAUXX/2oz6cBqbuZWPYRfTsC/czxtHxWchPxJQEAHmFODunsXYCm
         YRKpAAx515PswWuJ8jF4dXUjBFMkFrPGGKj+unbzS5FXVSSQ03EG4zupEOCzNkoBpCN6
         atDUBJVsQUrWx6Kv6AwgkrpKUuw8lfyyZypXVEd3EtXKN73sFC0KHDpn5pExCiLi6Jk2
         d8JxPFUXbdnUV/HIAosyb29IO9nM5m42Y1ZLbRHdU0o6RoHN16df4O/B0xurwRBGY2YJ
         uJYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071444; x=1770676244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mmtmfbbvXxKteucNld5iLbNSkR9VsVAFECPjDufbIRI=;
        b=Tr+IW2qt5vq/FjM749gonmzf3jIckqy8ASJNTZjSvoQEij4kymD9wORlHNTucO6z0y
         y/09vIgyUlGYAdxONTYPxuYWN0SfpxeLNX7hFjPLa0gMLD1w9S7TjzIzYmPo1hu23U/a
         rxpcPVFEz8LfO8WMVTPIM7ySxa2MLhnt0jGLX4e7SuvYkPlm6mFe6tkFf7siOvDzfnBq
         vHZ6RPz+yrzz/MbC3Zqav7avGbI6Tx643rrHx/TFvVFAnfyfPNvwtAH1sxz4+N2MTujN
         gaEAmNKN2oLLoYndxYdHNerlVmTWZzZ+jGRx0Yr/8tKOgUJzzyl7Qr2pVc0+uVxJJs+v
         5aPA==
X-Gm-Message-State: AOJu0Yzfpi+aih8V3NPHx2LHc1WajNkjU4j0/8JhnLzKuYdm0J2Ilytx
	cmOKbkFrOYkMPpGfo/EzVLfuCC2vh9DfZtMTi0+c/LVZG1kl8tog5a4IjniuEowDB6Hgo6zazTo
	swhAAZ5kNsVX4rx4bgpTRxj43ju/esrvKdSyUFa9Zc+sGLoyql6DX5vNVMsAeKlXgHB1hICbbGx
	Bh+GIyRVjBYFuGB+Hk/TTUUb5uhO38yRuAtTsRJn9eGmwTy/Qwb/dBUFpTr44=
X-Received: from pjqo15.prod.google.com ([2002:a17:90a:ac0f:b0:352:c381:4153])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:41:b0:340:f009:ca89 with SMTP id 98e67ed59e1d1-3543b3941c6mr11441073a91.22.1770071443781;
 Mon, 02 Feb 2026 14:30:43 -0800 (PST)
Date: Mon,  2 Feb 2026 14:29:51 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <b40baa430e23838bfd0b78468e58b17dd2625e6e.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 13/37] KVM: selftests: Create gmem fd before "regular"
 fd when adding memslot
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
	yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69928-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_GT_50(0.00)[50];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7DA5ED2380
X-Rspamd-Action: no action

From: Sean Christopherson <seanjc@google.com>

When adding a memslot associated a guest_memfd instance, create/dup the
guest_memfd before creating the "normal" backing file.  This will allow
dup'ing the gmem fd as the normal fd when guest_memfd supports mmap(),
i.e. to make guest_memfd the _only_ backing source for the memslot.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 45 +++++++++++-----------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8279b6ced8d2..1d69baf900a2 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1028,6 +1028,29 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	if (alignment > 1)
 		region->mmap_size += alignment;
 
+	if (flags & KVM_MEM_GUEST_MEMFD) {
+		if (guest_memfd < 0) {
+			uint32_t guest_memfd_flags = 0;
+
+			TEST_ASSERT(!guest_memfd_offset,
+				    "Offset must be zero when creating new guest_memfd");
+			guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
+		} else {
+			/*
+			 * Install a unique fd for each memslot so that the fd
+			 * can be closed when the region is deleted without
+			 * needing to track if the fd is owned by the framework
+			 * or by the caller.
+			 */
+			guest_memfd = kvm_dup(guest_memfd);
+		}
+
+		region->region.guest_memfd = guest_memfd;
+		region->region.guest_memfd_offset = guest_memfd_offset;
+	} else {
+		region->region.guest_memfd = -1;
+	}
+
 	region->fd = -1;
 	if (backing_src_is_shared(src_type))
 		region->fd = kvm_memfd_alloc(region->mmap_size,
@@ -1057,28 +1080,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	region->backing_src_type = src_type;
 
-	if (flags & KVM_MEM_GUEST_MEMFD) {
-		if (guest_memfd < 0) {
-			uint32_t guest_memfd_flags = 0;
-			TEST_ASSERT(!guest_memfd_offset,
-				    "Offset must be zero when creating new guest_memfd");
-			guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
-		} else {
-			/*
-			 * Install a unique fd for each memslot so that the fd
-			 * can be closed when the region is deleted without
-			 * needing to track if the fd is owned by the framework
-			 * or by the caller.
-			 */
-			guest_memfd = kvm_dup(guest_memfd);
-		}
-
-		region->region.guest_memfd = guest_memfd;
-		region->region.guest_memfd_offset = guest_memfd_offset;
-	} else {
-		region->region.guest_memfd = -1;
-	}
-
 	region->unused_phy_pages = sparsebit_alloc();
 	if (vm_arch_has_protected_memory(vm))
 		region->protected_phy_pages = sparsebit_alloc();
-- 
2.53.0.rc1.225.gd81095ad13-goog


