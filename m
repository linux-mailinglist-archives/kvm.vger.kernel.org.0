Return-Path: <kvm+bounces-34058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BED489F6A9F
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 16:59:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FE521896449
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 15:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80BE81F37B5;
	Wed, 18 Dec 2024 15:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hb1w4GJF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EB71F2C4E
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 15:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734537563; cv=none; b=gS1/Em6pVl+s8qUiU30w9zHlwesH98Fq/l+10kEZ4L/yjAEng8JNYRMHiWTSAhpQrPeOp6d+WAyj0flvpRl8CPgVkfK6KwqJZXz6kAnuyHnu0RrCdkvPH7fWrvLOBMDRs9fGvDyVxqBGjb3OrookUbsWaX5ooH1cfZemOpqD7UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734537563; c=relaxed/simple;
	bh=HfAIejhc3RCNIBZf9s6+Y9P6+a7tWgHFCooOZU4FsTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lLlp4iVbDzYc5k+7Wj4/Q7n4iKKknGkiuOvRuatxQTJfDMO0ootjMPa7Q8hZadI7w2YtRbQp4D9spI69lf1Oj0GL878QPxzfBOMEZ5aOFiBwaSxvBjDBnUrcE5zqnjCZKDp1X7pfs9lUZf8u8/EVX+/FkjCEZmrCe2qNfjqPXis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hb1w4GJF; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43622354a3eso46504785e9.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 07:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734537560; x=1735142360; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i1PtiwkJt/+DijNbqUoe227vdUj70+KPR5ybVcrTmE4=;
        b=hb1w4GJFApFb73oCbgEj5ai3i474Yu3B6jEcETYN0r84MY+fNk3/6XwbhomWRyoFNX
         +Gg1elATMN02UAF0jk+tJLFZlNlmT0VCJMpIwk0ZRpwUVudibm2n+/qm5N2BsfzXtYO7
         nUpdk1Qe+uIQSCWpEJCBmaaWB7kRXi6V2z9OaL9ID3UHdjMv2Yt0dW9DEpdTE7jSfIet
         fPCuS1LHSgt9Kywa+w9xDsJmIjJ6mU7XLC3Re/e7lFyt5gedWYqr43EKnLTE8MZ8EfmU
         KOokGFSimlBeQEyPqH6h2v0UBpDaub9u7XVLHynwlxvfhvnUAbetFAXv241cDBoqouMq
         CXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734537560; x=1735142360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i1PtiwkJt/+DijNbqUoe227vdUj70+KPR5ybVcrTmE4=;
        b=Eez7Sy/yqKAF64PObbh3N7/Z2SmmJO6mCNVRB+af8PREmgUpJg9yJz2uNFvcSNi7C+
         vRBtB88EjlyPsSlhRsPqyXNbFTo2F3sztbk0obqzyh+O0eUbloGk7yOHumobAX/pNBTk
         2MOPwuw60e86h6PVP1OayhoHkM8Syxdj8DnQkhJBP7B5SVPKfngtTPjrGIZfsVaHHr1d
         KxDdTSVCCgOZQuA5oFYHMdY9VmMwgVRUjJatpswiVRzZNQ4BLKwMUP46JTMrezc5wF9C
         Gz8QvNyT5dtJn9OaWiL7sb3n9rHAPzEHM6LfPSdjgDMRGh58BuqgVpg8033PMHt8iIUx
         TU2g==
X-Forwarded-Encrypted: i=1; AJvYcCXaB4xkWELAy8jGasfZ02ZzbSw/cR52R8alEJahB0h730ejmKBRKvKLu9ZYeUhrENW7/EQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHbHnCmHgkGxrOZDRDLEHT4n5jflfxt4R6F/ohMASAyTzwqlbn
	ewmdErTCJZ+YJxlQukDwZCeowj5qtibt8edZAB7zU6TQ5DH0AZtDbEyMgX8Bbng=
