Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E50D1ED9AB
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 01:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgFCX4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 19:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFCX4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 19:56:34 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3B9C08C5C0
        for <kvm@vger.kernel.org>; Wed,  3 Jun 2020 16:56:34 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f1so5789838ybg.22
        for <kvm@vger.kernel.org>; Wed, 03 Jun 2020 16:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=EsZQLrQJSyQkCuychfLvZShzcqdD0cO40o8NeAVTCg4=;
        b=uwolmXfgFAS8XqOUCJRYeSP9tBcD28EZGy7cE87FemkA03JAewLvSs+O7ERJhNgV/i
         ER/QP0m/V7fUbP1CeSoT40APWPH0VVBhpvM/00MoWlU+/sZHs97Rdhos0U0+MAKD2FZQ
         eaeFbBfDV+ov2uhmYuAa3RC1KOQO10VK9Z2gSU/SM6715/5v74cymoNBGLu5MAxhT/pL
         btGyxK1JOLPJBAIi9aNaRk84hsFB8ErULC6FoELzxdJBA8MjC/e2p44JTnB8Ugfrp0tU
         3/ZBs1C9Vo89vxV7jkcpU0xkGS1BX1x0FdpdMqMmu7ZcuT036Um6yJbZBv7ZYs9uASIL
         jS1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=EsZQLrQJSyQkCuychfLvZShzcqdD0cO40o8NeAVTCg4=;
        b=fuere1eeHEuO49IsKgUjdnIq7hqn3fPhTWrPRYPy41tVnLucUccgPZ1r1vQOeFaiaE
         o7Ix7QeyLpTKDacS1YmaUsesALuGkL4h2gwtiZ0L3374ml8zx4JBRgI2WmeyLWxpiY7l
         ge9kULLM4S/Mwv4iqClILVvkEOLEp+VwNEdjHWYx++RPhwlYUoDUEYMd+AqYAIgJG7/U
         r/x+wahuJQRJWD8qNxkOG0fEQxp8poAflPiHnjwOEttpRaxtBzGxId3jVxIndZXm3vuW
         t5ZwX0d/Lr+o/kVkWX6YKdTPVPjSAI+jjwJ/RznitP3iM+MVrYHaQ0cl2ImC3hnfN81X
         Q0ug==
X-Gm-Message-State: AOAM532l/ex9wonVostK2fl2DFHj6aGJX5eT/K0yT9KWYxmvFEIetoLr
        GykqEnrorxLJ7/fG3Oedy20dYZtq6214t0YR6yptOukn/OpcH+n7iYDghcwXnOFWwug4Syd+98R
        kCSI8zJc/IPG7N0n3IqKvEWd+eI6vcFMC5AHaqa3Q/9+LwNP5i+SkK4FHlwibrbk=
X-Google-Smtp-Source: ABdhPJxno+nOSexygeYoHCLZ4k6gWIvEg51BNYbMvry31Jignjp1TjgK1HkFAPJyFXj47wxAVi/xFKLoXXf8qA==
X-Received: by 2002:a25:99c8:: with SMTP id q8mr3822487ybo.3.1591228593204;
 Wed, 03 Jun 2020 16:56:33 -0700 (PDT)
Date:   Wed,  3 Jun 2020 16:56:17 -0700
Message-Id: <20200603235623.245638-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
Subject: [PATCH v4 0/6] Add logical CPU to KVM_EXIT_FAIL_ENTRY info
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's been about 6 months since v2. Sorry for the delay. Initially, this
was a single patch to add information to KVM_EXIT_FAIL_ENTRY to help
identify a defective CPU. It has gotten a little more complicated,
since Peter Shier pointed out that the vCPU thread may have migrated
between the time of failure and the KVM exit. Fortunately, the SEV folks
started to make the necessary information available with "last_cpu," but
only on AMD and only with SEV. The current version expands upon that by
making "last_cpu" available in all configurations on AMD and Intel.

v2: Use vcpu->cpu rather than raw_smp_processor_id() (Liran).
v3: Record the last logical processor to run the vCPU thread (Peter).
    Add the "last CPU" information to KVM_EXIT_INTERNAL_ERROR exits as
    well as KVM_EXIT_FAIL_ENTRY [except for "EMULATION" errors].
    (Liran & Paolo).
v4: Move last_cpu into kvm_vcpu_arch as last_vmentry_cpu, and set this
    field in vcpu_enter_guest (Sean).

Jim Mattson (6):
  kvm: svm: Prefer vcpu->cpu to raw_smp_processor_id()
  kvm: svm: Always set svm->last_cpu on VMRUN
  kvm: vmx: Add last_cpu to struct vcpu_vmx
  kvm: x86: Add "last CPU" to some KVM_EXIT information
  kvm: x86: Move last_cpu into kvm_vcpu_arch as last_vmentry_cpu
  kvm: x86: Set last_vmentry_cpu in vcpu_enter_guest

 Documentation/virt/kvm/api.rst  |  1 +
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/svm/sev.c          |  3 +--
 arch/x86/kvm/svm/svm.c          | 13 ++++++-------
 arch/x86/kvm/svm/svm.h          |  3 ---
 arch/x86/kvm/vmx/vmx.c          | 10 ++++++++--
 arch/x86/kvm/x86.c              |  2 ++
 include/uapi/linux/kvm.h        |  2 ++
 8 files changed, 23 insertions(+), 14 deletions(-)

-- 
2.27.0.rc2.251.g90737beb825-goog

