Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB3F2FA82E
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 19:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407415AbhARSAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 13:00:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36081 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407399AbhARR7c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 12:59:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610992675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cYNkeXcF9Tcb7cX793JXOfrYFyYndnmkMLiVTA0JAN0=;
        b=UwkE72vl9nJoCzvzJJsH+mJ0kpSQAcCvA27H5uYwqE8sUxux0QtTJXLZKW6S/1Wd/z5zEp
        sQHJP/HZJgEYy9ADy519ok4U8OVbQk51QAvvJ2BH+GTbNywuanqKN2j06V/xBal/dLkLmQ
        TmTrQKn29vgT4T7BcRc1EgApDcc1hxk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-msN2yIPpP-q2JhYHhB9ycQ-1; Mon, 18 Jan 2021 12:57:54 -0500
X-MC-Unique: msN2yIPpP-q2JhYHhB9ycQ-1
Received: by mail-ed1-f72.google.com with SMTP id n18so8152713eds.2
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 09:57:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cYNkeXcF9Tcb7cX793JXOfrYFyYndnmkMLiVTA0JAN0=;
        b=NB6lnBPn5ZkdRzNnPBJZK5aVdL63ayiUTHyauT7bQmbf2N5cr69foj/ssRYaHwdMqo
         +oRpERZTY+pN94FAimkUK+RfTMyR+82BrVWdGRHTREx2QTwyfslIov0Uk8gHwV0+2Grq
         pSB5ZwRR51r9EUkG6BCvlfwGaWF7snVLElNXKysGCR8GuX62FD5nn/j9SxZ13F20ElBJ
         hb9Ti2MXgT361xuKFhDZeRBKJ5ueMVweCUrRX/Axd+lNV2Y+Gyt3l2xSkOijdy4dkpp0
         n+nE/Qi9pHwUo9b1+nRzERyY4YshBgqqY7yjWbfsYAz2EgNmL5AVZwIitnt0AlCdqLJX
         siQw==
X-Gm-Message-State: AOAM532TAsW6FmXPoPpQNkFhH5XWu3AgMK0N0ZnliduMUuPEdMctxUnY
        zcNDCcn9vNh++lLxcFXQbi0P63O+ApC1nmS4Wh+N/eUW8henX6Ik3GW2Y6iFqLVnbNL+fGs0Hm8
        TOxA0OyoQdV1B
X-Received: by 2002:a17:906:f144:: with SMTP id gw4mr549990ejb.189.1610992673007;
        Mon, 18 Jan 2021 09:57:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxSHMzcxJIbrnIvZGKiBf5FtKWIEpbgLrxS9fGg2sCij+HrCde4Y/eLFskKXmoDcQzdUNnTLg==
X-Received: by 2002:a17:906:f144:: with SMTP id gw4mr549977ejb.189.1610992672811;
        Mon, 18 Jan 2021 09:57:52 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g25sm10636592edw.92.2021.01.18.09.57.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 09:57:52 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: get smi pending status correctly
To:     Jay Zhou <jianjay.zhou@huawei.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com,
        vkuznets@redhat.com, weidong.huang@huawei.com,
        wangxinxin.wang@huawei.com, zhuangshengen@huawei.com
References: <20210118084720.1585-1-jianjay.zhou@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4b2565ca-83da-c337-ccf3-ee31a28fd605@redhat.com>
Date:   Mon, 18 Jan 2021 18:57:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210118084720.1585-1-jianjay.zhou@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/01/21 09:47, Jay Zhou wrote:
> The injection process of smi has two steps:
> 
>      Qemu                        KVM
> Step1:
>      cpu->interrupt_request &= \
>          ~CPU_INTERRUPT_SMI;
>      kvm_vcpu_ioctl(cpu, KVM_SMI)
> 
>                                  call kvm_vcpu_ioctl_smi() and
>                                  kvm_make_request(KVM_REQ_SMI, vcpu);
> 
> Step2:
>      kvm_vcpu_ioctl(cpu, KVM_RUN, 0)
> 
>                                  call process_smi() if
>                                  kvm_check_request(KVM_REQ_SMI, vcpu) is
>                                  true, mark vcpu->arch.smi_pending = true;
> 
> The vcpu->arch.smi_pending will be set true in step2, unfortunately if
> vcpu paused between step1 and step2, the kvm_run->immediate_exit will be
> set and vcpu has to exit to Qemu immediately during step2 before mark
> vcpu->arch.smi_pending true.
> During VM migration, Qemu will get the smi pending status from KVM using
> KVM_GET_VCPU_EVENTS ioctl at the downtime, then the smi pending status
> will be lost.
> 
> Signed-off-by: Jay Zhou <jianjay.zhou@huawei.com>
> Signed-off-by: Shengen Zhuang <zhuangshengen@huawei.com>
> ---
>   arch/x86/kvm/x86.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9a8969a..9025c76 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -105,6 +105,7 @@
>   
>   static void update_cr8_intercept(struct kvm_vcpu *vcpu);
>   static void process_nmi(struct kvm_vcpu *vcpu);
> +static void process_smi(struct kvm_vcpu *vcpu);
>   static void enter_smm(struct kvm_vcpu *vcpu);
>   static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
>   static void store_regs(struct kvm_vcpu *vcpu);
> @@ -4230,6 +4231,9 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
>   {
>   	process_nmi(vcpu);
>   
> +	if (kvm_check_request(KVM_REQ_SMI, vcpu))
> +		process_smi(vcpu);
> +
>   	/*
>   	 * In guest mode, payload delivery should be deferred,
>   	 * so that the L1 hypervisor can intercept #PF before
> 

Queued, thanks.

Paolo

