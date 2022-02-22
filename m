Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAFD64BF23D
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 07:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiBVGsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 01:48:03 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiBVGsB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 01:48:01 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569C210DA41
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 22:47:37 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id l19so11017414pfu.2
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 22:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y49qeHSLbsysRmrFWFJDrfEyQJx8/GQPaFEvbP+Ukrw=;
        b=ZN3bOcztuVRMyT6u3TFaoftMURDWMOScA8rb8F8dxdpu8aj/CKpHIZ/1SWUh+HMCEv
         eJyWuQ2idrqFcvz9OidKyPV+PL0LEOslBphDAW6c/QLqED1EAKHp+EzxKjUsiHsyCUo5
         t9o0WOS4MfeCrdc+1qbiOeF20S4GOnx0kHcS7VwtV0+DZcxM+zwbZUodAjOLEFNhLBDN
         50D7TaU914L+0e7VXr8mNSrpUXiymy8n2fWxmsONGPBn9MgwiF/ueqfqDpq2KrjaIyz/
         sMPcZ73zPoqWg5/pet4M5DU1PFkB0thG3I55rofzAfjYGNrXxej090YC6CxYYI1dhqtP
         FVIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y49qeHSLbsysRmrFWFJDrfEyQJx8/GQPaFEvbP+Ukrw=;
        b=kAW94ijRe3PJSvQuE2ovb4rRGEeeUa0s87W1gnzX7hwZO53uM9xfN+U2npr3Mamhd9
         WSkbXdQOl0/QLz/YzC7ZcdNJEq51MVnvtBiznQkstZ0TB/y2zqIoE3+EDfkQUxPbv91I
         IyPOZMIR6bJb+oJcUi5eofEeSejwpGGL5dQmGShlkb8Gwlin2TfHl4E324z2sAHzQebT
         HuqFjgpCoeLZOLotNZ+v4650Zy94c9Zpw8FNgwcd/ZA6OiUFF4PrBKUM8BUz2DzDEthh
         76Jny6BCaVrF+3B8Hfiawd/CBFk5Gfu/pR+QmNoi7PNp/0guTGgXbIBkjd1WOHqIA81r
         DKFw==
X-Gm-Message-State: AOAM531i4xvSXXfMMkqie02h6Cb558+WySHPlF7m3Y0530PmQSe/5hXX
        CRaOEMjh1E1nomU9YlG8L6c=
X-Google-Smtp-Source: ABdhPJwQWl8rMbXMOAO253k7mJBge7rkMz0FhtnaM+7AnNTJBEQuTwK5wvhHoJgc9u+Qvg3skV8gtw==
X-Received: by 2002:a05:6a00:1687:b0:4e1:45d:3ded with SMTP id k7-20020a056a00168700b004e1045d3dedmr23286018pfc.0.1645512456816;
        Mon, 21 Feb 2022 22:47:36 -0800 (PST)
Received: from bobo.ibm.com (193-116-225-41.tpgi.com.au. [193.116.225.41])
        by smtp.gmail.com with ESMTPSA id d8sm16346711pfv.84.2022.02.21.22.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 22:47:36 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v4 0/3] KVM: PPC: Book3S PR: Fixes for AIL and SCV
Date:   Tue, 22 Feb 2022 16:47:24 +1000
Message-Id: <20220222064727.2314380-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Patch 3 requires a KVM_CAP_PPC number allocated. QEMU maintainers are
happy with it (link in changelog) just waiting on KVM upstreaming. Do
you have objections to the series going to ppc/kvm tree first, or
another option is you could take patch 3 alone first (it's relatively
independent of the other 2) and ppc/kvm gets it from you?

The first patch in this series fixes a KVM PR host crash due to a
guest executing the scv instruction or with a pseries SMP host, the
host CPUs executing the scv instruction while a PR guest is running.

The second patch fixes unimplemented H_SET_MODE AIL modes by returning
failure from the hcall rather than succeeding but not implementing
the required behaviour. This works around missing host scv support for
scv-capable Linux guests by causing them to disable the facility.

The third patch adds a new KVM CAP to go with some QEMU work to get
the AIL differences properly represented in QEMU. The third patch will
need to allocate a KVM CAP number and merged with upstream KVM tree
before the QEMU side goes ahead.

Changes since v2:
- Fix fscr compile error in patch 1.
- Add patch 3.

Changes since v3:
- Rebased, cc kvm@

Thanks,
Nick

Nicholas Piggin (3):
  KVM: PPC: Book3S PR: Disable SCV when AIL could be disabled
  KVM: PPC: Book3S PR: Disallow AIL != 0
  KVM: PPC: Add KVM_CAP_PPC_AIL_MODE_3

 Documentation/virt/kvm/api.rst         | 14 +++++++++++++
 arch/powerpc/include/asm/setup.h       |  2 ++
 arch/powerpc/kernel/exceptions-64s.S   |  4 ++++
 arch/powerpc/kernel/setup_64.c         | 28 ++++++++++++++++++++++++++
 arch/powerpc/kvm/Kconfig               |  9 +++++++++
 arch/powerpc/kvm/book3s_pr.c           | 26 +++++++++++++++---------
 arch/powerpc/kvm/book3s_pr_papr.c      | 20 ++++++++++++++++++
 arch/powerpc/kvm/powerpc.c             | 17 ++++++++++++++++
 arch/powerpc/platforms/pseries/setup.c | 12 ++++++++++-
 include/uapi/linux/kvm.h               |  1 +
 tools/include/uapi/linux/kvm.h         |  1 +
 11 files changed, 124 insertions(+), 10 deletions(-)

-- 
2.23.0

