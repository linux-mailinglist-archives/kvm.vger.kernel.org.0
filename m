Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678803F92AC
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 05:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244068AbhH0DNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 23:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbhH0DNN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 23:13:13 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB7AC061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:25 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id s9-20020a17090aa10900b001797c5272b4so204647pjp.7
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=vCgzekYimM/snulOng8oq997HW2QQXgi7+oHlkfHzP8=;
        b=auGhJHGV4A+0dJtk/tKfNeUhldo257GZohnTOrE3ZxofkdiVKv8xGwRO8pZ6prVFPW
         W9Srkwkaz4zg+vMdIPQzvg4ROtfjn5qyIXJXzNgHcnFbnIN2KEi4LOSJg8KEkql6alcH
         vgbf9WufMvNJ4OVEAzxHJD2MPGzXsR3ugx9bPKLxjWnp29v9mxNJ06/7+jDIgLHSJwS5
         KGGOXr9fbePMUZvBvvTiT24HAZebCNF7d1qbQcOPxjAsxezlkc0mkFiMfElq5iIZHnN8
         rfoR+Ijfc5htEZ7heKElQjQ0S1ACz1HndM6cyS8OSAYWd5sqoQZroJRzjGpuhLjCg/od
         Lc7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=vCgzekYimM/snulOng8oq997HW2QQXgi7+oHlkfHzP8=;
        b=YTqJ7ftY7kva34+nKQta/urnwN/ohogFaTjfbmIcSpk8H76SvhKjuCxfl25FbaPXXZ
         APrLMqRWkmeWrnfWTf4B8qL4txB3cuW0A6sT1bD5+HRUfAmuoFMGw/MRUq7rnKgbmpk/
         esdkJWPgIre1aYCR5V+z0Ahgot020xWD212EkKbEWlSI/0jTbyp21YF7L49cXVUOQ8ww
         dvVy043Xzmf1ksWXKhpM7QtIzqdOoybv1kEthCQ+DVFlWNzsI6O2eL6XJOpM5+yiYBGa
         wpQMK0dsCKBgB7d4tH2cdU88QfaPVQHmosvTFRya6L+HGwcM/hpuZfpHiY9cnGjgx6oB
         xicw==
X-Gm-Message-State: AOAM531OMNNHR+DYkIY+jTQJxzylY9FgeZQYXjG1v2DDwcNf9L1MEqkD
        syj+AqKUHqJYqjdSAzh5jxdRCTG1jGEwzKgaTvzEhf3xpxHsh/0G9TUd5AEcYBFJp8ygDu/7eww
        gxvAgD5okBtRnT68kcYPCccsQMJhAJrkK1EgFnYdXuJYVckmVABiBb8x3//WXoSVBKHgV
X-Google-Smtp-Source: ABdhPJzM1YRBC84f3b6sCoC3cUQitONvDiECRVEQNC0qu8hb0n236PXcd9TRs+wug2UFbaZ/7ACA8trlTqcHW6/A
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a17:90b:ed7:: with SMTP id
 gz23mr297560pjb.1.1630033944176; Thu, 26 Aug 2021 20:12:24 -0700 (PDT)
Date:   Fri, 27 Aug 2021 03:12:05 +0000
Message-Id: <20210827031222.2778522-1-zixuanwang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [kvm-unit-tests PATCH v2 00/17] x86_64 UEFI and AMD SEV/SEV-ES support
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

This patch series updates the x86_64 KVM-Unit-Tests to run under UEFI
and culminates in enabling AMD SEV/SEV-ES. The patches are organized as
three parts.

The first part (patches 1-2) copies code from Varad's patch set [1]
that builds EFI stubs without depending on GNU-EFI. Part 2 and 3 are
built on top of this part.

The second part (patches 3-10) enables the x86_64 test cases to run
under UEFI. In particular, these patches allow the x86_64 test cases to
be built as EFI executables and take full control of the guest VM. The
efi_main() function sets up the KVM-Unit-Tests framework to run under
UEFI and then launches the test cases' main() function. To date, we
have 38/43 test cases running with UEFI using this approach.

The third part of the series (patches 11-17) focuses on SEV. In
particular, these patches introduce SEV/SEV-ES set up code into the EFI
set up process, including checking if SEV is supported, setting c-bits
for page table entries, and (notably) reusing the UEFI #VC handler so
that the set up process does not need to re-implement it (a test case
can always implement a new #VC handler and load it after set up is
finished). Using this approach, we are able to launch the x86_64 test
cases under SEV-ES and exercise KVM's VMGEXIT handler.

Note, a previous feedback [3] indicated that long-term we'd like to
instrument KVM-Unit-Tests with it's own #VC handler. However, we still
believe that the current approach is good as an intermediate solution,
because it unlocks a lot of testing and we do not expect that testing
to be inherently tied to the UEFI's #VC handler. Rather, test cases
should be tied to the underlying GHCB spec implemented by an
arbitrary #VC handler.

See the Part 1 to Part 3 summaries, below, for a high-level breakdown
of how the patches are organized.

Part 1 Summary:
Commits 1-2 copy code from Varad's patch set [1] that implements
EFI-related helper functions to replace the GNU-EFI library.

Part 2 Summary:
Commits 3-4 introduce support to build test cases with EFI support.

Commits 5-9 set up KVM-Unit-Tests to run under UEFI. In doing so, these
patches incrementally enable most existing x86_64 test cases to run
under UEFI.

