Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE075B35FA
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 13:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiIILCu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 07:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiIILCc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 07:02:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA94139C1C
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 04:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662721330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=552oMY7StYxcNv74FqiwwC+bER9EAS86HhvPvxTkRvE=;
        b=Znr4EI9zy9h83Qs30eeAJpt/ZhugP5rKvctult060GB8WSeuFMjVtTNhuE/oEojdJ5N4gg
        L2R9rOIcVkphZ0kmEHYmxZsVh0bePXV2XnFDgtBayUwpT26mcGjTdauher+w9oDZYM3YTH
        ZXq52HLSYlhKO6/RhcrV5HdR4rIqCdI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-46-J0EBfaH2O9Sc9gqcXe-YWA-1; Fri, 09 Sep 2022 07:02:08 -0400
X-MC-Unique: J0EBfaH2O9Sc9gqcXe-YWA-1
Received: by mail-wr1-f70.google.com with SMTP id t12-20020adfa2cc000000b00224f577fad1so270048wra.4
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 04:02:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=552oMY7StYxcNv74FqiwwC+bER9EAS86HhvPvxTkRvE=;
        b=SwncPHWFLA0MQfrOhbK/t4SQZ5a3mS/7sEvoREgRq7bNqKAT+pgtAA91nTr5oh9Lly
         AccCQCoETCJVN9Rxvahxb8GDozwFd2ZQqwY4SDZCqfOlFyYvWrPdKHskMMKYYjcSnYfC
         MmOXi4IIO1gH8Dv7xHbUuuDDU5FZ1FJUG6tSniZonteB4RG62xVqfQuQjHWwrs4DCWRk
         tZmcqHFT8DkBaCI2YuUIODVhAjvYrRyDmgcahmYboAK11LuCPBZVYHGtIf/HW/lK+6hZ
         Kqe2oadRVoI2nZCGEQg6vnW+U8zygrRS1Zj4kvNmTytzRxmhkhuNhBVttUj7V9GrIkNE
         UPeA==
X-Gm-Message-State: ACgBeo3Oqm2i0LDI1LclwE3IBL+HQlWTX2UUKXMPx6nPeYgxwaW03Nmq
        YEncHPBALpE7grSev6nsc07/br62+1Ow1P/FD2vOpADgx0zXThKm9DvcBUi58wiuTb5/u6rtvUf
        YmkdVSLkjoCyB
X-Received: by 2002:adf:edc9:0:b0:228:60de:1d4b with SMTP id v9-20020adfedc9000000b0022860de1d4bmr7840947wro.306.1662721327697;
        Fri, 09 Sep 2022 04:02:07 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6XrE6BUCNUNrNXlO+Yq7s10DLek+7dAPopvXjQd5tznH4HCs4Zzv6Wb4RjFhFEk1Hz/MJ9mg==
X-Received: by 2002:adf:edc9:0:b0:228:60de:1d4b with SMTP id v9-20020adfedc9000000b0022860de1d4bmr7840932wro.306.1662721327450;
        Fri, 09 Sep 2022 04:02:07 -0700 (PDT)
Received: from ?IPV6:2003:cb:c704:6300:1fe0:42e1:62c5:91b6? (p200300cbc70463001fe042e162c591b6.dip0.t-ipconnect.de. [2003:cb:c704:6300:1fe0:42e1:62c5:91b6])
        by smtp.gmail.com with ESMTPSA id z5-20020a05600c0a0500b003a540fef440sm449486wmp.1.2022.09.09.04.02.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 04:02:06 -0700 (PDT)
Message-ID: <36a9dc69-d045-7ca4-a0a8-995c63951a9f@redhat.com>
Date:   Fri, 9 Sep 2022 13:02:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [RFC PATCH 2/2] kvm/kvm-all.c: listener should delay kvm_vm_ioctl
 to the commit phase
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Peter Xu <peterx@redhat.com>
Cc:     Leonardo Bras Soares Passos <lsoaresp@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
References: <20220816101250.1715523-1-eesposit@redhat.com>
 <20220816101250.1715523-3-eesposit@redhat.com> <Yv6baJoNikyuZ38R@xz-m1.local>
 <CAJ6HWG6maoPjbP8T5qo=iXCbNeHu4dq3wHLKtRLahYKuJmMY-g@mail.gmail.com>
 <YwOOcC72KKABKgU+@xz-m1.local>
 <d4601180-4c95-a952-2b40-d40fa8e55005@redhat.com>
 <YwqFfyZ1fMA9knnK@xz-m1.local>
 <d02d6a6e-637e-48f9-9acc-811344712cd3@redhat.com>
 <66ed2e5b-b6a8-d9f7-3fe4-43c974dc0ecd@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <66ed2e5b-b6a8-d9f7-3fe4-43c974dc0ecd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09.09.22 10:02, Emanuele Giuseppe Esposito wrote:
> 
>>> One thing I forgot to ask: iirc we used to have a workaround to kick all
>>> vcpus out, update memory slots, then continue all vcpus.  Would that work
>>> for us too for the problem you're working on?
>>
>> As reference, here is one such approach for region resizes only:
>>
>> https://lore.kernel.org/qemu-devel/20200312161217.3590-1-david@redhat.com/
>>
>> which notes:
>>
>> "Instead of inhibiting during the region_resize(), we could inhibit for
>> the hole memory transaction (from begin() to commit()). This could be
>> nice, because also splitting of memory regions would be atomic (I
>> remember there was a BUG report regarding that), however, I am not sure
>> if that might impact any RT users."
>>
>>
> I read:
> 
> "Using pause_all_vcpus()/resume_all_vcpus() is not possible, as it will
> temporarily drop the BQL - something most callers can't handle (esp.
> when called from vcpu context e.g., in virtio code)."

... that's why the patch takes a different approach? :)

-- 
Thanks,

David / dhildenb

