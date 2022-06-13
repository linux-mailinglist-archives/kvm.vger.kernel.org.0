Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C892254A17A
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 23:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352410AbiFMVb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 17:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353119AbiFMV3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 17:29:18 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C811FF
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 14:25:26 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id s10-20020a170902a50a00b00162359521c9so3633800plq.23
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 14:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=BdnFH6BzKbOFo4fS+klZ+MzOcoinhP5p7LWOzL4Vzwo=;
        b=C4NYruo82VP57N6JKjXb2HLUBgGIsvjU6QUitx2vEKxCQiuwajCqpxyA6ZzCgZafMm
         RUUkyzdJ1CYt8xrKrDLEBRUYQ2ieoARlrNbfRAL8/zZCUws1BLC3s4D4ScGft4Vn0Eba
         HY+7TTG4mFYmHot18GeIW5AJz2e2UnWzGkAgdN08BMLG/fI3WwbJ+IaJ0HrUutjjUufJ
         esffVoEtQXmDXTopCFqg3ETMhsjiVUVs8H04RssK7tlwMPz9XbFy/nVJyi5/tlnre5vD
         eWFjoM62scHZy2eH9NdLTryX7jts6cBEeotzAm1VvCYwXva6IBsreAhC2fEWIyRmng53
         PjZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=BdnFH6BzKbOFo4fS+klZ+MzOcoinhP5p7LWOzL4Vzwo=;
        b=IMh2GDF3qknt9S2DyF1BVHyb7NXVOd84nrJn3JKwnFwXyMtvBrRmtXJdAj7jqO6rMN
         DHYK/tCB9L4pbU5RejzD9YF1l/MN8PfF0OwOqtd83VduthQJXTqo3ItnIN10BQpE51j7
         4j025+P0XlsSj4Tjmcr1lkT1OJsM/4Vv6OrJ5BgHNqM/DNgZgu4+Y0he72tU/eljLoIk
         6dQ68ANPUXZWajXVeJMGOV8FdujxAVprAxUvNPOiL2dtATtr/r11kJMd9H1RH3veUebj
         uE2W/yH/SU904aPEz6r43C20YfNjzHO7R5YUVsoEzEyemyTAktrR4NiVQQehhyC+dWn+
         UPNw==
X-Gm-Message-State: AJIora98tqpWY/9E74IyG43bGp3j25Dp/pMbUVU6R0D7Rpp0zS1JdKjS
        CPHEkuX/bmZUOdOGn2sFIvcVYZwgEU1W73uB1Khbbe2F+BOx3pBnWnscFZSXJCFoZ+WtPc4AoYf
        ZaFPe+SyYXWd+M5K1lafdR+UZNSZ9SgKqef1zXV6YVf35iKcqKZhbwahBLY0e
X-Google-Smtp-Source: AGRyM1vs03CCYwiwt6anyDxfDrpcBlStTO74fjToQ3dw29aTVPJdY/XC7xdYuXHUXfy8hipUKF03iHdTDIc0
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:902:e5cc:b0:167:5526:ea68 with SMTP id
 u12-20020a170902e5cc00b001675526ea68mr974312plf.133.1655155526214; Mon, 13
 Jun 2022 14:25:26 -0700 (PDT)
Date:   Mon, 13 Jun 2022 21:25:13 +0000
Message-Id: <20220613212523.3436117-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v9 00/10] KVM: x86: Add a cap to disable NX hugepages on a VM
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
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
        autolearn=unavailable autolearn_force=no version=3.4.6
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

v7->v8:
	Spell out descriptors in library function names [Sean]
	Reorganize stat descriptor size calculation [Sean]
	Addded a get_stats_descriptor helper [Sean]
	Remove misleading comment about error reporting in read_stat_data() [Sean]
	Use unsigned size_t for input to pread [Sean]
	Clean up read_stat_data() [Sean]
	Add nx_huge_pages_test to .gitignore [Sean]
	Fix organization of get_vm_stat() functions. [Sean]
	Clean up #defines in NX huge pages test [Sean]
	Add flag parsing and reclaim period flag to NX test [Sean]
	Don't reduce hugepage allocation for NX test [Sean]
	Fix error check when disabling NX huge pages [Sean]
	Don't leave reboot permissions on test binary when executing as root [Sean]

v8->v9:
	Rebased on top of Sean's giant selftests refactor series

Ben Gardon (9):
  KVM: selftests: Remove dynamic memory allocation for stats header
  KVM: selftests: Read binary stats header in lib
  KVM: selftests: Read binary stats desc in lib
  KVM: selftests: Read binary stat data in lib
  KVM: selftests: Add NX huge pages test
  KVM: x86: Fix errant brace in KVM capability handling
  KVM: x86/MMU: Allow NX huge pages to be disabled on a per-vm basis
  KVM: selftests: Test disabling NX hugepages on a VM
  KVM: selftests: Cache binary stats metadata for duration of test

Sean Christopherson (1):
  KVM: selftests: Clean up coding style in binary stats test

 Documentation/virt/kvm/api.rst                |  16 ++
 arch/x86/include/asm/kvm_host.h               |   2 +
 arch/x86/kvm/mmu/mmu_internal.h               |   7 +-
 arch/x86/kvm/mmu/spte.c                       |   7 +-
 arch/x86/kvm/mmu/spte.h                       |   3 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |   2 +-
 arch/x86/kvm/x86.c                            |  32 ++-
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |  10 +
 .../selftests/kvm/include/kvm_util_base.h     |  59 ++++
 .../selftests/kvm/kvm_binary_stats_test.c     | 138 +++++----
 tools/testing/selftests/kvm/lib/kvm_util.c    | 116 ++++++++
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 269 ++++++++++++++++++
 .../kvm/x86_64/nx_huge_pages_test.sh          |  52 ++++
 15 files changed, 635 insertions(+), 80 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
 create mode 100755 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh

-- 
2.36.1.476.g0c4daa206d-goog

