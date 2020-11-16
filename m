Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862242B420A
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 12:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbgKPLCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 06:02:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728876AbgKPLCA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 06:02:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605524520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wNJRDdqcP3xkVEkoYc9nSjTCx79g2/ufcD7qjCATKZc=;
        b=Fs9liUtQ0+fn58f39S/5v+qM2jozE7yaa/HCB8FcsD9G713p9Yto5VVe9zvuYD9RtucO50
        q+GAap5K7+MgycPU5dkbbhaq46+7uGW/kUTK2OL1j3mKNEzRtdHT/S9pvuhHTIWeo60AnG
        nEH15sbyZ1g5ltqoyVL0qTD7wHHTz04=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-dyGj-XJ2N0qKa-l5x9OV4Q-1; Mon, 16 Nov 2020 06:01:56 -0500
X-MC-Unique: dyGj-XJ2N0qKa-l5x9OV4Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E03371008567;
        Mon, 16 Nov 2020 11:01:52 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-230.ams2.redhat.com [10.36.113.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BD8C5C716;
        Mon, 16 Nov 2020 11:01:41 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com,
        alex.williamson@redhat.com
Cc:     jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com, tn@semihalf.com,
        nicoleotsuka@gmail.com, yuzenghui@huawei.com
Subject: [PATCH v11 09/13] vfio: Add new IRQ for DMA fault reporting
Date:   Mon, 16 Nov 2020 12:00:26 +0100
Message-Id: <20201116110030.32335-10-eric.auger@redhat.com>
In-Reply-To: <20201116110030.32335-1-eric.auger@redhat.com>
References: <20201116110030.32335-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new IRQ type/subtype to get notification on nested
stage DMA faults.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 include/uapi/linux/vfio.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0e2bfbeccd08..1e5c82f9d14d 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -722,6 +722,9 @@ struct vfio_irq_info_cap_type {
 	__u32 subtype;  /* type specific */
 };
 
+#define VFIO_IRQ_TYPE_NESTED				(1)
+#define VFIO_IRQ_SUBTYPE_DMA_FAULT			(1)
+
 /**
  * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_set)
  *
-- 
2.21.3

