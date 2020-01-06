Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDD1130FED
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgAFKEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:04:13 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23800 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726536AbgAFKEN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jan 2020 05:04:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578305052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Cqfdj26rLJl/dquUbqJKo5g9RGHl1/HVf1Ebr2+TFI=;
        b=ZW94OR8ZfTBODULmpnjzNnOnPWN6wnOnprug1STwkm2WPdJCDX3hcERJrhoc4STuJQHgaj
        khl5Y+8D9gVbCcefTF3yxhJFBLjkhZDX7ZvwigSEFIpvtsASTW8YAs+7NeTC4XG3sARmt6
        rIIshHc+Ry06i1oCiQxx8BWRCgZhkMo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-9PJn3eXYMqqKyh2K87Az0g-1; Mon, 06 Jan 2020 05:04:09 -0500
X-MC-Unique: 9PJn3eXYMqqKyh2K87Az0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FE85801E6C;
        Mon,  6 Jan 2020 10:04:08 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8175563BCA;
        Mon,  6 Jan 2020 10:04:07 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 11/17] lib: arm: Implement flush_tlb_all
Date:   Mon,  6 Jan 2020 11:03:41 +0100
Message-Id: <20200106100347.1559-12-drjones@redhat.com>
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

flush_tlb_all performs a TLBIALL, which invalidates the entire TLB and
affects only the executing PE; translation table walks are now Inner
Shareable, so execute a TLBIALLIS (invalidate TLB Inner Shareable) instea=
d.
TLBIALLIS is the equivalent of TLBIALL [1] when the multiprocessing
extensions are implemented, which are mandated by the virtualization
extensions.

Also add the necessary barriers to tlb_flush_all and a comment to
flush_dcache_addr stating what instruction is uses (unsurprisingly, it's
DCCIMVAC, which does a dcache clean and invalidate by VA to PoC).

[1] ARM DDI 0406C.d, section B3.10.6

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/mmu.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/arm/asm/mmu.h b/lib/arm/asm/mmu.h
index 2bf8965ed35e..122874b8aebe 100644
--- a/lib/arm/asm/mmu.h
+++ b/lib/arm/asm/mmu.h
@@ -26,8 +26,11 @@ static inline void local_flush_tlb_all(void)
=20
 static inline void flush_tlb_all(void)
 {
-	//TODO
-	local_flush_tlb_all();
+	dsb(ishst);
+	/* TLBIALLIS */
+	asm volatile("mcr p15, 0, %0, c8, c3, 0" :: "r" (0));
+	dsb(ish);
+	isb();
 }
=20
 static inline void flush_tlb_page(unsigned long vaddr)
@@ -41,6 +44,7 @@ static inline void flush_tlb_page(unsigned long vaddr)
=20
 static inline void flush_dcache_addr(unsigned long vaddr)
 {
+	/* DCCIMVAC */
 	asm volatile("mcr p15, 0, %0, c7, c14, 1" :: "r" (vaddr));
 }
=20
--=20
2.21.0

