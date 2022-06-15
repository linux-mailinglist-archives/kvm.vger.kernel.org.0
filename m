Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C436054D540
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344042AbiFOX3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbiFOX3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:29:52 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993A813E3F
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:29:51 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id ob5-20020a17090b390500b001e2f03294a7so111549pjb.8
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=IpRHRC1m/nfVpFclf0C9MrqrO+VlgUhAW9qPS5MuHGY=;
        b=UXwvtJrl58O24fn2gm5JgHIWpnhSgGVrfKptZAy24BOMKf4CZyok7jCC9HCnyWCDMR
         ALZ7/vvis0xr8pNTl+IbDPHpzDQ/IvQWJbcpFYd5zbpLKY0pMt4f+IyFmkl2coG9Wxjc
         5xh5aQIFfXETwq+FYBHd+wXhw6oVkuGEgeNf1D+L19k2nYx+TVI3UZyltxodfLAlOikU
         KnEb9PWcLCqtPBWK7qbGOfAjZNx8+guMW1WXiAoheTpOq3Hki9j0yMDjX+Ig/z/Gb/uY
         2+OPm6QP8iNQzRZPzJgGQMwVKzsHk7uMdB6W66no9oaxM7d4gZjJhgC7KqDoqJ3twQbc
         dP7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=IpRHRC1m/nfVpFclf0C9MrqrO+VlgUhAW9qPS5MuHGY=;
        b=0vYjAFSH49SoLNcWlwVg0C4Idm2Hof/ypsXI3LcvWid6FhN5jg57ICeLiJtjFC+txF
         rAbJ14IaTcL4F+XOVLOotK1p0GxYG7WyRsmi0/6Mkxo6kSw1j7zPFMhguFP97vgvqEtG
         cL3KMaiTySgexEuxMY7Wout6zaXmIozwRrVWyRHHXoic+B647/4UD/oHiXarly2E68f6
         tIFSDR2ebUPAYXc5HxgamXbKslNjaN8kXYMhD7nJWkwV8/rbwbZHvF0sN1Euxcdijm1f
         zOX2mjpv6Iuen3yRFWY/EEe7K3QRsf3PcsKiSKiegEQXlCae5/PMqDu9DOjinJRkYzx1
         EdTQ==
X-Gm-Message-State: AJIora9ElzXm0q4pAuXp+M7Bf4j12lsZqxbPnbDtuxvT8WZjL0cXGcKo
        4OpsNd7OCdoRHLzvemDdlbvSzvYjdVw=
X-Google-Smtp-Source: AGRyM1swrc7drVMIncN+c4veuXF8fOC6rDbDycDtcETNnPL51Ttli9b1xrDKJwBqdHx3y/ITXUKq8Zxf5MQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:a113:0:b0:51c:1b4c:38d1 with SMTP id
 b19-20020a62a113000000b0051c1b4c38d1mr1846514pff.13.1655335791125; Wed, 15
 Jun 2022 16:29:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 15 Jun 2022 23:29:30 +0000
Message-Id: <20220615232943.1465490-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [kvm-unit-tests PATCH v4 00/13] x86: SMP Support for x86 UEFI Tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Orr <marcorr@google.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>, Thomas.Lendacky@amd.com,
        Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@alien8.de>
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

This is Varad's series to bring multi-vcpu support to UEFI tests on x86,
with some relatively minor massaging by me.  The only change I made that
I suspect might be controversial is squashing start16.S and start32.S into
a single trampolines.S.

Most of the necessary AP bringup code already exists within kvm-unit-tests'
cstart64.S, and has now been either rewritten in C or moved to a common location
to be shared between EFI and non-EFI test builds.

A call gate is used to transition from 16-bit to 32-bit mode, since EFI may
not load the 32-bit entrypoint low enough to be reachable from the SIPI vector.

v4:
 - Add an explict magic string in dummy.c for probing.
 - Reduce #ifdefs via macros
 - Consolidate final "AP online" code.
 - Misc tweaks, e.g. to adhere to preferred style.

v3:
 - Unbreak i386 build, ingest seanjc's reviews from v2.a
 - https://lore.kernel.org/all/20220426114352.1262-1-varad.gautam@suse.com

v2: https://lore.kernel.org/kvm/20220412173407.13637-1-varad.gautam@suse.com/

Sean Christopherson (3):
  x86: Use an explicit magic string to detect that dummy.efi passes
  x86: Rename ap_init() to bringup_aps()
  x86: Add ap_online() to consolidate final "AP is alive!" code

Varad Gautam (10):
  x86: Share realmode trampoline between i386 and x86_64
  x86: Move ap_init() to smp.c
  x86: Move load_idt() to desc.c
  x86: desc: Split IDT entry setup into a generic helper
  x86: Move load_gdt_tss() to desc.c
  x86: efi: Provide a stack within testcase memory
  x86: efi: Provide percpu storage
  x86: Move 32-bit => 64-bit transition code to trampolines.S
  x86: efi, smp: Transition APs from 16-bit to 32-bit mode
  x86: Provide a common 64-bit AP entrypoint for EFI and non-EFI

 lib/alloc_page.h          |   3 +
 lib/x86/apic.c            |   2 -
 lib/x86/asm/setup.h       |   3 +
 lib/x86/desc.c            |  38 ++++++++--
 lib/x86/desc.h            |   4 +
 lib/x86/setup.c           |  82 +++++++++++++++++----
 lib/x86/smp.c             | 150 +++++++++++++++++++++++++++++++++++++-
 lib/x86/smp.h             |  11 +++
 scripts/runtime.bash      |   2 +-
 x86/cstart.S              |  48 ++----------
 x86/cstart64.S            | 125 +------------------------------
 x86/dummy.c               |   8 ++
 x86/efi/crt0-efi-x86_64.S |   3 +
 x86/efi/efistart64.S      |  79 ++++++++++++--------
 x86/svm_tests.c           |  10 +--
 x86/trampolines.S         | 129 ++++++++++++++++++++++++++++++++
 16 files changed, 470 insertions(+), 227 deletions(-)
 create mode 100644 x86/trampolines.S


base-commit: 610c15284a537484682adfb4b6d6313991ab954f
-- 
2.36.1.476.g0c4daa206d-goog

