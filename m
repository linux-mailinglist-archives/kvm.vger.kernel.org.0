Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F594C7BC5
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 22:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiB1VVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 16:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiB1VVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 16:21:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01600EFFA6
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 13:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646083239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u6wu1+m7/y8nI6BZGp4jNazhv0Rsh6xTe2mPvqYxCIw=;
        b=PLCqfJkOiN+PIQbU3K7tc5GNTG6NhjVxC4YSWarVGLQTw5dPA/YcALoe7XuFXZ5DApEKov
        9gc7+6ukUw80XnSUnyMpV+7+JaCwBUa9X7kkQG70IdYGCLvfvQwa5ZGsxJtUDM+Ghr/2NJ
        M79CzxuVlza0dvkK8Z4Egq+vkK8jK5I=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-D9yw3ZAGP9CtAD2hlHxPRA-1; Mon, 28 Feb 2022 16:20:38 -0500
X-MC-Unique: D9yw3ZAGP9CtAD2hlHxPRA-1
Received: by mail-oo1-f70.google.com with SMTP id 7-20020a4a0007000000b0031d5b7742c6so4724952ooh.2
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 13:20:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u6wu1+m7/y8nI6BZGp4jNazhv0Rsh6xTe2mPvqYxCIw=;
        b=NRODGwb09CF7GsCAPkLnyy+6W1gpFgG9F411tSlWeae1lJWIARgFFKA/+DR3LK1Tva
         4nEJf1nEO1mK8A6wNEytCnTo8GAxV/Nfahh+j+5CHUz0Zi2zuL0TTzY1FDOhdItDzR4z
         j9niZtQV+Ui4hEPnVbrI7wWzMsOfa1kYHSrwxfr1x3C3MYxAuF/oowFXZ9mR00UepAQ0
         w7ZQN0AwIGWJUOcNEHecVUZWpcgikD6jD2B8NSrMW2//SS3iw/1Oa/TxvmBI5CbawZoZ
         C+9r5baIJSuq9+NQNPdX1EJW/CJm13kK4eZtNfeOA+1K4Qsz5S7dG0VTTlJHakdEERBr
         Tv0w==
X-Gm-Message-State: AOAM533s7vairdD7lUyjIl0PLftq0rSlg4slJfq32n5VzwDjGO9lWJku
        1dpVRnLg9ItiXUiPx08lbgkHiVVlp47Lw/d3QTikBX6ZLME7bzVxrUnmPlGd6Z7KkMxiEanMm/y
        HuvHY6j4cZiqG
X-Received: by 2002:a05:6871:79b:b0:d3:4039:7e7c with SMTP id o27-20020a056871079b00b000d340397e7cmr9367042oap.121.1646083237870;
        Mon, 28 Feb 2022 13:20:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwHK6xVIr8qQr3M46nx2bUSEdvIL0NZBwiWDciAqFz2Oi4tFkHyMFlLCQIvyTFhjzN3Y8aPjg==
X-Received: by 2002:a05:6871:79b:b0:d3:4039:7e7c with SMTP id o27-20020a056871079b00b000d340397e7cmr9367028oap.121.1646083237618;
        Mon, 28 Feb 2022 13:20:37 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v5-20020a544d05000000b002d7652b3c52sm4722517oix.25.2022.02.28.13.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 13:20:37 -0800 (PST)
Date:   Mon, 28 Feb 2022 14:20:34 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v6 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220228142034.024e7be6.alex.williamson@redhat.com>
In-Reply-To: <20220228202919.GP219866@nvidia.com>
References: <20220228090121.1903-1-shameerali.kolothum.thodi@huawei.com>
        <20220228090121.1903-10-shameerali.kolothum.thodi@huawei.com>
        <20220228145731.GH219866@nvidia.com>
        <58fa5572e8e44c91a77bd293b2ec6e33@huawei.com>
        <20220228180520.GO219866@nvidia.com>
        <20220228131614.27ad37dc.alex.williamson@redhat.com>
        <20220228202919.GP219866@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Feb 2022 16:29:19 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Feb 28, 2022 at 01:16:14PM -0700, Alex Williamson wrote:
