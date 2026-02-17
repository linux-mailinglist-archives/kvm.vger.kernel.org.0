Return-Path: <kvm+bounces-71163-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uPspMVqYlGkoFwIAu9opvQ
	(envelope-from <kvm+bounces-71163-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 17:33:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8761D14E3B3
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 17:33:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0F68D304437E
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 16:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1FF36F41C;
	Tue, 17 Feb 2026 16:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D1RMK4M9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9590136EAAE
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 16:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771345975; cv=none; b=MnpylTlkvwZO4knFJS9suqnRe86KK3Ti/eVBCedVz6H9SMPR70E4GgjmV9lcr+VQcyBYr3OwjaohUYsrMy+nNEjsPnWa3qfEEYg+vtpDkuYKrqhHoiKy5iODvEaXzOEEk2SkUyUu4QjSHIGmD6RE5aB/qPXyuy1fRwqHnRsmkrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771345975; c=relaxed/simple;
	bh=HAnMN+TsnixmoToA8UrLxfl2Tg4SZY6PvAOYZzLEnE8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=AGtvz34OvDzX7AfuTcy2y7cij7FbLPIJIREfSg/0IyLopWA/w3ugpoUN+K7zMkOb1O5A2h5AFjyyfXe054fiL61fNj7og0pES7jKRJuDTcOf0pMMeE35V6P2baPkr3O8MBcmkHrbTUpToyC7lPLuOTid61jZO6MffOmagS02VyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--surenb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D1RMK4M9; arc=none smtp.client-ip=74.125.82.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--surenb.bounces.google.com
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-126e8ee6227so7849383c88.0
        for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 08:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771345974; x=1771950774; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bJd/jsI1Ahr6ZvCTFiQFd3QULQDNn4kGH1XUoRnqvFw=;
        b=D1RMK4M9j0ahrRfLk2h5yB4TJB+vxxqxZgRoIjhJNg5DtLFELrpBeJmYxnixAOLNzv
         K/6ARGGXHuTsQZtBmw7CX3bqKrEygcmPLqCfLPAhEtahj44muXGoPih7Qs6z5nmL/80p
         sNJ/37TY4yWSlI26dzMVpvFD/cqWENHePyS7uwzvpatV7UBLZXqlfUtrRf6wRpiLhazF
         Y2VDBvVfQbWb71eFU7VHvAKsbrAuvjs0dNZ3+jvYyCexduEX3JF8vyQPZz1IWfNrRwP/
         c2vU//jIwQoyFXxym18yML0umCC/R6HpJE60cL+JKFYF8QAfba9m43zT/JHNvrJighFZ
         LXmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771345974; x=1771950774;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bJd/jsI1Ahr6ZvCTFiQFd3QULQDNn4kGH1XUoRnqvFw=;
        b=mRIGleglpUF1Yvn4wEGRTaqIbjmQz+4lN264cS9ztpgdLnbOs8nV0V0KI+MvGla/A9
         1mCBd20/8nJ7FMvL9rvL5gXXk4UgP23d+dwOE00fIwHkr4BGj4N2qcxIMiYuqte5P4pS
         4tz5eRWpFvkXNqWz3PdOfPV081CRojZ44MmtKAv+J99i4VST+k28pcbGS3NBzoSjyEP0
         Mkeybekec19vCfbPdJb7wJh5cwjm0cX4GxCsrZlvOX2YzYqUPvgsEjMejj3/CxpMZSYn
         nDaJLC3/8VyLSarXTifocmA5W5k4UELeIiZ1HTdbc9SlI1SbB1q3PAWtOsDL+w/ZZheK
         1+QQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0b8AMuralklhRyIpqQYe5XSjNU7KmcA/sJULdWssAgbU8zZ0aNOxYwCpQS32GfIJHd50=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGj3tg//v80EpGCRo/DZYVRNMmfMqWGGLR7XBK4SNB91BySE3F
	dRSm3qNxXHva+QLU3TRQSnpwA1QHxn4/EeVBbAdCjWF+5FKU8TBxei+QjubRckwDypqrWUnH82U
	3JhvKzw==
X-Received: from dlbur9.prod.google.com ([2002:a05:7022:ea49:b0:127:e77:9377])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:6b9f:b0:123:3488:899c
 with SMTP id a92af1059eb24-1273ae56e4dmr5617423c88.40.1771345973444; Tue, 17
 Feb 2026 08:32:53 -0800 (PST)
Date: Tue, 17 Feb 2026 08:32:47 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260217163250.2326001-1-surenb@google.com>
Subject: [PATCH v2 0/3] Use killable vma write locking in most places
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
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71163-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,oracle.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[43];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[surenb@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8761D14E3B3
X-Rspamd-Action: no action

Now that we have vma_start_write_killable() we can replace most of the
vma_start_write() calls with it, improving reaction time to the kill
signal.

There are several places which are left untouched by this patchset:

1. free_pgtables() because function should free page tables even if a
fatal signal is pending.

2. userfaultd code, where some paths calling vma_start_write() can
handle EINTR and some can't without a deeper code refactoring.

3. vm_flags_{set|mod|clear} require refactoring that involves moving
vma_start_write() out of these functions and replacing it with
vma_assert_write_locked(), then callers of these functions should
lock the vma themselves using vma_start_write_killable() whenever
possible.

A cleanup patch is added in the beginning to make later changes more
readable. The second patch contains most of the changes and the last
patch contains the changes associated with process_vma_walk_lock()
error handling.

Changes since v1 [1]:
- Moved vma_start_write_killable() inside set_mempolicy_home_node()
to be done before mpol_dup(new), per Jann Horn
- Added error propagation for the missing PGWALK_WRLOCK users and
split it into a separate patch, per Jann Horn
- Moved vma_start_write_killable() inside __split_vma() to be done
before new->vm_ops->open(), per Jann Horn
- Added a separate patch to change flow control in vma_expand(),
per Jann Horn
- Brought back signal_pending() in mm_take_all_locks, per Jann Horn
- Moved vma_start_write_killable() inside __mmap_new_vma() to be done
before __mmap_new_file_vma(), per Jann Horn
- Added Reviewed-by for powerpc, per Ritesh Harjani
- Added s390 reviewers and the list due to changes in the last patch

[1] https://lore.kernel.org/all/20260209220849.2126486-1-surenb@google.com/

Suren Baghdasaryan (3):
  mm/vma: cleanup error handling path in vma_expand()
  mm: replace vma_start_write() with vma_start_write_killable()
  mm: use vma_start_write_killable() in process_vma_walk_lock()

 arch/powerpc/kvm/book3s_hv_uvmem.c |   5 +-
 arch/s390/kvm/kvm-s390.c           |   5 +-
 arch/s390/mm/gmap.c                |  13 +++-
 fs/proc/task_mmu.c                 |   7 +-
 include/linux/mempolicy.h          |   5 +-
 mm/khugepaged.c                    |   5 +-
 mm/madvise.c                       |   4 +-
 mm/memory.c                        |   2 +
 mm/mempolicy.c                     |  23 +++++--
 mm/mlock.c                         |  20 ++++--
 mm/mprotect.c                      |   4 +-
 mm/mremap.c                        |   4 +-
 mm/pagewalk.c                      |  20 ++++--
 mm/vma.c                           | 105 ++++++++++++++++++++---------
 mm/vma_exec.c                      |   6 +-
 15 files changed, 164 insertions(+), 64 deletions(-)


base-commit: b08472d036a36893ecf68296d87beb58d21f4357
-- 
2.53.0.273.g2a3d683680-goog


