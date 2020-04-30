Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37311C002C
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 17:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgD3PZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 11:25:16 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20913 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727800AbgD3PZP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 11:25:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588260314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DyKdklucIGbvdhS2tGasIAFGNWO8hinN55TF/mpDW5E=;
        b=NquSnbYpDUCCe6sO3PNqtQJk+ulxBWbUOA/tqpyA63vBprB8GQ/vuRnePp6zUTFD6WG3Yj
        LWIwwNumvwPsgNgeEpZ9tFxo/tucGFIRNIXwvM4DegTBgo+A3wtsFs7PboqUWpArZTQCFu
        Tb4LOgGHe7xJUcOOTEHW6/lclyARqIs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-Jm2a-yd2MUqH6T-Ku0kofQ-1; Thu, 30 Apr 2020 11:25:12 -0400
X-MC-Unique: Jm2a-yd2MUqH6T-Ku0kofQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4452F1B18BC2;
        Thu, 30 Apr 2020 15:25:11 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 621FA5EDF1;
        Thu, 30 Apr 2020 15:25:07 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 15/17] s390x: smp: Use full PSW to bringup new cpu
Date:   Thu, 30 Apr 2020 17:24:28 +0200
Message-Id: <20200430152430.40349-16-david@redhat.com>
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

Up to now we ignored the psw mask and only used the psw address when
bringing up a new cpu. For DAT we need to also load the mask, so let's
do that.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Message-Id: <20200429143518.1360468-8-frankja@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/smp.c  | 2 ++
 s390x/cstart64.S | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index df8dcd9..2860e9c 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -202,6 +202,8 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
 	cpu->stack =3D (uint64_t *)alloc_pages(2);
=20
 	/* Start without DAT and any other mask bits. */
+	cpu->lowcore->sw_int_psw.mask =3D psw.mask;
+	cpu->lowcore->sw_int_psw.addr =3D psw.addr;
 	cpu->lowcore->sw_int_grs[14] =3D psw.addr;
 	cpu->lowcore->sw_int_grs[15] =3D (uint64_t)cpu->stack + (PAGE_SIZE * 4)=
;
 	lc->restart_new_psw.mask =3D 0x0000000180000000UL;
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index ecffbe0..e084f13 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -161,7 +161,8 @@ smp_cpu_setup_state:
 	lctlg   %c0, %c0, GEN_LC_SW_INT_CRS
 	/* We should only go once through cpu setup and not for every restart *=
/
 	stg	%r14, GEN_LC_RESTART_NEW_PSW + 8
-	brasl	%r14, %r14
+	larl	%r14, 0f
+	lpswe	GEN_LC_SW_INT_PSW
 	/* If the function returns, just loop here */
 0:	j	0
=20
--=20
2.25.3

