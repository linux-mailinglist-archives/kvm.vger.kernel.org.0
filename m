Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6B869C64D
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 09:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjBTIK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 03:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjBTIKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 03:10:55 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C15812077;
        Mon, 20 Feb 2023 00:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676880652; x=1708416652;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=sQjAeJdABGevNSdtiYdVvOb7oEelsfTpHEbM8x/oakU=;
  b=HZW3KNEge0Jw+kmbLkZUiLjskUZfXQVnkZBcmaNvNPM8X5JDDqes+Pm7
   KQR4sBElQqKBoct2vsZfTn0UcfGI+oralc15XMdV/O7CMYqspmGYSCOT4
   w30NCVamlcJX10Y6lSkGZFDTRWlvHDHWAhVP8yAoPdBwpzmzP9KDtq4eA
   BjXznadDVEKVZs/nYeTV7IkxrV0g8Aodp1IX4KH3xSjLcz3AjNe2MjYdy
   U5M16YpDOgaJoY8g/DFOeOYjfTYy6htH6+4ZhHCW2IKSNLKnXJEHhm8Kl
   8gVJgvRToU7nEoH6nd82h6dCYcjQxhZ5IyLfeUi0jYRvEjpaunnf4Y799
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10626"; a="394829845"
X-IronPort-AV: E=Sophos;i="5.97,311,1669104000"; 
   d="scan'208";a="394829845"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 00:10:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10626"; a="845246987"
X-IronPort-AV: E=Sophos;i="5.97,311,1669104000"; 
   d="scan'208";a="845246987"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga005.jf.intel.com with ESMTP; 20 Feb 2023 00:10:25 -0800
Date:   Mon, 20 Feb 2023 16:10:24 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sagi Shahar <sagis@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Peter Shier <pshier@google.com>,
        Anish Ghulati <aghulati@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Babu Moger <babu.moger@amd.com>, Chao Gao <chao.gao@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Guang Zeng <guang.zeng@intel.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Jing Liu <jing2.liu@intel.com>,
        Junaid Shahid <junaids@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Leonardo Bras <leobras@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Li RongQing <lirongqing@baidu.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Michal Luczaj <mhal@rbox.co>,
        Mingwei Zhang <mizhang@google.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Paul Durrant <pdurrant@amazon.com>,
        Peng Hao <flyingpenghao@gmail.com>,
        Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
        Robert Hoo <robert.hu@linux.intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vipin Sharma <vipinsh@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Documentation/process: Add a maintainer handbook for
 KVM x86
Message-ID: <20230220081024.pdldxveqpbgkcuei@yy-desk-7060>
References: <20230217225449.811957-1-seanjc@google.com>
 <20230217225449.811957-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230217225449.811957-3-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,GUARANTEED_100_PERCENT,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 17, 2023 at 02:54:49PM -0800, Sean Christopherson wrote:
