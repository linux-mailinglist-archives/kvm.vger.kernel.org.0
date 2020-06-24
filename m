Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C5C207568
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 16:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390049AbgFXOOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 10:14:35 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48942 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389583AbgFXOOe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Jun 2020 10:14:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593008073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZEqT8Oy86SuWyMii7V54P8YjMki3kKQTmwnWT92jSIM=;
        b=dJnNKjAbHuGjaIHfG/XJkaplIIF091l7p5r0tv1UaCjWHzVkg8+P/eaRPoC1zbnzQVW8ng
        ZPO8YymZv6CUXwKYtU85nfk1cQKFxbM2Z7zpA1j7AKrXR7Wp7iobZzhBexw31PClmPs6jo
        TvTjOiDv5lpZQKlAh9p6hevaFNxm+so=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-KSvMrACgOAWHNwbjwLkQmA-1; Wed, 24 Jun 2020 10:14:31 -0400
X-MC-Unique: KSvMrACgOAWHNwbjwLkQmA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D3251940923
        for <kvm@vger.kernel.org>; Wed, 24 Jun 2020 14:14:30 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A5F07B600
        for <kvm@vger.kernel.org>; Wed, 24 Jun 2020 14:14:30 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] i386: setup segment registers before percpu areas
Date:   Wed, 24 Jun 2020 10:14:29 -0400
Message-Id: <20200624141429.382157-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The base of the percpu area is stored in the %gs base, and writing
to %gs destroys it.  Move setup_segments earlier, before the %gs
base is written.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/cstart.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/cstart.S b/x86/cstart.S
index 5ad70b5..77dc34d 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -106,6 +106,7 @@ MSR_GS_BASE = 0xc0000101
 .globl start
 start:
         mov $stacktop, %esp
+        setup_segments
         push %ebx
         call setup_multiboot
         call setup_libcflat
@@ -118,7 +119,6 @@ start:
 
 prepare_32:
         lgdtl gdt32_descr
-	setup_segments
 
 	mov %cr4, %eax
 	bts $4, %eax  // pse
-- 
2.26.2

