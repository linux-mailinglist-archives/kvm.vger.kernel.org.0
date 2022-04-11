Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13D44FC68C
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 23:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350151AbiDKVRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 17:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbiDKVRf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 17:17:35 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8CC1580B
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:15:20 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2db2add4516so181008027b3.1
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BK+a2hyolOZzz96GWzJLTVp92WPHUi38p0fzqvqUHN4=;
        b=PswKfha9pFPt+kcJK344DtAAoNOhl+xIJ0mO3pQcSfLHCz3nZ8T9PhbWPLUyTx6YkF
         pKERuzPrBpHBwoZJEcataq7Je1K8gDU/YiN/sIe1127tQmOhIW+u7TvmImH9Cg8XAlvZ
         bigp/kZrtiX/j6bXJ/ISLwfTgmpLhPM9/U+Zk01xQ5G8IbBYaESPOhyrieLSUyg0lKou
         WL6Vh2MTND6sZMdXRUyann4AWjg99ZjUbAFm8NtcfxpknuYmocoAqeaeOBWlq75exghv
         EI/auZTmQr1iCwcDBzpMYH9swCYNIENGJObbo7OOV+e/r+xTgsLnLgv3utzFX0pKRtFm
         +Vog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BK+a2hyolOZzz96GWzJLTVp92WPHUi38p0fzqvqUHN4=;
        b=eYBxGpjR+bcwqF6dZTd+IuU68Zk6zkk+7rYYDlT70CIEPVyQPFh+kRW1KI0bV/Ad1Z
         bnFnXE8aoTX2Gd5kb7MaN8YPY3B+9qkJs7J5PUCa9ynXnb80ONAKF3qpsBhPhtiN4jns
         oBiJWqzBHG7SSAmT4wqUwoeSEdPvjwFMT+OZPGaLHBf3bidwA7smYSkkMf0e6ci9wCl5
         MD5grJdlATxdTvYMO05SHuOO4uuJXrHhwb4WK3b2Bha2gdbFMnVBsXlbwE7+ap4qVNFw
         C9zHvYfEeE/VYamz/FfnV7Q299PO4OLxGs8b6I9DNHv0y+CkyoMTD2FeRiyA8CYY0UYb
         65KA==
X-Gm-Message-State: AOAM532WIoy8SizbtV/I9j17cQ44QBsQ9f3BePpj3pxw8dswhsqk1XbZ
        d2DYAA6tRVfnEnWK9MPQJrz4wlxBUviPD3CtXhm22w==
X-Google-Smtp-Source: ABdhPJxxXRNQKSgMIYSybPhYvdP69jmtkDnormm07sSVPDeKxidzDFoexRAtf6OL93weZRoLgGVS7xkrb+Zynf/FvXs=
X-Received: by 2002:a81:1957:0:b0:2ec:91:c9da with SMTP id 84-20020a811957000000b002ec0091c9damr8755733ywz.254.1649711719549;
 Mon, 11 Apr 2022 14:15:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220411211015.3091615-1-bgardon@google.com>
