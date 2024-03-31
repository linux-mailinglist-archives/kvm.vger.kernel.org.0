Return-Path: <kvm+bounces-13167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF2A3892FA9
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 10:47:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F64B1C20D49
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 08:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF3C86151;
	Sun, 31 Mar 2024 08:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iJmF4xMb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEFD85277
	for <kvm@vger.kernel.org>; Sun, 31 Mar 2024 08:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711874690; cv=none; b=KOCAfLoSYW60vNMRGYervfZe7L3QO2SxpgwJ7xwKlAUJYJ2WKck5Dfgzo6zOMUlGCVCm4d5Wsd0QbFBQKBoOoH3d7ARBmxiWiIsF8tkjplcAD/XHuumWH2yFf39n7vCdHZlHewy7jQciFEpQi95Iyqj3KVJiTp35BDbPXHAejZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711874690; c=relaxed/simple;
	bh=wAjyw+8BG9Q/VwqKx0H5MhNDfrH26X7x79bC5lwKCk8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OLTtVOFOy6w5kUG+Ao3x1JIMNKf6JFB17tV3r0Ui86kZWCjukYtgZiFM0+dOrJp5rY8crkgYVK84OEEjaydPmkT1zs8T+CrPfBG7G5XM0jGt/uGcnnpxOY1c9TeoHHoeJZwHFKUbpzXNQ6oUhO5iQpJCBwL9aOfYxzYeaBTCzBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iJmF4xMb; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-341808b6217so2094991f8f.3
        for <kvm@vger.kernel.org>; Sun, 31 Mar 2024 01:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711874686; x=1712479486; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=shrdZmoV/+LZqwehvxghCY6dk8UPLlZrkww7U3AfLpA=;
        b=iJmF4xMb2f0Var/mB8Ni6YsQfrOuznfrqDBXofOWFBUNRK5YTo1kR4CuYM6CJVH9Sz
         aAu7MWosbLrpopfJJFsE290qbFrB+tkkcWnlyGMdBdjNHstpRGs0t+Qqt7O2YYTQZJRg
         f+40fHrgDE74s8GddCBZD6JyjGmHFJBMthpPWj+aQSdJN0waSBXSEviIfziXOiZ26/I5
         I8rLhNP/SDma7zSuzaD/MN9GTODuUrqAmBTD1kdwH1jPPk5nq6KFyEXCzWVLzwp6cXfs
         GrMxZwpXDxu896rkRvbec39Fmk/oTm7T9UyQJ/hDgckK9ib4xA3PhnUzZK+yXnShV339
         PyRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711874686; x=1712479486;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=shrdZmoV/+LZqwehvxghCY6dk8UPLlZrkww7U3AfLpA=;
        b=CAqsqTpWQft6JhvuFNqyoYltegCXKwuKeHLK1o9B2FpLZx8aHhCqUIGlPJBAI1h7Ji
         P0w1yiGCJlKYa+OzRgo1IryNTCdOI4ewqX8RUsQt+ago3siCWgf0UpVgD6rDNop1Ss5j
         PZIvn3Af++EeXqWIfpzlkP9ZoZs/j7z5oO+T5U17/0LK8NQHPkMUsWYrelj73H3xI+ha
         aLpndik6dtUmMrJeOIRf7xIEaHBChi/Q1riDL6cZbYHdSKMkI2OYydt8uuJZD48ddIBi
         wI2Xt/sqmTJorlUjczyxm30ypwhTRcJy9wvjM52eevOqqhDjA8xQ4kOt2qWxQhUIoqGx
         CNEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZZpJvQ/DWSLsTfazi+pfzvkxzcXHBGvud8swAQaNV4LFZ8FcXcK+HyuIvc0SCeaFuSfBM2XTwUY8ozkTB6b3SLyYM
X-Gm-Message-State: AOJu0YwzH+xxbPo4B8aSwQ3PLY5iaQjWFP6WG/esZUfwQXU3ncpVF5OS
	OOajFy3wEu9j3yn4Fp89MkfPWidv//dwrusqk64VEF9BBm6YinPbixr0eUn7fSE=
X-Google-Smtp-Source: AGHT+IGE3mBHpk2iYgCZr4y748sr+z9cCqPzcpXrC7rbWUuwjwgJ1DZOI40A9D2OMrxW16aiemUNVw==
X-Received: by 2002:adf:fa43:0:b0:33e:d68a:7d42 with SMTP id y3-20020adffa43000000b0033ed68a7d42mr3902796wrr.30.1711874686293;
        Sun, 31 Mar 2024 01:44:46 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.223.16])
        by smtp.gmail.com with ESMTPSA id k17-20020adff5d1000000b00341b7388dafsm8436003wrp.77.2024.03.31.01.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 01:44:45 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Sun, 31 Mar 2024 10:43:51 +0200
Subject: [PATCH v2 04/25] virtio: mem: drop owner assignment
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240331-module-owner-virtio-v2-4-98f04bfaf46a@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=785;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=wAjyw+8BG9Q/VwqKx0H5MhNDfrH26X7x79bC5lwKCk8=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmCSJTSAIIgTimebstG/Qy7uAfSArMFyh2juPUo
 6ZPodVLBXKJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgkiUwAKCRDBN2bmhouD
 1xDtD/4z5RmDFqjWll6kjvhDzAxQrcOG1NaTdWTMxysEd+H0xrvYrwZ47DKXPkAUiIdSBZbN+wM
 vueRYnxKlobdHqQt51krKCLl+ShScgF1bRuBVLLEK9c0R9rXygVdMqVnmYUOzjgGI5AP4dK8hd3
 /UxxdtXu5ezHuGb3vXKiFiVtZuTorRjWXgX5EfYg1qmNq0mZVLnzQjPl6hk2eUwnAyzaNAHlWkP
 il+dRt35QvwCmiKSxbsVvt1xUw2O58H5Ln21w9RYHg9yaqD9r9biAKNT8hz0+OhQ+csGBzb1qNQ
 Yy0/B2aVcnfNoxlvU/3B0n3IXe/94fTVmCGaMutYCGWUd7mmtXBPLQHQigb7XF/WhI+H3ZlhQ5j
 9iPp98vj6pSGuwWtvf1vAmWQ3C7hLch5jnolS3lhEb3Kr+Mzp7FvMpBPkSPapmaEoXyMhD9aFHS
 plVjGY0URnm/4qINC7B0fqXMQf5XKv1ozQF6C3ea3p8LZgknmtkiQGJOQjblgGJqwugh2zyhUBF
 9bx7ZBmQgtIz4A9IbAP5ZxYy+9ZZCD5dPZe4Hrwc1s2CGw8Ajpl8CNB+otZFRPRor3W0vF8G+hM
 dPJ70z0cLIp74sE/i0MtNiKtmuqVcPtTD2ASbduSMGLBpM0o4WfdMTlVFNjz4hdDGCV0cAgC34+
 RVnhiy/vQaspgfg==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Changes in v2:
1. New patch
---
 drivers/virtio/virtio_mem.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index e8355f55a8f7..e605d906639f 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -2991,7 +2991,6 @@ static struct virtio_driver virtio_mem_driver = {
 	.feature_table = virtio_mem_features,
 	.feature_table_size = ARRAY_SIZE(virtio_mem_features),
 	.driver.name = KBUILD_MODNAME,
-	.driver.owner = THIS_MODULE,
 	.id_table = virtio_mem_id_table,
 	.probe = virtio_mem_probe,
 	.remove = virtio_mem_remove,

-- 
2.34.1


