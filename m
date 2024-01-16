Return-Path: <kvm+bounces-6320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB1882E9BA
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 07:59:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 108DD283C1E
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 06:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF96210A2B;
	Tue, 16 Jan 2024 06:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iZ31Gg/d"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE8C10A1B
	for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 06:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705388331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tqq6wYIFEnT+LQV2qUAqyFES2NYVYOIc6yshT9Yaoeg=;
	b=iZ31Gg/d+N+QmJHMxy6ZeNEdo9uY6qhWq1AzlnG7HiJ66SeQC7gSiAqL/2bVe68GLiZ+GD
	fk2hmKT+0jE/gJUta8oMEqXqRRAAmhblKdRrv4BZxn8lEcdeRSpcDuh62UYvUDBRkgvwSg
	mPRJ81LGf+/ffUfkp0TCKWAdGnW+Af4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-286-_Kqv1i-AMLK86Exz2t7-UA-1; Tue, 16 Jan 2024 01:58:48 -0500
X-MC-Unique: _Kqv1i-AMLK86Exz2t7-UA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A48D848942;
	Tue, 16 Jan 2024 06:58:48 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4E48E3C25;
	Tue, 16 Jan 2024 06:58:48 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Nico Boehr <nrb@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Ricardo Koller <ricarkol@google.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 1/3] runtime: Fix the missing last_line
Date: Tue, 16 Jan 2024 01:58:44 -0500
Message-Id: <20240116065847.71623-2-shahuang@redhat.com>
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

The last_line is deleted by the 2607d2d6 ("arm64: Add an efi/run script").
This lead to when SKIP test, the reason is missing. Fix the problem by
adding last_line back.

Fixes: 2607d2d6 ("arm64: Add an efi/run script")
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 scripts/runtime.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index fc156f2f..c73fb024 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -149,7 +149,7 @@ function run()
         fi
 
         if [ ${skip} == true ]; then
-            print_result "SKIP" $testname "" "$last_line"
+            print_result "SKIP" $testname "" "$(tail -1 <<<"$log")"
             return 77
         fi
     }
-- 
2.40.1


