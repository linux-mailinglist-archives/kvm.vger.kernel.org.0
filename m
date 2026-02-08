Return-Path: <kvm+bounces-70553-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mFg8Cj+fiGlAsgQAu9opvQ
	(envelope-from <kvm+bounces-70553-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 15:35:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AD314108EBE
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 15:35:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A2585301C6DE
	for <lists+kvm@lfdr.de>; Sun,  8 Feb 2026 14:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5512359FA1;
	Sun,  8 Feb 2026 14:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ilYP/Qdb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5B12BF3D7
	for <kvm@vger.kernel.org>; Sun,  8 Feb 2026 14:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770561302; cv=none; b=qHwMUiGp4R151FT8q68BewCLRcTluOfwXAuZZEIILWFJI+JdHXXX+Tj1VZ1vdB62Ig+1SxZc/DgzXLD/viaM7SFLFDzEylHMLai5iQtTunnsomTuf7BPlaWLkcXLH7KH8EWNNuux9bz1uqvTlibwmrdlE32/Pz3SUBiOYHreuL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770561302; c=relaxed/simple;
	bh=kCFklQNimDbQxqRtKmEGp8OsrVvQkvdJ4FZi/fH6BTM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=sDZiYQZ5w4RrU3SYG7GFiHWZYIAaBNTFyYgIxRAFAQcmBBtupz9ELLuTX1Tb80sXesX9/TxlO3Ni9rnyrO1sIgFGlqT7sBQ6KQvlaskiTDrfiXSbZa4PsIwDovySl8Wpwi9199IRgVXcIbYyTmxQnIBuWoo61EF0IwLbfdyqoxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ilYP/Qdb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770561301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pspMQtjTZwBdLYk3DLvxWkcNg8Z4rVD+1Sbx2a24tGE=;
	b=ilYP/Qdb7fTEDwW0G0AcXhLQA4DGgcM3WEgBX45EqfhbXaSwNm6MCSH64Tk2dpe12YtRDw
	QF/EwTDtp8f0B7BeAAK7lwlkoHtZ+q0uJKLbRP38C2WD/nHnyyUJbRWm29QetTpz0f+Psj
	awoVqaKfWyKqJsnSDoLFQ6TQf4zRMVs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-549-kjLThcnnP4CWE2wVqlkZkQ-1; Sun,
 08 Feb 2026 09:34:58 -0500
X-MC-Unique: kjLThcnnP4CWE2wVqlkZkQ-1
X-Mimecast-MFC-AGG-ID: kjLThcnnP4CWE2wVqlkZkQ_1770561297
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A1C6195608F;
	Sun,  8 Feb 2026 14:34:57 +0000 (UTC)
Received: from S2.redhat.com (unknown [10.72.112.33])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8BC7718004AD;
	Sun,  8 Feb 2026 14:34:53 +0000 (UTC)
From: Cindy Lu <lulu@redhat.com>
To: lulu@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC 0/3]  vhost-net: netfilter support for RX path
Date: Sun,  8 Feb 2026 22:32:21 +0800
Message-ID: <20260208143441.2177372-1-lulu@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lulu@redhat.com,kvm@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-70553-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-0.997];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AD314108EBE
X-Rspamd-Action: no action

This series adds a minimal vhost-net filter support for RX.
It introduces a UAPI for VHOST_NET_SET_FILTER and a simple
SOCK_SEQPACKET message header. The kernel side keeps a filter
socket reference and routes RX packets to userspace when
it was enabled.

Tested
- vhost=on  and vhost=off

Cindy Lu (3):
  uapi: vhost: add vhost-net netfilter offload API
  vhost/net: add netfilter socket support
  vhost/net: add RX netfilter offload path

 drivers/vhost/net.c        | 338 +++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vhost.h |  20 +++
 2 files changed, 358 insertions(+)

-- 
2.52.0


