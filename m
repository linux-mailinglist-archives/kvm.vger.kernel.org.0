Return-Path: <kvm+bounces-49733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A094ADD7E1
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:50:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A389919E2BF7
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 732832EA724;
	Tue, 17 Jun 2025 16:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V9NWWtsy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31FC2F9488
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 16:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178038; cv=none; b=tJ1EOibTofEDV1kTA//09G/Lo6gKCSWKAjFblX4lO5aVqQaOGR+A6hCDfVBsUgnXAfKgQJOccEUECPC1BUKY4K5urkSmhFvJsVbo8MQXsaDOM5VLrNYcviJ55sO3Apvwgc8SoxYux7ndGwGcH6OXPdpt79cwiHdEtxHbFmuD8qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178038; c=relaxed/simple;
	bh=3/iqtF4hHRcoSspgVyO2H7j38SgwyWDku3Ny3jIOnLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hCWZBVTCvFj4foMYjNU6ksGKu0n2fs7jgPvXitqRFkPA0LMDLkeCTG26tAbVidA2B9ekljl4Awh7hp5QRX/BwZHUcv6ow0BKLIeyO7C62UyNTqpTDDLr7KPggrSDQ1eRLQPBg+oXkhFTvZtL92I1T9y2C9FV2U8R3a0fYFw8R0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V9NWWtsy; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4531e146a24so36920985e9.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750178035; x=1750782835; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QKHVjbEZEAlGzEnK1mT5V15dOYDZALJJ9P4ZN2AdSHE=;
        b=V9NWWtsykUEKczdKmbl8ohEqG3v4M+BE4oqgD2hZ/cc4nJp8/wuuRtBLZl3fMucN+w
         60ckqUiIj9MwzWVjIZVGAVmFlHhlx63pFQXQpTtykspzjbEO7GvIBz1SATz1+hk4o22y
         5PXfGTPePNWJmArYcyN36QpYpi6zJHcJofhr4AbQGZn97JVG6bUjTwocGSZWqvvxuvIp
         1fr7V2F1NPPP/n9iZujqSwV2vn7klip2CeQOc8EMGzEURL4oxiOILDbAfiiwfCFhgs5O
         n0HOXywqgPjfv2B28541MKbyzuRi4X7soVmzEZ9SlZPAGAUtdT1U0j7unga/9tMx0DwU
         m/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750178035; x=1750782835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QKHVjbEZEAlGzEnK1mT5V15dOYDZALJJ9P4ZN2AdSHE=;
        b=mrxnxjugw/fWceEgqSV1AGBnKrh1V59h8AVJWySYzAElGPlaczFndZg8GHAcGEWDKl
         4GMxyeInk4JtnrFV1iI8iLoefZEb/9NADDdpQ15uv4PuGXw9fwensUn0sUU5zzIEMn7C
         HW8Uh/hx4kqlfZvz0jfKWq6rl9loKp9+GCh9hKKAVZt4tw33Or8cc9rkH4aCVCwsdTgA
         skUaevkv7u2TriMEFLWRZzENS7ljxRjSVnmCOfSDyxhadp/gIcMid00FqlkDqHn30gE+
         doHMYV8su5d5Osi2frQjK29Ikt6IFeDwBLaV12X/8F4ZlkEDpCimyYhfzeLSVmVEj5Yq
         9Ccw==
X-Forwarded-Encrypted: i=1; AJvYcCUUKkifAvrOW3JzKOhOQTVst61FDWrmG9SupyrumLXnE4MXg9VT61VYm5hAJW6yi7AKDUY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWz8cNR5gAb2PTzcSoKVlNiJgr3VfhwwVFaGRNqgHqESsFxOdR
	5zhk8ue0u3/TWIUrROH6ng3+sWqgry5lnlO9NwyRwgLpja3HFv5rKaVyod+iS9R4DpU=
