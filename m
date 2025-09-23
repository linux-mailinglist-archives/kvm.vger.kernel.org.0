Return-Path: <kvm+bounces-58599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65559B979D1
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 23:48:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CAE92A15FB
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 21:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344A930F55E;
	Tue, 23 Sep 2025 21:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bdard7qT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C413230C62B
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 21:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758664083; cv=none; b=UU4vf7ozMltIDrmfk9TaQwsAkVlglxH5eu9vnuMXrTF/uaY0AsYjM+jDa1xwr0P/YE2m2DSLY3+jVZ/ubdX5yVl/lL+DjDZNUGRcfAUjd2wlnNz4CwL++GdX35lSJa/7Z2N37cVyMYgWpK8xxnnlS5qGie83PCKPUpS239hWPuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758664083; c=relaxed/simple;
	bh=ueTXvYOaTGFnlsHbGUKhUluBx5Uj1EtJeF74+R0Vgys=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=P5OFWUAG2b7emnPbhb64pOIygqV0sLS6MXI2F/0NrC6qhtMG893pWUb3mMF0a6HFUOXcfQCQeM/i/H/GMuvsNhG7Lvlp/r84df6V2Q0kSOKywr+LPko6qKOB7ctk2T3F/fnWGS4R2W2fUxFDonUMkM3QtYqQC1RqFw0+5IjATJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bdard7qT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758664080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=gE1p9jvRg0lKTpk9XpwlgaFgqtSuJtcDtsDSqLMg4mo=;
	b=bdard7qTKU5DeUvjM4JyvGu/IPeBN9jrpgo468jZAzGRMpWFwtJnpYkvdQMx+zIKsImMZo
	8xuF0luWdh5exTskASxgvmI+De+MVkg3kUWTphbq7D+bqnuPxwp+r/gaFMwph+c92CLOSD
	R0fqorNBe66gElddR1DX/lr98UmFD7g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-r_R3rtPTPxKFb8K18KthhQ-1; Tue, 23 Sep 2025 17:47:57 -0400
X-MC-Unique: r_R3rtPTPxKFb8K18KthhQ-1
X-Mimecast-MFC-AGG-ID: r_R3rtPTPxKFb8K18KthhQ_1758664076
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ee888281c3so3071235f8f.3
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 14:47:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758664076; x=1759268876;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gE1p9jvRg0lKTpk9XpwlgaFgqtSuJtcDtsDSqLMg4mo=;
        b=Kd7X0hE8APJ0c3x9dA7wX9J5Wi9XPxHVIikWObZSE8XGyq0bkaLDdjRc86bLZ7sP6c
         sbi0tyNFM0RFHuueRGf8EUOlFSwuxmnu3yA/OlGNYhNd5rZXzV7y4OnRLFjO7cX94EaR
         nFhKZwaFzLS0l5zn+79uEdNqEa1nlKc22cvErVw/Rv4HNW7NMWakO47st021mxhwuVmD
         U58ooBhX4hnFu5aARuFW5XhunkR7JKkdbzm+VW+hJcoaPLLnSd1xpDqU6tqC5hYYOlSQ
         Wr9DKV8W1nj3tzjihSu64mLw4oBHAA30vjYW8zvawHRS74/oXndkE+7WuuxbRW7h8KVa
         jNQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqih9X3ED4gXTx8iKbMnlplbVgvMUwL0266XBujWHN+91887or3XWXBQP1RT29X4IdA5s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yypj4y5p3kZ+817o3b9SwNuCJRnogDRZKjdQ7im22K3/AmFPEtt
	Y4FLHudDlRWJvaG/uQuoANbiXRs7Dm5wbFaI/gOkh0UaZhENnFE2s3NYqan0vmg+9LLivbvNaIU
	bRi7yRQOTO5xxhpdiFcRzGRydO+4gSa03vFAsxAqNeFeF9UtdpTDZQw==
X-Gm-Gg: ASbGncuiE+xFujTrHeprIZwu7OKENTbsADj2CeVcib5ra1SpuG4ZHfIEjx4XpeGZ+ab
	XJfx7Mu7AkMfRwnNsnyya/L4jnzBXlSBpA70z9CBcXKGwfSKWS9P8aJO/79YUiTESvRDZupxCVK
	ycjTp5j3oXvhVUQoE+y+E6kDnjcO/ANqDW1H/HnVUT55W5dSjaUDkjVSkzaiFirMfGoEQht9BD6
	8D82QzMUS1LApEdhNMpT1GX3eXvvXB8wj+cCd28DjXlTHzRrY6qoVMGrHj0OsnTktunifPJfbt7
	MJ9IFYD4fkSJlj8bcWqkHLYstIItTqC/BkM=
X-Received: by 2002:a05:6000:1885:b0:3cd:ef83:a9a1 with SMTP id ffacd0b85a97d-405c6751cabmr3721720f8f.20.1758664075765;
        Tue, 23 Sep 2025 14:47:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETV4Q7KUf/fsmOmIwTE27eO2P2KhRHj2pOb3/FmZCSUNeq3z+t0xn78V0pxCEhXhxYrElaFg==
X-Received: by 2002:a05:6000:1885:b0:3cd:ef83:a9a1 with SMTP id ffacd0b85a97d-405c6751cabmr3721711f8f.20.1758664075279;
        Tue, 23 Sep 2025 14:47:55 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73ea:f900:52ee:df2b:4811:77e0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3f61703b206sm15270816f8f.6.2025.09.23.14.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 14:47:54 -0700 (PDT)
Date: Tue, 23 Sep 2025 17:47:53 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH] vhost: vringh: Fix copy_to_iter return value check
Message-ID: <cd637504a6e3967954a9e80fc1b75e8c0978087b.1758664002.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

The return value of copy_to_iter can't be negative, check whether the
copied length is equal to the requested length instead of checking for
negative values.

Cc: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Link: https://lore.kernel.org/all/20250910091739.2999-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---


Lightly tested. zhang jiao could you pls also test, either ack or
fold into your patch?

 drivers/vhost/vringh.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 0c8a17cbb22e..925858cc6096 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1162,6 +1162,7 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 		struct iov_iter iter;
 		u64 translated;
 		int ret;
+		size_t size;
 
 		ret = iotlb_translate(vrh, (u64)(uintptr_t)dst,
 				      len - total_translated, &translated,
@@ -1179,9 +1180,9 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 				      translated);
 		}
 
-		ret = copy_to_iter(src, translated, &iter);
-		if (ret < 0)
-			return ret;
+		size = copy_to_iter(src, translated, &iter);
+		if (size != translated)
+			return -EFAULT;
 
 		src += translated;
 		dst += translated;
-- 
MST


