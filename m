Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627927B98D3
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 01:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240950AbjJDXrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 19:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjJDXrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 19:47:19 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472E7C0
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 16:47:16 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-27763c2c27dso386906a91.2
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 16:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696463236; x=1697068036; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WfiepEv/LKhAXzybyJ+CjdLDBfoN1mMfHVU5qQvL01c=;
        b=fl9SXyEFljNctZ0MIa77ROQONCESib3+t8CqfA15x1ratExocx2O4dFqhIh2mjLn3u
         gVSmhavU2sEL/kxvWFRlofqJZO+wHXUgCnePUB5G3fFs/r8qilaovChx689M8AaNbsmm
         o4XV1DYOPgKfW0Kkh+uMWVEimcR/7fogPQuPis3UeBMaqfjzA5eaUAU+UAOGGXXO3X9P
         14DbbQZckoj1atnjK9Y5HTeGY6hEMrxLHCQasFXzdHKbDDqFfjZDgi8s2LuOLnlCAMeP
         o6IT3+RFgs6aSum67nqG64Azt8R+SCRXgDbqZvhmOH+X/R4a0dHKxgMTOtFZ20Uz9Bxo
         2sYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696463236; x=1697068036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WfiepEv/LKhAXzybyJ+CjdLDBfoN1mMfHVU5qQvL01c=;
        b=dG5dJnLtDn6EWNRCI0Sx/o9WbfVnXTQTCoUejyXnko/ZsWr59zR0UsSD36j7KsOd4U
         Vaouo9nWhDiUW6EGV9AJicx3jDVlaL4X/Cv/JyFtpDY76DuhuRsNO+zvdNo9JBbUoutZ
         EyOOH72UT/8cXdpu8KDhosT1OV0XG6jgs0ucBsuCFs7y9eFHn4+8SBUcsaEnVEQXnm35
         k0TdGkOcuVIeBJq5GbDFE3FEPGuRTRzJUlp9RJ2fWFCVFFnD3NBKWQFXLqo/xUtiUESL
         2NqNQsjdNQ/lg1ha+20F2P4z76HUDab3CLLB/21W8ZGhbBCqlgEyMS3tEy62u8dtnqt4
         kmSg==
X-Gm-Message-State: AOJu0YwEK5J2kZSNCVzuK3zWYugLSDWOPE95FYEZ2jMOozTV+B9pVRua
        XBskZCqBYBo/qu7145rbouJbWTXZoPc=
X-Google-Smtp-Source: AGHT+IEHz+mw4DhitY8y9C/S8Up/qu3OdT/M7XZs12P6EE5VRHRcOOuhoE73ZugxuOKawvct7RsGdsREFJ0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:e06:b0:279:9aa1:402c with SMTP id
 ge6-20020a17090b0e0600b002799aa1402cmr59319pjb.7.1696463235588; Wed, 04 Oct
 2023 16:47:15 -0700 (PDT)
