Return-Path: <kvm+bounces-40367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90F18A56FFA
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:03:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCD6416E146
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:03:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4959923E229;
	Fri,  7 Mar 2025 18:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sKmFfI9q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2A021C16A
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 18:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370623; cv=none; b=mWgXBdLiMISOaBOc/Pxw6C/OMQ2D1c/IFIJST6c/DiZOKV86ZJ2DDYm3eHbxdvz6x3HiVCEKUJKH7kRz50LzlwZk1F1l2/QotRfYb7AZLJWGQC0WEz+stgd+SYGRpceJy2iQgLXvEd+va5BdRRYVnBenKuwIFSuhqIJ6fcL+IzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370623; c=relaxed/simple;
	bh=a3DdeA32W87FgQ/xhadkA3m244c0tJayVWUSPA4Rb/A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XVqxj2vm+9LJvX5sA8a+ovWnUJ3yNH01AM/zSvsAEmXxyVATX8O3UQdKKaa3s8t1Bn4gnU5RbKi1tIwwm/5ypQMhdVqLZaMtWz3012a54LFPpcjphazcE8xOPk1MHskr28ZBcc4i/gIAqCqSK3sS+kA9ydMnu0aYvc+oITd8Nzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sKmFfI9q; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43bc638686eso21300245e9.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 10:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741370620; x=1741975420; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q/oAHM+o1HyAZE1R9TLHu1sG81uMnmeMuAy/uRUVPY4=;
        b=sKmFfI9qxVgcmswmjPwuEghx1r2VJcTuxFvMDYjuE+5DP+An95bYLftS+86aZHrvH0
         BgWW+BKkJYbGeKrew7fmOLASbOp4IPUZGICcMiJRibWKvXZIXK/fdoMHLK2tPaZ7yRfW
         E/AHBw31JSgBuhxr/SazNFbLPtK+AgXph1S3R1PaK51bMZI3ntoD3t6E67qWCkggqOVg
         1PCLs0Kt0Kom35RhoXpea4B9gP8nAMJPMWfswUXBYMr6S3D3OchJ+YmUp82Oy3xLhMZ0
         DS7pnx0OqM5HcO1BhdLDbnSdlQh7iOqGZv4h5uD0odtSNovL/5HsDCo4qSlVAu5WbuFp
         Y2rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741370620; x=1741975420;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q/oAHM+o1HyAZE1R9TLHu1sG81uMnmeMuAy/uRUVPY4=;
        b=In0bRtx5d6jNSb550+4DbtnVYW/hupn71PDttqNvv4ArAC5+FM9WVfAduTDCyJ/FKi
         MBnLYTwXKlEfnRSAu+kJkLAwORO70cR6czvee9UpzzBn0d3MuybtB1qvMzsNYg5mD/8T
         kwKuhYUwotu/0zev3RjXnrPhbeEsX37hCMrM8HW699f3WIWRE91fxphUaSeCSLVUo5ex
         xOWnpEttC5/T9cgH54zL66QnDrbmTm1SH8w0SvKkrHPCyoH25mea1LyrZl7cz2L7ZAjw
         K5qOEg+uT8yQpuP6X3GQpP8sCnxFw0ASIwIyn1QTcrY7G8Pgp2V5mey4PbNKM4+Evt7e
         rOCA==
X-Forwarded-Encrypted: i=1; AJvYcCUV+/Cj1igRA6ilBNltbyPrVbdp8TC1uWSL+ZUjHOAfg5+Qe5lgn4FljCsAFYZpHRaK6XQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzDAV3O0i+XC7HIaN+Ns/x8E48IIH6X5Mw5nxz0AJEVY+7aG3G
	y6K4YHDxK0XEXEeEXOqbPI4Ra6bx+xMW4gMzI0GK3k6hdaT7zkgHXLc6Ir8/Qyw=