In-Reply-To: <20220411211015.3091615-1-bgardon@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 11 Apr 2022 14:15:08 -0700
Message-ID: <CANgfPd-4xVGyMrPHmgobjSVAY7_p5Kp1dPRggPoCsHxAPh8EVA@mail.gmail.com>
Subject: Re: [PATCH v4 00/10] KVM: x86: Add a cap to disable NX hugepages on a VM
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 11, 2022 at 2:10 PM Ben Gardon <bgardon@google.com> wrote:
>
> Given the high cost of NX hugepages in terms of TLB performance, it may
> be desirable to disable the mitigation on a per-VM basis. In the case of public
> cloud providers with many VMs on a single host, some VMs may be more trusted
> than others. In order to maximize performance on critical VMs, while still
> providing some protection to the host from iTLB Multihit, allow the mitigation
> to be selectively disabled.
>
> Disabling NX hugepages on a VM is relatively straightforward, but I took this
> as an opportunity to add some NX hugepages test coverage and clean up selftests
> infrastructure a bit.
>
> This series was tested with the new selftest and the rest of the KVM selftests
> on an Intel Haswell machine.
>
> The following tests failed, but I do not believe that has anything to do with
> this series:
>         userspace_io_test
>         vmx_nested_tsc_scaling_test
>         vmx_preemption_timer_test
>
> Changelog:
> v1->v2:
>         Dropped the complicated memslot refactor in favor of Ricardo Koller's
>         patch with a similar effect.
>         Incorporated David Dunn's feedback and reviewed by tag: shortened waits
>         to speed up test.
> v2->v3:
>         Incorporated a suggestion from David on how to build the NX huge pages
>         test.
>         Fixed a build breakage identified by David.
>         Dropped the per-vm nx_huge_pages field in favor of simply checking the
>         global + per-VM disable override.
>         Documented the new capability
>         Separated out the commit to test disabling NX huge pages
>         Removed permission check when checking if the disable NX capability is
>         supported.
>         Added test coverage for the permission check.
> v3->v4:
>         Collected RB's from Jing and David
>         Modified stat collection to reduce a memory allocation [David]
>         Incorporated various improvments to the NX test [David]
>         Changed the NX disable test to run by default [David]
>         Removed some now unnecessary commits
>         Dropped the code to dump KVM stats from the binary stats test, and
>         factor out parts of the existing test to library functions instead.
>         [David, Jing, Sean]
>         Dropped the improvement to a debugging log message as it's no longer
>         relevant to this series.
>
> Ben Gardon (10):
>   KVM: selftests: Remove dynamic memory allocation for stats header
>   KVM: selftests: Read binary stats header in lib
>   KVM: selftests: Read binary stats desc in lib
>   KVM: selftests: Read binary stat data in lib
>   KVM: selftests: Add NX huge pages test
>   KVM: x86/MMU: Factor out updating NX hugepages state for a VM
>   KVM: x86/MMU: Allow NX huge pages to be disabled on a per-vm basis
>   KVM: x86: Fix errant brace in KVM capability handling
>   KVM: x86/MMU: Require reboot permission to disable NX hugepages
>   KVM: selftests: Test disabling NX hugepages on a VM

Paolo, I'm hoping we can get patches 1-5 in relatively quickly, and I
don't mind merging them first and then iterating on the later commits.
David Matlack and Mingwei Zhang both have series depending on those
test commits, so getting them finalized will help move all three of
our series along.

David, Mingwei, Sean, when you have time, I'd appreciate your reviews
on the first five patches in this series.

>
>  Documentation/virt/kvm/api.rst                |  13 ++
>  arch/x86/include/asm/kvm_host.h               |   2 +
>  arch/x86/kvm/mmu.h                            |  10 +-
>  arch/x86/kvm/mmu/mmu.c                        |  17 +-
>  arch/x86/kvm/mmu/spte.c                       |   7 +-
>  arch/x86/kvm/mmu/spte.h                       |   3 +-
>  arch/x86/kvm/mmu/tdp_mmu.c                    |   3 +-
>  arch/x86/kvm/x86.c                            |  17 +-
>  include/uapi/linux/kvm.h                      |   1 +
>  tools/testing/selftests/kvm/Makefile          |  10 +
>  .../selftests/kvm/include/kvm_util_base.h     |  11 +
>  .../selftests/kvm/kvm_binary_stats_test.c     |  75 +++----
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 125 ++++++++++-
>  .../selftests/kvm/x86_64/nx_huge_pages_test.c | 198 ++++++++++++++++++
>  .../kvm/x86_64/nx_huge_pages_test.sh          |  25 +++
>  15 files changed, 453 insertions(+), 64 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
>  create mode 100755 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
>
> --
> 2.35.1.1178.g4f1659d476-goog
>
