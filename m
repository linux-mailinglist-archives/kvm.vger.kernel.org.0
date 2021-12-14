Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB25473F05
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 10:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhLNJMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 04:12:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31716 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230031AbhLNJMr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 04:12:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639473167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pCMq7x6Y7jQFdf5VWW5PH4Y3hew/wMImKvNMOw/y70k=;
        b=GF+UREt47x/SZkN3o2SipfENrvxt7pLm5GmAkVBsKH5SiZojpqbe9gJK33ccAUkVuybI/G
        siUD9QTbQ5tpNrw07iccQakII5QuxNqRwEVyBbVzMO8TWhIIGSTuO4HKUpkfWZ+mLh9JNq
        /9ZL0nKW9lcNZ05uvla0iXJjK3toxEo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-YuyZXwpZPUWgN8UD1IsE4A-1; Tue, 14 Dec 2021 04:12:43 -0500
X-MC-Unique: YuyZXwpZPUWgN8UD1IsE4A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD1818DE3FE;
        Tue, 14 Dec 2021 09:12:36 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B516196F1;
        Tue, 14 Dec 2021 09:12:33 +0000 (UTC)
Message-ID: <1c66981541a52e8d7c2b72db2ecd1bcc79c16be6.camel@redhat.com>
Subject: Re: [PATCH 2/4] KVM: nVMX: Synthesize TRIPLE_FAULT for L2 if
 emulation is required
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com
Date:   Tue, 14 Dec 2021 11:12:32 +0200
In-Reply-To: <20211207193006.120997-3-seanjc@google.com>
References: <20211207193006.120997-1-seanjc@google.com>
         <20211207193006.120997-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-12-07 at 19:30 +0000, Sean Christopherson wrote:
