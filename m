Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0891151649
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 08:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgBDHNv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 02:13:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49000 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726406AbgBDHNu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 02:13:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580800430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=FJSLRqnUOmBGqCSh0mxQAQkRf4rFOdRIZLA+FkEnWYk=;
        b=J1mlALhePh6lD7HpqWh40tBzWA1DpLc4IHi0l59zoQxauxCRW6KmtgaS3V4Zbi7VBg5zCc
        FVGmeCxJmgWwOavrePgEv/lRIofehV+KOr7mlzVkyL7CpMSYbM22ohZTQPUf7YfHXYLREx
        V6/iitTvrQAp8N1DJLPKUX/r9j2Mv1U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-xQxhe7tjMBWVqGdbOVRzGA-1; Tue, 04 Feb 2020 02:13:48 -0500
X-MC-Unique: xQxhe7tjMBWVqGdbOVRzGA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45A498010CB;
        Tue,  4 Feb 2020 07:13:47 +0000 (UTC)
Received: from thuth.com (ovpn-116-39.ams2.redhat.com [10.36.116.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0ACEE5C1D4;
        Tue,  4 Feb 2020 07:13:45 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     david@redhat.com, Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 3/9] s390x: Stop the cpu that is executing exit()
Date:   Tue,  4 Feb 2020 08:13:29 +0100
Message-Id: <20200204071335.18180-4-thuth@redhat.com>
In-Reply-To: <20200204071335.18180-1-thuth@redhat.com>
References: <20200204071335.18180-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

CPU 0 is not necessarily the CPU which does the exit if we ran into a
test abort situation. So, let's ask stap() which cpu does the exit and
stop it on exit.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20200201152851.82867-4-frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/io.c b/lib/s390x/io.c
index 32f09b5..e091c37 100644
--- a/lib/s390x/io.c
+++ b/lib/s390x/io.c
@@ -46,6 +46,6 @@ void exit(int code)
 	smp_teardown();
 	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
 	while (1) {
-		sigp(0, SIGP_STOP, 0, NULL);
+		sigp(stap(), SIGP_STOP, 0, NULL);
 	}
 }
-- 
2.18.1

