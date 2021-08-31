Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB0F3FCEC3
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 22:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241197AbhHaUqf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 16:46:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57375 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240039AbhHaUqe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Aug 2021 16:46:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630442738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MPUXni5LPwSO1o7AfAJmuaMGzG/Eq+Nqde9lJhEFDC8=;
        b=H+clp0aCLZ9Kl5X+sqKDQBNnGMBrm6v7/BFtg1G2pDA0l/pgqIUEr/BWtXiJnxLnp1eGjv
        E9jg0eVgRQPai6gN5yFEfKEg8xwz0ZkRmE6d9xEheboRqs3By1QnjIrI6Lz1H44AnAHPzV
        j5ir+q0ssofjOBQ2WrTWFi8/h72LFSs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-c5L6-OxtPCGSImv8dP1uNw-1; Tue, 31 Aug 2021 16:45:37 -0400
X-MC-Unique: c5L6-OxtPCGSImv8dP1uNw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EB6D190A7B0
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 20:45:36 +0000 (UTC)
Received: from localhost (unknown [10.22.8.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 142B35F9B0;
        Tue, 31 Aug 2021 20:45:35 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH] kvm: x86: Increase MAX_VCPUS to 710
Date:   Tue, 31 Aug 2021 16:45:35 -0400
Message-Id: <20210831204535.1594297-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Support for 710 VCPUs has been tested by Red Hat since RHEL-8.4.
Increase KVM_MAX_VCPUS and KVM_SOFT_MAX_VCPUS to 710.

For reference, visible effects of changing KVM_MAX_VCPUS are:
- KVM_CAP_MAX_VCPUS and KVM_CAP_NR_VCPUS will now return 710 (of course)
- Default value for CPUID[HYPERV_CPUID_IMPLEMENT_LIMITS (00x40000005)].EAX
  will now be 710
- Bitmap stack variables that will grow:
  - At kvm_hv_flush_tlb()  kvm_hv_send_ipi():
    - Sparse VCPU bitmap (vp_bitmap) will be 96 bytes long
    - vcpu_bitmap will be 92 bytes long
  - vcpu_bitmap at bioapic_write_indirect() will be 92 bytes long
    once patch "KVM: x86: Fix stack-out-of-bounds memory access
    from ioapic_write_indirect()" is applied

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index af6ce8d4c86a..f76fae42bf45 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -37,8 +37,8 @@
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
-#define KVM_MAX_VCPUS 288
-#define KVM_SOFT_MAX_VCPUS 240
+#define KVM_MAX_VCPUS 710
+#define KVM_SOFT_MAX_VCPUS 710
 #define KVM_MAX_VCPU_ID 1023
 /* memory slots that are not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 3
-- 
2.31.1

