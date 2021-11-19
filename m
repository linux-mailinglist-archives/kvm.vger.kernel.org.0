Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7669E45766C
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 19:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbhKSSeM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 13:34:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37490 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231841AbhKSSeK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 13:34:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637346667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U64RY7OU2Xju+JsoSQCaxT3xKU3oSuMc1u+Un65V0zY=;
        b=Vmnak2UghSzmiTeMiuGxWv9ulI4c6AdFCz8/GowKiUghP9uLd7SMseGr51uVcINnPB6XI+
        BTmSF70mRgDkqnOTvIqCec3cMtEdBXiTcLSe+Yep1ISN1HRB4L3AZiF8Ckzx9h7oSTbKWs
        hK5cF7CUaEfckoolP43DS7JGiCm33tA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-kNiuQashN52E2p9NHxGi6g-1; Fri, 19 Nov 2021 13:31:02 -0500
X-MC-Unique: kNiuQashN52E2p9NHxGi6g-1
Received: by mail-ed1-f69.google.com with SMTP id v10-20020aa7d9ca000000b003e7bed57968so9136958eds.23
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 10:31:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=U64RY7OU2Xju+JsoSQCaxT3xKU3oSuMc1u+Un65V0zY=;
        b=oa31DGdLjR1TlXb+/EpAs7k31sRIX8DYyZNAVBTiXtl/o8zXDprJKjN9/IBbJeMy2L
         TPWKw/O2Uv08v4ZyR3X3/IhSzXp4EywNwpxMydvQftz0OqYzLiyMxzgw54p9MiLq647w
         8QTbKW9+2ujAEBFcMxKythBBhCMhN+PlTDXlA23kawYQ9xc6nvM5BItEmZ/5SqBCh72V
         1LDWYUjHNSjjQQ3rgR8Jq0vZZSagrsazHNHhl+ekxg3Ik6QUqF2y2pfLxYTZ2ggKd+6z
         e2v7aVjKnXkLiVTqHOpjRVaqRsXElHdNTwqNwzoh0UYwPAT//G/9VhzMMdaH7SI2B1To
         AUBg==
X-Gm-Message-State: AOAM531ygXYudVg7zY3T+d8Jrdym+hPtgTtWtCHa0ZzUKaierJrZHgGV
        RaSHr5tK21omiNcPhIJRxXeijtbpa/towCXwfUwNFS/f7frtAhozTOVhxUXfdnUbAVdhXPzCkvJ
        DnHINeDXztwJx
X-Received: by 2002:a17:907:980e:: with SMTP id ji14mr10567039ejc.346.1637346661496;
        Fri, 19 Nov 2021 10:31:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJysizuNz29kxmyK5Y1pJmiEUFOOyuHyVXO5SYZcYalJ0raRF2y2AltBq/8bujU2pPYgEOHbiA==
X-Received: by 2002:a17:907:980e:: with SMTP id ji14mr10567009ejc.346.1637346661324;
        Fri, 19 Nov 2021 10:31:01 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id qf9sm301194ejc.18.2021.11.19.10.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 10:31:00 -0800 (PST)
Date:   Fri, 19 Nov 2021 19:30:59 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, maz@kernel.org, shashi.mallela@linaro.org,
        qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Message-ID: <20211119183059.jwrhb77jfjbv5rbz@gator.home>
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
 <20211112132312.qrgmby55mlenj72p@gator.home>
 <87wnldfoul.fsf@linaro.org>
 <20211112145442.5ktlpwyolwdsxlnx@gator.home>
 <877dd4umy6.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <877dd4umy6.fsf@linaro.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 04:30:47PM +0000, Alex Bennée wrote:
> 
> Andrew Jones <drjones@redhat.com> writes:
> 
> > On Fri, Nov 12, 2021 at 02:08:01PM +0000, Alex Bennée wrote:
> >> 
> >> Andrew Jones <drjones@redhat.com> writes:
> >> 
> >> > On Fri, Nov 12, 2021 at 11:47:31AM +0000, Alex Bennée wrote:
> >> >> Hi,
> >> >> 
> >> >> Sorry this has been sitting in my tree so long. The changes are fairly
> >> >> minor from v2. I no longer split the tests up into TCG and KVM
> >> >> versions and instead just ensure that ERRATA_FORCE is always set when
> >> >> run under TCG.
> >> >> 
> >> >> Alex Bennée (3):
> >> >>   arm64: remove invalid check from its-trigger test
> >> >>   arm64: enable its-migration tests for TCG
> >> >>   arch-run: do not process ERRATA when running under TCG
> >> >> 
> >> >>  scripts/arch-run.bash |  4 +++-
> >> >>  arm/gic.c             | 16 ++++++----------
> >> >>  arm/unittests.cfg     |  3 ---
> >> >>  3 files changed, 9 insertions(+), 14 deletions(-)
> >> >> 
> >> >> -- 
> >> >> 2.30.2
> >> >> 
> >> >> _______________________________________________
> >> >> kvmarm mailing list
> >> >> kvmarm@lists.cs.columbia.edu
> >> >> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> >> >
> >> > Hi Alex,
> >> >
> >> > Thanks for this. I've applied to arm/queue, but I see that
> >> >
> >> > FAIL: gicv3: its-trigger: inv/invall: dev2/eventid=20 pending LPI is received
> >> >
> >> > consistently fails for me. Is that expected? Does it work for you?
> >> 
> >> doh - looks like I cocked up the merge conflict...
> >> 
> >> Did it fail for TCG or for KVM (or both)?
> >
> > Just TCG, which was why I was wondering if it was expected. I've never run
> > these tests with TCG before.
> 
> Hmm I think expecting the IRQ at all is broken so I think I should
> delete the whole pending test.

Feel free to repost. I'll update the patches in arm/queue before my next
MR.

Thanks,
drew

