Return-Path: <kvm+bounces-71986-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KGVNG3lVoGlLiQQAu9opvQ
	(envelope-from <kvm+bounces-71986-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:15:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AA59E1A74F7
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:15:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8EFB630A296B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E0B3ACA73;
	Thu, 26 Feb 2026 14:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cQnFR/DI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292B03B961A
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 14:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114437; cv=none; b=kMY1wx85nwaz3NOnRLnhdSdDDsoh2O24uSxu//9iQqMlYTKwdlIJqMHx97Ys1QKIVB5CnCiKRZKwXbUyPPqoicCOKCcWTK5uHCXWoVYwlW7TMmERi9OzeP2DWAU7vB472kPs+8vQLcnPaEIpD3JRjGLN5Z42vfJBvGq4COKRniE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114437; c=relaxed/simple;
	bh=23UguC9uQACKKw1RXPExJ7UwqTtjzsomgkhrL/tp8qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VglG6oSr4HlgtXv4d60X6p7fLYF1HXNjASg1Xsvi+Qcxl/UZgnFlNKJdIWjbW1ZDEIQ5Tx6UB5gNLcjH7188YtXfszJ9Pg5jV7+sl2DUl9SPeXkEjk7znAgHSPQH8fPB+ZSDVXYGIyvWp/KJc9o9Xyn8AvoraCHgZooDnIpwXiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cQnFR/DI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772114425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YojGkR9U2ESl4vEoymd56OJc8xyM37B0p+ADPxQm3Fc=;
	b=cQnFR/DIHg0OTwe41qTveGqLKm7Ng3ASGxU/c0iSysFgtbllmD5uZv2SrTIbUCTxx546uA
	B9nsOWqFL9iBOd+Q1QwluQtysV3g0z9xeiuDct8CoQMzO19MqTwHo/FbGiTzPKfF9sGCPu
	jA8c/BDZQz+QKbdqv50pteOjaoGbK/o=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-474-lYyvKkLCNT2Tlv-G0Vmr1w-1; Thu,
 26 Feb 2026 09:00:22 -0500
X-MC-Unique: lYyvKkLCNT2Tlv-G0Vmr1w-1
X-Mimecast-MFC-AGG-ID: lYyvKkLCNT2Tlv-G0Vmr1w_1772114421
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F361C18004BB;
	Thu, 26 Feb 2026 14:00:20 +0000 (UTC)
Received: from localhost (unknown [10.45.242.29])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5C63130001B9;
	Thu, 26 Feb 2026 14:00:20 +0000 (UTC)
From: marcandre.lureau@redhat.com
To: qemu-devel@nongnu.org
Cc: Ben Chaney <bchaney@akamai.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Fabiano Rosas <farosas@suse.de>,
	David Hildenbrand <david@kernel.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	kvm@vger.kernel.org,
	Mark Kanda <mark.kanda@oracle.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH v3 05/15] kvm: replace RamDicardManager by the RamBlockAttribute
Date: Thu, 26 Feb 2026 14:59:50 +0100
Message-ID: <20260226140001.3622334-6-marcandre.lureau@redhat.com>
In-Reply-To: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
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
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71986-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_NEQ_ENVFROM(0.00)[marcandre.lureau@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AA59E1A74F7
X-Rspamd-Action: no action

From: Marc-André Lureau <marcandre.lureau@redhat.com>

No need to cast through the RamDiscardManager interface, use the
RamBlock already retrieved. Makes it more direct and readable, and allow
further refactoring to make RamDiscardManager an aggregator object in
the following patches.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Reviewed-by: Cédric Le Goater <clg@redhat.com>
---
 accel/kvm/kvm-all.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 0d8b0c43470..20131e563da 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3124,7 +3124,7 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
     addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
     rb = qemu_ram_block_from_host(addr, false, &offset);
 
-    ret = ram_block_attributes_state_change(RAM_BLOCK_ATTRIBUTES(mr->rdm),
+    ret = ram_block_attributes_state_change(rb->attributes,
                                             offset, size, to_private);
     if (ret) {
         error_report("Failed to notify the listener the state change of "
-- 
2.53.0


