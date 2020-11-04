Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8542A6F91
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 22:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731985AbgKDVYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 16:24:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21232 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729828AbgKDVYN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 16:24:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604525052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x7/Wf0IuIaYM1juLS5dLyn5/J87lHx9a4D+VHeUtWFQ=;
        b=MPhCiQ+0O0b7vn9ZtDh4BjWekau0/DGURjeRVPeygxcPFKL3knnE1ir+qyJDIscFNeKIZ3
        DYfibZV/YuJvviw2dfcMoO0AhIcwwq1hAGS3CyFL8Gc+3MbQy+6qBVTQErUbN7ksJTo37s
        e8NblMIusZmBr9OHXHh+BHOWGLvkjvw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298--1_TvCjLPeCeAeqtslHiRA-1; Wed, 04 Nov 2020 16:24:10 -0500
X-MC-Unique: -1_TvCjLPeCeAeqtslHiRA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35F7B100F775;
        Wed,  4 Nov 2020 21:24:09 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 440405D98F;
        Wed,  4 Nov 2020 21:24:06 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH 02/11] KVM: selftests: Drop pointless vm_create wrapper
Date:   Wed,  4 Nov 2020 22:23:48 +0100
Message-Id: <20201104212357.171559-3-drjones@redhat.com>
In-Reply-To: <20201104212357.171559-1-drjones@redhat.com>
References: <20201104212357.171559-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
 tools/testing/selftests/kvm/dirty_log_test.c     | 2 +-
 tools/testing/selftests/kvm/include/kvm_util.h   | 1 -
 tools/testing/selftests/kvm/lib/kvm_util.c       | 7 +------
 4 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 360cd3ea4cd6..d1fe6c8e595b 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -166,7 +166,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, int vcpus,
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	vm = _vm_create(mode, pages, O_RDWR);
+	vm = vm_create(mode, pages, O_RDWR);
 	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
 #ifdef __x86_64__
 	vm_create_irqchip(vm);
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 752ec158ac59..37445aa4876f 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -252,7 +252,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	vm = _vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
+	vm = vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
 	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
 #ifdef __x86_64__
 	vm_create_irqchip(vm);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 919e161dd289..ebf7f87d72df 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -65,7 +65,6 @@ int kvm_check_cap(long cap);
 int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
 
 struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
-struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
 void kvm_vm_free(struct kvm_vm *vmp);
 void kvm_vm_restart(struct kvm_vm *vmp, int perm);
 void kvm_vm_release(struct kvm_vm *vmp);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 3327cebc1095..b9943e935dc7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -152,7 +152,7 @@ _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params)
  * descriptor to control the created VM is created with the permissions
  * given by perm (e.g. O_RDWR).
  */
-struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
+struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 {
 	struct kvm_vm *vm;
 
@@ -243,11 +243,6 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 	return vm;
 }
 
-struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
-{
-	return _vm_create(mode, phy_pages, perm);
-}
-
 /*
  * VM Restart
  *
-- 
2.26.2

