Return-Path: <kvm+bounces-2839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 091F17FE7A7
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 04:30:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B722B21324
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 03:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5105313AE3;
	Thu, 30 Nov 2023 03:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JYP7kThJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FAA10CB
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 19:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701315010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NxZFFMDpBFfPPZndp5yBJyp7e8IUPc9SqT8KXrNXg6o=;
	b=JYP7kThJ7n3Y/XRq2OxPkChOuTc4+v8/rRqam8VdqEM9wbL9V96qJML6zmA4qUiM5zA7iw
	prscfUQiByYJxie7TCpxUsRnllmESA2VqlqZIM5wSBWir3uq5ADFY7i73L0LnhGUN5l0UX
	vjNFxiNy3Rq/34f+6nUdq62Heu6heo4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-O6XhYT-OPTO9OThdqPmiXw-1; Wed, 29 Nov 2023 22:30:06 -0500
X-MC-Unique: O6XhYT-OPTO9OThdqPmiXw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE750811E7B;
	Thu, 30 Nov 2023 03:30:05 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A66AF112130C;
	Thu, 30 Nov 2023 03:30:05 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Nico Boehr <nrb@linux.ibm.com>,
	Colton Lewis <coltonlewis@google.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 2/3] runtime: arm64: Skip the migration tests when run on EFI
Date: Wed, 29 Nov 2023 22:29:39 -0500
Message-Id: <20231130032940.2729006-3-shahuang@redhat.com>
In-Reply-To: <20231130032940.2729006-1-shahuang@redhat.com>
References: <20231130032940.2729006-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

When running the migration tests on EFI, the migration will always fail
since the efi/run use the vvfat format to run test, but the vvfat format
does not support live migration. So those migration tests will always
fail.

Instead of waiting for fail everytime when run migration tests on EFI,
skip those tests if running on EFI.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 scripts/runtime.bash | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index c73fb024..64d223e8 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -156,6 +156,10 @@ function run()
 
     cmdline=$(get_cmdline $kernel)
     if find_word "migration" "$groups"; then
+        if [ "{CONFIG_EFI}" == "y" ]; then
+            print_result "SKIP" $testname "" "migration tests are not supported with efi"
+            return 2
+        fi
         cmdline="MIGRATION=yes $cmdline"
     fi
     if find_word "panic" "$groups"; then
-- 
2.40.1


