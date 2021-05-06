Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B653E3759E0
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 19:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbhEFR7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 13:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236455AbhEFR7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 13:59:30 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10E6C061761
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 10:58:31 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id o5-20020ac872c50000b02901c32e7e3c21so4082461qtp.8
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 10:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=SUMsUAFzIemUpIBh2rroEWqtHg/B5XRDxbgXqiS7JYk=;
        b=OJ1k0E0Z3EM1Jd+PqZlqiUTHRz2VbvEyk6Ph32nc1oQ3BxdvTn5XfcAi7cXOr3sbTL
         bj5hLwc/CkfTcjm30F7Wf9VihsDtH86hu32xeB6qM/07sGUXbx0bsVxw7cll6pmlK9cv
         TTBGm++H8aMhgmnNCFvz+6JE/SRMUYMrya2QcKndzRlY40mp/U1GKxu9jgTYAwlS1Tkw
         1U2gkPnYH2IVUlYrD38OqdkOXxLtALL7jCwo2lt9k6L1qTxlDQvgwzsGxKMCcAAR7Dmo
         XH0sY17LEmePiS++VIktKhcohJJf8SBCZswQD3NKvi63MGsrEQt7ltfJjNYC3r1GekPU
         /jIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=SUMsUAFzIemUpIBh2rroEWqtHg/B5XRDxbgXqiS7JYk=;
        b=Sw/hdlPWkpdEEcK3KglcdsRDpXtmSycGdIP8hknaknQsrCPC+MDM7ltK/cIY174K/+
         0+zxYW5i7buowQT2au6a/srFzeG3/+2wYsFu01KUQUiFVcc9F31wsPHp4bHpp9fj6Rx8
         v5dOJLn1JojcK4h06U/N1AUnFKY/fwVy1lqJmu3EY1Osf84TGSKca7G1a7H7oPnY45UD
         RUPBk6RZ9UXk0sih8uVRgSGVoV3BHL8k7zOGB3h0Q1NdZTvnuOmKrKH2biKUJZbBshsG
         TJJbtON3OuDejSzVdlc3yueF1x3cfIm/rvsaZVW2w11AHuj5oXXJkCY0Qejia+gCHaMr
         064w==
X-Gm-Message-State: AOAM530onGPjKuOtVWosvxxQugBCFcCBIQud7fKNly7LzTspVNB8tQTf
        p2Q1viEYO5N90nZ6G2OD+JA8p4oZ6o8=
X-Google-Smtp-Source: ABdhPJx0cGg+sprFiauhsjPcfoixOwxTfbfmSMeTmduPX7FT15DTHEoDsTXgjDcfPTxqQJ7rr3Iu/+6OeBg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:818d:5ca3:d49c:cfc8])
 (user=seanjc job=sendgmr) by 2002:a0c:c3cd:: with SMTP id p13mr5775763qvi.4.1620323911188;
 Thu, 06 May 2021 10:58:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 May 2021 10:58:24 -0700
Message-Id: <20210506175826.2166383-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH 0/2] KVM: SVM: Fix error handling bugs in SEV migration
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steve Rutherford <srutherford@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes for bugs reported by Dan Carpenter, found by static analysis.  All
credit goes to Dan, the bug report all but wrote the code for me.

Compile tested only, I don't have a SEV migration sussed out yet.

Sean Christopherson (2):
  KVM: SVM: Return -EFAULT if copy_to_user() for SEV mig packet header
    fails
  KVM: SVM: Fix sev_pin_memory() error checks in SEV migration utilities

 arch/x86/kvm/svm/sev.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

-- 
2.31.1.607.g51e8a6a459-goog

