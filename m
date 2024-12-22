Return-Path: <kvm+bounces-34322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 855879FA877
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 23:36:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9BF11886599
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 22:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76497194C77;
	Sun, 22 Dec 2024 22:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PLOakvNX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E6E192B62;
	Sun, 22 Dec 2024 22:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734906968; cv=none; b=trVUNzOJM58aV7fhtNY2Yi5oDcIhCFk0g5ijz/Hm0nJ9vsdIzYH3msb4kOcoKbwwJF6yoHNGN7JaZ4T0uuXWVetrc7sfNjpvYegRA9yo1qy/NQwvOA5UhKwQ2mKgpg2ybIIcPpKj2Vt5oBO7OfiiQsMcuftmRIS/m2B7llOxOTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734906968; c=relaxed/simple;
	bh=/43HSdEtYyVjDZJjnecKHUCc3uqTj+JIRgsPRb+NMrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pBkIIqyy99mssrkcJr7D4b88K2ZTwzaMucYKPw8Jr7S2LuuvJ8oty2hOlk5d96HJSYOEN04H2GBX2QRMTMnIHaVonweYaj6q4MDqbHJ77N3fhVvOlmGRHsK1DI0UQB4BkMfFWwYg1cmm298axJKTbe5LoaCvzHsn5xsqycxcdmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PLOakvNX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA08C4CECD;
	Sun, 22 Dec 2024 22:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734906967;
	bh=/43HSdEtYyVjDZJjnecKHUCc3uqTj+JIRgsPRb+NMrQ=;
	h=Date:From:To:Cc:Subject:From;
	b=PLOakvNX3nznLdM0zf+oPLS6/dOKix5wtjclqBXG/Qckr1H+w6xdsT/6d9qj/ldfn
	 T3yaEIvxehrVnx3mmaGehfkVd2uu8krKqTuFeXZfRXOBd7+Li3Qe8SguMQj3uKplEs
	 F1HkZ2rnDpj3VTvDwxgGDe7BuiOD/fvmT5GSVYdPoFKamg/o61PJqQPRoplUydRZ19
	 tJvJDWfYAydIUOeSC6f8CtwhetQNqT36B6B/bnV+Q93Wz3yO+3YLRpFrEpddtdGefH
	 8+secFKHbkoobdiwm9KyMbjEbFIxYKmn6c76YeFf91bmuvTEWNVwSOFBroYe3ei8Lu
	 cE4uEv3Bh44eA==
Date: Sun, 22 Dec 2024 16:36:04 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Athul Krishna <athul.krishna.kr@protonmail.com>
Cc: kvm@vger.kernel.org, linux-pci@vger.kernel.org,
	regressions@lists.linux.dev
Subject: [bugzilla-daemon@kernel.org: [Bug 219619] New: vfio-pci: screen
 graphics artifacts after 6.12 kernel upgrade]
Message-ID: <20241222223604.GA3735586@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Forwarding since not everybody follows bugzilla.  Apparently bisected
to f9e54c3a2f5b ("vfio/pci: implement huge_fault support").

Athul, f9e54c3a2f5b appears to revert cleanly from v6.13-rc1.  Can you
verify that reverting it is enough to avoid these artifacts?

#regzbot introduced: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")

----- Forwarded message from bugzilla-daemon@kernel.org -----

Date: Sat, 21 Dec 2024 10:10:02 +0000
From: bugzilla-daemon@kernel.org
To: bjorn@helgaf9e54c3a2f5bas.com
Subject: [Bug 219619] New: vfio-pci: screen graphics artifacts after 6.12 kernel upgrade
Message-ID: <bug-219619-41252@https.bugzilla.kernel.org/>

https://bugzilla.kernel.org/show_bug.cgi?id=219619

            Bug ID: 219619
           Summary: vfio-pci: screen graphics artifacts after 6.12 kernel
                    upgrade
           Product: Drivers
           Version: 2.5
          Hardware: AMD
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: PCI
          Assignee: drivers_pci@kernel-bugs.osdl.org
          Reporter: athul.krishna.kr@protonmail.com
        Regression: No

Created attachment 307382
  --> https://bugzilla.kernel.org/attachment.cgi?id=307382&action=edit
dmesg

Device: Asus Zephyrus GA402RJ
CPU: Ryzen 7 6800HS
GPU: RX 6700S
Kernel: 6.13.0-rc3-g8faabc041a00

Problem:
Launching games or gpu bench-marking tools in qemu windows 11 vm will cause
screen artifacts, ultimately qemu will pause with unrecoverable error.

Commit:
f9e54c3a2f5b79ecc57c7bc7d0d3521e461a2101 is the first bad commit
commit f9e54c3a2f5b79ecc57c7bc7d0d3521e461a2101
Author: Alex Williamson <alex.williamson@redhat.com>
Date:   Mon Aug 26 16:43:53 2024 -0400

    vfio/pci: implement huge_fault support

    With the addition of pfnmap support in vmf_insert_pfn_{pmd,pud}() we can
    take advantage of PMD and PUD faults to PCI BAR mmaps and create more
    efficient mappings.  PCI BARs are always a power of two and will typically
    get at least PMD alignment without userspace even trying.  Userspace
    alignment for PUD mappings is also not too difficult.

    Consolidate faults through a single handler with a new wrapper for
    standard single page faults.  The pre-faulting behavior of commit
    d71a989cf5d9 ("vfio/pci: Insert full vma on mmap'd MMIO fault") is removed
    in this refactoring since huge_fault will cover the bulk of the faults and
    results in more efficient page table usage.  We also want to avoid that
    pre-faulted single page mappings preempt huge page mappings.

    Link: https://lkml.kernel.org/r/20240826204353.2228736-20-peterx@redhat.com
    Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
    Signed-off-by: Peter Xu <peterx@redhat.com>
    Cc: Alexander Gordeev <agordeev@linux.ibm.com>
    Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    Cc: Borislav Petkov <bp@alien8.de>
    Cc: Catalin Marinas <catalin.marinas@arm.com>
    Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
    Cc: Dave Hansen <dave.hansen@linux.intel.com>
    Cc: David Hildenbrand <david@redhat.com>
    Cc: Gavin Shan <gshan@redhat.com>
    Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    Cc: Heiko Carstens <hca@linux.ibm.com>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Jason Gunthorpe <jgg@nvidia.com>
    Cc: Matthew Wilcox <willy@infradead.org>
    Cc: Niklas Schnelle <schnelle@linux.ibm.com>
    Cc: Paolo Bonzini <pbonzini@redhat.com>
    Cc: Ryan Roberts <ryan.roberts@arm.com>
    Cc: Sean Christopherson <seanjc@google.com>
    Cc: Sven Schnelle <svens@linux.ibm.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Vasily Gorbik <gor@linux.ibm.com>
    Cc: Will Deacon <will@kernel.org>
    Cc: Zi Yan <ziy@nvidia.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 drivers/vfio/pci/vfio_pci_core.c | 60 ++++++++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 17 deletions(-)

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.

----- End forwarded message -----

