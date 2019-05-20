Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB1CE230D4
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 11:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbfETJ6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 05:58:34 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39366 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730209AbfETJ6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 05:58:33 -0400
Received: by mail-wr1-f67.google.com with SMTP id w8so13855920wrl.6
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 02:58:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JVX6gPsrTfTmuCUUF5HGp9mgh5XhxV0UDCSIyVUX2pU=;
        b=t5eTxk8WE3Fkl3wgQWEpaL+GFnQz66xvblHq5pYHQv7PgqTyk0OTghaKsddv7HPhBZ
         DOSXhLm5GOFX4b+dFRIMEm3t1dgnFKx74pZj7ULOuiueH1g8EO/F8zgs0LHrbZYVRcg1
         8r2BMs1Mxfo6XTSa0dAKHSZgWfGIktKYkgIR1wh9K1mbnZpBoiWfTfzPf2vFyWRKo4oI
         lpOKV9TSieOsiWHdcjc0xduVM50rYrYfU60EovoPgDGBcKx7zR/kwAcC+giEN9Ri7NlI
         FaPbeoj+7Wm3lZE3+ggNxsGiT1TX0rKn1vArxSEutut7QoherGNB6uKg1h81amyeGi+v
         niVQ==
X-Gm-Message-State: APjAAAV0ZT23HYW+KycDuqVKSLqHzIwPARqBE//YiZd94rUXCBLWGq+z
        kiqBxPLkDwgU503Kbeem+sF8Vg==
X-Google-Smtp-Source: APXvYqyX+/koAl8XVvzNRVRQDgM/pyryMi4qE9o/3q6ykq4c2PuK+wPoPcWKF4qxruA4OZxBGgrJBA==
X-Received: by 2002:adf:e908:: with SMTP id f8mr13645789wrm.124.1558346312200;
        Mon, 20 May 2019 02:58:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id u2sm26180540wra.82.2019.05.20.02.58.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 02:58:31 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: Fix a condition in test_hv_cpuid()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20190514103451.GA1694@mwanda>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4bb7a5d3-887f-8487-e8f3-70770312517a@redhat.com>
Date:   Mon, 20 May 2019 11:58:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190514103451.GA1694@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/05/19 12:34, Dan Carpenter wrote:
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
> @@ -58,9 +58,8 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
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
> 

Queued, thanks.

Paolo
