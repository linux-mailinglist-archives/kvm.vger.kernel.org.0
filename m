Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20CED508E7D
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 19:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381129AbiDTRiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 13:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239686AbiDTRiD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 13:38:03 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35031BF78
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:35:17 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id z132-20020a63338a000000b003844e317066so1362021pgz.19
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=tU5Q7AkrYRkb/Zz2lPFDi8k7QtsqyIwswpbby7oV6Iw=;
        b=AquOJoyB2fnkjHD6l/OfOFQOR360AjjZZ/PfrEdvVu88ycHUXtWCVzXLlE2VHg+Kqc
         ZFFKLXaloES0yYy02F1YG2fhY0kSX8RDJzn0ZeXJLSkLwb3+mjCiYVslaQk/g3YiVOX3
         E1MoDbIxCA4Kh6gOnx1vxkLzPiufuvExDg9mr/8MRhPzqUg5Lt1qDQq5hj1HXuhFNfB3
         01eKcBTRNnUimOyQiV6JlBoZUhjJcgVOIEwuEWXghf+2utrmLJ9iRJzSGQD5K4zEsDMg
         0WBDCYoKkZzJriv/49acSi9DbKwIgsCD5qUz6M2vgOoH137ySiMQ5eH9FmKd+3M5zvne
         X1nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=tU5Q7AkrYRkb/Zz2lPFDi8k7QtsqyIwswpbby7oV6Iw=;
        b=JW1+d1bHz37clgImDRBzNadpLbOpGBH2tYtcN/1OpKfVWGP0F1F7JwGwpetpV7BRtq
         Y4OfwiXOMhGxog8mHaq7a33P96IbPfsFOPuD5UzG+b9V2VO5kARe7yYxvYF2oM3ZACYm
         rdrfEdqFEauDeifRbyFVKECzxNg/UYKZ5ugNYCVk5ComfgvbSb8KKsnQzaoq3ivJ8WGY
         tfG38kpDECM6M/XHXzFFkAw/hFhDV1fOOEQCGIJpZncEjkmCgRithzbdj7nj1gYl7gcK
         4hJkFrCcPtIl+0D3M2xTghaM9KDB3uuWl6DaT3HRJL/ltFVGBLODNUPMGngwX8toUC5+
         gFOg==
X-Gm-Message-State: AOAM530/kv12scFh70fpxNFhRi7M/Mzm2U/gaUh/1HMVBlXbmIbLtx12
        ZKpQ0phF0ujFqJ3XYa/oOcyEQ6IMtE6Y
X-Google-Smtp-Source: ABdhPJz+OMnkdiTtcqZmdSPNIRuOO1Dleu8nq+GBJsZhB1GkN3juXnyvUJ7I1PR8pJQaUzYMjRVAqdym5f6p
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6ea6:489a:aad6:761c])
 (user=bgardon job=sendgmr) by 2002:a17:902:d0cb:b0:158:7c60:2297 with SMTP id
 n11-20020a170902d0cb00b001587c602297mr21509537pln.145.1650476116665; Wed, 20
 Apr 2022 10:35:16 -0700 (PDT)
Date:   Wed, 20 Apr 2022 10:35:03 -0700
Message-Id: <20220420173513.1217360-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v6 00/10] KVM: x86: Add a cap to disable NX hugepages on a VM
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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

v5->v6:
	Scooped up David's RBs
	Added a magic token to skip nx_huge_pages_test when not run via
	wrapper script [Sean]
	Made the call to nx_huge_pages_test in the wrapper script more
	robust [Sean]
	Incorportated various nits and comment / documentation suggestions from
	Sean.
	Improved negative testing of NX disable without reboot permissions. [Sean]

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

 Documentation/virt/kvm/api.rst                |  17 ++
 arch/x86/include/asm/kvm_host.h               |   2 +
 arch/x86/kvm/mmu.h                            |   8 +-
 arch/x86/kvm/mmu/spte.c                       |   7 +-
 arch/x86/kvm/mmu/spte.h                       |   3 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |   2 +-
 arch/x86/kvm/x86.c                            |  31 ++-
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/Makefile          |  10 +
 .../selftests/kvm/include/kvm_util_base.h     |  13 +
 .../selftests/kvm/kvm_binary_stats_test.c     | 142 +++++-----
 tools/testing/selftests/kvm/lib/kvm_util.c    | 248 ++++++++++++++++--
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 224 ++++++++++++++++
 .../kvm/x86_64/nx_huge_pages_test.sh          |  38 +++
 14 files changed, 652 insertions(+), 94 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
 create mode 100755 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh

-- 
2.36.0.rc0.470.gd361397f0d-goog

