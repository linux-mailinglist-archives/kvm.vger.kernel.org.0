Return-Path: <kvm+bounces-56184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9DF7B3ABB6
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 22:37:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FB555602DF
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 20:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07535288CA3;
	Thu, 28 Aug 2025 20:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QVPEKu+n"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC3727B330
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 20:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756413413; cv=none; b=NI/BK6EdSAQAgAGFY3lDe6dK2W0D/FYqUJw6z/Tnm2SGd1xTlc8ppO5N5k5BZyP6CW/9ZN9/tI7HUvDxcJMch2oA+joc/g949B6/9UQJziXQxUUGnIYqXoDyBGHPYo9tdPU4afWhRVFlQS67YXfnr21nbjXGgHUmQjSddQM8cKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756413413; c=relaxed/simple;
	bh=rUfxaTF48nEGUV10uSSzXEUdMJvhSqNtA2pbhDCY+h4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NuT9yHRy6Yhi/WeiEbvvzz9UIkQPFQZYSVyfsUimda86i1f/Z+tVSbYtHBhnCoXo/LzgnicShKunxDsLCjPaUQB6cYuvQuTsMEU/qYgeqrqjjNRyxngNjhLt+J0k4ZCjqQEE00yL6HtNhF29ct8XsSv7651122dhq5W0IoCbtZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QVPEKu+n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756413410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iMSYCMOvfWZn97rU63Rxs44+GYsNMV+1UH9H7cieIcw=;
	b=QVPEKu+ni3Be/+fD1CRQmnsnEfusYrdVGq9A6rYemVWKQNHiYHRKuFUrGcQwZYld+A/4c8
	yZNqK2QdccFb86N1tVr2S+V6J/t8jEZs2iydVXkVkVy6y8fN/9Rs+q5A47lwB2DX5QRzZa
	3J+c2FSI3K73VNBzg5ej3ec+f7aqbqE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-530-yAxcOyiTNdaCtDJoEL_0TA-1; Thu,
 28 Aug 2025 16:36:47 -0400
X-MC-Unique: yAxcOyiTNdaCtDJoEL_0TA-1
X-Mimecast-MFC-AGG-ID: yAxcOyiTNdaCtDJoEL_0TA_1756413406
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3EEB918003FD;
	Thu, 28 Aug 2025 20:36:45 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.64.127])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D58691800447;
	Thu, 28 Aug 2025 20:36:42 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Alex Mastro <amastro@fb.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] docs: proc.rst: Fix VFIO Device title formatting
Date: Thu, 28 Aug 2025 14:36:24 -0600
Message-ID: <20250828203629.283418-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Title underline is one character too short.

Cc: Alex Mastro <amastro@fb.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/all/20250828123035.2f0c74e7@canb.auug.org.au
Fixes: 1e736f148956 ("vfio/pci: print vfio-device syspath to fdinfo")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

To be applied through vfio next branch.

 Documentation/filesystems/proc.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index ed8d23b677ca..ff09f668cdeb 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -2167,7 +2167,7 @@ where 'size' is the size of the DMA buffer in bytes. 'count' is the file count o
 the DMA buffer file. 'exp_name' is the name of the DMA buffer exporter.
 
 VFIO Device files
-~~~~~~~~~~~~~~~~
+~~~~~~~~~~~~~~~~~
 
 ::
 
-- 
2.51.0


