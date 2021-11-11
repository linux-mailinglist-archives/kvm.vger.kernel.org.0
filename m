Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B46244D787
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 14:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbhKKNup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 08:50:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22217 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233320AbhKKNup (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 08:50:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636638476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xahSpUdRnqSm12epmOAhtr6bKCO9iTR18R9pvrUHXh8=;
        b=Mxcm5Nch1Zg0kZfuDnhtGfG6oZvAbRUtOJOvaVZXYyVIJ9MCkj1P+N8peEio2xJH4Hw9eC
        +3nQL/u6k0z1GeaMa9hBMXjPN7Dv7dKGQbr8dUwunTVs4sERtv8hcZr7FshshH7JAiPRsQ
        jVDUoQLLcF9IrCMegmYw/PNZhBX6GLE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-h4VG2NzdPL6IpNGT5rgpxw-1; Thu, 11 Nov 2021 08:47:52 -0500
X-MC-Unique: h4VG2NzdPL6IpNGT5rgpxw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CEF3871810;
        Thu, 11 Nov 2021 13:47:51 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D9AA556A97;
        Thu, 11 Nov 2021 13:47:34 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC] KVM: x86: Drop arbitraty KVM_SOFT_MAX_VCPUS
Date:   Thu, 11 Nov 2021 14:47:33 +0100
Message-Id: <20211111134733.86601-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CAP_NR_VCPUS is used to get the "recommended" maximum number of
VCPUs and arm64/mips/riscv report num_online_cpus(). Powerpc reports
either num_online_cpus() or num_present_cpus(), s390 has multiple
constants depending on hardware features. On x86, KVM reports an
arbitrary value of '710' which is supposed to be the maximum tested
value but it's possible to test all KVM_MAX_VCPUS even when there are
less physical CPUs available.

Drop the arbitrary '710' value and return num_online_cpus() on x86 as
well. The recommendation will match other architectures and will mean
'no CPU overcommit'.

For reference, QEMU only queries KVM_CAP_NR_VCPUS to print a warning
when the requested vCPU number exceeds it. The static limit of '710'
is quite weird as smaller systems with just a few physical CPUs should
certainly "recommend" less.

Suggested-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/x86.c              | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88fce6ab4bbd..0232a00598f2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -38,7 +38,6 @@
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
 #define KVM_MAX_VCPUS 1024
-#define KVM_SOFT_MAX_VCPUS 710
 
 /*
  * In x86, the VCPU ID corresponds to the APIC ID, and APIC IDs
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b..91ef1b872b90 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4137,7 +4137,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = !static_call(kvm_x86_cpu_has_accelerated_tpr)();
 		break;
 	case KVM_CAP_NR_VCPUS:
-		r = KVM_SOFT_MAX_VCPUS;
+		r = num_online_cpus();
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
-- 
2.33.1

