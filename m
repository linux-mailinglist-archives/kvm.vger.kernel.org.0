Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614FE7D835D
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 15:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344993AbjJZNQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 09:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjJZNQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 09:16:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF64AB
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 06:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698326122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V+ivfBY0EhBt3SvBEqkvRAnG/KAtacMk+jERdi9zRd8=;
        b=FkwYBlyBDlRN04s7JLIc1LdrYf1iWDhbEx1/XQw04ZWk4qiCS7jgr2kJ7xkDZ0++T3bpeo
        N3ceG4mFq3kncZ+/aLo5me0Lg4+6UBEentBqfJ3Ftn5yqvtMPMa/2ewiPn8em5DGi53FP/
        iKACTverB4z7iCrKwh0EixQO1EX2ZGA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-620-tp1zo2FSMkuVv2hdMz8F0w-1; Thu, 26 Oct 2023 09:15:21 -0400
X-MC-Unique: tp1zo2FSMkuVv2hdMz8F0w-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9b65c46bca8so63275066b.1
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 06:15:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698326120; x=1698930920;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V+ivfBY0EhBt3SvBEqkvRAnG/KAtacMk+jERdi9zRd8=;
        b=DUhrAvVZZlGq1+Bf4eSvBXMfVj7rtVCUtgH6oA/dw2S7KaV5smm/wJh7XUg/2haB+1
         EyaJVCH9HEdAj9H8F4n5hwMbHHzy5YlCPvNrYdhDxgJQ3lvDo8mobKWeJ3oOtev6Z3Tu
         OXEZ5eLR9UnWjyywPpoO6rqR5qXx4obj1n8vrmTiwHUb/FKPYzIt1RvHyqUE6skac065
         zpMHgvS3hQh0XqRf5BpH3RyelvAP1WQuK6ICA6FG0+maqYjLD3TZQw4z6wvniCEulBu+
         ytINarKJjOXSJ9Gr2T/vZ7h5ZpjzkTVJ9HW0RGMlXNc5Ts+MMPZHJPk0skHBwF3BCsbl
         SPxg==
X-Gm-Message-State: AOJu0YxD2glu7qB3DRTt9RnRlLmCWwO2vuT/LLF3AUDcnSMQjl8TFXw9
        0J006TjHkfWiUn3aA3HuFfHP1EMtOrW0oXFYMAkirAhMmVY7Gw5R3RJV+0XGkx7iXRdzMXiCrPY
        8XOrw71BUf9DC
X-Received: by 2002:a17:907:940b:b0:9b2:74a1:6b30 with SMTP id dk11-20020a170907940b00b009b274a16b30mr11707770ejc.33.1698326119981;
        Thu, 26 Oct 2023 06:15:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOL/fiO/SndAbiqJJ06r4gwbwdZjUHuuWA1xhHABgHCCooD5g48fXhYoIzcng70jfrbGhT/Q==
X-Received: by 2002:a17:907:940b:b0:9b2:74a1:6b30 with SMTP id dk11-20020a170907940b00b009b274a16b30mr11707756ejc.33.1698326119649;
        Thu, 26 Oct 2023 06:15:19 -0700 (PDT)
Received: from redhat.com ([2a02:14f:17b:37eb:8e1f:4b3b:22c7:7722])
        by smtp.gmail.com with ESMTPSA id s12-20020a170906354c00b0098f33157e7dsm11516690eja.82.2023.10.26.06.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Oct 2023 06:15:19 -0700 (PDT)
Date:   Thu, 26 Oct 2023 09:15:14 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231026091459-mutt-send-email-mst@kernel.org>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <20231017134217.82497-10-yishaih@nvidia.com>
 <20231024135713.360c2980.alex.williamson@redhat.com>
 <d6c720a0-1575-45b7-b96d-03a916310699@nvidia.com>
 <20231025131328.407a60a3.alex.williamson@redhat.com>
 <a55540a1-b61c-417b-97a5-567cfc660ce6@nvidia.com>
 <20231026081033-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481E1AF869C1296B987A34BDCDDA@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB5481E1AF869C1296B987A34BDCDDA@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 26, 2023 at 12:40:04PM +0000, Parav Pandit wrote:
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Thursday, October 26, 2023 5:42 PM
> > 
> > On Thu, Oct 26, 2023 at 03:08:12PM +0300, Yishai Hadas wrote:
> > > > > Makes sense ?
> > > > So do I understand correctly that virtio dictates the subsystem
> > > > device ID for all subsystem vendor IDs that implement a legacy
> > > > virtio interface?  Ok, but this device didn't actually implement a
> > > > legacy virtio interface.  The device itself is not tranistional,
> > > > we're imposing an emulated transitional interface onto it.  So did
> > > > the subsystem vendor agree to have their subsystem device ID managed
> > > > by the virtio committee or might we create conflicts?  I imagine we
> > > > know we don't have a conflict if we also virtualize the subsystem vendor ID.
> > > >
> > > The non transitional net device in the virtio spec defined as the
> > > below tuple.
> > > T_A: VID=0x1AF4, DID=0x1040, Subsys_VID=FOO, Subsys_DID=0x40.
> > >
> > > And transitional net device in the virtio spec for a vendor FOO is
> > > defined
> > > as:
> > > T_B: VID=0x1AF4,DID=0x1000,Subsys_VID=FOO, subsys_DID=0x1
> > >
> > > This driver is converting T_A to T_B, which both are defined by the
> > > virtio spec.
> > > Hence, it does not conflict for the subsystem vendor, it is fine.
> > 
> > You are talking about legacy guests, what 1.X spec says about them is much less
> > important than what guests actually do.
> > Check the INF of the open source windows drivers and linux code, at least.
> 
> Linux legacy guest has,
> 
> static struct pci_device_id virtio_pci_id_table[] = {
>         { 0x1af4, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
>         { 0 },
> };
> Followed by an open coded driver check for 0x1000 to 0x103f range.
> Do you mean windows driver expects specific subsystem vendor id of 0x1af4?

Look it up, it's open source.

