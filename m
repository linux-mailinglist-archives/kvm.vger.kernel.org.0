Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBF3351A98
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236184AbhDASCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:02:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54681 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236571AbhDAR6C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:58:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fL+sm3fDoeQVw/phEkL72DmeE0hZ8upmmmSY12kpjHo=;
        b=fPiRrvTBK0hXT7v/XKBrAIUebpXjYLdMEpsExL6H8K0hyFAtmB653LDTjG0ZkXpUMa+wjB
        kwYpnb9MzeDAYCeR5T3VmXUd6GRftoh6sj0ZxkSUxTTwdTVbX8BbOyANUYW48jEgj1QaEJ
        mawCACHv21yPkNXR5RZnksWHGlQI1No=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-zaaTPaldOCWh5S3hVw1eLA-1; Thu, 01 Apr 2021 09:56:30 -0400
X-MC-Unique: zaaTPaldOCWh5S3hVw1eLA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CDF5107ACCD;
        Thu,  1 Apr 2021 13:56:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A83185D6B1;
        Thu,  1 Apr 2021 13:56:15 +0000 (UTC)
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
        MACHINE FOR ARM64 (KVM/arm64)), James Morse <james.morse@arm.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH v2 8/9] KVM: x86: add force_intercept_exceptions_mask
Date:   Thu,  1 Apr 2021 16:54:50 +0300
Message-Id: <20210401135451.1004564-9-mlevitsk@redhat.com>
In-Reply-To: <20210401135451.1004564-1-mlevitsk@redhat.com>
References: <20210401135451.1004564-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This parameter will be used by VMX and SVM code to force
interception of a set of exceptions, given by a bitmask
for guest debug and/or kvm debug.

This option is not intended for production.

This is based on an idea first shown here:
https://patchwork.kernel.org/project/kvm/patch/20160301192822.GD22677@pd.tnic/

CC: Borislav Petkov <bp@suse.de>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 3 +++
 arch/x86/kvm/x86.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3627ce8fe5bb..1a51031d64d8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -176,6 +176,9 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 
+uint force_intercept_exceptions_mask;
+module_param(force_intercept_exceptions_mask, uint, S_IRUGO | S_IWUSR);
+EXPORT_SYMBOL_GPL(force_intercept_exceptions_mask);
 /*
  * Restoring the host value for MSRs that are only consumed when running in
  * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index daccf20fbcd5..644480711ff7 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -311,6 +311,8 @@ extern struct static_key kvm_no_apic_vcpu;
 
 extern bool report_ignored_msrs;
 
+extern uint force_intercept_exceptions_mask;
+
 static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
 {
 	return pvclock_scale_delta(nsec, vcpu->arch.virtual_tsc_mult,
-- 
2.26.2

