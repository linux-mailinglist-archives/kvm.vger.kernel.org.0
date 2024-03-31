Return-Path: <kvm+bounces-13181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B1AF89309B
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 10:58:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D65B4282A0B
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 08:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23740144D05;
	Sun, 31 Mar 2024 08:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rO63Xy4q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A54C1442E2
	for <kvm@vger.kernel.org>; Sun, 31 Mar 2024 08:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711874755; cv=none; b=Tzx0Hl1Th9YQcfEw03z6wo7XzGx3YVsnr/I/Dhp/WG6HDPKqzOC/y5WJW/F2/tfyB3RAaVe6JT36Ec74NAF+nwkS08R9FzSNkUviIR0VSkDPoSI9jxLrQcm7KG7egFJjcothfCluVvDGTvy0k2uJZyhNdN5Aq0grLV7lCz5dkAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711874755; c=relaxed/simple;
	bh=JcKhWFch83brhdG0VtzetHVJQ40R24YKIvpYHZtTLn8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nlyPPhrMa9nEwyrFCJ82kCyh5bPD03wL3cIiHJ9qi8rj/YXCUBxocA6QnjcoTldOJZILxybUJjvWp9MLbh/CE7BxRGv0RyvptjvAZLMVYOOOh7IYJmLXiNZ+W2mxGuurkpQpliUI/30IG4VXrc9dnB+FtxM76YyqJqsz7Qss3uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rO63Xy4q; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-341cf77b86bso2244121f8f.2
        for <kvm@vger.kernel.org>; Sun, 31 Mar 2024 01:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711874751; x=1712479551; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DTHQAQAXVP2yHTVyN3Qf81PY6hYlRsflmkOJj4KRX5A=;
        b=rO63Xy4qB92+3FqAqk1sC2M6fdoj//Auh2hmwujuj3NIeOhtb+ipsUfpyvc7Q68ejJ
         wbjFGt2Qfk9StveruxsCiYUySkjqNyecGC6RjRWASeqFfxA1P/MTrb2Oc5oNuSB90OIT
         VoYD1oes5IT33xWUdDY1nJsClgZhbZKDTdT/FT2JOR71yw6+4c8p+lqha0eMs+TKlU8C
         QxX688LuuBsXvVGw2JjFWwRDqfUxHNrHwu5+IMepKAVSu2dXyyCstH3g5zlRxVTxvVFM
         WEhjBwCkV2ntf6yrKtNwDpQFZXRk8Z/vowMD0TJdkzdoyQ9sI1DxwXx3qycpYKThc2Th
         Qgcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711874751; x=1712479551;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DTHQAQAXVP2yHTVyN3Qf81PY6hYlRsflmkOJj4KRX5A=;
        b=F7y0AWMhkDhS1ti1M/MebOB4busIN+i3yNpHNKSQZ1P/BR90184hBKSEDGsq2UHjVZ
         F37jAhyotzxvmg8LCGd9INA7+9geeIEXF/Kf87oZHkTa6r1+PRUtmrnrEFUsaKyrC+zG
         qG8MkXun/m4pAR5YeNrsa+aAZkBgproiw9TX/ZtvWzcsh+e5LKrVzZQN4H76kvDszf3m
         yxCJvyXfHOO74xDws0O9D/5xjl0s9NHW45TPQ/AVq70Y+cIfxDjIMuB+bvBQcSFPqJ1E
         8HNCcJs5QXGJONJXzzOmVNPYLHoQpKRDdM3MQ8jlTI+3kcUXOsHrUyiZ9iWYwieexJRv
         PXyg==
X-Forwarded-Encrypted: i=1; AJvYcCWTwnJHxgcwjExjv7tcHKZ910gw7cixFgtFc6IWAKQqgqWtDnDb+3eaOjaBhcHNDsCsQg3xbkUFInVXbSTYwDbZNghw
X-Gm-Message-State: AOJu0Yx2MsY5msV15IBhAY8IKZ8LC/Pz7HsezM0MYWhTH8LsnhHf7f2w
	WWGZkc6DbmASZg4N6x/Oj1hbGos6VW38NBzBEgMJLIfJlXk6FmUo3ODuAF62Tsg=
X-Google-Smtp-Source: AGHT+IGeuGXiCbCJT2fwDI0SEWizUJ9iibgMGqfwV7TaAR+tREdoNJwDLyVfYi67Bn1T1MJNDldUog==
X-Received: by 2002:adf:f804:0:b0:341:ddbc:fcf7 with SMTP id s4-20020adff804000000b00341ddbcfcf7mr3806166wrp.1.1711874750824;
        Sun, 31 Mar 2024 01:45:50 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.223.16])
        by smtp.gmail.com with ESMTPSA id k17-20020adff5d1000000b00341b7388dafsm8436003wrp.77.2024.03.31.01.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 01:45:50 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Sun, 31 Mar 2024 10:44:05 +0200
Subject: [PATCH v2 18/25] net: 9p: virtio: drop owner assignment
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240331-module-owner-virtio-v2-18-98f04bfaf46a@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=719;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=JcKhWFch83brhdG0VtzetHVJQ40R24YKIvpYHZtTLn8=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmCSJgSqws1ddSI6zt8bZXVN2NyD1CLEpfewZVv
 OwoagjJv6qJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgkiYAAKCRDBN2bmhouD
 102lD/wIvu7W4oAOrFSz41pWQt8EAwtItoVXQB9hvcjw/YA+2zX+aydeb02+0qHLAQbGNHBdxfc
 yT1jMBjqC7hm1u0RTSxBcbJJzGs8e2DQ5Vhp70FBMhH5Suzn68J6dOPX6N5wHdff75zMWr9dJyK
 vSMxNyOJ19ThsLo5G/naBdf5gD/wl7GWZ/BynkDrQeahyUwT7EAmobRBH3C58X0PJzx1UeyIaGn
 BD4PrDB3XmtMl2+8fDS+Yga7XtwImkKcCKQmPYaMiOyK8nsvmE0G5mjoqBDyuvj3DbXP5PyEcah
 8siN4HSdpwXj68yE2KgItH1tHOp6PLEId2/8rHBD1Cf8LRqYUpJOSxYFlVCzh0QFv0epWEaRBFY
 t+sVw1BOnmBi6uJ6zpDaomcniLZ7+QMb6J8kX0aGCnE5xhfvD3GSVTn0b4+Zt9glME77oY2Csxv
 27NZ0gLAatWrCnBDi9A/Xe83MKDzfdh5+JqvpcrgsnvNQamvwK41r74/++Ec+O8FElCfF/VXAcc
 ON4Fxjm+sLJHUICUQYzW8QNCnzdVMi6R+G1UPZyqrIbvxfEG1TvL3Sd5Z+A14qs4De367Wz2+XG
 1OHZrEYXkqdpZXUSnF3NgkWODrQkgjG6Fl/9xfwVMVzKxPLTYE5G/yHlgDd6baxF42Rlh2MjRz5
 eR/43u41s6aOCmQ==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Depends on the first patch.
---
 net/9p/trans_virtio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index e305071eb7b8..0b8086f58ad5 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -781,7 +781,6 @@ static struct virtio_driver p9_virtio_drv = {
 	.feature_table  = features,
 	.feature_table_size = ARRAY_SIZE(features),
 	.driver.name    = KBUILD_MODNAME,
-	.driver.owner	= THIS_MODULE,
 	.id_table	= id_table,
 	.probe		= p9_virtio_probe,
 	.remove		= p9_virtio_remove,

-- 
2.34.1


