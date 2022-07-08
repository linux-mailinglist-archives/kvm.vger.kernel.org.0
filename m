Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A63A56C408
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 01:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238666AbiGHVVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 17:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238467AbiGHVVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 17:21:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406462BB09
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 14:21:15 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a126-20020a254d84000000b0066ec586adafso3739411ybb.12
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 14:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ZsW33TkaPVzGGAiF9Xw3rp8pMfW3pJDcP2sjUehOYU4=;
        b=Khnt/FKK2tmsglb39aHaXQe/85L0TtdEJmytldtpcB7PdifoCaJXvAu2CXcRmW1fzx
         y39SxrSY7BKqQOhMItRgS/Cx13UN/kBbrwQ/Gam0nbaR+8Q7CoY1CiXg5B71WoRePh2j
         BmY3lKiwS2ycyhg1BS16LXD9Z7aJPS0FkC2pQXd9qzhTDIpI2i7CD++lRaDj6QF8edbp
         dmfRRneCPKYpTwMrDrz8fnENuy1IXO5JIE+xD92f0pgT98gAriCpCX0P3s1Ps91yxQy7
         2hW2FGKbnGGRHuFURNW1H5Kl/eN3DF8tCmpGMZd4C4s8/P7ZhEauaDouX1m50xPL/K5r
         KtKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ZsW33TkaPVzGGAiF9Xw3rp8pMfW3pJDcP2sjUehOYU4=;
        b=iUw9CATvycx1G2Lz1esiDRX73KRQwf2emAso5E1XMf0q4Xum+Iz/kCopd4mjkDOCju
         mTvDrdDP6z/EJc6WRuyh/9XYmj25Ht/AIYxsZtLGWKMbjpBpeGu5JSJoCMDu3DxdJ3dP
         8imyCYZGJli1CclwUPVO6HEZ4Fd3B4c6rKrV5P0wr82DEpuICGD3iAAg4+dTyBDD5KPg
         tsXsT8asP2WfHlJl3x79vxoLAfpcSnWej6CK8fFNAFSINWrz7ngvg6tIiiumZgkXBf2O
         eGrkGSmzMAZBmBPGarBWobvxnWEQPlJLSvbBMBhMJ0uW3ENRbJk8kdP9V98GlcDV5Jnz
         qvww==
X-Gm-Message-State: AJIora8Dw4CUakfRMa4y0bSKHdS1bwfjl5ZU3ZbbRY7nnnkp4KPqPfIt
        2HyRwMTewbMJoteN3cwuBt+/yvU=
X-Google-Smtp-Source: AGRyM1vp5D7KtAIwbZuWBcV6WXvCFoP7Sbed2vVEKCoE284wiEj/Qi2clX5cWcAQ3mb99Pg3ce7swR0=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:ff27:d65:6bb8:b084])
 (user=pcc job=sendgmr) by 2002:a5b:18e:0:b0:66e:ca1c:bab0 with SMTP id
 r14-20020a5b018e000000b0066eca1cbab0mr6050295ybl.298.1657315274526; Fri, 08
 Jul 2022 14:21:14 -0700 (PDT)
Date:   Fri,  8 Jul 2022 14:21:03 -0700
Message-Id: <20220708212106.325260-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v2 0/3] KVM: arm64: support MTE in protected VMs
From:   Peter Collingbourne <pcc@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Peter Collingbourne <pcc@google.com>,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        linux-arm-kernel@lists.infradead.org,
        Michael Roth <michael.roth@amd.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>
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

Hi,

This patch series contains a proposed extension to pKVM that allows MTE
to be exposed to the protected guests. It is based on the base pKVM
series previously sent to the list [1] and later rebased to 5.19-rc3
and uploaded to [2].

This series takes precautions against host compromise of the guests
via direct access to their tag storage, by preventing the host from
accessing the tag storage via stage 2 page tables. The device tree
must describe the physical memory address of the tag storage, if any,
and the memory nodes must declare that the tag storage location is
described. Otherwise, the MTE feature is disabled in protected guests.

Now that we can easily do so, we also prevent the host from accessing
any unmapped reserved-memory regions without a driver, as the host
has no business accessing that memory.

A proposed extension to the devicetree specification is available at
[3], a patched version of QEMU that produces the required device tree
nodes is available at [4] and a patched version of the crosvm hypervisor
that enables MTE is available at [5].

v2:
- refcount the PTEs owned by NOBODY

[1] https://lore.kernel.org/all/20220519134204.5379-1-will@kernel.org/
[2] https://android-kvm.googlesource.com/linux/ for-upstream/pkvm-base-v2
[3] https://github.com/pcc/devicetree-specification mte-alloc
[4] https://github.com/pcc/qemu mte-shared-alloc
[5] https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/3719324

Peter Collingbourne (3):
  KVM: arm64: add a hypercall for disowning pages
  KVM: arm64: disown unused reserved-memory regions
  KVM: arm64: allow MTE in protected VMs if the tag storage is known

 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/include/asm/kvm_host.h             |  6 ++
 arch/arm64/include/asm/kvm_pkvm.h             |  4 +-
 arch/arm64/kernel/image-vars.h                |  3 +
 arch/arm64/kvm/arm.c                          | 83 ++++++++++++++++++-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  9 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 11 +++
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  8 +-
 arch/arm64/kvm/mmu.c                          |  4 +-
 11 files changed, 123 insertions(+), 8 deletions(-)

-- 
2.37.0.144.g8ac04bfd2-goog

