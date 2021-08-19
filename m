Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA633F101D
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 03:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235566AbhHSBzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 21:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235258AbhHSBzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 21:55:49 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB22C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 18:55:13 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id qk33so9178285ejc.12
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 18:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5fJ4QoiERO7mOVVJY9cLiWJv+BztYXiri0O71N77ysY=;
        b=lQHz0HhI+tmXSNmvB+z7rPxLyvp75l75RCvqUqw387YPqBN7pEp6Q2UxR1dYmkOIWV
         JlkRpy30JLTQ/Be3XH/BmPAF5G1btNEDI3gFX9WnT1oqTfxjaZ9xscPITNtN7bvGEdRA
         Ri4aA1GiWiteaIaPR0C+6cPJYN/nTD/5PsxkHhIgv4j+dnQzP8KXL6TO8+fvAUhv69UC
         eqwPWrLRc48dfGkPwcj9X8Bjnz0xpUX3JvhlUqgh6BVge3ray73UA5ztGYG1or9DeXEH
         CIs4VOCgMBglsMSZaayal03KAaLEmzwMtiI8CsC1LPkhAF7zsgxh8utjfg+ELx8ChfkR
         biwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5fJ4QoiERO7mOVVJY9cLiWJv+BztYXiri0O71N77ysY=;
        b=cpybUlzLNtbq7MCWy3IBRm4jUJwNxdOdaC+qwMWisIQ5z5QiKg3fV5S51tD3BOlie3
         IUGU+N6iak5DSJnZYIeSWtpwKb2WPRvLRAGCzgRzfkWvs7s3GUp5Hk+YzzAvIa8hkFjK
         KL/jSnw7n1+/lJp5lkDtFF0Y+cMBy4hZjRdFdQ0eCG5qvT/3SUefLcigHEhy7KXpFMoP
         cmY7FwNHF0JefniHRRltVkYyc5i72/EyK70AXMUjuLroqr5foC6uOjFYcZTbKZTF5/1Q
         hwMSZvkj2fsQ5u/25i/lF91NvY3f8xijxROhQ8wlFZlUfC9c1qHBWP2OhYawTIKEZitB
         3Qng==
X-Gm-Message-State: AOAM530XlqwZ23g0/riFDex20if5R/VEykAzT2bBmgBUixM/Tt46pRWg
        xk0wStxQIkmv+DRDQVb3xdlvQC0mc/xF3TYEKfwwEoz8rt1ANg==
X-Google-Smtp-Source: ABdhPJyYvmrVOhbqDOLa/51WUU5KfYudtavo0eLESA8/YbfCWY4HvLHgAC9vU3wIXnj2UUZLfcdsAOXTMOZ69Sf7Fxw=
X-Received: by 2002:a17:906:b094:: with SMTP id x20mr12676768ejy.257.1629338111678;
 Wed, 18 Aug 2021 18:55:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210702114820.16712-1-varad.gautam@suse.com> <CAA03e5HCdx2sLRqs2jkLDz3z8SB9JhCdxGv7Y6_ER-kMaqHXUg@mail.gmail.com>
 <YRuURERGp8CQ1jAX@suse.de> <CAA03e5FTrkLpZ3yr3nBphOW3D+8HF-Wmo4um4MTXum3BR6BMQw@mail.gmail.com>
 <71db10eb-997f-aac1-5d41-3bcbc34c114d@suse.com> <CAA03e5H6mM0z5r4knbjHDLS4svLP6WQuhC_5BnSgCyXpRZgqAQ@mail.gmail.com>
 <0250F07B-AC9A-4110-B2F4-8537A40D8848@gmail.com>
In-Reply-To: <0250F07B-AC9A-4110-B2F4-8537A40D8848@gmail.com>
From:   Zixuan Wang <zixuanwang@google.com>
Date:   Wed, 18 Aug 2021 18:54:59 -0700
Message-ID: <CAFVYft2ObMDtPsZHgLNo1VgWxfgCq6+FPmyv2dsQCzM=JRMbeg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 0/6] Initial x86_64 UEFI support
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Marc Orr <marcorr@google.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Joerg Roedel <jroedel@suse.de>, kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>, bp@suse.de,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 18, 2021 at 6:42 PM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> Just wondering (aka, my standard question): does it work on
> bare-metal (putting aside tests that rely on test-devices)?
>

Hi Nadav,

We tested our patches in VMs, and have not tested on bare-metal machines.

Regards,
Zixuan Wang
