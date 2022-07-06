Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6035569373
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 22:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbiGFUkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 16:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbiGFUkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 16:40:00 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAEC1A82E
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 13:39:59 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 70so260106pfx.1
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 13:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dm+uqJs1xF69dP23AqiPAQraH9V4KWFlTqQ+Rsyoru8=;
        b=QrOKWI3Vca/k1a+GRCxhBvSqLNySlJUCzRudfWzvCco3kJpMv9lmI1NaHFkWt9KJ8f
         Sz5gzRbyy97ot4xcElAlpT0C4Y/widxJ++sRRBeV+OpB0SNukh2LdguVFaUoUoG66KzV
         4jklcXdCLnRgBnU0Xm6beUEA/UOfVjbkQnkOLgRougFPtKg87j+cNQh8GfXLu18tU0DG
         dCM8DYWuaKv+++ar9hppsbHLi25BqBobopLlZO9q1qcFQg2yIP+DCANUWoeUAY0BMxgY
         5iXYcXrBA9nzpDDSUCfD3Tez53FQXDIYWSmUUOtTwBPFNeCjX7Ze2HKOO4j/kr1CISxj
         03Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dm+uqJs1xF69dP23AqiPAQraH9V4KWFlTqQ+Rsyoru8=;
        b=Din8bbatcRiOimdU1+cuQlPvleffZwmzLoGxjlWRLrXxE+fvmMnIQuEqDgMZRYJb9G
         2CU6oAYNsUw6iqYszt+RWA112w2p4Lzdnhik4cN7DmjBPBheFPJTQ3NoQh30fOr0blag
         taBI+eBQBOZCVPPulUzBj4/DQKwLh0EnGHqkC8LXp4WQt8EWX76nZJugixb4LA+vc4e3
         RdhZi8GwdIm6Cs68NJ5n/ZnlFYyqBcmDKoAXsrNXVsZljpH4AsCm2qh8jgHyLSGgvsOr
         UQNv3mdOkHuSuJ28iE2Z7GR9x+zsLDTFEsC026ceDVhpPBnNVCdayfc+2QA2OL0gnjwu
         4Fcg==
X-Gm-Message-State: AJIora9PG2kqAlI3zcdNjPLX1A9wDrKiBplCNGgsMRt8mFXSXWxm0haS
        fKFDa1huV4SXkRyws4EMr8Yv+A==
X-Google-Smtp-Source: AGRyM1uqW9n2ybKdzfrSPPxpBOQBQk4fh9bX4Udga5fPyZMbd19FcLmUBARjsRVMPp1gMR6ypiWthg==
X-Received: by 2002:a05:6a00:2410:b0:528:be6e:8c2e with SMTP id z16-20020a056a00241000b00528be6e8c2emr4305258pfh.31.1657139998870;
        Wed, 06 Jul 2022 13:39:58 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id s11-20020a170902a50b00b001620eb3a2d6sm25933855plq.203.2022.07.06.13.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 13:39:57 -0700 (PDT)
Date:   Wed, 6 Jul 2022 20:39:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dmytro Maluka <dmy@semihalf.com>
Cc:     Auger Eric <eric.auger@redhat.com>,
        Micah Morton <mortonm@chromium.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: Add vfio-platform support for ONESHOT irq forwarding?
Message-ID: <YsXzGkRIVVYEQNE3@google.com>
References: <CAJ-EccMWBJAzwECcJtFh9kXwtVVezWv_Zd0vcqPMPwKk=XFqYQ@mail.gmail.com>
 <20210125133611.703c4b90@omen.home.shazbot.org>
 <c57d94ca-5674-7aa7-938a-aa6ec9db2830@redhat.com>
 <CAJ-EccPf0+1N_dhNTGctJ7gT2GUmsQnt==CXYKSA-xwMvY5NLg@mail.gmail.com>
 <8ab9378e-1eb3-3cf3-a922-1c63bada6fd8@redhat.com>
 <CAJ-EccP=ZhCqjW3Pb06X0N=YCjexURzzxNjoN_FEx3mcazK3Cw@mail.gmail.com>
 <CAJ-EccNAHGHZjYvT8LV9h8oWvVe+YvcD0dwF7e5grxymhi5Pug@mail.gmail.com>
 <99d0e32c-e4eb-5223-a342-c5178a53b692@redhat.com>
 <31420943-8c5f-125c-a5ee-d2fde2700083@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31420943-8c5f-125c-a5ee-d2fde2700083@semihalf.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 06, 2022, Dmytro Maluka wrote:
> This is not a problem on native, since for oneshot irq we keep the interrupt
> masked until the thread exits, so that the EOI at the end of hardirq doesn't
> result in immediate re-assert. In vfio + KVM case, however, the host doesn't
> check that the interrupt is still masked in the guest, so
> vfio_platform_unmask() is called regardless.

Isn't not checking that an interrupt is unmasked the real bug?  Fudging around vfio
(or whatever is doing the premature unmasking) bugs by delaying an ack notification
in KVM is a hack, no?

> Therefore, since the interrupt has not yet been acked in the guest's threaded
> handler, a new (unwanted) physical interrupt is generated in the host and
> queued for injection to the guest in vfio_automasked_irq_handler().
