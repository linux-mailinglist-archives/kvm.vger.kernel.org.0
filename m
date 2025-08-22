Return-Path: <kvm+bounces-55540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D99FB32456
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 23:29:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D86E1CE2460
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 21:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 337D433472E;
	Fri, 22 Aug 2025 21:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AOkW4fda"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08B33469E6
	for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 21:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755897986; cv=none; b=YqExITNuOuVuVb4TM6dZfUlalfNiqRaJ6o/nXkazJZhgCeZX1RNUkscmoK+pQsqtVyxEyJ/MGFBvxHPWZWV8EbS2VKSyGtzZqr8kEChpFzg2ugD2RNavbzEdwWA8fM53vh2kRGj7Q0yhaTQYB/PRkUsjThZGunj2H0Pp+qkaJeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755897986; c=relaxed/simple;
	bh=/gcvHWEicqvg4NHfjT2iLZ2gcQ7MhMrotCT7GSFBNZw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AQx23BrBsntsKQCa6AOFu17Di9glOpobIZP+LrUP3rJsu8e9orUXOju3oAUci7m1wl8+9wE7ZMQoYv6VCFoZvGa6YlnnGTeM43Q62slP9xxAyMDBrkGIumf6WrlA2HAgyeUcxUcxMxCHZXIDQ4o15m+Mmpb7KXhbT4Hlv4sKmAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AOkW4fda; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3234811cab3so2841297a91.3
        for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 14:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755897983; x=1756502783; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XmHVA/Z+D99CZXHsH4HoJkEgTUq7522BHSZkj6XFVEc=;
        b=AOkW4fdaTIo8gaVGvhejaat1sk3mCIj6HEtKBDSpZNdUymg14/b7Egu/I1214HpiR5
         5zXRktXsn845JyDmyxdn3JGO01924JCdUm4OjdbanH1g+toBILsxqs/xaYrTM4iF00tJ
         U78m/Ixh5uNL7MwWKuEMjbCStOGop6bdUk0voudMVfhiEyGccX6LfNIu/3cHebhS8h1/
         +Ni4OdujzSGtNoCyMqomhzaw992rr35AzLJrQMPwzmd4QB3USstWy4yRA1Q07Kx73S06
         yo46iqj3WxRIcTZthvnsEKx/KSsYOg+fz1040xyf6TYXiZe95Qrhaz2kWu3CbqMDasQm
         ZcPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755897983; x=1756502783;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XmHVA/Z+D99CZXHsH4HoJkEgTUq7522BHSZkj6XFVEc=;
        b=TAfK3gFu+wy1MTUalJWy7fNQSfy8IOUBAvvMV7SMopEvNTx3GGai3FkngftLyBYjlb
         GZ3z5AMb7Z2PV2UN21PjIdP7jKeNGkx8DbQm98kQ96RYK4yO4mWCtbEumFGO5BErVrTB
         t2gNSNS70EbS3L3TNIyjTGbMGWP9RV0Oo9Zy/SrRzzI2txtYaVjYCuqBGV826YBybZAc
         QHcN5+/8DIxVUGlPdX3ZhCS/BxERapVJe7j+X7qt1M9oDbKewkrmdSfmJ1gS4mpcvci1
         V9pPhs5Bo/xRDa6rhmL+rk+Adyo+3lGFS1o42YQvKLJpnKfH/fj1D7YVMcN/ZKmxDYhV
         pwCg==
X-Forwarded-Encrypted: i=1; AJvYcCWTTXpHccVVhiorcs1Kbi+ZYYtxzVrWsQl98NJEOX/pulk1Wu7KzO6BO9cSvrK4YWpbwHw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjdZrwFQNv9gCpu60/XHxvj84UIjO4ZdOpRVm+R/rJw4GtfJiU
	iiUoV4GjALg14b9ozUnqixgmzpEnV6wVBSVb1S7EUeWC+KYU7hIp8B0LLkQ4s0xgHzaoo5n8Er5
	G/t3J04BZxjMBTw==
