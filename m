Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46C537187E
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 17:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhECPy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 11:54:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20623 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230511AbhECPyY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 11:54:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620057211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eW25/UgqutiKmZjUcom0hJywBiqaVfV77ax9Dtfjk2k=;
        b=JirXypqD82yghcCe7uYfYTGzg6nxYk4hOgpUo3tqOAUttqiVgYjE3sXyqHecNyFLC2zM2L
        qsB2FNazXkOmVMO69ePKGtCJs5WGJnKo66mqm1d7jB88+uJZMKl9/YRIffD27dZcQF76YV
        /eGjNVi14Cf/tK+UpMVtl34IUrd25v4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-FkxBsbhKOqG2Baue-MRYEQ-1; Mon, 03 May 2021 11:53:29 -0400
X-MC-Unique: FkxBsbhKOqG2Baue-MRYEQ-1
Received: by mail-ej1-f71.google.com with SMTP id z13-20020a1709067e4db02903a28208c9bdso2239350ejr.0
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 08:53:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eW25/UgqutiKmZjUcom0hJywBiqaVfV77ax9Dtfjk2k=;
        b=OIqM4gnEcVGrJmAN7zrnYRgmmYg/6o4WljzJTfNuDkyLGvTIeQqu4NnLj4wcFwvx5c
         bLMM3EHlqxi+ibiRP1GNc/cpv+5bvoARY5Q7ZEQzBgnulgiaZCrAC6+njv6zhwZwtXqo
         /nYPWzTrFPbZzO21GwhDR8z4sqNKlDQdPGcIwYW1ku5QEtR3Q0/rdF0Kg9liuOCJCbAe
         oztGMK4P1oj5W8UzeIzlhkqFPBCmdC5w8ky4YYpP4EPUFa+jNIFMgDG8snj1C7SJtlvI
         fD0Dl2OKZtEdL56F7Sudm2AsRzrO6h1dEIvqQu18AERnZUbABYrXebOYafNF69kyyKJH
         FgGw==
X-Gm-Message-State: AOAM530vXn2mGR29ksO6FX1T7Rm/qVRfn0teQj9hLiXHPLUZmbcPuLjn
        /1qLHWkZe2ubNB7sc/MJ6yBaB9Xq64ddSnEm/xEtqnETo22r8gDT9LEn8kh4RrYxNQVDHsdGrdi
        fMx8IyXoTLTGO
X-Received: by 2002:a05:6402:28f:: with SMTP id l15mr21084539edv.246.1620057207848;
        Mon, 03 May 2021 08:53:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz50Cax+zYd3Jv3mVDf0fptucEmzbPpYjuq5457t1eJPNJ43lNuaInbKE4D2kwtHP+ZLSjmkg==
X-Received: by 2002:a05:6402:28f:: with SMTP id l15mr21084518edv.246.1620057207677;
        Mon, 03 May 2021 08:53:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id aj8sm45366ejc.64.2021.05.03.08.53.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 08:53:27 -0700 (PDT)
Subject: Re: [PATCH 4/4] KVM: nVMX: Map enlightened VMCS upon restore when
 possible
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20210503150854.1144255-1-vkuznets@redhat.com>
 <20210503150854.1144255-5-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <87de6570-750c-5ce1-17a2-36abe99813ac@redhat.com>
Date:   Mon, 3 May 2021 17:53:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210503150854.1144255-5-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/21 17:08, Vitaly Kuznetsov wrote:
> It now looks like a bad idea to not restore eVMCS mapping directly from
> vmx_set_nested_state(). The restoration path now depends on whether KVM
> will continue executing L2 (vmx_get_nested_state_pages()) or will have to
> exit to L1 (nested_vmx_vmexit()), this complicates error propagation and
> diverges too much from the 'native' path when 'nested.current_vmptr' is
> set directly from vmx_get_nested_state_pages().
> 
> The existing solution postponing eVMCS mapping also seems to be fragile.
> In multiple places the code checks whether 'vmx->nested.hv_evmcs' is not
> NULL to distinguish between eVMCS and non-eVMCS cases. All these checks
> are 'incomplete' as we have a weird 'eVMCS is in use but not yet mapped'
> state.
> 
> Also, in case vmx_get_nested_state() is called right after
> vmx_set_nested_state() without executing the guest first, the resulting
> state is going to be incorrect as 'KVM_STATE_NESTED_EVMCS' flag will be
> missing.
> 
> Fix all these issues by making eVMCS restoration path closer to its
> 'native' sibling by putting eVMCS GPA to 'struct kvm_vmx_nested_state_hdr'.
> To avoid ABI incompatibility, do not introduce a new flag and keep the

I'm not sure what is the disadvantage of not having a new flag.

Having two different paths with subtly different side effects however 
seems really worse for maintenance.  We are already discussing in 
another thread how to get rid of the check_nested_events side effects; 
that might possibly even remove the need for patch 1, so it's at least 
worth pursuing more than adding this second path.

I have queued patch 1, but I'd rather have a kvm selftest for it.  It 
doesn't seem impossible to have one...

Paolo

> original eVMCS mapping path through KVM_REQ_GET_NESTED_STATE_PAGES in
> place. To distinguish between 'new' and 'old' formats consider eVMCS
> GPA == 0 as an unset GPA (thus forcing KVM_REQ_GET_NESTED_STATE_PAGES
> path). While technically possible, it seems to be an extremely unlikely
> case.


> Signed-off-by: Vitaly Kuznetsov<vkuznets@redhat.com>

