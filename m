Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62357345A20
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 09:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhCWIxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 04:53:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34395 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229915AbhCWIxK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 04:53:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616489590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hwAolZy4s3g0O+tDHC689/78ebeI0EMXlZOQe6J+/Wk=;
        b=ABRicki0MK7rN+i28jCLQ7In2cZsJeDAR1gH3/4h8HD0IiLO1bg9I42yfYROS/gjgj2Q/Z
        NubTDFQG65GD/kWTeWdtUQpVGLqUa8/cPAomFRDVPwy2oAqDzjcJHJmpWUaxaSsZR2VQZC
        DawZaN1aEER3dHu/NHDusNw2cKdvY7w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-9gYoLGQ4MH25yAjgkcH__Q-1; Tue, 23 Mar 2021 04:53:08 -0400
X-MC-Unique: 9gYoLGQ4MH25yAjgkcH__Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6783080006E;
        Tue, 23 Mar 2021 08:53:06 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 875EA69324;
        Tue, 23 Mar 2021 08:53:04 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: kvm: make hardware_disable_test less verbose
Date:   Tue, 23 Mar 2021 09:53:03 +0100
Message-Id: <20210323085303.1347449-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hardware_disable_test produces 512 snippets like
...
 main: [511] waiting semaphore
 run_test: [511] start vcpus
 run_test: [511] all threads launched
 main: [511] waiting 368us
 main: [511] killing child

and this doesn't have much value, let's just drop these fprintf().
Restoring them for debugging purposes shouldn't be too hard.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/hardware_disable_test.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index 2f2eeb8a1d86..d6d4517c4a8a 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -108,7 +108,6 @@ static void run_test(uint32_t run)
 	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
 	vm_create_irqchip(vm);
 
-	fprintf(stderr, "%s: [%d] start vcpus\n", __func__, run);
 	for (i = 0; i < VCPU_NUM; ++i) {
 		vm_vcpu_add_default(vm, i, guest_code);
 		payloads[i].vm = vm;
@@ -124,7 +123,6 @@ static void run_test(uint32_t run)
 			check_set_affinity(throw_away, &cpu_set);
 		}
 	}
-	fprintf(stderr, "%s: [%d] all threads launched\n", __func__, run);
 	sem_post(sem);
 	for (i = 0; i < VCPU_NUM; ++i)
 		check_join(threads[i], &b);
@@ -147,16 +145,13 @@ int main(int argc, char **argv)
 		if (pid == 0)
 			run_test(i); /* This function always exits */
 
-		fprintf(stderr, "%s: [%d] waiting semaphore\n", __func__, i);
 		sem_wait(sem);
 		r = (rand() % DELAY_US_MAX) + 1;
-		fprintf(stderr, "%s: [%d] waiting %dus\n", __func__, i, r);
 		usleep(r);
 		r = waitpid(pid, &s, WNOHANG);
 		TEST_ASSERT(r != pid,
 			    "%s: [%d] child exited unexpectedly status: [%d]",
 			    __func__, i, s);
-		fprintf(stderr, "%s: [%d] killing child\n", __func__, i);
 		kill(pid, SIGKILL);
 	}
 
-- 
2.30.2

