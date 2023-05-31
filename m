Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B441571885D
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 19:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjEaRWg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 13:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjEaRWe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 13:22:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AD711D
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 10:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685553706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Aqycy5XGd/Zg3D6nCw9dbFWiEKfPLLpIUb43lPV1w3E=;
        b=VpzJMDD3U2ovpeDG1qM7eqNC5u0o51XisWgx599Pw9LhD7x/AQIJbgCpXRMwsZDJtA73iu
        FNcRURnI0smBnTAc9fKINo4jLF8t3xWafGzRHqUxMoGocqk98/acdzsGtPnTcPgxS8qtRC
        0PY7wXZ+kku1uUK9u45+DmjcoxZA9ts=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-dIMpOH62PFGugHt06ZNGqw-1; Wed, 31 May 2023 13:21:41 -0400
X-MC-Unique: dIMpOH62PFGugHt06ZNGqw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C44B43802140;
        Wed, 31 May 2023 17:21:40 +0000 (UTC)
Received: from [10.18.17.153] (dhcp-17-153.bos.redhat.com [10.18.17.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E08AC154D7;
        Wed, 31 May 2023 17:21:40 +0000 (UTC)
Message-ID: <3cb96907-0d58-ba60-ed0e-6c17c69bd0f8@redhat.com>
Date:   Wed, 31 May 2023 13:21:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v4] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
Content-Language: en-US
To:     Jon Kohler <jon@nutanix.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <20230531144128.73814-1-jon@nutanix.com>
 <9d37ab07-97c6-5245-6939-9c1090b4b3a9@redhat.com>
 <ECE9A3B4-2CF3-452A-838A-99BE075D5E68@nutanix.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <ECE9A3B4-2CF3-452A-838A-99BE075D5E68@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/23 13:13, Jon Kohler wrote:
>
>> On May 31, 2023, at 1:02 PM, Waiman Long <longman@redhat.com> wrote:
>>
>> On 5/31/23 10:41, Jon Kohler wrote:
>>> Avoid expensive rdmsr on every VM Exit for MSR_IA32_SPEC_CTRL on
>>> eIBRS enabled systems iff the guest only sets IA32_SPEC_CTRL[0] (IBRS)
>>> and not [1] (STIBP) or [2] (SSBD) by not disabling interception in
>>> the MSR bitmap. Note: this logic is only for eIBRS, as Intel's guidance
>>> has long been that eIBRS only needs to be set once, so most guests with
>>> eIBRS awareness should behave nicely. We would not want to accidentally
>>> regress misbehaving guests on pre-eIBRS systems, who might be spamming
>>> IBRS MSR without the hypervisor being able to see it today.
>>>
>>> eIBRS enabled guests using just IBRS will only write SPEC_CTRL MSR
>>> once or twice per vCPU on boot, so it is far better to take those
>>> VM exits on boot than having to read and save this msr on every
>>> single VM exit forever. This outcome was suggested on Andrea's commit
>>> 2f46993d83ff ("x86: change default to spec_store_bypass_disable=prctl spectre_v2_user=prctl")
>>> however, since interception is still unilaterally disabled, the rdmsr
>>> tax is still there even after that commit.
>>>
>>> This is a significant win for eIBRS enabled systems as this rdmsr
>>> accounts for roughly ~50% of time for vmx_vcpu_run() as observed
>>> by perf top disassembly, and is in the critical path for all
>>> VM-Exits, including fastpath exits.
>>>
>>> Opportunistically update comments for both MSR_IA32_SPEC_CTRL and
>>> MSR_IA32_PRED_CMD to make it clear how L1 vs L2 handling works.
>>>
>>> Fixes: 2f46993d83ff ("x86: change default to spec_store_bypass_disable=prctl spectre_v2_user=prctl")
>>> Signed-off-by: Jon Kohler <jon@nutanix.com>
>>> Cc: Sean Christopherson <seanjc@google.com>
>>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>>> Cc: Kees Cook <keescook@chromium.org>
>>> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
>>> Cc: Waiman Long <longman@redhat.com>
>>> ---
>>> v1
>>>   - https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_all_20220512174427.3608-2D1-2Djon-40nutanix.com_&d=DwICaQ&c=s883GpUCOChKOHiocYtGcg&r=NGPRGGo37mQiSXgHKm5rCQ&m=PT1QjB8Lk_a3baDOwHBfedQG67HsVDmOdmcWHlr5PrT8WyuS9e6PfHF5JxLxD0zw&s=jNnloZQgh0KG-n36uwVC0dJTmokvqsQdYQCWYI8hVvM&e= v1 -> v2:
>>>   - https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_all_20220520195303.58692-2D1-2Djon-40nutanix.com_&d=DwICaQ&c=s883GpUCOChKOHiocYtGcg&r=NGPRGGo37mQiSXgHKm5rCQ&m=PT1QjB8Lk_a3baDOwHBfedQG67HsVDmOdmcWHlr5PrT8WyuS9e6PfHF5JxLxD0zw&s=Rwi5NoHwaezlmzzLiGGCuI6QHuGQZ1BVK2hs6-SZvzU&e=   - Addressed comments on approach from Sean.
>>> v2 -> v3:
>>>   - https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_kvm_20220520204115.67580-2D1-2Djon-40nutanix.com_&d=DwICaQ&c=s883GpUCOChKOHiocYtGcg&r=NGPRGGo37mQiSXgHKm5rCQ&m=PT1QjB8Lk_a3baDOwHBfedQG67HsVDmOdmcWHlr5PrT8WyuS9e6PfHF5JxLxD0zw&s=R2Ykxdv-DyeVGLWd8_pLpu43zEsnWzpyvvBPEZ9lz-Y&e=   - Addressed comments on approach from Sean.
>>> v3 -> v4:
>>>   - Fixed inline code comments from Sean.
>>>
>>>   arch/x86/kvm/vmx/vmx.c | 35 ++++++++++++++++++++++++-----------
>>>   1 file changed, 24 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index 44fb619803b8..5e643ac897bc 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -2260,20 +2260,33 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>   			return 1;
>>>
>>>   		vmx->spec_ctrl = data;
>>> -		if (!data)
>>> +
>>> +		/*
>>> +		 * Disable interception on the first non-zero write, except if
>>> +		 * eIBRS is advertised to the guest and the guest is enabling
>>> +		 * _only_ IBRS.  On eIBRS systems, kernels typically set IBRS
>>> +		 * once at boot and never touch it post-boot.  All other bits,
>>> +		 * and IBRS on non-eIBRS systems, are often set on a per-task
>>> +		 * basis, i.e. change frequently, so the benefit of avoiding
>>> +		 * VM-exits during guest context switches outweighs the cost of
>>> +		 * RDMSR on every VM-Exit to save the guest's value.
>>> +		 */
>>> +		if (!data ||
>>> +		    (data == SPEC_CTRL_IBRS &&
>>> +		     (vcpu->arch.arch_capabilities & ARCH_CAP_IBRS_ALL)))
>>>   			break;
>>>
>>>   		/*
>>> -		 * For non-nested:
>>> -		 * When it's written (to non-zero) for the first time, pass
>>> -		 * it through.
>>> -		 *
>>> -		 * For nested:
>>> -		 * The handling of the MSR bitmap for L2 guests is done in
>>> -		 * nested_vmx_prepare_msr_bitmap. We should not touch the
>>> -		 * vmcs02.msr_bitmap here since it gets completely overwritten
>>> -		 * in the merging. We update the vmcs01 here for L1 as well
>>> -		 * since it will end up touching the MSR anyway now.
>>> +		 * Update vmcs01.msr_bitmap even if L2 is active, i.e. disable
>>> +		 * interception for the vCPU on the first write regardless of
>>> +		 * whether the WRMSR came from L1 or L2.  vmcs02's bitmap is a
>>> +		 * combination of vmcs01 and vmcs12 bitmaps, and will be
>>> +		 * recomputed by nested_vmx_prepare_msr_bitmap() on the next
>>> +		 * nested VM-Enter.  Note, this does mean that future WRMSRs
>>> +		 * from L2 will be intercepted until the next nested VM-Exit if
>>> +		 * L2 was the first to write, but L1 exposing the MSR to L2
>>> +		 * without first writing it is unlikely and not worth the
>>> +		 * extra bit of complexity.
>>>   		 */
>>>   		vmx_disable_intercept_for_msr(vcpu,
>>>   					      MSR_IA32_SPEC_CTRL,
>> I have 2 comments.
>>
>> 1) Besides the IBRS, STIBP & SSBD bits, the SPEC_CTRL MSR may have the RRSBA_DIS_S bit set in the future. I am not aware of any current Intel processors having this capability yet, but a future Intel processor may have this and the above patch will have to be modified accordingly. It looks like that the RRSBA_DIS_S bit will be set once.
> Agreed. Once that becomes pubic with future processors, this code can be fixed up in a fairly trivial manner. I don’t have any access to said future processors, so I’d like to keep it as-is today rather than project it out too far. Is that ok?
That is certainly OK. I am just raising a question here.
>> 2) AMD has their own AutoIBRS capability in Genoa which is similar to eIBRS but is not identified by the ARCH_CAP_IBRS_ALL bit. Instead it is identified by the AUTOIBRS bit in MSR_EFER. Are you planning to support that?
> This is a vmx-only optimization. AMD optimizations can certainly be picked up separately if they suffer from same interception type issue that is called out here, but that isn’t something I’m looking at this time.

Right, I forgot kvm has a different set of code for AMD CPUs. Since this 
is Intel only, the patch looks sane to me.

Thanks,
Longman

