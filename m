Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6AB94FC6F4
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 23:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239646AbiDKV6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 17:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiDKV6l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 17:58:41 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3973E11C02
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:56:26 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id bn33so21808206ljb.6
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X+N09zcbJuqm02OJTE8uJJpeovv6DbQqyDBNINHqtKw=;
        b=RmRBQGhkggmKgOue9Zj0QAjU2XCKkMLlAE0ZWGiZcb72k0TCf8WEtPlX3DZaEvSDUS
         JL9R0qNEdmTT2XRJuAmDI5bsBPLwvOdjdWHHugqDmBPfN7Jgrw57EO4IHPeqlpD2SHF4
         KgtICwJKk9JpEYpjFhtj0RRC9toaHIbjJO49vpV7PH3vFmn9oVwjdIKdIIxpH8j0pMGn
         0RfzGyLC4jw/DCTIIjYBtxjCSOtAUCj6bCiuWVtMsBt1Lc33qdgdeSH6Cef2lXvOR3UN
         1MNUULVQ017RHqjfGSsj4emah3ldGyE1R+T5CRDow95/tJWl0Ygp8I2fYGXZSugnRpSs
         AlVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X+N09zcbJuqm02OJTE8uJJpeovv6DbQqyDBNINHqtKw=;
        b=IDmABp7e3W4bQMxQKzwytYm8pqYHsQjYsL4rIoyJG+JatuQhdlxWAHZkqOBFs+5e/Y
         k0n6791kPNk9W+goxRDX4nu05/JtWSZTooaEtghMKAtGrSEmcAvp5ObUWe2J1mqJ+zK/
         Md5nk95Zw/8TzOTEajl/BrI14AdzA74XDhYAB3RqKzTtc70RsyMCsjiQWc0TCm2Ifmle
         KSrCK4OxkF8vfKndbjqCII9zqGrt2X1NgbzO7dMRftJIL47tAdKL2TukqY0pL9kqM+sX
         RuSkNzh1Lu2REjVpOz0Jk7ahTmSmF2yqkux016c2QG095hr0IVoGJ5g4nrAakrOjIbNh
         dUhg==
X-Gm-Message-State: AOAM531Skem9GHj7PB0THVcHd9WKisrckt32He7KMEtSkLrftkA60wJn
        kGwvOLDa+oj6NqqbGijsYRkqDS9LO9NHGlU+khHX1A==
X-Google-Smtp-Source: ABdhPJwUJSKM70Ef6WWKpw+MOIHQo7C3Mn2ZLkhBJMoshCxngtIZbG4xO+0LT5/7ZHXH8xHhK0Ut448Nz0tWqvtCkV0=
X-Received: by 2002:a05:651c:988:b0:24a:c21f:7057 with SMTP id
 b8-20020a05651c098800b0024ac21f7057mr22231208ljq.16.1649714184279; Mon, 11
 Apr 2022 14:56:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220411211015.3091615-1-bgardon@google.com> <20220411211015.3091615-3-bgardon@google.com>
In-Reply-To: <20220411211015.3091615-3-bgardon@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 11 Apr 2022 14:55:57 -0700
Message-ID: <CALzav=cRWQ5dHbR75AoFnXUuAWLcNfoG+aepO4GOyzsU0oWV7A@mail.gmail.com>
Subject: Re: [PATCH v4 02/10] KVM: selftests: Read binary stats header in lib
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>
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

On Mon, Apr 11, 2022 at 2:10 PM Ben Gardon <bgardon@google.com> wrote:
>
> Move the code to read the binary stats header to the KVM selftests
> library. It will be re-used by other tests to check KVM behavior.
>
> No functional change intended.
>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
>  tools/testing/selftests/kvm/kvm_binary_stats_test.c | 4 ++--
>  tools/testing/selftests/kvm/lib/kvm_util.c          | 8 ++++++++
>  3 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 92cef0ffb19e..5ba3132f3110 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -400,6 +400,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
>
>  int vm_get_stats_fd(struct kvm_vm *vm);
>  int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
> +void read_vm_stats_header(int stats_fd, struct kvm_stats_header *header);
>
>  uint32_t guest_get_vcpuid(void);
>
> diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> index dad34d8a41fe..22c22a90f15a 100644
> --- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> +++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> @@ -33,8 +33,8 @@ static void stats_test(int stats_fd)
>         struct kvm_stats_desc *pdesc;
>
>         /* Read kvm stats header */
> -       ret = read(stats_fd, &header, sizeof(header));
> -       TEST_ASSERT(ret == sizeof(header), "Read stats header");
> +       read_vm_stats_header(stats_fd, &header);

stats_test() is used to test both VM and vCPU stats. The only
difference is whether stats_fd is the VM stats fd or a vCPU stats fd.

Given that, please rename read_vm_stats_header() to something more
generic (since it can also be used for reading the vCPU stats header).
e.g. read_stats_header().

> +
>         size_desc = sizeof(*stats_desc) + header.name_size;
>
>         /* Read kvm stats id string */
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 1665a220abcb..0caf28e324ed 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2556,3 +2556,11 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
>
>         return ioctl(vcpu->fd, KVM_GET_STATS_FD, NULL);
>  }
> +
> +void read_vm_stats_header(int stats_fd, struct kvm_stats_header *header)
> +{
> +       ssize_t ret;
> +
> +       ret = read(stats_fd, header, sizeof(*header));
> +       TEST_ASSERT(ret == sizeof(*header), "Read stats header");
> +}
> --
> 2.35.1.1178.g4f1659d476-goog
>
