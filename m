Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0314E5B77
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 23:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbiCWWzl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 18:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiCWWzk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 18:55:40 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB44887A8
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:54:10 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id y4-20020a623204000000b004fad845e9bdso1637979pfy.23
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=KKW1/KO/KoM4PtUUxqCzptnpYmhmZGLDr0xVnYILraY=;
        b=IdFLGLKLY8qNT/p7FGx+35du5zw9U/0pX9eKVxHvcxYuslZuqj41h/F0kGx1w0G50u
         7Qb3YH9QIAs2TQ2uUnKwzjB16pjnMqu1QEn7oqYgzoEkoBms9XFZAO0tr3nDY0kRBRJw
         IjUtXASDbrfJNywu0SZQHk4aBT/QHKGuwkwBwQ5KuhsbKeko7yAgQwJTEiSG3ZCV/ecp
         S6rdGOhy/wfVOQrQPlqNtve6n5eMdnaS+826195i/QZIq7UQFA5seYzVfEoHLTMi4Rup
         JuWBOai8jtLJSiIZm++MUHT4PKGWToXoWOpI6PNhbuVkuC93AWzNpGg1CZuY6YlKOcDz
         /6yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=KKW1/KO/KoM4PtUUxqCzptnpYmhmZGLDr0xVnYILraY=;
        b=L8Dwj3rbMRKwb2VQWWJBxKvWs6YsJA/BhyXUecK3RFzy4VHATdofAWIx9CRAWLelVq
         ZkNS3cpjYXI0Z4Fx1orqYT9AUy5SxYJEP7UTDBlv9dChLvpR95dxB6svCAlr3kVzLZuL
         x/H7xnBE+u59qTDpPPoK4dtSBk89AeTF6WpSD68CJcnSPaQdqbWVeEHiaTg++IAHFMOG
         stYYaLbnUZbxGI5vTqvbc/NhnAiSzIHLCNH8klaO6t3k0GV/EbwJz/5Zgq6vGbuPLa7e
         4btyDEfz4NHJSAX8L4cV2JmODjbS+9iV3rviQTPXZmFoJsIKxhiVRbEWm2zgtJXg3mfG
         uDsw==
X-Gm-Message-State: AOAM530JviyC6MqqQ35vdBq5GeodrDYlx4EN8IkRHJ4WxGrAcvUnWqNr
        RWfXRalV4/PB7E3u5likNAvmMMkl0EdWEMsDMedfd4Lb6SfLDx18EKWMmTg2vwVHL6VP6g+9tdQ
        7IrgJzxRtMSYc541ytt3Q9WJziKxGSWLK9SXiypSK/pI5pPJ+w9zRvjCtndEj7/M=
X-Google-Smtp-Source: ABdhPJw0puhfZM7YFERrVtz+tjl4IY23os+HiHwDbvyJbBsLATrJtxRy9PtAqa8RE6V1i7F9y0VAMpujlQEoTA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:2311:b0:4e1:52bf:e466 with SMTP
 id h17-20020a056a00231100b004e152bfe466mr2180170pfh.77.1648076049708; Wed, 23
 Mar 2022 15:54:09 -0700 (PDT)
Date:   Wed, 23 Mar 2022 15:53:54 -0700
Message-Id: <20220323225405.267155-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 00/11] KVM: selftests: Add aarch64/page_fault_test
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

v1 -> v2:
- collect r-b from Ben for the memslot lib commit. [Ben]
- move userfaultfd desc struct to header. [Ben]
- move commit "KVM: selftests: Add vm_mem_region_get_src_fd library function"
  to right before it's used. [Ben]
- nit: wrong indentation in patch 6. [Ben]

Ricardo Koller (11):
  KVM: selftests: Add a userfaultfd library
  KVM: selftests: aarch64: Add vm_get_pte_gpa library function
  KVM: selftests: Add vm_alloc_page_table_in_memslot library function
  KVM: selftests: aarch64: Export _virt_pg_map with a pt_memslot arg
  KVM: selftests: Add missing close and munmap in __vm_mem_region_delete
  KVM: selftests: Add vm_mem_region_get_src_fd library function
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
 .../selftests/kvm/include/userfaultfd_util.h  |   47 +
 .../selftests/kvm/lib/aarch64/processor.c     |   36 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   37 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  187 +++
 9 files changed, 1797 insertions(+), 208 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
 create mode 100644 tools/testing/selftests/kvm/include/userfaultfd_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/userfaultfd_util.c

-- 
2.35.1.894.gb6a874cedc-goog

