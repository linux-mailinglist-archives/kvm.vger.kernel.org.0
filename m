Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB75E50DA9
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 16:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfFXOQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 10:16:40 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34621 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfFXOQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 10:16:35 -0400
Received: by mail-wm1-f68.google.com with SMTP id w9so74756wmd.1
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2019 07:16:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=hSk6AE3sbQCAIoBtKIdZqdvHi2gn9KW0bMwzPsLPB2Y=;
        b=DBJg0jIzQ5VXA9FEd/4TLzVONcX5Hf9y12mgo76yEYYof9iAsRubO0ftB7KdH0He5s
         kBiiWgcltd/56W0LEWvtRSltZPUEsBfsj8N5mg/YZuEO25Z+Fsknfh+l09b9IoC8hjBq
         lCFKRiMfgjkoHH/ZsgY+j697UCgwgnq76QrHW49jaXLlEDrrvqXI/CyM4vKBHE75pbyr
         hfXPt83bHu88C1EyFi18NImsbNUCZNf0JdqEJvTjyQDM7aMDegi2eV6fTlRMlpFYbi+z
         7FfRd6hfzhaSZCzSMivCVS/dq05ry68uxYXZZ93AvpKKXudT7JVKpPyO4x+RfFiS2O7T
         5MUw==
X-Gm-Message-State: APjAAAURUnm4sg/pwemB2yJptJpKZP3MUM5GNI0cu4YvSbRtOKFpBIy9
        HAPfFuDHjcIf4gKQwUIqS7GUmg==
X-Google-Smtp-Source: APXvYqwxhltrQvnUOGQ838zdFDCyaoakfZQwDFHcjuC4zhxp6GhRmKpHb3kDVinsmaaNjyJ5up5jNA==
X-Received: by 2002:a1c:1947:: with SMTP id 68mr16215464wmz.171.1561385793113;
        Mon, 24 Jun 2019 07:16:33 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id s10sm10868351wrt.49.2019.06.24.07.16.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 07:16:32 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH] x86/kvm/nVMCS: fix VMCLEAR when Enlightened VMCS is in use
In-Reply-To: <CEFF2A14-611A-417C-BC0A-8814862F26C6@oracle.com>
References: <20190624133028.3710-1-vkuznets@redhat.com> <CEFF2A14-611A-417C-BC0A-8814862F26C6@oracle.com>
Date:   Mon, 24 Jun 2019 16:16:31 +0200
Message-ID: <87r27jdq68.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Liran Alon <liran.alon@oracle.com> writes:

>> On 24 Jun 2019, at 16:30, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>> 
>> When Enlightened VMCS is in use, it is valid to do VMCLEAR and,
>> according to TLFS, this should "transition an enlightened VMCS from the
>> active to the non-active state". It is, however, wrong to assume that
>> it is only valid to do VMCLEAR for the eVMCS which is currently active
>> on the vCPU performing VMCLEAR.
>> 
>> Currently, the logic in handle_vmclear() is broken: in case, there is no
>> active eVMCS on the vCPU doing VMCLEAR we treat the argument as a 'normal'
>> VMCS and kvm_vcpu_write_guest() to the 'launch_state' field irreversibly
>> corrupts the memory area.
>> 
>> So, in case the VMCLEAR argument is not the current active eVMCS on the
>> vCPU, how can we know if the area it is pointing to is a normal or an
>> enlightened VMCS?
>> Thanks to the bug in Hyper-V (see commit 72aeb60c52bf7 ("KVM: nVMX: Verify
>> eVMCS revision id match supported eVMCS version on eVMCS VMPTRLD")) we can
>> not, the revision can't be used to distinguish between them. So let's
>> assume it is always enlightened in case enlightened vmentry is enabled in
>> the assist page. Also, check if vmx->nested.enlightened_vmcs_enabled to
>> minimize the impact for 'unenlightened' workloads.
>> 
>> Fixes: b8bbab928fb1 ("KVM: nVMX: implement enlightened VMPTRLD and VMCLEAR")
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>> arch/x86/kvm/vmx/evmcs.c  | 18 ++++++++++++++++++
>> arch/x86/kvm/vmx/evmcs.h  |  1 +
>> arch/x86/kvm/vmx/nested.c | 19 ++++++++-----------
>> 3 files changed, 27 insertions(+), 11 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
>> index 1a6b3e1581aa..eae636ec0cc8 100644
>> --- a/arch/x86/kvm/vmx/evmcs.c
>> +++ b/arch/x86/kvm/vmx/evmcs.c
>> @@ -3,6 +3,7 @@
>> #include <linux/errno.h>
>> #include <linux/smp.h>
>> 
>> +#include "../hyperv.h"
>> #include "evmcs.h"
>> #include "vmcs.h"
>> #include "vmx.h"
>> @@ -309,6 +310,23 @@ void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
>> }
>> #endif
>> 
>> +bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmptr)
>
> I prefer to rename evmptr to evmcs_ptr. I think it’s more readable and sufficiently short.
> In addition, I think you should return either -1ull or assist_page.current_nested_vmcs.
> i.e. Don’t return evmcs_ptr by pointer but instead as a return-value
> and get rid of the bool.

Sure, can do in v2.

