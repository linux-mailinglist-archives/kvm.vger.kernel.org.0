Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B02B315DA1A
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 16:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387495AbgBNO77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 09:59:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51566 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387605AbgBNO76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 09:59:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581692397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OL4zgZFmo4zIodUl2Z1olCtMNpI4bpdcKk9RhxO/Lgc=;
        b=biCRZ0UIm4a+9aGpmvx8fhuG09v2381Cc+reBOE1y2ArhDb8wK5qfsJ6qDqYHh4A1ndTmI
        AbW17h2isZt/IhWARE0WkSwGB7LnI2KwDtrkGXMHf7c23QHJdBbOogzpO9R6RwE2O/Kieq
        tIe04yyiriipdyKaNY7Vxmgb/R56F+4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-PLD-yucgOBiCUevLNs_uHg-1; Fri, 14 Feb 2020 09:59:54 -0500
X-MC-Unique: PLD-yucgOBiCUevLNs_uHg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2201A19057A0;
        Fri, 14 Feb 2020 14:59:53 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 712AA19E9C;
        Fri, 14 Feb 2020 14:59:51 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, peterx@redhat.com
Subject: [PATCH 11/13] KVM: selftests: Rename vm_guest_mode_params
Date:   Fri, 14 Feb 2020 15:59:18 +0100
Message-Id: <20200214145920.30792-12-drjones@redhat.com>
In-Reply-To: <20200214145920.30792-1-drjones@redhat.com>
References: <20200214145920.30792-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We're going to want this name in the library code, so use a shorter
name in the tests.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/demand_paging_test.c        | 34 +++++++++----------
 tools/testing/selftests/kvm/dirty_log_test.c  | 34 +++++++++----------
 2 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/tes=
ting/selftests/kvm/demand_paging_test.c
index 5aae166c2817..a5e57bd63e78 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -543,16 +543,14 @@ static void run_test(enum vm_guest_mode mode, bool =
use_uffd,
 	}
 }
=20
-struct vm_guest_mode_params {
+struct guest_mode {
 	bool supported;
 	bool enabled;
 };
-struct vm_guest_mode_params vm_guest_mode_params[NUM_VM_MODES];
+static struct guest_mode guest_modes[NUM_VM_MODES];
=20
-#define vm_guest_mode_params_init(mode, supported, enabled)		     \
-({									     \
-	vm_guest_mode_params[mode] =3D					     \
-			(struct vm_guest_mode_params){ supported, enabled }; \
+#define guest_mode_init(mode, supported, enabled) ({ \
+	guest_modes[mode] =3D (struct guest_mode){ supported, enabled }; \
 })
=20
 static void help(char *name)
@@ -568,7 +566,7 @@ static void help(char *name)
 	       "     Guest mode IDs:\n");
 	for (i =3D 0; i < NUM_VM_MODES; ++i) {
 		printf("         %d:    %s%s\n", i, vm_guest_mode_string(i),
-		       vm_guest_mode_params[i].supported ? " (supported)" : "");
+		       guest_modes[i].supported ? " (supported)" : "");
 	}
 	printf(" -u: use User Fault FD to handle vCPU page\n"
 	       "     faults.\n");
@@ -594,24 +592,24 @@ int main(int argc, char *argv[])
 	useconds_t uffd_delay =3D 0;
=20
 #ifdef __x86_64__
-	vm_guest_mode_params_init(VM_MODE_PXXV48_4K, true, true);
+	guest_mode_init(VM_MODE_PXXV48_4K, true, true);
 #endif
 #ifdef __aarch64__
-	vm_guest_mode_params_init(VM_MODE_P40V48_4K, true, true);
-	vm_guest_mode_params_init(VM_MODE_P40V48_64K, true, true);
+	guest_mode_init(VM_MODE_P40V48_4K, true, true);
+	guest_mode_init(VM_MODE_P40V48_64K, true, true);
 	{
 		unsigned int limit =3D kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
=20
 		if (limit >=3D 52)
-			vm_guest_mode_params_init(VM_MODE_P52V48_64K, true, true);
+			guest_mode_init(VM_MODE_P52V48_64K, true, true);
 		if (limit >=3D 48) {
-			vm_guest_mode_params_init(VM_MODE_P48V48_4K, true, true);
-			vm_guest_mode_params_init(VM_MODE_P48V48_64K, true, true);
+			guest_mode_init(VM_MODE_P48V48_4K, true, true);
+			guest_mode_init(VM_MODE_P48V48_64K, true, true);
 		}
 	}
 #endif
 #ifdef __s390x__
-	vm_guest_mode_params_init(VM_MODE_P40V48_4K, true, true);
+	guest_mode_init(VM_MODE_P40V48_4K, true, true);
 #endif
=20
 	while ((opt =3D getopt(argc, argv, "hm:ud:b:v:")) !=3D -1) {
@@ -619,13 +617,13 @@ int main(int argc, char *argv[])
 		case 'm':
 			if (!mode_selected) {
 				for (i =3D 0; i < NUM_VM_MODES; ++i)
-					vm_guest_mode_params[i].enabled =3D false;
+					guest_modes[i].enabled =3D false;
 				mode_selected =3D true;
 			}
 			mode =3D strtoul(optarg, NULL, 10);
 			TEST_ASSERT(mode < NUM_VM_MODES,
 				    "Guest mode ID %d too big", mode);
-			vm_guest_mode_params[mode].enabled =3D true;
+			guest_modes[mode].enabled =3D true;
 			break;
 		case 'u':
 			use_uffd =3D true;
@@ -654,9 +652,9 @@ int main(int argc, char *argv[])
 	}
=20
 	for (i =3D 0; i < NUM_VM_MODES; ++i) {
-		if (!vm_guest_mode_params[i].enabled)
+		if (!guest_modes[i].enabled)
 			continue;
-		TEST_ASSERT(vm_guest_mode_params[i].supported,
+		TEST_ASSERT(guest_modes[i].supported,
 			    "Guest mode ID %d (%s) not supported.",
 			    i, vm_guest_mode_string(i));
 		run_test(i, use_uffd, uffd_delay, vcpus, vcpu_memory_bytes);
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing=
/selftests/kvm/dirty_log_test.c
index 587edf40cc32..12acf90826c1 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -388,15 +388,14 @@ static void run_test(enum vm_guest_mode mode, unsig=
ned long iterations,
 	kvm_vm_free(vm);
 }
=20
-struct vm_guest_mode_params {
+struct guest_mode {
 	bool supported;
 	bool enabled;
 };
-struct vm_guest_mode_params vm_guest_mode_params[NUM_VM_MODES];
+static struct guest_mode guest_modes[NUM_VM_MODES];
=20
-#define vm_guest_mode_params_init(mode, supported, enabled)					\
-({												\
-	vm_guest_mode_params[mode] =3D (struct vm_guest_mode_params){ supported=
, enabled };	\
+#define guest_mode_init(mode, supported, enabled) ({ \
+	guest_modes[mode] =3D (struct guest_mode){ supported, enabled }; \
 })
=20
 static void help(char *name)
@@ -419,7 +418,7 @@ static void help(char *name)
 	       "     Guest mode IDs:\n");
 	for (i =3D 0; i < NUM_VM_MODES; ++i) {
 		printf("         %d:    %s%s\n", i, vm_guest_mode_string(i),
-		       vm_guest_mode_params[i].supported ? " (supported)" : "");
+		       guest_modes[i].supported ? " (supported)" : "");
 	}
 	puts("");
 	exit(0);
@@ -442,24 +441,25 @@ int main(int argc, char *argv[])
 #endif
=20
 #ifdef __x86_64__
-	vm_guest_mode_params_init(VM_MODE_PXXV48_4K, true, true);
+	guest_mode_init(VM_MODE_PXXV48_4K, true, true);
 #endif
 #ifdef __aarch64__
-	vm_guest_mode_params_init(VM_MODE_P40V48_4K, true, true);
-	vm_guest_mode_params_init(VM_MODE_P40V48_64K, true, true);
+	guest_mode_init(VM_MODE_P40V48_4K, true, true);
+	guest_mode_init(VM_MODE_P40V48_64K, true, true);
+
 	{
 		unsigned int limit =3D kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
=20
 		if (limit >=3D 52)
-			vm_guest_mode_params_init(VM_MODE_P52V48_64K, true, true);
+			guest_mode_init(VM_MODE_P52V48_64K, true, true);
 		if (limit >=3D 48) {
-			vm_guest_mode_params_init(VM_MODE_P48V48_4K, true, true);
-			vm_guest_mode_params_init(VM_MODE_P48V48_64K, true, true);
+			guest_mode_init(VM_MODE_P48V48_4K, true, true);
+			guest_mode_init(VM_MODE_P48V48_64K, true, true);
 		}
 	}
 #endif
 #ifdef __s390x__
-	vm_guest_mode_params_init(VM_MODE_P40V48_4K, true, true);
+	guest_mode_init(VM_MODE_P40V48_4K, true, true);
 #endif
=20
 	while ((opt =3D getopt(argc, argv, "hi:I:p:m:")) !=3D -1) {
@@ -476,13 +476,13 @@ int main(int argc, char *argv[])
 		case 'm':
 			if (!mode_selected) {
 				for (i =3D 0; i < NUM_VM_MODES; ++i)
-					vm_guest_mode_params[i].enabled =3D false;
+					guest_modes[i].enabled =3D false;
 				mode_selected =3D true;
 			}
 			mode =3D strtoul(optarg, NULL, 10);
 			TEST_ASSERT(mode < NUM_VM_MODES,
 				    "Guest mode ID %d too big", mode);
-			vm_guest_mode_params[mode].enabled =3D true;
+			guest_modes[mode].enabled =3D true;
 			break;
 		case 'h':
 		default:
@@ -500,9 +500,9 @@ int main(int argc, char *argv[])
 	srandom(time(0));
=20
 	for (i =3D 0; i < NUM_VM_MODES; ++i) {
-		if (!vm_guest_mode_params[i].enabled)
+		if (!guest_modes[i].enabled)
 			continue;
-		TEST_ASSERT(vm_guest_mode_params[i].supported,
+		TEST_ASSERT(guest_modes[i].supported,
 			    "Guest mode ID %d (%s) not supported.",
 			    i, vm_guest_mode_string(i));
 		run_test(i, iterations, interval, phys_offset);
--=20
2.21.1

