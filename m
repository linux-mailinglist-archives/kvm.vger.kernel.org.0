Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064E331A939
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 02:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhBMBGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 20:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbhBMBGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 20:06:08 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23537C061574
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 17:05:28 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id j128so1602866ybc.5
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 17:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=QgASd7HymXzjEEBUQWt6fGnHVl+PB7ICzUP2iM3Rrog=;
        b=Tgygxik75WgrNARZrV/5F5ho2r1q1SBdQNic9CuSEBlCZFZP8DCDksNswPV0ke0Wrk
         3TdJSbrmfHLFiOPpsnA9jvJTdt/t2tSp5HZIT2tGjnQleO1DHaoVhO6EYO9uyKBZdxMR
         v2mBO6bq4otn26wi7JIzl3iCdfCPZIogwL9AhPwg8OAokLcIxFAj2GEvZ/iGjJv/QZsf
         AazciC9HWQ9px4fYON8kQyfB7/Ihe+M5hw9rVy9Ug4Go0DDUerKKRDYhlcLYPabvcWdU
         VLcZcdrMwPAdZjqY5gqtMfRH4IEe2CB3RLMR12WAO17pWkG7IMp4YtKqpOih8fKeC8A4
         iIMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=QgASd7HymXzjEEBUQWt6fGnHVl+PB7ICzUP2iM3Rrog=;
        b=HjEeKfPdyz4s/EsYt/vdnz26SpOZO4IMfmhDnqlrzCeHvNQExZxDYu6e2peppUM8Sv
         v4Q8OawSd5qZ2lzoFFW/SnFlUGOF9zQMhQy7Zi0JMbuIGDrRS5SwNtvu0KZnkczXa5fI
         rG9c8tyEBX9aI03Zi9u70QjCGo9JDFRMsix00+8K3tz5J+/Vs8mtoC0cC7CDB+3tVkQR
         IwcXVIJifoheMEjdb/41HCNFxpsU96qif5PeWXn9UkfnnjBxieU1AtcYYM9Fs1y3qmoM
         J7y6R36W6L24ioqjldfGOtgTGJq5o5i0zhM7zFEHKvQ2o/ZBKDPuE3c0Gji4fBnnmMu0
         LX2g==
X-Gm-Message-State: AOAM530sWgEdAVIESjSYry+D7S5yaBU3Q6DOGP9b1mSGLLeiAqN0sejr
        5xWYzHwXUEiofTpYaaVrI+jhoxazPjo=
X-Google-Smtp-Source: ABdhPJwYPLHaHaSEOaf5FEJAASrdsX6q+bTh8H9y+wEWFBwMBk5QOY6FIa2H9hhe7TWUMlnMPGrYPUVKHyU=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b407:1780:13d2:b27])
 (user=seanjc job=sendgmr) by 2002:a25:b41:: with SMTP id 62mr7713296ybl.34.1613178327442;
 Fri, 12 Feb 2021 17:05:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 Feb 2021 17:05:09 -0800
Message-Id: <20210213010518.1682691-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 0/9] KVM: x86: Fixes for (benign?) truncation bugs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patches 01 and 02 fix theoretical bugs related to loading CRs through
the emulator.  The rest of the patches are a bunch of small fixes for
cases where KVM reads/writes a 64-bit register outside of 64-bit mode.

I stumbled on this when puzzling over commit 0107973a80ad ("KVM: x86:
Introduce cr3_lm_rsvd_bits in kvm_vcpu_arch"), which stated that SEV
guests failed to boot on PCID-enabled hosts.  Why only PCID hosts?

After much staring, I realized that the initial CR3 load in
rsm_enter_protected_mode() would skip the MAXPHYADDR check due to the
vCPU not being in long mode.  But due to the ordering problems with
PCID, when PCID is enabled in the guest, the second load of CR3 would
be done with long mode enabled and thus hit the SEV C-bit bug.

Changing kvm_set_cr3() made me look at the callers, and seeing that
SVM didn't properly truncate the value made me look at everything else,
and here we are.

Note, I strongly suspect the emulator still has bugs.  But, unless the
guest is deliberately trying to hit these types of bugs, even the ones
fixed here, they're likely benign.  I figured I was more likely to break
something than I was to fix something by diving into the emulator, so I
left it alone.  For now. :-)

P.S. A few of the segmentation tests in kvm-unit-tests fail with
     unrestricted guest disabled, but those failure go back to at least
     v5.9.  I'll bisect 'em next week.

Sean Christopherson (9):
  KVM: x86: Remove emulator's broken checks on CR0/CR3/CR4 loads
  KVM: x86: Check CR3 GPA for validity regardless of vCPU mode
  KVM: SVM: Truncate GPR value for DR and CR accesses in !64-bit mode
  KVM: VMX: Truncate GPR value for DR and CR reads in !64-bit mode
  KVM: nVMX: Truncate bits 63:32 of VMCS field on nested check in
    !64-bit
  KVM: nVMX: Truncate base/index GPR value on address calc in !64-bit
  KVM: x86/xen: Drop RAX[63:32] when processing hypercall
  KVM: SVM: Use default rAX size for INVLPGA emulation
  KVM: x86: Rename GPR accessors to make mode-aware variants the
    defaults

 arch/x86/kvm/emulate.c        | 68 +----------------------------------
 arch/x86/kvm/kvm_cache_regs.h | 19 ++++++----
 arch/x86/kvm/svm/svm.c        | 11 ++++--
 arch/x86/kvm/vmx/nested.c     | 14 ++++----
 arch/x86/kvm/vmx/vmx.c        |  6 ++--
 arch/x86/kvm/x86.c            | 19 ++++++----
 arch/x86/kvm/x86.h            |  8 ++---
 7 files changed, 47 insertions(+), 98 deletions(-)

-- 
2.30.0.478.g8a0d178c01-goog

