Return-Path: <kvm+bounces-40505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EDF36A57FAC
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:09:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5240D1888680
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A043A1F9F5C;
	Sat,  8 Mar 2025 23:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f+wMa2qG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD8220F06D
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475394; cv=none; b=b3IFq5/5bYNfRNuRPyhluQUoqbvMqOd8/octdMzOJwVZcg0L+VltjFOV/MoT5+DoX1Gi+Bb/lf4f+AtbQ+5oosVl2msSwUWo2CIyTpx6sOddOn38pnKEro5E2XINcV+eZPRcTwvejosrXjTITc1W01PeeWXcj7WujeHiJ4XQuB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475394; c=relaxed/simple;
	bh=yXs/LQSQE4OqjK8HsPlzJMOG1v9dx8mt7k/gx8R+/TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XemHxFiIP9i64EcIS+hX3fQQ72ty5Bd1ym2o8ickE7SA8YkUtx+DPoq8dli04Qbfhgz0XU7xI6UnC9/9+Rj3FcmbOYNWSgdmuUp1cW3A6xkhzwYumLIqFWEG+M/ECzgmvk++jaY1b2FoGYGpDTz/rnAthqK9fT7y3XEA7y2MQcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f+wMa2qG; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43cf06eabdaso1438715e9.2
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475391; x=1742080191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mLqJv5GFiMdqC5SzSdRzdt+1VdUICrsHDhSI3tGgwd0=;
        b=f+wMa2qGhN6yFyd0GOwQiweN0LBf3BfZcsB0Qge/CFnnS3hLoyaD0KzxYYQfDEs1Ya
         kRXTjifMSK7jA0KFUPTi+Q++UE1cbtiGw7lPhqLPl6RoaYGw5MkZB6X0nNOzlpgIUduf
         TZiEx/xtxcM90SKkcb1ddOUqEFl/KO2GKdCpU1ClIVY8f2JsUGWG9dgwwTGuTot+daxr
         4dsN2rXPY3c6/+C3YxSBD3oI1GN+zgK5IEhC4q0A6pnG8DsUuuFPi+bOyP83KHYzNPt4
         zWTMk5TCdofoi0lhNJty/psHPkGIbrkq6xxesqRcaX63pGn3F2KnfnHINnp/jn6ptlVE
         QGxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475391; x=1742080191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mLqJv5GFiMdqC5SzSdRzdt+1VdUICrsHDhSI3tGgwd0=;
        b=URNYGZvt4vTeYok4FATqVqLsA5rWo84l3HQzFMnDsdRm5kZNx3u3Ic1PsydxPV9dsH
         m8ENm60WWzwDtFvnaNJwE6FP77gkD1tOAJjgBfyGj6U12V2xPESBdqcaQkWaoSj92DJQ
         hwXCCbzoR+mRYQXaBARkfkQpFhQAsBflwZRt4U2w7z47Ehr1R1vIcaM/DLuF+WeN4vrP
         hKT4ycmybVpLFx48gFbicmJXnd0Ykf8u5T7ZkNhN4TnZUmvk4qTTXsLidj2hMv7E6Y4v
         3nwXNdcEhN6DxzvruR6zlif3zFC4WaWTbWbbKc2dEhwrAjQzTYuvIofaR1QR2xK2KDWv
         NseQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdazO1tUOgXDxy5WWcJWLP2mPMosywavzkqysm2MamJt/h5WzbYvH/nnbOCzEfK3UndD8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrHp3UNxprhGTtQbUB7ToOjjBxzWVC/LGmJYWVjGgEXhq7m7w3
	X67QPhenDqz8CqTLZCSOogLEkMT7bi4sfc3F/5Ct0BoI5osYKnUqJaQNUpqSFJo=
X-Gm-Gg: ASbGnct2r0eLxIeSMFgHjuTFt/srEV1sf2vQqDy8Pp+Gxk+iBD0gLXB+KnQlCbSrQJK
	sSCD9WG7bo9oSU3Et+x3cDofpAOEG2ugMkJimMvvJxcd16TM7wJumTGAKWzVwf/25p5n+qy6AfO
	qKv+gSzuJp6DqVnHg7R9Ci8FRXp9mp3UyRJCTrZs0vA5372cFeEERyqNfUd9vu/Tr65+yE+/vXj
	MV2uvD+j7yTN0ks98XrhBSxEDK9p4AHiR0t5XL7NSDF5EogAOd3AWYoT4yydvZmSlpYclcmcQny
	GjhSvG5hSD9RPu6hwfokfF2cMPfOKRct9Fax/mavzCiCKDce+YTgIe2kDYWNUBx2xRLvIVppxZ7
	5FbmXaRiZ+tK5bfVSbbI=
X-Google-Smtp-Source: AGHT+IFoLK+xqCwbE74i/YFIgsjJ7Nm/q7qXKgEmlP4DidAEt6Fl8aqw1QkG8mrCX5ar2z4veKXWag==
X-Received: by 2002:a5d:648f:0:b0:38c:2745:2df3 with SMTP id ffacd0b85a97d-39132da24bfmr7412108f8f.37.1741475391309;
        Sat, 08 Mar 2025 15:09:51 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c102e01sm10299396f8f.93.2025.03.08.15.09.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:09:50 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Eric Farman <farman@linux.ibm.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Peter Xu <peterx@redhat.com>,
	kvm@vger.kernel.org,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	qemu-s390x@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 05/21] hw/vfio: Compile iommufd.c once
Date: Sun,  9 Mar 2025 00:09:01 +0100
Message-ID: <20250308230917.18907-6-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250308230917.18907-1-philmd@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
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
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Cédric Le Goater <clg@redhat.com>
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
index 784eae4b559..5c9ec7e8971 100644
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


