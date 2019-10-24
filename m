Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1087BE336C
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393534AbfJXNHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:07:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41557 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393525AbfJXNHN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 09:07:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571922432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ySh5FzLv3PhiEYiCeAga8oLpZp/gEcCTnNgFcAQ1J1c=;
        b=g0t+af7f7DQFsJxaidSUBT9rmkZd/YLqE6XaDmoGZMYnXfX+PgFvVDkL67dfJ/OUyUUqWM
        R3OnP0+DBrYsUIxuCX/PMnYGtzDfrmWO2LoEzteT+HBfcD1tN0KghpJZ6IY5IeunlXYBlw
        EXlOdqfBgyBtZSaqc6Ndk07fM3pEZBk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-4sc6jEfqNC6G1w1G4tay6w-1; Thu, 24 Oct 2019 09:07:09 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CE05801E5F;
        Thu, 24 Oct 2019 13:07:08 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F9715D712;
        Thu, 24 Oct 2019 13:07:07 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Andre Przywara <andre.przywara@arm.com>
Subject: [PULL 03/10] arm: timer: Split variable output data from test name
Date:   Thu, 24 Oct 2019 15:06:54 +0200
Message-Id: <20191024130701.31238-4-drjones@redhat.com>
In-Reply-To: <20191024130701.31238-1-drjones@redhat.com>
References: <20191024130701.31238-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 4sc6jEfqNC6G1w1G4tay6w-1
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
 arm/timer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arm/timer.c b/arm/timer.c
index f2f60192ba62..0b808d5da9da 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -249,7 +249,8 @@ static void test_timer(struct timer_info *info)
 =09local_irq_enable();
 =09left =3D info->read_tval();
 =09report("interrupt received after TVAL/WFI", info->irq_received);
-=09report("timer has expired (%d)", left < 0, left);
+=09report("timer has expired", left < 0);
+=09report_info("TVAL is %d ticks", left);
 }
=20
 static void test_vtimer(void)
--=20
2.21.0

