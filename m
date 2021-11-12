Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B5A44E897
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 15:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbhKLO1x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 09:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbhKLO1v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 09:27:51 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE64C061766
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 06:25:00 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id f7-20020a1c1f07000000b0032ee11917ceso6923454wmf.0
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 06:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=mCchX4v/Fcx1Qw8e/Kgnp+lsdk0xg73uHEXcXcz9oFU=;
        b=aH4TB+ISknzm/p2JFPos2dzjfyrQ+pheBKg1LdACZsb/bOtxlFt/AU1GFR+BjlnnHc
         Ael6r7GaYyw6vn4DwRU/OzyHafc/OLskHJ4KyHqwXsmgy5B83QBfXzjRulh6w+hRs4P1
         QHDgu7KHsatnKVwdLkaGxKIcqkc2HVdNrRC0mRcr34ynmUxF5U7SdeqWudmCBkOXK8++
         7xfsggB6FsYk6UkITpYPtph+fRWFU65h/toNZJ/KFLrHEWWI6YVpxhbyFyzBUuzDmtae
         36F529MdcPzazY0eqbaFqV8iy8JENrzYEC+TrVXLHS7/s+j4lhxwshKXBJ84Pbgms4LA
         n9Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=mCchX4v/Fcx1Qw8e/Kgnp+lsdk0xg73uHEXcXcz9oFU=;
        b=ruIZ7AxwOtEhhWdct9xgDcn3y7kQg1XvU/8DDM16fSR3fGSOA9IsB9qFQxg7qXlFx2
         02d39nk6rGNPPEgGAQghs/tncj2390yyqNyZjTYgZDlDWaIFenfBI5izcRFG7CrzSaQp
         jY59PIrhA8xWVuMHCWRUnsNofRl7asoxW2+APJZPk2+mLsNfiINzF2nPkx+Xjt3RJq3f
         5TL4xkFLZJcguHo0TpteI1YCgjEAWzHz1IduG1bDN/jpZoXsv0PM5YqIJIZLrwzAI42J
         Bb72v0aeEBdU+N0zffmfRklxncswpS4XQ4Vnl/9U4PkrWUd5fB1uYB1Pw13tLWmqMlJB
         dGBA==
X-Gm-Message-State: AOAM531B1ILIdIWmVkhruc+TOzD5FdbKK2T+49p/9916LVkdrS6JzilY
        NA+TScOoGHKsNK/y+x/RNaomeg==
X-Google-Smtp-Source: ABdhPJx6dd8ODC5PRVeasF6GbND+Y3hUscef1E1G4kdca1HAtVpCh/e4iiU0gQT560sssELYvgYphA==
X-Received: by 2002:a1c:9d48:: with SMTP id g69mr36632983wme.188.1636727099083;
        Fri, 12 Nov 2021 06:24:59 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id m14sm8352559wrp.28.2021.11.12.06.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 06:24:58 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 9AA281FF96;
        Fri, 12 Nov 2021 14:24:57 +0000 (GMT)
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
 <20211112132312.qrgmby55mlenj72p@gator.home>
User-agent: mu4e 1.7.4; emacs 28.0.60
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, shashi.mallela@linaro.org,
        qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Date:   Fri, 12 Nov 2021 14:24:18 +0000
In-reply-to: <20211112132312.qrgmby55mlenj72p@gator.home>
Message-ID: <87sfw1fo3q.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Andrew Jones <drjones@redhat.com> writes:

> On Fri, Nov 12, 2021 at 11:47:31AM +0000, Alex Benn=C3=A9e wrote:
>> Hi,
>>=20
>> Sorry this has been sitting in my tree so long. The changes are fairly
>> minor from v2. I no longer split the tests up into TCG and KVM
>> versions and instead just ensure that ERRATA_FORCE is always set when
>> run under TCG.
>>=20
>> Alex Benn=C3=A9e (3):
>>   arm64: remove invalid check from its-trigger test
>>   arm64: enable its-migration tests for TCG
>>   arch-run: do not process ERRATA when running under TCG
>>=20
>>  scripts/arch-run.bash |  4 +++-
>>  arm/gic.c             | 16 ++++++----------
>>  arm/unittests.cfg     |  3 ---
>>  3 files changed, 9 insertions(+), 14 deletions(-)
>>=20
>> --=20
>> 2.30.2
>>=20
>> _______________________________________________
>> kvmarm mailing list
>> kvmarm@lists.cs.columbia.edu
>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>
> Hi Alex,
>
> Thanks for this. I've applied to arm/queue, but I see that
>
> FAIL: gicv3: its-trigger: inv/invall: dev2/eventid=3D20 pending LPI is re=
ceived
>
> consistently fails for me. Is that expected? Does it work for you?

Hmm so it works with KVM so I suspect it's showing up an error in the
TCG ITS implementation which I didn't see in earlier runs.

>
> Thanks,
> drew


--=20
Alex Benn=C3=A9e
