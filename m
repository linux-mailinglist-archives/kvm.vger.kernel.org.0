Return-Path: <kvm+bounces-25862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB3FF96BA4F
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:24:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94D5D28336D
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5886F1DA60F;
	Wed,  4 Sep 2024 11:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g3tRnGSr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09101DA0FE
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 11:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725448739; cv=none; b=vAKqdbEIHbsZLR5GV6nYuZYdxPwD+KTecySxD0BWATbMWPpw4aIeLwhqxipEB/04t3+1X58I1FSdK/3M5QwchV8MMGWypMCjTjYyDLyknRkHJcDTlWfCT42SiaGZvt2QCRzsYTMRNXT+Ug0iZbESMDURQ7ieDaijUBfplNPcw0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725448739; c=relaxed/simple;
	bh=IxdzLEkjhlU2bXEoIJbE3Gcf8uPXcmKKsCZtbYwAdGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=pi+rok2hJlt2I9LDWI7jIzTtT1aTvYpgwJrWYA/Gm1S72B02bC8c2nuY0GSkSixsRVRM1OhITgNcbf+7vaTmdIpjxRr/vepp5sB4d2U1V/lkv/YeO9krkejEjmZU6gCnEQPSSTxeV1KC9dnjZzSzVXsQElvqrz0mpnavsvEA1s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g3tRnGSr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725448737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cgyAtkjmkamaAiZWsKefrgdh6QwwNTx6VRHP9div+qI=;
	b=g3tRnGSrzcjf9770H0IZZXRRe9Ox4P4SDsMDndzSKOrUA2Fnl+c5xlbcKEctVHTwZxaIAK
	XMdlUaNZbo4BcinLxOWF83eCUZ79LRKM6hhHeC59VdVVaqnJJWYO6RcDyNXidjXP8u1Q91
	C5BOY6B9Jv5qdJuDACLrobHtuy4hydA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-92-Ma6bQ6FpOSGSk9Gn1qDidg-1; Wed,
 04 Sep 2024 07:18:53 -0400
X-MC-Unique: Ma6bQ6FpOSGSk9Gn1qDidg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EE7111955D71;
	Wed,  4 Sep 2024 11:18:44 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B28EC195605A;
	Wed,  4 Sep 2024 11:18:43 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id AB26A21E68B2; Wed,  4 Sep 2024 13:18:36 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: alex.williamson@redhat.com,
	andrew@codeconstruct.com.au,
	andrew@daynix.com,
	arei.gonglei@huawei.com,
	berrange@redhat.com,
	berto@igalia.com,
	borntraeger@linux.ibm.com,
	clg@kaod.org,
	david@redhat.com,
	den@openvz.org,
	eblake@redhat.com,
	eduardo@habkost.net,
	farman@linux.ibm.com,
	farosas@suse.de,
	hreitz@redhat.com,
	idryomov@gmail.com,
	iii@linux.ibm.com,
	jamin_lin@aspeedtech.com,
	jasowang@redhat.com,
	joel@jms.id.au,
	jsnow@redhat.com,
	kwolf@redhat.com,
	leetroy@gmail.com,
	marcandre.lureau@redhat.com,
	marcel.apfelbaum@gmail.com,
	michael.roth@amd.com,
	mst@redhat.com,
	mtosatti@redhat.com,
	nsg@linux.ibm.com,
	pasic@linux.ibm.com,
	pbonzini@redhat.com,
	peter.maydell@linaro.org,
	peterx@redhat.com,
	philmd@linaro.org,
	pizhenwei@bytedance.com,
	pl@dlhnet.de,
	richard.henderson@linaro.org,
	stefanha@redhat.com,
	steven_lee@aspeedtech.com,
	thuth@redhat.com,
	vsementsov@yandex-team.ru,
	wangyanan55@huawei.com,
	yuri.benditovich@daynix.com,
	zhao1.liu@intel.com,
	qemu-block@nongnu.org,
	qemu-arm@nongnu.org,
	qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	avihaih@nvidia.com
