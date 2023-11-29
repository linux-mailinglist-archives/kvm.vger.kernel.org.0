Return-Path: <kvm+bounces-2716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D7D87FCD62
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 04:21:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 945301C21070
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 03:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF276ABA;
	Wed, 29 Nov 2023 03:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z1a3yFto"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733231710
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 19:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701228094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=70dWe0iCbVqLX19qzuXJQcGyzgyV+XFQOF3eP0y6/bg=;
	b=Z1a3yFtodcCBPTkrtDfZiKhSqctT7JxtPGBCf6yRjSvUV/7/U4/i/cCJPMxB8q9VBR6Jr5
	rylQDd0EipbMZsXiLbyTSgY6JPbaijHfdJAOYdnyKRdLntKI3AeGCMC79NrlheNHFFEjaX
	is+HAEm42NFxGvYRjpLux39QJVuVAYY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-383-WLfCfUsgNJiGWrSaWSfgzw-1; Tue,
 28 Nov 2023 22:21:31 -0500
X-MC-Unique: WLfCfUsgNJiGWrSaWSfgzw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB69F38062BB;
	Wed, 29 Nov 2023 03:21:30 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D3CE6492BFE;
	Wed, 29 Nov 2023 03:21:30 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Nico Boehr <nrb@linux.ibm.com>,
	Ricardo Koller <ricarkol@google.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Colton Lewis <coltonlewis@google.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 2/3] runtime: arm64: Skip the migration tests when run on EFI
Date: Tue, 28 Nov 2023 22:21:22 -0500
Message-Id: <20231129032123.2658343-3-shahuang@redhat.com>
In-Reply-To: <20231129032123.2658343-1-shahuang@redhat.com>
References: <20231129032123.2658343-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

When running the migration tests on EFI, the migration will always fail
since the efi/run use the vvfat format to run test, but the vvfat format
does not support live migration. So those migration tests will always
fail.

Instead of waiting for fail everytime when run migration tests on EFI,
skip those tests if running on EFI.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 scripts/runtime.bash | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index d7054b80..b7105c19 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -156,6 +156,11 @@ function run()
         fi
     }
 
+    if [ "${CONFIG_EFI}" == "y" ] && find_word "migration" "$groups"; then
+        print_result "SKIP" $testname "" "migration test is not support in efi"
+        return 2
+    fi
+
     cmdline=$(get_cmdline $kernel)
     if find_word "migration" "$groups"; then
         cmdline="MIGRATION=yes $cmdline"
-- 
2.40.1


