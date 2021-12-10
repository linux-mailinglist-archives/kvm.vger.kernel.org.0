Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BD6470405
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 16:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242954AbhLJPmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 10:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242903AbhLJPms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 10:42:48 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FF3C061746
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 07:39:13 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id g14so30446145edb.8
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 07:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=AOZkdRC+CJ+PlUEpOZm9T90sfKp+i/oDgrKmJYRkPhU=;
        b=ZizVwEZkAydiLEQYWBYNODOEWr60QjsjBINddQJTkw8FL+DX0c13Vg1WVtpKq9U+Aq
         e++XdnJH6ohxVIJhSgvgnsU69yn/Iq2aj3Y2t5jz+WLja+jmVNGdBADfTjIIZutTS/xB
         8A8Cz4DLo1E5lBQLm+LsssVKMVZsgJKC4irQ4GnCPwB95S2c59sXVFnSNEt+836wGSjE
         QgNC0CnAPP/qLcCZ5iwDFCqY8x1wUirAfqvEn2hnUMBrggmSRQvWkQbSpCLcl/KI3tJG
         xQJFT8ci6Xzigg1yDJ8qN3KUCqSma/7pD0RNGs4OlwFjoXAeuxrag6QsOIrRWcEQFGTg
         U0ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=AOZkdRC+CJ+PlUEpOZm9T90sfKp+i/oDgrKmJYRkPhU=;
        b=F9qd4oS0TGW3ol3J1lm2GcfxY9Fr7QsF+R6gzCTzg3vAqwmzZu8CWmJo25mM5hoKnf
         tWNnfNxVWbUmUUuBW96ZLANASfY+osmWKVpu8K2FdTSKx7rvmELo2YSXXutSSQlemzR5
         lldbCfoRqf11Dg5Hn1heu2z1Dcv8f7EENHDr8FLvKJpw+JKyBGaKlOfvhnshc/3Sx+2m
         EY7bkbSjzznNwGt9Pnu1IzCvAvorsqwSq/255mXA6RZzgHFRnzUY93NpbAsfwPPTinun
         GyaSa3+fbWEB6XFPLgI+XosQEUKs76V0FmFtvrurNeet220cvgUrMulYDrl53aPDJsjO
         xwmw==
X-Gm-Message-State: AOAM5316RJ3ins3HuGptPvvKDAnhc2Xda+2jA3lT8ayZ2qzOOc5N0WgR
        Z19uUh7KmlXgKYsP7hGfkmR9nQ==
X-Google-Smtp-Source: ABdhPJyKLs05FJwfh3elkrf4n1AKWwU1t1JPNYqG6PNSzNOg39JnN4HBPm/pFLc0ebZKOsKOqT0VOQ==
X-Received: by 2002:a17:906:e115:: with SMTP id gj21mr24985353ejb.348.1639150751866;
        Fri, 10 Dec 2021 07:39:11 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id ne33sm1770325ejc.6.2021.12.10.07.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 07:39:10 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id B07661FF96;
        Fri, 10 Dec 2021 15:39:09 +0000 (GMT)
References: <20211202115352.951548-1-alex.bennee@linaro.org>
User-agent: mu4e 1.7.5; emacs 28.0.90
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     pbonzini@redhat.com, drjones@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v9 0/9] MTTCG sanity tests for ARM
Date:   Fri, 10 Dec 2021 15:38:56 +0000
In-reply-to: <20211202115352.951548-1-alex.bennee@linaro.org>
Message-ID: <87czm4jwpu.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Alex Benn=C3=A9e <alex.bennee@linaro.org> writes:

> Hi,
>
> Not a great deal has changed from the last posting although I have
> dropped the additional unittests.cfg in favour of setting "nodefault"
> for the tests. Otherwise the clean-ups are mainly textual (removing
> printfs, random newlines and cleaning up comments). As usual the
> details are in the commits bellow the ---.
>
> I've also tweaked .git/config so get_maintainer.pl should ensure
> direct delivery of the patches ;-)

Gentle ping...

--=20
Alex Benn=C3=A9e
