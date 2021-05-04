Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4EC372E9A
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbhEDRSi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbhEDRSi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:18:38 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A427C06174A
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:17:43 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id t14-20020ac8588e0000b02901bc2b5853b1so4020621qta.16
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=2xWZdvogf0ze6g50j9Z7ywuPrceLwwW3g11yg2g3TOs=;
        b=SmbCPjuSQLSJNYSCAdiifnXtT/H2AqQdTpZINcEF/GfIcUtCzvYZjSYKvxQr4162hD
         kj9ZAGJTnxgB3dSb0COCqb10XIlyOqpmfOj5LZcjJB8vHUp+siIFwCfaViiQ5IV3++xp
         xrVcVf8esLJnkhfNGkLSdivxNqkxVFWaXP5fbP63rQ+8AW3I0lNo2g/f5ypcM/ij+pYI
         5Z/iIv0+hgMICMEkPSt1Pkrk62Ji5SooQ33z8NC9lcbU8EiW7tRJ8M6BFvJXEpvdifJT
         RKhi+zeuiI2+Wj1RfEzML/Eolp6rKf+/Sg+yu5osyK9toW9SL4x055MzPOj0z2sr19uc
         6lqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=2xWZdvogf0ze6g50j9Z7ywuPrceLwwW3g11yg2g3TOs=;
        b=Z1ZMT4Vkgy2mq4zvZMXZvF8VAiSuDaYCQ/Jx1GO6093ywuGZ21iCwSEWOjS2MUYK8r
         ESa5xl9qOyyGMpVonXzV7F+6c2ZG/xItE//Edru7IZSpXCdLgIFBYWn2S8wgPuTpMdPL
         KmQNU0EIWXwnNffQDKvjvuRlf7MA9XjKZgzgcjfmetzRAbBEZxrRMeYr4IwI5reLhhsi
         927SlkiV94lUU40D34rHOMoZ0VJleTDrEjJGPNBFrJwIyGYd/RMLyqUfZjejTX/FL9YV
         qHj4/GI4NRNdPCNB+JrIWEaA/18hqwSAtNrd4OXW0xiKkyj6+sx77huLE6GO9qpP5NkC
         iEWw==
X-Gm-Message-State: AOAM533O/8i6te8qaKoBSh/xAMNgaCPuugzoep10+GR1oxdAehn0iSSt
        0dkuWnIofnjvWFt4CkJVDSdpf2U6rS0=
X-Google-Smtp-Source: ABdhPJwt+/Q+KjHniWgBRhccJXjTUe7IsrkwWMn8aXCHIW6G12CoJJY+nIbZ5i4yEccmX/qSaYnPw8KZxKU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:a0c:c488:: with SMTP id u8mr26264785qvi.47.1620148662633;
 Tue, 04 May 2021 10:17:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 10:17:19 -0700
Message-Id: <20210504171734.1434054-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH 00/15] KVM: x86: RDPID/RDTSCP fixes and uret MSR cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a continuation of a less ambitious effort to unify MSR_TSC_AUX
handling across SVM and VMX.  Reiji pointed out that MSR_TSC_AUX exists if
RDTSCP *or* RDPID is supported, and things went downhill from there. 

The first half of this series fixes a variety of RDTSCP and RDPID related
bugs.

The second half of the series cleans up VMX's user return MSR framework
and consolidates more of the uret logic into common x86.

The last two patches leverage the uret MSR cleanups to move MSR_TSC_AUX
handling to common x86 and add sanity checks to guard against misreporting
of RDPID and/or RDTSCP support.

This will conflict with my vCPU RESET/INIT cleanup series.  Feel free to
punt the conflicts to me.

Other "fun" things to tackle:

 - The kernel proper also botches RDPID vs. RDTSCP, as MSR_TSC_AUX is
   configured if RDTSCP is supported, but is consumed if RDPID is
   supported.  I'll send this fix separately.

 - Commit 844d69c26d83 ("KVM: SVM: Delay restoration of host MSR_TSC_AUX
   until return to userspace") unwittingly fixed a bug where KVM would
   write MSR_TSC_AUX with the guest's value when svm->guest_state_loaded
   is false, which could lead to running the host with the guest's value.
   The bug only exists in 5.12 (maybe 5.11 too?), so crafting a fix for
   stable won't be too awful.

Sean Christopherson (15):
  KVM: VMX: Do not adverise RDPID if ENABLE_RDTSCP control is
    unsupported
  KVM: x86: Emulate RDPID only if RDTSCP is supported
  KVM: SVM: Inject #UD on RDTSCP when it should be disabled in the guest
  KVM: x86: Move RDPID emulation intercept to its own enum
  KVM: VMX: Disable preemption when probing user return MSRs
  KVM: SVM: Probe and load MSR_TSC_AUX regardless of RDTSCP support in
    host
  KVM: x86: Add support for RDPID without RDTSCP
  KVM: VMX: Configure list of user return MSRs at module init
  KVM: VMX: Use flag to indicate "active" uret MSRs instead of sorting
    list
  KVM: VMX: Use common x86's uret MSR list as the one true list
  KVM: VMX: Disable loading of TSX_CTRL MSR the more conventional way
  KVM: x86: Export the number of uret MSRs to vendor modules
  KVM: x86: Move uret MSR slot management to common x86
  KVM: x86: Tie Intel and AMD behavior for MSR_TSC_AUX to guest CPU
    model
  KVM: x86: Hide RDTSCP and RDPID if MSR_TSC_AUX probing failed

 arch/x86/include/asm/kvm_host.h |   9 +-
 arch/x86/kvm/cpuid.c            |  18 ++-
 arch/x86/kvm/emulate.c          |   2 +-
 arch/x86/kvm/kvm_emulate.h      |   1 +
 arch/x86/kvm/svm/svm.c          |  50 +++-----
 arch/x86/kvm/vmx/vmx.c          | 217 ++++++++++++++++----------------
 arch/x86/kvm/vmx/vmx.h          |  12 +-
 arch/x86/kvm/x86.c              | 101 ++++++++++++---
 8 files changed, 245 insertions(+), 165 deletions(-)

-- 
2.31.1.527.g47e6f16901-goog

