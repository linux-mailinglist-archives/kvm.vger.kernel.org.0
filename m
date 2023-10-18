Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34307CE7E8
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 21:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbjJRTlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 15:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjJRTlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 15:41:10 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24088112
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 12:41:08 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7d1816bccso109853157b3.1
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 12:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697658067; x=1698262867; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1HjjlWV93sYNVV0Q80LXp2xExJaJHLYvfys9VI+7ya0=;
        b=DQrO8gYwfjibiHN0rlSiIoQ/nLfg/Mj1Sle/edKowt5MgMlpgR0dyArOp+aO7PjTgI
         bL4AaIl1/+fLCwYuBsRf3KavSBJ8TuiiJdf3hK9Q2aCccYr8zi/aCSzRSNfNf98h2UFJ
         yMg4zKbTYVvhPKcmscDh+0vpxzLpKFWNSJyc09cPe+8+veUTug2wYwBP33nwI2+pklPU
         3o4GBtUWMtx5Nu5CJCU8rR4tSO/cvCA3qdq6vQ612TO1MHXGaraKGRg0BhsN2nVSXYxs
         HjVFXMW2p6TT+m9mLSP+ubzhuT8DomIeiThXyxsq4Inex3INW6yMvv6X4Zk+G7ea1pID
         2dkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697658067; x=1698262867;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1HjjlWV93sYNVV0Q80LXp2xExJaJHLYvfys9VI+7ya0=;
        b=Q+krI3T5gbzzeTtxFxXCrGyh8Z/tw7dRCYh+XUWhbtAJ6u7NMG5YqiOQyQ9VH2WyaA
         /0w2z1rlq1joUNxgtIOdRvB6Xvq2GZ36TamfTzwWInkpT8k7vRB416AXRqh3dtUXvIuM
         tW0YFIwV38UFrRBoM+jP9BaThVBgf/a6DkKlH/yZmoL9Tm4IDYY9tTbfxazcvw38JLJG
         GH/pKYyxe50I2zGtzQC4doiGcUGYCoKKRkjv1zOm8FGI9Xs6D+2K0DurDbpxdF9wlgy6
         88dyCtSJu1MZWE+3BMfauBTcRmG0WPHgglNaKUmzELCLSqK1hlx5U0vu6mxTkK9ofDgh
         9teg==
X-Gm-Message-State: AOJu0YzrRORaukChKgdo0E6X+3RhWrvH2+j3j0k7v54Nt+TjddOY2k9p
        EjfD0cQUOXcVJQ5uWvHczQoKp39K/4w=
X-Google-Smtp-Source: AGHT+IE8JldtjibywpNTblhydXdy1N3IhzSNsL72GrUuV8XFAoJlygXGx8+Q6rayxL9AkgT412uQ4HEq/YI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:cbcc:0:b0:592:7a39:e4b4 with SMTP id
 n195-20020a0dcbcc000000b005927a39e4b4mr6046ywd.6.1697658067412; Wed, 18 Oct
 2023 12:41:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 18 Oct 2023 12:41:02 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231018194104.1896415-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: nSVM: TLB_CONTROL / FLUSHBYASID "fixes"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Sterz <s.sterz@proxmox.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two "fixes" to play nice with running VMware Workstation on top of KVM,
in quotes because patch 2 isn't really a fix.

Sean Christopherson (2):
  Revert "nSVM: Check for reserved encodings of TLB_CONTROL in nested
    VMCB"
  KVM: nSVM: Advertise support for flush-by-ASID

 arch/x86/kvm/svm/nested.c | 15 ---------------
 arch/x86/kvm/svm/svm.c    |  1 +
 2 files changed, 1 insertion(+), 15 deletions(-)


base-commit: 437bba5ad2bba00c2056c896753a32edf80860cc
-- 
2.42.0.655.g421f12c284-goog

