Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF324DA42E
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 21:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240589AbiCOUrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 16:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235380AbiCOUrE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 16:47:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A552D27B04
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 13:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647377150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mfsuVWuQAKJg+F+zcfbiO96TVlca2UoPYtQW08E2LFI=;
        b=hrGBSiHFRS79x+QCKlu8wlyGkCHjF72l5FPFa+Sh7jRsS5WW/4J4fcZDIJ2yWXBO6pNN+R
        YZ5iDF2cmA8+FmDPjwnXT86CfZyuufzpOS2UgsfF86Q2GABPuqYqmBXBTcROCPuZdSt21K
        Mx5g4I8tlraglyX1Ybi5Yasfchv9SfE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-caqol04lOY6xYAB_karetA-1; Tue, 15 Mar 2022 16:45:49 -0400
X-MC-Unique: caqol04lOY6xYAB_karetA-1
Received: by mail-ej1-f72.google.com with SMTP id x2-20020a1709065ac200b006d9b316257fso26532ejs.12
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 13:45:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mfsuVWuQAKJg+F+zcfbiO96TVlca2UoPYtQW08E2LFI=;
        b=CKfOC7ChSvsorCUyXd8v4l7wUVs2s1b2Pt+PwD6ZmfEPrZ14Ju/pZSURbDYp6Od/Ce
         ivO8ePplYTKUumZOqqzV4bDLg5loQy8cvW/Bkr7TuHQBHCUvLnUKf1vO0KrfJRz9m3dk
         ncu17iBLKqoIs9/QHn0vQK1wFAFOtBXxWkTm94u4MfJY9dZuCWtkbd581O2ncwjrnfL/
         RQztgf3jCvTawdkXARp5vah2mxaqf4XSh2UHv9sQNze12fqv4YBvZzlOFyQVrus84oY9
         hZYituS6iVnC4qtf9sUwTe6+HGYGh9QrUu0iS2a/19ODu/OJovXGj0+mq8NiHV2ye66e
         0hdw==
X-Gm-Message-State: AOAM532p4whqTM3ttMvS+vX2i/HcJ6aR/J+Z+VxsX60Q9RpX6hphyt9S
        vMShQYGLQx6Nnfoxa9IgnFthbKM69rzdt5eoH4gmQxMX7Tf9jmpuGWDw3gBDo1gbEt92W4hSmO0
        sH/dhygFXo5Wg
X-Received: by 2002:a05:6402:5243:b0:418:e5f7:7b1 with SMTP id t3-20020a056402524300b00418e5f707b1mr819116edd.153.1647377148307;
        Tue, 15 Mar 2022 13:45:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDVTf9id9co9geemsNRV2GfTX3x2HDSYveRlWEoLl0162igpVWp9eSdiYwBNBvHBG+KoHtcg==
X-Received: by 2002:a05:6402:5243:b0:418:e5f7:7b1 with SMTP id t3-20020a056402524300b00418e5f707b1mr819095edd.153.1647377148096;
        Tue, 15 Mar 2022 13:45:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id re21-20020a170906d8d500b006daf3718d0csm39570ejb.143.2022.03.15.13.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 13:45:47 -0700 (PDT)
Message-ID: <fc0bca25-fbda-d489-5ad9-04db49cee205@redhat.com>
Date:   Tue, 15 Mar 2022 21:45:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH RESEND 1/2] KVM: Prevent module exit until all VMs are
 freed
Content-Language: en-US
To:     muriloo@linux.ibm.com, David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Rik van Riel <riel@redhat.com>,
        seanjc@google.com, bgardon@google.com, stable@vger.kernel.org,
        farosas@linux.ibm.com
References: <20220303183328.1499189-1-dmatlack@google.com>
 <20220303183328.1499189-2-dmatlack@google.com>
 <cb11c10b-0520-02ef-afb5-6f524847d67f@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <cb11c10b-0520-02ef-afb5-6f524847d67f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/15/22 16:43, Murilo Opsfelder Araújo wrote:
>>
>> +    if (!try_module_get(kvm_chardev_ops.owner)) {
>> +        r = -ENODEV;
>> +        goto out_err;
>> +    }
>> +
> 
> Doesn't this problem also affects the other functions called from
> kvm_dev_ioctl()?
> 
> Is it possible that the module is removed while other ioctl's are
> still running, e.g. KVM_GET_API_VERSION and KVM_CHECK_EXTENSION, even
> though they don't use struct kvm?

No, because opening /dev/kvm also adds a reference to the module.  The 
problem is that create_vm creates another source of references to the 
module that can survive after /dev/kvm is closed.

Paolo

