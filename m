Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2890C623E62
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 10:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiKJJO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 04:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiKJJO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 04:14:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD4F51C2E
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 01:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668071638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Eo+993tzPE//U6vfrnyaKgpwg49AGZ5ezTqTVPuNTw=;
        b=iGVSU1+hzw/Vfs2X+1d/TCuEoVq0nnvaSyr0CfRO1NVASmd+XS59RWIAVJPIjq/qW4o331
        FVsd3ppXowWamSI2X+V/sSNOYKTWA4k7iyfYpIjukx9CSQn5FEWevyQTSQ5SEk/JheUsNT
        ZcxN40e4/e7tA5h9VrPV74YtDO4spMY=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-416-AumPWU5-MfuUYODFo7gQpQ-1; Thu, 10 Nov 2022 04:13:56 -0500
X-MC-Unique: AumPWU5-MfuUYODFo7gQpQ-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-13bdcfbd787so751422fac.18
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 01:13:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Eo+993tzPE//U6vfrnyaKgpwg49AGZ5ezTqTVPuNTw=;
        b=aLCEDvuaIfiHzedXqoqIdsXUoOTx/g40K8vc5A7RIc4LErYw2aJW1bFibGtEg8+sHs
         6f0z+zJeaJzEKfY5D37V8UqzTh7nqUBTf1oZtbRkjccpijz9F+ty38U/FYb7K3hwtg2/
         Qt5igVn+bkO09HAptDXkMf91Ln7nzUx3Cu5QzeihIaMi9ZjIPff9QW1rBD2t5l2tMkiB
         xVN5ugz6fwIHesRT1JYOTNZP9WhU1WfiOvun3WOnfGIhU6Rk1fWlypvzBW6VjGf/8JaT
         dD2UQS2KRE7EJu9Mjn+mOZthkobjesLvA0SQNVfRnFN5+Z2dvwe+yHiQ7JCOE63nAQBr
         H6JA==
X-Gm-Message-State: ACrzQf2IEl9PY0dXF24KXLccqO4UUSnmjoohGXqslQq+HVmvVtjv6mOu
        RqH3+SuTA3DJ+zP9HCKBeyIV5dr8PhyDBPxGLuDT5zWTIiA24BAE+LXKE/M+pvmoFF7mSv4oFVj
        AY42VPKU0OKOaA0Teba5BasnpXPqs
X-Received: by 2002:a05:6808:181e:b0:35a:5959:5909 with SMTP id bh30-20020a056808181e00b0035a59595909mr17332934oib.35.1668071636100;
        Thu, 10 Nov 2022 01:13:56 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5g8DkSxI973B+iDAGilOnCuX4Ay70bh6mLHXgA5dZRuIYpLjeNOnYvc77Ze9zce4mijbGDhSRedk2PxKgKvYA=
X-Received: by 2002:a05:6808:181e:b0:35a:5959:5909 with SMTP id
 bh30-20020a056808181e00b0035a59595909mr17332927oib.35.1668071635886; Thu, 10
 Nov 2022 01:13:55 -0800 (PST)
MIME-Version: 1.0
References: <20221107093345.121648-1-lingshan.zhu@intel.com>
 <CACGkMEs9af1E1pLd2t8E71YBPF=rHkhfN8qO9_3=x6HVaCMAxg@mail.gmail.com>
 <0b15591f-9e49-6383-65eb-6673423f81ec@intel.com> <CACGkMEujqOFHv7QATWgYo=SdAKef5jQXi2-YksjgT-hxEgKNDQ@mail.gmail.com>
 <80cdd80a-16fa-ac75-0a89-5729b846efed@intel.com> <CACGkMEu-5TbA3Ky2qgn-ivfhgfJ2b12mDJgq8iNgHce8qu3ApA@mail.gmail.com>
 <03657084-98ab-93bc-614a-e6cc7297d93e@intel.com> <d59c311f-ba9f-4c00-28f8-c50e099adb9f@redhat.com>
 <3286ad00-e432-da69-a041-6a3032494470@intel.com>
