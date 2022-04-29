Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5C951515F
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 19:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379428AbiD2RMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 13:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379021AbiD2RMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 13:12:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 204D8D115A
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 10:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651252151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bR7U7XKW06Rd0hYKWp18hOYc2jittIlTjeGYl3Ta7P4=;
        b=OCI1sK17OTqD91AUQxT7vL5HY28/vJ9p9htgQlF7phfXxZ0oMu8IF+Tf189Ry0U5LxlX2x
        K6HXQGZqVDnZ2x6GNyO4c1KD74+XdKqHEB+JtIF0s/au0tuOuUZVCgKWag2ZLo1CliEm7l
        It9A1NtJMxIr0eBZpFzYyYDNmk9ViAE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-LyhCIx-9NiaE-1uOxB3fhw-1; Fri, 29 Apr 2022 13:09:09 -0400
X-MC-Unique: LyhCIx-9NiaE-1uOxB3fhw-1
Received: by mail-ed1-f69.google.com with SMTP id eg38-20020a05640228a600b00425d61d0302so4842679edb.17
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 10:09:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bR7U7XKW06Rd0hYKWp18hOYc2jittIlTjeGYl3Ta7P4=;
        b=G/0sfcJTYuY1biGJxnXPBpGuwBL8rvPWQupv/UEMzQiB6izI+RziUvRFPG3Trlt0iH
         q4ZARlqxsh2BmZcxXTuckVS/eMzDh5HWLp9YGG57orZtLxWO0rdToJ9awrX5ZL3SP2dn
         aTj2gBQ3FYKkysi5uWd7WeW92Md+5OYsiGecQH+muipFUKRXhnzkO5B0UPw84d6RdhEJ
         Y5jNg6kxVYBPqrLq7DfOB/s2xf1RBzrzOBxfUDWuvgsCfFsOOFQG043UNRZmV/n5bkl8
         8KHzRrIw774LTZ8ysxG8tdFdUXkGtRFAPq7238CNlJxg4mQmAxw4oLpSsnr5AMbARSds
         wN6w==
X-Gm-Message-State: AOAM530UB5GWdEGesfZrW3kE/zQR/0/pnk4C14cT7CWUnd/0NYBw8WnY
        r9j+BrBL5e/Aqr9gvy3cVR3nFh0KNUKdF3IYIS/PrTmDIspJTtT2sEnKvSV8IlNS+HBNug8qY2M
        3BX94J4VCn1Z7
X-Received: by 2002:a05:6402:5114:b0:423:f33d:b3c with SMTP id m20-20020a056402511400b00423f33d0b3cmr196219edd.199.1651252148345;
        Fri, 29 Apr 2022 10:09:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgSmtYizJefurAotPaAGKxQWAIKDpoKa9RhzQgBMvyNJAu2o8gugfd+deHOvkf9pb1W9NpYQ==
X-Received: by 2002:a05:6402:5114:b0:423:f33d:b3c with SMTP id m20-20020a056402511400b00423f33d0b3cmr196192edd.199.1651252148063;
        Fri, 29 Apr 2022 10:09:08 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id g14-20020a056402180e00b0042617ba6389sm3115953edy.19.2022.04.29.10.09.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 10:09:07 -0700 (PDT)
Message-ID: <0b554e22-6766-8299-287c-c40240c08536@redhat.com>
Date:   Fri, 29 Apr 2022 19:09:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/3] KVM: x86: make vendor code check for all nested
 events
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com, stable@vger.kernel.org
References: <20220427173758.517087-1-pbonzini@redhat.com>
 <20220427173758.517087-2-pbonzini@redhat.com> <YmwaVY5vERO43CRI@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YmwaVY5vERO43CRI@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 19:03, Sean Christopherson wrote:
> This doesn't even compile...
> 
> arch/x86/kvm/vmx/nested.c: In function ‘vmx_has_nested_events’:
> arch/x86/kvm/vmx/nested.c:3862:61: error: ‘vmx’ undeclared (first use in this function)
>   3862 |         return nested_vmx_preemption_timer_pending(vcpu) || vmx->nested.mtf_pending;
>        |                                                             ^~~
> arch/x86/kvm/vmx/nested.c:3862:61: note: each undeclared identifier is reported only once for each function it appears in
>    CC [M]  arch/x86/kvm/svm/svm_onhyperv.o
> arch/x86/kvm/vmx/nested.c:3863:1: error: control reaches end of non-void function [-Werror=return-type]
>   3863 | }
>        | ^
> cc1: all warnings being treated as errors
>    LD [M]  arch/x86/kvm/kvm.o

Yeah, it doesn't.  Of course this will need a v2, also because there are 
failures in the vmx tests.

What can I say, testing these patches on AMD hardware wasn't a great idea.

Paolo

