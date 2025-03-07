Return-Path: <kvm+bounces-40374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14F8FA57001
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:04:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F38783AE89F
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7512823F40D;
	Fri,  7 Mar 2025 18:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AGakfjb8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E887123E229
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 18:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370661; cv=none; b=eooTPkfAq4Thw7qoscwa1fQJvYsv740Y94Sal8MS1q6jF/aS+oqdcnp7MyGFo+dkw/qkF8vMvyp+5uNI9+tizbw5WW4ypaZ2Gmabk3MVBEBP9bYGr7tTpHQZezbVUcxE+xBuhU29DdAQgKFzHs+Nf9hcIEjjRR9XgcBMD6IZVMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370661; c=relaxed/simple;
	bh=IZhCmu4cNUDWxqZM4d4LY3tPB2mJF4YclUHsfrjMzWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HMWleHUDLjUSYdceWNsOtxU6HxAqQ6rxRwL17bRLVlyZ6RN+LB5W4cBNa6CWMBnN4zX8tNKd85W5kUYg/I7oPEPf6VqB3bRxYFlY73ArGCTXBbJvgQLiKVYo3fV8e62ruYvA3wC0fnPc3SyHC2+pyNziUpJJwMgb/9rZmBdAiNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AGakfjb8; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4394a823036so18348565e9.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 10:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741370658; x=1741975458; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qbL4jYEWkDOTQMFiCDljIBBdBkk1lhILqkIilS+kSdQ=;
        b=AGakfjb8ritGnqp/ua+KLYBlBZhhe1bMQlayJVNuNLrLa1akrX8MAGVZ8bauLXNMxX
         CvXmRPz+xvV6mbVzryOLRlo8GUdC/QeuZVOTFC5TW3C3aUl2fnhDJaFJYti+pMVN4lw4
         TqN+IU95bzpN1fYzFTWr6kPSjZ4oL0lmPO51gOQtXiLfdKaFqqNCmeFcC6ibSmdHGNro
         mG6WGcSUR6R40wDbHD/zcX6J0zKBerUqVQA0T+NAubLkvsIZuRp68d1omcPeFESFqt2h
         AScMkcom1eTauBnY1sZrKaZ/HnjCzbakepDr4oBQ41F5gVeRcVvoEcfjCpKzBYVMNwSX
         Q1/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741370658; x=1741975458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qbL4jYEWkDOTQMFiCDljIBBdBkk1lhILqkIilS+kSdQ=;
        b=lm3YZPyiSr83LaMgv4gTvuO/iHOhncmfCMcAlVEahYt2IZEnnCHe3+Mnx8PPNOhpM0
         wQheZsuG+Gi6ymbzCLcagJQ4Eo4bTUwVw/MgMvKKR6HXxcXwdwR4+JWE4AdYOYIWYySk
         wlF+9/cAmZruu+KLSpWTY1D1AvOD5nWqmgK4TXPZnJHdtzz2oD3enhLWs7IilpZAuqUA
         LOHmA3zfaqA7M4CJAqx4povK1CA+u6zw777etYQhlqRvNH+blgucSCXHZefG5R8YS5pn
         mkkrENnCPkC24YI+VvcQL/V5/W1AMjbtBsQ5H24cucSw3uV8m0BxkyrLkunmvM3Lx3Ia
         P8wQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6Pa6QtGV6zOJQsw8gB+37fNxg0MJRm0naeyEkLrOUXrY4LOAE/o96XZQLqqnWDSuWvtA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWaHD/ivtIeyfVc21Nk/562gHJ4jxgqOXlSojuA5lXe7hFUPx7
	JgNI1H+Kiph1BlWDW3Y//MDb6oEJ/qLszqKDVRTXqPPh5EEA4y3a35Eo9mb7Vy0=
X-Gm-Gg: ASbGncvXYyeyApJUS6YmCfXH4KYqth5/CXuyrd2FfgCXPvNFV+iEfGO9GP+2SPIZlnf
	O4kykfolJbo/eTguKhMF8FhW6bqqdQjLbTN/UwFODm3N96o4GOPMfwgRTZYHTmxr5GaslRZjUIp
	Sobi0tGAyR+iSSfVMnpS3my6rub1XyDfp4veSwk6Ba3rwGErvhL9EQUtDgBvKkjU5zFubJChlaU
	XvIfD+GP76+UX7TIni1SmGaqmzyJccY0lCrgGidKPcmCtQaCzFTCmDAENdXjk4lzwJkgfTkiCMm
	QM/lXEwI6EJdFOBGeIKf46FsXO0A7cwihMC0ysfOLQK+iefzJNQ32vpBbjpu6BzsQHtSlbPFBgb
	V0MAu/BuC738MvhaHfrc=
X-Google-Smtp-Source: AGHT+IEc0uflM7XSjD6JKBXbS+veYnGpRErIZqn03oBD1gdH1lamqtUvX68sdYGTF8GJTCscI5i4zw==
X-Received: by 2002:a05:600c:5117:b0:43b:d12a:40e4 with SMTP id 5b1f17b1804b1-43c601cfd31mr33628725e9.17.1741370658139;
        Fri, 07 Mar 2025 10:04:18 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ce3d5a0e2sm5945365e9.12.2025.03.07.10.04.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 07 Mar 2025 10:04:17 -0800 (PST)
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
Subject: [PATCH 07/14] hw/vfio: Compile display.c once
Date: Fri,  7 Mar 2025 19:03:30 +0100
Message-ID: <20250307180337.14811-8-philmd@linaro.org>
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

display.c doesn't rely on target specific definitions,
move it to system_ss[] to build it once.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/vfio/meson.build | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index fea6dbe88cd..96e342aa8cb 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -5,7 +5,6 @@ vfio_ss.add(files(
 ))
 vfio_ss.add(when: 'CONFIG_PSERIES', if_true: files('spapr.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
-  'display.c',
   'pci-quirks.c',
   'pci.c',
 ))
@@ -28,3 +27,6 @@ system_ss.add(when: 'CONFIG_VFIO', if_true: files(
 system_ss.add(when: ['CONFIG_VFIO', 'CONFIG_IOMMUFD'], if_true: files(
   'iommufd.c',
 ))
+system_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
+  'display.c',
+))
-- 
2.47.1


