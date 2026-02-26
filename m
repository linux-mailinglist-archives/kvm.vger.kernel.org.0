Return-Path: <kvm+bounces-71996-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KNLfEQ5XoGkNigQAu9opvQ
	(envelope-from <kvm+bounces-71996-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:22:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FFEC1A76CC
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:22:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 54D1130B3D30
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84AA73A1D05;
	Thu, 26 Feb 2026 14:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WRnOmFJp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D803636D4E6
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 14:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114473; cv=none; b=Rd1G8u39cmMwkGz4Oexq2DXkh+M22SCKwRot0wqYQQJ9PKAoR41JPJSGakekdReHkGdHMeLiMsDzEZLWeftqyZ21o/piNYLX74Ntif48vggqZzJnMibmYcmbKLdrCwaK+QX6pMic04Qda24yE4cbfu9ShNYV/JepM4rlCAZVPxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114473; c=relaxed/simple;
	bh=aAhmnFU5iK61m0s6eT+tQt+2zx7oAaoKUwFS1RbdqzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YDso+aydQjPblOFBC8R90Zs+FGkCGMsQ0ijodmpXHDhm4chuyEmGv88zaAa5V8ac1sxi2PF1F/cW6b6dJMrKDikCPGPMG7kfKQhJZHjDb3Y+k3WQVIylm4WUq5uKch0Pv0rUDRurTijA4YlQfx0yo181bYj7URS0noQRjm7Dsi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WRnOmFJp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772114459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z2KGzf0HMEkIVAc9UiJzuxWJ25Lw3QMqbgo+wk0wHYQ=;
	b=WRnOmFJp/VG0MhKAX1ymJCZuGrz2RYwZlOBQ2XUuSMzinfh/Pc2c69ZHaD/t8gjsEEw7/1
	EgaXLFtv5iatfS3SZeVqqEbiaiLLi3FqZZ60maidU6iEbKdQ0pCEqsfTz9VO7IjmAt38jC
	hJgVJ1Rzu3EtiCmD2AusgWa779PnhZs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-369-76BAIdJaMIKA4SHAsDz84g-1; Thu,
 26 Feb 2026 09:00:53 -0500
X-MC-Unique: 76BAIdJaMIKA4SHAsDz84g-1
X-Mimecast-MFC-AGG-ID: 76BAIdJaMIKA4SHAsDz84g_1772114450
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9D8AD1956058;
	Thu, 26 Feb 2026 14:00:50 +0000 (UTC)
Received: from localhost (unknown [10.45.242.29])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0C4D130001A5;
	Thu, 26 Feb 2026 14:00:49 +0000 (UTC)
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
Subject: [PATCH v3 14/15] system/memory: add RamDiscardManager reference counting and cleanup
Date: Thu, 26 Feb 2026 14:59:59 +0100
Message-ID: <20260226140001.3622334-15-marcandre.lureau@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71996-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 0FFEC1A76CC
X-Rspamd-Action: no action

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Listeners now hold a reference to the RamDiscardManager, ensuring it
stays alive while listeners are registered. The RDM is eagerly freed
when the last source and listener are removed, and also unreffed during
MemoryRegion finalization as a safety net.

This completes the TODO left in the previous commit and prevents both
use-after-free and memory leaks of the RamDiscardManager.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 system/memory.c              | 7 +++++--
 system/ram-discard-manager.c | 2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/system/memory.c b/system/memory.c
index 8a4cb7b59ac..664d24109ab 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -1817,6 +1817,7 @@ static void memory_region_finalize(Object *obj)
     memory_region_clear_coalescing(mr);
     g_free((char *)mr->name);
     g_free(mr->ioeventfds);
+    object_unref(mr->rdm);
 }
 
 Object *memory_region_owner(MemoryRegion *mr)
@@ -2123,8 +2124,10 @@ void memory_region_del_ram_discard_source(MemoryRegion *mr,
     g_assert(mr->rdm);
 
     ram_discard_manager_del_source(mr->rdm, source);
-
-    /* if there is no source and no listener left, we could free rdm */
+    if (QLIST_EMPTY(&mr->rdm->source_list) && QLIST_EMPTY(&mr->rdm->rdl_list)) {
+        object_unref(mr->rdm);
+        mr->rdm = NULL;
+    }
 }
 
 /* Called with rcu_read_lock held.  */
diff --git a/system/ram-discard-manager.c b/system/ram-discard-manager.c
index 5592bfd3486..904a98cbef1 100644
--- a/system/ram-discard-manager.c
+++ b/system/ram-discard-manager.c
@@ -549,6 +549,7 @@ void ram_discard_manager_register_listener(RamDiscardManager *rdm,
 
     g_assert(section->mr == rdm->mr);
 
+    object_ref(rdm);
     rdl->section = memory_region_section_new_copy(section);
     QLIST_INSERT_HEAD(&rdm->rdl_list, rdl, next);
 
@@ -570,6 +571,7 @@ void ram_discard_manager_unregister_listener(RamDiscardManager *rdm,
     memory_region_section_free_copy(rdl->section);
     rdl->section = NULL;
     QLIST_REMOVE(rdl, next);
+    object_unref(rdm);
 }
 
 int ram_discard_manager_replay_populated_to_listeners(RamDiscardManager *rdm)
-- 
2.53.0


