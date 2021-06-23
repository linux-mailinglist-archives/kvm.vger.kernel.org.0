Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143F63B2294
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 23:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhFWVk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 17:40:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229758AbhFWVk5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 17:40:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624484318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kbw/q0E3m9HA9XQc4l4QqdVFK2E0gU6u2QRRV8T1Zwk=;
        b=B84jzxmlJomJze74KaaG3aR0AP1AlQHHJuZndvBtnC2iqBjEw/vl7ODl7fYgjP1v1LIf2Z
        tgvU/LJOWjTii0ob1qIM2/xXU28EJmFWGFSYVtDGo/xnJhMKadgm7D74tatllDu+u2pkLl
        CDNhlbAcJ6SzBE5lYIMQPcRCefnkmac=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-Ph1UODKsOYOItS21FUr43A-1; Wed, 23 Jun 2021 17:38:37 -0400
X-MC-Unique: Ph1UODKsOYOItS21FUr43A-1
Received: by mail-ej1-f69.google.com with SMTP id o12-20020a17090611ccb02904876d1b5532so1433999eja.11
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 14:38:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kbw/q0E3m9HA9XQc4l4QqdVFK2E0gU6u2QRRV8T1Zwk=;
        b=As6UoTIJMawqA9WlkXvjb36R56mNd9xwZNZOhw2L7S3FP5GO80PQHlWUY1t/jEuHmO
         bBi/YVkFhqadh3gpPP3tlTxk8+VrINQYCmn6e1zWmeWkj8nqwadDEnKXenbKstAZ5zkI
         4tKeqQgMxy7VFzkPA+BGi4hw5imOplblCj0LGOFvq7aNAmJw3ZCF5Fsil2JZaaBLuFzx
         rrDQkvRPw4FSPpylCG9wWkF0sUYTHJgPCxDt3ku8rSqCOlSBnasYEiPQAblEC1CztpHF
         Hdm5FICQwqZ7lB6V6H79D8Fz5LbOcNIf24pJJTkLWtVmkdMVylNmyu7muBJ4tZiy6PHO
         QOeA==
X-Gm-Message-State: AOAM530P1oq9u1x49vnbabY+pPJSQpk/RJfqdeLrkzUV7w9WePHta3Ym
        FsGYOeTnH3Sr3RArqOrQeEKgYmY+VABQPbdCpMyCHlDBzHkx80z6XYhkA6xNmRDf7VWJbm2ATWm
        C5LHBCLZZM6iT
X-Received: by 2002:a17:906:9511:: with SMTP id u17mr2052870ejx.440.1624484316058;
        Wed, 23 Jun 2021 14:38:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiE/b5tNl8Qju9u7Vi6gnFDrmOQPvcJzVfyDAeSvqtQ9x8yy4g7gsDlcxCuVF0+AfK4sjM7Q==
X-Received: by 2002:a17:906:9511:: with SMTP id u17mr2052862ejx.440.1624484315898;
        Wed, 23 Jun 2021 14:38:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id yc20sm370033ejb.5.2021.06.23.14.38.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:38:35 -0700 (PDT)
Subject: Re: [PATCH v6 1/2] kvm: x86: Allow userspace to handle emulation
 errors
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     David Edmondson <david.edmondson@oracle.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>
References: <20210510144834.658457-1-aaronlewis@google.com>
 <20210510144834.658457-2-aaronlewis@google.com>
 <CALMp9eQ_42r-S-JPD-n7oXEaeMRVZdUG1UQkYJkhmHCSUkjvrw@mail.gmail.com>
 <CAAAPnDEQUG0_0+UuJoybdbQOv_p+267n_3it9m64wR1Nar7cOw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3242548f-5479-ac7e-c195-2a099428f530@redhat.com>
Date:   Wed, 23 Jun 2021 23:38:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAAPnDEQUG0_0+UuJoybdbQOv_p+267n_3it9m64wR1Nar7cOw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 19:44, Aaron Lewis wrote:
> On Thu, Jun 3, 2021 at 1:35 PM Jim Mattson <jmattson@google.com> wrote:
>>
>> On Mon, May 10, 2021 at 7:48 AM Aaron Lewis <aaronlewis@google.com> wrote:
>>>
>>> Add a fallback mechanism to the in-kernel instruction emulator that
>>> allows userspace the opportunity to process an instruction the emulator
>>> was unable to.  When the in-kernel instruction emulator fails to process
>>> an instruction it will either inject a #UD into the guest or exit to
>>> userspace with exit reason KVM_INTERNAL_ERROR.  This is because it does
>>> not know how to proceed in an appropriate manner.  This feature lets
>>> userspace get involved to see if it can figure out a better path
>>> forward.
>>>
>>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>>> Reviewed-by: David Edmondson <david.edmondson@oracle.com>
>> Reviewed-by: Jim Mattson <jmattson@google.com>
> 
> Hi Paolo,
> 
> Does this change look okay to you?  Can I get it queued?
> 
> Thanks,
> Aaron
> 

Sorry I missed it.  Looking now.

Paolo

