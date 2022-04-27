Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB17511FA3
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243256AbiD0Q05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 12:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243215AbiD0Q0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 12:26:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7D1B228F22
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 09:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651076370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cpdTKSdO+rieFpHnkUAZpM/6Dw8rA4JkcSTNkjZ8rq0=;
        b=dw/IKhS1vbgDPbdAkAXZ0s1xwxbO/ohjo79xY/H1Lme3kFBbm/cMVbFGlKaPfvdgxRCfOY
        6JUdFHZQE7MCI20rQ1u/eWfIpbQx6UWg4mX8NYDae3MZNBWYG7PzR/Gfkx8NrQXYQ70lCc
        iL3gvvAX666MzwFqRugLcVX1ot8bqrY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-hMyzZ57zOTqnfDevvlW7JQ-1; Wed, 27 Apr 2022 12:19:29 -0400
X-MC-Unique: hMyzZ57zOTqnfDevvlW7JQ-1
Received: by mail-ed1-f72.google.com with SMTP id dn26-20020a05640222fa00b00425e4b8efa9so1277472edb.1
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 09:19:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cpdTKSdO+rieFpHnkUAZpM/6Dw8rA4JkcSTNkjZ8rq0=;
        b=20VdrIyxDXagGKkxK9W5y0V/VMmzWLhs4/BKnJrGnh7I4u9UkdeBPJ4qcZv30En/O2
         5PZDOCLio7AlXaYC5X1EAzrxpNFW53egRQ/kSLuZuMbdr7BZBsK0++9GYvXob6XsNSEI
         VItqaDc3r755RssSNIhN8LyZKBq2NxZrFxVREabz2yq0NyWmxVZKTaDh1cUiA3PpaxCL
         xXvbVVAeDoj/R84iy21izZkshGH6wUbN4Je7SkEJHTgqmnh9yBsb4vvtuptvqdTovOpm
         E0DMHgYgJYe8R3LIsQ1FggBvBidZp/s/7QGa1cj+xxviZQZyQ3xzdwxnBAPQyFSS6uyw
         Aagw==
X-Gm-Message-State: AOAM532bUIpOXi3T6PlwwB1bv11DDUd9DkD7a2CH+zEn2nDIen5CoOqm
        BVyPkIeddOX3n6WHmQ4vUOFwOH05UoPec/1aSzbA0aView9BVmS7pP336MQH3HnMBmPYZGSbhU0
        0iQ7++RrvbnK3
X-Received: by 2002:a05:6402:4004:b0:426:1a0a:a2b8 with SMTP id d4-20020a056402400400b004261a0aa2b8mr2943531eda.241.1651076367941;
        Wed, 27 Apr 2022 09:19:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRi274/0pJFnefUE34/+I0M2mwYpfNL1VVyniwojXwdGQHhToi5cq0Vivpg5gmlGbu04FBdw==
X-Received: by 2002:a05:6402:4004:b0:426:1a0a:a2b8 with SMTP id d4-20020a056402400400b004261a0aa2b8mr2943517eda.241.1651076367773;
        Wed, 27 Apr 2022 09:19:27 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id t27-20020a1709063e5b00b006f3a94f5194sm3347586eji.77.2022.04.27.09.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:19:27 -0700 (PDT)
Message-ID: <032e22bd-4faa-7a0c-da78-8bf7ee3df31f@redhat.com>
Date:   Wed, 27 Apr 2022 18:19:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH MANUALSEL 5.15 2/7] KVM: selftests: Silence compiler
 warning in the kvm_page_table_test
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, shuah@kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20220427155431.19458-1-sashal@kernel.org>
 <20220427155431.19458-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427155431.19458-2-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/22 17:54, Sasha Levin wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> [ Upstream commit 266a19a0bc4fbfab4d981a47640ca98972a01865 ]
> 
> When compiling kvm_page_table_test.c, I get this compiler warning
> with gcc 11.2:
> 
> kvm_page_table_test.c: In function 'pre_init_before_test':
> ../../../../tools/include/linux/kernel.h:44:24: warning: comparison of
>   distinct pointer types lacks a cast
>     44 |         (void) (&_max1 == &_max2);              \
>        |                        ^~
> kvm_page_table_test.c:281:21: note: in expansion of macro 'max'
>    281 |         alignment = max(0x100000, alignment);
>        |                     ^~~
> 
> Fix it by adjusting the type of the absolute value.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Message-Id: <20220414103031.565037-1-thuth@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   tools/testing/selftests/kvm/kvm_page_table_test.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
> index 36407cb0ec85..f1ddfe4c4a03 100644
> --- a/tools/testing/selftests/kvm/kvm_page_table_test.c
> +++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
> @@ -278,7 +278,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
>   	else
>   		guest_test_phys_mem = p->phys_offset;
>   #ifdef __s390x__
> -	alignment = max(0x100000, alignment);
> +	alignment = max(0x100000UL, alignment);
>   #endif
>   	guest_test_phys_mem &= ~(alignment - 1);
>   

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

