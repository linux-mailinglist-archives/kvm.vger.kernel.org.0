Return-Path: <kvm+bounces-52094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 426B2B01497
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 09:27:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A655C1884CB7
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 07:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFDF41F1534;
	Fri, 11 Jul 2025 07:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HdhraVeW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AC61EE033
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 07:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752218772; cv=none; b=Ex4hdrVEJ/TVUPL7GuI4ERpoORSrXriHNk7v7oXk2cbSsxnq+rnb6gamNSWseRXXi5ZXH62NljZawpchdMoqp7G8frddY2g60fRipLKDm6j8C+65G0dhY/0/VD19K09WUC225QdKsb7hEOzU5lOdhI4WFX12hkay3eJEdYMcxzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752218772; c=relaxed/simple;
	bh=hMsl64gby8Q0twdUtCV+g0c/6bX4OupItL/pvuQ6z/E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z8/uNvy+mWB1RPC6uiwNpk+xY9tTkij44vcMDSIlIE4OTmWvH5VoQe+irAUz2a2BfhW2USDfpnaOL9OOZcYkR0a9vCy5juVqql/ymkXKXxEEWzWYRKVFLw89AdIh8KC4kEVZ4YS9omjwY23ymBrit5FLKKaUe2tEdBQ4OWweAZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HdhraVeW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752218768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QSPK6pFRzoDLrBX1H6YdlGjEz0PyKwAT8n2cjPzr4Lo=;
	b=HdhraVeWd7m+MbOJVd6mY1DTIbtW1/3G12weIJDtIe/ofO81WDihfdw88KD5E6BxgmiBu7
	47WEAeunOsUaLlN+naVUZkwdlXcK/GYb9U3mQe/zIWEQ08AgxHzOjJ3Y4g3g3jAv8CfE8R
	DqNgTTTNrRXuS0L3ZvKKLERXZEspYps=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-619-WWcPSqBrOKO-WQ_t2gZxcg-1; Fri,
 11 Jul 2025 03:26:03 -0400
X-MC-Unique: WWcPSqBrOKO-WQ_t2gZxcg-1
X-Mimecast-MFC-AGG-ID: WWcPSqBrOKO-WQ_t2gZxcg_1752218762
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 13FEA180034E;
	Fri, 11 Jul 2025 07:26:02 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.45.224.54])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5EE0E30001A1;
	Fri, 11 Jul 2025 07:25:54 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Thomas Gleixner <tglx@linutronix.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-spdx@vger.kernel.org
Subject: [PATCH v3] powerpc: Drop GPL boilerplate text with obsolete FSF address
Date: Fri, 11 Jul 2025 09:25:53 +0200
Message-ID: <20250711072553.198777-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Thomas Huth <thuth@redhat.com>

The FSF does not reside in the Franklin street anymore, so we should not
request the people to write to this address. Fortunately, these header
files already contain a proper SPDX license identifier, so it should be
fine to simply drop all of this license boilerplate code here.

Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 v3: Renamed the patch from "powerpc: Replace the obsolete address of
     the FSF" and drop the boilerplate text instead of replacing the
     address.

 arch/powerpc/include/uapi/asm/eeh.h      | 13 -------------
 arch/powerpc/include/uapi/asm/kvm.h      | 13 -------------
 arch/powerpc/include/uapi/asm/kvm_para.h | 13 -------------
 arch/powerpc/include/uapi/asm/ps3fb.h    | 13 -------------
 4 files changed, 52 deletions(-)

diff --git a/arch/powerpc/include/uapi/asm/eeh.h b/arch/powerpc/include/uapi/asm/eeh.h
index 28186071fafc4..3b5c47ff3fc4b 100644
--- a/arch/powerpc/include/uapi/asm/eeh.h
+++ b/arch/powerpc/include/uapi/asm/eeh.h
@@ -1,18 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License, version 2, as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
- *
  * Copyright IBM Corp. 2015
  *
  * Authors: Gavin Shan <gwshan@linux.vnet.ibm.com>
diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
index eaeda001784eb..077c5437f5219 100644
--- a/arch/powerpc/include/uapi/asm/kvm.h
+++ b/arch/powerpc/include/uapi/asm/kvm.h
@@ -1,18 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License, version 2, as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
- *
  * Copyright IBM Corp. 2007
  *
  * Authors: Hollis Blanchard <hollisb@us.ibm.com>
diff --git a/arch/powerpc/include/uapi/asm/kvm_para.h b/arch/powerpc/include/uapi/asm/kvm_para.h
index a809b1b44ddfe..ac596064d4c76 100644
--- a/arch/powerpc/include/uapi/asm/kvm_para.h
+++ b/arch/powerpc/include/uapi/asm/kvm_para.h
@@ -1,18 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License, version 2, as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
- *
  * Copyright IBM Corp. 2008
  *
  * Authors: Hollis Blanchard <hollisb@us.ibm.com>
diff --git a/arch/powerpc/include/uapi/asm/ps3fb.h b/arch/powerpc/include/uapi/asm/ps3fb.h
index fd7e3a0d35d57..b1c6b0cd9e802 100644
--- a/arch/powerpc/include/uapi/asm/ps3fb.h
+++ b/arch/powerpc/include/uapi/asm/ps3fb.h
@@ -2,19 +2,6 @@
 /*
  * Copyright (C) 2006 Sony Computer Entertainment Inc.
  * Copyright 2006, 2007 Sony Corporation
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published
- * by the Free Software Foundation; version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
 #ifndef _ASM_POWERPC_PS3FB_H_
-- 
2.50.0