In-Reply-To: <3286ad00-e432-da69-a041-6a3032494470@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 10 Nov 2022 17:13:44 +0800
Message-ID: <CACGkMEuca97Cv+XuKxmHHHgAQYsayZvJRtpONCCqcEE8qMu5Kw@mail.gmail.com>
Subject: Re: [PATCH 0/4] ifcvf/vDPA implement features provisioning
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, hang.yuan@intel.com, piotr.uminski@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 10, 2022 at 4:59 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrot=
e:
>
>
>
> On 11/10/2022 2:29 PM, Jason Wang wrote:
> >
> > =E5=9C=A8 2022/11/10 14:20, Zhu, Lingshan =E5=86=99=E9=81=93:
> >>
> >>
> >> On 11/10/2022 11:49 AM, Jason Wang wrote:
> >>> On Wed, Nov 9, 2022 at 5:06 PM Zhu, Lingshan
> >>> <lingshan.zhu@intel.com> wrote:
> >>>>
> >>>>
> >>>> On 11/9/2022 4:59 PM, Jason Wang wrote:
> >>>>> On Wed, Nov 9, 2022 at 4:14 PM Zhu, Lingshan
> >>>>> <lingshan.zhu@intel.com> wrote:
> >>>>>>
> >>>>>> On 11/9/2022 2:51 PM, Jason Wang wrote:
> >>>>>>> On Mon, Nov 7, 2022 at 5:42 PM Zhu Lingshan
> >>>>>>> <lingshan.zhu@intel.com> wrote:
> >>>>>>>> This series implements features provisioning for ifcvf.
> >>>>>>>> By applying this series, we allow userspace to create
> >>>>>>>> a vDPA device with selected (management device supported)
> >>>>>>>> feature bits and mask out others.
> >>>>>>> I don't see a direct relationship between the first 3 and the las=
t.
> >>>>>>> Maybe you can state the reason why the restructure is a must for
> >>>>>>> the
> >>>>>>> feature provisioning. Otherwise, we'd better split the series.
> >>>>>> When introducing features provisioning ability to ifcvf, there is
> >>>>>> a need
> >>>>>> to re-create vDPA devices
> >>>>>> on a VF with different feature bits.
> >>>>> This seems a requirement even without feature provisioning? Device
> >>>>> could be deleted from the management device anyhow.
> >>>> Yes, we need this to delete and re-create a vDPA device.
> >>> I wonder if we need something that works for -stable.
> >> I can add a fix tag, so these three patches could apply to stable
> >
> >
> > It's too huge for -stable.
> >
> >
> >>>
> >>> AFAIK, we can move the vdpa_alloc_device() from probe() to dev_add()
> >>> and it seems to work?
> >> Yes and this is done in this series and that's why we need these
> >> refactoring code.
> >
> >
> > I meant there's probably no need to change the association of existing
> > structure but just do the allocation in dev_add(), then we will have a
> > patch with much more small changeset that fit for -stable.
> Patch 1(ifcvf_base only work on ifcvf_hw) and patch 2(irq functions only
> work on ifcvf_hw) are not needed for stable.
> I have already done this allocation of ifcvf_adapter which is the
> container of struct vdpa_device in dev_add() in Patch 3, this should be
> merged to stable.
> Patch 3 is huge but necessary, not only allocate ifcvf_adapter in
> dev_add(), it also refactors the structures of ifcvf_mgmt_dev and
> ifcvf_adapter,
> because we need to initialize the VF's hw structure ifcvf_hw(which was a
> member of ifcvf_adapter but now should be a member of ifcvf_mgmt_dev) in
> probe.
>
> Is it still huge?

Then please reorder the patches, stable-kernel-rules.rst said:

 - It cannot be bigger than 100 lines, with context.

Let's see.

Thanks

>
> Thanks
> >
> > Thanks
> >
> >
> >>
> >> By the way, do you have any comments to the patches?
> >>
> >> Thanks,
> >> Zhu Lingshan
> >>>
> >>> Thanks
> >>>
> >>>> We create vDPA device from a VF, so without features provisioning
> >>>> requirements,
> >>>> we don't need to re-create the vDPA device. But with features
> >>>> provisioning,
> >>>> it is a must now.
> >>>>
> >>>> Thanks
> >>>>
> >>>>
> >>>>> Thakns
> >>>>>
> >>>>>> When remove a vDPA device, the container of struct vdpa_device
> >>>>>> (here is
> >>>>>> ifcvf_adapter) is free-ed in
> >>>>>> dev_del() interface, so we need to allocate ifcvf_adapter in
> >>>>>> dev_add()
> >>>>>> than in probe(). That's
> >>>>>> why I have re-factored the adapter/mgmt_dev code.
> >>>>>>
> >>>>>> For re-factoring the irq related code and ifcvf_base, let them
> >>>>>> work on
> >>>>>> struct ifcvf_hw, the
> >>>>>> reason is that the adapter is allocated in dev_add(), if we want
> >>>>>> theses
> >>>>>> functions to work
> >>>>>> before dev_add(), like in probe, we need them work on ifcvf_hw
> >>>>>> than the
> >>>>>> adapter.
> >>>>>>
> >>>>>> Thanks
> >>>>>> Zhu Lingshan
> >>>>>>> Thanks
> >>>>>>>
> >>>>>>>> Please help review
> >>>>>>>>
> >>>>>>>> Thanks
> >>>>>>>>
> >>>>>>>> Zhu Lingshan (4):
> >>>>>>>>      vDPA/ifcvf: ifcvf base layer interfaces work on struct
> >>>>>>>> ifcvf_hw
> >>>>>>>>      vDPA/ifcvf: IRQ interfaces work on ifcvf_hw
> >>>>>>>>      vDPA/ifcvf: allocate ifcvf_adapter in dev_add()
> >>>>>>>>      vDPA/ifcvf: implement features provisioning
> >>>>>>>>
> >>>>>>>>     drivers/vdpa/ifcvf/ifcvf_base.c |  32 ++-----
> >>>>>>>>     drivers/vdpa/ifcvf/ifcvf_base.h |  10 +-
> >>>>>>>>     drivers/vdpa/ifcvf/ifcvf_main.c | 156
> >>>>>>>> +++++++++++++++-----------------
> >>>>>>>>     3 files changed, 89 insertions(+), 109 deletions(-)
> >>>>>>>>
> >>>>>>>> --
> >>>>>>>> 2.31.1
> >>>>>>>>
> >>
> >
>

