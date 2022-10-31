Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6112F613E15
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 20:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiJaTRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 15:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiJaTRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 15:17:41 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B339C120BD
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 12:17:40 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id k5so3638032pjo.5
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 12:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vZbAd2QA8PXpbAfUALwUz+wT1/AJE5gljoRSaVW/H/A=;
        b=IZwtfOLa81No8jysJfcSE6yAo+lZTl5uNnsu9/RBJGA9DpqQjChb+sLxyjI6mejXl4
         X88zenLYMA66cj8jyJy3IPvz2cYY76sH9adW7ILMAQn9K5HvCnGI/yh+gEjBo04fMUZp
         VhtoycWNEWtQMUwzxtowxke7xyOKrLSJUSvXojqeb9sw2Q11zC+wHks066KMufhqtbNm
         g3Ed3as5+6QtPsS1DvKe2VYM7A1nHhVzA5pK5/5RSlQUJKlfbbEVJy3yzqs8o5KWTdrg
         5vvCHWW3syyejZKx/9xdaUuHtq1dUzQkwEggLbkZvSZ2zUutJprXDg+kkynt/ZY6d0HY
         PAHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vZbAd2QA8PXpbAfUALwUz+wT1/AJE5gljoRSaVW/H/A=;
        b=730Bq2QrugCdDfJv5nTpiHvFcKqiQieCNdqzLmVfE1SipgnFCn0jxptVNwxAgFlxku
         XuvbKu6cqSyFWTp9QrbMXsKhhc5FVt5lkY1kQYywsdbDT1qlcWlWtrcTedXucp99MQEW
         DU/jQXH3VNOVV/tzGj5uDJdC77MIOp8KfwE0k1Tnpw1/NjmGQMBHm9rKIWMZS6TGzUDh
         OfBuOxPxpoqFarfc1kAW1I4b1rKuZfJ8s3kDG3Gen5gUnI0DeofIyqqCdcbtVP5HHD6r
         UAE+fiMiA8R9gWq9MmJXnYtcxt7OnyVS5zUJddAyhmFVhsIWZfXrr1siviSeSkne7I+k
         lBbA==
X-Gm-Message-State: ACrzQf0VymbPBLb5avhavjD8L1p9Puvmg38NtfcYwzWRRvS7eW2mVvCm
        V3ZAjj/AlmehMQvfgcH2Yu5ukw==
X-Google-Smtp-Source: AMsMyM5cp8SOrjs7jI9E89Ce0bk8MtV50GzNv4Smu8P5Zx9SieEPJaHzMpo3jWe8dH8Q7gGBcUYmSw==
X-Received: by 2002:a17:903:2cf:b0:186:61b8:84d3 with SMTP id s15-20020a17090302cf00b0018661b884d3mr15983274plk.34.1667243860148;
        Mon, 31 Oct 2022 12:17:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id bc11-20020a656d8b000000b00462612c2699sm4477627pgb.86.2022.10.31.12.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 12:17:39 -0700 (PDT)
Date:   Mon, 31 Oct 2022 19:17:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 3/5] KVM: selftests: Add atoi_paranoid() to catch
 errors missed by atoi()
Message-ID: <Y2AfUKJ19yZrlHzN@google.com>
References: <20221031173819.1035684-1-vipinsh@google.com>
 <20221031173819.1035684-4-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031173819.1035684-4-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 31, 2022, Vipin Sharma wrote:
> atoi() doesn't detect errors. There is no way to know that a 0 return
> is correct conversion or due to an error.
> 
> Introduce atoi_paranoid() to detect errors and provide correct
> conversion. Replace all atoi() calls with atoi_paranoid().
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index 6d23878bbfe1..ec0f070a6f21 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -334,3 +334,22 @@ long get_run_delay(void)
>  
>  	return val[1];
>  }
> +
> +int atoi_paranoid(const char *num_str)
> +{
> +	char *end_ptr;
> +	long num;
> +
> +	errno = 0;
> +	num = strtol(num_str, &end_ptr, 10);

I take back my review.  This forces specifying params in decimal, e.g. a large
hex number yields:

  strtol("0xffffffffff") failed to parse trailing characters "xffffffffff".

Obviously I'm intentionally being a bad user in this particular case, but there
will inevitably be tests that want to take hex input, e.g. an x86 test that takes
an MSR index would definitely want hex input.

Looking through all selftests, I don't think there are existing cases that would
likely want hex, but it's trivial to support since strtol() will autodetect the
format if the base is '0', i.e.

diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 210e98a49a83..8c37cfa12edc 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -341,7 +341,7 @@ int atoi_paranoid(const char *num_str)
        long num;
 
        errno = 0;
-       num = strtol(num_str, &end_ptr, 10);
+       num = strtol(num_str, &end_ptr, 0);
        TEST_ASSERT(!errno, "strtol(\"%s\") failed", num_str);
        TEST_ASSERT(num_str != end_ptr,
                    "strtol(\"%s\") didn't find a valid integer.\n", num_str);
