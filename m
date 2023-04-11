Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C236DE163
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 18:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjDKQqv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 12:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjDKQqg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 12:46:36 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFCF55A1
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 09:46:16 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-94cfe3db2aaso86529566b.0
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 09:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1681231573; x=1683823573;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nWck0qnNaoiFiCtCGNjSsTsFcMjQqGSwfdGnBkruvQE=;
        b=MbVv3M5wjyeWsSWIRL4r5ZirT7K5n9QJ5g/k24GIIt1qkwdAek7yEMtNBg3EoO6d0I
         F2AjeCQZWficlvHmS5wc4oe850OJRh6/7ccdaeoXIHdllOzLIEFksCCrG3d018hBKMN0
         c8jpBDr9uoHQ8gTXgv193cG+89LSFZRveSDfI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681231573; x=1683823573;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nWck0qnNaoiFiCtCGNjSsTsFcMjQqGSwfdGnBkruvQE=;
        b=NAZoCeOl8sSMbJMMcO6XuKYJj/cb+jQWqBM7M7xIP6tbb2wpEcJJ+s4COaOywBu+Cf
         XlRyXOw2fdQiSunCKSB/xktQ9MB0i+VCww5ndv3xTGbxpzOAv3Dv1B/z160ztNrPBDB6
         LM3Y+X8jx9NtAFaRUBzG4MtsBWVjl52YW3i1WhDxRl7D/G3+3IVyFR8XY6zeOKfD3Zxh
         cvD9wGuILguEjUjxX/bLl8r7DoIHNdbokfHWR9sY6RHq1iGwMKeIRC0i7xM77Yyo68TI
         mXXmXvyGmncjz+h+3hazKGfnqLKtqnW0ptOa9Y/8fO+I5T1GFGiyhKJHPoEVjDGLve1N
         sG1g==
X-Gm-Message-State: AAQBX9ckV1IxSejnKSfuwoM8jOaoCU2QK4loK1zCLb+Fe1NgP8f9eOcC
        l7DdpX3/ygOzv5hBMTLGr1NX2b70xK2tz9Hj9qZ7rA==
X-Google-Smtp-Source: AKy350b/LQzmSYduvH2G0+nI+tjjS48ITcj7nFrB25CMb5Tqefu1wqKux+t6M39sJA9sysu0vvhxZQ==
X-Received: by 2002:a05:6402:2051:b0:4fb:999:e04c with SMTP id bc17-20020a056402205100b004fb0999e04cmr14136744edb.38.1681231573510;
        Tue, 11 Apr 2023 09:46:13 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id x102-20020a50baef000000b004af73333d6esm6048238ede.53.2023.04.11.09.46.12
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 09:46:12 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-504ae0a698cso1246226a12.1
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 09:46:12 -0700 (PDT)
X-Received: by 2002:a50:baec:0:b0:504:9390:180f with SMTP id
 x99-20020a50baec000000b005049390180fmr4434766ede.2.1681231571945; Tue, 11 Apr
 2023 09:46:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230410153917.1313858-1-pbonzini@redhat.com> <CAHk-=wiYktfscvihY0k6M=Rs=Xykx9G7=oT5uCy1A80zpmu1Jg@mail.gmail.com>
 <2560f4b4-8620-6160-eee5-4086630bb5cc@redhat.com>
In-Reply-To: <2560f4b4-8620-6160-eee5-4086630bb5cc@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 11 Apr 2023 09:45:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=whSZViPSuwTv02P34ncDJNFdZS4RoDxN4C2EEoff-W7Ew@mail.gmail.com>
Message-ID: <CAHk-=whSZViPSuwTv02P34ncDJNFdZS4RoDxN4C2EEoff-W7Ew@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 6.3-rc7
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, KVM list <kvm@vger.kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 10, 2023 at 11:34=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
>
> Out of curiosity, do you have some kind of script that parses the "git
> request-pull" messages and does these checks?  Or was it just the
> mismatch between diffstat and tag message?

For me, it's manual - I check that the diffstat matches, but also
check that the description matches the shortlog I get.

And if anything looks weird, I dig deeper (the diffstat often doesn't
match - some people use "--patience" for the diff which can generate
small differences, or there are other changes nearby so that the
merged end result diffs differently from the pre-merge state etc etc).

But "git request-pull" should actually have warned you about the SHA's
not matching. When it generates that

  "are available in the Git repository at:

     https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

   for you to fetch changes up to 0bf9601f8ef0703523018e975d6c1f3fdfcff4b9:=
"

verbiage, it should actually have verified that the tag matches
locally, and it generates that commit ID and the shortlog from the
local tag.

And the fact that the shortlog (and commit ID) you had was the
expected one, but the tag pointed to something else makes me suspect
that you are mis-using "git request-pull".

I strongly suspect that you did the request-pull *without* pointing at
the tag (in fact, you cannot possibly have pointed at the correct tag,
since the request-pull contents did *not* match the tag contents), and
then fixed things up manually later when you created the tag.

So you must have explicitly avoided all the automation that "git
request-pull" does.

              Linus
