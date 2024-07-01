Return-Path: <kvm+bounces-20748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 176E291D69C
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 05:32:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41E601C213B1
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 03:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4D2A22092;
	Mon,  1 Jul 2024 03:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="axlvBROo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93BB28F4
	for <kvm@vger.kernel.org>; Mon,  1 Jul 2024 03:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719804739; cv=none; b=J8Ac6gW4rmYmhPZZuWo8ZkK9mELrbbEoZHQS3p6EqDjdzrDI5hdTUCbTgrDeqnBtb4JLO8EWaiVd27pZQh488XyP0Tu3eIiFcC8bqVOkzuLV7Am+4q2b9jZCbN3vReuUrOnB5cQaeKKJFq+9IsEZOgPk6cMVM5p7tFTTqoATnuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719804739; c=relaxed/simple;
	bh=qQQjGDoJ0myh77aPdjP+sWJgsk2E2ZsVb0POwmgofvI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XRGrSBGHUGNo/Wt0y3NwRAnuuf67SflUheAG90vtEo3Dc4snM5Sy9L4qLPez4sZzJmFBhdFgcEGdvuGG8Dz3xlHS8QE5Xu1PugXvA63yDBoC668WJ4xI5nsvWzYAVhUMnHyT8DlsKPd7696vPYFK4F3dHekyehk/xmpRDILQYBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=axlvBROo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719804735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lrXIw9w05RWnWwbiO9aOe5v3MpC5DP8zU3Bul/SygzI=;
	b=axlvBROocrdlpoCxr7V6I2hxInN/atzBo5SkvEuZOb2QX9GITrAxNy7p9+xBjDjQxaLf5a
	YmCeI+M5Ms9ZIvg7dua4WB2htmV0D+BNzHRpii+DJCNgFwPmr1Z8cAApose1syaDtrxcbg
	B7UmTVMWdbCJFnVSn6pOFE6BcvAn1wY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-601-dgew17BePSaVyxa7FmGRsg-1; Sun,
 30 Jun 2024 23:32:10 -0400
X-MC-Unique: dgew17BePSaVyxa7FmGRsg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 189DB19560A2;
	Mon,  1 Jul 2024 03:32:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.165])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C4EBA19560AA;
	Mon,  1 Jul 2024 03:32:03 +0000 (UTC)
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com,
	jasowang@redhat.com,
	eperezma@redhat.com
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dragos Tatulea <dtatulea@nvidia.com>,
	stable@vger.kernel.org
Subject: [PATCH] vhost-vdpa: switch to use vmf_insert_pfn() in the fault handler
Date: Mon,  1 Jul 2024 11:31:59 +0800
Message-ID: <20240701033159.18133-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

remap_pfn_page() should not be called in the fault handler as it may
change the vma->flags which may trigger lockdep warning since the vma
write lock is not held. Actually there's no need to modify the
vma->flags as it has been set in the mmap(). So this patch switches to
use vmf_insert_pfn() instead.

Reported-by: Dragos Tatulea <dtatulea@nvidia.com>
Tested-by: Dragos Tatulea <dtatulea@nvidia.com>
Fixes: ddd89d0a059d ("vhost_vdpa: support doorbell mapping via mmap")
Cc: stable@vger.kernel.org
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 63a53680a85c..6b9c12acf438 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1483,13 +1483,7 @@ static vm_fault_t vhost_vdpa_fault(struct vm_fault *vmf)
 
 	notify = ops->get_vq_notification(vdpa, index);
 
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	if (remap_pfn_range(vma, vmf->address & PAGE_MASK,
-			    PFN_DOWN(notify.addr), PAGE_SIZE,
-			    vma->vm_page_prot))
-		return VM_FAULT_SIGBUS;
-
-	return VM_FAULT_NOPAGE;
+	return vmf_insert_pfn(vma, vmf->address & PAGE_MASK, PFN_DOWN(notify.addr));
 }
 
 static const struct vm_operations_struct vhost_vdpa_vm_ops = {
-- 
2.31.1


