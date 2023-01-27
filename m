Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF7B67F24D
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 00:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjA0Xiv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 18:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbjA0Xir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 18:38:47 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB33D721CC
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 15:38:37 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id l1so3032894qkg.11
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 15:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r3p/T/C5LEjZklM/3McjmH+nwXiuvZ9AZNDnHBso/wI=;
        b=LvPpqflUiyzNIOBtF7ovVHDoam5nkOWs7FwK65q1MQ6uvVWAF23RlNqpLDYoyvsLtc
         SSfyr0GPJ7bFYVrOik+cQjyeO6GED86cC4GDj+OPpjKACcpLC5DsJBghDxZ1eaGEnJM4
         ud53ek8zV1JEZILhRxrYxQEkj9eDxo+6MWhkTzLWIwSj2MNMUJQzZbgqLWYJZ0i3e6Hh
         XyCDym/pvD2zhV4Kyv1RqgfCrZWDIP6wPGcofH3xEocTAoV721FxGal/pY+6IVSFEnau
         2CWs7CA9zSsGY/Rvo+4sVwIOvGArveMa86D6S1fYg09sAmW3NlPmEXS9Yson/kL3GUHi
         xPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r3p/T/C5LEjZklM/3McjmH+nwXiuvZ9AZNDnHBso/wI=;
        b=z3BQJ0fFn+IGIe4jZrE5cU4kl11JgXVFaf0d9D3dzmLmdzun/PPAGPuOSlIHn93t3L
         QBnzeoJjZJSFU7y1CmMMjAnUH5j7VwWbQYp5EaLuSXnfhL4qrGYo+O8onXSFR09hTqgA
         bqkbCKkGba1/QaNvledPps2iUhB10g3hMO+g2CuHaEjLOuGgtiFOPFI/zZXMKK8bfsRa
         7ybLYkpiaAwM/gkzp9DZPp+bd6lPxWV/ig9xIkaSaDhewULNZdmPbpUVl/aj1Ic9cmk8
         p2BwXZtLL0u0LD5obQyNXENMgB0JmZmu8Eu4FNkl69ww7QEX+avOUXw/KKX90OLMn/53
         i13Q==
X-Gm-Message-State: AO0yUKUzK9IGncZyNTs8ek4xvz96Ei5kg5klxJIwqTIk7smpqeGZlVg5
        pnX3mAsE0F9IBILXD4pDgQGVje16mWDi8c4WRH2qNw==
X-Google-Smtp-Source: AK7set9MfTU7CQFxRLAhgQucoy0y3vpnRRQ9+J1NriTODEPbSGW1cQOL8vN3HkxIljjuJtsgbKngsx0hXiWyABVodmw=
X-Received: by 2002:a05:620a:1426:b0:71b:8e29:18fb with SMTP id
 k6-20020a05620a142600b0071b8e2918fbmr424qkj.230.1674862716796; Fri, 27 Jan
 2023 15:38:36 -0800 (PST)
MIME-Version: 1.0
References: <20230127214353.245671-1-ricarkol@google.com> <20230127214353.245671-5-ricarkol@google.com>
 <Y9RXfxCiKGZNNV3h@google.com>
In-Reply-To: <Y9RXfxCiKGZNNV3h@google.com>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Fri, 27 Jan 2023 15:38:25 -0800
Message-ID: <CAOHnOrwGbLfS_w_R79-bSUDyARnNKiU5r6afC7sQf_mYtAjdLQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: selftests: aarch64: Test read-only PT memory regions
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Jan 27, 2023 at 3:00 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hi Ricardo,
>
> On Fri, Jan 27, 2023 at 09:43:53PM +0000, Ricardo Koller wrote:
> > Extend the read-only memslot tests in page_fault_test to test
> > read-only PT (Page table) memslots. Note that this was not allowed
> > before commit 406504c7b040 ("KVM: arm64: Fix S1PTW handling on RO
> > memslots") as all S1PTW faults were treated as writes which resulted
> > in an (unrecoverable) exception inside the guest.
>
> More of a style nit going forward (don't bother respinning):
>
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  .../selftests/kvm/aarch64/page_fault_test.c    | 18 +++++++++++-------
> >  1 file changed, 11 insertions(+), 7 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> > index 2e2178a7d0d8..54680dc5887f 100644
> > --- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> > +++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> > @@ -829,8 +829,9 @@ static void help(char *name)
> >
> >  #define TEST_RO_MEMSLOT(_access, _mmio_handler, _mmio_exits)                 \
> >  {                                                                            \
> > -     .name                   = SCAT3(ro_memslot, _access, _with_af),         \
> > +     .name                   = SCAT2(ro_memslot, _access),                   \
>
> You should explicitly call out these sort of drive-by/opportunistic
> changes in the commit message as being just that reviewers don't get
> lost figuring out how it relates to the functional change of this
> patch.

Ah, sorry for that. Forgot about mentioning this in the commit message.

Ricardo

>
> --
> Thanks,
> Oliver
