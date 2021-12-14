Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396C74741DA
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 12:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhLNLyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 06:54:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53991 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229648AbhLNLyK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 06:54:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639482850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vFWy//LIJxob/lWiTb+7jlaVoy7eDwB1D/1wX1Vb67M=;
        b=ihaC3P5pAnNf8IFG5hB88HeoSC920UrcXrMD2on98VZ7YhI6BMKsDa2R590b+4lOnmIgF/
        nHOtZnkrrF5ElTe/tdgbEL3fmOI4JI9MxWlNKp9LCRLQY1EiAu2HmoZB7rrgv8O1Ke4IaG
        QpIimFRVsD32Ot0u3/avg1DwRgcQnks=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-_eIC1NykN9mv4GU_Und97w-1; Tue, 14 Dec 2021 06:54:08 -0500
X-MC-Unique: _eIC1NykN9mv4GU_Und97w-1
Received: by mail-ed1-f70.google.com with SMTP id a3-20020a05640213c300b003e7d12bb925so16820861edx.9
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 03:54:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=vFWy//LIJxob/lWiTb+7jlaVoy7eDwB1D/1wX1Vb67M=;
        b=D4r7piNu6JNPLvEsro+wcDkWJLEvRosdeRGSG2Fh3HH6zjbSrooLfbfB7jpmLfKHif
         KO7V8agm2dZeUJ/gq4NDTgZHI3n6P552IFMJk4lVtwyreC7kOZZ3YwpEB+i5xo8unRiZ
         2XCS+2T5oJ1xvGUTcGlqVGdAR2zmnQEkhsGyYxtlUOVhVDx5zqL5w4wivHWPQbupT/OH
         Tt1IH6iI4TyJM7Mg3BKgru2a+Gbnd0k/4tL5bein6FyyrUaTnNa1vUmMuHwiMf4v4Ntb
         K34Y/2K+rdIODGYz086WzoMG1ReeULL0PDLcyH9bD0NmgHKYFRNpsTKVE8jaEYvtSi3b
         aWyQ==
X-Gm-Message-State: AOAM530HUBAturPxrks4npaTa3amTiiwlWLkU8L/9eQCbjjd+H2BqVTY
        ySfhA1KCHDfxmprds+tF4HlV1JP5A5C706N/ShI2MT1Ql7suWCNzpr0ESCArdnH1YgRHP1yzHMg
        19ORKZO/eDstm
X-Received: by 2002:aa7:cb48:: with SMTP id w8mr7389231edt.402.1639482847852;
        Tue, 14 Dec 2021 03:54:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxLM06eEkb8R3hqpzcN6AfgAcpZ997bUu2u6dHgiRyTJ9K7eZkp9IDJ4EfaILuqE4kwYGoHuQ==
X-Received: by 2002:aa7:cb48:: with SMTP id w8mr7389206edt.402.1639482847698;
        Tue, 14 Dec 2021 03:54:07 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id t5sm7728720edd.68.2021.12.14.03.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 03:54:07 -0800 (PST)
Date:   Tue, 14 Dec 2021 12:54:05 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com,
        maz@kernel.org
Subject: Re: [kvm-unit-tests PATCH v9 0/9] MTTCG sanity tests for ARM
Message-ID: <20211214115405.wt4gazkqsvmhqv6w@gator.home>
References: <20211202115352.951548-1-alex.bennee@linaro.org>
 <20211214115046.kpiboz7uzgymdoci@gator.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211214115046.kpiboz7uzgymdoci@gator.home>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 14, 2021 at 12:50:46PM +0100, Andrew Jones wrote:
> On Thu, Dec 02, 2021 at 11:53:43AM +0000, Alex Bennée wrote:
> > Hi,
> > 
> > Not a great deal has changed from the last posting although I have
> > dropped the additional unittests.cfg in favour of setting "nodefault"
> > for the tests. Otherwise the clean-ups are mainly textual (removing
> > printfs, random newlines and cleaning up comments). As usual the
> > details are in the commits bellow the ---.
> > 
> > I've also tweaked .git/config so get_maintainer.pl should ensure
> > direct delivery of the patches ;-)
> > 
> > Alex Bennée (9):
> >   docs: mention checkpatch in the README
> >   arm/flat.lds: don't drop debug during link
> 
> >   arm/run: use separate --accel form
> 
> I queued these three to arm/queue[1].
> 
> >   Makefile: add GNU global tags support
> 
> Haven't queued this yet since I think we need .gitignore changes.
> 
> >   lib: add isaac prng library from CCAN
> >   arm/tlbflush-code: TLB flush during code execution
> >   arm/locking-tests: add comprehensive locking test
> >   arm/barrier-litmus-tests: add simple mp and sal litmus tests
> >   arm/tcg-test: some basic TCG exercising tests
> 
> These I've queued to arm/mttcg[2] with a slight change of dropping the
> 'mttcg' group name from any tests that can also run under kvm and
> renaming mttcg to to tcg for the tests that require tcg.

Hmm. I also just noticed that we should rename these tests to something
without the ::  The :: works with standalone, but it isn't all that nice
of a unix file name.

Thanks,
drew

> 
> I haven't pushed everything to arm/queue yet since I'm not yet sure
> I like all the nodefault tests showing up in the logs, even though that
> was my suggestion... I need to play with it some more.
> 
> Thanks,
> drew
> 
> [1] https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue
> [2] https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/mttcg

