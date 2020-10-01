Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0367B27FA27
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 09:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731484AbgJAHW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 03:22:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38856 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731444AbgJAHW4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 03:22:56 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601536974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=bp7eVt/GZmB7ydFRGprxtKVGtrQbZrgzniSBsu3qoQQ=;
        b=V+m8NB7o/4rCjkgqnQRczrwsmbWFUlFRoQAwhgzhyaT6xb113k6T5+diUzJbm1neK/zSJl
        xO5jQxvv9tsaX2MoLz5wKXLmhHk+MCaf5Z9twgLKlMep0py9wHcmAzof6b1FgEl64aH5iB
        xusuIAmikJFPF+qRajXvrjb6PIItCZo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-8Cm5oT-yPm6OfcYbovQEcg-1; Thu, 01 Oct 2020 03:22:48 -0400
X-MC-Unique: 8Cm5oT-yPm6OfcYbovQEcg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3869A801AC2
        for <kvm@vger.kernel.org>; Thu,  1 Oct 2020 07:22:47 +0000 (UTC)
Received: from thuth.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E6CCB60BF1;
        Thu,  1 Oct 2020 07:22:45 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, lvivier@redhat.com
Subject: [PATCH v2 4/7] kbuild: fix asm-offset generation to work with clang
Date:   Thu,  1 Oct 2020 09:22:31 +0200
Message-Id: <20201001072234.143703-5-thuth@redhat.com>
In-Reply-To: <20201001072234.143703-1-thuth@redhat.com>
References: <20201001072234.143703-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

