Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AACA3100219
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 11:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfKRKIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 05:08:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22811 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726761AbfKRKIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 05:08:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574071697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AsF9OHSdlsKS6rwHyhm8uC61MVisTsEjO24dF2lfbXE=;
        b=IwS/Dulg8jqgvMqrMJhc7jQWDiKBM6zcFDITRSElC5YyYbqd0PjFvysCDkI2tglEURRlC7
        IHOtlxO+TItOPpCndUH6+DT2V561WnHqpNqhzwRC1TQZtjGX3AZgwYgnV/OAhh57oKa+S3
        NQEJwPjMFL+AXkG40KQ15I5hGx/JGWY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-RVkvkPo_MOqD3kr72BuCWA-1; Mon, 18 Nov 2019 05:08:15 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58095477;
        Mon, 18 Nov 2019 10:08:14 +0000 (UTC)
Received: from t460s.redhat.com (unknown [10.36.118.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42F8E66856;
        Mon, 18 Nov 2019 10:08:10 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 05/12] s390x: Fix initial cr0 load comments
Date:   Mon, 18 Nov 2019 11:07:12 +0100
Message-Id: <20191118100719.7968-6-david@redhat.com>
In-Reply-To: <20191118100719.7968-1-david@redhat.com>
References: <20191118100719.7968-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: RVkvkPo_MOqD3kr72BuCWA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

We need to load cr0 to have access to all fprs during save and restore
of fprs. Saving conditionally on basis of the CR0 AFP bit would be a
pain.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20191111153345.22505-2-frankja@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 s390x/cstart64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 8e2b21e..043e34a 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -94,7 +94,7 @@ memsetxc:
 =09stmg=09%r0, %r15, GEN_LC_SW_INT_GRS
 =09/* save cr0 */
 =09stctg=09%c0, %c0, GEN_LC_SW_INT_CR0
-=09/* load initial cr0 again */
+=09/* load a cr0 that has the AFP control bit which enables all FPRs */
 =09larl=09%r1, initial_cr0
 =09lctlg=09%c0, %c0, 0(%r1)
 =09/* save fprs 0-15 + fpc */
@@ -139,7 +139,7 @@ diag308_load_reset:
 =09xgr=09%r2, %r2
 =09br=09%r14
 =09/* Success path */
-=09/* We lost cr0 due to the reset */
+=09/* load a cr0 that has the AFP control bit which enables all FPRs */
 0:=09larl=09%r1, initial_cr0
 =09lctlg=09%c0, %c0, 0(%r1)
 =09RESTORE_REGS
--=20
2.21.0

