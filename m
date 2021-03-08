Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8146E331A6E
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 23:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhCHWwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 17:52:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22352 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230047AbhCHWvv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 17:51:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615243910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hWBOwAebpQRB0wNXn8a6DM63MP2+UfsxZ4n4z5ZRkG4=;
        b=BhR+8wfIOmqwxdXgWfiOxjB0MJPDx/suWEd7zaq6Bz2wmX6Bvpkgs9ix4rnmpBeZhRJdCl
        Acty3xhhWiLc9NjvK60e8IlaXjTnn0qx5Z+qJsGfR1E81VE8jTZvMT3ZM4PpFErMShl9vE
        iI+B2I44GWUCxFU5AEYv6uPBKuvnnvU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-u3WlfEfbMyC0QefEtAW8yQ-1; Mon, 08 Mar 2021 17:51:48 -0500
X-MC-Unique: u3WlfEfbMyC0QefEtAW8yQ-1
Received: by mail-ej1-f70.google.com with SMTP id p8so4751244ejl.0
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 14:51:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hWBOwAebpQRB0wNXn8a6DM63MP2+UfsxZ4n4z5ZRkG4=;
        b=rNQPw4YmOD94s9mcw7+WLZQYyP8mqE5+6CzQr3dmSPIdVn/obsqY2ym1Aim2IWhbrd
         7RAtnEpwuD4hUzkI5GIPj0cFzs6yKiUJjQ4VzYM3gaAinGa42ex4A57i56jLUdZ9juz0
         XqsyR4llbH//wiiwSyWqz3kXIKm7FbGOw5atg/dgv9LPf+kBBkujPdtHOp1eySeE//NB
         PwA/Vz24+f7TuJr17Y2IHQD7G0dqDz8QfE0kj96qtDj2BYjHCzUBB/5+V0fenMjgqkAv
         6kN9OfzkxeMJ01tfSeRkdLPIzNkcYsBYmyFDJ24Vu93judb9faFOJcfBD3W8n7wPQce/
         JI5Q==
X-Gm-Message-State: AOAM5303q2XvMbD4ISpEhCHK7gx+HAjnh6B0XUVO6gWeCkKwzImgBhBn
        xanYEZVBDh730ZRRMQnyF9s0hh6pGxO8wATteKSLxlj5bOp6oi27zArZTl5cgZ87IRbh+3MDlIR
        2SvJ1nzUJwP3j
X-Received: by 2002:a17:906:110d:: with SMTP id h13mr17391840eja.357.1615243907815;
        Mon, 08 Mar 2021 14:51:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxtoSI5zhutYPdc14J0CbwqHgr5iKUdl1vCcbKfFfSZbY+nDqpwijXzf4JQTz2RWDSGh8vUrw==
X-Received: by 2002:a17:906:110d:: with SMTP id h13mr17391833eja.357.1615243907690;
        Mon, 08 Mar 2021 14:51:47 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id cw14sm8224396edb.8.2021.03.08.14.51.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 14:51:47 -0800 (PST)
Subject: Re: [PATCH 03/28] KVM: nSVM: inject exceptions via
 svm_check_nested_events
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com,
        Jim Mattson <jmattson@google.com>
References: <YELdblXaKBTQ4LGf@google.com>
 <fc2b0085-eb0f-dbab-28c2-a244916c655f@redhat.com>
 <YEZUhbBtNjWh0Zka@google.com>
 <006be822-697e-56d5-84a7-fa51f5087a34@redhat.com>
 <YEaMhHG7ylvTpoYD@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <30846470-28e2-c05d-21c7-9ad5631bf821@redhat.com>
Date:   Mon, 8 Mar 2021 23:51:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YEaMhHG7ylvTpoYD@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/03/21 21:43, Sean Christopherson wrote:
> On Mon, Mar 08, 2021, Paolo Bonzini wrote:
>> On 08/03/21 17:44, Sean Christopherson wrote:
>>> VMCALL is also probably ok
>>> in most scenarios, but patching L2's code from L0 KVM is sketchy.
>>
>> I agree that patching is sketchy and I'll send a patch.  However...
>>
>>>> The same is true for the VMware #GP interception case.
>>>
>>> I highly doubt that will ever work out as intended for the modified IO #GP
>>> behavior.  The only way emulating #GP in L2 is correct if L1 wants to pass
>>> through the capabilities to L2, i.e. the I/O access isn't intercepted by L1.
>>> That seems unlikely.
>>
>> ... not all hypervisors trap everything.  In particular in this case the
>> VMCS12 I/O permission bitmap should be consulted (which we do in
>> vmx_check_intercept_io), but if the I/O is not trapped by L1 it should
>> bypass the IOPL and TSS-bitmap checks in my opinion.
> 
> I agree, _if_ it's not trapped.  But bypassing the checks when it is trapped is
> clearly wrong.

You can still trap #GP unconditionally and run the emulator. The 
intercept check will (or should) handle it.

Paolo

