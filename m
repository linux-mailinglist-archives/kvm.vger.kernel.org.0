Return-Path: <kvm+bounces-11957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 62A7187D8FB
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 06:26:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5808B2152C
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 05:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3F436AB8;
	Sat, 16 Mar 2024 05:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IHQ99m0b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875846139
	for <kvm@vger.kernel.org>; Sat, 16 Mar 2024 05:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710566782; cv=none; b=Eza9L1fJRUhcJRD3/bctlg48bvMKpOsPNwDD4+dFS6FfTA+DjsNQ9TIRcSPRxGCF+DAyu40L4GAkh2WVSmEWehb3c8rhDBx5SKr9CnSjOQDAwcQP7dtsx66E2QtcK/FPGwtsvU2bU3vHV/6OdEb38BH5JcqQsaLHLx4CSTJZUTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710566782; c=relaxed/simple;
	bh=w/cDJ5u2SD+WucgKY2u+DrVQbPzmgF2ZF61wCT0ekrU=;
	h=From:To:Cc:Subject:Date:Message-Id; b=HJc419PmYxgZ1XoIcmqkpewJ5hfiGvcQALMx8zhIswBJX1Sjo4Ql/SwINcQf784yFLHkoArf3WRpyxFTj8tttrNXYVtwEaNODMQEbiSeMvcD4lqShQQ4RrR0dXRyXkg7a42Cmjwk58gioSWHenMzJl2pXHrUCGEQsmPJG9t1vGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IHQ99m0b; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-221816e3ab9so1572376fac.2
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 22:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710566779; x=1711171579; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6maJgO96ZsBUYbSJV41jMxtlMZ1mp4w+JL6cKZWUS2I=;
        b=IHQ99m0bQy7dz489QNazXftmOfs7CNEe1lNqpewgIpQJEKvCNXfeLZ4Jiory9eJkG2
         5Va7//rLjU0atqw+RGP3oLyEsgPuVqaJWtjFuLtDZLc+mNKVGjM2RNEXQcLvr+GzaY/b
         XNX21Do5FLKGik31udM1Uqi0AQXBs1AoFnWg/EAKMJQIm059k1rFNqdKDv8R11lk/aB6
         m/hCbtMeJzeVf/mIvy0ozltwp39E4m3kaxYsVNSM+dHt7wm9whCJQyLQmTntjvEBACmo
         DxV5ImvfuksnBo3NvEN4J475QOttT49AV7KoTs17pB6OHwodP3h21pAp7dwnovnInDJI
         3sVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710566779; x=1711171579;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6maJgO96ZsBUYbSJV41jMxtlMZ1mp4w+JL6cKZWUS2I=;
        b=HkHEaODX3npvveWVWuaBcm5+1pZ/2xoKZFovnYNv4J5ikiPiyxU8wf1UUF/z2lt8s2
         t4Llynp65Y5qsiq/XxTz+gAkFUjwHVyQieSNmiLHBftwzIhJIrk3j7loWFWcH9Fj63Dl
         mMx/oPHAmY2T8s5xRIKuCEqLm1kMEPwpiXouhYpMiQCJ+LTIUywR4hJTMJgGM6ZfoVtd
         yzrC+IjUQatx6IVS6+szeP/zCRng3QUGjkWLHRR3AdEMrVpzHnDPx51Kf4BuAHLxdX3Y
         mlE2xw+x8TXjdIwYI8aoBSLRtfiXZbZ/zGKlsoGuM5rktFypM5H9EX1YU2dIH5QoBMhO
         Q6Jw==
X-Gm-Message-State: AOJu0YwWe/0aUBZkBqY6FJ/rEDCvD3efCbybkO2fwxsXOjYCj0DDJbPr
	/8PW5pTIQfPeH0yA0dtaVhNQNreQScLqqy3ZCQPx5JBHZa0JrdEg7qAOx/piXPPFKjCn
X-Google-Smtp-Source: AGHT+IHFeWQQ9gxANIbDujE2XKUphivMPAv2dSwGH5xJWGjlNJb2VFaFthj7P7+HBHFOhLiDqHkmfA==
X-Received: by 2002:a05:6358:2909:b0:17b:57fb:aa72 with SMTP id y9-20020a056358290900b0017b57fbaa72mr8705862rwb.8.1710566779239;
        Fri, 15 Mar 2024 22:26:19 -0700 (PDT)
Received: from zlke.localdomain ([14.145.51.228])
        by smtp.gmail.com with ESMTPSA id v22-20020a634816000000b005dc26144d96sm3366178pga.75.2024.03.15.22.26.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Mar 2024 22:26:18 -0700 (PDT)
From: Li Zhang <zhanglikernel@gmail.com>
To: kvm@vger.kernel.org
Cc: Li Zhang <zhanglikernel@gmail.com>
Subject: [PATCH]virtio-pci: Check if is_avq is NULL
Date: Sat, 16 Mar 2024 13:25:54 +0800
Message-Id: <1710566754-3532-1-git-send-email-zhanglikernel@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

[bug]
In the virtio_pci_common.c function vp_del_vqs, vp_dev->is_avq is involved
to determine whether it is admin virtqueue, but this function vp_dev->is_avq
 may be empty. For installations, virtio_pci_legacy does not assign a value
 to vp_dev->is_avq.

[fix]
Check whether it is vp_dev->is_avq before use.

[test]
Test with virsh Attach device
Before this patch, the following command would crash the guest system

After applying the patch, everything seems to be working fine.

Signed-off-by: Li Zhang <zhanglikernel@gmail.com>
---
 drivers/virtio/virtio_pci_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index b655fcc..3c18fc1 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -236,7 +236,7 @@ void vp_del_vqs(struct virtio_device *vdev)
 	int i;
 
 	list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
-		if (vp_dev->is_avq(vdev, vq->index))
+		if (vp_dev->is_avq && vp_dev->is_avq(vdev, vq->index))
 			continue;
 
 		if (vp_dev->per_vq_vectors) {
-- 
1.8.3.1


