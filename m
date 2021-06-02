Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CEF398589
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 11:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhFBJtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 05:49:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44678 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229878AbhFBJs7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 05:48:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622627236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ByEAV4YrwKVnhlwghStCjIo8Ke5CCjeHAPkaCAqWSBs=;
        b=GxW8i4xj1LR1yPW8mYmf+PpGBzIqt/NbinQpIZZCQdl+VzCJjXlODgl84tc7dm/xEl3dGA
        lz6Akb7vOEZO12a7iLa2uuHG2nebH9ByfdK/h5XqIHL99ioXxdJVmsR7suCOux01sZ8NR3
        /dzK4TChY81L9FavQVgzpVDAh51uWNs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-BvhjAx2kMsC-AJgEITcEBQ-1; Wed, 02 Jun 2021 05:47:14 -0400
X-MC-Unique: BvhjAx2kMsC-AJgEITcEBQ-1
Received: by mail-wr1-f71.google.com with SMTP id u5-20020adf9e050000b029010df603f280so764340wre.18
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 02:47:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ByEAV4YrwKVnhlwghStCjIo8Ke5CCjeHAPkaCAqWSBs=;
        b=Hm4hNVQWBwxtQ86cyLt57WmlPsgsG9euEAsjpdzEa3B8tJ3+7HFKsR43kf8a4reqBO
         xkdLOqFaacLN65cg6QCwRQH12FMdq6lKYJZfeMcYlvR91iXpQfoMJ1WBQooLyIbe6nBM
         SVx6sgZ/cDGPQ/ux/bMo98OricPd+fcaBBY50Jb8pPMa0vfCrO9WRZxw67zfsc338Ymn
         vIEeOqQ/vGK7ID6f/o2/QI06lWPMSkrTn2qsTuIzQVwjcBY+VCrOcBfmlzl+XfFZcNuo
         IVzaJiEcnqlqaoivzQfJrcd0T/6Vkd0M/+zf55NU5QsU8hX3UwlAYuS6BwsxoPDoDhrl
         cU2g==
X-Gm-Message-State: AOAM531y7KAVoaydCJQ1G16+86l+jn7v54+D8jQGt6M0TCq+3QXUvhnJ
        EKOVnyXYfmcG7HFBSSwFdl3NCxRS86jLEUOadZp42j9qY3m9eBbau7qyXry6jpBpcov6/h+VXEl
        gwpc9Kqf9JVpq
X-Received: by 2002:a05:6000:1089:: with SMTP id y9mr9606084wrw.412.1622627233746;
        Wed, 02 Jun 2021 02:47:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyUJSokevpnMmcmivUKSr723WrPQIhCwIs1GeO35ViokWlEl5+KpLP1m0RDaONZ1NPYTW+3g==
X-Received: by 2002:a05:6000:1089:: with SMTP id y9mr9606067wrw.412.1622627233594;
        Wed, 02 Jun 2021 02:47:13 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6b6d.dip0.t-ipconnect.de. [91.12.107.109])
        by smtp.gmail.com with ESMTPSA id d3sm5920103wrs.41.2021.06.02.02.47.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 02:47:13 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] s390x: sie: Only overwrite r3 if it isn't
 needed anymore
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, cohuck@redhat.com
References: <20210602094352.11647-1-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <539ca61d-eaf8-f47f-c7ce-d5a520273517@redhat.com>
Date:   Wed, 2 Jun 2021 11:47:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210602094352.11647-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.06.21 11:43, Janosch Frank wrote:
> The lmg overwrites r3 which we later use to reference the fprs and fpc.
> Let's do the lmg at the end where overwriting is fine.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
> 
> Finding this took me longer than I'd like to admit. :)
> 
> ---
>   s390x/cpu.S | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/cpu.S b/s390x/cpu.S
> index e2ad56c8..82b5e25d 100644
> --- a/s390x/cpu.S
> +++ b/s390x/cpu.S
> @@ -81,11 +81,11 @@ sie64a:
>   	stg	%r3,__SF_SIE_SAVEAREA(%r15)	# save guest register save area
>   
>   	# Load guest's gprs, fprs and fpc
> -	lmg	%r0,%r13,SIE_SAVEAREA_GUEST_GRS(%r3)
>   	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>   	ld	\i, \i * 8 + SIE_SAVEAREA_GUEST_FPRS(%r3)
>   	.endr
>   	lfpc	SIE_SAVEAREA_GUEST_FPC(%r3)
> +	lmg	%r0,%r13,SIE_SAVEAREA_GUEST_GRS(%r3)
>   
>   	# Move scb ptr into r14 for the sie instruction
>   	lg	%r14,__SF_SIE_CONTROL(%r15)
> 

Oh, that's nasty

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

