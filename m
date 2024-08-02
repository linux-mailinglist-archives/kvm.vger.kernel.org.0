Return-Path: <kvm+bounces-23082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2B0994620B
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:51:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3119A1C210F0
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 16:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5968113C914;
	Fri,  2 Aug 2024 16:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TmOxOju/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32AB16BE0E
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 16:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722617483; cv=none; b=Dv4KGt8Tji5lthWG/YR6BGndgzEgSeeZdXO5EhTiGqoCKUxvxI89M/z0PpJ0vg343dd3y2yAxCyHQaPGZoXQGCmW/UpiFLDArEkircIBGCqaeuepdrJrs9Y3tuN+3Hk5t/09j3E3N8JzIoZeJn4oNzblJPCDXYZH6D2ZWkYg14g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722617483; c=relaxed/simple;
	bh=3z/2zYlDCXGTCcM1TjTsleXxMEQbpfFMmDOlcMhN+/k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WhGKitBzZlrqaEDnQR28urPLVz6GFNf2Ao5QpGfcHnQBnjkSo4k1ODkaHRb47neXQ7iL9nnVuwZqAZwGCg2fgpVB0UJDl6zlUyP+CPRmZBkku9bFhW++u/Dn9xIL+ZXZV/BFfoaeq89SK7CyQXhyyyqtq2c5RScSklJmAtrbenY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TmOxOju/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722617480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LZq+J3PF/5lHK2txfO00htKny5WSVtLdCEO2uV8Cy+c=;
	b=TmOxOju/Oz92AU5/TjCy264P8eYym2nZMSlKPdo61kCo0AnvcUutME5mSzZ9+ASdCtBPmB
	qFQgilcOoA4DBxArxD0qxBw++jn5tXWo1XrZKuebnfqSrD7I2IRc7ME8M5ambPDhXevVRA
	jqy6K8tkUv+N54dD/i9jfWH7tA1a/Hc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-470-TQxPMVu6N5GOOpuZHLYoew-1; Fri,
 02 Aug 2024 12:51:19 -0400
X-MC-Unique: TQxPMVu6N5GOOpuZHLYoew-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D581F1944A8D;
	Fri,  2 Aug 2024 16:51:17 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 32F051955D42;
	Fri,  2 Aug 2024 16:51:17 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.11-rc2
Date: Fri,  2 Aug 2024 12:51:16 -0400
Message-ID: <20240802165116.9197-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Linus,

The following changes since commit 8400291e289ee6b2bf9779ff1c83a291501f017b:

  Linux 6.11-rc1 (2024-07-28 14:19:55 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 1773014a975919195be71646fc2c2cad1570fce4:

  Merge branch 'kvm-fixes' into HEAD (2024-08-02 12:33:43 -0400)

The bulk of the changes here is a largish change to guest_memfd, delaying
the clearing and encryption of guest-private pages until they are
actually added to guest page tables.  This started as "let's make it
impossible to misuse the API" for SEV-SNP; but then it ballooned a bit.
The new logic is generally simpler and more ready for hugepage support
in guest_memfd.

Thanks,

Paolo
----------------------------------------------------------------
* fix latent bug in how usage of large pages is determined for
  confidential VMs

* fix "underline too short" in docs

* eliminate log spam from limited APIC timer periods

* disallow pre-faulting of memory before SEV-SNP VMs are initialized

* delay clearing and encrypting private memory until it is added to
  guest page tables

* this change also enables another small cleanup: the checks in
  SNP_LAUNCH_UPDATE that limit it to non-populated, private pages
  can now be moved in the common kvm_gmem_populate() function

* fix compilation error that the RISC-V merge introduced in selftests

----------------------------------------------------------------
Ackerley Tng (1):
      KVM: x86/mmu: fix determination of max NPT mapping level for private pages

Chang Yu (1):
      KVM: Documentation: Fix title underline too short warning

Jim Mattson (1):
      KVM: x86: Eliminate log spam from limited APIC timer periods

Paolo Bonzini (16):
      KVM: x86: disallow pre-fault for SNP VMs before initialization
      KVM: guest_memfd: return folio from __kvm_gmem_get_pfn()
      KVM: guest_memfd: delay folio_mark_uptodate() until after successful preparation
      KVM: guest_memfd: do not go through struct page
      KVM: rename CONFIG_HAVE_KVM_GMEM_* to CONFIG_HAVE_KVM_ARCH_GMEM_*
      KVM: guest_memfd: return locked folio from __kvm_gmem_get_pfn
      KVM: guest_memfd: delay kvm_gmem_prepare_folio() until the memory is passed to the guest
      KVM: guest_memfd: make kvm_gmem_prepare_folio() operate on a single struct kvm
      KVM: remove kvm_arch_gmem_prepare_needed()
      KVM: guest_memfd: move check for already-populated page to common code
      KVM: cleanup and add shortcuts to kvm_range_has_memory_attributes()
      KVM: extend kvm_range_has_memory_attributes() to check subset of attributes
      KVM: guest_memfd: let kvm_gmem_populate() operate only on private gfns
      KVM: guest_memfd: abstract how prepared folios are recorded
      Merge tag 'kvm-riscv-fixes-6.11-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge branch 'kvm-fixes' into HEAD

Yong-Xuan Wang (1):
      KVM: riscv: selftests: Fix compile error

 Documentation/virt/kvm/api.rst                   |   8 +-
 arch/x86/include/asm/kvm_host.h                  |   1 +
 arch/x86/kvm/Kconfig                             |   4 +-
 arch/x86/kvm/lapic.c                             |   2 +-
 arch/x86/kvm/mmu/mmu.c                           |   7 +-
 arch/x86/kvm/svm/sev.c                           |  17 +-
 arch/x86/kvm/svm/svm.c                           |   1 +
 arch/x86/kvm/x86.c                               |  12 +-
 include/linux/kvm_host.h                         |   9 +-
 tools/testing/selftests/kvm/riscv/get-reg-list.c |   8 +-
 virt/kvm/Kconfig                                 |   4 +-
 virt/kvm/guest_memfd.c                           | 227 ++++++++++++++---------
 virt/kvm/kvm_main.c                              |  73 ++++----
 13 files changed, 214 insertions(+), 159 deletions(-)


