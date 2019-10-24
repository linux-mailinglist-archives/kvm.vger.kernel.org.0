Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC51BE3371
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393529AbfJXNHT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:07:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35116 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2393527AbfJXNHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:07:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571922437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pn1bwJ9+9AINZi93Ccf5bbrwslVAPOtF64W9cwOY830=;
        b=LGuab+SIL/1TedpsfLvXpyHO/pEHmnod3DpwijUFls6+XUwugDBvCvfGjrCrasQxyrvVzM
        xsrstqFQ5nk8Us21UCCcCT7yAjgNj+FzBx1qCV1BMQY+Bcdg67ecPC+AKxmFWw6btYPbP7
        Z5Lwk81bhD6LOZF5OMAqFECkN0LrANc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-aYeMZeFWNliVRQGCS6-ZIQ-1; Thu, 24 Oct 2019 09:07:10 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F7481800E04;
        Thu, 24 Oct 2019 13:07:09 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74C855D70E;
        Thu, 24 Oct 2019 13:07:08 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Andre Przywara <andre.przywara@arm.com>
Subject: [PULL 04/10] arm: selftest: Split variable output data from test name
Date:   Thu, 24 Oct 2019 15:06:55 +0200
Message-Id: <20191024130701.31238-5-drjones@redhat.com>
In-Reply-To: <20191024130701.31238-1-drjones@redhat.com>
References: <20191024130701.31238-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: aYeMZeFWNliVRQGCS6-ZIQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

For some tests we mix variable diagnostic output with the test name,
which leads to variable test line, confusing some higher level
frameworks.

Split the output to always use the same test name for a certain test,
and put diagnostic output on a separate line using the INFO: tag.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/selftest.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arm/selftest.c b/arm/selftest.c
index 28a17f7a7531..a0c1ab8180bc 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -43,13 +43,16 @@ static void check_setup(int argc, char **argv)
 =09=09=09phys_addr_t memsize =3D PHYS_END - PHYS_OFFSET;
 =09=09=09phys_addr_t expected =3D ((phys_addr_t)val)*1024*1024;
=20
-=09=09=09report("size =3D %" PRIu64 " MB", memsize =3D=3D expected,
-=09=09=09=09=09=09=09memsize/1024/1024);
+=09=09=09report("memory size matches expectation",
+=09=09=09       memsize =3D=3D expected);
+=09=09=09report_info("found %" PRIu64 " MB", memsize/1024/1024);
 =09=09=09++nr_tests;
=20
 =09=09} else if (strcmp(argv[i], "smp") =3D=3D 0) {
=20
-=09=09=09report("nr_cpus =3D %d", nr_cpus =3D=3D (int)val, nr_cpus);
+=09=09=09report("number of CPUs matches expectation",
+=09=09=09       nr_cpus =3D=3D (int)val);
+=09=09=09report_info("found %d CPUs", nr_cpus);
 =09=09=09++nr_tests;
 =09=09}
=20
--=20
2.21.0

