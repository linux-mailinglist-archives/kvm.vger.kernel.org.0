Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F4C4BAB70
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 22:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244766AbiBQVE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 16:04:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244229AbiBQVEL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 16:04:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41E71D1080
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 13:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645131834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mUS9+xPfstqadLkqJ3LrklUPZUjyiG4wtcGNmDoEiYw=;
        b=GENKnGurh3XErsaAhB38smM7kFfVwBxMm1JEhSxm0bPdwxVSPyZsNBTnWTW35HTj2oTGiA
        Nd6I0Tfv7HyfhtBPZuz4nd3BC+DhyHgdyGkF3BK5k6wk2Fmw8XEzHJTgPJgm8UFZeSdxZ+
        zYdp+Mjz1/nLQTAyZ+2S43EN2ivfSdk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-311-gP4HMt8lMwyQIBWXz0nXDg-1; Thu, 17 Feb 2022 16:03:51 -0500
X-MC-Unique: gP4HMt8lMwyQIBWXz0nXDg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E48C01091DA0;
        Thu, 17 Feb 2022 21:03:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95C486AB90;
        Thu, 17 Feb 2022 21:03:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v2 18/18] KVM: x86: do not unload MMU roots on all role changes
Date:   Thu, 17 Feb 2022 16:03:40 -0500
Message-Id: <20220217210340.312449-19-pbonzini@redhat.com>
In-Reply-To: <20220217210340.312449-1-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_mmu_reset_context is called on all role changes and right now it
calls kvm_mmu_unload.  With the legacy MMU this is a relatively cheap
operation; the previous PGDs remains in the hash table and is picked
up immediately on the next page fault.  With the TDP MMU, however, the
roots are thrown away for good and a full rebuild of the page tables is
necessary, which is many times more expensive.

Fortunately, throwing away the roots is not necessary except when
the manual says a TLB flush is required:

- changing CR0.PG from 1 to 0 (because it flushes the TLB according to
  the x86 architecture specification)

- changing CPUID (which changes the interpretation of page tables in
  ways not reflected by the role).

- changing CR4.SMEP from 0 to 1 (not doing so actually breaks access.c)

Except for these cases, once the MMU has updated the CPU/MMU roles
and metadata it is enough to force-reload the current value of CR3.
KVM will look up the cached roots for an entry with the right role and
PGD, and only if the cache misses a new root will be created.

Measuring with vmexit.flat from kvm-unit-tests shows the following
improvement:

             TDP         legacy       shadow
   before    46754       5096         5150
   after     4879        4875         5006

which is for very small page tables.  The impact is however much larger
when running as an L1 hypervisor, because the new page tables cause
extra work for L0 to shadow them.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c44b5114f947..913cc7229bf4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5043,8 +5043,8 @@ EXPORT_SYMBOL_GPL(kvm_init_mmu);
 void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	/*
-	 * Invalidate all MMU roles to force them to reinitialize as CPUID
-	 * information is factored into reserved bit calculations.
+	 * Invalidate all MMU roles and roots to force them to reinitialize,
+	 * as CPUID information is factored into reserved bit calculations.
 	 *
 	 * Correctly handling multiple vCPU models with respect to paging and
 	 * physical address properties) in a single VM would require tracking
@@ -5057,6 +5057,7 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.root_mmu.mmu_role.ext.valid = 0;
 	vcpu->arch.guest_mmu.mmu_role.ext.valid = 0;
 	vcpu->arch.nested_mmu.mmu_role.ext.valid = 0;
+	kvm_mmu_unload(vcpu);
 	kvm_mmu_reset_context(vcpu);
 
 	/*
@@ -5068,8 +5069,8 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
 {
-	kvm_mmu_unload(vcpu);
 	kvm_init_mmu(vcpu);
+	kvm_make_request(KVM_REQ_MMU_UPDATE_ROOT, vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_reset_context);
 
-- 
2.31.1

