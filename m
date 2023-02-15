Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D146981CE
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjBORUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBORUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:20:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C7838EB6
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676481581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f8VA1c6iZtz7FGtZvF7i96siVIEbaGum/570KUL8JYQ=;
        b=DgqKb6sQ/OkfUHUbW6PDkw/fcroPt9jQ/01J4/A13wYJHbi1b3fkTaQA4nS0LVqHGcWGJj
        2dL0Fa8iApYwYS85DaR+EjThNAHMFbrP/a/nPB8+SU7+drv7eBY/zqlrXITQZTycMc7Evn
        s3TD3EHUoT3RwcE3/PjGC/2JAgtLRo4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-629-fdLu4Yk-MT-KDiApsHTfJQ-1; Wed, 15 Feb 2023 12:19:39 -0500
X-MC-Unique: fdLu4Yk-MT-KDiApsHTfJQ-1
Received: by mail-io1-f72.google.com with SMTP id t185-20020a6bc3c2000000b00733ef3dabe3so12451653iof.14
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:19:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f8VA1c6iZtz7FGtZvF7i96siVIEbaGum/570KUL8JYQ=;
        b=PmDazGHnE3JHTScHv8SJgkrXicfXEekTfKPFIanP5njUPgWF/Gt35FjriIFxycadfv
         AEF4eGT6HPF6yWfds47ba8zkMZegQBK0tMVkSMZeza4bbhnykI2LQEUAHJLRZQVG+2nj
         x2u619hkHFtbKGtOVaLwULub0wbsf6Jfw5ruudgYNf1EiI66zpGLhxd/FRHErHyeDt4o
         3hAYN55uyDUf0TwnZiOrBKKmjYmK0/6ENuGzIrCGffBE4e7kmT19I24tF3uB7HF5YR5q
         10Odmk8+r6eUsfbJufdSi7PrFkmnr1fGVA7usXRScxBxGObJLDoMVMqe+GGE6fWn2IVH
         CKag==
X-Gm-Message-State: AO0yUKUMpLlEH1Qyt01qj6GDqeUFx8Dc7lJFrZE5Jk75vaQXxg8Y/nd7
        v1p0vnHBLiGhZsFuUztYss9Fo/8jYZite8v/3uOKIvx80O7JzFyMTCHASrm5pvmR+bLo6A+6iDI
        R+kAWoBjtiTDd
X-Received: by 2002:a92:c264:0:b0:314:5aa:94ba with SMTP id h4-20020a92c264000000b0031405aa94bamr3025123ild.9.1676481578291;
        Wed, 15 Feb 2023 09:19:38 -0800 (PST)
X-Google-Smtp-Source: AK7set8JFQMg3wd2K4N1A/L6AEEoJSZuErtZEgPbOjbAIunGxdN2sZ5/fVleX+GPj5DIkwZFSCFuTg==
X-Received: by 2002:a92:c264:0:b0:314:5aa:94ba with SMTP id h4-20020a92c264000000b0031405aa94bamr3025097ild.9.1676481577996;
        Wed, 15 Feb 2023 09:19:37 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q6-20020a02c8c6000000b00374fa5b600csm5932699jao.0.2023.02.15.09.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 09:19:37 -0800 (PST)
Date:   Wed, 15 Feb 2023 10:19:35 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 03/15] vfio: Accept vfio device file in the driver
 facing kAPI
Message-ID: <20230215101935.6416b39c.alex.williamson@redhat.com>
In-Reply-To: <Y+0QjaIWr84eVzsp@nvidia.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
        <20230213151348.56451-4-yi.l.liu@intel.com>
        <Y+rLKvCMivND0izd@nvidia.com>
        <DS0PR11MB7529B43C7D357D8A0C2438C7C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
        <Y+zSRklKkL3rc2FB@nvidia.com>
        <DS0PR11MB75299F5D92AAC33FD8690694C3A39@DS0PR11MB7529.namprd11.prod.outlook.com>
        <Y+zwSn63eA7HrefO@nvidia.com>
        <20230215083234.194d07a9.alex.williamson@redhat.com>
        <Y+0QjaIWr84eVzsp@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Feb 2023 13:04:13 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Feb 15, 2023 at 08:32:34AM -0700, Alex Williamson wrote:
> 
> > We've discussed this with Paolo before and I believe the bar of proof
> > is not very high.  I suspect it's not a problem that the device itself
> > is not yet accessible, so long as the user can prove they have the
> > ability to access the device, such as access to a restricted file.  In
> > most cases this isn't going to turn on wbinvd anyway since DMA will be
> > coherent.  Thanks,  
> 
> Isn't that a second problem, we don't know if the device is coherent
> until it is bound?

I think this is already accounted for in the conversion to device level
IOMMU ops, ie. device_iommu_capable() follows the
dev->iommu->iommu_dev->ops, where for example intel_iommu_capable() is
only looking at the capabilities of the IOMMU managing the device.  We
did some hand waving simplifications that was sufficient at some point,
IIRC.  Thanks,

Alex