X-Gm-Gg: ASbGnctX3oGP4+s3RL150SxXzSnElm7zzCd7D9u+QyU65oxPkMz7BT7bNNzvrjksPmm
	5QqRITbSeTEvuYr00Ik5d57ud6JVDLbWkhZ3UpK8yM2DiUAu5ZO//0czL8/F2FoCDrxLNuywxs5
	Eiq4lTZ3ieLRxAvDB8bos0XTU6p6De41Lh7sjqFjUoamVSNufndPzoRH1gDlAormkADpVAJjugL
	gbSS8uxCQHjJLkGYyKeQ2VyNriRJuatNY9Z3DaISiykLGUjOPbti1QC26rymJpvQI2hc0vXnlLU
	OfD1pRVm068JT/94gCuY3a8UqBFEuH21k6Xd0RfdEx6oX8QgvznaddzQrM06Fo0=
X-Google-Smtp-Source: AGHT+IEcabvh7yBYNUgPCbH5qrmXiMx66xje3D7cTPVNv24ZJ3XnrP+Kpx0AQ2nGH2YgxABhGdC5jA==
X-Received: by 2002:a05:600c:1d06:b0:43c:e7ae:4bcf with SMTP id 5b1f17b1804b1-4533c9bf9e2mr148215485e9.0.1750178034971;
        Tue, 17 Jun 2025 09:33:54 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568a7e980sm14106592f8f.41.2025.06.17.09.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 09:33:53 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 2E6FE5F878;
	Tue, 17 Jun 2025 17:33:52 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Cornelia Huck <cohuck@redhat.com>,
	qemu-arm@nongnu.org,
	Mark Burton <mburton@qti.qualcomm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC PATCH 03/11] linux-headers: Update to Linux 6.15.1 with trap-mem-harder (WIP)
Date: Tue, 17 Jun 2025 17:33:43 +0100
Message-ID: <20250617163351.2640572-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250617163351.2640572-1-alex.bennee@linaro.org>
References: <20250617163351.2640572-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Import headers for trap-me-harder, based on 6.15.1.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/standard-headers/linux/virtio_pci.h | 1 +
 linux-headers/linux/kvm.h                   | 8 ++++++++
 linux-headers/linux/vhost.h                 | 4 ++--
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/standard-headers/linux/virtio_pci.h b/include/standard-headers/linux/virtio_pci.h
index 91fec6f502..09e964e6ee 100644
--- a/include/standard-headers/linux/virtio_pci.h
+++ b/include/standard-headers/linux/virtio_pci.h
@@ -246,6 +246,7 @@ struct virtio_pci_cfg_cap {
 #define VIRTIO_ADMIN_CMD_LIST_USE	0x1
 
 /* Admin command group type. */
+#define VIRTIO_ADMIN_GROUP_TYPE_SELF	0x0
 #define VIRTIO_ADMIN_GROUP_TYPE_SRIOV	0x1
 
 /* Transitional device admin command. */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 99cc82a275..bb51fb179b 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -178,6 +178,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_ARM_TRAP_HARDER  40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -439,6 +440,12 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_ARM_TRAP_HARDER */
+		struct {
+			__u64 esr;
+			__u64 elr;
+			__u64 far;
+		} arm_trap_harder;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -645,6 +652,7 @@ struct kvm_enable_cap {
 #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
 #define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
 	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
+#define KVM_VM_TYPE_ARM_TRAP_ALL        0x10000ULL
 /*
  * ioctls for /dev/kvm fds:
  */
diff --git a/linux-headers/linux/vhost.h b/linux-headers/linux/vhost.h
index b95dd84eef..d4b3e2ae13 100644
--- a/linux-headers/linux/vhost.h
+++ b/linux-headers/linux/vhost.h
@@ -28,10 +28,10 @@
 
 /* Set current process as the (exclusive) owner of this file descriptor.  This
  * must be called before any other vhost command.  Further calls to
- * VHOST_OWNER_SET fail until VHOST_OWNER_RESET is called. */
+ * VHOST_SET_OWNER fail until VHOST_RESET_OWNER is called. */
 #define VHOST_SET_OWNER _IO(VHOST_VIRTIO, 0x01)
 /* Give up ownership, and reset the device to default values.
- * Allows subsequent call to VHOST_OWNER_SET to succeed. */
+ * Allows subsequent call to VHOST_SET_OWNER to succeed. */
 #define VHOST_RESET_OWNER _IO(VHOST_VIRTIO, 0x02)
 
 /* Set up/modify memory layout */
-- 
2.47.2


