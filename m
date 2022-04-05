Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C97B44F551D
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1458072AbiDFFaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585760AbiDFAAP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 20:00:15 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F0871A39
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 15:24:21 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id ku13-20020a17090b218d00b001ca8fcd3adeso4004883pjb.2
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 15:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AFohrDwPLJ24B3bsNYFKKfK0pUNl+4eRfrb3Wv82z8Q=;
        b=kMa3GPA0lkk2iNEDUuwVMJ3d9K8pD/NCUfgKm4F3iVaENyQ8BHH0E2DbpSmnaP3oKr
         ljk46BOQgavuqHkKGrgE3jRLv7og4JiojPJ8x4BzN9wiMlUUr7LWf0mJnAGvke9ALkQR
         QJ0pRbRqnb4oQKbLt5+eBKeGIaULeaKS/FCP2RhtfX9Nkq9P8M2z2kqyYwaq0bG/8mkb
         E8rKUre0zGiuwA9AEoLxg/vmQfVHGQxk9D9EBsT1pWbn8cZaxj0P7DZGK/bQMNiq034u
         lS+VstGL2uJBCxA45sIpOkJTyDcc3iVGRUDSlmReWBx/PafRzKHFrB+wbYOjenbfJAZO
         shlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AFohrDwPLJ24B3bsNYFKKfK0pUNl+4eRfrb3Wv82z8Q=;
        b=C2Gl+9dapXc4jJYmqaGGvOlm7wz1w5x6Q8mw8UtNlocsqa5XU4CKkgF+84kHrJzcna
         zqbem7tCIngYG2NE4ECAcITXw3YHiMLV9+1cpDcGFLY6zcr1IkWIW+hzp/cBL0f5ZFaZ
         izgnUSYLgux6keDTbTK8+31cU722Q93xNnU3OFDgoTiAiWzk4/OxAYUvc3Ul5wN80mxr
         8ayCxzGuB8DQbmuLe11aZEA6POUBrbGliu5KK+pYtIPwjGVjOPqVpaBzMMV5WbFrTvkJ
         75tvVevzVOM167Syr/QfvvHJEU0BfWNCT9i+s5+BXMicoViRU1fuoyxNKDxbdpMXd5nT
         f3Mg==
X-Gm-Message-State: AOAM531XIsc91/1As9PuWVktiN+b7UkkhniOi0OuUOWNqzXcmf/Zb2K1
        rapqMBosKZAxxzSuEfHC4VNkTw==
X-Google-Smtp-Source: ABdhPJy6s0kDnRB3ZIolWmKvR2DBkwHjL6Yfe8nTD97Ezla3Chsf/1YlYAWsX1sb7fcsxxSvM+W3fg==
X-Received: by 2002:a17:902:9309:b0:156:983d:2193 with SMTP id bc9-20020a170902930900b00156983d2193mr5399926plb.158.1649197457026;
        Tue, 05 Apr 2022 15:24:17 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090a390d00b001c995e0a481sm3446636pjb.30.2022.04.05.15.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 15:24:16 -0700 (PDT)
Date:   Tue, 5 Apr 2022 22:24:12 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v3 03/11] KVM: selftests: Test reading a single stat
Message-ID: <YkzBjF3NyI9fyZad@google.com>
References: <20220330174621.1567317-1-bgardon@google.com>
 <20220330174621.1567317-4-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330174621.1567317-4-bgardon@google.com>
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

On Wed, Mar 30, 2022 at 10:46:13AM -0700, Ben Gardon wrote:
> Retrieve the value of a single stat by name in the binary stats test to
> ensure the kvm_util library functions work.
> 
> CC: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  1 +
>  .../selftests/kvm/kvm_binary_stats_test.c     |  3 ++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 53 +++++++++++++++++++
>  3 files changed, 57 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 4783fd1cd4cf..78c4407f36b4 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -402,6 +402,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
>  int vm_get_stats_fd(struct kvm_vm *vm);
>  int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
>  void dump_vm_stats(struct kvm_vm *vm);
> +uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name);
>  
>  uint32_t guest_get_vcpuid(void);
>  
> diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> index afc4701ce8dd..97bde355f105 100644
> --- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> +++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> @@ -177,6 +177,9 @@ static void vm_stats_test(struct kvm_vm *vm)
>  
>  	/* Dump VM stats */
>  	dump_vm_stats(vm);
> +
> +	/* Read a single stat. */
> +	printf("remote_tlb_flush: %lu\n", vm_get_single_stat(vm, "remote_tlb_flush"));
>  }
>  
>  static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index f87df68b150d..9c4574381daa 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2705,3 +2705,56 @@ void dump_vm_stats(struct kvm_vm *vm)
>  	close(stats_fd);
>  }
>  
> +static int vm_get_stat_data(struct kvm_vm *vm, const char *stat_name,
> +			    uint64_t **data)
> +{
> +	struct kvm_stats_desc *stats_desc;
> +	struct kvm_stats_header *header;
> +	struct kvm_stats_desc *desc;
> +	size_t size_desc;
> +	int stats_fd;
> +	int ret = -EINVAL;
> +	int i;
> +
> +	*data = NULL;
> +
> +	stats_fd = vm_get_stats_fd(vm);
> +
> +	header = read_vm_stats_header(stats_fd);
> +
> +	stats_desc = read_vm_stats_desc(stats_fd, header);
> +
> +	size_desc = stats_desc_size(header);
> +
> +	/* Read kvm stats data one by one */
> +	for (i = 0; i < header->num_desc; ++i) {
> +		desc = (void *)stats_desc + (i * size_desc);
> +
> +		if (strcmp(desc->name, stat_name))
> +			continue;
> +
> +		ret = read_stat_data(stats_fd, header, desc, data);
> +	}
> +
> +	free(stats_desc);
> +	free(header);
> +
> +	close(stats_fd);
> +
> +	return ret;
> +}
> +
> +uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name)
> +{
> +	uint64_t *data;
> +	uint64_t value;
> +	int ret;
> +
> +	ret = vm_get_stat_data(vm, stat_name, &data);
> +	TEST_ASSERT(ret == 1, "Stat %s expected to have 1 element, but has %d",
> +		    stat_name, ret);
> +	value = *data;
> +	free(data);

Allocating temporary storage for the data is unnecessary. Just read the
stat directly into &value. You'll need to change read_stat_data() to
accept another parameter that defines the number of elements the caller
wants to read. Otherwise botched stats could trigger a buffer overflow.

> +	return value;
> +}
> +
> -- 
> 2.35.1.1021.g381101b075-goog
> 
