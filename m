Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46EFA7C6C61
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 13:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378390AbjJLLb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 07:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378399AbjJLLbU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 07:31:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76F994
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 04:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697110232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dkpePPgIVWd5oaGtwlSyhYxM45IhaABBMmHMkqnTYdA=;
        b=VXdt+gC6vbaw1ISgcrmxGjOaHxmjiRZMQy7fB1lD4+pmzP0IkGJ+SQITXWNhL2gOF3NMgk
        y5vinq+r6qU+w8rdgGSMQnIXcKlJUroIIu5cUij0omSaJ3z7GRvPoLNRTYZKH6zLFiJ6po
        obs7WIJw5qa17lEiNb3dPuXiJX7hI5E=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-10-lR77NPuhNGGfurxhcIzNRQ-1; Thu, 12 Oct 2023 07:30:25 -0400
X-MC-Unique: lR77NPuhNGGfurxhcIzNRQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-503177646d2so835294e87.2
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 04:30:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697110224; x=1697715024;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dkpePPgIVWd5oaGtwlSyhYxM45IhaABBMmHMkqnTYdA=;
        b=MbbWi14BFgRpSIrdXPQiXUKayhNfXIv5LsUHcWEu1trU2rp1i1WxiVdh1j10itQ4kX
         quv4N2qo+n4mekGtkgB7UTI0/aS5a/SXtvs4VH8ZgsvcaLSRUCDE2gaOIgbfVDmiPzbS
         xYkZSBkIPE7EbCaMwHyO++dZmJfnRbUCGARiYZX91f7KN+Xw/AA+OdxqjaxUNawIlAn2
         h+CARy61eAmGdXNp/p33eirbcYnsAsOAchrOhx3UAl9zobVv+WZtGsiND0Uq95+K7ckk
         llQxUQfeufbYZn1d8jpONF8Hhfsx5Hqea1kNFqJXwK4EfenTzWhl9KqPCQZYNPqDeeGW
         LaLQ==
X-Gm-Message-State: AOJu0YwWnRs9eNDfYKbxse+MC4Pp9gttfYle2+r9rUmTy1d9rlWw8Xd+
        csZTscIavdtS6ASZTm7FB3+KWNQ/NPwCVgsvPKEeXiZgHqzfNzulGW2GPEvIN9y/PtikAMLm8Xj
        srmq0p7AdXTyT
X-Received: by 2002:a19:5513:0:b0:507:9683:519f with SMTP id n19-20020a195513000000b005079683519fmr202418lfe.37.1697110224272;
        Thu, 12 Oct 2023 04:30:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGor000SivxDPktQW5GKmppDqVpkcOdvz9WUJoX9tNMyxlcE/WUw3DQITOpI1BS+aIB9Co5pQ==
X-Received: by 2002:a19:5513:0:b0:507:9683:519f with SMTP id n19-20020a195513000000b005079683519fmr202391lfe.37.1697110223896;
        Thu, 12 Oct 2023 04:30:23 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73d2:bf00:e379:826:5137:6b23])
        by smtp.gmail.com with ESMTPSA id l9-20020a1c7909000000b00401b242e2e6sm21574262wme.47.2023.10.12.04.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 04:30:23 -0700 (PDT)
Date:   Thu, 12 Oct 2023 07:30:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231012071804-mutt-send-email-mst@kernel.org>
References: <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com>
 <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEuX5HJVBOw9E+skr=K=QzH3oyHK8gk-r0hAvi6Wm7OA7Q@mail.gmail.com>
 <PH0PR12MB5481ED78F7467EEB0740847EDCFCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20230925141713-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481AF4B2F61E96794D7ABC7DCC3A@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231012065008-mutt-send-email-mst@kernel.org>
 <PH0PR12MB548135D0DF3C8B0CD5F73616DCD3A@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB548135D0DF3C8B0CD5F73616DCD3A@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 12, 2023 at 11:11:20AM +0000, Parav Pandit wrote:
> 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Thursday, October 12, 2023 4:23 PM
> > 
> > On Tue, Sep 26, 2023 at 03:45:36AM +0000, Parav Pandit wrote:
> > >
> > >
> > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > Sent: Tuesday, September 26, 2023 12:06 AM
> > >
> > > > One can thinkably do that wait in hardware, though. Just defer
> > > > completion until read is done.
> > > >
> > > Once OASIS does such new interface and if some hw vendor _actually_ wants
> > to do such complex hw, may be vfio driver can adopt to it.
> > 
> > The reset behaviour I describe is already in the spec. What else do you want
> > OASIS to standardize? Virtio currently is just a register map it does not yet
> > include suggestions on how exactly do pci express transactions look. You feel we
> > should add that?
> 
> The reset behavior in the spec for modern as listed in [1] and [2] is just fine.
> 
> What I meant is in context of having MMIO based legacy registers to "defer completion until read is done".
> I think you meant, "Just differ read completion, until reset is done".

yes

> This means the hw needs to finish the device reset for thousands of devices within the read completion timeout of the pci.

no, each device does it's own reset.

> So when if OASIS does such standardization, someone can implement it.
> 
> What I recollect, is OASIS didn't not standardize such anti-scale approach and took the admin command approach which achieve better scale.
> Hope I clarified.

You are talking about the extension for trap and emulate.
I am instead talking about devices that work with
existing legacy linux drivers with no traps.

> I am not expecting OASIS to do anything extra for legacy registers.
> 
> [1] The device MUST reset when 0 is written to device_status, and present a 0 in device_status once that is done.
> [2] After writing 0 to device_status, the driver MUST wait for a read of device_status to return 0 before reinitializing
> the device.

We can add a note explaining that legacy drivers do not wait
after doing reset, that is not a problem.
If someone wants to make a device that works with existing
legacy linux drivers, they can do that.
Won't work with all drivers though, which is why oasis did not
want to standardize this.

-- 
MST

