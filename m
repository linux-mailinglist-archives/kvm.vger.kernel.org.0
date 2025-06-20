Return-Path: <kvm+bounces-50093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 498B2AE1BB0
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:12:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0C7C1787F3
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA39529187E;
	Fri, 20 Jun 2025 13:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rMtF4Jhj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CF1291880
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424982; cv=none; b=SWgkSVEm8uSVP5RfL0AhD2SIs2nD2Z/G94w/l3MtACIlw8SLSypS2KBpHV7txftaBJxugcw0ug8DBIf8+xbYDteqaGh8YbZp9e4DRtIDQCCdKzxYZ7uBXfOWOOP8aBtoMMlbs1Otm35o6ME5pUSdEBz868bCbM/EUu8cHGr7N1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424982; c=relaxed/simple;
	bh=4GaVKajVYypw9MuibPTrlwQsMIE6PdjmlY0G5wy8d74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GTkqsK21RkH+KGVOOByM/63wAUs/U4lYuvgpPP1ENAtrtFhhyEKKiOGJWlP2uncbZww8A60WRB2SPOy5JxEcsvxWL/R7WY9QyfPxm9rHB+g0EfPbr/SKhAW89mtsChH4chjxNFKp4uLectuoodBwrFwh/V0q1f7f2Zjj1qk8ZtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rMtF4Jhj; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a4e742dc97so1830201f8f.0
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424980; x=1751029780; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w6n2BSSxRh+KStXe1TUl7/blQoxrrxglxVgcpHIzilA=;
        b=rMtF4JhjzITbk9UJvK8xjDzaC7za1Q4oZoUFcU+vhCceqjV2XpleRS9iWnmXtC9zL0
         l8+hEelCRCMNXQrW3Er0MQgUZTMI0/3OhEV/v/IP6ye2+lM7hM1yr93l/n4zxSI0mez0
         yU40aSOiGORuJWmH0Sz8u71UUhbu99fgTC2z5mwlhwadNiae4d3VA/1dedXvoZLyrU3K
         e9PDcPU66GQetwtZJRfYCoqEJ0OB03jeNXgOssODFxdhfrEsBrUto9NYWrd5N3LD5Vg4
         eBNUvDsP12Du6GHb5btzeR0cobBvaJxHG2Z4PCuwnlCXZADcj9e/txSNpdtcRwlqxTow
         abaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424980; x=1751029780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w6n2BSSxRh+KStXe1TUl7/blQoxrrxglxVgcpHIzilA=;
        b=gSjONb6uLd1nfCHeTbhRX9oVgFJ9FCbxP+zQV4/icyXq5LAruKGJXBvcxGX1vUwR4B
         zq+DOgdnqgUp8NOrbLUS4bZLCjtL3pvNV4subv6RdNbhFUUVMGytWoBuASOBcsIH7ZaX
         dU5SM2s7KzuPo4O4uGYlG/lH+BLQgU/Iea9Yb0g7maXVDjt4ryiTdWYz6rinLtR7Qp3F
         BJOJJL0Ik9ZfR09ARf3mrh8nt9T/sB9O1z8p6F2uXnim5gWk+87OUrOUd3D7Vn7hMlTc
         DNlcO35YloLC8DHKP5ctnoFag7LQbAqmqQ7cfUnTGO9DGBsO3TAbI7hGyBJE3FQMZvbE
         zT6Q==
X-Forwarded-Encrypted: i=1; AJvYcCX4JrVtXpkj/iIR0kuTIhsJPLTIXNRrBBt/Q84DlijT96GVERPYZvw21OJ9sz4fplHhgyA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhM66k7Rp1Ue/ZGZ08JlftAxj0SgZB96bJn3eLYYobH08yhqjI
	vz1RYWiz294ym/+AJ/9+Fjyq9y9UqHQolW/AcQleVrjgLejHXqFrvcpJEVTde5GapK0=
X-Gm-Gg: ASbGnct2LHQj6tszdFbgHPm4CHNecASY2oEtmxIFFYylh3hcKUigMFEqlZzN0yjsem+
	r1xQLpAFlgfC3WYzIz3XuUBIVjgAP3DVI/porTAtpwvkNzObUbVbBQrFQGUxgybJIIfVR+P3sau
	38WXLp7RdxZhObV2fkWdEft66/utzYmtl3Ad7LjSBCiZHPAgcrp0b4y8oxE8XwmcmWZZDuxSLLf
	EJ1LKToq+/u/gAkdVHQLKUFY6kt/uiD7aqhvqLWWfRYf9yy1M8iiNnB7nuEsB/8r43ntx43YAVf
	1VX9TpXFwc9AjIVTkYYx8J7a+lmtuY2KqWu3a9HiAQc4Rbq0zHx7Yqmw2qLPeKOMf5gLylliWVb
	3kt55Pmzm/4xTl7WBHwftB52caA7FpYqQ8aII
X-Google-Smtp-Source: AGHT+IGXwFQFfwW7rAMovUtfDAuB9Dz2J3aZxTUZqf2DF7gPQ8T5LAmGCEyFfgo/pTiyQMieyUC1PQ==
X-Received: by 2002:a05:6000:26c8:b0:3a5:8977:e0f8 with SMTP id ffacd0b85a97d-3a6d27e16f5mr2027646f8f.19.1750424979716;
        Fri, 20 Jun 2025 06:09:39 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d1188804sm2015800f8f.79.2025.06.20.06.09.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:09:39 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Bernhard Beschow <shentey@gmail.com>,
	Cleber Rosa <crosa@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	John Snow <jsnow@redhat.com>
Subject: [PATCH v2 26/26] tests/functional: Expand Aarch64 SMMU tests to run on HVF accelerator
Date: Fri, 20 Jun 2025 15:07:09 +0200
Message-ID: <20250620130709.31073-27-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250620130709.31073-1-philmd@linaro.org>
References: <20250620130709.31073-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 tests/functional/test_aarch64_smmu.py | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tests/functional/test_aarch64_smmu.py b/tests/functional/test_aarch64_smmu.py
index c65d0f28178..59b62a55a9e 100755
--- a/tests/functional/test_aarch64_smmu.py
+++ b/tests/functional/test_aarch64_smmu.py
@@ -22,6 +22,7 @@
 
 class SMMU(LinuxKernelTest):
 
+    accel = 'kvm'
     default_kernel_params = ('earlyprintk=pl011,0x9000000 no_timer_check '
                              'printk.time=1 rd_NO_PLYMOUTH net.ifnames=0 '
                              'console=ttyAMA0 rd.rescue')
@@ -45,11 +46,11 @@ def set_up_boot(self, path):
         self.vm.add_args('-device', 'virtio-net,netdev=n1' + self.IOMMU_ADDON)
 
     def common_vm_setup(self, kernel, initrd, disk):
-        self.require_accelerator("kvm")
+        self.require_accelerator(self.accel)
         self.require_netdev('user')
         self.set_machine("virt")
         self.vm.add_args('-m', '1G')
-        self.vm.add_args("-accel", "kvm")
+        self.vm.add_args("-accel", self.accel)
         self.vm.add_args("-cpu", "host")
         self.vm.add_args("-machine", "iommu=smmuv3")
         self.vm.add_args("-d", "guest_errors")
@@ -201,5 +202,9 @@ def test_smmu_ril_nostrict(self):
         self.run_and_check(self.F33_FILENAME, self.F33_HSUM)
 
 
+class SMMU_HVF(SMMU):
+    accel = 'hvf'
+
+
 if __name__ == '__main__':
     LinuxKernelTest.main()
-- 
2.49.0


