Return-Path: <kvm+bounces-47661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E141AAC32C5
	for <lists+kvm@lfdr.de>; Sun, 25 May 2025 09:49:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEF493B9E05
	for <lists+kvm@lfdr.de>; Sun, 25 May 2025 07:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17F5817B50F;
	Sun, 25 May 2025 07:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HJOJw7T3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FDF2DCBF7
	for <kvm@vger.kernel.org>; Sun, 25 May 2025 07:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748159378; cv=none; b=ipI0lzxvBPe0DZxmwGQWuqr2+WBXpQJBaeCMvZwIhX+gcQX6fYOaoIvtNqyohQSKVuIrcrQ3K9JaVMINeH882xHDWMwjp8flk8rMvi8Kbv6BGnKu8SUsG87yrhcg+Le+kJOfljxZetHen3S/fXWqV7afksfuOiYfFpDb1IyW950=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748159378; c=relaxed/simple;
	bh=+kgv0ieRAs1DLuTnrmkcE4js63cQBWKGd04j1Q7RAWc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VGaayI8pa9BgkMINBl76dGM+u1m79laGSYLFZf9UfcfcHFkLjflO64/C/oiSZ9wgyFvbjCGvdytbfh0Xcj2naY1vO/hKSy0gx8J6OwTKvZEqKhCXejBvC2d73QGS4Oyngtbzahh/8xCw9pje2MkMRqae5ZWMwROI3UTruOMTfMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HJOJw7T3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7AAC4CEEA;
	Sun, 25 May 2025 07:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748159377;
	bh=+kgv0ieRAs1DLuTnrmkcE4js63cQBWKGd04j1Q7RAWc=;
	h=From:To:Cc:Subject:Date:From;
	b=HJOJw7T3FCj5c7BQjA3FU/tr5bpL2KyRlWuOIzbPLQFL2SClAB8Mb8rXK7AzwW3E9
	 0OOWXkSEgX+vnBAGd8xg6iaAPYU8cZCy6cDk8g+fadjTLyj40wc/R94CoYXXR8Up/n
	 hUCwpiSBF63EjGErnqrj+M3UkTASCSYY9xKeMh7uG3HJRGBn4Qzvw6qsZmnLX4Hz3m
	 7jx5dCEisW6O0+0O6/THEVnEOgplpx7KHLFLzDQXYITbteOitTwfpY4w/wNIycJ/CC
	 RtrQWAL+zfo0q5FRkX4/P0TcsCF1XpV/Y/v/mOHq/ZvYbAeiZJt38MiPX6zwEpNg+4
	 sSiJiNyCXMFVQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: kvm@vger.kernel.org
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [RFC PATCH kvmtool 01/10] vfio: Associate vm instance with vfio fd
Date: Sun, 25 May 2025 13:19:07 +0530
Message-ID: <20250525074917.150332-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is needed for followup patches

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 vfio/core.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/vfio/core.c b/vfio/core.c
index 3ff2c0b075df..c6b305c30cf7 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -9,6 +9,7 @@
 #define IOMMU_GROUP_DIR		"/sys/kernel/iommu_groups"
 
 static int vfio_container;
+static int kvm_vfio_device;
 static LIST_HEAD(vfio_groups);
 static struct vfio_device *vfio_devices;
 
@@ -437,8 +438,19 @@ static int vfio_configure_groups(struct kvm *kvm)
 		ret = vfio_configure_reserved_regions(kvm, group);
 		if (ret)
 			return ret;
-	}
 
+		struct kvm_device_attr attr = {
+			.group = KVM_DEV_VFIO_FILE,
+			.attr = KVM_DEV_VFIO_FILE_ADD,
+			.addr = (__u64)&group->fd,
+		};
+
+		if (ioctl(kvm_vfio_device, KVM_SET_DEVICE_ATTR, &attr)) {
+			pr_err("Failed KVM_SET_DEVICE_ATTR for KVM_DEV_VFIO_FILE");
+			return -ENODEV;
+		}
+
+	}
 	return 0;
 }
 
@@ -656,6 +668,16 @@ static int vfio__init(struct kvm *kvm)
 	if (!vfio_devices)
 		return -ENOMEM;
 
+	struct kvm_create_device device = {
+		.type = KVM_DEV_TYPE_VFIO,
+	};
+
+	if (ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &device)) {
+		pr_err("Failed KVM_CREATE_DEVICE ioctl");
+		return -ENODEV;
+	}
+	kvm_vfio_device = device.fd;
+
 	ret = vfio_container_init(kvm);
 	if (ret)
 		return ret;
-- 
2.43.0


