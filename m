Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6666B9A7A
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 17:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjCNQA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 12:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjCNQA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 12:00:56 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F72C34038
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 09:00:55 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id o32so14497664vsv.12
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 09:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678809654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uby9qlcFKmMY2fsZUKJLGUq3FWjzW0DSSs7z/4wZjPc=;
        b=DeQ6DMTwPYVJOy67swDKCZkFrTsT6aC7WKKM6LuOrsZSMHJvovMsb9sFSn8hEDS/DB
         UzxtLwtMXOD9+lqIAQ6LO7i9mKaClTb2GhS3+mZNobCXT5SGA2DfeLlOxpUh68inj4o4
         WI1eH/7ptO19emktw++HegtvaBvCiK7IecZ2g4Hz5oBp3tx9I/lgOYMcklqG4l1zXPly
         SGxpBXArcOHkkMCjdoC1Hyq3sC7q6iYI4uxvS9KsyyIYZhOM/ubMaCMnBxXjkXggjTHK
         0hccdd9mzHlBkJK1bjW3fraWcutiqJ8uHu85PrTxuoQe54fSjN4ifLx3MD8AZaKwbOjP
         Cp4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678809654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uby9qlcFKmMY2fsZUKJLGUq3FWjzW0DSSs7z/4wZjPc=;
        b=lf/eFd1JP1MTPZkwrmYORsY/8nP/WRBeaZ1GLi1PtHMD7TfrD+lVTcnD5b5vh9bmoQ
         bnJfDY/eOQGSl3bJXd9+0wlRx7OSY2XZWpzHIcHW9XSGv4KEMeE8S5DItJcKW6MlNsUe
         b8jocYcu1Efe7JQ4Y4mHBO1UvYBOFrYhDbmw+fZAaehtZwfXMPWVDMEvlE9fwz1LpsLH
         P1/CpINL8pYrNEWmOcP24ESpPmnBbuQvV/X0sYY0GbpBSJO/WSCHr/0Ap5hRHMg3FNb/
         8scE3tbjIH+54Ou280OEOQODuxskiBmKxgIx7qswVzuywSzvjnYDgAfqM639rBIq0oQD
         IhkA==
X-Gm-Message-State: AO0yUKW2616aW+YWhUoLgSp/1kuywpu7cH5Cb5M9R42BN9srXv/rIm3Y
        5YpOWNqHhgCQuxbXvpyni4nVwPmQ+W6Qb6eu8JtIOw==
X-Google-Smtp-Source: AK7set+JhqzS0W9CSOklKEQKTPAJWFCt+2/xyhR2xXzm6EQAcRxtGVgrMWA5Xiu7RQGE33YvU8AhvlCh5c8PM8ZXTmo=
X-Received: by 2002:a67:d81b:0:b0:423:e7f7:bc52 with SMTP id
 e27-20020a67d81b000000b00423e7f7bc52mr7079439vsj.2.1678809654397; Tue, 14 Mar
 2023 09:00:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230131181820.179033-1-bgardon@google.com> <CABgObfaP7P7fk66-EGF-zPEk0H14u3YkM42FRXrEvU=hwFSYgg@mail.gmail.com>
 <CABgObfYAStAC5FgJfGUiJ=BBFtN7drD+NGHLFJY5fP3hQzVOBw@mail.gmail.com>
In-Reply-To: <CABgObfYAStAC5FgJfGUiJ=BBFtN7drD+NGHLFJY5fP3hQzVOBw@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 14 Mar 2023 09:00:28 -0700
Message-ID: <CALzav=c-wtJiz9M6hpPtcoBMFvFP5_2BNYoY66NzF-J+8_W6NA@mail.gmail.com>
Subject: Re: [PATCH V5 0/2] selftests: KVM: Add a test for eager page splitting
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>
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

On Tue, Mar 14, 2023 at 7:23=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On Tue, Mar 14, 2023 at 2:27=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.co=
m> wrote:
> > I have finally queued it, but made a small change to allow running it
> > with non-hugetlbfs page types.
>
> Oops, it fails on my AMD workstation:
>
> $ tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> guest physical test memory: [0x7fc7fe00000, 0x7fcffe00000)
> =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
>   x86_64/dirty_log_page_splitting_test.c:195: __a =3D=3D __b
>   pid=3D1378203 tid=3D1378203 errno=3D0 - Success
>      1    0x0000000000402d02: run_test at dirty_log_page_splitting_test.c=
:195
>      2    0x000000000040367c: for_each_guest_mode at guest_modes.c:100
>      3    0x00000000004024df: main at dirty_log_page_splitting_test.c:245
>      4    0x00007f4227c3feaf: ?? ??:0
>      5    0x00007f4227c3ff5f: ?? ??:0
>      6    0x0000000000402594: _start at ??:?
>   ASSERT_EQ(stats_populated.pages_4k, stats_repopulated.pages_4k) failed.
>     stats_populated.pages_4k is 0x413
>     stats_repopulated.pages_4k is 0x412
>
> Haven't debugged it yet.

I wonder if pages are getting swapped, especially if running on a
workstation. If so, mlock()ing all guest memory VMAs might be
necessary to be able to assert exact page counts.

>
> Paolo
>
