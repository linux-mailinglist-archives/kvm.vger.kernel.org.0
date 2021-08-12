Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73F13EAA00
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 20:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237618AbhHLSOs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 14:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236744AbhHLSOr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 14:14:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4368C0613D9
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 11:14:19 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i32-20020a25b2200000b02904ed415d9d84so6875817ybj.0
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 11:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=PaSEFkv8nY5W54B7TNXDIBLFRXOHOQ5fVhWGiqJIlhw=;
        b=FvTv0MfDjkfbfLUitgb3JrTe3A8KG8l5ZdZ0WBE+5JOHiJrnH56LYlBVYMOhSzleca
         EbDuAQZYD42ab5gfyzzQMq6Hkn4AP/Tpo+jgNxahi/Yik5E4no+yPtPt68yE3z/nzbAh
         rRSTAdWXm4kbPAz+F4GsUwwT25DtRG9mjxHiyKeMX2ZZvWxPebv7gGBcb4z1BjUxiBba
         Z+xk02xo+bVeSOVJElGeu8LU6XQ3CooUuiu5FAEO50SaChzHzA6CEz1cuc/Q5peFjCh7
         2WGdWTtCHyEZJPRisJM6v7D0FsARCvt4fSrE5zgBEs6IwAcI8AGqxvGHzt0yH6vMsK7J
         kMAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=PaSEFkv8nY5W54B7TNXDIBLFRXOHOQ5fVhWGiqJIlhw=;
        b=jlz5qB17q2OiI6w91WqxmxFfCt4uRUbHck7R2RoleZI2qdzZ60qkYTBghXCdhXRGER
         5kdawV+Da872CHo/Lgrz1z9CeLR5QONa478am/XyTZn3236+LJTN2UO1YBWXtxw1QoEj
         2z5Uy1Xq4XJxxNBjXwenDgs8/hxe9krIVfI3JZbLLyluy+HNBM4TWd5dSQdZFbDNTUmo
         Ngy5YPp77dmVfB5qnVEbBw6bOqGWBowfyKkM9hWaW3JPN3DOU2QZfM4NmQw7Mvj6MruC
         V3I7iWoyL74tazyGtqFM11eNRM7FQ0qZykvKw9qyfAYepspcZxRqqbT/D1Gk4Ycgrn0M
         prYg==
X-Gm-Message-State: AOAM531OBPOQWuj9t0d/MvUwmPZK15y+e71cIF3AI66nVEoY3fydnaHJ
        B/ed0AL/Dh4bFx9UsUEzHjBKEFHBhZg=
X-Google-Smtp-Source: ABdhPJy+Fj4AxkozJVWqQ1ecr6dzxUVj2Ju0s8v9C3yenHVw7nAymBPFVQNdUxa8M1n4IlckdfsrQnvvAJ0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:f150:c3bd:5e7f:59bf])
 (user=seanjc job=sendgmr) by 2002:a25:bc10:: with SMTP id i16mr6048991ybh.73.1628792058982;
 Thu, 12 Aug 2021 11:14:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 12 Aug 2021 11:14:12 -0700
Message-Id: <20210812181414.3376143-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 0/2] KVM: x86/mmu: Fix a TDP MMU leak and optimize zap all
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

Patch 1 fixes a leak of root-1 shadow pages, patch 2 is a minor
optimization to the zap all flow that avoids re-reading and re-checking
the root-1 SPTEs after they've been zapped by "zap all" flows.

I'm still somewhat on the fence for patch 2, feel free to drop it.

v2:
 - Replaced magic number silliness with Paolo's much more clever suggestion.
 - Elaborated on the benefits of the optimization.
 - Add Ben's somewhat reluctant review for the optimization.

v1: https://lkml.kernel.org/r/20210812050717.3176478-1-seanjc@google.com

Sean Christopherson (2):
  KVM: x86/mmu: Don't leak non-leaf SPTEs when zapping all SPTEs
  KVM: x86/mmu: Don't step down in the TDP iterator when zapping all
    SPTEs

 arch/x86/kvm/mmu/tdp_mmu.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

-- 
2.33.0.rc1.237.g0d66db33f3-goog

