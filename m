Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA1477C5D7
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbfGaPKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:10:54 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42264 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388284AbfGaPIU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:08:20 -0400
Received: by mail-ed1-f68.google.com with SMTP id v15so66043644eds.9
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CeyH5xklnpYBs6CGVIzo+cxzDISU4PO2e+tzGnUlwU0=;
        b=E/z0OwHO4VjIMi8tgJyUoNgNaJaby2/cyfOFIU+Sq8CE10sFcQ2mu9j8KdYlzvcUeO
         5tqKu+oxyPhe55UjY/g8mIU1V3+cqkNmCXtS9JljylhZb/90ijuIHMQr+N4+8YyJqTU+
         CxFXl8WqxdtMXvnijzAmv+kNMHTOuEYR4Im6vqo82nId8HfQWvTtN39gEK+pEWEwYRoM
         nt5bJKyefpzsienZAY3roY7xhYbeE9k2FRARsG2El9T6Ly5jWFPOhN5UMxS5GG8A93Kn
         j0+OkmZ10uLZsoiSU64Ufp8c8178jqGJBCF/RcVxNz+bN6/r30eu4QCY4lBCqa/W6pPq
         TFEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CeyH5xklnpYBs6CGVIzo+cxzDISU4PO2e+tzGnUlwU0=;
        b=sUaFJFB9QwGsOzr6dJ+JYgrwWk+GFjOLoxcZxDfSUBqobVMSb+LZVArNao+o7V/cqN
         EppmMHuC+G7K5UIvitt1dFtvZoJyV1TqMZFkMEGV5MPpByQpaJdMZeOtSD29mB0feSfe
         gE0XP6ritkc4Z1iJCw5Q8H4GUd7heR/yVcvOs5KQ9Ucd+c55j+ysc2ttAuPwxr7xzFT7
         etUcJkKkT9MQKqrqM8UjYI/uZStz01GceVhopKLvZQ+0McpHLHQRq9XDE4bZv3Pqkl8Z
         8nKORW+hq8Z9z4cS+t227CUio4wTGyha81mQsKX59agUmZfR5xAIJv4EELGw0xN+GPcv
         Hg4A==
X-Gm-Message-State: APjAAAWh+BTSHqUOWA1oSu8lYpLWxTCCMJ0wPFjP3+N5DWFHXVV/5Tt9
        xEQj4k6sP2pS5eVP7Mi5Dm0=
X-Google-Smtp-Source: APXvYqzUdD7hKI/2w91hB5okX/8AVmQRF7XP3uxtUq8EpFiJNIZkdxdXzAuH1096Fn3w/jBRodRDtA==
X-Received: by 2002:a17:906:68d0:: with SMTP id y16mr95508683ejr.161.1564585697298;
        Wed, 31 Jul 2019 08:08:17 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id p43sm17362727edc.3.2019.07.31.08.08.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:08:15 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id E60C3101317; Wed, 31 Jul 2019 18:08:15 +0300 (+03)
To:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 00/59] Intel MKTME enabling
Date:   Wed, 31 Jul 2019 18:07:14 +0300
Message-Id: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

= Intro =

The patchset brings enabling of Intel Multi-Key Total Memory Encryption.
It consists of changes into multiple subsystems:

 * Core MM: infrastructure for allocation pages, dealing with encrypted VMAs
   and providing API setup encrypted mappings.
 * arch/x86: feature enumeration, program keys into hardware, setup
   page table entries for encrypted pages and more.
 * Key management service: setup and management of encryption keys.
 * DMA/IOMMU: dealing with encrypted memory on IO side.
 * KVM: interaction with virtualization side.
 * Documentation: description of APIs and usage examples.

Please review. Any feedback is welcome.

= Overview =

Multi-Key Total Memory Encryption (MKTME)[1] is a technology that allows
transparent memory encryption in upcoming Intel platforms.  It uses a new
instruction (PCONFIG) for key setup and selects a key for individual pages
by repurposing physical address bits in the page tables.

