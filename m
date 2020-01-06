Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 796FB130FF1
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgAFKET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:04:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38748 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726524AbgAFKES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 05:04:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578305057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U6EYR9kSpHzBO/fTsPUECX7raCjmpQCAZckRwMH5FMA=;
        b=edRlMo4JeGHljHobtpIjnFvILpRWD/gPpRJBFWm7S2k8HVLdy3jiCKB0fdhUtjJyIH7Ht0
        Q19Kg61J/LBwtxt9+19RntYyPt2Zt2R+90hgkBPzIs9MtyxCIDvOMKmfHBj27CzFKTJcbe
        sE5rXhITT9ETnItu4mvmJcWU4qAVECc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-oSD6lU3mPuaZ_yaiYN_Ifw-1; Mon, 06 Jan 2020 05:04:13 -0500
X-MC-Unique: oSD6lU3mPuaZ_yaiYN_Ifw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C61E1800D4A;
        Mon,  6 Jan 2020 10:04:12 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BF4A63BCA;
        Mon,  6 Jan 2020 10:04:11 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 14/17] lib: arm/arm64: Refuse to disable the MMU with non-identity stack pointer
Date:   Mon,  6 Jan 2020 11:03:44 +0100
Message-Id: <20200106100347.1559-15-drjones@redhat.com>
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

When the MMU is off, all addresses are physical addresses. If the stack
pointer is not an identity mapped address (the virtual address is not the
same as the physical address), then we end up trying to access an invalid
memory region. This can happen if we call mmu_disable from a secondary CP=
U,
which has its stack allocated from the vmalloc region.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 928a3702c563..111e3a52591a 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -68,8 +68,12 @@ void mmu_enable(pgd_t *pgtable)
 extern void asm_mmu_disable(void);
 void mmu_disable(void)
 {
+	unsigned long sp =3D current_stack_pointer;
 	int cpu =3D current_thread_info()->cpu;
=20
+	assert_msg(__virt_to_phys(sp) =3D=3D sp,
+			"Attempting to disable MMU with non-identity mapped stack");
+
 	mmu_mark_disabled(cpu);
=20
 	asm_mmu_disable();
--=20
2.21.0

