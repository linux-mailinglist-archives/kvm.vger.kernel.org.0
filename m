Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A46136045C
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 10:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhDOIfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 04:35:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57054 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230090AbhDOIf3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Apr 2021 04:35:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618475706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kBrEkGF0cKPOnazz8Z/zsgBklfJjCzSq4ge542EZuHE=;
        b=ely7SxgQRXCBEMGUUqkGqg1zJ+DSjh0yfXEWlDnx5JzIr1+oaIq6LiXzUUxIF7es1DSxac
        2SXyeW8fVg4Qn1IqhRGESrOFch7kZX6pc+FnGc0cTKOqDJeV7D/87TWPE0bk13j1FwtY8t
        tf3pvbU8HEnjlMKj0iL26StcfvB3njQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-TNAubPgFMj6vm05rKqiq5A-1; Thu, 15 Apr 2021 04:35:04 -0400
X-MC-Unique: TNAubPgFMj6vm05rKqiq5A-1
Received: by mail-wm1-f69.google.com with SMTP id n67-20020a1c59460000b0290114d1a03f5bso3977628wmb.6
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 01:35:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kBrEkGF0cKPOnazz8Z/zsgBklfJjCzSq4ge542EZuHE=;
        b=klWzvdhcsrcMLSubfuyg4uV+72CpOex2w2C3zEyDnDKg3InTR5Wn1lUQHu9dBWjSsk
         HYL0S/wsK1NIgqSqjGXSqZ+s9yO/ATT1Gr+evN4U4XaucXB5yohVRPOzuen2+nhUjhPf
         twSEWDTiz+1pMLNKvhXLdnFL5qCAFb9kxTiXpSIygGKDNWF0L7XO/YzQKiWUZ96VzJRj
         Hnzxrnga7Bt0j/53i5d+MRVzvYmZVy7VlBH50jjvMrLk5KGvgjIqBObLvDdTyHrg/YiL
         A/7ezwkGCz4hxcU4E7eg6PywJBfSyKRG27Rghc4FYvUw02UXYBYyQRKc7JuUlp/ivAE5
         +DgQ==
X-Gm-Message-State: AOAM531QsX2YM3yqS23VIGF8fJrthY1Fbc6LW7rJQqDhfDXKav4V1kH3
        x8OtZFdgaV6qddzMIDOXcBEWUwI/XmCx7I+A9FWo+eI5TZfhjB9w0j/3hlYkyDWuoyF0TCVsjGx
        k50fCjpEXLK0U
X-Received: by 2002:a7b:c0c4:: with SMTP id s4mr1991137wmh.184.1618475703265;
        Thu, 15 Apr 2021 01:35:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGZCsXSmAIkvUHqtLei5+QBL+hT7QlvinwDuxwvPls7mLWYCQxPgO24ot/vvyDhbjHTf6xfQ==
X-Received: by 2002:a7b:c0c4:: with SMTP id s4mr1991108wmh.184.1618475702975;
        Thu, 15 Apr 2021 01:35:02 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6392.dip0.t-ipconnect.de. [91.12.99.146])
        by smtp.gmail.com with ESMTPSA id c18sm1922711wrn.92.2021.04.15.01.35.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 01:35:02 -0700 (PDT)
Subject: Re: [PATCH] KVM: s390: fix guarded storage control register handling
To:     Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210415080127.1061275-1-hca@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <2f67dfd0-bdd6-a998-07c9-834c2443c53f@redhat.com>
Date:   Thu, 15 Apr 2021 10:35:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210415080127.1061275-1-hca@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15.04.21 10:01, Heiko Carstens wrote:
> store_regs_fmt2() has an ordering problem: first the guarded storage
> facility is enabled on the local cpu, then preemption disabled, and
> then the STGSC (store guarded storage controls) instruction is
> executed.
> 
> If the process gets scheduled away between enabling the guarded
> storage facility and before preemption is disabled, this might lead to
> a special operation exception and therefore kernel crash as soon as
> the process is scheduled back and the STGSC instruction is executed.
> 
> Fixes: 4e0b1ab72b8a ("KVM: s390: gs support for kvm guests")
> Cc: <stable@vger.kernel.org> # 4.12
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> ---
>   arch/s390/kvm/kvm-s390.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 2f09e9d7dc95..24ad447e648c 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4307,16 +4307,16 @@ static void store_regs_fmt2(struct kvm_vcpu *vcpu)
>   	kvm_run->s.regs.bpbc = (vcpu->arch.sie_block->fpf & FPF_BPBC) == FPF_BPBC;
>   	kvm_run->s.regs.diag318 = vcpu->arch.diag318_info.val;
>   	if (MACHINE_HAS_GS) {
> +		preempt_disable();
>   		__ctl_set_bit(2, 4);
>   		if (vcpu->arch.gs_enabled)
>   			save_gs_cb(current->thread.gs_cb);
> -		preempt_disable();
>   		current->thread.gs_cb = vcpu->arch.host_gscb;
>   		restore_gs_cb(vcpu->arch.host_gscb);
> -		preempt_enable();
>   		if (!vcpu->arch.host_gscb)
>   			__ctl_clear_bit(2, 4);
>   		vcpu->arch.host_gscb = NULL;
> +		preempt_enable();
>   	}
>   	/* SIE will save etoken directly into SDNX and therefore kvm_run */
>   }
> 


LGTM

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

