Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63F50148561
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 13:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388812AbgAXMrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 07:47:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47721 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387709AbgAXMrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 07:47:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579870026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ChLDmdrX0uO5zFp9WY4jkSOIQvobAH+yrFsmG1ZcUzY=;
        b=hNHEMZ0+PN70xguWEiqziOzBvyNrYjAxa29q0nwKgBWYTu5Gqd2haMN18bRhabjZvHb4OU
        dA7N23m01qaR27qz6+V6GhaFLITuz8PVpOGVye6qM63GvagW+jHseehghHssyR9cJSpguB
        95kTpl4SlG0xX3oAwNee2YmbjBkeDlQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-X_TKEVurOSKMwFWtWgpp3A-1; Fri, 24 Jan 2020 07:47:05 -0500
X-MC-Unique: X_TKEVurOSKMwFWtWgpp3A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 173BA800D41
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2020 12:47:04 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40B6819C69;
        Fri, 24 Jan 2020 12:47:03 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH] kvm: selftests: aarch64: dirty_log_test: Remove unnecessary ifdefs
Date:   Fri, 24 Jan 2020 13:47:01 +0100
Message-Id: <20200124124701.32688-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 21 +++++++++-----------
 1 file changed, 9 insertions(+), 12 deletions(-)

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
2.18.2

