Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234B2429640
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 20:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbhJKSDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 14:03:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35612 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234220AbhJKSDY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 14:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633975283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ipPrNa9mFzNPNBqhZ92y9q243LfEtR+9w1LoEF2nuIM=;
        b=RmgK3EHzMb0MhsJ+am5ZkWxsJEsEXKrKPS/cPSWaeHmIL6q8Jwffn9QCzxA8yrJ7kuXncT
        5n+CxkdH4v5CnMSS5Slge0X5DpTRdx/A/Pgn30Woq8uWsdVEVZKik0f5c87n/QYctiQZ/J
        lGl0A9PmR4HAjku+WB+cDdi7ss0Hv0w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-7xyq5oIQNKCewA_UUuTMhg-1; Mon, 11 Oct 2021 14:01:22 -0400
X-MC-Unique: 7xyq5oIQNKCewA_UUuTMhg-1
Received: by mail-wr1-f70.google.com with SMTP id r16-20020adfbb10000000b00160958ed8acso13860987wrg.16
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 11:01:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ipPrNa9mFzNPNBqhZ92y9q243LfEtR+9w1LoEF2nuIM=;
        b=D5Vb54xRNd73itaRbCoBTYVwVmJRQt0XypXpgAfMve2SoMI0acgIiAke+TVLioBHPY
         ptbvl7ylhrmdzm/16iCPu1Pb/x2FbdPGTfJEhPuyYri9ydCtDIoM+b1Mf6MoajlvRp1G
         a7S+xJoqfPh3DNSlm6tDJh12g4PJ9YWXj5I0cKV6scwGfmUi8AU57v9Xw9T185W0Xxtu
         wlVXw9/hPYh1KsyIc4XImc3i5VM2hPSYx2NbRvK5R110L3v0QsHVHOlcPPdjTm6Pjh5y
         3jd1OqFNhN3GvKEuivVACzjYC8qv+2ZAj6hSyRbtO4TuXe64DzrRhnSoLs4kKzqXSrJp
         lwcg==
X-Gm-Message-State: AOAM530y86l3EZm/XnEE1JVZx7gFjLWfrAjksgtfg3y495fWFIxp4DXg
        I5PwWey8oaJs20Zwn3xpnBYXIoQaBfOH49pI25V837pAv8CudC47VR1Oqs/SFPvMV5rRqeaEw+i
        5Syjf1Fy9K2k1
X-Received: by 2002:a05:600c:1c97:: with SMTP id k23mr495147wms.80.1633975281234;
        Mon, 11 Oct 2021 11:01:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8mmtPhzP90/itHryK5XXdw5COtyJto+TOd/Pr9KoY1r8SXld+CDdpa7oEaHZEfaYH3zToOg==
X-Received: by 2002:a05:600c:1c97:: with SMTP id k23mr495117wms.80.1633975281009;
        Mon, 11 Oct 2021 11:01:21 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c64ba.dip0.t-ipconnect.de. [91.12.100.186])
        by smtp.gmail.com with ESMTPSA id o26sm212039wmc.17.2021.10.11.11.01.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 11:01:20 -0700 (PDT)
Subject: Re: [RFC PATCH v1 5/6] KVM: s390: Give BUSY to SIGP SENSE during
 Restart
To:     Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20211008203112.1979843-1-farman@linux.ibm.com>
 <20211008203112.1979843-6-farman@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <12271458-652a-8a25-1686-da4448ba1196@redhat.com>
Date:   Mon, 11 Oct 2021 20:01:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211008203112.1979843-6-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08.10.21 22:31, Eric Farman wrote:
> A SIGP RESTART is a special animal, in that it directs the
> destination CPU to perform the restart operation. This is
> basically the loading of the Restart PSW and letting it take
> over, but a stopped CPU must first be made operating for this
> to work correctly.
> 
> As this can take a moment, let's leave a reminder that this
> SIGP is being processed, such that the SIGP SENSE logic
> (which is not handled in userspace) can return CC=2 instead
> of CC=1 (and STOPPED) until the CPU is started.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h |  1 +
>   arch/s390/kvm/kvm-s390.c         |  1 +
>   arch/s390/kvm/sigp.c             | 17 +++++++++++++++++
>   3 files changed, 19 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index a604d51acfc8..536f174c5e81 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -746,6 +746,7 @@ struct kvm_vcpu_arch {
>   	__u64 cputm_start;
>   	bool gs_enabled;
>   	bool skey_enabled;
> +	bool sigp_restart;
>   	struct kvm_s390_pv_vcpu pv;
>   	union diag318_info diag318_info;
>   };
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 6a6dd5e1daf6..33d71fa42d68 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4603,6 +4603,7 @@ int kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
>   	}
>   
>   	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_STOPPED);
> +	vcpu->arch.sigp_restart = 0;
>   	/*
>   	 * The real PSW might have changed due to a RESTART interpreted by the
>   	 * ultravisor. We block all interrupts and let the next sie exit
> diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
> index c64e37f4347d..5a21354d0265 100644
> --- a/arch/s390/kvm/sigp.c
> +++ b/arch/s390/kvm/sigp.c
> @@ -27,6 +27,8 @@ static int __sigp_sense(struct kvm_vcpu *vcpu, struct kvm_vcpu *dst_vcpu,
>   	ext_call_pending = kvm_s390_ext_call_pending(dst_vcpu);
>   	if (!stopped && !ext_call_pending)
>   		rc = SIGP_CC_ORDER_CODE_ACCEPTED;
> +	else if (stopped && dst_vcpu->arch.sigp_restart)
> +		rc = SIGP_CC_BUSY;
>   	else {
>   		*reg &= 0xffffffff00000000UL;
>   		if (ext_call_pending)
> @@ -385,6 +387,18 @@ static int handle_sigp_order_in_user_space(struct kvm_vcpu *vcpu, u8 order_code,
>   	return 1;
>   }
>   
> +static void handle_sigp_restart(struct kvm_vcpu *vcpu, u16 cpu_addr)
> +{
> +	struct kvm_vcpu *dst_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, cpu_addr);
> +
> +	/* Ignore SIGP Restart to non-existent CPUs */
> +	if (!dst_vcpu)
> +		return;
> +
> +	if (is_vcpu_stopped(dst_vcpu))
> +		dst_vcpu->arch.sigp_restart = 1;
> +}
> +
>   static int handle_sigp_order_is_blocked(struct kvm_vcpu *vcpu, u8 order_code,
>   					u16 cpu_addr)
>   {
> @@ -443,6 +457,9 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
>   	if (handle_sigp_order_is_blocked(vcpu, order_code, cpu_addr))
>   		return 0;
>   
> +	if (order_code == SIGP_RESTART)
> +		handle_sigp_restart(vcpu, cpu_addr);
> +
>   	if (handle_sigp_order_in_user_space(vcpu, order_code, cpu_addr))
>   		return -EOPNOTSUPP;
>   
> 

Okay, staring at this, I think we really might just let user space 
indicate SIGP as busy/!busy. Will take a lot of magic out of this code. 
My 2 cents.

-- 
Thanks,

David / dhildenb

