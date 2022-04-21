Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280A650A75E
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 19:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390909AbiDURvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 13:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390903AbiDURvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 13:51:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C64C49F90
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 10:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650563309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UaleRKtw0CvWp7uQEJvzfTdk7vmzg67w+yNSLXIT5VQ=;
        b=FBScBaDQiMsvlSaDK33prmopTdMwgSK4FO6JaE1qzdsdU9Vi6LLM7AmNA+TKnkfzsRoHDh
        zDPXqns/jmMABXVo/AXaR0kU7DTcjpNV5EdxX75PkS9Oek5EGMyiv4A9921A4G4rU2dkX2
        gp7Tzko2DYo1uaW+UhqyjFD5Qfbk84E=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-w9S8h197PbqVAKZmmY44Kg-1; Thu, 21 Apr 2022 13:48:28 -0400
X-MC-Unique: w9S8h197PbqVAKZmmY44Kg-1
Received: by mail-il1-f197.google.com with SMTP id i22-20020a056e021d1600b002cd69a8f421so897869ila.6
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 10:48:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UaleRKtw0CvWp7uQEJvzfTdk7vmzg67w+yNSLXIT5VQ=;
        b=CPdjZVk6dELSU95IvFuHe1D96HVlmaB3yhKeFLwLvATRJ3LAUXWNEVforoHkp2anF+
         tBP9d9GlZxG7TYzmLKjSADPS5qaVVXnsXikKbZSvoz2jOsdo2obGy12oumnFX1+PwxLT
         dl4lLxAfD0nQ617Khw8fpZ8rZd3A8ORRqI5d7AqGMjcZcRKizFIDvZ4P2dyUgyxDzLJU
         P0+0Ag9nds88l+s1ecOaoLwaX66dL+9PTg7XzMbmgXpI7yUZ/9phm869rmhb7uCVT+m2
         H7VWfvhB/W/HFg7MLGRuuSGKcdpppxfFpaB35QN0NJs+376etsy/tEoDfbpBfGULNUv7
         7UYw==
X-Gm-Message-State: AOAM531OUg27CUToe/5QAWpvGsP+2FsgLL4/mzBb6+1ouoZqm+WB9ttp
        b6kAdp+Q7z/ocSG8j/ktbQA7sNGuEhMEAFzLKYRTzlJCr+dENeOqTLBjn6rbXgUJko45J2v3May
        8Ojnh6EZyCl8i
X-Received: by 2002:a05:6602:1510:b0:657:277e:8096 with SMTP id g16-20020a056602151000b00657277e8096mr438107iow.152.1650563307485;
        Thu, 21 Apr 2022 10:48:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5vCKW+ck3Q+nGQNnYnBqI/+x27HmSTjNDsNLAV2dTFr6Ln0KKO7Q1Dpy7I982Jp7ovQLnXg==
X-Received: by 2002:a05:6602:1510:b0:657:277e:8096 with SMTP id g16-20020a056602151000b00657277e8096mr438096iow.152.1650563307265;
        Thu, 21 Apr 2022 10:48:27 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id b21-20020a056602331500b006572790ed8dsm3268006ioz.40.2022.04.21.10.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 10:48:26 -0700 (PDT)
Date:   Thu, 21 Apr 2022 13:48:24 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v6 05/10] KVM: selftests: Read binary stat data in lib
Message-ID: <YmGY6EXvw6tW+kPg@xz-m1.local>
References: <20220420173513.1217360-1-bgardon@google.com>
 <20220420173513.1217360-6-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220420173513.1217360-6-bgardon@google.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 20, 2022 at 10:35:08AM -0700, Ben Gardon wrote:
> Move the code to read the binary stats data to the KVM selftests
> library. It will be re-used by other tests to check KVM behavior.
> 
> No functional change intended.

I think there's a very trivial functional change...

> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  3 ++
>  .../selftests/kvm/kvm_binary_stats_test.c     |  7 ++--
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 36 +++++++++++++++++++
>  3 files changed, 41 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index fabe46ddc1b2..2a3a4d9ed8e3 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -403,6 +403,9 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
>  void read_stats_header(int stats_fd, struct kvm_stats_header *header);
>  struct kvm_stats_desc *read_stats_desc(int stats_fd,
>  				       struct kvm_stats_header *header);
> +int read_stat_data(int stats_fd, struct kvm_stats_header *header,
> +		   struct kvm_stats_desc *desc, uint64_t *data,
> +		   ssize_t max_elements);
>  
>  uint32_t guest_get_vcpuid(void);
>  
> diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> index 8b31f8fc7e08..59677fae26e5 100644
> --- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> +++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> @@ -160,11 +160,8 @@ static void stats_test(int stats_fd)
>  	size_data = 0;
>  	for (i = 0; i < header.num_desc; ++i) {
>  		pdesc = (void *)stats_desc + i * size_desc;
> -		ret = pread(stats_fd, stats_data,
> -				pdesc->size * sizeof(*stats_data),
> -				header.data_offset + size_data);
> -		TEST_ASSERT(ret == pdesc->size * sizeof(*stats_data),
> -				"Read data of KVM stats: %s", pdesc->name);
> +		read_stat_data(stats_fd, &header, pdesc, stats_data,
> +			       pdesc->size);
>  		size_data += pdesc->size * sizeof(*stats_data);
>  	}
>  
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 12fa8cc88043..ea4ab64e5997 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2615,3 +2615,39 @@ struct kvm_stats_desc *read_stats_desc(int stats_fd,
>  
>  	return stats_desc;
>  }
> +
> +/*
> + * Read stat data for a particular stat
> + *
> + * Input Args:
> + *   stats_fd - the file descriptor for the binary stats file from which to read
> + *   header - the binary stats metadata header corresponding to the given FD
> + *   desc - the binary stat metadata for the particular stat to be read
> + *   max_elements - the maximum number of 8-byte values to read into data
> + *
> + * Output Args:
> + *   data - the buffer into which stat data should be read
> + *
> + * Return:
> + *   The number of data elements read into data or -ERRNO on error.
> + *
> + * Read the data values of a specified stat from the binary stats interface.
> + */
> +int read_stat_data(int stats_fd, struct kvm_stats_header *header,
> +		   struct kvm_stats_desc *desc, uint64_t *data,
> +		   ssize_t max_elements)
> +{
> +	ssize_t size = min_t(ssize_t, desc->size, max_elements);
> +	ssize_t ret;
> +
> +	ret = pread(stats_fd, data, size * sizeof(*data),
> +		    header->data_offset + desc->offset);
> +
> +	/* ret from pread is in bytes. */
> +	ret = ret / sizeof(*data);
> +
> +	TEST_ASSERT(ret == size,
> +		    "Read data of KVM stats: %s", desc->name);

... where we do the check with 8-bytes aligned now, so we'll stop failing
the case e.g. when pread() didn't get multiples of 8 bytes.

But not a big deal I guess.

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu

