Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D7215DA12
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 15:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387519AbgBNO7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 09:59:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32726 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729488AbgBNO7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 09:59:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581692382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SvAmkZoO/MA/JMHC9NgX2sDh4qOOOmo3zKF7ggb6ueg=;
        b=BDJALGoPfSMQerp8S2dEKvgJLhwEPWFpAAsQDCTVEwRVWiYyz1qfhna3l02NXxjoatc81m
        RTBpcIscdpv/gLDjTdtcctr/HV8TAgtJmSOj1LsUYjOIA2U812s8TnDZMe8j35bDqgCwNG
        y/3zmgvIAfB39hlMwwM1ZmKbUENQWlE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-Koue2KIHNAOS8ZyM2Nq1Qg-1; Fri, 14 Feb 2020 09:59:41 -0500
X-MC-Unique: Koue2KIHNAOS8ZyM2Nq1Qg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E456107ACC9;
        Fri, 14 Feb 2020 14:59:40 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CBFD19E9C;
        Fri, 14 Feb 2020 14:59:38 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, peterx@redhat.com
Subject: [PATCH 07/13] KVM: selftests: aarch64: Remove unnecessary ifdefs
Date:   Fri, 14 Feb 2020 15:59:14 +0100
Message-Id: <20200214145920.30792-8-drjones@redhat.com>
In-Reply-To: <20200214145920.30792-1-drjones@redhat.com>
References: <20200214145920.30792-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/demand_paging_test.c        | 21 ++++++++-----------
 tools/testing/selftests/kvm/dirty_log_test.c  | 21 ++++++++-----------
 2 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/tes=
ting/selftests/kvm/demand_paging_test.c
index 22a3011df62f..f20aa9f0a227 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -422,9 +422,7 @@ static void run_test(enum vm_guest_mode mode, bool us=
e_uffd,
 	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem,
 		 guest_num_pages * guest_page_size, 0);
=20
-#ifdef __aarch64__
 	ucall_init(vm, NULL);
-#endif
=20
 	guest_data_prototype =3D malloc(host_page_size);
 	TEST_ASSERT(guest_data_prototype,
@@ -594,9 +592,6 @@ int main(int argc, char *argv[])
 	int opt, i;
 	bool use_uffd =3D false;
 	useconds_t uffd_delay =3D 0;
-#ifdef __aarch64__
-	unsigned int host_ipa_limit;
-#endif
=20
 #ifdef __x86_64__
 	vm_guest_mode_params_init(VM_MODE_PXXV48_4K, true, true);
@@ -604,13 +599,15 @@ int main(int argc, char *argv[])
 #ifdef __aarch64__
 	vm_guest_mode_params_init(VM_MODE_P40V48_4K, true, true);
 	vm_guest_mode_params_init(VM_MODE_P40V48_64K, true, true);
-
-	host_ipa_limit =3D kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
-	if (host_ipa_limit >=3D 52)
-		vm_guest_mode_params_init(VM_MODE_P52V48_64K, true, true);
-	if (host_ipa_limit >=3D 48) {
-		vm_guest_mode_params_init(VM_MODE_P48V48_4K, true, true);
-		vm_guest_mode_params_init(VM_MODE_P48V48_64K, true, true);
+	{
+		unsigned int limit =3D kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
+
+		if (limit >=3D 52)
+			vm_guest_mode_params_init(VM_MODE_P52V48_64K, true, true);
+		if (limit >=3D 48) {
+			vm_guest_mode_params_init(VM_MODE_P48V48_4K, true, true);
+			vm_guest_mode_params_init(VM_MODE_P48V48_64K, true, true);
+		}
 	}
 #endif
 #ifdef __s390x__
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing=
/selftests/kvm/dirty_log_test.c
index 5614222a6628..3146302ac563 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -341,9 +341,7 @@ static void run_test(enum vm_guest_mode mode, unsigne=
d long iterations,
 #ifdef __x86_64__
 	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 #endif
-#ifdef __aarch64__
 	ucall_init(vm, NULL);
-#endif
=20
 	/* Export the shared variables to the guest */
 	sync_global_to_guest(vm, host_page_size);
@@ -433,9 +431,6 @@ int main(int argc, char *argv[])
 	uint64_t phys_offset =3D 0;
 	unsigned int mode;
 	int opt, i;
-#ifdef __aarch64__
-	unsigned int host_ipa_limit;
-#endif
=20
 #ifdef USE_CLEAR_DIRTY_LOG
 	if (!kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2)) {
@@ -450,13 +445,15 @@ int main(int argc, char *argv[])
 #ifdef __aarch64__
 	vm_guest_mode_params_init(VM_MODE_P40V48_4K, true, true);
 	vm_guest_mode_params_init(VM_MODE_P40V48_64K, true, true);
-
-	host_ipa_limit =3D kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
-	if (host_ipa_limit >=3D 52)
-		vm_guest_mode_params_init(VM_MODE_P52V48_64K, true, true);
-	if (host_ipa_limit >=3D 48) {
-		vm_guest_mode_params_init(VM_MODE_P48V48_4K, true, true);
-		vm_guest_mode_params_init(VM_MODE_P48V48_64K, true, true);
+	{
+		unsigned int limit =3D kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
+
+		if (limit >=3D 52)
+			vm_guest_mode_params_init(VM_MODE_P52V48_64K, true, true);
+		if (limit >=3D 48) {
+			vm_guest_mode_params_init(VM_MODE_P48V48_4K, true, true);
+			vm_guest_mode_params_init(VM_MODE_P48V48_64K, true, true);
+		}
 	}
 #endif
 #ifdef __s390x__
--=20
2.21.1

