Return-Path: <kvm+bounces-72348-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IIU1B8lPpWnS8QUAu9opvQ
	(envelope-from <kvm+bounces-72348-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 09:52:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B00441D4F46
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 09:52:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2DB4F301946B
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 08:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D4C738CFF2;
	Mon,  2 Mar 2026 08:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KY5AMMQr";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ORYhLeps"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF3C38BF60
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 08:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772441517; cv=none; b=mLUXGkSL7dRLiBK5RSihk077+PNDQQalt9aVvcyymIvgu06GvHnZCTdSrftirXM2p9qgK7dHoX1EwuIYVi8iM4N8JEVXKNdCIFvZoNktgi00um9/DFSjwG+81NpVte5cqPrCVaNhHQZieQAYY+1LSzfeZLmxst/nHxrh7uzHo8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772441517; c=relaxed/simple;
	bh=ejoxH+LGsx0lf40D7kcEz2BR8ZKftH4l7JfUa0+NqoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HvxsmcZ1r1nfces47KqEwWOAZOamQ9nKpZ8ApRxCfqLiyEbOjtW4DG66wued64Gf61v5nurdwtR8kwsGYIp20Or7ZHnp2e+SHvc02E6hPJ5TMgLMfMY3vUyNYGj/ctf8EkXPMg2AFPXqlvmD+NtYNTgzh5+26FJqCuXO0fe60HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KY5AMMQr; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ORYhLeps; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772441515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=Z9WT3KJPKaJS7kZ732QoTptenX1xk5GVKXR5OHJOtrk=;
	b=KY5AMMQr/1UMD23OF39s4doog0XG0e/lBySPMg3YZhxCteP3ANnzqSJvgKg0aqrlxsnomA
	8N6Il9wkJMAR6w30gGGOPhBaPrpO8QAbwrwIPTjycv3pho3M1v/7XUEZMDYZOKg3wBqbfM
	aNIGwLJ9m639dCIQi0LegE1Azleutv4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-YxsHIh_mOKOMQM1lRGuFRg-1; Mon, 02 Mar 2026 03:51:53 -0500
X-MC-Unique: YxsHIh_mOKOMQM1lRGuFRg-1
X-Mimecast-MFC-AGG-ID: YxsHIh_mOKOMQM1lRGuFRg_1772441512
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4837b9913c9so29955375e9.0
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 00:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772441512; x=1773046312; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z9WT3KJPKaJS7kZ732QoTptenX1xk5GVKXR5OHJOtrk=;
        b=ORYhLepsLZhmUY8NiCMWZzli7YpKTEQFZ+FYkAqOscemomwxu0+96eJBFtJ33Lx6Pn
         FCpj+u210l1JleaxCFb9u81b97+oy0nxuzjtOVPiSaqqVfXMWwx8ITWyWcx1Aj0P3Vzb
         wiWw2DD7TM2RCKA6oK1+ZYN3eMnaDSktzGuSlD1lSrJTmN5yPK+gf2KLu5HQ54NG6pxK
         8NNq/W6fA/13MBGOgRoybFqof3Rjx8g5GywwDnm96nvNWGmwVp1Q0XKdxEyShorz/rbx
         /ZAsqwAPlG1YqVWT6XeDttkH/6J54cTrsGAugvYuQUxmW03oCMv5NK6Xxll4jGM61DM8
         8nUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772441512; x=1773046312;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z9WT3KJPKaJS7kZ732QoTptenX1xk5GVKXR5OHJOtrk=;
        b=w4QbGqXhO3LICpEXIed1uZHaKoKtzEryeHq8dgsuym4FOxkz4sVK0g0aRrbeF0XK2h
         R5rUDuS8Z5Y6/RqrljU/lFZez0Nd9b3gBqKbxCs/cl0XBNOqMnyQQEFFteOEXeWPVxhp
         MUKpO7uNPaVE8ivHtG9znE0fYGcTGUM5X6dagLvf4dOy2o3veg3GDDEWMiuM9aXfKUos
         f32yOHIOhcUPNyFkt8DQ1sX7W9Q49lj9iA0xXoNnEhyb/aQELDEMvtDOouRifJWXWhS4
         fnyV9KTVmHJ9Es6n2YjkDvoHrYhK244OCvU6mJ2WhHDhw2lCxbmhW8RvUGNZqgGIb+46
         sP3A==
X-Forwarded-Encrypted: i=1; AJvYcCXjfToK88KYweMG+FS6M2PT82OVQKNDLC6vMweCGREWvjsvunQ/PeSODttddpC2JFnLI90=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz+XmQb2U4oA9kTTLMNjksXQklQU3lPzaIIrJdkejoBLsV/f2Z
	xzIOpUN6GpNJRY8cyCY1wKoeITzW3t0C4Tb7X+Gr7oROQeFqyjW+50y3jg+bf+sDqxBhGLULmsa
	lk0VjhM8R0iFBp3rXaYPoaMY9874gp03EePmFvZ9JFlw3R6EmuoV4Jw==
X-Gm-Gg: ATEYQzzxlC/w4ymzLNez2996HcSlcIveLpFJCuygfY58VzGlXkY4OFHT+cmOEolmdLf
	fedebkeGqCZ9rUPdKKf0JUa+RfRv1Gq/73LUYvYqfqI9pUg5QI7ip69ua3t3vg5MW90NIJECBhs
	8WyByhjL7+54+qW8tzO3W9CWSPWOnrCDsHR40lWYMzcYJpQb3RGtiboN9UkkSC5SkcfOroyknjq
	xa/nZKUgZfgLQ4PrbHz38V2Hd341E4n0k/0pWNbybkdFaqooTzkr/w43nOSZ0H/m4xO5cgqxZLO
	vnL8/B7r0KqfVKXrUWaFJyZYLXzavQTXqMLIpZqnTySXmtQuNPPmTfW/S2ZkDAEwyNozXDFPhVs
	nYjafvyLFkMHYVxjpKtC5NOB05WFtdwyUI48kAgorwpwVWg==
X-Received: by 2002:a05:600c:4fc8:b0:483:6f37:1b51 with SMTP id 5b1f17b1804b1-483c9bedb07mr228267945e9.23.1772441512163;
        Mon, 02 Mar 2026 00:51:52 -0800 (PST)
X-Received: by 2002:a05:600c:4fc8:b0:483:6f37:1b51 with SMTP id 5b1f17b1804b1-483c9bedb07mr228267415e9.23.1772441511572;
        Mon, 02 Mar 2026 00:51:51 -0800 (PST)
Received: from redhat.com (IGLD-80-230-79-166.inter.net.il. [80.230.79.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfcbd781sm233836855e9.8.2026.03.02.00.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 00:51:51 -0800 (PST)
Date: Mon, 2 Mar 2026 03:51:49 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ShuangYu <shuangyu@yunyoo.cc>, Stefano Garzarella <sgarzare@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH RFC] vhost: fix vhost_get_avail_idx for a non empty ring
Message-ID: <559b04ae6ce52973c535dc47e461638b7f4c3d63.1772441455.git.mst@redhat.com>
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
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72348-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mst@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B00441D4F46
X-Rspamd-Action: no action

vhost_get_avail_idx is supposed to report whether it has updated
vq->avail_idx. Instead, it returns whether all entries have been
consumed, which is usually the same. But not always - in
drivers/vhost/net.c and when mergeable buffers have been enabled, the
driver checks whether the combined entries are big enough to store an
incoming packet. If not, the driver re-enables notifications with
available entries still in the ring. The incorrect return value from
vhost_get_avail_idx propagates through vhost_enable_notify and causes
the host to livelock if the guest is not making progress, as vhost will
immediately disable notifications and retry using the available entries.

The obvious fix is to make vhost_get_avail_idx do what the comment
says it does and report whether new entries have been added.

Reported-by: ShuangYu <shuangyu@yunyoo.cc>
Fixes: d3bb267bbdcb ("vhost: cache avail index in vhost_enable_notify()")
Cc: Stefano Garzarella <sgarzare@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Lightly tested, posting early to simplify testing for the reporter.

 drivers/vhost/vhost.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 2f2c45d20883..db329a6f6145 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1522,6 +1522,7 @@ static void vhost_dev_unlock_vqs(struct vhost_dev *d)
 static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq)
 {
 	__virtio16 idx;
+	u16 avail_idx;
 	int r;
 
 	r = vhost_get_avail(vq, idx, &vq->avail->idx);
@@ -1532,17 +1533,19 @@ static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq)
 	}
 
 	/* Check it isn't doing very strange thing with available indexes */
-	vq->avail_idx = vhost16_to_cpu(vq, idx);
-	if (unlikely((u16)(vq->avail_idx - vq->last_avail_idx) > vq->num)) {
+	avail_idx = vhost16_to_cpu(vq, idx);
+	if (unlikely((u16)(avail_idx - vq->last_avail_idx) > vq->num)) {
 		vq_err(vq, "Invalid available index change from %u to %u",
-		       vq->last_avail_idx, vq->avail_idx);
+		       vq->last_avail_idx, avail_idx);
 		return -EINVAL;
 	}
 
 	/* We're done if there is nothing new */
-	if (vq->avail_idx == vq->last_avail_idx)
+	if (avail_idx == vq->avail_idx)
 		return 0;
 
+	vq->avail_idx = avail_idx;
+
 	/*
 	 * We updated vq->avail_idx so we need a memory barrier between
 	 * the index read above and the caller reading avail ring entries.
-- 
MST