These patches add support for MKTME into the existing kernel keyring
subsystem and add a new mprotect_encrypt() system call that can be used by
applications to encrypt anonymous memory with keys obtained from the
keyring.

This architecture supports encrypting both normal, volatile DRAM and
persistent memory.  However, these patches do not implement persistent
memory support.  We anticipate adding that support next.

== Hardware Background ==

MKTME is built on top of an existing single-key technology called TME.
TME encrypts all system memory using a single key generated by the CPU on
every boot of the system. TME provides robust mitigation against
single-read physical attacks, such as physically removing a DIMM and
inspecting its contents.  TME provides weaker mitigations against
multiple-read physical attacks.

MKTME enables the use of multiple encryption keys[2], allowing selection
of the encryption key per-page using the page tables.  Encryption keys are
programmed into each memory controller and the same set of keys is
available to all entities on the system with access to that memory (all
cores, DMA engines, etc...).

MKTME inherits many of the mitigations against hardware attacks from TME.
Like TME, MKTME does not fully mitigate vulnerable or malicious operating
systems or virtual machine managers.  MKTME offers additional mitigations
when compared to TME.

TME and MKTME use the AES encryption algorithm in the AES-XTS mode.  This
mode, typically used for block-based storage devices, takes the physical
address of the data into account when encrypting each block.  This ensures
that the effective key is different for each block of memory. Moving
encrypted content across physical address results in garbage on read,
mitigating block-relocation attacks.  This property is the reason many of
the discussed attacks require control of a shared physical page to be
handed from the victim to the attacker.

== MKTME-Provided Mitigations ==

MKTME adds a few mitigations against attacks that are not mitigated when
using TME alone.  The first set are mitigations against software attacks
that are familiar today:

 * Kernel Mapping Attacks: information disclosures that leverage the
   kernel direct map are mitigated against disclosing user data.
 * Freed Data Leak Attacks: removing an encryption key from the
   hardware mitigates future user information disclosure.

The next set are attacks that depend on specialized hardware, such as an
“evil DIMM” or a DDR interposer:

 * Cross-Domain Replay Attack: data is captured from one domain
   (guest) and replayed to another at a later time.
 * Cross-Domain Capture and Delayed Compare Attack: data is captured
   and later analyzed to discover secrets.
 * Key Wear-out Attack: data is captured and analyzed in order to
   later write precise changes to plaintext.

More details on these attacks are below.

MKTME does not mitigate all attacks that can be performed with an “evil
DIMM” or a DDR interposer.  In determining MKTME’s security value in an
environment, the ease and effectiveness of the above attacks mitigated by
MKTME should be compared with those which are not mitigated.  Some key
examples of unmitigated attacks follow:

  * Random Data Modification Attack: An attacker writes random
    ciphertext, which causes the victim to consume random data.
    This can be used to flip security-sensitive bits.
  * Same-Domain Replay Attacks: Data can be captured and replayed
    within a single domain. An attacker could, for instance, replay
    an old ‘struct cred’ value to a newer, less-privileged process.
  * Ciphertext Side Channel Attacks: Similar to delayed-compare
    attacks, useful information might be inferred even from ciphertext.
    This information might be leveraged to infer information about
    secrets such as private keys.

=== Kernel Mapping Attacks ===

Information disclosure vulnerabilities leverage the kernel direct map
because many vulnerabilities involve manipulation of kernel data
structures (examples: CVE-2017-7277, CVE-2017-9605).  We normally think of
these bugs as leaking valuable *kernel* data, but they can leak
application data when application pages are recycled for kernel use.

With this MKTME implementation, there is a direct map created for each
MKTME KeyID which is used whenever the kernel needs to access plaintext.
But, all kernel data structures are accessed via the direct map for
KeyID-0.  Thus, memory reads which are not coordinated with the KeyID get
garbage (for example, accessing KeyID-4 data with the KeyID-0 mapping).

