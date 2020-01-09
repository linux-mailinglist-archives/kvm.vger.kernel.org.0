Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC20135BE7
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 15:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731916AbgAIO5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 09:57:43 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44718 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731907AbgAIO5m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 09:57:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578581861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UEeMY0L9h1cGjmSmJRSArJW3guXbSNp3v29BbhovZjg=;
        b=T09uUC7c7tL31araNhoWHTcMFHWBGs3KGkJ/4MMkWVxAf+CEusC/0WHEawv+QPQTwb3spL
        WPxMN/WApnlUjT7x51tprTr17Y+1++tsRLYQhWMzichBiVu4VxNQzERK8+3SRTBRnxocjA
        lEB6cbemZk8PPYatgNeznZJHrO6nwO0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-FpmiIt5IP4Clv4Go5iFMJQ-1; Thu, 09 Jan 2020 09:57:40 -0500
X-MC-Unique: FpmiIt5IP4Clv4Go5iFMJQ-1
Received: by mail-qk1-f197.google.com with SMTP id j16so4298488qkk.17
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 06:57:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UEeMY0L9h1cGjmSmJRSArJW3guXbSNp3v29BbhovZjg=;
        b=fRky5DXwiAdKybilgiYfCsRJ2r5VBtL496ast0iK6tI95qtTHM2qV0a6XSI8TVFatz
         ApLXdGmrB9ehCfWAo3DJZEqXAUdOTcpiR4L4zzsh+Ym3uUCWyMBg4cJXjQjV0Juw2eM0
         Dru6Cu1B5WSDhJ0s/F6c7axVLwb1Ryv29DB2p7GQyOUd2d0WoG+BggzKWtuRseTZ+fcC
         DeNUyJyDQKyN2XBhhqSRsXRFl4BEA25wHyCOilTH9UnoL6L+LbrS6X8DGI9ZDfr+b7WS
         Yq6hBdj2WeR8NBgDzfMVeML+evmElYL5ubm3SIgYRXsxedHc1YortP6mFcnSw4JqdU/E
         IMZQ==
X-Gm-Message-State: APjAAAWINLQYBc5gejmhM9YsSwEMoJIX8O4C+R5dpdNzLQC4w1Xno+35
        odZYCNpME+y4Z7Vlj9slU+VbNNmbA4avpF+GyrZHGsFqnRI9aGiTugUQy04nYs76j6vt6e+fjkK
        C8Bh4cjVnzY+j
X-Received: by 2002:a37:9ed1:: with SMTP id h200mr10197430qke.390.1578581858652;
        Thu, 09 Jan 2020 06:57:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqxyTk3NXqX9G3kGKxoo4ojyuQTBdPfBxO21UKAMm33TtYTFwDUkwRRvpBGjneEqklTgj8BP9w==
X-Received: by 2002:a37:9ed1:: with SMTP id h200mr10197404qke.390.1578581858408;
        Thu, 09 Jan 2020 06:57:38 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q2sm3124179qkm.5.2020.01.09.06.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 06:57:36 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v3 02/21] drm/i915/gvt: subsitute kvm_read/write_guest with vfio_iova_rw
Date:   Thu,  9 Jan 2020 09:57:10 -0500
Message-Id: <20200109145729.32898-3-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109145729.32898-1-peterx@redhat.com>
References: <20200109145729.32898-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yan Zhao <yan.y.zhao@intel.com>

As a device model, it is better to read/write guest memory using vfio
interface, so that vfio is able to maintain dirty info of device IOVAs.

Compared to CPU side interfaces kvm_read/write_guest(), vfio_iova_rw()
has ~600 cycles more overhead on average.
-------------------------------------
|    interface     | avg cpu cycles |
|-----------------------------------|
| kvm_write_guest  |     1546       |
| ----------------------------------|
| kvm_read_guest   |     686        |
|-----------------------------------|
| vfio_iova_rw(w)  |     2233       |
|-----------------------------------|
| vfio_iova_rw(r)  |     1262       |
-------------------------------------

Comparison of benchmarks scores are as blow:
---------------------------------------------------------
|  avg score  | kvm_read/write_guest   | vfio_iova_rw   |
---------------------------------------------------------
|   Glmark2   |         1132           |      1138.2    |
---------------------------------------------------------
|  Lightsmark |        61.558          |      61.538    |
|--------------------------------------------------------
|  OpenArena  |        142.77          |      136.6     |
---------------------------------------------------------
|   Heaven    |         698            |      686.8     |
--------------------------------------------------------
No obvious performance downgrade found.

Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
[peterx: pass in "write" to vfio_iova_rw(), suggested by Paolo]
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 3259a1fa69e1..5fb82f285b98 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1968,31 +1968,18 @@ static int kvmgt_rw_gpa(unsigned long handle, unsigned long gpa,
 			void *buf, unsigned long len, bool write)
 {
 	struct kvmgt_guest_info *info;
-	struct kvm *kvm;
-	int idx, ret;
-	bool kthread = current->mm == NULL;
+	int ret;
+	struct intel_vgpu *vgpu;
+	struct device *dev;
 
 	if (!handle_valid(handle))
 		return -ESRCH;
 
 	info = (struct kvmgt_guest_info *)handle;
-	kvm = info->kvm;
-
-	if (kthread) {
-		if (!mmget_not_zero(kvm->mm))
-			return -EFAULT;
-		use_mm(kvm->mm);
-	}
-
-	idx = srcu_read_lock(&kvm->srcu);
-	ret = write ? kvm_write_guest(kvm, gpa, buf, len) :
-		      kvm_read_guest(kvm, gpa, buf, len);
-	srcu_read_unlock(&kvm->srcu, idx);
+	vgpu = info->vgpu;
+	dev = mdev_dev(vgpu->vdev.mdev);
 
-	if (kthread) {
-		unuse_mm(kvm->mm);
-		mmput(kvm->mm);
-	}
+	ret = vfio_iova_rw(dev, gpa, buf, len, write);
 
 	return ret;
 }
-- 
2.24.1

