Return-Path: <kvm+bounces-2870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F61E7FEB79
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:09:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 464882825CD
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 935243B7B3;
	Thu, 30 Nov 2023 09:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NSOgs5ns"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4500310E3
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b2BrihdLe4pGZEbs5jmiizmBAK+7Wuy8kKIYMt7+5/c=;
	b=NSOgs5nsNVTtbl8OfmmjY7JUS7YlHJm2AI6jK3NqPGrZa/WUxO2O/EVue0p3M9MAGT8d5E
	89fnlEDL/lEmKWrGqzudJLuPE/eSycgA7AH/djMkjNKqUS3XPMGWUhNfgTDI/Jr+L6mbha
	/iuuyfjyEL5/JCTM5I5VFYLaVxxMxZ0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615--bdy0aOIPie9UH3lJtZuIg-1; Thu, 30 Nov 2023 04:07:56 -0500
X-MC-Unique: -bdy0aOIPie9UH3lJtZuIg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7DA084ACA0;
	Thu, 30 Nov 2023 09:07:55 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B6BE61C060AE;
	Thu, 30 Nov 2023 09:07:55 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Nico Boehr <nrb@linux.ibm.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Nadav Amit <namit@vmware.com>,
	kvm@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
Subject: [kvm-unit-tests PATCH v1 01/18] Makefile: Define __ASSEMBLY__ for assembly files
Date: Thu, 30 Nov 2023 04:07:03 -0500
Message-Id: <20231130090722.2897974-2-shahuang@redhat.com>
In-Reply-To: <20231130090722.2897974-1-shahuang@redhat.com>
References: <20231130090722.2897974-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

From: Alexandru Elisei <alexandru.elisei@arm.com>

There are 25 header files today (found with grep -r "#ifndef __ASSEMBLY__)
with functionality relies on the __ASSEMBLY__ prepocessor constant being
correctly defined to work correctly. So far, kvm-unit-tests has relied on
the assembly files to define the constant before including any header
files which depend on it.

Let's make sure that nobody gets this wrong and define it as a compiler
constant when compiling assembly files. __ASSEMBLY__ is now defined for all
.S files, even those that didn't set it explicitely before.

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 Makefile           | 5 ++++-
 arm/cstart.S       | 1 -
 arm/cstart64.S     | 1 -
 powerpc/cstart64.S | 1 -
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 602910dd..27ed14e6 100644
--- a/Makefile
+++ b/Makefile
@@ -92,6 +92,9 @@ CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
 
 autodepend-flags = -MMD -MP -MF $(dir $*).$(notdir $*).d
 
+AFLAGS  = $(CFLAGS)
+AFLAGS += -D__ASSEMBLY__
+
 LDFLAGS += -nostdlib $(no_pie) -z noexecstack
 
 $(libcflat): $(cflatobjs)
@@ -113,7 +116,7 @@ directories:
 	@mkdir -p $(OBJDIRS)
 
 %.o: %.S
-	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+	$(CC) $(AFLAGS) -c -nostdlib -o $@ $<
 
 -include */.*.d */*/.*.d
 
diff --git a/arm/cstart.S b/arm/cstart.S
index 3dd71ed9..b24ecabc 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -5,7 +5,6 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
-#define __ASSEMBLY__
 #include <auxinfo.h>
 #include <asm/assembler.h>
 #include <asm/thread_info.h>
diff --git a/arm/cstart64.S b/arm/cstart64.S
index bc2be45a..a8ad6dc8 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -5,7 +5,6 @@
  *
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
-#define __ASSEMBLY__
 #include <auxinfo.h>
 #include <asm/asm-offsets.h>
 #include <asm/assembler.h>
diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
index 34e39341..fa32ef24 100644
--- a/powerpc/cstart64.S
+++ b/powerpc/cstart64.S
@@ -5,7 +5,6 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
-#define __ASSEMBLY__
 #include <asm/hcall.h>
 #include <asm/ppc_asm.h>
 #include <asm/rtas.h>
-- 
2.40.1


