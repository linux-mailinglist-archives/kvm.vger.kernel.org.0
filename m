Return-Path: <kvm+bounces-70170-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6ODpFWcag2n+hgMAu9opvQ
	(envelope-from <kvm+bounces-70170-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 11:07:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CBD6DE43EA
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 11:07:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 87BBC301F7AB
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 10:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A26B3D6466;
	Wed,  4 Feb 2026 10:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h9xAUpac"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D41B226863
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 10:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770199651; cv=none; b=tUBI5cHIb4JoYRhv7Aegk2IfQM1R4wO1HxMQ6BzGztbXV9IJWPRCZuabhQD0NL29sobmdjkbCjsCfnyzUYlaJiJCRX7HsTu2xieT73Pc017nadqpCMQNagkH0ztqZ5NzUOMNzNIOU1LDdBZqJ2dx4muWek1KtZFCKkjAJnan70o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770199651; c=relaxed/simple;
	bh=T22sMMA8YEuTElWh6JP7A5ehu6/pCcbHBL5dUgZ7rW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OlUsX3OFWZ4ePrh4hDvVci/tgvX0kDa5g2hr5IYf81dSsPDu5BtfkF5rm56ccgRQEgCrYAzZqs3ppzg1X4ha6IH8WWEtpayCaEp7oUEbMkp/oh+zDilgMJh6QveWGZYy+0SQoAWcqjFncI03eazkcuwRAQvYef8unh0BViyRPuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h9xAUpac; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770199650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tkLNAKQI54XNalRuCNfScWmToO2pgvJK9kp1aOTV5Zo=;
	b=h9xAUpacPb25g9xNhQn7iXDfjpMRRWQRdP+/4wTMaeWhB644l0St10E5KN3n+rqvufrdh4
	pPwU6QxCnhUmHpGPzIAQg8en8zbNuJCjnVakf4Ojl9ehCuiwKrcOq1+EjNvLDixij3LlQk
	zdahXDJ0N+tAkV6NYZUxpfCl0A1l2tc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-401-2D5PbSVdPwmTpoxyCTs2hw-1; Wed,
 04 Feb 2026 05:07:21 -0500
X-MC-Unique: 2D5PbSVdPwmTpoxyCTs2hw-1
X-Mimecast-MFC-AGG-ID: 2D5PbSVdPwmTpoxyCTs2hw_1770199640
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 05CAF1956058;
	Wed,  4 Feb 2026 10:07:20 +0000 (UTC)
Received: from localhost (unknown [10.45.242.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 369E819560A3;
	Wed,  4 Feb 2026 10:07:17 +0000 (UTC)
From: marcandre.lureau@redhat.com
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Alex Williamson <alex@shazbot.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ben Chaney <bchaney@akamai.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Fabiano Rosas <farosas@suse.de>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Mark Kanda <mark.kanda@oracle.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH 01/10] system/rba: use DIV_ROUND_UP
Date: Wed,  4 Feb 2026 14:06:57 +0400
Message-ID: <20260204100708.724800-2-marcandre.lureau@redhat.com>
In-Reply-To: <20260204100708.724800-1-marcandre.lureau@redhat.com>
References: <20260204100708.724800-1-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70170-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.998];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: CBD6DE43EA
X-Rspamd-Action: no action

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Mostly for readability.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
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
2.52.0


