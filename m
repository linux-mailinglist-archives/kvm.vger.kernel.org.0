Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B662257C23D
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 04:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbiGUC2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 22:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiGUC2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 22:28:33 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42ED67748D
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 19:28:32 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id b21-20020a05600c4e1500b003a32bc8612fso77696wmq.3
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 19:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=19tjAXZdXv68l+YAa0ZBgRNpk344mTsjynA3NFgFKCA=;
        b=TKoFdcXDZLfDMneVBORAok2+vyXEb+qu9uNr5uMmuS01DbWsKwgeyA5InrxDT+Es39
         TS8SFJzYuqq7kQmqOkdrDt+aUiY/OKqSQPVfMrWqor0zv9GM56GPwglzZyTYQXSukIPv
         2NvA7OMMiEXh2jy/w7M82TX0PZ2pDJi0pkI1uD6f5c2HLXEFYZMDa0rSkGdZ7L22EJb7
         28lVqyBW0oiH3lmKnBpbNzqK/vtstvIbN/XlQ+RtjPiJx1DMcrZiQM32/y7X7S/H9r2f
         6r7OuMf/nTGPozqlF1is0Xgl7v6P3eYROxJjcHuoK0nBdJBp3FuH63B+TptQHyDobQdJ
         hDBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=19tjAXZdXv68l+YAa0ZBgRNpk344mTsjynA3NFgFKCA=;
        b=feFq1NDZzpdnSGzwm+Ce4Dte32iIzFkZH9hFYWE/jMu8lo3wXLC1DDkxxHuVfNfse4
         FySMYBGHDQOQw2xleE9EGvCqnJWFLD+wPgv9Sn3KY40eSaWUcANmDvqCmf+IkO1toPWU
         cP3kZMT2KL3EY8DMc569cHn861jBb1GgdNyW9/owGpjzBOVIrm/ZdMfLTUKlLCW3mrD+
         GJrg9C2QmnMBtmv/Dmkei5jalsHElLz0phUiy1xxB9klaocBIJUa8UCU5oOxMxvop5en
         9T8ythDrMaDp80UF4rfCe6kIrjl06Rpsn/fm8TKtQJpnOMTpAcR1BrhoMLaRLIVnJ18a
         ndOQ==
X-Gm-Message-State: AJIora/ep7i6swP5Iho3kNidpG/bp3SwXnan/ZorIUR/Zs2x7qVDYGrT
        0Al7tyZrKnFJPWwIsvbZouIu3gW1r7xR6Y3RldJRlw==
X-Google-Smtp-Source: AGRyM1vE7AdNjWBIwuiujlKAqemHdV3gh9ZupYfREkyvjWQZ7lbVC7ZR8mv0zwVT+luSSVfqjBmsotZvsGZFZpciAQU=
X-Received: by 2002:a05:600c:1e0f:b0:3a3:191c:a3c8 with SMTP id
 ay15-20020a05600c1e0f00b003a3191ca3c8mr6353368wmb.151.1658370510638; Wed, 20
 Jul 2022 19:28:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220719234950.3612318-1-aaronlewis@google.com>
 <20220719234950.3612318-4-aaronlewis@google.com> <YtiOgtQy1bjL3VNX@google.com>
In-Reply-To: <YtiOgtQy1bjL3VNX@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 21 Jul 2022 02:28:18 +0000
Message-ID: <CAAAPnDEKS5hrunMg8Q5Gvt=bU81zZD6fMWsfqRJu029JXpvv1w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/3] selftests: kvm/x86: Test the flags in MSR
 filtering / exiting
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
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

> > --- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> > @@ -734,6 +734,99 @@ static void test_msr_permission_bitmap(void)
> >       kvm_vm_free(vm);
> >  }
> >
> > +static void test_results(int rc, const char *scmd, bool expected_succe=
ss)
>
> Rather than pass in "success expected", pass in the actual value and the =
valid
> mask.  Then you can spit out the problematic value in the assert and be k=
ind to
> future debuggers.
>
> And similarly, make the __vm_ioctl() call here instead of in the "caller"=
 and name
> this __test_ioctl() (rename as necessary, see below) to show it's relatio=
nship with
> the macro.

The other comments look good.  I'll update.

This one is a bit tricky though.  I did originally have __vm_ioctl()
in test_results() (or whatever name it will end up with), but the
static assert in kvm_do_ioctl() gave me problems.  Unless I make
test_results() a macro, I have to force cmd to a uint64_t or something
other than a literal, then I get this:

include/kvm_util_base.h:190:39: error: expression in static assertion
is not constant
190 |         static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) =3D=3D
_IOC_SIZE(cmd), "");   \
       |                                       ^
include/kvm_util_base.h:213:9: note: in expansion of macro =E2=80=98kvm_do_=
ioctl=E2=80=99
213 |         kvm_do_ioctl((vm)->fd, cmd, arg);                       \

That's not the only problem.  In order to pass 'arg' in I would have
to pass it as a void *, making sizeof(*arg) wrong.

Being that the ioctl call was the first thing I did in that function I
opted to make it a part of test_ioctl() rather than making
test_results() a macro.

If only C had templates :)

>
> > +{
> > +     int expected_rc;
> > +
> > +     expected_rc =3D expected_success ? 0 : -1;
> > +     TEST_ASSERT(rc =3D=3D expected_rc,
> > +                 "Unexpected result from '%s', rc: %d, expected rc: %d=
.",
> > +                 scmd, rc, expected_rc);
> > +     TEST_ASSERT(!rc || (rc =3D=3D -1 && errno =3D=3D EINVAL),
> > +                 "Failures are expected to have rc =3D=3D -1 && errno =
=3D=3D EINVAL(%d),\n"
> > +                 "  got rc: %d, errno: %d",
> > +                 EINVAL, rc, errno);
> > +}
> > +
> > +#define test_ioctl(vm, cmd, arg, expected_success)   \
>
