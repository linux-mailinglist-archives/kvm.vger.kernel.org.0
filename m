Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469237A2C17
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 02:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238558AbjIPAcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 20:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238602AbjIPAcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 20:32:10 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC660106
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:31:23 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59b5d4a8242so34193997b3.0
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824283; x=1695429083; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CcWcgzjI/Sjr3SKdjnMS4CWAtaq/GpOs1NzqJV8HV48=;
        b=OuiUusccrI1dBz823+RYFHRz4umrPXI3ePQ4joT6b9h1bX+K5wr0pKY7/NAepdzJ+8
         N0LPT7ScUngYtOsaCgIuR7i0NDFbd/iuyX/GrqTub/2H4g8mBRJ3BiCuT/2TOAwOI+cU
         31c1gRAfBEXY5+SsEVVK2ewPce5CCjAGwumjaXeiPEVU4dwXIS052fKYD6sdA5hNbwNK
         qbKbpVfZxrbUEcdWAfvmCIASXx1xeaTzzZDXfGsA4bSki6ozzrhs6AIP0SLDD8UbOeSl
         uVwl7/q4+nHxHIghDOEdOOXBUrmqaOd95gA7v28rO2+NtD7uAdx8RfT83WmbxuPgeTO9
         DIuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824283; x=1695429083;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CcWcgzjI/Sjr3SKdjnMS4CWAtaq/GpOs1NzqJV8HV48=;
        b=lhHuo/ERV9fd2DIq9L3LhjJUgVT38+BLpbHVjpQUnx6Osa1fvjojmnWUcLmLzFlprY
         WrEJHtPs+uptRWh9p0IIcRlAsVAXYuHWmE/7c7UpwVYsb5unPyQnqVTfXRJrlDqJbTMO
         TlFVvYy4I1ou60JE1NQMHUM8n42dI2rlVx4L6UcbbgjdOYgCLLHpbkQ+qejl/qnmX/Jm
         i2+vqHrusUPqkolCtPX+MVUyniZCbYVXEVJ2SsL/elGMNfniyrnD3zdgqzE049kyeqF1
         xFaP7D1qnbo0jn6NpglMF86QBhSyXlDTGeHlJL6PjO7HBGoeXQ8x5aGbIty1/4jE4LWx
         goqQ==
X-Gm-Message-State: AOJu0YyaLpdOR1bLWrUnpJwagBOmeDeDTM7YIo9j8WPLmnOp9Z9zrAiN
        Ll4FvJozbznN4PRQBXmeQRZBAP39FYA=
X-Google-Smtp-Source: AGHT+IEjplB8N3p+oR/7zKlMcxL9iCUBmO4vshw551ibG3RHlQehJcUKg5dHZyrgSIjo7xUVmV5xBYFOkj8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b612:0:b0:565:9bee:22e0 with SMTP id
 u18-20020a81b612000000b005659bee22e0mr85362ywh.0.1694824282871; Fri, 15 Sep
 2023 17:31:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Sep 2023 17:30:53 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-2-seanjc@google.com>
Subject: [PATCH 01/26] vfio: Wrap KVM helpers with CONFIG_KVM instead of CONFIG_HAVE_KVM
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

Wrap the helpers for getting references to KVM instances with a check on
CONFIG_KVM being enabled, not on CONFIG_HAVE_KVM being defined.  PPC does
NOT select HAVE_KVM, despite obviously supporting KVM, and guarding code
to get references to KVM based on whether or not the architecture supports
KVM is nonsensical.

Drop the guard around linux/kvm_host.h entirely, conditionally including a
generic headers is completely unnecessary.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/vfio/vfio.h      | 2 +-
 drivers/vfio/vfio_main.c | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 307e3f29b527..c26d1ad68105 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -434,7 +434,7 @@ static inline void vfio_virqfd_exit(void)
 }
 #endif
 
-#ifdef CONFIG_HAVE_KVM
+#if IS_ENABLED(CONFIG_KVM)
 void vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm);
 void vfio_device_put_kvm(struct vfio_device *device);
 #else
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 40732e8ed4c6..80e39f7a6d8f 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -16,9 +16,7 @@
 #include <linux/fs.h>
 #include <linux/idr.h>
 #include <linux/iommu.h>
-#ifdef CONFIG_HAVE_KVM
 #include <linux/kvm_host.h>
-#endif
 #include <linux/list.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
@@ -383,7 +381,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 
-#ifdef CONFIG_HAVE_KVM
+#if IS_ENABLED(CONFIG_KVM)
 void vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm)
 {
 	void (*pfn)(struct kvm *kvm);
-- 
2.42.0.459.ge4e396fd5e-goog

