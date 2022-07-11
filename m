Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64108570E45
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 01:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiGKX2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 19:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiGKX2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 19:28:11 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E179D89ABA
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 16:28:10 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h190-20020a636cc7000000b003fd5d5452cfso2448594pgc.8
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 16:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=DOykPfZhOOv0A0SN4H+uKTFYCJTV7QKNGrNlJuhxp84=;
        b=DhjR00I2EIl9ur7w4+92haoVAvaSmx6M50NPQsvNeU4+2tdO//RaVDVPR9uhkYpuHI
         g3FZM3me5poAWnd3bHGWSsGgmUrWdgd1C7lYar8J4jADipoGzXBNot27/DEM/yjiGRtA
         korePGbE9xdv0s0COoYaVOJFTrzIPmVsxTcmPoKSEx5L/40neFymhoWoaEFrBup7lThU
         FO70qtZLjWU4939rLwfGJQll0oW/NIs3apt4Xm+GBbDIyyIM5IQsankaVpEobaf+uF+t
         FuHOYgKiNCxGBSf21EuO3EB7Ey+Ps2nDX+IZEq0AIwzi3HLmsmK7Fs27nUIq+tf/IBWQ
         tvOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=DOykPfZhOOv0A0SN4H+uKTFYCJTV7QKNGrNlJuhxp84=;
        b=Xu6ePg85usZzMT11u45YAcgnz5I/KYtaF2M3vRZ3mFzDo1zcnp1QDFCvAtYTswFlBT
         ZyYgP/sDf25I0I+PLy6pSjn9wbdWywd1tyD+0MxCHCRG4PmsqgbA5J1S/sV27YRXDY/7
         WuixBmPwaowz7K7ab+8mcfzL06UUTPmIHYvdPM4BPeZHvJI/Bc5cZVJTPH90GTHDSwRA
         +p/WnYzz8oI0IPBB3SU/ke/C/RRS7tILnn5Z24ZuiqgHWDsJZVO+EI+6R8d8erlKjLZ2
         vZRlTK/ENtc66Zuu3TDUyXJcdAd6dF8Ba+4rRHCrfX5QrSOgHoNDedtGp1CG5qjFl6/i
         BLWA==
X-Gm-Message-State: AJIora+vbICoRLzzKjwWLFpCxLJ0g/9wRgH/8eZ//L5+avt+ObNqDFnh
        vwXDSEYET7ji15ZRyp1U7p4JP5mUzx8=
X-Google-Smtp-Source: AGRyM1vDkuLDhPZPzDb+e7RX9GzZoroE4ub/CuME1ey11DpIJVbkNuemy4Wcx9+RbAEgfHM7hxMRV9bWBg4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b598:b0:168:f664:f1cb with SMTP id
 a24-20020a170902b59800b00168f664f1cbmr21014227pls.26.1657582090526; Mon, 11
 Jul 2022 16:28:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 11 Jul 2022 23:27:47 +0000
Message-Id: <20220711232750.1092012-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH 0/3] KVM: x86: Fix fault-related bugs in LTR/LLDT emulation
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+760a73552f47a8cd0fd9@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>
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

Patch 1 fixes a bug found by syzkaller where KVM attempts to set the
TSS.busy bit during LTR before checking that the new TSS.base is valid.

Patch 2 fixes a bug found by inspection (when reading the APM to verify
the non-canonical logic is correct) where KVM doesn't provide the correct
error code if the new TSS.base is non-canonical.

Patch 3 makes the "dangling userspace I/O" WARN_ON two separate WARN_ON_ONCE
so that a KVM bug doesn't spam the kernel log (keeping the WARN is desirable
specifically to detect these types of bugs).

Sean Christopherson (3):
  KVM: x86: Mark TSS busy during LTR emulation _after_ all fault checks
  KVM: x86: Set error code to segment selector on LLDT/LTR non-canonical
    #GP
  KVM: x86: WARN only once if KVM leaves a dangling userspace I/O
    request

 arch/x86/kvm/emulate.c | 23 +++++++++++------------
 arch/x86/kvm/x86.c     |  6 ++++--
 2 files changed, 15 insertions(+), 14 deletions(-)


base-commit: b9b71f43683ae9d76b0989249607bbe8c9eb6c5c
-- 
2.37.0.144.g8ac04bfd2-goog

