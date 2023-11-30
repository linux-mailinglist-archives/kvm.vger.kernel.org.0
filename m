Return-Path: <kvm+bounces-2841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BA867FE7A8
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 04:30:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A62801C20AC5
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 03:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD3A613FF6;
	Thu, 30 Nov 2023 03:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DzNQbfWH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9225010D0
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 19:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701315010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ww/G23VY72lofFkj/eKFHI/9f21iUPOtr0q5DiHkEsk=;
	b=DzNQbfWHJDwGuUfIQyHMJQ8cvrkWqyQf2+frhvOue2+jjvcPS99/O+EqzJQMD22tmalgg4
	cFrO2ADk2aTrPaLCtlCOKikUZNvwOsDU8mSHTyvrTrPqw30tZbwoQofqlflLjr6idhdk8J
	FSKtVV+/uTD8CrqlvzA9bVBP/QQV6Ss=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-160-UC0XSGceN8aF_tBiCGLWKQ-1; Wed,
 29 Nov 2023 22:30:06 -0500
X-MC-Unique: UC0XSGceN8aF_tBiCGLWKQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 928643C0008D;
	Thu, 30 Nov 2023 03:30:05 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 88D94112130C;
	Thu, 30 Nov 2023 03:30:05 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Nico Boehr <nrb@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 1/3] runtime: Fix the missing last_line
Date: Wed, 29 Nov 2023 22:29:38 -0500
Message-Id: <20231130032940.2729006-2-shahuang@redhat.com>
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

The last_line is deleted by the 2607d2d6 ("arm64: Add an efi/run script").
This lead to when SKIP test, the reason is missing. Fix the problem by
adding last_line back.

Fixes: 2607d2d6 ("arm64: Add an efi/run script")
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


