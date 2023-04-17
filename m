Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58836E510C
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 21:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjDQTfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 15:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbjDQTez (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 15:34:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6481B5
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 12:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681760048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0qQGxbZ2Ila+Q997whosT821l4x4H8QzSUtQhvaCL+o=;
        b=KpCVkLann2LhuX/F7JfHQnlmvlGaAiOhsAFVBOCOtbs2Epao9YVJ7AZPZFt8qulf1aoCEs
        /K2RmTV6EnZDUL9OG2GUM6fjwXqzuGuVKR18pPALGz1CM5Eji3AXxLjefdxddqMbOhAuOT
        Wt2BHQaMBBKi1FlWyX2d96ZtY0Bm1NI=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-8ScQUTJGOSS3N2_w61FLKQ-1; Mon, 17 Apr 2023 15:34:07 -0400
X-MC-Unique: 8ScQUTJGOSS3N2_w61FLKQ-1
Received: by mail-il1-f200.google.com with SMTP id y7-20020a056e02128700b0032a9be7a8e4so3336851ilq.6
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 12:34:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681760047; x=1684352047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0qQGxbZ2Ila+Q997whosT821l4x4H8QzSUtQhvaCL+o=;
        b=Yb5/ohsfbNzvkZEBaI31/aZEtNoXas5+xqmhtG3yfeKIDWpfNrqsbSdpdKdWyBjKEn
         9IAh/hnBUlPQoBTdfUW7yVGJ2+DOYfcyhfm30S2Emx7o6IHh4toMDM5sydfjqzXuK24p
         tLDhJOEK4SA2TI6Y7QjJ6/wf1NqmucuUZWbu0SSBdLhRmfXPdSCwOUTQ9UWU1WNagxNk
         OXjkAyR1AfYBHbtGrTeDdDVH/nJATMmgiWRrMbxiC/Up4h81MFrxdwkPiUwSMiMHom9M
         Z4kP41DQvRWm6je7vegi7zGC+pJfdncuP0C36RbeBrsK3txA2Xw3Seoai17S2jOf+HhZ
         aNaQ==
X-Gm-Message-State: AAQBX9f0TqGPitzwrOUV5+eh/8HCdoW3eOLJHh8mnpwllOYSN3/a3PLx
        AtjCj32bx650fZPMSZWLWigkI4r+H3ZYwTKDrRSbOlfQPqWWfjr1nP9K0qTntp2SgSR5r3evJoy
        YPCLL7ORrmKgE
X-Received: by 2002:a6b:d30e:0:b0:763:5a15:5b0c with SMTP id s14-20020a6bd30e000000b007635a155b0cmr1493490iob.6.1681760046820;
        Mon, 17 Apr 2023 12:34:06 -0700 (PDT)
X-Google-Smtp-Source: AKy350YbGCKpuxX3FSGpwGzEfcn/NsieT3yolj4kjxkZv5G24STHUOQLOvCM5pgGGWTFPPFecos5YA==
X-Received: by 2002:a6b:d30e:0:b0:763:5a15:5b0c with SMTP id s14-20020a6bd30e000000b007635a155b0cmr1493472iob.6.1681760046552;
        Mon, 17 Apr 2023 12:34:06 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c12-20020a5ea80c000000b0075c47fb539asm3388760ioa.0.2023.04.17.12.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 12:34:06 -0700 (PDT)
Date:   Mon, 17 Apr 2023 13:34:05 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>
Subject: Re: [PATCH v2] docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD
 before VFIO_GROUP_GET_DEVICE_FD
Message-ID: <20230417133405.0891ae1a.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB75294B4B9E061F7CFEF94829C39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230222022231.266381-1-yi.l.liu@intel.com>
        <20230411132803.4628e9fc.alex.williamson@redhat.com>
        <20230414140801.17d27396.alex.williamson@redhat.com>
        <DS0PR11MB75294B4B9E061F7CFEF94829C39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Apr 2023 13:04:50 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Saturday, April 15, 2023 4:08 AM
> > On Tue, 11 Apr 2023 13:28:03 -0600
> > Alex Williamson <alex.williamson@redhat.com> wrote:
> >   
> > > On Tue, 21 Feb 2023 18:22:31 -0800
> > > Yi Liu <yi.l.liu@intel.com> wrote:
> > >  
> > > > as some vfio_device drivers require a kvm pointer to be set in their
> > > > open_device and kvm pointer is set to VFIO in GROUP_ADD path.
> > > >
> > > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > > ---
> > > > v2:
> > > >  - Adopt Alex's suggestion
> > > > v1: https://lore.kernel.org/kvm/20230221034114.135386-1-yi.l.liu@intel.com/
> > > > ---
> > > >  Documentation/virt/kvm/devices/vfio.rst | 7 +++++++
> > > >  1 file changed, 7 insertions(+)
> > > >
> > > > diff --git a/Documentation/virt/kvm/devices/vfio.rst  
> > b/Documentation/virt/kvm/devices/vfio.rst  
> > > > index 2d20dc561069..79b6811bb4f3 100644
> > > > --- a/Documentation/virt/kvm/devices/vfio.rst
> > > > +++ b/Documentation/virt/kvm/devices/vfio.rst
> > > > @@ -39,3 +39,10 @@ KVM_DEV_VFIO_GROUP attributes:
> > > >  	- @groupfd is a file descriptor for a VFIO group;
> > > >  	- @tablefd is a file descriptor for a TCE table allocated via
> > > >  	  KVM_CREATE_SPAPR_TCE.
> > > > +
> > > > +::
> > > > +
> > > > +The GROUP_ADD operation above should be invoked prior to accessing the
> > > > +device file descriptor via VFIO_GROUP_GET_DEVICE_FD in order to support
> > > > +drivers which require a kvm pointer to be set in their .open_device()
> > > > +callback.  
> > >
> > > I updated the title and commit log so as not to further construe that
> > > documentation can impose a requirement, otherwise applied to vfio next
> > > branch for v6.4.  Thanks,  
> > 
> > Dropped
> > 
> > https://lore.kernel.org/all/20230413163336.7ce6ecec.alex.williamson@redhat.com/
> > 
> > Please resubmit, resolving the warning and change the title since a
> > requirement of some drivers does not equate to a requirement of the
> > API.  Thanks,  
> 
> Sorry for it. May just remove the "::". So a version as below. Please let me
> know it is ok, then I'll submit it.

Sure, so long as the docs build warning is gone.  I'll wait for a
separate v3 posting.  Thanks,

Alex

 
> From abfc87425aa2977c08511b648a194bcfb072dcb8 Mon Sep 17 00:00:00 2001
> From: Yi Liu <yi.l.liu@intel.com>
> Date: Thu, 16 Feb 2023 02:37:28 -0800
> Subject: [PATCH] docs: kvm: vfio: Suggest KVM_DEV_VFIO_GROUP_ADD vs VFIO_GROUP_GET_DEVICE_FD ordering
> 
> as some vfio_device's open_device op requires kvm pointer and kvm pointer
> set is part of GROUP_ADD.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  Documentation/virt/kvm/devices/vfio.rst | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/devices/vfio.rst b/Documentation/virt/kvm/devices/vfio.rst
> index 2d20dc561069..79b6811bb4f3 100644
> --- a/Documentation/virt/kvm/devices/vfio.rst
> +++ b/Documentation/virt/kvm/devices/vfio.rst
> @@ -39,3 +39,8 @@ KVM_DEV_VFIO_GROUP attributes:
>  	- @groupfd is a file descriptor for a VFIO group;
>  	- @tablefd is a file descriptor for a TCE table allocated via
>  	  KVM_CREATE_SPAPR_TCE.
> +
> +The GROUP_ADD operation above should be invoked prior to accessing the
> +device file descriptor via VFIO_GROUP_GET_DEVICE_FD in order to support
> +drivers which require a kvm pointer to be set in their .open_device()
> +callback.

