Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA35F6D1E41
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 12:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjCaKnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 06:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjCaKnS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 06:43:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327D82705
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 03:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680259349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M4gW+92HQigOLGQ3gyB/02bsGS45kmlj6oHrKNELynU=;
        b=UnUfmGZPsVB6YftzDnvHDtG2vDBV+Ry5x9WnXnaOAoNlD7qkrpqw9YyMYk+aHhmIwnAVBd
        U/XDU5cvUNZMcgF42h8mQQzC2MLAwWgYLr+thevetX9FlKmCVGLWqV0JXoRn1M/2Cge0di
        GE1F9fCAmRfdTlMuinnaWwv+qXNQHTk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-c8P98f5IPI-bQe3HwJQnXQ-1; Fri, 31 Mar 2023 06:42:28 -0400
X-MC-Unique: c8P98f5IPI-bQe3HwJQnXQ-1
Received: by mail-wm1-f70.google.com with SMTP id iv18-20020a05600c549200b003ee21220fccso10893161wmb.1
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 03:42:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680259347;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M4gW+92HQigOLGQ3gyB/02bsGS45kmlj6oHrKNELynU=;
        b=StJHHjW6/GuOkc1RHf3u7GLWPQnoG5OrQDLmgcG7HsZF6ROBhoHZQRt0D3SeS/lwIJ
         a5pcpn9o1nku+vOhxQ7T+RF+5yQy374U4Wbppd5iqarX3VEXUg3T01LaEN1CMP39WH/W
         Urs9p8CMjlMhxWOi7LgwS3nfmW2yhWlt+PXBEtxPRBu1NqIdKjj7VL9oBLQ7UOZYKA/W
         DwNY6TjYMPe8gdeopeX4doNA5zNJIuHZl2XfeiQ2F4ZQ8PYje+2ipYZfMKebNLq7PtJH
         H2Cj8JwehS+vebaRLaXMJgZ2itGI/R0o+49hIZ/bbHEsIna1pRQrl9xrNu0gIVFWmNk9
         i6mQ==
X-Gm-Message-State: AAQBX9fIT1ZPdRDLMT0gFZvMtcE22OK2slK0Wo4c5LXyvwhNxIGNev8q
        36MzePxLd/53TURYxC/SIzdMeLTtNGM3UcfUFd+a2C3QRFCfNQWowgSInM9viTUx+JjlekA+jTx
        QWv/cC4aYLC4a
X-Received: by 2002:a7b:c416:0:b0:3f0:310c:165 with SMTP id k22-20020a7bc416000000b003f0310c0165mr5963244wmi.28.1680259346949;
        Fri, 31 Mar 2023 03:42:26 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZFY/AxqiMUfp3i7cmi0DBcTEngrj8XQsQ/uWFKGzKZ8U/flsGZ88H2cSEOcMpIPnHAVhkKuw==
X-Received: by 2002:a7b:c416:0:b0:3f0:310c:165 with SMTP id k22-20020a7bc416000000b003f0310c0165mr5963231wmi.28.1680259346701;
        Fri, 31 Mar 2023 03:42:26 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-177-12.web.vodafone.de. [109.43.177.12])
        by smtp.gmail.com with ESMTPSA id o9-20020a05600c4fc900b003ef6bc71cccsm9739348wmq.27.2023.03.31.03.42.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 03:42:26 -0700 (PDT)
Message-ID: <9ca2a5e0-ae91-2f0a-44b8-50e5cd4f4d09@redhat.com>
Date:   Fri, 31 Mar 2023 12:42:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     Laurent Vivier <lvivier@redhat.com>
References: <20230327124520.2707537-1-npiggin@gmail.com>
 <20230327124520.2707537-7-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests v3 06/13] powerpc: Extract some common helpers
 and defines to headers
In-Reply-To: <20230327124520.2707537-7-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/03/2023 14.45, Nicholas Piggin wrote:
> Move some common helpers and defines to processor.h.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
> Since v2:
> - New patch
> 
>   lib/powerpc/asm/processor.h | 38 +++++++++++++++++++++++++++++++++----
>   powerpc/spapr_hcall.c       |  9 +--------
>   powerpc/sprs.c              |  9 ---------
>   3 files changed, 35 insertions(+), 21 deletions(-)
> 
> diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
> index ebfeff2..4ad6612 100644
> --- a/lib/powerpc/asm/processor.h
> +++ b/lib/powerpc/asm/processor.h
> @@ -9,13 +9,43 @@ void handle_exception(int trap, void (*func)(struct pt_regs *, void *), void *);
>   void do_handle_exception(struct pt_regs *regs);
>   #endif /* __ASSEMBLY__ */
>   
> -static inline uint64_t get_tb(void)
> +#define SPR_TB		0x10c
> +#define SPR_SPRG0	0x110
> +#define SPR_SPRG1	0x111
> +#define SPR_SPRG2	0x112
> +#define SPR_SPRG3	0x113
> +
> +static inline uint64_t mfspr(int nr)
>   {
> -	uint64_t tb;
> +	uint64_t ret;
> +
> +	asm volatile("mfspr %0,%1" : "=r"(ret) : "i"(nr) : "memory");
> +
> +	return ret;
> +}
>   
> -	asm volatile ("mfspr %[tb],268" : [tb] "=r" (tb));
> +static inline void mtspr(int nr, uint64_t val)
> +{
> +	asm volatile("mtspr %0,%1" : : "i"(nr), "r"(val) : "memory");
> +}

I'd maybe use __always_inline for the above two helper functions, since "nr" 
is used with immediate constraint in the asm part.

Did you also check whether this works with Clang ? (IIRC I saw issues with 
that on other occasions in the past)

Anyway:
Reviewed-by: Thomas Huth <thuth@redhat.com>

