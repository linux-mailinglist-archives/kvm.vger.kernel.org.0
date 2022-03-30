Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95E84ECCB7
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 20:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350105AbiC3Sxt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 14:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350621AbiC3Sw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 14:52:58 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30F538DBF
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 11:51:12 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id a127so23458840vsa.3
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 11:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Cw0eDjE+WN/K3Pk88Mm97poeGAlfoJe1nXSMsdWjxQ=;
        b=PBnXugz3W3FccisFa9X1Wda7UUG3RLHh2bnnXcqZ3NXAlxbKZSJQHDUrSpcydHQgZl
         7DvKFrXmNKWh41LsMHenYFak+ydkiQuDJ2hg94Bj4toZViFyn/kqGsZ5iOhYEaAELVma
         dt+9udjXdiliG618o4wCmeUMxUMrf/KnPlfdkaQyrDYkzrI0OPLyQfaWbZ70UxuXHFIj
         Ork4btLIryLO9xwDA+Ql79w/s8BgN9vD8k+8FUHt9bN7bWXK/1WtWqOry+T83InnC0Uc
         FNhWUwj3yM/N8rE/4xoOER1OLBl+dQ7IvY/9jQ3B5l/1Vl6xI3cJVf9Kbop8WkDqw2JL
         C//w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Cw0eDjE+WN/K3Pk88Mm97poeGAlfoJe1nXSMsdWjxQ=;
        b=Crhanx2T2OiccGIxsca2oTX4cyILIcs+/q1PGBFIq4BQsu/uxNex0mxarGHRdvBHD4
         JBFg9HXYpwqRBoGhjEYkGhaBnV+j6tjEqH9JRXajE37MJuMlZHpKNVG+Mdy5BPdk8Bxr
         ue2txWGttE31TPAf9ip4rQPE+FS9BDWpcGb71uvq2v57wMyfb0IzgR7wGUHlDGQfhRWO
         1EUbkDVjBxtm8W8WBsul5QqviGFfVri2jBGBmseNbZ83d6uwUuq7UnhRVeWjpcOcVIlZ
         gb3auMrMQtnArhE7MUfl8g7C1n0KhFswRQZtQUYgbH973wvU1X9Gk7S+j/Bg8B4vemTA
         e7sA==
X-Gm-Message-State: AOAM533HWWqMCLSAOms9p4xSHRPSQVxq2C8bqLehw5/aJd7s9oWvMb59
        5Tr8onmJ4YhBQDfFITeiha+bfWHy1RrvrUOQ/HCUlQ==
X-Google-Smtp-Source: ABdhPJzxVqcq1tlUyH0+NG9swHpjyfnd+H076E9nGki9qqpM6bAJiZK7CQpMFw/XNGhFH1e33CojlOhDT2FrnQt5OGQ=
X-Received: by 2002:a05:6102:e8a:b0:325:7b06:c348 with SMTP id
 l10-20020a0561020e8a00b003257b06c348mr15453693vst.52.1648666271800; Wed, 30
 Mar 2022 11:51:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220330174621.1567317-1-bgardon@google.com> <20220330174621.1567317-4-bgardon@google.com>
In-Reply-To: <20220330174621.1567317-4-bgardon@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 30 Mar 2022 11:51:01 -0700
Message-ID: <CAAdAUtizJcjEqLv8hcjNv0ZCOAy62DXA6voEhtYeeK4EpLf6HQ@mail.gmail.com>
Subject: Re: [PATCH v3 03/11] KVM: selftests: Test reading a single stat
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Mar 30, 2022 at 10:46 AM Ben Gardon <bgardon@google.com> wrote:
>
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
>         /* Dump VM stats */
>         dump_vm_stats(vm);
> +
> +       /* Read a single stat. */
> +       printf("remote_tlb_flush: %lu\n", vm_get_single_stat(vm, "remote_tlb_flush"));
>  }
>
>  static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index f87df68b150d..9c4574381daa 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2705,3 +2705,56 @@ void dump_vm_stats(struct kvm_vm *vm)
>         close(stats_fd);
>  }
>
> +static int vm_get_stat_data(struct kvm_vm *vm, const char *stat_name,
> +                           uint64_t **data)
> +{
> +       struct kvm_stats_desc *stats_desc;
> +       struct kvm_stats_header *header;
> +       struct kvm_stats_desc *desc;
> +       size_t size_desc;
> +       int stats_fd;
> +       int ret = -EINVAL;
> +       int i;
> +
> +       *data = NULL;
> +
> +       stats_fd = vm_get_stats_fd(vm);
> +
> +       header = read_vm_stats_header(stats_fd);
> +
> +       stats_desc = read_vm_stats_desc(stats_fd, header);
> +
> +       size_desc = stats_desc_size(header);
> +
> +       /* Read kvm stats data one by one */
> +       for (i = 0; i < header->num_desc; ++i) {
> +               desc = (void *)stats_desc + (i * size_desc);
> +
> +               if (strcmp(desc->name, stat_name))
> +                       continue;
> +
> +               ret = read_stat_data(stats_fd, header, desc, data);
> +       }
> +
> +       free(stats_desc);
> +       free(header);
> +
> +       close(stats_fd);
> +
> +       return ret;
> +}
> +
> +uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name)
> +{
> +       uint64_t *data;
> +       uint64_t value;
> +       int ret;
> +
> +       ret = vm_get_stat_data(vm, stat_name, &data);
> +       TEST_ASSERT(ret == 1, "Stat %s expected to have 1 element, but has %d",
> +                   stat_name, ret);
> +       value = *data;
> +       free(data);
> +       return value;
> +}
> +
> --
> 2.35.1.1021.g381101b075-goog
>
Reviewed-by: Jing Zhang <jingzhangos@google.com>
