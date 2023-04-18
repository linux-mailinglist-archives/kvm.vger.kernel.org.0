Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F546E6493
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 14:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbjDRMuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 08:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbjDRMuU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 08:50:20 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D1116DE9;
        Tue, 18 Apr 2023 05:50:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ms80ndK0zi9QP2mttKrbQ7qDR6eX3YGSj2CJH0aL0molHc92ac5YF5wyocpyTe3IMWUMHOYU7sgvFUoGhU5tbPyvaoyuTAxMruV4tRQP39b0SWHVvZLWXnHCtbDTXLtV16rWHqtF8Jl0GfZqtvahgABPUsbAxYj63tI9kw67h5DD/w7a415R8RCghtj8zgTzsOKh0imwrVl2Om9fPJCeA27M4MS8bZAleP40Cy1bifWXtwrLmngmgk0M1XPGG3WK4TLcazhn80q1gJ9FFyWSjJ0w7lf/e6nXfQDlgFxxDGSQpYijRiJ2ufkoZORfY8eNKHzJhS5eWAhbR/GWtQggjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQerL7Y5HiNlI1qwd2LbFOUJg5EmJcu4kVqozwp5eeY=;
 b=iZNPWSs0LD+2yStyUHcR0/MFpanRQXmAKEWJKATNaJHBSfCUr4WM/IN/BduXx3wDgLsxKt5TQXmfy52rLW6k0QQw/PMLeuWo1nejx1f7TSl9R88NvkmUZkXAlNuLdP799my8wtjfCRitkgXHdAPVtxdh1ssRq1Jbb+FvTgOrTV3uJmjTLsCpF8bQoCoHf+ExutbfSnkQI065biFZdAECcOo6l//NMdfkBGoO2Eea1/Wm9FiTaKwFjSAm1OMM3Sde5J/viNI9Lj5kBhqPLbruJox6ITyyy/Gcu+2iDmWRnQy2IeVclXmlCzjCrzc/U3+Y7Tj5ooYN5KtJlwpFA+1/dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQerL7Y5HiNlI1qwd2LbFOUJg5EmJcu4kVqozwp5eeY=;
 b=O0QGaQDpU8/KDfhrmK0Dj+yBP/mIVv47O4p7DFUCy5ecidKXvHAQPP2mptXnZ46af3u7f9deYgEyGI5Q+EWM278p6F2dE2OqcdTlp185qITLGtKuMuGV0DluylXZrOnlfhL1lv1AcZt6iFC89IekUJnrkSAKtZdHJy53CQBYZkw=