X-Gm-Gg: ASbGncvN7S3bLkYry63oaeaDcVAgGTK/r07DkhwzDUGX/mgNa97lvDUpwK+37rSTTa+
	4nQr/mE1kfiWx3wXQhEDcMutvlYAoKgBAxdAt7AFeq8LXOBLJeTf37Q2ekNm6eetCGPk/1TJ5l7
	iXBXmnn9Qdz4RbO+jmF/Y0K+wp+RDZfnD1TWi0qIvKVs92C3qgUiugazWo0FhNbIKBYgHWqOgrj
	3ZwKAd5PH6eta9keYNqHmtZEd1iGr2Bxxdfxgu/OArOuDRJ2x0peDGwP+d3bv9CvvYdHxJzCjdF
	ZoR2
X-Google-Smtp-Source: AGHT+IHmkwoIYW6Cp/iqDz90yD50zgbZisO+B/FzbG+TIKWUEJjeysPGArnAL3+O3AtChZFuiI545w==
X-Received: by 2002:a05:600c:5103:b0:434:ff9d:a3a1 with SMTP id 5b1f17b1804b1-436553445f5mr32035875e9.2.1734537559916;
        Wed, 18 Dec 2024 07:59:19 -0800 (PST)
Received: from localhost.localdomain ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b01d17sm23876155e9.16.2024.12.18.07.59.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Dec 2024 07:59:19 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Eric Farman <farman@linux.ibm.com>,
	kvm@vger.kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org,
	Zhao Liu <zhao1.liu@intel.com>,
	qemu-s390x@nongnu.org,
	Yanan Wang <wangyanan55@huawei.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>
Subject: [PATCH 1/2] system: Move 'exec/confidential-guest-support.h' to system/
Date: Wed, 18 Dec 2024 16:59:12 +0100
Message-ID: <20241218155913.72288-2-philmd@linaro.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241218155913.72288-1-philmd@linaro.org>
References: <20241218155913.72288-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

"exec/confidential-guest-support.h" is specific to system
emulation, so move it under the system/ namespace.
Mechanical change doing:

  $ sed -i \
    -e 's,exec/confidential-guest-support.h,sysemu/confidential-guest-support.h,' \
        $(git grep -l exec/confidential-guest-support.h)

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/{exec => system}/confidential-guest-support.h | 6 +++---
 target/i386/confidential-guest.h                      | 2 +-
 target/i386/sev.h                                     | 2 +-
 backends/confidential-guest-support.c                 | 2 +-
 hw/core/machine.c                                     | 2 +-
 hw/ppc/pef.c                                          | 2 +-
 hw/ppc/spapr.c                                        | 2 +-
 hw/s390x/s390-virtio-ccw.c                            | 2 +-
 system/vl.c                                           | 2 +-
 target/s390x/kvm/pv.c                                 | 2 +-
 10 files changed, 12 insertions(+), 12 deletions(-)
 rename include/{exec => system}/confidential-guest-support.h (96%)

diff --git a/include/exec/confidential-guest-support.h b/include/system/confidential-guest-support.h
similarity index 96%
rename from include/exec/confidential-guest-support.h
rename to include/system/confidential-guest-support.h
index 02dc4e518f0..b68c4bebbc1 100644
--- a/include/exec/confidential-guest-support.h
+++ b/include/system/confidential-guest-support.h
@@ -18,7 +18,9 @@
 #ifndef QEMU_CONFIDENTIAL_GUEST_SUPPORT_H
 #define QEMU_CONFIDENTIAL_GUEST_SUPPORT_H
 
-#ifndef CONFIG_USER_ONLY
+#ifdef CONFIG_USER_ONLY
+#error Cannot include system/confidential-guest-support.h from user emulation
+#endif
 
 #include "qom/object.h"
 
@@ -94,6 +96,4 @@ static inline int confidential_guest_kvm_reset(ConfidentialGuestSupport *cgs,
     return 0;
 }
 
-#endif /* !CONFIG_USER_ONLY */
-
 #endif /* QEMU_CONFIDENTIAL_GUEST_SUPPORT_H */
diff --git a/target/i386/confidential-guest.h b/target/i386/confidential-guest.h
index 7342d2843aa..0afb8317b58 100644
--- a/target/i386/confidential-guest.h
+++ b/target/i386/confidential-guest.h
@@ -14,7 +14,7 @@
 
 #include "qom/object.h"
 
-#include "exec/confidential-guest-support.h"
+#include "system/confidential-guest-support.h"
 
 #define TYPE_X86_CONFIDENTIAL_GUEST "x86-confidential-guest"
 
