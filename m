Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E41F4B7B43
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 00:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbiBOXct (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 18:32:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244823AbiBOXcs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 18:32:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A980673C9
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 15:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644967956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HbY27dJz2tGl4xMXk2P1x5vlNbwhNu+BghSXyoUl3L0=;
        b=TKtW1jt4iWwJ1rA/HBp7OGfcmnUGIAfSqPIMLWvucgV3flCxV3mCap5amrKrdoImhuFK9i
        11i4OdcMKRmisCo3PBKhyuH07G630okPAzwDOsyiqNI/sJtHU701w+8thiFWeSWzOxr3KA
        IQT4H15bbrL3EoIDbS+xFuq9B4aL1Gw=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-HiRDljpJPBKIUs67KQD5Rg-1; Tue, 15 Feb 2022 18:32:35 -0500
X-MC-Unique: HiRDljpJPBKIUs67KQD5Rg-1
Received: by mail-oi1-f198.google.com with SMTP id t3-20020acaaa03000000b002d4174a211eso346153oie.5
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 15:32:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=HbY27dJz2tGl4xMXk2P1x5vlNbwhNu+BghSXyoUl3L0=;
        b=FWoHt1bHvY72b6uMPk1Zsg94UrE9m/gwBUOVjdVkJ1GmU0OSqwj9qDEho54FfsKb0L
         bsGhrEp6aCLjk1LpQLUp+LKNtmaitPpIeGhKOWyisJ09sAylbaaZc2rN4VsrB+vH6KhN
         WMzGs4ImD5YcixIhGE3BKZmcFU47p0cSycMY78cACifDPWS9Ey3pKFcRyGMIVuordvGI
         Ez7497+rRsNpO7ru4Bo05jBjPprBONMk7wG3Wyk7+M3muiC0+VhyXULvpj+Nj46NtGJY
         X7C9mIfXkqEC4aGwO3mODG9RxDD4osLqrLNSiMHtkUA69A6aVkVInNIx1fAOSB7X+nbv
         2W2Q==
X-Gm-Message-State: AOAM532lPN207xpmAiJew2iERmLfPSs/I4U9FQ61Uy8CByxoS1ekXhDX
        9Y8XOFvsgFmApIanRUkSTGH861CVTKWJ2vHDTM//Jm9r3auF5ISayeWR/Z5G0uLf6TDUp8NKgjN
        AH4z7YcPFNILa
X-Received: by 2002:a05:6830:1246:b0:5ac:7838:60b7 with SMTP id s6-20020a056830124600b005ac783860b7mr7912otp.289.1644967954624;
        Tue, 15 Feb 2022 15:32:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy5GogzupFoMRHMah1lwd6mBOKZQhEu4WVtQCgnMvmLCpF1QrMXCh1f92lxXeaSnmbkkeK19g==
X-Received: by 2002:a05:6830:1246:b0:5ac:7838:60b7 with SMTP id s6-20020a056830124600b005ac783860b7mr7899otp.289.1644967954371;
        Tue, 15 Feb 2022 15:32:34 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i26sm6683068oos.35.2022.02.15.15.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 15:32:33 -0800 (PST)
Date:   Tue, 15 Feb 2022 16:32:31 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V7 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Message-ID: <20220215163231.57f0ebb6.alex.williamson@redhat.com>
In-Reply-To: <20220215160419.GC1046125@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
        <20220207172216.206415-9-yishaih@nvidia.com>
        <20220208170754.01d05a1d.alex.williamson@redhat.com>
        <20220209023645.GN4160@nvidia.com>
        <BN9PR11MB5276BD03F292902A803FA0E58C349@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20220215160419.GC1046125@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Feb 2022 12:04:19 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Feb 15, 2022 at 10:41:56AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, February 9, 2022 10:37 AM
> > >   
> > > > >  /* -------- API for Type1 VFIO IOMMU -------- */
> > > > >
> > > > >  /**  
> > > >
> > > > Otherwise, I'm still not sure how userspace handles the fact that it
> > > > can't know how much data will be read from the device and how important
> > > > that is.  There's no replacement of that feature from the v1 protocol
> > > > here.  
> > > 
> > > I'm not sure this was part of the v1 protocol either. Yes it had a
> > > pending_bytes, but I don't think it was actually expected to be 100%
> > > accurate. Computing this value accurately is potentially quite
> > > expensive, I would prefer we not enforce this on an implementation
> > > without a reason, and qemu currently doesn't make use of it.
> > > 
> > > The ioctl from the precopy patch is probably the best approach, I
> > > think it would be fine to allow that for stop copy as well, but also
> > > don't see a usage right now.
> > > 
> > > It is not something that needs decision now, it is very easy to detect
> > > if an ioctl is supported on the data_fd at runtime to add new things
> > > here when needed.
> > >   
> > 
> > Another interesting thing (not an immediate concern on this series)
> > is how to handle devices which may have long time (e.g. due to 
> > draining outstanding requests, even w/o vPRI) to enter the STOP 
> > state. that time is not as deterministic as pending bytes thus cannot
> > be reported back to the user before the operation is actually done.  
> 
> Well, it is not deterministic at all..
> 
> I suppose you have to do as Alex says and try to estimate how much
> time the stop phase of migration will take and grant only the
> remaining time from the SLA to the guest to finish its PRI flushing,
> otherwise go back to PRE_COPY and try again later if the timer hits.
> 
> This suggests to me the right interface from the driver is some
> estimate of time to enter STOP_COPY and resulting required transfer
> size.
> 
> Still, I just don't see how SLAs can really be feasible with this kind
> of HW that requires guest co-operation..

Devil's advocate, does this discussion raise any concerns whether a
synchronous vs asynchronous arc transition ioctl is still the right
solution here?  I can imagine for instance that posting a state change
and being able to poll for pending transactions or completion of the
saved state generation and ultimate size could be very useful for
managing migration SLAs, not to mention trivial userspace support to
parallel'ize state changes.

Reporting a maximum device state size hint also seems relatively
trivial since this should just be the sum of on-device memory, asics,
and processors.  The mlx5 driver already places an upper bound on
migration data size internally.

Maybe some of these can come as DEVICE_FEATURES as we go, but for any
sort of cloud vendor SLA, I'm afraid we're only enabling migration of
devices with negligible transition latencies and negligible device
states, with some hand waving how to determine that either of those are
the case without device specific knowledge in the orchestration.
Thanks,

Alex

