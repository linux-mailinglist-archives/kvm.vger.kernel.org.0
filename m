Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749953E9DC0
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 07:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbhHLFHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 01:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbhHLFHq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 01:07:46 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72633C061765
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 22:07:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n200-20020a25d6d10000b02905935ac4154aso4960900ybg.23
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 22:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=MGO3eu+69A+3zEDZ0OIrCDSLNnAJOWz2QBEh8ypXny4=;
        b=pMXZOmpnvS5i/V0QAPh96XFOGpXLFSzzsZFeGiZdpqM8zjUrBVg3VKjna/Shb588Dd
         5eIrJCjEVvhGW9j8lBuEC7SEiG5KX07w3I6rnaiK0ONN4VFoycjhmWcFtZmezYMFUEa1
         Nh8zEgBUBucCHVKVFTHWmJuMCAR5LlXJEPkBW8J4P7gFSWHQQpYWTGoKfqU4FkW4zHGP
         oQzFC5ip8cFLwdROTMLXnF7BjwbBII06aFtWRf0aSFQWz4cvV5FukS4mlKb2mlQ3/L5r
         tf7NfvuzDuWJ2CqHrgbbFUavMkc9Lg8cheb0Gnq5sEuKCs1MZ52KmsrKOONvgTmG1ljT
         R7nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=MGO3eu+69A+3zEDZ0OIrCDSLNnAJOWz2QBEh8ypXny4=;
        b=GbEySsTids1e4R2mJihrr+BLK7go4hKDHdqQukrWbLRIx7AN6Vnu5lpiPoChnvz0nl
         xeIQm2Nr8PMFUk1SlWg9XCtD/ZdJIOVRWy2EJxunyHU4yRovbQ7iJG19A5gjV71b2zj0
         7tOodMms42aZZQ/SxP3PBqU0YwwBDbwsrrWWsP5Mmj8aUHrOcnZ4KkN+fcxpeRpoa9fN
         fpv9ogryuIwtSN+ZOBAJhHcQodVSPSS749odCDIhis1mpbN5SQW9lmnBSu2cQWQeOhDe
         Tt3d1gi0eRDwGnggCWeD60r944bdoqyMnOlJq6d+41FX1rEu1Mg9tHg2JBH+crdJNwA9
         wBzA==
X-Gm-Message-State: AOAM531r6inusIkdIiux7pWK76w7VY732Z7RNCHLXPNmrbSM1v73hu3J
        jMpCqtOmFrs/3+5LzKc1DYjC25kXC8M=
X-Google-Smtp-Source: ABdhPJy2bpn5nmxNeT8Kxp75pFIA5BDr6AUwfne0xwi3DUsnVFgvyDYUASTjCG2EcJ8IEGyzufyy5pjy588=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:f150:c3bd:5e7f:59bf])
 (user=seanjc job=sendgmr) by 2002:a25:918c:: with SMTP id w12mr2048740ybl.226.1628744840665;
 Wed, 11 Aug 2021 22:07:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 11 Aug 2021 22:07:15 -0700
Message-Id: <20210812050717.3176478-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 0/2] KVM: x86/mmu: Fix a TDP MMU leak and optimize zap all
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

Sean Christopherson (2):
  KVM: x86/mmu: Don't skip non-leaf SPTEs when zapping all SPTEs
  KVM: x86/mmu: Don't step down in the TDP iterator when zapping all
    SPTEs

 arch/x86/kvm/mmu/tdp_mmu.c | 49 +++++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 11 deletions(-)

-- 
2.33.0.rc1.237.g0d66db33f3-goog

