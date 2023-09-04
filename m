Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C886C7915C2
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 12:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244069AbjIDKiy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 06:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbjIDKix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 06:38:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0605E19B
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 03:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693823881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kB/mKl04D1nauBtQD42CnfhXSKfamjz9K6ZUolRckUw=;
        b=V1PvnFiqpS4veVfLWoLiKlQ4RqdJcaDy8tFY37HcTJ4eG9wrsG0MEwZGRozI8p8ZCX5PZc
        H0DhW6Yhooriaz0Hr3tdzTjsAyNC9LsWcFcUR5l4qzLgX64QsD8HondXqFhwf49YqiG+82
        lkOd+Ji1EPcH6HIMZnq5KSrhOJl3DGI=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-eyeT4WRdPh6f_idc2sv53A-1; Mon, 04 Sep 2023 06:37:59 -0400
X-MC-Unique: eyeT4WRdPh6f_idc2sv53A-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-50098600fd7so1407751e87.1
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 03:37:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693823878; x=1694428678;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kB/mKl04D1nauBtQD42CnfhXSKfamjz9K6ZUolRckUw=;
        b=Dt9CBiLiOMf3n0hQ2YKKrivHDO5UjNZ7fD1mNoQ5FrKroKYLZHfnrgIvpco+zrMAGe
         dvvbazttqPPi7ij+N3P2bzoNH3hfABS6HpEEXX+v3pv+Vt//2JaszRcpVx/0KiEIDOvg
         0ofjkTaDg3cXrlyIfrTjZZpuCzO1GS4TayzeEXssPTurwm8jvZTmXcc1b9sNq51q33Ve
         SZzAhzLWtESeobUQ2nctXE8fO8ktLKLxcw7noIW0KdnkKvHclqaANIJxefczECaTQEpa
         AdP/ZOs/q7kTuE3GD6sM1MSDNK0osCaLqjCgu+ktdbRWWJVbQYPRG/XGZOOP4txA32oO
         51PA==
X-Gm-Message-State: AOJu0Yz3a4z/Up1qmVbQOd/oIRibq8advTc9bFGLlT5IDjs1ypLe1iDV
        yVXNmb0fZ0wrV7jN4M0h1couqCCYGpvCq8coFX4HaJ0gZIuehXFE5ifakjmc8dzsXiJTx1GNQ8f
        MukHwFeYcuAH5
X-Received: by 2002:a05:6512:401e:b0:500:b7dc:6c90 with SMTP id br30-20020a056512401e00b00500b7dc6c90mr8035075lfb.36.1693823878406;
        Mon, 04 Sep 2023 03:37:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZy+TKH5uraUkUcIKJ3GTBj7PqNOLTlrizw3fYS9+pkb9g/V6szA42tCREnPG0KkrnJtrHfQ==
X-Received: by 2002:a05:6512:401e:b0:500:b7dc:6c90 with SMTP id br30-20020a056512401e00b00500b7dc6c90mr8035061lfb.36.1693823878121;
        Mon, 04 Sep 2023 03:37:58 -0700 (PDT)
Received: from [10.33.192.199] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id 17-20020a05600c249100b003fbc30825fbsm13500437wms.39.2023.09.04.03.37.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Sep 2023 03:37:57 -0700 (PDT)
Message-ID: <e1fa6315-5de1-e843-3022-7f3023b1e189@redhat.com>
Date:   Mon, 4 Sep 2023 12:37:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [kvm-unit-tests PATCH v6 6/8] s390x: add test source dir to
 include paths
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230904082318.1465055-1-nrb@linux.ibm.com>
 <20230904082318.1465055-7-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230904082318.1465055-7-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/09/2023 10.22, Nico Boehr wrote:
> Sometimes, it is useful to share some defines between a snippet and a
> test. By adding the source directory to include paths, header files can
> be placed in the snippet directory and included from the test (or vice
> versa).
> 
> This is a prerequisite for "s390x: add a test for SIE without MSO/MSL".
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 706be7920406..9d5c08339d16 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -67,7 +67,7 @@ test_cases: $(tests)
>   test_cases_binary: $(tests_binary)
>   test_cases_pv: $(tests_pv_binary)
>   
> -INCLUDE_PATHS = $(SRCDIR)/lib $(SRCDIR)/lib/s390x
> +INCLUDE_PATHS = $(SRCDIR)/lib $(SRCDIR)/lib/s390x $(SRCDIR)/s390x
>   # Include generated header files (e.g. in case of out-of-source builds)
>   INCLUDE_PATHS += lib
>   CPPFLAGS = $(addprefix -I,$(INCLUDE_PATHS))

Reviewed-by: Thomas Huth <thuth@redhat.com>

