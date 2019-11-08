Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED3EF56E0
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 21:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390020AbfKHTMt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 14:12:49 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45587 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732760AbfKHTMs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 14:12:48 -0500
Received: by mail-lj1-f194.google.com with SMTP id n21so7327050ljg.12
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 11:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=a3vQFiEAfh9O9XwA5nMCqQFpZlYhBVLvt3EKilq7WEg=;
        b=XsWkOZw9Z0Y7qCN47gcDax4OqwdSp9/YhlQscYqBMmTJ553+p82rkIvUjhb9aNYF9q
         toLEgr6V0GHfJeaziDghaVmu4BIfxLLuf7DosBNbHWLOLCG5lCTIxWTGWzMIK9HpPjUr
         6IZ4UTeo0RHmOQrt60OfSnUN71Gw8FjomeNFFZVOOAGeM/fXzljV3OBP+yT7nY7+8U2o
         wVBLTBsxjxj2jbFOhxkqCFi3+qeOHc497DKeGMqhKfzH/2R+dlbC2gK7d37c/K+yfqQL
         d2nTBFqX8kJcKatUN+Rj8hvv9FdMBN8wAFfEjGkew01aSza2E76roz1r/R5ZvmhZ9tr2
         OcHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=a3vQFiEAfh9O9XwA5nMCqQFpZlYhBVLvt3EKilq7WEg=;
        b=JNVGA/H0Ujdmr8vwadlxjK7A5tTyxExrEW/wIJy+m1om0xvlN92kRX/Nv3O3GFctxl
         qCui810zeZYbIM36FnXEKdIH6oPIIfXXUyQ5sftwFeBeAYU5TvgWxvP45uFz/HDiMwWL
         ma0LjGZJzzjyKlbCtx8OWyPaoHvDXcJCvgfcz7XHKQRlSB0Db7NmBaixmNn1vE1XcZx6
         dn6gzHSIqxAeCNLrvMQTPOitkZ2I2CIzzfPPwRDfF0I9NwzAFY/iix31+iHH0Kx0E64n
         RjFlcec78943u/GYh4kbbgJ5dBPu9ZJMRY/nAmrfJr6z/2SoRZWU2mZGFmo8Wjrw9gnY
         kjCg==
X-Gm-Message-State: APjAAAVQsnBdHHXC2lFnq1ws5nLMdLj1+g+Fj0VJcDaFS4yhalgiBXiY
        fOSQmY8HX6hB1jF38O9t/Lbn8w==
X-Google-Smtp-Source: APXvYqwjsmXBIWFCeW8Ftdb12MTBChBoMUmD3dhCSqIssd0i5LdWV+oLQuBUuHRvOGqHVeE09iymWg==
X-Received: by 2002:a2e:b5a2:: with SMTP id f2mr7768671ljn.108.1573240367183;
        Fri, 08 Nov 2019 11:12:47 -0800 (PST)
Received: from cakuba ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z20sm2690798ljj.85.2019.11.08.11.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 11:12:46 -0800 (PST)
Date:   Fri, 8 Nov 2019 11:12:38 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Jiri Pirko <jiri@resnulli.us>,
        "Ertman@ziepe.ca" <Ertman@ziepe.ca>,
        David M <david.m.ertman@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191108111238.578f44f1@cakuba>
In-Reply-To: <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <20191108121233.GJ6990@nanopsycho>
        <20191108144054.GC10956@ziepe.ca>
        <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 8 Nov 2019 15:40:22 +0000, Parav Pandit wrote:
> > The new intel driver has been having a very similar discussion about how to
> > model their 'multi function device' ie to bind RDMA and other drivers to a
> > shared PCI function, and I think that discussion settled on adding a new bus?
> > 
> > Really these things are all very similar, it would be nice to have a clear
> > methodology on how to use the device core if a single PCI device is split by
> > software into multiple different functional units and attached to different
> > driver instances.
> > 
> > Currently there is alot of hacking in this area.. And a consistent scheme
> > might resolve the ugliness with the dma_ops wrappers.
> > 
> > We already have the 'mfd' stuff to support splitting platform devices, maybe
> > we need to create a 'pci-mfd' to support splitting PCI devices?
> > 
> > I'm not really clear how mfd and mdev relate, I always thought mdev was
> > strongly linked to vfio.
> >   
> Mdev at beginning was strongly linked to vfio, but as I mentioned above it is addressing more use case.
> 
> I observed that discussion, but was not sure of extending mdev further.
> 
> One way to do for Intel drivers to do is after series [9].
> Where PCI driver says, MDEV_CLASS_ID_I40_FOO
> RDMA driver mdev_register_driver(), matches on it and does the probe().

Yup, FWIW to me the benefit of reusing mdevs for the Intel case vs
muddying the purpose of mdevs is not a clear trade off.

IMHO MFD should be of more natural use for Intel, since it's about
providing different functionality rather than virtual slices of the
same device.

> > At the very least if it is agreed mdev should be the vehicle here, then it
> > should also be able to solve the netdev/rdma hookup problem too.
