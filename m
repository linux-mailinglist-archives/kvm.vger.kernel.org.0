Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7F7349AC4
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 21:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhCYUBx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 16:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbhCYUBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 16:01:23 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AB5C06174A
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 13:01:23 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id a1so4692695qkn.11
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 13:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=OPHCEnv3IH5HETxShRsKAPF8udKnECk6wv4oHyblTuE=;
        b=BeKSruwHWTA4iEPdpdv8zEnockAVt0H6lVRsdLVGy1ARx/rQo9+bQfI8FB5R7ca4B7
         Ad7V67Vox0OAwiKdMGfa2qX7ghT59Av/Sy5AfDbjoeTFQgD+Sh6DEHVZeMO0HkcQo0J3
         5UOzagrJC0pkuJXeGO6LKICwkWMCu5lzxniRU093oZqronMoWUb2/gdQLtSw71PdpY3V
         eD/IQSY0WYoP0SLbXcWAyh6m9KzUArB7dVwgKKu6J5uBCrLu0Mj5hronPOTlgHy7BGtR
         KTPLyBqYqODwlcMQZhmthuuX1CzTNsZ74cSEIJsWgG6KJoPtxPS3K5cEj0f2Cq5HyMJk
         PNtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=OPHCEnv3IH5HETxShRsKAPF8udKnECk6wv4oHyblTuE=;
        b=LUKoOqmUtzKqpG/8dtyxdGGIr/dJ7KoM9Zw4cNcIPdFODI/07hlTDA03kpOowEya3D
         3LgWQZ9OZI/4+y4IG7Zmm2tgV7RflRUCkvze9d/e77cqKFZWed5cGRfFiYeox6GT4Bzt
         5KRaFCuPHJKxHqr42bW65g3EKxu7zFKZanpZVgpB6vOaqVWTujbPxhezfEHmdVw3e9cX
         R2lJoOUxfELJu738Q+8f1SV83T8/9KDjoI0HyrjpFt91Rp9wCIaHWI4sOZPzxi38mhvp
         PD3QOZq9IPh4AY5XLTAa4F2e51Ubxtdsmbjrfn/u83kdoD8eXluY1AArGKyk4F34cAZt
         keXQ==
X-Gm-Message-State: AOAM5301ipv+hEg62gkYlki7UBden2aqKfQOh3eZ3bkpEHu5PH5WQuDk
        0QcfMQOmYRjl3YSK8jUguVWwivIg0io=
X-Google-Smtp-Source: ABdhPJx+c2hqxP76WsAheoxmp/+Z8PsVvpwZCAHUHbhEJTX8ymTXvaKwyhSoBOkmsppO8Rve+FVcIAebtPI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a05:6214:425:: with SMTP id
 a5mr10117188qvy.55.1616702482646; Thu, 25 Mar 2021 13:01:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Mar 2021 13:01:16 -0700
Message-Id: <20210325200119.1359384-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH v2 0/3] KVM: x86/mmu: Fix TLB flushing bugs in TDP MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two bug fixes and a clean up involving the TDP MMU, found by inspection.

Patch 1 fixes a bug where KVM yields, e.g. due to lock contention, without
performing a pending TLB flush that was required from a previous root.

Patch 2 fixes a much more egregious bug where it fails to handle TDP MMU
flushes in NX huge page recovery.

Patch 3 explicitly disallows yielding in the TDP MMU to prevent a similar
bug to patch 1 from sneaking in.

v2:
 - Collect a review. [Ben]
 - Disallowing yielding instead of feeding "flush" into the TDP MMU. [Ben]
 - Move the yielding logic to a separate patch since it's not strictly a
   bug fix and it's standalone anyways (the flush feedback loop was not).

v1:
 - https://lkml.kernel.org/r/20210319232006.3468382-1-seanjc@google.com

Sean Christopherson (3):
  KVM: x86/mmu: Ensure TLBs are flushed when yielding during GFN range
    zap
  KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping
  KVM: x86/mmu: Don't allow TDP MMU to yield when recovering NX pages

 arch/x86/kvm/mmu/mmu.c     |  9 +++++----
 arch/x86/kvm/mmu/tdp_mmu.c | 26 ++++++++++++++------------
 arch/x86/kvm/mmu/tdp_mmu.h | 23 ++++++++++++++++++++++-
 3 files changed, 41 insertions(+), 17 deletions(-)

-- 
2.31.0.291.g576ba9dcdaf-goog

