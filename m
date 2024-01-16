Return-Path: <kvm+bounces-6321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB28982E9BB
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 07:59:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6E176B22FD0
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 06:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7E191118A;
	Tue, 16 Jan 2024 06:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eEqHcj0x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992A010A1F
	for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 06:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705388332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HlK+W/3Y6hR8zU8dV/B+PirvVRSMRiHzK52ecqQW9NI=;
	b=eEqHcj0xXNC7474SkoKI6iZukee2QRxqN+3jspPewkg91RzR+bHabGz7WTiBz9mYnskHxt
	Z1RNKtxi+3HSGV1aEw/wmB3AtM7K1kTLKC1zkfQzm2rfGIWPLP68cnR1VOODmjYBVNPUUU
	7jhEFNsJvRCtly/v2JIs0+t9keZYTeI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-26-1ekKJL4NPNGLoRnWJ1x7sA-1; Tue,
 16 Jan 2024 01:58:49 -0500
X-MC-Unique: 1ekKJL4NPNGLoRnWJ1x7sA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 798B63C025C1;
	Tue, 16 Jan 2024 06:58:48 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6E3D13C25;
	Tue, 16 Jan 2024 06:58:48 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Nico Boehr <nrb@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Colton Lewis <coltonlewis@google.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 2/3] runtime: Skip the migration tests when run on EFI
Date: Tue, 16 Jan 2024 01:58:45 -0500
Message-Id: <20240116065847.71623-3-shahuang@redhat.com>
In-Reply-To: <20240116065847.71623-1-shahuang@redhat.com>
References: <20240116065847.71623-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

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
index c73fb024..7deb047c 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -156,6 +156,10 @@ function run()
 
     cmdline=$(get_cmdline $kernel)
     if find_word "migration" "$groups"; then
+        if [ "${CONFIG_EFI}" == "y" ]; then
+            print_result "SKIP" $testname "" "migration tests are not supported with efi"
+            return 2
+        fi
         cmdline="MIGRATION=yes $cmdline"
     fi
     if find_word "panic" "$groups"; then
-- 
2.40.1


