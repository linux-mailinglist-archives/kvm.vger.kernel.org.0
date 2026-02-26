Return-Path: <kvm+bounces-71928-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8AfLCibxn2lwfAQAu9opvQ
	(envelope-from <kvm+bounces-71928-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:07:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 956341A1A12
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:07:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A6378309DD20
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 07:06:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AAC438E127;
	Thu, 26 Feb 2026 07:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GLwr0cXP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648C936215A
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 07:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772089575; cv=none; b=pcOcn8r//7IEv+u9ZuEOe1SAu1ore38/+EqFP0/+TKUaG96LRyPjNTE6At5RffPZnLWqsbHPNMJcT+j9Qr+oqLc2nmM0QTPDo9a0PVkMX8kvNcI01DvQo4RTnzEgRkyq5TOiQZS0q4EKwv9s+We9Lb+xU+jzDG/YzjqRMv9RitI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772089575; c=relaxed/simple;
	bh=1R7msjHSmTG/2uO3oYIInFkTi1ERP76I/8NVV+UDL1w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ifN2UxvTJs59yiknS+tE3YVXIpvYtJ6jC6+tC+PkYmush/X9yUxLCoTFQOfiTdh26pUaK58Bt/BnWf9OKBg70CiuBlFDyQLX1iqdI8EhI2vo7VSo4Pem5W29CUHsGtjGd+67E8i7dGuMZMcBuPmzaqdTnGnwUpeopSqmgSXkhJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--surenb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GLwr0cXP; arc=none smtp.client-ip=74.125.82.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--surenb.bounces.google.com
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2bd3bf5dde4so516853eec.1
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 23:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772089573; x=1772694373; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vucVmOFSxssu4W4+hD04IB0isnzzlwVXoGbpC2l+3Iw=;
        b=GLwr0cXP1leI0GVWJ9lNk52GfIww9JL+A1Vf17tmO+w5fbnDGQiT6Sakg/rHF4qDjo
         Cenbny35Z57pU54e9/QWmygik3ul/ayGty7TqwUWBkfMhw5x2iq48EuHsSteg1Z1IaSd
         x/ISsXuNwaqE2eLbu0fmKPi7pHDKlvhjRwgIFPBtN6qrSyQFPUNUaMNMZHwgnpx2C//j
         VT0zZCXIyMR/470tRdXuDUvmEN63ZzmgEOHiJsDuMDfwYPVJVmwZukQgv/HAEtMDbXHS
         TY1pxffp4aGNr/v0albCqjsIwjyqz4/EXvc8+iHVl1ZgkvMPAummF4Iu/JwpcqttvNTP
         STwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772089573; x=1772694373;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vucVmOFSxssu4W4+hD04IB0isnzzlwVXoGbpC2l+3Iw=;
        b=StFBBxT8dVmTjYUV72fL0IbqWzFcCDc1fr4iGkQBRw99AJPyPqggucb7uikO5sBd7P
         8qDbqW5aUKJTktjZNKSTlQQQcjhI5WjlP+g4YykZDjPYfTGr4fRQyUdoy0Ky/E5nL3eH
         tscpvhsXJu3UrBcL9VaHIpUjtY6aG0MjBVbIo77w/mZ1H66F/HSylSO0/mYKtQRYZTGe
         nEndmbNePzeyzNTwKbjRI9hfI/AkYaQWWMFb5uzoLDhi2pYSnwfh1OEfLxa9CKwXlL6L
         R0Ot/MhE7B9Q04SqNCrPXYKL2rns6Kg9T/tREbrsHQ4g4xUu1trAHVGm89cl4ZFD2eaj
         DNug==
X-Forwarded-Encrypted: i=1; AJvYcCXymP03/J3fJX1WH9LQ5MefucBSW7lkAXIt4UUOJpQr2qiaJhhjpKHqQrqyX+BYNMz0GK8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNNu+/DfIVK+zF3qnoA5rrZytCPmVb6qDw0OT/grY1GiHqURYI
	FPN283pTOj2SeDASG9gSYgPw342yY/uRpycp253OxlslMgN1dDerM1ZfA6e+segc5PI1rdTOBAP
	FNljgMA==
X-Received: from dlam21-n1.prod.google.com ([2002:a05:701b:2095:10b0:127:89b6:8d2a])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:60aa:b0:127:3b16:bf4f
 with SMTP id a92af1059eb24-127869c9ac6mr1332481c88.40.1772089573227; Wed, 25
 Feb 2026 23:06:13 -0800 (PST)
Date: Wed, 25 Feb 2026 23:06:06 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260226070609.3072570-1-surenb@google.com>
Subject: [PATCH v3 0/3] Use killable vma write locking in most places
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,oracle.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-71928-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[43];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[surenb@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.834];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 956341A1A12
X-Rspamd-Action: no action

Now that we have vma_start_write_killable() we can replace most of the
vma_start_write() calls with it, improving reaction time to the kill
signal.

There are several places which are left untouched by this patchset:

1. free_pgtables() because function should free page tables even if a
fatal signal is pending.

2. userfaultd code, where some paths calling vma_start_write() can
handle EINTR and some can't without a deeper code refactoring.

3. mpol_rebind_mm() which is used by cpusset controller for migrations
and operates on a remote mm. Incomplete operations here would result
in an inconsistent cgroup state.

4. vm_flags_{set|mod|clear} require refactoring that involves moving
vma_start_write() out of these functions and replacing it with
vma_assert_write_locked(), then callers of these functions should
lock the vma themselves using vma_start_write_killable() whenever
possible.

A cleanup patch is added in the beginning to make later changes more
readable. The second patch contains most of the changes and the last
patch contains the changes associated with process_vma_walk_lock()
error handling.

Changes since v2 [1]:
- rebased over mm-unstable, per Matthew Wilcox;
- removed mpol_rebind_mm() changes since the function operates on a
remote mm and incomplete operation can leave unrelated process in an
inconsistent state;
- moved vma_start_write_killable() inside set_mempolicy_home_node() to
avoid locking extra vmas, per Liam R. Howlett
- moved vma_start_write_killable() inside __mmap_new_vma() to lock the
vma right after it's allocation, per Liam R. Howlett
- introduced VMA_MERGE_ERROR_INTR to add EINTR handling for vma_modify()
- changed do_mbind() error handling for avoid EINTR overrides;
- changed migrate_to_node() error handling for avoid EINTR overrides;
- added EINTR handling in queue_pages_range();
- fixed clear_refs_write() error handling which previous verstion broke
by skipping some of the cleanup logic;

[1] https://lore.kernel.org/all/20260217163250.2326001-1-surenb@google.com/

Suren Baghdasaryan (3):
  mm/vma: cleanup error handling path in vma_expand()
  mm: replace vma_start_write() with vma_start_write_killable()
  mm: use vma_start_write_killable() in process_vma_walk_lock()

 arch/powerpc/kvm/book3s_hv_uvmem.c |   5 +-
 arch/s390/kvm/kvm-s390.c           |   2 +-
 fs/proc/task_mmu.c                 |   5 +-
 mm/khugepaged.c                    |   5 +-
 mm/madvise.c                       |   4 +-
 mm/memory.c                        |   2 +
 mm/mempolicy.c                     |  22 +++--
 mm/mlock.c                         |  21 +++--
 mm/mprotect.c                      |   4 +-
 mm/mremap.c                        |   4 +-
 mm/pagewalk.c                      |  20 +++--
 mm/vma.c                           | 127 ++++++++++++++++++++---------
 mm/vma.h                           |   6 ++
 mm/vma_exec.c                      |   6 +-
 14 files changed, 167 insertions(+), 66 deletions(-)


base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
-- 
2.53.0.414.gf7e9f6c205-goog


