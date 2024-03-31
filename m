Return-Path: <kvm+bounces-13188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98BD78930FE
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 11:03:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F6C11F21E93
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 09:03:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E35783CB1;
	Sun, 31 Mar 2024 08:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Hjtn5Hln"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F4C1494C9
	for <kvm@vger.kernel.org>; Sun, 31 Mar 2024 08:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711874787; cv=none; b=mIeHT1jKDXeYpB7SSvwzlmJi66sgj7+JkRFw1+gpnSNBHejvlY8MfAj5dKjMVSDjxU+4cmyvVTh2h7pWzGqxuNpQKyAjW7C1F/zSEq8zkLQVQ5nmddl4zOlcjdCMO73ltxy+YGd+rVGSFQyiu4R8s8hsCqBS8NDo74j+ylkT9bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711874787; c=relaxed/simple;
	bh=ZZgxTq79++b7HHq30K3VBjFNBWdk1QKSfVGAvnwx7/U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LqzSGdY+FRhG6a21jSgDqXRKFoYXKatWDrQChxqf1r9qn8sdLCR+SRFjKzy6e+H1HIevJNjDf0j4AW/cL3/PxJq7pNs3dclmfEpepw/7iTG6WTkldbIkHnceqk4dGu8sAaqGDUN5KFZekYJG8/Lzd47Cd/Yzfi+FwhFiGQYhAKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Hjtn5Hln; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-33ececeb19eso1933392f8f.3
        for <kvm@vger.kernel.org>; Sun, 31 Mar 2024 01:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711874782; x=1712479582; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PUGaKwdvwMokLlZR31UQgBcIJ2q0krEU+yZMO7QbwcI=;
        b=Hjtn5Hlnes+w/e3w0eIr7nTTgSvMkDmZzsGAWeX3YC3DfaOpgP2PPknWKtAJoy6EE/
         qmCDP91IjqyT+WUq1JbCAoWyjT8nVHhBFmWdVgk0Fe56zIGX0EzaY4w5JojZUz8eOTSq
         bbVl2PykGm/CmM9SBKHHXHVZBsO5HZaZIDO33uuEaZufu9xJt7GORX5VUBtdXMbrqC/X
         Y0LErKvrlsDnwUy4CqDF8HF1dE5RNaIEwnyl3cbuOSSMg4B0PyOU51qtlo5YuSt6FLLf
         MToJ2Fztixc0ZZyl+McVdkXLITXzwverL2iGuRWtvyoEjfDLYSgIL5jdI6FpwhSg6kGH
         kWPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711874782; x=1712479582;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PUGaKwdvwMokLlZR31UQgBcIJ2q0krEU+yZMO7QbwcI=;
        b=ET7Gkdkva/CkFSE26dNn1f6jDevI/bhUOmRJMc1IlQBIreNEtwCpsFmsS2PYcv7T3R
         FH7VBgGK1QYFxgECxZBUBPiQGvFmhcmoFVe5zX09tMoJpbDLlZjI+62PSFNqCKnxPfmC
         fzjjvdHcwV0SBP1PdO2hQh5VpH661g2wxkNfcnlNvjJuebZb4Zt6lT6rMYzQ+aAkcmFY
         GuJNleQsGRR8XN8tcgVe6EO32xYzI/PN0meRbTZWmyAzYAFhkZYmpE6PhoB4qg0lxiYC
         v7BeBCaHrpBqt1x1w1pKJw0R93X5kwPDcNhcQBsBlH0nPzV5dPPurplKYI6ShgfBL7T1
         KgdA==
X-Forwarded-Encrypted: i=1; AJvYcCX9UqpAfVsmCmMq43F7UKqRIUYzHn4U9CfCNb8kxfLJ0Rweu7pCt/fs7mp4HJHTp1atnceuTYiLCcHcLftJMSToJOSn
X-Gm-Message-State: AOJu0Yz7xrI6Y75VcP9NG5SDtdwqIPg7ScYyzX0T+o6PEjF0qqcJ4XYi
	KubGV++Hp+FO8EFondT1odnq1+eFjUpeI9X8KbsWWEMm70GpRAtDos/sYlhXMlU=
X-Google-Smtp-Source: AGHT+IF7MARc7H4ZqzG7wJkQ89qaWtgYzIyVWgX/basw0DoDqcekmy5aXwgVIVD/A5uDZbyMRmIPWA==
X-Received: by 2002:adf:f88f:0:b0:341:d2f9:494c with SMTP id u15-20020adff88f000000b00341d2f9494cmr3575737wrp.55.1711874782419;
        Sun, 31 Mar 2024 01:46:22 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.223.16])
        by smtp.gmail.com with ESMTPSA id k17-20020adff5d1000000b00341b7388dafsm8436003wrp.77.2024.03.31.01.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 01:46:21 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Sun, 31 Mar 2024 10:44:12 +0200
Subject: [PATCH v2 25/25] sound: virtio: drop owner assignment
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240331-module-owner-virtio-v2-25-98f04bfaf46a@linaro.org>
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
 bh=ZZgxTq79++b7HHq30K3VBjFNBWdk1QKSfVGAvnwx7/U=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmCSJm5t8lRjxPTys8b+WU0OKgg1LgcvzKJ4xNt
 n3OV06BuwyJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgkiZgAKCRDBN2bmhouD
 13W/D/oDYwucjXt0Tt8Y0Uy9LmGcrAbjofc6FyMbOg5ZcMm5e3+WVCaJvH1GzuMW7eKutG1NKq4
 SG+22VBevobbwXkTrzQkvyrydccLRDbeWLWm+HJad5tojpoFvW83SYI4iPlD0b266lNVIdzpKjz
 hcUgfDLubJvg2WN81urFjglAG74SusSyGpct+7+xypg9xUvAMj+j+vblD6MiYvdlR7YTT07NpVb
 CnsXjptZ5D0mdqdAp/yyZAVgxH8IatToMVp+zeRzRlVPHc8mepyeo/z9irAjfvJMoh/GGv0t6Gr
 6lHVgN1q09NOsaKCBvZgBc1M3JNDSEvRjO4LMT7dAINa97EQdIp9+8ZpNqqX0RQXYDulXZIS5+F
 Fi4LuIifmxFvnLlK3XGafTiE+izB6Av3JwLIwcg0Q9VTwxzmWeoDKL9c1o0P/bZ5TzBsp8cO5Az
 EQrw4GwFCAMD7jfVzip/IzS25Sgb5lVDNqj2sWyi5R9/l0bzGoRd8h0nMUo0h60LV8+UQNG4Qn2
 Z5ijAWCJJVA4mNoA3tp1IfoltFnoxAy+WhGYLKaLo80DfbVnlQAHuwY8P4oIqsfEalA2ZTmhTBx
 qz3zO+FBApnCfqIytRnVYYYjPxsP+kbjFVJOBhR1fGzSU1/is2cPkZduK341zXENT6nHwkNDVK4
 VB34pc8fk3aFIrA==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Depends on the first patch.
---
 sound/virtio/virtio_card.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/virtio/virtio_card.c b/sound/virtio/virtio_card.c
index 2da20c625247..7805daea0102 100644
--- a/sound/virtio/virtio_card.c
+++ b/sound/virtio/virtio_card.c
@@ -438,7 +438,6 @@ static unsigned int features[] = {
 
 static struct virtio_driver virtsnd_driver = {
 	.driver.name = KBUILD_MODNAME,
-	.driver.owner = THIS_MODULE,
 	.id_table = id_table,
 	.feature_table = features,
 	.feature_table_size = ARRAY_SIZE(features),

-- 
2.34.1


