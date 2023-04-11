Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFE46DDB9F
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 15:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjDKNFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 09:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbjDKNFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 09:05:05 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF07A3AB6
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 06:04:53 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id v20-20020a05600c471400b003ed8826253aso890553wmo.0
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 06:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681218292; x=1683810292;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+VsLOycAHyGZoxoPqUjjK9qLhajHi2nxfZLNUeNazbU=;
        b=gbOmLCmuIScS2z0LOiNoMXkdN/CaFp4IOGreYjmCp5ohvxd0PukiO+daoaxEFYV2T1
         OfTngPbS1qJFuFJGbm3AdX0FAUT8fxeMh3WXxh/ylVEw61l68O5hnUkHeAIzSgUzpUkL
         rB49yTD0m1dhutmYCuQrZCsCLlg7oYsFLFcfi9b0cDxXUTMEAKMfq0516UmqA9tTOK1e
         LMoE7/ro3o5FNhnnvzbWnsuEF5cvJwtflCZb6pTRvoxsBkUXx10hKEWUZgVmxinKFR6H
         2nEz+LtiJE/Q8IcREWEXUIBfaYX6WGxlTkRBpv1cCB7C1iGAOtZItjBjOrOncZC/XWhH
         Qv9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681218292; x=1683810292;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+VsLOycAHyGZoxoPqUjjK9qLhajHi2nxfZLNUeNazbU=;
        b=p463RiZ2bN7btjRXMA5cbr0vlrbQ3+PYyxcgLifqhR3t057kpCvMwbjcBmfrN27OGG
         VkozDuQCG49rUskvkVhqoOYypoiPvoTfjhLF6ViqfDwBm+s/2QBUbm5Xe34dmO74r/PS
         eyngGq+MexrwP7UaM1Qvf3WPgAc1fQPrXzv0KlUWF1Adhe3nnneaKeel8Atxj4oCQX0l
         H74JY+VtObJEdpgLBLTrtXl77OwUon7APowPVr5HG7r8e1IaV42ag0BOnPdWENmHpdld
         pokpa8ox8mhcYAVStCCS5Da5pZJINXT2XXoTy76UOc6o+E4Uo+Y1EFZjDZq/LrU2jcxc
         YBcg==
X-Gm-Message-State: AAQBX9ckzFgaUG+EB2mAa+gCF1gC6jxktBFKBWQM5SDSm6wXbC3JZ4cQ
        odRP4zymmpUV3hpIVtUo0upiVQ==
X-Google-Smtp-Source: AKy350bSzYQKI+JiwlucbWXfDBB89IiLUayKbfhkAVFYgHvUcugimzW1q0J4r7UlrQ2tGjrcMEevpA==
X-Received: by 2002:a7b:c5c2:0:b0:3ed:c84c:7efe with SMTP id n2-20020a7bc5c2000000b003edc84c7efemr9597516wmk.7.1681218292069;
        Tue, 11 Apr 2023 06:04:52 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id w16-20020a05600c475000b003f092f0e0a0sm2037796wmo.3.2023.04.11.06.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 06:04:51 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 075CE1FFB7;
        Tue, 11 Apr 2023 14:04:51 +0100 (BST)
References: <20230403134920.2132362-1-alex.bennee@linaro.org>
 <20230403134920.2132362-6-alex.bennee@linaro.org>
 <ZCwsvaxRzx4bzbXo@redhat.com>
 <cbb3df0a-7714-cbc0-efda-45f1d608e988@msgid.tls.msk.ru>
 <ZCxNqb9tEO24KaxX@redhat.com> <ZC8qXxB6X8t7RBa+@gorilla.13thmonkey.org>
 <ZDVN9TlzrCOJHlDR@redhat.com>
User-agent: mu4e 1.10.0; emacs 29.0.90
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Kevin Wolf <kwolf@redhat.com>
Cc:     Reinoud Zandijk <reinoud@netbsd.org>,
        Michael Tokarev <mjt@tls.msk.ru>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ryo ONODERA <ryoon@netbsd.org>, qemu-block@nongnu.org,
        Hanna Reitz <hreitz@redhat.com>, Warner Losh <imp@bsdimp.com>,
        Beraldo Leal <bleal@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Kyle Evans <kevans@freebsd.org>, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Cleber Rosa <crosa@redhat.com>, Thomas Huth <thuth@redhat.com>,
        armbru@redhat.com
Subject: Re: [PATCH v2 05/11] qemu-options: finesse the recommendations
 around -blockdev
Date:   Tue, 11 Apr 2023 14:03:36 +0100
In-reply-to: <ZDVN9TlzrCOJHlDR@redhat.com>
Message-ID: <87o7nupo25.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Kevin Wolf <kwolf@redhat.com> writes:

> Am 06.04.2023 um 22:23 hat Reinoud Zandijk geschrieben:
>> On Tue, Apr 04, 2023 at 06:17:45PM +0200, Kevin Wolf wrote:
>> > Am 04.04.2023 um 17:07 hat Michael Tokarev geschrieben:
>> > > 04.04.2023 16:57, Kevin Wolf =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> > Maybe -snapshot should error out if -blockdev is in use. You'd general=
ly
>> > expect that either -blockdev is used primarily and snapshots are done
>> > externally (if the command line is generated by some management tool),
>> > or that -drive is used consistently (by a human who likes the
>> > convenience). In both cases, we wouldn't hit the error path.
>> >=20
>> > There may be some exceptional cases where you have both -drive and
>> > -blockdev (maybe because a human users needs more control for one
>> > specific disk). This is the case where you can get a nasty surprise and
>> > that would error out. If you legitimately want the -drive images
>> > snapshotted, but not the -blockdev ones, you can still use individual
>> > '-drive snapshot=3Don' options instead of the global '-snapshot' (and =
the
>> > error message should mention this).
>>=20
>> I didn't know that! I normally use the -snapshot as global option. Is th=
ere a
>> reason why -blockdev isn't honouring -snapshot?
>
> The philosophy behind -blockdev is that you're explicit about every
> image file (and other block node) you want to use and that QEMU doesn't
> magically insert or change things behind your back.
>
> For simple use cases that might not seem necessary, but many of the
> newer functions added to the block layer, like the block jobs, are
> operations that can work on any node in the block graph (i.e. any of the
> open images, including backing files etc.). If QEMU changed something
> behind your back, you can easily access the wrong image. Especially for
> management software like libvirt this kind of magic that -drive involves
> was really hard to work with because it always had to second guess what
> the world _really_ looked like on the QEMU side.
>
> For example, imagine you open foo.img with -snapshot. Now you want to
> create a backup of your current state, so tell QEMU to backup the block
> node for foo.img because that's what your VM is currently running on,
> right? Except that nobody told you that the active image is actually a
> temporary qcow2 image file that -snapshot created internally. You're
> backing up the wrong image without the changes of your running VM.
>
> So it's better to always be explicit, and then it's unambiguous which
> image file you really mean in operations.

With that in mind please review:

  Subject: [PATCH v3] qemu-options: finesse the recommendations around -blo=
ckdev
  Date: Thu,  6 Apr 2023 10:53:17 +0100
  Message-Id: <20230406095317.3321318-1-alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
