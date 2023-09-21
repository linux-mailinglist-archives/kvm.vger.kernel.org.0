Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A647C7AA0A4
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbjIUUoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbjIUUn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:43:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8B424842
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695327670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1SECl7HHOuHpRqQu6Pg2t83dXUaZvAMYkmKX/gGCDg0=;
        b=VXsEkmhENBK1tflDQQHSuXgnGFIigF/pd4OHmsXbVbemOfa9GHneMitEeclnbhiBwmB2ms
        RFU9pVwiogY9fKBRncMaQeGR74M7lyMJBa1izOeWusAOlWOZulfCW+Y4IGL5F80BCjKlss
        YmEPJJ3AVmfq6PDPfr/kBXhu8dFq+Dc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-lH7O857ZOIqz2fwN1hsf4Q-1; Thu, 21 Sep 2023 16:21:09 -0400
X-MC-Unique: lH7O857ZOIqz2fwN1hsf4Q-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-993c2d9e496so108614466b.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:21:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695327668; x=1695932468;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1SECl7HHOuHpRqQu6Pg2t83dXUaZvAMYkmKX/gGCDg0=;
        b=f9sqkGU1mxltfCujzpTFVM6x2H+JGrr/DdXzhfLp65kyFK4Q1KM3h1oijnqORW8a7/
         i57frj1CNdw1eOj+zSA3BnAs6zjeh89NgWEMhc5v6u7p3NYW91LS5ZNBxaJKBL5qYc/Y
         l5E7m4dTFdzqZnZSEXANUDGJP3XQnwAwNXlVmHgjAeXnGkme9rsXpZxNeRRNcWbdbXbO
         B07isd3+3D9cc2IHvskn+MOAUwwvnWCnGotDXGaZUGk0mdRkpt/qeq74mUYiW0trTETu
         9+ZMYPOBsfSX9tHFtv38Gp0RiYHVZaI6GrQToOPFf2FNfRbecweyGdLJjz3Ja0GH+b7Y
         zi+g==
X-Gm-Message-State: AOJu0Yy1/D8YaWfHoQRPy8sw7LSCg3i6Zj2fCdfYWs3dMr7zuZPMdwur
        3Qsja8d/ywEmghQ3X3nIyGTHMVWk2P3Rfaj/B4BmMHtfSkhbSXwtwWOS4FNdSd32GQyM/ECJZJx
        qp+tiG+XxqN9/
X-Received: by 2002:a17:907:7755:b0:9a5:d657:47ec with SMTP id kx21-20020a170907775500b009a5d65747ecmr5891140ejc.64.1695327668593;
        Thu, 21 Sep 2023 13:21:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3QCdXAxYwhPYQqQbPpiWRW9ysxpmHnqzUV7PdQNvEFRE1hFOgf1uBv4E8bUxI9licalfcNg==
X-Received: by 2002:a17:907:7755:b0:9a5:d657:47ec with SMTP id kx21-20020a170907775500b009a5d65747ecmr5891121ejc.64.1695327668272;
        Thu, 21 Sep 2023 13:21:08 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id t2-20020a17090616c200b0099d45ed589csm1506083ejd.125.2023.09.21.13.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 13:21:03 -0700 (PDT)
Date:   Thu, 21 Sep 2023 16:20:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921161834-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921135832.020d102a.alex.williamson@redhat.com>
 <20230921200121.GA13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921200121.GA13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 05:01:21PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 21, 2023 at 01:58:32PM -0600, Alex Williamson wrote:
> 
> > > +static const struct pci_device_id virtiovf_pci_table[] = {
> > > +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID) },
> > 
> > libvirt will blindly use this driver for all devices matching this as
> > we've discussed how it should make use of modules.alias.  I don't think
> > this driver should be squatting on devices where it doesn't add value
> > and it's not clear whether this is adding or subtracting value in all
> > cases for the one NIC that it modifies.  How should libvirt choose when
> > and where to use this driver?  What regressions are we going to see
> > with VMs that previously saw "modern" virtio-net devices and now see a
> > legacy compatible device?  Thanks,
> 
> Maybe this approach needs to use a subsystem ID match?
> 
> Jason

Maybe make users load it manually?

Please don't bind to virtio by default, you will break
all guests.

-- 
MST

