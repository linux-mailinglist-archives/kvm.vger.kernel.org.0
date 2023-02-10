Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD75691950
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 08:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjBJHoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 02:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbjBJHoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 02:44:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7B83644A
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 23:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676015001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a7HohraEnnLuS7SCGV4RgDXKY3P8/2UTebn28HhlcUQ=;
        b=fVQ3E2RClk4kF0LjI/pQZSmzDGwfpB3VPgrdQZaA0pINdqYH3GLVAH7IcMsCsCg45iVShS
        cgnlFtzIIcrDuNgvLCiMTN58ZmUDq8KR3AZaQFH4V1N6kOUVS9YaiPZetnU9xT8Ak8tyn1
        wHNUkVCKNAnmLAcITxCryXrhHR+5zhc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-359-mSTdhKsUPNix9YOO7nQcCg-1; Fri, 10 Feb 2023 02:43:19 -0500
X-MC-Unique: mSTdhKsUPNix9YOO7nQcCg-1
Received: by mail-qk1-f199.google.com with SMTP id h13-20020a05620a244d00b006fb713618b8so2844633qkn.0
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 23:43:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a7HohraEnnLuS7SCGV4RgDXKY3P8/2UTebn28HhlcUQ=;
        b=NtNl/+VQIafHucKsnn7TJWC6qCrx694XuzlTnKK45piASiyv2QTWWyUSBzStQAA/Kw
         Ow0J5IsCZwS3UJqYpCL+5yAO1sEyU7ZsJ6tx/GjBqFdf6nCPgRG7H0xElNtghjbfK4ac
         BE14pNQnVEcqZbYMZwcMSYN618ad1JaBYY6+leccLQqqIa9DXff3oXB+0swhYtYQ3Nwq
         Ek6BiD7m6+3XvlfSF2opqQ3nKn2TOyG//MAeO9ZE/SNDLfGxHSK7qRD7x+jOjfEMOkkz
         fKPNlizy08YMjtZgi8Bxt0kRSosAV4jsX+aN1eAzgqj30jc+g0MzyM/fsjx1yC39r+S0
         UcRQ==
X-Gm-Message-State: AO0yUKUBTXZDNu+us+FCr5o9eziPr8p7QaU3rOAWb+/IaxkQoqECDwyT
        SlSWATiHe1L69F4DTc92DmBdl3xAvMiVaaHn49FE47Fdr/OY/B4afCa7FjpZGdVigXRjybODir2
        YPEogbQWQJ76k
X-Received: by 2002:ac8:4e8d:0:b0:3b8:6c97:e5de with SMTP id 13-20020ac84e8d000000b003b86c97e5demr24592133qtp.41.1676014999372;
        Thu, 09 Feb 2023 23:43:19 -0800 (PST)
X-Google-Smtp-Source: AK7set+caySjIQAZ74Bz7BqJMfnNlYYmnsvPLuaw6J545d9z9xW+fbcW/Ef6xisosG/7GJyZGl40yA==
X-Received: by 2002:ac8:4e8d:0:b0:3b8:6c97:e5de with SMTP id 13-20020ac84e8d000000b003b86c97e5demr24592123qtp.41.1676014999157;
        Thu, 09 Feb 2023 23:43:19 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-178-85.web.vodafone.de. [109.43.178.85])
        by smtp.gmail.com with ESMTPSA id c18-20020a05622a025200b003b85ed59fa2sm2919674qtx.50.2023.02.09.23.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 23:43:18 -0800 (PST)
Message-ID: <31bc059c-dc8c-36ee-8288-209811d9ba98@redhat.com>
Date:   Fri, 10 Feb 2023 08:43:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PULL 12/17] AVX512 support for xbzrle_encode_buffer
Content-Language: en-US
To:     Juan Quintela <quintela@redhat.com>, qemu-devel@nongnu.org,
        ling xu <ling1.xu@intel.com>
Cc:     kvm@vger.kernel.org,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        Zhou Zhao <zhou.zhao@intel.com>, Jun Jin <jun.i.jin@intel.com>
References: <20230209233426.37811-1-quintela@redhat.com>
 <20230209233426.37811-13-quintela@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230209233426.37811-13-quintela@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/02/2023 00.34, Juan Quintela wrote:
> From: ling xu <ling1.xu@intel.com>
> 
> This commit is the same with [PATCH v6 1/2], and provides avx512 support for xbzrle_encode_buffer
> function to accelerate xbzrle encoding speed.

  Hi!

Just a hint for future patches: Please don't put version information into 
the patch description itself, this "PATCH v6 1/2" will now end up in the git 
history without its context.

Information like that should go into cover letters or below the "---" marker 
only.

  Thanks,
   Thomas

