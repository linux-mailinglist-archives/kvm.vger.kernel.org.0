Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA6F4C18A6
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 17:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242815AbiBWQfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 11:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241813AbiBWQfQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 11:35:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41C3A50E3A
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 08:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645634087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nQ3OobjVOllFjF//341g+8FVMNuOOL65pOBy6n0VyaU=;
        b=Ejj2iU4cZ/2qtJPBUiHrCiWJ7Qm1ARp14iPAWckKRRG7uYyZ1RsXc6U3UlHe5mVi0wsEkm
        HmoivDhmm5y8UcYHjfUi/sS6Po1SYvd3KFL82ZaOx2ibrYGsYld9k6nvNhpHuQkRe6FPk9
        agdZKBpV80/o9Oohwkz8DCssXw99BQo=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-yUu-HzZdM1iXnXSJCXP3iw-1; Wed, 23 Feb 2022 11:34:46 -0500
X-MC-Unique: yUu-HzZdM1iXnXSJCXP3iw-1
Received: by mail-ot1-f70.google.com with SMTP id d3-20020a9d4f03000000b005af2a6014f7so6948802otl.23
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 08:34:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nQ3OobjVOllFjF//341g+8FVMNuOOL65pOBy6n0VyaU=;
        b=15BpTXtP+ufLJjR2wdYPtVxCdZpgabNF8rXdm2zSVH5p+2zKU7E9Ty4Kr8pnQ/GfD6
         MFRnL1JynKQKtp/Iq3JlKf8trlqPv9gWUy/n+EG8QwUE5sVdwchjWiq2LUxHL3aK9x+b
         HT0EsmsQ6vVwql9Q3gko3YQiawmMWzFMitzVn05sEwQ+NRuMUYO54UapEf3qZqv/sGiE
         fbdGjosN8F6of0e6KeBOpISSl2SHkau93Qbkw5fRucBNC18axve84YsVgJY33Wq3cMge
         kQe5TMkbJQA3GuJKi0nX1IraQLdepaSckLIVfFunRB2YLuAK9eXEt9KJp7CCWerpVh2M
         3rkQ==
X-Gm-Message-State: AOAM532O/KOBNyWSCyC2SYl4pDafbQkdCAD3WjLycY60gHzspqIhN/Ui
        XmKTHGaASYGNexIziQSjJhGRWqklqbixahd/ftwpTqp1XkSvosWqdQkQ1nOyVZXo+NfvuB9iOGT
        sXRFIE2vsUHxj
X-Received: by 2002:a54:4085:0:b0:2d4:6f0b:f3b7 with SMTP id i5-20020a544085000000b002d46f0bf3b7mr258688oii.148.1645634085370;
        Wed, 23 Feb 2022 08:34:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxaP/1ZvmMsLm7zZq6HfYZWjNtio48LTCUjFpR9oZZdGxGMhkpLSdC41ujeIjXVdKBnwi0P6A==
X-Received: by 2002:a54:4085:0:b0:2d4:6f0b:f3b7 with SMTP id i5-20020a544085000000b002d46f0bf3b7mr258680oii.148.1645634085157;
        Wed, 23 Feb 2022 08:34:45 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s9sm55235otg.6.2022.02.23.08.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 08:34:44 -0800 (PST)
Date:   Wed, 23 Feb 2022 09:34:43 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, cohuck@redhat.com,
        mgurtovoy@nvidia.com, yishaih@nvidia.com, linuxarm@huawei.com,
        liulongfang@huawei.com, prime.zeng@hisilicon.com,
        jonathan.cameron@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH v5 7/8] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220223093443.367ee531.alex.williamson@redhat.com>
In-Reply-To: <20220223005251.GJ10061@nvidia.com>
References: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
        <20220221114043.2030-8-shameerali.kolothum.thodi@huawei.com>
        <20220223005251.GJ10061@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Feb 2022 20:52:51 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Feb 21, 2022 at 11:40:42AM +0000, Shameer Kolothum wrote:
> 
> > +	/*
> > +	 * ACC VF dev BAR2 region consists of both functional register space
> > +	 * and migration control register space. For migration to work, we
> > +	 * need access to both. Hence, we map the entire BAR2 region here.
> > +	 * But from a security point of view, we restrict access to the
> > +	 * migration control space from Guest(Please see mmap/ioctl/read/write
> > +	 * override functions).
> > +	 *
> > +	 * Also the HiSilicon ACC VF devices supported by this driver on
> > +	 * HiSilicon hardware platforms are integrated end point devices
> > +	 * and has no capability to perform PCIe P2P.  
> 
> If that is the case why not implement the RUNNING_P2P as well as a
> NOP?
> 
> Alex expressed concerned about proliferation of non-P2P devices as it
> complicates qemu to support mixes

I read the above as more of a statement about isolation, ie. grouping.
Given that all DMA from the device is translated by the IOMMU, how is
it possible that a device can entirely lack p2p support, or even know
that the target address post-translation is to a peer device rather
than system memory.  If this is the case, it sounds like a restriction
of the SMMU not supporting translations that reflect back to the I/O
bus rather than a feature of the device itself.  Thanks,

Alex

