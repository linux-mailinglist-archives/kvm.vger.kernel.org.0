Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFF4623AF4
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 05:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbiKJESZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 23:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbiKJESU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 23:18:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26566122
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 20:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668053840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hZ47d7jrOigedO39iu9a033pdJ+h7flGkGadTHehkDc=;
        b=ckai44fIhmDjMhpiJ9pTqXqEJaav+jLruvnkQoSbVT5NbZ6gTfYRg37i4jefgGae1jMC/f
        tyonbanVGMj65cRWFqxGnjRHMt2BcQsCCf1mNg0IIOPguahVI2qNhOQz4athkMWzBuvQqs
        AgPAf0tEzEp8btMYitJyWxXJwOyZHMA=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-584-dHxXJZEbMOWoOegblOXeUg-1; Wed, 09 Nov 2022 23:17:19 -0500
X-MC-Unique: dHxXJZEbMOWoOegblOXeUg-1
Received: by mail-il1-f198.google.com with SMTP id d2-20020a056e020be200b00300ecc7e0d4so776161ilu.5
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 20:17:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hZ47d7jrOigedO39iu9a033pdJ+h7flGkGadTHehkDc=;
        b=G7Gps1xg/PJa5r8hUOW2aXMSAtL1wZ4xJaPZHIiQ9nNNrQxY9bzxqiU4ncE7o+6GrJ
         tJv6lDuxzJsNLvQPZUEuw51C02B4kHdpRDW2bKRd7fzSCm5ABo4U+TXuEEQqbyZc4oZj
         kAn039MPCwHLd2Ph9DUUq3XIlD3gyKVDAEUB8AzwekVctURVXxIbu5gdYDdikGIN2xzf
         fjAeY1SmVYClkMDLVANGa9Hc5Tk+Je36fjHwS2yUulj10iLrsL/HaykDeQazYiEH/Pus
         atCFr9SGRMZpZ7ETJ8YLRK6LM9gFWoehRBVdwhXXliED7kCkhGnybZegLaNnzufhc8+I
         30aQ==
X-Gm-Message-State: ANoB5pm1poSFzGljAQLWY7Bt6H6hTwI4YzYs6nWIpS/MlIGY394YDick
        K7+Th6rhLxHMWJ73Oy63gDLmQR22dLrKXf7RJ9ENwxX/ZreyDtIEy2UzdgIApoK2GrUKvbIMmnH
        z+xauaxNC4mgr
X-Received: by 2002:a6b:8f11:0:b0:6db:6299:112f with SMTP id r17-20020a6b8f11000000b006db6299112fmr1769515iod.25.1668053837803;
        Wed, 09 Nov 2022 20:17:17 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6sbbaPt3dZk6/bz4BjYFMtE07XpPzigTWD86T6EMAfrbVtdds8ENAIgaYcg1xifZhURs9DAw==
X-Received: by 2002:a6b:8f11:0:b0:6db:6299:112f with SMTP id r17-20020a6b8f11000000b006db6299112fmr1769511iod.25.1668053837604;
        Wed, 09 Nov 2022 20:17:17 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y19-20020a056638229300b00375147442f3sm5416744jas.16.2022.11.09.20.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 20:17:17 -0800 (PST)
Date:   Wed, 9 Nov 2022 21:17:15 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     Anthony DeRossi <ajderossi@gmail.com>, <kvm@vger.kernel.org>,
        <cohuck@redhat.com>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
        <abhsahu@nvidia.com>, <yishaih@nvidia.com>
Subject: Re: [PATCH v6 3/3] vfio/pci: Check the device set open count on
 reset
Message-ID: <20221109211715.7cdacf3d.alex.williamson@redhat.com>
In-Reply-To: <49b64e4b-43b9-ec7b-23d2-2fa1bf921046@intel.com>
References: <20221110014027.28780-1-ajderossi@gmail.com>
        <20221110014027.28780-4-ajderossi@gmail.com>
        <49b64e4b-43b9-ec7b-23d2-2fa1bf921046@intel.com>
Organization: Red Hat
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

On Thu, 10 Nov 2022 11:03:29 +0800
Yi Liu <yi.l.liu@intel.com> wrote:

> Hi DeRossi,
> 
> On 2022/11/10 09:40, Anthony DeRossi wrote:
> > vfio_pci_dev_set_needs_reset() inspects the open_count of every device
> > in the set to determine whether a reset is allowed. The current device
> > always has open_count == 1 within vfio_pci_core_disable(), effectively
> > disabling the reset logic. This field is also documented as private in
> > vfio_device, so it should not be used to determine whether other devices
> > in the set are open.  
> 
> haven't went through the prior version. maybe may question has been already
> answered. My question is:
> 
> the major reason is the order problem in vfio_main.c. close_device() is
> always called before decreasing open_count to be 0. So even other device
> has no open fd, the current vfio_device still have one open count. So why
> can't we just switch the order of open_count-- and close_device()?

This is what was originally proposed and Jason shot it down:

https://lore.kernel.org/all/Y1kY0I4lr7KntbWp@ziepe.ca/
 
> > Checking for vfio_device_set_open_count() > 1 on the device set fixes
> > both issues  
> tbh. it's weird to me that a driver needs to know the internal logic of
> vfio core before knowing it needs to check the vfio_device_set_open_count()
> in this way. Is vfio-pci the only driver that needs to do this check or
> there are other drivers? If there are other drivers, maybe fixing the order
> in core is better.

Please see the evolution of reflck into device sets.  Both PCI and FSL
can have multiple devices in a set, AIUI.  The driver defines the set.
This ability to test for the last close among devices in the set is a
fundamental feature of the original reflck.  Thanks,

Alex

