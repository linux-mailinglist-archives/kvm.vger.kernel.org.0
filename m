Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22C53E2811
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 12:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244807AbhHFKHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 06:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244841AbhHFKHt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 06:07:49 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3422C061798
        for <kvm@vger.kernel.org>; Fri,  6 Aug 2021 03:07:33 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id u16so6439328ple.2
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 03:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x6feBf9HHFfTJo5VBeJadJAVn2sLzP1PBAkuOCFqAFQ=;
        b=O9w1LNgNGb8Oa24qAxBilCSvkVEcE9Ej9r2ANCue0ou4JfMF8ytKrogiWfKn1IdXW4
         /QyzIU3e9K0wdlVIdJVK9ysvFjopgir7+VRpkh9rZqO3DPoC8cSsskb3xkKyrqf4uU9Q
         p0+iMGAeZa5/5L9RDamJFqg0uAKCVe+flj0Qo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x6feBf9HHFfTJo5VBeJadJAVn2sLzP1PBAkuOCFqAFQ=;
        b=AhF1/ZdCmc6XJTyurripTMdMGs6/0+db2J2Ep1vDA3ZIiW0+2QOx9tY5RfA4eNeUCT
         B1mioW3lb5w1FugmZiUkNC6gfeY18xJ7Hi4sMeVnyoiS2C3JmlgzVwZzJvOhHT5ShFmE
         Z68pwyufVmSe5puh0beDr2h+e1XU+26h1SsEu/haKjgzbpT/Fqt2hZWH1kAYERAtUgK5
         7g3k6HMZjvJbAUTgMTwUENmlqzZ1zBWXiSHo+H5HMMshOSLPaXzU9nmCoEQLQ6M3V6sm
         e8kfKWSS9XLsvlWKWiyqd9LGqFzAWYof+AGnRIZXzlRtZBYG5So2hvYjHONGrm4v0Jt6
         84jw==
X-Gm-Message-State: AOAM533kCoH3qNfZpAjSoHPnRcogFRShAcYoT3x6mTGbBEb3IIKIqBFy
        Yj6zBgMZo9eXHQ5tzHVYIxpvEg==
X-Google-Smtp-Source: ABdhPJyojKdf1A1mhaHwoS2sCbrTfC4tzRJhWfp4CTlAn1AbaMHcr7ba9JApUobqvx0Sm3+olsVflw==
X-Received: by 2002:a05:6a00:c81:b029:30e:21bf:4c15 with SMTP id a1-20020a056a000c81b029030e21bf4c15mr9975980pfv.70.1628244453447;
        Fri, 06 Aug 2021 03:07:33 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:b731:9e91:71e2:65e7])
        by smtp.gmail.com with UTF8SMTPSA id r14sm2394630pff.106.2021.08.06.03.07.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 03:07:32 -0700 (PDT)
From:   Hikaru Nishida <hikalium@chromium.org>
To:     linux-kernel@vger.kernel.org, dme@dme.org, tglx@linutronix.de,
        mlevitsk@redhat.com
Cc:     suleiman@google.com, Hikaru Nishida <hikalium@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Juergen Gross <jgross@suse.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Mike Travis <mike.travis@hpe.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Steve Wahl <steve.wahl@hpe.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, x86@kernel.org
Subject: [v2 PATCH 0/4] x86/kvm: Virtual suspend time injection support
Date:   Fri,  6 Aug 2021 19:07:06 +0900
Message-Id: <20210806100710.2425336-1-hikalium@chromium.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi,

This patch series adds virtual suspend time injection support to KVM.
(It is an updated version of the following series.)
https://lore.kernel.org/kvm/20210426090644.2218834-1-hikalium@chromium.org/

Changes to v1:

- Using IRQ instead of polling to detect the host's suspension.
- Removed unused arg "updated" from kvm_write_suspend_time()
- Improved comments and commit messages.

Please take a look again.

Thanks,

Hikaru Nishida



Hikaru Nishida (4):
  x86/kvm: Reserve KVM_FEATURE_HOST_SUSPEND_TIME and
    MSR_KVM_HOST_SUSPEND_TIME
  x86/kvm: Add definitions for virtual suspend time injection
  x86/kvm: Add host side support for virtual suspend time injection
  x86/kvm: Add guest side support for virtual suspend time injection

 Documentation/virt/kvm/cpuid.rst     |   3 +
 Documentation/virt/kvm/msr.rst       |  30 ++++++++
 arch/x86/Kconfig                     |  13 ++++
 arch/x86/include/asm/idtentry.h      |   4 +
 arch/x86/include/asm/irq_vectors.h   |   7 +-
 arch/x86/include/asm/kvm_host.h      |   5 ++
 arch/x86/include/asm/kvm_para.h      |   9 +++
 arch/x86/include/uapi/asm/kvm_para.h |   6 ++
 arch/x86/kernel/kvmclock.c           |  40 ++++++++++
 arch/x86/kvm/Kconfig                 |  13 ++++
 arch/x86/kvm/cpuid.c                 |   4 +
 arch/x86/kvm/x86.c                   | 109 ++++++++++++++++++++++++++-
 include/linux/kvm_host.h             |   8 ++
 include/linux/timekeeper_internal.h  |   4 +
 kernel/time/timekeeping.c            |  37 +++++++++
 15 files changed, 290 insertions(+), 2 deletions(-)

-- 
2.32.0.605.g8dce9f2422-goog

