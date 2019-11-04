Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E41EF0F8
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 00:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbfKDXAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 18:00:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45959 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729194AbfKDXAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 18:00:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572908411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tktmbgMbA44XbKL0C1wWEcJpxBYyzYw3dy09GJTCB3c=;
        b=PSddy8ZYP+HimJ1X3wd/oKMDnkjtie2fCftkQYUOcLvtJ2mnGgMgz5LD+gebNr2hyt4ipQ
        xMl2H6Hcw1BWxAwsbnSBMMVrpXmOdcj1ZJ3/MBzXYfPAICerzayqerPFyxim7yUjNqcAiE
        jp01MnofLUpy2qhCEfGD5+z32FttK30=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-8Y_kaONzMEuyO5vOv_3xzg-1; Mon, 04 Nov 2019 18:00:08 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44F0E1800DFB;
        Mon,  4 Nov 2019 23:00:07 +0000 (UTC)
Received: from mail (ovpn-121-157.rdu2.redhat.com [10.10.121.157])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B0E1B1001B34;
        Mon,  4 Nov 2019 23:00:02 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 01/13] KVM: monolithic: x86: remove kvm.ko
Date:   Mon,  4 Nov 2019 17:59:49 -0500
Message-Id: <20191104230001.27774-2-aarcange@redhat.com>
In-Reply-To: <20191104230001.27774-1-aarcange@redhat.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 8Y_kaONzMEuyO5vOv_3xzg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the first commit of a patch series that aims to replace the
modular kvm.ko kernel module with a monolithic kvm-intel/kvm-amd
model. This change has the only possible cons of wasting some disk
space in /lib/modules/. The pros are that it saves CPUS and some minor
iTLB and RAM which are more scarse resources than disk space.

The pointer to function virtual template model cannot provide any
runtime benefit because kvm-intel and kvm-amd can't be loaded at the
same time.

This removes kvm.ko and it links and duplicates all kvm.ko objects to
both kvm-amd and kvm-intel.

Linking both vmx and svm into the kernel at the same time isn't
possible anymore or the kvm_x86/kvm_x86_pmu external function names
would collide.

Explanation of Kbuild from Paolo Bonzini follows:

=3D=3D=3D
The left side of the "||" ensures that, if KVM=3Dm, you can only choose
module build for both KVM_INTEL and KVM_AMD.  Having just "depends on
KVM" would allow a pre-existing .config to choose the now-invalid
combination

        CONFIG_KVM=3Dy
        CONFIG_KVM_INTEL=3Dy
        CONFIG_KVM_AMD=3Dy

The right side of the "||" part is just for documentation, to avoid
that a selected symbol does not satisfy its dependencies.
=3D=3D=3D=3D

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/kvm/Kconfig  | 30 ++++++++++++++++++++++++++----
 arch/x86/kvm/Makefile |  5 ++---
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 840e12583b85..0d6e8809e359 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -59,9 +59,30 @@ config KVM
=20
 =09  If unsure, say N.
=20
+if KVM=3Dy
+
+choice
+=09prompt "KVM built-in support"
+=09help
+=09  In order to build a kernel with support for both AMD and Intel
+=09  CPUs, you need to set CONFIG_KVM=3Dm instead.
+
+config KVM_AMD_STATIC
+=09select KVM_AMD
+=09bool "AMD"
+
+config KVM_INTEL_STATIC
+=09select KVM_INTEL
+=09bool "Intel"
+
+endchoice
+
+endif
+
 config KVM_INTEL
-=09tristate "KVM for Intel processors support"
-=09depends on KVM
+=09tristate
+=09prompt "KVM for Intel processors support" if KVM=3Dm
+=09depends on (KVM=3Dm && m) || KVM_INTEL_STATIC
 =09# for perf_guest_get_msrs():
 =09depends on CPU_SUP_INTEL
 =09---help---
@@ -72,8 +93,9 @@ config KVM_INTEL
 =09  will be called kvm-intel.
=20
 config KVM_AMD
-=09tristate "KVM for AMD processors support"
-=09depends on KVM
+=09tristate
+=09prompt "KVM for AMD processors support" if KVM=3Dm
+=09depends on (KVM=3Dm && m) || KVM_AMD_STATIC
 =09---help---
 =09  Provides support for KVM on AMD processors equipped with the AMD-V
 =09  (SVM) extensions.
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 31ecf7a76d5a..68b81f381369 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -12,9 +12,8 @@ kvm-y=09=09=09+=3D x86.o mmu.o emulate.o i8259.o irq.o la=
pic.o \
 =09=09=09   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 =09=09=09   hyperv.o page_track.o debugfs.o
=20
-kvm-intel-y=09=09+=3D vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o=
 vmx/evmcs.o vmx/nested.o
-kvm-amd-y=09=09+=3D svm.o pmu_amd.o
+kvm-intel-y=09=09+=3D vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o=
 vmx/evmcs.o vmx/nested.o $(kvm-y)
+kvm-amd-y=09=09+=3D svm.o pmu_amd.o $(kvm-y)
=20
-obj-$(CONFIG_KVM)=09+=3D kvm.o
 obj-$(CONFIG_KVM_INTEL)=09+=3D kvm-intel.o
 obj-$(CONFIG_KVM_AMD)=09+=3D kvm-amd.o

