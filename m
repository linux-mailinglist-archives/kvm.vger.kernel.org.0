Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24CE427B3A4
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 19:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgI1Rua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 13:50:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59108 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726685AbgI1Ru3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 13:50:29 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601315428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=5pzSOmdwNBbWykFB5gvwfruiXYEsFxeeh3MH2ruHvNg=;
        b=OD+9p70rmkqObe2/YM8bXEj2jspX5wNbLngXLuNhFP3KALQ5T//G/0O1qfQEMTjzIoWfSb
        dKzpIjgYPdgUzTT84dgb+4z0Z63jExDKnsh/oYNB1qva4cliuFu0WKHYjKgwnXjRJF63Lj
        VweKdWpA303sDoPtXoKtoafAVRyMgHo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-ailEwMcOOvi5MxXDwx_wpA-1; Mon, 28 Sep 2020 13:50:23 -0400
X-MC-Unique: ailEwMcOOvi5MxXDwx_wpA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6B67425D0;
        Mon, 28 Sep 2020 17:50:21 +0000 (UTC)
Received: from thuth.com (unknown [10.40.192.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C20B10013C0;
        Mon, 28 Sep 2020 17:50:20 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 10/11] s390x/selftest: Fix constraint of inline assembly
Date:   Mon, 28 Sep 2020 19:49:57 +0200
Message-Id: <20200928174958.26690-11-thuth@redhat.com>
In-Reply-To: <20200928174958.26690-1-thuth@redhat.com>
References: <20200928174958.26690-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang on s390x compains:

/home/thuth/devel/kvm-unit-tests/s390x/selftest.c:39:15: error:
 %r0 used in an address
        asm volatile("  stg %0,0(%0)\n" : : "r"(-1L));
                     ^
<inline asm>:1:13: note: instantiated into assembly here
                stg %r0,0(%r0)
                          ^

Right it is. We should not use address register 0 for STG.
Thus let's use the "a" constraint to avoid register 0 here.

Message-Id: <20200924111746.131633-1-thuth@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 s390x/selftest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/selftest.c b/s390x/selftest.c
index 4c16646..eaf5b18 100644
--- a/s390x/selftest.c
+++ b/s390x/selftest.c
@@ -36,7 +36,7 @@ static void test_pgm_int(void)
 	check_pgm_int_code(PGM_INT_CODE_OPERATION);
 
 	expect_pgm_int();
-	asm volatile("	stg %0,0(%0)\n" : : "r"(-1L));
+	asm volatile("	stg %0,0(%0)\n" : : "a"(-1L));
 	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
 }
 
-- 
2.18.2

