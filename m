Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC75472D08
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 14:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbhLMNQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 08:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbhLMNQP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 08:16:15 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E8CC061574;
        Mon, 13 Dec 2021 05:16:14 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id w1so51786380edc.6;
        Mon, 13 Dec 2021 05:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q0rvbhn63gQKVZEWack1tAOTzbiQ34HJtQMGG7mhGh0=;
        b=J50lKBUNZ/QFX/hXza3LrsiCcoeodSHcSdm3LgK6um2wxoDQ/AYcjMe37cyh/6vdy7
         J5YBlAiQk2PbqrgTnX8jf3eNaz2oXrqnkHzX6bI5toCyMUV1Xq5/aVE4FExkiFNefJ21
         TNLkpyQf0wx6KOlkBjd/lwj732zI+itn7mjCPCBUPviAUathVdBvnI9YqeJljN6oWTaS
         UlwxVTFnLphrs9vDdibs5Ns9zuwd4m1XJkESZHQJdytXCO2KZ1KAw0cyy8+tR5ooeDB+
         4lMT2+kB5DQQ6yaLuBiyXEs2rmg6eMOw9wc/z8NKj9+Ty1qtKLjOWmvYVsKhTtW5J+tY
         Eh8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q0rvbhn63gQKVZEWack1tAOTzbiQ34HJtQMGG7mhGh0=;
        b=ppyHwCLMo5+ebkDvWvdxpOjBDDH7B7f0uxjRIdmRQl6P77lAhpfQ79HRvP8c1nFJmN
         hVZfBflbtrYDyEsRTaq1fIrgjbV2LYl75Guox6ciDLoHq28ApAjzMCGcV/jDkGQzIWNP
         pRAqtkNag6eUjufhQZlhjuU0UOoBQO1IjqVGzOkRATgAdUNwzctCMx7A8HKgV9sv9nd3
         ME2kQkaAb5mv3SdB0ebEEApoBvMn1J6pkwlI2O3rPGKI24u4KF+1iph5sbtgRnd7k+Ba
         iTBsmmPA5Y2ew7+4zOyK2zIrdI2iQ9uh0tjePZTMYdv7IV0kal144P19eJ/fgblrdT8H
         KfaA==
X-Gm-Message-State: AOAM531ZjEBd2fni4hNUTciaa6k209Ara12jWtnsTZe8ZOYbp1pd0sKP
        HlheIxMXt8RmyZeE+fmIi5k=
X-Google-Smtp-Source: ABdhPJwWci3+2M2TLk0/q6XZywG2dYCsmUcUrYrJBA7N+Ca4AFsydUIo+iqtIG7Y/J+MmPrQKcdibQ==
X-Received: by 2002:aa7:c390:: with SMTP id k16mr64603823edq.161.1639401373505;
        Mon, 13 Dec 2021 05:16:13 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id hz15sm5731499ejc.63.2021.12.13.05.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 05:16:13 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <6ce77eaf-ed2e-9092-0822-84caddd4a80c@redhat.com>
Date:   Mon, 13 Dec 2021 14:15:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 1/5] KVM: nSVM: deal with L1 hypervisor that intercepts
 interrupts but lets L2 control EFLAGS.IF
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
 <20211213104634.199141-2-mlevitsk@redhat.com>
 <0d893664-ff8d-83ed-e9be-441b45992f68@redhat.com>
 <74c548c61aeb4afba3acb4143fcb91d92e7de8d6.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <74c548c61aeb4afba3acb4143fcb91d92e7de8d6.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/21 14:07, Maxim Levitsky wrote:
>> Right, another case is when CLGI is not trapped and the guest therefore
>> runs with GIF=0.  I think that means that a similar change has to be
>> done in all the *_allowed functions.
>
> I think that SVM sets real GIF to 1 on VMentry regardless if it is trapped or not.

Yes, the issue is only when CLGI is not trapped (and vGIF is disabled).

> However if not trapped, and neither EFLAGS.IF is trapped, one could enter a guest
> that has EFLAGS.IF == 0, then the guest could disable GIF, enable EFLAGS.IF,
> and then enable GIF, but then GIF enablement should trigger out interrupt window
> VINTR as well.

While GIF=0 you have svm_nmi_blocked returning true and svm_nmi_allowed 
returning -EBUSY; that's wrong isn't it?

Paolo

