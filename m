Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2478367752
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbhDVCWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhDVCWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:22:06 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D057C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:21:31 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e13-20020a25d30d0000b02904ec4109da25so18092208ybf.7
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=rT4lxch1DR2GkeTff1L00Dgn8Fdap0zTJCYmiCzUm04=;
        b=cbcIiOk5g9BZdG2KVvbh+6RjHbqX9y7SeN0xmJONeDTbp0AU4mgpeZXGGc9onqiH7j
         ALVukuNejcJXSE9ZZsuEOXPMZ99xqJmbGkeb6NBt2OgJLu/kFxOGfJ9EfvIR7xrzNpTV
         aRubpMvyxW/RM1OS8WQKQgW4Ml+sha1KWodw1oDc3xgxIPvCvoWqZMPkQPuUkNslnPAk
         3C5iA+ki2W8awuG+lwnOa+tAEh4ZaK31XnNSZ5fthc/NNQ5S7IA3gGMNJGZwcMr+bIDR
         qb1U+4AF2f4X1HhS5v1oIv297Mf+ap3KPVfwObzRWk/ioW+d+Njju3yiAO1qw1nisDRV
         iB/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=rT4lxch1DR2GkeTff1L00Dgn8Fdap0zTJCYmiCzUm04=;
        b=jRLqjSfuumJ7K2jhwqH77RyI0pznEj0XGavFk0b5CmR2J2jIvfkNL58GvejRwpKgWz
         jpuxN6w76dNXYfkNzy8BPzZDyrFkG5whvmc8LymAN/WubwQhqRCe96ZlKC++EP1cP37Z
         hCRPCCEUfN61+PZsGWJIbFL+4J+zS0c8RLFDFBGhwMCnJvcCWmeGqldWD0olHEUIFZdz
         9T4d+QOYK+tOgAF3zjnhoUG5RUTIrF/2162j5BVS2IvMFjalEisOwO24sMH5MhF6Gnrp
         CSu8ULFIt01wxYI76HhxxsHXyu5tWNDhtR8aY3JVvY6T8xTXfdg11viRb7EYh1P+2T8/
         zN8w==
X-Gm-Message-State: AOAM532vHQhXFf8/WlMAo8OWxEa/D96emoziQkeOy/U82boa/YKDmoqK
        S8wESRvQnqD+1X7GdrbESxOSft4axaY=
X-Google-Smtp-Source: ABdhPJwPERXJ8ChGU08WyQVlfjTE3keyNalrjLGd3NiD+Dg08UYAQFyjxuxKTcJElOjwYxuZY+YCeKBIh/4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:b098:: with SMTP id f24mr1441373ybj.210.1619058090787;
 Wed, 21 Apr 2021 19:21:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:21:19 -0700
Message-Id: <20210422022128.3464144-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 0/9] KVM: x86: Fixes for (benign?) truncation bugs
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

v2: Rebase to kvm/queue, commit 89a22e37c8c2 ("KVM: avoid "deadlock"
    between install_new_memslots and MMU notifier")

v1: https://lkml.kernel.org/r/20210213010518.1682691-1-seanjc@google.com

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
 arch/x86/kvm/svm/svm.c        | 12 +++++--
 arch/x86/kvm/vmx/nested.c     | 14 ++++----
 arch/x86/kvm/vmx/vmx.c        |  6 ++--
 arch/x86/kvm/x86.c            | 19 ++++++----
 arch/x86/kvm/x86.h            |  8 ++---
 7 files changed, 48 insertions(+), 98 deletions(-)

-- 
2.31.1.498.g6c1eba8ee3d-goog

