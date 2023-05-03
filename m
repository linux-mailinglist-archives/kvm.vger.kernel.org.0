Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145216F5DE6
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 20:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjECS3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 14:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjECS27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 14:28:59 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B4340FD
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 11:28:58 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-559f142fce7so90459427b3.3
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 11:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683138537; x=1685730537;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s5LULsV/BdFLkiwudhTGLsFbr5fms2w2Tnl9u44tzu4=;
        b=tvndxQi8cncEOtLXgaJJX/Ao77CjcBg/UcnSTaI9xh8loBUrJhtEH8926QK+yV9xDN
         ER80a71OG1AJJPGq12QVYHSwAZOMio8WkoahoJ43G4BQBjO8fsQKESDJx7jBBYOj6CEy
         Vp83tbu+6e5JF7jnGyjIfrpjFL4BOieaGcljpnGgybT1P4TTMzKzOF52zYvpu5mHWqmN
         mhB3T0DTI00KSU0fk4uegpCwYBIzWzXEjFs6rqyO/McKLpOIAdCHPATxNr0kkHCAuFs0
         K/mEtSFWS9HSl147y+GPRSWPGADkChdAADfihxnc/ZSoVSzUanT1J0xi22KBk1dXG0cw
         rCxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683138537; x=1685730537;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s5LULsV/BdFLkiwudhTGLsFbr5fms2w2Tnl9u44tzu4=;
        b=GdlAQRu0RWzP7HjkCPkpTNMmzhjv3egnqOClgxcQbbMHGWZINtxvGcV8sw8KZSZ8QL
         ASKKCwJIYyjVx5wWo1jawN0bCY17XInvw5oqOcvaS8P1YkDv5ZlnsVicpgQr3LK9tsTl
         sTh/00hRWoDlnFKDAoscXI8gKtdtxqv2w3cscNxpthbkOhTnwj9DsJAYRCFT1rArzzfo
         fhXXwV9SmKWuoMBZ1tGRZ1t07ElR5RfOOTFT2UedDVWSNpjdfmYHUdjXhPipLQWT9nUN
         2lKly+JW0aGFsrAbHU6LBUjz1O/8TrGTLHsveCe+c7Ywg9FiPKtl7E+PDLRzawPd7/wx
         g/Wg==
X-Gm-Message-State: AC+VfDzQoIaXbMf95pr81p9HJ0WDKniBohsfBuCn0wdmmVYGEzNMfjPH
        qGwZZ3MedC9ypRza58SO8T32ZLPBnX8=
X-Google-Smtp-Source: ACHHUZ6yET+gdVz04kU+dzAlp3RTSVPYl+F1ACJt8J69qSC3JYUa1SgwomnQ2cwXY/Dn4hK3Enn0fmSLc5w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ec05:0:b0:54c:bdc:ef18 with SMTP id
 j5-20020a81ec05000000b0054c0bdcef18mr13467659ywm.5.1683138537542; Wed, 03 May
 2023 11:28:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 May 2023 11:28:47 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230503182852.3431281-1-seanjc@google.com>
Subject: [PATCH 0/5] KVM: x86: Clean up MSR PAT handling
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wenyao Hai <haiwenyao@uniontech.com>,
        Ke Guo <guoke@uniontech.com>
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

Clean up KVM's handling of MSR PAT.  The PAT is currently lumped in with
MTRRs, and while the PAT does affect memtypes, it's not an MTRR and is even
exempted from KVM's kludgy attempts to play nice with UC memory for guests
with passthrough devices that have non-coherent DMA.

Note, this includes two previously posted patches:

  https://lore.kernel.org/all/20230329081859.2571698-1-guoke@uniontech.com
  https://lore.kernel.org/all/20230331071929.102070-1-haiwenyao@uniontech.com

Ke Guo (1):
  KVM: SVM: Use kvm_pat_valid() directly instead of kvm_mtrr_valid()

Sean Christopherson (3):
  KVM: x86: Use MTRR macros to define possible MTRR MSR ranges
  KVM: x86: WARN if writes to PAT MSR are handled by common KVM code
  KVM: x86: Move PAT MSR handling out of mtrr.c

Wenyao Hai (1):
  KVM: VMX: Open code writing vCPU's PAT in VMX's MSR handler

 arch/x86/kvm/mtrr.c    | 20 ++++++--------------
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/vmx/vmx.c |  8 +++-----
 arch/x86/kvm/x86.c     | 18 ++++++++++++++----
 4 files changed, 24 insertions(+), 24 deletions(-)


base-commit: 5c291b93e5d665380dbecc6944973583f9565ee5
-- 
2.40.1.495.gc816e09b53d-goog

