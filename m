Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4273412ADF
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 04:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241482AbhIUCCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 22:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238064AbhIUB5D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 21:57:03 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8717C06B668
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:06 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id o7-20020a05622a138700b002a0e807258bso192298383qtk.13
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=cTtFFhZS/6D7sjIC0eSf55DYdfH2WRALnDh/1lgXOGA=;
        b=mPqGGYBZfXTozJoaH1j0ZOMMlLdWJDzCpOwa+X82RZz074i6YgQpzxGhrQFIPEFRRI
         YFQaGAOP7zUtK2jVdorV3ra3hxOyVpDHLrruS8b2lVYRJlOGIEikgUd6czhd7G0z+Uv3
         f83X75swRZUSwCc/5GAlKfA/na135JDNxISFfqEzJ5YtaW9rSmc3SPaT87uhB/OOkdLC
         vTOfsWhmen8iYa1ykUqdlqUarrCmb3z5yktQl2dirpvsrUN98SC0uuGS0gj89yK24Eos
         HuJ5yOFPvX/X0v4CyF75c3xnJFay0OiW6aiGAc9vuJUTmklKJ84CJ6bgio0msPA9beAj
         rRww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=cTtFFhZS/6D7sjIC0eSf55DYdfH2WRALnDh/1lgXOGA=;
        b=J8dhgiifpIXPh8O73LmYp3C/ZYNGUEg4I9Iet3qT0D2nrhhn2hccNkNJ/q7eEEQxk+
         JE6WX6KobwessYkaI8Y0Q68l15Tw5Q4xJDMeoD+uEB34c6ewJCkeO/LR9PiL9//nZqF2
         4gi0jqMWD27cxc8/5C6O7b/YD/VqCVwg51/7ol1EJla/7yceA4MDh80yPLmvk69l3NKT
         pHTLADXy4L0JBLlT8Rp8qCDfHJCFk2Afne8wKmDXGT05SYVu5TmCfTwCo9VTetqxwIFm
         oTFBsPAVCRqVhND1M3QIhjjJcMKjtEA45p7UcXT/S8aURA2pGwWe1EiXqu632hbZcEFO
         9WGw==
X-Gm-Message-State: AOAM532PHL67Col7b2RPp3GsMCPFyAgz4sYjbrSilshwxilNTmXiGPqz
        2DoMdktzW0bvucYK5+UEGhoaqmI8Y30=
X-Google-Smtp-Source: ABdhPJxsmXE/uShIuD0GALsHqgqcgBkSBOtoRXS6l2OVCLHiZ6n7yYUsZnXjmlZ4mGcvDBrJ/LMx86sZ5C0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e430:8766:b902:5ee3])
 (user=seanjc job=sendgmr) by 2002:a05:6214:13cd:: with SMTP id
 cg13mr28202964qvb.51.1632182586086; Mon, 20 Sep 2021 17:03:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 20 Sep 2021 17:02:53 -0700
Message-Id: <20210921000303.400537-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 00/10] KVM: x86: Clean up RESET "emulation"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add dedicated helpers to emulate RESET (or at least, the parts of RESET
that KVM actually emulates) instead of having the relevant code scattered
throughout vcpu_create() and vcpu_reset().

Vitaly's innocuous suggestion to WARN on non-zero CR0 led to a wonderful
bit of git archaeology after, to my complete surprise, it fired on RESET
due to fx_init() setting CR0.ET (and XCR0.FP).

v2:
 - Add patches to drop defunct fx_init() code.
 - Add patch to zero CR3 at RESET/INIT. 
 - Add patch to mark all regs avail/dirty at creation, not at RESET/INIT.
 - Add patch to WARN if CRs are non-zero at RESET. [Vitaly]

v1: https://lkml.kernel.org/r/20210914230840.3030620-1-seanjc@google.com

Sean Christopherson (10):
  KVM: x86: Mark all registers as avail/dirty at vCPU creation
  KVM: x86: Clear KVM's cached guest CR3 at RESET/INIT
  KVM: x86: Do not mark all registers as avail/dirty during RESET/INIT
  KVM: x86: Remove defunct setting of CR0.ET for guests during vCPU
    create
  KVM: x86: Remove defunct setting of XCR0 for guest during vCPU create
  KVM: x86: Fold fx_init() into kvm_arch_vcpu_create()
  KVM: VMX: Drop explicit zeroing of MSR guest values at vCPU creation
  KVM: VMX: Move RESET emulation to vmx_vcpu_reset()
  KVM: SVM: Move RESET emulation to svm_vcpu_reset()
  KVM: x86: WARN on non-zero CRs at RESET to detect improper
    initalization

 arch/x86/kvm/svm/sev.c |  6 ++--
 arch/x86/kvm/svm/svm.c | 29 ++++++++++--------
 arch/x86/kvm/svm/svm.h |  2 +-
 arch/x86/kvm/vmx/vmx.c | 68 ++++++++++++++++++++----------------------
 arch/x86/kvm/x86.c     | 44 +++++++++++++--------------
 5 files changed, 76 insertions(+), 73 deletions(-)

-- 
2.33.0.464.g1972c5931b-goog

