Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0BD6482C0
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 14:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiLINTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 08:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLINTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 08:19:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B39271267
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 05:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670591888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/9tvB40DHzaz/Kv1fA8KRgs6/1Raa5MBrdbg9hBsYVo=;
        b=gpzjMOVHPmpyG3XHSywnd3LSSt5/AWsHNeQ/qwl+S0if6IpvPIZpG4U5Rg+8S9s9ltYnAn
        /J1DhLrtq0jy4UEqNEWnacYEhaHiK8QHeGHObZG8AaSr1iccBJoejXePxtdjrOJmDJjADx
        fp4S3NR40aN5z1+XHSjEDpJVpQKdvm4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-578-aD5J9Lc1PFKM5SBd8Pxc0g-1; Fri, 09 Dec 2022 08:18:07 -0500
X-MC-Unique: aD5J9Lc1PFKM5SBd8Pxc0g-1
Received: by mail-wm1-f69.google.com with SMTP id v188-20020a1cacc5000000b003cf76c4ae66so3921568wme.7
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 05:18:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/9tvB40DHzaz/Kv1fA8KRgs6/1Raa5MBrdbg9hBsYVo=;
        b=pwrA6W+HU06vH5h0xjRDd+/ntXhHjtrtrYmGyvs5dNls/ZsoBx7NgSaRQiYdqJujKW
         nmdLa3zalzjSwbkI1hye7yFg4kuDWSnyAhiWgR2hgHplIXrCd3uIZlns8pXzHkzOB3ns
         Csfgf9gRmNhOj8vwgVCXIAWapgh44UedKhy1LzHN7wrJG0+24dbJhKYeiNlpiNm7xHuk
         3w33ZvdWXIqe4/LcRVy8cxZY/ykVfQwhVd3Tq2Qdm8oh2TlDxhCpXqjUSld+Smlq6/1G
         siI94FStlYwAVoNEGqSyZtoHmlJNks6G4xSoNXQNnSuccXwyhYWiAlH+9GCXcjQdrgjx
         wV9g==
X-Gm-Message-State: ANoB5pnYjuykwnKLgUnOYc4myAy8wn7dqBjxEZBj2FRWJ1c+ag54+vLf
        iaDWzgaiqeZ7AfdgWDM2ezs+caTrigBviw/YuLBlmMgOTQ8zjS78TB/H8PLA+RPCugndE5Z0+ZZ
        CT9h3jcLAG9Cp
X-Received: by 2002:a5d:6d0f:0:b0:242:132e:b7af with SMTP id e15-20020a5d6d0f000000b00242132eb7afmr6678152wrq.43.1670591886756;
        Fri, 09 Dec 2022 05:18:06 -0800 (PST)
X-Google-Smtp-Source: AA0mqf46JSS0WZRRuK1UDXKTICDpEltpDKI6a3DGwel2jJI3LUdtzSP2fGQ0leZ/g5DcSHxhdFhY+w==
X-Received: by 2002:a5d:6d0f:0:b0:242:132e:b7af with SMTP id e15-20020a5d6d0f000000b00242132eb7afmr6678126wrq.43.1670591886518;
        Fri, 09 Dec 2022 05:18:06 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-177-15.web.vodafone.de. [109.43.177.15])
        by smtp.gmail.com with ESMTPSA id bl1-20020adfe241000000b00241fea203b6sm1415758wrb.87.2022.12.09.05.18.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 05:18:05 -0800 (PST)
Message-ID: <ba74566e-a9f1-1acb-6072-deadc77d26a2@redhat.com>
Date:   Fri, 9 Dec 2022 14:18:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v1 2/4] powerpc: use migrate_once() in
 migration tests
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, lvivier@redhat.com
References: <20221130142249.3558647-1-nrb@linux.ibm.com>
 <20221130142249.3558647-3-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20221130142249.3558647-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/11/2022 15.22, Nico Boehr wrote:
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   powerpc/Makefile.common | 1 +
>   powerpc/sprs.c          | 4 ++--
>   2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
> index 12c280c15fff..8ce00340b6be 100644
> --- a/powerpc/Makefile.common
> +++ b/powerpc/Makefile.common
> @@ -36,6 +36,7 @@ cflatobjs += lib/getchar.o
>   cflatobjs += lib/alloc_phys.o
>   cflatobjs += lib/alloc.o
>   cflatobjs += lib/devicetree.o
> +cflatobjs += lib/migrate.o
>   cflatobjs += lib/powerpc/io.o
>   cflatobjs += lib/powerpc/hcall.o
>   cflatobjs += lib/powerpc/setup.o
> diff --git a/powerpc/sprs.c b/powerpc/sprs.c
> index d3c8780e8376..5cc1cd16cfda 100644
> --- a/powerpc/sprs.c
> +++ b/powerpc/sprs.c
> @@ -21,6 +21,7 @@
>    */
>   #include <libcflat.h>
>   #include <util.h>
> +#include <migrate.h>
>   #include <alloc.h>
>   #include <asm/handlers.h>
>   #include <asm/hcall.h>
> @@ -285,8 +286,7 @@ int main(int argc, char **argv)
>   	get_sprs(before);
>   
>   	if (pause) {
> -		puts("Now migrate the VM, then press a key to continue...\n");
> -		(void) getchar();
> +		migrate_once();
>   	} else {
>   		puts("Sleeping...\n");
>   		handle_exception(0x900, &dec_except_handler, &decr);

Reviewed-by: Thomas Huth <thuth@redhat.com>

