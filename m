Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4125A9B3E
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 17:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbiIAPIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 11:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiIAPIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 11:08:14 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF7C74343
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 08:08:13 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id c66so7476739pfc.10
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 08:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Fq0ekErVXJDWil/E50tDxiM+tfA4mWxyU7wswKHf5FY=;
        b=UMllB6o3GSAyrYXYQvdageapI9InpEBTzYUnaB//0Dr7iv9Yy4xL5EiZNrYM+NPntC
         I310zPiDU4mhpBT3SWUKIjT/k6alv9tWwizNDssmOGwN7201o6MjmH64cbKeJcz7zqOZ
         IOD7fH9Gak7FkjTikOi7rLVKCOGtswejt0u4sHNmsLcYBFkL35MJ1miF7nnAvLXcdoCK
         w7iH6jnZNpb0J9j8tyt+bS6dJDm1+X5uZjVYIWE0gee4Roga4Qs8Ok5ahVnARLyNr9Nl
         1NQdbZiE3xoP+BFi+cSGGOUu+Ggc16S3RYb9SJa6Gwu3ARTsUHAdgIzOh/08gPbvoBKO
         uAbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Fq0ekErVXJDWil/E50tDxiM+tfA4mWxyU7wswKHf5FY=;
        b=PC1lUOkTtS/4U9hcK4ozA4czQUrL5ZPfCm+91G6tiq7CF6Epq3leullvpGdY4zwSoT
         6mPtThLXPgQXwUOgOQIGLEafVUQ9ilUtBdzhXg1HCmX6mzACsvakl5z8KAkK1idUGPWi
         g06Nc7sGMuwbVoKYlQovFTfQWJG8T6YV1D0kBK2yx0U9m9ZslxF3r04XA1PREBpQW92v
         bK5KGK69ym3P1Po5VEDn3lvMTFzoHH3gpeaQX2J3NrxSbNSgJb0Rwarsi3570Q40c+af
         0eqylI+80Trx9ms8aN3hTj47/LMoDft7JhKdGZvRTvmFkdk+pKEtK0IDDmrPkylN1zUv
         r/Wg==
X-Gm-Message-State: ACgBeo1xEiFxavlUJOasGpdMAvD02IsjHq5trKXeyecP4T6VK3Z4XOgU
        fF7LtCqgF2ZdMAp92d9S3GYGHg==
X-Google-Smtp-Source: AA6agR6tqozr7gCfHGpwcc/zCo72xzDKevY2OMKHYb1ZNcrHbpzo4uDKZKmR9TQLEHU7lYT/CFnasg==
X-Received: by 2002:a63:5620:0:b0:429:9ad7:b4f2 with SMTP id k32-20020a635620000000b004299ad7b4f2mr26305648pgb.162.1662044892953;
        Thu, 01 Sep 2022 08:08:12 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id r14-20020a17090a4dce00b001fde4a4c28csm3387201pjl.37.2022.09.01.08.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 08:08:12 -0700 (PDT)
Date:   Thu, 1 Sep 2022 15:08:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH 03/19] Revert "KVM: SVM: Introduce hybrid-AVIC mode"
Message-ID: <YxDK2GIlhr+mQFWd@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
 <20220831003506.4117148-4-seanjc@google.com>
 <17e776dccf01e03bce1356beb8db0741e2a13d9a.camel@redhat.com>
 <84c2e836d6ba4eae9fa20329bcbc1d19f8134b0f.camel@redhat.com>
 <Yw+MYLyVXvxmbIRY@google.com>
 <59206c01da236c836c58ff96c5b4123d18a28b2b.camel@redhat.com>
 <Yw+yjo4TMDYnyAt+@google.com>
 <c6e9a565d60fb602a9f4fc48f2ce635bf658f1ea.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6e9a565d60fb602a9f4fc48f2ce635bf658f1ea.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry for forking a bunch of different threads, wanted to respond to the other
stuff before you signed off for the day.

On Thu, Sep 01, 2022, Maxim Levitsky wrote:
> However when APIC mode changes to x2apic, I don't think that we zap that
> SPTE.

Hmm, yes. 

> A side efect of this will be that AVIC in hybrid mode will just work and be
> 100% to the spec. 

And I believe we can solve the avic_set_virtual_apic_mode() issue as well.  If
x2APIC is treated as an inhibit for xAPIC but not APICv at large, then setting the
inhibit will zap the SPTEs, and toggling the inhibit will force AVIC to re-assess
its VMCB controls without needing to hook ->set_virtual_apic_mode().

Roughly what I'm thinking.  I'll try to give this a shot today.

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 164b002777cf..0b69acef2bee 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2381,7 +2381,11 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
        if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
                kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
 
-       if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
+       if ((old_value ^ value) & X2APIC_ENABLE) {
+               kvm_set_or_clear_apicv_inhibit(vcpu->kvm,
+                                              APICV_INHIBIT_REASON_X2APIC,
+                                              value & X2APIC_ENABLE;
+       } else if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE) {
                kvm_vcpu_update_apicv(vcpu);
                static_call_cond(kvm_x86_set_virtual_apic_mode)(vcpu);
        }
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 270403610185..76d93f87071f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4156,7 +4156,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
                 * when the AVIC is re-enabled.
                 */
                if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
-                   !kvm_apicv_activated(vcpu->kvm))
+                   !kvm_xapic_apicv_activated(vcpu->kvm))
                        return RET_PF_EMULATE;
        }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1328326acfae..ee381d155adc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9297,11 +9297,24 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
        kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq, NULL);
 }
 
-bool kvm_apicv_activated(struct kvm *kvm)
+bool kvm_xapic_apicv_activated(struct kvm *kvm)
 {
        return (READ_ONCE(kvm->arch.apicv_inhibit_reasons) == 0);
 }
 
+bool kvm_apicv_activated(struct kvm *kvm)
+{
+       unsigned long inhibits = READ_ONCE(kvm->arch.apicv_inhibit_reasons);
+
+       /*
+        * x2APIC only needs to "inhibit" the MMIO region, all other aspects of
+        * APICv can continue to be utilized.
+        */
+       inhibits &= ~APICV_INHIBIT_REASON_X2APIC;
+
+       return !inhibits;
+}
+
 bool kvm_vcpu_apicv_activated(struct kvm_vcpu *vcpu)
 {
        ulong vm_reasons = READ_ONCE(vcpu->kvm->arch.apicv_inhibit_reasons);

