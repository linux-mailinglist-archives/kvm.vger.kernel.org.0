Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755827A2C6E
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 02:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238796AbjIPAd0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 20:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238809AbjIPAcs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 20:32:48 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CED68E
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:31:39 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d8191a1d5acso2867951276.1
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824298; x=1695429098; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OjnVLG9a9LJLqorH8Rj1ZnrY26noTE5ZeEoscx0wCrE=;
        b=3iwsnBBg9U9rpDKqYhVnwIOmDRQRmg6VPUkonz/huNUXNLJwhQBvwByqsEaueNfXsG
         3FRR/r+a38kQBwhJqk8rnRXZ6B25yca5VIiPhk/HlCGmCwQFo7S0Jy7SCZt7mDqcRtaS
         WNfLsZPOSBNhaWmq59Gx9VrL5De2F0OpOU9uoEPEnntmkk/j5pSN5+lhF0SoyvbSmLGg
         0jdpYz2TnQgNkxXIhgUFs6rHAycucPVycDEZ+eIzigDEm96Ewq8OuxMO0cFbbQVTYRzG
         ZS4R7RSd4dPGC/Kbd5b65d+sV1BBGAKwQ167T0oAG8kRxOWlmFQSICPuARM7hNT4eYFs
         w2Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824298; x=1695429098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OjnVLG9a9LJLqorH8Rj1ZnrY26noTE5ZeEoscx0wCrE=;
        b=qv7taoCek6AZrtxOANWl4z68k+DVzskBYrhqXGfHJ/H09mUQixLkTIkPQTS9bvKnb4
         IRsaqME1RfMWXtZb9vC2Wcscl946HxlQuYpsq6QZAgQojI9VXwdLAE/ixelvy5y+FgR1
         vYAKds+g6NL2yyUIh7cgEEFuFySMfgxNmP1IAV/zki55e9HwCNXMfKAlTrdo2XbcqDJH
         bCVXol+ZdBXPAPzxhRuFtJxMe+3gKNzbKBgMWFi6WpvFLuPfmxSx1wRDF43JmyAmVnw2
         UBtRZJ4fAGP4ibJq8acOC0eRAZ/QptSzXGVu68EbKwjxvAQ3ojCw2/SOf1GS5BX16aC7
         V4Zg==
X-Gm-Message-State: AOJu0YzeR8aaCRhYwscortsbzm/cl7ctB1ocygAOOPqdMRnyacbJI7CO
        TLLMGm4LQuzdhSUqJxz1zZuY/LQxGus=
X-Google-Smtp-Source: AGHT+IEejUplN0yThqJglSyf2PAl899GMvDcyB4OaKD9HL7AL2P8QSuIFDWAjhltJc72cwzADimsWD5lopA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:138e:b0:d78:245a:aac4 with SMTP id
 x14-20020a056902138e00b00d78245aaac4mr82623ybu.1.1694824298283; Fri, 15 Sep
 2023 17:31:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Sep 2023 17:31:01 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-10-seanjc@google.com>
Subject: [PATCH 09/26] KVM: arm64: Stop selecting and depending on HAVE_KVM
From:   Sean Christopherson <seanjc@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Anish Ghulati <aghulati@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Andrew Thornton <andrewth@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that nothing in arm64 or architecture agnostic code consumes HAVE_KVM,
stop selecting it in arm64.  This is one of several steps towards deleting
HAVE_KVM from the common KVM Kconfig.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/Kconfig     | 1 -
 arch/arm64/kvm/Kconfig | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b10515c0200b..7d99f132e57c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -214,7 +214,6 @@ config ARM64
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IOREMAP_PROT
 	select HAVE_IRQ_TIME_ACCOUNTING
-	select HAVE_KVM
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
 	select HAVE_PERF_EVENTS
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 2b5c332f157d..c76af1973315 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -20,7 +20,6 @@ if VIRTUALIZATION
 
 menuconfig KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
-	depends on HAVE_KVM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select MMU_NOTIFIER
 	select PREEMPT_NOTIFIERS
-- 
2.42.0.459.ge4e396fd5e-goog

