Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C7E503411
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 07:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiDPDp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 23:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiDPDp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 23:45:26 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B962A9941
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 20:42:55 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id l7-20020a17090b078700b001d090271f1dso2211333pjz.1
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 20:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=8gqRG0zSL+s/MwLzwmAZ7evCIrSOqpXierRC2ea+1Y0=;
        b=Qx/ne/Hp6I4PuAZbjON2odwjYxsJ14MHHLmDGeflAHGVykHvRh3K+GQLA4UBc8Od6v
         2uILtDy1dxIxe0biG23oiPXWA/r8HosWz6u3of0TAcKIWi/9NcsR1zUDWkFsWgVDOSnO
         7/1IiCzLw4c39fagffM3TMMFGkaTbQngkGvSJuPs1AXaHIjIx3NJimulWSFTTdWME7dw
         xKovNG3X7JUvQsRqd1ZidNrj62XIeplf16YqovY2G3+0gIZp5x7AsahN2tO6XoioagxY
         g6wdyl/TMiIEF7h0jg3V68Ei0/UhNur/mzgsyU4suUamZtxusxfCFvWR+R7/gTSbH68t
         MB3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=8gqRG0zSL+s/MwLzwmAZ7evCIrSOqpXierRC2ea+1Y0=;
        b=FSvOMWfTOgE3obev2RPsdXTH8VBo+ye0nYLC6YqPTFZwuYjA/kVqbFX8Pp/hsyf4Eq
         ZtxZcL1EXkqhk9aJ2FsArKmhlo4RMfYe5+3n7gdgW/TdM5M6wMfEck91bUc63iXm4ykz
         UJfP8f3fVJh1UIfIwSZ37mbiVXWVqTFkbsUWrERUdbyj8ZJKoQKoqLEt4iP8M4kBxbBU
         lL43U2cQ401x95HJk2RgIsJWOX3vVVSFGlwOOH52Aq5wHa2bigI6MFvF/Fcqsx+rDDe+
         2q9aafgvZxTJDb/Hl8EuxsL5GfD9yylKqrFnHc7K7oUqNMUMLSkrHnhISZpJHVS/TGqk
         1qhQ==
X-Gm-Message-State: AOAM530/2PTzNuRAN0WFdW3mCW3rKqxlqG2VmauYNNJ3VTcFv73cwqCq
        jO+c963Wt/Tqd4a/hemTkzQyIrT2g78=
X-Google-Smtp-Source: ABdhPJw3qyK/1SGPtAQqaNm3lDkgNgcqt6njwj+5mB1ILzdNhEDS53UF4nqOQi5OEC44npQ3nVZ5IVPSUhc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:8644:b0:153:9f01:2090 with SMTP id
 y4-20020a170902864400b001539f012090mr1918513plt.101.1650080574945; Fri, 15
 Apr 2022 20:42:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 16 Apr 2022 03:42:45 +0000
Message-Id: <20220416034249.2609491-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH 0/4] KVM: x86: APICv fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gaoning Pan <pgn@zju.edu.cn>,
        Yongkang Jia <kangel@zju.edu.cn>,
        Maxim Levitsky <mlevitsk@redhat.com>
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

