Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1C069E6BF
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 19:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjBUSDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 13:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjBUSDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 13:03:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6623AA9
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 10:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677002585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X5G7yNJYR/7nFmDPXDuo4nvzidlzmsTdXIb/lCyVhoE=;
        b=iG5hunCAay3hdfWOTuRk+/0Jaw6exa+uf0esvVqRjeZWXvVh84QWu5VUiADKaTCy3Os0p4
        04M6u1l1Q9NDefrv2QS6BQ/B10Exe0Po2eNcw7L9nQBhrF2jXRg0qrOraRpCKn0VzoebLz
        MtCRPvuBJSHXF53C10X/2T2CBQSYgmQ=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-414-xmjfTELSOnGFldFq3taqjA-1; Tue, 21 Feb 2023 13:03:04 -0500
X-MC-Unique: xmjfTELSOnGFldFq3taqjA-1
Received: by mail-il1-f197.google.com with SMTP id y14-20020a92c74e000000b003157134a9fbso2148760ilp.2
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 10:03:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X5G7yNJYR/7nFmDPXDuo4nvzidlzmsTdXIb/lCyVhoE=;
        b=eyHDL+melnOBN1rK70ipKk0mbGLnv3QUHHxWMZOI/jZiDNC0TCkEYCPkbMsC+20uZk
         UCQ8T+V1LS98xPSAuku+7RqFI0y2NBL9h5lLmup2t1fI4LKYwU28ysfU9jTqbHfact1P
         iEwYfCBZhxCzWkZYFZDlIva+UKpFUZf0iJy7tNja1PtXh3UYpqwhiN9pd6/1EB3fusdS
         RdkaedGxACeG7EnxUgbWbeDt7Dr9+ZEU5Z5SCj9cqrtrk6J6FAKwdqQ4cMdtqoohMHvX
         Agq4Xp+ln9hc6yYLwLIWaDp1EhmU05XlfrDd92XsdROAmQV5YnnIhRCOiSh+N/6DiGJh
         du8Q==
X-Gm-Message-State: AO0yUKV7FYP7WZtb9Thd4UIyLofSkPUkmqpHt0FwzPjXupkBYJpuQMnO
        fAGhGgaIhD98JKcMEZLhVVwo2V4i1m6reR7KxfiFzYo2W26MLn2jiU1p3fUEuRYk40B8WtdGecI
        23BdUCJZXDPwA
X-Received: by 2002:a05:6e02:221d:b0:315:69ef:345d with SMTP id j29-20020a056e02221d00b0031569ef345dmr2844793ilf.16.1677002583287;
        Tue, 21 Feb 2023 10:03:03 -0800 (PST)
X-Google-Smtp-Source: AK7set/hLeVsKTqTWrORz6QWWSp1fT0Ez9wF5+sgA3ye/y/dTmsm7MwxUyeQMsrKgy04bowZYojXSg==
X-Received: by 2002:a05:6e02:221d:b0:315:69ef:345d with SMTP id j29-20020a056e02221d00b0031569ef345dmr2844771ilf.16.1677002582978;
        Tue, 21 Feb 2023 10:03:02 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a25-20020a029999000000b0038a6ae38ceasm356488jal.26.2023.02.21.10.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 10:03:02 -0800 (PST)
Date:   Tue, 21 Feb 2023 11:03:00 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH] docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD
 before VFIO_GROUP_GET_DEVICE_FD
Message-ID: <20230221110300.0a36a3f6.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529D25552603AAE0A557034C3A59@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230221034114.135386-1-yi.l.liu@intel.com>
        <20230220213916.212e03a4.alex.williamson@redhat.com>
        <DS0PR11MB7529D25552603AAE0A557034C3A59@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Feb 2023 05:07:36 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, February 21, 2023 12:39 PM
> > 
> > On Mon, 20 Feb 2023 19:41:14 -0800
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >   
> > > as some vfio_device's open_device op requires kvm pointer and kvm  
> > pointer  
> > > set is part of GROUP_ADD.
> > >
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  Documentation/virt/kvm/devices/vfio.rst | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/Documentation/virt/kvm/devices/vfio.rst  
> > b/Documentation/virt/kvm/devices/vfio.rst  
> > > index 2d20dc561069..5722e283f1b5 100644
> > > --- a/Documentation/virt/kvm/devices/vfio.rst
> > > +++ b/Documentation/virt/kvm/devices/vfio.rst
> > > @@ -39,3 +39,8 @@ KVM_DEV_VFIO_GROUP attributes:
> > >  	- @groupfd is a file descriptor for a VFIO group;
> > >  	- @tablefd is a file descriptor for a TCE table allocated via
> > >  	  KVM_CREATE_SPAPR_TCE.
> > > +
> > > +::
> > > +
> > > +The GROUP_ADD operation above should be invoked before  
> > vfio_device's  
> > > +open_device op which is called in the ioctl  
> > VFIO_GROUP_GET_DEVICE_FD.
> > 
> > Why only include the reasoning in the commit log and not the docs?  
> 
> Oops, sure. How about below?
> 
> KVM_DEV_VFIO_GROUP_ADD has a duty to set the kvm pointer to VFIO as some
> vfio_devices require kvm pointer to open_device. Like gvt-g, vfio-ap and etc.
> Meanwhile, open_device is part of VFIO_GROUP_GET_DEVICE_FD. Hence user should
> invoke KVM_DEV_VFIO_GROUP_ADD before VFIO_GROUP_GET_DEVICE_FD.

How about:

The GROUP_ADD operation above should be invoked prior to accessing the
device file descriptor via VFIO_GROUP_GET_DEVICE_FD in order to support
drivers which require a kvm pointer to be set in their .open_device()
callback.

Thanks,
Alex

