Return-Path: <kvm+bounces-40500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 378C4A57FA7
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:09:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C78C1884ECF
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B6420C468;
	Sat,  8 Mar 2025 23:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EBUNbpoK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB95C2FA
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475364; cv=none; b=gezfyMjxVfqK2r+IQXrJuX8Fn/Qpk/bc/5slpGS0VeLQFZ3OXpbIWWfM8BhK+dTHsHY2ezFJm3doqCxRXj4O8TwAZgc+c9Qk3D1qLDSV7Wdv/DG8j79o5D5roDtUjzo6lxDC17QrB8p9ML+zCJOqwRr44LsWSkfR2LpQlcg2ZDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475364; c=relaxed/simple;
	bh=f7ZqRrRPrD5LqXVWQX0zQ2nOmYHL9JWk9n0syraHzcY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=m9GU91F+b/syeWT6yf0ZunLnwNInZeA9mJGrem6/slLX+tzKUeoTKvcuo7PwzaBpOMIa47lTZUJg9q/INXLhx4g5ME0EZemc2WqRH/zEricg8wqyz5PVJeVDn5N6B7M7D8yHzhgW6HRO6kIF4kKVcdR2gexYBvt2Zp2PxAPMqcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EBUNbpoK; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43948021a45so26053085e9.1
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475361; x=1742080161; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ObCXdxBV5FFXTAkBikkLyhnu4rSBn8wDnLJnCi+DE38=;
        b=EBUNbpoKuDGzxDTn6q5OAIKNsZV74Y4oOiFRqWxVYzgqk2UFyHw0fZ0CTxv1IR6gJk
         wLRr9VOz+5eWXz/TugikLsORF2fNBY9U+eT9SJzdfrPvwHwkXgrNtAwTHZjUbtjFGFU6
         cXeXrDauBGMgFK+XNXkz4kiDa1u/fGwDh1T7noaIuvSHilUTWnzMx54coCH1xwl5XQdp
         9MMHQ6JidX7rMKdQokyBHBc2jXJ7W+0kQgpa71juULogHAGKrlZMPpHHS2xOVrLe3QCF
         TreOJrVPHrXDX/5aHRKhrBXXLxc2hhhZbonrihhcxYYM/9P6QvoiUXOWSauggKEnfxNd
         r4LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475361; x=1742080161;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ObCXdxBV5FFXTAkBikkLyhnu4rSBn8wDnLJnCi+DE38=;
        b=l+LUzzQi1iANLYRrfvbKv4UhbNP/ciCMRAYHfAtsA7IKwvHOXXt3vlg4Rkb3z+YPYp
         YuoSWHv5spPMgvAcUpyeU4fRhnZS17Qng5DktnXi06/xJ/qLMZwb3Ss5brMMr5h+Rr0K
         9VFpYVklLs6zYlpL8Us60dOTJQXW1uOOXNm8frwc9cPvyjnwQXaoNqo+UAiUMB9MUdxx
         ESawWhJbwpZpzjoE9tGq8z98Fm5c5VVn+FT8O1h4/h7VWCbWVJ87owyB0ZtWntg79UbB
         R2dpwRHE0j14OR6A4gpPFQB6SdRT31UGikZkG22hQ9gbidZa6XTtgP/VLwPd5uMgCYs5
         GWNg==
X-Forwarded-Encrypted: i=1; AJvYcCVQwYdRuPMQlolOSAjpiggxmb/D/SgHKNE2V7qAt6AXGb4o60i48Jn9a8pEZQSBPezSvWw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaaYwIbb1V/3k8dWOShXVYwsnZL7OBl7b16fX/y3Zvu4jtf5Fe
	VJ2CzXjyY8G8ytyiRxBpfU/0cGQO6Wy+9Pg1OkuREbGoUIUKbL5U2lpXOAyFWNE=
