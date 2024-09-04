Return-Path: <kvm+bounces-25857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A5D296BA49
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:23:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC89B28325D
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F15431DA2EA;
	Wed,  4 Sep 2024 11:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NxwuP397"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BFF1D47D7
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 11:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725448738; cv=none; b=NAxvNFD5KJPRnYrNPFwKu/9i/RPGmBmdp/kWsRGyfv692ICqnM4g6xJ9HncjEWW06ZNPf4IUTPBVl8bDiBQFDGYkCJKplbLi0OscKn8mLX+vgzPIbjByGhqQunpCZ96c8HyE0vGQN3zruPMT563go6CIGBDHe4JlLIrMPpajEzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725448738; c=relaxed/simple;
	bh=ZXlwL8AdFMTJEHIXH+UxXE1VuO9hXvJjRmPvcA9DGYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=XISE050m1KVk1redfS7CBlD0fZr/rO1oz5VTias7FFkw2++uYGSfdvDtCzBZXDfzQMs61v9GCwvGw0fjEzcXdMGU32Zx9cggm6qvjPRGEb3zs8QpsFL0vwVVtvrSxPkpQzWRXZzu7NUPYxAsuCgFhFJ3cfqSlqPqPtxONVAFhB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NxwuP397; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725448735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v5OxU5+fri0QNP4QtfQ3jXNPwWqLTQ/eTokftl8fAO4=;
	b=NxwuP397fiKFB69M61FE4i9E1LLFGk6ySv791IES0dxZ5F2087UAprG+2ASqHF3QdPfu3f
	7/LU+v5VggVKYG9RUkSAtB7DPOytz984VTs9hh1L9XssvRaAZ1kAlcOXiEjvUlM/xQ63aV
	dDKboOwUvnv57y3Bw3rtgz5zTP6Ji+g=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-186-pVd6KmuaMr2gAXdvQZzOMA-1; Wed,
 04 Sep 2024 07:18:52 -0400
X-MC-Unique: pVd6KmuaMr2gAXdvQZzOMA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 89E3D1955DB2;
	Wed,  4 Sep 2024 11:18:44 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA934300019A;
	Wed,  4 Sep 2024 11:18:43 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id A626921E6891; Wed,  4 Sep 2024 13:18:36 +0200 (CEST)
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
Subject: [PATCH v2 06/19] qapi/ebpf: Drop temporary 'prefix'
Date: Wed,  4 Sep 2024 13:18:23 +0200
Message-ID: <20240904111836.3273842-7-armbru@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Recent commit "qapi: Smarter camel_to_upper() to reduce need for
'prefix'" added a temporary 'prefix' to delay changing the generated
code.

Revert it.  This improves EbpfProgramID's generated enumeration
constant prefix from EBPF_PROGRAMID to EBPF_PROGRAM_ID.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 qapi/ebpf.json  | 1 -
 ebpf/ebpf_rss.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/qapi/ebpf.json b/qapi/ebpf.json
index 42df548777..db19ae850f 100644
--- a/qapi/ebpf.json
+++ b/qapi/ebpf.json
@@ -42,7 +42,6 @@
 # Since: 9.0
 ##
 { 'enum': 'EbpfProgramID',
-  'prefix': 'EBPF_PROGRAMID',   # TODO drop
   'if': 'CONFIG_EBPF',
   'data': [ { 'name': 'rss' } ] }
 
diff --git a/ebpf/ebpf_rss.c b/ebpf/ebpf_rss.c
index 87f0714910..dcaa80f380 100644
--- a/ebpf/ebpf_rss.c
+++ b/ebpf/ebpf_rss.c
@@ -271,4 +271,4 @@ void ebpf_rss_unload(struct EBPFRSSContext *ctx)
     ctx->map_indirections_table = -1;
 }
 
-ebpf_binary_init(EBPF_PROGRAMID_RSS, rss_bpf__elf_bytes)
+ebpf_binary_init(EBPF_PROGRAM_ID_RSS, rss_bpf__elf_bytes)
-- 
2.46.0


