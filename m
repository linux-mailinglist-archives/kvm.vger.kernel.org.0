Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9A97AA41C
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 00:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjIUWAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 18:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233390AbjIUWAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 18:00:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D479044BA
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 14:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695330004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w92TIdX77sqPjb1fzpSj+HbzxRLdHbB40Saqu1w60+Q=;
        b=Mm3GvieGt8uD+irbtVMpU1ZRedPiqqDrT3ih0I8dCsbsxyRxSVKQEwpNME0BMn8WdJscW6
        8GDKKVOLB0Kxi1f8qw9PpF3PF9gRPnofqi0LWfraY1emcUM6jTEK1N6bIaWDJoDYlku5PF
        YOqwrdi0TK+NR51/5bsMAqzFDWBGZrE=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-CeAUiaMHNsO-PGWfpjB1Xg-1; Thu, 21 Sep 2023 17:00:03 -0400
X-MC-Unique: CeAUiaMHNsO-PGWfpjB1Xg-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-1d66d948417so1971488fac.3
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 14:00:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695330002; x=1695934802;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w92TIdX77sqPjb1fzpSj+HbzxRLdHbB40Saqu1w60+Q=;
        b=oaMa+XpJ1F/ei2FpOIWxVkR7ADgsfNzPeZ3vdXbmYqEI1MuViTfLUCZHDZMrfOEdu8
         0m67D/1D1TlmPeO+xA3WTHl3/omjvC/rEZyQDHwY8eewZiykZ+TXG5UPQ/K7l2+oerO0
         +7mQsU1gJGaCyZ95oblHHlIIZtxB+bduMYop5QOoaOyGqqJ9/5fD+P1Kf/x4OrfvSJgV
         M0gQv0Fy7vMUFQVIv3ltPNpbDD8uojnzrz3teIj+wCFgsqeuN2V+t6xukKxzkY66z3CM
         yl8PslKgGBBso+WAhqxOXBTgKQKVJmhl6Y+ZClJrYOa2cDVn1Xv3yyIGwz3RiHYY8gQU
         +F6w==
X-Gm-Message-State: AOJu0YygtyKgeE7pURJZUujxoF7J4cM9ZFj8va09GMHwb6/2y0E7826Z
        1hxkIsUbjtjXv0pk5UjEkZ2RPsTu8mHfjAs9vqyyJ/fejE1+p8xjpYiK04z9A1Y92IlCZA17P3r
        6PAgREWTH5pfJ
X-Received: by 2002:a05:6870:304c:b0:1d5:ef9d:5564 with SMTP id u12-20020a056870304c00b001d5ef9d5564mr6571677oau.11.1695330001961;
        Thu, 21 Sep 2023 14:00:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHp49HT+ZImBpexc/Hl0xUqdHosRzIOsU7V7v6//pfkOGXqA0pJhTnPQVS6l0Y658YpvuzV9Q==
X-Received: by 2002:a05:6870:304c:b0:1d5:ef9d:5564 with SMTP id u12-20020a056870304c00b001d5ef9d5564mr6571664oau.11.1695330001699;
        Thu, 21 Sep 2023 14:00:01 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id n21-20020a056870a45500b001d6631fd08fsm686096oal.47.2023.09.21.14.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 14:00:01 -0700 (PDT)
Date:   Thu, 21 Sep 2023 14:59:59 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921145959.7d6b5b95.alex.williamson@redhat.com>
In-Reply-To: <20230921161834-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
        <20230921124040.145386-12-yishaih@nvidia.com>
        <20230921135832.020d102a.alex.williamson@redhat.com>
        <20230921200121.GA13733@nvidia.com>
        <20230921161834-mutt-send-email-mst@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Sep 2023 16:20:59 -0400
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Thu, Sep 21, 2023 at 05:01:21PM -0300, Jason Gunthorpe wrote:
> > On Thu, Sep 21, 2023 at 01:58:32PM -0600, Alex Williamson wrote:
> >   
> > > > +static const struct pci_device_id virtiovf_pci_table[] = {
> > > > +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID) },  
> > > 
> > > libvirt will blindly use this driver for all devices matching this as
> > > we've discussed how it should make use of modules.alias.  I don't think
> > > this driver should be squatting on devices where it doesn't add value
> > > and it's not clear whether this is adding or subtracting value in all
> > > cases for the one NIC that it modifies.  How should libvirt choose when
> > > and where to use this driver?  What regressions are we going to see
> > > with VMs that previously saw "modern" virtio-net devices and now see a
> > > legacy compatible device?  Thanks,  
> > 
> > Maybe this approach needs to use a subsystem ID match?
> > 
> > Jason  
> 
> Maybe make users load it manually?
> 
> Please don't bind to virtio by default, you will break
> all guests.

This would never bind by default, it's only bound as a vfio override
driver, but if libvirt were trying to determine the correct driver to
use with vfio for a 0x1af4 device, it'd land on this one.  Thanks,

Alex

