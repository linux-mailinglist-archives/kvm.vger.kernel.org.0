Return-Path: <kvm+bounces-69086-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cFcvJxo5d2mMdQEAu9opvQ
	(envelope-from <kvm+bounces-69086-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:51:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 19CFD86368
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:51:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A415F3034E02
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 09:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF5B632D43C;
	Mon, 26 Jan 2026 09:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PGaPFijY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2E132BF51
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 09:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769420944; cv=none; b=Nz5+AAGXlCeOjwchDSjmQ1fRu8e7Ea1F0ffGrTWveJIkCZ9u4D/ik5svcJoEGeoOqMQKJpQH0D0lO6bZRcJHvo/Z9Gm0XEhc7/uWPR1LjEwAdWk9Szm0Po6BIs5AGZMn2dE7RfIVv+Cax3PLHNIBcqynJ/6cIegwe8JpcIEjYCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769420944; c=relaxed/simple;
	bh=r+oip4R667LHFktLfsnoRd3W3lTXOBV3+88WDRL4GUA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=PI20Rj3UP4c5MKoeMfQY/TMcOFQ+QnB9LsV1rUHO/FiMSRwVOf+p8TSbiXxcjrfem8iO2jMVIiVHdoumDG8xN6m7uCalXnXHv1moQFXr0Izz7lL1vpJ7Npfj/Vk6qv3x/GiDoEb0BcZbbFQiDdfAxM1VtNWyJ7u4Q8CY+ZRfo0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PGaPFijY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769420941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Z5yOTegihamA+5DHF4ho0ETS7pvQFQEOBeeVEwzyjsk=;
	b=PGaPFijYM9Finl6Vw+LqsftiI6RlMEOCFKf2rCSDLPSVQipXV2rSqyI48q5sbRNdUzWoGo
	9oWjNWdZGUTh5TyOnJxudDDpyp5i2kPPaUBbdvwE7CwnQKaeYNFbDo/lnjJDmfuftJl67t
	dDn6HGp5GioCNgMAeROqOARAtjSYaD8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-HZwwQUGLO92c1Ytd60hUjg-1; Mon,
 26 Jan 2026 04:48:58 -0500
X-MC-Unique: HZwwQUGLO92c1Ytd60hUjg-1
X-Mimecast-MFC-AGG-ID: HZwwQUGLO92c1Ytd60hUjg_1769420937
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2DE511956096;
	Mon, 26 Jan 2026 09:48:57 +0000 (UTC)
Received: from S2.redhat.com (unknown [10.72.112.82])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 11B1518001D5;
	Mon, 26 Jan 2026 09:48:52 +0000 (UTC)
From: Cindy Lu <lulu@redhat.com>
To: lulu@redhat.com,
	dtatulea@nvidia.com,
	mst@redhat.com,
	jasowang@redhat.com,
	netdev@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v4 0/3] vdpa/mlx5: Fix MAC address update via vdpa-tool
Date: Mon, 26 Jan 2026 17:45:35 +0800
Message-ID: <20260126094848.9601-1-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lulu@redhat.com,kvm@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-69086-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 19CFD86368
X-Rspamd-Action: no action

This series hardens the mlx5 vDPA MAC plumbing by ensuring new addresses replace old
entries cleanly, reusing shared update logic to keep flow tables consistent, and only
advertising the MAC feature when the device is not yet DRIVER_OK

Changes in v2
 Factor out the MAC address update logic and reuse it from handle_ctrl_mac().
 Address review comments.
Changes in v3
 rename mlx5_vdpa_change_new_mac to mlx5_vdpa_change_mac
 Address review comments.
Changes in v4
 Replace memcpy with ether_addr_copy in mlx5_vdpa_change_mac 


Cindy Lu (3):
  vdpa/mlx5: update mlx_features with driver state check
  vdpa/mlx5: reuse common function for MAC address updates
  vdpa/mlx5: update MAC address handling in mlx5_vdpa_set_attr()

 drivers/vdpa/mlx5/net/mlx5_vnet.c | 149 +++++++++++++++++-------------
 1 file changed, 83 insertions(+), 66 deletions(-)

-- 
2.51.0


