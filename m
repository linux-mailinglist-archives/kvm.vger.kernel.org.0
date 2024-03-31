Return-Path: <kvm+bounces-13179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC94B893078
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 10:56:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFE1E1C20DAA
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 08:56:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88AF0142E63;
	Sun, 31 Mar 2024 08:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KOASxY3M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2739614264A
	for <kvm@vger.kernel.org>; Sun, 31 Mar 2024 08:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711874745; cv=none; b=DQML/AegxR9Ikfua42fhuFevUZGVj4Ca4MsArVJINPlvJruNA6+TAQ3fuQeCSB0AJl5YeF6vEc2WaBQLn7FN2lGK1Cb7PAet2YE1jr/LCYLpthuQjOhuWp1xGEAiOJUfB1FBeAS5v30AYIkZE6Oryhbt8VstbocitJJ8f/IuQJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711874745; c=relaxed/simple;
	bh=se3bAL9NWlxdnI0R5l3waFKazObx3hz9jbN0xln52SE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Q7oHVFGvQCvs+vEMLbJn6XGQn6FlvSjzV92IyypmCQCk+96CFT4u7yqDhZLtM9RlzNuTy0VyaqFyj6LntRoYwClgQ3t7qwciPqyTp4nhdN0WZBhGRiCvgdjdx+u76uUFaq7mXBD5qOQbMZAl8NS8o6HYtkumfaATaaXtG8QzpmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KOASxY3M; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-33ed7ba1a42so2219016f8f.2
        for <kvm@vger.kernel.org>; Sun, 31 Mar 2024 01:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711874742; x=1712479542; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BCsDfZXw6LzB3XdNG+WbYeCWTW98m3a94TU3WahPKsY=;
        b=KOASxY3M6lO+qQQLfwJ1jGGy0pePEQ3YqYwc0wYTgZL6LKJTmVNTyCDT/F5HgUMl5P
         OVEqcKOeaS86ZQjWQnxNpkHgDj/wy9WmusI+4ouR7oFSw6PcbZTQ6HIWWGByI7bmfh9j
         TuKAhfu2FRHwX+/a1z0N71ajUeMaLYQfrTxMMQ7iasB28GVesgKM3HTL13QDwHJk4tdG
         W7Bod69+BBbYI2SFFFlacgcC0y240pisCLDzPMc29LB2dMOQviDih9hRoykP/1HpM+qO
         D88joXBXmlStSTZm2+3tJvgGbU8koHBuUA6ztcLrIEfj3XuTv9j29sT5S5frXzmu+3OJ
         LgCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711874742; x=1712479542;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BCsDfZXw6LzB3XdNG+WbYeCWTW98m3a94TU3WahPKsY=;
        b=weDOa6NjDQP8rbV6e3k9/qtH7210z8tDJRUmurhGJQ8bbXj3679OuW54jA43crv1m2
         ygweaPPvpSEi74Re8Cs2z2wIWxPHxW8lzOcSYo7jD28sW+jx0UmVuzaqzCOG2kEADGQg
         YQdySzGrhcfPQc/GaNbYtjya1YXT2xN8jtXnOuXxyYAWa3pGuIV8coqkolaEE4SJ6dQZ
         9QV93fbWvwZmHbAS+jy1Ry7qzTjOr91s54INjKUn44/uinyZmwV4k0Utpmq0cTSnrGft
         Oikw0/Pqa62+IrRMYR69jaV0kRDDqNBTqzDNVbIBrejyjgy8TiaAFourA6GwXVLHJ9V8
         aGpg==
X-Forwarded-Encrypted: i=1; AJvYcCV57PG+5m+60o50fLTDWVE5xZfx++Bw7NgisiAA89Dp9jsVEuilB46jHJq9FZM3g/dE3z/aQHDTEsqPOM6BC5HABhOs
X-Gm-Message-State: AOJu0YwXMrjvCNlXPe0TcOCpWe2oztHLWzAsU/+AMSdQ559RBWiciRK5
	/XYoKVnSZvfU8Xj3loMHc1jpmqLKcDb1mLJZXBqln7zZmr+4gAaoaV7Db8Lf4Z0=
X-Google-Smtp-Source: AGHT+IF3ZrUCOMfmBGxr0QtcEyHWRTvBM0iQXjRTcy/YDkzaetKNZ8K3RMX84Tih4bjsekACtKBC5w==
X-Received: by 2002:a05:6000:4027:b0:343:4609:ec27 with SMTP id cp39-20020a056000402700b003434609ec27mr2052015wrb.70.1711874741641;
        Sun, 31 Mar 2024 01:45:41 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.223.16])
        by smtp.gmail.com with ESMTPSA id k17-20020adff5d1000000b00341b7388dafsm8436003wrp.77.2024.03.31.01.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 01:45:41 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Sun, 31 Mar 2024 10:44:03 +0200
