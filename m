Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B7921A64F
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 19:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgGIRsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 13:48:46 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60202 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726615AbgGIRso (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 13:48:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594316923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OBKaxszc9J3brzbIe9PuekXCVyqXMqYSpp7GRiPhBv8=;
        b=C9cYy60XrGG+Uw7S2M5cqUp8/jSqnwwRzmrlifZ8QfkJA5Lnd3l9DdAnQ2+52FAZcdrpoF
        ferpXnjtfODNtdEDALIJc/ic7i5F35Nla6X4AVYbB0X3hmFJUxsC7T10i3OJreAePSAjC5
        udJ/snUA01uCbuUsyI7tWTz9GgIcRLA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-k8KwuMo7Ni62aO9D_TrJqw-1; Thu, 09 Jul 2020 13:48:39 -0400
X-MC-Unique: k8KwuMo7Ni62aO9D_TrJqw-1
Received: by mail-wm1-f69.google.com with SMTP id v6so2925138wmg.1
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 10:48:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OBKaxszc9J3brzbIe9PuekXCVyqXMqYSpp7GRiPhBv8=;
        b=pVDOGY4rUdB1SPPIKZTAmCgVHatj631q+4Wlc5n9ckSogwOVFu8/KgCbqVOQdKLqtB
         mRMN+pNK8LJoHoWBbOokjIlH0rhXEdlkp3VK93ZnjhWs1jUXqKTe6UDfvHfVtNokZstv
         K/P/TpaQMGtJzDJtJ70M/R8lFo32XPZe/A+o6XtPMrIwyo7odwljJl9qfl2ljvBMWfEX
         w94JOFRtTWvTFmGvfCY+06UfJ6YhL9YjCYsE80fO9E+dNxoGy4ksD5VR0je6/AjVpZM2
         +UzBHBJPgFHGUZecGpXWA9RHVJqFCPJgMlk2d+w1MFmsn8vgNp9eC0jrTMEBflcVXM/l
         Er5Q==
X-Gm-Message-State: AOAM530+OuP/qyF/HWyoPGNTeqE+zc72t2cDYvAhIriyHiNm0Ue72yiM
        MJeMZQRucBu5z5PRbFlnOHnminJ1GkxHj+EKc0yyo+octcN/nXFyvV3FVCXqTL0bMofsXGqW3xO
        BwoH73CM6wfra
X-Received: by 2002:adf:81c8:: with SMTP id 66mr64370295wra.348.1594316918512;
        Thu, 09 Jul 2020 10:48:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8a4V2UuLN2uaVwSJn5bbrkO3YT8wXDAE7gV63PAyJaykIzI1KjDbVMYIB+Kg+e9aq5HyBaA==
X-Received: by 2002:adf:81c8:: with SMTP id 66mr64370278wra.348.1594316918245;
        Thu, 09 Jul 2020 10:48:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id o205sm6104990wme.24.2020.07.09.10.48.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 10:48:37 -0700 (PDT)
Subject: Re: [PATCH v3 3/9] KVM: nSVM: reset nested_run_pending upon
 nested_svm_vmrun_msrpm() failure
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
References: <20200709145358.1560330-1-vkuznets@redhat.com>
 <20200709145358.1560330-4-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <262fc5f8-935d-dce2-314e-ce5db6e73940@redhat.com>
Date:   Thu, 9 Jul 2020 19:48:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200709145358.1560330-4-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/20 16:53, Vitaly Kuznetsov wrote:
> WARN_ON_ONCE(svm->nested.nested_run_pending) in nested_svm_vmexit()
> will fire if nested_run_pending remains '1' but it doesn't really
> need to, we are already failing and not going to run nested guest.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index e424bce13e6c..1cc8592b1820 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -468,6 +468,8 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
>  	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb);
>  
>  	if (!nested_svm_vmrun_msrpm(svm)) {
> +		svm->nested.nested_run_pending = 0;
> +
>  		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
>  		svm->vmcb->control.exit_code_hi = 0;
>  		svm->vmcb->control.exit_info_1  = 0;
> 

I wouldn't complain if you added a kvm-unit-tests testcase for this...

Paolo

