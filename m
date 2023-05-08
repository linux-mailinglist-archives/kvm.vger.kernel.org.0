Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E7A6FB42E
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbjEHPrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234436AbjEHPri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:47:38 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884A21BE4
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:47:18 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so50091694a12.0
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560837; x=1686152837;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KpanxEpEiTbQ5JhnaTFz7pk8ID815+1xUb3+Dt60o2M=;
        b=Tazu9/dERiZuPhnFF+Id1IjKmiN/RRl8b4mMRmGnNJgxwqyq7w1lwgUiHHCsWffLyU
         w7U37z3aCJvtFS8TbxYM8enfPLy6eHjS8v/jtqvGOgpZrFvE84ANDEsn4yreHUbde9H3
         o3/Ebp27tA6rNGe8D4WKIxRRPeNyP0TOzinHmr6sQJZ7IsHlVnjnA69qITdOY+WE90kn
         qtwovh/J3Z9cJ+BqvrR/JCsDBhVe93yPv0JJJa+T5wxZQlXnGeFdbEG/brU8Iwh6sVeP
         UscsCXWDXi5Y0UsmEVmF4ktwcjTI+gcy4aYXfSWktC8pexipeaF40vx6pwk9FVImZOyG
         Zd2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560837; x=1686152837;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KpanxEpEiTbQ5JhnaTFz7pk8ID815+1xUb3+Dt60o2M=;
        b=iVZrF1M9mawThb2XDPJ6NU157skItcpP6J90PTr/oAC00u0KTypTWTJcZ8nkc1Ep8U
         8VgO0PYAHO0PrOoICvEXF1CO4+T57IBmNGa/WThEVg/GWHn82ECr4eACedD1AyIeOLFg
         DJgE5mGWye8luC/0kx19lM1KCVJJ9/RTNLMHea9+D/D3kVWB3CMuFIeqQFpYXI1yU5HH
         ShNI8oeYYVONufXcgORxOwTsjaJyFhZG144+RyKtm+jk3gu+YBV3A33VN/hmekVYZgm8
         ifEHIkAMBlxIIDarsmkiL71i+mqlp1SJrTxJAvchVGGTGtNc/30IZKj8MNW58AWHvfpE
         jXsQ==
X-Gm-Message-State: AC+VfDy0U4xgZllWbCS7U0SMRsOD3Lmls9kty974Kh1VbiVLS+UbgdN+
        JLn4hbMKV9tS/u/+QjUmFHefcw==
X-Google-Smtp-Source: ACHHUZ700/ZKWGTSV3XJfWwEGOkIm/IxrcSqS6qmT0qqfsZ2wclfJ9MWOUph//zbE254QZe2FVj3Jg==
X-Received: by 2002:a17:907:7295:b0:94e:bf3e:638 with SMTP id dt21-20020a170907729500b0094ebf3e0638mr8870455ejc.11.1683560837034;
        Mon, 08 May 2023 08:47:17 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id md1-20020a170906ae8100b0094b5ce9d43dsm121822ejb.85.2023.05.08.08.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:47:16 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 5.15 0/8] KVM CR0.WP series backport
Date:   Mon,  8 May 2023 17:47:01 +0200
Message-Id: <20230508154709.30043-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a backport of the CR0.WP KVM series[1] to Linux v5.15. It
differs from the v6.1 backport as in needing additional prerequisite
patches from Lai Jiangshan (and fixes for those) to ensure the
assumption it's safe to let CR0.WP be a guest owned bit still stand.

I used 'ssdd 10 50000' from rt-tests[2] as a micro-benchmark, running on
a grsecurity L1 VM. Below table shows the results (runtime in seconds,
lower is better):

                          legacy     TDP    shadow
    Linux v5.15.106        9.94s    66.1s    64.9s
    + patches              4.81s     4.79s   64.6s

It's interesting to see that using the TDP MMU is even slower than
shadow paging on a vanilla kernel, making the impact of this backport
even more significant.

The KVM unit test suite showed no regressions.

Please consider applying.

Thanks,
Mathias

[1] https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/
[2] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git


Lai Jiangshan (3):
  KVM: X86: Don't reset mmu context when X86_CR4_PCIDE 1->0
  KVM: X86: Don't reset mmu context when toggling X86_CR4_PGE
  KVM: x86/mmu: Reconstruct shadow page root if the guest PDPTEs is
    changed

Mathias Krause (3):
  KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP
    enabled
  KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
  KVM: VMX: Make CR0.WP a guest owned bit

Paolo Bonzini (1):
  KVM: x86/mmu: Avoid indirect call for get_cr3

Sean Christopherson (1):
  KVM: x86/mmu: Refresh CR0.WP prior to checking for emulated permission
    faults

 arch/x86/kvm/kvm_cache_regs.h  |  2 +-
 arch/x86/kvm/mmu.h             | 42 ++++++++++++++++++++++++++++++----
 arch/x86/kvm/mmu/mmu.c         | 27 +++++++++++++++++-----
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/pmu.c             |  4 ++--
 arch/x86/kvm/vmx/nested.c      |  4 ++--
 arch/x86/kvm/vmx/vmx.c         |  6 ++---
 arch/x86/kvm/vmx/vmx.h         | 18 +++++++++++++++
 arch/x86/kvm/x86.c             | 27 +++++++++++++++++++---
 9 files changed, 110 insertions(+), 22 deletions(-)

-- 
2.39.2

