Return-Path: <kvm+bounces-40372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C59CBA56FFF
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:04:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01F01165C82
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D16DF23F29C;
	Fri,  7 Mar 2025 18:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mC13cNAJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5136223E229
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 18:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370651; cv=none; b=dvV6f8A2QylkQI3sJ6xlgp//6lFj055yhgKatZ8RT9QPZYv9/gJm+ZlVLSX0oQumL4AWPoOEoRPxuCLeU7lvXvGy2ZZrl98lMocj+kITmo3cbPDi3ToaN5cBsAPph+Hx0QoUcAJQbmN28O9BjlHv6LZ+YVAbslwHsPKY/UdWQCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370651; c=relaxed/simple;
	bh=4NU+RjGBUYuu23EMdj6qV2xxTpRFZpBkjafWKSM9eXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LsDzvwYopPwzCO52+mNVymH+0nJNV3odefp3DGGU3LJq0nb7uOimT8pbx9W2IwlCen6oT8ZS4s75CLqduWu4VMOVTwXbs4Gk7EmtidxueAspItlSx97kpHmnW2q2Pj66rcAAYW+w4fVhzWxtCnuBD/ieGbA9bPPmdrkz+7qIsAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mC13cNAJ; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-38f406e9f80so1584303f8f.2
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 10:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741370647; x=1741975447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TEveCyP6FEOPe2OjJI8iFRo9o4gmTgwH3d2sFhPvDtA=;
        b=mC13cNAJqnEbC8gwm4ODJNyfnmwDTLdkcXaNqlkl1qKLGIL6vkuzx1Pnispo+OiA4d
         rcCRYH/jXCKQrx5IuLRG3wOLaHF6TefoA2hLNCM7OVfmkWR8YIjrO3WDW6gCEol8kBYZ
         fLuVbQIyTVm+DAfCqbbdtVAj1Yh0BYz2JI5rWN8EAzcDr3ByJ2KLu8NfpceBvZIjEeWG
         jtoDLUB5eXBjUmJK+w0yhVgG0CE4ZMd8tbwcOS+x8X5gKrwB0XbQuv4neu/qdLpH+fL9
         5n5iayKjkm0RZRnGyoaeceuAnPz90JEOn98hrO3d9crvOtscg6Cad5URNNJIn1uksZKy
         7ATA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741370647; x=1741975447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TEveCyP6FEOPe2OjJI8iFRo9o4gmTgwH3d2sFhPvDtA=;
        b=bxAESCaRq5pgnHwqQGrvN96UC8aMawU1374MwbqJUF2ITRll8E6o9Im/XdUelQObzc
         ANlKG6bRYxK0geo8GdHa+Saj7fLdvKShSVZ29IdQG8HOnSjN/jeoo4iZcD1G7vHEGF5Z
         pzA8PPlXojkxH1zdtoZNtWZSN+ID5dcRUW2y+2JcYsz6U/L2qDMi3Y98mCGA76mfmmnG
         JL4po5y/tKuts2nNbR5P14LzvEv9BnE9wU/LoaaG+p6F7ro5IdODRrHgC7rLE4T2VK4c
         DT6CghbVoNRGmruMmv382DLGCi1baIMVA6c+/647l1Da+nXvedWQcOCYqeXF0OFiLuSQ
         qlVw==
X-Forwarded-Encrypted: i=1; AJvYcCVgjlU7i1WQtODA5bFwTMgksKwL/jHruV6zxdgJU8NWCScfL2+fVTBkO3Mlq5C7ZRi7BWU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrlBXKa6Qfqg1HzJhMQXJw6TRcOvKCP9apsKLz5vatqWouU72l
	eaIK3nXIzwRMiXN6g/Qg4AXun/XbtMnPbM93IgkXF2Ucsqs30dXbHLe9NHm2YjA=
X-Gm-Gg: ASbGnctxWN9yKocAXoHeKcmpuGTIMGyCop9QovEBNTafF8nnGoCakCf+i9lbynprSnf
	f2PUAnlo1kkGoq5rAa4NBUGsAfjl6h8Wv01kpxtkZ7RUAsPXkuyqLf2yZpRWmxdEM4fcUtHS8EI
	Ca80rxqFB1WRlfdT06MCSxlIMeoPOnlrGg7lZRv+0KId0FzjPJlmMf9F1ozoNdhCA1kYlzrXNHd
	ilURAoIDJjYrmj3i7TXkiqSVJCrriMyh3IfpEM3zaiGQnHltNrrw/q8LwMj2xFOkA+Lg2fJ3zRj
	lKqSjHZVeB71+pUSsziULzsr0JbBZmC+1IKSaw/mQ2rBNMsqqmE/RYf9qm1r3Ib738gngUt/Iwk
	eE15kFoAKEhKG6tkWrs8=
X-Google-Smtp-Source: AGHT+IFP46e+d4zSpLLCoseVXCZJECsAXVPehPMPfpJJ5BpgkkXKnlM7odaYTNUUfr+LJlq6dGhKCQ==
X-Received: by 2002:a5d:64cd:0:b0:391:2995:5ef2 with SMTP id ffacd0b85a97d-39132dace0fmr2665116f8f.37.1741370647439;
        Fri, 07 Mar 2025 10:04:07 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c01d81csm6127965f8f.58.2025.03.07.10.04.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 07 Mar 2025 10:04:06 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	qemu-ppc@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Yi Liu <yi.l.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Eric Auger <eric.auger@redhat.com>,
	qemu-s390x@nongnu.org,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 05/14] hw/vfio: Compile iommufd.c once
Date: Fri,  7 Mar 2025 19:03:28 +0100
Message-ID: <20250307180337.14811-6-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250307180337.14811-1-philmd@linaro.org>
References: <20250307180337.14811-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Removing unused "exec/ram_addr.h" header allow to compile
iommufd.c once for all targets.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/vfio/iommufd.c   | 1 -
 hw/vfio/meson.build | 6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/hw/vfio/iommufd.c b/hw/vfio/iommufd.c
index df61edffc08..42c8412bbf5 100644
--- a/hw/vfio/iommufd.c
+++ b/hw/vfio/iommufd.c
@@ -25,7 +25,6 @@
 #include "qemu/cutils.h"
 #include "qemu/chardev_open.h"
 #include "pci.h"
-#include "exec/ram_addr.h"
 
 static int iommufd_cdev_map(const VFIOContainerBase *bcontainer, hwaddr iova,
                             ram_addr_t size, void *vaddr, bool readonly)
diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index 2972c6ff8de..fea6dbe88cd 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -4,9 +4,6 @@ vfio_ss.add(files(
   'container.c',
 ))
 vfio_ss.add(when: 'CONFIG_PSERIES', if_true: files('spapr.c'))
-vfio_ss.add(when: 'CONFIG_IOMMUFD', if_true: files(
-  'iommufd.c',
-))
 vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
   'display.c',
   'pci-quirks.c',
@@ -28,3 +25,6 @@ system_ss.add(when: 'CONFIG_VFIO', if_true: files(
   'migration-multifd.c',
   'cpr.c',
 ))
+system_ss.add(when: ['CONFIG_VFIO', 'CONFIG_IOMMUFD'], if_true: files(
+  'iommufd.c',
+))
-- 
2.47.1


