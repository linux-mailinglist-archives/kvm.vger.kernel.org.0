Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306831C0016
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 17:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgD3PYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 11:24:50 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55094 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726955AbgD3PYt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 11:24:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588260288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OqZ66/q53T5tsOQUwEg0/wWd28TgA4UfMH3dvKqQtN0=;
        b=Y/c6lPLRKV4odE6sD94A3AR7cg9QlIKzFBz5v8UZgY9rNU6Fw7PXDTh06SFTxrHCtj0Gks
        HiWTiFf3OPFUcsvGkyqCnEp92h6ezUykXHcx8RwYK2xSxZem4QMZEb4jOYTZDrcRIwLBQZ
        xioS69kQd0WY5TRnvx68kHtNqKkMKC8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-yb3pGOD9O2WgbJYKJkPe0w-1; Thu, 30 Apr 2020 11:24:46 -0400
X-MC-Unique: yb3pGOD9O2WgbJYKJkPe0w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59E42468;
        Thu, 30 Apr 2020 15:24:45 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CBED5EDE3;
        Thu, 30 Apr 2020 15:24:43 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 05/17] s390x/smp: fix detection of "running"
Date:   Thu, 30 Apr 2020 17:24:18 +0200
Message-Id: <20200430152430.40349-6-david@redhat.com>
In-Reply-To: <20200430152430.40349-1-david@redhat.com>
References: <20200430152430.40349-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

On s390x hosts with a single CPU, the smp test case hangs (loops).
The check if our restart has finished is wrong.
Sigp sense running status checks if the CPU is currently backed by a
real CPU. This means that on single CPU hosts a sigp sense running
will never claim that a target is running. We need to check for not
being stopped instead.

Reviewed-by: Janosch Frank <frankja@linux.vnet.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Message-Id: <20200330084911.34248-2-borntraeger@de.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 3f86243..203792a 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -128,7 +128,7 @@ static int smp_cpu_restart_nolock(uint16_t addr, stru=
ct psw *psw)
 	 * The order has been accepted, but the actual restart may not
 	 * have been performed yet, so wait until the cpu is running.
 	 */
-	while (!smp_cpu_running(addr))
+	while (smp_cpu_stopped(addr))
 		mb();
 	cpu->active =3D true;
 	return 0;
--=20
2.25.3

