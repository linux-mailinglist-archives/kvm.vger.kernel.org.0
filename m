Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC536E2AED
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 22:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjDNUIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 16:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjDNUIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 16:08:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC25865BC
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 13:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681502887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vr6uwSQuXozRClSp8sqfIkdgWu/iFgT8RltUCx6FP5I=;
        b=SJJ7qF+QcAnGdB5YYy5coAW78vFJEVUlRlPwzwfNcejlDULHwpoGTAyVjaXbszhYpvksGM
        f2oOdxgiyXPCGmDqcI8F3I8c6452gWQNVNa2rm21EHMNWpc/DfVVusGbGK9yOce/yhRQwK
        MHw6jIoRQAUP5rW5J6WPtWGEF6pSwgc=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-FKGUaoN1MlOB4P7IhYVDFQ-1; Fri, 14 Apr 2023 16:08:05 -0400
X-MC-Unique: FKGUaoN1MlOB4P7IhYVDFQ-1
Received: by mail-io1-f70.google.com with SMTP id h7-20020a6bb707000000b00760a8765317so3901689iof.23
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 13:08:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681502885; x=1684094885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vr6uwSQuXozRClSp8sqfIkdgWu/iFgT8RltUCx6FP5I=;
        b=hnc5Sns497HNW+8zqSlaRgB1tcVZyi6ivFZwUlexNkqfkdMhcTQ01GskzaUCV6fUVx
         epnt4o3Vyg5cweZSaOJkfFkzumBHOR9BXJxm9qWhWDsIiWAb+kNdUcBXID964j4WIz45
         lB/ZxFOaLqf8d8RNLJNFKWSI/MnvTlMZQIgx35jDTeWb+O7PnicZ8zcjaAa3j4YmXxPo
         Qdz9EjqCVipxm/90UFmkBIBOvU+OmWVGYD4iwsM10CAOOle49EkNeT8P8eiMJfD2ZFIk
         QJTjTXDMpktl2NEq1Wvf7HLKon6CWjU2kvdWmhgoBe8BDIsfR0nUfcW4XYRCjUUp/eEV
         Uavw==
X-Gm-Message-State: AAQBX9eZsuYUJPwlbEByC8EswPu2jEl0g0rPzLaQjupq2M4WG2i2J7Du
        jxv5b6AIAvPGEiWU5ulXKqnqc8KGrU1S8/No5p7rW63IMkqN/umBuFtxeVhMUF+JrK61+9AtYe6
        ZrJVNUDWHzefn
X-Received: by 2002:a5d:9844:0:b0:750:c68e:f028 with SMTP id p4-20020a5d9844000000b00750c68ef028mr3717453ios.9.1681502884903;
        Fri, 14 Apr 2023 13:08:04 -0700 (PDT)
X-Google-Smtp-Source: AKy350YpKWDpYWmic9y1b5BSJ7sAH6feMT18EXGxjhNBFhsUS6kpQechjkHGGpWk0NrK3gFgdxhw3A==
X-Received: by 2002:a5d:9844:0:b0:750:c68e:f028 with SMTP id p4-20020a5d9844000000b00750c68ef028mr3717446ios.9.1681502884655;
        Fri, 14 Apr 2023 13:08:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m6-20020a026d06000000b003bf39936d1esm1394867jac.131.2023.04.14.13.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 13:08:03 -0700 (PDT)
Date:   Fri, 14 Apr 2023 14:08:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, cohuck@redhat.com,
        eric.auger@redhat.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        pbonzini@redhat.co
Subject: Re: [PATCH v2] docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD
 before VFIO_GROUP_GET_DEVICE_FD
Message-ID: <20230414140801.17d27396.alex.williamson@redhat.com>
In-Reply-To: <20230411132803.4628e9fc.alex.williamson@redhat.com>
References: <20230222022231.266381-1-yi.l.liu@intel.com>
        <20230411132803.4628e9fc.alex.williamson@redhat.com>
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

On Tue, 11 Apr 2023 13:28:03 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 21 Feb 2023 18:22:31 -0800
> Yi Liu <yi.l.liu@intel.com> wrote:
> 
> > as some vfio_device drivers require a kvm pointer to be set in their
> > open_device and kvm pointer is set to VFIO in GROUP_ADD path.
> > 
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> > v2:
> >  - Adopt Alex's suggestion
> > v1: https://lore.kernel.org/kvm/20230221034114.135386-1-yi.l.liu@intel.com/
> > ---
> >  Documentation/virt/kvm/devices/vfio.rst | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/devices/vfio.rst b/Documentation/virt/kvm/devices/vfio.rst
> > index 2d20dc561069..79b6811bb4f3 100644
> > --- a/Documentation/virt/kvm/devices/vfio.rst
> > +++ b/Documentation/virt/kvm/devices/vfio.rst
> > @@ -39,3 +39,10 @@ KVM_DEV_VFIO_GROUP attributes:
> >  	- @groupfd is a file descriptor for a VFIO group;
> >  	- @tablefd is a file descriptor for a TCE table allocated via
> >  	  KVM_CREATE_SPAPR_TCE.
> > +
> > +::
> > +
> > +The GROUP_ADD operation above should be invoked prior to accessing the
> > +device file descriptor via VFIO_GROUP_GET_DEVICE_FD in order to support
> > +drivers which require a kvm pointer to be set in their .open_device()
> > +callback.  
> 
> I updated the title and commit log so as not to further construe that
> documentation can impose a requirement, otherwise applied to vfio next
> branch for v6.4.  Thanks,

Dropped

https://lore.kernel.org/all/20230413163336.7ce6ecec.alex.williamson@redhat.com/

Please resubmit, resolving the warning and change the title since a
requirement of some drivers does not equate to a requirement of the
API.  Thanks,

Alex

