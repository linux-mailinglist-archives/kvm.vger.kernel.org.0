Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8801658DA91
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 16:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244544AbiHIOwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 10:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244549AbiHIOwH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 10:52:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50D5E1CFFA
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 07:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660056725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ijCljIFJxQDs9rpUwOiA9T47hiYGL1KMvk4jTLLiFLc=;
        b=ZAkOVcZpFNwUgFf2P7NCnejsHzvcm7jSXw2+hv3TJucBG3Mmah+YmT6IFTs0KX+850Kyqo
        Wzg/K5Q5y9YaUers4GrAP8xWGI2or0s/TpckKJj++dyBv6NRaXRlPSwkMOHbu8t37wgo3V
        2/LcxRt5YxQkaP86wWOQ1fbCwzy5GDQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-3-oQ5hQ1aoN2qYwf4iTuBCjw-1; Tue, 09 Aug 2022 10:52:04 -0400
X-MC-Unique: oQ5hQ1aoN2qYwf4iTuBCjw-1
Received: by mail-ed1-f71.google.com with SMTP id l19-20020a056402255300b0043df64f9a0fso7426768edb.16
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 07:52:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=ijCljIFJxQDs9rpUwOiA9T47hiYGL1KMvk4jTLLiFLc=;
        b=Go3xuAXHlyCy6Q/TScv3w3XkGgLpj4+2L/eEQGGtgw8UmfyWL/P2h8SuPj+KeXS2i8
         u39SnZ6+JM+MBp8WV7nT7+XcDf3pousWEHqcaBJEExiMZcCDHzB7KleinrI38/vVYOfV
         CqCthfz+wGZ6oZgKDxR1gmLAQUm6yfJgNlKUCjrD4U+B1E/Mdta0gol9mHAGyqkumSSD
         qZYaHdfdthGhRlH1oaHxeQ8LpgR/LBtIlPJpauSqQzMmGtiTol/Rx7TbQtlMpgupMi4b
         Wi8w0vszzKSTd7iFEHIDvFN5GCLbGOD8c71+MbCghy+j5huCTqkI+DIogd7wvteshQ+I
         LrXQ==
X-Gm-Message-State: ACgBeo3sOSm0X2PPEgGqa/S4/mDL/7CtjRkw7/G7oP5z9Abeq2QIWyTW
        ojccSJeBUULtgqnkM4x7ZkFbO7RfC6hPh+f8G9acfbCCkkWSCuotfEl0fKbG0jvx3yRA4i1CHC7
        4YF7mLBUg/14V
X-Received: by 2002:a05:6402:5388:b0:435:71b:5d44 with SMTP id ew8-20020a056402538800b00435071b5d44mr21744575edb.364.1660056723076;
        Tue, 09 Aug 2022 07:52:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7plxHqwIsjkKTlX0Eb6J8uwVOpAMNr+St8GLqxzDCUKQbz55ORjxu51ovqt7+0lbOwMrFKkw==
X-Received: by 2002:a05:6402:5388:b0:435:71b:5d44 with SMTP id ew8-20020a056402538800b00435071b5d44mr21744566edb.364.1660056722916;
        Tue, 09 Aug 2022 07:52:02 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id 2-20020a170906300200b007121361d54asm1218327ejz.25.2022.08.09.07.52.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 07:52:02 -0700 (PDT)
Message-ID: <59e48e63-8dcb-cd14-64e5-821d50fcd02f@redhat.com>
Date:   Tue, 9 Aug 2022 16:52:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v3 2/6] KVM: Shove vcpu stats_id init into kvm_vcpu_init()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, Oliver Upton <oupton@google.com>
References: <20220720092259.3491733-1-oliver.upton@linux.dev>
 <20220720092259.3491733-3-oliver.upton@linux.dev>
 <Yu1qT0ly3y3qkmKn@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yu1qT0ly3y3qkmKn@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/22 21:06, Sean Christopherson wrote:
>    Initialize stats_id alongside other kvm_vcpu fields to make it more
>    difficult to unintentionally access stats_id before it's set.

Thanks for the proposal, I'll fix it when applying.

Paolo

