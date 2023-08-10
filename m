Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8CA4777E95
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 18:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbjHJQsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 12:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjHJQsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 12:48:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4376B10C4
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 09:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691686058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iX9dfigAcH8NeakNhELzqilWH4hSvNPsTzEZpq3rGQc=;
        b=MDzlq3Q6AsJjmFt+x6mSNtwLhsGK+G4HBkxSP4NwqcrpA2HbOC2t3gjlY5h4eoCR2jzFX3
        YGmlmIQO5E0gVPUCGQrG0Nzw7UtmLA4JFDB/UT8DMzAJaVsEnfbFijbwvpNcndboGOrtLm
        sFP8GjmUUZmU/Tkx7gt9+R3U1uWnbSA=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-SgFhSi4VMU6Rx35_ndBMsg-1; Thu, 10 Aug 2023 12:47:37 -0400
X-MC-Unique: SgFhSi4VMU6Rx35_ndBMsg-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-790f73b8f8aso82833839f.2
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 09:47:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691686056; x=1692290856;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iX9dfigAcH8NeakNhELzqilWH4hSvNPsTzEZpq3rGQc=;
        b=eiiXYiLkQhzoaI3k8Wmi/hJ7KcpAMKHm/+i3qZcn3HsyrAyK1Dt2nq5GO8u99B03/R
         Rlfbd857T7RyiwXUiyv8rtaEHIF/9xJ0dDv8KMEWZ6yVz81Tz5xpwe5cd3vCz+fDdMoT
         LL5N88szTrHtZlm+VZg9bdIp1J6daydtgis1FXZObvUKb0U/v3RtEFV7H9jIPwUrv2Pd
         dm3LgPIcrRTgXhomV3gRE26jseZUbvLPfThADJ0lhyrQT6tFUdVo2sdvOdjaPhu6Pf13
         xCXWUYSbZfQ1ecEHpxcnQ3VWjn3SWXIfUSlMkoK35WdDbNz2uLDGMUJqu7JLPPP4bVZU
         0goA==
X-Gm-Message-State: AOJu0YyqK/wsMKcH8w0Sk0TdVNPZl3y1cT5X1GudOw/aIjhumysRaH5e
        XqwHjUrm3B1s1CtQ2AY2iMKpJVNv2qoVoGJ96sWwnNjBHvKw4eA0AMswbjcv7MR+QlYUV2rcKlR
        3UMuqljL5TQrL
X-Received: by 2002:a6b:5c0f:0:b0:783:7275:9c47 with SMTP id z15-20020a6b5c0f000000b0078372759c47mr3904104ioh.7.1691686056515;
        Thu, 10 Aug 2023 09:47:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhnW6Ng1wIjDiplvduIBOywRGh+zdPgNAkWpJy5wXLpufiRZOX4I6I6q3EE9yZ1q5WAEx+sA==
X-Received: by 2002:a6b:5c0f:0:b0:783:7275:9c47 with SMTP id z15-20020a6b5c0f000000b0078372759c47mr3904084ioh.7.1691686056256;
        Thu, 10 Aug 2023 09:47:36 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id eh11-20020a056638298b00b004182f88c368sm510175jab.67.2023.08.10.09.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 09:47:35 -0700 (PDT)
Date:   Thu, 10 Aug 2023 10:47:34 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Brett Creeley <bcreeley@amd.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "horms@kernel.org" <horms@kernel.org>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: Re: [PATCH v14 vfio 6/8] vfio/pds: Add support for dirty page
 tracking
Message-ID: <20230810104734.74fbe148.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276F32CC5791B3D91C62A468C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230807205755.29579-1-brett.creeley@amd.com>
        <20230807205755.29579-7-brett.creeley@amd.com>
        <20230808162718.2151e175.alex.williamson@redhat.com>
        <01a8ee12-7a95-7245-3a00-2745aa846fca@amd.com>
        <20230809113300.2c4b0888.alex.williamson@redhat.com>
        <ZNPVmaolrI0XJG7Q@nvidia.com>
        <BN9PR11MB5276F32CC5791B3D91C62A468C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Aug 2023 02:47:15 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, August 10, 2023 2:06 AM
> > 
> > On Wed, Aug 09, 2023 at 11:33:00AM -0600, Alex Williamson wrote:
> >   
> > > Shameer, Kevin, Jason, Yishai, I'm hoping one or more of you can
> > > approve this series as well.  Thanks,  
> > 
> > I've looked at it a few times now, I think it is OK, aside from the
> > nvme issue.
> >   
> 
> My only concern is the duplication of backing storage management
> of the migration file which I didn't take time to review.
> 
> If all others are fine to leave it as is then I will not insist.

There's leverage now if you feel strongly about it, but code
consolidation could certainly come later.

Are either of you willing to provide a R-b?

What are we looking for relative to NVMe?  AIUI, the first couple
revisions of this series specified an NVMe device ID, then switched to
a wildcard, then settled on an Ethernet device ID, all with no obvious
changes that would suggest support is limited to a specific device
type.  I think we're therefore concerned that migration of an NVMe VF
could be enabled by overriding/adding device IDs, whereas we'd like to
standardize NVMe migration to avoid avoid incompatible implementations.

It's somewhat a strange requirement since we have no expectation of
compatibility between vendors for any other device type, but how far
are we going to take it?  Is it enough that the device table here only
includes the Ethernet VF ID or do we want to actively prevent what
might be a trivial enabling of migration for another device type
because we envision it happening through an industry standard that
currently doesn't exist?  Sorry if I'm not familiar with the dynamics
of the NVMe working group or previous agreements.  Thanks,

Alex

