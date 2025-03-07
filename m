Return-Path: <kvm+bounces-40377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B25CA57004
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:04:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 472647A9E20
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:03:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DB5121C16A;
	Fri,  7 Mar 2025 18:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZIQM7Tfg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F055923F29C
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 18:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370678; cv=none; b=qI9A1VhizhNpQ3KMtzq7YeRoDUad8yBJOguO4OxjK7eexmFDftcjQqCw4lDWlMlVBN/wP3uNPHt4wLoQRFJeTY3DmaPZLFXWmf/E0c+z0thlAXMmUGhg/theIptcFKNvbfmj9Q6lgb96g3+764L9yXVHoCrpXObbQySDNQeJ/yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370678; c=relaxed/simple;
	bh=U6hkGzDkkh1f4TzbGH4D+UA1K3GyDuZ//h7KhIjCPPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=biGmWNRMDZ2O0bbQnMWT1oeN3KD9mfDRGZW9YimAINgU3TvQBAh41rprfSUIs0tm1IOZoHVymWHbySDpxAzcX0ThwTQLOvcZjeRHVXXQJomQKjHkitzQtfp9PV5Rsis/nhHbZ0y13rCFAGFrzbtkhvISWmfr7VDycFg8YE4jH90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZIQM7Tfg; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43bb6b0b898so18301285e9.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 10:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741370675; x=1741975475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jwX1K0+iQl31BRmPX8xi9KD5c4T56nkQjSQYXLzdF0A=;
        b=ZIQM7TfgQ0/DTfPkV2sov5pWjpUMXDHM9r3VXNYOpcZKnjMkROhB/5QJXpWeHrhKec
         z6RliL00FNc2fkY00uOgWXtq80Y4FA2VAwrY9Iu55vKEM/MyCbh/tnqCCPZ8S56esOLo
         xQZzNfXk7WE38wmmVwE4aYfK8cC0m3E85Xi2zcnIijAA3/i9O/9KLRf5Nq7mw6pDB0je
         6O4mJEcEU1MAK7v2SnS4RrH1y/4XIxO8fLN/yhYa9Y+S9lh3Iev5Qc0AS8EcRmymtXUk
         Mddd4Tu9Nt3sDO0ezIsaYklCTcuQ7abHCoxldH85vuZygDKrfYBMymbt4t6n/K9WS1Dz
         dRYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741370675; x=1741975475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jwX1K0+iQl31BRmPX8xi9KD5c4T56nkQjSQYXLzdF0A=;
        b=Jez5+rYvmhKv2GENPwkhuWa4Aq+TvJCAFf4IaGjqRV809IGzCFKhY6UVNC4tuucKpS
         7yrhybR+6XdmuBC4F+WW+PykXXkmO1icv/HDmFCaNuoeF8n0BxapxMgeQsC+Di85mnIP
         bIgh9Ii2FLlwONMr00fn1hAwdBNwmXDIp2WDzbwSfR1To45b/HazlFCZ6jJxOG24idLg
         6h7OJopCB4DsdefLdPscbWH1Y5r+7wEmlaHhELyyCGkcJgLPVgCU+WMIsd1kQ4WC/8eV
         7oFBcLQ+u5tNG1ydzcDkOmJurKkGKPUIdiQLAncSk5/Sc41I1+10XAVCjpJzgcPPpJ0h
         voww==
X-Forwarded-Encrypted: i=1; AJvYcCUKr1lKs/DqPH4uxU+1Qr2jG4FPny4iTl5KL1VSVYRdmmGsaLKtXTr0NxJ07hSATHkShDA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe16RfzZyzAf4qDeKRAUFtwdlmGGO3igrLCMlJw7AzxPm0IvWJ
	bfAXLQZEDnQp0K25mbymtIdZlZvPV6yab8sz6ZkCa1wTO/vED3kUSi+FTYnvfl0=
X-Gm-Gg: ASbGncuFGv4cqVhSPmqWn8PCmlZCDl+Bam8gSq3vmVgoElfwzzC5MNH5WFBIL/Vk3Jy
	D2o0GrgUwdySoD+BRCIfjJg3SPYibxWwowjNAYOKhhUVrhXMWtrTk1VYB2ewcCAn0vM5ZuMB5nT
	ls6VB5E+2Y2SEwtrzpjVdSfObtC7PGojzwHFcIf4/EmOXtkYW92hh8BkLEAK+cVBKhR15ZLLk6P
	qi0IOnjQdst2jARVoJskz8HvFNmgiY86KrQ35cm1HgNq2zwvKdxJojT2XZViedr3C9+eNtHdyhx
	v0I4AEpClaDVH8+uLPj3JF/eB35DV/5LWRdLCrntgLOATXvYq1lUnuIYNHuoL63Zd048P84zu31
	Un5vejzyxk5PCLpfqvDI=
X-Google-Smtp-Source: AGHT+IFd2dAhiRB8kpwGRBj8I24YTq49QXdG4iwSMQDOtTBB781rulRfrC60gif1x5YVtYtrXppgDw==
X-Received: by 2002:a05:600c:350a:b0:439:86fb:7326 with SMTP id 5b1f17b1804b1-43c602082a0mr29865065e9.22.1741370675155;
        Fri, 07 Mar 2025 10:04:35 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd8db6c7sm58089865e9.22.2025.03.07.10.04.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 07 Mar 2025 10:04:34 -0800 (PST)
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
Subject: [PATCH 10/14] system/iommufd: Introduce iommufd_builtin() helper
Date: Fri,  7 Mar 2025 19:03:33 +0100
Message-ID: <20250307180337.14811-11-philmd@linaro.org>
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

iommufd_builtin() can be used to check at runtime whether
the IOMMUFD feature is built in a qemu-system binary.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 docs/devel/vfio-iommufd.rst | 2 +-
 include/system/iommufd.h    | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/docs/devel/vfio-iommufd.rst b/docs/devel/vfio-iommufd.rst
index 3d1c11f175e..08882094eee 100644
--- a/docs/devel/vfio-iommufd.rst
+++ b/docs/devel/vfio-iommufd.rst
@@ -88,7 +88,7 @@ Step 2: configure QEMU
 ----------------------
 
 Interactions with the ``/dev/iommu`` are abstracted by a new iommufd
-object (compiled in with the ``CONFIG_IOMMUFD`` option).
+object (which availability can be checked at runtime using ``iommufd_builtin()``).
 
 Any QEMU device (e.g. VFIO device) wishing to use ``/dev/iommu`` must
 be linked with an iommufd object. It gets a new optional property
diff --git a/include/system/iommufd.h b/include/system/iommufd.h
index cbab75bfbf6..ce459254025 100644
--- a/include/system/iommufd.h
+++ b/include/system/iommufd.h
@@ -63,4 +63,12 @@ bool iommufd_backend_get_dirty_bitmap(IOMMUFDBackend *be, uint32_t hwpt_id,
                                       Error **errp);
 
 #define TYPE_HOST_IOMMU_DEVICE_IOMMUFD TYPE_HOST_IOMMU_DEVICE "-iommufd"
+
+static inline bool iommufd_builtin(void)
+{
+    bool ambig = false;
+
+    return object_resolve_path_type("", TYPE_IOMMUFD_BACKEND, &ambig) || ambig;
+}
+
 #endif
-- 
2.47.1


