Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47A951C87B
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379984AbiEES55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383152AbiEES54 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:57:56 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A55043BF8C
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 11:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651776853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YccfAqMOu3LpxaL6LllR645qv1qUYmKX1TfxuY7MMC0=;
        b=bCc5Vq+EuBAMIHzzPB2Su1wcPy/xqbjchWIFoAOuI/BN/lyERtd3+TKdM1K0myqHHR3JbA
        +TkNynfDsxWw7xPnxroGgocOWI6NUBHhZM3mQQ68RXfM+r2wyuyJ5SNHRQr01Lt4sBst5t
        IwZCn1lguhVaToEdeIYP480PGJpKQD4=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-neJWpVxIPbKR8Sj_f0FFkw-1; Thu, 05 May 2022 14:54:12 -0400
X-MC-Unique: neJWpVxIPbKR8Sj_f0FFkw-1
Received: by mail-il1-f197.google.com with SMTP id g1-20020a92cda1000000b002cf30d49956so2894168ild.18
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 11:54:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=YccfAqMOu3LpxaL6LllR645qv1qUYmKX1TfxuY7MMC0=;
        b=jYc0Tn6OIwGpDyq0pFKTK4UTrPb5X2twAW+hofO5R0icXyEfbCBuWhoPcWxa+zOyZw
         a+3QaNFGlpba6FgYXqjtWVwhX3Do+5j3lqXQlP5S7ZqG8geznTNQP/l3PuOXdJaNZVcR
         QlHoLamW8urK/NGmknDBVpYrejfPjrPnPXjdWmdnbvC3xbOiEKKQX3nE2YMwcbzN4Ph9
         MnF4BFlj8W82iQTgl0Kgfy5PEfqFrxM3sp3T83JHAyZoutEGyv0BfTDsWt5KWJC5Iu3g
         zLVWAQRh8TFnjuGRUZ+eACaamhk7DQ9RF1wxvO4fNgGK+Rt1qEVxfILN4L3y6eQ6YQ6N
         yOwg==
X-Gm-Message-State: AOAM533WTXMQxGG9kgTZvgJawxejVvn9YQ2hFgO2/gs+6Xg79zba/D6+
        CKMFBh+ZwKW9nOngmpHcohXQCfcgb2H/oQlXtqTsD3pi3BObhGLJgJ2wBJXoQl3bPKYHg4PRYZT
        Y35YEWKox+7eK
X-Received: by 2002:a92:d212:0:b0:2cb:7635:9940 with SMTP id y18-20020a92d212000000b002cb76359940mr11206172ily.132.1651776851882;
        Thu, 05 May 2022 11:54:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWgZqDqWytbjdfByvd2XH344PgjnE/7H/ycJouML/zY2AbyQg6TitW1YERSLL/J/FbPykhHQ==
X-Received: by 2002:a92:d212:0:b0:2cb:7635:9940 with SMTP id y18-20020a92d212000000b002cb76359940mr11206158ily.132.1651776851637;
        Thu, 05 May 2022 11:54:11 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u20-20020a02b1d4000000b0032b3a7817bbsm686492jah.127.2022.05.05.11.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 11:54:11 -0700 (PDT)
Date:   Thu, 5 May 2022 12:54:09 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH v3 1/2] vfio/pci: Have all VFIO PCI drivers store the
 vfio_pci_core_device in drvdata
Message-ID: <20220505125409.7388d369.alex.williamson@redhat.com>
In-Reply-To: <20220505183421.GU49344@nvidia.com>
References: <0-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
        <1-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
        <20220505121047.5b798dd6.alex.williamson@redhat.com>
        <20220505183421.GU49344@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 5 May 2022 15:34:21 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, May 05, 2022 at 12:10:47PM -0600, Alex Williamson wrote:
> 
> > > +	/* Drivers must set the vfio_pci_core_device to their drvdata */
> > > +	if (WARN_ON(vdev != dev_get_drvdata(&vdev->pdev->dev)))
> > > +		return -EINVAL;
> > > +  
> > 
> > The ordering seems off, if we only validate in the core enable function
> > then we can only guarantee drvdata is correct once the user has opened
> > the device.  However, we start invoking power management controls,
> > which Abhishek proposes moving to runtime pm, from the core register
> > device function.  Therefore we've not validated drvdata for anything we
> > might do in the background, not under the direction of the user.  
> 
> It is just a guard to make it obvious to someone testing the driver
> that something has gone wrong, ie in backporting or something. 
> 
> It is not intended to be protective against drivers that are actually
> wrong and installed in the system.
> 
> I added this because I felt a driver could silently be wrong and never
> hit a PM or AER callback during some basic testing to catch a crash or
> whatever.

Then the earlier we do the sanity test such that it fails simply by
loading the driver, the better, right?
 
> > I'd also rather see the variant driver fail to register with the core
> > than to see a failure opening the device an arbitrary time later.  
> 
> It still permits a driver to be wrong, eg all the drivers are like
> this today:
> 
> 	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
> 	if (ret)
> 		goto out_free;
> 	dev_set_drvdata(&pdev->dev, &hisi_acc_vdev->core_device);
> 
> So a WARN_ON inside register_device will not catch the mistake, as
> this is the common pattern it isn't as helpful.

In the above case the WARN_ON would trigger because drvdata isn't set
to the core device for the registration call.  Yes, a driver could
still set drvdata after the registration call, but then they get to
explain why they set drvdata twice and thought they could get away with
changing it after the core made pretty clear that it wants a specific
thing there.  Thanks,

Alex

