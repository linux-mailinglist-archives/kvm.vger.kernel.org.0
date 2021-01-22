Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D13301180
	for <lists+kvm@lfdr.de>; Sat, 23 Jan 2021 01:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbhAWAP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 19:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbhAVXvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 18:51:48 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFF4C061788
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 15:50:59 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b131so7136671ybc.3
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 15:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=3POhTHexc6LhDaubtjgYfatSABcmeOtOygjcnj4BcAk=;
        b=pryGpbyDnNOlGkYMhi2UiMqUHCC/6GQrKj10KF3gt440WMZK53ART6IIrsh+WVazvJ
         yGNW9MIybtRzmL1HlgL2Co1zBKOMJOQOBvMcGsekWCeR8mb4cLqOrIyNpQy4W8nU/fr9
         hymtvZgOXTRTfKcVSCAoWdQWlmQIrfrOtVGHmyxr/ag24AGO9ZKJiEOmvU3aBArQQMf4
         dAYzd5myoRnm2qmPqCIKk0KPYkA2m8AMgsLEopGXzaxJolosOwcQV3f59f3Zv9/wv1BQ
         7DhWRyy/gtiNuGi1LYheMQmr+kvzS0LENiposnKznX/dxvLn7omnUJvTuZji4pdjFcwW
         Jtgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=3POhTHexc6LhDaubtjgYfatSABcmeOtOygjcnj4BcAk=;
        b=CwtXk5OTxJW9BpOY9RI563XrSX1hoxi5ntDoiSa3kJgTauyOHs6wy2DOqS15ttOpbf
         /XpygXRwgCzo2FHajo3qfzW9STJDVTir+Ey8TV2SULbw7zQ0zE9V6ATSd5A/zV49UPgQ
         ylTjnovtOsdQM5E9NWoNfbaSWbdRzo9iFDPs8coKegf/AWq/4wcWwBh7pb3q4TfbY011
         UJIH0SFK5lVzT3nfTAP91j3v+/toqfyjE9noTTA2gGzjotjfDsNrPzsMXvpoca9+qTl/
         oTnM/SbYYi3g3dW+u1l8AiuQeg8FO3TujXiELdh4YyQMBJLMpaSWHCtdMzhpLRz12rdq
         jE5g==
X-Gm-Message-State: AOAM531+pknThHXOv8aBUnZlMu1gXbv6avWte0YNEyQQszfYxlha0ZeZ
        TKuktLjjcJtGTXhRegq57oo2a7Qh4ig=
X-Google-Smtp-Source: ABdhPJwRa6A+ByMCfzsyYm3rJ5xGzonineYxYMTISwqJkhK1O0xoGicNKm02GnIcwVQOJd8axJMihD0A/gg=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:a0d4:: with SMTP id i20mr10015259ybm.182.1611359458330;
 Fri, 22 Jan 2021 15:50:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jan 2021 15:50:46 -0800
Message-Id: <20210122235049.3107620-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH 0/3] KVM: x86: Revert dirty tracking for GPRs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is effectively belated feedback on the SEV-ES series.  My primary
interest is to revert the GPR dirty/available tracking, as it's pure
overhead for non-SEV-ES VMs, and even for SEV-ES I suspect the dirty
tracking is at best lost in the noise, and possibly even a net negative.

My original plan was to submit patches 1+3 as patch 1, taking a few
creative liberties with the GHCB spec to justify writing the GHCB GPRs
after every VMGEXIT.  But, since KVM is effectively writing the GHCB GPRs
on every VMRUN, I feel confident in saying that my interpretation of the
spec has already been proven correct.

The SEV-ES changes are effectively compile tested only, but unless I've
overlooked a code path, patch 1 is a nop.  Patch 3 definitely needs
testing.

Paolo, I'd really like to get patches 1 and 2 into 5.11, the code cost of
the dirty/available tracking is not trivial.

Sean Christopherson (3):
  KVM: SVM: Unconditionally sync GPRs to GHCB on VMRUN of SEV-ES guest
  KVM: x86: Revert "KVM: x86: Mark GPRs dirty when written"
  KVM: SVM: Sync GPRs to the GHCB only after VMGEXIT

 arch/x86/kvm/kvm_cache_regs.h | 51 +++++++++++++++++------------------
 arch/x86/kvm/svm/sev.c        | 14 +++++-----
 arch/x86/kvm/svm/svm.h        |  1 +
 3 files changed, 34 insertions(+), 32 deletions(-)

-- 
2.30.0.280.ga3ce27912f-goog

