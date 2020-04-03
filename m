Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1355B19DA2A
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 17:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404345AbgDCPb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 11:31:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60103 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404293AbgDCPbK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 11:31:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585927869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Mna+DLBALS7Nv4a/6CqV2AmkqQOOKpm1xodEo/O7Gc=;
        b=MsT0cfMpBjOopiQKCAqXD9aXdwmFiWMzdqYPyEYzyOjoLik8SM/EgHmS1Dtaq2vLmMPDMx
        Aw6ZJ4pG0IXiqywCjvNCZrjkvL2nxTaR/vV3Ljj1g91uEYG12lfchdsUveTRrKo0d6AQIC
        ILXqcnDPceuGZH54ttOhlBvJ2DwJZSE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-3_BoqKm6MkSVwTpjGmDjAA-1; Fri, 03 Apr 2020 11:31:08 -0400
X-MC-Unique: 3_BoqKm6MkSVwTpjGmDjAA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BBD2800D50;
        Fri,  3 Apr 2020 15:31:06 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-112-213.ams2.redhat.com [10.36.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D8D626DD1;
        Fri,  3 Apr 2020 15:31:04 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 4/5] KVM: s390: vsie: Move conditional reschedule
Date:   Fri,  3 Apr 2020 17:30:49 +0200
Message-Id: <20200403153050.20569-5-david@redhat.com>
In-Reply-To: <20200403153050.20569-1-david@redhat.com>
References: <20200403153050.20569-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

