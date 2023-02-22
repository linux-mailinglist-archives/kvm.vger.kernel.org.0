Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5A569FB0A
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 19:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbjBVSds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 13:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjBVSdr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 13:33:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11549211D6
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 10:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677090779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RxTLlKY+9ULrzzMXgSndrIJ/8bCAMpyPVZCvM+mLSnU=;
        b=JhKngjvI1EXfB3GO/WT8NhjNE3eBQBWHKqjJ5/obUeYrfsljNMy0SvMU6xCdUYoVNIryqf
        8/HHd8GlRihXyhP1nR0M1PkDger2vGpU6XG4cdkTmWPPUHfPJevUHmgsqWHOPYQYmsmnrA
        JEQ5ZhsmNYrAtyK4dZsp8CErafGjP1Y=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645--wpzUTfGOP-0tHqRNzcKKg-1; Wed, 22 Feb 2023 13:32:57 -0500
X-MC-Unique: -wpzUTfGOP-0tHqRNzcKKg-1
Received: by mail-ed1-f71.google.com with SMTP id c1-20020a0564021f8100b004acbe232c03so11669858edc.9
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 10:32:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RxTLlKY+9ULrzzMXgSndrIJ/8bCAMpyPVZCvM+mLSnU=;
        b=BSCxbOMHaork2V3fiiaikxzRe6/NwVRLBogBLdr7xaDP5x58GuvnvKAUM8MLFFemMM
         ZqFrPD0ASjaslTBQcDh184zscFXjJPS62du0tNpTDT6u2NqdQVi4KINzvpi92LsmImW7
         HmZJFrIhPib8V9ITxRFp23l8Jlqn4bp1jxlvpZsUtesdVA6WFR0pfbrouCz3RK6cykKK
         bF0HhNi1r0AnjUGuDxSTyFBEn04T4OD/Xw5SjAkpgmBuYYYNb4x6uOOMRLhRF+bRIZKq
         rKdy8WeD6OgS7gcyZHQmoocK+zQtATnOElJMIiEg6/lpLZ9pWfFxT5Q40BVGoNxuLY1o
         e8iQ==
X-Gm-Message-State: AO0yUKX93Q+1jQO3rf3LAPXKarpxgcpDAQsB91IDW+H9PPuiSU7k/YPN
        Q94+SUoKhB8QL+5pnhU1kuO3V9JdkvThYQwDbqmrkESeFxnlJKJK5YlVUyma8aWfXtTiGCiQyP5
        aXoxRa308UDRS
X-Received: by 2002:a17:906:6d11:b0:86f:763c:2695 with SMTP id m17-20020a1709066d1100b0086f763c2695mr19160431ejr.17.1677090775569;
        Wed, 22 Feb 2023 10:32:55 -0800 (PST)
X-Google-Smtp-Source: AK7set/PslfAFfrcvFRi8NUH0wtaoIfKKC3ofUUlS9iItCKHzhNsqOJxd9xPZha2wUF1fM+RNDjeaQ==
X-Received: by 2002:a17:906:6d11:b0:86f:763c:2695 with SMTP id m17-20020a1709066d1100b0086f763c2695mr19160411ejr.17.1677090775238;
        Wed, 22 Feb 2023 10:32:55 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id n27-20020a17090673db00b008d173604d72sm4487933ejl.174.2023.02.22.10.32.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 10:32:54 -0800 (PST)
Message-ID: <27364a82-fa60-1454-e25d-15239905baf3@redhat.com>
Date:   Wed, 22 Feb 2023 19:32:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2] KVM: SVM: hyper-v: placate modpost section mismatch
 error
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
References: <20230222162511.7964-1-rdunlap@infradead.org>
 <Y/ZG8u6/aUtpsVDa@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y/ZG8u6/aUtpsVDa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/23 17:46, Sean Christopherson wrote:
>    Tag svm_hv_hardware_setup() with __init to fix a modpost warning as the
>    non-stub implementation accesses __initdata (svm_x86_ops), i.e. would
>    generate a use-after-free if svm_hv_hardware_setup() were actually invoked
>    post-init.  The helper is only called from svm_hardware_setup(), which is
>    also __init, i.e. other than the modpost warning, lack of __init is benign.

Done.  It's caused by the compiler deciding not to inline the function, 
probably.

Also Cc'ed stable.

Paolo

