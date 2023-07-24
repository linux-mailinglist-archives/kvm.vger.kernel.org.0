Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAF875ED86
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 10:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbjGXI2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 04:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbjGXI1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 04:27:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270E319AA
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 01:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690187182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pqVPx2T65FEY/gXsUV2SoZ8UzlYeQwEk4kcTv3TVfeE=;
        b=UAywrS/zwYLtKVaEb85V6HLbSZ985id7e2+i/kbqebmvEdWzIsDMbL/j5oMwZKNX3Ln5kK
        aVCRHgwMF1mNINoQ/xIn5gUAyXCPkAE7IU2dBW5SmfVHJ11hNiVXx1Jmn/PPIFMf/CL+GZ
        XtccG+pKI4FbawvKABsGC3F1QfA3CHI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-RUVzeip0NGG1eEcEXi1zTQ-1; Mon, 24 Jul 2023 04:26:21 -0400
X-MC-Unique: RUVzeip0NGG1eEcEXi1zTQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3fd2d331e1eso6633715e9.3
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 01:26:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690187180; x=1690791980;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pqVPx2T65FEY/gXsUV2SoZ8UzlYeQwEk4kcTv3TVfeE=;
        b=C4mEsYokDof42ISvqKiAR2m63DOTKX3Jv4PrpSkjZwWBoIe7VeKx+3nJ7LF1ijepKp
         u6SJA6H8LcuHSVHNu9wx2ouTaGhcLQLzONvv/cj/4T4HXiIr+OMHKkbelvAAh8cK7EGw
         O5+WjcmwY9/cU/oHFuvjvQN8d0lpps2ongqFJ8OApnsIm0mUpiOoA7yC4idPyZaJuLBa
         jyzvPNJ4sZHl2gTi+HpV900wvlRgBCnjt0llGkkyhsiRBZogf9EWt9C9iDc6STbJw07h
         fSYLvgUO2vfIBPXdpPCHTMfbIc6Io4PJJrH6IeRROvhB1GHZEgkIz5Xt+09H0T2PL6AS
         n+Ww==
X-Gm-Message-State: ABy/qLYeo1yoD4WSdnfoM3eniIzq/BWkD3cHliGgQT19BKQ9tLHnxGFL
        zqaU2qTohbNf8f7L9clBCIhiLuuGuPzTRsTlxMt8D9tnPpopfF8X/PkxL75UKCRyb+4tOUh7qFN
        udWCFxCYgc46q
X-Received: by 2002:a7b:cb17:0:b0:3fc:3f31:422f with SMTP id u23-20020a7bcb17000000b003fc3f31422fmr6181994wmj.3.1690187180428;
        Mon, 24 Jul 2023 01:26:20 -0700 (PDT)
X-Google-Smtp-Source: APBJJlF4C3chb1ZF5Gy7gkNTBsd4XDa1BBS6NdelEQsZRTFBdvkPciuK9ApSjTXleiRojJjbF4lAyw==
X-Received: by 2002:a7b:cb17:0:b0:3fc:3f31:422f with SMTP id u23-20020a7bcb17000000b003fc3f31422fmr6181967wmj.3.1690187180039;
        Mon, 24 Jul 2023 01:26:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f45:d000:62f2:4df0:704a:e859? (p200300d82f45d00062f24df0704ae859.dip0.t-ipconnect.de. [2003:d8:2f45:d000:62f2:4df0:704a:e859])
        by smtp.gmail.com with ESMTPSA id j5-20020adff005000000b0031764e85b91sm363145wro.68.2023.07.24.01.26.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 01:26:19 -0700 (PDT)
Message-ID: <b9ecc108-aa14-d11c-1314-cbf21a2548f1@redhat.com>
Date:   Mon, 24 Jul 2023 10:26:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 2/6] KVM: s390: interrupt: Fix single-stepping into
 program interrupt handlers
Content-Language: en-US
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>
References: <20230721120046.2262291-1-iii@linux.ibm.com>
 <20230721120046.2262291-3-iii@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230721120046.2262291-3-iii@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.07.23 13:57, Ilya Leoshkevich wrote:
> Currently, after single-stepping an instruction that generates a
> specification exception, GDB ends up on the instruction immediately
> following it.
> 
> The reason is that vcpu_post_run() injects the interrupt and sets
> KVM_GUESTDBG_EXIT_PENDING, causing a KVM_SINGLESTEP exit. The
> interrupt is not delivered, however, therefore userspace sees the
> address of the next instruction.
> 
> Fix by letting the __vcpu_run() loop go into the next iteration,
> where vcpu_pre_run() delivers the interrupt and sets
> KVM_GUESTDBG_EXIT_PENDING.
> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>   arch/s390/kvm/intercept.c | 19 +++++++++++++++++--
>   1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 954d39adf85c..7cdd927541b0 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -226,7 +226,22 @@ static int handle_itdb(struct kvm_vcpu *vcpu)
>   	return 0;
>   }
>   
> -#define per_event(vcpu) (vcpu->arch.sie_block->iprcc & PGM_PER)
> +static bool should_handle_per_event(const struct kvm_vcpu *vcpu)
> +{
> +	if (!guestdbg_enabled(vcpu))
> +		return false;
> +	if (!(vcpu->arch.sie_block->iprcc & PGM_PER))
> +		return false;
> +	if (guestdbg_sstep_enabled(vcpu) &&
> +	    vcpu->arch.sie_block->iprcc != PGM_PER) {
> +		/*
> +		 * __vcpu_run() will exit after delivering the concurrently
> +		 * indicated condition.
> +		 */
> +		return false;
> +	}
> +	return true;
> +}
>   
>   static int handle_prog(struct kvm_vcpu *vcpu)
>   {
> @@ -242,7 +257,7 @@ static int handle_prog(struct kvm_vcpu *vcpu)
>   	if (kvm_s390_pv_cpu_is_protected(vcpu))
>   		return -EOPNOTSUPP;
>   
> -	if (guestdbg_enabled(vcpu) && per_event(vcpu)) {
> +	if (should_handle_per_event(vcpu)) {
>   		rc = kvm_s390_handle_per_event(vcpu);
>   		if (rc)
>   			return rc;

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