Received: from CH3PR12MB8308.namprd12.prod.outlook.com (2603:10b6:610:131::8)
 by BN9PR12MB5382.namprd12.prod.outlook.com (2603:10b6:408:103::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 12:50:13 +0000
Received: from CH3PR12MB8308.namprd12.prod.outlook.com
 ([fe80::4e4f:3a93:b7bd:489c]) by CH3PR12MB8308.namprd12.prod.outlook.com
 ([fe80::4e4f:3a93:b7bd:489c%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 12:50:13 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "nicolas@fjasle.eu" <nicolas@fjasle.eu>,
        "git (AMD-Xilinx)" <git@amd.com>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Jansen Van Vuuren, Pieter" <pieter.jansen-van-vuuren@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>
Subject: RE: [PATCH v4] vfio/cdx: add support for CDX bus
Thread-Topic: [PATCH v4] vfio/cdx: add support for CDX bus
Thread-Index: AQHZceotnDdKVcO/JUaNbNYBLFyGmq8w+X4AgAAH6JA=
Date:   Tue, 18 Apr 2023 12:50:13 +0000
Message-ID: <CH3PR12MB8308DE1607789063D04B3529E89D9@CH3PR12MB8308.namprd12.prod.outlook.com>
References: <20230418113655.25207-1-nipun.gupta@amd.com>
 <ZD6IiHjWQOv47ZMg@ziepe.ca>
In-Reply-To: <ZD6IiHjWQOv47ZMg@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_ActionId=01be468c-7729-41a3-8a4a-cce49f41c212;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_ContentBits=0;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_Enabled=true;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_Method=Privileged;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_Name=Non-Business-AIP
 2.0;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_SetDate=2023-04-18T12:38:14Z;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB8308:EE_|BN9PR12MB5382:EE_
x-ms-office365-filtering-correlation-id: fb18128f-f7ca-42a2-bcd5-08db400b73ea
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yGaMOeC7Nql/i6wmkdZprAjdETVnOWTFFiIcT5bnzdd02DAxam+FoT7lJX8nUgfhBrKM2DTV/TGGxt+M/eq95cTLNiQVpK7bMyK85mbRC+mIA8fGESo8/n7rZ7WhWg3/jzPNWWJ+EMX0TUKRmjm8Dohoic9p3NNdt3MyaH5YPJ/T2cWXvSKoxFYq2O1PWFsaPrbPRTnM5arJx8GfZk10STSo+tFIX9grNFYEFQqcyeG6bLjn+MuTZDijbq+BhMcr41Bimb7Ys2TermCEasYmjLc6mq2k4xEYYMwAXWxAKklCre7JtPwa6gSGj6cK3P7/UFn33+xcQtvji5FQEo1xxls5vkRdn+aMX+2DGB4NcW4S9Mq6C+itEbaupo1Fwx9hB6Se/6ial0EoP9XHPnHfIx+ZqZL4z/RtEuCgA8aQrgflxMWx/g/7jeM2FSfZ1DCbbcKosOOxyWvOjWkxaUz9mEuzZ3/kha4JTMzWCdYsOodfHAVpbJl4X3ZNyZ5hCNxBw92FQOrsvcY1+iFMCbOpekz3QBdjpx2lN+tkTogVM7ryGkG17pSJrBHDfjgDJ19ndm93lbKAFZEJhfmd5ShocnNgK6pusTR79H9sl0+imSHtKGCTO0Jnk0axRdKr+kzI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8308.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(366004)(136003)(376002)(451199021)(55016003)(478600001)(71200400001)(38100700002)(8676002)(8936002)(316002)(41300700001)(4326008)(64756008)(66556008)(66946007)(66446008)(76116006)(54906003)(122000001)(110136005)(186003)(2906002)(38070700005)(53546011)(6506007)(9686003)(66476007)(83380400001)(86362001)(33656002)(52536014)(5660300002)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q9im7UcprGta6haJKd//p5bSGZZzPm0PUhi7KI1OghToOuPoyUafpZwNm6Wr?=
 =?us-ascii?Q?hzGfABpLn93M5UHLdVOCmajgRfPQNNG5JzPoa96vFEF3Z7NGZu5i+h0L5tIz?=
 =?us-ascii?Q?w8LofpHAEPVVDYVwqqGNRRCGmlVoex50jzeBv4dgvzj/CmQiA2WHHcIAjQgr?=
 =?us-ascii?Q?VSJ7XpeepeEKWXFAbYY7n3TWInqksTWdxU9/5+J9qWqvn+zYCBsA3TJ8AQ71?=
 =?us-ascii?Q?6AiIZP77k09/4rNSBsjjpdrrcnmpP5mTflIIIZg8IbKv/02A49qG68b2KtCb?=
 =?us-ascii?Q?Z1mDpNStdoybo8Myjd8LXMo8UhycisQrnrJYlL/fz2Sfryz/PDvhhM6j2u/O?=
 =?us-ascii?Q?wZFEV/h8IFeEtkSrq3Et/19dxKNr7ffjAGLrsXKVY6/US+7SRHycOQzvoo39?=
 =?us-ascii?Q?6LvvUMDtzB5X9SyZ4U36a3UbFjTQnvXJbsaQjlJApoe6CjsbR6d4CsfEAu1Q?=
 =?us-ascii?Q?70yOYD0KY4JuOvbCv2Vk2vYcwnzHSVg6UbTfVG5jZumVx1B55D9RC9YdqcjC?=
 =?us-ascii?Q?INtld8Uso/PpGAFatKhPVpdTmgyH54rx3JONOu2/oFfUOVeviqzaKrKXl6e3?=
 =?us-ascii?Q?TkgeVVVXeJv56do01dexIMPLXh5W3qzYsAMBTIH6GLzG1u1N8+AC0pr/VlCw?=
 =?us-ascii?Q?75TiSy8xECYedxfqEYZKX3PTO3UtjNwlPVx7thw713BlHQKSkBATYYpwo+bA?=
 =?us-ascii?Q?yCcRt9WiNr5z/F1OKOjAFqJfziMQQ2/xX8EDG3FNEhFCDnpI+S6RFXU+UX7r?=
 =?us-ascii?Q?VGmAom1gv6HICtlaXpJOdWwEDuhTsIGtgNZyIKc08o7GSt+RlY8ut7R9jwqD?=
 =?us-ascii?Q?s3cEkNgbd6Zr2MPz75VOKD0bTdXz8EM4l9D9uAP8JQZHeLFmbDHU754NBreO?=
 =?us-ascii?Q?zWMYmjVvipl2G6LPH45VKuajf+Edv635nPueBHlvRRvFx0NJodb6zfU4quQ/?=
 =?us-ascii?Q?p2caemasfzR3489NrE9yy0lJmmHPjNkPhjGA7P6z4khnAcxxIufUprYTRslI?=
 =?us-ascii?Q?ArTV603NqK7Q5nv4J+k5S2M0ZfWpCFB2L81xnYhNebOpsKEv/KCczrZ7DqNY?=
 =?us-ascii?Q?NCKsCArJKl16ldzGc7eHEhlIcDUUiOk5aPsgRpInv/LRwlnu6mTEy6bfUuwl?=
 =?us-ascii?Q?40bpLJjq0HVwA201COOiuIRxPCK1IIDw3xZhghj2LkmhANMrx49YR4YPuJAz?=
 =?us-ascii?Q?rihFwi346f59cHzJQBkgodY2IT+absdJR9xAlY55LLVIn96nkIlk+mmxwTQ6?=
 =?us-ascii?Q?P855VdyjDGQHjUj5vIF7JLwphkwJSTTNrPn1kQGRy2p13jihkGByOs3L9YUR?=
 =?us-ascii?Q?TjwSSPELkjv9qhg5fhtBaAMORQTqWxMo63krJSKx8hJIitDliNX4kD+vE4Ch?=
 =?us-ascii?Q?tZvHubyG1r/lYnW+EMDBz3/TROSK7ATew9odm1oCkIVf/2ox8jEXBOM7TdDq?=
 =?us-ascii?Q?2KWpivdCUQhcSY28aiJEX5mrM96YfKsnRZ5F9/47aDgDikR1seaMLyqN7k7R?=
 =?us-ascii?Q?/yGz7n9JEEqKH5yYT/X1lRQ/vXjwf7sk9qgNPXq96E/C0Ej2ZCB89VUeahGO?=
 =?us-ascii?Q?0iwZf0/T46a3ZAu0M94HLEvnm6eQQUdp3SCKf/EifuPGKSsDxCUKY2qr06ED?=
 =?us-ascii?Q?CUlkiYX+gVaVbBTQilGgQSU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8308.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb18128f-f7ca-42a2-bcd5-08db400b73ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 12:50:13.6263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BZnt33szUo9jaB4RL5G6vNfp9yeSI49kf3ZtPfQBdQkc5XV+crNL8RecmYRmV6XL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5382
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Tuesday, April 18, 2023 5:40 PM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>
> Cc: alex.williamson@redhat.com; linux-kernel@vger.kernel.org;
> kvm@vger.kernel.org; masahiroy@kernel.org; nathan@kernel.org;
> ndesaulniers@google.com; nicolas@fjasle.eu; git (AMD-Xilinx) <git@amd.com=
>;
> Anand, Harpreet <harpreet.anand@amd.com>; Jansen Van Vuuren, Pieter
> <pieter.jansen-van-vuuren@amd.com>; Agarwal, Nikhil
> <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>
> Subject: Re: [PATCH v4] vfio/cdx: add support for CDX bus
>=20
> Caution: This message originated from an External Source. Use proper caut=
ion
> when opening attachments, clicking links, or responding.
>=20
>=20
> On Tue, Apr 18, 2023 at 05:06:55PM +0530, Nipun Gupta wrote:
>=20
> > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > index 89e06c981e43..aba36f5be4ec 100644
> > --- a/drivers/vfio/Kconfig
> > +++ b/drivers/vfio/Kconfig
> > @@ -57,6 +57,7 @@ source "drivers/vfio/pci/Kconfig"
> >  source "drivers/vfio/platform/Kconfig"
> >  source "drivers/vfio/mdev/Kconfig"
> >  source "drivers/vfio/fsl-mc/Kconfig"
> > +source "drivers/vfio/cdx/Kconfig"
>=20
> keep sorted

Since it is not sorted as of now, should a separate patch to be created for
sorting, before adding vfio-cdx?

>=20
> >  endif
> >
> >  source "virt/lib/Kconfig"
> > diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> > index 70e7dcb302ef..1a27b2516612 100644
> > --- a/drivers/vfio/Makefile
> > +++ b/drivers/vfio/Makefile
> > @@ -14,3 +14,4 @@ obj-$(CONFIG_VFIO_PCI) +=3D pci/
> >  obj-$(CONFIG_VFIO_PLATFORM) +=3D platform/
> >  obj-$(CONFIG_VFIO_MDEV) +=3D mdev/
> >  obj-$(CONFIG_VFIO_FSL_MC) +=3D fsl-mc/
> > +obj-$(CONFIG_VFIO_CDX) +=3D cdx/
>=20
> keep sorted

Is there Linux guideline here on how objects and folders in Makefile are so=
rted,
as there are mix and match of files and folders in "drivers/vfio/Makefile".
I could not find any reference for sorting in other Makefiles as well.

>=20
> > diff --git a/drivers/vfio/cdx/Makefile b/drivers/vfio/cdx/Makefile
> > new file mode 100644
> > index 000000000000..82e4ef412c0f
> > --- /dev/null
> > +++ b/drivers/vfio/cdx/Makefile
> > @@ -0,0 +1,8 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
> > +#
> > +
> > +obj-$(CONFIG_VFIO_CDX) +=3D vfio-cdx.o
> > +
> > +vfio-cdx-objs :=3D vfio_cdx.o
>=20
> Linus has asked about "suttering" filenames before, suggest to call
> this
>=20
> "vfio/cdx/main.c"

Okay, I do not any strong affiliation towards the name.
Alex, your thoughts on this please?

>=20
> > +static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
> > +                        unsigned int cmd, unsigned long arg)
> > +{
> > +     struct vfio_cdx_device *vdev =3D
> > +             container_of(core_vdev, struct vfio_cdx_device, vdev);
> > +     struct cdx_device *cdx_dev =3D to_cdx_device(core_vdev->dev);
> > +     unsigned long minsz;
> > +
> > +     switch (cmd) {
> > +     case VFIO_DEVICE_GET_INFO:
> > +     {
> > +             struct vfio_device_info info;
> > +
> > +             minsz =3D offsetofend(struct vfio_device_info, num_irqs);
> > +
> > +             if (copy_from_user(&info, (void __user *)arg, minsz))
> > +                     return -EFAULT;
> > +
> > +             if (info.argsz < minsz)
> > +                     return -EINVAL;
> > +
> > +             info.flags =3D VFIO_DEVICE_FLAGS_CDX;
> > +             info.flags |=3D VFIO_DEVICE_FLAGS_RESET;
> > +
> > +             info.num_regions =3D cdx_dev->res_count;
> > +             info.num_irqs =3D 0;
> > +
> > +             return copy_to_user((void __user *)arg, &info, minsz) ?
> > +                     -EFAULT : 0;
> > +     }
> > +     case VFIO_DEVICE_GET_REGION_INFO:
> > +     {
> > +             struct vfio_region_info info;
> > +
> > +             minsz =3D offsetofend(struct vfio_region_info, offset);
> > +
> > +             if (copy_from_user(&info, (void __user *)arg, minsz))
> > +                     return -EFAULT;
> > +
> > +             if (info.argsz < minsz)
> > +                     return -EINVAL;
> > +
> > +             if (info.index >=3D cdx_dev->res_count)
> > +                     return -EINVAL;
> > +
> > +             /* map offset to the physical address  */
> > +             info.offset =3D vfio_cdx_index_to_offset(info.index);
> > +             info.size =3D vdev->regions[info.index].size;
> > +             info.flags =3D vdev->regions[info.index].flags;
> > +
> > +             if (copy_to_user((void __user *)arg, &info, minsz))
> > +                     return -EFAULT;
> > +             return 0;
> > +     }
> > +     case VFIO_DEVICE_RESET:
> > +     {
> > +             return cdx_dev_reset(core_vdev->dev);
> > +     }
> > +     default:
> > +             return -ENOTTY;
> > +     }
> > +}
>=20
> Please split this into functions, eg look at PCI

Sure, will split this into functions.

Regards,
Nipun

>=20
> Jason
