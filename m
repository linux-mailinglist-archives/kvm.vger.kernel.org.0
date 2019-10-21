Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC4EDF8AC
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 01:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbfJUXdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 19:33:33 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:54356 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbfJUXdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 19:33:33 -0400
Received: by mail-pf1-f201.google.com with SMTP id s139so12126062pfc.21
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 16:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=DECjQWAQ8z8wZuignjSkrpe4WRRQhpm1lQFjhGtur9A=;
        b=AeaxkYbFxKwIIQVK84RXoPiEH3mmXWjOI5NhqR/O74rCeGPiizz7dWwCgSY+jDPFz7
         A8/Oxqzp6ausfkyxUsZ+khaS+JvMay71co7/8FtgFX7TtN7BLv2cqwGOnHeHHagZpHZS
         dqwJk4rCDm7fyQldDl8IwH5Y3AEwDXjHt4R+fWi7vw++2fh8pbUWDaIDkGdB1KvJFwi3
         T3eOoTrCgfueeeaEIHyfpUoQhTEYrVYwvDMqcTwmpeAOVqx+I8sD4lU97uH+00Z2f/cr
         4p0DE3p9jZp6yoX8ds73USgA9farLUD9XmA7CzZXO/SbwMOLYuOnvCeWCLh7F3rx1VIk
         qYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=DECjQWAQ8z8wZuignjSkrpe4WRRQhpm1lQFjhGtur9A=;
        b=sNh0OreelKt7T5nm4u8Lido2o85zGKo00wm352DqbMAcQIN1pOFhhftzsPzKG5BRvM
         lOwVBn6A0C86jhat6n98A8K/dIpSgviCEeUJW3uFxz5HrQWAXfF7AhNpf9NORZHRf3+P
         1ZKQSbDdJBLHf9HBD9O7iy++WxsbCwIrnBkn8mUL4guGWz0TOSeoiE8kw4uLfKBq18IQ
         hTQZrUm6fs2pxrVC+C51lwdcWVWhzucrtkbbyCrhFn0kLWmr1+degBTZ76aXMKKhGI4i
         /T4+nKBiBzr+TF1v/7plK+/7baRBoRS14JwC4VhQ53tcXT8Jy2a057HbO/KCCtCluL4X
         utEA==
X-Gm-Message-State: APjAAAVydVHUbxNy2csT58ERLcv1FnxKbZzYIak1nfLKpG8//wYKBxeG
        4U+PGu3EVF4aZmQfliBXua8IAJ5PhZxAfFDW
X-Google-Smtp-Source: APXvYqwhogW8fMY1A6mAaigEQuglE471ounh+hJXMjRUI23EOrctOJc8ErdL63LxkT/if+FBJZNpef9V8F6TYd9t
X-Received: by 2002:a63:7405:: with SMTP id p5mr461781pgc.264.1571700812016;
 Mon, 21 Oct 2019 16:33:32 -0700 (PDT)
Date:   Mon, 21 Oct 2019 16:30:19 -0700
Message-Id: <20191021233027.21566-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v3 0/9] Add support for XSAVES to AMD and unify it with Intel
From:   Aaron Lewis <aaronlewis@google.com>
To:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unify AMD's and Intel's approach for supporting XSAVES.  To do this
change Intel's approach from using the MSR-load areas to writing
the guest/host values to IA32_XSS on a VM-enter/VM-exit.  Switching to
this strategy allows for a common approach between both AMD and Intel.
Additionally, define svm_xsaves_supported() based on AMD's feedback, and add
vcpu->arch.xsaves_enabled to track whether XSAVES is enabled in the guest.

This change sets up IA32_XSS to be a non-zero value in the future, which
may happen sooner than later with support for guest CET feature being
added.

v2 -> v3:
 - Remove guest_xcr0_loaded from kvm_vcpu.
 - Add vcpu->arch.xsaves_enabled.
 - Add staged rollout to load the hardware IA32_XSS MSR with guest/host
   values on VM-entry and VM-exit:
     1) Introduce vcpu->arch->xsaves_enabled.
     2) Add svm implementation for switching between guest and host IA32_XSS.
     3) Add vmx implementation for switching between guest and host IA32_XSS.
     4) Remove svm and vmx implementation and add it to common code.

v1 -> v2:
 - Add the flag xsaves_enabled to kvm_vcpu_arch to track when XSAVES is
   enabled in the guest, whether or not XSAVES is enumerated in the
   guest CPUID.
 - Remove code that sets the X86_FEATURE_XSAVES bit in the guest CPUID
   which was added in patch "Enumerate XSAVES in guest CPUID when it is
   available to the guest".  As a result we no longer need that patch.
 - Added a comment to kvm_set_msr_common to describe how to save/restore
   PT MSRS without using XSAVES/XRSTORS.
 - Added more comments to the "Add support for XSAVES on AMD" patch.
 - Replaced vcpu_set_msr_expect_result() with _vcpu_set_msr() in the
   test library.

Aaron Lewis (9):
  KVM: x86: Introduce vcpu->arch.xsaves_enabled
  KVM: VMX: Fix conditions for guest IA32_XSS support
  KVM: x86: Remove unneeded kvm_vcpu variable, guest_xcr0_loaded
  KVM: SVM: Use wrmsr for switching between guest and host IA32_XSS on AMD
  KVM: VMX: Use wrmsr for switching between guest and host IA32_XSS on Intel
  KVM: x86: Move IA32_XSS-swapping on VM-entry/VM-exit to common x86 code
  kvm: x86: Move IA32_XSS to kvm_{get,set}_msr_common
  kvm: svm: Update svm_xsaves_supported
  kvm: tests: Add test to verify MSR_IA32_XSS

 arch/x86/include/asm/kvm_host.h               |  1 +
 arch/x86/kvm/svm.c                            |  9 ++-
 arch/x86/kvm/vmx/vmx.c                        | 41 ++--------
 arch/x86/kvm/x86.c                            | 52 ++++++++++---
 arch/x86/kvm/x86.h                            |  4 +-
 include/linux/kvm_host.h                      |  1 -
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/include/x86_64/processor.h  |  7 +-
 .../selftests/kvm/lib/x86_64/processor.c      | 72 +++++++++++++++---
 .../selftests/kvm/x86_64/xss_msr_test.c       | 76 +++++++++++++++++++
 11 files changed, 205 insertions(+), 60 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/xss_msr_test.c

-- 
2.23.0.866.gb869b98d4c-goog

