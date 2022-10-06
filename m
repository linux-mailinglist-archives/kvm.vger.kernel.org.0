Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F89A5F6E84
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 21:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbiJFT6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 15:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiJFT6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 15:58:31 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE97A879E
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 12:58:30 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q9so2761104pgq.8
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 12:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IXlZwi8tQbkf9JfbcZapOF4ed3WL+b+3X/IWlS/eJJk=;
        b=b0Rh4NehN3Ua78YBcPYsHQRHI+cXa2P38z4vFCn4EMumhVLD2gUkUUhcbmW1jpw5+3
         gC5tR1DMA2PS5HxUv2ZXHMsqJ1fwo6eQ2Uebuv+eMiFXUrCdYQ6Q/VWq2Y3gIeMDwCi0
         42VckS5DcH0tcv9cTSkkKLL5jAdpvS36C0KXOqLDf4Bvat0FxppBmfuXMe7uCKWsbBsP
         u5TNBQEgUm1vHyC0ACFGiusSqsx7ye3p6DYfKWJhUgbcQnVxoFX80oqAP1GoK+RBiYco
         tNJLhdJcUvv5BnSTZJVoajzXd0V2HQ0k1nwH7rYOFe1YhVG1IMl3zNWW9qUDxQCDU6wE
         PFiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IXlZwi8tQbkf9JfbcZapOF4ed3WL+b+3X/IWlS/eJJk=;
        b=pv1J7MEMlyOH1wNDyZ7zLlL5HVK34NWn4IZFdvOW3JwHXCd2wnSbKxi8AIMo0HHopg
         cs/w82ZI1dqdMickJZLCETzT6xkWe8+whogkYaNN3pSrkUMUb9DzzKiEfQN3YNjCbs0l
         Yjwd9GrdeQliLH0rsFxT4jPIXM88SsepJOJGORKYT/+G3aLcK3+xEV+qRZtBwtcbmEbt
         tRgsgZjHu77WWt/0Q8w9HayqCN+nWlV1mfxLpKcjpItxY8+kv0Z0pHzcy87M+kegcFfs
         GAuWX7qGzFxo1kOHfIl3HWQX/hztf5ndgBa1P4BoM7eXlkFtSe30h9ygqEK2Sm9pSlkA
         U2uw==
X-Gm-Message-State: ACrzQf0snNvKUWMXbb79N5oyO4JffHNoJD0h0JffsMB4gi7Z0rVYLOFS
        ciihq4edtISBavTtW5Gk/+t4Bw==
X-Google-Smtp-Source: AMsMyM7NRiApVi3AWDuHyOSLddOe4w1fQiDb+pletF5e3gBtmvRoFD4jVaQfg4IWWzKnlbXPmfbWBA==
X-Received: by 2002:a05:6a00:1249:b0:543:aa0a:9c0a with SMTP id u9-20020a056a00124900b00543aa0a9c0amr1174972pfi.2.1665086309546;
        Thu, 06 Oct 2022 12:58:29 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f14-20020a17090a4a8e00b0020b092534fbsm102727pjh.40.2022.10.06.12.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 12:58:28 -0700 (PDT)
Date:   Thu, 6 Oct 2022 19:58:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] KVM: selftests: Add atoi_paranoid() to catch
 errors missed by atoi()
Message-ID: <Yz8zYXvhp9WGH4Uz@google.com>
References: <20221006171133.372359-1-vipinsh@google.com>
 <20221006171133.372359-4-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221006171133.372359-4-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 06, 2022, Vipin Sharma wrote:
> +int atoi_paranoid(const char *num_str)
> +{
> +	int num;
> +	char *end_ptr;

Reverse fir-tree when it's convention:

	char *end_ptr;

> +
> +	errno = 0;
> +	num = (int)strtol(num_str, &end_ptr, 10);
> +	TEST_ASSERT(!errno, "strtol(\"%s\") failed", num_str);
> +	TEST_ASSERT(num_str != end_ptr,
> +		    "strtol(\"%s\") didn't find any valid number.\n", num_str);

s/number/integer ?  And should that be "a valid intenger", not "any valid integer"?
"any" implies that this helper will be happy if there's at least one integer,
whereas I believe the intent is to find _exactly_ one integer.

> +	TEST_ASSERT(
> +		*end_ptr == '\0',

Weird and unnecessary wrap+indentation.

> +		"strtol(\"%s\") failed to parse trailing characters \"%s\".\n",
> +		num_str, end_ptr);
> +
> +	return num;
> +}
> diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
> index 9a6e4f3ad6b5..1595b73dc09a 100644
> --- a/tools/testing/selftests/kvm/max_guest_memory_test.c
> +++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
> @@ -193,15 +193,15 @@ int main(int argc, char *argv[])
>  	while ((opt = getopt(argc, argv, "c:h:m:s:H")) != -1) {
>  		switch (opt) {
>  		case 'c':
> -			nr_vcpus = atoi(optarg);
> +			nr_vcpus = atoi_paranoid(optarg);
>  			TEST_ASSERT(nr_vcpus > 0, "number of vcpus must be >0");

Many users require a positive and or non-negative value, maybe add wrappers in
a follow-up?

			nr_vcpus = atoi_positive(optarg);

and later down

			targs->tfirst = atoi_non_negative(optarg);

We'll lose custom error messages, but I don't think that's a big deal.  Definitely
not required, just a thought.

> diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
> index 0d55f508d595..c366949c8362 100644
> --- a/tools/testing/selftests/kvm/set_memory_region_test.c
> +++ b/tools/testing/selftests/kvm/set_memory_region_test.c
> @@ -407,7 +407,7 @@ int main(int argc, char *argv[])
>  
>  #ifdef __x86_64__
>  	if (argc > 1)
> -		loops = atoi(argv[1]);
> +		loops = atoi_paranoid(argv[1]);

This is a good candidate for atoi_positive().

>  	else
>  		loops = 10;
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> index 59ffe7fd354f..354b6902849c 100644
> --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> @@ -241,10 +241,10 @@ int main(int argc, char **argv)
>  	while ((opt = getopt(argc, argv, "hp:t:r")) != -1) {
>  		switch (opt) {
>  		case 'p':
> -			reclaim_period_ms = atoi(optarg);
> +			reclaim_period_ms = atoi_paranoid(optarg);
>  			break;
>  		case 't':
> -			token = atoi(optarg);
> +			token = atoi_paranoid(optarg);
>  			break;
>  		case 'r':
>  			reboot_permissions = true;
> -- 
> 2.38.0.rc1.362.ged0d419d3c-goog
> 
