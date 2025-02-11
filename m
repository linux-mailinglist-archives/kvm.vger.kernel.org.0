Return-Path: <kvm+bounces-37839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70D8DA30ABE
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:49:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F7693AA8F8
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 11:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B020A1FCFF3;
	Tue, 11 Feb 2025 11:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.com header.i=@yandex-team.com header.b="LJ5WKFHm"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422DB1FBCB6;
	Tue, 11 Feb 2025 11:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739274436; cv=none; b=IfXCe6FMR8Xo3o8sUj9+tdGP4w2jy1Efi101ywm/4z1HhUeNLUJqU17x8jBFLEH9WhP+znS8eonmsVbJAAnacYjlHJxtKtCg4P1x+E08ZP9ps+OnVAH/YmcKXIFYma9dSUSIpSCUuWwrx2b/kqra5lph0F/Y8ImTUv2KsteLajY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739274436; c=relaxed/simple;
	bh=Y0fh7AWxUG/Btsyl6afxXwMV1HfS5uyYkfO9R1i/q0c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mAqSgxCWghrngbyz0SScHwJx/YPp6foQIUjEqts/fmSM8bLfUvhi5n/hRT1WAGW2p9jP4i7ozLvAB39QBd57iQbTfH2PCvpQyxkJw24QC1bZGwUfRz/Wq48ywhpMHKBjxDQLpOkE4hmVEYnzyiiPmcncHm7Iow0ewA7THol83uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.com; spf=pass smtp.mailfrom=yandex-team.com; dkim=pass (1024-bit key) header.d=yandex-team.com header.i=@yandex-team.com header.b=LJ5WKFHm; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.com
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c0f:1286:0:640:6f2b:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id A65BE614BD;
	Tue, 11 Feb 2025 14:46:00 +0300 (MSK)
Received: from dellarbn.yandex.net (unknown [10.214.35.248])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id njMaW61IYa60-0cIaOumc;
	Tue, 11 Feb 2025 14:45:59 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com;
	s=default; t=1739274360;
	bh=y1+8TKaZyt8/6ij0O/nQoH47E1MV/9ZBI4/TT9VKt0Q=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=LJ5WKFHmyCrCn1KYL3qcylN81InuVfSerkMsn+VBoeKh8/wdxrbUdzZdQ+PpMKMyh
	 oGWt9zOHcNbRA3SiMQ2rM6FIaaD8FM4h8AwmMdD3qpAfcSUkrKnO1pBCwXvTw8TKGl
	 FAEAxOhG/j/IwM2mkQ+KPz4ubeN23snm5HpH+GaQ=
Authentication-Results: mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.com
From: Andrey Ryabinin <arbn@yandex-team.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	intel-gvt-dev@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Andrey Ryabinin <arbn@yandex-team.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] drm/i915/gvt: Store ->kvm reference in intel_vgpu struct.
Date: Tue, 11 Feb 2025 12:45:43 +0100
Message-ID: <20250211114544.17845-1-arbn@yandex-team.com>
X-Mailer: git-send-email 2.45.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'vfio_device' keeps the ->kvm pointer with elevated counter from the first
open of the device up until the last close(). So the kvm struct and its
dependencies (kvm kthreads, cgroups ...) kept alive even for VFIO device
that don't need ->kvm.

Copy ->kvm pointer from the vfio_device struct and store it in the
'intel_vgpu'. Note that kvm_page_track_[un]register_notifier() already
does get/put calls, keeping the kvm struct alive.

This will allow to release ->kvm from the vfio_device righ after the
first open call, so that devices not using kvm not keeping it alive.

Devices that are using kvm (like intel_vgpu) will be expected to mange
the lifetime of the kvm struct by themselves.

Fixes: 2b48f52f2bff ("vfio: fix deadlock between group lock and kvm lock")
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
---
 drivers/gpu/drm/i915/gvt/gvt.h   |  1 +
 drivers/gpu/drm/i915/gvt/kvmgt.c | 14 +++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index 2c95aeef4e41..6c62467df22c 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -232,6 +232,7 @@ struct intel_vgpu {
 	unsigned long nr_cache_entries;
 	struct mutex cache_lock;
 
+	struct kvm *kvm;
 	struct kvm_page_track_notifier_node track_node;
 #define NR_BKT (1 << 18)
 	struct hlist_head ptable[NR_BKT];
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index b27ff77bfb50..cf418e2c560d 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -36,6 +36,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/kthread.h>
+#include <linux/kvm_host.h>
 #include <linux/sched/mm.h>
 #include <linux/types.h>
 #include <linux/list.h>
@@ -649,7 +650,7 @@ static bool __kvmgt_vgpu_exist(struct intel_vgpu *vgpu)
 		if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, itr->status))
 			continue;
 
-		if (vgpu->vfio_device.kvm == itr->vfio_device.kvm) {
+		if (vgpu->kvm == itr->kvm) {
 			ret = true;
 			goto out;
 		}
@@ -664,13 +665,13 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
 	struct intel_vgpu *vgpu = vfio_dev_to_vgpu(vfio_dev);
 	int ret;
 
+	vgpu->kvm = vgpu->vfio_device.kvm;
 	if (__kvmgt_vgpu_exist(vgpu))
 		return -EEXIST;
 
 	vgpu->track_node.track_write = kvmgt_page_track_write;
 	vgpu->track_node.track_remove_region = kvmgt_page_track_remove_region;
-	ret = kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
-					       &vgpu->track_node);
+	ret = kvm_page_track_register_notifier(vgpu->kvm, &vgpu->track_node);
 	if (ret) {
 		gvt_vgpu_err("KVM is required to use Intel vGPU\n");
 		return ret;
@@ -707,8 +708,7 @@ static void intel_vgpu_close_device(struct vfio_device *vfio_dev)
 
 	debugfs_lookup_and_remove(KVMGT_DEBUGFS_FILENAME, vgpu->debugfs);
 
-	kvm_page_track_unregister_notifier(vgpu->vfio_device.kvm,
-					   &vgpu->track_node);
+	kvm_page_track_unregister_notifier(vgpu->kvm, &vgpu->track_node);
 
 	kvmgt_protect_table_destroy(vgpu);
 	gvt_cache_destroy(vgpu);
@@ -1560,7 +1560,7 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
 	if (kvmgt_gfn_is_write_protected(info, gfn))
 		return 0;
 
-	r = kvm_write_track_add_gfn(info->vfio_device.kvm, gfn);
+	r = kvm_write_track_add_gfn(info->kvm, gfn);
 	if (r)
 		return r;
 
@@ -1578,7 +1578,7 @@ int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
 	if (!kvmgt_gfn_is_write_protected(info, gfn))
 		return 0;
 
-	r = kvm_write_track_remove_gfn(info->vfio_device.kvm, gfn);
+	r = kvm_write_track_remove_gfn(info->kvm, gfn);
 	if (r)
 		return r;
 
-- 
2.45.3


