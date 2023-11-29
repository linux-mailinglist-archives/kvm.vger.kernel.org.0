Return-Path: <kvm+bounces-2718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B1997FCD64
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 04:22:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82482B21497
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 03:22:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA7C96FB6;
	Wed, 29 Nov 2023 03:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U6Mr8+bA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97301AD
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 19:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701228096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=avS4J2IuJovZqhrdKeCYjn42GytW2g/uQGH2bJQRq0I=;
	b=U6Mr8+bAZMNvGoFSuZ+ELBhRT814DiRhewMQVMYkQQiDJUURlox7QRIbuVUs5qSjiBRNUF
	R/geaMNa70aL3hFz+CEQPs7d/bCyBd/kGEx8vP96C5noneiy48d4HBwzzAKdbcu68aE/8i
	PSgiZ+60mQgZqieSKyMO5s0l05b4p7w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-DZHphnXxMKKrXV8KmFO-Cw-1; Tue, 28 Nov 2023 22:21:31 -0500
X-MC-Unique: DZHphnXxMKKrXV8KmFO-Cw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFDA8101A529;
	Wed, 29 Nov 2023 03:21:30 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B5BF6492BFE;
	Wed, 29 Nov 2023 03:21:30 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Nico Boehr <nrb@linux.ibm.com>,
	Ricardo Koller <ricarkol@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 1/3] runtime: Fix the missing last_line
Date: Tue, 28 Nov 2023 22:21:21 -0500
Message-Id: <20231129032123.2658343-2-shahuang@redhat.com>
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

The last_line is deleted by the 2607d2d6 ("arm64: Add an efi/run script").
This lead to when SKIP test, the reason is missing. Fix the problem by
adding last_line back.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 scripts/runtime.bash | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index fc156f2f..d7054b80 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -148,6 +148,8 @@ function run()
             fi
         fi
 
+	last_line=$(tail -1 <<<"$log")
+
         if [ ${skip} == true ]; then
             print_result "SKIP" $testname "" "$last_line"
             return 77
-- 
2.40.1


