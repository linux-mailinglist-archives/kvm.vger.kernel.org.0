Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB13D647EF0
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 09:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiLIIIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 03:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiLIIH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 03:07:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAD55B867
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 00:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670573217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4sxH0I5QtK63vsm8GUs2GfZ9XLUpU5JHWlHlEFhZnIc=;
        b=C505qvlpQUdpJPfIraOKpwAcCM+S/YOlgoDaFdtUyGxTn4lX0UPvlHX6nMKCwiTnpb/eBW
        B/1MRk3Wn36pil/tIEUg2kAZ9h7Jml7Qsdk9YIoBqryfPSzgjmxiO4tXHbEdH19Ob+Ll03
        +divFSPZYFKuuWI598kEuV09FBuyAgU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-98-WtSVgYOOMFSgS5np3YBpXA-1; Fri, 09 Dec 2022 03:06:55 -0500
X-MC-Unique: WtSVgYOOMFSgS5np3YBpXA-1
Received: by mail-ej1-f70.google.com with SMTP id sb2-20020a1709076d8200b007bdea97e799so2651258ejc.22
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 00:06:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4sxH0I5QtK63vsm8GUs2GfZ9XLUpU5JHWlHlEFhZnIc=;
        b=75mkUguCUSwAchX7vOvVQfZ5aIPwufo+IdwScw/N80BqAF6mi08DYrSVfhEz55wrq2
         I4cWPea72lHZnBpgLC7cUjPSPa+vS5PDr068dk/rIc3CuOy6bp6VdWW3RCJpP2zsTe54
         u+REPDAj41YxqOOsvO6EMM7Szn7hWH7JI56sQBEQXs6/0Ikte1Ib0+thb/8gellz7Tvo
         POPLHzCWIGRIibscdYEgypVVAIAUjKhYRf0U8UTrTBm1uMrGLL63r4P3L6mJ/Er/sb3c
         CEQjfmLe1AZxmDoJ936ZqSgJ1lkL5PWNovIIPDcltVYIlQddslxa8UWbvyg8h+o/Bq1r
         z+fg==
X-Gm-Message-State: ANoB5pmVe40nWT6MKaCLKM3eOGT98ISX5PsrLX5wp1+89a39L085DftQ
        Vy2K3+8uPxcfsPqcLULd+5eD9ZNArHtKVa8jo8yIJFE9PsTIDhuOJwsTT9gaq9Vxe2bK9iCzHya
        cJVTdtcZXC+r3
X-Received: by 2002:a05:6402:294b:b0:461:ca30:653 with SMTP id ed11-20020a056402294b00b00461ca300653mr5783803edb.31.1670573214728;
        Fri, 09 Dec 2022 00:06:54 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4IWiovX3D2RO3PKxMaf3X1KDdCX7WBEwluagDv4bB4lLaMjPqF5xAXvwkyMTS9DjXMSz6MeA==
X-Received: by 2002:a05:6402:294b:b0:461:ca30:653 with SMTP id ed11-20020a056402294b00b00461ca300653mr5783786edb.31.1670573214464;
        Fri, 09 Dec 2022 00:06:54 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id k23-20020a05640212d700b00462bd673453sm332365edx.39.2022.12.09.00.06.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 00:06:53 -0800 (PST)
Message-ID: <6e316b6a-7a9d-8e53-2c5f-8b71892ec7fd@redhat.com>
Date:   Fri, 9 Dec 2022 09:06:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] KVM: X86: set EXITING_GUEST_MODE as soon as vCPU exits
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Jon Kohler <jon@nutanix.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20221129182226.82087-1-jon@nutanix.com>
 <Y4j9u6YEpJ/px6kj@google.com>
 <B9071742-7C64-40F4-8A93-D61DC1FD4CE5@nutanix.com>
 <Y5D1JWutV7+nARxS@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y5D1JWutV7+nARxS@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/22 21:18, Sean Christopherson wrote:
> 
> And now that kvm-asm-offsets.c exists, I think it makes sense to drop the @regs
> parameter for __vmx_vcpu_run(), e.g. to roughly match __svm_vcpu_run().

Yeah, that I had already here 
(https://lore.kernel.org/kvm/20221028230723.3254250-1-pbonzini@redhat.com/T/#me77cdd848fa86cdce03f59447ddb4f2cba45f79c) 
but then I dropped when it became clear the SVM series was targeting 
6.1.  I planned to resubmit for 6.3 after the holidays.

Paolo

