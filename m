Return-Path: <kvm+bounces-2823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CCC987FE491
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 01:10:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 897C52822D6
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 00:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7ABA636;
	Thu, 30 Nov 2023 00:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KCOIPM7j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AACFCA
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 16:10:03 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da0737dcb26so388885276.3
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 16:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701303002; x=1701907802; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gmjQgaxxDn5r7HkZPUYCJ27qew3aSHzjX5AlpzkdkoY=;
        b=KCOIPM7jBghjlaNvqZNIMzRxk+NyDgmjBQ89cFR2w0ohLu6aBrZjaYfEEiYwvuhv6v
         6E8TuDuiCaH4aEZxU4K3bnKhrEIRIkJHQ1CXY5ZUeSuwIeAeDRSM2pDnNEi8WQrR7zMA
         NMijg9ahLR8QEuRc7DP2Cr9XZl91t8aXq796sJKXQUTzxuuczXk3dmHQlN/UXLmZKsbX
         kZhpkIGaQxkjYxjLGSaTdVOzPwMdNDLpauzMwVA+ihKnmCv7l18SDT4IKVU45amBwftL
         4izK2uTpqlzYAOATDdVCYDLsIur9uhBGes3kpOPUSMS4sXt3diDBx5zeIeCbrEGPKCv3
         1s3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701303002; x=1701907802;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gmjQgaxxDn5r7HkZPUYCJ27qew3aSHzjX5AlpzkdkoY=;
        b=HWSKgfbtQ9HCeAm263HX+Mtdl89SzE1Qn3ErTxGp/zd7oSOrL9u6oHmQ2682zOJPxN
         XkE1RdWsLvUDrLDwmaxeI188kdw4h+xd8wW7yxY9G/MlTfevZQM+o3ybokp+BRmaTIlc
         wa8dtea7XoAuPnZp0S4R+iAUSCmlG2j+B/8lP4v5yHkDhIWg4lGm7lPlw9qW7i+/8cgy
         wRkwWBUs3gPs0LeGe5cC6HwulKCGUn/pxysdL9JpQL5d7NIQnixa9nE6MBAXRmLdwWxB
         Pe/K127TpNhaOl0HVPcIs7/8AanyKQNd0IevlkzE9dX/EqOZDETdNK++i3cLK8RaA7+t
         HOkg==
X-Gm-Message-State: AOJu0Yz7ckzO+RDRaw2am2xuu1NrXboFZ+3rSdm10vfsYZpH22DDjAj7
	dzpXOXRmrW8uyHNEVDoase7QZ/moQc0=
X-Google-Smtp-Source: AGHT+IGkmKVAkhUhDCuNHCF6qsZZjcgx0kXiwfuTem15ifyWvEMkuHM1uhjC+KfnOKjPGQulGYD2XibZdq8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:bac6:0:b0:db3:fd6a:7bdb with SMTP id
 a6-20020a25bac6000000b00db3fd6a7bdbmr395765ybk.2.1701303002773; Wed, 29 Nov
 2023 16:10:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 29 Nov 2023 16:10:00 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Message-ID: <20231130001000.543240-1-seanjc@google.com>
Subject: [PATCH] vfio: Drop vfio_file_iommu_group() stub to fudge around a KVM wart
From: Sean Christopherson <seanjc@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Nick Desaulniers <ndesaulniers@google.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the vfio_file_iommu_group() stub and instead unconditionally declare
the function to fudge around a KVM wart where KVM tries to do symbol_get()
on vfio_file_iommu_group() (and other VFIO symbols) even if CONFIG_VFIO=n.

Ensuring the symbol is always declared fixes a PPC build error when
modules are also disabled, in which case symbol_get() simply points at the
address of the symbol (with some attributes shenanigans).  Because KVM
does symbol_get() instead of directly depending on VFIO, the lack of a
fully defined symbol is not problematic (ugly, but "fine").

   arch/powerpc/kvm/../../../virt/kvm/vfio.c:89:7:
   error: attribute declaration must precede definition [-Werror,-Wignored-attributes]
           fn = symbol_get(vfio_file_iommu_group);
                ^
   include/linux/module.h:805:60: note: expanded from macro 'symbol_get'
   #define symbol_get(x) ({ extern typeof(x) x __attribute__((weak,visibility("hidden"))); &(x); })
                                                              ^
   include/linux/vfio.h:294:35: note: previous definition is here
   static inline struct iommu_group *vfio_file_iommu_group(struct file *file)
                                     ^
   arch/powerpc/kvm/../../../virt/kvm/vfio.c:89:7:
   error: attribute declaration must precede definition [-Werror,-Wignored-attributes]
           fn = symbol_get(vfio_file_iommu_group);
                ^
   include/linux/module.h:805:65: note: expanded from macro 'symbol_get'
   #define symbol_get(x) ({ extern typeof(x) x __attribute__((weak,visibility("hidden"))); &(x); })
                                                                   ^
   include/linux/vfio.h:294:35: note: previous definition is here
   static inline struct iommu_group *vfio_file_iommu_group(struct file *file)
                                     ^
   2 errors generated.

Although KVM is firmly in the wrong (there is zero reason for KVM to build
virt/kvm/vfio.c when VFIO is disabled), fudge around the error in VFIO as
the stub is unnecessary and doesn't serve its intended purpose (KVM is the
only external user of vfio_file_iommu_group()), and there is an in-flight
series to clean up the entire KVM<->VFIO interaction, i.e. fixing this in
KVM would result in more churn in the long run, and the stub needs to go
away regardless.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202308251949.5IiaV0sz-lkp@intel.com
Closes: https://lore.kernel.org/oe-kbuild-all/202309030741.82aLACDG-lkp@intel.com
Closes: https://lore.kernel.org/oe-kbuild-all/202309110914.QLH0LU6L-lkp@intel.com
Link: https://lore.kernel.org/all/0-v1-08396538817d+13c5-vfio_kvm_kconfig_jgg@nvidia.com
Link: https://lore.kernel.org/all/20230916003118.2540661-1-seanjc@google.com
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Fixes: c1cce6d079b8 ("vfio: Compile vfio_group infrastructure optionally")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/vfio.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 454e9295970c..a65b2513f8cd 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -289,16 +289,12 @@ void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
 /*
  * External user API
  */
-#if IS_ENABLED(CONFIG_VFIO_GROUP)
 struct iommu_group *vfio_file_iommu_group(struct file *file);
+
+#if IS_ENABLED(CONFIG_VFIO_GROUP)
 bool vfio_file_is_group(struct file *file);
 bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
 #else
-static inline struct iommu_group *vfio_file_iommu_group(struct file *file)
-{
-	return NULL;
-}
-
 static inline bool vfio_file_is_group(struct file *file)
 {
 	return false;

base-commit: ae2667cd8a479bb5abd6e24c12fcc9ef5bc06d75
-- 
2.43.0.rc1.413.gea7ed67945-goog


