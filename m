Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECA11C952
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 15:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfENNW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 09:22:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42253 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbfENNW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 09:22:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id l2so19191360wrb.9
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 06:22:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=uFHSJsNByyay2Kmq9r271hEwxa2SlTHGMXGEWSzHBMI=;
        b=g9ARIGOwWpshAOtltGl+lDSSZ/T4U4pdjE3sgXWJmDai8ZncZBjTlNSIP/lmPQAlSf
         A1y5jkphxYHejkfR+96SvKXc0DDyHp7PUQjpyhGWgcV8Jl1qIRlRqdUvPOowPgdYfasX
         ZQFayzNAlchJ543Pmrmz2AUtu/VuCe22neiU45JQ0QUmUybQPZbfuKcSOMA6Cn5CLSvD
         9FRPqJwtr0VkVMA93Uy3ePCf+nwX9cOQVRxsg02kupBXOS4AUmT955iu+BGHMJ4Iduof
         2AQUUPjOpt/FuKPse/sbEl0l5YpvBb42hOdnpgfyDp0rd3sw7NPMGoP6mLDt10EL56JN
         WrDg==
X-Gm-Message-State: APjAAAVd/ZVV6cqQ1DOGBqcBOHfOnhWSLHOsyTQThbp8N41fXfLtm24t
        /HlKu4HJ7dbqmpEB6eBDd1bkTtT7Rs0=
X-Google-Smtp-Source: APXvYqzLA7DdgWaapFTZmwqb7mHH3YTIXbyeudVVfoFPH8Bo3tN3uBaZw6hz9LJ9L3lpSlUDwHsiVA==
X-Received: by 2002:adf:ce90:: with SMTP id r16mr22028791wrn.156.1557840177629;
        Tue, 14 May 2019 06:22:57 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id s22sm4289095wmh.45.2019.05.14.06.22.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 06:22:56 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Fix a condition in test_hv_cpuid()
In-Reply-To: <20190514103451.GA1694@mwanda>
References: <20190514103451.GA1694@mwanda>
Date:   Tue, 14 May 2019 09:22:56 -0400
Message-ID: <87lfz9npan.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> The code is trying to check that all the padding is zeroed out and it
> does this:
>
>     entry->padding[0] == entry->padding[1] == entry->padding[2] == 0
>
> Assume everything is zeroed correctly, then the first comparison is
> true, the next comparison is false and false is equal to zero so the
> overall condition is true.  This bug doesn't affect run time very
> badly, but the code should instead just check that all three paddings
> are zero individually.
>
> Also the error message was copy and pasted from an earlier error and it
> wasn't correct.
>
> Fixes: 7edcb7343327 ("KVM: selftests: Add hyperv_cpuid test")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> index 9a21e912097c..63b9fc3fdfbe 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> @@ -58,9 +58,8 @@ static void test_hv_cpuid(struct kvm_cpuid2
> *hv_cpuid_entries,

we also seem to check for 'entry->index == 0' twice here.

>  		TEST_ASSERT(entry->flags == 0,
>  			    ".flags field should be zero");
>  
> -		TEST_ASSERT(entry->padding[0] == entry->padding[1]
> -			    == entry->padding[2] == 0,
> -			    ".index field should be zero");
> +		TEST_ASSERT(!entry->padding[0] && !entry->padding[1] &&
> +			    !entry->padding[2], "padding should be zero");
>  
>  		/*
>  		 * If needed for debug:

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly
