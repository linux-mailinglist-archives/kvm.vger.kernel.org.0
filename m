Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A6F594EC3
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 04:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbiHPCi5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 22:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbiHPCil (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 22:38:41 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C807B5D101
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:13 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3328a211611so28486747b3.5
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=mVKUfHAxxgg9dFR0UAB3JD/C7QlqlSU382wKoS0CjRg=;
        b=bfFJrPOqEiG3kZ4wcq0MTyR0LGxcU2DaUVTGr9SOWonBgS/WduTzmcK2FykxQ2CekV
         pPTO/UCafYm85N6/ESycmdenzIQfbEJZYLEaIU6SXvg6c2KPTGiA++3rGkNm4nfqSQ8r
         HYHfEKV6FHUl/8ZJAbES/P6CR1fstHdDZqOa716rnX8rSeXh8EKLTQ3IeMNO6fUD1FsN
         Z1dQY1flG830yRk0qbjQ87KKHpQncZZ9g2NWzjLn+osh0FxSS1opApLwslDc6AZLrkaV
         Q/Cm4fhDokXuGCobENLK8UIpZB6nvCRHuQMkp4H6GI/AiPSKgOxJ9fsimB+Sk1io2PWA
         eCJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=mVKUfHAxxgg9dFR0UAB3JD/C7QlqlSU382wKoS0CjRg=;
        b=Wo8E62LzEPAk1F5k6bGFSJoNCjTqBa07O8IeoZGHPjmQbmdPipg5xsrfsxvAJ0eUIy
         3V745pz/CHUkf67FGaXAY2sr7Cri/BBVd6oNob+Q/FoOuvYsKA6T0i0O+1TsGRnx3A59
         7JjGLqGA13bCqfsHjcFj2QlQGszpU+98jRqUtbZKwouBnFXq13g5XaDHGsV7Qrjs7zyo
         stg/Qd2vkXAt72C0SINhxFX5alN/KPA/dQyY/oq8Ucpydup/Qa65mrXL9CYsEze6ehLb
         n9wHN0mmyBjsFxIAWRbQhgltaxErQHlhDCG4nwXdElpvno4BYb44ywWdl++JkSBt/TX8
         xKpQ==
X-Gm-Message-State: ACgBeo0ixSGfxkJiV5qsqCBfubqCUE03aV9Ooxq6hVvJ7/olV5puW/xz
        USJae4yxVa9rM9ly2caHwNahjMFrzddxtg==
X-Google-Smtp-Source: AA6agR4cB5cTPK00re1vK+Vka58Nx77CWOJa7JOnC4DyOOSZW8vzCKmnYF6HZ49rSx9Yrlz0G4Lt7ZdW1/EObg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a5b:485:0:b0:67c:2c89:f3a3 with SMTP id
 n5-20020a5b0485000000b0067c2c89f3a3mr12809435ybp.571.1660604472981; Mon, 15
 Aug 2022 16:01:12 -0700 (PDT)
Date:   Mon, 15 Aug 2022 16:01:01 -0700
Message-Id: <20220815230110.2266741-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 0/9] KVM: x86/mmu: Always enable the TDP MMU when TDP is enabled
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
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

Patch 1 deletes the module parameter tdp_mmu and forces KVM to always
use the TDP MMU when TDP hardware support is enabled.  The rest of the
patches are related cleanups that follow (although the kvm_faultin_pfn()
cleanups at the end are only tangentially related at best).

The TDP MMU was introduced in 5.10 and has been enabled by default since
5.15. At this point there are no known functionality gaps between the
TDP MMU and the shadow MMU, and the TDP MMU uses less memory and scales
better with the number of vCPUs. In other words, there is no good reason
to disable the TDP MMU.

Dropping the ability to disable the TDP MMU reduces the number of
possible configurations that need to be tested to validate KVM (i.e. no
need to test with tdp_mmu=N), and simplifies the code.

David Matlack (9):
  KVM: x86/mmu: Always enable the TDP MMU when TDP is enabled
  KVM: x86/mmu: Drop kvm->arch.tdp_mmu_enabled
  KVM: x86/mmu: Consolidate mmu_seq calculations in kvm_faultin_pfn()
  KVM: x86/mmu: Rename __direct_map() to nonpaging_map()
  KVM: x86/mmu: Separate TDP and non-paging fault handling
  KVM: x86/mmu: Stop needlessly making MMU pages available for TDP MMU
    faults
  KVM: x86/mmu: Handle "error PFNs" in kvm_faultin_pfn()
  KVM: x86/mmu: Avoid memslot lookup during KVM_PFN_ERR_HWPOISON
    handling
  KVM: x86/mmu: Try to handle no-slot faults during kvm_faultin_pfn()

 .../admin-guide/kernel-parameters.txt         |   3 +-
 arch/x86/include/asm/kvm_host.h               |   9 -
 arch/x86/kvm/mmu.h                            |   8 +-
 arch/x86/kvm/mmu/mmu.c                        | 197 ++++++++++--------
 arch/x86/kvm/mmu/mmu_internal.h               |   1 +
 arch/x86/kvm/mmu/paging_tmpl.h                |  10 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |   9 +-
 7 files changed, 115 insertions(+), 122 deletions(-)


base-commit: 93472b79715378a2386598d6632c654a2223267b
-- 
2.37.1.595.g718a3a8f04-goog

