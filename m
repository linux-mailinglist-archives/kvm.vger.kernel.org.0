Return-Path: <kvm+bounces-12128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E9CF87FD52
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 13:04:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F8021C21DD2
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 12:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 664107F7EA;
	Tue, 19 Mar 2024 12:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="neRnQCxX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001917EEEA;
	Tue, 19 Mar 2024 12:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710849878; cv=none; b=oNonPs2bfqBHfNOQNNIvGArzMCOdpNQCC/msg3yvc/AVudqVb+HLlcLDz04hH6IwSlhiuyyV38QJlzx9nm1oDsW1FZ+XK7AyMxbifZe8TLNdkkeY0BWrPU7PidXfyFRBj9Lf6sx8gYpq9zc9dFiErRokiHQbhLd/0853Z2g6Vog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710849878; c=relaxed/simple;
	bh=2whijhBAm4dx6QwkeeGpNsVaN2Kx4eOfqHixS++YrtA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ELuxscNUJyCYsZPPXlhHv96vKJB8tbR7s5dMc3j/6zLUXdFH0tL2F1g7C0y7N9nIMtgVr+bAc9LQlwg2l2/353w6Tzxc0lowgG7E+2gnkq+uyrM9ljTCuucVZJD2eg+5fkPfuHBSqM822TTSirAgum/y/C0s4pAmvj3nfRewhNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=neRnQCxX; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2d41d1bedc9so95113291fa.3;
        Tue, 19 Mar 2024 05:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710849875; x=1711454675; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IN3wN3yRolVo19T+AVLYl3UCmMVfUc/5cyFO6aotwr0=;
        b=neRnQCxX95jGvRifRf8JpVO0QYJk3uibDJ2sOv534maQ8vPtpp2KKvrUe1QEmFsCWE
         kDD7mtSrXA+QRUM/19GjSsc+hHHfQNmv1tD9RJfGd8ZNN/Rm0kLQ8BqFyPxwn2iLEjZd
         buhjnalX9MzmjC1+W8HAfW7rHr5OkuKv1HCJ9di3AQW0nUCrzqxcVu3QoZ/zDQlLXvJn
         3jeXDmarmHP/jRfDm6OQghvLlntioQdfcptRcxrK1CJ6TFF2LvWdHUOlcYwGiNyGiVz8
         8YNPDXi/nP8Z+YfjdIb0aOJttQXNTqltholb3fJd+SnUUvPr6OYrdsCcCdANVZSS3V4d
         OUXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710849875; x=1711454675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IN3wN3yRolVo19T+AVLYl3UCmMVfUc/5cyFO6aotwr0=;
        b=s+nX+BeHSYtxG4zbnqdPfIbGkyGijwQfrZKJbFcNEaoSf4VMCXq3zhpWvZm8GwT7ai
         OxjeB7qI9pzVVXQZNmhaAJVK0hEyltu91PeVjbb2hTQUUb2hpITKpJTu/NaRFsJqViq7
         K5BFGlAiPMHOBiq3p1hmiBOs0UwXkgXTSQneLXvUVPSKr+A+dFv0dVQ35izMhTQI+eIc
         J6MSPdECUaDwZgkMnpmlvyYsyOp/9HS1TEQtShWfT5EfNGrTGuWz4nNJk8FAg+ggpFXO
         hezaYpyI6ffhmJYSfytsqhFw7NfeSGORYBfn52wypPjahhPDcNBUx2IpSpqNyDOIsJQ/
         0kxw==
X-Forwarded-Encrypted: i=1; AJvYcCXHRa6kn4KNZN0tThEkuNBcpxzgjGCeYG+xtANnTHsifviSM/113PzM00fxzN8wzLqFKm+GQPAdNe8tVefKG2T+IN0/kQI5ykOfzjfUpVsK1J2M0MIJ6PnaKG1a6+9aS0/C
X-Gm-Message-State: AOJu0YyF6hnBmYHavZtlJiWdb8vU2WK4MCzr4e0+hyD1SvryxT9q6rJr
	jp9Tiwcrqmg75KMExDnS/7Im1mFaMJSV1CMXqXVesEIHAowT/3EXa+0h+WKBgwQM9Q==
X-Google-Smtp-Source: AGHT+IEhOOYjcdGfgitwor41R2Ak270M2lC5BoeDuwljNKRdjdoEA5HsuucUaxu5WJnx4+4kYgD4/g==
X-Received: by 2002:a2e:a412:0:b0:2d4:6893:24e1 with SMTP id p18-20020a2ea412000000b002d4689324e1mr6883968ljn.50.1710849874999;
        Tue, 19 Mar 2024 05:04:34 -0700 (PDT)
Received: from linguini.. ([62.96.37.222])
        by smtp.gmail.com with ESMTPSA id f23-20020a170906049700b00a4588098c5esm5989722eja.132.2024.03.19.05.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 05:04:34 -0700 (PDT)
From: Mikhail Malyshev <mike.malyshev@gmail.com>
To: alex.williamson@redhat.com,
	jgg@ziepe.ca,
	yi.l.liu@intel.com,
	kevin.tian@intel.com,
	tglx@linutronix.de,
	reinette.chatre@intel.com,
	stefanha@redhat.com
Cc: abhsahu@nvidia.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mikhail Malyshev <mike.malyshev@gmail.com>
Subject: [PATCH 1/1] vfio/pci: Reenable runtime PM for dynamically unbound devices
Date: Tue, 19 Mar 2024 12:04:10 +0000
Message-Id: <20240319120410.1477713-2-mike.malyshev@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240319120410.1477713-1-mike.malyshev@gmail.com>
References: <20240319120410.1477713-1-mike.malyshev@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a device is unbound from its driver it may call pm_runtime_disable()
in its ->remove() callback. When such device is bound to vfio-pci driver
VFIO framework should reenable runtime PM before calling pm_runtime_xxx
functions.

The problem was introduced by
commit 7ab5e10eda02 ("vfio/pci: Move the unused device into low power state
 with runtime PM")

Signed-off-by: Mikhail Malyshev <mike.malyshev@gmail.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1cbc990d42e0..05c25ee66ee1 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2258,6 +2258,16 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	vfio_pci_set_power_state(vdev, PCI_D0);
 
 	dev->driver->pm = &vfio_pci_core_pm_ops;
+
+	/*
+	 * If the device was previously associated with a driver, the
+	 * driver might have invoked pm_runtime_disable in its remove()
+	 * callback. We must re-enable runtime PM here to ensure the
+	 * device can be managed.
+	 */
+	if (!pm_runtime_enabled(dev))
+		pm_runtime_enable(dev);
+
 	pm_runtime_allow(dev);
 	if (!disable_idle_d3)
 		pm_runtime_put(dev);
-- 
2.34.1


