Return-Path: <kvm+bounces-53553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3992EB13E5E
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 17:31:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89E0F188ADA3
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 15:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F41C272812;
	Mon, 28 Jul 2025 15:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ge2Jh4DY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA20273D7F
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 15:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753716539; cv=none; b=gjAk7pDb2AgqPt22TkahfAwFZU8+jxcXgySSlgmXr7Cbzu1dNpq6jdbVua3ExWodz7SE7ht/gBNV1AeyYpVIuWlegbyLqSk64r+tNSbrdxIvAwdU01/0Wg7Hxpvi/c8/6XgUiXEQVgJOaV8jJhsTvwkSSPdXsI6wZAG84vXW5Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753716539; c=relaxed/simple;
	bh=Is8oyg2/N+59TfixNCdXQx2xGV4bt1ob9Dnl+MK8YP4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DsUMAfMUMM4hBSCmU98RaEQ4vbN08gG5VHfalY7KC/r1X3fusL90tH6mCnRcfHObffZ/cjAF0Xs9faFnB72HJc2/2U2G32Knt38xbtuwyqMjGNqDS4SJ+gtUN9iNX5iufNj4muboPQOOE1v1Ed19sRrdBFeq2l6SZD11/+oHVW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ge2Jh4DY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753716536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oPUbpFdhDjx738ED6Igrtjj1Rv4vpulmUrhFrKZepIo=;
	b=Ge2Jh4DYMpWy43HZW6YTWpXM/1tQZSN8yTB3UO5X/R+ycnzv0NAhGRAU0t/vre20BYfc6r
	/0bnvnxh+ibXkdEOmZFdrwe8of76akEOyBseyuYGihmJg/y5PJkXrOJ/6PPfAAJ94eKpud
	mGZn6kIx5Hu1g9//HWrnLs+nNmtOVCo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-265-5cBuTXNlOkWN7dhjZSRcgA-1; Mon,
 28 Jul 2025 11:28:52 -0400
X-MC-Unique: 5cBuTXNlOkWN7dhjZSRcgA-1
X-Mimecast-MFC-AGG-ID: 5cBuTXNlOkWN7dhjZSRcgA_1753716531
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BAB8E19560B1;
	Mon, 28 Jul 2025 15:28:50 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.45.224.117])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B0D9C19560A2;
	Mon, 28 Jul 2025 15:28:45 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-spdx@vger.kernel.org
Subject: [PATCH v2] arch/x86/kvm/ioapic: Remove license boilerplate with bad FSF address
Date: Mon, 28 Jul 2025 17:28:43 +0200
Message-ID: <20250728152843.310260-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Thomas Huth <thuth@redhat.com>

The Free Software Foundation does not reside in "59 Temple Place"
anymore, so we should not mention that address in the source code here.
But instead of updating the address to their current location, let's
rather drop the license boilerplate text here and use a proper SPDX
license identifier instead. The text talks about the "GNU *Lesser*
General Public License" and "any later version", so LGPL-2.1+ is the
right choice here.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 v2: Don't use the deprecated LGPL-2.1+ identifier

 arch/x86/kvm/ioapic.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 45dae2d5d2f1f..69b9f8e9dfcda 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: LGPL-2.1-or-later
 /*
  *  Copyright (C) 2001  MandrakeSoft S.A.
  *  Copyright 2010 Red Hat, Inc. and/or its affiliates.
@@ -8,20 +9,6 @@
  *    http://www.linux-mandrake.com/
  *    http://www.mandrakesoft.com/
  *
- *  This library is free software; you can redistribute it and/or
- *  modify it under the terms of the GNU Lesser General Public
- *  License as published by the Free Software Foundation; either
- *  version 2 of the License, or (at your option) any later version.
- *
- *  This library is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- *  Lesser General Public License for more details.
- *
- *  You should have received a copy of the GNU Lesser General Public
- *  License along with this library; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
- *
  *  Yunhong Jiang <yunhong.jiang@intel.com>
  *  Yaozu (Eddie) Dong <eddie.dong@intel.com>
  *  Based on Xen 3.1 code.
-- 
2.50.1


