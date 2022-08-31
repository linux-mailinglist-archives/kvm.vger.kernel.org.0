Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75365A84B2
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 19:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbiHaRsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 13:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiHaRsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 13:48:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E112B99F6
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 10:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661968097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MFM8G20h2y86tadKGRfdgvSUOpPfLBfziDAHYvDVzjw=;
        b=UXWfiLxOH7p6CrJyKWs+7eVVVdnhASCBK7cAkCSKTwBZHBxapWLbSJmZ9pEpjCWcqOlnx0
        IEZsP11z1ArPQKWTckJX9Rayt+ZlWpJxNl1H0GZKL4tr/UyiSl1E0O80VD44nqEgNJvKTF
        3RHOfdxx6k9FbxYCGpgYpf/shKlvyGE=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-517-dinXkB8HNDuYAU4s7cG4jw-1; Wed, 31 Aug 2022 13:48:16 -0400
X-MC-Unique: dinXkB8HNDuYAU4s7cG4jw-1
Received: by mail-io1-f70.google.com with SMTP id be26-20020a056602379a00b0068b50a068baso7134009iob.11
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 10:48:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=MFM8G20h2y86tadKGRfdgvSUOpPfLBfziDAHYvDVzjw=;
        b=BM/PqOtVOtCuD4YmHpC7Nl51Q8UeONpzIDyRZD0Gv0Q9ZzAR8oTp7zaLn8kZVpDL+q
         ywFC0mzMepR9s/C2vUJCj+T/g0nCANT1qbB4bSsGQcHi8wIW/eJFchfJ5n+HK6+QM66r
         Vy2sZHRJqCVX+kLO8BeD2R73DP1JF4ntav6MZNYetZI5Z5mZLeLvIB1ud5fyIqoQtwBK
         JH9BpoeAAbVswoiKi22ga3Db9w3s/R9hXfSyDK/kBFCNZfM/RLSDeCC1q3sLrJ3zdGUm
         jM9wQ1E27F9cJXgFO7gUDcjzqDiH/89hyOVqYVjoNjU47kMuIjh3hgYC5AG1S62N9OTe
         4peA==
X-Gm-Message-State: ACgBeo2U+AnprBmmhg+k9pEJs5RqX5HdefmxpvfiNgk4oWeCVXL3JjRi
        Z791N7pTDty1tWUXG228Yq3F5MgKrk34soMLuV+WTpkh0e9YF6/0yeMR2xXRiOZTBz+1GE+/jyW
        /2ARoTAD1I60e
X-Received: by 2002:a05:6638:3043:b0:341:d8a4:73e8 with SMTP id u3-20020a056638304300b00341d8a473e8mr15430055jak.239.1661968094897;
        Wed, 31 Aug 2022 10:48:14 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6+CfcvzPBONN2iPT2RRzjHiaxFZVzBVT87w2WH85kZRbul/NpX2oCrEUi/sPZ8Y4GRBDekjw==
X-Received: by 2002:a05:6638:3043:b0:341:d8a4:73e8 with SMTP id u3-20020a056638304300b00341d8a473e8mr15430044jak.239.1661968094717;
        Wed, 31 Aug 2022 10:48:14 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id d7-20020a02a487000000b003428c21ed12sm6911808jam.167.2022.08.31.10.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 10:48:14 -0700 (PDT)
Date:   Wed, 31 Aug 2022 11:48:12 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: Re: [PATCH 7/8] vfio: Follow the naming pattern for
 vfio_group_ioctl_unset_container()
Message-ID: <20220831114812.4a8a0e95.alex.williamson@redhat.com>
In-Reply-To: <Yw5ABqI20sMyNiG9@nvidia.com>
References: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
        <7-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
        <BN9PR11MB5276B0A8F6DD36C6482F37038C769@BN9PR11MB5276.namprd11.prod.outlook.com>
        <YwzbB5NZGOqOsOVK@nvidia.com>
        <20220830104231.0bbb7c89.alex.williamson@redhat.com>
        <Yw5ABqI20sMyNiG9@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 Aug 2022 13:51:18 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Aug 30, 2022 at 10:42:31AM -0600, Alex Williamson wrote:
> > On Mon, 29 Aug 2022 12:28:07 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Mon, Aug 29, 2022 at 12:41:30AM +0000, Tian, Kevin wrote:  
> > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > Sent: Thursday, August 18, 2022 12:07 AM
> > > > > 
> > > > > Make it clear that this is the body of the ioctl - keep the mutex outside
> > > > > the function since this function doesn't have and wouldn't benefit from
> > > > > error unwind.    
> > > > 
> > > > but doing so make unset_container() unpair with set_container() and
> > > > be the only one doing additional things in main ioctl body.
> > > > 
> > > > I'd prefer to moving mutex inside unset_container() for better readability.    
> > > 
> > > Yes, I tried both ways and ended up here since adding the goto unwind
> > > was kind of ungainly for this function. Don't mind either way
> > > 
> > > The functions are not intended as strict pairs, they are ioctl
> > > dispatch functions.  
> > 
> > The lockdep annotation seems sufficient, but what about simply
> > prefixing the unset ioctl function with underscores to reinforce the
> > locking requirement, as done by the called function
> > __vfio_group_unset_container()?  Thanks,  
> 
> Could do, but IMHO, that is not a popular convention in VFIO
> (anymore?).
> 
> I've been adding lockdep annotations, not adding __ to indicate
> the function is called with some kind of lock.
> 
> In my tree __vfio_group_get_from_iommu() is the only one left using
> that style. uset_container was turned into
> vfio_container_detatch_group() in aother series
> 
> Conversly we have __vfio_register_dev() which I guess __ indicates is
> internal or wrappered, not some statement about locking. I think this
> has become the more popular usage of the __ generally in the kernel
> 
> So I will do a v2 with the extra goto unwind then
> 
> Are there any other remarks before I do it?

None from me.  The pile of things relying on this series is growing, so
it looks like time to push v2.  Thanks,

Alex

