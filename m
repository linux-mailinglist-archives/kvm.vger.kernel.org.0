Return-Path: <kvm+bounces-15555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBBE28AD57B
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 22:02:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 090D51C21295
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 20:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DEE215539E;
	Mon, 22 Apr 2024 20:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="me3XbiC3"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A73155354
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 20:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816135; cv=none; b=O0Eba67Z3bIHfZUeGp9+tI4lwiF1T7aa5QSiXo/Jxn1f9nCROqnRNaXqtN5jolwJxu9VgmKKBrz3Ns0a3RWbIoPoJDjahPNZtg+Rt4MaObFjCSGLkqHPfWRAi8xDutJWJyXK5MBD0F+yLIXq77i89Iu2bPyoj9SIXFZ6qZ1UfMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816135; c=relaxed/simple;
	bh=dOdCMtV8e6b36zSdTT8BwjG+NSdp42iVnHem1jiIdek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgNnZJM7DxG691HWgkE5sObW9Tb4BwoULWQY6SgRNkQqQpixoCA2JqXFOtftPH47x/eKNz87lFzFigyWoTIJhuTBU+Sbdk9vvtk9ltPLecMeaftrWtv2NpzPxEk9+Tsa6s5x4pHuaw9KcT217Wg0RLD4v9UkR632mQKR4YHFHeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=me3XbiC3; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713816132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GJJqqZnMoG1V2LuZsq0jM/45KJtVgKZEDxyRtl+U1Ow=;
	b=me3XbiC3GqRPVxjp4FFs9wtSvhYW6QVdCpsqQSAHu/9jcJZPM70hCP6GTviIG7PUpimu7S
	925IBTkWUb4/v1WXu+5wmAwVvv+bhas289tmT9ZBFJ9SG2KLMO2LLgv2LtkV1Zu51e7mfO
	A8838qQfQPW7CPiLfU5GcraCs3OQmcI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH v3 01/19] KVM: Treat the device list as an rculist
Date: Mon, 22 Apr 2024 20:01:40 +0000
Message-ID: <20240422200158.2606761-2-oliver.upton@linux.dev>
In-Reply-To: <20240422200158.2606761-1-oliver.upton@linux.dev>
References: <20240422200158.2606761-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A subsequent change to KVM/arm64 will necessitate walking the device
list outside of the kvm->lock. Prepare by converting to an rculist. This
has zero effect on the VM destruction path, as it is expected every
reader is backed by a reference on the kvm struct.

On the other hand, ensure a given device is completely destroyed before
dropping the kvm->lock in the release() path, as certain devices expect
to be a singleton (e.g. the vfio-kvm device).

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 virt/kvm/kvm_main.c | 14 +++++++++++---
 virt/kvm/vfio.c     |  2 ++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fb49c2a60200..6c09fe40948f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1329,6 +1329,12 @@ static void kvm_destroy_devices(struct kvm *kvm)
 	 * We do not need to take the kvm->lock here, because nobody else
 	 * has a reference to the struct kvm at this point and therefore
 	 * cannot access the devices list anyhow.
+	 *
+	 * The device list is generally managed as an rculist, but list_del()
+	 * is used intentionally here. If a bug in KVM introduced a reader that
+	 * was not backed by a reference on the kvm struct, the hope is that
+	 * it'd consume the poisoned forward pointer instead of suffering a
+	 * use-after-free, even though this cannot be guaranteed.
 	 */
 	list_for_each_entry_safe(dev, tmp, &kvm->devices, vm_node) {
 		list_del(&dev->vm_node);
@@ -4725,7 +4731,8 @@ static int kvm_device_release(struct inode *inode, struct file *filp)
 
 	if (dev->ops->release) {
 		mutex_lock(&kvm->lock);
-		list_del(&dev->vm_node);
+		list_del_rcu(&dev->vm_node);
+		synchronize_rcu();
 		dev->ops->release(dev);
 		mutex_unlock(&kvm->lock);
 	}
@@ -4808,7 +4815,7 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 		kfree(dev);
 		return ret;
 	}
-	list_add(&dev->vm_node, &kvm->devices);
+	list_add_rcu(&dev->vm_node, &kvm->devices);
 	mutex_unlock(&kvm->lock);
 
 	if (ops->init)
@@ -4819,7 +4826,8 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 	if (ret < 0) {
 		kvm_put_kvm_no_destroy(kvm);
 		mutex_lock(&kvm->lock);
-		list_del(&dev->vm_node);
+		list_del_rcu(&dev->vm_node);
+		synchronize_rcu();
 		if (ops->release)
 			ops->release(dev);
 		mutex_unlock(&kvm->lock);
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index ca24ce120906..76b7f6085dcd 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -366,6 +366,8 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type)
 	struct kvm_device *tmp;
 	struct kvm_vfio *kv;
 
+	lockdep_assert_held(&dev->kvm->lock);
+
 	/* Only one VFIO "device" per VM */
 	list_for_each_entry(tmp, &dev->kvm->devices, vm_node)
 		if (tmp->ops == &kvm_vfio_ops)
-- 
2.44.0.769.g3c40516874-goog


