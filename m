Return-Path: <kvm+bounces-53376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD025B10B6B
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 15:31:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6249AE778B
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 13:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA4F22D1900;
	Thu, 24 Jul 2025 13:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X3oUb79D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EF35FEE6
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 13:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753363872; cv=none; b=UxFZ65cAS3kdeBzOX5LwrEUo2ADiq0lNxy9DFNY3axQq1ZgWIMtgDwmpArvTm4g849/Y2FCFmEJbIU9RuCqGQ1S0p6j4roAh6a857dK4hHP8DMqBBpMByqFvzekqJQCgR0N52piOhkGFS34YOV7muUxRvlRQY7diPhBgmuHzolU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753363872; c=relaxed/simple;
	bh=0WJ+3UFOLj0EjL30KYoYtpD8DQbBcXcXMSak85Blh+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2LXx2HtCqWqhwOoBj7ZZUfV30umxaVaYPBsoh/cJJjnhg4QRu7lZ/LCwQ8NQjWEqYfRwdd8gxiMWR2oht5PcD7CmOawFims+V18/81z8AaGDaBPmk0VOZ4lZJYXUaF34rX8piZ9T+Mg9itU0x5yfiFzVc98jMsmKWBT4IMUh+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X3oUb79D; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753363870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=duaQyAVRbkBAk+diiySFaCJuDFBkhYfgf7V2EYmBFeg=;
	b=X3oUb79DYDcLzxb+v+PgCJJz3U794lxf/PekDP0JSkGQCAV7NY883uKOxxaMm3suzjHY2v
	N3Hdr30aXW0nK5v4LoxKUjbPkpX/rkktSonTbsqcz2IWrwJHLsYhPf+UfB8eX67jqgpHDV
	wpbZ6W1gl57TkDxAnoGSsUzY0XwTcJ4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-244-3tnBbaBgP7aCulIIFfy5Gg-1; Thu,
 24 Jul 2025 09:31:08 -0400
X-MC-Unique: 3tnBbaBgP7aCulIIFfy5Gg-1
X-Mimecast-MFC-AGG-ID: 3tnBbaBgP7aCulIIFfy5Gg_1753363867
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 67B361800360;
	Thu, 24 Jul 2025 13:31:07 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.45.224.82])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F3211300018D;
	Thu, 24 Jul 2025 13:30:59 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 2/3] .gitlab-ci.yml: Add the s390x panic-loop tests to the CI
Date: Thu, 24 Jul 2025 15:30:50 +0200
Message-ID: <20250724133051.44045-3-thuth@redhat.com>
In-Reply-To: <20250724133051.44045-1-thuth@redhat.com>
References: <20250724133051.44045-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Thomas Huth <thuth@redhat.com>

Now that these tests should work reliable, we should also run them
in our CI.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index aa69ca59..7e3d4661 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -517,6 +517,8 @@ s390x-kvm:
       migration-sck
       migration-skey-parallel
       migration-skey-sequential
+      panic-loop-extint
+      panic-loop-pgm
       pfmf
       sclp-1g
       sclp-3g
-- 
2.50.1


