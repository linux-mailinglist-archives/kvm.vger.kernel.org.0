Return-Path: <kvm+bounces-25850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B306396BA41
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:22:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E55A71C21E65
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ADC41D096B;
	Wed,  4 Sep 2024 11:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DQcGWjYY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191881CF7DA
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 11:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725448732; cv=none; b=hjEHeo88vy29knVL8H1dYa0Tql62pKpLHF4+E3KbjcuNC9TDDN2RMkoCjcdaLFVez4X8cjF+tBxZmmVteYcvOHh663lRzwBA0CbOQA4NHTbMLeRP8vx+DvDSNkWiNcYQWlfSq7MHWYGDLWnEqmBliHX3Xox7Z9ClaQAITvrFvPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725448732; c=relaxed/simple;
	bh=rz6wNtjI6EAnAbpnIHz2TpGU//T4hwN2jOndCFi3guo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=E9qnIwEzoKDH/KB2EnYV50ZaPM60y9rd7+CUQfYi3KvHu5jqz7FTi4Hy9guCMjqXqJyIyiL7p6dF1G26luyZDxE27UfX9HKtWHzmiMqV24WtjVpA4bsmfErv5L+4iWl8evmySplLf2VHC9xXAq40P4G44UnPgjoeD8j23Oec1EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DQcGWjYY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725448729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=60/S7nrmH8dWcOxOWOtd93pxbq0cOxGZapRifYABfNs=;
	b=DQcGWjYYr8lUzgA1lCi7K0At/9t4ekyuBZtMT8jIzTUFRQK9zBjerSVD+SCNT2mFp+qZ0Y
	yWAKZvTx4EuA+Y7ZU9OMUPDNqzNiv2VQZyLtUyUFsR9wDaYXxT1J2F19J+s04T6oGWZjjH
	fcLWR5QRU8n6hp2w9FAXDiPExzdnXV8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-640-sjpFcQu1MvupF4SYoECIcA-1; Wed,
 04 Sep 2024 07:18:46 -0400
X-MC-Unique: sjpFcQu1MvupF4SYoECIcA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D3DE71955F56;
	Wed,  4 Sep 2024 11:18:41 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA1FB19560AA;
	Wed,  4 Sep 2024 11:18:38 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 97E0921E6939; Wed,  4 Sep 2024 13:18:36 +0200 (CEST)
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
Subject: [PATCH v2 03/19] qapi/block-core: Drop temporary 'prefix'
Date: Wed,  4 Sep 2024 13:18:20 +0200
Message-ID: <20240904111836.3273842-4-armbru@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Recent commit "qapi: Smarter camel_to_upper() to reduce need for
'prefix'" added a temporary 'prefix' to delay changing the generated
code.

Revert it.  This improves XDbgBlockGraphNodeType's generated
enumeration constant prefix from
X_DBG_BLOCK_GRAPH_NODE_TYPE_BLOCK_BACKEND to
XDBG_BLOCK_GRAPH_NODE_TYPE_BLOCK_BACKEND.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 qapi/block-core.json | 1 -
 block.c              | 6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/qapi/block-core.json b/qapi/block-core.json
index 452047102a..a7ae2da47b 100644
--- a/qapi/block-core.json
+++ b/qapi/block-core.json
@@ -2011,7 +2011,6 @@
 # Since: 4.0
 ##
 { 'enum': 'XDbgBlockGraphNodeType',
-  'prefix': 'X_DBG_BLOCK_GRAPH_NODE_TYPE', # TODO drop
   'data': [ 'block-backend', 'block-job', 'block-driver' ] }
 
 ##
diff --git a/block.c b/block.c
index c317de9eaa..7d90007cae 100644
--- a/block.c
+++ b/block.c
@@ -6351,7 +6351,7 @@ XDbgBlockGraph *bdrv_get_xdbg_block_graph(Error **errp)
         if (!*name) {
             name = allocated_name = blk_get_attached_dev_id(blk);
         }
-        xdbg_graph_add_node(gr, blk, X_DBG_BLOCK_GRAPH_NODE_TYPE_BLOCK_BACKEND,
+        xdbg_graph_add_node(gr, blk, XDBG_BLOCK_GRAPH_NODE_TYPE_BLOCK_BACKEND,
                            name);
         g_free(allocated_name);
         if (blk_root(blk)) {
@@ -6364,7 +6364,7 @@ XDbgBlockGraph *bdrv_get_xdbg_block_graph(Error **errp)
              job = block_job_next_locked(job)) {
             GSList *el;
 
-            xdbg_graph_add_node(gr, job, X_DBG_BLOCK_GRAPH_NODE_TYPE_BLOCK_JOB,
+            xdbg_graph_add_node(gr, job, XDBG_BLOCK_GRAPH_NODE_TYPE_BLOCK_JOB,
                                 job->job.id);
             for (el = job->nodes; el; el = el->next) {
                 xdbg_graph_add_edge(gr, job, (BdrvChild *)el->data);
@@ -6373,7 +6373,7 @@ XDbgBlockGraph *bdrv_get_xdbg_block_graph(Error **errp)
     }
 
     QTAILQ_FOREACH(bs, &graph_bdrv_states, node_list) {
-        xdbg_graph_add_node(gr, bs, X_DBG_BLOCK_GRAPH_NODE_TYPE_BLOCK_DRIVER,
+        xdbg_graph_add_node(gr, bs, XDBG_BLOCK_GRAPH_NODE_TYPE_BLOCK_DRIVER,
                            bs->node_name);
         QLIST_FOREACH(child, &bs->children, next) {
             xdbg_graph_add_edge(gr, bs, child);
-- 
2.46.0


