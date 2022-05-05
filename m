Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA0451C6BA
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382988AbiEESKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382972AbiEESJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:09:59 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B409F54BF6
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 11:06:18 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id z5-20020a17090a468500b001d2bc2743c4so4813333pjf.0
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 11:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=csa5Mj5E+ZKvHVZb+3IE/GuCgzkqVA+V6IRZnVKxYjQ=;
        b=BDoPQjE5lYzOYbFxxPfMObdUUb96/hnlzMC2QQ3J9l8h+pnj7Akud0FVhawwEah6R2
         NtYhsKmxx7l2g8bQrYlZ2iHixqIqRhvXrDqjQAAaDtErX4k1eQ2ccAFSuEa+2jVL7RR8
         fDbSJ76yzER0JwcZVw7fzLN5KkV/V3hRa2RFgmuDBXgj9zdge/MdYmLaFFET1+dfTglS
         I6T8gyYdDI58sHz0V9F6duONXsoeCNJy5+5CYd+vu++4guK+roeUCnxPyTOHRf32oq5w
         NGT+/AXzUaKPKT5atnwbCpk19p5KUrGrn9vT6xwMtAX7ZJN21ZKSproidUMh93/oQg6o
         Cxlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=csa5Mj5E+ZKvHVZb+3IE/GuCgzkqVA+V6IRZnVKxYjQ=;
        b=iYORnFl20OmDbMZqWSYUzq/nMP3Zgx2YGfvPSDxzc2NgdJvjQ1Rc3eUFGH0PEHxzjP
         SzytXPibcPYTrqr/Z9Jevjz3Ssn5YIESch1Jk38X/VbwbE2TRFlJ+QAHtKSW4h7g4t4I
         O0BHCYdW099tEOmL2TCIpZo4HPvcDMDWzuaUuqejVo2gBR4byh0Yqvq7UFaa4s+VCk8O
         95PMJVURSZecU5SMMlTOh1YLye+Gx5lY/PX+n7C0jUW7QLCRvw+kFpG7fcoTdnuhNOGl
         0Ma6bgwHsnVxYYEjjZYgpAImyKPpSiwI8fpat79xEm1dBoVKR1m+DqX8bsCU7+0oQylW
         EspA==
X-Gm-Message-State: AOAM53149Mm0cAdlAbfJrg056HqA2Dj0hWPgpMOJj8eceNUQhFPMfiqF
        am+p/AWm/Hg252QRZfXFJwCqZw==
X-Google-Smtp-Source: ABdhPJwNktaPZjslvuxXyp8B21Tg5wZCqPH78HxSFnAeo0EZwJhjpESx7WUTNVNgOEdA6HqZWY1BZg==
X-Received: by 2002:a17:90b:4a4e:b0:1dc:55ca:6f33 with SMTP id lb14-20020a17090b4a4e00b001dc55ca6f33mr7653761pjb.4.1651773978039;
        Thu, 05 May 2022 11:06:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d133-20020a621d8b000000b0050dc7628196sm1671225pfd.112.2022.05.05.11.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 11:06:17 -0700 (PDT)
Date:   Thu, 5 May 2022 18:06:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v7 05/11] KVM: selftests: Read binary stat data in lib
Message-ID: <YnQSFmNArNUMs9/U@google.com>
References: <20220503183045.978509-1-bgardon@google.com>
 <20220503183045.978509-6-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503183045.978509-6-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 03, 2022, Ben Gardon wrote:
> Move the code to read the binary stats data to the KVM selftests
> library. It will be re-used by other tests to check KVM behavior.
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
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

Not your code, but updating size_data is pointless and confusing.  It's especially
confusing as of this patch because it ignores the return read_stat_data().  I vote
to opportunistically delete this code.

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

This is a lie, it can never return -ERRNO.  Well, unless the caller is mean and
passes in -EINVAL for max_elements I guess.

> + *
> + * Read the data values of a specified stat from the binary stats interface.
> + */
> +int read_stat_data(int stats_fd, struct kvm_stats_header *header,
> +		   struct kvm_stats_desc *desc, uint64_t *data,
> +		   ssize_t max_elements)

Uber nit, @max_elements should be unsigned size_t, only the return from pread()
is signed, the input is unsigned.

> +{
> +	ssize_t size = min_t(ssize_t, desc->size, max_elements);

Not your fault (I blame struct kvm_stats_desc), but "nr_elements" would be far
more appropriate than "size".  And that frees up "size" to be the actual size,
which eliminates the division.

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

It'd be very helpful to print the expected vs. actual.

> +
> +	return ret;

Eww.  I really, really hate code that asserts on a value and then returns that
same value.  E.g. looking at just the declaration of read_stat_data() and the
change in stats_test(), I genuinely thought this patch dropped the assert.  The
assert in vm_get_stat() also added to the confusion (I was reviewing that patch,
not this one).

Rather than return the number of entries read, just assert that the number of
elements to be read is non-zero, then vm_get_stat() doesn't need to assert because
it'll be impossible to read anything but one entry without asserting.

void read_stat_data(int stats_fd, struct kvm_stats_header *header,
		    struct kvm_stats_desc *desc, uint64_t *data,
		    size_t max_elements)
{
	size_t nr_elements = min_t(size_t, desc->size, max_elements);
	size_t size = nr_elements * sizeof(*data);
	ssize_t ret;

	TEST_ASSERT(size, "No elements in stat '%s'", desc->name);

	ret = pread(stats_fd, data, size, header->data_offset + desc->offset);

	TEST_ASSERT(ret == size,
		    "pread() failed on stat '%s', wanted %lu bytes, got %ld",
		    desc->name, size, ret);
}