> Synthesize a triple fault if L2 guest state is invalid at the time of
> VM-Enter, which can happen if L1 modifies SMRAM or if userspace stuffs
> guest state via ioctls(), e.g. KVM_SET_SREGS.  KVM should never emulate
> invalid guest state, since from L1's perspective, it's architecturally
> impossible for L2 to have invalid state while L2 is running in hardware.
> E.g. attempts to set CR0 or CR4 to unsupported values will either VM-Exit
> or #GP.
> 
> Modifying vCPU state via RSM+SMRAM and ioctl() are the only paths that
> can trigger this scenario, as nested VM-Enter correctly rejects any
> attempt to enter L2 with invalid state.
> 
> RSM is a straightforward case as (a) KVM follows AMD's SMRAM layout and
> behavior, and (b) Intel's SDM states that loading reserved CR0/CR4 bits
> via RSM results in shutdown, i.e. there is precedent for KVM's behavior.
> Following AMD's SMRAM layout is important as AMD's layout saves/restores
> the descriptor cache information, including CS.RPL and SS.RPL, and also
> defines all the fields relevant to invalid guest state as read-only, i.e.
> so long as the vCPU had valid state before the SMI, which is guaranteed
> for L2, RSM will generate valid state unless SMRAM was modified.  Intel's
> layout saves/restores only the selector, which means that scenarios where
> the selector and cached RPL don't match, e.g. conforming code segments,
> would yield invalid guest state.  Intel CPUs fudge around this issued by
> stuffing SS.RPL and CS.RPL on RSM.  Per Intel's SDM on the "Default
> Treatment of RSM", paraphrasing for brevity:
> 
>   IF internal storage indicates that the [CPU was post-VMXON]
>   THEN
>      enter VMX operation (root or non-root);
>      restore VMX-critical state as defined in Section 34.14.1;
>      set to their fixed values any bits in CR0 and CR4 whose values must
>      be fixed in VMX operation [unless coming from an unrestricted guest];
>      IF RFLAGS.VM = 0 AND (in VMX root operation OR the
>         “unrestricted guest” VM-execution control is 0)
>      THEN
>        CS.RPL := SS.DPL;
>        SS.RPL := SS.DPL;
>      FI;
>      restore current VMCS pointer;
>   FI;
> 
> Note that Intel CPUs also overwrite the fixed CR0/CR4 bits, whereas KVM
> will sythesize TRIPLE_FAULT in this scenario.  KVM's behavior is allowed
> as both Intel and AMD define CR0/CR4 SMRAM fields as read-only, i.e. the
> only way for CR0 and/or CR4 to have illegal values is if they were
> modified by the L1 SMM handler, and Intel's SDM "SMRAM State Save Map"
> section states "modifying these registers will result in unpredictable
> behavior".
> 
> KVM's ioctl() behavior is less straightforward.  Because KVM allows
> ioctls() to be executed in any order, rejecting an ioctl() if it would
> result in invalid L2 guest state is not an option as KVM cannot know if
> a future ioctl() would resolve the invalid state, e.g. KVM_SET_SREGS, or
> drop the vCPU out of L2, e.g. KVM_SET_NESTED_STATE.  Ideally, KVM would
> reject KVM_RUN if L2 contained invalid guest state, but that carries the
> risk of a false positive, e.g. if RSM loaded invalid guest state and KVM
> exited to userspace.  Setting a flag/request to detect such a scenario is
> undesirable because (a) it's extremely unlikely to add value to KVM as a
> whole, and (b) KVM would need to consider ioctl() interactions with such
> a flag, e.g. if userspace migrated the vCPU while the flag were set.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 32 ++++++++++++++++++++++++--------
>  1 file changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9e415e5a91ab..5307fcee3b3b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5900,18 +5900,14 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  		vmx_flush_pml_buffer(vcpu);
>  
>  	/*
> -	 * We should never reach this point with a pending nested VM-Enter, and
> -	 * more specifically emulation of L2 due to invalid guest state (see
> -	 * below) should never happen as that means we incorrectly allowed a
> -	 * nested VM-Enter with an invalid vmcs12.
> +	 * KVM should never reach this point with a pending nested VM-Enter.
> +	 * More specifically, short-circuiting VM-Entry to emulate L2 due to
> +	 * invalid guest state should never happen as that means KVM knowingly
> +	 * allowed a nested VM-Enter with an invalid vmcs12.  More below.
>  	 */
>  	if (KVM_BUG_ON(vmx->nested.nested_run_pending, vcpu->kvm))
>  		return -EIO;
>  
> -	/* If guest state is invalid, start emulating */
> -	if (vmx->emulation_required)
> -		return handle_invalid_guest_state(vcpu);
> -
>  	if (is_guest_mode(vcpu)) {
>  		/*
>  		 * PML is never enabled when running L2, bail immediately if a
> @@ -5933,10 +5929,30 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  		 */
>  		nested_mark_vmcs12_pages_dirty(vcpu);
>  
> +		/*
> +		 * Synthesize a triple fault if L2 state is invalid.  In normal
> +		 * operation, nested VM-Enter rejects any attempt to enter L2
> +		 * with invalid state.  However, those checks are skipped if
> +		 * state is being stuffed via RSM or KVM_SET_NESTED_STATE.  If
> +		 * L2 state is invalid, it means either L1 modified SMRAM state
> +		 * or userspace provided bad state.  Synthesize TRIPLE_FAULT as
> +		 * doing so is architecturally allowed in the RSM case, and is
> +		 * the least awful solution for the userspace case without
> +		 * risking false positives.
> +		 */
> +		if (vmx->emulation_required) {
> +			nested_vmx_vmexit(vcpu, EXIT_REASON_TRIPLE_FAULT, 0, 0);
> +			return 1;
> +		}
> +
>  		if (nested_vmx_reflect_vmexit(vcpu))
>  			return 1;
>  	}
>  
> +	/* If guest state is invalid, start emulating.  L2 is handled above. */
> +	if (vmx->emulation_required)
> +		return handle_invalid_guest_state(vcpu);
> +
>  	if (exit_reason.failed_vmentry) {
>  		dump_vmcs(vcpu);
>  		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;



Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Best regards,
	Maxim Levitsky

