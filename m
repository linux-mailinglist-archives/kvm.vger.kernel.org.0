Return-Path: <kvm+bounces-4827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F0B36818B44
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 16:31:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F516285EBB
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 15:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D7331CA8A;
	Tue, 19 Dec 2023 15:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TR5yvi6R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3510B1CA85
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 15:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702999899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ctWMksUWYcEKlTzlUMuJc7NbFVx7osylg16lZ3XBPMM=;
	b=TR5yvi6R5S7Rs2r/mYBIvTUg6qEYihO25ZZuUPW2o6nVzC9i4zqFbnqXAKfSSux/nSnDiv
	KDKBAA+xGGTy7dzzkIP0YSpR+KI+37gFERw78LwcddUmsUULc3RpYiiEm+M11EwHyF/6BE
	GAVF0lXB5XwiuKjQJ46LAtioqi3itKs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-257-yZKURujwM6ObNGSrnLNm8w-1; Tue,
 19 Dec 2023 10:31:37 -0500
X-MC-Unique: yZKURujwM6ObNGSrnLNm8w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6187A3C29A66;
	Tue, 19 Dec 2023 15:31:36 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.39.192.219])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4071B2166B31;
	Tue, 19 Dec 2023 15:31:35 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH v2] scripts/pretty_print_stacks.py: Silence warning from Python 3.12
Date: Tue, 19 Dec 2023 16:31:34 +0100
Message-ID: <20231219153134.47323-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Python 3.12 complains:

 ./scripts/pretty_print_stacks.py:41: SyntaxWarning:
  invalid escape sequence '\?'
  m = re.match(b'(.*) at (.*):(([0-9]+)|\?)([^:]*)', line)

Switch to a raw byte string to silence the problem.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 v2: Use "rb" prefix

 scripts/pretty_print_stacks.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/pretty_print_stacks.py b/scripts/pretty_print_stacks.py
index d990d300..a1526d5e 100755
--- a/scripts/pretty_print_stacks.py
+++ b/scripts/pretty_print_stacks.py
@@ -38,7 +38,7 @@ def pretty_print_stack(binary, line):
         return
 
     for line in out.splitlines():
-        m = re.match(b'(.*) at (.*):(([0-9]+)|\?)([^:]*)', line)
+        m = re.match(rb'(.*) at (.*):(([0-9]+)|\?)([^:]*)', line)
         if m is None:
             puts('%s\n' % line)
             return
-- 
2.43.0