> > On Mon, 28 Feb 2022 14:05:20 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Mon, Feb 28, 2022 at 06:01:44PM +0000, Shameerali Kolothum Thodi wrote:
> > >   
> > > > +static long hisi_acc_vf_save_unl_ioctl(struct file *filp,
> > > > +                                      unsigned int cmd, unsigned long arg)
> > > > +{
> > > > +       struct hisi_acc_vf_migration_file *migf = filp->private_data;
> > > > +       loff_t *pos = &filp->f_pos;
> > > > +       struct vfio_device_mig_precopy precopy;
> > > > +       unsigned long minsz;
> > > > +
> > > > +       if (cmd != VFIO_DEVICE_MIG_PRECOPY)
> > > > +               return -EINVAL;    
> > > 
> > > ENOTTY
> > >   
> > > > +
> > > > +       minsz = offsetofend(struct vfio_device_mig_precopy, dirty_bytes);
> > > > +
> > > > +       if (copy_from_user(&precopy, (void __user *)arg, minsz))
> > > > +               return -EFAULT;
> > > > +       if (precopy.argsz < minsz)
> > > > +               return -EINVAL;
> > > > +
> > > > +       mutex_lock(&migf->lock);
> > > > +       if (*pos > migf->total_length) {
> > > > +               mutex_unlock(&migf->lock);
> > > > +               return -EINVAL;
> > > > +       }
> > > > +
> > > > +       precopy.dirty_bytes = 0;
> > > > +       precopy.initial_bytes = migf->total_length - *pos;
> > > > +       mutex_unlock(&migf->lock);
> > > > +       return copy_to_user((void __user *)arg, &precopy, minsz) ? -EFAULT : 0;
> > > > +}    
> > > 
> > > Yes
> > > 
> > > And I noticed this didn't include the ENOMSG handling, read() should
> > > return ENOMSG when it reaches EOS for the pre-copy:
> > > 
> > > + * During pre-copy the migration data FD has a temporary "end of stream" that is
> > > + * reached when both initial_bytes and dirty_byte are zero. For instance, this
> > > + * may indicate that the device is idle and not currently dirtying any internal
> > > + * state. When read() is done on this temporary end of stream the kernel driver
> > > + * should return ENOMSG from read(). Userspace can wait for more data (which may
> > > + * never come) by using poll.  
> > 
> > I'm confused by your previous reply that the use of curr_state should
> > be eliminated, isn't this ioctl only valid while the device is in the
> > PRE_COPY or PRE_COPY_P2P states?  Otherwise the STOP_COPY state would
> > have some expectation to be able to use this ioctl for devices
> > supporting PRE_COPY.    
> 
> I think it is fine to keep working on stop copy, though the
> implementation here isn't quite right for that..
> 
> if (migf->total_length > QM_MATCH_SIZE)
>    precopy.dirty_bytes = migf->total_length - QM_MATCH_SIZE - *pos;
> else
>    precopy.dity_bytes = 0;
> 
> if (*pos < QM_MATCH_SIZE)
>     precopy.initial_bytes = QM_MATCH_SIZE - *pos;
> else
>     precopy.initial_Bytes = 0;
> 
> Unless you think we should block it.

What's the meaning of initial_bytes and dirty_bytes while in STOP_COPY?
It seems like these become meaningless and if so, why shouldn't the
ioctl simply return -EINVAL if the device state doesn't match the
window where it's useful?

> > I'd like to see the uapi clarify exactly what states allow this
> > ioctl and define the behavior of the ioctl when transitioning out of
> > those states with an open data_fd, ie. is it defined to return an
> > -errno once in STOP_COPY?  Thanks,  
> 
> The ioctl is on the data_fd, so it should follow all the normal rules
> of the data_fd just like read() - ie all ioctls/read/write fails when
> teh state is moved outside one where the data_fd is valid.
> 
> That looks like another issue with the above, it doesn't chck
> migf->disabled.
> 
> Should we add another sentence about this?

Right, of course the ioctl goes away when the data_fd is invalid, the
question is more that we've created this PRE_COPY_* specific ioctl and
what does it mean to call it when not in a device state where the
data_fd is still valid but this ioctl is really not.  We should
specify how the driver is intended to respond to this ioctl in
STOP_COPY.  Thanks,

Alex

