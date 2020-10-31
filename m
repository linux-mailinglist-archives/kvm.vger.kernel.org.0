Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755252A1843
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 15:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgJaOlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Oct 2020 10:41:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727842AbgJaOlB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 31 Oct 2020 10:41:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604155260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/b9J+vxOttrgBJE1uXeDHgYSPta6eEMpYMEoomCmbKc=;
        b=TZL3hv9zUjxTbVsi72GXapPQP1GQ9YJPaT7aMcKJfwaY2dCkwgle6Wc4lbMuUCSUTm4vkc
        ZXyNganIShiIDYqcOdWUdNv7hEHJw/nQXBsbrChx+F3TB5FFoBKVotPoBwTQu8uf5mpY6+
        pouo7lsNeRsldYQuQ9tLJXCzXlzrJdE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-sNyNJntKNrmgi-OeUaNofw-1; Sat, 31 Oct 2020 10:40:54 -0400
X-MC-Unique: sNyNJntKNrmgi-OeUaNofw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFFF9425F0;
        Sat, 31 Oct 2020 14:40:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7207B19C66;
        Sat, 31 Oct 2020 14:40:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Subject: [PATCH kvm-unit-tests] reduce number of iterations for apic test
Date:   Sat, 31 Oct 2020 10:40:52 -0400
Message-Id: <20201031144052.3982250-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test generally fails quite quickly, 1 million iterations is
a lot and, on Azure cloud hyperv instance Standard_D48_v3, it will
take about 45 seconds to run this apic test.

It takes even longer (about 150 seconds) to run inside a KVM instance
VM.Standard2.1 on Oracle cloud.

Reported-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/apic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/apic.c b/x86/apic.c
index 82c6ab2..23508ad 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -437,7 +437,7 @@ static void test_multiple_nmi(void)
     handle_irq(2, multiple_nmi_handler);
     handle_irq(0x44, flush_nmi);
     on_cpu_async(1, kick_me_nmi, 0);
-    for (i = 0; i < 1000000; ++i) {
+    for (i = 0; i < 100000; ++i) {
 	nmi_flushed = false;
 	nmi_received = 0;
 	++cpu0_nmi_ctr1;
-- 
2.26.2

