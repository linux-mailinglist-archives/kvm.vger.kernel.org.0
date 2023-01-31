Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAFAE683954
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 23:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjAaW2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 17:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjAaW2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 17:28:44 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEF113D41
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 14:28:43 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id m13so4689375plx.13
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 14:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N7s5g/njGNZsKUP9bAQb4HSON8Z3dq/K+SA0pUZricQ=;
        b=mAH8PQYsCu2WsusNle75fK+ImCQJbe6PwHrn65rGsY9u3wY4P+r30oPg17wcax6EkL
         s6aE6kRtwrHxa6unsjnMzjC3+1K8KRceFqsU5+SdlxsogaGfY9Dgjj3Vda+g3Tlc7fng
         GsXsVfGYls49N1tixbqDfqfCSrzj1qYfLhGgUgIw+qQlWxjSEY6B7QdnIkhSowDpV3Lt
         MmU1CbAeZGdqQRoUZd6270KsC1SzXkrcSi3ptXwhq72nFuV4gQiQavLJVK8/ykhNXGeH
         OtGyHbrq5z728kqlr8usdqSOHnKoaDQKxdwIaqWG0rcINo2qFA3WRZhFwBxNpeDbw1FV
         fOgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N7s5g/njGNZsKUP9bAQb4HSON8Z3dq/K+SA0pUZricQ=;
        b=oAT8oDMzPjL2ezCPMkJId8YRiUxecBzpj05jUzWCPxzb/Lh8bMyzg88mpicoTetQlz
         vi2zJReGsb3XNNoGDLaZhqtfjQzTYlUpUqzxueyEgrW13LLdw6Rvv1c0vpIVGMc6wteT
         fIj4p/CI2uPfCAfKxrXIAv3LyysFp/Xw+QwnztGJDDuF/3kuyHqZ5AXthH2TTg304Ivv
         FXIturw2LgMKu3EMZK6lDEpUJaO/YUK4UIeyW1ZwlP1KpBYX983woB5bXU1nXghtnMYq
         Al+7isk8Mhgslooe2+iAC0o6Go+GT2nkUybp43t0Bi5/Z2WF36UpP3GjfK48XF4RDHeh
         cvcg==
X-Gm-Message-State: AO0yUKWQbFajuV/AdXSSdyaO3DMeZ2bXPKTAWuzEPLonryndLgagwiXO
        NMRInFJzul0SDb4JXI8BZSahIw==
X-Google-Smtp-Source: AK7set9P4eybO7vgLjy2Ta8j4KN+vUkU4sgnPdrhY+RoILUDe983URuNAhrj8GrLzIh3DwbaSI8oRg==
X-Received: by 2002:a05:6a20:a69d:b0:9d:c38f:9bdd with SMTP id ba29-20020a056a20a69d00b0009dc38f9bddmr174533pzb.2.1675204122667;
        Tue, 31 Jan 2023 14:28:42 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o9-20020a1709026b0900b00180033438a0sm10215571plk.106.2023.01.31.14.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 14:28:42 -0800 (PST)
Date:   Tue, 31 Jan 2023 22:28:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 07/11] KVM: x86: add a delayed hardware NMI injection
 interface
Message-ID: <Y9mWFlGdzoa8ZDW7@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-8-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129193717.513824-8-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29, 2022, Maxim Levitsky wrote:
> @@ -5191,9 +5191,12 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>  
>  	vcpu->arch.nmi_injected = events->nmi.injected;
>  	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING)
> -		vcpu->arch.nmi_pending = events->nmi.pending;
> +		atomic_add(events->nmi.pending, &vcpu->arch.nmi_queued);
> +
>  	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
>  
> +	process_nmi(vcpu);

Argh, having two process_nmi() calls is ugly (not blaming your code, it's KVM's
ABI that's ugly).  E.g. if we collapse this down, it becomes:

	process_nmi(vcpu);

	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
		<blah blah blah>
	}
	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);

	process_nmi(vcpu);

And the second mess is that V_NMI needs to be cleared.

