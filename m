Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833B07A2C32
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 02:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238294AbjIPAcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 20:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238794AbjIPAcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 20:32:46 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9542D7D
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:31:53 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59c240e637aso11256767b3.3
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824313; x=1695429113; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pl7bBxxWVXjTf9iTQwKV6iNN5dTCLVhIVjlh92R6IC4=;
        b=zOLzyvf9Xh9Oyip0BwJ83PeBHCS/GkeIkYW7amwKWpbVRBulRSs+M2ewlVHSYEk8Y1
         fZi/rLeXSktTS8MyrHSb7oSjjoji3mP8DLBFys3HTkweHkzNEjUj/MYjO6bhCObLf6WI
         C4epHaQCDHjamTfPTIFUVJo9uV7rJeD8D3Ev5VTy1GaRUXNCbP9vUakULPRry3f2UmYw
         gyw5WDenpiA4SZAJNYLZ4b5c/W6CHbsXfPj0GoeSA/wcWsneuM9gT86MPn9Q/cBxCCsq
         e6qXt7/vwX6T3FspiyVRjD7e2hTXM1HQsLlpY6p8Z4vdzbokFmWoStzOeNzcENym+vhB
         +SRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824313; x=1695429113;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pl7bBxxWVXjTf9iTQwKV6iNN5dTCLVhIVjlh92R6IC4=;
        b=wMWEac2kkkyIreeh4FjRR/z7T5GSGm/ntx3WwNv+3as0/m68OlDcm0Jb93+OqYQvcI
         /mEyyoB2oLHmM2ZEGRmIliO1KpyoQQgdgRxGlD7X93uXNij3Mjy0hRsm0Q/7X2bkGPT4
         h56ojDWhXRnKADqYE6ODJZDBFOsrNitJSBBsC99ppLF6tEBSNgh/H4TAKOAKdVRn9BIb
         MTssH+gwKCPWQ1FP4lJZONRmnbZwgzD4tzr4cdSMQZafU+RaxR/4ReeOnOQeX6QnGkKN
         jq6YvUggRREk2YMDz3REt1gJpVrVQam12CT0s1y8de5zYsWSs6hep8sj0Rk2LJYLf2SM
         irOw==
X-Gm-Message-State: AOJu0YzOPP4lpRQoi2bA0rR2w5ajTiT5ySbdxof1JTD8RjbStfuhiEjd
        lqaLulELwg92jRWhmzl8lClVBuiFCxs=
X-Google-Smtp-Source: AGHT+IHIEoJ5Qp0cT7058FSDnFlcgu0NfKZ+k2cnwo0UQE0i+ifeNt8ssvIZEJlieWuqLdMggeWcLX6T9W4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:4cf:b0:d7b:92d7:5629 with SMTP id
 v15-20020a05690204cf00b00d7b92d75629mr82335ybs.8.1694824312956; Fri, 15 Sep
 2023 17:31:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Sep 2023 17:31:08 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-17-seanjc@google.com>
Subject: [PATCH 16/26] KVM: MIPS: Stop adding virt/kvm to the arch include path
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

Don't add virt/kvm to KVM MIPS' include path, the headers in virt/kvm are
intended to be used only by other code in virt/kvm, i.e. are "private" to
the core KVM code.  It's not clear that MIPS *ever* included a header from
virt/kvm, i.e. odds are good the "-Ivirt/kvm" was copied from a different
architecture's Makefile when MIPS support was first added.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/kvm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
index 805aeea2166e..96a7cd21b140 100644
--- a/arch/mips/kvm/Makefile
+++ b/arch/mips/kvm/Makefile
@@ -4,7 +4,7 @@
 
 include $(srctree)/virt/kvm/Makefile.kvm
 
-ccflags-y += -Ivirt/kvm -Iarch/mips/kvm
+ccflags-y += -Iarch/mips/kvm
 
 kvm-$(CONFIG_CPU_HAS_MSA) += msa.o
 
-- 
2.42.0.459.ge4e396fd5e-goog

