Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95AE46E3EC9
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 07:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjDQFNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 01:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjDQFNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 01:13:32 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2053.outbound.protection.outlook.com [40.107.96.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDA7A4;
        Sun, 16 Apr 2023 22:13:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+vNUyuaUHSeYhIztdO/sjC6yBwTpcMd8xjmaqrPYbo5o8kssle9dncCYrC6BMIYaGuuDZZcFTzoRspgwOIixCV94rhdjpVMA/wnClNqWmy5XSW7EF4CqlyaIcoo7Rgsb+KYHyysLyqgAPiOTdcpoIRHPaYonR16/aodQECMOIXgiRQhrnqi/3GP/AJ0dpupfEivJqHFUBoDDxROrPMjMfMwan+mEyLlX7QD9c0ZcKCnTGvp8UvZp2aFr1erIKOUcc7t5IznCZ6Y/wopN1Ps03NCsuEV7QQ2ZOnaw4uK5Wi2LVnItAuc/q2nIkLf6Feb2sIfE0DjtQZVmOTl8kyh3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ve8o8m1ET3BCzAxydUtjKCtrZthiTbp688R7YVqKpB0=;
 b=NKLGU+EAzint+gbLKneV5dKpWE/blZTBew3RXo6OfjNXbnmoSb9UEGzmIy8TdT6XhUBOttugB3TG41yxmh0TycQ2WEc7IDAJwIdXtyuKaNcQZIHjLzABgGpQvzaMlUEXBjbMzAD4nMbZHIKMlIe/8Wt6cOG9ZZpliBSRy653PZDjJStKtmGV3ZHioUWUJwyNLgsQMyKU5/XN7L97HpN8FeOjK/OncRHi9DIRFP1TN786Fd0MXQQv24RDopcs24DehSYbEj/b6WAbad3Uw8hg7Tuo6pGtJhNl7vrLU4j1EI/Bi0riAIV0sczUQqTPZ1I1vO3iMnDaqds/y4fqEsjiRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ve8o8m1ET3BCzAxydUtjKCtrZthiTbp688R7YVqKpB0=;
 b=Qhcn4kp9xaorPvnxdGrug6dXJKeCtL4l/fOWVHz8Bzl0ovuaBjnEGnWispVMfGConzc1QwZkSZymAFpjhnTijVo0Dx/is+N/9kLcm09GE8Tvt2dywrIOo9lRjWU156d0KQNCblw3LmgpZN5Mvadkfn7Wafv/i7lCspLfWCp53sE=
Received: from DS7PR12MB8322.namprd12.prod.outlook.com (2603:10b6:8:ec::20) by
 MW3PR12MB4569.namprd12.prod.outlook.com (2603:10b6:303:57::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.45; Mon, 17 Apr 2023 05:13:26 +0000
Received: from DS7PR12MB8322.namprd12.prod.outlook.com
 ([fe80::4c72:689e:3319:5cc]) by DS7PR12MB8322.namprd12.prod.outlook.com
 ([fe80::4c72:689e:3319:5cc%8]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 05:13:26 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Subject: RE: [PATCH v2] vfio/cdx: add support for CDX bus
Thread-Topic: [PATCH v2] vfio/cdx: add support for CDX bus
Thread-Index: AQHZbs15HOi8AGJVHEyZ47Q7VDPnRK8rVKsAgAOhlFA=
Date:   Mon, 17 Apr 2023 05:13:26 +0000
Message-ID: <DS7PR12MB83222F51F6102B85ADFFBB6DE89C9@DS7PR12MB8322.namprd12.prod.outlook.com>
References: <20230414123414.21645-1-nipun.gupta@amd.com>
 <20230414153614.3b72e659.alex.williamson@redhat.com>
In-Reply-To: <20230414153614.3b72e659.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_ActionId=2d518638-0c46-4c57-b1bf-80fba9c9a01d;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_ContentBits=0;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_Enabled=true;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_Method=Privileged;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_Name=Non-Business-AIP
 2.0;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_SetDate=2023-04-17T05:03:25Z;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR12MB8322:EE_|MW3PR12MB4569:EE_
x-ms-office365-filtering-correlation-id: 78417061-7c10-4fea-3ec4-08db3f02794c
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BMSpt7ZmpvgwYdUL1a/ebbqP5wEGNeL3bB46vIsiLh3n9NxfTkTMVUaww2Xu0/WSe5yLZEUJ4yKKu2VBGljgpfxhny2IVIz4fY8tVh507b7OIazlFg1pNjPX5GQdUJ7hs4f37uHlov/ouqh5HYimhRCPg2QUD74+9eSA9LCdBTqgLWycOz/ENz7wuJ/XZNsVGlfV0AmzyPBmzboJc4VKxLSFsS2WCBlURFmxEbwcckb0ZyyPPt89LwN7MAMqc5ls/pSdoK08XLTqvNRBA1jjWAcx8QJczPuyiar6P8vbyDXDuz8xRD8YK0wIP93sfbNiQi+GcqOGkltbbR3wvg66BzgbisY+4kmIRGEx+BAW1r55CWJn55ltv1eFpiGxXdsPbGgP89gtof6AhdIqwt1H79zyk8UapwYC9j9Ave6MJuawEqoZCBC+kpqAf8naFb/18Dl7RlL6N/UZ5W5nFNPqNApPvqkplqwXNqWGOitelUBaeYXcvHXBuJ/3HcEQ9xi7QLqX2OluLnnMngtnkE83kgytB/v1gvybFOenPS4PBKty76Urx9vt+Gw29XcSe7iFPMzDX+3DXEwoqqNeUK2+Rs4Lv0EY4DyHSvs+28IlYS275V96TQ/fOWQjU4wRxAjN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(451199021)(38070700005)(52536014)(2906002)(30864003)(5660300002)(8676002)(8936002)(41300700001)(122000001)(55016003)(86362001)(33656002)(38100700002)(4326008)(478600001)(54906003)(53546011)(26005)(6506007)(9686003)(186003)(71200400001)(7696005)(6916009)(64756008)(66446008)(66476007)(66556008)(76116006)(66946007)(316002)(83380400001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ge136I928K//GCSI1DpxaljS80yuFJ5/clyNdROK0w9DXpolln3YNWpqLZi7?=
 =?us-ascii?Q?GNdREn+FayLUy+pRhh+FsjU6weY2i0E5EamOAj2VE7E8aZYnXhU+5Q6K89FN?=
 =?us-ascii?Q?Q/u9OuYTh0gFXqTgB9OX3CBd22PRqH9WSvc7FMN0S13LMUYoLzNJQSYTOOvk?=
 =?us-ascii?Q?s6WTjN5cnBiDeZDY3RgGxGQmRYEB1tkVAKwlTYAs7Srp0elBKsnuEmz0MGRf?=
 =?us-ascii?Q?9ogxqSs5zjq8fzTE5ZollBAxzT054oNVU6MCUcy6Vgab0EXzvPoWGvqXVwsX?=
 =?us-ascii?Q?ACSs/G+f1SYLw6AdROnR99OfPmov6lm4nb8EpQaVkyUkGtnJqZVTWwKLAKHj?=
 =?us-ascii?Q?WfHMcTd09jo56HQp5PqXM6ec/PB55gdHXAzRalfGL0TDbF2NOGYnKLxXCDFQ?=
 =?us-ascii?Q?I761eozW3Js6l2dtVyYTzRr5qKewEk9pBozinkNthMLBIydtWrhcK6qOehUl?=
 =?us-ascii?Q?uJpu0aVHSZO6Wzha0CfP0oqF1wMyzDzGEFxTMb4r2IRIyGOja9wOk0x7xm6u?=
 =?us-ascii?Q?fz2yMgC+PvatOjorkCcDP234hVa3xx8WONrmQo3hknDfarm+EwC3UEkF7B9A?=
 =?us-ascii?Q?bzywXdO5VHcU03BQSrC9Lj6LFA1RDbLsf8X4VcB+2pD9LKqKJaQoT47I0Hpl?=
 =?us-ascii?Q?XCSt1iVNTw9WnVSpRtodjFCKUr4FCLh2qPU9hsQZsdlVxTNvdqYkGfvj0MxX?=
 =?us-ascii?Q?uPJkxjN6XIQPqgTP2gdCccPkIJRETQVR+Ucd0RUY65g+2dT3Wz7rx509ja9n?=
 =?us-ascii?Q?04M54qv4sZtkgt8FGJnSiZAGOBsKGMcuqfi9ybY3LeNhA96oOxk71U0+vMtw?=
 =?us-ascii?Q?eSTtDAIgs7SAXIIBoBPQzawBZQSjp6cXc4KDHIdhEBimNlVUUKD+CJD1oIf0?=
 =?us-ascii?Q?WdRTiDLbLeudvdKI2uy5obImV0dB0gs3/v5gDt4HmksUsOsqRIU6HkWEEUFs?=
 =?us-ascii?Q?D0Wwv6PqLxq9bvPz3Vc4rBHXSIPzSt8zLHFYnD9D1VzoScH99KStmPoDs6cm?=
 =?us-ascii?Q?YT+LiiJ73J6RFIfpoPNd5nJ0NRIFPMVdO/JGF+SmSMVNMe8uk99dWkL9fW56?=
 =?us-ascii?Q?8HmP/fbIgvlGnvHlWBFQNbPNQX8rtFRm7Cnlbpn+tuiTkaTageZXAEKVuA1g?=
 =?us-ascii?Q?r5kzGEdhZttHaIwHrrKTOT3BlItZ29aZmQdpN9UMw+I9VubOmsWwuvUEJxTI?=
 =?us-ascii?Q?2qw1gL0YBkj0alUoh1+xUup7BxS7Bdd/jTHKQ8CJu1ap6PtcoXModVNwvEpq?=
 =?us-ascii?Q?GpXzfuct1LAJiJaqGSwQzzBmUD4ZzygZtU/FwZqlMSfgH1CNRw0RaKX607A9?=
 =?us-ascii?Q?syuyYf5f4ehCi00icU5gnA5fleuPeTXKUei4g1LcZQOAQkSFPRXYF3zt+ECv?=
 =?us-ascii?Q?hqFihPVBr4USqkUc4mz/NKGCho1YhRY3hOtea4d/O3q0o8Csx08kpkizHmGf?=
 =?us-ascii?Q?opPV2cqPfPSqioFdV6Y4Q4EUz/18ySuOVpMihdVcUwYeYYGNejGIIyLCoFTO?=
 =?us-ascii?Q?LTeGurUMEzLe6hMfHwuq+WF7fUChDUCWNuSNd+wIVVta228vffJLFppeUxQI?=
 =?us-ascii?Q?WyjrE9FG7jFxCcFI6L0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB8322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78417061-7c10-4fea-3ec4-08db3f02794c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2023 05:13:26.0492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s/+VwGt8kLZc5vc1yQxFuB3c20KUaHbvc2eRTt+qOF/6zucXoZlXgwWHDzQ0dWwA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4569
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, April 15, 2023 3:06 AM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>
> Cc: jgg@ziepe.ca; linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
> masahiroy@kernel.org; nathan@kernel.org; ndesaulniers@google.com;
> nicolas@fjasle.eu; git (AMD-Xilinx) <git@amd.com>; Anand, Harpreet
> <harpreet.anand@amd.com>; Jansen Van Vuuren, Pieter <pieter.jansen-van-
> vuuren@amd.com>; Agarwal, Nikhil <nikhil.agarwal@amd.com>; Simek, Michal
> <michal.simek@amd.com>
> Subject: Re: [PATCH v2] vfio/cdx: add support for CDX bus
>=20
> Caution: This message originated from an External Source. Use proper caut=
ion
> when opening attachments, clicking links, or responding.
>=20
>=20
> On Fri, 14 Apr 2023 18:04:14 +0530
> Nipun Gupta <nipun.gupta@amd.com> wrote:
>=20
> > vfio-cdx driver enables IOCTLs for user space to query
> > MMIO regions for CDX devices and mmap them. This change
> > also adds support for reset of CDX devices.
> >
> > This change adds the VFIO CDX driver and enables the following
> > ioctls for CDX devices:
> >  - VFIO_DEVICE_GET_INFO:
> >  - VFIO_DEVICE_GET_REGION_INFO
> >  - VFIO_DEVICE_RESET
> >
> > Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> > Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com=
>
> > Tested-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
> > ---
> >
> > Changes v1->v2:
> > - Updated file2alias to support vfio_cdx
> > - removed some un-necessary checks in mmap
> > - removed vfio reset wrapper API
> > - converted complex macros to static APIs
> > - used pgprot_device and io_remap_pfn_range
> >
> >  MAINTAINERS                         |   7 +
> >  drivers/vfio/Kconfig                |   1 +
> >  drivers/vfio/Makefile               |   1 +
> >  drivers/vfio/cdx/Kconfig            |  17 ++
> >  drivers/vfio/cdx/Makefile           |   8 +
> >  drivers/vfio/cdx/vfio_cdx.c         | 290 ++++++++++++++++++++++++++++
> >  drivers/vfio/cdx/vfio_cdx_private.h |  31 +++
> >  include/linux/cdx/cdx_bus.h         |   1 -
> >  include/linux/mod_devicetable.h     |   6 +
> >  scripts/mod/devicetable-offsets.c   |   1 +
> >  scripts/mod/file2alias.c            |  17 +-
> >  11 files changed, 378 insertions(+), 2 deletions(-)
> >  create mode 100644 drivers/vfio/cdx/Kconfig
> >  create mode 100644 drivers/vfio/cdx/Makefile
> >  create mode 100644 drivers/vfio/cdx/vfio_cdx.c
> >  create mode 100644 drivers/vfio/cdx/vfio_cdx_private.h
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 7f74d8571ac9..c4fd42ba8f46 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -22064,6 +22064,13 @@ F:   Documentation/filesystems/vfat.rst
> >  F:   fs/fat/
> >  F:   tools/testing/selftests/filesystems/fat/
> >
> > +VFIO CDX DRIVER
> > +M:   Nipun Gupta <nipun.gupta@amd.com>
> > +M:   Nikhil Agarwal <nikhil.agarwal@amd.com>
> > +L:   kvm@vger.kernel.org
> > +S:   Maintained
> > +F:   drivers/vfio/cdx/*
> > +
> >  VFIO DRIVER
> >  M:   Alex Williamson <alex.williamson@redhat.com>
> >  L:   kvm@vger.kernel.org
> > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > index 89e06c981e43..aba36f5be4ec 100644
> > --- a/drivers/vfio/Kconfig
> > +++ b/drivers/vfio/Kconfig
> > @@ -57,6 +57,7 @@ source "drivers/vfio/pci/Kconfig"
> >  source "drivers/vfio/platform/Kconfig"
> >  source "drivers/vfio/mdev/Kconfig"
> >  source "drivers/vfio/fsl-mc/Kconfig"
> > +source "drivers/vfio/cdx/Kconfig"
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
> > diff --git a/drivers/vfio/cdx/Kconfig b/drivers/vfio/cdx/Kconfig
> > new file mode 100644
> > index 000000000000..e6de0a0caa32
> > --- /dev/null
> > +++ b/drivers/vfio/cdx/Kconfig
> > @@ -0,0 +1,17 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# VFIO CDX configuration
> > +#
> > +# Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
> > +#
> > +
> > +config VFIO_CDX
> > +     tristate "VFIO support for CDX bus devices"
> > +     depends on CDX_BUS
> > +     select EVENTFD
> > +     help
> > +       Driver to enable VFIO support for the devices on CDX bus.
> > +       This is required to make use of CDX devices present in
> > +       the system using the VFIO framework.
> > +
> > +       If you don't know what to do here, say N.
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
> > diff --git a/drivers/vfio/cdx/vfio_cdx.c b/drivers/vfio/cdx/vfio_cdx.c
> > new file mode 100644
> > index 000000000000..c19062ce7680
> > --- /dev/null
> > +++ b/drivers/vfio/cdx/vfio_cdx.c
> > @@ -0,0 +1,290 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
> > + */
> > +
> > +#include <linux/vfio.h>
> > +#include <linux/cdx/cdx_bus.h>
> > +
> > +#include "vfio_cdx_private.h"
> > +
> > +static struct cdx_driver vfio_cdx_driver;
> > +
> > +static int vfio_cdx_init_device(struct vfio_device *core_vdev)
> > +{
> > +     struct vfio_cdx_device *vdev =3D
> > +             container_of(core_vdev, struct vfio_cdx_device, vdev);
> > +     struct cdx_device *cdx_dev =3D to_cdx_device(core_vdev->dev);
> > +
> > +     vdev->cdx_dev =3D cdx_dev;
> > +     vdev->dev =3D &cdx_dev->dev;
>=20
> Both of these seem trivial to factor out of this patch, cdx_device is
> always available via to_cdx_device(core_vdev->dev) and the struct
> device is always available via core_vdev->dev.  vdev->dev isn't even
> used anywhere yet.  Both the init and release functions here could be
> dropped afaict.

Agree, these functions can be removed. Will update, test, and send in next =
spin.

>=20
> > +
> > +     return 0;
> > +}
> > +
> > +static void vfio_cdx_release_device(struct vfio_device *core_vdev)
> > +{
> > +     struct vfio_cdx_device *vdev =3D
> > +             container_of(core_vdev, struct vfio_cdx_device, vdev);
> > +
> > +     vdev->cdx_dev =3D NULL;
> > +     vdev->dev =3D NULL;
> > +}
> > +
> > +/**
> > + * CDX_DRIVER_OVERRIDE_DEVICE_VFIO - macro used to describe a VFIO
> > + *                                   "driver_override" CDX device.
> > + * @vend: the 16 bit CDX Vendor ID
> > + * @dev: the 16 bit CDX Device ID
> > + *
> > + * This macro is used to create a struct cdx_device_id that matches a
> > + * specific device. driver_override will be set to
> > + * CDX_ID_F_VFIO_DRIVER_OVERRIDE.
> > + */
> > +#define CDX_DRIVER_OVERRIDE_DEVICE_VFIO(vend, dev) \
> > +     CDX_DEVICE_DRIVER_OVERRIDE(vend, dev,
> CDX_ID_F_VFIO_DRIVER_OVERRIDE)
> > +
> > +static int vfio_cdx_open_device(struct vfio_device *core_vdev)
> > +{
> > +     struct vfio_cdx_device *vdev =3D
> > +             container_of(core_vdev, struct vfio_cdx_device, vdev);
> > +     struct cdx_device *cdx_dev =3D vdev->cdx_dev;
> > +     int count =3D cdx_dev->res_count;
> > +     int i;
> > +
> > +     vdev->regions =3D kcalloc(count, sizeof(struct vfio_cdx_region),
> > +                             GFP_KERNEL);
> > +     if (!vdev->regions)
> > +             return -ENOMEM;
> > +
> > +     for (i =3D 0; i < count; i++) {
> > +             struct resource *res =3D &cdx_dev->res[i];
> > +
> > +             vdev->regions[i].addr =3D res->start;
> > +             vdev->regions[i].size =3D resource_size(res);
> > +             vdev->regions[i].type =3D res->flags;
> > +             /*
> > +              * Only regions addressed with PAGE granularity may be
> > +              * MMAP'ed securely.
> > +              */
> > +             if (!(vdev->regions[i].addr & ~PAGE_MASK) &&
> > +                 !(vdev->regions[i].size & ~PAGE_MASK))
> > +                     vdev->regions[i].flags |=3D
> > +                                     VFIO_REGION_INFO_FLAG_MMAP;
> > +             vdev->regions[i].flags |=3D VFIO_REGION_INFO_FLAG_READ;
> > +             if (!(cdx_dev->res[i].flags & IORESOURCE_READONLY))
> > +                     vdev->regions[i].flags |=3D VFIO_REGION_INFO_FLAG=
_WRITE;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static void vfio_cdx_regions_cleanup(struct vfio_cdx_device *vdev)
> > +{
> > +     kfree(vdev->regions);
> > +}
> > +
> > +static void vfio_cdx_close_device(struct vfio_device *core_vdev)
> > +{
> > +     struct vfio_cdx_device *vdev =3D
> > +             container_of(core_vdev, struct vfio_cdx_device, vdev);
> > +     int ret;
> > +
> > +     vfio_cdx_regions_cleanup(vdev);
> > +
> > +     /* reset the device before cleaning up the interrupts */
> > +     ret =3D cdx_dev_reset(&vdev->cdx_dev->dev);
> > +     if (WARN_ON(ret))
> > +             dev_warn(core_vdev->dev,
> > +                      "VFIO_CDX: reset device has failed (%d)\n", ret)=
;
>=20
> WARN_ON() + dev_warn(), do we need both?  Curious we're not even using
> vdev->dev here ;)

WARN_ON will be removed and we will keep using core_vdev->dev as vdev->dev
will be removed :)

>=20
> > +}
> > +
> > +static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
> > +                        unsigned int cmd, unsigned long arg)
> > +{
> > +     struct vfio_cdx_device *vdev =3D
> > +             container_of(core_vdev, struct vfio_cdx_device, vdev);
> > +     struct cdx_device *cdx_dev =3D vdev->cdx_dev;
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
> > +             info.flags =3D VFIO_DEVICE_FLAGS_RESET;
>=20
> There ought to be a flag here indicating the vfio device exposed is
> vfio-cdx.

Sure, will add.

>=20
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
> > +             return cdx_dev_reset(&vdev->cdx_dev->dev);
> > +     }
> > +     default:
> > +             return -ENOTTY;
> > +     }
> > +}
> > +
> > +static int vfio_cdx_mmap_mmio(struct vfio_cdx_region region,
> > +                           struct vm_area_struct *vma)
> > +{
> > +     u64 size =3D vma->vm_end - vma->vm_start;
> > +     u64 pgoff, base;
> > +
> > +     pgoff =3D vma->vm_pgoff &
> > +             ((1U << (VFIO_CDX_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> > +     base =3D pgoff << PAGE_SHIFT;
> > +
> > +     if (region.size < PAGE_SIZE || base + size > region.size)
> > +             return -EINVAL;
> > +
> > +     vma->vm_pgoff =3D (region.addr >> PAGE_SHIFT) + pgoff;
> > +     vma->vm_page_prot =3D pgprot_device(vma->vm_page_prot);
> > +
> > +     return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
> > +                               size, vma->vm_page_prot);
> > +}
> > +
> > +static int vfio_cdx_mmap(struct vfio_device *core_vdev,
> > +                      struct vm_area_struct *vma)
> > +{
> > +     struct vfio_cdx_device *vdev =3D
> > +             container_of(core_vdev, struct vfio_cdx_device, vdev);
> > +     struct cdx_device *cdx_dev =3D vdev->cdx_dev;
> > +     unsigned int index;
> > +
> > +     index =3D vma->vm_pgoff >> (VFIO_CDX_OFFSET_SHIFT - PAGE_SHIFT);
> > +
> > +     if (index >=3D cdx_dev->res_count)
> > +             return -EINVAL;
> > +
> > +     if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_MMAP))
> > +             return -EINVAL;
> > +
> > +     if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_READ) &&
> > +         (vma->vm_flags & VM_READ))
> > +             return -EINVAL;
> > +
> > +     if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE) &=
&
> > +         (vma->vm_flags & VM_WRITE))
> > +             return -EINVAL;
> > +
> > +     return vfio_cdx_mmap_mmio(vdev->regions[index], vma);
> > +}
> > +
> > +static const struct vfio_device_ops vfio_cdx_ops =3D {
> > +     .name           =3D "vfio-cdx",
> > +     .init           =3D vfio_cdx_init_device,
> > +     .release        =3D vfio_cdx_release_device,
> > +     .open_device    =3D vfio_cdx_open_device,
> > +     .close_device   =3D vfio_cdx_close_device,
> > +     .ioctl          =3D vfio_cdx_ioctl,
> > +     .mmap           =3D vfio_cdx_mmap,
>=20
> Missing bind_iommufd, unbind_iommufd, and attach_ioas, which will be
> necessary for iommufd support.

Sure, will add these too.

>=20
> > +};
> > +
> > +static int vfio_cdx_probe(struct cdx_device *cdx_dev)
> > +{
> > +     struct vfio_cdx_device *vdev =3D NULL;
> > +     struct device *dev =3D &cdx_dev->dev;
> > +     int ret;
> > +
> > +     vdev =3D vfio_alloc_device(vfio_cdx_device, vdev, dev,
> > +                              &vfio_cdx_ops);
> > +     if (IS_ERR(vdev))
> > +             return PTR_ERR(vdev);
> > +
> > +     ret =3D vfio_register_group_dev(&vdev->vdev);
> > +     if (ret) {
> > +             dev_err(dev, "VFIO_CDX: Failed to add to vfio group\n");
> > +             goto out_uninit;
> > +     }
> > +
> > +     dev_set_drvdata(dev, vdev);
> > +     return 0;
> > +
> > +out_uninit:
> > +     vfio_put_device(&vdev->vdev);
> > +     return ret;
> > +}
> > +
> > +static int vfio_cdx_remove(struct cdx_device *cdx_dev)
> > +{
> > +     struct device *dev =3D &cdx_dev->dev;
> > +     struct vfio_cdx_device *vdev;
> > +
> > +     vdev =3D dev_get_drvdata(dev);
> > +     vfio_unregister_group_dev(&vdev->vdev);
> > +     vfio_put_device(&vdev->vdev);
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct cdx_device_id vfio_cdx_table[] =3D {
> > +     { CDX_DRIVER_OVERRIDE_DEVICE_VFIO(CDX_ANY_ID, CDX_ANY_ID) }, /*
> match all by default */
> > +     {}
> > +};
> > +
> > +MODULE_DEVICE_TABLE(cdx, vfio_cdx_table);
> > +
> > +static struct cdx_driver vfio_cdx_driver =3D {
> > +     .probe          =3D vfio_cdx_probe,
> > +     .remove         =3D vfio_cdx_remove,
> > +     .match_id_table =3D vfio_cdx_table,
> > +     .driver =3D {
> > +             .name   =3D "vfio-cdx",
> > +             .owner  =3D THIS_MODULE,
> > +     },
> > +     .driver_managed_dma =3D true,
> > +};
> > +
> > +static int __init vfio_cdx_driver_init(void)
> > +{
> > +     return cdx_driver_register(&vfio_cdx_driver);
> > +}
> > +
> > +static void __exit vfio_cdx_driver_exit(void)
> > +{
> > +     cdx_driver_unregister(&vfio_cdx_driver);
> > +}
> > +
> > +module_init(vfio_cdx_driver_init);
> > +module_exit(vfio_cdx_driver_exit);
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_DESCRIPTION("VFIO for CDX devices - User Level meta-driver");
> > diff --git a/drivers/vfio/cdx/vfio_cdx_private.h
> b/drivers/vfio/cdx/vfio_cdx_private.h
> > new file mode 100644
> > index 000000000000..5f143736eb7a
> > --- /dev/null
> > +++ b/drivers/vfio/cdx/vfio_cdx_private.h
> > @@ -0,0 +1,31 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
> > + */
> > +
> > +#ifndef VFIO_CDX_PRIVATE_H
> > +#define VFIO_CDX_PRIVATE_H
> > +
> > +#define VFIO_CDX_OFFSET_SHIFT    40
> > +
> > +static inline u64 vfio_cdx_index_to_offset(u32 index)
> > +{
> > +     return ((u64)(index) << VFIO_CDX_OFFSET_SHIFT);
> > +}
> > +
> > +struct vfio_cdx_region {
> > +     u32                     flags;
> > +     u32                     type;
> > +     u64                     addr;
> > +     resource_size_t         size;
> > +     void __iomem            *ioaddr;
>=20
> I don't see that ioaddr is used in this patch.  Future r/w support?

Agree, will remove this from this patch.

Thanks,
Nipun

> Thanks,
>=20
> Alex
>=20
> > +};
> > +
> > +struct vfio_cdx_device {
> > +     struct vfio_device      vdev;
> > +     struct cdx_device       *cdx_dev;
> > +     struct device           *dev;
> > +     struct vfio_cdx_region  *regions;
> > +};
> > +
> > +#endif /* VFIO_CDX_PRIVATE_H */
> > diff --git a/include/linux/cdx/cdx_bus.h b/include/linux/cdx/cdx_bus.h
> > index 35ef41d8a61a..bead71b7bc73 100644
> > --- a/include/linux/cdx/cdx_bus.h
> > +++ b/include/linux/cdx/cdx_bus.h
> > @@ -14,7 +14,6 @@
> >  #include <linux/mod_devicetable.h>
> >
> >  #define MAX_CDX_DEV_RESOURCES        4
> > -#define CDX_ANY_ID (0xFFFF)
> >  #define CDX_CONTROLLER_ID_SHIFT 4
> >  #define CDX_BUS_NUM_MASK 0xF
> >
> > diff --git a/include/linux/mod_devicetable.h
> b/include/linux/mod_devicetable.h
> > index ccaaeda792c0..ccf017353bb6 100644
> > --- a/include/linux/mod_devicetable.h
> > +++ b/include/linux/mod_devicetable.h
> > @@ -912,6 +912,12 @@ struct ishtp_device_id {
> >       kernel_ulong_t driver_data;
> >  };
> >
> > +#define CDX_ANY_ID (0xFFFF)
> > +
> > +enum {
> > +     CDX_ID_F_VFIO_DRIVER_OVERRIDE =3D 1,
> > +};
> > +
> >  /**
> >   * struct cdx_device_id - CDX device identifier
> >   * @vendor: Vendor ID
> > diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetabl=
e-
> offsets.c
> > index 62dc988df84d..abe65f8968dd 100644
> > --- a/scripts/mod/devicetable-offsets.c
> > +++ b/scripts/mod/devicetable-offsets.c
> > @@ -265,6 +265,7 @@ int main(void)
> >       DEVID(cdx_device_id);
> >       DEVID_FIELD(cdx_device_id, vendor);
> >       DEVID_FIELD(cdx_device_id, device);
> > +     DEVID_FIELD(cdx_device_id, override_only);
> >
> >       return 0;
> >  }
> > diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> > index 28da34ba4359..38120f932b0d 100644
> > --- a/scripts/mod/file2alias.c
> > +++ b/scripts/mod/file2alias.c
> > @@ -1458,8 +1458,23 @@ static int do_cdx_entry(const char *filename, vo=
id
> *symval,
> >  {
> >       DEF_FIELD(symval, cdx_device_id, vendor);
> >       DEF_FIELD(symval, cdx_device_id, device);
> > +     DEF_FIELD(symval, cdx_device_id, override_only);
> >
> > -     sprintf(alias, "cdx:v%08Xd%08Xd", vendor, device);
> > +     switch (override_only) {
> > +     case 0:
> > +             strcpy(alias, "cdx:");
> > +             break;
> > +     case CDX_ID_F_VFIO_DRIVER_OVERRIDE:
> > +             strcpy(alias, "vfio_cdx:");
> > +             break;
> > +     default:
> > +             warn("Unknown CDX driver_override alias %08X\n",
> > +                  override_only);
> > +             return 0;
> > +     }
> > +
> > +     ADD(alias, "v", vendor !=3D CDX_ANY_ID, vendor);
> > +     ADD(alias, "d", device !=3D CDX_ANY_ID, device);
> >       return 1;
> >  }
> >