This means that if sensitive data encrypted using MKTME is leaked via the
KeyID-0 direct map, ciphertext decrypted with the wrong key will be
disclosed.  To disclose plaintext, an attacker must “pivot” to the correct
direct mapping, which is non-trivial because there are no kernel data
structures in the KeyID!=0 direct mapping.

=== Freed Data Leak Attack ===

The kernel has a history of bugs around uninitialized data.  Usually, we
think of these bugs as leaking sensitive kernel data, but they can also be
used to leak application secrets.

MKTME can help mitigate the case where application secrets are leaked:

 * App (or VM) places a secret in a page
 * App exits or frees memory to kernel allocator
 * Page added to allocator free list
 * Attacker reallocates page to a purpose where it can read the page

Now, imagine MKTME was in use on the memory being leaked.  The data can
only be leaked as long as the key is programmed in the hardware.  If the
key is de-programmed, like after all pages are freed after a guest is shut
down, any future reads will just see ciphertext.

Basically, the key is a convenient choke-point: you can be more confident
that data encrypted with it is inaccessible once the key is removed.

=== Cross-Domain Replay Attack ===

MKTME mitigates cross-domain replay attacks where an attacker replaces an
encrypted block owned by one domain with a block owned by another domain.
MKTME does not prevent this replacement from occurring, but it does
mitigate plaintext from being disclosed if the domains use different keys.

With TME, the attack could be executed by:
 * A victim places secret in memory, at a given physical address.
   Note: AES-XTS is what restricts the attack to being performed at a
   single physical address instead of across different physical
   addresses
 * Attacker captures victim secret’s ciphertext
 * Later on, after victim frees the physical address, attacker gains
   ownership
 * Attacker puts the ciphertext at the address and get the secret
   plaintext

But, due to the presumably different keys used by the attacker and the
victim, the attacker can not successfully decrypt old ciphertext.

=== Cross-Domain Capture and Delayed Compare Attack ===

This is also referred to as a kind of dictionary attack.

Similarly, MKTME protects against cross-domain capture-and-compare
attacks. Consider the following scenario:
 * A victim places a secret in memory, at a known physical address
 * Attacker captures victim’s ciphertext
 * Attacker gains control of the target physical address, perhaps
   after the victim’s VM is shut down or its memory reclaimed.
 * Attacker computes and writes many possible plaintexts until new
   ciphertext matches content captured previously.

Secrets which have low (plaintext) entropy are more vulnerable to this
attack because they reduce the number of possible plaintexts an attacker
has to compute and write.

The attack will not work if attacker and victim uses different keys.

=== Key Wear-out Attack ===

Repeated use of an encryption key might be used by an attacker to infer
information about the key or the plaintext, weakening the encryption.  The
higher the bandwidth of the encryption engine, the more vulnerable the key
is to wear-out.  The MKTME memory encryption hardware works at the speed
of the memory bus, which has high bandwidth.

This attack requires capturing potentially large amounts of cipertext,
processing it, then replaying modified cipertext.  Our expectation is that
most attackers would opt for lower-cost attacks like the replay attack
mentioned above.

For this implementation, the kernel always uses KeyID-0 which is always
vulnerable to wear out since it can not be rotated.  KeyID-0 wearout can
be mitigated by limiting the bandwidth with which an attacker can write
KeyID-0-encrypted data.

Such a weakness has been demonstrated[3] on a theoretical cipher with
similar properties as AES-XTS.

An attack would take the following steps:
 * Victim system is using TME with AES-XTS-128
 * Attacker repeatedly captures ciphertext/plaintext pairs (can be
   performed with online hardware attack like an interposer).
 * Attacker compels repeated use of the key under attack for a
   sustained time period without a system reboot[4].
 * Attacker discovers a ‘plaintext XOR cipertext’ collision pair
 * Attacker can induce controlled modifications to the targeted
   plaintext by modifying the colliding ciphertext

