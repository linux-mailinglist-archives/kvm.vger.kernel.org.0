Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298B04C7A30
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 21:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiB1URC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 15:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiB1URA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 15:17:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34F6131501
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 12:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646079378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G1qwirYd+erEvHJ95lOtyR0Vo6sDtD7Al1rwYNacQIM=;
        b=afuzBMKSE50cOh4PzglSTcvyPL0Tdvt/UFGXTgjMODkbzDxLUEvEa7VK2VkRfr45bHu1y/
        ZjEIOXDNV550fI1RUTvZURIDoR+3iSsblSFESJIxLyw7i47UYCFQAA8VWQrpEP1IRF7EYn
        RLeLDkW2rm5hUy1EDsPqyIDO9mSku0M=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-62rYY4xXMw62AUr4QHPiWw-1; Mon, 28 Feb 2022 15:16:17 -0500
X-MC-Unique: 62rYY4xXMw62AUr4QHPiWw-1
Received: by mail-oo1-f71.google.com with SMTP id t26-20020a4ac89a000000b0031c5daeddb4so9234808ooq.3
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 12:16:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G1qwirYd+erEvHJ95lOtyR0Vo6sDtD7Al1rwYNacQIM=;
        b=yQ4ckxwUC7oiCwM4jATSpu5fm9ahwmCKr9ES0klOLmO2YPU98PEuIVUYOxGr1JTWQc
         3D17Rs+S2h4auzL/ZFxusWFi5tBtestVhrOgS4bcLm6tsQCOHkYwrFJd3+Pz8Wok7mus
         9VpG4kI9WuuDH5ml6ZbMXrxFkTjKsNTaOJBibT156FccAIy6VvUZsoh9sxmO3Bmi1GgZ
         zedswVwUtzYsaCzOEFjcRcNBLqaRDWt/VygCu1Ee1nxI4NwdVZtk+S8Js6W8mURlbgFD
         MHQW/ugfipw85YwvNIh3IiKsYdFwjGx/KaNXQC6bF/oPIHIhko12+XOxlFZy/5Hu7dFy
         vIvQ==
X-Gm-Message-State: AOAM532w6CfEOcDRGb8+fB0PdOykMYCzv71e8ZekZjm+DRLiaiKE73/W
        XlHNWiwwvJVatyYhWHuQm1x2AxSy5iujcKm8uTCpwUATi0H6ZiNcaWfcGpuUY7i80FQaGgG/9xM
        kFXCFmR2IvQeU
X-Received: by 2002:a05:6808:2022:b0:2d4:752b:dfb5 with SMTP id q34-20020a056808202200b002d4752bdfb5mr10313214oiw.174.1646079376569;
        Mon, 28 Feb 2022 12:16:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwATX/TctczNS/gHsk9mEtkZD5TmnQxZgG63VALy5wIcqHFt0Pz7L2VnwImfYiFNYQ8F3+yVw==
X-Received: by 2002:a05:6808:2022:b0:2d4:752b:dfb5 with SMTP id q34-20020a056808202200b002d4752bdfb5mr10313198oiw.174.1646079376357;
        Mon, 28 Feb 2022 12:16:16 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a12-20020a056870d60c00b000d6d215bf88sm4908975oaq.37.2022.02.28.12.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 12:16:15 -0800 (PST)
Date:   Mon, 28 Feb 2022 13:16:14 -0700
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
Message-ID: <20220228131614.27ad37dc.alex.williamson@redhat.com>
In-Reply-To: <20220228180520.GO219866@nvidia.com>
References: <20220228090121.1903-1-shameerali.kolothum.thodi@huawei.com>
        <20220228090121.1903-10-shameerali.kolothum.thodi@huawei.com>
        <20220228145731.GH219866@nvidia.com>
        <58fa5572e8e44c91a77bd293b2ec6e33@huawei.com>
        <20220228180520.GO219866@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Feb 2022 14:05:20 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Feb 28, 2022 at 06:01:44PM +0000, Shameerali Kolothum Thodi wrote:
> 
> > +static long hisi_acc_vf_save_unl_ioctl(struct file *filp,
> > +                                      unsigned int cmd, unsigned long arg)
> > +{
> > +       struct hisi_acc_vf_migration_file *migf = filp->private_data;
> > +       loff_t *pos = &filp->f_pos;
> > +       struct vfio_device_mig_precopy precopy;
> > +       unsigned long minsz;
> > +
> > +       if (cmd != VFIO_DEVICE_MIG_PRECOPY)
> > +               return -EINVAL;  
> 
> ENOTTY
> 
> > +
> > +       minsz = offsetofend(struct vfio_device_mig_precopy, dirty_bytes);
> > +
> > +       if (copy_from_user(&precopy, (void __user *)arg, minsz))
> > +               return -EFAULT;
> > +       if (precopy.argsz < minsz)
> > +               return -EINVAL;
> > +
> > +       mutex_lock(&migf->lock);
> > +       if (*pos > migf->total_length) {
> > +               mutex_unlock(&migf->lock);
> > +               return -EINVAL;
> > +       }
> > +
> > +       precopy.dirty_bytes = 0;
> > +       precopy.initial_bytes = migf->total_length - *pos;
> > +       mutex_unlock(&migf->lock);
> > +       return copy_to_user((void __user *)arg, &precopy, minsz) ? -EFAULT : 0;
> > +}  
> 
> Yes
> 
> And I noticed this didn't include the ENOMSG handling, read() should
> return ENOMSG when it reaches EOS for the pre-copy:
> 
> + * During pre-copy the migration data FD has a temporary "end of stream" that is
> + * reached when both initial_bytes and dirty_byte are zero. For instance, this
> + * may indicate that the device is idle and not currently dirtying any internal
> + * state. When read() is done on this temporary end of stream the kernel driver
> + * should return ENOMSG from read(). Userspace can wait for more data (which may
> + * never come) by using poll.

I'm confused by your previous reply that the use of curr_state should
be eliminated, isn't this ioctl only valid while the device is in the
PRE_COPY or PRE_COPY_P2P states?  Otherwise the STOP_COPY state would
have some expectation to be able to use this ioctl for devices
supporting PRE_COPY.  I'd like to see the uapi clarify exactly what
states allow this ioctl and define the behavior of the ioctl when
transitioning out of those states with an open data_fd, ie. is it
defined to return an -errno once in STOP_COPY?  Thanks,

Alex

