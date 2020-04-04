Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC08E19E5B1
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 16:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgDDOiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 10:38:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22910 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726490AbgDDOiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 10:38:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586011099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X/FnkgGUsHKu76b7rfSyf9V2vp8FmKEyZRkIYQEnR7c=;
        b=gez8s6OdzI565C6GjPp3CXFQGyMzc1IEk4xYdKIviMqnwZfh+tm9BnNtiDu2M582/HRVYM
        NRqhhbVFuESOuKhYjCpjIKJc4O/yU7cHRWcCko+rHqhsv7BJ32/Yyl7HK2coa8Ttf6w8gE
        pryVcNiIJXC1drjqQYG04K6ojMXKIV4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-kRr9Vb7zPLuZE7cheQwSxg-1; Sat, 04 Apr 2020 10:38:12 -0400
X-MC-Unique: kRr9Vb7zPLuZE7cheQwSxg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C8261005509;
        Sat,  4 Apr 2020 14:38:11 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 142B29B912;
        Sat,  4 Apr 2020 14:38:09 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PULL kvm-unit-tests 13/39] arm64: timer: Use existing helpers to access counter/timers
Date:   Sat,  4 Apr 2020 16:37:05 +0200
Message-Id: <20200404143731.208138-14-drjones@redhat.com>
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

We already have some good helpers to access the counter and timer
registers.  Use them to avoid open coding the accessors again.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index 10a88f3f1d19..f5cf775ce50f 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -331,7 +331,7 @@ static void test_init(void)
 	vtimer_info.irq_flags =3D fdt32_to_cpu(data[8]);
=20
 	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, ptimer_unsuppo=
rted_handler);
-	read_sysreg(cntp_ctl_el0);
+	ptimer_info.read_ctl();
 	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, NULL);
=20
 	if (ptimer_unsupported && !ERRATA(7b6b46311a85)) {
@@ -366,15 +366,15 @@ static void print_timer_info(void)
 {
 	printf("CNTFRQ_EL0   : 0x%016lx\n", read_sysreg(cntfrq_el0));
=20
-	if (!ptimer_unsupported){
-		printf("CNTPCT_EL0   : 0x%016lx\n", read_sysreg(cntpct_el0));
-		printf("CNTP_CTL_EL0 : 0x%016lx\n", read_sysreg(cntp_ctl_el0));
-		printf("CNTP_CVAL_EL0: 0x%016lx\n", read_sysreg(cntp_cval_el0));
+	if (!ptimer_unsupported) {
+		printf("CNTPCT_EL0   : 0x%016lx\n", ptimer_info.read_counter());
+		printf("CNTP_CTL_EL0 : 0x%016lx\n", ptimer_info.read_ctl());
+		printf("CNTP_CVAL_EL0: 0x%016lx\n", ptimer_info.read_cval());
 	}
=20
-	printf("CNTVCT_EL0   : 0x%016lx\n", read_sysreg(cntvct_el0));
-	printf("CNTV_CTL_EL0 : 0x%016lx\n", read_sysreg(cntv_ctl_el0));
-	printf("CNTV_CVAL_EL0: 0x%016lx\n", read_sysreg(cntv_cval_el0));
+	printf("CNTVCT_EL0   : 0x%016lx\n", vtimer_info.read_counter());
+	printf("CNTV_CTL_EL0 : 0x%016lx\n", vtimer_info.read_ctl());
+	printf("CNTV_CVAL_EL0: 0x%016lx\n", vtimer_info.read_cval());
 }
=20
 int main(int argc, char **argv)
--=20
2.25.1

