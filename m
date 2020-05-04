Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0691C40B5
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 19:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729737AbgEDRDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 13:03:23 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38265 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729459AbgEDRDX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 13:03:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588611802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DOROlQMiNPJWfRV7/CSrwARih59v8ZpS7QsX9oW6VGM=;
        b=LZ92mpCPZ9/tzTOCRIUYtFH/QZZBtI8vsW+KyL0u6a/pL0Q2CohTgcnOi9Nqo231l8qfRd
        +cIGLC4eCE1lED4fGp1KKFRhWEL0wTptW0HEecWAYWJcfE3N6C/TjS7e6Bxn3/IFDTb6jS
        FAe7LaYleANuLnGYPeN4+sk1VFSEYIQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-ShYq-cRUNJaWZMByEMeYqQ-1; Mon, 04 May 2020 13:03:20 -0400
X-MC-Unique: ShYq-cRUNJaWZMByEMeYqQ-1
Received: by mail-wr1-f71.google.com with SMTP id a3so37704wro.1
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 10:03:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DOROlQMiNPJWfRV7/CSrwARih59v8ZpS7QsX9oW6VGM=;
        b=aukFEdjfZuMdIzgvjfnvna4cNwQGm8jeLKf48Pq1QxGK28+39AhsTwzH4RuVReL3Qz
         zAQKp7JQ5IZmE5MGRbQ+Qounok7eRikfWmQ4t4T2DkNTZTgb+RJvtGg0Svw7lXaMGm7u
         zbtFuPJJIGIJU/HMl+v6RcGBzEWtikIX7jIfGge9fOQ8DiI078OYlRYp+YBu2TFZL9Nn
         sVMBt9YtPY9D0NuRomCE+IHAwL7tdrQwAXewHxPQYkxs2mfndsN1OcSQYg5iLeZlxG8C
         XjmtFnDJs1DbqAGVEcYJBMjR8f1qJ9Mlz6yqZ5mYRWzATMpH1bH4z6nKcsJsFKOpN+lD
         4YBg==
X-Gm-Message-State: AGi0PuaErocmaSMx0DA6U37Rvlw1jHM+fRaHmEBqG3dWKTkq9OdL2xM/
        6fMlW+7lM70FQbqtEVd/ZANXnofEIK9BzCJcSrrwMg4FzodrpoM37R5uUfCP8CrBTmEmKmt7JMh
        yd3yzeazL+5Sd
X-Received: by 2002:adf:f5c4:: with SMTP id k4mr270408wrp.294.1588611799201;
        Mon, 04 May 2020 10:03:19 -0700 (PDT)
X-Google-Smtp-Source: APiQypKEGqngqTL62vANmYw8MNZ/t78mH/tWUZAgBtAwMIclNwNoRLiI8cvg/NcnHiR4qg2MaM+vNA==
X-Received: by 2002:adf:f5c4:: with SMTP id k4mr270388wrp.294.1588611798970;
        Mon, 04 May 2020 10:03:18 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id c190sm69917wme.10.2020.05.04.10.03.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 10:03:18 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: nVMX: vmcs.SYSENTER optimization and "fix"
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200428231025.12766-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <61ba7eb0-4c51-0001-1d99-ef1478750c78@redhat.com>
Date:   Mon, 4 May 2020 19:03:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200428231025.12766-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/20 01:10, Sean Christopherson wrote:
> Patch 1 is a "fix" for handling SYSENTER_EIP/ESP in L2 on a 32-bit vCPU.
> The primary motivation is to provide consistent behavior after patch 2.
> 
> Patch 2 is essentially a re-submission of a nested VMX optimization to
> avoid redundant VMREADs to the SYSENTER fields in the nested VM-Exit path.
> 
> After patch 2 and without patch 1, KVM would end up with weird behavior
> where L1 and L2 would only see 32-bit values for their own SYSENTER_E*P
> MSRs, but L1 could see a 64-bit value for L2's MSRs.
> 
> Sean Christopherson (2):
>   KVM: nVMX: Truncate writes to vmcs.SYSENTER_EIP/ESP for 32-bit vCPU
>   KVM: nVMX: Drop superfluous VMREAD of vmcs02.GUEST_SYSENTER_*
> 
>  arch/x86/kvm/vmx/nested.c |  4 ----
>  arch/x86/kvm/vmx/vmx.c    | 18 ++++++++++++++++--
>  2 files changed, 16 insertions(+), 6 deletions(-)
> 

Queued, thanks.

Paolo

