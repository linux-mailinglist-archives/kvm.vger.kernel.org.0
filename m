Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0213E477E55
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 22:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241668AbhLPVIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 16:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241679AbhLPVHk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 16:07:40 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440AFC061763;
        Thu, 16 Dec 2021 13:07:39 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id o20so189825eds.10;
        Thu, 16 Dec 2021 13:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DUsG7i+wY0cUZ+8DrLfOWNVbBEitgU4m1Cwk5onux8Y=;
        b=jzMp6jsjqmJNX/zi69ytKA63hbBJDeKmOdDohISpycSsySqly/zgFJVqCAJMcivA4K
         7wWarZ3t3yxvyyMIPB+D8rmw7gj8wlm0WuMMw4lBXcXDFyT5BAhKXSAXCK9icyTA3lJC
         fy7U5Nf6Y0wp854pDF+8AwzLA4g257rwujwNjI6byREFOVpAnfsjCn9DuK0KdUjLE5nc
         b3MKtx+HgBsWnxgfgMwenfLMijcMJvz+bh84WeDhkWzpwiXG/Yy/is5zcYe/3tKC48QH
         yRsRzuroUcTuqYT2Jp2HspvYak3RxItRUHDj5Vr7RuuzyZ+wqrjLfAHTOMqSn/VpvcnN
         kUyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DUsG7i+wY0cUZ+8DrLfOWNVbBEitgU4m1Cwk5onux8Y=;
        b=iDyn5DOSV04H/0TzyaUjjMHOsBB0Htiyp5KLeHB9sJl6HnDWxST0I1zMAjpbYGh37z
         HH0NRS3gjp4UH4HtLBhF+CpfmqEeqlpCzlmpYzU+w95RharcWPht7Moyt7DAdVZu+7HZ
         wxHH8sjsvcgwNLYIQKhFhknuqnhCTlBQjMuUxkuUqcKx0gkYv+NIGIFAC2YaA0YDvwnP
         1qQ/3ByBoxrKXhek2es4LeruQzXd/9MKsekmaCQceFYnGTp60P8J9K148XfN0IcxikeB
         /UwvgsWGusD+6/T4Rb8wVo8Pd1Lq8ddbgzphkBSJgT4nMjWHhM2sWDBKXGZ7QV7+DLCu
         BArQ==
X-Gm-Message-State: AOAM532/Ju/eIY4CnvMF7D0Zl6u3U44utvcFcZIwlWY5FXu23cVplqij
        6eCkls+r3VxMtFm/A1tb/Tg=
X-Google-Smtp-Source: ABdhPJwnvkg9z98TGfzR+eFnmte79e1Y7FtCspULcPkMlomkqJ/7Cuk9ApIMwZmEOC5HaOGgHIkX+A==
X-Received: by 2002:a17:907:6d99:: with SMTP id sb25mr17027829ejc.261.1639688857807;
        Thu, 16 Dec 2021 13:07:37 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id l16sm257364eds.63.2021.12.16.13.07.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 13:07:37 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <6ce0aca5-5f5d-c21f-441f-c2db852b65e0@redhat.com>
Date:   Thu, 16 Dec 2021 22:07:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "quintela@redhat.com" <quintela@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
 <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
 <b3ac7ba45c984cf39783e33e0c25274d@intel.com> <87r1afrrjx.ffs@tglx>
 <87k0g7qa3t.fsf@secure.mitica> <87k0g7rkwj.ffs@tglx>
 <878rwm7tu8.fsf@secure.mitica> <afeba57f71f742b88aac3f01800086f9@intel.com>
 <878rwmrxgb.ffs@tglx> <a4fbf9f8-8876-f58c-d2b6-15add35bedd0@redhat.com>
 <8f37c8a3-1823-0e8f-dc24-6dbae5ce1535@redhat.com>
 <BN9PR11MB5276F8C1F89911D4E04F8A9C8C779@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <BN9PR11MB5276F8C1F89911D4E04F8A9C8C779@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/21 06:36, Tian, Kevin wrote:
> 2) Do expansion at vCPU creation or KVM_ SET_CPUID2?
> 
> If the reallocation concept is still kept, then we feel doing expansion in
> KVM_SET_CPUID2 makes slightly more sense. There is no functional
> difference between two options since the guest is not running at this
> point. And in general Qemu should set prctl according to the cpuid bits.
> But since anyway we still need to check guest cpuid against guest perm in
> KVM_SET_CPUID2, it reads clearer to expand the buffer only after this
> check is passed.

Yes, that makes sense to me as well.  In principle userspace could call 
prctl only after KVM_CREATE_VCPU.

> 
> One option is to always disable WRMSR interception once 
> KVM_SET_CPUID2 succeeds, with the cost of one RDMSR per vm-exit. 
> But doing so affects legacy OS which even has no XFD logic at all.
> 
> The other option is to continue the current policy i.e. disable write 
> emulation only after the 1st interception of setting XFD to a non-zero 
> value. Then the RDMSR cost is added only for guest which supports XFD.

For this I suggest to implement the current policy, but place it at the 
end of the series so it's easy to drop it.

Paolo
