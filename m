Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE7D44DA7B
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 17:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbhKKQcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 11:32:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33812 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234342AbhKKQcV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 11:32:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636648172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fzs/tu22nSIiklxyWhqw5I8HgPrSNduRvkzTjwACmGg=;
        b=Lus6dqkDci3jixuzICU8ED0pM3LNo19UZhn/FW997cVdA4hU6WvqUcKjCMa1SBQIwyTSHm
        PLcAliD04rhx2cn6/Zy1BlF7NJU8OB4uSd882HpLWrCydvK7Yvrszj3odg0p2KTUNHE5rr
        /d9obasamHGQoaQwKO4eTh8zzYTi/cI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-OgT-AuPfP963EDRa56NUfg-1; Thu, 11 Nov 2021 11:29:28 -0500
X-MC-Unique: OgT-AuPfP963EDRa56NUfg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7590CBAFBD;
        Thu, 11 Nov 2021 16:29:24 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D9DB10495BC;
        Thu, 11 Nov 2021 16:29:20 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] KVM: x86: Drop arbitraty KVM_SOFT_MAX_VCPUS
Date:   Thu, 11 Nov 2021 17:27:46 +0100
Message-Id: <20211111162746.100598-6-vkuznets@redhat.com>
In-Reply-To: <20211111162746.100598-1-vkuznets@redhat.com>
References: <20211111162746.100598-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index ac83d873d65b..18a00a7c23bc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4137,7 +4137,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = !static_call(kvm_x86_cpu_has_accelerated_tpr)();
 		break;
 	case KVM_CAP_NR_VCPUS:
-		r = KVM_SOFT_MAX_VCPUS;
+		r = min_t(unsigned int, num_online_cpus(), KVM_MAX_VCPUS);
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
-- 
2.33.1

