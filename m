Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477D235E32B
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 17:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346097AbhDMPvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 11:51:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345974AbhDMPvc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 11:51:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618329072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mx8G23iIwQpvCopH+lLZJCQYD8cBudejzb4dbgEmNqA=;
        b=BR1df5v60O36fZLRzhvnBsrpoNSPZctrsFj3etI/rP3Qeb5jtH+oEgJU25hClJZlhCtcEa
        Expob/o/TduPqCyy3PG7ZqEfPneudBGzIQdXuDZhbC0F7NLpUyvAq5346QQmDmMnsrrig4
        xTDVYX9RUlpDfSAqZscwIfFDvZTmXTc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-8y_lQLHsMpSJgxG6WxBTcw-1; Tue, 13 Apr 2021 11:51:10 -0400
X-MC-Unique: 8y_lQLHsMpSJgxG6WxBTcw-1
Received: by mail-ed1-f69.google.com with SMTP id w15-20020a056402268fb02903828f878ec5so1498627edd.5
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 08:51:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mx8G23iIwQpvCopH+lLZJCQYD8cBudejzb4dbgEmNqA=;
        b=fsZ0eyDJOvoFHqPQ4uWICmQWAsJttfmuVOzpDXaP14HIOC93QfW9J8ad0Y0g4wEbOm
         w6fBDjEH0x47eoFW4PGqmRsUlZ6fE7/aqRxq4a1yq33/kpGUjUVPwzbRQNveZFlYhCAj
         CsMhpm1MddUhDnnvxckUDYd1PLoZzrK1OLAFcIXFPxtcD7JMcWlEslzPbkcvsME1qGha
         I4EO6i21Aa6WrwWArTiuMdsj26wU9oGZcxGTd6UZj2ZLIA9EuFduB4EyxvTolg6yanQu
         X5lAyoOqCmV5IPFcEp7GHxhuvwkVtTkJ6doadyHXq2eHApMUD6hsrosGRHXK+c19AaeY
         CWLA==
X-Gm-Message-State: AOAM533+t8uzkSQZYwSGn+35wV7+qD+KHw5Ry5YEzcsRsio/tF8AVHu9
        Nf5o1AreX3oHy/j1yuPZeQHSwnSIIMVNZcXxZUCLT7PU8rD4RibRFV9aDOfxVrCmo45xiWPKOIy
        NWTvGIv9isa7V
X-Received: by 2002:a50:f30b:: with SMTP id p11mr36114945edm.387.1618329068645;
        Tue, 13 Apr 2021 08:51:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRP0mScfJ9iRajaAMOFLSgSLAQJizgI2mMTF0t2j1suQMYsHwEKLjiHf/9H5zGqVSu3A8lzA==
X-Received: by 2002:a50:f30b:: with SMTP id p11mr36114928edm.387.1618329068442;
        Tue, 13 Apr 2021 08:51:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ho11sm8037287ejc.112.2021.04.13.08.51.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 08:51:07 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Don't use vcpu->run->internal.ndata as an array
 index
To:     Reiji Watanabe <reijiw@google.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
References: <20210413154739.490299-1-reijiw@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <87a44c1d-8c69-8a1d-8348-4207bf7296a9@redhat.com>
Date:   Tue, 13 Apr 2021 17:51:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210413154739.490299-1-reijiw@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/04/21 17:47, Reiji Watanabe wrote:
> __vmx_handle_exit() uses vcpu->run->internal.ndata as an index for
> an array access.  Since vcpu->run is (can be) mapped to a user address
> space with a writer permission, the 'ndata' could be updated by the
> user process at anytime (the user process can set it to outside the
> bounds of the array).
> So, it is not safe that __vmx_handle_exit() uses the 'ndata' that way.
> 
> Fixes: 1aa561b1a4c0 ("kvm: x86: Add "last CPU" to some KVM_EXIT information")
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)

Ouch.  In theory it's an internal error, but we've seen it happen on 
problematic hardware.  Should we consider it a security issue?

Paolo

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 32cf8287d4a7..29b40e092d13 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6027,19 +6027,19 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>   	     exit_reason.basic != EXIT_REASON_PML_FULL &&
>   	     exit_reason.basic != EXIT_REASON_APIC_ACCESS &&
>   	     exit_reason.basic != EXIT_REASON_TASK_SWITCH)) {
> +		int ndata = 3;
> +
>   		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>   		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
> -		vcpu->run->internal.ndata = 3;
>   		vcpu->run->internal.data[0] = vectoring_info;
>   		vcpu->run->internal.data[1] = exit_reason.full;
>   		vcpu->run->internal.data[2] = vcpu->arch.exit_qualification;
>   		if (exit_reason.basic == EXIT_REASON_EPT_MISCONFIG) {
> -			vcpu->run->internal.ndata++;
> -			vcpu->run->internal.data[3] =
> +			vcpu->run->internal.data[ndata++] =
>   				vmcs_read64(GUEST_PHYSICAL_ADDRESS);
>   		}
> -		vcpu->run->internal.data[vcpu->run->internal.ndata++] =
> -			vcpu->arch.last_vmentry_cpu;
> +		vcpu->run->internal.data[ndata++] = vcpu->arch.last_vmentry_cpu;
> +		vcpu->run->internal.ndata = ndata;
>   		return 0;
>   	}
>   
> 

