Return-Path: <kvm+bounces-69677-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OFEwHnlGfGn8LgIAu9opvQ
	(envelope-from <kvm+bounces-69677-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 06:49:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 016E4B777A
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 06:49:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CC9E43046516
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 05:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77688374189;
	Fri, 30 Jan 2026 05:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BBuWHfP5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6511919E819
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 05:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769752095; cv=none; b=knO32kZf8r5yQOma0FNZRUUhauNAHiRN5QMCV4ya9FfcFBYOXyIYJibkOB7GKVQCh8KzPB/imvVnfEqZs2RaTvXDAiuCaCoG1Og95cHudBb/uOiq8r9bzIjCoaXJvy1ulAJQ3CyyrY5LaIyP2G24IL4HXsLglkZqY2pf5X+6y18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769752095; c=relaxed/simple;
	bh=9/3oou2Reu3e+kq6OLauYdVSarqc8K8KQsD/ls9In2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZUG0/GHjqotcnTqxMaQSGC2C+OSGTtqeprL46Zhln/m8tYq83n4OPK+j/FTu7R+G7NISYxYgxPgjpqmU2prNhy/ktiRDnz4QNd7Jpdz24WZFbCdLe+0jW1UwRnjfCv4krroLQxnWwr2FqxA58rxld/K+yUxfqF3jPOpdn8ru0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BBuWHfP5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769752093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Si/Kii2ggAVTdYuNl9bX4xHdx4QI2ldGNdtiEINfNJw=;
	b=BBuWHfP5U76njwjMuRgyz5lUdCa2RyLQD6RnnZSjbYpGw10lNop14wXF1JkHkYVgeHI4zD
	qgiTjm8TDeCdsA4lB3GeTuAIOqscycgOqHBawW+WHGDfKzoiw7lDgL73Xm3ntrGkrXYXLB
	p5QERx2EQaDZvsfnVHhHr7AimYabE98=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-569-Y7buGfhxNJSIuN5A_xWpfA-1; Fri,
 30 Jan 2026 00:48:11 -0500
X-MC-Unique: Y7buGfhxNJSIuN5A_xWpfA-1
X-Mimecast-MFC-AGG-ID: Y7buGfhxNJSIuN5A_xWpfA_1769752090
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 78BC0195608E;
	Fri, 30 Jan 2026 05:48:10 +0000 (UTC)
Received: from osteffen-thinkpadx1carbongen12.rmtde.csb (unknown [10.45.226.150])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 672B719560A2;
	Fri, 30 Jan 2026 05:48:04 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH v6 8/9] igvm: Only build stubs if igvm is enabled
Date: Fri, 30 Jan 2026 06:47:13 +0100
Message-ID: <20260130054714.715928-9-osteffen@redhat.com>
In-Reply-To: <20260130054714.715928-1-osteffen@redhat.com>
References: <20260130054714.715928-1-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,intel.com,habkost.net,vger.kernel.org,linaro.org,amd.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69677-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[osteffen@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 016E4B777A
X-Rspamd-Action: no action

Change meson script to only include the IGVM stubs file if the IGVM
feature is enabled. It is used to handle architecture specific
differences within the IGVM backend, not to provide stubs of the backend
itself.

Signed-off-by: Oliver Steffen <osteffen@redhat.com>
---
 stubs/meson.build | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/stubs/meson.build b/stubs/meson.build
index 2b5fd8a88a..8a07059500 100644
--- a/stubs/meson.build
+++ b/stubs/meson.build
@@ -71,7 +71,9 @@ if have_system
   stub_ss.add(files('dump.c'))
   stub_ss.add(files('cmos.c'))
   stub_ss.add(files('fw_cfg.c'))
-  stub_ss.add(files('igvm.c'))
+  if igvm.found()
+    stub_ss.add(files('igvm.c'))
+  endif
   stub_ss.add(files('target-get-monitor-def.c'))
   stub_ss.add(files('target-monitor-defs.c'))
   stub_ss.add(files('win32-kbd-hook.c'))
-- 
2.52.0


