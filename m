Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC948351B31
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbhDASGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:06:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55891 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235435AbhDAR7B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:59:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hpXKaWdM30cWIaQVbyhFPNqGgFNQZTFU9RkGsXLMuug=;
        b=Pr3illfwiXx3LSYc9KlPrVODxEKY3WAwTMBw/FASTodgNGhVRtdWK7cSh92h1cu5tBRyVy
        9H1MwsHDjrHDWxrDw0fTIjptky094m3MDLu07DRlZOJ8ew8d4pwZGy7eFOB9IpfBBRsGLX
        UTTVkCJtpuB9eEvrCU+wOmTQ5EpzY9w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-Ef-wpVs8NMa8pPkjpC2bKA-1; Thu, 01 Apr 2021 09:56:18 -0400
X-MC-Unique: Ef-wpVs8NMa8pPkjpC2bKA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AE9B10866A5;
        Thu,  1 Apr 2021 13:56:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 342705D6B1;
        Thu,  1 Apr 2021 13:56:07 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org (open list),
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Will Deacon <will@kernel.org>,
        kvmarm@lists.cs.columbia.edu (open list:KERNEL VIRTUAL MACHINE FOR
        ARM64 (KVM/arm64)), Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Jim Mattson <jmattson@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org (open list:S390),
        Heiko Carstens <hca@linux.ibm.com>,
        Kieran Bingham <kbingham@kernel.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-arm-kernel@lists.infradead.org (moderated list:KERNEL VIRTUAL
        MACHINE FOR ARM64 (KVM/arm64)), James Morse <james.morse@arm.com>
Subject: [PATCH v2 7/9] KVM: SVM: split svm_handle_invalid_exit
Date:   Thu,  1 Apr 2021 16:54:49 +0300
Message-Id: <20210401135451.1004564-8-mlevitsk@redhat.com>
In-Reply-To: <20210401135451.1004564-1-mlevitsk@redhat.com>
References: <20210401135451.1004564-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split the check for having a vmexit handler to
svm_check_exit_valid, and make svm_handle_invalid_exit
only handle a vmexit that is already not valid.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 271196400495..2aa951bc470c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3220,12 +3220,14 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       "excp_to:", save->last_excp_to);
 }
 
-static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
+static bool svm_check_exit_valid(struct kvm_vcpu *vcpu, u64 exit_code)
 {
-	if (exit_code < ARRAY_SIZE(svm_exit_handlers) &&
-	    svm_exit_handlers[exit_code])
-		return 0;
+	return (exit_code < ARRAY_SIZE(svm_exit_handlers) &&
+		svm_exit_handlers[exit_code]);
+}
 
+static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
+{
 	vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%llx\n", exit_code);
 	dump_vmcb(vcpu);
 	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
@@ -3233,14 +3235,13 @@ static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
 	vcpu->run->internal.ndata = 2;
 	vcpu->run->internal.data[0] = exit_code;
 	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
-
-	return -EINVAL;
+	return 0;
 }
 
 int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
 {
-	if (svm_handle_invalid_exit(vcpu, exit_code))
-		return 0;
+	if (!svm_check_exit_valid(vcpu, exit_code))
+		return svm_handle_invalid_exit(vcpu, exit_code);
 
 #ifdef CONFIG_RETPOLINE
 	if (exit_code == SVM_EXIT_MSR)
-- 
2.26.2

