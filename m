Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D52A277668
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 18:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgIXQQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 12:16:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21734 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726900AbgIXQQf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 12:16:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600964193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=r5Jds/eXAP3wYBOEkstBuMvhZ77tu8VT8maKv+pV3f4=;
        b=E0CiiRkRZ/hNsPCr2w1NsxFzzF3tYd8GXfDNdqIraRtEfRg9LeULpNI60jDduSiFoJqok/
        VvSsUF09Fv+8A3si99kVT8r2PtLGSdIYk5+BLTTrQN083t12WWQZk84UCJ1d+9x4omCfpz
        dVH1QNWxnWF/rPvoC6zXPgha/dvRG68=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-Vt265L-dOMeZ6TzqYqR5GA-1; Thu, 24 Sep 2020 12:16:31 -0400
X-MC-Unique: Vt265L-dOMeZ6TzqYqR5GA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7C161084C8A;
        Thu, 24 Sep 2020 16:16:30 +0000 (UTC)
Received: from thuth.com (ovpn-113-113.ams2.redhat.com [10.36.113.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB0C173662;
        Thu, 24 Sep 2020 16:16:28 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Drew Jones <drjones@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH 2/9] travis.yml: Rework the x86 64-bit tests
Date:   Thu, 24 Sep 2020 18:16:05 +0200
Message-Id: <20200924161612.144549-3-thuth@redhat.com>
In-Reply-To: <20200924161612.144549-1-thuth@redhat.com>
References: <20200924161612.144549-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We currently have three test jobs here:

1) gcc, in-tree build
2) gcc, out-of-tree build
3) clang, in-tree build

Keeping everything in perspective, it should be sufficient to only use two
build jobs for this, one in-tree with one compiler, and one out-of-tree
with the other compiler.
So let's re-order the jobs accordingly now. And while we're at it, make
sure that all additional tests that work with the newer QEMU from Ubuntu
Focal now are tested, too, and that we check all possible tests with
Clang (i.e. the same list as with GCC except for the "realmode" test
that still causes some problems with Clang).

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 3b18ce5..4c35509 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -12,30 +12,30 @@ jobs:
       env:
       - CONFIG=""
       - BUILD_DIR="."
-      - TESTS="access asyncpf debug emulator ept hypercall hyperv_stimer
-               hyperv_synic idt_test intel_iommu ioapic ioapic-split
-               kvmclock_test msr pcid rdpru realmode rmap_chain s3 setjmp umip"
+      - TESTS="access asyncpf debug emulator ept hypercall hyperv_clock
+          hyperv_connections hyperv_stimer hyperv_synic idt_test intel_iommu
+          ioapic ioapic-split kvmclock_test memory msr pcid pcid-disabled
+          rdpru realmode rmap_chain s3 setjmp sieve smap smptest smptest3
+          syscall tsc tsc_adjust tsx-ctrl umip vmexit_cpuid vmexit_inl_pmtimer
+          vmexit_ipi vmexit_ipi_halt vmexit_mov_from_cr8 vmexit_mov_to_cr8
+          vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
+          vmexit_vmcall vmx_apic_passthrough_thread xsave"
       - ACCEL="kvm"
 
     - addons:
         apt_packages: clang-10 qemu-system-x86
+      compiler: clang
       env:
       - CONFIG="--cc=clang-10"
-      - BUILD_DIR="."
-      - TESTS="access asyncpf debug emulator ept hypercall hyperv_stimer
-               hyperv_synic idt_test intel_iommu ioapic ioapic-split
-               kvmclock_test msr pcid rdpru rmap_chain s3 setjmp umip"
-      - ACCEL="kvm"
-
-    - addons:
-        apt_packages: gcc qemu-system-x86
-      env:
-      - CONFIG=""
       - BUILD_DIR="x86-builddir"
-      - TESTS="smptest smptest3 tsc tsc_adjust xsave vmexit_cpuid vmexit_vmcall
-               sieve vmexit_inl_pmtimer vmexit_ipi_halt vmexit_mov_from_cr8
-               vmexit_mov_to_cr8 vmexit_ple_round_robin vmexit_tscdeadline
-               vmexit_tscdeadline_immed  vmx_apic_passthrough_thread syscall"
+      - TESTS="access asyncpf debug emulator ept hypercall hyperv_clock
+          hyperv_connections hyperv_stimer hyperv_synic idt_test intel_iommu
+          ioapic ioapic-split kvmclock_test memory msr pcid pcid-disabled
+          rdpru rmap_chain s3 setjmp sieve smap smptest smptest3 syscall tsc
+          tsc_adjust tsx-ctrl umip vmexit_cpuid vmexit_inl_pmtimer vmexit_ipi
+          vmexit_ipi_halt vmexit_mov_from_cr8 vmexit_mov_to_cr8
+          vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
+          vmexit_vmcall vmx_apic_passthrough_thread xsave"
       - ACCEL="kvm"
 
     - addons:
-- 
2.18.2

