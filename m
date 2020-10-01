Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D272027FA21
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 09:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731342AbgJAHWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 03:22:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731330AbgJAHWo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 03:22:44 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601536962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=3CD6D8u0IDtlVRO4Rki12jrlUun38FvaDxOMGSocPnA=;
        b=IfOyB6618ac/Qe29q1iWkTkFA/qawNs78n6ttAOrtusGhoU7zrhFdStHPQ5Ln62JiUG1RS
        sMhVRiL/JB1ctT2kJPZjrgKmx+MewdRCMX2Uf47zrbTD17/rFAhy7l8YMYLUCEp/dNDchY
        c0Pra7vlYMRnCcWxho4t8EGtqmDqnis=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-nN_utaYEMi64SBOmvLLDwQ-1; Thu, 01 Oct 2020 03:22:40 -0400
X-MC-Unique: nN_utaYEMi64SBOmvLLDwQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCA6A873119
        for <kvm@vger.kernel.org>; Thu,  1 Oct 2020 07:22:39 +0000 (UTC)
Received: from thuth.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F57C60BF1;
        Thu,  1 Oct 2020 07:22:38 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, lvivier@redhat.com
Subject: [PATCH v2 1/7] travis.yml: Rework the x86 64-bit tests
Date:   Thu,  1 Oct 2020 09:22:28 +0200
Message-Id: <20201001072234.143703-2-thuth@redhat.com>
In-Reply-To: <20201001072234.143703-1-thuth@redhat.com>
References: <20201001072234.143703-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
Clang.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index ef3cc40..0feaec1 100644
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
-               kvmclock_test msr pcid rdpru realmode rmap_chain s3 setjmp umip"
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
+          rdpru realmode rmap_chain s3 setjmp sieve smap smptest smptest3
+          syscall tsc tsc_adjust tsx-ctrl umip vmexit_cpuid vmexit_inl_pmtimer
+          vmexit_ipi vmexit_ipi_halt vmexit_mov_from_cr8 vmexit_mov_to_cr8
+          vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
+          vmexit_vmcall vmx_apic_passthrough_thread xsave"
       - ACCEL="kvm"
 
     - addons:
-- 
2.18.2

