Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F28719E5AB
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 16:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgDDOiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 10:38:10 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49801 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726189AbgDDOh5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 4 Apr 2020 10:37:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586011075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UcAnXTLK05SgTXUHXQBKYPlI5GJyG0mw92B1RM6BqXM=;
        b=FQ2jQCIB7/O+8KkkIi/xlSbF3Av+8QgxTZhpYClC1LOpUqLdUqVfn4eUxnzeqSD3QCI9mg
        eZK9FfIuwBUitpg13JKzL9eC5mxAGQlxXQiyC+Alom6OyRaXNAkSa9FEQfyBsFmyYMd2mm
        ixPHtn/P0sUMw6g/odYPWoGbPv4x6pQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-Amhc2xJtMUmRaY-ktwU_mQ-1; Sat, 04 Apr 2020 10:37:53 -0400
X-MC-Unique: Amhc2xJtMUmRaY-ktwU_mQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1A798024D0;
        Sat,  4 Apr 2020 14:37:48 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E30F09B912;
        Sat,  4 Apr 2020 14:37:46 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 04/39] arm64: timer: Add ISB before reading the counter value
Date:   Sat,  4 Apr 2020 16:36:56 +0200
Message-Id: <20200404143731.208138-5-drjones@redhat.com>
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

Reads of the physical counter and the virtual counter registers "can occu=
r
speculatively and out of order relative to other instructions executed on
the same PE" [1, 2].

There is no theoretical limit to the number of instructions that the CPU
can reorder and we use the counter value to program the timer to fire in
the future. Add an ISB before reading the counter to make sure the read
instruction is not reordered too long in the past with regard to the
instruction that programs the timer alarm, thus causing the timer to fire
unexpectedly. This matches what Linux does (see
arch/arm64/include/asm/arch_timer.h).

Because we use the counter value to program the timer, we create a regist=
er
dependency [3] between the value that we read and the value that we write=
 to
CVAL and thus we don't need a barrier after the read. Linux does things
differently because the read needs to be ordered with regard to a memory
load (more information in commit 75a19a0202db ("arm64: arch_timer: Ensure
counter register reads occur with seqlock held")).

This also matches what we already do in get_cntvct from
lib/arm{,64}/asm/processor.h.

[1] ARM DDI 0487E.a, section D11.2.1
[2] ARM DDI 0487E.a, section D11.2.2
[3] ARM DDI 0486E.a, section B2.3.2

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arm/timer.c b/arm/timer.c
index c6ea108cfa4b..e758e84855c3 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -30,6 +30,7 @@ static void ptimer_unsupported_handler(struct pt_regs *=
regs, unsigned int esr)
=20
 static u64 read_vtimer_counter(void)
 {
+	isb();
 	return read_sysreg(cntvct_el0);
 }
=20
@@ -68,6 +69,7 @@ static void write_vtimer_ctl(u64 val)
=20
 static u64 read_ptimer_counter(void)
 {
+	isb();
 	return read_sysreg(cntpct_el0);
 }
=20
--=20
2.25.1

