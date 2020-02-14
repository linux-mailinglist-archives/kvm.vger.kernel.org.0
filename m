Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1910E15DA0E
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 15:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387518AbgBNO7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 09:59:36 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38590 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387508AbgBNO7g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 09:59:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581692375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sKMRS3w2kuRy22TJgAb6tpFvHgSy+MoTPg7mVoTVTYs=;
        b=CJRX98PxZA9/L3LgQsJPFrs5niagZ785zkZYzgt0LMa3xzlVjTutDi0mfTWZwYgSjUMHeK
        FQaPvbT30YSY+qlWYT6+3H9DANawIOO5ERO6kkCv9ysCFwY0vYsCgvGWkO4Y/Js/V5JnoW
        eXkRps89gjpX/dHZufsSCsGiy4QJXfI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-HcXJ-yepOqSsFMK02kJumg-1; Fri, 14 Feb 2020 09:59:33 -0500
X-MC-Unique: HcXJ-yepOqSsFMK02kJumg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24439100550E;
        Fri, 14 Feb 2020 14:59:32 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70B3D19E9C;
        Fri, 14 Feb 2020 14:59:30 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, peterx@redhat.com
Subject: [PATCH 03/13] fixup! KVM: selftests: Support multiple vCPUs in demand paging test
Date:   Fri, 14 Feb 2020 15:59:10 +0100
Message-Id: <20200214145920.30792-4-drjones@redhat.com>
In-Reply-To: <20200214145920.30792-1-drjones@redhat.com>
References: <20200214145920.30792-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[guest_code() can't return, use GUEST_ASSERT(). Ensure the number
 of guests pages is compatible with the host.]
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/tes=
ting/selftests/kvm/demand_paging_test.c
index ec8860b70129..2e6e3db8418a 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -115,9 +115,8 @@ static void guest_code(uint32_t vcpu_id)
 	uint64_t pages;
 	int i;
=20
-	/* Return to signal error if vCPU args data structure is courrupt. */
-	if (vcpu_args[vcpu_id].vcpu_id !=3D vcpu_id)
-		return;
+	/* Make sure vCPU args data structure is not corrupt. */
+	GUEST_ASSERT(vcpu_args[vcpu_id].vcpu_id =3D=3D vcpu_id);
=20
 	gva =3D vcpu_args[vcpu_id].gva;
 	pages =3D vcpu_args[vcpu_id].pages;
@@ -186,6 +185,12 @@ static struct kvm_vm *create_vm(enum vm_guest_mode m=
ode, int vcpus,
 	pages +=3D ((2 * vcpus * vcpu_memory_bytes) >> PAGE_SHIFT_4K) /
 		 PTES_PER_4K_PT;
=20
+	/*
+	 * If the host is uing 64K pages, then we need the number of 4K
+	 * guest pages to be a multiple of 16.
+	 */
+	pages +=3D 16 - pages % 16;
+
 	vm =3D _vm_create(mode, pages, O_RDWR);
 	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
 #ifdef __x86_64__
--=20
2.21.1

