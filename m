Return-Path: <kvm+bounces-69999-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GKh8LGTlgWl0LwMAu9opvQ
	(envelope-from <kvm+bounces-69999-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 13:09:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 39334D8CFB
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 13:09:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 52AC8303C000
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 12:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 142BF33D50E;
	Tue,  3 Feb 2026 12:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RL/NZkiv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75D833D6CD
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 12:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770120242; cv=none; b=r/KcoV80l/MSODi0MNl8tj5MW0E2rBsloqwYq3IGhqArDwyrkXeovnJVJbyEfaOcAxgZFryWIq3mci+ykk5I29R4c9jmGgaUbRk7tPkLy1i3W2p4+51dU2G5Betl/vXnSBfeKpWCOX5AuatfP1ecLNk0jQ7s+jsTM2zx48AQlvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770120242; c=relaxed/simple;
	bh=U0g6OtSMp1gExzlRk/1cUylmypjadDwakB5wxtgXy44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqeoeqj1Zg7hC9IIk5co5iHaBVXT/ONsiL2/d2V99xzFrsN4uCGbkLVxAOnegoac+7uxbfYmGkVrJJoXVu8DtTe9562IsjpRhHpAE9MqeVHljBONhHzSAe9I+WQ3MotCUc3inWo2y86iKSC1YSrzLwUWmJXu9rYQGxki3Rr43QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RL/NZkiv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770120239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qkdoZn+iKo45E0fUEaUBU7em89paVKCLSORYybGXFeU=;
	b=RL/NZkiv7ysaXZA6DDLXc4VbBs+jRAQaJgWmYwVL639+/Zfor3u+jLPBT+G4SDDqcchZ/U
	PIilA2QSg5/ZlNnsXkUnErGsvs3NGrh274lxauDvIRmuuSNR1Fj91j2tug95XYIQho1ktw
	QEPQymJP4WHEr3RrHzUXH74JcWu+GXM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-359-sHcz83X3P3-8Trh607mlOw-1; Tue,
 03 Feb 2026 07:03:56 -0500
X-MC-Unique: sHcz83X3P3-8Trh607mlOw-1
X-Mimecast-MFC-AGG-ID: sHcz83X3P3-8Trh607mlOw_1770120235
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4AA85195422D;
	Tue,  3 Feb 2026 12:03:55 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.44.34.28])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 606811955F16;
	Tue,  3 Feb 2026 12:03:54 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id EFBAD1800988; Tue, 03 Feb 2026 13:03:43 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Igor Mammedov <imammedo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Ani Sinha <anisinha@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Zhao Liu <zhao1.liu@intel.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>
Subject: [PULL 07/17] igvm: add trace points for igvm file loading and processing
Date: Tue,  3 Feb 2026 13:03:32 +0100
Message-ID: <20260203120343.656961-8-kraxel@redhat.com>
In-Reply-To: <20260203120343.656961-1-kraxel@redhat.com>
References: <20260203120343.656961-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,linaro.org,habkost.net,intel.com,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69999-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kraxel@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 39334D8CFB
X-Rspamd-Action: no action

Reviewed-by: Ani Sinha <anisinha@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Message-ID: <20260126123755.357378-5-kraxel@redhat.com>
---
 backends/igvm.c       | 5 +++++
 backends/trace-events | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/backends/igvm.c b/backends/igvm.c
index a01e01a12a60..4cf7b572347c 100644
--- a/backends/igvm.c
+++ b/backends/igvm.c
@@ -20,6 +20,8 @@
 #include "system/address-spaces.h"
 #include "hw/core/cpu.h"
 
+#include "trace.h"
+
 #include <igvm/igvm.h>
 #include <igvm/igvm_defs.h>
 
@@ -886,6 +888,8 @@ IgvmHandle qigvm_file_init(char *filename, Error **errp)
         error_setg(errp, "Unable to parse IGVM file %s: %d", filename, igvm);
         return -1;
     }
+
+    trace_igvm_file_loaded(filename, igvm);
     return igvm;
 }
 
@@ -903,6 +907,7 @@ int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
         return -1;
     }
     ctx.file = cfg->file;
+    trace_igvm_process_file(cfg->file, onlyVpContext);
 
     /*
      * The ConfidentialGuestSupport object is optional and allows a confidential
diff --git a/backends/trace-events b/backends/trace-events
index 87e0c636ec02..8dc64a20d3d9 100644
--- a/backends/trace-events
+++ b/backends/trace-events
@@ -28,3 +28,5 @@ iommufd_backend_alloc_vdev(int iommufd, uint32_t dev_id, uint32_t viommu_id, uin
 igvm_reset_enter(int type) "type=%u"
 igvm_reset_hold(int type) "type=%u"
 igvm_reset_exit(int type) "type=%u"
+igvm_file_loaded(const char *fn, int32_t handle) "fn=%s, handle=0x%x"
+igvm_process_file(int32_t handle, bool context_only) "handle=0x%x context-only=%d"
-- 
2.52.0