diff --git a/target/i386/sev.h b/target/i386/sev.h
index 858005a119c..2664c0b1b6c 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -18,7 +18,7 @@
 #include CONFIG_DEVICES /* CONFIG_SEV */
 #endif
 
-#include "exec/confidential-guest-support.h"
+#include "system/confidential-guest-support.h"
 
 #define TYPE_SEV_COMMON "sev-common"
 #define TYPE_SEV_GUEST "sev-guest"
diff --git a/backends/confidential-guest-support.c b/backends/confidential-guest-support.c
index 052fde8db04..1cd9bed505d 100644
--- a/backends/confidential-guest-support.c
+++ b/backends/confidential-guest-support.c
@@ -13,7 +13,7 @@
 
 #include "qemu/osdep.h"
 
-#include "exec/confidential-guest-support.h"
+#include "system/confidential-guest-support.h"
 
 OBJECT_DEFINE_ABSTRACT_TYPE(ConfidentialGuestSupport,
                             confidential_guest_support,
diff --git a/hw/core/machine.c b/hw/core/machine.c
index ba819fec0af..0e8af37194f 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -30,7 +30,7 @@
 #include "hw/pci/pci_bridge.h"
 #include "hw/mem/nvdimm.h"
 #include "migration/global_state.h"
-#include "exec/confidential-guest-support.h"
+#include "system/confidential-guest-support.h"
 #include "hw/virtio/virtio-pci.h"
 #include "hw/virtio/virtio-net.h"
 #include "hw/virtio/virtio-iommu.h"
diff --git a/hw/ppc/pef.c b/hw/ppc/pef.c
index cffda44602e..8b2d726e008 100644
--- a/hw/ppc/pef.c
+++ b/hw/ppc/pef.c
@@ -14,7 +14,7 @@
 #include "qom/object_interfaces.h"
 #include "system/kvm.h"
 #include "migration/blocker.h"
-#include "exec/confidential-guest-support.h"
+#include "system/confidential-guest-support.h"
 
 #define TYPE_PEF_GUEST "pef-guest"
 OBJECT_DECLARE_SIMPLE_TYPE(PefGuest, PEF_GUEST)
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index ad21018b5aa..623842f8064 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -75,7 +75,7 @@
 #include "hw/virtio/vhost-scsi-common.h"
 
 #include "exec/ram_addr.h"
-#include "exec/confidential-guest-support.h"
+#include "system/confidential-guest-support.h"
 #include "hw/usb.h"
 #include "qemu/config-file.h"
 #include "qemu/error-report.h"
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index f4d64d64f94..b45d8963b36 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -14,7 +14,7 @@
 #include "qemu/osdep.h"
 #include "qapi/error.h"
 #include "exec/ram_addr.h"
-#include "exec/confidential-guest-support.h"
+#include "system/confidential-guest-support.h"
 #include "hw/boards.h"
 #include "hw/s390x/s390-virtio-hcall.h"
 #include "hw/s390x/sclp.h"
diff --git a/system/vl.c b/system/vl.c
index a271ecc1acf..4785b3ff09a 100644
--- a/system/vl.c
+++ b/system/vl.c
@@ -107,7 +107,7 @@
 #include "qemu/plugin.h"
 #include "qemu/queue.h"
 #include "system/arch_init.h"
-#include "exec/confidential-guest-support.h"
+#include "system/confidential-guest-support.h"
 
 #include "ui/qemu-spice.h"
 #include "qapi/string-input-visitor.h"
diff --git a/target/s390x/kvm/pv.c b/target/s390x/kvm/pv.c
index e4b0d17a48a..69c1811e156 100644
--- a/target/s390x/kvm/pv.c
+++ b/target/s390x/kvm/pv.c
@@ -19,7 +19,7 @@
 #include "system/kvm.h"
 #include "system/cpus.h"
 #include "qom/object_interfaces.h"
-#include "exec/confidential-guest-support.h"
+#include "system/confidential-guest-support.h"
 #include "hw/s390x/ipl.h"
 #include "hw/s390x/sclp.h"
 #include "target/s390x/kvm/kvm_s390x.h"
-- 
2.45.2


