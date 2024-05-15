Return-Path: <kvm+bounces-17438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC7908C6935
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 17:05:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 883A62810E9
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 15:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F8515573E;
	Wed, 15 May 2024 15:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZSmYjFm0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F79A15572C
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 15:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715785552; cv=none; b=jezOAUHfFqhpCrgRCTElWpbRly6rGTUz435JmrEC2y+TFD7+fKV8qpqm3mnaYbUfzieSh6sdzLedgRF2RY5ExjCS8N/NN4XhYd0ndCSmCb5dB6Q8AKRykqtcOkEOBMvkKsQI+oa7fGZ1Qcikk7fhDpxoAqTFeFj1iXgrX1rin6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715785552; c=relaxed/simple;
	bh=Eqhliyv/rLaqDzkaLcjCJEDibkGNoMMtCnsez51KbII=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=M3Rcg8DEPqDk/CBAMRF2cINM9pAjnUUK7IHuFj9IGaKjrmbCqg2RZXI+odETIx4A1yi3bpawUA+GnXnME5OBzKRUK6PYpxGPJTtvuLuFMAW0T3AViNNAZ4nmZZDJ9ITIpVzXauyXaM4EIrFxxwJDSeOxOh1jwYjSzWohK2uo8+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZSmYjFm0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715785549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=5HsQnBBLUP3Pazt+byzwwgyn37KXCpOuxjPpikdkNik=;
	b=ZSmYjFm0MHQMDWa0aiKkvIRrfjy+0cdAKxXhhqZ4bo/nOAsROJf6n8lYKmzR7SF1J6oKoV
	GnvTFX25TFNvbBXbUWlPS832iC6Kbu3JWfJ1rIgz9FzRTubx8rZili01BFKmYdPJ9KnxUX
	aMv8jnKV8RYJvf+0kZs/QLjayC9/o2o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-pEuUgMq1Ori9MljuyVrsxg-1; Wed, 15 May 2024 11:05:48 -0400
X-MC-Unique: pEuUgMq1Ori9MljuyVrsxg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4200efb9ac6so24648425e9.2
        for <kvm@vger.kernel.org>; Wed, 15 May 2024 08:05:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715785547; x=1716390347;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5HsQnBBLUP3Pazt+byzwwgyn37KXCpOuxjPpikdkNik=;
        b=YZ4J4mF3rmOTohSaqeAZ/5HsbEtovDdqB3AjwipJxRjjKvQcNtNyy8HC59K3PH6vwO
         e83mz00Mtbx6mBKCdC0TXzbPVAcTeCFo0WtxZSPlx1v4aME1r0l3OrTPS7dX+UZc12qZ
         zPR9zgOSpicvNljkzxbSd33EgOx6qKJ2a4TP8ZIOVWlpOhJ1NK7XnyruqGZLdpldwqb0
         nhz4A1UJRNu5RzrpheWLuin6wj4prX1LmnrbqyquOFCxNbQg6mY4XabwPSfDAh+5jsTt
         iXcS4M49Bd+yNnxvpNKQMlFOAnaf6vxT4sHV5lUK+8H+kwcd9rWQSGZlsOF47RHav6fC
         PUFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBS7SPkHLdH0IHsUzP718RYfD1VwalfT5tvdRxihKPeGNBnibJTyQcZrJh1CapGVoivEyfbprp26P1JSHcaBQXRIWQ
X-Gm-Message-State: AOJu0YwX/tia8qG5Weg/29SdYNk0zRreyXwVVLxxuO05hIBqGKknM0RW
	GWUG2lwVVcDBWiBEzZfVptvJvWv93qlSjvzksztHnT5kOqWkxacE2xAkIyzURSX5apLpP4gGBmQ
	ReZ9eyocqCtOAPZR1vOLePYCXMqKZ8vRNk9+sza9shxGTuukTlQ==
X-Received: by 2002:a05:600c:a44:b0:41a:34c3:2297 with SMTP id 5b1f17b1804b1-41fea93a34cmr139868015e9.5.1715785547163;
        Wed, 15 May 2024 08:05:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwcKYJU04KRN+C9m9RrjwdUumM+NzjuDj85eoasrKYaMbDWv5ZX8CZUBelGxUEWCXHzSMp8A==
X-Received: by 2002:a05:600c:a44:b0:41a:34c3:2297 with SMTP id 5b1f17b1804b1-41fea93a34cmr139867595e9.5.1715785546575;
        Wed, 15 May 2024 08:05:46 -0700 (PDT)
Received: from redhat.com ([2a02:14f:175:c01e:6df5:7e14:ad03:85bd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-41ff7a840d2sm197154985e9.39.2024.05.15.08.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 May 2024 08:05:45 -0700 (PDT)
Date: Wed, 15 May 2024 11:05:43 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Arseny Krasnov <arseny.krasnov@kaspersky.com>,
	"David S . Miller" <davem@davemloft.net>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH] vhost/vsock: always initialize seqpacket_allow
Message-ID: <bcc17a060d93b198d8a17a9b87b593f41337ee28.1715785488.git.mst@redhat.com>
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

There are two issues around seqpacket_allow:
1. seqpacket_allow is not initialized when socket is
   created. Thus if features are never set, it will be
   read uninitialized.
2. if VIRTIO_VSOCK_F_SEQPACKET is set and then cleared,
   then seqpacket_allow will not be cleared appropriately
   (existing apps I know about don't usually do this but
    it's legal and there's no way to be sure no one relies
    on this).

To fix:
	- initialize seqpacket_allow after allocation
	- set it unconditionally in set_features

Reported-by: syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com
Reported-by: Jeongjun Park <aha310510@gmail.com>
Fixes: ced7b713711f ("vhost/vsock: support SEQPACKET for transport").
Cc: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Tested-by: Arseniy Krasnov <avkrasnov@salutedevices.com>

---


Reposting now it's been tested.

 drivers/vhost/vsock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index ec20ecff85c7..bf664ec9341b 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -667,6 +667,7 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	}
 
 	vsock->guest_cid = 0; /* no CID assigned yet */
+	vsock->seqpacket_allow = false;
 
 	atomic_set(&vsock->queued_replies, 0);
 
@@ -810,8 +811,7 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
 			goto err;
 	}
 
-	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
-		vsock->seqpacket_allow = true;
+	vsock->seqpacket_allow = features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET);
 
 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
 		vq = &vsock->vqs[i];
-- 
MST


