Return-Path: <kvm+bounces-13596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67E04898E46
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 20:51:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 064BD1F24929
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13261133404;
	Thu,  4 Apr 2024 18:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h3M+Dofd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABE21311B4
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 18:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712256641; cv=none; b=afQM8XA8rDRAwldUCDluTXQkq+LV+3vtdFpSR+7KrEvY/6XlxdWrNgwpdcHM9ywREPBZGph+gBwTBBCXLGzEh+mr/vd/xrYQ3E8qx8oSocwB1SDkHebRKkl9qJ43tRGh63BaT4/4EWRyNM2YTV1lA4lY+YMvfLE2fSLPhUIxzYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712256641; c=relaxed/simple;
	bh=+Ow8KhJTzO8VPoYKwL7qe3PnkQ9EklWJ5SuZs3K2q/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=a1MARcV+vzMxkH3ri6XTkZjIW/lPf7MPq6G5J6sUmroeg6HHCJNZlrA5FtOtbIccMXrxQ7lvzZHq1Cv4tG7xHyp/1DXs44XUhbgvztxkadJLG/R7IyTNAiCyPP6xB6p1uFEWbCYR5cUrQt2JpaX7AIRTEJZEB6Esthn0ow85hm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h3M+Dofd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712256638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=x14DtsNMvIOrspoag3gOecAB/Pjfzl1YzHd1pA6CG68=;
	b=h3M+Dofd3UX117k3iJeV5JetS2hezLe816l5kE1dYoKoaZT6kkagEIDqQCLi4Uv6rSQDJt
	WoSXX5aOdvIGZBNPiyzY1nuVvpQ2hulSQ26ynA5Riwa6158v+OoLJCGOaRmI0w39DpgZOR
	iEbRabW2RnwH2LJIDOthKJeUumlUo/M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-_faobFCjPIaRe213qj9J7A-1; Thu, 04 Apr 2024 14:50:35 -0400
X-MC-Unique: _faobFCjPIaRe213qj9J7A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C30BE8007A3;
	Thu,  4 Apr 2024 18:50:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 951DA1C060A4;
	Thu,  4 Apr 2024 18:50:34 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	isaku.yamahata@intel.com,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 00/11] KVM: guest_memfd: New hooks and functionality for SEV-SNP and TDX
Date: Thu,  4 Apr 2024 14:50:22 -0400
Message-ID: <20240404185034.3184582-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

[Matthew, you're Cc'd here for patches 1 and 3 which touch
 the mm/filemap code.  Since in the meanwhile the KVM side has
 taken a more definitive shape, this time through review/ack is
 welcome! And there is a proper commit message too. - Paolo]

This is the next version of the gmem common API patches,
adding target-independent functionality and hooks that are
needed by SEV-SNP and TDX.

The code in here is mostly taken from two series:

- [PATCH 00/21] TDX/SNP part 1 of n, for 6.9
  https://lore.kernel.org/kvm/20240227232100.478238-1-pbonzini@redhat.com/

- [PATCH gmem 0/6] gmem fix-ups and interfaces for populating gmem pages
  https://lore.kernel.org/kvm/20240329212444.395559-1-michael.roth@amd.com/

1-2: This introduces an AS_INACCESSIBLE flag that prevents unexpected
     accesses to hole-punched gmem pages before invalidation hooks have had
     a chance to make them safely accessible to the host again.

3-9: This introduces an interface for preparing gmem pages either on first
     use or by populating them with user data.

     The latter interface, kvm_gmem_populate(), alternates calls
     to __kvm_gmem_get_pfn() with calls to a user provided callback.
     This implementation simplifies the handling of races and errors,
     by confining filemap rollback and locking in kvm_gmem_populate().
     The function's tasks are otherwise kept to the minimum so that
     it can be used by both SNP and TDX.

10-11: This introduces other hooks needed by SEV-SNP, and is unchanged
       from "[PATCH 00/21] TDX/SNP part 1 of n, for 6.9".

The main changes compared to the previous posting are in patch 9;
both the locking of kvm_gmem_populate() (which now takes the
filemap's invalidate_lock) and the operation of the function
(which now looks up the memslot, but OTOH does not do copy_from_user()
anymore) are pretty new.  I tested the logic slightly by adding a call
to it for sw-protected VMs.

Shout or post fixups if it breaks something for you.

Current state:

- kvm/queue has the SEV_INIT2 and some easy refactorings from
  the TDX series.  Both are expected to move to kvm/next soon.

- I have pushed this already at kvm-coco-queue, but I haven't
  finished the #VE series yet so tomorrow I'll post it and
  update kvm-coco-queue again.

Paolo


Michael Roth (4):
  mm: Introduce AS_INACCESSIBLE for encrypted/confidential memory
  KVM: guest_memfd: Use AS_INACCESSIBLE when creating guest_memfd inode
  KVM: guest_memfd: Add hook for invalidating memory
  KVM: x86: Add gmem hook for determining max NPT mapping level

Paolo Bonzini (7):
  KVM: guest_memfd: pass error up from filemap_grab_folio
  filemap: add FGP_CREAT_ONLY
  KVM: guest_memfd: limit overzealous WARN
  KVM: guest_memfd: Add hook for initializing memory
  KVM: guest_memfd: extract __kvm_gmem_get_pfn()
  KVM: guest_memfd: extract __kvm_gmem_punch_hole()
  KVM: guest_memfd: Add interface for populating gmem pages with user
    data

 arch/x86/include/asm/kvm-x86-ops.h |   3 +
 arch/x86/include/asm/kvm_host.h    |   4 +
 arch/x86/kvm/mmu/mmu.c             |   8 +
 arch/x86/kvm/x86.c                 |  13 ++
 include/linux/kvm_host.h           |  35 +++++
 include/linux/pagemap.h            |   3 +
 mm/filemap.c                       |   4 +
 mm/truncate.c                      |   3 +-
 virt/kvm/Kconfig                   |   8 +
 virt/kvm/guest_memfd.c             | 230 ++++++++++++++++++++++++-----
 10 files changed, 277 insertions(+), 34 deletions(-)

-- 
2.43.0


