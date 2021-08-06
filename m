Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F73D3E29D6
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 13:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245576AbhHFLj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 07:39:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45273 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242589AbhHFLj1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Aug 2021 07:39:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628249951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6CCTGCsVlejSWa2TDvN4nfZAMgKaHGMDw5CATIJdm6E=;
        b=MYSwsJJGQpbfSg2leZGA4AF/cpFPNysJ6v+NXf7RXuzoMHnTStWatKg5F2i/JfXTccBu/0
        uanVwSioqLHgFQWrkfhwggRNfOA2z2zofzVvauu+2rdVA2haX3GPeKbwqMDMiAcwtJFcGG
        PXSwO7BDPavNY85m8FqrmmZao925ydM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-VPY7Jf-dPj-wtnkjvLlkJw-1; Fri, 06 Aug 2021 07:39:10 -0400
X-MC-Unique: VPY7Jf-dPj-wtnkjvLlkJw-1
Received: by mail-wm1-f72.google.com with SMTP id g187-20020a1c20c40000b02902458d430db6so1921674wmg.9
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 04:39:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6CCTGCsVlejSWa2TDvN4nfZAMgKaHGMDw5CATIJdm6E=;
        b=LyyoXpAN9my5dR5RDlQNwiwt0BwpkympEtrayHRyfjFTDyZ1Nd9Zhl2LCo3Yz5pCEZ
         hcpfWJccn/9owyGjRIc4JeRvOamE/WTBrOyXkLtYFQqorjyqNWpIBcELMCSX2XH983O9
         3iX29aNOssflZwnoPzpHcWZUesOgDiMQE4tP2XOeDHcJD7OmPtTEUkZFabfjhUCeXSQD
         YqtoiYmkADMin+rQFqDH54nrBvX50Qj20u/nAoRN8l+C4SBQH7fOhGIhRF3im9cHGFyQ
         VelOoRCQYNVvEaIm7aXMwFze8VfLi8ECdS8l1GShCPuBzRgAdZ4Xqeqx8lc8KANhQjAC
         +kiw==
X-Gm-Message-State: AOAM533Q3wNYvAw4jZOpxTSmS1gTwEHUAlS0kfeaTDkko/O9QD97mpXh
        WbLyp2EyW0oAmh2rpTLKMsfWVYwzOHWLuq9S9eQgFhN4W4xw1oozOCGCN65XZLSmnW5723PPzH0
        VzDg0XUGJu8Ph
X-Received: by 2002:a05:600c:35c1:: with SMTP id r1mr2807875wmq.101.1628249948972;
        Fri, 06 Aug 2021 04:39:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBopaYdlFz12anxgFBxd76mmz9lAC4I8VKP8fU5XI5T+hbGBeAtWlQNXOP+dSKFRa9bqFXqA==
X-Received: by 2002:a05:600c:35c1:: with SMTP id r1mr2807863wmq.101.1628249948780;
        Fri, 06 Aug 2021 04:39:08 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6104.dip0.t-ipconnect.de. [91.12.97.4])
        by smtp.gmail.com with ESMTPSA id b15sm9184520wrx.73.2021.08.06.04.39.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 04:39:08 -0700 (PDT)
Subject: Re: [PATCH v3 03/14] KVM: s390: pv: leak the ASCE page when destroy
 fails
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
References: <20210804154046.88552-1-imbrenda@linux.ibm.com>
 <20210804154046.88552-4-imbrenda@linux.ibm.com>
 <6b75cc71-b996-cf3d-ce57-dbcd475ebc3a@redhat.com>
 <20210806113244.4d0712d2@p-imbrenda>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <f2902086-6c77-eb7d-c4c9-15abb738b214@redhat.com>
Date:   Fri, 6 Aug 2021 13:39:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210806113244.4d0712d2@p-imbrenda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.08.21 11:32, Claudio Imbrenda wrote:
> On Fri, 6 Aug 2021 09:31:54 +0200
> David Hildenbrand <david@redhat.com> wrote:
> 
>> On 04.08.21 17:40, Claudio Imbrenda wrote:
>>> When a protected VM is created, the topmost level of page tables of
>>> its ASCE is marked by the Ultravisor; any attempt to use that
>>> memory for protected virtualization will result in failure.
>>>
>>> Only a successful Destroy Configuration UVC will remove the marking.
>>>
>>> When the Destroy Configuration UVC fails, the topmost level of page
>>> tables of the VM does not get its marking cleared; to avoid issues
>>> it must not be used again.
>>>
>>> Since the page becomes in practice unusable, we set it aside and
>>> leak it.
>>
>> Instead of leaking, can't we add it to some list and try again later?
>> Or do we only expect permanent errors?
> 
> once the secure VM has been destroyed unsuccessfully, there is nothing
> that can be done, this is a permanent error
> 
>> Also, we really should bail out loud (pr_warn) to tell the admin that
>> something really nasty is going on.
> 
> when a destroy secure VM UVC fails, there are already other warnings
> printed, no need to add one more
> 

Okay, makes sense then to me, thanks! Might be worth adding some of that 
info to the patch description.

-- 
Thanks,

David / dhildenb