The first process_nmi() effectively exists to (a) purge nmi_queued and (b) keep
nmi_pending if KVM_VCPUEVENT_VALID_NMI_PENDING is not set.  I think we can just
replace that with an set of nmi_queued, i.e.

	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
		vcpu->arch-nmi_pending = 0;	
		atomic_set(&vcpu->arch.nmi_queued, events->nmi.pending);
		process_nmi();
	}

because if nmi_queued is non-zero in the !KVM_VCPUEVENT_VALID_NMI_PENDING, then
there should already be a pending KVM_REQ_NMI.  Alternatively, replace process_nmi()
with a KVM_REQ_NMI request (that probably has my vote?).

If that works, can you do that in a separate patch?  Then this patch can tack on
a call to clear V_NMI.

>  	if (events->flags & KVM_VCPUEVENT_VALID_SIPI_VECTOR &&
>  	    lapic_in_kernel(vcpu))
>  		vcpu->arch.apic->sipi_vector = events->sipi_vector;
> @@ -10008,6 +10011,10 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
>  static void process_nmi(struct kvm_vcpu *vcpu)
>  {
>  	unsigned limit = 2;
> +	int nmi_to_queue = atomic_xchg(&vcpu->arch.nmi_queued, 0);
> +
> +	if (!nmi_to_queue)
> +		return;
>  
>  	/*
>  	 * x86 is limited to one NMI running, and one NMI pending after it.
> @@ -10015,13 +10022,34 @@ static void process_nmi(struct kvm_vcpu *vcpu)
>  	 * Otherwise, allow two (and we'll inject the first one immediately).
>  	 */
>  	if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_injected)
> -		limit = 1;
> +		limit--;
> +
> +	/* Also if there is already a NMI hardware queued to be injected,
> +	 * decrease the limit again
> +	 */
> +	if (static_call(kvm_x86_get_hw_nmi_pending)(vcpu))
> +		limit--;

I don't think this is correct.  If a vNMI is pending and NMIs are blocked, then
limit will end up '0' and KVM will fail to pend the additional NMI in software.
After much fiddling, and factoring in the above, how about this?

	unsigned limit = 2;

	/*
	 * x86 is limited to one NMI running, and one NMI pending after it.
	 * If an NMI is already in progress, limit further NMIs to just one.
	 * Otherwise, allow two (and we'll inject the first one immediately).
	 */
	if (vcpu->arch.nmi_injected) {
		/* vNMI counts as the "one pending NMI". */
		if (static_call(kvm_x86_is_vnmi_pending)(vcpu))
			limit = 0;
		else
			limit = 1;
	} else if (static_call(kvm_x86_get_nmi_mask)(vcpu) ||
		   static_call(kvm_x86_is_vnmi_pending)(vcpu)) {
		limit = 1;
	}

	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);

	if (vcpu->arch.nmi_pending &&
	    static_call(kvm_x86_set_vnmi_pending(vcpu)))
		vcpu->arch.nmi_pending--;

	if (vcpu->arch.nmi_pending)
		kvm_make_request(KVM_REQ_EVENT, vcpu);

With the KVM_REQ_EVENT change in a separate prep patch:

--
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 31 Jan 2023 13:33:02 -0800
Subject: [PATCH] KVM: x86: Raise an event request when processing NMIs iff an
 NMI is pending

Don't raise KVM_REQ_EVENT if no NMIs are pending at the end of
process_nmi().  Finishing process_nmi() without a pending NMI will become
much more likely when KVM gains support for AMD's vNMI, which allows
pending vNMIs in hardware, i.e. doesn't require explicit injection.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 508074e47bc0..030136b6ebbd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10134,7 +10134,9 @@ static void process_nmi(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
 	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);
-	kvm_make_request(KVM_REQ_EVENT, vcpu);
+
+	if (vcpu->arch.nmi_pending)
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
 
 void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,

base-commit: 916b54a7688b0b9a1c48c708b848e4348c3ae2ab
-- 