Subject: [PATCH v2 16/25] net: caif: virtio: drop owner assignment
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240331-module-owner-virtio-v2-16-98f04bfaf46a@linaro.org>
References: <20240331-module-owner-virtio-v2-0-98f04bfaf46a@linaro.org>
In-Reply-To: <20240331-module-owner-virtio-v2-0-98f04bfaf46a@linaro.org>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jonathan Corbet <corbet@lwn.net>, 
 David Hildenbrand <david@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, 
 Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
 Jens Axboe <axboe@kernel.dk>, Marcel Holtmann <marcel@holtmann.org>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Amit Shah <amit@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Gonglei <arei.gonglei@huawei.com>, "David S. Miller" <davem@davemloft.net>, 
 Sudeep Holla <sudeep.holla@arm.com>, 
 Cristian Marussi <cristian.marussi@arm.com>, 
 Viresh Kumar <vireshk@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, 
 Bartosz Golaszewski <brgl@bgdev.pl>, David Airlie <airlied@redhat.com>, 
 Gurchetan Singh <gurchetansingh@chromium.org>, 
 Chia-I Wu <olvaffe@gmail.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Daniel Vetter <daniel@ffwll.ch>, 
 Jean-Philippe Brucker <jean-philippe@linaro.org>, 
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
 Robin Murphy <robin.murphy@arm.com>, Alexander Graf <graf@amazon.com>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Eric Van Hensbergen <ericvh@kernel.org>, 
 Latchesar Ionkov <lucho@ionkov.net>, 
 Dominique Martinet <asmadeus@codewreck.org>, 
 Christian Schoenebeck <linux_oss@crudebyte.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, Kalle Valo <kvalo@kernel.org>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Ira Weiny <ira.weiny@intel.com>, 
 Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Anton Yakovlev <anton.yakovlev@opensynergy.com>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc: virtualization@lists.linux.dev, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-um@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 iommu@lists.linux.dev, netdev@vger.kernel.org, v9fs@lists.linux.dev, 
 kvm@vger.kernel.org, linux-wireless@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-remoteproc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, alsa-devel@alsa-project.org, 
 linux-sound@vger.kernel.org, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=759;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=se3bAL9NWlxdnI0R5l3waFKazObx3hz9jbN0xln52SE=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmCSJenCPpEnFAHTEofapxPYFUf4fpJ0gAnwfPB
 1J9/P7me5OJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgkiXgAKCRDBN2bmhouD
 1wIcD/sGSIoIdHj/zYFnEhadRlmmHAAIVdCpD+G+O+AagKBU2I+fBkRPidWKXAPBKfSU3fF6iNx
 uy9LpF6AU9fW2XytaIZDWmq4ZJoJ/yAlIDFZ0Rt4uyhqB0Ggl7wHDrkYT+Ex4M4c8tLxOXPYSsD
 /bGA5wL677fAt50nzo4AT1T2X4LfwWGTL+ocvXlBhxRqPH6BXaXP1TjezXkHSM5HO95HqOW5EPM
 Loavoa3/t1lD1JXa+aAsjLL2Bb2wgcaRACpNZhtjn6Ps/S/rG7bwwek8RGlnaKxRX9GvGmlsjNG
 hBpWfYGDD2+pMIzk9NPKw/4wicHB2nBN1tqGXUwEvj19tJSZqhNt2GJZ+MmMQ0HmnNy74MgtOs6
 W//DnrXgIvSgXQJJunvc1dupJIshYqu36eDdmga1kDj9VYUZQlysCR1S3hyI2ius9goKWJBlYze
 Fu/qHoWTsTdRqlUPbU6IjDsrCWb00dmZ18/kXp0+LAYAYP2wqvZDKPx37pJZuxcFvCgr16gA+BI
 pNFOggLaDpzsFbU5gsdMYxLb9OM3j4nA6499+p8u5iFIEtJOzBSMw5Zm5ulZTlh/ED85nO/CPE3
 Vp5uHW1WKRV+ba2+hA3mDrxUmVM1OcbOXZlFGKll5nBtbAwTXF1bW9up1XBE3MAsu6b+tYKjhJh
 hYegPHr37N5IQTw==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Depends on the first patch.
---
 drivers/net/caif/caif_virtio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index 0b0f234b0b50..99d984851fef 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -782,7 +782,6 @@ static struct virtio_driver caif_virtio_driver = {
 	.feature_table		= features,
 	.feature_table_size	= ARRAY_SIZE(features),
 	.driver.name		= KBUILD_MODNAME,
-	.driver.owner		= THIS_MODULE,
 	.id_table		= id_table,
 	.probe			= cfv_probe,
 	.remove			= cfv_remove,

-- 
2.34.1


