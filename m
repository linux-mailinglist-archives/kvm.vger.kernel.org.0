Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8778151652
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 08:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbgBDHOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 02:14:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41234 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725834AbgBDHN6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 02:13:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580800438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=6hsLWcttreSGRgYk7YYpJiVWchjMZwHmFaSUuP438V8=;
        b=QL5y3mAACPpF6OZH9+ey8am/6XHPZxg+oxUsDTNo+ycgygB4V0Devlv+InQ3SrvLrNWYuz
        /q0gq26xzeIJW/jdoGHCItfom7sg8pW3jjemGIpENHrrFKtpaJxmGikL0sMR3w7gbRtB4D
        wcRoYDpDSZJ0rWBXw5shIHQ4bHffDGE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123--bScj_qZOTWVHmHrkLXIAQ-1; Tue, 04 Feb 2020 02:13:54 -0500
X-MC-Unique: -bScj_qZOTWVHmHrkLXIAQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8CB91090780;
        Tue,  4 Feb 2020 07:13:53 +0000 (UTC)
Received: from thuth.com (ovpn-116-39.ams2.redhat.com [10.36.116.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 773BA5C1D4;
        Tue,  4 Feb 2020 07:13:52 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     david@redhat.com, Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 7/9] s390x: smp: Wait for cpu setup to finish
Date:   Tue,  4 Feb 2020 08:13:33 +0100
Message-Id: <20200204071335.18180-8-thuth@redhat.com>
In-Reply-To: <20200204071335.18180-1-thuth@redhat.com>
References: <20200204071335.18180-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

We store the user provided psw address into restart new, so a psw
restart does not lead us through setup again.

Also we wait on smp_cpu_setup() until the cpu has finished setup
before returning. This is necessary for z/VM and LPAR where sigp is
asynchronous.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20200201152851.82867-8-frankja@linux.ibm.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/smp.c  | 3 +++
 s390x/cstart64.S | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 4578003..3f86243 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -210,6 +210,9 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
 
 	/* Start processing */
 	smp_cpu_restart_nolock(addr, NULL);
+	/* Wait until the cpu has finished setup and started the provided psw */
+	while (lc->restart_new_psw.addr != psw.addr)
+		mb();
 out:
 	spin_unlock(&lock);
 	return rc;
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 86dd4c4..9af6bb3 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -159,6 +159,8 @@ smp_cpu_setup_state:
 	xgr	%r1, %r1
 	lmg     %r0, %r15, GEN_LC_SW_INT_GRS
 	lctlg   %c0, %c0, GEN_LC_SW_INT_CRS
+	/* We should only go once through cpu setup and not for every restart */
+	stg	%r14, GEN_LC_RESTART_NEW_PSW + 8
 	br	%r14
 
 pgm_int:
-- 
2.18.1

