Return-Path: <kvm+bounces-71995-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MEIDNR5YoGkNigQAu9opvQ
	(envelope-from <kvm+bounces-71995-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:26:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D33FA1A781D
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:26:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8FCF53130DEC
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E78F363C57;
	Thu, 26 Feb 2026 14:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HDV0xSsk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A303BFE29
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 14:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114465; cv=none; b=txJm4Wf0p/KD4UDNRkEch8wfc2/igInITZ9fGbHbwCGU83FXv2TM1F4ei1kv/kCK+Lln/qcUe8J1sLkqaBVja511ZEH4tR4ZnNEOJ+OeP/mCgybwoBUokVn8XJrL0bf3BnoRc4uHENd31J9WXVNYW++YkWaKe04sbk8PPgD7H/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114465; c=relaxed/simple;
	bh=6CloF9pxjTCH0nnMDhjIrHf2rlEl9xAFk6fyQ9XH/Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pM0Ms5imRCpm4CP57BSHZzTQ8zPm8NaVh5xRsjyjZPRE9lVsHv0+RACFFcwtNqslbraBrTD5TSk/xr/kxwdH8SCVgBgIzIApw5LxjvhLn134/RAD8YV662L2h/gGQ378ndLv4sWkIaHz/lqpOiShbhrPVxY8CJRVVcmQCUUEaX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HDV0xSsk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772114453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2WvlEsuPi6e7u3qLm/tyXMiGoFxoDbeEYBboebD1eIM=;
	b=HDV0xSsk5PAqqG9kkBTUT4jX0dCTfT8aNMOj7hn/4RY7Y75cIflUBjJQrKSLCsc/D3qqfD
	C3rTKiA8JByFB2oj+oLvRJzdjJpNx8V3DuVjUBxo/RqqeAzf7TceGOc37oEuLAUEKB+j8W
	/qERAn5WW5+fcuLKUr7af93G5sg7mWI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-83-r2k1fx2VMWKbW7KwiIZpbw-1; Thu,
 26 Feb 2026 09:00:49 -0500
X-MC-Unique: r2k1fx2VMWKbW7KwiIZpbw-1
X-Mimecast-MFC-AGG-ID: r2k1fx2VMWKbW7KwiIZpbw_1772114448
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F5B819560B7;
	Thu, 26 Feb 2026 14:00:48 +0000 (UTC)
Received: from localhost (unknown [10.45.242.29])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BCB5430001B9;
	Thu, 26 Feb 2026 14:00:46 +0000 (UTC)
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
Subject: [PATCH v3 13/15] system/physmem: destroy ram block attributes before RCU-deferred reclaim
Date: Thu, 26 Feb 2026 14:59:58 +0100
Message-ID: <20260226140001.3622334-14-marcandre.lureau@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71995-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D33FA1A781D
X-Rspamd-Action: no action

From: Marc-André Lureau <marcandre.lureau@redhat.com>

ram_block_attributes_destroy() was called from reclaim_ramblock(), which
runs as an RCU callback deferred by call_rcu().

However,when the RamDiscardManager is finalized, it will assert that its
source_list is empty in the next commit. Since the RCU callback hasn't
run yet, the source added by ram_block_attributes_create() is still
attached.

Move ram_block_attributes_destroy() into qemu_ram_free() so the source
is removed synchronously. This is safe because qemu_ram_free() during
shutdown runs after pause_all_vcpus(), so no vCPU thread can
concurrently access the attributes via kvm_convert_memory().

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 system/physmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/system/physmem.c b/system/physmem.c
index 2fb0c25c93b..cf64caf6285 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2589,7 +2589,6 @@ static void reclaim_ramblock(RAMBlock *block)
     }
 
     if (block->guest_memfd >= 0) {
-        ram_block_attributes_destroy(block->attributes);
         close(block->guest_memfd);
         ram_block_coordinated_discard_require(false);
     }
@@ -2618,6 +2617,7 @@ void qemu_ram_free(RAMBlock *block)
     /* Write list before version */
     smp_wmb();
     ram_list.version++;
+    g_clear_pointer(&block->attributes, ram_block_attributes_destroy);
     call_rcu(block, reclaim_ramblock, rcu);
     qemu_mutex_unlock_ramlist();
 }
-- 
2.53.0


