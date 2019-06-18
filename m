Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D49C649C5F
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 10:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbfFRIuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 04:50:21 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40658 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728918AbfFRIuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 04:50:21 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so2247671wmj.5
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 01:50:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XaRQwyUTgn2L8cxm2l8iSyR5oTljpteKkzWOcGKtjWc=;
        b=htg9qKYEY+TrgmNJ67Cr+g0bP7rhrloieYdW4zyrb1bDB4+L2DWiy7cVuuVHyph7+d
         iDfs6RncQZXiPlxnN2SIw+WTbwmXTj4YE2UHsevViQw5Oe5hJ1oTqBD5xUYB2ZFOasFI
         6mYFFfMSjdOtfldH1w+VPzmdN95AVohcRJ/rZHdjBeSjh3QH4k22DRX36J3D0/Ar5L4+
         XNf6y9gNz5HwAL89Xr3NiQ6q638c0GzuAtVqiDKLunkuCVj6LjrtlPGMqN7qVrAjT1o+
         dPWaqo7hvB45SOcuIWTMVbQLZhVzHgQ68t3WBlnSe1V2SY4UFyd1wb82FuxA8/uejH/s
         i2Xw==
X-Gm-Message-State: APjAAAWN6bJkzpkdr/5R3wH5ASxM6ZTZTvtdmkoqcA93mSyUH3Z40TMW
        Qlj53gWV4SHUgipXKxtqILljKspl/Ps=
X-Google-Smtp-Source: APXvYqzZGAzEwOQbHnAo4NEGyxeY8Rhb9eoy7zPk8ORLHQMa+HycqGYgiqCpgBpFzOUrxv1AdcNfWA==
X-Received: by 2002:a7b:cae9:: with SMTP id t9mr2419484wml.126.1560847818835;
        Tue, 18 Jun 2019 01:50:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1da0:213e:1763:a1a8? ([2001:b07:6468:f312:1da0:213e:1763:a1a8])
        by smtp.gmail.com with ESMTPSA id v67sm1569584wme.24.2019.06.18.01.50.18
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 01:50:18 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: Mask undefined bits in exit
 qualifications
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org
References: <20190503174919.13846-1-nadav.amit@gmail.com>
 <A9500030-816E-49F7-84C7-6176C722C2B0@gmail.com>
 <720b1ba2-11aa-6baf-9f21-aa3e1e324afa@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cd192b1f-471d-bf05-7af2-b4a7761042b5@redhat.com>
Date:   Tue, 18 Jun 2019 10:50:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <720b1ba2-11aa-6baf-9f21-aa3e1e324afa@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/06/19 00:22, Krish Sadhukhan wrote:
> 
> 
> On 06/17/2019 12:52 PM, Nadav Amit wrote:
>>> On May 3, 2019, at 10:49 AM, nadav.amit@gmail.com wrote:
>>>
>>> From: Nadav Amit <nadav.amit@gmail.com>
>>>
>>> On EPT violation, the exit qualifications may have some undefined bits.
>>>
>>> Bit 6 is undefined if "mode-based execute control" is 0.
>>>
>>> Bits 9-11 are undefined unless the processor supports advanced VM-exit
>>> information for EPT violations.
>>>
>>> Right now on KVM these bits are always undefined inside the VM (i.e., in
>>> an emulated VM-exit). Mask these bits to avoid potential false
>>> indication of failures.
>>>
>>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>>> ---
>>> x86/vmx.h       | 20 ++++++++++++--------
>>> x86/vmx_tests.c |  4 ++++
>>> 2 files changed, 16 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/x86/vmx.h b/x86/vmx.h
>>> index cc377ef..5053d6f 100644
>>> --- a/x86/vmx.h
>>> +++ b/x86/vmx.h
>>> @@ -603,16 +603,20 @@ enum vm_instruction_error_number {
>>> #define EPT_ADDR_MASK        GENMASK_ULL(51, 12)
>>> #define PAGE_MASK_2M        (~(PAGE_SIZE_2M-1))
>>>
>>> -#define EPT_VLT_RD        1
>>> -#define EPT_VLT_WR        (1 << 1)
>>> -#define EPT_VLT_FETCH        (1 << 2)
>>> -#define EPT_VLT_PERM_RD        (1 << 3)
>>> -#define EPT_VLT_PERM_WR        (1 << 4)
>>> -#define EPT_VLT_PERM_EX        (1 << 5)
>>> +#define EPT_VLT_RD        (1ull << 0)
>>> +#define EPT_VLT_WR        (1ull << 1)
>>> +#define EPT_VLT_FETCH        (1ull << 2)
>>> +#define EPT_VLT_PERM_RD        (1ull << 3)
>>> +#define EPT_VLT_PERM_WR        (1ull << 4)
>>> +#define EPT_VLT_PERM_EX        (1ull << 5)
>>> +#define EPT_VLT_PERM_USER_EX    (1ull << 6)
>>> #define EPT_VLT_PERMS        (EPT_VLT_PERM_RD | EPT_VLT_PERM_WR | \
>>>                  EPT_VLT_PERM_EX)
>>> -#define EPT_VLT_LADDR_VLD    (1 << 7)
>>> -#define EPT_VLT_PADDR        (1 << 8)
>>> +#define EPT_VLT_LADDR_VLD    (1ull << 7)
>>> +#define EPT_VLT_PADDR        (1ull << 8)
>>> +#define EPT_VLT_GUEST_USER    (1ull << 9)
>>> +#define EPT_VLT_GUEST_WR    (1ull << 10)
> 
> This one should be named EPT_VLT_GUEST_RW,  assuming you are naming them
> according to the 1-setting of the bits.

Applied with this change, thanks.

Paolo

