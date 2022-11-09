Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D94562260D
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 10:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiKIJAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 04:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiKIJA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 04:00:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8189B1CFEF
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 00:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667984374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6N0lCIAD53nCM8NWFUXR1L2cUAw2KB/QLdCa57mdxSw=;
        b=i5tKyia1Y8Q7IRB5J+LrUyy4Rg2T5ywgCPh9LLgWsf+09vpgUgYbWlBAQ9rj4etrWbfUeb
        kCFYHLxPUoXdpGuMFUT0kpvTkDRPYZDTIVPUsGmHpbLkNs3RvjulMroeyBtw0qZqtg+KAr
        k2xZ4R75YI6N7Lk5sIxT3dp1z0zgUhc=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-284-wAYQ_da7PRGCUFB-aTSS5Q-1; Wed, 09 Nov 2022 03:59:33 -0500
X-MC-Unique: wAYQ_da7PRGCUFB-aTSS5Q-1
Received: by mail-ot1-f71.google.com with SMTP id c25-20020a056830349900b0066d31b7ca49so1272564otu.4
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 00:59:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6N0lCIAD53nCM8NWFUXR1L2cUAw2KB/QLdCa57mdxSw=;
        b=HmdZCMfuxUvfRAv36lcPycIKAiWnieQHSyC3tvX9G3dsknh1FKsbsa1D3oI74CFpdT
         WhDuwqgtdneBd0Hpk/2xhNnehnorqchVn/FlILQPE9mxGK2tT78PMMl6YTUaTypm6mgJ
         WvF3kNg3TfKmdPDSGuohGFw1wLCFhdQOtF9CNgz9Bnr787/fFqiBgKgeHxmXk5Xd991N
         cPcZLlBna7sf+orgF+INK45lYf5ZH7ZRodocS6PASF8NTDJsJtBZoVhL+5YeFoTVAfE0
         +6DoIHRb0nVQkpHlzKKLt3kcO77R385mL5ZOO+UDSxtpfpQjcfe8shA9BLFg2k2nBkSg
         sNEg==
X-Gm-Message-State: ACrzQf0HR/u5MhrJpoWR+T+Dk2vL0zdgz7Mo3m4IGUSSxJbp33XvE4A5
        xkGPuVWVQhTym5A64mN/JAYEu42HMyqxi4LsleSmu9rN3JulDS8vfvcq/Fz8jZWaaPzj13Fplm5
        WjibMr2Y6Ym8lV77l/Ste14k6UR8U
X-Received: by 2002:a05:6871:54e:b0:13b:29b7:e2e8 with SMTP id t14-20020a056871054e00b0013b29b7e2e8mr43834499oal.35.1667984372353;
        Wed, 09 Nov 2022 00:59:32 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4N1uceXI6J7DP3npNVfHBKhZGxDCbi8hC/jrrwqBzU5VaqPmYEk9Hbn9lNXK1m3yNFIvSN6C2Qn8RkB1/22Wg=
X-Received: by 2002:a05:6871:54e:b0:13b:29b7:e2e8 with SMTP id
 t14-20020a056871054e00b0013b29b7e2e8mr43834490oal.35.1667984372087; Wed, 09
 Nov 2022 00:59:32 -0800 (PST)
MIME-Version: 1.0
References: <20221107093345.121648-1-lingshan.zhu@intel.com>
 <CACGkMEs9af1E1pLd2t8E71YBPF=rHkhfN8qO9_3=x6HVaCMAxg@mail.gmail.com> <0b15591f-9e49-6383-65eb-6673423f81ec@intel.com>
In-Reply-To: <0b15591f-9e49-6383-65eb-6673423f81ec@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 9 Nov 2022 16:59:20 +0800
Message-ID: <CACGkMEujqOFHv7QATWgYo=SdAKef5jQXi2-YksjgT-hxEgKNDQ@mail.gmail.com>
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

On Wed, Nov 9, 2022 at 4:14 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>
>
>
> On 11/9/2022 2:51 PM, Jason Wang wrote:
> > On Mon, Nov 7, 2022 at 5:42 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
> >> This series implements features provisioning for ifcvf.
> >> By applying this series, we allow userspace to create
> >> a vDPA device with selected (management device supported)
> >> feature bits and mask out others.
> > I don't see a direct relationship between the first 3 and the last.
> > Maybe you can state the reason why the restructure is a must for the
> > feature provisioning. Otherwise, we'd better split the series.
> When introducing features provisioning ability to ifcvf, there is a need
> to re-create vDPA devices
> on a VF with different feature bits.

This seems a requirement even without feature provisioning? Device
could be deleted from the management device anyhow.

Thakns

>
> When remove a vDPA device, the container of struct vdpa_device (here is
> ifcvf_adapter) is free-ed in
> dev_del() interface, so we need to allocate ifcvf_adapter in dev_add()
> than in probe(). That's
> why I have re-factored the adapter/mgmt_dev code.
>
> For re-factoring the irq related code and ifcvf_base, let them work on
> struct ifcvf_hw, the
> reason is that the adapter is allocated in dev_add(), if we want theses
> functions to work
> before dev_add(), like in probe, we need them work on ifcvf_hw than the
> adapter.
>
> Thanks
> Zhu Lingshan
> >
> > Thanks
> >
> >> Please help review
> >>
> >> Thanks
> >>
> >> Zhu Lingshan (4):
> >>    vDPA/ifcvf: ifcvf base layer interfaces work on struct ifcvf_hw
> >>    vDPA/ifcvf: IRQ interfaces work on ifcvf_hw
> >>    vDPA/ifcvf: allocate ifcvf_adapter in dev_add()
> >>    vDPA/ifcvf: implement features provisioning
> >>
> >>   drivers/vdpa/ifcvf/ifcvf_base.c |  32 ++-----
> >>   drivers/vdpa/ifcvf/ifcvf_base.h |  10 +-
> >>   drivers/vdpa/ifcvf/ifcvf_main.c | 156 +++++++++++++++-----------------
> >>   3 files changed, 89 insertions(+), 109 deletions(-)
> >>
> >> --
> >> 2.31.1
> >>
>

