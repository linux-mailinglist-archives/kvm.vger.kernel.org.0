Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739787A2C4A
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 02:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238876AbjIPAdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 20:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238777AbjIPAco (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 20:32:44 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF402D50
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:31:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d8141d6fbe3so3253525276.3
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824302; x=1695429102; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=11iXbA6RA96N2ihdzvT9DOzykVF8TPNgieg32BOfaCo=;
        b=TMBBmJdJhKP3G7bLvh5bdJ5HGVmLAGy+9sz6UWizDB39p5JJWRUAN4BMluE44WgqaK
         wt2Nl4rnJkO+uUW1TJHGwPYu7Wmkckr5hY3/lUNOEkpsbYkjO25i9vBxMNWLW93wE1FQ
         eOH0ZTOXp5SxEVktCtxbclt7fwt1iwZGB5KE0Jr7gVN8jx1uM5DeCq7X08FEv0vvkXLB
         mmgiSAzG42PIPMtMopVz6N/tt6PE6lLuAmQTEBDHCWix+mIbNF1izydhDD8DnzM0IfuM
         /wBerUvM6cRESUAgk7f1LS+zk4wSiO+8El28U4AC5EvVZjkDW5MGweeXrUJAn/6ijUQf
         8Q6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824302; x=1695429102;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=11iXbA6RA96N2ihdzvT9DOzykVF8TPNgieg32BOfaCo=;
        b=AWpCcLko6zA/fdeumjJ5HmxjP2PZBDgjnivxp9Io+qzA/QqeHwG8KEU+LvWa7DJRPn
         Cv0MUwY4fjQXpQziSwJCLflgKIMSobAc5ZB833VGpdlT93LRwI6JPEcubFUA0dtPRgwF
         ZXgjOm0UiK8Kb9oJZ+zCylOozPkOZZehh+zILJPdZ0dxjD7Dnw1/H5/47Rhq/4DDn+KR
         9o0x1JX9tHJezVgH+omkKjxRMus5/S1c/P3ZtwpMpjFQSKmCWnmFJrGN8s49ApSYpcCQ
         dVWiIOIsJ/LEpYiOO6e5dTgCGFABT/UEt0JdWlOiWoZB3HGdfYEVth6a9lQXufTn3R5W
         q9hA==
X-Gm-Message-State: AOJu0Yz7zF0lFG9/j3ZlHKjxVW3mT+wTvRVuv2vfaahuEaJVtnGxvphx
        kMhtChm9sOFT/h1EiqfGIUljJJfmUjo=
X-Google-Smtp-Source: AGHT+IEXzBZMjfoz19MMDpz0z/mfp5J4Xc54+oTqT/y9sTC3/YRTAU+NLkJhdnChwcXUDWkKwhep1BL4HMg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:138e:b0:d78:245a:aac4 with SMTP id
 x14-20020a056902138e00b00d78245aaac4mr82625ybu.1.1694824302614; Fri, 15 Sep
 2023 17:31:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Sep 2023 17:31:03 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-12-seanjc@google.com>
Subject: [PATCH 11/26] KVM: MIPS: Make HAVE_KVM a MIPS-only Kconfig
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

Now that MIPS is the sole remaining user of HAVE_KVM, make HAVE_KVM a
MIPS-only Kconfig.  Because most architectures unconditionally support
virtualization, advertising to the kernel at-large that an arch has KVM
just led to a bunch of useless and misguided #ifdefs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/kvm/Kconfig | 3 +++
 virt/kvm/Kconfig      | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index a8cdba75f98d..c4508f49caae 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -4,6 +4,9 @@
 #
 source "virt/kvm/Kconfig"
 
+config HAVE_KVM
+       bool
+
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
 	help
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index f0be3b55cea6..f7bb6c59658e 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -1,9 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # KVM common configuration items and defaults
 
-config HAVE_KVM
-       bool
-
 config HAVE_KVM_PFNCACHE
        bool
 
-- 
2.42.0.459.ge4e396fd5e-goog

