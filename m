Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68BB279F1A
	for <lists+kvm@lfdr.de>; Sun, 27 Sep 2020 08:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbgI0Gyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Sep 2020 02:54:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730350AbgI0Gyy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 27 Sep 2020 02:54:54 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601189693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bd/ZPlUtGfcavMMYXo7QbCua2yw75N9F0WV8AxCRw+M=;
        b=J+Xy+j3/6vxIT236L5w9MR2QKAW3UKC2oaK0SggAtgFadyPFhjTnawBdIvZ+MpU9bX9Tqj
        WLpnp5sTWkYR+tQTwCAO5vl8/A+hX1KjBd7s6GeLhtxFmteqQ2CSzi2jYtbOw/LzQ/VXkh
        xdz07yGFUui0+Q6u7lzhdO3ZWEZ7LeE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-dXM5i3PjO2K0PMtN0KzAqQ-1; Sun, 27 Sep 2020 02:54:51 -0400
X-MC-Unique: dXM5i3PjO2K0PMtN0KzAqQ-1
Received: by mail-wr1-f71.google.com with SMTP id d9so3208819wrv.16
        for <kvm@vger.kernel.org>; Sat, 26 Sep 2020 23:54:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bd/ZPlUtGfcavMMYXo7QbCua2yw75N9F0WV8AxCRw+M=;
        b=smlCeXMc9sV1WsAYmQPQq1cXkmQeGBjjB7S4NtxJ1PLhm9Tbjr32L1fFLzliz9i9xE
         0Zfh+JMQRCKI/gBR1woM7tFr8GiQs+NBMbN/TByreet0HBnFadQ+gnXhwQYgyoQhli9E
         U3k/aT5O2qEf2T9wf2nl2YovxUG3xRkJU4FaSG6vRKl98WDmt1Q0tcMEyhUuwVlErqRW
         UaTICZI6UGJR5EAO8CwFyGgkxfbld/p+/x610IwJdXcCSP2Lki+Z5jkuMpGO68yblG1v
         0vKMO1rnPykEFJiBBSbwJZuxdiCQF9bzTdLsPuzO1Yh62oUCTigPuWw/d2obx5sym4f/
         3QWg==
X-Gm-Message-State: AOAM531P/JO6xMFC4izMYaJ+P6yoFsVltY9COjZ9GF2TiDXw1kXBAa9c
        SZLar+7L9dLDLCGm9KFWq5vS7AOyFbl7ACCilwIWg2j7UL2oDzhIoZLUslaagxtZuARhvXHPz9U
        G4oWA+lYziN6I
X-Received: by 2002:a1c:26c3:: with SMTP id m186mr5488357wmm.115.1601189690317;
        Sat, 26 Sep 2020 23:54:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHzGTRSMAbCCKFrPZbp4Zv97tRct/WUPEKLmIQIF9Yuq5mVmVNaU8KzZHi/AcXFfyqzJEjXw==
X-Received: by 2002:a1c:26c3:: with SMTP id m186mr5488333wmm.115.1601189690096;
        Sat, 26 Sep 2020 23:54:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fc81:b99a:aac0:e256? ([2001:b07:6468:f312:fc81:b99a:aac0:e256])
        by smtp.gmail.com with ESMTPSA id k12sm8527873wrn.39.2020.09.26.23.54.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Sep 2020 23:54:49 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
To:     "Qi, Yadong" <yadong.qi@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "nikita.leshchenko@oracle.com" <nikita.leshchenko@oracle.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Chen, Luhai" <luhai.chen@intel.com>,
        "Zhu, Bing" <bing.zhu@intel.com>,
        "Wang, Kai Z" <kai.z.wang@intel.com>
References: <20200922052343.84388-1-yadong.qi@intel.com>
 <c0157014-d1bb-ef81-b92f-ebecb72396c9@redhat.com>
 <MWHPR11MB196858E9DC7AF08DC87E9261E3380@MWHPR11MB1968.namprd11.prod.outlook.com>
 <MWHPR11MB1968CD560E8BB15613F3EA73E3340@MWHPR11MB1968.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5019ebd5-4612-ae15-f976-a95000d0e1ad@redhat.com>
Date:   Sun, 27 Sep 2020 08:54:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB1968CD560E8BB15613F3EA73E3340@MWHPR11MB1968.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/20 03:51, Qi, Yadong wrote:
>> Subject: RE: [PATCH] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
>>
>>> Again, this looks good but it needs testcases.
>>
>> Yes, the unit test development is WIP.
>>
> 
> Hi, Paolo
> 
> I have sent out the unit test patch.
> https://patchwork.kernel.org/patch/11799305/
> Could you help review it? Thanks a lot.

Yes, I've seen it.  Tomorrow. :)

Paolo

