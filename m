Return-Path: <kvm+bounces-69270-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MJQzCD0SeWkcvAEAu9opvQ
	(envelope-from <kvm+bounces-69270-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:30:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C9B7D99DC8
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:30:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1240B300DF59
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 19:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC47D36D4F8;
	Tue, 27 Jan 2026 19:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SKv6WAS+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F0136C5BB;
	Tue, 27 Jan 2026 19:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769542187; cv=none; b=UfqtiqLgU+8W1Ps38IX+7YllQm/1o0mGj9maKNDO3WiZtX7gRDl7ZgLV/FgcxuNVLLvPqCFI1Vva711Jfcpuo7aE8bkPaH4kRa5AmxPNKsxQOgiud0BHx5Cb9XMxhqXEKT8aauiNh97RJxDS59Z9ox4UTD3p5Ed+EPnHkJfEh0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769542187; c=relaxed/simple;
	bh=mpVeGCYsLiNY/UK6lKg9GGRaTRVOTOvc32/dwDOYLMA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PwEDJxdgfB0/qyvv+I5c87rGpYQSt9cWRXE8tQxYtKKI4aGFFoGYcbzA+Np6lXaCTnrby1rVBKCX8fLFKuUfvX+t3FzXmhgtYoUJiaw8vYhJAiYdeJEerQd5Ca11EUtoxnTJESr5qirp3SsI4Az6Xy+VYOaOC0bpvYeDcNlYV0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SKv6WAS+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDA1C116C6;
	Tue, 27 Jan 2026 19:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542187;
	bh=mpVeGCYsLiNY/UK6lKg9GGRaTRVOTOvc32/dwDOYLMA=;
	h=From:To:Cc:Subject:Date:From;
	b=SKv6WAS+1yy/6CAdsN6erxvRRsIsbUo+OGhqi4iWXCmDkaR33qEO5lAk4xu5teO2O
	 +J7lknBZban67bcny3JrQNfctgd7R3Lhl4ej+2uTLVXE1PDaxncoEM9TPfXZGXALSZ
	 FDNoZ2b18Z38m9F1hQGvR8xECcIlWnUqmMD1w0f1lK6vuP9rxfFuHYDPSIc8H5OwEs
	 9auA6iIlZNyevSsNBPW+B/2kSH+bmVO40izpG/ivDprGyAGssi1G8I2uFXnyRgSaXg
	 p7FE6FSu6eRBYHJNHa23BPrU5iySD+4/tktqLRfXkiBOyPwPi0OIbQmV4ggh/FhMKz
	 REg8RZsU6xmRg==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH RFC 00/17] mm, kvm: allow uffd suppot in guest_memfd
Date: Tue, 27 Jan 2026 21:29:19 +0200
Message-ID: <20260127192936.1250096-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69270-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rppt@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: C9B7D99DC8
X-Rspamd-Action: no action

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

These patches enable support for userfaultfd in guest_memfd.
They are quite different from the latest posting [1] so I'm restarting the
versioning. As there was a lot of tension around the topic, this is an RFC
to get some feedback and see how we can move forward.

As the ground work I refactored userfaultfd handling of PTE-based memory types
(anonymous and shmem) and converted them to use vm_uffd_ops for allocating a
folio or getting an existing folio from the page cache. shmem also implements
callbacks that add a folio to the page cache after the data passed in
UFFDIO_COPY was copied and remove the folio from the page cache if page table
update fails.

In order for guest_memfd to notify userspace about page faults, there are new
VM_FAULT_UFFD_MINOR and VM_FAULT_UFFD_MISSING that a ->fault() handler can
return to inform the page fault handler that it needs to call
handle_userfault() to complete the fault.

Nikita helped to plumb these new goodies into guest_memfd and provided basic
tests to verify that guest_memfd works with userfaultfd.

I deliberately left hugetlb out, at least for the most part.
hugetlb handles acquisition of VMA and more importantly establishing of parent
page table entry differently than PTE-based memory types. This is a different
abstraction level than what vm_uffd_ops provides and people objected to
exposing such low level APIs as a part of VMA operations.

Also, to enable uffd in guest_memfd refactoring of hugetlb is not needed and I
prefer to delay it until the dust settles after the changes in this set.

[1] https://lore.kernel.org/all/20251130111812.699259-1-rppt@kernel.org

Mike Rapoport (Microsoft) (12):
  userfaultfd: introduce mfill_copy_folio_locked() helper
  userfaultfd: introduce struct mfill_state
  userfaultfd: introduce mfill_get_pmd() helper.
  userfaultfd: introduce mfill_get_vma() and mfill_put_vma()
  userfaultfd: retry copying with locks dropped in mfill_atomic_pte_copy()
  userfaultfd: move vma_can_userfault out of line
  userfaultfd: introduce vm_uffd_ops
  userfaultfd, shmem: use a VMA callback to handle UFFDIO_CONTINUE
  userfaultfd: introduce vm_uffd_ops->alloc_folio()
  shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops
  userfaultfd: mfill_atomic() remove retry logic
  mm: introduce VM_FAULT_UFFD_MINOR fault reason

Nikita Kalyazin (5):
  mm: introduce VM_FAULT_UFFD_MISSING fault reason
  KVM: guest_memfd: implement userfaultfd minor mode
  KVM: guest_memfd: implement userfaultfd missing mode
  KVM: selftests: test userfaultfd minor for guest_memfd
  KVM: selftests: test userfaultfd missing for guest_memfd

 include/linux/mm.h                            |   5 +
 include/linux/mm_types.h                      |  15 +-
 include/linux/shmem_fs.h                      |  14 -
 include/linux/userfaultfd_k.h                 |  74 +-
 mm/hugetlb.c                                  |  21 +
 mm/memory.c                                   |   8 +-
 mm/shmem.c                                    | 188 +++--
 mm/userfaultfd.c                              | 671 ++++++++++--------
 .../testing/selftests/kvm/guest_memfd_test.c  | 191 +++++
 virt/kvm/guest_memfd.c                        | 134 +++-
 10 files changed, 871 insertions(+), 450 deletions(-)


base-commit: f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da
--
2.51.0

