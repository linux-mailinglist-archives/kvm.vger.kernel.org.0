Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7EE663F209
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 14:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiLANvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 08:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiLANvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 08:51:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72912A47C9
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 05:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669902606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DujN8k37EyfyDhZ+fRAcfwv3P6z5CE7dhs4QeTUTuzI=;
        b=H00YGmT2siKG2TOItig/SC7/qyWLLAIaCizWXp1yH1ywe89Sp+qGjcjc5C5bdFVNvkqTga
        2fwnS8+KsOVLR/TcJKaioSt1PHh0UHFiG/nAsnjI8p42qYGUqTXjTnF+l1YCQGBNTRYk0g
        X73b7eRvAzTGD4wfwjM6xXpLmTkvGK4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-421-WEy1qO0RPySz1FQ-99WREA-1; Thu, 01 Dec 2022 08:46:39 -0500
X-MC-Unique: WEy1qO0RPySz1FQ-99WREA-1
Received: by mail-qk1-f198.google.com with SMTP id j13-20020a05620a410d00b006e08208eb31so6168176qko.3
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 05:46:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DujN8k37EyfyDhZ+fRAcfwv3P6z5CE7dhs4QeTUTuzI=;
        b=OemXzaqS2sI3IxCNlyV0uqzfEGiLWT7Y28eUgERfQY82NpC87XYiyxwG35iY5tstuV
         hwXrBxQykPMIiLgaijx2NURjfbTbhQxuPez2jRImxiZkSXleYAifXtDalpgWb1E8aMY7
         JLmJePXMQTL5dVVqdkfZdqstzDWkPYwhN0iPTSPWfXcIT4t/SDCaNooazu3yZKbEhEbk
         d1jLbJMqAd3WJ087WZ1AfteaaCMtiLWpI1fp47GyjeTqHZSGUDMNrjHNkFSqSEZmfhc5
         SBS5D8AQ9Vpws8lTdJf6pO17EdzjkBXX6wBHblGYnET3QY7Pr9HflIH4ciLFCCyUYWTS
         0ufg==
X-Gm-Message-State: ANoB5pmTXrrFngF75zeVugaaFNSask6Uyo2Fq55oX+jdvEP5sW6rHiL8
        H6MfvdAnah9D/Eyt0anv0wwGYxtbN73jOO1eRSjPr07QWvfml3WEWp8vQnE4wHHWaH1h8YgoSo/
        JaC3w/ao2EWzK
X-Received: by 2002:a05:622a:4889:b0:3a5:6854:32fe with SMTP id fc9-20020a05622a488900b003a5685432femr62069421qtb.655.1669902399306;
        Thu, 01 Dec 2022 05:46:39 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6ikP0wueASgT3+swzUIolUYGsmDxYxIcq6wc7j+UVc3aRbkNi4q5YrrxQZlCjHhya8IEpKqw==
X-Received: by 2002:a05:622a:4889:b0:3a5:6854:32fe with SMTP id fc9-20020a05622a488900b003a5685432femr62069405qtb.655.1669902399082;
        Thu, 01 Dec 2022 05:46:39 -0800 (PST)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id j6-20020a05620a288600b006fc7302cf89sm3553199qkp.28.2022.12.01.05.46.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 05:46:38 -0800 (PST)
Message-ID: <0cbe20fd-fe9c-cb5b-71ff-002724c3ebdb@redhat.com>
Date:   Thu, 1 Dec 2022 14:46:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v3 09/27] svm: add simple nested shutdown
 test.
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
 <20221122161152.293072-10-mlevitsk@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <20221122161152.293072-10-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8
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



Am 22/11/2022 um 17:11 schrieb Maxim Levitsky:
> Add a simple test that a shutdown in L2 is intercepted
> correctly by the L1.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  x86/svm_tests.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index a7641fb8..7a67132a 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -11,6 +11,7 @@
>  #include "apic.h"
>  #include "delay.h"
>  #include "x86/usermode.h"
> +#include "vmalloc.h"
>  
>  #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
>  
> @@ -3238,6 +3239,21 @@ static void svm_exception_test(void)
>  	}
>  }
>  
> +static void shutdown_intercept_test_guest(struct svm_test *test)
> +{
> +	asm volatile ("ud2");
> +	report_fail("should not reach here\n");
> +
Remove empty line here
> +}Add empty line here
> +static void svm_shutdown_intercept_test(void)
> +{
> +	test_set_guest(shutdown_intercept_test_guest);
> +	vmcb->save.idtr.base = (u64)alloc_vpage();
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_SHUTDOWN);
> +	svm_vmrun();
> +	report(vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown test passed");
> +}
> +

