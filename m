Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184564D5B44
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 07:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243129AbiCKGFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 01:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347298AbiCKGDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 01:03:54 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABE21A905C
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 22:02:11 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id bh9-20020a056a02020900b0036c0d29eb3eso4245130pgb.9
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 22:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2nOoHi6NjbjuTQS8aSeXk0qlUOIjsUXdfh7SYmb/M0g=;
        b=f/LPydLCAcr3oCfm7JZZL52CYv82tocPbn/zue3zOZ9rml9Qw33idaDfWuvHzdNIOg
         RIS7LPw/oaoIhGA1kdb65ss2M0kZDJu8x26ogOvd0983oc7YnHwhCWcrOGl3ndkGCdv7
         EHnZfwuAuVfxepeIzBS3F2Bq2xusqpd71joAxrlU9lCeEzQyjt6A3lCJ8Jlw1WkRb/ZA
         nSJbLXRoxAUctYoxRRjTV+wOqQZqUNemOFzeQp4N6lPD566NeIPZNTk7UzCjY8sntWqr
         mSNi2Wtll6aW2jX3ewSdT877BCB1VchxWfmgUJpHdRXaWF9tGIfvm9FtFlbSvY274mlK
         G3tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2nOoHi6NjbjuTQS8aSeXk0qlUOIjsUXdfh7SYmb/M0g=;
        b=FAH49oOpJtaKtSBmGY5iWbsn/8JeEiIdY4HpIKwgKx79bL2xpb46NDuhhID4kT0SQ0
         el5w3UlltzD1vvurZIogrXYV6IWUgPKbxGNQitAlh2Nj4wcxMYe2CQ/V2m4z5QXEjXw/
         76wjBn6q6QnEXBR1FgWbLJVjZoq3OtcFfFlKO+H8ma8ioUgYuuxn3bktKKmcIVzRVvmy
         M/4UHu+6pLVLWZAfI/KOIKgMOKzEu+2orpriCE+rCiQeCSeBNhOODq/Yx2edvMeV2XXr
         LQ1Wq08JoMa3YUXUp0xYy3jQ3sDt1O2pJ8SFZsLu1Q8fjO5xY/Reyare98VmsowaYkrI
         b2iw==
X-Gm-Message-State: AOAM531ZluY1+TUZ+PEtv+uBr65MzcdhXBdXGMKc6WFdzwfLGSXkhk1P
        yMpg56zPS7rzUGD2Zqmsu2ttGjvF2LqSp8BxzriseRao9v5yWTgkFsLrgiDc940W77PubBAi2pD
        ZHmz1jg7YQi+vYewprJZPPbLa+bs4vac2epm4C1Q0aM5aR8+yrugNVaqEIT3Qi/4=
X-Google-Smtp-Source: ABdhPJxS2t8wUzNs13Sbj1BYmvoToi5oHMNJ32R4vwSmgV52aS6W1eu6JS97Ic3xpD+4p2l7tczs2iXDjoXdOA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:da89:b0:153:349c:d240 with SMTP
 id j9-20020a170902da8900b00153349cd240mr1999318plx.73.1646978530438; Thu, 10
 Mar 2022 22:02:10 -0800 (PST)
Date:   Thu, 10 Mar 2022 22:01:56 -0800
Message-Id: <20220311060207.2438667-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 00/11] KVM: selftests: Add aarch64/page_fault_test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds a new aarch64 selftest for testing stage 2 fault handling for
various combinations of guest accesses (e.g., write, S1PTW), backing sources
(e.g., anon), and types of faults (e.g., read on hugetlbfs with a hole, write
on a readonly memslot). Each test tries a different combination and then checks
that the access results in the right behavior (e.g., uffd faults with the right
address and write/read flag). Some interesting combinations are:

- loading an instruction leads to a stage 1 page-table-walk that misses on
  stage 2 because the backing memslot for the page table it not in host memory
  (a hole was punched right there) and the fault is handled using userfaultfd.
  The expected behavior is that this leads to a userfaultfd fault marked as a
  write. See commit c4ad98e4b72c ("KVM: arm64: Assume write fault on S1PTW
  permission fault on instruction fetch") for why that's a write.
- a cas (compare-and-swap) on a readonly memslot leads to a failed vcpu run.
- write-faulting on a memslot that's marked for userfaultfd handling and dirty
  logging should result in a uffd fault and having the respective bit set in
  the dirty log.

The first 6 commits of this series add library support. The first one adds a
new userfaultfd library (out of demand_paging_test.c). The next 3 add some
library functions to get the GPA of a PTE, and to get the fd of a backing
source. Commit 6 fixes a leaked fd when using shared backing stores. The last 5
commits add the new selftest, one type of test at a time. It first adds core
tests, then uffd, then dirty logging, then readonly memslots tests, and finally
combinations of the previous ones (like uffd and dirty logging at the same
time).

Ricardo Koller (11):
  KVM: selftests: Add a userfaultfd library
  KVM: selftests: Add vm_mem_region_get_src_fd library function
  KVM: selftests: aarch64: Add vm_get_pte_gpa library function
  KVM: selftests: Add vm_alloc_page_table_in_memslot library function
  KVM: selftests: aarch64: Export _virt_pg_map with a pt_memslot arg
  KVM: selftests: Add missing close and munmap in __vm_mem_region_delete
  KVM: selftests: aarch64: Add aarch64/page_fault_test
  KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
  KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
  KVM: selftests: aarch64: Add readonly memslot tests into
    page_fault_test
  KVM: selftests: aarch64: Add mix of tests into page_fault_test

 tools/testing/selftests/kvm/Makefile          |    3 +-
 .../selftests/kvm/aarch64/page_fault_test.c   | 1461 +++++++++++++++++
 .../selftests/kvm/demand_paging_test.c        |  227 +--
 .../selftests/kvm/include/aarch64/processor.h |    5 +
 .../selftests/kvm/include/kvm_util_base.h     |    2 +
 .../selftests/kvm/include/userfaultfd_util.h  |   46 +
 .../selftests/kvm/lib/aarch64/processor.c     |   36 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   37 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  196 +++
 9 files changed, 1805 insertions(+), 208 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
 create mode 100644 tools/testing/selftests/kvm/include/userfaultfd_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/userfaultfd_util.c

-- 
2.35.1.723.g4982287a31-goog

