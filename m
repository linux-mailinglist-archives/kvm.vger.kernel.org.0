Return-Path: <kvm+bounces-26672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 348C29764D3
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 10:49:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0DF4281642
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 08:49:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0EF2191F8F;
	Thu, 12 Sep 2024 08:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Jqo6VpIY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB5018BC32
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 08:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726130958; cv=none; b=pSqIzeWLctxTlAXR7srSteH23+ep6tuK9oDjxIszHlFSgFe52QaQj31dsdUcuIAQdhWHLwl+O2k4p7dXPvTfMmM6/4SXy0DqLP2dn8JCp4/hqsdmAxPzK8+rzPBfmeHOC1adCx0Y9p8uYBleSGL0ZntKSC+ZeT70gsrV7+U2ttI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726130958; c=relaxed/simple;
	bh=1J3zCxy9ale5iPnZvhLv3BIL0HELGZX5YdbP0RlIDCk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pfFKlnt1O6FXl+i/+jyfAftMZ1yppdNF7gKV2Bp9B8NERFfUTTjOm8qRPk8554xzwzfeXo6zCTURxMb/ZzlWM9WMKz7n8Y9bLC/B9rfTXMAFzwyaOBQm7sIIbv6dzRUsu4qxTomlYfv6JNzFIXNbi+dmKsYT28Z4zts/+F6q+Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Jqo6VpIY; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-42cb8dac900so6053335e9.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 01:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726130955; x=1726735755; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ABTI+i6mJ4CMOQCHX/yBx2eOYtdjf5jrjUW+ELTOTP8=;
        b=Jqo6VpIYxXYgopCeVNiihBtgOQywzUOcijkwXm0Eob9wlMZWFt2ZssPK4DhN5r3o1e
         pnq0yvmPoXP2s8vFXRGZk7Y8cm1fM5ku1OSCSk3iv4XhXVuLk++bdSw0eFFtnBekpzpW
         mQ6k3EcjCXewk01Y0p0gUscm3UMEzqf46zx/dkx4kCN9sP4nCaZM09t+71hnsx9awrzQ
         6VoWeHqbcRMgJ+EE1erd4/ug7CKWOHa76ztWY8dg589W2plkLrdpzqqpxNKzvJ1+HEe8
         Tymp+fNhzXRSQkJRSRO3S2notZ14q7nrUUFeUZuDl7k6LMS26yZhiQOdWIMD1wYQE4Ws
         E5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726130955; x=1726735755;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ABTI+i6mJ4CMOQCHX/yBx2eOYtdjf5jrjUW+ELTOTP8=;
        b=GRLQyFt1AsUEFVzb2oWFbDsWvBa2yDXOcENXpRhIJyFWSlMXsRjJGRYyZhsbZAR3a+
         sp3Jis2ZfPHjEIkq50GOH3a9AE0pqJSKSEAds1k/hyvXSA+3xLABks6Jrm4coJU6135w
         zcz8fkIvtyODAXMKkKBcZKYVzGJpKIXDfoPefzuoSZfnEpdyqK4Bo9mrUfW9fiq9rOf1
         rp09l4nlgzPNACA25prZTX0Pyme9K0n+YpBr5Ibt71ebVT5z91VKLV7/MUwXHg6BMK/7
         A1hIJXngNsTKKdmEbdoEFVEmlRKKyj3fFOjqXvITxTSA60EXTlBPdzooYv92EtpAHTOX
         2fMg==
X-Forwarded-Encrypted: i=1; AJvYcCUMcJZ9VJ1WXKv2Bx6gxJSJzU+MdNmjKT3s5o0moBvInAcMiGhyUsciPanMHl9TSODMRo8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI8YCwtbObanAaCq40L1r/H54DBnebTXnaNuKlK/fqWd0wuVcJ
	mQUJoZexcTfJgF9o6ZPbDxaLrjxDXuGen5vrerrF3QuO4dJL4fp5GBm0YP/n34s=
X-Google-Smtp-Source: AGHT+IFtFhvViZFvTwkPEdAJJREABhf7QxIe71ol7T4wz3pTBiMjTRfKnT+ODmIORLshY159TZO6IQ==
X-Received: by 2002:a05:600c:5127:b0:42c:c080:7954 with SMTP id 5b1f17b1804b1-42cdb575510mr17534465e9.30.1726130954537;
        Thu, 12 Sep 2024 01:49:14 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42caeb8120asm164411255e9.37.2024.09.12.01.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 01:49:14 -0700 (PDT)
Date: Thu, 12 Sep 2024 11:49:10 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
	Yi Liu <yi.l.liu@intel.com>, Christian Brauner <brauner@kernel.org>,
	Kunwu Chan <chentao@kylinos.cn>, Ankit Agrawal <ankita@nvidia.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] vfio/pci: clean up a type in
 vfio_pci_ioctl_pci_hot_reset_groups()
Message-ID: <262ada03-d848-4369-9c37-81edeeed2da2@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The "array_count" value comes from the copy_from_user() in
vfio_pci_ioctl_pci_hot_reset().  If the user passes a value larger than
INT_MAX then we'll pass a negative value to kcalloc() which triggers an
allocation failure and a stack trace.

It's better to make the type unsigned so that if (array_count > count)
returns -EINVAL instead.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 077d4a2629c8..1ab58da9f38a 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1324,7 +1324,7 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 
 static int
 vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
-				    int array_count, bool slot,
+				    u32 array_count, bool slot,
 				    struct vfio_pci_hot_reset __user *arg)
 {
 	int32_t *group_fds;
-- 
2.45.2