X-Gm-Gg: ASbGncuv0p3zanTEoiIY6CAwSwHbj6509ss5GOx/JtNIcqXK+6AUYy6motHVONYs4IQ
	iAz5ifuwrq4phr/+CPfihdxMQaReiIh7C1zmzgpeFMxV12E0bdvXPvUFxZkyOO6kcIWgxQcmwNc
	WQZeDyIDzbJhw4y+4LVT4A3IyNUcjzzvg6gJsW58clAu8vy1+RgFyUdtrmHWTaUatlH7FEtkydm
	3Le5GacheLFc+Y5ScULgskB/6Z0oJaEyvOKXE4Y2Umdti8LjeHLLETI70NBPHpGQmyGJjeY87Yw
	KI0pi5k0qNvKIE5Aer1q6Bt9eOVu0PouM5BZg950McabywP0O+5DS2/bbPqd0g1wPRrcvArRotX
	Un7wdGIiCpBpkOvYZzB4=
X-Google-Smtp-Source: AGHT+IGJCt1VGdsMr+uydjBiH7JPgewvP9Ih/z/ZXT/fA/i9Aw0RMbjmlNL8hvAx3QH87mYJ2fMqvw==
X-Received: by 2002:a05:6000:1f84:b0:390:ec6e:43ea with SMTP id ffacd0b85a97d-3913af060e0mr441014f8f.15.1741370619758;
        Fri, 07 Mar 2025 10:03:39 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c0195bfsm6006751f8f.48.2025.03.07.10.03.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 07 Mar 2025 10:03:39 -0800 (PST)
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
Subject: [PATCH 00/14] hw/vfio: Build various objects once
Date: Fri,  7 Mar 2025 19:03:23 +0100
Message-ID: <20250307180337.14811-1-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

By doing the following changes:
- Clean some headers up
- Replace compile-time CONFIG_KVM check by kvm_enabled()
- Replace compile-time CONFIG_IOMMUFD check by iommufd_builtin()
we can build less vfio objects.

Philippe Mathieu-Daudé (14):
  hw/vfio/common: Include missing 'system/tcg.h' header
  hw/vfio/spapr: Do not include <linux/kvm.h>
  hw/vfio: Compile some common objects once
  hw/vfio: Compile more objects once
  hw/vfio: Compile iommufd.c once
  system: Declare qemu_[min/max]rampagesize() in 'system/hostmem.h'
  hw/vfio: Compile display.c once
  system/kvm: Expose kvm_irqchip_[add,remove]_change_notifier()
  hw/vfio/pci: Convert CONFIG_KVM check to runtime one
  system/iommufd: Introduce iommufd_builtin() helper
  hw/vfio/pci: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
  hw/vfio/ap: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
  hw/vfio/ccw: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
  hw/vfio/platform: Check CONFIG_IOMMUFD at runtime using
    iommufd_builtin

 docs/devel/vfio-iommufd.rst  |  2 +-
 include/exec/ram_addr.h      |  3 --
 include/system/hostmem.h     |  3 ++
 include/system/iommufd.h     |  8 +++++
 include/system/kvm.h         |  8 ++---
 target/s390x/kvm/kvm_s390x.h |  2 +-
 accel/stubs/kvm-stub.c       | 12 ++++++++
 hw/ppc/spapr_caps.c          |  1 +
 hw/s390x/s390-virtio-ccw.c   |  1 +
 hw/vfio/ap.c                 | 27 ++++++++---------
 hw/vfio/ccw.c                | 27 ++++++++---------
 hw/vfio/common.c             |  1 +
 hw/vfio/iommufd.c            |  1 -
 hw/vfio/migration.c          |  1 -
 hw/vfio/pci.c                | 57 +++++++++++++++++-------------------
 hw/vfio/platform.c           | 25 ++++++++--------
 hw/vfio/spapr.c              |  4 +--
 hw/vfio/meson.build          | 33 ++++++++++++---------
 18 files changed, 117 insertions(+), 99 deletions(-)

-- 
2.47.1


