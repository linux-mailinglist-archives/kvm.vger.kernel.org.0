Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C8721A65F
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 19:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgGIR5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 13:57:25 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29629 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726722AbgGIR5Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 13:57:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594317443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rtpxiZIC9DpP6xJFiIycdqh94KkxS8BGOIOnHFuI6lM=;
        b=Ue9UWeIhkv9ff//+nOOcXUDv98oX4GwdFePVx90Wx/66XqEto8k4J5AobFUFgU00jNG6cN
        Z9/fcAJlGbbH40aiBZ8c1rsjtAkVeCCPNV0Y/MG4uqryMCJzXssvK39v+zfJfgEdpW8DCH
        +Sf0h6UL2FyNsiNXu2vm0duFsfWvJIU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-pFi9fZkhOyWWfQ3rmuKIRw-1; Thu, 09 Jul 2020 13:57:21 -0400
X-MC-Unique: pFi9fZkhOyWWfQ3rmuKIRw-1
Received: by mail-wr1-f70.google.com with SMTP id i10so2612472wrn.21
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 10:57:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rtpxiZIC9DpP6xJFiIycdqh94KkxS8BGOIOnHFuI6lM=;
        b=WS93WkE3GSQfTDIUkHBlvgGP6N955EYF0iK3ZAN3750upWKckrJ+aaP/jQwfGFRYB+
         3PDEl7qnUwNAOJ+8KRtwgX+ZpqTGShrHkgLY0Uu4RDx5kv4uHvCHu76OwEDZRQCVbpwE
         y+ZBYHTr1mKZNKFSX9TNxrcLClrjYQwMqQI3weWZ3COL899pM3pMol9hhw/S6VA3FKJ2
         OvfqCvbMxVl5MgUgW4vOxlaHetAvO5cBOt+H5kv4UhEA8YEsFylT1SuVe5ZVNCFxTupX
         pmjh3svGIxwPXG7JgahvT3p6oA6+IkLg1BKDuClBOQTtANNdjU3QUDbUftkuR7U3Qmpl
         /fgw==
X-Gm-Message-State: AOAM531kiPGWAoL+k/lQ4R/WecOlmGkbrO9VPAIJXVPlt2gXKflmzgaj
        2dAXUHkKoBNYisHAWtCtZ/XKFEVWln27hN46psBpGSeT1BNB3rtwQnbJYgTol6kj8oG4g4quzCe
        c/GPj0PdvC4n0
X-Received: by 2002:a7b:cc85:: with SMTP id p5mr1178746wma.18.1594317440359;
        Thu, 09 Jul 2020 10:57:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx816lR7V68tmogTqyiFqHKuAvOPgpQwxxuTWOciDQGLYuS7UzzPPkmPiIBoJAvQFDceCtG9w==
X-Received: by 2002:a7b:cc85:: with SMTP id p5mr1178730wma.18.1594317440116;
        Thu, 09 Jul 2020 10:57:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id w128sm5899563wmb.19.2020.07.09.10.57.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 10:57:19 -0700 (PDT)
Subject: Re: [PATCH v3 7/9] KVM: nSVM: implement nested_svm_load_cr3() and use
 it for host->guest switch
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
References: <20200709145358.1560330-1-vkuznets@redhat.com>
 <20200709145358.1560330-8-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4d3f5b01-72d9-c2c5-08e8-c2b1e0046e5e@redhat.com>
Date:   Thu, 9 Jul 2020 19:57:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200709145358.1560330-8-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/20 16:53, Vitaly Kuznetsov wrote:
> +	if (nested_npt_enabled(svm))
> +		nested_svm_init_mmu_context(&svm->vcpu);
> +
>  	ret = nested_svm_load_cr3(&svm->vcpu, nested_vmcb->save.cr3,
>  				  nested_npt_enabled(svm));

This needs to be done in svm_set_nested_state, so my suggestion is that
the previous patch includes a call to nested_svm_load_cr3 in
svm_set_nested_state, and this one adds the "if" inside
nested_svm_load_cr3 itself.

Paolo

> @@ -364,13 +388,6 @@ static int nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vm
>  static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
>  {
>  	const u32 mask = V_INTR_MASKING_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK;
> -	if (nested_npt_enabled(svm))
> -		nested_svm_init_mmu_context(&svm->vcpu);
> -
> -	/* Guest paging mode is active - reset mmu */
> -	kvm_mmu_reset_context(&svm->vcpu);
> -
> -	svm_flush_tlb(&svm->vcpu);
>  

