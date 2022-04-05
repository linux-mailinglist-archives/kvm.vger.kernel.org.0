Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9B74F550A
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243364AbiDFFZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585450AbiDEX74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 19:59:56 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82ACF10F3
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 15:19:08 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id i11so313132plg.12
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 15:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mb3Hz6A+dQKIIp0hbQkZNPT8r/kfRWqo9hHnNe02tSc=;
        b=DJKVcAlgYQLRGDnF4oZDPo6kaUyeBcvUbtM9DQf4086nr63s8CV9xaA1pFyPyVd6zv
         KsxOq1fTBSBLVdVE0CbjXdyfvsPtrQSojZ3Ik5EtcFOlwIq5JQgHzxbHR555WL9crepH
         S72rxBu3yQnfLA+Xf5i9Hnhm5xnrtmZcwryoQPDPjxI+PAJgd+UNYC/EvIZh82CdY+qq
         8FH2u9NSIAcodKHw8ZNc9P4332gvKphUsRzJgm9IKnYZTyiQl4gK6EDr2RbIq/9XSL0j
         0zvL2UaSPEYpXMRAltbASNWRMwres9qAkSc5MNKP6PB+1a+E4jJDsFpqG+tuLHf5+s+l
         L2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mb3Hz6A+dQKIIp0hbQkZNPT8r/kfRWqo9hHnNe02tSc=;
        b=On5xImeJZD9bkkKklsE+L195tqapNL4qcKI9tWBG3FTTdUQd12xT3OkuopLmhNz6Yh
         1MWdIR0k0h3PUrl3wY1Q8Pr3nRwtQffpqJ3fVuGu8uI3WlrZprl/4T6fWdBxoK/pKK1o
         yCKoYGqilObUC8SZo5AYLnV27DlMiVlQ8nAtvgHG80eR3MZtDPkTYM6NwxZa61S68xOl
         7jAP+lDJNabb3r6m2lV8ovT0tsHptFFIyC83LvQ1782o5V/0Wo/zIjqdReYxHAWRQ6jZ
         bEtH9N9EK44+CWjfIkgnRz6lY+pC72mg41NzX4iBEG7n6QyaEG9/FUT8ri2k5e++8H+o
         8b2A==
X-Gm-Message-State: AOAM5318tBnToM3+jgdEG6jD2ys1YY1KIdCuKVDkU6k3KvC3rikVC7Ep
        qbh60Wd/rHNe4AG4l8aquyNasQ==
X-Google-Smtp-Source: ABdhPJy+b1vR1UXlC3uR2Ml8TmaQn1bk7ySEIBS8UyT96phSNBkzKhPLn6QizSDq1o7c3oi0zmDf1A==
X-Received: by 2002:a17:90a:280d:b0:1ca:b14e:35e4 with SMTP id e13-20020a17090a280d00b001cab14e35e4mr6485344pjd.158.1649197147763;
        Tue, 05 Apr 2022 15:19:07 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id 207-20020a6217d8000000b004fdd5af8885sm16164740pfx.22.2022.04.05.15.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 15:19:06 -0700 (PDT)
Date:   Tue, 5 Apr 2022 22:19:03 +0000
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
Subject: Re: [PATCH v3 02/11] KVM: selftests: Dump VM stats in binary stats
 test
Message-ID: <YkzAV8FPdSjzDOd1@google.com>
References: <20220330174621.1567317-1-bgardon@google.com>
 <20220330174621.1567317-3-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330174621.1567317-3-bgardon@google.com>
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

On Wed, Mar 30, 2022 at 10:46:12AM -0700, Ben Gardon wrote:
> Add kvm_util library functions to read KVM stats through the binary
> stats interface and then dump them to stdout when running the binary
> stats test. Subsequent commits will extend the kvm_util code and use it
> to make assertions in a test for NX hugepages.
> 
> CC: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |   1 +
>  .../selftests/kvm/kvm_binary_stats_test.c     |   3 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 143 ++++++++++++++++++
>  3 files changed, 147 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 976aaaba8769..4783fd1cd4cf 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -401,6 +401,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
>  
>  int vm_get_stats_fd(struct kvm_vm *vm);
>  int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
> +void dump_vm_stats(struct kvm_vm *vm);
>  
>  uint32_t guest_get_vcpuid(void);
>  
> diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> index 17f65d514915..afc4701ce8dd 100644
> --- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> +++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> @@ -174,6 +174,9 @@ static void vm_stats_test(struct kvm_vm *vm)
>  	stats_test(stats_fd);
>  	close(stats_fd);
>  	TEST_ASSERT(fcntl(stats_fd, F_GETFD) == -1, "Stats fd not freed");
> +
> +	/* Dump VM stats */
> +	dump_vm_stats(vm);
>  }
>  
>  static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 11a692cf4570..f87df68b150d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2562,3 +2562,146 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
>  
>  	return ioctl(vcpu->fd, KVM_GET_STATS_FD, NULL);
>  }
> +
> +/* Caller is responsible for freeing the returned kvm_stats_header. */
> +static struct kvm_stats_header *read_vm_stats_header(int stats_fd)
> +{
> +	struct kvm_stats_header *header;
> +	ssize_t ret;
> +
> +	/* Read kvm stats header */
> +	header = malloc(sizeof(*header));
> +	TEST_ASSERT(header, "Allocate memory for stats header");
> +
> +	ret = read(stats_fd, header, sizeof(*header));
> +	TEST_ASSERT(ret == sizeof(*header), "Read stats header");
> +
> +	return header;
> +}

