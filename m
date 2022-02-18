Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F424BBE94
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 18:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbiBRRlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 12:41:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiBRRlv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 12:41:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 73067D3AFB
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 09:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645206092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GnuYPx4ALc7vupBYJPJ5qvV7EVEzwTLdGl9AEN4VlDg=;
        b=F1mcQpuRA/s1eyvtzDG4ax/w+dkbdHmWHGe227MZ37IOXz/d9HMEfI/ChzRs7Vd/5WZucZ
        uD8ECaGhR1GlHh9mYf+oCKITVhqvHCRaItQBt+jlTi8++8OkmhPwYYdSIdCdUXRIE4SLqs
        Dry2hLEi2WfUjHehDugoKanBMi6Oku4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-Z8UBXsD2P6eqplgIsdyDsg-1; Fri, 18 Feb 2022 12:41:31 -0500
X-MC-Unique: Z8UBXsD2P6eqplgIsdyDsg-1
Received: by mail-ej1-f72.google.com with SMTP id gn20-20020a1709070d1400b006cf1fcb4c8dso3391267ejc.12
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 09:41:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GnuYPx4ALc7vupBYJPJ5qvV7EVEzwTLdGl9AEN4VlDg=;
        b=LfqRr08g2jhROqZzfXXRKo9krCxk/uCwv9gImSP6tmTc6XQjYgsAwCrcvfqOm4v/Fv
         74QkAggtrK8t9CD7DqWxnxUMqkTCP0a2nzBmqC/4cKOwYypi6hppaYgWSe2jn6Ct0eoR
         +10z7rNY/QFR91bOuPVr1de5dQmoARedS0nbDVjqEh3/XYjH1SUd4gtZyIy1Aietfm+U
         gIccBh+tHLWXRqjsOrVw3kzI9O21iZzoY+GGGV3FVTLFYsEEUnCE31eyvbik2nSBEMCi
         qGGDtzDVGnm7GS0hx6wNcrzsRu0ReEp0el8hosHJuMbfBKfvrro3fYd2qhC4IcXg1szP
         +qMQ==
X-Gm-Message-State: AOAM530e6Ix0SM3HnUvEVQEiA2zeGzp8Zqo5RBZjYX6c1iO8pB8HQ+nR
        mVaYXc7tcbCUefm1uh6Ij7W/vDaue0XFMBWav+HAeNhrG5nwx9Fd+CP0bzty0bF8G23Xk5E/1Ht
        yYMItplYpuVme
X-Received: by 2002:a17:906:91c8:b0:6c5:76a6:688b with SMTP id b8-20020a17090691c800b006c576a6688bmr7601172ejx.174.1645206090168;
        Fri, 18 Feb 2022 09:41:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwVaFGgjuTsFPf5JRE18FJ5HhxPm41qDpdkzlQQSvv+/hX9VXjS7tjz10ooZ8Pb4bglOjzg1Q==
X-Received: by 2002:a17:906:91c8:b0:6c5:76a6:688b with SMTP id b8-20020a17090691c800b006c576a6688bmr7601160ejx.174.1645206089931;
        Fri, 18 Feb 2022 09:41:29 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id h8sm4926063edk.14.2022.02.18.09.41.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 09:41:29 -0800 (PST)
Message-ID: <65871234-0c94-2455-c55f-6c1d5775e485@redhat.com>
Date:   Fri, 18 Feb 2022 18:41:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 5/6] KVM: x86: make several AVIC callbacks optional
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220217180831.288210-1-pbonzini@redhat.com>
 <20220217180831.288210-6-pbonzini@redhat.com> <Yg/IGUFqqS2r98II@google.com>
 <eff2543a-10ab-611a-28e2-18999d21ddd8@redhat.com>
 <Yg/ZZMAz7XZ6wn/u@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yg/ZZMAz7XZ6wn/u@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/22 18:37, Sean Christopherson wrote:
>> True, on the other hand there's no reason why a hypothetical third vendor
>> would have to support it.  The call is conditional to apicv_active being
>> true.
> Ah, right, even if the the static_call_cond() is unnecessary because we want to
> make the hook mandatory if APICv is supported, APICv itself may not be supported.

I'm not even sure we want to make it mandatory, in fact.

Also new full log:

----
All their invocations are conditional on vcpu->arch.apicv_active,
meaning that they need not be implemented by vendor code: even
though at the moment both vendors implement APIC virtualization,
all of them should be optional.  In fact SVM does not need many of
them, and their implementation can be deleted now.
----

Paolo

