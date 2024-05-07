Return-Path: <kvm+bounces-16905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 12BE08BEB22
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:07:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A2762B26B23
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 623AA16D4CE;
	Tue,  7 May 2024 18:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ITDJOR9F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6832B16C87F
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 18:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715105256; cv=none; b=gD2LUwqOOqdA3PBPO3cninAvIPJba4mnKA5Oc+7f3SuswDEaEMCA7ieuCnKFrA72dyOPG/g9gOkokov/FP3i9KtN0CnK0ZrKSngiF4aqCS8l3ZU8QyZ8MQ0I9B1zBd8JgLLb7o3o/ZIML2FTD/Ms+J6ZkX+w7gM4etGf8clsMUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715105256; c=relaxed/simple;
	bh=oM0xLP5jl7bR1zRP0BomjyItcpgeGBonLYIWaJTee5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=V7h/JX2fXa1FUboXKQHCg/0pRnvITNAmH/S/foVl96itZQOyxGSYpliDB22H865eexpfVvjseEvtEq61bz7d0rpaUD3H+1C8i/sx5mUK08RCjuLqRfLy1IpH4wO1O9eV7cmfl7kDjFoZlgI262EbC/tH8WNNJvuirkpkKTx9jUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ITDJOR9F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715105253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3ddTGpbjx2+WT1p0uacgUI01OGwZkg2TgnqBeAPppik=;
	b=ITDJOR9FnTGK4eHA5zNN3eTruFM72lQ5iPql92wKQgpI/xLM7sHzQDTM5u28IwGHhRdg4n
	IawwcAtQENbVylJOWq5WqDXvt2jgvEWrZN8IQ52n/cm4MB2aRwOkwuokU8qN8gLWd9bEnj
	B03SXElwLpz7RxBCoBLn7n0SN1pG8yc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-554-xafu7ii7Mp2jy6t5zZO3hg-1; Tue,
 07 May 2024 14:07:30 -0400
X-MC-Unique: xafu7ii7Mp2jy6t5zZO3hg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1766929ABA0B;
	Tue,  7 May 2024 18:07:30 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C88DA40C6EB7;
	Tue,  7 May 2024 18:07:29 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: vbabka@suse.cz,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	michael.roth@amd.com,
	yilun.xu@intel.com
Subject: [PATCH v2 0/9] KVM: guest_memfd: New hooks and functionality for SEV-SNP and TDX
Date: Tue,  7 May 2024 14:07:20 -0400
Message-ID: <20240507180729.3975856-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

This is the hopefully final version of the gmem common API patches,
adding target-independent functionality and hooks that are
needed by SEV-SNP and TDX.

Changes from https://patchew.org/linux/20240404185034.3184582-1-pbonzini@redhat.com/:

- added acks and comments from Vlastimil to patches 1-2

- dropped FGP_CREAT_ONLY, which also means removing kvm_gmem_undo_get_pfn()
  in the last patch

- filemap_grab_folio() cannot return NULL

- dropped weak implementation of kvm_arch_gmem_prepare_needed()

- dropped __kvm_gmem_punch_hole()

- introduced kvm_gmem_populate_cb typedef

- renamed argument of kvm_gmem_populate from gfn to start_gfn,
  variable from this_gfn to gfn

- post_populate hook is mandatory

- replaced implementation of "KVM: x86: Add hook for determining max NPT
  mapping level" with suggestion from SNP series

Contrarily to my answer to Yilun, prepare does not need to test
hwpoison.  It's kvm_gmem_populate() that needs it, and in fact
it already does via __kvm_gmem_get_pfn().

Paolo


Michael Roth (4):
  mm: Introduce AS_INACCESSIBLE for encrypted/confidential memory
  KVM: guest_memfd: Use AS_INACCESSIBLE when creating guest_memfd inode
  KVM: guest_memfd: Add hook for invalidating memory
  KVM: x86: Add hook for determining max NPT mapping level

Paolo Bonzini (5):
  KVM: guest_memfd: pass error up from filemap_grab_folio
  KVM: guest_memfd: limit overzealous WARN
  KVM: guest_memfd: Add hook for initializing memory
  KVM: guest_memfd: extract __kvm_gmem_get_pfn()
  KVM: guest_memfd: Add interface for populating gmem pages with user
    data

 arch/x86/include/asm/kvm-x86-ops.h |   3 +
 arch/x86/include/asm/kvm_host.h    |   3 +
 arch/x86/kvm/mmu/mmu.c             |  23 +++-
 arch/x86/kvm/x86.c                 |  13 +++
 include/linux/kvm_host.h           |  36 +++++++
 include/linux/pagemap.h            |   1 +
 mm/truncate.c                      |   3 +-
 virt/kvm/Kconfig                   |   8 ++
 virt/kvm/guest_memfd.c             | 167 +++++++++++++++++++++++++----
 9 files changed, 231 insertions(+), 26 deletions(-)

-- 
2.43.0


