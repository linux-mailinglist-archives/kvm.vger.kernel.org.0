Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020C67D892F
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 21:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjJZTuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 15:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjJZTuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 15:50:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496CF129
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 12:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698349762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Ge+RJ7YbGV1FiftUYJphvZYNXalHGufmR6iNwfI/PI=;
        b=MtjrEFFBNM5MVDkF/zzqfU1Zqm3iOguAoHyBDmyOSAgAjsEsBLiRi16n03ukoLlbQv3ctv
        NETe9UVWtg1yTxwGJhDa8JuQlfM1hpPCf0H14JQ8hj9mYktHcF2zhRok6tezrE6ihHFm0O
        gDUeW6zDQSwttv7QsKww1PbOCzwkJoI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-Q2r4svehOM23NOJYiUD9HQ-1; Thu, 26 Oct 2023 15:49:20 -0400
X-MC-Unique: Q2r4svehOM23NOJYiUD9HQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9ae57d8b502so84182966b.2
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 12:49:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698349759; x=1698954559;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Ge+RJ7YbGV1FiftUYJphvZYNXalHGufmR6iNwfI/PI=;
        b=LpgdHJbLKZVioKpbjTV5vHqWvP55Z9ETesaa+pqZKwrq3oGhBuM506yXPcKX11EooZ
         F0sT8MoUqAy8svtdHlvjDgXdhI3e882nMzn1w+A2VLO0Y9+rAE+ukhUUvJ0wPYxQdaBl
         aZJPCv4QD8XrsL9TEoBs+k9vhPuZzSpVjFAIaDmR6sqXV2mT/eT+33bKBZfJvyOIX1fn
         WZoJfuBZOGp2DkubjMqq8fkI3aaaytj1Orl7Kz8pstOjdAieeBcJhDnq/al88p5RcGLJ
         HiTao8CNY7LMQhhZhp6I6fFcCnVY0mldK+bf2YJ1fYglQTPmuOXWlCreolTwbJCAefiM
         YftA==
X-Gm-Message-State: AOJu0Yzdi8vVerRBQqHVsyrTr/mYe1R1HJ3vrJ8OwjV3YyCTR7n86nnC
        dy/ZOcV3mT+BbC8Z+C9c7vD1yTHgpTa0AGDp/8kTkNqcbu8ZvIuQGUBP0W9xv+GS6kBpwTd4F08
        SssVLO7Z/tIeb
X-Received: by 2002:a17:907:9620:b0:9ae:5370:81d5 with SMTP id gb32-20020a170907962000b009ae537081d5mr597034ejc.41.1698349759158;
        Thu, 26 Oct 2023 12:49:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUXOHkBYIfn+2pBCYONpHqii41GknD203DYooZrGXdYwVBkC1hVdFsqenoFskybh62G6EpgA==
X-Received: by 2002:a17:907:9620:b0:9ae:5370:81d5 with SMTP id gb32-20020a170907962000b009ae537081d5mr597017ejc.41.1698349758844;
        Thu, 26 Oct 2023 12:49:18 -0700 (PDT)
Received: from redhat.com ([2a02:14f:17b:37eb:8e1f:4b3b:22c7:7722])
        by smtp.gmail.com with ESMTPSA id r24-20020a1709067fd800b0099cd008c1a4sm75668ejs.136.2023.10.26.12.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Oct 2023 12:49:18 -0700 (PDT)
Date:   Thu, 26 Oct 2023 15:49:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, jasowang@redhat.com,
        jgg@nvidia.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, si-wei.liu@oracle.com,
        leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231026140839-mutt-send-email-mst@kernel.org>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <20231017134217.82497-10-yishaih@nvidia.com>
 <20231024135713.360c2980.alex.williamson@redhat.com>
 <d6c720a0-1575-45b7-b96d-03a916310699@nvidia.com>
 <20231025131328.407a60a3.alex.williamson@redhat.com>
 <a55540a1-b61c-417b-97a5-567cfc660ce6@nvidia.com>
 <20231026115539.72c01af9.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231026115539.72c01af9.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 26, 2023 at 11:55:39AM -0600, Alex Williamson wrote:
> On Thu, 26 Oct 2023 15:08:12 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
> > On 25/10/2023 22:13, Alex Williamson wrote:
> > > On Wed, 25 Oct 2023 17:35:51 +0300
> > > Yishai Hadas <yishaih@nvidia.com> wrote:
> > >  
> > >> On 24/10/2023 22:57, Alex Williamson wrote:  
> > >>> On Tue, 17 Oct 2023 16:42:17 +0300
> > >>> Yishai Hadas <yishaih@nvidia.com> wrote:
>    
> > >>>> +		if (copy_to_user(buf + copy_offset, &val32, copy_count))
> > >>>> +			return -EFAULT;
> > >>>> +	}
> > >>>> +
> > >>>> +	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_ID, sizeof(val16),
> > >>>> +				  &copy_offset, &copy_count, NULL)) {
> > >>>> +		/*
> > >>>> +		 * Transitional devices use the PCI subsystem device id as
> > >>>> +		 * virtio device id, same as legacy driver always did.  
> > >>> Where did we require the subsystem vendor ID to be 0x1af4?  This
> > >>> subsystem device ID really only makes since given that subsystem
> > >>> vendor ID, right?  Otherwise I don't see that non-transitional devices,
> > >>> such as the VF, have a hard requirement per the spec for the subsystem
> > >>> vendor ID.
> > >>>
> > >>> Do we want to make this only probe the correct subsystem vendor ID or do
> > >>> we want to emulate the subsystem vendor ID as well?  I don't see this is
> > >>> correct without one of those options.  
> > >> Looking in the 1.x spec we can see the below.
> > >>
> > >> Legacy Interfaces: A Note on PCI Device Discovery
> > >>
> > >> "Transitional devices MUST have the PCI Subsystem
> > >> Device ID matching the Virtio Device ID, as indicated in section 5 ...
> > >> This is to match legacy drivers."
> > >>
> > >> However, there is no need to enforce Subsystem Vendor ID.
> > >>
> > >> This is what we followed here.
> > >>
> > >> Makes sense ?  
> > > So do I understand correctly that virtio dictates the subsystem device
> > > ID for all subsystem vendor IDs that implement a legacy virtio
> > > interface?  Ok, but this device didn't actually implement a legacy
> > > virtio interface.  The device itself is not tranistional, we're imposing
> > > an emulated transitional interface onto it.  So did the subsystem vendor
> > > agree to have their subsystem device ID managed by the virtio committee
> > > or might we create conflicts?  I imagine we know we don't have a
> > > conflict if we also virtualize the subsystem vendor ID.
> > >  
> > The non transitional net device in the virtio spec defined as the below 
> > tuple.
> > T_A: VID=0x1AF4, DID=0x1040, Subsys_VID=FOO, Subsys_DID=0x40.
> > 
> > And transitional net device in the virtio spec for a vendor FOO is 
> > defined as:
> > T_B: VID=0x1AF4,DID=0x1000,Subsys_VID=FOO, subsys_DID=0x1
> > 
> > This driver is converting T_A to T_B, which both are defined by the 
> > virtio spec.
> > Hence, it does not conflict for the subsystem vendor, it is fine.
> 
> Surprising to me that the virtio spec dictates subsystem device ID in
> all cases.

Modern virtio spec doesn't. Legacy spec did.

-- 
MST

