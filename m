Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FDF1FBE95
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 20:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730421AbgFPS4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 14:56:38 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:47736 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729994AbgFPS4e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 14:56:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592333793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:in-reply-to:in-reply-to:references:references;
        bh=gI8VGlGSnMQyE03VP9aqGEe1Ss4f/jEXIJkRru5nAI0=;
        b=bbrH74ioRNDpfWMWmwgBMvrGOSpEzDagMJPAMoJYkKlhEVbF1rQVysukm+I0h4FGbRNMIB
        LdIw7PNn5tAt0IHPVaTvYZZ0DAtvb5fIYyGceZ4YEVFivmPosj8ot2isdPM/GBmL/okCOy
        bNcPMjAlfZgvhSWtqFl184+SnEeQVQc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-bp5IqzFENWC7hdZHdySVVw-1; Tue, 16 Jun 2020 14:56:31 -0400
X-MC-Unique: bp5IqzFENWC7hdZHdySVVw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 890F110AB64C
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 18:56:30 +0000 (UTC)
Received: from thuth.com (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B01037CAA8;
        Tue, 16 Jun 2020 18:56:29 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PULL 04/12] Always compile the kvm-unit-tests with -fno-common
Date:   Tue, 16 Jun 2020 20:56:14 +0200
Message-Id: <20200616185622.8644-5-thuth@redhat.com>
In-Reply-To: <20200616185622.8644-1-thuth@redhat.com>
References: <20200616185622.8644-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new GCC v10 uses -fno-common by default. To avoid that we commit
code that declares global variables twice and thus fails to link with
the latest version, we should also compile with -fno-common when using
older versions of the compiler. However, this now also means that we
can not play the trick with the common auxinfo struct anymore. Thus
declare it as extern in the header now and link auxinfo.c on x86, too.

Message-Id: <20200514192626.9950-6-thuth@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 Makefile            | 2 +-
 lib/auxinfo.h       | 3 +--
 x86/Makefile.common | 1 +
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 754ed65..3ff2f91 100644
--- a/Makefile
+++ b/Makefile
@@ -49,7 +49,7 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
 cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
               > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
 
-COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing
+COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing -fno-common
 COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
 COMMON_CFLAGS += -Wignored-qualifiers -Werror
 
diff --git a/lib/auxinfo.h b/lib/auxinfo.h
index 08b96f8..a46a1e6 100644
--- a/lib/auxinfo.h
+++ b/lib/auxinfo.h
@@ -13,7 +13,6 @@ struct auxinfo {
 	unsigned long flags;
 };
 
-/* No extern!  Define a common symbol.  */
-struct auxinfo auxinfo;
+extern struct auxinfo auxinfo;
 #endif
 #endif
diff --git a/x86/Makefile.common b/x86/Makefile.common
index ab67ca0..2ea9c9f 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -5,6 +5,7 @@ all: directories test_cases
 cflatobjs += lib/pci.o
 cflatobjs += lib/pci-edu.o
 cflatobjs += lib/alloc.o
+cflatobjs += lib/auxinfo.o
 cflatobjs += lib/vmalloc.o
 cflatobjs += lib/alloc_page.o
 cflatobjs += lib/alloc_phys.o
-- 
2.18.1

