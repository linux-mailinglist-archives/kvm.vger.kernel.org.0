Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72E04FFD4E
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 19:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235992AbiDMSCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 14:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237448AbiDMSCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 14:02:09 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C6735DE1
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:59:47 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id x10-20020a170902ec8a00b001585af19391so1533013plg.15
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=gBJVdHhxm3GylgacmWD4CA/ifDNVdvbWbULAPZqy7VE=;
        b=sd037rf2A4JxY/GtuAQ7UCl7/Jjdbya15GJrjwsy+a1uDXTrB8Agp7gzicl7WX2K8f
         lhdo1uHr70KKsqJpPL7YHinTiIn6o8/T9jA4RVjKrm59hZ8q9FcBO0tZARJUeMRyjiJV
         TalM6uq2LSotD+6t7cdi7Y/b2YeKLGe8xr3UbfEQpWXpOgRVyiKKcm1odgfsTX1yRuq7
         wGFlYI1xmnKCwXobpnPZOkc/RcDs8OQHeCjMpGmNiR+psCFbs3wI6o5jLQN3xN+TXYhV
         VsEl7rUutgZZlp2dRZLDDXPOzZen8er/sgG9EBc/WNbyYuWfrRKxMlgv4oTVj95bs+7U
         nfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=gBJVdHhxm3GylgacmWD4CA/ifDNVdvbWbULAPZqy7VE=;
        b=UunyUZAPvuB8Ri/2YVe1dnDBPXHLI1D7TNDZv6MA6zxygtX1vrYRdvoegh+Kbss0P9
         RiXN0RmDrvqoCv3ZyY2PxEcu/yMw3qEzCKxaCm2VX9L/48LM5RLWQisVlLalURSJ3Wx0
         pD27Rz51/fYyO4VRJa93WByHrmiMDsmOPcp4gKJg5ta7NKdC3mGGii0Tcg+i75NQDFSu
         jXnHlLprEGA9qfKSNMzipX+2u5VbCGM5uAvjBk1lrtOQUAQ6T2ip2WXDauaZs8OmRoLN
         qe1osEpCZJuTlDrH/zgL1rP47NSibXTTqltP+Z9JngyN2izWp2GDjYyVGYRG378REcE7
         8lxg==
X-Gm-Message-State: AOAM5309X60vmkRzPhi+qHY/VclgiqrJPraZZW/12xzoHYqDwCzs4YmQ
        9GVP6eA7G2bl1yDyU/gIIxek09gRKVnB
X-Google-Smtp-Source: ABdhPJyCUNMCRCkM0yKckab2XpWxWrir3hR1dwC9VSUCkx8ZnVXmj9rZdlaYHaJA/gsEl5/kVobEXd7KyAeT
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:c087:f2f2:f5f0:f73])
 (user=bgardon job=sendgmr) by 2002:a17:902:ec86:b0:156:a032:7cf1 with SMTP id
 x6-20020a170902ec8600b00156a0327cf1mr43256946plg.40.1649872787285; Wed, 13
 Apr 2022 10:59:47 -0700 (PDT)
Date:   Wed, 13 Apr 2022 10:59:34 -0700
Message-Id: <20220413175944.71705-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 00/10] KVM: x86: Add a cap to disable NX hugepages on a VM
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
v2->v3:
	Incorporated a suggestion from David on how to build the NX huge pages
	test.
	Fixed a build breakage identified by David.
	Dropped the per-vm nx_huge_pages field in favor of simply checking the
	global + per-VM disable override.
	Documented the new capability
	Separated out the commit to test disabling NX huge pages
	Removed permission check when checking if the disable NX capability is
	supported.
	Added test coverage for the permission check.
v3->v4:
	Collected RB's from Jing and David
	Modified stat collection to reduce a memory allocation [David]
	Incorporated various improvments to the NX test [David]
	Changed the NX disable test to run by default [David]
	Removed some now unnecessary commits
	Dropped the code to dump KVM stats from the binary stats test, and
	factor out parts of the existing test to library functions instead.
	[David, Jing, Sean]
	Dropped the improvement to a debugging log message as it's no longer
	relevant to this series.
v4->v5:
	Incorporated cleanup suggestions from David and Sean
	Added a patch with style fixes for the binary stats test from Sean
	Added a restriction that NX huge pages can only be disabled before
	vCPUs are created [Sean]

Ben Gardon (9):
  KVM: selftests: Remove dynamic memory allocation for stats header
  KVM: selftests: Read binary stats header in lib
  KVM: selftests: Read binary stats desc in lib
  KVM: selftests: Read binary stat data in lib
  KVM: selftests: Add NX huge pages test
  KVM: x86: Fix errant brace in KVM capability handling
  KVM: x86/MMU: Allow NX huge pages to be disabled on a per-vm basis
  KVM: selftests: Factor out calculation of pages needed for a VM
  KVM: selftests: Test disabling NX hugepages on a VM

Sean Christopherson (1):
  KVM: selftests: Clean up coding style in binary stats test

 Documentation/virt/kvm/api.rst                |  13 +
 arch/x86/include/asm/kvm_host.h               |   2 +
 arch/x86/kvm/mmu.h                            |   9 +-
 arch/x86/kvm/mmu/spte.c                       |   7 +-
 arch/x86/kvm/mmu/spte.h                       |   3 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |   3 +-
 arch/x86/kvm/x86.c                            |  25 +-
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/Makefile          |  10 +
 .../selftests/kvm/include/kvm_util_base.h     |  13 +
 .../selftests/kvm/kvm_binary_stats_test.c     | 142 ++++++-----
 tools/testing/selftests/kvm/lib/kvm_util.c    | 232 ++++++++++++++++--
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 206 ++++++++++++++++
 .../kvm/x86_64/nx_huge_pages_test.sh          |  25 ++
 14 files changed, 597 insertions(+), 94 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
 create mode 100755 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh

-- 
2.35.1.1178.g4f1659d476-goog

