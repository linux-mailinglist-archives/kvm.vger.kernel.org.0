Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0360130FE8
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgAFKEE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:04:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56171 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726467AbgAFKEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 05:04:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578305040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RJ/RHuW7Tsl+Lx0wmRe6Z7jRCrdepZD9gMBau33v86o=;
        b=T5081A+PW63dFoStHH7F92dELAp55BhkmZuXMuXZJkKqX68eE3a9D4Oba/mV4icy5VVg+i
        jbHu8kBWacirfFckDnvr9kHl0zbD+n6hTHyvs4osxTp/V6YPyjUZAgLst0n+abEIXoYPUe
        qUXjeB5PB1Qj69s25YNidgy4Yx8Cufc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-qGDTxaumNJyomfU0oeJyCQ-1; Mon, 06 Jan 2020 05:03:59 -0500
X-MC-Unique: qGDTxaumNJyomfU0oeJyCQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B832107ACC5;
        Mon,  6 Jan 2020 10:03:58 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D0EE7BA4F;
        Mon,  6 Jan 2020 10:03:57 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 06/17] lib: arm: Add proper data synchronization barriers for TLBIs
Date:   Mon,  6 Jan 2020 11:03:36 +0100
Message-Id: <20200106100347.1559-7-drjones@redhat.com>
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

We need to issue a DSB before doing TLB invalidation to make sure that th=
e
table walker sees the new VA mapping after the TLBI finishes. For
flush_tlb_page, we do a DSB ISHST (synchronization barrier for writes in
the Inner Shareable domain) because translation table walks are now
coherent for arm. For local_flush_tlb_all, we only need to affect the
Non-shareable domain, and we do a DSB NSHST. We need a synchronization
barrier here, and not a memory ordering barrier, because a table walk is
not a memory operation and therefore not affected by the DMB.

For the same reasons, we downgrade the full system DSB after the TLBI to =
a
DSB ISH (synchronization barrier for reads and writes in the Inner
Shareable domain), and, respectively, DSB NSH (in the Non-shareable
domain).

With these two changes, our TLB maintenance functions now match what Linu=
x
does in __flush_tlb_kernel_page, and, respectively, in local_flush_tlb_al=
l.

A similar change was implemented in Linux commit 62cbbc42e001 ("ARM: tlb:
reduce scope of barrier domains for TLB invalidation").

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/mmu.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/arm/asm/mmu.h b/lib/arm/asm/mmu.h
index 361f3cdcc3d5..2bf8965ed35e 100644
--- a/lib/arm/asm/mmu.h
+++ b/lib/arm/asm/mmu.h
@@ -17,9 +17,10 @@
=20
 static inline void local_flush_tlb_all(void)
 {
+	dsb(nshst);
 	/* TLBIALL */
 	asm volatile("mcr p15, 0, %0, c8, c7, 0" :: "r" (0));
-	dsb();
+	dsb(nsh);
 	isb();
 }
=20
@@ -31,9 +32,10 @@ static inline void flush_tlb_all(void)
=20
 static inline void flush_tlb_page(unsigned long vaddr)
 {
+	dsb(ishst);
 	/* TLBIMVAAIS */
 	asm volatile("mcr p15, 0, %0, c8, c3, 3" :: "r" (vaddr));
-	dsb();
+	dsb(ish);
 	isb();
 }
=20
--=20
2.21.0

