Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FA51C0024
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 17:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgD3PZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 11:25:05 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27909 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727106AbgD3PZE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 11:25:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588260303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jZEGSLl0JZmQ17JeqZ0bSsFXXTWmCtNEI/q1OjLpaYk=;
        b=iIub7+9++g9SI5l15lbE+A/WuDZ3JBUN7kmqjdR7SxjAz3NqhPfXbEZK+YybOBiSNfcx2s
        ftD4nDkIpQpTuDVXb9G0nlgVqdOYr8TSW1E2Us9BMVcJWbVuAT6Ng8sXY+LNZJSh0deKi7
        y8eJP2tkOTAfnKYOO4pAyAjueK2HU/w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-NLG_3CDrOIqA5GQDRgYUbg-1; Thu, 30 Apr 2020 11:25:00 -0400
X-MC-Unique: NLG_3CDrOIqA5GQDRgYUbg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60F91800D24;
        Thu, 30 Apr 2020 15:24:59 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8ED205EDE3;
        Thu, 30 Apr 2020 15:24:57 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 11/17] s390x: smp: Test stop and store status on a running and stopped cpu
Date:   Thu, 30 Apr 2020 17:24:24 +0200
Message-Id: <20200430152430.40349-12-david@redhat.com>
In-Reply-To: <20200430152430.40349-1-david@redhat.com>
References: <20200430152430.40349-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Let's also test the stop portion of the "stop and store status" sigp
order.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Message-Id: <20200429143518.1360468-4-frankja@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 s390x/smp.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index bf082d1..57eacb2 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -76,6 +76,18 @@ static void test_stop_store_status(void)
 	struct lowcore *lc =3D (void *)0x0;
=20
 	report_prefix_push("stop store status");
+	report_prefix_push("running");
+	smp_cpu_restart(1);
+	lc->prefix_sa =3D 0;
+	lc->grs_sa[15] =3D 0;
+	smp_cpu_stop_store_status(1);
+	mb();
+	report(lc->prefix_sa =3D=3D (uint32_t)(uintptr_t)cpu->lowcore, "prefix"=
);
+	report(lc->grs_sa[15], "stack");
+	report(smp_cpu_stopped(1), "cpu stopped");
+	report_prefix_pop();
+
+	report_prefix_push("stopped");
 	lc->prefix_sa =3D 0;
 	lc->grs_sa[15] =3D 0;
 	smp_cpu_stop_store_status(1);
@@ -83,6 +95,8 @@ static void test_stop_store_status(void)
 	report(lc->prefix_sa =3D=3D (uint32_t)(uintptr_t)cpu->lowcore, "prefix"=
);
 	report(lc->grs_sa[15], "stack");
 	report_prefix_pop();
+
+	report_prefix_pop();
 }
=20
 static void test_store_status(void)
--=20
2.25.3

