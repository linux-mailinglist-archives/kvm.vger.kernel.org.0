Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC037507E44
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 03:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358760AbiDTBkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 21:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbiDTBkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 21:40:18 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57FF3467B
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:37:34 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id m12-20020a170902d18c00b001589ea4e0d6so137339plb.12
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=eY9rhzFCQwp4CslexU/2ccvHtC1KtRSxjLpofde0bGw=;
        b=VHH5ZBF37otk0WtV/tSvsGY/Gct4zudkIIYxo0R5S43YvQhA4s4SvHIWOFCkQam3Lg
         2/wSihGWny4ZRcpoZ9Rd5JSXRhn6YF5twzkUSt18W33pViahuC2Td8TmzgBDdlHjI2+n
         fc4nhFQZobPbNgCYFCpKgO2zoxunEX9IA5wHDvAutKvmo50yBckK5yE6cvJEFdRfb1oF
         pgVTuzHizqB+/zwB5bYzQwm7/XQyWtP9bcP96LypAgUtm9972uxNLawZaPVsAtsXW+Oq
         xKES0Kea7RalLxSBNj9jMHv22sRILhbdH+9wzq8/HQBZZpUNKWkd4bM9PwDmQ02QVXq8
         UFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=eY9rhzFCQwp4CslexU/2ccvHtC1KtRSxjLpofde0bGw=;
        b=QH8iuaLWQB5CPMpCMOXRJ8wGmi72XHvFGnmliFTKrTbPAMGLHh/VY1cVCD1UzQBI/a
         l2EBArWnXsDtXIEUHGbWC0t6zzN88RwKOvNu/nOmXn5Dg9nFDRZ1oWH/Z52B2yHtHzXN
         7tIR33LifgkMPme7M1TY6W46df9icg6Qm6qd+OA28slUynw6LLwxRTb23UBYDLE4evc/
         p/RTUYQb+QWuO4X8JgOuSKDxORtMX+9CEMSziEJMZh0P+hFSpK7ecvGGDHWDzZKvELPw
         ZvABe7eaaPsKys8S9Km3vmDCcQwXM5Y4ON8LDaiqKRlbILF4MwW2rc0x3POJZgjwHGkK
         VPmQ==
X-Gm-Message-State: AOAM5324WQmLBlMrgHftKnMu2hqnlYSCtGoGcnmudm4hZvDsqlfigr+k
        cBJpuaSui8e8ZbsYWHkYlTOqU0O6A90=
X-Google-Smtp-Source: ABdhPJyItzAyxnB6JimtWaJClPTmyqjT/e4k9MJ4QGgq2Tsac1QNZdwbAF08WqmHc+RZjf6K63IxRjDytYc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1490:b0:4fb:1544:bc60 with SMTP id
 v16-20020a056a00149000b004fb1544bc60mr20634404pfu.73.1650418654213; Tue, 19
 Apr 2022 18:37:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 20 Apr 2022 01:37:28 +0000
Message-Id: <20220420013732.3308816-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v2 0/4] KVM: x86: APICv fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Gaoning Pan <pgn@zju.edu.cn>, Yongkang Jia <kangel@zju.edu.cn>
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

Patch 1 is brown paper bag fix for a copy+paste bug (thankfully from this
cycle).

Patch 2 fixes a nVMX + APICv bug where KVM essentially corrupts vmcs02 if
an APICv update arrives while L2 is running.  Found when testing a slight
variation of patch 3.

Patch 3 fixes a race where an APICv update that occurs while a vCPU is
being created will fail to notify that vCPU due it not yet being visible
to the updater.

Patch 4 is a minor optimization/cleanup found by inspection when digging
into everything else.

v2:
  - Collect reviews. [Maxim]
  - Reword patch 2's changelog to make it clear that ignoring vmcs02
    is perfectly ok. [Maxim]

v1: https://lore.kernel.org/all/20220416034249.2609491-3-seanjc@google.com

Sean Christopherson (4):
  KVM: x86: Tag APICv DISABLE inhibit, not ABSENT, if APICv is disabled
  KVM: nVMX: Defer APICv updates while L2 is active until L1 is active
  KVM: x86: Pend KVM_REQ_APICV_UPDATE during vCPU creation to fix a race
  KVM: x86: Skip KVM_GUESTDBG_BLOCKIRQ APICv update if APICv is disabled

 arch/x86/kvm/vmx/nested.c |  5 +++++
 arch/x86/kvm/vmx/vmx.c    |  5 +++++
 arch/x86/kvm/vmx/vmx.h    |  1 +
 arch/x86/kvm/x86.c        | 20 ++++++++++++++++++--
 4 files changed, 29 insertions(+), 2 deletions(-)


base-commit: 150866cd0ec871c765181d145aa0912628289c8a
-- 
2.36.0.rc0.470.gd361397f0d-goog

