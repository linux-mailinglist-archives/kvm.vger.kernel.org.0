Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653E43DE00A
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 21:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhHBT2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 15:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhHBT2X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 15:28:23 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29237C06175F
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 12:28:14 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id cb3-20020ad456230000b02903319321d1e3so13760267qvb.14
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 12:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7p7mJlnVfl7T+hlkAFYQVL3Is2jTnSQaIAIQgTOcTTk=;
        b=OY292XYyvnBQO68s2vxsf3lDot6Bl03ugOYkZXMJ9nkuBk+VuvbVvn/odIPpSKl276
         xD0eqPI8jPoX/TF86opk9ZaMJQWa2HRJOq94tzbxlPWK8vES8KnmkizzX+2ms4SdkJJ6
         OAEGDsS4vYub5LQa1QcPWHWhWX9ACr/85Dk+uBeK3Sgz0w17r8COtDiuMi5Eq4Hpqqcy
         FgTth+PT7AlHU0Y4O1Ql51fYFcVknWX7ukp6pFJ/ozpKLOPNo0Mma784d+wGq25wDBsO
         8sl1aV66fmgfyNYGSCjjzQaZZDi76dVnOSRnA0hS9eEjO/QAPnioTibV1YLced4eE/us
         9tLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=7p7mJlnVfl7T+hlkAFYQVL3Is2jTnSQaIAIQgTOcTTk=;
        b=pqz+8XrAgk0C/KJrfaA0o0b/ojyv7y+5LzsXzqHAOJ0zoknfyzuMNSjzdTP6JBR836
         4jD9vQ+Eba0Sig+i4f4fFL5u7ufg0kVV0euu6zA1ilqCf0LWedOLugy4P50GmXVq9V5d
         dorJ5mR2957Sp/wTzQpUnQgOaSBnba8UisrleMUyG5i5FUc0RdCulKuRgKVGqrCkSvg/
         qgH0Z4l6k8csPr5Gi8DAgOdmXib4UaHgrKr1qB2UprE105rkAJ/ov+TuY2BKEkCiu6wc
         JDBHRqrXBtOdZt+W5EUNvOmTgvQbY+/pUA9h6fBfJvEBP/sFKaF0VjOTGUHeFUfeVOmV
         BtUA==
X-Gm-Message-State: AOAM531toi0THBR0Arpw2B0/4+gmnIRF8Ku8buD+THilTmpfDZMWdw0H
        ronAn711FSgQEFXKI8hSr8O6WiVMZok=
X-Google-Smtp-Source: ABdhPJwgN1HZ3KJQEcy/2zN9k/TS5BpBTtk4TBxtE7nS2taL/Exse1zhnY7xm/INDrcGXMRjZGi0yvlXbY0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:18c7:: with SMTP id
 cy7mr17647152qvb.59.1627932493300; Mon, 02 Aug 2021 12:28:13 -0700 (PDT)
Date:   Mon,  2 Aug 2021 19:28:06 +0000
Message-Id: <20210802192809.1851010-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v3 0/3] KVM: arm64: Use generic guest entry infrastructure
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Guangyu Shi <guangyus@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The arm64 kernel doesn't yet support the full generic entry
infrastructure. That being said, KVM/arm64 doesn't properly handle
TIF_NOTIFY_RESUME and could pick this up by switching to the generic
guest entry infrasturture.

Patch 1 adds a missing vCPU stat to ARM64 to record the number of signal
exits to userspace.

Patch 2 unhitches entry-kvm from entry-generic, as ARM64 doesn't
currently support the generic infrastructure.

Patch 3 replaces the open-coded entry handling with the generic xfer
function.

This series was tested on an Ampere Mt. Jade reference system. The
series cleanly applies to kvm/queue (note that this is deliberate as the
generic kvm stats patches have not yet propagated to kvm-arm/queue) at
the following commit:

8ad5e63649ff ("KVM: Don't take mmu_lock for range invalidation unless necessary")

v1 -> v2:
 - Address Jing's comment
 - Carry Jing's r-b tag

v2 -> v3:
 - Roll all exit conditions into kvm_vcpu_exit_request() (Marc)
 - Avoid needlessly checking for work twice (Marc)

v1: http://lore.kernel.org/r/20210729195632.489978-1-oupton@google.com
v2: http://lore.kernel.org/r/20210729220916.1672875-1-oupton@google.com

Oliver Upton (3):
  KVM: arm64: Record number of signal exits as a vCPU stat
  entry: KVM: Allow use of generic KVM entry w/o full generic support
  KVM: arm64: Use generic KVM xfer to guest work function

 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/Kconfig            |  1 +
 arch/arm64/kvm/arm.c              | 71 +++++++++++++++++++------------
 arch/arm64/kvm/guest.c            |  1 +
 include/linux/entry-kvm.h         |  6 ++-
 5 files changed, 52 insertions(+), 28 deletions(-)

-- 
2.32.0.554.ge1b32706d8-goog

