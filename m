Return-Path: <kvm+bounces-70554-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0K9PA1ufiGlAsgQAu9opvQ
	(envelope-from <kvm+bounces-70554-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 15:36:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 69AC9108EDB
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 15:36:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CC2EB300EC91
	for <lists+kvm@lfdr.de>; Sun,  8 Feb 2026 14:35:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B7E035A948;
	Sun,  8 Feb 2026 14:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="avQBR4G+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F9035B122
	for <kvm@vger.kernel.org>; Sun,  8 Feb 2026 14:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770561305; cv=none; b=IndbRbl567JMbmbwJfLw5YdXnFOEuA7j+pX02cMhCca7ZN0FJBwlYvU2cmjS22AsIETPirYBy11Ktlr5/7ifQsNyGd55LY0dzfYs3530Hew0Tc2CalPMfHBsp46ox9L2AKiq4J0bL3ug0Dk+57XSh5gFvewRvANXiWRab27y/CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770561305; c=relaxed/simple;
	bh=jbLiVAKMhESJ8+i8oOV5pM46x7SY1sE0iQGT/xEUVFU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jl+BcYa93kP02Y26cOb/UOoXaAeggYIi0nc9JTTso3/h9kaMIBM2UNduuQX7CYFvDmNaGHsl4lXA3szX/f0Nbxmj6RgVo0CU5UQBzbCUacgzHP83a10JXvVwpnXlrWgrOvtjPQfl8/n8VoOePUmiSfCNfoeqLAjagGHtgH72DPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=avQBR4G+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770561304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CVev9RGq9dVMgOhnEQZeZI8sYWkDO4xwFAo1DRJbKV4=;
	b=avQBR4G+88YTusRZ2ENsoeM3FVkDGragKel9jln6+aeMeehSvabMrhE7P7eH56+OpNlpOn
	2wcrYSf3oW0+RRoiR8S3e8IKZKJ35SG30c/JJKLKfhVkMU33BW0GQdCXwSIBOsjP3z6jAM
	eqJbN0BN54R6H0Eua83xW9o6H11MypQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-41-YIOmSm6KMder5mDp-5P10g-1; Sun,
 08 Feb 2026 09:35:03 -0500
X-MC-Unique: YIOmSm6KMder5mDp-5P10g-1
X-Mimecast-MFC-AGG-ID: YIOmSm6KMder5mDp-5P10g_1770561302
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D34AC1956089;
	Sun,  8 Feb 2026 14:35:01 +0000 (UTC)
Received: from S2.redhat.com (unknown [10.72.112.33])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2CC2C18004BB;
	Sun,  8 Feb 2026 14:34:57 +0000 (UTC)
From: Cindy Lu <lulu@redhat.com>
To: lulu@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC 1/3] uapi: vhost: add vhost-net netfilter offload API
Date: Sun,  8 Feb 2026 22:32:22 +0800
Message-ID: <20260208143441.2177372-2-lulu@redhat.com>
In-Reply-To: <20260208143441.2177372-1-lulu@redhat.com>
References: <20260208143441.2177372-1-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lulu@redhat.com,kvm@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-70554-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-0.997];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 69AC9108EDB
X-Rspamd-Action: no action

Add VHOST_NET_SET_FILTER ioctl and the filter socket protocol used for
vhost-net filter offload.

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 include/uapi/linux/vhost.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index c57674a6aa0d..d9a0ca7a3df0 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -131,6 +131,26 @@
  * device.  This can be used to stop the ring (e.g. for migration). */
 #define VHOST_NET_SET_BACKEND _IOW(VHOST_VIRTIO, 0x30, struct vhost_vring_file)
 
+/* VHOST_NET filter offload (kernel vhost-net dataplane through QEMU netfilter) */
+struct vhost_net_filter {
+	__s32 fd;
+};
+
+enum {
+	VHOST_NET_FILTER_MSG_REQUEST = 1,
+};
+
+#define VHOST_NET_FILTER_DIRECTION_TX 1
+
+struct vhost_net_filter_msg {
+	__u16 type;
+	__u16 direction;
+	__u32 len;
+};
+
+
+#define VHOST_NET_SET_FILTER _IOW(VHOST_VIRTIO, 0x31, struct vhost_net_filter)
+
 /* VHOST_SCSI specific defines */
 
 #define VHOST_SCSI_SET_ENDPOINT _IOW(VHOST_VIRTIO, 0x40, struct vhost_scsi_target)
-- 
2.52.0


