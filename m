Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D660209D4D
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 13:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404125AbgFYLNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 07:13:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26552 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404042AbgFYLNc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 07:13:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593083611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0dsCTG5l149JURh9HRnb5gcWP46PjgZEHPEl+fIj16g=;
        b=A6O7sDxLkFacO1sh3IY6Zu7ydp4oTe1P+T0KbafDW+VYNgLiKr3Ra03ZlGgubbuMFksnHG
        Qq0OhNme6kl+GersL1Am10LRNQie8XSfvLeUGrs/b/9C7j/zfIQsjfWRLjCN860FBUWjhP
        ITX0ZBdDlcZhiHIb0q+vE3iNqJ9yK90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-R_7LxPF1PEiFYEnCFy--Zg-1; Thu, 25 Jun 2020 07:13:29 -0400
X-MC-Unique: R_7LxPF1PEiFYEnCFy--Zg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54FE410059B9;
        Thu, 25 Jun 2020 11:13:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FCA51010428;
        Thu, 25 Jun 2020 11:13:27 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     nadav.amit@gmail.com
Subject: [PATCH kvm-unit-tests v2] x86: setup segment registers before percpu areas
Date:   Thu, 25 Jun 2020 07:13:27 -0400
Message-Id: <20200625111327.1509-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The base of the percpu area is stored in the %gs base, and writing
to %gs destroys it.  Move setup_segments earlier, before the %gs
base is written, and keep setup_percpu_area close so that the base
is updated close to the selector.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/cstart.S | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/cstart.S b/x86/cstart.S
index 6b5004e..deb08b7 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -109,21 +109,21 @@ MSR_GS_BASE = 0xc0000101
 
 .globl start
 start:
+        lgdtl gdt32_descr
+        setup_segments
         mov $stacktop, %esp
+        setup_percpu_area
+
         push %ebx
         call setup_multiboot
         call setup_libcflat
         mov mb_cmdline(%ebx), %eax
         mov %eax, __args
         call __setup_args
-        setup_percpu_area
         call prepare_32
         jmpl $8, $start32
 
 prepare_32:
-        lgdtl gdt32_descr
-	setup_segments
-
 	mov %cr4, %eax
 	bts $4, %eax  // pse
 	mov %eax, %cr4
-- 
2.26.2

