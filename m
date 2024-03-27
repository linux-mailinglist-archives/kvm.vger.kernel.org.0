Return-Path: <kvm+bounces-12834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 493A588E4F8
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:16:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADF8B1F2FE57
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 14:16:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBFE7147C8B;
	Wed, 27 Mar 2024 12:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O/ZLzWMw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D445A146D6A
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 12:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711543350; cv=none; b=gB3HWWkpkyE2Vndn9t5ZitvuAslYLVUHxHnQfuAk+El4v+Xg/UuMgAmNEp+StYLoZMXYOj6KYUNCQf6/yI3RhBpFFK1EGLOHVUgBinJC/4LUxbx6l+OrQEP4xKBJTX1NWgrkoqwccZ5qC6rg8w9dE/sodDmVvZoij0hudcjNZ9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711543350; c=relaxed/simple;
	bh=KrWaLvXjNRGS2R/7/B1+JUwLcklixu9aLwMl5ahCx2Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=f1dXWwp+bM1GFqSbCRDL/Oo874yS42uvJztX6vB1UV2GoPF5J2Bj8VhzQPXpysITRCr4TKZ6qjL5HuV0TtC1U0gF9i2/Oz1OpbRtAtp1LXp/sEpOOerBVOfF0A/1FZvVMNyrfOd91GFxv3l/iIcn2zQZA2o0jzAbpY0DvKAK+r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=O/ZLzWMw; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-515b3077d09so2309292e87.1
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 05:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711543343; x=1712148143; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eyRMm/wBFZCWNsLJMI0b6MGwMk/UDF0WMd3K76wQcuc=;
        b=O/ZLzWMwXmSS4XsxO+De/TaZx0NeRvXPsoZhsjTM7jACrwgsA9FJs3wK/NvzEl0QXd
         SAAl3lbOKqIIFcYEypt80y9eWNKn2AtrBgOEhW7JuhaQFqPvgdveuZcRugJdi8sQgm3O
         QEty0D/nOmY7seqXgjKyH/9iBuaRzFx38Ln4MNolyvku2M6/tVfMvquh/s3d/4/Nsnp1
         ldMFo5H9jxzy+ib76dUfxw3SgARsCSq/JMXFv4kH0hH1QufpoHHilnI9Ku9YlfwYXn7f
         tkr0u+1eZude3PadOc5oyIs5XicLXIt7Cl4K8entzhcK21dsmZE1+R7f70+gNle/er/B
         /EAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711543343; x=1712148143;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eyRMm/wBFZCWNsLJMI0b6MGwMk/UDF0WMd3K76wQcuc=;
        b=tQRp2t7c6qx2RMoMaITsVKvQONWOb6scQSYmIFeBUphGrOMBZt8sCQeot1tXoJPNih
         oWEpEG2D3mrtaFsVEdqhf4pGL8kiHtHqyypgQ9A9GsV8gmIZbBUnpDzxtGkZ+h4h9UuH
         qX/YpJAoSUhptSmckS3ccNFVOM79S5+8u3hBS2rMIU8uT839+oBXeXuY36kihnCIv+54
         1Grud6yFvofDMKUUQGDSwkmKcPpY7KFJ0FEC2UvPQsLmKxbYyC1hROyewjVnoYVXJp1v
         DtNbMPePOAisby92tgFfI3loTm6RcQDjwu2Nxkw/R6vifZZN+Ao++C+wRd644ODZ3mrH
         3PUw==
X-Forwarded-Encrypted: i=1; AJvYcCW1Eih78DWHami3+LrW6qYcYrhs7th+idthJwGnaLYasxgslVHFNsLjHJa2GYgo1u4p7KiNmJmOiFw8h4ls5jabWywK
X-Gm-Message-State: AOJu0YyeRGDyrPvLzISO8UMBiNAcrSGEEX+UYgFNiff6DEdGMiO6255+
	PPFmWzouXSk1JjOrxuvD19b+oHJDg/gLJ+06VdcrbBaI4X8OaLSrd4HlmH8/tic=
