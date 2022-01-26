Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8071149CFA7
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 17:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243123AbiAZQ1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 11:27:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21799 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236712AbiAZQ1N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 11:27:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643214432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=efzC2IwqGzejEAIdbekALVZEUqxrdpopAyww58idfp8=;
        b=SA+donqYp+rAoMJ4gISW//JCe04SN8W3z750NY052iDabqcaZtR+DdZf0EhqhkAUZgWf2q
        FpVNITOfcb6PtCi2sh+QrhHHTTr/go5iKBLSaLzQpdxZhopYgPh77jywCsxh8XKCxbZHAI
        sTRFSWhci189IqwoCDCnI0qjU0bjXcA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-U5jTIf-ANIOCZfReT-S1xQ-1; Wed, 26 Jan 2022 11:27:11 -0500
X-MC-Unique: U5jTIf-ANIOCZfReT-S1xQ-1
Received: by mail-wm1-f70.google.com with SMTP id s190-20020a1ca9c7000000b00347c6c39d9aso106767wme.5
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 08:27:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=efzC2IwqGzejEAIdbekALVZEUqxrdpopAyww58idfp8=;
        b=ZvqjI+e70LweAhx4BgXyMDf4/POjjopKtZshZncmBef2SfxiXdCkibzBXer70VT0L1
         S9xCIJO5UCpnV3C2vGIod73RBGVjzQK6bjdvn3LHF0Sg732PNwsJYP1a1IBqX7RSIjFI
         CrW3GCcJVXEj5LQKsFMirKJZeRNNdzVmFSUovou+HX0C+BqTAaEExaBZ39o3ueJWmR+U
         OG7s3uhfzraxIDNeH4H3VyfTeEO6Fpht0hAjA5R6CNSdaSuddpDan70vTECPvLhCqH+s
         kzkJim6atDLy+MYmY7+V+CbUdiJCosrXFA8WiYsUgXymU7Y+pthUs7WHfWXf2RvcwYSB
         XuuA==
X-Gm-Message-State: AOAM533zd4bqaHRv8o8eC1MSLw/V78RRNn/q8DBplwhkXrVi93Lwv1kx
        OnBS7rj/9oSaW1Dsg6vHdlAVZugZqHCvEwsdtPfRczPzKj+zBRnh8big/3ZjiP29FJd+qyznnGn
        xA+6VVmiuMSw/
X-Received: by 2002:a7b:c08b:: with SMTP id r11mr8062071wmh.111.1643214429803;
        Wed, 26 Jan 2022 08:27:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzat5xFG+n6X0ZtwIT2WzJvrNYAslBIVDm2zn1aj/rH3RM3gfE4afk84ck3WLdB4s/rkdFzNA==
X-Received: by 2002:a7b:c08b:: with SMTP id r11mr8062061wmh.111.1643214429639;
        Wed, 26 Jan 2022 08:27:09 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a14sm21852909wri.25.2022.01.26.08.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 08:27:09 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: WARN on any attempt to allocate shadow VMCS
 for vmcs02
In-Reply-To: <053bb241-ea71-abf8-262b-7b452dc49d37@redhat.com>
References: <20220125220527.2093146-1-seanjc@google.com>
 <87r18uh4of.fsf@redhat.com>
 <053bb241-ea71-abf8-262b-7b452dc49d37@redhat.com>
Date:   Wed, 26 Jan 2022 17:27:08 +0100
Message-ID: <87k0emh38j.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 1/26/22 16:56, Vitaly Kuznetsov wrote:
>>> -	WARN_ON(loaded_vmcs == &vmx->vmcs01 && loaded_vmcs->shadow_vmcs);
>>> +	if (WARN_ON(loaded_vmcs != &vmx->vmcs01 || loaded_vmcs->shadow_vmcs))
>>> +		return loaded_vmcs->shadow_vmcs;
>> Stupid question: why do we want to care about 'loaded_vmcs' at all,
>> i.e. why can't we hardcode 'vmx->vmcs01' in alloc_shadow_vmcs()? The
>> only caller is enter_vmx_operation() and AFAIU 'loaded_vmcs' will always
>> be pointing to 'vmx->vmcs01' (as enter_vmx_operation() allocates
>> &vmx->nested.vmcs02 so 'loaded_vmcs' can't point there!).
>> 
>
> Well, that's why the WARN never happens.  The idea is that if shadow 
> VMCS _virtualization_ (not emulation, i.e. running L2 VMREAD/VMWRITE 
> without even a vmexit to L0) was supported, then you would need a 
> non-NULL shadow_vmcs in vmx->vmcs02.
>
> Regarding the patch, the old WARN was messy but it was also trying to 
> avoid a NULL pointer dereference in the caller.
>
> What about:
>
> 	if (WARN_ON(loaded_vmcs->shadow_vmcs))
> 		return loaded_vmcs->shadow_vmcs;
>
> 	/* Go ahead anyway.  */
> 	WARN_ON(loaded_vmcs != &vmx->vmcs01);
>
> ?
>

FWIW, this looks better [to my personal taste].

-- 
Vitaly

