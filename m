Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7816CAA73
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 18:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbjC0QVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 12:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbjC0QVx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 12:21:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3DFA3
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679934064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MfPEz+gSgW7GAR9BiPtZZaLjByj1qxYcpBtut/UkmIQ=;
        b=EtCoj4gQa4c7hJ5bOUSrQ5tOsppRrnOSbMmf5B2Sngh2WUw3z3mBdZY1JMkhz6ImY/dH12
        /41CG2EqDe/sy7EK2WkjsUE3N9AtRX1rp2mrEqXwudxBI8n8I/y1NIu1jdwmywOrbLJR2w
        6VGiFUqDS5CIdN8ZXKrBj3kkDFXlHms=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-K3eNeABJM4KQGvAnClK-vw-1; Mon, 27 Mar 2023 12:21:02 -0400
X-MC-Unique: K3eNeABJM4KQGvAnClK-vw-1
Received: by mail-il1-f200.google.com with SMTP id z8-20020a92cd08000000b00317b27a795aso6164864iln.0
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:21:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679934061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MfPEz+gSgW7GAR9BiPtZZaLjByj1qxYcpBtut/UkmIQ=;
        b=xes/YUqTLL8LMb8U82nHQPdyG/70uxnm4cSyKa2QsZKO4MwJSCYPCONAF3pbb6s6CQ
         szZYr/xdQH3N9C3FK9ozfkVPVKbd/sKjAsFazQ+ypFcVLPR+pDuHV0MH5S682BaNzOTG
         VrX5sS4l1amWBUTW2NB2TQ4I2L8BxA4kYwP6gFLksqdvlotg1eRy8LGFJX8cizLTiyfd
         3lR3bHC6dVJ3lTkAdA4O4vK0X+4Ai9VzaTRrEFmIp9o2hZ9SEvUQUONqr6na+yISd2Fj
         3FkC/wzkcVF+yDi0lkA3cg1OuNT9uqWH6WwK/03a/vvACmsSTbI92NWcdjE35ecR61qG
         ZUbQ==
X-Gm-Message-State: AO0yUKV9F6WxHaMXogORkDk/faiBKXLw6dt+Gv/D9RaTBbj/wZKwMMD9
        C0Re/yCqM/Vq0XXJYFY65jLnAzY+sgzBg0rznUzEhMzZliCeSdEQl65MXQ4v+ijB0qLPOnQW4Bj
        cahYzWFVIsRsd
X-Received: by 2002:a5e:a913:0:b0:758:86ab:4b34 with SMTP id c19-20020a5ea913000000b0075886ab4b34mr9053730iod.13.1679934061536;
        Mon, 27 Mar 2023 09:21:01 -0700 (PDT)
X-Google-Smtp-Source: AK7set8uTOYHBXa0RoTj5j5FAO/eGKwapUq3IT2s8U5Wt0Nw+fHKT+LW7MnqNWmsoWzZvlcB3wX7PQ==
X-Received: by 2002:a5e:a913:0:b0:758:86ab:4b34 with SMTP id c19-20020a5ea913000000b0075886ab4b34mr9053720iod.13.1679934061298;
        Mon, 27 Mar 2023 09:21:01 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g8-20020a6b7608000000b0074c7db1470dsm7911949iom.20.2023.03.27.09.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 09:21:00 -0700 (PDT)
Date:   Mon, 27 Mar 2023 10:20:59 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD
 before VFIO_GROUP_GET_DEVICE_FD
Message-ID: <20230327102059.333d6976.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB75294EAD611174E5DEBFAAC8C3859@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230222022231.266381-1-yi.l.liu@intel.com>
        <BN9PR11MB5276EFCF9C8273C441D46DC38CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <DS0PR11MB75294EAD611174E5DEBFAAC8C3859@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 25 Mar 2023 12:37:02 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Tian, Kevin <kevin.tian@intel.com>
> > Sent: Wednesday, February 22, 2023 10:33 AM
> > 
> > Paolo's mail address is wrong. Added the right one.  
> 
> Thanks. @Alex, do you want a new version or this one is ok?

This one is fine.  Thanks,

Alex

> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Wednesday, February 22, 2023 10:23 AM
> > >
> > > as some vfio_device drivers require a kvm pointer to be set in their
> > > open_device and kvm pointer is set to VFIO in GROUP_ADD path.
> > >
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > > v2:
> > >  - Adopt Alex's suggestion
> > > v1: https://lore.kernel.org/kvm/20230221034114.135386-1-
> > > yi.l.liu@intel.com/
> > > ---
> > >  Documentation/virt/kvm/devices/vfio.rst | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > >
> > > diff --git a/Documentation/virt/kvm/devices/vfio.rst
> > > b/Documentation/virt/kvm/devices/vfio.rst
> > > index 2d20dc561069..79b6811bb4f3 100644
> > > --- a/Documentation/virt/kvm/devices/vfio.rst
> > > +++ b/Documentation/virt/kvm/devices/vfio.rst
> > > @@ -39,3 +39,10 @@ KVM_DEV_VFIO_GROUP attributes:
> > >  	- @groupfd is a file descriptor for a VFIO group;
> > >  	- @tablefd is a file descriptor for a TCE table allocated via
> > >  	  KVM_CREATE_SPAPR_TCE.
> > > +
> > > +::
> > > +
> > > +The GROUP_ADD operation above should be invoked prior to accessing  
> > the  
> > > +device file descriptor via VFIO_GROUP_GET_DEVICE_FD in order to  
> > support  
> > > +drivers which require a kvm pointer to be set in their .open_device()
> > > +callback.
> > > --
> > > 2.34.1  
> 