Subject: [PATCH v2 07/19] qapi/machine: Drop temporary 'prefix'
Date: Wed,  4 Sep 2024 13:18:24 +0200
Message-ID: <20240904111836.3273842-8-armbru@redhat.com>
In-Reply-To: <20240904111836.3273842-1-armbru@redhat.com>
References: <20240904111836.3273842-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Recent commit "qapi: Smarter camel_to_upper() to reduce need for
'prefix'" added a temporary 'prefix' to delay changing the generated
code.

Revert it.  This improves HmatLBDataType's generated enumeration
constant prefix from HMATLB_DATA_TYPE to HMAT_LB_DATA_TYPE, and
HmatLBMemoryHierarchy's from HMATLB_MEMORY_HIERARCHY to
HMAT_LB_MEMORY_HIERARCHY.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 qapi/machine.json            | 2 --
 hw/core/numa.c               | 4 ++--
 hw/pci-bridge/cxl_upstream.c | 4 ++--
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/qapi/machine.json b/qapi/machine.json
index 552d1c20e9..d4317435e7 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -686,7 +686,6 @@
 # Since: 5.0
 ##
 { 'enum': 'HmatLBMemoryHierarchy',
-  'prefix': 'HMATLB_MEMORY_HIERARCHY', # TODO drop
   'data': [ 'memory', 'first-level', 'second-level', 'third-level' ] }
 
 ##
@@ -713,7 +712,6 @@
 # Since: 5.0
 ##
 { 'enum': 'HmatLBDataType',
-  'prefix': 'HMATLB_DATA_TYPE', # TODO drop
   'data': [ 'access-latency', 'read-latency', 'write-latency',
             'access-bandwidth', 'read-bandwidth', 'write-bandwidth' ] }
 
diff --git a/hw/core/numa.c b/hw/core/numa.c
index f8ce332cfe..fb81c1ed51 100644
--- a/hw/core/numa.c
+++ b/hw/core/numa.c
@@ -249,7 +249,7 @@ void parse_numa_hmat_lb(NumaState *numa_state, NumaHmatLBOptions *node,
     lb_data.initiator = node->initiator;
     lb_data.target = node->target;
 
-    if (node->data_type <= HMATLB_DATA_TYPE_WRITE_LATENCY) {
+    if (node->data_type <= HMAT_LB_DATA_TYPE_WRITE_LATENCY) {
         /* Input latency data */
 
         if (!node->has_latency) {
@@ -313,7 +313,7 @@ void parse_numa_hmat_lb(NumaState *numa_state, NumaHmatLBOptions *node,
             numa_info[node->target].lb_info_provided |= BIT(0);
         }
         lb_data.data = node->latency;
-    } else if (node->data_type >= HMATLB_DATA_TYPE_ACCESS_BANDWIDTH) {
+    } else if (node->data_type >= HMAT_LB_DATA_TYPE_ACCESS_BANDWIDTH) {
         /* Input bandwidth data */
         if (!node->has_bandwidth) {
             error_setg(errp, "Missing 'bandwidth' option");
diff --git a/hw/pci-bridge/cxl_upstream.c b/hw/pci-bridge/cxl_upstream.c
index e51221a5f3..f3e46f0651 100644
--- a/hw/pci-bridge/cxl_upstream.c
+++ b/hw/pci-bridge/cxl_upstream.c
@@ -234,7 +234,7 @@ static int build_cdat_table(CDATSubHeader ***cdat_table, void *priv)
                 .type = CDAT_TYPE_SSLBIS,
                 .length = sslbis_size,
             },
-            .data_type = HMATLB_DATA_TYPE_ACCESS_LATENCY,
+            .data_type = HMAT_LB_DATA_TYPE_ACCESS_LATENCY,
             .entry_base_unit = 10000,
         },
     };
@@ -254,7 +254,7 @@ static int build_cdat_table(CDATSubHeader ***cdat_table, void *priv)
                 .type = CDAT_TYPE_SSLBIS,
                 .length = sslbis_size,
             },
-            .data_type = HMATLB_DATA_TYPE_ACCESS_BANDWIDTH,
+            .data_type = HMAT_LB_DATA_TYPE_ACCESS_BANDWIDTH,
             .entry_base_unit = 1024,
         },
     };
-- 
2.46.0


