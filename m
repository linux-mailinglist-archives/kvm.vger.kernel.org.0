Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8525FD962
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 14:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiJMMni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 08:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiJMMnf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 08:43:35 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D426012007F
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 05:43:32 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id a24so866279qto.10
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 05:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5GLjOW0BdIWUzC24491suSRlciPNhdwolicX7+j12wA=;
        b=SAEIiL74kEmoL7i6K+FYqWYt1OQC0cAaHX12qGeOzYXKJYjkEQAv7uljHXJ4swa6JR
         xHlzlAi1STF9FMZLYrCuntQOvDs5BQQQPxJNF3wfOuWu4E3nVEPIqcgSDMeXg4W9foEx
         0k+Hg9nLfuR5H3rbCakZXpB23lScKeqGXgHhy6TUwyz+9v5bENkOeE6fD/gpEwe5Bxf8
         M/NMiVb+q2oJLRq1/nR2hNa+gk4jKzwubgW4zUEfNWFDeL0SX384wdAplhzPwDYznJw8
         lgiepffTEMTrRRlC+4XC2iHdyDe8mR5JOTJf66zXX3BgrzWWTN5zjDZrFb7Xy67Npu6b
         X8Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5GLjOW0BdIWUzC24491suSRlciPNhdwolicX7+j12wA=;
        b=QZf5aphC/+XCZquR+9up+EY87WjAw5x3i+O/Pik8ijzdhi1J4MfS+Q9FkMCbXqnROS
         +5oU5Gqi2K37OUgeluIwyfokuUglt3JX9zizGZunX8NV7KBWqyueRhamTIH/VjSRnlMw
         vk3EBQmFQrU3oXlS07m7m0voB3x/X7uOx9S4F5V8gNkSEh8Rr5a5B7g5uIXCKuoZ5mCE
         6zCnqcHI+q7KFRqEoHe3VtV6YmaQSWVgf6BudOPgkAnFIJtepZAxZEwLu+TlUwfM2vVD
         sTt3WVoGoxIjt1h1HuGupyv+GhK/nQeLCIiw7Jn/MsbSL7bNK5cG3I8SPRwm+/kw9ZJn
         LoKg==
X-Gm-Message-State: ACrzQf2z3CfQtdOhTjgIroAyFuAXxwpKqasx0iMktM6lZN122fJP0LGb
        4ms60qwJzNA9CEZg830tcPVNiA==
X-Google-Smtp-Source: AMsMyM6G5JimpMoD9asbrrZ+i9ANXy1SXyDx3Pt9ou8Ri40WatBI18xwZQ0CGdktSGP9wh6uVBoUDg==
X-Received: by 2002:a05:622a:90:b0:394:1a9b:638e with SMTP id o16-20020a05622a009000b003941a9b638emr27765696qtw.314.1665665011242;
        Thu, 13 Oct 2022 05:43:31 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id h19-20020a05620a401300b006eeb185c209sm2752971qko.50.2022.10.13.05.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 05:43:30 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oixYf-002fJN-2g;
        Thu, 13 Oct 2022 09:43:29 -0300
Date:   Thu, 13 Oct 2022 09:43:29 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>
Cc:     "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: Re: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Message-ID: <Y0gH8R8tEqn6sqZ5@ziepe.ca>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-5-nipun.gupta@amd.com>
 <87h71juxuk.wl-maz@kernel.org>
 <DM6PR12MB30820EE430405FF50C7F856BE8229@DM6PR12MB3082.namprd12.prod.outlook.com>
 <MN2PR12MB43586084670E14691920952889229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0a65a9leWXpKfTo@ziepe.ca>
 <MN2PR12MB4358A871519748CD7A6DB7A089229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0bRZTP9Kc6mdCiu@ziepe.ca>
 <MN2PR12MB4358277977C1B7E0BC214AC789229@MN2PR12MB4358.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR12MB4358277977C1B7E0BC214AC789229@MN2PR12MB4358.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 12, 2022 at 03:09:26PM +0000, Radovanovic, Aleksandar wrote:

> > On Wed, Oct 12, 2022 at 01:37:54PM +0000, Radovanovic, Aleksandar wrote:
> > > > On Wed, Oct 12, 2022 at 10:34:23AM +0000, Radovanovic, Aleksandar
> > wrote:
> > > >
> > > >
> > > > > As for GITS_TRANSLATER, we can take up to 4 different IOVAs, which
> > > > > limits us to 4 CDX devices (should be sufficient for current HW
> > > > > use-cases). Also, it means that the address part must be the same
> > > > > for all vectors within a single CDX device. I'm assuming this is
> > > > > OK as it is going to be a single interrupt and IOMMU domain anyway.
> > > >
> > > > This is not at all how MSI is supposed to work.
> > >
> > > In the general case, no, they're not.
> > 
> > I don't mean that you can hack this to work - I mean that in MSI the
> > addr/data is supposed to come from the end point itself, not from some kind
> > of shared structure. This is important because the actual act of generating
> > the write has to be coherent with the DMA the device is doing, as the MSI
> > write must push any DMA data to visibility to meet the "producer /
> > consumer" model.
> > 
> 
> I'm not sure I follow your argument, the limitation here is that the MSI
> address value is shared between vectors of the same device (requester id
> or endpoint, whichever way you prefer to call it), not between
> devices.

That isn't what you said, you said "we can take up to 4 different
IOVAs, which limits us to 4 CDX devices" - which sounds like HW being
shared across devices??

Jason
