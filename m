Return-Path: <kvm+bounces-31736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25BE39C6EF4
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 13:22:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE6322828B7
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 12:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 779F6202634;
	Wed, 13 Nov 2024 12:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="crUAuBVK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29B5200B82
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 12:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731500433; cv=none; b=s7TofBQB/wV0GgkPJw3UptBXLLnNmPUs8UVdKmUH+SQniBQdXgMpZ24dT3vtqpt1ffIlhC58Zl3tFTWovqonJfHqaXyopb4tzHDifMMZxVCf079F3MVD5vUYGn0vlLT83xiic93GQ5gQGI1vQlmjeucKRgkQiYgyC/HGVLYzV+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731500433; c=relaxed/simple;
	bh=MyXspHy8E56OmrrDkXPOStxWUk3a44yzuN2HGnHHOv8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WZMjhRJ0l+aI5wH8jKY4ZtWQLBaHnLA14CzXG7c2LuizMJ16IMS9A8juCcC6Q8EBWiOrG4FsDDZeyVwxFO0toff0BM0GlqV6MlIzED19ddIWQD/ziorqdL4lIDCmPlnmfQ5aiU2R2hD4H3nJbqscJf8DxGpWc7Y0WfkioDNU8Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=crUAuBVK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731500430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FUMezApKSDMzpHEt4BfAFjklFDXYA4Tg9HM+jTPB9Js=;
	b=crUAuBVKO7ctssgCF3r2TQsu96g8yon+PlSAfVnKPtkFzzTE65laS79UAIezkwpqvyoUBm
	Qomv11LSoEGUsoIOgxKGX6T4qwioEVtubFWrEl+QD3YYRxqlrZBVx+HSQmH35f0v7IQe/P
	jYdP/7q7LDf0RCXRu1k1dy+g0mMzjLw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-546-RCxpWcQ9NCmr3WU0Abk6Cw-1; Wed,
 13 Nov 2024 07:20:27 -0500
X-MC-Unique: RCxpWcQ9NCmr3WU0Abk6Cw-1
X-Mimecast-MFC-AGG-ID: RCxpWcQ9NCmr3WU0Abk6Cw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0C2E11956083;
	Wed, 13 Nov 2024 12:20:26 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ED9B319560A3;
	Wed, 13 Nov 2024 12:20:24 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] Documentation: KVM: fix malformed table
Date: Wed, 13 Nov 2024 07:20:24 -0500
Message-ID: <20241113122024.389632-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 5f6a3badbb74 ("KVM: x86/mmu: Mark page/folio accessed only when zapping leaf SPTEs")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/locking.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index f463ac42ac7a..c56d5f26c750 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -157,8 +157,8 @@ writable between reading spte and updating spte. Like below case:
 +-------------------------------------------------------------------------+
 | At the beginning::                                                      |
 |                                                                         |
-|	spte.W = 0                                                              |
-|	spte.Accessed = 1                                                       |
+|  spte.W = 0                                                             |
+|  spte.Accessed = 1                                                      |
 +-------------------------------------+-----------------------------------+
 | CPU 0:                              | CPU 1:                            |
 +-------------------------------------+-----------------------------------+
-- 
2.43.5


