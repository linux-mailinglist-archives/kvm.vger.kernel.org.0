Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01833130FF2
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgAFKET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:04:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42931 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726620AbgAFKES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 05:04:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578305057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RePL3KzY2Q6VE1/iBu/pMbH5HuIY2VI1umXTKnfSztQ=;
        b=L43/Wt45R1rm+tym0V43G5pD3QnDc6jpAf9q+WK6966tz1ulH1B8dWrSibh6pf2BIrKVb6
        P2xX9Da6QytT9o5cw+KsTlNcw7tg+abRwQQkGU8p1FY3/5A8Yjn3vfzOeB6RlSeRQsJoWB
        FksIqHbjQo0W2g+oqT6VAggViItHkPo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-TIhB1x7MP-6SSG-rN_-4CQ-1; Mon, 06 Jan 2020 05:04:15 -0500
X-MC-Unique: TIhB1x7MP-6SSG-rN_-4CQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D284B1800D4E;
        Mon,  6 Jan 2020 10:04:13 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4AD963BCA;
        Mon,  6 Jan 2020 10:04:12 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 15/17] arm: cstart64.S: Downgrade TLBI to non-shareable in asm_mmu_enable
Date:   Mon,  6 Jan 2020 11:03:45 +0100
Message-Id: <20200106100347.1559-16-drjones@redhat.com>
In-Reply-To: <20200106100347.1559-1-drjones@redhat.com>
References: <20200106100347.1559-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

There's really no need to invalidate the TLB entries for all CPUs when
enabling the MMU for the current CPU, so use the non-shareable version of
the TLBI operation (and downgrade the DSB accordingly).

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/cstart64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index b0e8baa1a23a..6f49506ca19b 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -160,8 +160,8 @@ halt:
 .globl asm_mmu_enable
 asm_mmu_enable:
 	ic	iallu			// I+BTB cache invalidate
-	tlbi	vmalle1is		// invalidate I + D TLBs
-	dsb	ish
+	tlbi	vmalle1			// invalidate I + D TLBs
+	dsb	nsh
=20
 	/* TCR */
 	ldr	x1, =3DTCR_TxSZ(VA_BITS) |		\
--=20
2.21.0

