Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A62349D09B
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 18:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243660AbiAZRWg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 12:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243292AbiAZRW3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 12:22:29 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A89C06161C
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 09:22:29 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id u24-20020a656718000000b0035e911d79edso33989pgf.1
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 09:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=4zdqvDRcKscDm+lnZv7gUuJZV8rrHFi40CWOKIaL7JI=;
        b=aB+N+NsJ2bzr0imFihYSeflE2CQvIUancoVRwZRxvgRXBSsvH6WyZ4qorMMtoLiPoK
         mzU/8QfNGqpuc9LHzoEr0ykFebxxw3UdHeAUjPE8+Rnk98TZ7rismWQmnL2dkhEm/DrQ
         gxyeHvYimaS3vwQC7N5m0RQJbtvlsIwxSfO2PRpyBNAebd8JqcWrS7jIADG2tLt0S1A4
         6hFjoxBfbK7q0JkSH25T6AggzpUyqVFCaV9SnZiqXbwSk0+9/iBu5FscSkAKbXQMbsc/
         TE5ZL0VeANPHRAMEdwJDaSe3NmT+vJWASJNoM/1QADyxXrUcruPmPe4fFOcmtufrlRcQ
         dxtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=4zdqvDRcKscDm+lnZv7gUuJZV8rrHFi40CWOKIaL7JI=;
        b=1K1ai1ydZZhcLUPjovRPf3hXZ0RbVzM30LYRf4k92HNNVxEJdBjd/QMVKlKkkEmOGS
         U4ybhtRToW6zGQiItHMZL2f7XU9QtIm42KZ9gxrC2J9Et4/EdtfXxbFX4eaTQ+wSgdng
         2rcJL7OKcdq/m39H40TGedcOuVE3vtpg98+Al+/aPJ1gxL8Il4ju9boRBGl5+xTtRBsc
         DilPUrwCtVm8R3KKIolQQ2QYCHIpJ34idyMNIngvr2KQKVnRK50Ttvf56KS2/gdHeu7R
         F0KcjiYPkd0nxoFjnQ2OElztprz/Ij2fb0DTG0ZNFrldHxvB9DF2rrE2CvPHfPQ2anYo
         Y/dw==
X-Gm-Message-State: AOAM533E5aChTlFSlhfm2BOpeckKcY58KwPjPI4nuYpjiK2BjZoRlATb
        FQ6tDvDfFHWaQlFQcpeIVzcYoAsvJ4Q=
X-Google-Smtp-Source: ABdhPJze6iHI9zyjeiCDEqcUR8gsQq0yQvuwzmzW1OiviDNX4h/PXCj4/Sox6hvyBgl/o0xftcyY4xt5PJM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:bf08:b0:14a:bb95:6980 with SMTP id
 bi8-20020a170902bf0800b0014abb956980mr24265454plb.139.1643217749066; Wed, 26
 Jan 2022 09:22:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 26 Jan 2022 17:22:23 +0000
Message-Id: <20220126172226.2298529-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 0/3] KVM: x86: XSS and XCR0 fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For convenience, Like's patch split up and applied on top of Xiaoyao.
Tagged all for @stable, probably want to (retroactively?) get Xiaoyao's
patch tagged too?
 
Like Xu (2):
  KVM: x86: Update vCPU's runtime CPUID on write to MSR_IA32_XSS
  KVM: x86: Sync the states size with the XCR0/IA32_XSS at, any time

Xiaoyao Li (1):
  KVM: x86: Keep MSR_IA32_XSS unchanged for INIT

 arch/x86/kvm/x86.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


base-commit: e2e83a73d7ce66f62c7830a85619542ef59c90e4
-- 
2.35.0.rc0.227.g00780c9af4-goog

