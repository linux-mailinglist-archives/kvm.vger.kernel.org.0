Return-Path: <kvm+bounces-69997-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +DJ7DjvlgWl0LwMAu9opvQ
	(envelope-from <kvm+bounces-69997-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 13:08:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E112D8CDD
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 13:08:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 300B3312296B
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 12:04:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7DCA33CEB9;
	Tue,  3 Feb 2026 12:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PFktVqv0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938033382C8
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 12:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770120239; cv=none; b=OObIc5BQeuliC00JyJHRHyGLpALe79k/+K8CDOVO8zAV17WrcBHCt3DS1m+w3I1geoMJe60lCQWOtfpLarJDpyEptFzs18TY5pPc7FZavZQBXghD6cMFNG5TRpD/AlxDa0hTsfblTGlkB1jsKX6PQ+jJWtTMbHALp27QFKwsbQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770120239; c=relaxed/simple;
	bh=SWIarQWt00M6rzKafqN/NGLhcKwAv7eA8WUT9bd4+P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuE42TOCtct/rC44tFkE9xdxM/C8qHqTHJo8cYYcU+ZnCWOtIgkgpd2eNLi0tOjopvkx+CLgUktK9pnAosziX/1Q6rQftXDuQ4s7hjYzQXNyDkfE3S6rgkOdWgVRMlG2+Gz/e1ettuyAKoSrgJ/YOaECI7i5bm++uLTGGvMFzW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PFktVqv0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770120236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sRLBbgFTDogr0mxQlU7Ar0SmLCofwAXBKtnT/vctrJQ=;
	b=PFktVqv0/8jS7l07fOe97mXHA9DIxnKDY3DlYkN3wEM7ayxh4dfSmhVfBAWsj1f6VSSaN+
	iuLouIbuSBH0EL7pEnETWSMQvojaKzg97emJXjCweJCZWwpSoRCsydgR4wUfgW0pLhIGTl
	sYKOiQko3KINPkwvmKbmhMOLZLy7mmg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-wsp-GSfcP66iktyslz1m9A-1; Tue,
 03 Feb 2026 07:03:53 -0500
X-MC-Unique: wsp-GSfcP66iktyslz1m9A-1
X-Mimecast-MFC-AGG-ID: wsp-GSfcP66iktyslz1m9A_1770120232
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3591E18003FD;
	Tue,  3 Feb 2026 12:03:52 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.44.34.28])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6115018007D2;
	Tue,  3 Feb 2026 12:03:51 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id C8F6B1800637; Tue, 03 Feb 2026 13:03:43 +0100 (CET)
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
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PULL 05/17] igvm: make igvm-cfg object resettable
Date: Tue,  3 Feb 2026 13:03:30 +0100
Message-ID: <20260203120343.656961-6-kraxel@redhat.com>
In-Reply-To: <20260203120343.656961-1-kraxel@redhat.com>
References: <20260203120343.656961-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
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
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,linaro.org,habkost.net,intel.com,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69997-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 8E112D8CDD
X-Rspamd-Action: no action

Add TYPE_RESETTABLE_INTERFACE to interfaces.  Register callbacks for the
reset phases.  Add trace points for logging and debugging.  No
functional change, that will come in followup patches.

Reviewed-by: Ani Sinha <anisinha@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Message-ID: <20260126123755.357378-3-kraxel@redhat.com>
---
 include/system/igvm-internal.h |  2 ++
 backends/igvm-cfg.c            | 35 +++++++++++++++++++++++++++++++++-
 backends/trace-events          |  5 +++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/include/system/igvm-internal.h b/include/system/igvm-internal.h
index 475a29bbf3d7..ac9e5683cc63 100644
--- a/include/system/igvm-internal.h
+++ b/include/system/igvm-internal.h
@@ -11,6 +11,7 @@
 
 #include "qemu/typedefs.h"
 #include "qom/object.h"
