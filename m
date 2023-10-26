Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73037D87E1
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 19:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjJZR4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 13:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjJZR4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 13:56:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE2BAC
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 10:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698342944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RZ6iVv8oE6cIOnSLClGga0Gh0D3fHj5Pk7B1lo93yNA=;
        b=K5KKkhh8ZUAVFwlzi08WKOFBk5yNzIbS6v44WKnVj958zZ/kK2GlIf/u1CvjQicDF4cNz5
        Ojv383YCGliQw7MIEfDjjx/s6gWNTMQd2vFfC7oVWFYx90HAgOTAEhUmYJhNutSEBqPpvy
        baemgyRFJbadUGw/48byQj4JHBmov0k=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-HjaxiG8BMu2UXISJmcDPcw-1; Thu, 26 Oct 2023 13:55:43 -0400
X-MC-Unique: HjaxiG8BMu2UXISJmcDPcw-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3af7219c67fso1738985b6e.1
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 10:55:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698342942; x=1698947742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RZ6iVv8oE6cIOnSLClGga0Gh0D3fHj5Pk7B1lo93yNA=;
        b=JeCqNvJV8+alaLJb7qhgpil1aYfLWrVy0UX/9qr+/kM6HhKWzLqUg31Wn74bcjggt2
         uf1chlU7fxS/DhyYINhMcc4HZmiAHXh0wgArX/xBQW9/tEXPK56DWFtlkFXpfQwHMveh
         j8YkGxXvX9G4WLKHbxPFUiNHrxZtA5+7a7JvYmpEXvSwQyhPL6slGoEw5kDR6ZtBTC10
         2+Acp6z4NyDM2Bf+tM/IK6gNV/OXJbQEP9GOneOvBccyvFBBzAZ0ASQkxMjEpdSxQhbv
         CrCyASjrcw+GapVvCOwcfVuJaUAf/WhsOHXx0i01Utk4SCT6bYcxOaTeMgYrCzhRmJeI
         zTDQ==
X-Gm-Message-State: AOJu0Yxw2wSJO6D3NZ+AISBhfSjDm/1PKS8csL5B57L7bchjxMp2qaiW
        yHUFUU6JRlwVoE3FWeoiyuWo52E7mvh1LHyPRJWoouVua67y73uf/6WjRszBrQkz7do1D5fQyKW
        fX+Al9vav/RZ8
X-Received: by 2002:a05:6871:a40c:b0:1dd:7f3a:b703 with SMTP id vz12-20020a056871a40c00b001dd7f3ab703mr415396oab.0.1698342942571;
        Thu, 26 Oct 2023 10:55:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEg08tFB7c1YeA7yTIAQ6470xh94njF6ucMpjnRWWMJg718xKWDwz4Z93pBDCLt/eA2gSz+KA==
X-Received: by 2002:a05:6871:a40c:b0:1dd:7f3a:b703 with SMTP id vz12-20020a056871a40c00b001dd7f3ab703mr415360oab.0.1698342942178;
        Thu, 26 Oct 2023 10:55:42 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id fh10-20020a056638628a00b00459c279647bsm685293jab.127.2023.10.26.10.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Oct 2023 10:55:41 -0700 (PDT)
Date:   Thu, 26 Oct 2023 11:55:39 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <si-wei.liu@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231026115539.72c01af9.alex.williamson@redhat.com>
In-Reply-To: <a55540a1-b61c-417b-97a5-567cfc660ce6@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
        <20231017134217.82497-10-yishaih@nvidia.com>
        <20231024135713.360c2980.alex.williamson@redhat.com>
        <d6c720a0-1575-45b7-b96d-03a916310699@nvidia.com>
        <20231025131328.407a60a3.alex.williamson@redhat.com>
        <a55540a1-b61c-417b-97a5-567cfc660ce6@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 26 Oct 2023 15:08:12 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 25/10/2023 22:13, Alex Williamson wrote:
> > On Wed, 25 Oct 2023 17:35:51 +0300
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> >  
> >> On 24/10/2023 22:57, Alex Williamson wrote:  
> >>> On Tue, 17 Oct 2023 16:42:17 +0300
> >>> Yishai Hadas <yishaih@nvidia.com> wrote:
   
