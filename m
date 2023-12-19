Return-Path: <kvm+bounces-4810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7947881888D
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 14:23:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F25F3B23184
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 13:23:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CABBB1945C;
	Tue, 19 Dec 2023 13:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O+c0n8tA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8681018EAE
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 13:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702992197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=auyFLP+RINfVloDWaIGPXRbxPl1SShs43HZ5xQHSJy0=;
	b=O+c0n8tAVqCfj3wpb4eRTxFCFh8jz0bFoye9SNpDZZWSfZOO+2B+91nCplFGs1/7VkDN7N
	F6Nw3UJskCzeIqoWcsFTjMqtDodE7nmeNpGlcwKoTntg6zriOMqqxIxZPh0aHQljugjant
	NcJz8CmPFzVJL4ag73gWNr7qAoyBT84=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-428-SNfq1JJdPm2SWyskIjsSEw-1; Tue, 19 Dec 2023 08:23:16 -0500
X-MC-Unique: SNfq1JJdPm2SWyskIjsSEw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1ED2868A00;
	Tue, 19 Dec 2023 13:23:15 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.39.192.219])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A1E0F1121306;
	Tue, 19 Dec 2023 13:23:14 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH] scripts/pretty_print_stacks.py: Silence warning from Python 3.12
Date: Tue, 19 Dec 2023 14:23:13 +0100
Message-ID: <20231219132313.31107-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Python 3.12 complains:

 ./scripts/pretty_print_stacks.py:41: SyntaxWarning:
  invalid escape sequence '\?'
  m = re.match(b'(.*) at (.*):(([0-9]+)|\?)([^:]*)', line)

Switch to a raw string to silence the problem.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 scripts/pretty_print_stacks.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/pretty_print_stacks.py b/scripts/pretty_print_stacks.py
index d990d300..5bce84fc 100755
--- a/scripts/pretty_print_stacks.py
+++ b/scripts/pretty_print_stacks.py
@@ -38,7 +38,7 @@ def pretty_print_stack(binary, line):
         return
 
     for line in out.splitlines():
-        m = re.match(b'(.*) at (.*):(([0-9]+)|\?)([^:]*)', line)
+        m = re.match(r'(.*) at (.*):(([0-9]+)|\?)([^:]*)', line)
         if m is None:
             puts('%s\n' % line)
             return
-- 
2.43.0


