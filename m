Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54AB16D59BE
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 09:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbjDDHfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 03:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjDDHe7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 03:34:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5CA123
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 00:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680593651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=99tQM16AOIPSiD36e9lC8KgNlMe8A/CLkwAQnzAPAlM=;
        b=INgABNkVMiFdVbA0UHfs23ESG1lsi4p6Msk/7RLzHX3FNNx1ry4MJqnC6FRliLiO5LNdGl
        xCMn5VqDJT5Q87SaMlhaQdhL1ZK2p11VMKKghsdACoKQReRu4OzKslQwiQ+5BHhE76PsZv
        MrucjPszh3PYieZlqtpp/9p7n6FOei4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-19brWEYaMLSo3K38Snrfbw-1; Tue, 04 Apr 2023 03:34:10 -0400
X-MC-Unique: 19brWEYaMLSo3K38Snrfbw-1
Received: by mail-qt1-f197.google.com with SMTP id r22-20020ac85c96000000b003e638022bc9so9573984qta.5
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 00:34:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680593650;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=99tQM16AOIPSiD36e9lC8KgNlMe8A/CLkwAQnzAPAlM=;
        b=TiQ+5aKC9gRzKSzKE9XrQzi4/OTriRonMNbIv6+ozqCl7tzbl3gsh1ptHBU9+u0CTc
         JMwuPyYPn0avfVhZBCtLZu21F1QRfzifEoHoXo0gF5uPPRhPXV/npt+rNoNJYu8I3Xcf
         QuUTBds+fDqpe5xL0jZ4ngaTl5t4EVnvQre4s7fqiDoUANUgTraTdOJpbHkPyek1wq0o
         4Ed3dMaZjQZASZr3KYqc3bPk87lx9MFDgzUJyDixfyGuysyYVgdvKkAwqcqCl7v8UQmB
         cyixMOc2APy+9wXMYhCOzUVDO9WyMEqmR+WUiQeUFqaUD/hw2kmCHntxZCFnm6VYJbAs
         G5tg==
X-Gm-Message-State: AAQBX9eNS6KCAJC1aG6+TTtO2ZBTg2Nekpo5V32qw0/A8N9mvOZiFKuu
        0x3hOeUsJwt9Zc3Fp6rEMWTB/rD068FdfGxM/nr2mZyX1ZjCpCYPTxTd5s22MyqSGDZ1a/+yqSc
        9mJUMYohW2H4Rq53IPrb1UeI=
X-Received: by 2002:ac8:5bd1:0:b0:3bf:b5fe:372d with SMTP id b17-20020ac85bd1000000b003bfb5fe372dmr1675114qtb.61.1680593650214;
        Tue, 04 Apr 2023 00:34:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350Yn6pC2+LOXbHC+brsOhPYWbUELBitKuSNkTaw8rn7U2Tsgh0u4bgya1L8Kaug4snYGGiJM5g==
X-Received: by 2002:ac8:5bd1:0:b0:3bf:b5fe:372d with SMTP id b17-20020ac85bd1000000b003bfb5fe372dmr1675096qtb.61.1680593649980;
        Tue, 04 Apr 2023 00:34:09 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-178-74.web.vodafone.de. [109.43.178.74])
        by smtp.gmail.com with ESMTPSA id m124-20020a375882000000b0073b8745fd39sm3385199qkb.110.2023.04.04.00.34.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 00:34:09 -0700 (PDT)
Message-ID: <773ea477-2702-0511-eaca-2a110c5bf13d@redhat.com>
Date:   Tue, 4 Apr 2023 09:34:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests v3 11/13] powerpc: Discover runtime load address
 dynamically
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230327124520.2707537-1-npiggin@gmail.com>
 <20230327124520.2707537-12-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230327124520.2707537-12-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/03/2023 14.45, Nicholas Piggin wrote:
> The next change will load the kernels at different addresses depending
> on test options, so this needs to be reverted back to dynamic
> discovery.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   powerpc/cstart64.S | 19 ++++++++++++++-----
>   1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
> index 1bd0437..0592e03 100644
> --- a/powerpc/cstart64.S
> +++ b/powerpc/cstart64.S
> @@ -33,9 +33,14 @@ start:
>   	 * We were loaded at QEMU's kernel load address, but we're not
>   	 * allowed to link there due to how QEMU deals with linker VMAs,
>   	 * so we just linked at zero. This means the first thing to do is
> -	 * to find our stack and toc, and then do a relocate.
> +	 * to find our stack and toc, and then do a relocate. powernv and
> +	 * pseries load addreses are not the same, so find the address

With s/addreses/addresses/ :

Acked-by: Thomas Huth <thuth@redhat.com>

