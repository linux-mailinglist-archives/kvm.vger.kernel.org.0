Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 583FA11BE54
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 21:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfLKUsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 15:48:19 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:36387 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfLKUsS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 15:48:18 -0500
Received: by mail-pg1-f201.google.com with SMTP id i8so50418pgs.3
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 12:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2gC640IyhH5dA8WbV5f5/xeewX2HczJxP4vBYhavCEY=;
        b=QOXWFSPQYjnuJDMP0a4El8Kh5ujIbG0XtwVP1iVHds8uiUZsbjpHgG5WPdWl96GsCo
         q7mpMlt3B9pzVIYZHTKFtDCCu4Cvr0XBTzrrkwca0VvGL/x98Agf/uml2HXIsWn03J/l
         WoO+n1BkNjMXj+5AkWjhI5FAQqE+nZbr7cOSbOohyp/aWnmAVnsqkkfHpvoi7r8vgBUH
         sH301tcL19NGm1CgMJX76L3AFHahIWAjDQj43FZ32PTFZktgX/o2GS8BxEahhUYaBGVK
         7rzzv81Tk+0hZarU6nZi777LGxgGHFMLeu7JUR5JgFrTckNSQF4iBL6hi9nBElJsQ6iE
         /HjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2gC640IyhH5dA8WbV5f5/xeewX2HczJxP4vBYhavCEY=;
        b=H0iPTO1el2I/PeWu6K2xHuawx/neyPaT3OVtcaXawvIb22WHy4x7wEhEbrNghu4zKM
         vPH56zIFP3NcsMP19vtUkocTk4zqxXLAxRZZUVusgxV2FPLInwpF38UJFew0+hZwhnXc
         qlxuTQ5oBATqjGQ450ogBqRXg7cBDOTYFlbL9FAAlfYgH+3SWdQQzZ1in/WpyEf1FLVf
         /4qMZa8Di46D4+G7Exd/rUhkQ+XsgMjn+iknvyRHxb8QgfJ5E3RrzqGIpP0LKARohNSp
         LSm527TaV96fBjLvoJADr/HgNiuWh2icPTEJgljFvkpodjDUBKG+jRpCsgyUwGGcXOOm
         Ksrg==
X-Gm-Message-State: APjAAAVnoM/4YD0C5LQPUujpYieLdMhKhdlQPux9NDapMYSq5xk/Sxgy
        nWnk7AtDEtrPc+YEnqvLgXkmMJZgiA5U
X-Google-Smtp-Source: APXvYqwOL7uivEwokJX5aYM9537r8vrIEKgGR7nmvHWO9lF7B4kYZsHBsBQwsuUkGzh4uQRzcSr4YlBVlX8t
X-Received: by 2002:a63:c804:: with SMTP id z4mr6386725pgg.440.1576097297767;
 Wed, 11 Dec 2019 12:48:17 -0800 (PST)
Date:   Wed, 11 Dec 2019 12:47:40 -0800
Message-Id: <20191211204753.242298-1-pomonis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH v2 00/13] KVM: x86: Extend Spectre-v1 mitigation
From:   Marios Pomonis <pomonis@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>,
        Marios Pomonis <pomonis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nick Finco <nifi@google.com>

This extends the Spectre-v1 mitigation introduced in
commit 75f139aaf896 ("KVM: x86: Add memory barrier on vmcs field lookup")
and commit 085331dfc6bb ("x86/kvm: Update spectre-v1 mitigation") in light
of the Spectre-v1/L1TF combination described here:
https://xenbits.xen.org/xsa/advisory-289.html

As reported in the link, an attacker can use the cache-load part of a
Spectre-v1 gadget to bring memory into the L1 cache, then use L1TF to
leak the loaded memory. Note that this attack is not fully mitigated by
core scheduling; firstly when "kvm-intel.vmentry_l1d_flush" is not set
to "always", an attacker could use L1TF on the same thread that loaded the
memory values in the cache on paths that do not flush the L1 cache on
VMEntry. Otherwise, an attacker could perform this attack using a
collusion of two sibling hyperthreads: one that loads memory values in
the cache during VMExit handling and another that performs L1TF to leak
them.

This patch uses array_index_nospec() to prevent index computations from
causing speculative loads into the L1 cache. These cases involve a
bounds check followed by a memory read using the index; this is more
common than the full Spectre-v1 pattern. In some cases, the index
computation can be eliminated entirely by small amounts of refactoring.

Marios Pomonis (13):
  KVM: x86: Protect x86_decode_insn from Spectre-v1/L1TF attacks
  KVM: x86: Protect kvm_hv_msr_[get|set]_crash_data() from
    Spectre-v1/L1TF attacks
  KVM: x86: Refactor picdev_write() to prevent Spectre-v1/L1TF attacks
  KVM: x86: Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks
  KVM: x86: Protect ioapic_write_indirect() from Spectre-v1/L1TF attacks
  KVM: x86: Protect kvm_lapic_reg_write() from Spectre-v1/L1TF attacks
  KVM: x86: Protect MSR-based index computations in
    fixed_msr_to_seg_unit()
  KVM: x86: Protect MSR-based index computations in pmu.h
  KVM: x86: Protect MSR-based index computations from Spectre-v1/L1TF
    attacks in x86.c
  KVM: x86: Protect memory accesses from Spectre-v1/L1TF attacks in
    x86.c
  KVM: x86: Protect exit_reason from being used in Spectre-v1/L1TF
    attacks
  KVM: x86: Protect DR-based index computations from Spectre-v1/L1TF
    attacks
  KVM: x86: Protect pmu_intel.c from Spectre-v1/L1TF attacks

 arch/x86/kvm/emulate.c       | 11 ++++--
 arch/x86/kvm/hyperv.c        | 10 +++--
 arch/x86/kvm/i8259.c         |  6 ++-
 arch/x86/kvm/ioapic.c        | 15 +++++---
 arch/x86/kvm/lapic.c         | 13 +++++--
 arch/x86/kvm/mtrr.c          |  8 +++-
 arch/x86/kvm/pmu.h           | 18 +++++++--
 arch/x86/kvm/vmx/pmu_intel.c | 24 ++++++++----
 arch/x86/kvm/vmx/vmx.c       | 71 +++++++++++++++++++++---------------
 arch/x86/kvm/x86.c           | 18 +++++++--
 10 files changed, 129 insertions(+), 65 deletions(-)

-- 
2.24.0.393.g34dc348eaf-goog