> >>>> +		if (copy_to_user(buf + copy_offset, &val32, copy_count))
> >>>> +			return -EFAULT;
> >>>> +	}
> >>>> +
> >>>> +	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_ID, sizeof(val16),
> >>>> +				  &copy_offset, &copy_count, NULL)) {
> >>>> +		/*
> >>>> +		 * Transitional devices use the PCI subsystem device id as
> >>>> +		 * virtio device id, same as legacy driver always did.  
> >>> Where did we require the subsystem vendor ID to be 0x1af4?  This
> >>> subsystem device ID really only makes since given that subsystem
> >>> vendor ID, right?  Otherwise I don't see that non-transitional devices,
> >>> such as the VF, have a hard requirement per the spec for the subsystem
> >>> vendor ID.
> >>>
> >>> Do we want to make this only probe the correct subsystem vendor ID or do
> >>> we want to emulate the subsystem vendor ID as well?  I don't see this is
> >>> correct without one of those options.  
> >> Looking in the 1.x spec we can see the below.
> >>
> >> Legacy Interfaces: A Note on PCI Device Discovery
> >>
> >> "Transitional devices MUST have the PCI Subsystem
> >> Device ID matching the Virtio Device ID, as indicated in section 5 ...
> >> This is to match legacy drivers."
> >>
> >> However, there is no need to enforce Subsystem Vendor ID.
> >>
> >> This is what we followed here.
> >>
> >> Makes sense ?  
> > So do I understand correctly that virtio dictates the subsystem device
> > ID for all subsystem vendor IDs that implement a legacy virtio
> > interface?  Ok, but this device didn't actually implement a legacy
> > virtio interface.  The device itself is not tranistional, we're imposing
> > an emulated transitional interface onto it.  So did the subsystem vendor
> > agree to have their subsystem device ID managed by the virtio committee
> > or might we create conflicts?  I imagine we know we don't have a
> > conflict if we also virtualize the subsystem vendor ID.
> >  
> The non transitional net device in the virtio spec defined as the below 
> tuple.
> T_A: VID=0x1AF4, DID=0x1040, Subsys_VID=FOO, Subsys_DID=0x40.
> 
> And transitional net device in the virtio spec for a vendor FOO is 
> defined as:
> T_B: VID=0x1AF4,DID=0x1000,Subsys_VID=FOO, subsys_DID=0x1
> 
> This driver is converting T_A to T_B, which both are defined by the 
> virtio spec.
> Hence, it does not conflict for the subsystem vendor, it is fine.

Surprising to me that the virtio spec dictates subsystem device ID in
all cases.  The further discussion in this thread seems to indicate we
need to virtualize subsystem vendor ID for broader driver compatibility
anyway.

> > BTW, it would be a lot easier for all of the config space emulation here
> > if we could make use of the existing field virtualization in
> > vfio-pci-core.  In fact you'll see in vfio_config_init() that
> > PCI_DEVICE_ID is already virtualized for VFs, so it would be enough to
> > simply do the following to report the desired device ID:
> >
> > 	*(__le16 *)&vconfig[PCI_DEVICE_ID] = cpu_to_le16(0x1000);  
> 
> I would prefer keeping things simple and have one place/flow that 
> handles all the fields as we have now as part of the driver.

That's the same argument I'd make for re-using the core code, we don't
need multiple implementations handling merging physical and virtual
bits within config space.

> In any case, I'll further look at that option for managing the DEVICE_ID 
> towards V2.
> 
> > It appears everything in this function could be handled similarly by
> > vfio-pci-core if the right fields in the perm_bits.virt and .write
> > bits could be manipulated and vconfig modified appropriately.  I'd look
> > for a way that a variant driver could provide an alternate set of
> > permissions structures for various capabilities.  Thanks,  
> 
> OK
> 
> However, let's not block V2 and the series acceptance as of that.
> 
> It can always be some future refactoring as part of other series that 
> will bring the infra-structure that is needed for that.

We're already on the verge of the v6.7 merge window, so this looks like
v6.8 material anyway.  We have time.  Thanks,

Alex

