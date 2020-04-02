Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C90CE19C910
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 20:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390012AbgDBSsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 14:48:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46863 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389905AbgDBSsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 14:48:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585853317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Mna+DLBALS7Nv4a/6CqV2AmkqQOOKpm1xodEo/O7Gc=;
        b=eb162wYZL5Cs7rO9FmECy4Dz1IWoGoPvNLBJOwmlKsD7T2ggnBAToLHfxzAMfDNepojoJu
        8Gt3llG6KUZnsrhxLDcUEmIl+baZe3KraJp4APr7xqp7qfIAxdOd9QMTFgJFvLHhsnPmQy
        l/QxgZaSH4Q4fmnBZ+yAhElMb48GoQs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-DwQOlVzKNAGajjkV7xcR-w-1; Thu, 02 Apr 2020 14:48:35 -0400
X-MC-Unique: DwQOlVzKNAGajjkV7xcR-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C4B9107ACC9;
        Thu,  2 Apr 2020 18:48:34 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-114-29.ams2.redhat.com [10.36.114.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5243B60BF3;
        Thu,  2 Apr 2020 18:48:32 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v1 4/5] KVM: s390: vsie: Move conditional reschedule
Date:   Thu,  2 Apr 2020 20:48:18 +0200
Message-Id: <20200402184819.34215-5-david@redhat.com>
In-Reply-To: <20200402184819.34215-1-david@redhat.com>
References: <20200402184819.34215-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's move it to the outer loop, in case we ever run again into long
loops, trying to map the prefix. While at it, convert it to cond_resched(=
).

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/kvm/vsie.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 4f6c22d72072..ef05b4e167fb 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1000,8 +1000,6 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struc=
t vsie_page *vsie_page)
=20
 	handle_last_fault(vcpu, vsie_page);
=20
-	if (need_resched())
-		schedule();
 	if (test_cpu_flag(CIF_MCCK_PENDING))
 		s390_handle_mcck();
=20
@@ -1185,6 +1183,7 @@ static int vsie_run(struct kvm_vcpu *vcpu, struct v=
sie_page *vsie_page)
 		    kvm_s390_vcpu_has_irq(vcpu, 0) ||
 		    kvm_s390_vcpu_sie_inhibited(vcpu))
 			break;
+		cond_resched();
 	}
=20
 	if (rc =3D=3D -EFAULT) {
--=20
2.25.1

