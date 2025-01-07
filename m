Return-Path: <kvm+bounces-34733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FE54A050CC
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 03:31:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0DD018899A4
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 02:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A67A11A83F9;
	Wed,  8 Jan 2025 02:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HorjPr1m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7339E1A76B6;
	Wed,  8 Jan 2025 02:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736303360; cv=none; b=hJu5CvL1JL12gWagIvBz32cWpUwcwjW9vI6ZHWycqa058U4/TCj6rLcIx9KrcAZ11NV5zzJ3GcEbFWL40g9gPdHQtVLtWmHHfR5NVGhD7JLvOsOV6WFy6RQS/6/z0rsPpo2aLUrU2Fu/L7npKBRXuIK0mlLJFvNPU4F0bbJPR3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736303360; c=relaxed/simple;
	bh=aXS00hvcLCx/JNYY8Pz9dnfD+e6/gpdHuhaWAk8Hj8w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FsDI+ZgnX7KjJ3rEr+WVReBObjavgKoqEVltKHffppIJ9SBF5JAIyKoCplq0lEyjGGLtFymxxgiXSxpsw6nIIWvob6RmGKulA+hnfXVinKOy4Fc4MQllLjIFwK+HShMTUpWNvJLnmAqcwXLEXLbA6ljT5+Qw/zLF2kYGxNgHN9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HorjPr1m; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736303360; x=1767839360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aXS00hvcLCx/JNYY8Pz9dnfD+e6/gpdHuhaWAk8Hj8w=;
  b=HorjPr1mPYLXqBrhfegF/sTkEJfNdfMr1lwF3zNvHUb+xsXkzKhr5IQQ
   rotNAVliAWt3eMBk3illVtEeo8UBZqb3fVm6m46o5BF0/ux+E89Iujk9D
   dJHIt8f+lYEodnwYt0k4Aw1LDKQAAk8HM9VFMNr2uOMdWLFBtIDQ+UiNK
   Uz0kzogAujKf131GkWou+M/vzDfdvUWgE3u6avSzPJm1p+E1GZg99o85m
   oyc+OqTf6jF583aSYLsV9I5kOdViHf7RFPrq7M/QFKRsb1WLkqiejkwe4
   wd6NxgBUS0SYVgCUZsVB8Ht/WzzURGeUxizpQw6ZYZJKGP8NDDRRqr2Gt
   w==;
X-CSE-ConnectionGUID: /Q3EP+lPQlSj5bMfGa/U7Q==
X-CSE-MsgGUID: qU7FYrA6RI6d/KH75+1J9A==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="47010612"
X-IronPort-AV: E=Sophos;i="6.12,296,1728975600"; 
   d="scan'208";a="47010612"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 18:29:20 -0800
X-CSE-ConnectionGUID: sBlHVtLsRvylvXu/hmJb0w==
X-CSE-MsgGUID: YQy6dSo0QA2bbZy+yHWL6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103793822"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa008.jf.intel.com with ESMTP; 07 Jan 2025 18:29:14 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	vivek.kasireddy@intel.com,
	dan.j.williams@intel.com,
	aik@amd.com
Cc: yilun.xu@intel.com,
	yilun.xu@linux.intel.com,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch,
	leon@kernel.org,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: [RFC PATCH 10/12] KVM: vfio_dmabuf: Fetch VFIO specific dma-buf data for sanity check
Date: Tue,  7 Jan 2025 22:27:17 +0800
Message-Id: <20250107142719.179636-11-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250107142719.179636-1-yilun.xu@linux.intel.com>
References: <20250107142719.179636-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fetch VFIO specific dma-buf data to see if the dma-buf is eligible to
be assigned to CoCo VM as private MMIO.

KVM expects host unaccessible dma-buf for private MMIO mapping. So need
the exporter provide this information. VFIO also provides the
struct kvm *kvm handler for KVM to check if the owner device of the
MMIO region is already assigned to the same CoCo VM.

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 virt/kvm/vfio_dmabuf.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/virt/kvm/vfio_dmabuf.c b/virt/kvm/vfio_dmabuf.c
index c427ab39c68a..26e01b815ebf 100644
--- a/virt/kvm/vfio_dmabuf.c
+++ b/virt/kvm/vfio_dmabuf.c
@@ -12,6 +12,22 @@ struct kvm_vfio_dmabuf {
 	struct kvm_memory_slot *slot;
 };
 
+static struct vfio_dma_buf_data *kvm_vfio_dma_buf_get_data(struct dma_buf *dmabuf)
+{
+	struct vfio_dma_buf_data *(*fn)(struct dma_buf *dmabuf);
+	struct vfio_dma_buf_data *ret;
+
+	fn = symbol_get(vfio_dma_buf_get_data);
+	if (!fn)
+		return ERR_PTR(-ENOENT);
+
+	ret = fn(dmabuf);
+
+	symbol_put(vfio_dma_buf_get_data);
+
+	return ret;
+}
+
 static void kv_dmabuf_move_notify(struct dma_buf_attachment *attach)
 {
 	struct kvm_vfio_dmabuf *kv_dmabuf = attach->importer_priv;
@@ -48,6 +64,7 @@ int kvm_vfio_dmabuf_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	size_t size = slot->npages << PAGE_SHIFT;
 	struct dma_buf_attachment *attach;
 	struct kvm_vfio_dmabuf *kv_dmabuf;
+	struct vfio_dma_buf_data *data;
 	struct dma_buf *dmabuf;
 	int ret;
 
@@ -60,6 +77,15 @@ int kvm_vfio_dmabuf_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		goto err_dmabuf;
 	}
 
+	data = kvm_vfio_dma_buf_get_data(dmabuf);
+	if (IS_ERR(data))
+		goto err_dmabuf;
+
+	if (!data->is_private || data->kvm != kvm) {
+		ret = -EINVAL;
+		goto err_dmabuf;
+	}
+
 	kv_dmabuf = kzalloc(sizeof(*kv_dmabuf), GFP_KERNEL);
 	if (!kv_dmabuf) {
 		ret = -ENOMEM;
-- 
2.25.1


