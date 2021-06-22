Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6598A3B0E18
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 22:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbhFVUH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 16:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbhFVUH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 16:07:57 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B3CC061756
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:05:40 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id es19-20020a0562141933b029023930e98a57so281230qvb.18
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=4xDEyrn3HHz6L+fu48+GfShlH/vZQ/A+7NZnpXhmIWM=;
        b=m1f5GmwfDb5ryD/M4M2TiJRLL83bnKsKSkt9wkSMqMvTygR8MIWg9fS26MWtuQd8/d
         mmpOZLroAA2jPbnWL/yt+I7UEMfDDu9fpTS/CpRBuqq8Dp1dFgrRkZxsiD/FfPVR/nEN
         Cy8feg76ML7ECaqpMBmqygFu6NPfl4SM6R35zGJyjEKqRMkRTJWmRAZMBomeUd6QgeXb
         LizCXATz6zSJKAIEDwNRYGqiejqh+rw0akVXqyOFIuHMx9u5Saiw0Ditw+97+Sb2ggYo
         fWsO3n2CLr41MeSXTFiWHvyIp+IJ15WYY2dOz8UrlwimWW8N1N/CpcnbEQS00N3r2Ed2
         0Nlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=4xDEyrn3HHz6L+fu48+GfShlH/vZQ/A+7NZnpXhmIWM=;
        b=byi9LHRUR9YkY64ng27RGz4kh3KQwCQgkgTDMz25eBpk4ftiDD4W+L5iRDLaaN++VQ
         AVOMb+pAAYHp2iI5gV6X9OWM2VvR6IDAj+vcYmVIn0qFO9rl7JJvIaHzLLqxI7jlnIC+
         SQ70aeAtHVAV1bCT4b1PzcZv9Y3HDROOSfQaFMOSx9CWv/pEksxEFvkzQz8VxnWff3jE
         baNSH1cKbhZ6eOw3knkFJLhkfvjc2fe1UrKUnsSHyls3Q3YSy+dwQUlLKghoQnSDleVR
         Uj75CyB9/t72AjFxubG4LX8rwTop9VWWgkDm5sHPjWIZFQIJUZiYz/sDzPSn5ulThCf1
         o46Q==
X-Gm-Message-State: AOAM530vGfAaaFUkjoL8XT6Txwo4RQj/WXQm/1YQtZyFoHSDJZijeTCw
        aE1BNJbUwlbS+XjIWksC4WHdThaPWEQ=
X-Google-Smtp-Source: ABdhPJyTRuHyH5vGbURHHXwScZzWSDK/hcRzUE+vE7jAVENjHb7S2mNzag8RNVFo45F7PU7LLaYgHHSilTI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a25:33d7:: with SMTP id z206mr6983498ybz.33.1624392339468;
 Tue, 22 Jun 2021 13:05:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 13:05:10 -0700
Message-Id: <20210622200529.3650424-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 00/19] KVM: selftests: Add x86 mmu_role test and cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The primary intent of this series is to allow x86-64 tests to create
arbitrary hugepages and use the new functionality to abuse x86's CPUID
APIs to test KVM MMU behavior.

The majority of the prep work refactors the selftests APIs related to
memory allocation.  The core memory allocation APIs within the selftests
don't provide defaults for memslot or min virtual address, which has led
to a ridiculous amount of magic and duplicate code.  Literally zero tests
use non-standard values in a meaningful way, and if a test comes along
that has a legitimate use case, it should use lower-level helpers.

Patches 01 and 02 are fixes for bugs found during the refactoring.

As for the mmu_role test itself, the idea is to change the vCPU model
while the guest is running (via KVM_SET_CPUID2) to verify that KVM
reconfigures its MMUs when the vCPU model is changed.  E.g. toggling
guest support for 1gb hugepages and changing guest MAXPHYADDR.

Sadly, the test doesn't pass when KVM is using TDP paging (even with all
my mmu_role fixes) because KVM doesn't fully support manipulating GBPAGES
and MAXPHYADDR (and other CPUID-based properties that affect the MMU)
while the guest is running.  And practically speaking, KVM will never
fully support such behavior becuase (a) there is likely no sane use case,
(b) fixing the issues is very costly (memory consumption), (c) GBPAGES
and potentially other features _can't_ be handled correctly due to lack
of hardware support, and (d) userspace can workaround all issues simply
by deleting a memslot.

