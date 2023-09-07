Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E195E797775
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 18:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238027AbjIGQ0c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 12:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239918AbjIGQ0X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 12:26:23 -0400
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D7E211C
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 09:23:14 -0700 (PDT)
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-64aaf3c16c2so7033546d6.3
        for <kvm@vger.kernel.org>; Thu, 07 Sep 2023 09:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1694103659; x=1694708459; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xETPG2OLwFNrEouFmEXlo345UOWEVFv+efIvPP2Gjrs=;
        b=GRG6fvlK37DtNr5XHfJ0xTJYXsPX8peR7UbAjGSYbpFNRbjfMANuhb5xfuftDbWDzM
         bDCyoxTIETamaP7hVLYut6HEGMn/UodiEWqYMC144fWZBmTtRxjSfBPpo5/9405vnzfW
         XJqj20Byu7uMB4veuqjLkHSIRGGOF6MAON1flOnPW52R01Nz5oDVfhapMtJzuOJoCKFt
         J5TbgTdPIUfiVtgQROTWHKze39HQsj+rRnl+g65N3P7rNDSJHNoHLAd+/buXfnRWfchM
         0dH+IIBVkWzjXxfb2qV5q1oTiuUnYFdk0kTZB/4XY+T7utEiy2xiz6tM9UdYvclXudw6
         2Sng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694103659; x=1694708459;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xETPG2OLwFNrEouFmEXlo345UOWEVFv+efIvPP2Gjrs=;
        b=ceWjZQQKryz9S/t8Eg2UeSewzWU/2tS6sgWlhhw/U/iZaP62B6EiOe4M2iSheIHYkV
         b1C5xdEvZU5Dja2+EBRq6ds4S8WSXGXFcBFM3tsMHIQ3wzDf9PccEwJubsFrwurtpzw1
         6ZgaWVxxEdgCrmQVox+bEOFLXpAZsh+Io4iAbYWZIZT7j3GG6+q43r85inLJJtbvg++b
         YXhUmb0cdBshnQ6LFiPeNkvkJ0oeLL31Gjx4ADmGHNO/l1iTDW4L9wD5zLBIXw+boj0N
         I2NDwUAxEqbSWgSrOxg4rR+UtgJePzcQM7RNDWRyNw70xXgoWy1da+6m/ThTtWUaX3xu
         ul2Q==
X-Gm-Message-State: AOJu0YyxHTuGSa1/E56VGv9gdt6bjjwzS11n3pImwC8j9b1zNxUr5Pw+
        HgGV80FbrzR64kufa+JZP9Lvkw==
X-Google-Smtp-Source: AGHT+IE4iJpYPS+1PG9GLANln9Pyz9DJZFOu5J69P7504oOvRN4SvG/ikZlC871o26AeGx016VTdfw==
X-Received: by 2002:a0c:ca06:0:b0:64f:51fe:859c with SMTP id c6-20020a0cca06000000b0064f51fe859cmr21170303qvk.43.1694103659597;
        Thu, 07 Sep 2023 09:20:59 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-134-41-202-196.dhcp-dynamic.fibreop.ns.bellaliant.net. [134.41.202.196])
        by smtp.gmail.com with ESMTPSA id d2-20020a0ce442000000b0063cf4d0d558sm6399607qvm.25.2023.09.07.09.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 09:20:59 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qeHkY-00179Y-Bs;
        Thu, 07 Sep 2023 13:20:58 -0300
Date:   Thu, 7 Sep 2023 13:20:58 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     oushixiong <oushixiong@kylinos.cn>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Brett Creeley <brett.creeley@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pds: Add missing PCI_IOV depends
Message-ID: <ZPn4agslpPV6STtN@ziepe.ca>
References: <20230906014942.1658769-1-oushixiong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230906014942.1658769-1-oushixiong@kylinos.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 06, 2023 at 09:49:42AM +0800, oushixiong wrote:
> From: Shixiong Ou <oushixiong@kylinos.cn>
> 
> If PCI_ATS isn't set, then pdev->physfn is not defined.
> it causes a compilation issue:
> 
> ../drivers/vfio/pci/pds/vfio_dev.c:165:30: error: ‘struct pci_dev’ has no member named ‘physfn’; did you mean ‘is_physfn’?
>   165 |   __func__, pci_dev_id(pdev->physfn), pci_id, vf_id,
>       |                              ^~~~~~
> 
> So adding PCI_IOV depends to select PCI_ATS.
> 
> Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
> ---
>  drivers/vfio/pci/pds/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
