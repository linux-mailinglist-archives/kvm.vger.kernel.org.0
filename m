Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F564F9EA5
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 23:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239670AbiDHVIB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 17:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239669AbiDHVH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 17:07:57 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A3613C70C
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 14:05:52 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id z132-20020a63338a000000b003844e317066so5339905pgz.19
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 14:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=S51j5oo3opJvsRJNXI1+hkL5LxbcnR2OyLq+qXnMqiY=;
        b=anWu23sq3AlcbJM+bTrIjG/wtoRFd3im82SYu+mFMpJO9qZuudYLBDNN7pinnQ0PSM
         N70BfaXZ7yjraCCJFd3QJHbK39N9+lmHR6ezQmQ1F4Riv33qjWe6OHKqLLAWZw3oMHKH
         s9WGoYCmw40XXp3mJebllnw05X6UnAxaxnwWp1yPYcREpvz1KMzCw8LAT2VOxfhGeCN9
         PY6vNazZ+C8SM7L+ti/3Od7XldQy/EuDkvYk+DIwmiQO/2vQMxGDW30RR7icLRa9D/5M
         L8n7bIJsu/fNBVucA9SQDP/t38M1riWt89Z6R0ZKrRESJyh84SJciIYTc+axtElSX5EW
         eDBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=S51j5oo3opJvsRJNXI1+hkL5LxbcnR2OyLq+qXnMqiY=;
        b=68nEhxJZmYinw3+ebDq9rlhAiE8oJzRZVkRKC24XSEPg5+FnNwVyRftXxCpknKq8eR
         4sX7UzNrYoxMdowMSiZqZsIN8ycBMHIsRFaRHJpEGtjW1FJGYjZE1SI6fFYH3USQtIOQ
         RhF2n/CiBDaS3iyYJspcIJzTomNNARr9BqupazbtG2vfcFClR7uobwyoVMTiYcouh6Ki
         eYf3y71ROmQNkAXO+XA0y83iuTb/jZLvEWdzD0f9rdwxo2+4RJeZZIfbwwxfIAqGaL3r
         kvrAWS55rzNcwjC3wS68HSUybUVROZTv+yt1CIo9+XBaeuUV9nAPqnYa4XvlcC0Agtbl
         mb9A==
X-Gm-Message-State: AOAM530vKmXcexwFNWFlayWLl9oCrHnxMxDwD/FMrcuHE4wZKqrZV/rO
        8GdQxvTs4qNfPul/Au96IYU0S/vthMDNxQhQ
X-Google-Smtp-Source: ABdhPJwBI62+i1Cn7AwOjIj/QaMxxnX07OYtWyneOi+VOeF3IfJ16nT4vhAOtlvrCVnJcwMsb1ROmtAAUBhAthta
X-Received: from vannapurve2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:41f8])
 (user=vannapurve job=sendgmr) by 2002:a17:902:e889:b0:157:dd6:4621 with SMTP
 id w9-20020a170902e88900b001570dd64621mr9269146plg.17.1649451952012; Fri, 08
 Apr 2022 14:05:52 -0700 (PDT)
Date:   Fri,  8 Apr 2022 21:05:40 +0000
Message-Id: <20220408210545.3915712-1-vannapurve@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [RFC V1 PATCH 0/5] selftests: KVM: selftests for fd-based approach of
 supporting private memory
From:   Vishal Annapurve <vannapurve@google.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, shauh@kernel.org, yang.zhong@intel.com,
        drjones@redhat.com, ricarkol@google.com, aaronlewis@google.com,
        wei.w.wang@intel.com, kirill.shutemov@linux.intel.com,
        corbet@lwn.net, hughd@google.com, jlayton@kernel.org,
        bfields@fieldses.org, akpm@linux-foundation.org,
        chao.p.peng@linux.intel.com, yu.c.zhang@linux.intel.com,
        jun.nakajima@intel.com, dave.hansen@intel.com,
        michael.roth@amd.com, qperret@google.com, steven.price@arm.com,
        ak@linux.intel.com, david@redhat.com, luto@kernel.org,
        vbabka@suse.cz, marcorr@google.com, erdemaktas@google.com,
        pgonda@google.com, seanjc@google.com, diviness@google.com,
        Vishal Annapurve <vannapurve@google.com>
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

This series implements selftests targeting the feature floated by Chao
via:
https://lore.kernel.org/linux-mm/20220310140911.50924-1-chao.p.peng@linux.intel.com/

Below changes aim to test the fd based approach for guest private memory
in context of normal (non-confidential) VMs executing on non-confidential
platforms.

Confidential platforms along with the confidentiality aware software
stack support a notion of private/shared accesses from the confidential
VMs.
Generally, a bit in the GPA conveys the shared/private-ness of the
access. Non-confidential platforms don't have a notion of private or
shared accesses from the guest VMs. To support this notion,
KVM_HC_MAP_GPA_RANGE
is modified to allow marking an access from a VM within a GPA range as
always shared or private. Any suggestions regarding implementing this ioctl
alternatively/cleanly are appreciated.

priv_memfd_test.c file adds a suite of two basic selftests to access private
memory from the guest via private/shared access and checking if the contents
can be leaked to/accessed by vmm via shared memory view.

Test results:
1) PMPAT - PrivateMemoryPrivateAccess test passes
2) PMSAT - PrivateMemorySharedAccess test fails currently and needs more
analysis to understand the reason of failure.

Important - Below patch is needed to ensure host kernel crash is avoided while
running these tests:
https://github.com/vishals4gh/linux/commit/b9adedf777ad84af39042e9c19899600a4add68a

Github link for the patches posted as part of this series:
https://github.com/vishals4gh/linux/commits/priv_memfd_selftests_v1
Note that this series is dependent on Chao's v5 patches mentioned above
applied on top of 5.17.

Vishal Annapurve (5):
  x86: kvm: HACK: Allow testing of priv memfd approach
  selftests: kvm: Fix inline assembly for hypercall
  selftests: kvm: Add a basic selftest test priv memfd
  selftests: kvm: priv_memfd_test: Add support for memory conversion
  selftests: kvm: priv_memfd_test: Add shared access test

 arch/x86/include/uapi/asm/kvm_para.h          |   1 +
 arch/x86/kvm/mmu/mmu.c                        |   9 +-
 arch/x86/kvm/x86.c                            |  16 +-
 include/linux/kvm_host.h                      |   3 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/lib/x86_64/processor.c      |   2 +-
 tools/testing/selftests/kvm/priv_memfd_test.c | 410 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |   2 +-
 8 files changed, 436 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/priv_memfd_test.c

-- 
2.35.1.1178.g4f1659d476-goog