All that said, I purposely made the test off-by-default instead of
requiring TDP.  Partly because detecting whether TDP is enabled is a pain
becuase it's per-vendor, but also because running the test with TDP
enabled is still interesting to some extent, e.g. the test will fail, but
it shouldn't crash KVM, trigger WARNs, etc...

Sean Christopherson (19):
  KVM: selftests: Remove errant asm/barrier.h include to fix arm64 build
  KVM: selftests: Zero out the correct page in the Hyper-V features test
  KVM: selftests: Unconditionally use memslot 0 when loading elf binary
  KVM: selftests: Unconditionally use memslot 0 for x86's GDT/TSS setup
  KVM: selftests: Use "standard" min virtual address for Hyper-V pages
  KVM: selftests: Add helpers to allocate N pages of virtual memory
  KVM: selftests: Lower the min virtual address for misc page
    allocations
  KVM: selftests: Use alloc_page helper for x86-64's GDT/ITD/TSS
    allocations
  KVM: selftests: Use alloc page helper for xAPIC IPI test
  KVM: selftests: Use "standard" min virtual address for CPUID test
    alloc
  KVM: selftest: Unconditionally use memslot 0 for vaddr allocations
  KVM: selftests: Unconditionally use memslot '0' for page table
    allocations
  KVM: selftests: Unconditionally allocate EPT tables in memslot 0
  KVM: selftests: Add wrapper to allocate page table page
  KVM: selftests: Rename x86's page table "address" to "pfn"
  KVM: selfests: Add PTE helper for x86-64 in preparation for hugepages
  KVM: selftests: Genericize upper level page table entry struct
  KVM: selftests: Add hugepage support for x86-64
  KVM: sefltests: Add x86-64 test to verify MMU reacts to CPUID updates

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 tools/testing/selftests/kvm/dirty_log_test.c  |   5 +-
 .../selftests/kvm/hardware_disable_test.c     |   2 +-
 .../testing/selftests/kvm/include/kvm_util.h  |  18 +-
 .../selftests/kvm/include/x86_64/processor.h  |  11 +
 .../selftests/kvm/include/x86_64/vmx.h        |  10 +-
 .../selftests/kvm/kvm_page_table_test.c       |   2 +-
 .../selftests/kvm/lib/aarch64/processor.c     |  34 +--
 .../testing/selftests/kvm/lib/aarch64/ucall.c |   2 +-
 tools/testing/selftests/kvm/lib/elf.c         |   6 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  62 ++++-
 .../selftests/kvm/lib/perf_test_util.c        |   2 +-
 .../selftests/kvm/lib/s390x/processor.c       |  17 +-
 .../selftests/kvm/lib/x86_64/processor.c      | 254 ++++++++----------
 tools/testing/selftests/kvm/lib/x86_64/svm.c  |   9 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  52 ++--
 .../testing/selftests/kvm/memslot_perf_test.c |   2 +-
 .../selftests/kvm/set_memory_region_test.c    |   2 +-
 tools/testing/selftests/kvm/steal_time.c      |   2 +-
 .../selftests/kvm/x86_64/get_cpuid_test.c     |   3 +-
 .../selftests/kvm/x86_64/hyperv_clock.c       |   2 +-
 .../selftests/kvm/x86_64/hyperv_features.c    |   8 +-
 .../selftests/kvm/x86_64/mmu_role_test.c      | 147 ++++++++++
 .../selftests/kvm/x86_64/set_boot_cpu_id.c    |   2 +-
 .../kvm/x86_64/vmx_apic_access_test.c         |   2 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c |   8 +-
 .../selftests/kvm/x86_64/xapic_ipi_test.c     |   4 +-
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |   2 +-
 .../selftests/kvm/x86_64/xen_vmcall_test.c    |   2 +-
 30 files changed, 414 insertions(+), 260 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/mmu_role_test.c

-- 
2.32.0.288.g62a8d224e6-goog

