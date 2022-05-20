Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D0B52EDB5
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350062AbiETOCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236471AbiETOCj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:02:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 214803FBE6
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653055357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pTykjPF0FgliSCgMjJPguB2T7Tz+TAjG7uEHiw31Dqc=;
        b=Nv6/Cjq7WxyVptmwD2bnzpLrSArqfLgLTfLzTCqI1cf4hJIw3Ct91N1go0vxDNo2AHvhIs
        kvK36jiJJtRj0DMb3mMhmNdTe6tC79Efz5/elGFyqzToAizVoWStP+OOdP5HQSXqBwvEct
        jhfLpKZkEr+E7WqADy7UTdIafFObPZY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-98TZvg1qODeabackMuZ3pQ-1; Fri, 20 May 2022 10:02:36 -0400
X-MC-Unique: 98TZvg1qODeabackMuZ3pQ-1
Received: by mail-ed1-f71.google.com with SMTP id l18-20020aa7d952000000b0042ab7be9adaso5713874eds.21
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:02:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pTykjPF0FgliSCgMjJPguB2T7Tz+TAjG7uEHiw31Dqc=;
        b=e5MZHvBCqFQ7lap4njVGwPhb0fCXT0XlWNlh0YtqdC4G3Nh61lzlHc5hm3HYnTjlkD
         Qk57xgfecTqSkX4tXGx+MO6gQV8N1loDlBORI0ZR9Kq7ZqaibjreTcOEQoH7qWlWQC4X
         quS4otk0IeRHYQlV6GVmqBwnzAZcscErPw75wvo68CP3xUW4Ut8hZ+v2JZneAWyW4+CJ
         Zk7GeGPOZm1ofZqmLtEkQTM9K8h8Nau4GYfaXrOFEcoxKv1mpUxFdUiIqthEzHeMFoTs
         9IKXHak6GAyTRxgIBhhxQaJH0kW9qr23wACHjs3ktPTwB0WEks9AIRwDEQKG/HGh+XEN
         FYBQ==
X-Gm-Message-State: AOAM531ymKBBtbNhUZ04RYlqXu8sT/PCyqJLRPHblAAh7trn/QCN1RK1
        5IpsouzYDRPiwgl6fZQjTQ2LL8Iy4daofy2ZjXwaqcOgu2jV5zt4owdcfUaB89G5px+VnZwKjlT
        HWwSTDCdyKXcR
X-Received: by 2002:a17:907:8693:b0:6f8:635a:1d32 with SMTP id qa19-20020a170907869300b006f8635a1d32mr8818955ejc.663.1653055354930;
        Fri, 20 May 2022 07:02:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRbfqxA3paGcBp1rfOs8VoZLY8BNJyhc2ENPxO0V8dfzQwPaaUDck5+XF05U0RgbVOvbJa2w==
X-Received: by 2002:a17:907:8693:b0:6f8:635a:1d32 with SMTP id qa19-20020a170907869300b006f8635a1d32mr8818940ejc.663.1653055354731;
        Fri, 20 May 2022 07:02:34 -0700 (PDT)
Received: from gator (cst2-173-79.cust.vodafone.cz. [31.30.173.79])
        by smtp.gmail.com with ESMTPSA id f8-20020a1709063f4800b006f4c82c2b12sm3248000ejj.19.2022.05.20.07.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 07:02:33 -0700 (PDT)
Date:   Fri, 20 May 2022 16:02:32 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 14/23] lib: Avoid ms_abi for calls
 related to EFI on arm64
Message-ID: <20220520140232.xn6n6pbvlmva3wwu@gator>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-15-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-15-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:55:56PM +0100, Nikos Nikoleris wrote:
> x86_64 requires that EFI calls use the ms_abi calling convention. For
> arm64 this is unnecessary.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/linux/efi.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/lib/linux/efi.h b/lib/linux/efi.h
> index e3aba1d..594eaca 100644
> --- a/lib/linux/efi.h
> +++ b/lib/linux/efi.h
> @@ -33,7 +33,11 @@ typedef u16 efi_char16_t;		/* UNICODE character */
>  typedef u64 efi_physical_addr_t;
>  typedef void *efi_handle_t;
>  
> +#ifdef __x86_64__
>  #define __efiapi __attribute__((ms_abi))
> +#else
> +#define __efiapi
> +#endif
>  
>  /*
>   * The UEFI spec and EDK2 reference implementation both define EFI_GUID as
> -- 
> 2.25.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

