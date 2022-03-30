Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C65E4ECB0B
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 19:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349502AbiC3Rsn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 13:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349563AbiC3RsS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 13:48:18 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E2365145
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 10:46:27 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id j15-20020a17090a2a8f00b001c6d6b729f1so269165pjd.3
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 10:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=hRv+qXpwbo9GDUQrNblrZBkEF97GEZj0/UovDKEp30U=;
        b=gYvZMVtn+uyKeAuQc9rljJ9GaNc7GJUanzPaTkRriCyCFnZeKCpd5LeX+aYKxjE3S2
         byy/8NGYfdV/cKYP9JjJiOWqzJcBzc2L8vj3q5zru32E2GerfOOc2lutLUfTCmwZYTUX
         g92ZLJlXR2PmpILDlapvOHt7pBHUUhro4q0N7/+vT4P3ZGLrIdDmhbpICjg2Ulmo4soV
         pZAi42PA9aLxRb4rdyYhMqoLc5ObsRk2fAkJNq1PhcevHB2aSOEst6G7Om+dP/kC67n2
         a1fb/aHdP8FRVsoJGPbt2fQd7fr2fpVZoqgJ9n71hFzHUTtuTne1/hYSjNjKrPzkuoMx
         sxOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=hRv+qXpwbo9GDUQrNblrZBkEF97GEZj0/UovDKEp30U=;
        b=JiEHD/1OKLREg8ta/OUjrhAmZSyyCjG2sOiX6ELA7jkkJLCMBQHEpJaOpHOyJ8oTZS
         lCUcdnDcenoWFsBxibroiQWdlfrDFGPSLA97UjWkQKMWRzWoVu/AIJEco1PDtdShDJFP
         SI67j6h/MNu6hGzZS6+LiEqfn4N8Vxrb+3dlkEhfYI43qclDZyvsqYykF9WMEIpRsvbz
         wXBLCD7on+OORoBwIUJrzBJCc5prXxZs1LzbzODrrPx+lRoaYWUJyGqzgWvdlYAL6iAi
         MBPJ0fY0oSjfAENxi00jNZvTbIV+8GSvmR03eGFeZXOflBe6iljLPIbSLDdOC5ijIU/c
         0qGg==
X-Gm-Message-State: AOAM530nTcTK1vzirjuMGzBea/KrbYq/2JNrdxj9Z2eNyb/MTsVyDmvO
        yl3b0yPQluqAXxS4upTODHGzS9PQpncm
X-Google-Smtp-Source: ABdhPJwFFN2Fih8nQRZaaitKq/M8PEtVl1+kP0BThFDW4TEcwATS0gRn4LpwgHuR4FzxSOiJaqF5KXTrsQCy
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:7c53:ec2f:bd26:b69c])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:1256:b0:4fb:1374:2f65 with SMTP
 id u22-20020a056a00125600b004fb13742f65mr677102pfi.72.1648662386632; Wed, 30
 Mar 2022 10:46:26 -0700 (PDT)
Date:   Wed, 30 Mar 2022 10:46:10 -0700
Message-Id: <20220330174621.1567317-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v3 00/11] KVM: x86: Add a cap to disable NX hugepages on a VM
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

Ben Gardon (10):
  KVM: selftests: Dump VM stats in binary stats test
  KVM: selftests: Test reading a single stat
  KVM: selftests: Add memslot parameter to elf_load
  KVM: selftests: Improve error message in vm_phy_pages_alloc
  KVM: selftests: Add NX huge pages test
  KVM: x86/MMU: Factor out updating NX hugepages state for a VM
  KVM: x86/MMU: Allow NX huge pages to be disabled on a per-vm basis
  KVM: x86: Fix errant brace in KVM capability handling
  KVM: x86/MMU: Require reboot permission to disable NX hugepages
  selftests: KVM: Test disabling NX hugepages on a VM

Ricardo Koller (1):
  KVM: selftests: Add vm_alloc_page_table_in_memslot library function

 Documentation/virt/kvm/api.rst                |  13 +
 arch/x86/include/asm/kvm_host.h               |   2 +
 arch/x86/kvm/mmu.h                            |  10 +-
 arch/x86/kvm/mmu/mmu.c                        |  17 +-
 arch/x86/kvm/mmu/spte.c                       |   7 +-
 arch/x86/kvm/mmu/spte.h                       |   3 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |   3 +-
 arch/x86/kvm/x86.c                            |  17 +-
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/Makefile          |   7 +-
 .../selftests/kvm/include/kvm_util_base.h     |  10 +
 .../selftests/kvm/kvm_binary_stats_test.c     |   6 +
 tools/testing/selftests/kvm/lib/elf.c         |  13 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 230 +++++++++++++++++-
 .../kvm/lib/x86_64/nx_huge_pages_guest.S      |  45 ++++
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 178 ++++++++++++++
 .../kvm/x86_64/nx_huge_pages_test.sh          |  25 ++
 17 files changed, 561 insertions(+), 26 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/nx_huge_pages_guest.S
 create mode 100644 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
 create mode 100755 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh

-- 
2.35.1.1021.g381101b075-goog