X-Gm-Gg: ASbGnctUpheqxfPjJY93C4rV21+tmHGkPj1LVwlcY6eBFvV5VvDtRSIWkW95uHZuFe+
	5SboWKlLIwWWSnKEFtHinHc8YZRoDJZB17g/SmMxsPHnjiLheYD9NTODwPl3nGdpVgbI3IBT7MA
	IPLCL3WnrjaDYcliXL8uiui4vCsS4bpEIy6e9qkqGZIPBiY40jWk/Rc4aM79ti5sRgyfPA/VeEJ
	YD3GYgX/nMQSnzEzxug969t+xBWH+ka5KhGSSBcvcfIXmulFXLxkRiNwsmThMUrsSkLGR6/MAA5
	uaFjMC0ZmyH6HRv+Yf7FvYusIWehvzs4Ph5lIT8YkfDP7AR4aPiuBmJjWxXctF8b0TKq7iNEDou
	0zXlTovf2xWoL8hQLnx0=
X-Google-Smtp-Source: AGHT+IF98pReGBpdgLDkhd0lnLr9OBzKY1FVvFofkKlVXFbwmBnEwNlkFJzcxYQ3ZA/xQH45IkWqYg==
X-Received: by 2002:a05:6000:2107:b0:390:f6aa:4e6f with SMTP id ffacd0b85a97d-39132d306aamr4468226f8f.10.1741475360860;
        Sat, 08 Mar 2025 15:09:20 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd435c88esm125768485e9.36.2025.03.08.15.09.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:09:20 -0800 (PST)
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
Subject: [PATCH v2 00/21] hw/vfio: Build various objects once
Date: Sun,  9 Mar 2025 00:08:56 +0100
Message-ID: <20250308230917.18907-1-philmd@linaro.org>
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

Since v1:
- Added R-b tags
- Introduce type_is_registered()
- Split builtin check VS meson changes (rth)
- Consider IGD

Philippe Mathieu-Daudé (21):
  hw/vfio/common: Include missing 'system/tcg.h' header
  hw/vfio/spapr: Do not include <linux/kvm.h>
  hw/vfio: Compile some common objects once
  hw/vfio: Compile more objects once
  hw/vfio: Compile iommufd.c once
  system: Declare qemu_[min/max]rampagesize() in 'system/hostmem.h'
  hw/vfio: Compile display.c once
  system/kvm: Expose kvm_irqchip_[add,remove]_change_notifier()
  hw/vfio/pci: Convert CONFIG_KVM check to runtime one
  qom: Introduce type_is_registered()
  hw/vfio/igd: Define TYPE_VFIO_PCI_IGD_LPC_BRIDGE
  hw/vfio/igd: Check CONFIG_VFIO_IGD at runtime using vfio_igd_builtin()
  hw/vfio/igd: Compile once
  system/iommufd: Introduce iommufd_builtin() helper
  hw/vfio/pci: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
  hw/vfio/pci: Compile once
  hw/vfio/ap: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
  hw/vfio/ccw: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
  hw/vfio/s390x: Compile AP and CCW once
  hw/vfio/platform: Check CONFIG_IOMMUFD at runtime using
    iommufd_builtin
  hw/vfio/platform: Compile once

 docs/devel/vfio-iommufd.rst  |  2 +-
 hw/vfio/pci-quirks.h         |  8 +++++
 include/exec/ram_addr.h      |  3 --
 include/qom/object.h         |  8 +++++
 include/system/hostmem.h     |  3 ++
 include/system/iommufd.h     |  6 ++++
 include/system/kvm.h         |  8 ++---
 target/s390x/kvm/kvm_s390x.h |  2 +-
 hw/ppc/spapr_caps.c          |  1 +
 hw/s390x/s390-virtio-ccw.c   |  1 +
 hw/vfio/ap.c                 | 27 ++++++++---------
 hw/vfio/ccw.c                | 27 ++++++++---------
 hw/vfio/common.c             |  1 +
 hw/vfio/igd-stubs.c          | 20 +++++++++++++
 hw/vfio/igd.c                |  4 +--
 hw/vfio/iommufd.c            |  1 -
 hw/vfio/migration.c          |  1 -
 hw/vfio/pci-quirks.c         |  9 +++---
 hw/vfio/pci.c                | 57 +++++++++++++++++-------------------
 hw/vfio/platform.c           | 25 ++++++++--------
 hw/vfio/spapr.c              |  4 +--
 qom/object.c                 |  5 ++++
 hw/vfio/meson.build          | 35 +++++++++++++---------
 23 files changed, 152 insertions(+), 106 deletions(-)
 create mode 100644 hw/vfio/igd-stubs.c

-- 
2.47.1