>
>> +{
>> +	struct hv_vp_assist_page assist_page;
>> +
>> +	*evmptr = -1ull;
>> +
>> +	if (unlikely(!kvm_hv_get_assist_page(vcpu, &assist_page)))
>> +		return false;
>> +
>> +	if (unlikely(!assist_page.enlighten_vmentry))
>> +		return false;
>> +
>> +	*evmptr = assist_page.current_nested_vmcs;
>> +
>> +	return true;
>> +}
>> +
>> uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
>> {
>>        struct vcpu_vmx *vmx = to_vmx(vcpu);
>> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
>> index e0fcef85b332..c449e79a9c4a 100644
>> --- a/arch/x86/kvm/vmx/evmcs.h
>> +++ b/arch/x86/kvm/vmx/evmcs.h
>> @@ -195,6 +195,7 @@ static inline void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf) {}
>> static inline void evmcs_touch_msr_bitmap(void) {}
>> #endif /* IS_ENABLED(CONFIG_HYPERV) */
>> 
>> +bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmptr);
>> uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
>> int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>> 			uint16_t *vmcs_version);
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 9214b3aea1f9..ee8dda7d8a03 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -1765,26 +1765,21 @@ static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
>> 						 bool from_launch)
>> {
>> 	struct vcpu_vmx *vmx = to_vmx(vcpu);
>> -	struct hv_vp_assist_page assist_page;
>> +	u64 evmptr;
>
> I prefer to rename evmptr to evmcs_ptr. I think it’s more readable and sufficiently short.
>

Sure.

>> 
>> 	if (likely(!vmx->nested.enlightened_vmcs_enabled))
>> 		return 1;
>> 
>> -	if (unlikely(!kvm_hv_get_assist_page(vcpu, &assist_page)))
>> +	if (!nested_enlightened_vmentry(vcpu, &evmptr))
>> 		return 1;
>> 
>> -	if (unlikely(!assist_page.enlighten_vmentry))
>> -		return 1;
>> -
>> -	if (unlikely(assist_page.current_nested_vmcs !=
>> -		     vmx->nested.hv_evmcs_vmptr)) {
>> -
>> +	if (unlikely(evmptr != vmx->nested.hv_evmcs_vmptr)) {
>> 		if (!vmx->nested.hv_evmcs)
>> 			vmx->nested.current_vmptr = -1ull;
>> 
>> 		nested_release_evmcs(vcpu);
>> 
>> -		if (kvm_vcpu_map(vcpu, gpa_to_gfn(assist_page.current_nested_vmcs),
>> +		if (kvm_vcpu_map(vcpu, gpa_to_gfn(evmptr),
>> 				 &vmx->nested.hv_evmcs_map))
>> 			return 0;
>> 
>> @@ -1826,7 +1821,7 @@ static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
>> 		 */
>> 		vmx->nested.hv_evmcs->hv_clean_fields &=
>> 			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
>> -		vmx->nested.hv_evmcs_vmptr = assist_page.current_nested_vmcs;
>> +		vmx->nested.hv_evmcs_vmptr = evmptr;
>> 
>> 		/*
>> 		 * Unlike normal vmcs12, enlightened vmcs12 is not fully
>> @@ -4331,6 +4326,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
>> 	struct vcpu_vmx *vmx = to_vmx(vcpu);
>> 	u32 zero = 0;
>> 	gpa_t vmptr;
>> +	u64 evmptr;
>
> I prefer to rename evmptr to evmcs_ptr. I think it’s more readable and sufficiently short.
>

Sure.

>> 
>> 	if (!nested_vmx_check_permission(vcpu))
>> 		return 1;
>> @@ -4346,7 +4342,8 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
>> 		return nested_vmx_failValid(vcpu,
>> 			VMXERR_VMCLEAR_VMXON_POINTER);
>> 
>> -	if (vmx->nested.hv_evmcs_map.hva) {
>> +	if (unlikely(vmx->nested.enlightened_vmcs_enabled) &&
>> +	    nested_enlightened_vmentry(vcpu, &evmptr)) {
>> 		if (vmptr == vmx->nested.hv_evmcs_vmptr)
>
> Shouldn’t you also remove the (vmptr == vmx->nested.hv_evmcs_vmptr) condition?
> To my understanding, vmx->nested.hv_evmcs_vmptr represents the address of the loaded eVMCS on current vCPU.
> But according to commit message, it is valid for vCPU to perform
> VMCLEAR on eVMCS that differ from loaded eVMCS on vCPU.
> E.g. The current vCPU may even have vmx->nested.hv_evmcs_vmptr set to
> -1ull.

nested_release_evmcs() unmaps current eVMCS on the vCPU, we can't easily
unmap eVMCS on other vCPUs without somehow synchronizing with
them. Actually, if we remove nested_release_evmcs() from here nothing is
going to change: the fact that eVMCS is mapped doesn't hurt much. If the
next enlightened vmentry is going to happen with the same evmptr we'll
have to map it back, in case a different one will be used - we'll unmap
the old.

In KVM, there's nothing we *have* to do to transition an eVMCS from
active to non-activer state. We, for example, don't enforce the
requirement that it can only be active on one vCPU at a time. Enforcing
it is expensive (some synchronization is required) and if L1 hypervisor
is misbehaving than, well, things are not going to work anyway.

That said I'm ok with dropping nested_release_evmcs() for consistency
but we can't just drop 'if (vmptr == vmx->nested.hv_evmcs_vmptr)'.

Thanks for your review!

-- 
Vitaly
