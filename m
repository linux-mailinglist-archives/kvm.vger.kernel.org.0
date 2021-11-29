Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6642746266E
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbhK2WwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbhK2Wui (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:50:38 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5DCC125CFD;
        Mon, 29 Nov 2021 10:28:31 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id e3so75887146edu.4;
        Mon, 29 Nov 2021 10:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MB3GFFeOjtyBnMUEQAUlH0fE3HvRWrSglqVldeRNkTI=;
        b=NF66YJGu+z/q6t7oa19NAuq1tMHmcimI4KQHfoHawnz7oMeBmi2xajBtfAWXSd8k/0
         Y6BpBdbWc5Jv1jb+O9uiIEmkE42VYUJh4CB47+XcmyOpgoAVku4YvxVxt2hPeam/H7Pc
         +GTW7uuRFtNtFy3Xt+1l9/q2ytjf88eYEaTwEfPwIlQmcb5TadAxMSadsB6pni4Osbco
         ee5GYmpk77zhPqWHFJ09p3isaZ1fpCo7QsxAhTWcGRKD/4Rk44BVfU29qYXoMfgm3wOe
         kylDPEoXdokdXSi39AY80LEKpW7pZIUZCh1FwgmngPaxqpkKEDnRpSq4iSNmv9Ei5lpv
         cWpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MB3GFFeOjtyBnMUEQAUlH0fE3HvRWrSglqVldeRNkTI=;
        b=rLvkqoOiU1cIiQ8+eA9efR7p1KWCySV5a6W1yQT/yWzfK71xpindwp3mNEsnsn7GPK
         X5nv6nROaa0KagUw4sOxDJr0hZvaJpGAX6I3Ky+VvPtIoe9NKfnbEgSEU1aSijCW1yx4
         Hg8bOW90Y6QAqA6xvWJpZhcxwfA9U3RDx3CaaceWluE0ecyhbe9BcA0hcC2qIjcSv9hy
         kq6AClyc9aqmvID8rp0K2WCzffBYUtmB/GEx/8jkVcbpkrJnxYDgzo4Ads+d4pCHGGIh
         IkQqbGpqDSVd+ZLJ4pvuk6uPlrnDRsObITizZm0HNZcTYf03pGDF8FkBUV5iBsFpwsU/
         K8TA==
X-Gm-Message-State: AOAM532FQ4qgqxfHd5Uy1eZBnQhfc3JbEvaLaz7hwFocezFjp/FTJmha
        AUwiFetozz+x6jSbTwKsXWY=
X-Google-Smtp-Source: ABdhPJxUspOAr8cup2peU+OssossYU8fTUj+vYaMlORw+5h6Q/4s74Vn3mi5m9YJQwKF7ZS4d76B/g==
X-Received: by 2002:a05:6402:440b:: with SMTP id y11mr77775749eda.25.1638210510386;
        Mon, 29 Nov 2021 10:28:30 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id e7sm10108660edk.3.2021.11.29.10.28.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 10:28:29 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <39b21ede-5d53-0545-631e-165df9ecb7f5@redhat.com>
Date:   Mon, 29 Nov 2021 19:28:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v3 46/59] KVM: VMX: Move register caching logic to
 common code
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, isaku.yamahata@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <2f3c1207f66f44fdd2f3eb0809d552f5632e4b41.1637799475.git.isaku.yamahata@intel.com>
 <87mtlshu66.ffs@tglx> <620e127f-59d3-ccad-e0f6-39ca9ee7098e@redhat.com>
 <YaUaqTfzSUB2tpkR@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YaUaqTfzSUB2tpkR@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/29/21 19:23, Sean Christopherson wrote:
>>>> Only one generation of CPU, Nehalem, supports EPT but not
>>>> unrestricted guest, and disabling unrestricted guest without also
>>>> disabling EPT is, to put it bluntly, dumb.
>>> This one is only significantly better and lacks an explanation what this
>>> means for the dumb case.
>> Well, it means a retpoline (see paragraph before).
>
> No, the point being made is that, on a CPU that supports Unrestricted Guest (UG),
> disabling UG without disabling EPT is really, really stupid.

Yes, I understand that.

Thomas was asking what it means to "Move register caching logic to 
common code", i.e. what the consequences are.  The missing words at the 
end of the first paragraph didn't make the connection obvious between 
the extra retpoline and the "dumb case".

Paolo
