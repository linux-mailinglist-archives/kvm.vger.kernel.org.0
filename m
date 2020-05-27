Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDFD1E49A8
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 18:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730928AbgE0QSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 12:18:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56569 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730922AbgE0QSG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 May 2020 12:18:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590596284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CRm5cPL6z15Mnl2YBaAR83qOl+cyrSmYGHPD6J5WtrA=;
        b=WoW9vTNAtgJy2dk8XQ8N/IAnhas7wNzW1NzmHh1a4cE6T86FKdRSQycqSHgMJhFJeF8O/u
        J7HFMt2yFbpZDQYrTs9bJ6e2dCYChvJz5MlsaIWKLCIZsroGoxFFh96aqXkYcAT9IJg8Aq
        NM79cfTErKh4IRgnBg+VbSTojj+K5Es=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-jQu1iy9eP6eZQKhklrp5IA-1; Wed, 27 May 2020 12:18:03 -0400
X-MC-Unique: jQu1iy9eP6eZQKhklrp5IA-1
Received: by mail-wr1-f70.google.com with SMTP id l18so6339865wrm.0
        for <kvm@vger.kernel.org>; Wed, 27 May 2020 09:18:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CRm5cPL6z15Mnl2YBaAR83qOl+cyrSmYGHPD6J5WtrA=;
        b=mEI1DPWQgpYJczJIOPffguCXxLu0jYu7UXt6DVknwMxESiyJ68p8s0TUvxglPGG03K
         dSQmBrpNi48NYptvO84FFKPzUUI6A05xnoKjg8Ffq66UsPdb7pGnlNqcdCfT9kZiTfsN
         7LJ5nnwynNTnPOCs7CABlPxQRuQ1yInm5uGOtfyymdI+0Cs6JlUbknp+ntNQTtH9WzJ1
         iCZvfY5VJaglrltiqVnQUpefdSgHb1lxPVlmG9X33X8qtoTzg37MEDTKmFeQlAORq0dg
         ue9t+gOSfJrh5Zi6OAP1YfJbAG8DrriJ3Wq8YzF986tJJAA2Ry1MG+M3JTApPBEHihO6
         /N9A==
X-Gm-Message-State: AOAM533TsJpHRF/pcb6XBeMLWZ08mRYnd/UduHvZBA0UsY/TfYwVHixy
        PurouyvBxWb0xA+277I23G5Bivq/9k0Tb/9TYP0cWEfLaa7ahqcua3GwoI+Sbl8pw1+/2ogZJug
        LcJGQxmsQ/+UI
X-Received: by 2002:a5d:5605:: with SMTP id l5mr14379292wrv.318.1590596281370;
        Wed, 27 May 2020 09:18:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzum5m0L/JLhaElxEyyZzYisH72lxYN4r2OudO4NQkaHD5ru8XuM+8rkO6kq1TRyEptOKI8gA==
X-Received: by 2002:a5d:5605:: with SMTP id l5mr14379279wrv.318.1590596281110;
        Wed, 27 May 2020 09:18:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id n1sm3216999wrp.10.2020.05.27.09.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:18:00 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Initialize tdp_level during vCPU creation
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+904752567107eefb728c@syzkaller.appspotmail.com
References: <20200527085400.23759-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <40800163-2b28-9879-f21b-687f89070c91@redhat.com>
Date:   Wed, 27 May 2020 18:17:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200527085400.23759-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/05/20 10:54, Sean Christopherson wrote:
> Initialize vcpu->arch.tdp_level during vCPU creation to avoid consuming
> garbage if userspace calls KVM_RUN without first calling KVM_SET_CPUID.
> 
> Fixes: e93fd3b3e89e9 ("KVM: x86/mmu: Capture TDP level when updating CPUID")
> Reported-by: syzbot+904752567107eefb728c@syzkaller.appspotmail.com
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b226fb8abe41b..01a6304056197 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9414,6 +9414,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	fx_init(vcpu);
>  
>  	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
> +	vcpu->arch.tdp_level = kvm_x86_ops.get_tdp_level(vcpu);
>  
>  	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;

Queued, it is probably a good idea to add a selftests testcase for this
(it's even okay if it doesn't use the whole selftests infrastructure and
invokes KVM_CREATE_VM/KVM_CREATE_VCPU/KVM_RUN manually).

Paolo

