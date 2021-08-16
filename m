Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB893EDE96
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 22:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhHPUZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 16:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232227AbhHPUZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 16:25:23 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E90C0613CF
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 13:24:51 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id y27-20020a05620a09db00b003d3401f54ceso2906163qky.5
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 13:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=g9/o/9z4zsHt0A4xliRLw6qm1WgAQq/NIv8diVlT8V8=;
        b=Na3X8WB7HU4+Q6rnHbcbEUye2yyaMseyJnz+LAjXQqSHQ88sIut7dcBkUtIvj5yhwc
         Qh9OamjchJgGSoPW1u+0tow9mQJgUyZa+mm9ZTwwnTkOCfgvVpqx/U0Nchu8VA+SpdBq
         nH1pUu/wDwfzNKECulGVxKPyIpva3VxJ97CmiP7zHpT0fsO6DeRWlR1BPb9LusFYUGKF
         zemhX6whtx4nl7UcGBgmYqbxxfadoJFdSBrHA3Hn+PjKHP3Vw4zPyURNaT5XDwpIZl1K
         fWJZtzTAb3p/oAriDfOGX8Qv7HEV0vRtryfhpjq7LEVn0iDeCXMebHWwDq1D2ozwKtwc
         I7ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=g9/o/9z4zsHt0A4xliRLw6qm1WgAQq/NIv8diVlT8V8=;
        b=UYCqzHUsRY9C0z/AFyYMkxHV5CX5ZHhtib+/sHDThxVF5duAJmkUZzOqMoteezuzcb
         AFFq4tuVJAqmHG8IIBmJ6qLHuzdtf++5O21mwba8OIlnO3kqGJpTk1z7FO4ayUgTw0+u
         xhTe70WdLL9ygwwAKjECRwEnbLrcrL1y58JjdWWm2L725XZKO/qGfg5rbmGT66WpV1Gi
         R2knM88eBSNBpJvE1PLOBRQNUXizu0P1mjQD/4AjYUvu6/KFJ//pifPmMmKbXUp3xyBw
         7thWdnmISbUNg9p7rnEt0dxswnkh9PmMoxQmG3Jcq/AMBDKmB8ypomWxgdG+M3J70wUJ
         jrCw==
X-Gm-Message-State: AOAM532FJWJcWtnbDavlTcv9nphDFtSqQm6o0lL5nI056zoUgINcShtH
        i52OVTeURo2SGgPxjAlyX1E39JI6qeTG
X-Google-Smtp-Source: ABdhPJwyQSwjPkR0qaUuTjnATtBd/G0GgK4bzkRXvZ/+QgTGS2i6L2iov1MK4VgKXMwVdCMhqbzs5CiyzQUN
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:ad4:5dcf:: with SMTP id
 m15mr560462qvh.35.1629145490981; Mon, 16 Aug 2021 13:24:50 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 16 Aug 2021 20:24:38 +0000
Message-Id: <20210816202441.4098523-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 0/3] clean up interface between KVM and psp
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set is trying to help make the interface between KVM and psp
cleaner and simpler. In particular, the patches do the following
improvements:
 - avoid the requirement of psp data structures for some psp APIs.
 - hide error handling within psp API, eg., using sev_decommission.
 - hide the serialization requirement between DF_FLUSH and DEACTIVATE.

Mingwei Zhang (3):
  KVM: SVM: move sev_decommission to psp driver
  KVM: SVM: move sev_bind_asid to psp
  KVM: SVM: move sev_unbind_asid and DF_FLUSH logic into psp

 arch/x86/kvm/svm/sev.c       | 69 ++++--------------------------------
 drivers/crypto/ccp/sev-dev.c | 57 +++++++++++++++++++++++++++--
 include/linux/psp-sev.h      | 44 ++++++++++++++++++++---
 3 files changed, 102 insertions(+), 68 deletions(-)

--
2.33.0.rc1.237.g0d66db33f3-goog

