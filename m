Return-Path: <kvm+bounces-18602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDF208D7CF8
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 10:02:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A829828435C
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 08:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0740153E2B;
	Mon,  3 Jun 2024 08:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C31BTZme"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875ED482D8
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 08:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717401756; cv=none; b=HJxXw5xTbxUQCFa7YyjJyRJ5wKcrgzfhk4qYv1C/oULXXv3+Z8LgRB85tP/YLdYKzU3DNWFQAv3AD4STICnqQP4Tnuf7oCBESib4t4D6yuLGYQy2DnXgDiVFR30WGjQlfoRzgZrBTP7QjakcD41nESKkndf/25LqChbY9aDGqDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717401756; c=relaxed/simple;
	bh=yWTQCmiw4llmYam/bGTKz7lHQI6y+oAREBxoG7gqRkc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uEoBUgARKgZo/JOHxyuw9PiYeig0NfXzCsOFFiBl0K8tNtsphx4h0ygtcy9VYJHgdKMrO8rLwBNf0otqAe/POoll0qE12HFiXPyfaiYRYod8q22iohFGTp5VBF10qHpGQlhe1VZUCYrYyaePSp58PvOC/KzfTzob/SiXpy6+WWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C31BTZme; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717401753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ScFxO/z1YMI1dmk8FoS6VTnuVsBY6a6Y1MFjYPtT/MQ=;
	b=C31BTZmefpoZt7eIldLRgZCfQb4x9R2uGCxEKM0rMaWh0wptblhw9C9HuwQehkXwGU/igF
	PwfkUGJmY7j68iwsvpesF9MijaXk7yXcwnQUOUyQL3+k9n72r9DsQeNBBSHMHXY5q/E0jw
	4Kuec8zrd/qxO4vAPumwQKG3WHxB4/c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-KSZA082aM9ert8dtDWV_rw-1; Mon, 03 Jun 2024 04:02:31 -0400
X-MC-Unique: KSZA082aM9ert8dtDWV_rw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35582800281;
	Mon,  3 Jun 2024 08:02:31 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.39.192.65])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CF2B4C15BFC;
	Mon,  3 Jun 2024 08:02:29 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>,
	linux-s390@vger.kernel.org,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [kvm-unit-tests PATCH] MAINTAINERS: Add scripts/s390x/ to the s390x section
Date: Mon,  3 Jun 2024 10:02:28 +0200
Message-ID: <20240603080228.150742-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Make sure that the right people are CC:-ed when changing the
script in scripts/s390x/.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a2fa437d..6ceea991 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -112,6 +112,7 @@ R: Thomas Huth <thuth@redhat.com>
 L: linux-s390@vger.kernel.org
 F: s390x/
 F: lib/s390x/
+F: scripts/s390x/
 
 X86
 M: Paolo Bonzini <pbonzini@redhat.com>
-- 
2.45.1


