Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E491CF1F9
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 11:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgELJzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 05:55:55 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29122 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725889AbgELJzz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 May 2020 05:55:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589277354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=Cwzs7ZbyONiuQyNUGXZ9NLj8Z/LVym301E7C5sI+GWA=;
        b=hZyLH+KoyhhiIsFg64ibeehX3BypGlSo8lHqsLXAqJzKd1l0jyecPdKZ1dVTVy0ypf5Xt1
        WV+3iDHITwcwbQ2B6g7feTIs+xCMfBdI0MggAKcANX8EfDYcCicyZOB6MbofXUNr+esUUc
        aYh3sWYPWi6e8af+jQ/eeAkEZAC6SJ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-0WQcdyPhNnivVmvrAqqiqA-1; Tue, 12 May 2020 05:55:52 -0400
X-MC-Unique: 0WQcdyPhNnivVmvrAqqiqA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD29318A076C
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 09:55:51 +0000 (UTC)
Received: from thuth.com (ovpn-112-112.ams2.redhat.com [10.36.112.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EB6F5C1D3;
        Tue, 12 May 2020 09:55:49 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     dgilbert@redhat.com
Subject: [kvm-unit-tests PATCH] Always compile the kvm-unit-tests with -fno-common
Date:   Tue, 12 May 2020 11:55:46 +0200
Message-Id: <20200512095546.25602-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new GCC v10 uses -fno-common by default. To avoid that we commit
code that declares global variables twice and thus fails to link with
the latest version, we should also compile with -fno-common when using
older versions of the compiler.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
 
-- 
2.18.1

