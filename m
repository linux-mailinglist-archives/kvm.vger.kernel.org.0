Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F6B1C0026
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 17:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgD3PZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 11:25:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28364 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726774AbgD3PZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 11:25:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588260306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=10Tt0UeRl/eVZhHqu2dZwuFRp8r/OOuFvrA0QZOYC34=;
        b=BOIZRM2iA00VMZC4eXGKX/GNsCNtGkgB1cgNozYvRvNCe91dfDCEOzOUid8vd6ZnJtAf+E
        Z8RixwmTkiG8PzIRZPFWJ3ynxOmk7kD73+8h5yR1GazX7ZHV3mX+uhVRKMLkqwNYJ+ghOV
        Yj+Qqq6d2S1BmJgXdFT5V2ESR9pHuQo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-92GmfHT9P0yoBRkVUwMdTQ-1; Thu, 30 Apr 2020 11:25:04 -0400
X-MC-Unique: 92GmfHT9P0yoBRkVUwMdTQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13288107ACCA;
        Thu, 30 Apr 2020 15:25:03 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 851335EDF1;
        Thu, 30 Apr 2020 15:25:01 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 13/17] s390x: smp: Loop if secondary cpu returns into cpu setup again
Date:   Thu, 30 Apr 2020 17:24:26 +0200
Message-Id: <20200430152430.40349-14-david@redhat.com>
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

Up to now a secondary cpu could have returned from the function it was
executing and ending up somewhere in cstart64.S. This was mostly
circumvented by an endless loop in the function that it executed.

Let's add a loop to the end of the cpu setup, so we don't have to rely
on added loops in the tests.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20200429143518.1360468-6-frankja@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 s390x/cstart64.S | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 9af6bb3..ecffbe0 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -161,7 +161,9 @@ smp_cpu_setup_state:
 	lctlg   %c0, %c0, GEN_LC_SW_INT_CRS
 	/* We should only go once through cpu setup and not for every restart *=
/
 	stg	%r14, GEN_LC_RESTART_NEW_PSW + 8
-	br	%r14
+	brasl	%r14, %r14
+	/* If the function returns, just loop here */
+0:	j	0
=20
 pgm_int:
 	SAVE_REGS
--=20
2.25.3

