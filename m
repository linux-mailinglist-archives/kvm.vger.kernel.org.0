Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965AC6C1A32
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 16:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbjCTPt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 11:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjCTPs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 11:48:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4E938B63
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 08:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679326818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P4wr6vK0bvTOXLTPkOkYePqHNSfv0lxL+T1cPpt2oEU=;
        b=ZTNQB62tu2dk5ehlpx3leS5AWuIUF7dOvznAjjTEVgzG/BgqmfkhHT+hdTOVHFq8vctntY
        jNk3l5bTkK0+q8O2z4zMBUjL/rD8Vpvj1WOEofCKcC5q+opZt1AjWMwoBjJu4qyv2yhH8V
        uaKAZxbjcj5SOY3JDYkhj6edUP70MAo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-2Tqpr8pCMEuNRuRGGAe1uw-1; Mon, 20 Mar 2023 11:40:16 -0400
X-MC-Unique: 2Tqpr8pCMEuNRuRGGAe1uw-1
Received: by mail-wm1-f70.google.com with SMTP id bg13-20020a05600c3c8d00b003ed40f09355so5710150wmb.5
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 08:40:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679326815;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P4wr6vK0bvTOXLTPkOkYePqHNSfv0lxL+T1cPpt2oEU=;
        b=RHel2gYLdtOoIRH0bSiaQMvEZ/i3z4Cm/c5+ZL/Tp3pD/bQ3DTPu2vsfTmcoeKdcXt
         cF2PsUEwuhzAh8j1T5Ed34Wwi4GpjuUDBPhRtglplVXdGT6wFjp2IMk/90ZK1ckWrS5/
         HOQVCQfPvAHDcYPQl+53myOds90WRLIcJDVtCCQFYrxoAdH9ITcH553qWmGgZv53o83c
         gTDNknPrXrXEagRUQ+wnlTwf4kulk3+zIfSgGax1tYa71tOGKwxtGe2DI9650LUBFOGg
         hwbBx3mWuZQF3snHM5GsgWWVzq39PvA9VVlS1WEi0Qf/khHLEJ7Day0qjkCPufGMFdEL
         qrng==
X-Gm-Message-State: AO0yUKVlqb7ATwkf8M0sbkJ4PlfsZZ0MGUvyeFSd4WFxoJJAB0sxWOgZ
        SbY5e/y2QQIZ05meC3yQxxo+QnShEc4k/WnRGt4osA0Fk8zHtvPHN88wMF6fPcRQOQaeNYXW3Dx
        CJoaKZtkIm7x+
X-Received: by 2002:adf:f485:0:b0:2d1:6b10:f33c with SMTP id l5-20020adff485000000b002d16b10f33cmr12409206wro.14.1679326815494;
        Mon, 20 Mar 2023 08:40:15 -0700 (PDT)
X-Google-Smtp-Source: AK7set98zwbga88NXUhJbTyJzgnKghlLKTwwk49bjQlS1j1u4ainYZh9gd2n7AzSzgg4ZHN7VC4QeA==
X-Received: by 2002:adf:f485:0:b0:2d1:6b10:f33c with SMTP id l5-20020adff485000000b002d16b10f33cmr12409181wro.14.1679326815202;
        Mon, 20 Mar 2023 08:40:15 -0700 (PDT)
Received: from [192.168.149.90] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id p12-20020a5d48cc000000b002d431f61b18sm7452138wrs.103.2023.03.20.08.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 08:40:14 -0700 (PDT)
Message-ID: <301c7527-6319-b993-f43f-dc61b9af4b34@redhat.com>
Date:   Mon, 20 Mar 2023 16:40:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/3] kvm: vmx: Add IA32_FLUSH_CMD guest support
Content-Language: de-CH
To:     Sean Christopherson <seanjc@google.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Nathan Chancellor <nathan@kernel.org>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Ben Serebrin <serebrin@google.com>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20230201132905.549148-1-eesposit@redhat.com>
 <20230201132905.549148-2-eesposit@redhat.com>
 <20230317190432.GA863767@dev-arch.thelio-3990X>
 <20230317225345.z5chlrursjfbz52o@desk>
 <20230317231401.GA4100817@dev-arch.thelio-3990X>
 <20230317235959.buk3y25iwllscrbe@desk> <ZBhzhPDk+EV1zRf0@google.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <ZBhzhPDk+EV1zRf0@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 20/03/2023 um 15:53 schrieb Sean Christopherson:
> On Fri, Mar 17, 2023, Pawan Gupta wrote:
>> On Fri, Mar 17, 2023 at 04:14:01PM -0700, Nathan Chancellor wrote:
>>> On Fri, Mar 17, 2023 at 03:53:45PM -0700, Pawan Gupta wrote:
>>>> On Fri, Mar 17, 2023 at 12:04:32PM -0700, Nathan Chancellor wrote:
>>>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>>>>> index c788aa382611..9a78ea96a6d7 100644
>>>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>>>> @@ -2133,6 +2133,39 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
>>>>>>  	return debugctl;
>>>>>>  }
>>>>>>  
>>>>>> +static int vmx_set_msr_ia32_cmd(struct kvm_vcpu *vcpu,
>>>>>> +				struct msr_data *msr_info,
>>>>>> +				bool guest_has_feat, u64 cmd,
>>>>>> +				int x86_feature_bit)
>>>>>> +{
>>>>>> +	if (!msr_info->host_initiated && !guest_has_feat)
>>>>>> +		return 1;
>>>>>> +
>>>>>> +	if (!(msr_info->data & ~cmd))
>>>>
>>>> Looks like this is doing a reverse check. Shouldn't this be as below:
>>>
>>> That diff on top of next-20230317 appears to resolve the issue for me
>>> and my L1 guest can spawn an L2 guest without any issues (which is the
>>> extent of my KVM testing).
>>
>> Great!
>>
>>> Is this a problem for the SVM version? It has the same check it seems,
>>> although I did not have any issues on my AMD test platform (but I guess
>>> that means that the system has the support?).
>>
>> IIUC, SVM version also needs to be fixed.
> 
> Yeah, looks that way.  If we do go this route, can you also rename "cmd" to something
> like "allowed_mask"?  It took me far too long to understand what "cmd" represents.
> 
>>> I assume this will just be squashed into the original change but if not:
>>
>> Thats what I think, and if its too late to be squashed I will send a
>> formal patch. Maintainers?
> 
> Honestly, I'd rather revert the whole mess and try again.  

The patches obviously
> weren't tested,
Well... no. They were tested. Call it wrongly tested, badly tested,
whatever you want but don't say "obviously weren't tested". I even asked
you in a private email why the cpu flag was visible in Linux and not in
rhel when using the same machine.

So again, my bad with these patches, I sincerely apologize but I would
prefer that you think I don't know how to test this stuff rather than
say that I carelessly sent something without checking :)

About the rest of the email: whatever you decide is fine for me.

Thank you,
Emanuele

 and the entire approach (that was borrowed from the existing
> MSR_IA32_PRED_CMD code) makes no sense.
> 
> The MSRs are write-only command registers, i.e. don't have a persistent value.
> So unlike MSR_IA32_SPEC_CTRL (which I suspect was the source for the copy pasta),
> where KVM needs to track the guest value, there are no downsides to disabling
> interception of the MSRs.  
> 
> Manually checking the value written by the guest or host userspace is similarly
> ridiculous.  The MSR is being exposed directly to the guest, i.e. after the first
> access, the guest can throw any value at bare metal anyways, so just do wrmsrl_safe()
> and call it good.
> 
> In other words, the common __kvm_set_msr() switch should have something like so,
> 
> 	case MSR_IA32_PRED_CMD:
> 		if (!cpu_feature_enabled(X86_FEATURE_IBPB))
> 			return 1;
> 
> 		if (!msr_info->host_initiated &&
> 		    !guest_cpuid_has(vcpu, guest_has_pred_cmd_msr(vcpu)))
> 			return 1;
> 
> 		ret = !!wrmsrl_safe(MSR_IA32_PRED_CMD, msr_info->data);
> 		break;
> 	case MSR_IA32_FLUSH_CMD:
> 		if (!cpu_feature_enabled(X86_FEATURE_FLUSH_L1D))
> 			return 1;
> 
> 		if (!msr_info->host_initiated &&
> 		    !guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D))
> 			return 1;
> 
> 		ret = !!wrmsrl_safe(MSR_IA32_FLUSH_CMD, msr_info->data);
> 		break;
> 
> with the MSR interception handled in e.g. vmx_vcpu_after_set_cpuid().
> 
> Paolo?
> 

