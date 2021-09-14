Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A91D40B4AA
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhINQbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:31:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56625 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229790AbhINQbh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 12:31:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631637019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IrwGg2H1rsLzBpIrOeVhB/ZH433DI7RnPUeNaj2Oq8w=;
        b=NIWQ+QruVwIs4+n8aJOkP/NQd3XyfEYrIfZqYJSQFVitAY+X+MG812hvQAz15l++Hq1LUI
        5PwDHzdJpCVbWVVB0nL1UUUwSwfY2otW4WAhDRT8o4Igp7IKlcf9QzQba/V6/A981K9Jgt
        uHn9ODPI/c5Ky38sIHZXimnolkvREu0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-5hv_62y6NA-s7vitpV3SnQ-1; Tue, 14 Sep 2021 12:30:18 -0400
X-MC-Unique: 5hv_62y6NA-s7vitpV3SnQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3894C1922038
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 16:30:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F191E1972E;
        Tue, 14 Sep 2021 16:30:11 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/4] svm: intercept shutdown in all svm tests by default
Date:   Tue, 14 Sep 2021 19:30:06 +0300
Message-Id: <20210914163008.309356-3-mlevitsk@redhat.com>
In-Reply-To: <20210914163008.309356-1-mlevitsk@redhat.com>
References: <20210914163008.309356-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If L1 doesn't intercept shutdown, then L1 itself gets it,
which doesn't allow it to report the error that happened.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index f109caa..2210d68 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -174,7 +174,9 @@ void vmcb_ident(struct vmcb *vmcb)
 	save->cr2 = read_cr2();
 	save->g_pat = rdmsr(MSR_IA32_CR_PAT);
 	save->dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
-	ctrl->intercept = (1ULL << INTERCEPT_VMRUN) | (1ULL << INTERCEPT_VMMCALL);
+	ctrl->intercept = (1ULL << INTERCEPT_VMRUN) |
+			  (1ULL << INTERCEPT_VMMCALL) |
+			  (1ULL << INTERCEPT_SHUTDOWN);
 	ctrl->iopm_base_pa = virt_to_phys(io_bitmap);
 	ctrl->msrpm_base_pa = virt_to_phys(msr_bitmap);
 
-- 
2.26.3

