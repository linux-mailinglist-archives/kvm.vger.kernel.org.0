Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 871B4D8CB7
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 11:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404244AbfJPJko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 05:40:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48522 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732698AbfJPJkn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 05:40:43 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D051281F07
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 09:40:42 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id k4so11462893wru.1
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 02:40:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ErxuLlMobmLYC74NaNqAt2F8x+RQ/6BqJJt5ZsK39jA=;
        b=gsIsiNJMy36hLcXz0a4FBnOe1RN6ygaUZeeIYaCLKFxKv4TImWumvYwvrkzb7yVZAR
         hbdFMxdFinSF+kTvXiN1fIOZt2BnsC7mGXz3C0QK8h9/OLxsPzEPYS55uqQLLL0Pjffb
         0aPgYZYJKhvB5mfSndS0/pHroe6vqcy5eCKGjv1DjWhpbecdaJjMjBga7hvdzbT0/A73
         rLbM8a6sIEGLY0trDmac0FeUhY6qyy70n4uxP0U0e/qiUMz3dUYH5d9mSds3D0k/oDIA
         R/3dp3N132EvU4OK6BHI76UzN1jbpj1czvKm0bN4QhpwsjAEHy2VM0vMjn6c+MsHl8Lr
         Q28w==
X-Gm-Message-State: APjAAAUC72ZB8vY33PCg+yxqYsU0zfcCIvWED6dTTHD9tqqeQB3nht5f
        6HLuI8uDGr3Q4hG00BpcD+Cgl/NhCgM5xS0fkrDcvL+Wd2g0cmdhPNhI4pPD5WKbQqSTVtK38W/
        dmCmsYZXrKUj9
X-Received: by 2002:a1c:ac02:: with SMTP id v2mr2393738wme.85.1571218841236;
        Wed, 16 Oct 2019 02:40:41 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwsJxy70cLYMoF7l/VW8chmnZNzKQwU5PYQpVT7wXPSuA+YQf+PmLNyOibMuk/B0bQQL+t13g==
X-Received: by 2002:a1c:ac02:: with SMTP id v2mr2393719wme.85.1571218840942;
        Wed, 16 Oct 2019 02:40:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e? ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
        by smtp.gmail.com with ESMTPSA id f143sm3441248wme.40.2019.10.16.02.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 02:40:40 -0700 (PDT)
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
 <1560897679-228028-10-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de>
 <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de>
 <20190925180931.GG31852@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com>
Date:   Wed, 16 Oct 2019 11:40:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190925180931.GG31852@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/19 20:09, Sean Christopherson wrote:
> We're trying to sort out the trainwreck, but there's an additional wrinkle
> that I'd like your input on.

That's not exactly a wrinkle...

>   - Remove KVM loading of MSR_TEST_CTRL, i.e. KVM *never* writes the CPU's
>     actual MSR_TEST_CTRL.  KVM still emulates MSR_TEST_CTRL so that the
>     guest can do WRMSR and handle its own #AC faults, but KVM doesn't
>     change the value in hardware.
> 
>       * Allowing guest to enable split-lock detection can induce #AC on
>         the host after it has been explicitly turned off, e.g. the sibling
>         hyperthread hits an #AC in the host kernel, or worse, causes a
>         different process in the host to SIGBUS.
> 
>       * Allowing guest to disable split-lock detection opens up the host
>         to DoS attacks.
> 
>   - KVM advertises split-lock detection to guest/userspace if and only if
>     split_lock_detect_disabled is zero.
> 
>   - Add a pr_warn_once() in KVM that triggers if split locks are disabled
>     after support has been advertised to a guest.
> 
> Does this sound sane?

Not really, unfortunately.  Just never advertise split-lock detection to
guests.  If the host has enabled split-lock detection, trap #AC and
forward it to the host handler---which would disable split lock
detection globally and reenter the guest.

Paolo
