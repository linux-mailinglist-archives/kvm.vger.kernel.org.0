Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474564E34F4
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 00:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbiCUXuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 19:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbiCUXue (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 19:50:34 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720CD1890D2
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 16:48:52 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id h12-20020a63530c000000b0037c8f45bf1bso7916074pgb.7
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 16:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=+YgbvkkZm51JaV0SRfX6aMNQ49mjL4BnSXqIV4X04TI=;
        b=JEsyu2p4UrM4kdyFX8ELj2HBqWsLGkUlCdK1mQpR48w0KFTiqn3IQrFZiDsmRe53dO
         q+RLZ8rRK+706kUMUPA27q51x859mpxgZW7ZNjIWjII+IcGETPYR9fIUC4908mPsHcWN
         P6i/m4jZ5+gM0PzdESSfxFfgKSh/NYrPr3mWLt658axPdZu0EPZb07btYxILomMU30z9
         tZGptvmO/tCSN9OSk9NFXMShsm4jzHT4vPClV59WQ8ecrIYmtbx2DaLDxCRnHFtsmSSB
         IqEYNFXeFbxxpj258R+Sqn6cZhPm6M6UWh/Tg4a80ZTd4ArYmOpEY/Qx3BTm7EIpoX/5
         KD+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=+YgbvkkZm51JaV0SRfX6aMNQ49mjL4BnSXqIV4X04TI=;
        b=rJ02wrh/nFI1Hs/vqYCcOP+fN8wcaVGFITOynKyU2VeVlPgVlpOoPTuohSsDb+zdZx
         GtN9YitI9ixkCe2cTpazk8IccQRw16vjR5FuNw/cjXXD7e49+BzXgmTgLt3eZzO795kO
         T35ETgJRZbHH8ZnXyUQozQiSixJZHm9mJZAva0hVWZ5qK/buAAmzo5Nu7qvV49auaK/7
         EJKYDRbwfxnwzRV79LC7R6GgOQz4dOfVSwp7joiltmGUxFknpQUjy9cVgeVkaLCtf1FB
         B9F/C7Y4DL/QB4Q6Ei+lNy2ohS9G59r2Ao2JZNy+OmzZeZJB3xY9AGgqeExZ0luDlNuS
         3VTw==
X-Gm-Message-State: AOAM533btVmkNORkfxDbMNVja4ntrSgx48JQJJ6IkFO0x+LOsgOJZWAR
        ydaWTB1VfLwPpXhO+okabLf//XWz3wgq
X-Google-Smtp-Source: ABdhPJy5vW2ib87DOG/MIKm2vPI8btmyDLD7ahy4eJgfzjwSHviAxOjNJptPyVTiiKUXZpc/7YFtKI4Jbvtn
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b76a:f152:cb5e:5cd2])
 (user=bgardon job=sendgmr) by 2002:a17:90a:8a05:b0:1c6:e527:c613 with SMTP id
 w5-20020a17090a8a0500b001c6e527c613mr1669303pjn.143.1647906530831; Mon, 21
 Mar 2022 16:48:50 -0700 (PDT)
Date:   Mon, 21 Mar 2022 16:48:33 -0700
Message-Id: <20220321234844.1543161-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 00/11] KVM: x86: Add a cap to disable NX hugepages on a VM
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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

Given the high cost of NX hugepages in terms of TLB performance, it may
be desirable to disable the mitigation on a per-VM basis. In the case of public
cloud providers with many VMs on a single host, some VMs may be more trusted
than others. In order to maximize performance on critical VMs, while still
providing some protection to the host from iTLB Multihit, allow the mitigation
to be selectively disabled.

Disabling NX hugepages on a VM is relatively straightforward, but I took this
as an opportunity to add some NX hugepages test coverage and clean up selftests
infrastructure a bit.

This series was tested with the new selftest and the rest of the KVM selftests
on an Intel Haswell machine.

The following tests failed, but I do not believe that has anything to do with
this series:
	userspace_io_test
	vmx_nested_tsc_scaling_test
	vmx_preemption_timer_test

Changelog:
v1->v2:
	Dropped the complicated memslot refactor in favor of Ricardo Koller's
	patch with a similar effect.
	Incorporated David Dunn's feedback and reviewed by tag: shortened waits
	to speed up test.

Ben Gardon (10):
  KVM: selftests: Dump VM stats in binary stats test
  KVM: selftests: Test reading a single stat
  KVM: selftests: Add memslot parameter to elf_load
  KVM: selftests: Improve error message in vm_phy_pages_alloc
  KVM: selftests: Add NX huge pages test
  KVM: x86/MMU: Factor out updating NX hugepages state for a VM
  KVM: x86/MMU: Track NX hugepages on a per-VM basis
  KVM: x86/MMU: Allow NX huge pages to be disabled on a per-vm basis
  KVM: x86: Fix errant brace in KVM capability handling
  KVM: x86/MMU: Require reboot permission to disable NX hugepages

Ricardo Koller (1):
  KVM: selftests: Add vm_alloc_page_table_in_memslot library function

 arch/x86/include/asm/kvm_host.h               |   3 +
 arch/x86/kvm/mmu.h                            |   9 +-
 arch/x86/kvm/mmu/mmu.c                        |  23 +-
 arch/x86/kvm/mmu/spte.c                       |   7 +-
 arch/x86/kvm/mmu/spte.h                       |   3 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |   3 +-
 arch/x86/kvm/x86.c                            |  24 +-
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/include/kvm_util_base.h     |  10 +
 .../selftests/kvm/kvm_binary_stats_test.c     |   6 +
 tools/testing/selftests/kvm/lib/elf.c         |  13 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 230 +++++++++++++++++-
 .../kvm/lib/x86_64/nx_huge_pages_guest.S      |  45 ++++
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 160 ++++++++++++
 .../kvm/x86_64/nx_huge_pages_test.sh          |  25 ++
 16 files changed, 538 insertions(+), 27 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/nx_huge_pages_guest.S
 create mode 100644 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
 create mode 100755 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh

-- 
2.35.1.894.gb6a874cedc-goog

