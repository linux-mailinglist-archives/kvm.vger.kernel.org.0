Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35633E134A
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 12:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240527AbhHEKyo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 06:54:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232453AbhHEKyn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Aug 2021 06:54:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628160869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fNh464kHQ9hh2xtU0nEA+dod0fBOCqP6+88RFXNitZg=;
        b=aRsFeiKnlUvmr9GrBoVFiUr8fLcb8WSZkXJPWouEMorFpBFOXExzILR3MBJ4IH/FPr4Xr5
        cA2BtDgIw4q690kixGaurxO9CH60v/fcUDGOc9Q2WnndgPxqTiTpU7JhJXQcb397Hrwfm8
        en3erAfNqCaAlfR9sFd2XQPBxvT2yA8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-GQ6e45K_NQCjW6LbF9quYg-1; Thu, 05 Aug 2021 06:54:26 -0400
X-MC-Unique: GQ6e45K_NQCjW6LbF9quYg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09FC318C89CF;
        Thu,  5 Aug 2021 10:54:25 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F62660BF4;
        Thu,  5 Aug 2021 10:54:24 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] selftests: KVM: avoid failures due to reserved HyperTransport region
Date:   Thu,  5 Aug 2021 06:54:23 -0400
Message-Id: <20210805105423.412878-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Accessing guest physical addresses at 0xFFFD_0000_0000 and above causes
a failure on AMD processors because those addresses are reserved by
HyperTransport (this is not documented).  Avoid selftests failures
by reserving those guest physical addresses.

Fixes: ef4c9f4f6546 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()")
Cc: stable@vger.kernel.org
Cc: David Matlack <dmatlack@google.com>
Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 10a8ed691c66..d995cc9836ee 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -309,6 +309,12 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 	/* Limit physical addresses to PA-bits. */
 	vm->max_gfn = ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
 
+#ifdef __x86_64__
+	/* Avoid reserved HyperTransport region on AMD processors.  */
+	if (vm->pa_bits == 48)
+		vm->max_gfn = 0xfffcfffff;
+#endif
+
 	/* Allocate and setup memory for guest. */
 	vm->vpages_mapped = sparsebit_alloc();
 	if (phy_pages != 0)
-- 
2.27.0

