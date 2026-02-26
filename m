Return-Path: <kvm+bounces-71987-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EDCoA+xWoGn4iQQAu9opvQ
	(envelope-from <kvm+bounces-71987-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:21:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E16821A7690
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:21:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A213B319AD4E
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0288A3AEF30;
	Thu, 26 Feb 2026 14:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cR7g3JFw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983B039C653
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 14:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114444; cv=none; b=XFR7xhqmpXsPvA9n2vUAOqj5pS7WFpOtvP1HQ71mVZjX/hTuAnioom/fGZlg5TKyBMyof+CMyyDy2J6/Syhg46/Oc9gzwgneMtEeOxKZPpAfI4aeY6AkEty+q58EtTIoZRSmzciGXr/Vi8Ol/Pj65J4HtvZpOz9fmVQR8SGgJsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114444; c=relaxed/simple;
	bh=DnF8pPKzHcZF1fhFAZMd+VYNrLNYfR/JWvuXZAFrBVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jjdN5+PtLYHDgGQ7R0dfG83dY+y+8kTMIadx/rLxSknTjk2G9fZE0bYRoCGAUBeb+ZiwSeoFF+dKVteZVHW3umhivyLb9S99VagJ8sgMc8UmVsrkwjt60FdmY+YXRVhfgl4nroYuBQIxicX2bC3spM7Zh4T9s5M5qN36iHB00S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cR7g3JFw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772114431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AMzbmJIzsPzTcZ+AWDvyT8GOX03m4rQlRdL0+866S+c=;
	b=cR7g3JFwGy5w29DAQzrUkIpKNTTrhLQp9/9CYrjR6ZCw9ZiFN/Mca0xg+j5nczm7+y1vGG
	lu19jnALSkzkey14wMMD2ECvgLkYK/iXGQzzcNwFukyMQW5VkO9MhY0cZs1+N4/qhwy4yj
	WBLxGt75W5DK4VkA6BDs7YFTaZ5HmB8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-439-k6Hf-BFuMgiOyfOOZCob9A-1; Thu,
 26 Feb 2026 09:00:21 -0500
X-MC-Unique: k6Hf-BFuMgiOyfOOZCob9A-1
X-Mimecast-MFC-AGG-ID: k6Hf-BFuMgiOyfOOZCob9A_1772114418
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 509A61800464;
	Thu, 26 Feb 2026 14:00:18 +0000 (UTC)
Received: from localhost (unknown [10.45.242.29])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 855C419560B8;
	Thu, 26 Feb 2026 14:00:17 +0000 (UTC)
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
Subject: [PATCH v3 04/15] system/memory: minor doc fix
Date: Thu, 26 Feb 2026 14:59:49 +0100
Message-ID: <20260226140001.3622334-5-marcandre.lureau@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71987-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E16821A7690
X-Rspamd-Action: no action

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Reviewed-by: Cédric Le Goater <clg@redhat.com>
---
 include/system/memory.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/system/memory.h b/include/system/memory.h
index be36fd93dc0..a64b2826489 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -574,7 +574,7 @@ struct RamDiscardListener {
      * new population (e.g., unmap).
      *
      * @rdl: the #RamDiscardListener getting notified
-     * @section: the #MemoryRegionSection to get populated. The section
+     * @section: the #MemoryRegionSection to get discarded. The section
      *           is aligned within the memory region to the minimum granularity
      *           unless it would exceed the registered section.
      */
-- 
2.53.0


