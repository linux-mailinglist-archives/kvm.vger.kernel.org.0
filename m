Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3AF31A63D1
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 09:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbgDMHui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 03:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729434AbgDMHui (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 03:50:38 -0400
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com [207.211.31.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3614CC008679
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 00:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586764237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=lYN6NWfIRfj/yIGOoBz/hWKpypYJrD0ZyvpeCaMLxg8=;
        b=EPInsd93r07Q1gX1zp2nPtiLbsn4epyz4d0U4z1PiJusXgoj3ombJgnPTmHghErplG18Qe
        oH5obEutHUZEhYr4DfAoE5xNrM+GlrRtTfxBIPL1bz3gt9J/CmbpuC8+X/cXKSVCbhcxmN
        AO0ahfdzQ01qxVbseLJA/66G/4NaudI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-RHGsbDOdMDWecL_D8MqgFA-1; Mon, 13 Apr 2020 03:50:34 -0400
X-MC-Unique: RHGsbDOdMDWecL_D8MqgFA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75B491005513;
        Mon, 13 Apr 2020 07:50:33 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0364B5C64E;
        Mon, 13 Apr 2020 07:50:32 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     ubizjak@gmail.com
Subject: [PATCH] KVM: SVM: fix compilation with modular PSP and non-modular KVM
Date:   Mon, 13 Apr 2020 03:50:31 -0400
Message-Id: <20200413075032.5546-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use svm_sev_enabled() in order to cull all calls to PSP code.  Otherwise,
compilation fails with undefined symbols if the PSP device driver is compiled
as a module and KVM is not.

Reported-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0e3fc311d7da..364ffe32139c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1117,7 +1117,7 @@ int __init sev_hardware_setup(void)
 	/* Maximum number of encrypted guests supported simultaneously */
 	max_sev_asid = cpuid_ecx(0x8000001F);
 
-	if (!max_sev_asid)
+        if (!svm_sev_enabled())
 		return 1;
 
 	/* Minimum ASID value that should be used for SEV guest */
@@ -1156,6 +1156,9 @@ int __init sev_hardware_setup(void)
 
 void sev_hardware_teardown(void)
 {
+        if (!svm_sev_enabled())
+                return;
+
 	bitmap_free(sev_asid_bitmap);
 	bitmap_free(sev_reclaim_asid_bitmap);
 
-- 
2.18.2

