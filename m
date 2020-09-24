Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F8C27766A
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 18:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgIXQQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 12:16:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51803 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726906AbgIXQQy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 12:16:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600964213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=bp7eVt/GZmB7ydFRGprxtKVGtrQbZrgzniSBsu3qoQQ=;
        b=fl+oCYa9nDg8O38wF40NI5BovYH5OYM3yY13SRIU8cYo2+TYUMU0gxthcVAIgjfrRg5Yem
        gOf85+qrmmiPnLgLx/dUR9RCh8DPqa06+TYEizzwMeQBYMVGtQxCdLwAknjCXG3u5HtCcW
        WaOu3WIo/WcpvGajaqW7xGBkWzXeORI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-BKyOnfZNOHSev0VG_pHwGg-1; Thu, 24 Sep 2020 12:16:46 -0400
X-MC-Unique: BKyOnfZNOHSev0VG_pHwGg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65311100746C;
        Thu, 24 Sep 2020 16:16:45 +0000 (UTC)
Received: from thuth.com (ovpn-113-113.ams2.redhat.com [10.36.113.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86D1073662;
        Thu, 24 Sep 2020 16:16:35 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Drew Jones <drjones@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH 5/9] kbuild: fix asm-offset generation to work with clang
Date:   Thu, 24 Sep 2020 18:16:08 +0200
Message-Id: <20200924161612.144549-6-thuth@redhat.com>
In-Reply-To: <20200924161612.144549-1-thuth@redhat.com>
References: <20200924161612.144549-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KBuild abuses the asm statement to write to a file and
clang chokes about these invalid asm statements. Hack it
even more by fooling this is actual valid asm code.

This is an adaption of the Linux kernel commit cf0c3e68aa81f992b0
which in turn is based on a patch for the U-Boot:
  http://patchwork.ozlabs.org/patch/375026/

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/kbuild.h            | 6 +++---
 scripts/asm-offsets.mak | 5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/lib/kbuild.h b/lib/kbuild.h
index ab99db6..79644e5 100644
--- a/lib/kbuild.h
+++ b/lib/kbuild.h
@@ -1,8 +1,8 @@
 #ifndef _KBUILD_H_
 #define _KBUILD_H_
 #define DEFINE(sym, val) \
-	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
+	asm volatile("\n.ascii \"->" #sym " %0 " #val "\"" : : "i" (val))
 #define OFFSET(sym, str, mem)	DEFINE(sym, offsetof(struct str, mem))
-#define COMMENT(x)		asm volatile("\n->#" x)
-#define BLANK()			asm volatile("\n->" : : )
+#define COMMENT(x)		asm volatile("\n.ascii \"->#" x "\"")
+#define BLANK()			asm volatile("\n.ascii \"->\"" : : )
 #endif
diff --git a/scripts/asm-offsets.mak b/scripts/asm-offsets.mak
index b35da09..7b64162 100644
--- a/scripts/asm-offsets.mak
+++ b/scripts/asm-offsets.mak
@@ -8,10 +8,11 @@
 #
 
 define sed-y
-	"/^->/{s:->#\(.*\):/* \1 */:; \
+	's:^[[:space:]]*\.ascii[[:space:]]*"\(.*\)".*:\1:; \
+	/^->/{s:->#\(.*\):/* \1 */:; \
 	s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 \2 /* \3 */:; \
 	s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; \
-	s:->::; p;}"
+	s:->::; p;}'
 endef
 
 define make_asm_offsets
-- 
2.18.2

