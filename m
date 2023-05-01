Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7056F35BE
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 20:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbjEASRc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 14:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjEASRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 14:17:31 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE90E1986
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 11:17:30 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-63b57ad54a1so1737360b3a.3
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 11:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682965050; x=1685557050;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VW4hRo+Gvj3mshwLHGNL+eZyG+HLSQyCRtGXMkS1FY0=;
        b=YLiiGxWxAxmp8hAvkGk/6eoUxo9wAzHpvxzso68ih6DEiBUhGff/JtcZpEZDhUXzpg
         uiP0t7hUPfECdkoft6Y4xemW499vI0cN0pMEBkZ9/h2CyeYLS2J0CyLJ+YnYxzZjUjRR
         xCVKpx3xnp3n+tpuLnUbVrgEj1h0Xo0+ZJOQ4eXwMPKq2+/utKSX0I2zfDpXpN0+qnYY
         K4/ivFxdwxvhjFttrPTLGXdPyjUSw0Qwaw4fud2I7XT9+vXD4VstvuNYx/Uk8Nsua43+
         ujszHoAuCNJjdZs2qDmTFmU7qWZNV0T7EtYDXDOHN8/F/HFv0U9NsvKJA7NXY9p0jQhV
         Hg0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682965050; x=1685557050;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VW4hRo+Gvj3mshwLHGNL+eZyG+HLSQyCRtGXMkS1FY0=;
        b=P5C98p5OPswdYHcua3wSPQ3zlzDX30Jxd+8wZZVlskFa764q4xBtbLDDrbmb0XslLC
         HC8UuN+9eYp9zw9HEC12sB+2e2tLKPx9kyfBMf57xAsy7zMiDIxvqBMWTzGoEHCOFNdu
         a5sEo6dlpPsgJd1VK1/mkyLZmyjn4YJ036vV2tXqmYcND9kTUrylIIc+ARWpwYhfdldf
         yqopH90ejndimBeIIvbcbbZXzYMUjaYYUIAGIw2pZicOVKRKHbhFLnq8z9sCv8FOUkZ+
         7t9iOaXeNOWlKT2wDQKdtldE1iFizYPRtGqBgIaaTk1rCLtInrbInOpMB2WDl7daTK0I
         Lqug==
X-Gm-Message-State: AC+VfDw0FAX7EmSNd3NtM5+Uhu4eBpTuJ4KLG5wYU5i7Uy5KkryxcYII
        aRwXoFQz++PLKhEL6faAs8rKFWQSd+c=
X-Google-Smtp-Source: ACHHUZ5GWRtMk4jkjGHwetdLZuqz5KDvH8qM/mOu3Z6b4QAMk/AFUvoGRRbP7bK2DyTHWZD6oY27ozWFj5I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:d56:b0:641:31b1:e787 with SMTP id
 n22-20020a056a000d5600b0064131b1e787mr2659785pfv.5.1682965050276; Mon, 01 May
 2023 11:17:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  1 May 2023 11:17:12 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230501181711.3203661-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Make valid TDP MMU roots persistent
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
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

Please pull the previously discussed persistent TDP MMU roots change.  This
specific commit has been in linux-next since April 26th, and the core
functionality of the patch has been in linux-next since April 21st (the
only tweak from v2=>v3 was to reintroduce a lockdep assertion with a more
robust guard against false positives).

The following changes since commit 9ed3bf411226f446a9795f2b49a15b9df98d7cf5:

  KVM: x86/mmu: Move filling of Hyper-V's TLB range struct into Hyper-V code (2023-04-10 15:17:29 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.4-2

for you to fetch changes up to edbdb43fc96b11b3bfa531be306a1993d9fe89ec:

  KVM: x86: Preserve TDP MMU roots until they are explicitly invalidated (2023-04-26 15:50:27 -0700)

----------------------------------------------------------------
Fix a long-standing flaw in x86's TDP MMU where unloading roots on a vCPU can
result in the root being freed even though the root is completely valid and
can be reused as-is (with a TLB flush).

----------------------------------------------------------------
Sean Christopherson (1):
      KVM: x86: Preserve TDP MMU roots until they are explicitly invalidated

 arch/x86/kvm/mmu/tdp_mmu.c | 121 +++++++++++++++++++++------------------------
 1 file changed, 56 insertions(+), 65 deletions(-)
