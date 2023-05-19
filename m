Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF2D709EA0
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 19:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbjESR4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 13:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbjESR4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 13:56:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1689E107
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 10:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684518967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IaiViEvH0tonKl7XtHkSt8uNpoZYk0/1JT6fmXoL+d4=;
        b=QADnnHkloA0E5zXvX3wxCfo0wCtEOROJxwS/MtupIFGFsr814AXi7u51r9fzTIQf2buw3N
        +2nsa9eNE0I2mQb+fWafntByd6QD0bJF0rnYw1ZohzacPJmxCwDYt9qPkm9nrED1ges//5
        TTJU1iLuU26HVfYEevw2k0Gb/AQ49CI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-eJ8y_PCtPM-dkiOo-pM2bQ-1; Fri, 19 May 2023 13:56:06 -0400
X-MC-Unique: eJ8y_PCtPM-dkiOo-pM2bQ-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-50bd07fbd97so4336810a12.0
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 10:56:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684518964; x=1687110964;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IaiViEvH0tonKl7XtHkSt8uNpoZYk0/1JT6fmXoL+d4=;
        b=Sl07+E4iBRfiNg7Re3QrVJk0GXFtSqHMh4PruMeiHjpabjrjBQnxRzHYkY0hFHdrcR
         bUo9LZ5kVivAT7jU+mCVi+73wugeOKNAWwD31N5UqkB+MSbS2b2K7L2LWySBQo0DDfGQ
         3RvvN5Xf6/q4H97KYPbdvu03VVmhJlt0b5/9cQqTcI9BGUF5//R/CGvzzi9HbWSpYFV3
         BOVhtPgTwliIrHL01ZkAVZCXk+mZ7NcG26q06cwS0SQYvUABdFdgP2j5/nmL3UaLJeRB
         X9BDV4IkWBslyjBe05+jlGDmccuAro4envScWRUoEZPwgK6EUxF7tYiJusE3iXSMHC6d
         ospg==
X-Gm-Message-State: AC+VfDwTeumaPoyjrA9dVPGrtKA/HShF+0NhNvbhz8pt0WKARYfmC3Dl
        nksqNEjAV0jx5PZtGKFdELGSFDIp/XYYNGksXWo/eQP+F+SSaex/MDLBCIIUJxTGWOol/5aDBm0
        YsoQHzs7iUVY8aW8+RX2H
X-Received: by 2002:aa7:ccc6:0:b0:510:6ccf:84aa with SMTP id y6-20020aa7ccc6000000b005106ccf84aamr3089611edt.32.1684518964418;
        Fri, 19 May 2023 10:56:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ69Vc6aQEl7/0ZW+HUyj0N66ZekDVZpQxzHB5X4JxnafXUOAL+lppa4Lcq8lCYMhIm2+I1wPg==
X-Received: by 2002:aa7:ccc6:0:b0:510:6ccf:84aa with SMTP id y6-20020aa7ccc6000000b005106ccf84aamr3089599edt.32.1684518964134;
        Fri, 19 May 2023 10:56:04 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id c14-20020a056402100e00b0050bdd7fafd8sm8121edu.29.2023.05.19.10.56.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 10:56:03 -0700 (PDT)
Message-ID: <21c6e223-d482-b272-68c9-c442ea834777@redhat.com>
Date:   Fri, 19 May 2023 19:56:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3] KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save
Content-Language: en-US
To:     Mingwei Zhang <mizhang@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
References: <20230509032348.1153070-1-mizhang@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230509032348.1153070-1-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/9/23 05:23, Mingwei Zhang wrote:
> Add MSR_IA32_TSX_CTRL into msrs_to_save[] to explicitly tell userspace to
> save/restore the register value during migration. Missing this may cause
> userspace that relies on KVM ioctl(KVM_GET_MSR_INDEX_LIST) fail to port the
> value to the target VM.
> 
> In addition, there is no need to add MSR_IA32_TSX_CTRL when
> ARCH_CAP_TSX_CTRL_MSR is not supported in kvm_get_arch_capabilities(). So
> add the checking in kvm_probe_msr_to_save().
> 
> Fixes: c11f83e0626b ("KVM: vmx: implement MSR_IA32_TSX_CTRL disable RTM functionality")
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>   arch/x86/kvm/x86.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 237c483b1230..c8accbd6c861 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1431,7 +1431,7 @@ static const u32 msrs_to_save_base[] = {
>   #endif
>   	MSR_IA32_TSC, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA,
>   	MSR_IA32_FEAT_CTL, MSR_IA32_BNDCFGS, MSR_TSC_AUX,
> -	MSR_IA32_SPEC_CTRL,
> +	MSR_IA32_SPEC_CTRL, MSR_IA32_TSX_CTRL,
>   	MSR_IA32_RTIT_CTL, MSR_IA32_RTIT_STATUS, MSR_IA32_RTIT_CR3_MATCH,
>   	MSR_IA32_RTIT_OUTPUT_BASE, MSR_IA32_RTIT_OUTPUT_MASK,
>   	MSR_IA32_RTIT_ADDR0_A, MSR_IA32_RTIT_ADDR0_B,
> @@ -7077,6 +7077,10 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>   		if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
>   			return;
>   		break;
> +	case MSR_IA32_TSX_CTRL:
> +		if (!(kvm_get_arch_capabilities() & ARCH_CAP_TSX_CTRL_MSR))
> +			return;
> +		break;
>   	default:
>   		break;
>   	}

Queued, thanks.

Paolo