> Add a KVM x86 doc to the subsystem/maintainer handbook section to explain
> how KVM x86 (currently) operates as a sub-subsystem, and to soapbox on
> the rules and expectations for contributing to KVM x86.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../process/maintainer-handbooks.rst          |   1 +
>  Documentation/process/maintainer-kvm-x86.rst  | 347 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  3 files changed, 349 insertions(+)
>  create mode 100644 Documentation/process/maintainer-kvm-x86.rst
>
> diff --git a/Documentation/process/maintainer-handbooks.rst b/Documentation/process/maintainer-handbooks.rst
> index d783060b4cc6..d12cbbe2b7df 100644
> --- a/Documentation/process/maintainer-handbooks.rst
> +++ b/Documentation/process/maintainer-handbooks.rst
> @@ -17,3 +17,4 @@ Contents:
>
>     maintainer-tip
>     maintainer-netdev
> +   maintainer-kvm-x86
> diff --git a/Documentation/process/maintainer-kvm-x86.rst b/Documentation/process/maintainer-kvm-x86.rst
> new file mode 100644
> index 000000000000..ac81a42a32a3
> --- /dev/null
> +++ b/Documentation/process/maintainer-kvm-x86.rst
> @@ -0,0 +1,347 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +KVM x86
> +=======
> +
> +TL;DR
> +-----
> +Testing is mandatory.  Be consistent with established styles and patterns.
> +
> +Trees
> +-----
> +KVM x86 is currently in a transition period from being part of the main KVM
> +tree, to being "just another KVM arch".  As such, KVM x86 is split across the
> +main KVM tree, ``git.kernel.org/pub/scm/virt/kvm/kvm.git``, and a KVM x86
> +specific tree, ``github.com/kvm-x86/linux.git``.
> +
> +Generally speaking, fixes for the current cycle are applied directly to the
> +main KVM tree, while all development for the next cycle is routed through the
> +KVM x86 tree.
> +
> +Note, this transition period is expected to last quite some time, i.e. will be
> +the status quo for the foreseeable future.
> +
> +Branches
> +~~~~~~~~
> +The KVM x86 tree is organized into multiple topic branches.  The purpose of
> +using finer-grained topic branches is to make it easier to keep tabs on an area
> +of development, and to limit the collateral damage of human errors and/or buggy
> +commits, e.g. dropping the HEAD commit of a topic branch has no impact on other
> +in-flight commits' SHA1 hashes, and having to reject a pull request due to bugs
> +delays only that topic branch.
> +
> +All topic branches, except for ``next`` and ``fixes``, are rolled into ``next``
> +via a cthulu merge on an as-needed basis, i.e. when a topic branch is updated.
> +As a result, force pushes to ``next`` are common.
> +
> +Lifecycle
> +~~~~~~~~~
> +Pull requests for the next release cycle are sent to the main KVM tree, one
> +for each KVM x86 topic branch.  If all goes well, the topic branches are rolled
> +into the main KVM pull request sent during Linus' merge window.  Pull requests
> +for KVM x86 branches are typically made the week before Linus' opening of the
> +merge window, e.g. the week following rc7 for "normal" releases.
> +
> +The KVM x86 tree doesn't have its own official merge window, but there's a soft
> +close around rc5 for new features, and a soft close around rc6 for fixes.
> +
> +Timeline
> +~~~~~~~~
> +Submissions are typically reviewed and applied in FIFO order, with some wiggle
> +room for the size of a series, patches that are "cache hot", etc.  Fixes,
> +especially for the current release and or stable trees, get to jump the queue.
> +Patches that will be taken through a non-KVM tree (most often through the tip
> +tree) and/or have other acks/reviews also jump the queue to some extent.
> +
> +Note, the vast majority of review is done between rc1 and rc6, give or take.
> +The period between rc6 and the next rc1 is used to catch up on other tasks,
> +i.e. radio silence during this period isn't unusual.
> +
> +Pings to get a status update are welcome, but keep in mind the timing of the
> +current release cycle and have realistic expectations.  If you are pinging for
> +acceptance, i.e. not just for feedback or an update, please do everything you
> +can, within reason, to ensure that your patches are ready to be merged!  Pings
> +on series that break the build or fail tests lead to unhappy maintainers!
> +
> +Development
> +-----------
> +
> +Base Tree/Branch
> +~~~~~~~~~~~~~~~~
> +Fixes that target mainline, i.e. the current release, should be based on
> +``git://git.kernel.org/pub/scm/virt/kvm/kvm.git master``.
> +
> +Everything else should be based on a kvm-x86 topic branch.  If there is no
> +obvious fit, use ``misc``.  Unless a patch/series depends on and/or conflicts
> +with multiple topic branches, do not use ``next`` as a base.  Because ``next``
> +is force-pushed on a regular basis, depending on when others fetch ``next``,
> +they may or may not have the relevant objects in their local git tree.
> +
> +Coding Style
> +~~~~~~~~~~~~
> +When it comes to style, naming, patterns, etc., consistency is the number one
> +priority in KVM x86.  If all else fails, match what already exists.
> +
> +With a few caveats listed below, follow the tip tree maintainers' preferred
> +:ref:`maintainer-tip-coding-style`, as patches/series often touch both KVM and
> +non-KVM x86 files, i.e. draw the attention of KVM *and* tip tree maintainers.
> +
> +Using reverse fir tree for variable declarations isn't strictly required,
> +though it is still preferred.
> +
> +Except for a handful of special snowflakes, do not use kernel-doc comments for
> +functions.  The vast majority of "public" KVM functions aren't truly public as
> +they are intended only for KVM-internal consumption (there are plans to
> +privatize KVM's headers and exports to enforce this).
> +
> +Comments
> +~~~~~~~~
> +Write comments using imperative mood and avoid pronouns.  Use comments to
> +provide a high level overview of the code, and/or to explain why the code does
> +what it does.  Do not reiterate what the code literally does; let the code
> +speak for itself.  If the code itself is inscrutable, comments will not help.
> +
> +SDM and APM References
> +~~~~~~~~~~~~~~~~~~~~~~
> +Much of KVM's code base is directly tied to architectural behavior defined in
> +Intel's Software Development Manual (SDM) and AMD's Architecture Programmer’s
> +Manual (APM).  Use of "Intel's SDM" and "AMD's APM", or even just "SDM" or
> +"APM", without additional context is a-ok.
> +
> +Do not reference specific sections, tables, figures, etc. by number, especially
> +not in comments.  Instead, copy-paste the relevant snippet (if warranted), and
> +reference sections/tables/figures by name.  The layouts of the SDM and APM are
> +constantly changing, and so the numbers/labels aren't stable/consistent.
> +
> +Generally speaking, do not copy-paste SDM or APM snippets into comments.  With
> +few exceptions, KVM *must* honor architectural behavior, therefore it's implied
> +that KVM behavior is emulating SDM and/or APM behavior.
> +
> +Shortlog
> +~~~~~~~~
> +The preferred prefix format is ``KVM: <topic>:``, where ``<topic>`` is one of::
> +
> +  - x86
> +  - x86/mmu
> +  - x86/pmu
> +  - x86/xen
> +  - selftests
> +  - SVM
> +  - nSVM
> +  - VMX
> +  - nVMX
> +
> +**DO NOT use x86/kvm!**  ``x86/kvm`` is used exclusively for Linux-as-a-KVM-guest
> +changes, i.e. for arch/x86/kernel/kvm.c.
> +
> +Note, these don't align with the topics branches (the topic branches care much
> +more about code conflicts).
> +
> +All names are case sensitive!  ``KVM: x86:`` is good, ``kvm: vmx:`` is not.
> +
> +Capitalize the first word of the condensed patch description, but omit ending
> +punctionation.  E.g.::
> +
> +    KVM: x86: Fix a null pointer dererence in function_xyz()
> +
> +not::
> +
> +    kvm: x86: fix a null pointer dererence in function_xyz.
> +
> +If a patch touches multiple topics, traverse up the conceptual tree to find the
> +first common parent (which is often simply ``x86``).  When in doubt,
> +``git log path/to/file`` should provide a reasonable hint.
> +
> +New topics do occasionally pop up, but please start an on-list discussion if
> +you want to propose introducing a new topic, i.e. don't go rogue.
> +
> +Do not use file names or complete file paths as the subject/shortlog prefix.
> +
> +Changelog
> +~~~~~~~~~
> +Write changelogs using imperative mood and avoid pronouns.  Lead with a short
> +blurb on what is changing, and then follow up with the context and background.
> +Note!  This order directly conflicts with the tip tree's preferred approach!
> +
> +Beyond personal preference, there are less subjective reasons for stating what
> +a patch does before diving into details.  First and foremost, what code is
> +actually being changed is the most important information, and so that info
> +should be easy to find.  Changelogs that bury the "what's actually changing" in
> +a one-liner after 3+ paragraphs of background make it very hard to find that
> +information.
> +
> +For initial review, one could argue the "what's broken" is more important, but
> +for skimming logs and git archaeology, the gory details matter less and less.
> +E.g. when doing a series of "git blame", the details of each change along the
> +way are useless, the details only matter for the culprit.  Providing the "what
> +changed" makes it easy to quickly determine whether or not a commit might be of
> +interest.
> +
> +Another benefit of stating "what's changing" first is that it's almost always
> +possible to state "what's changing" in a single sentence.  Conversely, all but
> +the most simple bugs require multiple sentences or paragraphs to fully describe
> +the problem.  If both the "what's changing" and "what's the bug" are super
> +short then the order doesn't matter.  But if one is shorter (almost always the
> +"what's changing), then covering the shorter one first is advantageous because
> +it's less of an inconvenience for readers/reviewers that have a strict ordering
> +preference.  E.g. having to skip one sentence to get to the context is less
> +painful than having to skip three paragraphs to get to "what's changing".
> +
> +Fixes
> +~~~~~
> +If a change fixes a KVM/kernel bug, add a Fixes: tag even if the change doesn't
> +need to be backported to stable kernels, and even if the change fixes a bug in
> +an older release.
> +
> +Conversely, if a fix does need to be backported, explicitly tag the patch with
> +"Cc: stable@vger.kernel" (though the email itself doesn't need to Cc: stable);
> +KVM x86 opts out of backporting Fixes: by default.  Some auto-selected patches
> +do get backported, but require explicit maintainer approval (search MANUALSEL).
> +
> +Function References
> +~~~~~~~~~~~~~~~~~~~
> +When a function is mentioned in a comment, changelog, or shortlog (or anywhere
> +for that matter), use the format ``function_name()``.  The parentheses provide
> +context and disambiguate the reference.
> +
> +Testing
> +-------
> +At a bare minimum, *all* patches in a series must build cleanly for KVM_INTEL=m
> +KVM_AMD=m, and KVM_WERROR=y.  Building every possible combination of Kconfigs
> +isn't feasible, but the more the merrier.  KVM_SMM, KVM_XEN, PROVE_LOCKING, and
> +X86_64 are particularly interesting knobs to turn.
> +
> +Running KVM selftests and KVM-unit-tests is also mandatory (and stating the
> +obvious, the tests need to pass).  When possible and relevant, testing on both
> +Intel and AMD is strongly preferred.  Booting an actual VM is encouraged, but
> +not mandatory.
> +
> +For changes that touch KVM's shadow paging code, running with TDP (EPT/NPT)
> +disabled is mandatory.  For changes that affect common KVM MMU code, running
> +with TDP disabled is strongly encouraged.  For all other changes, if the code
> +being modified depends on and/or interacts with a module param, testing with
> +the relevant settings is mandatory.
> +
> +Note, KVM selftests and KVM-unit-tests do have known failures.  If you suspect
> +a failure is not due to your changes, verify that the *exact same* failure
> +occurs with and without your changes.
> +
> +If you can't fully test a change, e.g. due to lack of hardware, clearly state
> +what level of testing you were able to do, e.g. in the cover letter.
> +
> +New Features
> +~~~~~~~~~~~~
> +With one exception, new features *must* come with test coverage.  KVM specific
> +tests aren't strictly required, e.g. if coverage is provided by running a
> +sufficiently enabled guest VM, or by running a related kernel selftest in a VM,
> +but dedicated KVM tests are preferred in all cases.  Negative testcases in
> +particular are mandatory for enabling of new hardware features as error and
> +exception flows are rarely exercised simply by running a VM.
> +
> +The only exception to this rule is if KVM is simply advertising support for a
> +feature via KVM_SET_SUPPORTED_CPUID, i.e. for instructions/features that KVM
                   ^^^^^^^^^^^^
Should be KVM_GET_SUPPORTED_CPUID.

It's GOOD documentation to me!

> +can't prevent a guest from using and for which there is no true enabling.
> +
> +Note, "new features" does not just mean "new hardware features"!  New features
> +that can't be well validated using existing KVM selftests and/or KVM-unit-tests
> +must come with tests.
> +
> +Posting new feature development without tests to get early feedback is more
> +than welcome, but such submissions should be tagged RFC, and the cover letter
> +should clearly state what type of feedback is requested/expected.  Do not abuse
> +the RFC process; RFCs will typically not receive in-depth review.
> +
> +Bug Fixes
> +~~~~~~~~~
> +Except for "obvious" found-by-inspection bugs, fixes must be accompanied by a
> +reproducer for the bug being fixed.  In many cases the reproducer is implicit,
> +e.g. for build errors and test failures, but it should still be clear to
> +readers what is broken and how to verify the fix.  Some leeway is given for
> +bugs that are found via non-public workloads/tests, but providing regression
> +tests for such bugs is strongly preferred.
> +
> +In general, regression tests are preferred for any bug that is not trivial to
> +hit.  E.g. even if the bug was originally found by a fuzzer such as syzkaller,
> +a targeted regression test may be warranted if the bug requires hitting a
> +one-in-a-million type race condition.
> +
> +Note, KVM bugs are rarely urgent *and* non-trivial to reproduce.  Ask yourself
> +if a bug is really truly the end of the world before posting a fix without a
> +reproducer.
> +
> +Posting
> +-------
> +
> +Links
> +~~~~~
> +Do not explicitly reference bug reports, prior versions of a patch/series, etc.
> +via ``In-Reply-To:`` headers.  Using ``In-Reply-To:`` becomes an unholy mess
> +for large series and/or when the version count gets high, and ``In-Reply-To:``
> +is useless for anyone that doesn't have the original message, e.g. if someone
> +wasn't Cc'd on the bug report or if the list of recipients changes between
> +versions.
> +
> +To link to a bug report, previous version, or anything of interest, use lore
> +links.  For referencing previous version(s), generally speaking do not include
> +a Link: in the changelog as there is no need to record the history in git, i.e.
> +put the link in the cover letter or in the section git ignores.  Do provide a
> +formal Link: for bug reports and/or discussions that led to the patch.  The
> +context of why a change was made is highly valuable for future readers.
> +
> +Git Base
> +~~~~~~~~
> +If you are using git version 2.9.0 or later (Googlers, this is all of you!),
> +use ``git format-patch`` with the ``--base`` flag to automatically include the
> +base tree information in the generated patches.
> +
> +Note, ``--base=auto`` works as expected if and only if a branch's upstream is
> +set to the base topic branch, e.g. it will do the wrong thing if your upstream
> +is set to your personal repository for backup purposes.  An alternative "auto"
> +solution is to derive the names of your development branches based on their
> +KVM x86 topic, and feed that into ``--base``.  E.g. ``x86/pmu/my_branch_name``,
> +and then write a small wrapper to extract ``pmu`` from the current branch name
> +to yield ``--base=x/pmu``, where ``x`` is whatever name your repository uses to
> +track the KVM x86 remote.
> +
> +Co-Posting Tests
> +~~~~~~~~~~~~~~~~
> +KVM selftests that are associated with KVM changes, e.g. regression tests for
> +bug fixes, should be posted along with the KVM changes as a single series.
> +
> +KVM-unit-tests should *always* be posted separately.  Tools, e.g. b4 am, don't
> +know that KVM-unit-tests is a separate repository and get confused when patches
> +in a series apply on different trees.  To tie KVM-unit-tests patches back to
> +KVM patches, first post the KVM changes and then provide a lore Link: to the
> +KVM patch/series in the KVM-unit-tests patch(es).
> +
> +Notifications
> +-------------
> +When a patch/series is officially accepted, a notification email will be sent
> +in reply to the original posting (cover letter for multi-patch series).  The
> +notification will include the tree and topic branch, along with the SHA1s of
> +the commits of applied patches.
> +
> +If a subset of patches is applied, this will be clearly stated in the
> +notification.  Unless stated otherwise, it's implied that any patches in the
> +series that were not accepted need more work and should be submitted in a new
> +version.
> +
> +If for some reason a patch is dropped after officially being accepted, a reply
> +will be sent to the notification email explaining why the patch was dropped, as
> +well as the next steps.
> +
> +SHA1 Stability
> +~~~~~~~~~~~~~~
> +SHA1s are not 100% guaranteed to be stable until they land in Linus' tree!  A
> +SHA1 is *usually* stable once a notification has been sent, but things happen.
> +In most cases, an update to the notification email be provided if an applied
> +patch's SHA1 changes.  However, in some scenarios, e.g. if all KVM x86 branches
> +need to be rebased, individual notifications will not be given.
> +
> +Vulnerabilities
> +---------------
> +Bugs that can be exploited by the guest to attack the host (kernel or
> +userspace), or that can be exploited by a nested VM to *its* host (L2 attacking
> +L1), are of particular interest to KVM.  Please follow the protocol for
> +:ref:`securitybugs` if you suspect a bug can lead to an escape, data leak, etc.
> +
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6a47510d1592..13e67a8b4827 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11436,6 +11436,7 @@ M:	Sean Christopherson <seanjc@google.com>
>  M:	Paolo Bonzini <pbonzini@redhat.com>
>  L:	kvm@vger.kernel.org
>  S:	Supported
> +P:	Documentation/process/maintainer-kvm-x86.rst
>  T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
>  F:	arch/x86/include/asm/kvm*
>  F:	arch/x86/include/asm/svm.h
> --
> 2.39.2.637.g21b0678d19-goog
>
