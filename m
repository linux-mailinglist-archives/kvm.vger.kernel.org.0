Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2119471F428
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 22:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbjFAUsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 16:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbjFAUsI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 16:48:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063F71B0
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 13:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685652446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rmRZRfKWVEY0SEozIOD2eDdbXyNH6CzhN64nvWsaek4=;
        b=hcoGCZHX/bF7dj/+y+LhNr3cEo7qCC2h1wN64+IkzT1BpWyPosxhb3CSiUjkgz7LLjk7i0
        fiDyNlIQP3jmMgcvW1hgl79RdruhK79oR+vNiKC69I6/Kwhc4lRNYLfxpmosOSQE5k+haW
        OsK5BgKoECZazjNOZgi3ICq7km+hGf4=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-132-zxGF5nVWPAWr3p1ujhTgCw-1; Thu, 01 Jun 2023 16:47:24 -0400
X-MC-Unique: zxGF5nVWPAWr3p1ujhTgCw-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-777683e803bso29173039f.3
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 13:47:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685652444; x=1688244444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rmRZRfKWVEY0SEozIOD2eDdbXyNH6CzhN64nvWsaek4=;
        b=T5H//3lmG4mOSCYx3wL0i5iobudbDpm8S75Sa9fSlqDl5TZQd2tRD1IAHahrCceb40
         nPcicDdlSXsro/WrgS7jOoKYjR6AYhL+FAsWWPtJ6F8oQapP+XQCOKZNq4E0DkJBZsmn
         mW/hguQR3+l8u/BfRK8/1U2NQkEyJG73ZGiwiz6IAoQxiCU+462y3JFxuD3ai2Uric+a
         H7coKPnFLhCYC9+f1KmGUdwSR4whipIyisesuuuA2EwcP/Eg3M2M0ANNpeYBJ+rFRBj3
         Glyx8UTQUfmjMZVCuhpxXycD17WO2M9/zBCwQDpRjCDFSMmRiSv0Unl2ESu/EKFBUFVr
         PdpQ==
X-Gm-Message-State: AC+VfDwMpckIBcYPyE7Vg/tOvWlqC8Ltb5OSpRi/1Ibe/wkbmkKKBwYh
        rJnWKm7cUi6SYfvS0afpIgxaDm0k/7TEyNiqQd8061EzspvcXDPi4y7D8aWDnkQQW9K+XkoLDh/
        tIEEO7KnrtmF/kBE1Yg5k
X-Received: by 2002:a6b:6314:0:b0:774:982e:cb0a with SMTP id p20-20020a6b6314000000b00774982ecb0amr439738iog.15.1685652443900;
        Thu, 01 Jun 2023 13:47:23 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5SzX6PbeMg9q9vvXLKsxsPVcmec31tIfdfceJjEB6+21sbwbfrKA2JAoEEGHsUYkyz/sbdhA==
X-Received: by 2002:a6b:6314:0:b0:774:982e:cb0a with SMTP id p20-20020a6b6314000000b00774982ecb0amr439722iog.15.1685652443672;
        Thu, 01 Jun 2023 13:47:23 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l23-20020a056638221700b004164fe77c06sm2571841jas.26.2023.06.01.13.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 13:47:23 -0700 (PDT)
Date:   Thu, 1 Jun 2023 14:47:22 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        jjherne@linux.ibm.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, Cedric Le Goater <clegoate@redhat.com>
Subject: Re: [PATCH 0/3] s390/vfio-ap: fix hang when mdev attached to guest
 is removed
Message-ID: <20230601144722.6eba9c49.alex.williamson@redhat.com>
In-Reply-To: <30741787-441a-034f-f8d4-9f1060841051@linux.ibm.com>
References: <20230530223538.279198-1-akrowiak@linux.ibm.com>
        <30741787-441a-034f-f8d4-9f1060841051@linux.ibm.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 May 2023 10:51:54 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 5/30/23 6:35 PM, Tony Krowiak wrote:
> > When a user attempts to remove a vfio-ap mediated device attached to a
> > guest, the operation hangs until the mdev's fd is closed by the guest
> > (i.e., the hostdev is detached or the guest is shut down). This patch 
> > series provides kernel-side code that allows userspace to set up a 
> > communication channel that will allow the vfio_ap device driver to notify 
> > userspace when a request to release the mdev is received, so that userspace
> > can close the mdev fd and avoid the hang. The patch series provides the 
> > following:  
> > 
> > 1. Introduces code to handle the VFIO_DEVICE_GET_IRQ_INFO and 
> >    VFIO_DEVICE_SET_IRQS ioctl calls to set the eventfd_ctx for signaling a
> >    device request to userspace. 
> > 
> > 2. Wires up the VFIO bus driver callback to request a release of the mdev.
> >    When invoked, the vfio_ap device driver will use the eventfd_ctx set up
> >    in #1 to signal a request to userspace to release the mdev.
> >   
> 
> As to how this series eventually reaches master...  It touches both s390 and vfio.  
> 
> @Alex/@s390 maintainers -- I suggest it go through s390 given the
> diffstat, it's almost completely in s390 drivers code.  However there
> is a uapi hit to vfio.h (in patch 1) that should get at least an ACK
> from Alex beforehand.

Ack'd, I'll expect this to go through the s390 tree.  Thanks,

Alex