X-Google-Smtp-Source: AGHT+IHt61bhU3of54RHHccaWA4GtPhU7fD5uQAGPKCzLxpAFhcwbNvrb7/A96KLYDRG+P80zSCKBTfj216lZQ==
X-Received: from pjbqo15.prod.google.com ([2002:a17:90b:3dcf:b0:321:76a2:947c])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3e44:b0:311:eb85:96df with SMTP id 98e67ed59e1d1-3251744c5f5mr6822306a91.17.1755897983273;
 Fri, 22 Aug 2025 14:26:23 -0700 (PDT)
Date: Fri, 22 Aug 2025 21:24:57 +0000
In-Reply-To: <20250822212518.4156428-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250822212518.4156428-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250822212518.4156428-11-dmatlack@google.com>
Subject: [PATCH v2 10/30] vfio: selftests: Enable asserting MSI eventfds not firing
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Aaron Lewis <aaronlewis@google.com>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, 
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	David Matlack <dmatlack@google.com>, dmaengine@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Joel Granados <joel.granados@kernel.org>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	"Yury Norov [NVIDIA]" <yury.norov@gmail.com>, Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

Make it possible to assert that a given MSI eventfd did _not_ fire by
adding a helper to mark an eventfd non-blocking. Demonstrate this in
vfio_pci_device_test by asserting the MSI eventfd did not fire before
vfio_pci_irq_trigger().

Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/lib/include/vfio_util.h | 12 ++++++++++++
 tools/testing/selftests/vfio/vfio_pci_device_test.c  | 10 +++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index db08646c2819..9c928fcc00e2 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -2,6 +2,7 @@
 #ifndef SELFTESTS_VFIO_LIB_INCLUDE_VFIO_UTIL_H
 #define SELFTESTS_VFIO_LIB_INCLUDE_VFIO_UTIL_H
 
+#include <fcntl.h>
 #include <string.h>
 #include <linux/vfio.h>
 #include <linux/list.h>
@@ -130,6 +131,17 @@ void vfio_pci_irq_enable(struct vfio_pci_device *device, u32 index,
 void vfio_pci_irq_disable(struct vfio_pci_device *device, u32 index);
 void vfio_pci_irq_trigger(struct vfio_pci_device *device, u32 index, u32 vector);
 
+static inline void fcntl_set_nonblock(int fd)
+{
+	int r;
+
+	r = fcntl(fd, F_GETFL, 0);
+	VFIO_ASSERT_NE(r, -1, "F_GETFL failed for fd %d\n", fd);
+
+	r = fcntl(fd, F_SETFL, r | O_NONBLOCK);
+	VFIO_ASSERT_NE(r, -1, "F_SETFL O_NONBLOCK failed for fd %d\n", fd);
+}
+
 static inline void vfio_pci_msi_enable(struct vfio_pci_device *device,
 				       u32 vector, int count)
 {
diff --git a/tools/testing/selftests/vfio/vfio_pci_device_test.c b/tools/testing/selftests/vfio/vfio_pci_device_test.c
index 82e3c947f45d..1b5c2ff77e3f 100644
--- a/tools/testing/selftests/vfio/vfio_pci_device_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_device_test.c
@@ -129,6 +129,7 @@ FIXTURE_TEARDOWN(vfio_pci_irq_test)
 TEST_F(vfio_pci_irq_test, enable_trigger_disable)
 {
 	bool msix = variant->irq_index == VFIO_PCI_MSIX_IRQ_INDEX;
+	int msi_eventfd;
 	u32 count;
 	u64 value;
 	int i;
@@ -147,8 +148,15 @@ TEST_F(vfio_pci_irq_test, enable_trigger_disable)
 	printf("MSI%s: enabled %d interrupts\n", msix ? "-x" : "", count);
 
 	for (i = 0; i < count; i++) {
+		msi_eventfd = self->device->msi_eventfds[i];
+
+		fcntl_set_nonblock(msi_eventfd);
+		ASSERT_EQ(-1, read(msi_eventfd, &value, 8));
+		ASSERT_EQ(EAGAIN, errno);
+
 		vfio_pci_irq_trigger(self->device, variant->irq_index, i);
-		ASSERT_EQ(8, read(self->device->msi_eventfds[i], &value, 8));
+
+		ASSERT_EQ(8, read(msi_eventfd, &value, 8));
 		ASSERT_EQ(1, value);
 	}
 
-- 
2.51.0.rc2.233.g662b1ed5c5-goog


