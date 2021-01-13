Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1F52F4D50
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 15:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbhAMOjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 09:39:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53454 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726505AbhAMOjA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 09:39:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610548654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nyo6Ug6CBUUsr9Np8NmoohbF5XlqoIrdKIOLBF57t1Y=;
        b=Q1uxZ9XW8jWdAJgOyE4iA265fGyyjOZEA/OoQzk1EXWnz6BzaVVLzz5jm3eeS1Hjr8lfz8
        PEJ1Q7VGuskdvMpgCd0yFRiFovdwswcih50c2T/qwNiZ935TWMJNaEHKdP77h2x/S+/Lgf
        SzQ23tCWE+YZpZqPHUoFogsZuePyllY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-OgXFREiRNWmKagnxf2Hafw-1; Wed, 13 Jan 2021 09:37:30 -0500
X-MC-Unique: OgXFREiRNWmKagnxf2Hafw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D6F2802B4C;
        Wed, 13 Jan 2021 14:37:29 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3ACBC5C3E0;
        Wed, 13 Jan 2021 14:37:27 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 2/7] selftests: kvm: Properly set Hyper-V CPUIDs in evmcs_test
Date:   Wed, 13 Jan 2021 15:37:16 +0100
Message-Id: <20210113143721.328594-3-vkuznets@redhat.com>
In-Reply-To: <20210113143721.328594-1-vkuznets@redhat.com>
References: <20210113143721.328594-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Generally, when Hyper-V emulation is enabled, VMM is supposed to set
Hyper-V CPUID identifications so the guest knows that Hyper-V features
are available. evmcs_test doesn't currently do that but so far Hyper-V
emulation in KVM was enabled unconditionally. As we are about to change
that, proper Hyper-V CPUID identification should be set in selftests as
well.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../testing/selftests/kvm/x86_64/evmcs_test.c | 39 ++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 37b8a78f6b74..39a3cb2bd103 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -78,6 +78,42 @@ void guest_code(struct vmx_pages *vmx_pages)
 	GUEST_ASSERT(vmlaunch());
 }
 
+struct kvm_cpuid2 *guest_get_cpuid(void)
+{
+	static struct kvm_cpuid2 *cpuid_full;
+	struct kvm_cpuid2 *cpuid_sys, *cpuid_hv;
+	int i, nent = 0;
+
+	if (cpuid_full)
+		return cpuid_full;
+
+	cpuid_sys = kvm_get_supported_cpuid();
+	cpuid_hv = kvm_get_supported_hv_cpuid();
+
+	cpuid_full = malloc(sizeof(*cpuid_full) +
+			    (cpuid_sys->nent + cpuid_hv->nent) *
+			    sizeof(struct kvm_cpuid_entry2));
+	if (!cpuid_full) {
+		perror("malloc");
+		abort();
+	}
+
+	/* Need to skip KVM CPUID leaves 0x400000xx */
+	for (i = 0; i < cpuid_sys->nent; i++) {
+		if (cpuid_sys->entries[i].function >= 0x40000000 &&
+		    cpuid_sys->entries[i].function < 0x40000100)
+			continue;
+		cpuid_full->entries[nent] = cpuid_sys->entries[i];
+		nent++;
+	}
+
+	memcpy(&cpuid_full->entries[nent], cpuid_hv->entries,
+	       cpuid_hv->nent * sizeof(struct kvm_cpuid_entry2));
+	cpuid_full->nent = nent + cpuid_hv->nent;
+
+	return cpuid_full;
+}
+
 int main(int argc, char *argv[])
 {
 	vm_vaddr_t vmx_pages_gva = 0;
@@ -99,6 +135,7 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
+	vcpu_set_cpuid(vm, VCPU_ID, guest_get_cpuid());
 	vcpu_enable_evmcs(vm, VCPU_ID);
 
 	run = vcpu_state(vm, VCPU_ID);
@@ -142,7 +179,7 @@ int main(int argc, char *argv[])
 		/* Restore state in a new VM.  */
 		kvm_vm_restart(vm, O_RDWR);
 		vm_vcpu_add(vm, VCPU_ID);
-		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+		vcpu_set_cpuid(vm, VCPU_ID, guest_get_cpuid());
 		vcpu_enable_evmcs(vm, VCPU_ID);
 		vcpu_load_state(vm, VCPU_ID, state);
 		run = vcpu_state(vm, VCPU_ID);
-- 
2.29.2

