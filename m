Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244605B03F5
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 14:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiIGMdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 08:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiIGMdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 08:33:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A29A7ABF;
        Wed,  7 Sep 2022 05:33:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D5AD618D6;
        Wed,  7 Sep 2022 12:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB53C433D7;
        Wed,  7 Sep 2022 12:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662553979;
        bh=+oPcnp8Ehqf+5v9MwAdEHVeVY7vbOQ3ajdywYWvVyKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PbGVjNGQFIBeQlyORikeOGZ023BSRIg/LCmLoOXl+RupSx7yVXJLKwNpNNghwaQx+
         2c9cCoL8ZSLzwG0PPsta9NsFSI7VhSRiZUKu/xlOutzwnV+Ah2Y8wgQ5qbq+KtKClF
         zbh1++1nCbXnBG+42FRlhocM2eMzPFB2yI/vtpfk=
Date:   Wed, 7 Sep 2022 14:32:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nipun Gupta <nipun.gupta@amd.com>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        rafael@kernel.org, eric.auger@redhat.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        puneet.gupta@amd.com, song.bao.hua@hisilicon.com,
        mchehab+huawei@kernel.org, maz@kernel.org, f.fainelli@gmail.com,
        jeffrey.l.hugo@gmail.com, saravanak@google.com,
        Michael.Srba@seznam.cz, mani@kernel.org, yishaih@nvidia.com,
        jgg@ziepe.ca, jgg@nvidia.com, robin.murphy@arm.com,
        will@kernel.org, joro@8bytes.org, masahiroy@kernel.org,
        ndesaulniers@google.com, linux-arm-kernel@lists.infradead.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kvm@vger.kernel.org, okaya@kernel.org,
        harpreet.anand@amd.com, nikhil.agarwal@amd.com,
        michal.simek@amd.com, aleksandar.radovanovic@amd.com, git@amd.com
Subject: Re: [RFC PATCH v3 2/7] bus/cdx: add the cdx bus driver
Message-ID: <YxiPeOwo5tWrQuSE@kroah.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-3-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906134801.4079497-3-nipun.gupta@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022 at 07:17:56PM +0530, Nipun Gupta wrote:
> CDX bus supports the scanning and probing of FPGA based
> devices. These devices are registers as CDX devices.
> 
> The bus driver sets up the basic infrastructure and fetches
> the device related information from the firmware.
> 
> CDX bus is capable of scanning devices dynamically,
> supporting rescanning of dynamically added, removed or
> updated devices.

Really?  Then why is the platform driver mess still in here?


> --- /dev/null
> +++ b/drivers/bus/cdx/cdx.c
> @@ -0,0 +1,437 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Platform driver for CDX bus.

Again, this should not be a platform driver.

Now you can have a CDX "bus" driver, that is a platform driver, but that
needs to be in a separate file and as a separate module and totally
independant of the CDX bus code entirely.

Otherwise this is a mess to try to sift through and determine what is,
and is not, going on.  Please split that up and get rid of all of the
platform driver stuff here and put it in a separate patch that happens
after the CDX bus logic is added.

thanks,

greg k-h
