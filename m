Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F520130FF3
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgAFKET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:04:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30779 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726618AbgAFKES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 05:04:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578305057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cPQ0qhpb1ZXkfzisyfnBvtoThwxhaS4ps7eTC1k+e0k=;
        b=hEY2lV2AJsXt/EkI/HJB4PaQhN2aVQlh/wlpWUCl1FQpqtkrPLUdCzmrOD/9svg53HgwYi
        m7btS4IUK0t1+80Gnpr7hpDt3j72XhlBbGhB0XQkuCZSqFSxuiE6PQ68zTjk1HrhXvYhoi
        x9RoTI7FMEld5BKEENE+ozJvM5xcz7s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-gZflU_fzN9-udh1pTHPCdA-1; Mon, 06 Jan 2020 05:04:16 -0500
X-MC-Unique: gZflU_fzN9-udh1pTHPCdA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 266FE10054E3;
        Mon,  6 Jan 2020 10:04:15 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 284F07BA4F;
        Mon,  6 Jan 2020 10:04:13 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 16/17] arm/arm64: Invalidate TLB before enabling MMU
Date:   Mon,  6 Jan 2020 11:03:46 +0100
Message-Id: <20200106100347.1559-17-drjones@redhat.com>
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

Let's invalidate the TLB before enabling the MMU, not after, so we don't
accidently use a stale TLB mapping. For arm, we add a TLBIALL operation,
which applies only to the PE that executed the instruction [1]. For arm64=
,
we already do that in asm_mmu_enable.

We now find ourselves in a situation where we issue an extra invalidation
after asm_mmu_enable returns. Remove this redundant call to tlb_flush_all=
.

[1] ARM DDI 0406C.d, section B3.10.6

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/cstart.S  | 4 ++++
 lib/arm/mmu.c | 1 -
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 8c041da50ae2..e54e380e0d53 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -166,6 +166,10 @@ halt:
 .equ	NMRR,	0xff000004		@ MAIR1 (from Linux kernel)
 .globl asm_mmu_enable
 asm_mmu_enable:
+	/* TLBIALL */
+	mcr	p15, 0, r2, c8, c7, 0
+	dsb	nsh
+
 	/* TTBCR */
 	ldr	r2, =3D(TTBCR_EAE | 				\
 		      TTBCR_SH0_SHARED | 			\
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 111e3a52591a..5fb56180d334 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -59,7 +59,6 @@ void mmu_enable(pgd_t *pgtable)
 	struct thread_info *info =3D current_thread_info();
=20
 	asm_mmu_enable(__pa(pgtable));
-	flush_tlb_all();
=20
 	info->pgtable =3D pgtable;
 	mmu_mark_enabled(info->cpu);
--=20
2.21.0

