Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBA5130FDE
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgAFKDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:03:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37263 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725446AbgAFKDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 05:03:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578305033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1uqMJ/dalG5f6I7arCU4SZG4PVAJtaN3KTr4RIMAf6Y=;
        b=ZttHOFaA9vyR4PSxfTEhlPCiIjr7QCYl0triXmAQqzYcaOFgIglaaqI98LqwSoRQAdzFw4
        WgnLCyow2IuzZ7kL9fML01HtT1RyDbmntL9u3l9v/zvm7ko9IY1ArjedrAfmdILyFklfzK
        UleTn4dDhj5/e2fyGfeIk8JUjGS2ce8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-UXh7ykwhPr-u1k98hOkdTQ-1; Mon, 06 Jan 2020 05:03:52 -0500
X-MC-Unique: UXh7ykwhPr-u1k98hOkdTQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B4ED800D48;
        Mon,  6 Jan 2020 10:03:51 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C7F57BA4F;
        Mon,  6 Jan 2020 10:03:49 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Chen Qun <kuhn.chenqun@huawei.com>
Subject: [PULL kvm-unit-tests 01/17] arm: Add missing test name prefix for pl031 and spinlock
Date:   Mon,  6 Jan 2020 11:03:31 +0100
Message-Id: <20200106100347.1559-2-drjones@redhat.com>
In-Reply-To: <20200106100347.1559-1-drjones@redhat.com>
References: <20200106100347.1559-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chen Qun <kuhn.chenqun@huawei.com>

pl031 and spinlock testcase without prefix, when running
the unit tests in TAP mode (./run_tests.sh -t), it is
difficult to the test results.

The test results=EF=BC=9A
ok 13 - Periph/PCell IDs match
ok 14 - R/O fields are R/O
ok 15 - RTC ticks at 1HZ
ok 16 - RTC IRQ not pending yet
...
ok 24 -   RTC IRQ not pending anymore
ok 25 - CPU1: Done - Errors: 0
ok 26 - CPU0: Done - Errors: 0

It should be like this=EF=BC=9A
ok 13 - pl031: Periph/PCell IDs match
ok 14 - pl031: R/O fields are R/O
ok 15 - pl031: RTC ticks at 1HZ
ok 16 - pl031: RTC IRQ not pending yet
...
ok 24 - pl031:   RTC IRQ not pending anymore
ok 25 - spinlock: CPU0: Done - Errors: 0
ok 26 - spinlock: CPU1: Done - Errors: 0

Signed-off-by: Chen Qun <kuhn.chenqun@huawei.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/pl031.c         | 1 +
 arm/spinlock-test.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arm/pl031.c b/arm/pl031.c
index 1f63ef13994f..a6adf6845f55 100644
--- a/arm/pl031.c
+++ b/arm/pl031.c
@@ -252,6 +252,7 @@ int main(int argc, char **argv)
 		return 0;
 	}
=20
+	report_prefix_push("pl031");
 	report(!check_id(), "Periph/PCell IDs match");
 	report(!check_ro(), "R/O fields are R/O");
 	report(!check_rtc_freq(), "RTC ticks at 1HZ");
diff --git a/arm/spinlock-test.c b/arm/spinlock-test.c
index a63fb41ccd91..73aea76add3e 100644
--- a/arm/spinlock-test.c
+++ b/arm/spinlock-test.c
@@ -72,6 +72,7 @@ static void test_spinlock(void *data __unused)
=20
 int main(int argc, char **argv)
 {
+	report_prefix_push("spinlock");
 	if (argc > 1 && strcmp(argv[1], "bad") !=3D 0) {
 		lock_ops.lock =3D gcc_builtin_lock;
 		lock_ops.unlock =3D gcc_builtin_unlock;
--=20
2.21.0

