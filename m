Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74957719F66
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 16:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbjFAOPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 10:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbjFAOOo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 10:14:44 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0E198
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 07:14:43 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id 5614622812f47-399e9455e9fso592456b6e.0
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 07:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1685628883; x=1688220883;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HYGEm9dTJE3ymA0S0F6ScwYwUPa35e2IAPbfTBCKcIU=;
        b=EbAQ5Ei+h07qRmxJx0N7rdln8aAmyNZiqMxMPKukIo5oUEZWdXAB9gk0dKkOnoc6+k
         mCou3qOqGOWXu4ul5gEwV/PEj3yr7iN9iZ+TBDemD/3XxVWV3+d3dy0+Nsxbq+vBjJpT
         gh5Y+Ui/ZXnNUKHmz6iM/6A4YrNsCQSrJSKk6/ObouMYKejXT8fj3iH4iEBpZfWsws7U
         N0I4pX+nNHGH3V7g4V/HxAOj/OYCzaMQDffH6TUEyl1tkDaoeCUPVsMLLeVbYbAC6P8N
         sauBYfUmvEnqARonyjb9mhgnbuociYFnd1TrNC6o9cuWYe81RdkmYb/8u2nHMinU4fit
         dybA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685628883; x=1688220883;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HYGEm9dTJE3ymA0S0F6ScwYwUPa35e2IAPbfTBCKcIU=;
        b=Gl1jPmDTYgdJpAmaVk1ygZ8cT6HbCQJQPtR+Tr9VMTZwpZWyXUk11O0SvNzXbYtPQQ
         tlq7DNXX43F6PLgiqFKgLjAy4U03qW3TL8va8LC2KVnolsehMUBqP1A97nga6VVPZSnl
         DAmgClEVxGArHc6wkLnB2dWl4PfHnGoyDBWaESZyj5tKcqGO08D5BIsTx5EtkHe1+wo/
         j+9p5CcGDC//NndZoDoo1fls0exhoW+nv5u1jqWe2FtR2TH96NjQfn5ZiEREXsNYFmOH
         KD1mSeqAMBqz6mMwcKs94QO/V4Y2XIvf42N4gDHXkB2RfLwYZQgBKcDnngpg7Ub95k67
         YXmg==
X-Gm-Message-State: AC+VfDxTrxwTXutT3pQ441ydd40Nm0aZwJ1msGs5DqK5vHgDGKP4Jsw0
        4bHFzllv04E6RPFGNOVSQvTQiw==
X-Google-Smtp-Source: ACHHUZ6PrC66+GR4MdRjK6lCM7bCd/bfegu9TKXhQkF0BpUF2F8xbF/z6TLkeDy29ym4NZlrBWDDHw==
X-Received: by 2002:a05:6808:3942:b0:398:57fa:9b23 with SMTP id en2-20020a056808394200b0039857fa9b23mr7366943oib.0.1685628883119;
        Thu, 01 Jun 2023 07:14:43 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id pz14-20020ad4550e000000b0061b2a2f949bsm6018073qvb.61.2023.06.01.07.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 07:14:42 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1q4j4b-001SU1-Jr;
        Thu, 01 Jun 2023 11:14:41 -0300
Date:   Thu, 1 Jun 2023 11:14:41 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Nipun Gupta <nipun.gupta@amd.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        masahiroy@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        nicolas@fjasle.eu, git@amd.com, harpreet.anand@amd.com,
        pieter.jansen-van-vuuren@amd.com, nikhil.agarwal@amd.com,
        michal.simek@amd.com
Subject: Re: [PATCH v6] vfio/cdx: add support for CDX bus
Message-ID: <ZHin0Redl/YIgNFg@ziepe.ca>
References: <20230517095718.16117-1-nipun.gupta@amd.com>
 <20230524104529.28708ae8.alex.williamson@redhat.com>
 <20230524134831.28dc97e2.alex.williamson@redhat.com>
 <1bf0323b-1191-de11-061e-00227e09dc35@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bf0323b-1191-de11-061e-00227e09dc35@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 29, 2023 at 01:36:30PM +0530, Nipun Gupta wrote:
> 
> 
> On 5/25/2023 1:18 AM, Alex Williamson wrote:
> > 
> > On Wed, 24 May 2023 10:45:29 -0600
> > Alex Williamson <alex.williamson@redhat.com> wrote:
> > 
> > > On Wed, 17 May 2023 15:27:18 +0530
> > > Nipun Gupta <nipun.gupta@amd.com> wrote:
> > > 
> 
> <snip>
> 
> > > > +
> > > > +MODULE_DEVICE_TABLE(cdx, vfio_cdx_table);
> > > > +
> > > > +static struct cdx_driver vfio_cdx_driver = {
> > > > +   .probe          = vfio_cdx_probe,
> > > > +   .remove         = vfio_cdx_remove,
> > > > +   .match_id_table = vfio_cdx_table,
> > > > +   .driver = {
> > > > +           .name   = "vfio-cdx",
> > > > +           .owner  = THIS_MODULE,
> > > > +   },
> > > > +   .driver_managed_dma = true,
> > 
> > Hmm, looks like cdx bus is broken here, there's no actual
> > implementation of a dma_configure callback and no setup of the IOMMU
> > default domain for theoretical cdx drivers that might want to use the
> > DMA API.  Without that, this driver_manged_dma flag doesn't provide any
> > guarantees to a vfio driver that we have exclusive ownership of the
> > group.  Please fix, this flag needs to actually have some meaning on
> > cdx.  Thanks,
> > 
> > Alex
> 
> Agree, this change was missed on CDX bus and we are working on fixing this.
> Shall I send this fix as a commit with this patch?

You should send it as a rc fixup for your already merged CDX bus stuff

Jason
