Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED966DD2FC
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 08:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbjDKGiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 02:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjDKGh6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 02:37:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F190819AC
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 23:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681195033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=olF5mjepmtklFbFK7hKHFfEdos+6jxWkuuqywTknkRQ=;
        b=PM92Vt8jTux66/G2rvpKxOMC9sjcDV375dauFBeyJAidJ7U4e3lieYat3Fo5J95PTvZ1Lq
        pNlTzql3tQ6KyK/odfWedjnZuR39T8paVqlUTjfiZYohMJoJkuO+in66XCyxEzI4gajfix
        Yj2fgeR8KlnXZy28Lxc+zRAsf1MI5Sg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-JGeIHa0cMSCTpqM-LFFbFA-1; Tue, 11 Apr 2023 02:37:12 -0400
X-MC-Unique: JGeIHa0cMSCTpqM-LFFbFA-1
Received: by mail-wm1-f70.google.com with SMTP id l26-20020a05600c1d1a00b003edf85f6bb1so4940727wms.3
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 23:37:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681195030; x=1683787030;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=olF5mjepmtklFbFK7hKHFfEdos+6jxWkuuqywTknkRQ=;
        b=zG9jrYsN56XpoPei1aF/KGoKjKraei807Cjs+Ir/RiXrBS/r3iOA8TTZpYUkdGYeo7
         pENxa178moEt3e1xnLlRhSXlO5VssLlvfuLziOEoporEVgXdml7ZUmST2bTyPuV7N5pa
         8jYhHeN6zLE0enTY7OH/S2Idm/TGCs5wKyy5jCAABB2bCEPxAiESJN9WQ7EoPVadD7fy
         4BnS1VU4aRVPUTZoL3BIvmiZ/Xlq+3uqtGmeqTB649qeEcdmkNI+eH1wgGctlLjQDZ5s
         vbetKt2rsMXbG8lj2GHaFZuFhlqLj1kVPD08VfLG5qLIihDTzuyCtjXtOG7A7vwaNFFs
         xHZw==
X-Gm-Message-State: AAQBX9fvNTFEevpd84t8snYZLWcA6awSP7f/SHUUNFkbA0lbPrt8YwFx
        kVV+GHuJmkUzX5cz5OLbg/jnLeo+kn8VAMhIrlNiNNXAHqJyKrl8S5gJonz7wXt0h17j8wPtcPB
        wwWQXrXL+nVUiC+ahQxfo
X-Received: by 2002:a5d:48d2:0:b0:2ee:e42e:e8b7 with SMTP id p18-20020a5d48d2000000b002eee42ee8b7mr5945614wrs.33.1681195030470;
        Mon, 10 Apr 2023 23:37:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350bi7wOckY7Uos6LLY1S0H/CZrnhoKLnlhxa4G7i+9nqN5zOvtaIWdafQtZ1IKvo+jBX7RcldQ==
X-Received: by 2002:a5d:48d2:0:b0:2ee:e42e:e8b7 with SMTP id p18-20020a5d48d2000000b002eee42ee8b7mr5945602wrs.33.1681195030107;
        Mon, 10 Apr 2023 23:37:10 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id b16-20020adfe310000000b002f27a6a49d0sm2524355wrj.10.2023.04.10.23.37.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Apr 2023 23:37:09 -0700 (PDT)
Message-ID: <431136bf-2e49-fbef-457d-1145c1a59fac@redhat.com>
Date:   Tue, 11 Apr 2023 08:37:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] KVM: nVMX: Emulate NOPs in L2, and PAUSE if it's not
 intercepted
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
References: <20230405002359.418138-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230405002359.418138-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/23 02:23, Sean Christopherson wrote:
> Extend VMX's nested intercept logic for emulated instructions to handle
> "pause" interception, in quotes because KVM's emulator doesn't filter out
> NOPs when checking for nested intercepts.  Failure to allow emulation of
> NOPs results in KVM injecting a #UD into L2 on any NOP that collides with
> the emulator's definition of PAUSE, i.e. on all single-byte NOPs.
> 
> For PAUSE itself, honor L1's PAUSE-exiting control, but ignore PLE to
> avoid unnecessarily injecting a #UD into L2.  Per the SDM, the first
> execution of PAUSE after VM-Entry is treated as the beginning of a new
> loop, i.e. will never trigger a PLE VM-Exit, and so L1 can't expect any
> given execution of PAUSE to deterministically exit.
> 
>    ... the processor considers this execution to be the first execution of
>    PAUSE in a loop. (It also does so for the first execution of PAUSE at
>    CPL 0 after VM entry.)
> 
> All that said, the PLE side of things is currently a moot point, as KVM
> doesn't expose PLE to L1.
> 
> Note, vmx_check_intercept() is still wildly broken when L1 wants to
> intercept an instruction, as KVM injects a #UD instead of synthesizing a
> nested VM-Exit.  That issue extends far beyond NOP/PAUSE and needs far
> more effort to fix, i.e. is a problem for the future.
> 
> Fixes: 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest mode")
> Cc: Mathias Krause <minipli@grsecurity.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9ae4044f076f..1e560457bf9a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7898,6 +7898,21 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
>   		/* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
>   		break;
>   
> +	case x86_intercept_pause:
> +		/*
> +		 * PAUSE is a single-byte NOP with a REPE prefix, i.e. collides
> +		 * with vanilla NOPs in the emulator.  Apply the interception
> +		 * check only to actual PAUSE instructions.  Don't check
> +		 * PAUSE-loop-exiting, software can't expect a given PAUSE to
> +		 * exit, i.e. KVM is within its rights to allow L2 to execute
> +		 * the PAUSE.
> +		 */
> +		if ((info->rep_prefix != REPE_PREFIX) ||
> +		    !nested_cpu_has2(vmcs12, CPU_BASED_PAUSE_EXITING))
> +			return X86EMUL_CONTINUE;
> +
> +		break;
> +
>   	/* TODO: check more intercepts... */
>   	default:
>   		break;
> 
> base-commit: 27d6845d258b67f4eb3debe062b7dacc67e0c393

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Would you like me to apply this for 6.3?

Paolo

