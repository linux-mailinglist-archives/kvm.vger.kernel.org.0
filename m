Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC792079A1
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 18:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404796AbgFXQzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 12:55:03 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40315 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404431AbgFXQzD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Jun 2020 12:55:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593017702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Vip8xwgwmcPl38v+bIxTFJ+koVkwq3bCJZqiOBGmcbM=;
        b=YaazptKHYyTlWEKws59l85RRdbUSF/Kc0wwSxk5jbn4dbJWFPt30mh8AuGqhtSFB0o7hev
        /1/7+NDXGRUAdittrWvxLVg+mluIsrHce7Pjw20ubRRR/8uScUPOgDnDICWq5w/mL59usz
        F+Oi2V72zMWuHe1KQoWTsabvOt43kfQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-BIc9UCOsMYiMtfQknvvg5g-1; Wed, 24 Jun 2020 12:55:00 -0400
X-MC-Unique: BIc9UCOsMYiMtfQknvvg5g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2ECCC800D5C
        for <kvm@vger.kernel.org>; Wed, 24 Jun 2020 16:54:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4EC42B4AB;
        Wed, 24 Jun 2020 16:54:55 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     mcondotta@redhat.com, Thomas Huth <thuth@redhat.com>
Subject: [PATCH kvm-unit-tests] x86: move IDT away from address 0
Date:   Wed, 24 Jun 2020 12:54:55 -0400
Message-Id: <20200624165455.19266-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Address 0 is also used for the SIPI vector (which is probably something worth
changing as well), and now that we call setup_idt very early the SIPI vector
overwrites the first few bytes of the IDT, and in particular the #DE handler.

Fix this for both 32-bit and 64-bit, even though the different form of the
descriptors meant that only 32-bit showed a failure.

Reported-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/cstart.S   | 10 +++++++---
 x86/cstart64.S | 11 ++++++++++-
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/x86/cstart.S b/x86/cstart.S
index 77dc34d..e93dbca 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -4,8 +4,6 @@
 .globl boot_idt
 .global online_cpus
 
-boot_idt = 0
-
 ipi_vector = 0x20
 
 max_cpus = MAX_TEST_CPUS
@@ -30,6 +28,12 @@ i = 0
         i = i + 1
         .endr
 
+boot_idt:
+	.rept 256
+	.quad 0
+	.endr
+end_boot_idt:
+
 .globl gdt32
 gdt32:
 	.quad 0
@@ -71,7 +75,7 @@ tss:
 tss_end:
 
 idt_descr:
-	.word 16 * 256 - 1
+	.word end_boot_idt - boot_idt - 1
 	.long boot_idt
 
 .section .init
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 1ecfbdb..b44d0ae 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -9,6 +9,8 @@ boot_idt = 0
 .globl gdt64_desc
 .globl online_cpus
 
+boot_idt = 0
+
 ipi_vector = 0x20
 
 max_cpus = MAX_TEST_CPUS
@@ -51,6 +53,13 @@ ptl5:
 
 .align 4096
 
+boot_idt:
+	.rept 256
+	.quad 0
+	.quad 0
+	.endr
+end_boot_idt:
+
 gdt64_desc:
 	.word gdt64_end - gdt64 - 1
 	.quad gdt64
@@ -282,7 +291,7 @@ lvl5:
 	retq
 
 idt_descr:
-	.word 16 * 256 - 1
+	.word end_boot_idt - boot_idt - 1
 	.quad boot_idt
 
 online_cpus:
-- 
2.26.2

