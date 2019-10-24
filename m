Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D610E3374
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502320AbfJXNH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:07:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25614 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2502289AbfJXNH1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:07:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571922446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p6Add7eq6f12eyAWq2019g8AK0b1v262zSXSWVC4y7I=;
        b=iLDLZCpq3XSSyhS5xvlwUt+Z9IxgGBgNyV2plVYY4c56gYb00ZtIwL4m/6MmXs5j8ngqYQ
        Pc9w9/jsZl04qzK+GaBtKZaB3NXqPBNHGxqQRDM3IZawmUM7AMIDW51PjcADjRNRvIyiFs
        IWA+HJku8l7b489NWieQPJLRvwvHQyM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-g84IGUXJML-ENdnVB2CdPg-1; Thu, 24 Oct 2019 09:07:17 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A11325E9;
        Thu, 24 Oct 2019 13:07:16 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 904E761F27;
        Thu, 24 Oct 2019 13:07:13 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL 08/10] lib: arm/arm64: Add function to clear the PTE_USER bit
Date:   Thu, 24 Oct 2019 15:06:59 +0200
Message-Id: <20191024130701.31238-9-drjones@redhat.com>
In-Reply-To: <20191024130701.31238-1-drjones@redhat.com>
References: <20191024130701.31238-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: g84IGUXJML-ENdnVB2CdPg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

The PTE_USER bit (AP[1]) in a page entry means that lower privilege levels
(EL0, on arm64, or PL0, on arm) can read and write from that memory
location [1][2]. On arm64, it also implies PXN (Privileged execute-never)
when is set [3]. Add a function to clear the bit which we can use when we
want to execute code from that page or the prevent access from lower
exception levels.

Make it available to arm too, in case someone needs it at some point.

[1] ARM DDI 0406C.d, Table B3-6
[2] ARM DDI 0487E.a, table D5-28
[3] ARM DDI 0487E.a, table D5-33

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/mmu-api.h |  1 +
 lib/arm/mmu.c         | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
index df3ccf7bc7e0..8fe85ba31ec9 100644
--- a/lib/arm/asm/mmu-api.h
+++ b/lib/arm/asm/mmu-api.h
@@ -22,4 +22,5 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t =
virt_offset,
 extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
 =09=09=09       phys_addr_t phys_start, phys_addr_t phys_end,
 =09=09=09       pgprot_t prot);
+extern void mmu_clear_user(unsigned long vaddr);
 #endif
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 3d38c8397f5a..78db22e6af14 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -217,3 +217,18 @@ unsigned long __phys_to_virt(phys_addr_t addr)
 =09assert(!mmu_enabled() || __virt_to_phys(addr) =3D=3D addr);
 =09return addr;
 }
+
+void mmu_clear_user(unsigned long vaddr)
+{
+=09pgd_t *pgtable;
+=09pteval_t *pte;
+
+=09if (!mmu_enabled())
+=09=09return;
+
+=09pgtable =3D current_thread_info()->pgtable;
+=09pte =3D get_pte(pgtable, vaddr);
+
+=09*pte &=3D ~PTE_USER;
+=09flush_tlb_page(vaddr);
+}
--=20
2.21.0

