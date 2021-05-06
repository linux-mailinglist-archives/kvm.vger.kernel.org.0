Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79EB375269
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 12:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbhEFKfI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 06:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234443AbhEFKfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 06:35:05 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B03C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 03:34:06 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4FbVLP0fJWzQjx9;
        Thu,  6 May 2021 12:34:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        message-id:date:date:subject:subject:from:from:received; s=
        mail20150812; t=1620297241; bh=KSg8OBHMy9XZ/qF/svh0kP1dL0DArtxtX
        /X5djEOQHM=; b=v0xLBlmIkQ6DrFDUlg/9XfFoEIfnue1iaHkDM+2Uc+tryeP7+
        If7BuutlA2fGkkhsSZ7EMHwU8YdoTUyAkHuy1wAMcwZfpy+hwDflih5gzdEqoTyC
        NLFJJXZFBTRUyHqsjbI/ulr7ceCaOM/DSJrp26u8e6S0YeBWja4VfvIKj/dbF1sb
        qhoxi7Y63OSiAJxCcRraO/S6NUl0Xy4CT/uZ6i04zT3IDU8p06YAQA0Qgr6TLuoU
        w8g6nvHN1o7XwMxRPeEhQsIL4NCb3Z8/XS2aMzgWiZgIYXfrPQS7oIaHgsULmyLE
        mkP0h4K5nVoVpWa82tk2EEXMXD7RDlIH0sOKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1620297243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=o6UNy7s4Ky0OKTddd5MLvC/FJxKgZKt+z0XAH8iUwpY=;
        b=UpzbriPoVQtkUrkwo4ZtH+gJH9tpCek7NF4ZzAk+cnWUTls7ctC46ugmBL+i2MEk8KU5Tm
        rNrcbBAsLif1D5rBm83KwYEA1WlEvLMNCL9KJAdV7lpMiLUGjEI+2XT95lmbxxXD9Uq67E
        8TUEyIVie5i5l/UMV+XUsfhagNiHqbJaziG7HEm0Uph1ieFH8lNkEIShmJgye8LjT9+z+Z
        RIuf27uN5fLWz23BI4LH/pG1m33O0joD/x7vGqLuc9GjeD+mysRk0IQ/UEjuyaM1zoqsHJ
        02tPpE48c7XwMRYPkue88A4TAhPChGgiSl9ymRtlYSyZ/nU2to231vPzG+Ik4A==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id FYd6A0ERsLu4; Thu,  6 May 2021 12:34:01 +0200 (CEST)
From:   ilstam@mailbox.org
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     ilstam@amazon.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        haozhong.zhang@intel.com, zamsden@gmail.com, mtosatti@redhat.com,
        dplotnikov@virtuozzo.com, dwmw@amazon.co.uk
Subject: [PATCH 0/8] KVM: VMX: Implement nested TSC scaling
Date:   Thu,  6 May 2021 10:32:20 +0000
Message-Id: <20210506103228.67864-1-ilstam@mailbox.org>
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.11 / 15.00 / 15.00
X-Rspamd-Queue-Id: A98F71404
X-Rspamd-UID: 10da07
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ilias Stamatis <ilstam@amazon.com>

KVM currently supports hardware-assisted TSC scaling but only for L1 and it
doesn't expose the feature to nested guests. This patch series adds support for
nested TSC scaling and allows both L1 and L2 to be scaled with different
scaling factors.

When scaling and offsetting is applied, the TSC for the guest is calculated as:

(TSC * multiplier >> 48) + offset

With nested scaling the values in VMCS01 and VMCS12 need to be merged
together and stored in VMCS02.

The VMCS02 values are calculated as follows:

offset_02 = ((offset_01 * mult_12) >> 48) + offset_12
mult_02 = (mult_01 * mult_12) >> 48

The last patch of the series adds a KVM selftest.

Ilias Stamatis (8):
  KVM: VMX: Add a TSC multiplier field in VMCS12
  KVM: X86: Store L1's TSC scaling ratio in 'struct kvm_vcpu_arch'
  KVM: X86: Pass an additional 'L1' argument to kvm_scale_tsc()
  KVM: VMX: Adjust the TSC-related VMCS fields on L2 entry and exit
  KVM: X86: Move tracing outside write_l1_tsc_offset()
  KVM: VMX: Make vmx_write_l1_tsc_offset() work with nested TSC scaling
  KVM: VMX: Expose TSC scaling to L2
  KVM: selftests: x86: Add vmx_nested_tsc_scaling_test

 arch/x86/include/asm/kvm_host.h               |   8 +-
 arch/x86/kvm/svm/svm.c                        |   4 -
 arch/x86/kvm/vmx/nested.c                     |  32 ++-
 arch/x86/kvm/vmx/vmcs12.c                     |   1 +
 arch/x86/kvm/vmx/vmcs12.h                     |   4 +-
 arch/x86/kvm/vmx/vmx.c                        |  31 ++-
 arch/x86/kvm/x86.c                            |  54 ++++-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  | 209 ++++++++++++++++++
 10 files changed, 312 insertions(+), 33 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c

-- 
2.17.1

