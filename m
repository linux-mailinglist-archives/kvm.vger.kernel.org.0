Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B097570DB4
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 00:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiGKW55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 18:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiGKW54 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 18:57:56 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1D27E03F
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 15:57:55 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l16-20020a170902f69000b0016bf6a77effso4528544plg.2
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 15:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=8lbFNJS9mZLEnNAVzNRXBcrMEjTr/r9Ec5unYJJecmg=;
        b=YXREVBWZaz8Z10PkbJfyE2n8KjqCgFZBLq5wVuKzpzWyBtmTc8kvS833XqvcfPjtNm
         PTeu7fdtuQlcoL69C1FQCHTbA0OFRln/rztMlZajMTY0Vj7CoYDYslh9PNm9/yW/06EB
         Nv1Qke9xgOKjCXodIT9eTvuuSdFF9odZeAIIyOL5omilYUGj0eCBh5jq2T5xF9n6V2yQ
         TxuzY5zS399IfATNC+FMaq6TlvI4vGL+m18K9MiTV5zG1qp0Yp01IB+qfQf3UFipzZp3
         4oPsl+tsyW8Jnm0q8a4xCkXXyEfys1pPIsxZBSZJiBo5TE50zIZXMwT8U3x05R4AbEQl
         mvSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=8lbFNJS9mZLEnNAVzNRXBcrMEjTr/r9Ec5unYJJecmg=;
        b=ccAG6nBFJpHuDZGfe1IKka6HchVyuUnT3kK1CM7cQEw7cWNlBdJLO+FxyWd6O/INzP
         zXg1HHmKesytAq9iDcC8l6PSvrBkG1tcNTNSa6wrihLSEZjCNWtF5Y98kQNSIEPLDmYw
         FMSVV6pWiJFd8U2LSgk+v4FMfwGLnsSbJgC0Y7wAuShyXDnl3alKvT3R6WCr4qxYYFrq
         7WkhiRpEASD7dXo2kWIoGyd8PhC8u/+Oi27ZU2eLW2FgUkQGAgccF1mscYwX38dusvyk
         fEl01hcvStJcgqf9atfvS2JwraoVTMCIEX9LFsmKg47/bQKRi2ilnlzHdVyEEVTCkYgg
         AwNg==
X-Gm-Message-State: AJIora9PcWdCxblqSKZQREBSzsIkntvIC0NHIG+NrNUjV/Caehrz4+93
        lxwNsBWjCL3Rre1iVbg4kjR+nZI8Lg8=
X-Google-Smtp-Source: AGRyM1v3IoUTLKRUbg8JYiEg9MmKrRx8rnsHEhQVtDINuG9txKyQDM+rt/FZBJdE0OiPDhf+VpN4wsdUgBw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a502:b0:151:8289:b19 with SMTP id
 s2-20020a170902a50200b0015182890b19mr20872765plq.149.1657580275295; Mon, 11
 Jul 2022 15:57:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 11 Jul 2022 22:57:50 +0000
Message-Id: <20220711225753.1073989-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH 0/3] KVM: x86: Fix goofs with MONITOR/MWAIT quirk
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@linux.intel.com>
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

Fix two bugs in the MONITOR/MWAIT selftest, and tweak the name of the
quirk (which isn't yet set in stone) to clarify that it only applies to
the #UD behavior, i.e. to reserve the right to correctly emulate #GP and
other faults in the future even if the quirk is enabled.

Sean Christopherson (3):
  KVM: selftests: Test MONITOR and MWAIT, not just MONITOR for quirk
  KVM: selftests: Provide valid inputs for MONITOR/MWAIT regs
  KVM: x86: Tweak name of MONITOR/MWAIT #UD quirk to make it #UD
    specific

 Documentation/virt/kvm/api.rst                         |  2 +-
 arch/x86/include/asm/kvm_host.h                        |  2 +-
 arch/x86/include/uapi/asm/kvm.h                        |  2 +-
 arch/x86/kvm/x86.c                                     |  2 +-
 .../testing/selftests/kvm/x86_64/monitor_mwait_test.c  | 10 +++++++---
 5 files changed, 11 insertions(+), 7 deletions(-)


base-commit: b9b71f43683ae9d76b0989249607bbe8c9eb6c5c
-- 
2.37.0.144.g8ac04bfd2-goog

