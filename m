Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439994FCB92
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 03:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbiDLBGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 21:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351037AbiDLBAo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 21:00:44 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62BD2E9D8
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 17:55:00 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id u2so402268pgq.10
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 17:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZnYjR11gbYLeKCBoJXE7n0dD6k1+ZaVWjqJC494l/qo=;
        b=OxtnOilsm55GHwDHO1IO1CmDR6liEyJYEsYxqSRci+INpvWA+EBrPe+DTaMSBC2m1z
         nn770volbCNOSZAupt9b9igPVtXZXO58XljAHzuwRg3JCQ2fxQO2gDB87nGD4Si14mOA
         5hT5g8RhTy8LneiuVYgZPdOEDP4hR+qh9HB47Bx54pNQqrgC2hQOtI1C7WudE7yOpHU/
         KUX/G9Oo+OVYJJI//ScdHObW0sLduecpgNocjvMbPkcRe8omnuGeo0sAmQWENEWA+8Iu
         YCMMnnO7QM5J7mQ2FgOitQlrxGmNxwZI2y1Hmf+bYh/3aLzvSe/Kr0wK3JOIi02rpCcv
         CHrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZnYjR11gbYLeKCBoJXE7n0dD6k1+ZaVWjqJC494l/qo=;
        b=khBVSuo3YEmWbhHixpaOxdbohqabq5/Sp0TnNiPrmcd1CxockgNKVhu4YWZ3qoxunS
         Rl/gWm2D7iG6tESBwM2+OHuWwIzqvxpQMvpFgDH5O9mhC4xdhWMboIkeQtfOMwxjkwkd
         L8z6khWkbsldQn3kPphnbVmvlU6Lig/WcVWFthhgOKU8VhVLW7EDhzeo2m1EbZuCGLP+
         6Xv3la5f97rQ5hU/pEIMrb5lcigRTMzNbzM5fsDWcWVG3AWKK83YDRTk5wRzZr3eHxas
         iq/BDHHTJKiojCfUNgGGMoz95p3WE+ogTUGYnmtFCuLJRh+/Suo/fROReTmGhCt7zMXL
         2iNw==
X-Gm-Message-State: AOAM5336zjmvfLM1wgYzQ9+j2lUaay0ubMBPGGvBhNnDsodzAgdrgxe8
        9dYtbUeFVUEI0m64MtMe6A6hPg==
X-Google-Smtp-Source: ABdhPJzkUmD+KWnftYfsZyMv1CBfjNATM4YuEjzljSDhhekkc45DTU+jONr/2LieWgImFbtSd4VvFw==
X-Received: by 2002:a05:6a00:f92:b0:505:c53b:2668 with SMTP id ct18-20020a056a000f9200b00505c53b2668mr7314066pfb.64.1649724899437;
        Mon, 11 Apr 2022 17:54:59 -0700 (PDT)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id n2-20020aa79042000000b005057336554bsm5863557pfo.128.2022.04.11.17.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 17:54:58 -0700 (PDT)
Date:   Tue, 12 Apr 2022 00:54:55 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v4 03/10] KVM: selftests: Read binary stats desc in lib
Message-ID: <YlTN3yq1iBPkw6Aa@google.com>
References: <20220411211015.3091615-1-bgardon@google.com>
 <20220411211015.3091615-4-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411211015.3091615-4-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 11, 2022, Ben Gardon wrote:
> Move the code to read the binary stats descriptors to the KVM selftests
> library. It will be re-used by other tests to check KVM behavior.
> 
> No functional change intended.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  4 +++
>  .../selftests/kvm/kvm_binary_stats_test.c     |  9 ++----
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 29 +++++++++++++++++++
>  3 files changed, 35 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 5ba3132f3110..c5f34551ff76 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -401,6 +401,10 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
>  int vm_get_stats_fd(struct kvm_vm *vm);
>  int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
>  void read_vm_stats_header(int stats_fd, struct kvm_stats_header *header);
> +struct kvm_stats_desc *alloc_vm_stats_desc(int stats_fd,
> +					  struct kvm_stats_header *header);
> +void read_vm_stats_desc(int stats_fd, struct kvm_stats_header *header,
> +			struct kvm_stats_desc *stats_desc);
>  
>  uint32_t guest_get_vcpuid(void);
>  
> diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> index 22c22a90f15a..e4795bad7db6 100644
> --- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> +++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> @@ -62,14 +62,9 @@ static void stats_test(int stats_fd)
>  							header.data_offset),
>  			"Descriptor block is overlapped with data block");
>  
> -	/* Allocate memory for stats descriptors */
> -	stats_desc = calloc(header.num_desc, size_desc);
> -	TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");
>  	/* Read kvm stats descriptors */
> -	ret = pread(stats_fd, stats_desc,
> -			size_desc * header.num_desc, header.desc_offset);
> -	TEST_ASSERT(ret == size_desc * header.num_desc,
> -			"Read KVM stats descriptors");
> +	stats_desc = alloc_vm_stats_desc(stats_fd, &header);
> +	read_vm_stats_desc(stats_fd, &header, stats_desc);
>  
>  	/* Sanity check for fields in descriptors */
>  	for (i = 0; i < header.num_desc; ++i) {
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 0caf28e324ed..e3ae26fbef03 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2564,3 +2564,32 @@ void read_vm_stats_header(int stats_fd, struct kvm_stats_header *header)
>  	ret = read(stats_fd, header, sizeof(*header));
>  	TEST_ASSERT(ret == sizeof(*header), "Read stats header");
>  }
> +
> +static ssize_t stats_descs_size(struct kvm_stats_header *header)
> +{
> +	return header->num_desc *
> +	       (sizeof(struct kvm_stats_desc) + header->name_size);
> +}
I was very confused on header->name_size. So this field means the
maximum string size of a stats name, right? Can we update the comments
in the kvm.h to specify that? By reading the comments, I don't really
feel this is how we should use this field.

hmm, if that is true, isn't this field a compile time value? Why do we
have to get it at runtime?

> +
> +/* Caller is responsible for freeing the returned kvm_stats_desc. */
> +struct kvm_stats_desc *alloc_vm_stats_desc(int stats_fd,
> +					  struct kvm_stats_header *header)
> +{
> +	struct kvm_stats_desc *stats_desc;
> +
> +	stats_desc = malloc(stats_descs_size(header));
> +	TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");
> +
> +	return stats_desc;
> +}
> +
> +void read_vm_stats_desc(int stats_fd, struct kvm_stats_header *header,
> +			struct kvm_stats_desc *stats_desc)
> +{
> +	ssize_t ret;
> +
> +	ret = pread(stats_fd, stats_desc, stats_descs_size(header),
> +		    header->desc_offset);
> +	TEST_ASSERT(ret == stats_descs_size(header),
> +		    "Read KVM stats descriptors");
> +}
> -- 
> 2.35.1.1178.g4f1659d476-goog
> 
