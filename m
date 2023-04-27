Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2FB6F0D4D
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 22:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344088AbjD0UgQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 16:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343660AbjD0UgO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 16:36:14 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E511644AA
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 13:35:47 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-3ef34c49cb9so827151cf.1
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 13:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682627747; x=1685219747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ptBdlJ07v8HdQe+LoZZ45Ny20mkYLWz+prXa/vlPc5g=;
        b=ejGejKzhboVuH/Okkr279d6To4yc4YLxo/pErGIwVBZms1pTi6heNby96nKksTpX3a
         9ZVW2kjRNWY2WNF5IQ7O6q/srqJLqblDuMKQXyTWzx9rUb53h6IeiwdWT8DdiTvvFlnF
         ap59K2vgyFhSDWY7ymCDiaotKITRXEl6Kt//xXgyY9bowPyBNnmDww8lxUpkoxb/4MtX
         yzrPYzVLtrUUMHn6mUxs9CgVgcowuzqlknix5QPRtkcyKv8wsvFTnP59kim9sF5t4wXI
         vJ14wyoK1j9Bzvlhu/Jfaa3TEjEdAsJjGPGTgyyUrB3KSbgpzbJLTBv4J9aB28owmHQs
         PI6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682627747; x=1685219747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ptBdlJ07v8HdQe+LoZZ45Ny20mkYLWz+prXa/vlPc5g=;
        b=HFNBDTBiAwdFrji6z5XZFAeuNry5z5dVU7p01FY3zVIfQdntuppP4h3zf5jWW6fSGJ
         E5v+SIADGQYr6RyOUMnaHbWNiYkNCl7G+ZM4kKDZkX51h1XuUt6UHhqqvJNHlDiB3t/x
         jHE6ExJKQXr+2bvA2y4LhDTWS3ZUNFCCeZWdcYEnvj+IVsgehKY1kRO5zNDfj9Zi5Myi
         ZVrYtJ4UNnyrY8s+jcr9hyyxEmaiJPNipRF5XelMdIZkzGllUvHs9jDyEcf3VTqG/wYE
         cA5rMNS4+4oKzRKWpu/AeqCbelc4ArQ42cKL6meK3CsxF9LyBtMfR9WCRqQNOeCsj3EY
         PUaA==
X-Gm-Message-State: AC+VfDxlE9uwxcZ0ENYC85TD8GSPS/Mj4YD3wxm23DO+dTCj4EWnNWNS
        ZT3H2UdZgJQCFk4croPoVrk6xRG7lDsH1UfkaEPIAA==
X-Google-Smtp-Source: ACHHUZ6k2Icr8mvB78iBbOp/hEvzjLIV2SDthfJnvHGJz15ZjsD4VFeV8D723c/xR7fRgPMt1L9PXuavlP+NkvgJ2Pw=
X-Received: by 2002:ac8:590f:0:b0:3ef:4319:c6c5 with SMTP id
 15-20020ac8590f000000b003ef4319c6c5mr58453qty.19.1682627746969; Thu, 27 Apr
 2023 13:35:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230427201112.2164776-1-peterx@redhat.com> <20230427201112.2164776-2-peterx@redhat.com>
In-Reply-To: <20230427201112.2164776-2-peterx@redhat.com>
From:   James Houghton <jthoughton@google.com>
Date:   Thu, 27 Apr 2023 13:35:11 -0700
Message-ID: <CADrL8HWxdTBD5fKiK9BKRUFCghK_nd1oNOkykmh4RYbn4C7UgA@mail.gmail.com>
Subject: Re: [PATCH 1/2] selftests/kvm: Setup vcpu_alias only for minor mode test
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anish Moorthy <amoorthy@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Apr 27, 2023 at 1:11=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> This fixes two things:
>
> - Unbreaks MISSING mode test on anonymous memory type
>
> - Prefault alias mem before uffd thread creations, otherwise the uffd
>   thread timing will be inaccurate when guest mem size is large, because
>   it'll take prefault time into total time.
>
> Signed-off-by: Peter Xu <peterx@redhat.com>

Reviewed-by: James Houghton <jthoughton@google.com>

FWIW, it looks like this fixes this commit[1]. Not sure if it's worth
a Fixes: tag.

[1]: commit a93871d0ea9f ("KVM: selftests: Add a userfaultfd library")


> ---
>  .../testing/selftests/kvm/demand_paging_test.c  | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/tes=
ting/selftests/kvm/demand_paging_test.c
> index 2439c4043fed..9c18686b4f63 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -128,6 +128,7 @@ static void prefault_mem(void *alias, uint64_t len)
>
>  static void run_test(enum vm_guest_mode mode, void *arg)
>  {
> +       struct memstress_vcpu_args *vcpu_args;
>         struct test_params *p =3D arg;
>         struct uffd_desc **uffd_descs =3D NULL;
>         struct timespec start;
> @@ -145,24 +146,24 @@ static void run_test(enum vm_guest_mode mode, void =
*arg)
>                     "Failed to allocate buffer for guest data pattern");
>         memset(guest_data_prototype, 0xAB, demand_paging_size);
>
> +       if (p->uffd_mode =3D=3D UFFDIO_REGISTER_MODE_MINOR) {
> +               for (i =3D 0; i < nr_vcpus; i++) {
> +                       vcpu_args =3D &memstress_args.vcpu_args[i];
> +                       prefault_mem(addr_gpa2alias(vm, vcpu_args->gpa),
> +                                    vcpu_args->pages * memstress_args.gu=
est_page_size);
> +               }
> +       }
> +
>         if (p->uffd_mode) {
>                 uffd_descs =3D malloc(nr_vcpus * sizeof(struct uffd_desc =
*));
>                 TEST_ASSERT(uffd_descs, "Memory allocation failed");
> -
>                 for (i =3D 0; i < nr_vcpus; i++) {
> -                       struct memstress_vcpu_args *vcpu_args;
>                         void *vcpu_hva;
> -                       void *vcpu_alias;
>
>                         vcpu_args =3D &memstress_args.vcpu_args[i];
>
>                         /* Cache the host addresses of the region */
>                         vcpu_hva =3D addr_gpa2hva(vm, vcpu_args->gpa);
> -                       vcpu_alias =3D addr_gpa2alias(vm, vcpu_args->gpa)=
;
> -
> -                       prefault_mem(vcpu_alias,
> -                               vcpu_args->pages * memstress_args.guest_p=
age_size);
> -
>                         /*
>                          * Set up user fault fd to handle demand paging
>                          * requests.
> --
> 2.39.1
>
