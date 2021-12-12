Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05A1471965
	for <lists+kvm@lfdr.de>; Sun, 12 Dec 2021 10:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhLLJK1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Dec 2021 04:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhLLJK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Dec 2021 04:10:27 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38F7C061714;
        Sun, 12 Dec 2021 01:10:26 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id e3so43604603edu.4;
        Sun, 12 Dec 2021 01:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rILl6CcT7CpVVtaZSnLWIdMjI1vJbvVwqnPQFK8Fnxw=;
        b=k3eUNoyx+sHKeF1cnsFmcezsvBvT3owO7MgdgpX7jQrfBPRhv2QrR0gRKPmubDz5Qx
         skXpkdFxpeBvrbMFAYHdPxCUdSz092jg6q3zM6b6sR+MexV3hLOnVRWmupn14W9FzmjL
         Y7jH7JsJr2jAI2M8m5p0knoOW1M9q9jcvvnetkjoIWWzFq0uFNDw8zm7vpcKz7yK4xvk
         riTjjgJV32KHwJld9gatbR0wNqDHeK5ITeXDWXkocH54OWlNdQvDtLlgldHiEB22NWvR
         vNEAtcyypcck7ym+Z+pnF1oDhn7AegGTcxqqzMfysAs/cmnWR5Z9yxE7GxCIpv+aFhDj
         SqYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rILl6CcT7CpVVtaZSnLWIdMjI1vJbvVwqnPQFK8Fnxw=;
        b=AfIAptgPAwa9PxpxtklyFWwib4kqi1SPt6f2gaHbhKPGiexDcgRMYSi8A4BXfaYAXg
         S7gH0SUXxNXdcJ/gDbSXnZx21DfPRDJ/pQugTPyoenT9Tkc/iJOHW7HQZLYnYreaY/M/
         vQb7gPNeQtjEuPgmPMzMNQJ04w6IkBLoh64dLxHbKk2XZIhWm7zW4JrBTaSwb4LLApky
         LsMW69F7QzxtTWkIo/DcHOAYvBoZBOe+ef8p9oeY43LjTdXbF34lp5Rc58vZObXHccyB
         AbG1I5dNj/dy3ny1LDHjnkKHFXPSdGQlZ1QaXuCq7K5IqWH0Tq57JAPO6dIdZo+wvJWP
         UrIA==
X-Gm-Message-State: AOAM5328EpCBMkZsTX9/LDIZeVMKBroUykOdnty3H48wrEnsBXdSK85Q
        uqVq1DOxFfGONb/rqtFQkxeWRXRkFUA=
X-Google-Smtp-Source: ABdhPJyTl79SjLfDAA+1SCuMO81DM27qUWCgyXippjnFiJYJtH3H9nPaNWvxl1VcRffg8YRoVebGeA==
X-Received: by 2002:a17:907:9056:: with SMTP id az22mr35737544ejc.107.1639300225264;
        Sun, 12 Dec 2021 01:10:25 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id dp16sm4722947ejc.34.2021.12.12.01.10.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Dec 2021 01:10:24 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <a2e954bf-22bc-669b-e39e-dd941d330fa1@redhat.com>
Date:   Sun, 12 Dec 2021 10:10:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 15/19] kvm: x86: Save and restore guest XFD_ERR properly
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc:     "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-16-yang.zhong@intel.com> <87pmq4vw54.ffs@tglx>
 <BN9PR11MB5276DF25E38EE7C4F4D29F288C729@BN9PR11MB5276.namprd11.prod.outlook.com>
 <87zgp7uv6g.ffs@tglx>
 <BL1PR11MB5271FDCE84F4D25D0241D5998C739@BL1PR11MB5271.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <BL1PR11MB5271FDCE84F4D25D0241D5998C739@BL1PR11MB5271.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/21 02:50, Tian, Kevin wrote:
>>
>> If there are other XFD controlled facilities in the future, then it will
>> be NR_USED_XFD_CONTROLLED_FACILITIES * 2 VMEXITs per thread which
>> uses
>> them. Not the end of the world either.
>>
>> Looking at the targeted application space it's pretty unlikely that
>> tasks which utilize AMX are going to be so short lived that the overhead
>> of these VMEXITs really matters.
>>
>> This of course can be revisited when there is a sane use case, but
>> optimizing for it prematurely does not buy us anything else than
>> pointless complexity.
> It may affect guest which still uses CR0.TS to do lazy save. But likely
> modern OSes all move to eager save approach so always trapping #NM
> should be fine.

You also don't need to trap #NM if CPUID includes no dynamic bits, 
because then XFD will never be nonzero.

Paolo
