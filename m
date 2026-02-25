Return-Path: <kvm+bounces-71821-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4NSbJ9XlnmkCXwQAu9opvQ
	(envelope-from <kvm+bounces-71821-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 13:06:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA07196FC9
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 13:06:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4DC4F3050A1D
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 12:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89AC83AE6EE;
	Wed, 25 Feb 2026 12:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GBkv8X/P"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED8F3ACF17
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 12:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772021108; cv=none; b=WlcfgMgBzQgoRA+Zpq3LaDvyI07U7C58NpeSymFzGPSfEJsrRjBB5bwVCoNVmvE5oJT9I6dqc/x/3MD3hHEC3yxOWkaKw3WYZgnwYkqCWENsWRhU63IvCcHPOxZKe7ZsbUqDO3L3Ujv3wnKNWg6suDoicfJRiZo7b4pOLQMCouw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772021108; c=relaxed/simple;
	bh=qGMy+9B/VDohah3Jf8ZMby2bn9uFEjN7eTWiDdVP4iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VFOZfKxYBkdnuOhhd2aAgb25JBld9g67TgP7bFqwtOyCpuxlwErjUsLAcJtPQ3jrP1yewIBN9mAhm32mNSatWNtu1W4imD1oEXErhFB5AiYu/hytU0J6OtkJ26WnPvPK203vyPr9llc9Je2Ji16vBm5HuAKEfFlNOK5GH7Pn+zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GBkv8X/P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772021106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0fag7QDI9+TsFrYsYMuq+MvAPEZW2et9VpqeBxsP3bI=;
	b=GBkv8X/PtD7t9nAtNnbfCvUMgqs+6xaGcTQWtb5jP7B1lG9alLacJCBPdXeW2OSlo6vw2A
	Y7luBsXZYboWzATlf2IDyG2fnG76oteoeZvD2Nbpl2E3a1s50LaoSd8zfq3dcT2BI7BDSk
	adxtkgimIKaMVkf19+S5+PV26vV1gm0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-1-I4a_fzPY2Hq78CA45u5Q-1; Wed,
 25 Feb 2026 07:05:03 -0500
X-MC-Unique: 1-I4a_fzPY2Hq78CA45u5Q-1
X-Mimecast-MFC-AGG-ID: 1-I4a_fzPY2Hq78CA45u5Q_1772021102
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B2BC41956052;
	Wed, 25 Feb 2026 12:05:01 +0000 (UTC)
Received: from localhost (unknown [10.48.1.67])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7EAE43003D88;
	Wed, 25 Feb 2026 12:05:00 +0000 (UTC)
From: marcandre.lureau@redhat.com
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Mark Kanda <mark.kanda@oracle.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Ben Chaney <bchaney@akamai.com>,
	Fabiano Rosas <farosas@suse.de>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH v2 01/14] system/rba: use DIV_ROUND_UP
Date: Wed, 25 Feb 2026 13:04:42 +0100
Message-ID: <20260225120456.3170057-2-marcandre.lureau@redhat.com>
In-Reply-To: <20260225120456.3170057-1-marcandre.lureau@redhat.com>
References: <20260225120456.3170057-1-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71821-lists,kvm=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[marcandre.lureau@redhat.com,kvm@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: EFA07196FC9
X-Rspamd-Action: no action

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Mostly for readability.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Reviewed-by: Cédric Le Goater <clg@redhat.com>
---
 system/ram-block-attributes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/system/ram-block-attributes.c b/system/ram-block-attributes.c
index fb7c5c27467..9f72a6b3545 100644
--- a/system/ram-block-attributes.c
+++ b/system/ram-block-attributes.c
@@ -401,8 +401,7 @@ RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block)
         object_unref(OBJECT(attr));
         return NULL;
     }
-    attr->bitmap_size =
-        ROUND_UP(int128_get64(mr->size), block_size) / block_size;
+    attr->bitmap_size = DIV_ROUND_UP(int128_get64(mr->size), block_size);
     attr->bitmap = bitmap_new(attr->bitmap_size);
 
     return attr;
-- 
2.53.0