MKTME mitigates key wear-out in two ways:
 * Keys can be rotated periodically to mitigate wear-out.  Since TME
   keys are generated at boot, rotation of TME keys requires a
   reboot.  In contrast, MKTME allows rotation while the system is
   booted.  An application could implement a policy to rotate keys at
   a frequency which is not feasible to attack.
 * In the case that MKTME is used to encrypt two guests’ memory with
   two different keys, an attack on one guest’s key would not weaken
   the key used in the second guest.

== Userspace API ==

Here's an overview of the anonymous memory encryption process
as viewed from user space:

 * Allocate an MKTME Key:
        key = add_key("mktme", "name", "type=cpu algorithm=aes-xts-128" @u
 * Map memory:
        ptr = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
 * Protect memory:
        ret = syscall(SYS_encrypt_mprotect, ptr, size, PROT_READ|PROT_WRITE,
                      key);

*Enjoy the encrypted memory*

 * Free memory:
        ret = munmap(ptr, size);

 * Free the MKTME key:
        ret = keyctl(KEYCTL_INVALIDATE, key);

See the documentation patches for more info and a demo program.

This update removes support for user type keys. This closes a security
gap, where the encryption keys were exposed to user space. Additionally,
memory hotplug support was basically removed from the API. Only skeleton
support remains to enforce the rule that no new memory may be added to the
MKTME system.  This is a deferral of memory hot add support until the
platform support is in place.

== Changelog ==

v2:
 - Add comments in allocation and free paths on how ordering is ensured.
 - Modify pageattr code to sync direct mapping after the canonical direct
   mapping is modified.
 - Introduce helpers to access number of KeyIDs, KeyID shift and KeyID
   mask.
 - Drop unneeded EXPORT_SYMBOL_GPL().
 - User type key support, keys in which users bring their own encryption
   keys, has been removed. CPU generated keys remain and should be used
   instead of USER type keys.  (removes security gap, reduces complexity)
 - Adding a CPU generated key no longer offers the user an option of
   supplying additional entropy to the data and tweak key. (reduces
   complexity)
 - Memory hotplug add support is removed. This is basically a deferral
   of the feature until we have platform support for the feature.
   (reduces complexity)
 - Documentation is updated to match changes to the add key API.
 - Documentation adds an index in the x86 index, and corrects a typo.
 - Reference counting: code and commit message comments are updated
   to reflect the general nature of the ref counter. Previous comments
   said it counted VMAs only.
 - Replace an GFP_ATOMIC with GFP_KERNEL is mktme_keys.c

--

[1] https://software.intel.com/sites/default/files/managed/a5/16/Multi-Key-Total-Memory-Encryption-Spec.pdf
[2] The MKTME architecture supports up to 16 bits of KeyIDs, so a
    maximum of 65535 keys on top of the “TME key” at KeyID-0.  The
    first implementation is expected to support 5 bits, making 63 keys
    available to applications.  However, this is not guaranteed.  The
    number of available keys could be reduced if, for instance,
    additional physical address space is desired over additional
    KeyIDs.
[3] http://web.cs.ucdavis.edu/~rogaway/papers/offsets.pdf
[4] This sustained time required for an attack could vary from days
    to years depending on the attacker’s goals.

Alison Schofield (30):
  x86/pconfig: Set an activated algorithm in all MKTME commands
  keys/mktme: Introduce a Kernel Key Service for MKTME
  keys/mktme: Preparse the MKTME key payload
  keys/mktme: Instantiate MKTME keys
  keys/mktme: Destroy MKTME keys
  keys/mktme: Move the MKTME payload into a cache aligned structure
  keys/mktme: Set up PCONFIG programming targets for MKTME keys
  keys/mktme: Program MKTME keys into the platform hardware
  keys/mktme: Set up a percpu_ref_count for MKTME keys
  keys/mktme: Clear the key programming from the MKTME hardware
  keys/mktme: Require CAP_SYS_RESOURCE capability for MKTME keys
  acpi: Remove __init from acpi table parsing functions
  acpi/hmat: Determine existence of an ACPI HMAT
  keys/mktme: Require ACPI HMAT to register the MKTME Key Service
  acpi/hmat: Evaluate topology presented in ACPI HMAT for MKTME
  keys/mktme: Do not allow key creation in unsafe topologies
  keys/mktme: Support CPU hotplug for MKTME key service
  keys/mktme: Block memory hotplug additions when MKTME is enabled
  mm: Generalize the mprotect implementation to support extensions
  syscall/x86: Wire up a system call for MKTME encryption keys
  x86/mm: Set KeyIDs in encrypted VMAs for MKTME
  mm: Add the encrypt_mprotect() system call for MKTME
  x86/mm: Keep reference counts on hardware key usage for MKTME
  mm: Restrict MKTME memory encryption to anonymous VMAs
  x86/mktme: Overview of Multi-Key Total Memory Encryption
  x86/mktme: Document the MKTME provided security mitigations
  x86/mktme: Document the MKTME kernel configuration requirements
  x86/mktme: Document the MKTME Key Service API
  x86/mktme: Document the MKTME API for anonymous memory encryption
  x86/mktme: Demonstration program using the MKTME APIs

Jacob Pan (3):
  iommu/vt-d: Support MKTME in DMA remapping
  x86/mm: introduce common code for mem encryption
  x86/mm: Use common code for DMA memory encryption

Kai Huang (1):
  kvm, x86, mmu: setup MKTME keyID to spte for given PFN

Kirill A. Shutemov (25):
  mm: Do no merge VMAs with different encryption KeyIDs
  mm: Add helpers to setup zero page mappings
  mm/ksm: Do not merge pages with different KeyIDs
  mm/page_alloc: Unify alloc_hugepage_vma()
  mm/page_alloc: Handle allocation for encrypted memory
  mm/khugepaged: Handle encrypted pages
  x86/mm: Mask out KeyID bits from page table entry pfn
  x86/mm: Introduce helpers to read number, shift and mask of KeyIDs
  x86/mm: Store bitmask of the encryption algorithms supported by MKTME
  x86/mm: Preserve KeyID on pte_modify() and pgprot_modify()
  x86/mm: Detect MKTME early
  x86/mm: Add a helper to retrieve KeyID for a page
  x86/mm: Add a helper to retrieve KeyID for a VMA
  x86/mm: Add hooks to allocate and free encrypted pages
  x86/mm: Map zero pages into encrypted mappings correctly
  x86/mm: Rename CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING
  x86/mm: Allow to disable MKTME after enumeration
  x86/mm: Calculate direct mapping size
  x86/mm: Implement syncing per-KeyID direct mappings
  x86/mm: Handle encrypted memory in page_to_virt() and __pa()
  mm/page_ext: Export lookup_page_ext() symbol
  mm/rmap: Clear vma->anon_vma on unlink_anon_vmas()
  x86/mm: Disable MKTME on incompatible platform configurations
  x86/mm: Disable MKTME if not all system memory supports encryption
  x86: Introduce CONFIG_X86_INTEL_MKTME

 Documentation/x86/index.rst                   |   1 +
 Documentation/x86/mktme/index.rst             |  13 +
 .../x86/mktme/mktme_configuration.rst         |   6 +
 Documentation/x86/mktme/mktme_demo.rst        |  53 ++
 Documentation/x86/mktme/mktme_encrypt.rst     |  56 ++
 Documentation/x86/mktme/mktme_keys.rst        |  61 ++
 Documentation/x86/mktme/mktme_mitigations.rst | 151 ++++
 Documentation/x86/mktme/mktme_overview.rst    |  57 ++
 Documentation/x86/x86_64/mm.rst               |   4 +
 arch/alpha/include/asm/page.h                 |   2 +-
 arch/x86/Kconfig                              |  31 +-
 arch/x86/entry/syscalls/syscall_32.tbl        |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl        |   1 +
 arch/x86/include/asm/intel_pconfig.h          |  14 +-
 arch/x86/include/asm/mem_encrypt.h            |  29 +
 arch/x86/include/asm/mktme.h                  |  96 +++
 arch/x86/include/asm/page.h                   |   4 +
 arch/x86/include/asm/page_32.h                |   1 +
 arch/x86/include/asm/page_64.h                |   4 +-
 arch/x86/include/asm/pgtable.h                |  19 +
 arch/x86/include/asm/pgtable_types.h          |  23 +-
 arch/x86/include/asm/setup.h                  |   6 +
 arch/x86/kernel/cpu/intel.c                   |  65 +-
 arch/x86/kernel/head64.c                      |   4 +
 arch/x86/kernel/setup.c                       |   3 +
 arch/x86/kvm/mmu.c                            |  18 +-
 arch/x86/mm/Makefile                          |   3 +
 arch/x86/mm/init_64.c                         |  65 ++
 arch/x86/mm/kaslr.c                           |  11 +-
 arch/x86/mm/mem_encrypt.c                     |  30 -
 arch/x86/mm/mem_encrypt_common.c              |  52 ++
 arch/x86/mm/mktme.c                           | 683 ++++++++++++++++++
 arch/x86/mm/pageattr.c                        |  27 +
 drivers/acpi/hmat/hmat.c                      |  67 ++
 drivers/acpi/tables.c                         |  10 +-
 drivers/firmware/efi/efi.c                    |  25 +-
 drivers/iommu/intel-iommu.c                   |  29 +-
 fs/dax.c                                      |   3 +-
 fs/exec.c                                     |   4 +-
 fs/userfaultfd.c                              |   7 +-
 include/asm-generic/pgtable.h                 |   8 +
 include/keys/mktme-type.h                     |  31 +
 include/linux/acpi.h                          |   9 +-
 include/linux/dma-direct.h                    |   4 +-
 include/linux/efi.h                           |   1 +
 include/linux/gfp.h                           |  56 +-
 include/linux/intel-iommu.h                   |   9 +-
 include/linux/mem_encrypt.h                   |  23 +-
 include/linux/migrate.h                       |  14 +-
 include/linux/mm.h                            |  27 +-
 include/linux/page_ext.h                      |  11 +-
 include/linux/syscalls.h                      |   2 +
 include/uapi/asm-generic/unistd.h             |   4 +-
 kernel/fork.c                                 |   2 +
 kernel/sys_ni.c                               |   2 +
 mm/compaction.c                               |   3 +
 mm/huge_memory.c                              |   6 +-
 mm/khugepaged.c                               |  10 +
 mm/ksm.c                                      |  17 +
 mm/madvise.c                                  |   2 +-
 mm/memory.c                                   |   3 +-
 mm/mempolicy.c                                |  30 +-
 mm/migrate.c                                  |   4 +-
 mm/mlock.c                                    |   2 +-
 mm/mmap.c                                     |  31 +-
 mm/mprotect.c                                 |  98 ++-
 mm/page_alloc.c                               |  74 ++
 mm/page_ext.c                                 |   5 +
 mm/rmap.c                                     |   4 +-
 mm/userfaultfd.c                              |   3 +-
 security/keys/Makefile                        |   1 +
 security/keys/mktme_keys.c                    | 590 +++++++++++++++
 72 files changed, 2670 insertions(+), 155 deletions(-)
 create mode 100644 Documentation/x86/mktme/index.rst
 create mode 100644 Documentation/x86/mktme/mktme_configuration.rst
 create mode 100644 Documentation/x86/mktme/mktme_demo.rst
 create mode 100644 Documentation/x86/mktme/mktme_encrypt.rst
 create mode 100644 Documentation/x86/mktme/mktme_keys.rst
 create mode 100644 Documentation/x86/mktme/mktme_mitigations.rst
 create mode 100644 Documentation/x86/mktme/mktme_overview.rst
 create mode 100644 arch/x86/include/asm/mktme.h
 create mode 100644 arch/x86/mm/mem_encrypt_common.c
 create mode 100644 arch/x86/mm/mktme.c
 create mode 100644 include/keys/mktme-type.h
 create mode 100644 security/keys/mktme_keys.c

-- 
2.21.0

