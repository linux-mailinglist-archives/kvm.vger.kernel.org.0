Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A3C518C56
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 20:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235501AbiECSe1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 14:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241376AbiECSeX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 14:34:23 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1EA3F315
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 11:30:49 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id j8-20020aa78d08000000b0050ade744b37so9797120pfe.16
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 11:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=D/b4lmpRV1S4oq77zyZLQ2hr9b7x70TzpN91Y4dw1/o=;
        b=Y+EEi8961TGB6nwmrqnfcn6/9luwRSHrafK/WssjZWrEiHFgeIK4J3IpKOjYCgzVTI
         4PcP2XL0neruyqzq8G4FIUx7JY2fh4EbQzHUEUmFT/6ITTJxwm/yYdlzeTaDYMDdGbyI
         RbGdAlbGZD1DZh2ZnoWXR4T9QEDnbQQWV8ZDknY6La9xAmmCWX/b8dFqimLe/MbKRlVF
         wr+8AEVLV0613KS5XzCfmCjcnHOSXXpnYGoSARVC1FPLW07ijevaJxSO+QBHwj8b7ruU
         QtQDOiN+ZTPjO8R/177zYpZMDjvuj6MWXujsGg3050rpaV3OyeRbr3vDNUZrHNB/hG0t
         2x6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=D/b4lmpRV1S4oq77zyZLQ2hr9b7x70TzpN91Y4dw1/o=;
        b=SY+rcT5XJGzv7H1yCuSfKPhRV6QYJLCB/V05c/yPXsFy3ZYj1M1NOOPHPVPOIzt/lL
         ZunktsZ/5+9eV+2oOSj5cQMzU90Ge8s0ZsCqgjNFOGo8UqScFjbhncP2ZcTvXDQK06F/
         jwfbwxU5Q9dl8QWooQIdd+C3lY/VsywbAXwsk2Xbira5REeYJtSPEZWEvRWp5/1AbtOk
         yDrscu8PRTmZLAb//G5teZ+vAtK4m+bn/HfvBzLpb4uoma8KV6V+eg75mKBATflKgTJO
         l+PEKeTlxYaoJiNG8AOOSNHEqbdkCy0WbUAtise4RVJy7OLf5Vbhdj4KTP6qvuuNwFA4
         A1Ug==
X-Gm-Message-State: AOAM530dTvyAZ64tGfzp8uCHUNsUbZ2ljvebwTc4GUJMLj1z3n8Fvd81
        ZISp9YjjjpZHzbhNn1jqDTEsTvKGgGTS
X-Google-Smtp-Source: ABdhPJwK9diAS9QQDrYi4VIkhuWWuos+YheFi4FTQhhWZtc53Uo8yOtdb91nwtZcJk6M5+5PsI76ObJ1jUGU
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:902:a613:b0:156:b53d:c137 with SMTP id
 u19-20020a170902a61300b00156b53dc137mr17778009plq.73.1651602648787; Tue, 03
 May 2022 11:30:48 -0700 (PDT)
Date:   Tue,  3 May 2022 18:30:34 +0000
Message-Id: <20220503183045.978509-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v7 00/11] KVM: x86: Add a cap to disable NX hugepages on a VM
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

v6->v7:
	Collected Peter Xu's Reviewed-by tags
	Added stats metadata caching to kvm_util
	Misc NX test fixups

Ben Gardon (10):
  KVM: selftests: Remove dynamic memory allocation for stats header
  KVM: selftests: Read binary stats header in lib
  KVM: selftests: Read binary stats desc in lib
  KVM: selftests: Read binary stat data in lib
  KVM: selftests: Add NX huge pages test
  KVM: x86: Fix errant brace in KVM capability handling
  KVM: x86/MMU: Allow NX huge pages to be disabled on a per-vm basis
  KVM: selftests: Factor out calculation of pages needed for a VM
  KVM: selftests: Test disabling NX hugepages on a VM
  KVM: selftests: Cache binary stats metadata for duration of test

Sean Christopherson (1):
  KVM: selftests: Clean up coding style in binary stats test

 Documentation/virt/kvm/api.rst                |  17 ++
 arch/x86/include/asm/kvm_host.h               |   2 +
 arch/x86/kvm/mmu.h                            |   8 +-
 arch/x86/kvm/mmu/spte.c                       |   7 +-
 arch/x86/kvm/mmu/spte.h                       |   3 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |   2 +-
 arch/x86/kvm/x86.c                            |  32 ++-
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/Makefile          |  10 +
 .../selftests/kvm/include/kvm_util_base.h     |  13 +
 .../selftests/kvm/kvm_binary_stats_test.c     | 142 +++++-----
 tools/testing/selftests/kvm/lib/kvm_util.c    | 262 ++++++++++++++++--
 .../selftests/kvm/lib/kvm_util_internal.h     |   5 +
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 222 +++++++++++++++
 .../kvm/x86_64/nx_huge_pages_test.sh          |  46 +++
 15 files changed, 678 insertions(+), 94 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
 create mode 100755 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh

-- 
2.36.0.464.gb9c8b46e94-goog

