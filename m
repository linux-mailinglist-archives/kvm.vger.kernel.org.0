Return-Path: <kvm+bounces-13184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 226078930C0
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 11:00:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DA351F2139D
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 09:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 822961465A3;
	Sun, 31 Mar 2024 08:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eKn0UBLP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351B01465A5
	for <kvm@vger.kernel.org>; Sun, 31 Mar 2024 08:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711874768; cv=none; b=kdcCfSQL7Jh92t1vf/leNllpRiXkwp7qOVmC29KsKwmOgQKfx4HMjaIWVd8dQpiXsqfQXGeCWnxolsE4Ul6mkK/z1vf6E9hsTk4APt5QePuJBN9HiZNE0UcrawXJ6tSZyHlFj3FMABpRXeZKz0ALRF+DhHdMhdef292Qdstufco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711874768; c=relaxed/simple;
	bh=djiFy5u3KBh7sxz0UqH9tQzKO6FqFPG/J3nA2oWVUvM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=K3DPHZHc4YijKrF9pDFcFco5WFWgRnoIUD5V0UpFhfg73LSvz3T/N+lnzomkn9q73p5rG7ruQDRcXvgiPFJ8jK4PetSkzbBs2IioMnI7CIIKYV+j5NtBeMHJIBFG58AIUo3OTntbkJxBykeani0x0byRZYOOaQFsFH5rMCUNHrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eKn0UBLP; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-33ed4dd8659so2609463f8f.0
        for <kvm@vger.kernel.org>; Sun, 31 Mar 2024 01:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711874765; x=1712479565; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ynnKTjrcpie+nYJ7zJCc1O/bqKJjh6+n6bK0J+8BU9g=;
        b=eKn0UBLPfWs3/FCQwlmpwniiztBjeVdAShWQwH6W9vnKYQk7grjxmt538jyg83x3zY
         E2R4a14910zg0WKlaFgrzZPIhkRamYkdGo14QN85dM3/bvic5jLaQlSkB2q78wEs9WOE
         3gWACJvKc0GBK6KJhoMTY4MD7wpNMd0Q8zyNh52h6zQ6JxrVFDZAVcAY8c5BXEPgKvcI
         gQxpO00Xf9K1AZdZ0jJwVfLskr0Z6xhf2xRF9tFbGOcub6Kur5rKsx5287ZiUrb62M4S
         Rbf7BvcP9t+NTnh4+jIWJLu8W3jxTvX1bfRCODKRJnmSb8JiD8BQNDIpgI5n4pKuiET2
         1bmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711874765; x=1712479565;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ynnKTjrcpie+nYJ7zJCc1O/bqKJjh6+n6bK0J+8BU9g=;
        b=LdhXOE89ajnWl52fOvX5MzlWFm1XprCiDtjSMavJFxOy7qq0orguEMw7tdAIj0fKnj
         hao0RELp6NvM2/3gn9TXYDKO20BYxUQboEUUd3dmVDXtmeF4dRY6ivK0cx2MWvPi7cas
         5g4ZqVbrvDvpLViwQZ3aoOLhkoZ7HCfdntHGOGhNpgtcvWvWTo4t9ckZzSTd+5vbc9oU
         7eFkrN4BHgLIObbKICFztQFFQESYB5MNvb6SBgzjw6IoA5hqY5ISKnwPib77buN3NkY2
         I0+ytRjgICAwaoLPr5Y4u/t1a36uGadwtmPjrTZzRvlJs3QaQFlCBMt7nNNcVtJBtqDJ
         Z7tg==
X-Forwarded-Encrypted: i=1; AJvYcCU5PvftAa3SORHzwu5qeMQOQlXpHCghzmWKzryIMRafoGEbemqGw7Ao5UWHYHUYPsjParWmF1ncmG/S3R28Xa1MAptE
X-Gm-Message-State: AOJu0YzCLvRyP2r91/0GUMVgyvkviE7PoYUI+ubCVq6PhskShyaryCLT
	qpEixaAj4bOKfKucHH91QZUEE8Aa6r1/6j0Lva1CbgnKloUzt5o8hfyRqYNbvdk=
X-Google-Smtp-Source: AGHT+IE9HCbYqXr10WjNVCL6+bCwlLWbV/NMZIwtw1PAsCjjTRvMs1pGxGA/oXfJxTVFO3HnB1qqrw==
X-Received: by 2002:a05:6000:18a1:b0:341:e1b1:a5b5 with SMTP id b1-20020a05600018a100b00341e1b1a5b5mr6504132wri.13.1711874764733;
        Sun, 31 Mar 2024 01:46:04 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.223.16])
        by smtp.gmail.com with ESMTPSA id k17-20020adff5d1000000b00341b7388dafsm8436003wrp.77.2024.03.31.01.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 01:46:04 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Sun, 31 Mar 2024 10:44:08 +0200
Subject: [PATCH v2 21/25] nvdimm: virtio_pmem: drop owner assignment
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240331-module-owner-virtio-v2-21-98f04bfaf46a@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=811;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=djiFy5u3KBh7sxz0UqH9tQzKO6FqFPG/J3nA2oWVUvM=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmCSJiCUA1oHxtanMlVDa3B0IS2vFZjLtjegvnB
 r2LktHu/TmJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgkiYgAKCRDBN2bmhouD
 1+fCD/9rVUL5S9fAYP2Cn2joknxd9GcyxZ1ZcSysBEormmSyzUriEDIqirrsKi680bEbDylBOX9
 x2MmTBvkQvu/rIQaoQX/tKOG7I91b1Vbkk+M/NAsbbgnagkOSShnc3shFsc3rXApauvlxnO1qvb
 z8DY07D/WFV3/ayX9Pc0+PnpUDKtjympuX6u7ZHB4k6EwKFN2I+M+HiqBoPn3/ikV3qi8Pl5ABn
 dVmokdreeUGTxM3sQFHK02cmnhLTPk71xIHNooat+Oh5ZT6rcdAvm0AG4WFUisCpcckAFMO+cX6
 PQoSym3RhOSPNBuSGE69s0aBavxd4IuhZiI4o/Jw+0VdzvVble2tpHu+anv+0Glt6Ng5f1OPaYi
 CXmDxjyV03jkc2tlsgpIdfrBwo4k9U+5eOoACVeHWRlxa6eDLI8ViIyEzujQpnD8ueNX2Q8XFgl
 S2ARJ2DUcykXT3jv1xRLTcRYkjqbSrBQ4N13gZPLY2T8UnZrpAwIylFubiw1Ahd+W3KV1JUzxwL
 vUBVwDlontFEzLJVXp78UAxmuAChFTir9BJsAENfp8Sn6B+wzUxU1X5IwJrmDBoO/JvPuQAW3N1
 eQRSKA5Wuv0EaRhEEMBePFtrM57giBzRXdSf97ZWQDn40PWYCC+66dK7kdUzInryIhsEEMdcmlc
 cYX7/PO50bomQrA==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Acked-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---

Depends on the first patch.
---
 drivers/nvdimm/virtio_pmem.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 4ceced5cefcf..c9b97aeabf85 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -151,7 +151,6 @@ static struct virtio_driver virtio_pmem_driver = {
 	.feature_table		= features,
 	.feature_table_size	= ARRAY_SIZE(features),
 	.driver.name		= KBUILD_MODNAME,
-	.driver.owner		= THIS_MODULE,
 	.id_table		= id_table,
 	.validate		= virtio_pmem_validate,
 	.probe			= virtio_pmem_probe,

-- 
2.34.1


