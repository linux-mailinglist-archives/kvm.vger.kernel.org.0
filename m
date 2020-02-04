Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE1DC15164A
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 08:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgBDHNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 02:13:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41028 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727192AbgBDHNx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 02:13:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580800432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=OAV4F2+o9s/Gjq4pV+na9/3hpXSOMYF+C/ORbZgIhNA=;
        b=CDTpV5gXsgVr+r5imdyHM9F4YoHurLixnNqXjBqjP1gcCRlkRPuTSNO9eon7jb3uZLwyes
        GoPDlkNnozhYKDjIXTxAoL81irANYr8MbkJsJoXAIBwhfkCP5lCi6xgQejZJU9ZI/mtZ2D
        gcAnGDUCbghK/1DGK3qyJBaMognmi5o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-_iqiQbe_MBSS9JA3O5FBtA-1; Tue, 04 Feb 2020 02:13:49 -0500
X-MC-Unique: _iqiQbe_MBSS9JA3O5FBtA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1FA985EE6A;
        Tue,  4 Feb 2020 07:13:48 +0000 (UTC)
Received: from thuth.com (ovpn-116-39.ams2.redhat.com [10.36.116.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4E6C5C1D4;
        Tue,  4 Feb 2020 07:13:47 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     david@redhat.com, Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 4/9] s390x: Add cpu id to interrupt error prints
Date:   Tue,  4 Feb 2020 08:13:30 +0100
Message-Id: <20200204071335.18180-5-thuth@redhat.com>
In-Reply-To: <20200204071335.18180-1-thuth@redhat.com>
References: <20200204071335.18180-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

It's good to know which cpu broke the test.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20200201152851.82867-5-frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/interrupt.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index ccb376a..3a40cac 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -109,8 +109,8 @@ void handle_pgm_int(void)
 	if (!pgm_int_expected) {
 		/* Force sclp_busy to false, otherwise we will loop forever */
 		sclp_handle_ext();
-		report_abort("Unexpected program interrupt: %d at %#lx, ilen %d\n",
-			     lc->pgm_int_code, lc->pgm_old_psw.addr,
+		report_abort("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
+			     lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
 			     lc->pgm_int_id);
 	}
 
@@ -122,8 +122,8 @@ void handle_ext_int(void)
 {
 	if (!ext_int_expected &&
 	    lc->ext_int_code != EXT_IRQ_SERVICE_SIG) {
-		report_abort("Unexpected external call interrupt (code %#x): at %#lx",
-			     lc->ext_int_code, lc->ext_old_psw.addr);
+		report_abort("Unexpected external call interrupt (code %#x): on cpu %d at %#lx",
+			     lc->ext_int_code, stap(), lc->ext_old_psw.addr);
 		return;
 	}
 
@@ -140,18 +140,18 @@ void handle_ext_int(void)
 
 void handle_mcck_int(void)
 {
-	report_abort("Unexpected machine check interrupt: at %#lx",
-		     lc->mcck_old_psw.addr);
+	report_abort("Unexpected machine check interrupt: on cpu %d at %#lx",
+		     stap(), lc->mcck_old_psw.addr);
 }
 
 void handle_io_int(void)
 {
-	report_abort("Unexpected io interrupt: at %#lx",
-		     lc->io_old_psw.addr);
+	report_abort("Unexpected io interrupt: on cpu %d at %#lx",
+		     stap(), lc->io_old_psw.addr);
 }
 
 void handle_svc_int(void)
 {
-	report_abort("Unexpected supervisor call interrupt: at %#lx",
-		     lc->svc_old_psw.addr);
+	report_abort("Unexpected supervisor call interrupt: on cpu %d at %#lx",
+		     stap(), lc->svc_old_psw.addr);
 }
-- 
2.18.1

