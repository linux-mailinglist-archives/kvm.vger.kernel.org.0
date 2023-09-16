Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23FA7A2C42
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 02:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238763AbjIPAdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 20:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238467AbjIPAcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 20:32:20 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2BF94
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:31:41 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c43cd8b6cbso8823355ad.0
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824300; x=1695429100; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RPxwiI+CF5oY5axnD8PplP8rMTdwT2bOTUtJzDVfTIk=;
        b=4JDunwJWxDluddrMrRLTj/LNkgoGDpJZcWWCGcaCKouRqjfsjyOm4kgy50/93DGnZf
         47M5ulzp+LdIpA7ytRU4ah7PBKR0ywSq/f3x4FE3+ygF+EYDC0Hwo2P6X9XHCShKXJaj
         u71jWAsO/NSqunHJVsy6qy6pdJs6MMiXYrJBeQi6yHoqBzETx5iksGAYkEILl8n/zmcD
         xRU9wBMR8d7612MakXTzQp0Hf9Yd/+YpQuO9F0zqCh8rS+7W/P8zRrBOCvcbZ0EmxGRP
         +K3N+t53IM5kD3mmQa9K98Yd7WDxTdEqa/YPORKKcln/NzLt+E3f7UH1RblOyCG42MRY
         yWBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824300; x=1695429100;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RPxwiI+CF5oY5axnD8PplP8rMTdwT2bOTUtJzDVfTIk=;
        b=G0DrAjTJrEQzAoewNiPHjHB524SiwpgT8EO0Q1vEfV8Q7WF48NQE7cAAuI0RYFz//c
         83+mlRO6sLLvTlDbcx28BNQACOv+Yzob4FuCHmaNK8bsJYBfNuyCRf7cMz06qUSysZWz
         vNGW3ebOeNXqeFuN10RdhrDf/oOPBp+jBsetyzj+jIcAMvo6DEHgprGTNfPq5X4G16SS
         0Ih9IqA/1o9or9gUUx4pInOaTBdeA9zKf4sM2J5IwtztS8UQl33jaq2qn3OrtKJhWS9e
         y9tnD8Gl2VcT8GP3CRas9OD5k2QftcGmGXRbFxjGLk4syiops/hakvyqXdrNCJpSrSgn
         a5mQ==
X-Gm-Message-State: AOJu0YztwUBqGYLwM40vluMbL9dPSHEvX9jtMVn6TR4kkR0Y7Z12gk2g
        xI8N1/AWS8MSKDVowFv0pgKg2ca8Mq0=
X-Google-Smtp-Source: AGHT+IHW1P62bdhU5bhLcOltXlUxrv9g7sIQXkfjHJs3Wzbb395eeX6g+RNXiUsvwMV2ESouovB/6KamMFU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2302:b0:1b8:a555:385d with SMTP id
 d2-20020a170903230200b001b8a555385dmr88540plh.9.1694824300497; Fri, 15 Sep
 2023 17:31:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Sep 2023 17:31:02 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-11-seanjc@google.com>
Subject: [PATCH 10/26] KVM: s390: Stop selecting and depending on HAVE_KVM
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

Now that nothing in s390 or architecture agnostic code consumes HAVE_KVM,
stop selecting it in s390.  This is one of several steps towards deleting
HAVE_KVM from the common KVM Kconfig.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/Kconfig     | 1 -
 arch/s390/kvm/Kconfig | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index ae29e4392664..8a5dca0036d9 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -193,7 +193,6 @@ config S390
 	select HAVE_KPROBES
 	select HAVE_KPROBES_ON_FTRACE
 	select HAVE_KRETPROBES
-	select HAVE_KVM
 	select HAVE_LIVEPATCH
 	select HAVE_MEMBLOCK_PHYS_MAP
 	select HAVE_MOD_ARCH_SPECIFIC
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 459d536116a6..9056cee72945 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -19,7 +19,6 @@ if VIRTUALIZATION
 config KVM
 	def_tristate y
 	prompt "Kernel-based Virtual Machine (KVM) support"
-	depends on HAVE_KVM
 	select PREEMPT_NOTIFIERS
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
-- 
2.42.0.459.ge4e396fd5e-goog

