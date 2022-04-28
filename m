Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9BD513F46
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 01:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbiD2ACi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 20:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353464AbiD2ACh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 20:02:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F189BB3DE0
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 16:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651190360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GmImSFPf7Lk+sCfWgtXvV7fwMchqJTRIojOVtL7C1jE=;
        b=Gx7/kBzIrtIc7KWC+CdYzCfI/7G2bB8DmSU/ArTIGUz17+MTZh6TLlLZgKJEPXGO82GTGh
        azGpuPSi6cIoe1Vu5KK34KqaEV2Te1Lws8ZIVBAyJCIeSEg9hE6gJtwUAkRWcZqMHDM5nH
        VDmOKCxAPRqyjuDE/dVGUWsmBEULw+c=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-g5ppDwloNhKUcy2OBiyqCw-1; Thu, 28 Apr 2022 19:59:18 -0400
X-MC-Unique: g5ppDwloNhKUcy2OBiyqCw-1
Received: by mail-ej1-f72.google.com with SMTP id sc8-20020a1709078a0800b006f3ed35a96bso795066ejc.15
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 16:59:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=GmImSFPf7Lk+sCfWgtXvV7fwMchqJTRIojOVtL7C1jE=;
        b=APPRnoZ9ECI8NIWmmb/cZjCBcyalOhiG/jPLKSdZoJoK13voi6F3Yj553TpBZNgA/D
         Z9M0rVez2aKRyr4Ex7ULEH0tYlS52QCqNHfTJa8j4MGR01LdLEWoj6eeoZ6Ft27Q+1uu
         gpip/IKohvTqcshLIweNu4uNxbug4kbF4K85CF09ixifywF45o7XElV4XM288v2atZID
         8sHTeTLlO9S7OTi2eWB64xmqR5tgwj5LV9ajRhiXTK0stbFH5/5zBSdi2dUipgJUzsLj
         zwi73UpHT9pDFIeQankqNZ2IdCElvoq87Q7VcXwC5VMuzhUMkEv2pqs+QVL4h7a26X5v
         fDjw==
X-Gm-Message-State: AOAM533pR+Jg10Pqw8XM89bpzSy1a3dXaCkCu0N9YS3lLgcEcCDfxENE
        u1ccnMrOjgeEgyjtDw9dpArsV2OyWUfeFr/Vf1pweJjc0c7mOG2U+UN/3eJhmsE+mvilCTIB8+C
        MFKTK3ab1BPzs
X-Received: by 2002:a17:907:3e03:b0:6da:8c5a:6d4a with SMTP id hp3-20020a1709073e0300b006da8c5a6d4amr34480355ejc.585.1651190357693;
        Thu, 28 Apr 2022 16:59:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvQWqAkEscMBqtrgcOG7c/Xt8T1z0QIoEC+It5ziR4YdJrD098v9gADqk/w3yefNecLK0hTQ==
X-Received: by 2002:a17:907:3e03:b0:6da:8c5a:6d4a with SMTP id hp3-20020a1709073e0300b006da8c5a6d4amr34480346ejc.585.1651190357468;
        Thu, 28 Apr 2022 16:59:17 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id em20-20020a170907289400b006f3ef214e03sm129292ejc.105.2022.04.28.16.59.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 16:59:16 -0700 (PDT)
Message-ID: <0d282be4-d612-374d-84ba-067994321bab@redhat.com>
Date:   Fri, 29 Apr 2022 01:59:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     John Sperbeck <jsperbeck@google.com>,
        kvm list <kvm@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220407195908.633003-1-pgonda@google.com>
 <CAFNjLiXC0AdOw5f8Ovu47D==ex7F0=WN_Ocirymz4xL=mWvC5A@mail.gmail.com>
 <CAMkAt6r-Mc_YN-gVHuCpTj4E1EmcvyYpP9jhtHo5HRHnoNJAdA@mail.gmail.com>
 <CAMkAt6r+OMPWCbV_svUyGWa0qMzjj2UEG29G6P7jb6uH6yko2w@mail.gmail.com>
 <62e9ece1-5d71-f803-3f65-2755160cf1d1@redhat.com>
 <CAMkAt6q6YLBfo2RceduSXTafckEehawhD4K4hUEuB4ZNqe2kKg@mail.gmail.com>
 <4c0edc90-36a1-4f4c-1923-4b20e7bdbb4c@redhat.com>
 <CAMkAt6oL5qi7z-eh4z7z8WBhpc=Ow6WtcJA5bDi6-aGMnz135A@mail.gmail.com>
 <CAMkAt6rmDrZfN5DbNOTsKFV57PwEnK2zxgBTCbEPeE206+5v5w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3] KVM: SEV: Mark nested locking of vcpu->lock
In-Reply-To: <CAMkAt6rmDrZfN5DbNOTsKFV57PwEnK2zxgBTCbEPeE206+5v5w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/28/22 23:28, Peter Gonda wrote:
> 
> So when actually trying this out I noticed that we are releasing the
> current vcpu iterator but really we haven't actually taken that lock
> yet. So we'd need to maintain a prev_* pointer and release that one.

Not entirely true because all vcpu->mutex.dep_maps will be for the same 
lock.  The dep_map is essentially a fancy string, in this case 
"&vcpu->mutex".

See the definition of mutex_init:

#define mutex_init(mutex)                                              \
do {                                                                   \
         static struct lock_class_key __key;                            \
                                                                        \
         __mutex_init((mutex), #mutex, &__key);                         \
} while (0)

and the dep_map field is initialized with

         lockdep_init_map_wait(&lock->dep_map, name, key, 0, LD_WAIT_SLEEP);

(i.e. all vcpu->mutexes share the same name and key because they have a 
single mutex_init-ialization site).  Lockdep is as crude in theory as it 
is effective in practice!

> 
>           bool acquired = false;
>           kvm_for_each_vcpu(...) {
>                   if (!acquired) {
>                      if (mutex_lock_killable_nested(&vcpu->mutex, role)
>                          goto out_unlock;
>                      acquired = true;
>                   } else {
>                      if (mutex_lock_killable(&vcpu->mutex, role)
>                          goto out_unlock;

This will cause a lockdep splat because it uses subclass 0.  All the 
*_nested functions is allow you to specify a subclass other than zero.

Paolo

>                   }
>           }
> 
> To unlock:
> 
>           kvm_for_each_vcpu(...) {
>              mutex_unlock(&vcpu->mutex);
>           }
> 
> This way instead of mocking and releasing the lock_dep we just lock
> the fist vcpu with mutex_lock_killable_nested(). I think this
> maintains the property you suggested of "coalesces all the mutexes for
> a vm in a single subclass".  Thoughts?

