Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615AC4CDE31
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiCDUDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiCDUCr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:02:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 030242BBC09
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 11:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646423674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pM1F1/T2x1AGJPbHCgjIb2A2+Vv+D8cNuQhS+x4EuMs=;
        b=RoU35dzahap1VPkPWktktHX6NYXWTjGDNDqwOMl0QPkIoro1bzWJ0LZ4MxRnDcqQmTnBZu
        fYWXH0yLfg9e/OzIMDigf9X1//1dFybLdFrz718orYRcUTE+0hw5bHyoNyOAqZxazFPoCQ
        yK3UBBD1BKUpdYzkrwqaJGtRvJlo65U=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-MEz5SE6nOxqq-wg-Ji0zEQ-1; Fri, 04 Mar 2022 14:44:13 -0500
X-MC-Unique: MEz5SE6nOxqq-wg-Ji0zEQ-1
Received: by mail-ot1-f69.google.com with SMTP id 38-20020a9d0829000000b005afe328b01dso6536437oty.16
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 11:44:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pM1F1/T2x1AGJPbHCgjIb2A2+Vv+D8cNuQhS+x4EuMs=;
        b=WehUQLv4GOb3Sxn9muD7+JZI6QKSBQzp2+a3C7BKhv5Pc8w17ihmJi78ss4ARn3U/t
         8NGNkRtRLfCAuma647PSxXaixmtQpK1ggMeKEte2CbLEh8wDFW9cRd5WtOq0Qn1VyRCo
         sVaOAQwPk61pmavdWSxPO5BmTwfF7ZH6qlTQS13rQcYLQvxrAJ8qPQx8faskgpvAFoj2
         k8oMxMjq3jfyVI7+wZK+T5SiqYJ9MUyD2OL/Ft8Ty1WozxIX3pvcqFJosPJoRNRWTe66
         pYFGIaZo+eBv9M67NLJIQC2e3IvrM2SiIkvo0AYO9tEjExw+hSaVOkIVidGcQl5ju+DJ
         eGqg==
X-Gm-Message-State: AOAM533XDC0ExNWvetrSq9QVPUIKU2cpMTBpdwdYU+X2Mi55K+sdRrBR
        D5LojaU0HVInxgFFMmC5YDHSVE0G3mV+gohGRpkEKjyD1rP7OBjI2x+pkftZ7ouaSdO0FT8DVGw
        6eCyaJ7YpOsIv
X-Received: by 2002:a05:6870:f144:b0:da:b3f:2b88 with SMTP id l4-20020a056870f14400b000da0b3f2b88mr469549oac.295.1646423052399;
        Fri, 04 Mar 2022 11:44:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwLx1Oo2HmRahYyTM2fzwk1l6MYz7YP18iY6J/yREFpr5YIXwj0jeNtz5EMM11fBL1czktGLg==
X-Received: by 2002:a05:6870:f144:b0:da:b3f:2b88 with SMTP id l4-20020a056870f14400b000da0b3f2b88mr469546oac.295.1646423052181;
        Fri, 04 Mar 2022 11:44:12 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g2-20020a9d5f82000000b005af678c9cfdsm2749709oti.41.2022.03.04.11.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 11:44:11 -0800 (PST)
Date:   Fri, 4 Mar 2022 12:44:10 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220304124410.02423606.alex.williamson@redhat.com>
In-Reply-To: <0dc03eab33b74e6ea95f2ac0eb39cc83@huawei.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
        <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
        <0dc03eab33b74e6ea95f2ac0eb39cc83@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Mar 2022 08:48:27 +0000
Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

> Hi Alex,
> 
> > -----Original Message-----
> > From: Shameerali Kolothum Thodi
> > Sent: 03 March 2022 23:02
> > To: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-crypto@vger.kernel.org
> > Cc: linux-pci@vger.kernel.org; alex.williamson@redhat.com; jgg@nvidia.com;
> > cohuck@redhat.com; mgurtovoy@nvidia.com; yishaih@nvidia.com; Linuxarm
> > <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>; Zengtao (B)
> > <prime.zeng@hisilicon.com>; Jonathan Cameron
> > <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> > Subject: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live migration
> > 
> > From: Longfang Liu <liulongfang@huawei.com>
> > 
> > VMs assigned with HiSilicon ACC VF devices can now perform live migration if
> > the VF devices are bind to the hisi_acc_vfio_pci driver.
> > 
> > Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> > Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>  
> 
> [...]
> > +
> > +static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> > +			     struct hisi_acc_vf_migration_file *migf) {
> > +	struct acc_vf_data *vf_data = &migf->vf_data;
> > +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> > +	struct hisi_qm *pf_qm = &hisi_acc_vdev->vf_qm;  
> 
> Oops, the above has to be,
>   struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
> 
> This was actually fixed in v6, but now that I rebased mainly to v5, missed it.
> Please let me know if you want a re-spin with the above fix(in case there are no further
> comments) or this is something you can take care.

To confirm, you're looking for this change:

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index aa2e4b6bf598..f2a0c046413f 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -413,7 +413,7 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 {
 	struct acc_vf_data *vf_data = &migf->vf_data;
 	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
-	struct hisi_qm *pf_qm = &hisi_acc_vdev->vf_qm;
+	struct hisi_qm *pf_qm = &hisi_acc_vdev->pf_qm;
 	struct device *dev = &vf_qm->pdev->dev;
 	u32 que_iso_state;
 	int ret;

Right?  I can roll that in assuming there are no further comments that
would generate a respin.  Thanks,

Alex

