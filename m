Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9BC192D03
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 16:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgCYPlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 11:41:13 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:51512 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727574AbgCYPlN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 11:41:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585150872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Ngiuyi2mPOkcihv5oJIqBDsHsKSsKleu59l1oFbskM=;
        b=RyKwMif1TJyCfgXvXlK70cF/HAH2Z6Kux+E7tqzMnclvUOrjWHZrlYkyUe9jx8xQ7+xVWE
        /C/Ka6LqMqq3dUPUG1sHTjs/zn2FouVs/O4B8MgOEScsyHl0w9lvXW7ILmnZih2LEM6pWc
        4jXloO5hOVtEYA6zP0euqE5XtBVHd5k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-gz7eeyyPN2-Vj0Sjoh2UsQ-1; Wed, 25 Mar 2020 11:41:10 -0400
X-MC-Unique: gz7eeyyPN2-Vj0Sjoh2UsQ-1
Received: by mail-wr1-f69.google.com with SMTP id i18so1311476wrx.17
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 08:41:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/Ngiuyi2mPOkcihv5oJIqBDsHsKSsKleu59l1oFbskM=;
        b=rDiyYOrt/tbwvixzKI+uzVaMv0kuJfq1YHiZFpjwVkUPhXvqKPlhRWXuSe7ki0m9QB
         t9M1cBGGIt2jN+YaL+w5Yg9xbiKhLTl5ZnTXHk11rw3c5B/23nlbpvu4k2TfwJLROlnh
         9WhbD6YasAujKGA/WaMVEt35uxVQwY423cBYrP9jbzExbD6krBJfwJdGStBCX4Sd2PAs
         J2CPaIt14rtokIJqtJsPKLUAefky2Ptp4gXu/s7Lowvh+cHCZs7r4GxT14Wo9ngdRndE
         vyAqLTd3CwD1Lx7J4JPNnYDK+AHen30JkqFUPeiQxEtcY/+0V9jvPfD4BookAV7mJKTm
         RsiA==
X-Gm-Message-State: ANhLgQ3VEraoFbxdohJ7ex8eUHSXH6kjAla4jszFvdXfHZcv1I+6rpBk
        JpgUnlMvYgRkdura9NLylbwli3YxKMoo9qAOC57oiCyV5P0ohh0+NppIStV5AOP1FAIWN7klNw9
        ZC2Gf0uw6PeMF
X-Received: by 2002:a7b:c92d:: with SMTP id h13mr3959971wml.120.1585150869592;
        Wed, 25 Mar 2020 08:41:09 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvbr1+l/xZMbMViqldvquG3f4mIsOv7XLQLH9qfgp9XfXr6o0IjBTSGNeUaZgxu8Y59Ae59mQ==
X-Received: by 2002:a7b:c92d:: with SMTP id h13mr3959958wml.120.1585150869364;
        Wed, 25 Mar 2020 08:41:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e4f4:3c00:2b79:d6dc? ([2001:b07:6468:f312:e4f4:3c00:2b79:d6dc])
        by smtp.gmail.com with ESMTPSA id n9sm6377963wru.50.2020.03.25.08.41.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 08:41:08 -0700 (PDT)
Subject: Re: [PATCH v3 14/37] KVM: x86: Move "flush guest's TLB" logic to
 separate kvm_x86_ops hook
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-15-sean.j.christopherson@intel.com>
 <87369w7mxe.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9d1ef88c-2b68-58c5-c62e-8b123187e573@redhat.com>
Date:   Wed, 25 Mar 2020 16:41:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87369w7mxe.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/03/20 11:23, Vitaly Kuznetsov wrote:
> What do you think about the following (very lightly
> tested)?
> 
> commit 485b4a579605597b9897b3d9ec118e0f7f1138ad
> Author: Vitaly Kuznetsov <vkuznets@redhat.com>
> Date:   Wed Mar 25 11:14:25 2020 +0100
> 
>     KVM: x86: make Hyper-V PV TLB flush use tlb_flush_guest()
>     
>     Hyper-V PV TLB flush mechanism does TLB flush on behalf of the guest
>     so doing tlb_flush_all() is an overkill, switch to using tlb_flush_guest()
>     (just like KVM PV TLB flush mechanism) instead. Introduce
>     KVM_REQ_HV_TLB_FLUSH to support the change.
>     
>     Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 167729624149..8c5659ed211b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -84,6 +84,7 @@
>  #define KVM_REQ_APICV_UPDATE \
>  	KVM_ARCH_REQ_FLAGS(25, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_TLB_FLUSH_CURRENT	KVM_ARCH_REQ(26)
> +#define KVM_REQ_HV_TLB_FLUSH		KVM_ARCH_REQ(27)
>  
>  #define CR0_RESERVED_BITS                                               \
>  	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index a86fda7a1d03..0d051ed11f38 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1425,8 +1425,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *current_vcpu, u64 ingpa,
>  	 * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
>  	 * analyze it here, flush TLB regardless of the specified address space.
>  	 */
> -	kvm_make_vcpus_request_mask(kvm,
> -				    KVM_REQ_TLB_FLUSH | KVM_REQUEST_NO_WAKEUP,
> +	kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH,
>  				    vcpu_mask, &hv_vcpu->tlb_flush);
>  

Looks good, but why are you dropping KVM_REQUEST_NO_WAKEUP?

Paolo

