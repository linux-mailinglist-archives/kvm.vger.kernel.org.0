Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB4615DA19
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 16:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387618AbgBNO77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 09:59:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32077 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387608AbgBNO76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 09:59:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581692397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nXN3fbXl+1P1HU7aErZo4MnF0JNFN2LWLEoqDoFJCTo=;
        b=buuWJhLHiF6dALOgnLoYHwNtsPDp4mR8wsN7YSBmr67GL9nt1EayJgLHAzF5+Re8hGWg/1
        LtWZjeCIbPqv6vKADCuum+UwwOGqcoVolMs+bpKNS9ua0iRpNU2yc8kJjnvatJ0pifFqCc
        A9Yx5Gb/qWTRJNMUEdsXtMU5yu/2lr8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-3Yls1Au3MrSUtPO5hMJnwA-1; Fri, 14 Feb 2020 09:59:56 -0500
X-MC-Unique: 3Yls1Au3MrSUtPO5hMJnwA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DEB5100551A;
        Fri, 14 Feb 2020 14:59:55 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D7E68AC27;
        Fri, 14 Feb 2020 14:59:53 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, peterx@redhat.com
Subject: [PATCH 12/13] KVM: selftests: Introduce vm_guest_mode_params
Date:   Fri, 14 Feb 2020 15:59:19 +0100
Message-Id: <20200214145920.30792-13-drjones@redhat.com>
In-Reply-To: <20200214145920.30792-1-drjones@redhat.com>
References: <20200214145920.30792-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This array will allow us to easily translate modes to their parameter
values.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 52 +++++++++++-----------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
index c8a7ed338bed..5e26e24bd609 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -113,6 +113,25 @@ const char * const vm_guest_mode_string[] =3D {
 _Static_assert(sizeof(vm_guest_mode_string)/sizeof(char *) =3D=3D NUM_VM=
_MODES,
 	       "Missing new mode strings?");
=20
+struct vm_guest_mode_params {
+	unsigned int pa_bits;
+	unsigned int va_bits;
+	unsigned int page_size;
+	unsigned int page_shift;
+};
+
+static const struct vm_guest_mode_params vm_guest_mode_params[] =3D {
+	{ 52, 48,  0x1000, 12 },
+	{ 52, 48, 0x10000, 16 },
+	{ 48, 48,  0x1000, 12 },
+	{ 48, 48, 0x10000, 16 },
+	{ 40, 48,  0x1000, 12 },
+	{ 40, 48, 0x10000, 16 },
+	{  0,  0,  0x1000, 12 },
+};
+_Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_=
params) =3D=3D NUM_VM_MODES,
+	       "Missing new mode params?");
+
 #define KVM_INTERNAL_MEMSLOTS_START_PADDR 0xfe000000ULL
 #define KVM_INTERNAL_MEMSLOTS_END_PADDR (4ULL << 30)
 /*
@@ -147,60 +166,39 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, =
uint64_t phy_pages, int perm)
 	vm->mode =3D mode;
 	vm->type =3D 0;
=20
+	vm->pa_bits =3D vm_guest_mode_params[mode].pa_bits;
+	vm->va_bits =3D vm_guest_mode_params[mode].va_bits;
+	vm->page_size =3D vm_guest_mode_params[mode].page_size;
+	vm->page_shift =3D vm_guest_mode_params[mode].page_shift;
+
 	/* Setup mode specific traits. */
 	switch (vm->mode) {
 	case VM_MODE_P52V48_4K:
 		vm->pgtable_levels =3D 4;
-		vm->pa_bits =3D 52;
-		vm->va_bits =3D 48;
-		vm->page_size =3D 0x1000;
-		vm->page_shift =3D 12;
 		break;
 	case VM_MODE_P52V48_64K:
 		vm->pgtable_levels =3D 3;
-		vm->pa_bits =3D 52;
-		vm->va_bits =3D 48;
-		vm->page_size =3D 0x10000;
-		vm->page_shift =3D 16;
 		break;
 	case VM_MODE_P48V48_4K:
 		vm->pgtable_levels =3D 4;
-		vm->pa_bits =3D 48;
-		vm->va_bits =3D 48;
-		vm->page_size =3D 0x1000;
-		vm->page_shift =3D 12;
 		break;
 	case VM_MODE_P48V48_64K:
 		vm->pgtable_levels =3D 3;
-		vm->pa_bits =3D 48;
-		vm->va_bits =3D 48;
-		vm->page_size =3D 0x10000;
-		vm->page_shift =3D 16;
 		break;
 	case VM_MODE_P40V48_4K:
 		vm->pgtable_levels =3D 4;
-		vm->pa_bits =3D 40;
-		vm->va_bits =3D 48;
-		vm->page_size =3D 0x1000;
-		vm->page_shift =3D 12;
 		break;
 	case VM_MODE_P40V48_64K:
 		vm->pgtable_levels =3D 3;
-		vm->pa_bits =3D 40;
-		vm->va_bits =3D 48;
-		vm->page_size =3D 0x10000;
-		vm->page_shift =3D 16;
 		break;
 	case VM_MODE_PXXV48_4K:
 #ifdef __x86_64__
 		kvm_get_cpu_address_width(&vm->pa_bits, &vm->va_bits);
 		TEST_ASSERT(vm->va_bits =3D=3D 48, "Linear address width "
 			    "(%d bits) not supported", vm->va_bits);
-		vm->pgtable_levels =3D 4;
-		vm->page_size =3D 0x1000;
-		vm->page_shift =3D 12;
 		pr_debug("Guest physical address width detected: %d\n",
 			 vm->pa_bits);
+		vm->pgtable_levels =3D 4;
 #else
 		TEST_ASSERT(false, "VM_MODE_PXXV48_4K not supported on "
 			    "non-x86 platforms");
--=20
2.21.1