Date:   Wed, 4 Oct 2023 16:47:14 -0700
In-Reply-To: <20231001111313.77586-1-nsaenz@amazon.com>
Mime-Version: 1.0
References: <20231001111313.77586-1-nsaenz@amazon.com>
Message-ID: <ZR35gq1NICwhOUAS@google.com>
Subject: Re: [RFC] KVM: Allow polling vCPUs for events
From:   Sean Christopherson <seanjc@google.com>
To:     Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, graf@amazon.de, dwmw2@infradead.org,
        fgriffo@amazon.com, anelkz@amazon.de, peterz@infradead.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 01, 2023, Nicolas Saenz Julienne wrote:
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 9436dca9903b..7c12d44486e1 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -63,6 +63,10 @@
>   */
>  #define HV_EXT_CALL_MAX (HV_EXT_CALL_QUERY_CAPABILITIES + 64)
>  
> +#define HV_VTL_RETURN_POLL_MASK                                 \
> +	(BIT_ULL(KVM_REQ_UNBLOCK) | BIT_ULL(KVM_REQ_HV_STIMER) | \
> +		BIT_ULL(KVM_REQ_EVENT))
> +
>  void kvm_tdp_mmu_role_set_hv_bits(struct kvm_vcpu *vcpu, union kvm_mmu_page_role *role)
>  {
>  	//role->vtl = to_kvm_hv(vcpu->kvm)->hv_enable_vsm ? get_active_vtl(vcpu) : 0;
> @@ -3504,6 +3508,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  		goto hypercall_userspace_exit;
>  	case HVCALL_VTL_RETURN:
>  		vcpu->dump_state_on_run = true;
> +		vcpu->poll_mask = HV_VTL_RETURN_POLL_MASK;
>  		goto hypercall_userspace_exit;
>  	case HVCALL_TRANSLATE_VIRTUAL_ADDRESS:
>  		if (unlikely(hc.rep_cnt)) {

...

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index db106f2e16d8..2985e462ef56 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -238,7 +238,7 @@ static bool kvm_request_needs_ipi(struct kvm_vcpu *vcpu, unsigned req)
>  	 * READING_SHADOW_PAGE_TABLES mode.
>  	 */
>  	if (req & KVM_REQUEST_WAIT)
> -		return mode != OUTSIDE_GUEST_MODE;
> +		return !(mode == OUTSIDE_GUEST_MODE || mode == POLLING_FOR_EVENTS);

This won't work if the vCPU makes a self-request, because kvm_make_vcpu_request()
won't bother sending an IPI if the current pCPU is running the vCPU.  Piggybacking
the IPI logic is unnecessarily convoluted and silly.  More below.

> @@ -3996,6 +4002,39 @@ static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
>  	return 0;
>  }
>  
> +static __poll_t kvm_vcpu_poll(struct file *file, poll_table *wait)
> +{
> +	struct kvm_vcpu *vcpu = file->private_data;
> +
> +	if (!vcpu->poll_mask)
> +		return EPOLLERR;
> +
> +	switch (READ_ONCE(vcpu->mode)) {
> +	case OUTSIDE_GUEST_MODE:
> +		/*
> +		 * Make sure writes to vcpu->request are visible before the
> +		 * mode changes.
> +		 */

Huh?  There are no writes to vcpu->request anywhere in here.

> +		smp_store_mb(vcpu->mode, POLLING_FOR_EVENTS);
> +		break;
> +	case POLLING_FOR_EVENTS:
> +		break;
> +	default:
> +		WARN_ONCE(true, "Trying to poll vCPU %d in mode %d\n",
> +			  vcpu->vcpu_id, vcpu->mode);

This is definitely a user-triggerable WARN.

> +		return EPOLLERR;
> +	}
> +
> +	poll_wait(file, &vcpu->wqh, wait);
> +
> +	if (READ_ONCE(vcpu->requests) & vcpu->poll_mask) {

This effectively makes requests ABI.  The simple mask also means that this will
get false positives on unrelated requests.

In short, whatever mechanism controls the polling needs to be formal uAPI.

> +		WRITE_ONCE(vcpu->mode, OUTSIDE_GUEST_MODE);

This does not look remotely safe on multiple fronts.  For starters, I don't see
anything in the .poll() infrastructure that provides serialization, e.g. if there
are multiple tasks polling then this will be "interesting".

And there is zero chance this is race-free, e.g. nothing prevents the vCPU task
itself from changing vcpu->mode from POLLING_FOR_EVENTS to something else.

Why on earth is this mucking with vcpu->mode?  Ignoring for the moment that using
vcpu->requests as the poll source is never going to happen, there's zero reason
to write vcpu->mode.  From a correctness perspective, AFAICT there's no need for
any shenanigans at all, i.e. kvm_make_vcpu_request() could blindly and unconditionally
call wake_up_interruptible().

I suspect what you want is a fast way to track if there *may* be pollers.  Keying
off and *writing* vcpu->mode makes no sense to me.

I think what you want is something like this, where kvm_vcpu_poll() could use
atomic_fetch_or() and atomic_fetch_andnot() to manipulate vcpu->poll_mask.
Or if we only want to support a single poller at a time, it could be a vanilla
u64.  I suspect getting the poll_mask manipulation correct for multiple pollers
would be tricky, e.g. to avoid false negatives and leave a poller hanging.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 486800a7024b..5a260fb3b248 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -259,6 +259,14 @@ static inline bool kvm_kick_many_cpus(struct cpumask *cpus, bool wait)
        return true;
 }
 
+static inline bool kvm_request_is_being_polled(struct kvm_vcpu *vcpu,
+                                              unsigned int req)
+{
+       u32 poll_mask = kvm_request_to_poll_mask(req);
+
+       return (atomic_read(vcpu->poll_mask) & poll_mask)
+}
+
 static void kvm_make_vcpu_request(struct kvm_vcpu *vcpu, unsigned int req,
                                  struct cpumask *tmp, int current_cpu)
 {
@@ -285,6 +293,9 @@ static void kvm_make_vcpu_request(struct kvm_vcpu *vcpu, unsigned int req,
                if (cpu != -1 && cpu != current_cpu)
                        __cpumask_set_cpu(cpu, tmp);
        }
+
+       if (kvm_request_is_being_polled(vcpu, req))
+               wake_up_interruptible(...);
 }
 
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,

