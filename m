Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922B9417C7D
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 22:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343663AbhIXUuo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 16:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243488AbhIXUuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 16:50:44 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1005C061571
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 13:49:10 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id 7-20020ac85907000000b002a5391eff67so39692925qty.1
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 13:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=9uQma88kyFtTCD66aTAT4dBZ3xnbMYTqia+UpO7dM68=;
        b=q8M1GSzF/uBUsavt23wy+YLJPWcBBcZT5BXEK0AYGqqYtHjRFmnyHF8TwQknKBDtpI
         0409cYtHRvf+eCPbBBcysULI1JCsSl0bZZ+s1Nk09CTJ+90Ps91HkbgULhl5FaJSP14e
         mT8dZdSQl7md3C+dxBbFXAZJhg0ad4SCdTETFaJa9GDOACcgO5F7P5FODb1WAlPfaJx6
         Q+wEsNq6VTqNUkP6s+rmozQ1MP5SeE/cgFcBKmlWX0P/UkQJIZ2V/2kq08VAAjn061Ic
         mR2+0pM5roN2Yyv3cJYYzmadD4MGnubNTce+WM4TMTiA+C68V1hWlpQNVejiMxwONs1J
         Bhew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=9uQma88kyFtTCD66aTAT4dBZ3xnbMYTqia+UpO7dM68=;
        b=ap1x5XBIVE1xMGS0UzJOnXzucVIX0NHgka0Uy/5XbnrYhDTFwoLGEpW/LKDXIl/qZK
         yrsJnZCcwsGXsDoLNA7dRVD6NHh+74+HAX+uyYDFQ3GmQUAN/Qi8rz0F5NEsIkK6PBkc
         6OL3Gk2MgsuxloSMMzjDvCOlaraHPIbeeRxWqQ38a91WFay3Qbxb6bee00ogPWE0XDz4
         DPiNAuKPk0SOP8uFoSLJgcFqz83b8Bgi0IkoqePNYFPjykz2meH/L9OI94VKD32p4wBC
         C1HQ3ODSbSrXJXdI/vyoVcYQT9uO1aTknR/qy9Dri0rfDpPDD69dyiRbPRm9gbfAvFF3
         0mxA==
X-Gm-Message-State: AOAM5304f03uk3LyfJVn2UA2KwbM4NkJEy2xjhVnZ+lTiQA+2h0vg/MY
        RoQ+haFwrQ2dQvL7X2h/AlSXq8S+q/Y=
X-Google-Smtp-Source: ABdhPJxiLtviXzL8CQQcYg6Uoaj/fu0Jl4WDxgw9fGltT1ZWUZgWB3/7mOhylUer2mA9ZebhG56wP4C/Hj4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:13e3:: with SMTP id
 ch3mr12068427qvb.35.1632516550025; Fri, 24 Sep 2021 13:49:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Sep 2021 13:49:04 -0700
Message-Id: <20210924204907.1111817-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 0/3] KVM: x86: MSR filtering and related fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix two nVMX bugs related to MSR filtering (one directly, one indirectly),
and additional cleanup on top.  The main SRCU fix from the original series
was merged, but these got left behind.

v3:
  - Rebase to 9f6090b09d66 ("KVM: MMU: make spte .... in make_spte")

v2:
  - https://lkml.kernel.org/r/20210318224310.3274160-1-seanjc@google.com
  - Make the macro insanity slightly less insane. [Paolo]

v1: https://lkml.kernel.org/r/20210316184436.2544875-1-seanjc@google.com

Sean Christopherson (3):
  KVM: nVMX: Handle dynamic MSR intercept toggling
  KVM: VMX: Macrofy the MSR bitmap getters and setters
  KVM: nVMX: Clean up x2APIC MSR handling for L2

 arch/x86/kvm/vmx/nested.c | 164 +++++++++++++++-----------------------
 arch/x86/kvm/vmx/vmx.c    |  67 +---------------
 arch/x86/kvm/vmx/vmx.h    |  28 +++++++
 3 files changed, 95 insertions(+), 164 deletions(-)

-- 
2.33.0.685.g46640cef36-goog

