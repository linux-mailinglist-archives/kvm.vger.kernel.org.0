Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91AB623AA8
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 04:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbiKJDvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 22:51:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbiKJDvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 22:51:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D88E2F016
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 19:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668052201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=60TErWgB0U0U1ocEUPR6YUn8kraoamkgfQY4MoeZxSA=;
        b=DyigSyuQrIFip8vN+KyTs/6qRA0y6E2P26kGKohol+gFlRtt88KjkGR0Y0jezfXWqZ1Tuw
        1cRB86XMCZGy9H4WnwvJto4cCVwtTd0M6zY6t08b3YW3a+aHoTI0UMuQZm6OcvsLUrAC9f
        rDJdZJyRRpikvOWjH9YISdIn0BMbdmQ=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-572-RcY8gfy0PQ2I2Om01s55KA-1; Wed, 09 Nov 2022 22:49:59 -0500
X-MC-Unique: RcY8gfy0PQ2I2Om01s55KA-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-13b9bcc6b4cso478361fac.13
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 19:49:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=60TErWgB0U0U1ocEUPR6YUn8kraoamkgfQY4MoeZxSA=;
        b=HTmBwendI6rxSJSZfeWN6QNNiwlkZ1oR2G+OT4LhmJlVKBIXs+3RV6UQUt5sZ6FlHs
         k/9oZs+FijtZF479UdkoU96rBD2cW55h2lL5SAHM08lKhZubs8RyM+zi6n/67eIBhysF
         Cz3+YNsDLSzeZ0RHFvW9cGMN7JPfSI+77BE75lIBEGiizd60c8lRezUNnc2jTkMbnD6c
         /z4P+faqWabclxQR+nx2P6xixT0no3miKLM5jOzAGoP/5s4vMHQLY2aIueVi+Otb93UF
         FUpGd7B5hSI/tbUWOjQFCfnqz34QvOqVAAJTR7vT3ibOXek6Ix59hYSPEOF2oC9LQ3RM
         POZA==
X-Gm-Message-State: ACrzQf1pU5vf1+cs/2EVXfc5/9BgjL1hGfY84Z2Wy75eDK4ZbzZ0z+EO
        cNqNbvEBfuvMQtEVO5QsUb7rD49tqeySzyj9h/lEjzDnMYCPNkhP/oBlZkcZ9avVdC1xDz1wC6m
        O6mbEO7ALWgF/77p6GzV6J0j9Oo98
X-Received: by 2002:a05:6871:54e:b0:13b:29b7:e2e8 with SMTP id t14-20020a056871054e00b0013b29b7e2e8mr45759489oal.35.1668052199260;
        Wed, 09 Nov 2022 19:49:59 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6Yn+hSnYW2dtP/B4LNuU0FW2fGT1rkHGvoIuVlS3fet4Oamq0Y/5dGPg9Iq0HjoNmQTXjGOGpClzetCS9bnaE=
X-Received: by 2002:a05:6871:54e:b0:13b:29b7:e2e8 with SMTP id
 t14-20020a056871054e00b0013b29b7e2e8mr45759486oal.35.1668052199063; Wed, 09
 Nov 2022 19:49:59 -0800 (PST)
MIME-Version: 1.0
References: <20221107093345.121648-1-lingshan.zhu@intel.com>
 <CACGkMEs9af1E1pLd2t8E71YBPF=rHkhfN8qO9_3=x6HVaCMAxg@mail.gmail.com>
 <0b15591f-9e49-6383-65eb-6673423f81ec@intel.com> <CACGkMEujqOFHv7QATWgYo=SdAKef5jQXi2-YksjgT-hxEgKNDQ@mail.gmail.com>
 <80cdd80a-16fa-ac75-0a89-5729b846efed@intel.com>
In-Reply-To: <80cdd80a-16fa-ac75-0a89-5729b846efed@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 10 Nov 2022 11:49:47 +0800
Message-ID: <CACGkMEu-5TbA3Ky2qgn-ivfhgfJ2b12mDJgq8iNgHce8qu3ApA@mail.gmail.com>
Subject: Re: [PATCH 0/4] ifcvf/vDPA implement features provisioning
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, hang.yuan@intel.com, piotr.uminski@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 9, 2022 at 5:06 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>
>
>
> On 11/9/2022 4:59 PM, Jason Wang wrote:
> > On Wed, Nov 9, 2022 at 4:14 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
> >>
> >>
> >> On 11/9/2022 2:51 PM, Jason Wang wrote:
> >>> On Mon, Nov 7, 2022 at 5:42 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
> >>>> This series implements features provisioning for ifcvf.
> >>>> By applying this series, we allow userspace to create
> >>>> a vDPA device with selected (management device supported)
> >>>> feature bits and mask out others.
> >>> I don't see a direct relationship between the first 3 and the last.
> >>> Maybe you can state the reason why the restructure is a must for the
> >>> feature provisioning. Otherwise, we'd better split the series.
> >> When introducing features provisioning ability to ifcvf, there is a need
> >> to re-create vDPA devices
> >> on a VF with different feature bits.
> > This seems a requirement even without feature provisioning? Device
> > could be deleted from the management device anyhow.
> Yes, we need this to delete and re-create a vDPA device.

I wonder if we need something that works for -stable.

AFAIK, we can move the vdpa_alloc_device() from probe() to dev_add()
and it seems to work?

Thanks

>
> We create vDPA device from a VF, so without features provisioning
> requirements,
> we don't need to re-create the vDPA device. But with features provisioning,
> it is a must now.
>
> Thanks
>
>
> >
> > Thakns
> >
> >> When remove a vDPA device, the container of struct vdpa_device (here is
> >> ifcvf_adapter) is free-ed in
> >> dev_del() interface, so we need to allocate ifcvf_adapter in dev_add()
> >> than in probe(). That's
> >> why I have re-factored the adapter/mgmt_dev code.
> >>
> >> For re-factoring the irq related code and ifcvf_base, let them work on
> >> struct ifcvf_hw, the
> >> reason is that the adapter is allocated in dev_add(), if we want theses
> >> functions to work
> >> before dev_add(), like in probe, we need them work on ifcvf_hw than the
> >> adapter.
> >>
> >> Thanks
> >> Zhu Lingshan
> >>> Thanks
> >>>
> >>>> Please help review
> >>>>
> >>>> Thanks
> >>>>
> >>>> Zhu Lingshan (4):
> >>>>     vDPA/ifcvf: ifcvf base layer interfaces work on struct ifcvf_hw
> >>>>     vDPA/ifcvf: IRQ interfaces work on ifcvf_hw
> >>>>     vDPA/ifcvf: allocate ifcvf_adapter in dev_add()
> >>>>     vDPA/ifcvf: implement features provisioning
> >>>>
> >>>>    drivers/vdpa/ifcvf/ifcvf_base.c |  32 ++-----
> >>>>    drivers/vdpa/ifcvf/ifcvf_base.h |  10 +-
> >>>>    drivers/vdpa/ifcvf/ifcvf_main.c | 156 +++++++++++++++-----------------
> >>>>    3 files changed, 89 insertions(+), 109 deletions(-)
> >>>>
> >>>> --
> >>>> 2.31.1
> >>>>
>