Commit 10 fixes several test cases that fail to compile with EFI due
to UEFI's position independent code (PIC) requirement.

Part 3 Summary:
Commits 11-12 introduce support for SEV by adding code to set the SEV
c-bit in page table entries.

Commits 13-16 introduce support for SEV-ES by reusing the UEFI #VC
handler in KVM-Unit-Tests. They also fix GDT and IDT issues that occur
when reusing UEFI functions in KVM-Unit-Tests.

Commit 17 adds additional test cases for SEV-ES.

Changes in V2:
1.Merge Varad's patch set [1] as the foundation of this V2 patch set.
2.Remove AMD SEV/SEV-ES config flags and macros (patches 11-17)
3.Drop one commit 'x86 UEFI: Move setjmp.h out of desc.h' because we do
not link GNU-EFI library.

Notes on authorships and attributions:
The first two commits are from Varad's patch set [1], so they are
tagged as 'From:' and 'Signed-off-by:' Varad. Commits 3-7 are from our
V1 patch set [2], and since Varad implemented similar code [1], these
commits are tagged as 'Co-developed-by:' and 'Signed-off-by:' Varad.

Notes on patch sets merging strategy:
We understand that the current merging strategy (reorganizing and
squeezing Varad's patches into two) reduces Varad's authorships, and we
hope the additional attribution tags make up for it. We see another
approach which is to build our patch set on top of Varad's original
patch set, but this creates some noise in the final patch set, e.g.,
x86/cstart64.S is modified in Varad's part and later reverted in our
part as we implement start up code in C. For the sake of the clarity of
the code history, we believe the current approach is the best effort so
far, and we are open to all kinds of opinions.

[1] https://lore.kernel.org/kvm/20210819113400.26516-1-varad.gautam@suse.com/
[2] https://lore.kernel.org/kvm/20210818000905.1111226-1-zixuanwang@google.com/
[3] https://lore.kernel.org/kvm/YSA%2FsYhGgMU72tn+@google.com/

Regards,
Zixuan Wang

Varad Gautam (2):
  x86 UEFI: Copy code from Linux
  x86 UEFI: Implement UEFI function calls

Zixuan Wang (15):
  x86 UEFI: Copy code from GNU-EFI
  x86 UEFI: Boot from UEFI
  x86 UEFI: Load IDT after UEFI boot up
  x86 UEFI: Load GDT and TSS after UEFI boot up
  x86 UEFI: Set up memory allocator
  x86 UEFI: Set up RSDP after UEFI boot up
  x86 UEFI: Set up page tables
  x86 UEFI: Convert x86 test cases to PIC
  x86 AMD SEV: Initial support
  x86 AMD SEV: Page table with c-bit
  x86 AMD SEV-ES: Check SEV-ES status
  x86 AMD SEV-ES: Load GDT with UEFI segments
  x86 AMD SEV-ES: Copy UEFI #VC IDT entry
  x86 AMD SEV-ES: Set up GHCB page
  x86 AMD SEV-ES: Add test cases

 .gitignore                 |   3 +
 Makefile                   |  29 +-
 README.md                  |   6 +
 configure                  |   6 +
 lib/efi.c                  | 117 ++++++++
 lib/efi.h                  |  18 ++
 lib/linux/uefi.h           | 539 +++++++++++++++++++++++++++++++++++++
 lib/x86/acpi.c             |  38 ++-
 lib/x86/acpi.h             |  11 +
 lib/x86/amd_sev.c          | 214 +++++++++++++++
 lib/x86/amd_sev.h          |  64 +++++
 lib/x86/asm/page.h         |  28 +-
 lib/x86/asm/setup.h        |  31 +++
 lib/x86/setup.c            | 246 +++++++++++++++++
 lib/x86/usermode.c         |   3 +-
 lib/x86/vm.c               |  18 +-
 x86/Makefile.common        |  68 +++--
 x86/Makefile.i386          |   5 +-
 x86/Makefile.x86_64        |  58 ++--
 x86/access.c               |   9 +-
 x86/amd_sev.c              |  94 +++++++
 x86/cet.c                  |   8 +-
 x86/efi/README.md          |  63 +++++
 x86/efi/crt0-efi-x86_64.S  |  79 ++++++
 x86/efi/efistart64.S       | 143 ++++++++++
 x86/efi/elf_x86_64_efi.lds |  81 ++++++
 x86/efi/reloc_x86_64.c     |  97 +++++++
 x86/efi/run                |  63 +++++
 x86/emulator.c             |   5 +-
 x86/eventinj.c             |   6 +-
 x86/run                    |  16 +-
 x86/smap.c                 |   8 +-
 x86/umip.c                 |  10 +-
 33 files changed, 2110 insertions(+), 74 deletions(-)
 create mode 100644 lib/efi.c
 create mode 100644 lib/efi.h
 create mode 100644 lib/linux/uefi.h
 create mode 100644 lib/x86/amd_sev.c
 create mode 100644 lib/x86/amd_sev.h
 create mode 100644 lib/x86/asm/setup.h
 create mode 100644 x86/amd_sev.c
 create mode 100644 x86/efi/README.md
 create mode 100644 x86/efi/crt0-efi-x86_64.S
 create mode 100644 x86/efi/efistart64.S
 create mode 100644 x86/efi/elf_x86_64_efi.lds
 create mode 100644 x86/efi/reloc_x86_64.c
 create mode 100755 x86/efi/run

--
2.33.0.259.gc128427fd7-goog