+#include "hw/core/resettable.h"
 
 struct IgvmCfg {
     ObjectClass parent_class;
@@ -21,6 +22,7 @@ struct IgvmCfg {
      *           format.
      */
     char *filename;
+    ResettableState reset_state;
 };
 
 #endif
diff --git a/backends/igvm-cfg.c b/backends/igvm-cfg.c
index 001c4dc93346..e0df3eaa8efd 100644
--- a/backends/igvm-cfg.c
+++ b/backends/igvm-cfg.c
@@ -17,6 +17,8 @@
 #include "system/reset.h"
 #include "qom/object_interfaces.h"
 
+#include "trace.h"
+
 static char *get_igvm(Object *obj, Error **errp)
 {
     IgvmCfg *igvm = IGVM_CFG(obj);
@@ -30,24 +32,55 @@ static void set_igvm(Object *obj, const char *value, Error **errp)
     igvm->filename = g_strdup(value);
 }
 
+static ResettableState *igvm_reset_state(Object *obj)
+{
+    IgvmCfg *igvm = IGVM_CFG(obj);
+    return &igvm->reset_state;
+}
+
+static void igvm_reset_enter(Object *obj, ResetType type)
+{
+    trace_igvm_reset_enter(type);
+}
+
+static void igvm_reset_hold(Object *obj, ResetType type)
+{
+    trace_igvm_reset_hold(type);
+}
+
+static void igvm_reset_exit(Object *obj, ResetType type)
+{
+    trace_igvm_reset_exit(type);
+}
+
 OBJECT_DEFINE_TYPE_WITH_INTERFACES(IgvmCfg, igvm_cfg, IGVM_CFG, OBJECT,
-                                   { TYPE_USER_CREATABLE }, { NULL })
+                                   { TYPE_USER_CREATABLE },
+                                   { TYPE_RESETTABLE_INTERFACE },
+                                   { NULL })
 
 static void igvm_cfg_class_init(ObjectClass *oc, const void *data)
 {
     IgvmCfgClass *igvmc = IGVM_CFG_CLASS(oc);
+    ResettableClass *rc = RESETTABLE_CLASS(oc);
 
     object_class_property_add_str(oc, "file", get_igvm, set_igvm);
     object_class_property_set_description(oc, "file",
                                           "Set the IGVM filename to use");
 
     igvmc->process = qigvm_process_file;
+
+    rc->get_state = igvm_reset_state;
+    rc->phases.enter = igvm_reset_enter;
+    rc->phases.hold = igvm_reset_hold;
+    rc->phases.exit = igvm_reset_exit;
 }
 
 static void igvm_cfg_init(Object *obj)
 {
+    qemu_register_resettable(obj);
 }
 
 static void igvm_cfg_finalize(Object *obj)
 {
+    qemu_unregister_resettable(obj);
 }
diff --git a/backends/trace-events b/backends/trace-events
index 14a7ecf5aaf4..87e0c636ec02 100644
--- a/backends/trace-events
+++ b/backends/trace-events
@@ -23,3 +23,8 @@ iommufd_backend_get_dirty_bitmap(int iommufd, uint32_t hwpt_id, uint64_t iova, u
 iommufd_backend_invalidate_cache(int iommufd, uint32_t id, uint32_t data_type, uint32_t entry_len, uint32_t entry_num, uint32_t done_num, uint64_t data_ptr, int ret) " iommufd=%d id=%u data_type=%u entry_len=%u entry_num=%u done_num=%u data_ptr=0x%"PRIx64" (%d)"
 iommufd_backend_alloc_viommu(int iommufd, uint32_t dev_id, uint32_t type, uint32_t hwpt_id, uint32_t viommu_id, int ret) " iommufd=%d type=%u dev_id=%u hwpt_id=%u viommu_id=%u (%d)"
 iommufd_backend_alloc_vdev(int iommufd, uint32_t dev_id, uint32_t viommu_id, uint64_t virt_id, uint32_t vdev_id, int ret) " iommufd=%d dev_id=%u viommu_id=%u virt_id=0x%"PRIx64" vdev_id=%u (%d)"
+
+# igvm-cfg.c
+igvm_reset_enter(int type) "type=%u"
+igvm_reset_hold(int type) "type=%u"
+igvm_reset_exit(int type) "type=%u"
-- 
2.52.0


