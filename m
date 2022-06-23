Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9B85570FF
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 04:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377737AbiFWCTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 22:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377027AbiFWCTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 22:19:37 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C383A18E
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 19:19:36 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3177608c4a5so154978237b3.14
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 19:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=clGwED0aj4iCkpRX962hKSp2BNMhn+u4O4Dfvr+4TFo=;
        b=QIc7ryIuzZq7OzN7qncavyfDB+dbKXmztSbltzJfaHp1hfv5Y5C7ooLKoq0+zPKBFW
         Yb0/BwS6ZEfxF45IEKThJ2MueA04/+OqWzX470xd1LnNts5nGxalTSLvPuyQYFShfxVY
         fr4wYm+DZCv+ppd68WfEA3gHFWzd+l9k/IeA3ejN3UEhM2Mgzid5sCvby/eJdNVuWRpQ
         T0hYRgEzg4XuwmsYlfvFW+IIAB7fjU1loFiyTbwdYIVKiDrgd9GjTDFXVUeSo350hrx5
         PUr8oLhkHA9+OABNIyny8ozoHdOiM1g4AmYdxtdgzxsW7Kh9yYaDEBQC7KQPY5UXS7ff
         SqLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=clGwED0aj4iCkpRX962hKSp2BNMhn+u4O4Dfvr+4TFo=;
        b=7T33OvsG1vFi8DsY/Us8dH8laBUj5dQPWt3vSPhgu45MLhml6k0O2QgEMHXTKfspnZ
         Oy+hEap6SHX2JkXnfDW5J0qBuGjAYF0SwDsmEn4Uc/rZGN/Go4sxailiaErNiO5S3dmd
         tpbghfMPO/TcIvIoB7HUz3AH4VGQjPHE72BwsinGEHc5ptXbhk1AFW3H+xBe3Ic1b62e
         +TLCqGHamsLs/JxVPc4//G9Eo/QHVOD2k/CwDJBlfZtRRUICRg/uvSyY1VCeb7xfjD2j
         DGgPNDCfg69BZiwHUSF2mTtknX2/j8tktVa3x80PPT6BVRoWlWhOR08SxSOeeOFDWNya
         3JLA==
X-Gm-Message-State: AJIora9cbw9pmfJq83yKrCqcDfGM+XNK5ZrWcBKJPoqA57dQrpFt54ab
        nRvl9qExlN1tDI03DLmG6U4nuGk=
X-Google-Smtp-Source: AGRyM1tFAzIf0LizFYNaF+FpbBnP7KTyC21L9xOk3A4wFYiTKAd03Hngi8vpnd587mAKhdzQ+Cp3fcs=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:ba6f:123c:d287:a160])
 (user=pcc job=sendgmr) by 2002:a81:9c47:0:b0:313:31e7:dc16 with SMTP id
 n7-20020a819c47000000b0031331e7dc16mr7974663ywa.227.1655950776012; Wed, 22
 Jun 2022 19:19:36 -0700 (PDT)
Date:   Wed, 22 Jun 2022 19:19:23 -0700
Message-Id: <20220623021926.3443240-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH 0/3] KVM: arm64: support MTE in protected VMs
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
series previously sent to the list [1] and later rebased to 5.19-rc2
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
 arch/arm64/kvm/hyp/pgtable.c                  |  5 +-
 arch/arm64/kvm/mmu.c                          |  4 +-
 12 files changed, 126 insertions(+), 10 deletions(-)

-- 
2.37.0.rc0.104.g0611611a94-goog

