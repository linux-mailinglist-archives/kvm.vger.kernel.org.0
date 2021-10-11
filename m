Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BA84287AF
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 09:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhJKHeA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 03:34:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26444 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234485AbhJKHd5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 03:33:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633937517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a210ckzQm4JqYYBLhKsiHngtpgbwX0XEROzyJlo7jpM=;
        b=Y3Pxqc5eo07JWd33KGsv0SUmHna/wzlfkgzGU5HTI2VJl3yDfVN77oZpj9TzDDJc7udff5
        VH8lBzAWxh7oBQRQV4eOBuEusNC5e1H/9ysBmBq02iguxSygsJqaZX3yIRWx6rdj2iYze+
        9Hndae3WhKIHQHdOe8tQgxr6kUC8guk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-KEr3_ZZ_Mzm3MHUgYLz5YA-1; Mon, 11 Oct 2021 03:31:55 -0400
X-MC-Unique: KEr3_ZZ_Mzm3MHUgYLz5YA-1
Received: by mail-wr1-f71.google.com with SMTP id e12-20020a056000178c00b001606927de88so12516862wrg.10
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 00:31:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a210ckzQm4JqYYBLhKsiHngtpgbwX0XEROzyJlo7jpM=;
        b=3NPrjOQqRK/JotmjgfPsRfx7kk2798KWFXM0estSgQZbrs0/pI4bwKJcZM1oPYOqDK
         SW9kDHwo+MsW2wP8n/CQW+h7PEJovbtwAc0tDG1XgoDYxyYfXykbtVm+smt/zdszeK06
         RLjlnwvdhcnj02lpY59tA5B3LGDLahAEwfu+sghnqa9lOMTrsqs4jby8k6rA6PlU9UcM
         nIhEz1xnrDieojm7zgIdqV6+YMmJsvweNVO1UBa5UndF/oRjSRHEIOxa7A/dnlpvlsWm
         THrqBTF7Yv+4o15UdSLSBZztNr+5REak1ela+np2GP+7fSLDPmjwdWF5A40CS0kaqTqe
         2CVw==
X-Gm-Message-State: AOAM530KvdChWmrNX3rV8sadPo83EsI8KX8BEOfu12DlVhCX9YD0LS7j
        SJvt46INXDOLNrHHQGSPzQAerKERG5YQTx4DyjLxZAMarr3KqDcFpVb3DRZXs2Ah2HHhr0LU4E0
        gLboCWvB5nCF2
X-Received: by 2002:a1c:f201:: with SMTP id s1mr19273214wmc.101.1633937514702;
        Mon, 11 Oct 2021 00:31:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0c1SsMWT1kdbkWnjImvHpEkjZjpFpHfh+uoDJO5Bt7abuD+iUkEvXNytiunZjBlS2SLg8TA==
X-Received: by 2002:a1c:f201:: with SMTP id s1mr19273206wmc.101.1633937514543;
        Mon, 11 Oct 2021 00:31:54 -0700 (PDT)
Received: from thuth.remote.csb (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id k8sm7201014wmr.32.2021.10.11.00.31.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 00:31:54 -0700 (PDT)
Subject: Re: [RFC PATCH v1 6/6] KVM: s390: Add a routine for setting userspace
 CPU state
To:     Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20211008203112.1979843-1-farman@linux.ibm.com>
 <20211008203112.1979843-7-farman@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <ed462de1-47c7-695e-b958-6b5de6119a1d@redhat.com>
Date:   Mon, 11 Oct 2021 09:31:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211008203112.1979843-7-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/10/2021 22.31, Eric Farman wrote:
> This capability exists, but we don't record anything when userspace
> enables it. Let's refactor that code so that a note can be made in
> the debug logs that it was enabled.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   arch/s390/kvm/kvm-s390.c | 6 +++---
>   arch/s390/kvm/kvm-s390.h | 9 +++++++++
>   2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 33d71fa42d68..48ac0bd05bee 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2487,8 +2487,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
>   	case KVM_S390_PV_COMMAND: {
>   		struct kvm_pv_cmd args;
>   
> -		/* protvirt means user sigp */
> -		kvm->arch.user_cpu_state_ctrl = 1;
> +		/* protvirt means user cpu state */
> +		kvm_s390_set_user_cpu_state_ctrl(kvm);
>   		r = 0;
>   		if (!is_prot_virt_host()) {
>   			r = -EINVAL;
> @@ -3801,7 +3801,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>   	vcpu_load(vcpu);
>   
>   	/* user space knows about this interface - let it control the state */
> -	vcpu->kvm->arch.user_cpu_state_ctrl = 1;
> +	kvm_s390_set_user_cpu_state_ctrl(vcpu->kvm);
>   
>   	switch (mp_state->mp_state) {
>   	case KVM_MP_STATE_STOPPED:
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 57c5e9369d65..36f4d585513c 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -208,6 +208,15 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
>   	return kvm->arch.user_cpu_state_ctrl != 0;
>   }
>   
> +static inline void kvm_s390_set_user_cpu_state_ctrl(struct kvm *kvm)
> +{
> +	if (kvm->arch.user_cpu_state_ctrl)
> +		return;
> +
> +	VM_EVENT(kvm, 3, "%s", "ENABLE: Userspace CPU state control");
> +	kvm->arch.user_cpu_state_ctrl = 1;
> +}
> +
>   /* implemented in pv.c */
>   int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
>   int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

