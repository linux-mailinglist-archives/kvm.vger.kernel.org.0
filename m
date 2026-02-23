Return-Path: <kvm+bounces-71448-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aKD2BSX8m2kC+wMAu9opvQ
	(envelope-from <kvm+bounces-71448-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 08:05:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F6021727ED
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 08:05:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 51D1A302B3A3
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 07:04:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA8FA349AF8;
	Mon, 23 Feb 2026 07:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pWvhd9qN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0331F4C96
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 07:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771830292; cv=none; b=CY0BMLREjLUttBoPhzNGFJkk+pcy1LQZb+pgpO+wNpYCpTN8vfgM1wW0DhWVuedhn3kOeSzPUQ+YS8XdNM6tAo6/PwN4SBKPMVoq6GCxLQlEPLhSeo1wlRwwZNWoGgLiiYVawf1m7mj/JkITnjoxys3cYXk61lztWkGJg+OB4Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771830292; c=relaxed/simple;
	bh=FZRWd7OFFr94c+sVebCFrm+qPTKtpygBGZ1I5UbUj8Q=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tu0842P/yfs1OUE6u6XnS6KDKQ7LABRdlclbooxRv6nAjRTt/JT2AKexrR3zn52jmrm5g19isRr6BjHp5ok3EQ3HEVvH6HJKS0FnWRWmVcMx0w8S/xlDWNBmkMfHNqrb73z5NcgQfcDH5lr6WUB60lSuvmm3Ynri2Z9tVH6MTTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pWvhd9qN; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-824a405cfb7so1761927b3a.2
        for <kvm@vger.kernel.org>; Sun, 22 Feb 2026 23:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771830290; x=1772435090; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4ACR+5opE2f1Qb7L32b78WaUJ2hKK306WtP3f4Mrpeg=;
        b=pWvhd9qNuvzQ572O9PaGrTJAuMhFcr6E10rwLG4X/ylZYq3ljR25JK7vOQcihNQHRd
         4AsDElBydnpRqPKT6jkSuLoVfEEmlstEMBucbrUaU5j+KwBzSHTf98tNWa9BLQ+Oa1fv
         QfkP3gMJkqV1GZvKPilJgjltY5ckCG24iPoHV5LwnVr48v3jK5c7wPybdYT1LwXdDim6
         8AYrqiR6/MrGjPy3KCyZ6nx3gehYeR2BBY6emDi6+l61gFKXOmZaYmY8JaVBf9GimD9L
         ldRricmNp0lRhZvWNB/6oq21iCyl377gGgPNJbynpG1muZFAq1Bf1XTu0CiEMLovJTqL
         7bdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771830290; x=1772435090;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4ACR+5opE2f1Qb7L32b78WaUJ2hKK306WtP3f4Mrpeg=;
        b=Pv5ym+c3hoNNlNyfgFXFR3V4BMs2vf13LakKeWjGZe3EmBxp/r4+5wZMWkI2x6tYDR
         +//dla3b2bdjiXX8gRKyTVOYQ5ZBlxZpQUVn4v0zgy61rHjEf92JYRqBFWxGsHy+Kfck
         ZCwr/gg9yIhaoFFSMbQWGA+6KD3Q1MMWoSCxGvDSkBfibIasjHeFTiydt0mScQx3wQDs
         2QKtnB3NSFIU+N2TqhHV1fNsLV3bZJRZI0GQ92iJHRuek8DMjh2VAfNjBczQ7uuAsb8O
         4myLkqqsmEJSiffpuezX557XWGxLzjHW2AR15RFxnvX5OgGsaMN7O8hf2Bcts/7uuBHi
         7aRA==
X-Forwarded-Encrypted: i=1; AJvYcCUpzgaf7Pg25DMosO898DAwxDLgGSzQ547iKlTOQYmOJrwStt30xlcakIUh8noxmzScKoc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYps5/MhII44qPKZQHVNLMxcHvm9dREn8k6PjQnf5E9k8OdQrp
	dz6SPhd0ttD3SUvuRK6TghF2GhbnS/sjYxNfboohcjUg1WS2f0Jk7nvdYneKXzq/9vp3a7W3foD
	KAiwJeIpnECsFz+7sUz0DuMSt2w==
X-Received: from pfbgr10.prod.google.com ([2002:a05:6a00:4d0a:b0:7b8:ac8f:27c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2ea8:b0:823:f04:e89b with SMTP id d2e1a72fcca58-826daa5de1cmr5219573b3a.48.1771830290192;
 Sun, 22 Feb 2026 23:04:50 -0800 (PST)
Date: Mon, 23 Feb 2026 07:04:33 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <cover.1771826352.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 00/10] guest_memfd: Track amount of memory allocated on inode
From: Ackerley Tng <ackerleytng@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	ackerleytng@google.com, seanjc@google.com, shivankg@amd.com, 
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71448-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[30];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6F6021727ED
X-Rspamd-Action: no action

Hi,

Currently, guest_memfd doesn't update inode's i_blocks or i_bytes at
all. Hence, st_blocks in the struct populated by a userspace fstat()
call on a guest_memfd will always be 0. This patch series makes
guest_memfd track the amount of memory allocated on an inode, which
allows fstat() to accurately report that on requests from userspace.

The inode's i_blocks and i_bytes fields are updated when the folio is
associated or disassociated from the guest_memfd inode, which are at
allocation and truncation times respectively.

To update inode fields at truncation time, this series implements a
custom truncation function for guest_memfd. An alternative would be to
update truncate_inode_pages_range() to return the number of bytes
truncated or add/use some hook.

Implementing a custom truncation function was chosen to provide
flexibility for handling truncations in future when guest_memfd
supports sources of pages other than the buddy allocator. This
approach of a custom truncation function also aligns with shmem, which
has a custom shmem_truncate_range().

To update inode fields at allocation time, kvm_gmem_get_folio() is
simply augmented such that when a folio is added to the filemap, the
size of the folio is updated into inode fields.

The second patch, to use filemap_alloc_folio() during allocation of
guest_memfd folios, was written as a debugging step to resolve a bug
found by syzbot [1], but turned out to not be the fix. I include it
here because it cleans up the allocation process and provides a nice
foundation for updating inode fields during allocations.

The first patch was separately submitted [2], and provided here since
it is a prerequisite simplication before application of the second
patch.

[1] https://lore.kernel.org/all/29c347bde68ec027259654e8e85371307edf7058.1770148108.git.ackerleytng@google.com/
[2] https://lore.kernel.org/all/20260129172646.2361462-1-ackerleytng@google.com/

Ackerley Tng (10):
  KVM: guest_memfd: Don't set FGP_ACCESSED when getting folios
  KVM: guest_memfd: Directly allocate folios with filemap_alloc_folio()
  mm: truncate: Expose preparation steps for
    truncate_inode_pages_final()
  KVM: guest_memfd: Implement evict_inode for guest_memfd
  mm: Export unmap_mapping_folio() for KVM
  mm: filemap: Export filemap_remove_folio()
  KVM: guest_memfd: Implement custom truncation function
  KVM: guest_memfd: Track amount of memory allocated on inode
  KVM: selftests: Wrap fstat() to assert success
  KVM: selftests: Test that st_blocks is updated on allocation

 include/linux/mm.h                            |   3 +
 mm/filemap.c                                  |   2 +
 mm/internal.h                                 |   2 -
 mm/memory.c                                   |   2 +
 mm/truncate.c                                 |  21 +++-
 .../testing/selftests/kvm/guest_memfd_test.c  |  32 +++--
 .../selftests/kvm/include/kvm_syscalls.h      |   2 +
 virt/kvm/guest_memfd.c                        | 116 +++++++++++++++---
 8 files changed, 149 insertions(+), 31 deletions(-)


base-commit: b1195183ed42f1522fae3fe44ebee3af437aa000
--
2.53.0.345.g96ddfc5eaa-goog

