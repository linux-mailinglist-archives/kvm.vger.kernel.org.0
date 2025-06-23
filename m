Return-Path: <kvm+bounces-50337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4796AE4000
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:27:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7CC617A001
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:22:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E6B8248F41;
	Mon, 23 Jun 2025 12:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y8MBYEPs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBBE24887A
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681264; cv=none; b=jwLycUCaiJCHbDi1pTNtBQpsU3XdHygUD9NosBExVRJWHdewftiIZJj8NCbGkuB4hkmzt79K5xHD7lHxVktCPPHzfSQTBRFxcLuY7MvH1KnB7Em7IluCPRDlPH8SH1s7BGDQBjwZ/afjmoFAVcipcJt09YrYyD8GHvJWggZHmlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681264; c=relaxed/simple;
	bh=NXm0vm/Bzp8UKNwoIkQLAPNADndgBGAabB3FIUaEhpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bJWv49tLzpCgiNr0iFtaCjoK2DMpUfyaiTYmI8P95WFi1gBwEsD2TEIyPNGAoSakUnqkWrvvg+PN1lx2+n0LBqghXHDSTv8zoOivjHXK+YArO0UtpYl0jGeZoIvGQDGIDYVqrNZOJ4ssdAicfK5OFZmJD1LpCHMiiF6+vIl/l0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Y8MBYEPs; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a52874d593so4071553f8f.0
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681260; x=1751286060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=udXllEXY1gPSi8pgPr+YWAsY2WGcZfddjVlJVNiCuOE=;
        b=Y8MBYEPs6cJTOfZGwOavy6/8sSUR2A5YfDBeV4zCmfNeUfoRNHknC2SvQyCoCcF+gq
         Vx0fq/B0P9ErsC5A3EuyZsxUtpNwEiFBkbln4NUi3nM47mb5gh1IRIJFeLzXiJ9fY8ZM
         ScWJNCRtljJxl6E+xmJBqZkOgdqen/8cXsHzaD7B/SVIeVDCrgTQcXD3RI0ZkKfi19Wu
         VfCRTihloGOxO/DnQ+3BWS33qBkucpxlEOwuYdzWBIIKNN56Mx5Wh+kO6bamLj93G6u9
         38nI3wPp9NA2oFZmjzyJRvistsXpRtnR/gYJzoLR4ppPvICj6TOxlZ1bBRvNeiBATTFE
         Cz9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681260; x=1751286060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=udXllEXY1gPSi8pgPr+YWAsY2WGcZfddjVlJVNiCuOE=;
        b=r5WA63Y/+xoaztY10NhX29CIKqquStgeR6BFuQ3E36aF6f2lG0jrHE3wEJAggBi1qZ
         ZrQa/LSUbv6/XjlLn9rmLBH4s0V6b9jWXZvkFKv65CQLfdx1X91R02WiCYN5CTOXdKHs
         cbnKwaM5T04F+jgE43H5ZhSNNbPq44X8NaIyy6IGv74ufp5nLyjMwTBxMnW55upQ9e6c
         Imy+RzOQaM8NgpCXeH3zN8zRVVA5ycN420lxRa+LWfDIq9aJ6j5jx5UbYF+bjYrsGtgn
         yLrFvmtyfKqpKzQahMsOh7V17x1Azk0t0lbwcjbQ2gjRH5MnG6bucFZgAFTHJgeRUnbr
         cfPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdyEvuiMnk7nkhI6oRtmW/vrZHLd05gK2Jhm6g4vD+HuSxBkttM7USWFSghOdy/M/S7GY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpSk0TPa5jWGmQCEknokT4O2pe5VSeO3bvTKe8eJyu+UgtaPKi
	BFun82uP+nEclF5QwgJnnuQXsWa0sRLFO/+y93Tbg8upjoDluxng30VzEs91dxYg4/k=
X-Gm-Gg: ASbGncsomO35P63JWuYXV5OXXK41TUrPjPXgwiu6S+eCKUKrZyE5N2Mr5QWsYRKyc+G
	KT9FQ2KmrLawOpKMXO+BFk81sTiHoEj6AvyYz6pyAp4K1vbMu3eij39jn8uDoWhuOLqvG5YF+6f
	0c9xySrgFBBivMK8KS3WU4zgv0fVx3pWRiwqxvQYvILk0YCxuMuX8OTIM+YFfVwNT3U0ks1lgjQ
	yFBNzi9hmVvfllUzA8cGDtzFcJBWg2PlMmtSwZh+VNeNVTp+L0x/Zl2sNfVncjxC0PJa5Vr3xqu
	PexS9Vwe5RKBW9dU9JxbLZTaV5prybcTfLYzSpkf/psXqhVgneMVIyIl351DDcaUW/KKAR9RqlA
	KQazQpUGmJwvMrnkfzqke3M4NIEkSTlTpl9+y
X-Google-Smtp-Source: AGHT+IGSZgVi8a4ONdtjF7+uNRguyN8Xn3B71Lmx7xCfC5fcG/JmZoeL4oP6TQwKjqTxGU0oRlOa5A==
X-Received: by 2002:a05:6000:2d11:b0:3a4:e1e1:7779 with SMTP id ffacd0b85a97d-3a6d130707cmr5965156f8f.32.1750681260192;
        Mon, 23 Jun 2025 05:21:00 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d0ec947fsm9340220f8f.0.2025.06.23.05.20.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:20:59 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Bernhard Beschow <shentey@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Cleber Rosa <crosa@redhat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 26/26] tests/functional: Expand Aarch64 SMMU tests to run on HVF accelerator
Date: Mon, 23 Jun 2025 14:18:45 +0200
Message-ID: <20250623121845.7214-27-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623121845.7214-1-philmd@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
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
 tests/functional/test_aarch64_smmu.py | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tests/functional/test_aarch64_smmu.py b/tests/functional/test_aarch64_smmu.py
index c65d0f28178..e0f4a922176 100755
--- a/tests/functional/test_aarch64_smmu.py
+++ b/tests/functional/test_aarch64_smmu.py
@@ -17,7 +17,7 @@
 
 from qemu_test import LinuxKernelTest, Asset, exec_command_and_wait_for_pattern
 from qemu_test import BUILD_DIR
-from qemu.utils import kvm_available
+from qemu.utils import kvm_available, hvf_available
 
 
 class SMMU(LinuxKernelTest):
@@ -45,11 +45,17 @@ def set_up_boot(self, path):
         self.vm.add_args('-device', 'virtio-net,netdev=n1' + self.IOMMU_ADDON)
 
     def common_vm_setup(self, kernel, initrd, disk):
-        self.require_accelerator("kvm")
+        if hvf_available(self.qemu_bin):
+            accel = "hvf"
+        elif kvm_available(self.qemu_bin):
+            accel = "kvm"
+        else:
+            self.skipTest("Neither HVF nor KVM accelerator is available")
+        self.require_accelerator(accel)
         self.require_netdev('user')
         self.set_machine("virt")
         self.vm.add_args('-m', '1G')
-        self.vm.add_args("-accel", "kvm")
+        self.vm.add_args("-accel", accel)
         self.vm.add_args("-cpu", "host")
         self.vm.add_args("-machine", "iommu=smmuv3")
         self.vm.add_args("-d", "guest_errors")
-- 
2.49.0


