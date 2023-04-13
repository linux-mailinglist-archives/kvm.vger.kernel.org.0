Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4889B6E139D
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 19:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjDMRhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 13:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjDMRhf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 13:37:35 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D62E4220
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 10:37:34 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id u13so16382183ybu.5
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 10:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681407453; x=1683999453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B1jnZnwN/IOOycxEpyhHeYgSCymd9H+aV9u/LeikvAg=;
        b=xv33HL/Sgz5q7Yb32dgAQIxQHaYsTs1Ftmkoa477GEep3uRJcQJS6PO6P/CD+63CBC
         7tTmF9AlscXTRE36iKX5JBKqyiT5bNgSybovp2wpGA+tNaX++49xBa+MDD8Fv+7Y7oDG
         VpogIGbm1Fe0iyh5T9mbYYWHoQT+IEt3zH+l5qYDn+4Ay3e+zO50JUdZ+vBDwDMvhv99
         Hja9X1DItRSGLhqMCtBKsslxiTOpOtxhvcBWiWYtwAhQDsNjdSBVhZWDX5YHYhPV5Vo8
         T27BfNsRFq1j5pGTwMDbffM8HaDt+C/rb49bFht9N8O4Z42NEtUEoHwRdivvwGKgGfO/
         wqkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681407453; x=1683999453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B1jnZnwN/IOOycxEpyhHeYgSCymd9H+aV9u/LeikvAg=;
        b=cCHdOlF8RRe2cydxtMnR3FQsEhSqcNjXe80L7z0Uhne5f/CYznVo+i+ax2xtHLgDB/
         7UK4BYw9JEMXAl+PyFVAB0ovPI7GA7QG/kiNOI5UKPpRQuSG87iBa4VNy1J03lWwS2PC
         5GFdh+YxKdO9+WXE9ckIE13U59beSRodpg2xUZ1KdlmDMDCJi6cK3pGCYT8/hXYbt0Wr
         O8ex3OUoLzYiLiLDbe48aeZKimv33Rik8y/Dw32BM5BmWANWK96dWkl0sqhksDSmRLnZ
         24nYnf/n5EDIyovpj27p/WK0aFYGaoRKTRLvcKHbPJ6N18VwQ5sxw37DS/nRGlFUbBwD
         Znsw==
X-Gm-Message-State: AAQBX9fBWFrtyCQ6m2bUDMaIEhENw5ljf5vgVSVtbxgeeB44hKTLJuTK
        XH0iOvinYA9uoO/IWEM8fMZPAcUSSo6r12fvIHU+BofDLC8XcEoUdvUv5Q==
X-Google-Smtp-Source: AKy350bmp9rTde3h4dHbTs+0zI1C9HiIU2SS8lrLXda8AU+ZbTnWOceus6xiuH8hf7IYk3AddbVes2e0jALZx/r3dLw=
X-Received: by 2002:a25:df41:0:b0:b8f:3367:d5e0 with SMTP id
 w62-20020a25df41000000b00b8f3367d5e0mr1949248ybg.13.1681407453095; Thu, 13
 Apr 2023 10:37:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230412200913.1570873-1-pbonzini@redhat.com>
In-Reply-To: <20230412200913.1570873-1-pbonzini@redhat.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 13 Apr 2023 10:36:57 -0700
Message-ID: <CAHVum0fDp8B0YSYdmMV0OHjA8s5O1Ba2-i81WB8ybhzbRp8RGg@mail.gmail.com>
Subject: Re: [PATCH] selftests/kvm: touch all pages of args on each memstress iteration
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        bgardon@google.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, Apr 12, 2023 at 1:09=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> Access the same memory addresses on each iteration of the memstress
> guest code.  This ensures that the state of KVM's page tables
> is the same after every iteration, including the pages that host the
> guest page tables for args and vcpu_args.
>

AMD and eptad=3D0 reasoning you gave in
https://lore.kernel.org/lkml/199f404d-c08e-3895-6ce3-36b21514f487@redhat.co=
m
should also be included here.

"It also reproduces on Intel with pml=3D0 and eptad=3D0; the reason is due
to the different semantics of dirty bits for page-table pages on AMD
and Intel.  Both AMD and eptad=3D0 Intel treat those as writes, therefore
more pages are dropped before the repopulation phase when dirty logging
is disabled.

The "missing" page had been included in the population phase because it
hosts the page tables for vcpu_args, but repopulation does not need it."

> This difference is visible on the dirty_log_page_splitting_test
> on AMD machines.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  tools/testing/selftests/kvm/lib/memstress.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/=
selftests/kvm/lib/memstress.c
> index 3632956c6bcf..df457452d146 100644
> --- a/tools/testing/selftests/kvm/lib/memstress.c
> +++ b/tools/testing/selftests/kvm/lib/memstress.c
> @@ -65,6 +65,9 @@ void memstress_guest_code(uint32_t vcpu_idx)
>         GUEST_ASSERT(vcpu_args->vcpu_idx =3D=3D vcpu_idx);
>
>         while (true) {
> +               for (i =3D 0; i < sizeof(memstress_args); i +=3D args->gu=
est_page_size)
> +                       (void) *((volatile char *)args + i);
> +
>                 for (i =3D 0; i < pages; i++) {
>                         if (args->random_access)
>                                 page =3D guest_random_u32(&rand_state) % =
pages;
> --
> 2.39.1
>

Apart from the commit log.
Reviewed-by: Vipin Sharma <vipinsh@google.com>
