Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEEA6D594A
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 09:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbjDDHRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 03:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbjDDHRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 03:17:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31D21FE2
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 00:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680592629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NRYJdvmu2YT9+EZW2Y9gyrF6TzJ/lvpdC+QFmt09whw=;
        b=aSjMomFDk+E9OePG4mHFoeD4THklGUedoG/mhLiVTUabxU5dVc/TYu1lFY2l5RpBAvjR3g
        BYJOM41efIPChHHisa515LsKh21RIurtWzTwwF9wA+Mwo7fByF0iuLFpRvc1Zm97YtQLUI
        2XNtWNnu+WTCxpo5jfwnxbw56vEyeH8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-sqERC9-lOCacUT7D5Soj4Q-1; Tue, 04 Apr 2023 03:17:08 -0400
X-MC-Unique: sqERC9-lOCacUT7D5Soj4Q-1
Received: by mail-qv1-f71.google.com with SMTP id a15-20020a0562140c2f00b005ad28a23cffso14008960qvd.6
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 00:17:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680592628;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NRYJdvmu2YT9+EZW2Y9gyrF6TzJ/lvpdC+QFmt09whw=;
        b=10bZCIAjrdPN/7FFNzOcp6yBzGm6mgBG6FSlFq2ij4hFc3OUbXs41Wynsx7BZzWp6W
         vZVjQRKMA1I8Pnc/JqFjQG6N8FYGV598ROb0KHqB42TYpgUej5jCl/06gsCd0Pr+qVWF
         3Vhfg9L/+BLTGLdJyKH4NeuKDotOohIC1/QebOSZtV2fSWHeCsosJKo499uZwYVk97xw
         Dy7WNRgV6jnj/zAut/OabSW9TwSPhAWEL2jaywo5IHSnoGE4wNhEFwOQ8ELjpV6Wd/kW
         icRhSyZJq4dOgKMmn7lZJau145cvbK+rW0sIlgMpEJ4QfaQEBM98gKaS/H8EeIU7oW2i
         OSsA==
X-Gm-Message-State: AAQBX9c5FedmJOOb/4LcSnaoqT1Ca73+6ws6Rw2WSrFOhYx+Qo+mMn1I
        ra4Qo4R3w5E+HBWA+ITlEf2571djMZ0T1xZ5VoEbgJsb/G/36NN9YBkQV43vAewBpm5U4XtvmTw
        +jL02RpszhS7b
X-Received: by 2002:a05:6214:27e5:b0:5df:44f2:e97d with SMTP id jt5-20020a05621427e500b005df44f2e97dmr33283680qvb.19.1680592628185;
        Tue, 04 Apr 2023 00:17:08 -0700 (PDT)
X-Google-Smtp-Source: AKy350b6/Qv/o3wVhUyDFX4zCkfQ4F1t3P/9CUFpq6rARbRXin+E+2DWPBrOHxMRu4dS2R5/r6Cm9g==
X-Received: by 2002:a05:6214:27e5:b0:5df:44f2:e97d with SMTP id jt5-20020a05621427e500b005df44f2e97dmr33283667qvb.19.1680592627968;
        Tue, 04 Apr 2023 00:17:07 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-178-74.web.vodafone.de. [109.43.178.74])
        by smtp.gmail.com with ESMTPSA id k5-20020a0cebc5000000b005dd8b9345d3sm3160219qvq.107.2023.04.04.00.17.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 00:17:06 -0700 (PDT)
Message-ID: <de9407df-e3cf-8545-53fa-df7d671b4ea8@redhat.com>
Date:   Tue, 4 Apr 2023 09:17:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230327124520.2707537-1-npiggin@gmail.com>
 <20230327124520.2707537-9-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests v3 08/13] powerpc/spapr_vpa: Add basic VPA tests
In-Reply-To: <20230327124520.2707537-9-npiggin@gmail.com>
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
> The VPA is an optional memory structure shared between the hypervisor
> and operating system, defined by PAPR. This test defines the structure
> and adds registration, deregistration, and a few simple sanity tests.
> 
> [Thanks to Thomas Huth for suggesting many of the test cases.]
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
...
> diff --git a/powerpc/Makefile.ppc64 b/powerpc/Makefile.ppc64
> index ea68447..b0ed2b1 100644
> --- a/powerpc/Makefile.ppc64
> +++ b/powerpc/Makefile.ppc64
> @@ -19,7 +19,7 @@ reloc.o  = $(TEST_DIR)/reloc64.o
>   OBJDIRS += lib/ppc64
>   
>   # ppc64 specific tests
> -tests =
> +tests = $(TEST_DIR)/spapr_vpa.elf
>   
>   include $(SRCDIR)/$(TEST_DIR)/Makefile.common

That reminds me: We added all other tests to Makefile.common ... without 
ever checking them on 32-bit. Since we removed the early 32-bit code long 
ago already (see commit 2a814baab80af990eaf), it just might not make sense 
anymore to keep the separation for 64-bit and 32-bit Makefiles around here 
anymore --> could be a future cleanup to merge the Makefiles in the powerpc 
folder.

Anyway, that's not a problem of your patch here which looks fine, so:

Reviewed-by: Thomas Huth <thuth@redhat.com>

