Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B351562130
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 19:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbiF3R0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 13:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiF3R0D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 13:26:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6FF793E5F7
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 10:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656609961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3T5aBD9PUbE+5Fu1Vz+qh55CgD24J2SDZXI2Y4tmhUQ=;
        b=OI+E57//AnVDrHIuchkVaVN+XtC/S7E5KjX5Avxy3ZioXqNXmc8llLZx/i8ggXBg+7e6H8
        WCubORF+DA7syPMpV2xxrXUBfWFBHGZNvLS26tBVZHuwoJoAjbh8lPxsDMJZiRELFiJgbq
        nRrMya/7BCzUfwSW+ozBGdBbeFPNdYQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-Md95y3a2P765WNbDfO1aLQ-1; Thu, 30 Jun 2022 13:26:00 -0400
X-MC-Unique: Md95y3a2P765WNbDfO1aLQ-1
Received: by mail-wm1-f70.google.com with SMTP id k16-20020a7bc310000000b0038e6cf00439so1808236wmj.0
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 10:25:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=3T5aBD9PUbE+5Fu1Vz+qh55CgD24J2SDZXI2Y4tmhUQ=;
        b=nilX0dfnGW0YsCLzU4lI2FeAiLfPtNHbZziA8IqFIuy8lQ+hXBl9jiL8jNMwcnnkJh
         cevXGr7maCcnmShsjDh4C0Q7z0Hpm2JnUA2EMsQVqECkGuPHzv4htwi7ix9NvzYz083S
         /+3b2DM3zCVDdN393QpoGn3HRkDmIRKYIwn7MvoJQAgDYYY+cpmDHKGQZNNI45fh21jp
         EQYQuTg14ARKnSxLMC64gX/TRJAm1JQMf45e6C7fv5LbBdPhcU1zUNtBhy1aD1YuPGYD
         iKt0x4W9CoYxAy3lbLkhJZV0n5717R6Eysqo0MBRgpYPk7uwnputxXZVzq0Cm+ozHWrM
         Hlyg==
X-Gm-Message-State: AJIora9CKyqwf/ut1Yy0yvfdoRWCVMpGrJnrXkOlOhmdf82TfwHq9dta
        XoazeUrDEUCuJy6XUHE07ySj9HAHkzEpedqlnEw/KT6mQip2vl5waZJBUaY4E4Lx10cdF4FFBtN
        +SUb6yKY5rQny
X-Received: by 2002:adf:f6c5:0:b0:21b:a6b1:ac6f with SMTP id y5-20020adff6c5000000b0021ba6b1ac6fmr9970088wrp.595.1656609958880;
        Thu, 30 Jun 2022 10:25:58 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uvPVyKkwk9O81CQQqdU0A8ODbmBKkCB7g1UXHn87z4YkhWA6TO8MZBj2BSVIwRNhDuqgUw9g==
X-Received: by 2002:adf:f6c5:0:b0:21b:a6b1:ac6f with SMTP id y5-20020adff6c5000000b0021ba6b1ac6fmr9970061wrp.595.1656609958626;
        Thu, 30 Jun 2022 10:25:58 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-179-66.web.vodafone.de. [109.43.179.66])
        by smtp.gmail.com with ESMTPSA id f190-20020a1c38c7000000b0039c5328ad92sm3239958wma.41.2022.06.30.10.25.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 10:25:58 -0700 (PDT)
Message-ID: <069be6f0-2f3a-3fea-3eca-d42f99e98220@redhat.com>
Date:   Thu, 30 Jun 2022 19:25:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220630113059.229221-1-nrb@linux.ibm.com>
 <20220630113059.229221-4-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v1 3/3] s390x: add pgm spec interrupt loop
 test
In-Reply-To: <20220630113059.229221-4-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/06/2022 13.30, Nico Boehr wrote:
> An invalid PSW causes a program interrupt. When an invalid PSW is
> introduced in the pgm_new_psw, an interrupt loop occurs as soon as a
> program interrupt is caused.
> 
> QEMU should detect that and panick the guest, hence add a test for it.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
....
> +int main(void)
> +{
> +	report_prefix_push("pgmint-loop");
> +
> +	lowcore.pgm_new_psw.addr = (uint64_t) pgm_int_handler;
> +	/* bit 12 set is invalid */
> +	lowcore.pgm_new_psw.mask = extract_psw_mask() | BIT(63 - 12);

Basically patch looks fine to me ... just an idea for an extension (but that 
could also be done later):

Looking at the is_valid_psw() function in the Linux kernel sources, there 
are a couple of additional condition that could cause a PGM interrupt loop 
... you could maybe check them here, too, e.g. by adding a "extra_params = 
-append '...'" in the unittests.cfg file to select the indiviual tests via 
argv[] ?

  Thomas