X-Google-Smtp-Source: AGHT+IE4FzeNxkir4iuwm3e6fVZcYVR1d5yg6o049b/koMtV0XB/ttMCSkTpg1aZyXSbfrGYGznh4A==
X-Received: by 2002:a05:6512:3705:b0:515:ab92:6a82 with SMTP id z5-20020a056512370500b00515ab926a82mr890664lfr.17.1711543343032;
        Wed, 27 Mar 2024 05:42:23 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.206.205])
        by smtp.gmail.com with ESMTPSA id gx16-20020a170906f1d000b00a4707ec7c34sm5379175ejb.166.2024.03.27.05.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 05:42:22 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Wed, 27 Mar 2024 13:40:56 +0100
Subject: [PATCH 03/22] virtio_blk: drop owner assignment
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240327-module-owner-virtio-v1-3-0feffab77d99@linaro.org>
References: <20240327-module-owner-virtio-v1-0-0feffab77d99@linaro.org>
In-Reply-To: <20240327-module-owner-virtio-v1-0-0feffab77d99@linaro.org>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Richard Weinberger <richard@nod.at>, 
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
 Viresh Kumar <vireshk@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, 
 Bartosz Golaszewski <brgl@bgdev.pl>, David Airlie <airlied@redhat.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, 
 Gurchetan Singh <gurchetansingh@chromium.org>, 
 Chia-I Wu <olvaffe@gmail.com>, 
 Jean-Philippe Brucker <jean-philippe@linaro.org>, 
 Joerg Roedel <joro@8bytes.org>, Alexander Graf <graf@amazon.com>, 
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=774;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=KrWaLvXjNRGS2R/7/B1+JUwLcklixu9aLwMl5ahCx2Y=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmBBPc5tmdWrFuFntuG/yAvvaSc6QQDgGKV3xXR
 d69ixg4mVWJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgQT3AAKCRDBN2bmhouD
 1wyfEACQliB2cEZpIO2A3tCh010r1fx2tRLerPwdyLvNuhf6A4vHrISqh/SkyeIavgOK59NAl/t
 Rp1B5Fmk6cyoLlyVI3UYVrttitFKN8XkcCSz14RB1mX+RMx2NfxbqjfcyZrhAZl0WU+JB4naqnr
 q9JxnjjG+J7i5EXrvzVQdXcbr7gOkdPw2Hhpw9tA11Hz5uRz+D8tg+b65wm5+wWLP0XiP/fpabz
 Q7W+nWhPoxCjeNFXwQJtTsKiwQ3JQqULRZE5V6QsmTIoggFcbktqr8l32KIWs/wkNhhRCdo81Yr
 XPYCaRbxyvul4I+GW9Pl3Bcip334GkciqKP0lGqxycAZKaJmFhhkuKwVH1DMv4k/h32/UVfAV5t
 Xb+mTjrD42g79FYzXvebQB5sAowZnY20DCAbX0Nt0Ha/JryD115o9Rw5doyU6CQ25F3QUddYWkc
 v+6ciPckjK3LQi58EdyotgmVwlVwyg6qtaEd926djnW+bGSwFXtrd4qHl7VPC3tONytWWRDAfHP
 ok5hPHVC6UFMbmKRJVjv8X4yEQw9Xb0TY8o1Ejyg6ks6Y6jcJ2HTZnTqgUBtzgx6Amu+nXSivUM
 s6tjX9vd69r4uEsD4Gmgq9fA+gkgTwOwJKGBx5Hd8aGZU5JMaAy9ADXKv3I3QgWIdIaU2wk1GOf
 nY1C/0V1R8J6KUg==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Depends on the first patch.
---
 drivers/block/virtio_blk.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 42dea7601d87..46bdbad1ab48 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1658,7 +1658,6 @@ static struct virtio_driver virtio_blk = {
 	.feature_table_legacy		= features_legacy,
 	.feature_table_size_legacy	= ARRAY_SIZE(features_legacy),
 	.driver.name			= KBUILD_MODNAME,
-	.driver.owner			= THIS_MODULE,
 	.id_table			= id_table,
 	.probe				= virtblk_probe,
 	.remove				= virtblk_remove,

-- 
2.34.1


