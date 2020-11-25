Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6412C4965
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 21:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbgKYU5B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 15:57:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60064 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730546AbgKYU5B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 15:57:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606337820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UZZQRbSxpJbfML8IkKeWrdc8btDAgjJ9BXbeofnw+dE=;
        b=BOi//STMfN4gh/2ehf8/LmpUb6c7bA06PhvheaIo3EH38e4iSydXzctJiaslgNOdrPhMQQ
        eLsD809SAOhL/cSDbE7qpIrsTyLO8rIk1RZNrOw3ZA3WLIyCuVhck3qY0tFxAF2kmkt/jM
        gjFvZSePcUHRfT7njGq7y0uYsFu0Pko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-uPzmHt8iMk6LKtSdDdHVQg-1; Wed, 25 Nov 2020 15:56:56 -0500
X-MC-Unique: uPzmHt8iMk6LKtSdDdHVQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3F1A180E49C;
        Wed, 25 Nov 2020 20:56:54 +0000 (UTC)
Received: from localhost (unknown [10.10.67.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85F3560854;
        Wed, 25 Nov 2020 20:56:54 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Gerd Hoffmann <kraxel@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Claudio Fontana <cfontana@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 3/6] kvm: Remove kvm_available() function
Date:   Wed, 25 Nov 2020 15:56:33 -0500
Message-Id: <20201125205636.3305257-4-ehabkost@redhat.com>
In-Reply-To: <20201125205636.3305257-1-ehabkost@redhat.com>
References: <20201125205636.3305257-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The only caller can use accel_available("kvm") instead.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
Cc: Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Claudio Fontana <cfontana@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
---
 include/sysemu/arch_init.h | 1 -
 monitor/qmp-cmds.c         | 2 +-
 softmmu/arch_init.c        | 9 ---------
 3 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/include/sysemu/arch_init.h b/include/sysemu/arch_init.h
index 54f069d491..b32ce1afa9 100644
--- a/include/sysemu/arch_init.h
+++ b/include/sysemu/arch_init.h
@@ -32,7 +32,6 @@ enum {
 
 extern const uint32_t arch_type;
 
-int kvm_available(void);
 int xen_available(void);
 
 #endif
diff --git a/monitor/qmp-cmds.c b/monitor/qmp-cmds.c
index a08143b323..ac5b8a97d7 100644
--- a/monitor/qmp-cmds.c
+++ b/monitor/qmp-cmds.c
@@ -57,7 +57,7 @@ KvmInfo *qmp_query_kvm(Error **errp)
     KvmInfo *info = g_malloc0(sizeof(*info));
 
     info->enabled = kvm_enabled();
-    info->present = kvm_available();
+    info->present = accel_available("kvm");
 
     return info;
 }
diff --git a/softmmu/arch_init.c b/softmmu/arch_init.c
index 7ef32a98b9..79383c8db8 100644
--- a/softmmu/arch_init.c
+++ b/softmmu/arch_init.c
@@ -50,15 +50,6 @@ int graphic_depth = 32;
 
 const uint32_t arch_type = QEMU_ARCH;
 
-int kvm_available(void)
-{
-#ifdef CONFIG_KVM
-    return 1;
-#else
-    return 0;
-#endif
-}
-
 int xen_available(void)
 {
 #ifdef CONFIG_XEN
-- 
2.28.0