It seems like this helper could be used in kvm_binary_stats_test.c to
eliminate duplicate code.

> +
> +static void dump_header(int stats_fd, struct kvm_stats_header *header)
> +{
> +	ssize_t ret;
> +	char *id;
> +
> +	printf("flags: %u\n", header->flags);
> +	printf("name size: %u\n", header->name_size);
> +	printf("num_desc: %u\n", header->num_desc);
> +	printf("id_offset: %u\n", header->id_offset);
> +	printf("desc_offset: %u\n", header->desc_offset);
> +	printf("data_offset: %u\n", header->data_offset);
> +
> +	/* Read kvm stats id string */
> +	id = malloc(header->name_size);
> +	TEST_ASSERT(id, "Allocate memory for id string");
> +	ret = pread(stats_fd, id, header->name_size, header->id_offset);
> +	TEST_ASSERT(ret == header->name_size, "Read id string");
> +
> +	printf("id: %s\n", id);
> +
> +	free(id);
> +}
> +
> +static ssize_t stats_desc_size(struct kvm_stats_header *header)
> +{
> +	return sizeof(struct kvm_stats_desc) + header->name_size;
> +}
> +
> +/* Caller is responsible for freeing the returned kvm_stats_desc. */
> +static struct kvm_stats_desc *read_vm_stats_desc(int stats_fd,
> +						 struct kvm_stats_header *header)
> +{
> +	struct kvm_stats_desc *stats_desc;
> +	size_t size_desc;
> +	ssize_t ret;
> +
> +	size_desc = header->num_desc * stats_desc_size(header);
> +
> +	/* Allocate memory for stats descriptors */
> +	stats_desc = malloc(size_desc);
> +	TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");
> +
> +	/* Read kvm stats descriptors */
> +	ret = pread(stats_fd, stats_desc, size_desc, header->desc_offset);
> +	TEST_ASSERT(ret == size_desc, "Read KVM stats descriptors");
> +
> +	return stats_desc;
> +}

Same with this helper.

> +
> +/* Caller is responsible for freeing the memory *data. */
> +static int read_stat_data(int stats_fd, struct kvm_stats_header *header,
> +			  struct kvm_stats_desc *desc, uint64_t **data)
> +{
> +	u64 *stats_data;
> +	ssize_t ret;
> +
> +	stats_data = malloc(desc->size * sizeof(*stats_data));
> +
> +	ret = pread(stats_fd, stats_data, desc->size * sizeof(*stats_data),
> +		    header->data_offset + desc->offset);
> +
> +	/* ret is in bytes. */
> +	ret = ret / sizeof(*stats_data);
> +
> +	TEST_ASSERT(ret == desc->size,
> +		    "Read data of KVM stats: %s", desc->name);
> +
> +	*data = stats_data;
> +
> +	return ret;
> +}

Same with this helper.

> +
> +static void dump_stat(int stats_fd, struct kvm_stats_header *header,
> +		      struct kvm_stats_desc *desc)
> +{
> +	u64 *stats_data;
> +	ssize_t ret;
> +	int i;
> +
> +	printf("\tflags: %u\n", desc->flags);
> +	printf("\texponent: %u\n", desc->exponent);
> +	printf("\tsize: %u\n", desc->size);
> +	printf("\toffset: %u\n", desc->offset);
> +	printf("\tbucket_size: %u\n", desc->bucket_size);
> +	printf("\tname: %s\n", (char *)&desc->name);
> +
> +	ret = read_stat_data(stats_fd, header, desc, &stats_data);
> +
> +	printf("\tdata: %lu", *stats_data);
> +	for (i = 1; i < ret; i++)
> +		printf(", %lu", *(stats_data + i));
> +	printf("\n\n");
> +
> +	free(stats_data);
> +}
> +
> +void dump_vm_stats(struct kvm_vm *vm)
> +{
> +	struct kvm_stats_desc *stats_desc;
> +	struct kvm_stats_header *header;
> +	struct kvm_stats_desc *desc;
> +	size_t size_desc;
> +	int stats_fd;
> +	int i;
> +
> +	stats_fd = vm_get_stats_fd(vm);
> +
> +	header = read_vm_stats_header(stats_fd);
> +	dump_header(stats_fd, header);
> +
> +	stats_desc = read_vm_stats_desc(stats_fd, header);
> +
> +	size_desc = stats_desc_size(header);
> +
> +	/* Read kvm stats data one by one */
> +	for (i = 0; i < header->num_desc; ++i) {
> +		desc = (void *)stats_desc + (i * size_desc);
> +		dump_stat(stats_fd, header, desc);
> +	}
> +
> +	free(stats_desc);
> +	free(header);
> +
> +	close(stats_fd);
> +}
> +
> -- 
> 2.35.1.1021.g381101b075-goog
> 
