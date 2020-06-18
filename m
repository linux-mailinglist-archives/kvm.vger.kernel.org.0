Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8C91FF152
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 14:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgFRMKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 08:10:54 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29597 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728293AbgFRMKv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Jun 2020 08:10:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592482250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4BhAaUF6WRGpfAqOkgZuOyPei4wEh9xi+t7koUmuvAc=;
        b=bT72Lgr4z/APp6qXEejfpdPKc0/It+6w2qGo2rROzfdSJB9sQJBO3BkIKlp/aCirwLmJpV
        tfD1eJB5Xl+Pb8o+S/N7FOPkY7KtJSv+9SctxdHK07zDXtC4Cf/VaHubqe+h0WywOOCsPT
        DRh0pJSeY6wsqcLuxyyca6D5bcIrGtE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-_Yoenr_2PHeD6GS7jGiFNA-1; Thu, 18 Jun 2020 08:10:48 -0400
X-MC-Unique: _Yoenr_2PHeD6GS7jGiFNA-1
Received: by mail-wr1-f72.google.com with SMTP id s17so2702987wrt.7
        for <kvm@vger.kernel.org>; Thu, 18 Jun 2020 05:10:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4BhAaUF6WRGpfAqOkgZuOyPei4wEh9xi+t7koUmuvAc=;
        b=X7AIx1YLDXzMaonDMEidmnSAkLGC8JcfOoizxywkOaYwlUWIaAqFmUQ3G4HSfO1vWr
         1Tcv9Mqz0wCbdEe/RcC3+a6BNeRg6MvO0bQXalQtK8HKjHbTrZxSiC5dQnOfBj9QcTqQ
         y7En9zh5dhgd4GbPJukTY6Spfu8vrVb0hJ4o1B3kbvZol6XeVeK3xNVDpMjIlYqhsaW6
         8GKDmu1ZxK39jryqXAKAexu3uJBbkr74XACvsPNsnkWLezJNFp8BeTKaSxEoBC5zA57G
         Kud0dwSpSeO9G6zmO1kH/ZOjSYw4jy/hMmUxRgFxiH+sE2vAjbrG1Gl0joCjEWepXUnv
         5AYQ==
X-Gm-Message-State: AOAM5331mGqppJTZKKNENCc/GlHQhx+C1IlfmrH7g/cYFFlPD8iMOguY
        LZnE6abKi7P/28HSA3iEqB/nbdVWaEvxCQs1e3mJYrKleyFQM8B5VWyPHNfLNJB5TdGpV6/flTs
        ioAA6dPgT92UK
X-Received: by 2002:a5d:40d0:: with SMTP id b16mr4250703wrq.218.1592482247103;
        Thu, 18 Jun 2020 05:10:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlOURfKaDjxjqlQ0vKZlW8yVK31olTXINWGcAm3/4sIVpqW7bYXbgEMjhaOzE3wXvRfqKE0Q==
X-Received: by 2002:a5d:40d0:: with SMTP id b16mr4250675wrq.218.1592482246764;
        Thu, 18 Jun 2020 05:10:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e1d2:138e:4eff:42cb? ([2001:b07:6468:f312:e1d2:138e:4eff:42cb])
        by smtp.gmail.com with ESMTPSA id s18sm3928028wra.85.2020.06.18.05.10.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 05:10:46 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: SVM: emulate MSR_IA32_PERF_CAPABILITIES
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <like.xu@linux.intel.com>, linux-kernel@vger.kernel.org
References: <20200618111328.429931-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <adc8b307-4ec4-575f-ff94-c9b820189fb1@redhat.com>
Date:   Thu, 18 Jun 2020 14:10:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200618111328.429931-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/06/20 13:13, Vitaly Kuznetsov wrote:
> state_test/smm_test selftests are failing on AMD with:
> "Unexpected result from KVM_GET_MSRS, r: 51 (failed MSR was 0x345)"
> 
> MSR_IA32_PERF_CAPABILITIES is an emulated MSR on Intel but it is not
> known to AMD code, emulate it there too (by returning 0 and allowing
> userspace to write 0). This way the code is better prepared to the
> eventual appearance of the feature in AMD hardware.
> 
> Fixes: 27461da31089 ("KVM: x86/pmu: Support full width counting")
> Suggested-by: Jim Mattson <jmattson@google.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/svm/pmu.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)

This is okay and I'll apply it, but it would be even better to move the
whole handling of the MSR to common x86 code.

Paolo

