Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0136BF155
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 20:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjCQTBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 15:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjCQTBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 15:01:38 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9849710C0
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 12:01:09 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id x1so4000923uav.9
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 12:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679079668;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IVQFlWdpP4WdaM0vBFOrptKyrPgb3OepzK5c4pn+jco=;
        b=ouHJBTcAuYOCHdJI/OfUL6oCXUksGOulDDm0VwCl2qHVFwA/1+9WXMq1Bu+cRJqi45
         846lRQXr8CS1spFxfXNV9jYphlUR2P+zwuBGOwKQ8Lejfqx3eHVjawx7Tny/DAi2UJsN
         M7t+tao8iHbPh6Lm0wEUnreqC/m1MZMFQx7mNIkp3EOgH1Cj/Zd2g/O4A1pp1Wx5W9DJ
         FImJBPKYb7mYMj+qVTdl3ndhoQ/mSHHYMC+VHDZ3aDt/KajorP/Li5Up4SIXMqQxzhW9
         QfKuGyD/cVaedC7eGtQiePAGEQKm5Uen2qlRkTl3NqasYji1HIiBiUtrewMhusWFE5VE
         HY6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679079668;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IVQFlWdpP4WdaM0vBFOrptKyrPgb3OepzK5c4pn+jco=;
        b=nxV7Adixcd+W1dEgm3SI2r4AI++wXoUL/Jg4zGWz/lfAsfLWzupXZhKF/H6oo2S44F
         eW5I+B2CwQKNKqP/i2BKJGh+igxWjkmJFhmSnWVvYi0o/w+GpaIgz7bR8RSNmuTBQQZL
         XUMH1vSqLmTmCSGziRgmIPf39oqo+o4CDijMMqctA4CFG3tY75MMg5mJkPAub/sIJceV
         ec6Fllvy5Nrv2dQAbbbGC/xkLNp4H3vFx3dsPSn4QtgPQ9z9RESR8WqCCbXbfLC7/zF+
         SatYiWOrDp6ky4c3bOzq5I7vn3h+M7pnuBrVIce6ayrWMQIMyEF3DHsFC5do/BZMKKc4
         XjMw==
X-Gm-Message-State: AO0yUKVw0FGHGNZHXdXLNhoAXV8nlk8Q2RsY0OIf+rNe8whDFVlm9xUr
        Pc0N5XpaKCT7+rQ+7VV+Q5Pqb8xCubkbygn2Rz2dKg==
X-Google-Smtp-Source: AK7set9Mnj25Sb+hhLWqNw6xgGrM3V4SA1wqr0hgJ5n0TlWTz+v2ovPCoutUMLxSEZuJOr+J6NzMXXx39ioQ9B2sQhQ=
X-Received: by 2002:a1f:2a8f:0:b0:409:f633:89c0 with SMTP id
 q137-20020a1f2a8f000000b00409f63389c0mr643856vkq.1.1679079666889; Fri, 17 Mar
 2023 12:01:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-13-amoorthy@google.com>
 <ZBSw/jh/WfAwu3ga@linux.dev>
In-Reply-To: <ZBSw/jh/WfAwu3ga@linux.dev>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Fri, 17 Mar 2023 12:00:30 -0700
Message-ID: <CAF7b7mrG_jmrUohr9rXLBXS-uzJCwK6=BC5pyxE8O=Ov77WZ3w@mail.gmail.com>
Subject: Re: [WIP Patch v2 12/14] KVM: arm64: Implement KVM_CAP_MEMORY_FAULT_NOWAIT
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     seanjc@google.com, jthoughton@google.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 11:27=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:

> > +     pfn =3D __gfn_to_pfn_memslot(
> > +             memslot, gfn, exit_on_memory_fault, false, NULL,
> > +             write_fault, &writable, NULL);
>
> As stated before [*], this google3-esque style does not match the kernel =
style
> guide. You may want to check if your work machine is setting up a G3-spec=
ific
> editor configuration behind your back.
>
> [*] https://lore.kernel.org/kvm/Y+0QRsZ4yWyUdpnc@google.com/

If you're referring to the indentation, then that was definitely me.
I'll give the style guide another readthrough before I submit the next
version then, since checkpatch.pl doesn't seem to complain here.

> > +     if (exit_on_memory_fault && pfn =3D=3D KVM_PFN_ERR_FAULT) {
>
> nit: I don't think the local is explicitly necessary. I still find this
> readable:

The local was for keeping a consistent value between the two blocks of code=
 here

    pfn =3D __gfn_to_pfn_memslot(
        memslot, gfn, exit_on_memory_fault, false, NULL,
        write_fault, &writable, NULL);

    if (exit_on_memory_fault && pfn =3D=3D KVM_PFN_ERR_FAULT) {
        // Set up vCPU exit and return 0
    }

I wanted to avoid the possibility of causing an early
__gfn_to_pfn_memslot exit but then not populating the vCPU exit.
