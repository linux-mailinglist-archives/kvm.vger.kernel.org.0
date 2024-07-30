Return-Path: <kvm+bounces-22615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A553940AE2
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 10:11:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBAC01C22DE1
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 08:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B7D192B99;
	Tue, 30 Jul 2024 08:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N96xfFjv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B0C19007A
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 08:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722327053; cv=none; b=BNAmFMvYshpVwycLf95zD/r92WPRbI0uUOO//+BKBSsPLN+2x+dOa6S89w1AOADIPYRe88zLG0rff1zwI6UAg5d/7ZxdZ2Mpcl6uTc3pNhjsvoKa/Vt5jnz74jbKMN3xxPPK4OEx4QTip126bpLh6/QWIqYPnSZ1be1xliz/zyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722327053; c=relaxed/simple;
	bh=9P4BbPdQlnKg5IqXXwQAzjd6Sx2yWFsBZpGkWB1PANc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=U8TUxyrMMHCcRivVlrHLN/17koJ+LCY21s76uAMxgTkJrUI9URTY+MGH1eHPoXuhxKeAIZbxucb/TbZ7D9YDawnswa50pJ+/3S2HGs84qYeRXiDQLJkP7/9iYSKY7S0P68ijw9r1jgupt10iEGcU8ITO1Au44MtAl2wNrzyR7mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N96xfFjv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722327050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DV7+EVWYFbrbaXV5c6Y9cFzbPTN8d8JAt36ne5Q5Nhc=;
	b=N96xfFjv98ZgpE/dFrD6uH3ZGHCggiVR1LQBUr3Eo0Yesx2cvwgrPCxRE5V30Qgaa49L7z
	oRjdcqcr7PXOGxAHpT2aVcMNxRgoJs269cdXp16piLPIETn+VFJ+atgrGqyvvM39xXW+BB
	8iPMIgfs6EpVIFGu+YaOdgF1kXwDOnQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-663-HO2voRrbNwuPaRTmjAxVvQ-1; Tue,
 30 Jul 2024 04:10:47 -0400
X-MC-Unique: HO2voRrbNwuPaRTmjAxVvQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD9A819560B0;
	Tue, 30 Jul 2024 08:10:42 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.65])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9168E300018D;
	Tue, 30 Jul 2024 08:10:41 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id E265121F4B94; Tue, 30 Jul 2024 10:10:32 +0200 (CEST)
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
	kvm@vger.kernel.org
Subject: [PATCH 07/18] qapi/machine: Drop temporary 'prefix'
Date: Tue, 30 Jul 2024 10:10:21 +0200
Message-ID: <20240730081032.1246748-8-armbru@redhat.com>
In-Reply-To: <20240730081032.1246748-1-armbru@redhat.com>
References: <20240730081032.1246748-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Recent commit "qapi: Smarter camel_to_upper() to reduce need for
'prefix'" added a temporary 'prefix' to delay changing the generated
code.

Revert it.  This improves HmatLBDataType's generated enumeration
constant prefix from HMATLB_DATA_TYPE to HMAT_LB_DATA_TYPE.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 qapi/machine.json            | 1 -
 hw/core/numa.c               | 4 ++--
 hw/pci-bridge/cxl_upstream.c | 4 ++--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/qapi/machine.json b/qapi/machine.json
index 5514450e12..fcfd249e2d 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -712,7 +712,6 @@
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
2.45.0


