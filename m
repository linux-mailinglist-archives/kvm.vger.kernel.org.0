Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C461A148B5B
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 16:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388610AbgAXPhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 10:37:42 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23868 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388032AbgAXPhm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Jan 2020 10:37:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579880260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wPQZMPHMuLudlUICNOjLZWEM1dq74c0+KGBbOEg0s1U=;
        b=aNOKOW+fiLEV7KtVdbYndekfTyebDLEPNhvEmEBoClF3Ta2tZqIXNG1ISAaVX7T/7j34Ns
        nbuX39XcoZKicc4oIhOy3iv1rx9etXdyWG6svqdv9oKf63x1Ki3Gn+zE0A4IUv/s96wsoL
        mXJGJtp6dNmJzkgsqprvFg5TAwBdU44=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-T1Oa006gPtqgoHmnQ67Qdw-1; Fri, 24 Jan 2020 10:37:37 -0500
X-MC-Unique: T1Oa006gPtqgoHmnQ67Qdw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 712F5151ED3
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2020 15:37:30 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 958D41001B28;
        Fri, 24 Jan 2020 15:37:29 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 1/2] KVM: selftests: Rework debug message printing
Date:   Fri, 24 Jan 2020 16:37:25 +0100
Message-Id: <20200124153726.15455-2-drjones@redhat.com>
In-Reply-To: <20200124153726.15455-1-drjones@redhat.com>
References: <20200124153726.15455-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There were a few problems with the way we output "debug" messages.
The first is that we used DEBUG() which is defined when NDEBUG is
not defined, but NDEBUG will never be defined for kselftests
because it relies too much on assert(). The next is that most
of the DEBUG() messages were actually "info" messages, which
users may want to turn off if they just want a silent test that
either completes or asserts. Finally, a debug message output from
a library function, and thus for all tests, was annoying when its
information wasn't interesting for a test.

Rework these messages so debug messages only output when DEBUG
is defined and info messages output unless QUIET is defined.
Also name the functions pr_debug and pr_info and make sure that
when they're disabled we eat all the inputs. The later avoids
unused variable warnings when the variables were only defined
for the purpose of printing.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c     | 16 +++++++++-------
 tools/testing/selftests/kvm/include/kvm_util.h   | 13 ++++++++++---
 .../selftests/kvm/lib/aarch64/processor.c        |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c       |  7 ++++---
 4 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing=
/selftests/kvm/dirty_log_test.c
index 5614222a6628..973d5b1c1c0f 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -173,7 +173,7 @@ static void *vcpu_worker(void *data)
 		}
 	}
=20
-	DEBUG("Dirtied %"PRIu64" pages\n", pages_count);
+	pr_info("Dirtied %"PRIu64" pages\n", pages_count);
=20
 	return NULL;
 }
@@ -252,6 +252,8 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mo=
de, uint32_t vcpuid,
 	struct kvm_vm *vm;
 	uint64_t extra_pg_pages =3D extra_mem_pages / 512 * 2;
=20
+	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
+
 	vm =3D _vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDW=
R);
 	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
 #ifdef __x86_64__
@@ -311,7 +313,7 @@ static void run_test(enum vm_guest_mode mode, unsigne=
d long iterations,
 	guest_test_phys_mem &=3D ~((1 << 20) - 1);
 #endif
=20
-	DEBUG("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem=
);
+	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_m=
em);
=20
 	bmap =3D bitmap_alloc(host_num_pages);
 	host_bmap_track =3D bitmap_alloc(host_num_pages);
@@ -378,9 +380,9 @@ static void run_test(enum vm_guest_mode mode, unsigne=
d long iterations,
 	host_quit =3D true;
 	pthread_join(vcpu_thread, NULL);
=20
-	DEBUG("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "
-	      "track_next (%"PRIu64")\n", host_dirty_count, host_clear_count,
-	      host_track_next_count);
+	pr_info("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "
+		"track_next (%"PRIu64")\n", host_dirty_count, host_clear_count,
+		host_track_next_count);
=20
 	free(bmap);
 	free(host_bmap_track);
@@ -495,8 +497,8 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(iterations > 2, "Iterations must be greater than two");
 	TEST_ASSERT(interval > 0, "Interval must be greater than zero");
=20
-	DEBUG("Test iterations: %"PRIu64", interval: %"PRIu64" (ms)\n",
-	      iterations, interval);
+	pr_info("Test iterations: %"PRIu64", interval: %"PRIu64" (ms)\n",
+		iterations, interval);
=20
 	srandom(time(0));
=20
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
index 29cccaf96baf..787570d33d85 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -24,10 +24,17 @@ struct kvm_vm;
 typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address=
 */
 typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address =
*/
=20
-#ifndef NDEBUG
-#define DEBUG(...) printf(__VA_ARGS__);
+static inline int _no_printf(const char *format, ...) { return 0; }
+
+#ifdef DEBUG
+#define pr_debug(...) printf(__VA_ARGS__)
+#else
+#define pr_debug(...) _no_printf(__VA_ARGS__)
+#endif
+#ifndef QUIET
+#define pr_info(...) printf(__VA_ARGS__)
 #else
-#define DEBUG(...)
+#define pr_info(...) _no_printf(__VA_ARGS__)
 #endif
=20
 /* Minimum allocated guest virtual and physical addresses */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/=
testing/selftests/kvm/lib/aarch64/processor.c
index 86036a59a668..618881c0c91a 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -186,7 +186,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t=
 gva)
=20
 static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent, ui=
nt64_t page, int level)
 {
-#ifdef DEBUG_VM
+#ifdef DEBUG
 	static const char * const type[] =3D { "", "pud", "pmd", "pte" };
 	uint64_t pte, *ptep;
=20
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
index 41cf45416060..4b0938ee61f2 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -136,7 +136,8 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, ui=
nt64_t phy_pages, int perm)
 {
 	struct kvm_vm *vm;
=20
-	DEBUG("Testing guest mode: %s\n", vm_guest_mode_string(mode));
+	pr_debug("%s: mode=3D'%s' pages=3D'%ld' perm=3D'%d'\n", __func__,
+		 vm_guest_mode_string(mode), phy_pages, perm);
=20
 	vm =3D calloc(1, sizeof(*vm));
 	TEST_ASSERT(vm !=3D NULL, "Insufficient Memory");
@@ -196,8 +197,8 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, ui=
nt64_t phy_pages, int perm)
 		vm->pgtable_levels =3D 4;
 		vm->page_size =3D 0x1000;
 		vm->page_shift =3D 12;
-		DEBUG("Guest physical address width detected: %d\n",
-		      vm->pa_bits);
+		pr_debug("Guest physical address width detected: %d\n",
+			 vm->pa_bits);
 #else
 		TEST_ASSERT(false, "VM_MODE_PXXV48_4K not supported on "
 			    "non-x86 platforms");
--=20
2.21.1

