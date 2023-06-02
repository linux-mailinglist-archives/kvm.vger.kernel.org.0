Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0D771F7AA
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 03:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbjFBBT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 21:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjFBBTZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 21:19:25 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A765F2
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 18:19:24 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-babb76a9831so2005785276.2
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 18:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685668763; x=1688260763;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7s6TXqvpanfQFBEsVN94RP/FFrdSwVeosc4TIXMzv9Q=;
        b=ShqUQDV+6MH+Rk0LpIY+kQhVfsZfFoxbXgXsE0YZAn3zoQIIdEJMZnCVEm3A69HGov
         pjbcXGNbTZRaDIbKet1Q5bpNedda4NNl0U5bh29PkmhLmGjosBvHb8Ij8aZkoMAhI1ua
         1TJCCv/U30pBq70FdTDF/vxAotUG8qg7Zz+uvQe0eCKajthFwj1Pt+SVvLzm+YENaVIi
         eZWW0kMHD+Q75LZzWJzh50xKkr71ImnR1LXwMpz7D8NPl+PFf6yTYT0sZAVwq2TttcPq
         Ay12AKugOKaJhPbocv8I7RWk/w5Bt+DZJB9+uJ9DdXon4bVvqrLHY6+MigC3S9TMEL8N
         s+LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685668763; x=1688260763;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7s6TXqvpanfQFBEsVN94RP/FFrdSwVeosc4TIXMzv9Q=;
        b=AwP07SWcaH+r9qp3K02TL/iKVYQ/HyrWzt5M08gQcJCDZ0h1EbP3lsNiobxdvd1RNR
         GrvIw5j+c69GsLGtQUt4z5XtevoeKABmypKn7qRr04mWyYwIC+swB1wTV2N0UT/Au8Vg
         gde+HgKkyUimXRqqMtlC+A3aE57lUZLhyXpfWmNMwdfWpoqvw/j2n5w6kfFO3++NKO3V
         6ukxpbjvpReNjYV89phFJfQPdPmQwEq+wL/Apd+IjmV9aFkDNZ9+efL9tuJ5nvtkKSdx
         9BLZYjjFHVVUsqOx0LP7wjxJCYqylJqhtTFd41MmuFCgQPjRLIzLxBF4TpiBlcT13g9L
         MYEg==
X-Gm-Message-State: AC+VfDwASqJq3Gq6kehD9yMqHKQZOffB9ktF+h/eV9doUaBHxqzUoqf9
        lzhkDOwe4ySZOSyMbdtssHYAHPFj1cE=
X-Google-Smtp-Source: ACHHUZ6QCx5vcdViefzGxmDYcjizRuhzDj62nhQw5nWWSdQVLCV5Xo5iEqhfHjt3EHD8DpkjiSaGxtYW+Wo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:161e:b0:bab:f968:ec83 with SMTP id
 bw30-20020a056902161e00b00babf968ec83mr670519ybb.11.1685668763335; Thu, 01
 Jun 2023 18:19:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Jun 2023 18:19:18 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230602011920.787844-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: x86: Fastpath accounting fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix two bugs where KVM fails to account/trace exits that are handled
in the super fast fastpath.  SVM doesn't actually utilize the super fast
fastpath, i.e. patch 1 only affects VMX and the bug fixed by patch 2 is
benign in the current code base.

Found by inspection, confirmed by hacking together a small selftest and
manually verifying the stats via sysfs.

Sean Christopherson (2):
  KVM: x86: Account fastpath-only VM-Exits in vCPU stats
  KVM: SVM: Invoke trace_kvm_exit() for fastpath VM-Exits

 arch/x86/kvm/svm/svm.c | 4 ++--
 arch/x86/kvm/x86.c     | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)


base-commit: 39428f6ea9eace95011681628717062ff7f5eb5f
-- 
2.41.0.rc2.161.g9c6817b8e7-goog

