Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272C96F6266
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 02:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjEDAmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 20:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjEDAmD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 20:42:03 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADAC138;
        Wed,  3 May 2023 17:42:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AMSRPgEG7fRa4F7Fu7URlEQaJPLeS5ptIIs2O20KP87+Ycn0Fi1Ge9hG7B+RZTVs4qyLQmfJR2O7CUHIaOSvA4fJwKa3f1qE/bluXFTUjMCTIYL8YJaB/dHBud+WoIOczCS6b1WRR0qQq6dfD316wvPLshsJR88TClAu2Nk5zAydV+zYh0rzT4HD0ZuOeCBOxQsxDrBBkK7RoRA8eOcSz5aF15ixw81ywM65Jdw/JF8Rx9kwmrhIO6QQqJM/b6Mql7CJMWng2CNRO55/5M2Tja7U38vzzhjSeJ/fA+lKBYFWq4lhCGFsq+V/nG5iyU8ewKmEMhzGrMPwN3deokvBNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BMcXqyyi8gRrpmMKTrruHHaXFeG8L99I9aIA94kdIKY=;
 b=ODwJAwb9dKj/6e5yFw8E93LG9mQ1IZ69jY6FYrVzVsmK5A2opj+ERoxW23Gk02glsbhZRLqks+3SkpvpMdCDyed4Q5oBcLhxXcDEYtrRXiJdsw4/9HrI3JC8yJQybSfsXTwBwdSzawla7apRfzFhU0yMnmqFU6BFb8n2tdae3VyWafkHJr/Imrst0XMcAkncz2heOgfH6qOqdZxFOrZhj3LRXOHgesbRuRjGjhsL6B1+5eYv7zcPFeQk9Oge2pglU7rK6Y0pcP079sXiizuM04AEJcqyqjiNJEPDd4SjwxWVj3VwMM0c6h3NCeUJ2/lDim2ihpiYo4xRpEGowmFfpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BMcXqyyi8gRrpmMKTrruHHaXFeG8L99I9aIA94kdIKY=;
 b=HqIPC8wNne6OR3pukCJABYIWWerCewM/T2IKq1IPcz/xRAJt4qUDQRr/JBnC4lEryLTgu2JLoggc8iZusR3EUOIe1akmGDRmfLdNYexj1x+CEN+zZGKcyfu8UzobT2240UxZP8IyMmiT7zb1ombheb+nfSJXrhWNQD7DbW2nWWOmw3OSVdnrSouvXKoInSoK4vH5/eeYQ9Z/2WpaqggJhEs86gSO5i2KuTj0L73nSFU+NQ0CubKoEePYaqE7STKHa7uCHdTbe9UXEm5JcR0rQYBFCEMwrgolkAtQw2qK4ATizLgVyTLlquisS7GGhWfJTqEgvr0A0GZQQVbu7JVsAQ==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by DS7PR12MB8083.namprd12.prod.outlook.com (2603:10b6:8:e4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Thu, 4 May
 2023 00:41:56 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::499c:e465:f7f1:d0ef]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::499c:e465:f7f1:d0ef%3]) with mapi id 15.20.6340.031; Thu, 4 May 2023
 00:41:55 +0000
From:   Ankit Agrawal <ankita@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <ACurrid@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper device
Thread-Topic: [PATCH v1 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper device
Thread-Index: AQHZcw5SVCbgiFsXmkWau4/ObIvOs6801mYAgBSDHAA=
Date:   Thu, 4 May 2023 00:41:55 +0000
Message-ID: <BY5PR12MB37636C1F3B3B3316C31EBE99B06D9@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20230419222836.24714-1-ankita@nvidia.com>
 <20230420171720.418a3c0d.alex.williamson@redhat.com>
In-Reply-To: <20230420171720.418a3c0d.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|DS7PR12MB8083:EE_
x-ms-office365-filtering-correlation-id: 1a3fc7a2-dd77-4764-5007-08db4c385c60
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xfG6ACCUMFDeZ+A+o8XcrzhksHVJTBcH+bkI3nB4XIWPuG0qm4T8AoO0ynS1suFAUKzcqT37xJLpEn4HNsTv76x6aCCpXxgcB4Wac3uMHKwVtDOiphQb8+Q9BjITucyCR/bM1aP8u2WSpFd/qqy8nNKBmnpJJR4CgOnGiMsl2RFOD1/C7HOk+fjCQ21vskD5Ut2o4y6F2W3DHOWn5lwgedJtO0KBbkZPwyL8d3ranSiUtPm7NfwLUYY8xRa3Bpt3nhj4QjzBrcuqv4EsCJvda7XimzM8oh3TE6BvZ3zFYrTPJcjLoFSQLcHST9InhR/CvolJic/S3A6CtFKC8OSJGHNovlzA//xGoEmLcB72ef7AiF2xBBzBPDmKBXlgOVcHT7geh+dawltQPZ6eai6xKdNvIcrQq6vDpB7/vsOt7zYh4eV6D92DZvKAG0pRdxvpYS7tCK5CRE/oJ5JvFIg4tzuwwq9BNYm/rUPt/ehhMg6Zify2BbIT4pen+KJVHjPMxg6rumKymXOSvfhB9b+NtwSBN230kdjmab4Dt1UTiZtbaexn6uaHWitofPGj835/KuvYgSDQQ2q40/jiBxRBJrkWeGWxuFPdaBKAGQGhAhOIzJTaQjyYI9ytcbdLE057NF0DRhlyb8lW7m/960o1/bE9HwZN6uNDmvSyngfExFR4SWtGUoBkNK5tK85iwwQRoAsTzJ9pEIV6k38eppMRtw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199021)(86362001)(478600001)(33656002)(54906003)(66476007)(316002)(4326008)(66446008)(966005)(66556008)(6916009)(71200400001)(7696005)(76116006)(66946007)(64756008)(2906002)(55016003)(8936002)(30864003)(41300700001)(38070700005)(186003)(122000001)(5660300002)(38100700002)(53546011)(6506007)(26005)(9686003)(83380400001)(52536014)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9WF0RafNakvw162J8GRmgemsvFar4rRoMz4zLcqNngQU78Cdfap4fVIvFAFX?=
 =?us-ascii?Q?u4L6fiLb6dODLYrIjjcfEOidYkQ7hqFHN95wa5f1d2noOVt4ZAGX3yWSqcOL?=
 =?us-ascii?Q?KOP85vqFuQBZkcGBTtOBlErtq8xkeL/wGLXXt6pOgtn0ZPR8qcwDq0rIFJMa?=
 =?us-ascii?Q?LKRUyZubl5+Z+ojExjcZHd5G/16fu6lKfNwljY5APnI9Fvhb8SwA4GVCwgc7?=
 =?us-ascii?Q?D6neF8o8aWKpSvOM9wqSQNcsNcKoV4UYMHlpYZwYH9A65YzZ/abNnpppPvaz?=
 =?us-ascii?Q?TNiIjFSmxTMPHE4pLSEGwaboYqW3uQQTP4rSlFMaF92ww3N17oSNV2pcenJZ?=
 =?us-ascii?Q?KIvPK0l4yP44cID1bi/7Uwp8IwAxY+Nd+r41PIPJivLTsd2+FnZ934z3hdbi?=
 =?us-ascii?Q?PcjIgRJAJvJjumK+ST17jeEAqXoArC+fsay3ZiSFtNPq/TpqHvpr0N3qRSLk?=
 =?us-ascii?Q?g9zawyjPT3CQNcdK/+NlO55RBDayrDSnpcqtCAkaaUC3ubhpzF61qa9trmIr?=
 =?us-ascii?Q?XO0y8y1VLHzr3AMxSt0uXnbxeBEUi7dK81DYFE8axtSy24IQZHzb62AE8M6M?=
 =?us-ascii?Q?SRTjTSYxfocTqvFxNameYrNTXfiXpaPyho9JOTIZxL+sLBRp/sgr8NLaSPly?=
 =?us-ascii?Q?LY5njjGJnbE14v/RWKnSvOKlrKbnC7t9zeXc/NQpJMYo7zQWjH4Y9Qb3lpSM?=
 =?us-ascii?Q?TAUG0W5xHTfUC4gHQZMWezPaoGW+/QdrDqC8osi4h/af658pfYDXFhkLU5Bi?=
 =?us-ascii?Q?KDFpH5xQl67/NMhbhw/M9lghwPDQVEaR9W/d7U97JGN5CXIXps0ilSB4NCvR?=
 =?us-ascii?Q?XUS1JtkdYT7Qf3XT8jqBxpI+oZHZM+0gm4b7MNqmkH8JGNF/3cuo9sPLmi5z?=
 =?us-ascii?Q?wfHO4jVbL/taybLa0AYNlI9WrfqqYaywEj9Yat0QG7X4JI8xsiWj4sml7A8W?=
 =?us-ascii?Q?tesJsgytQAfG7KSkSYahgTAgPgrUUiTpD5vOqn8R/c8UupvJpE+2xBWW1U/s?=
 =?us-ascii?Q?dkcb/uW3K2WTXePDyGccztH03x+PMA5qgIt2vcSVE9shmsCiJZivu2MGG5BM?=
 =?us-ascii?Q?7TbgVOBqse+pJ89CFZx1YB7aPO/8JrLO33VEcecrfRD58SLge1RJfNe4Nre8?=
 =?us-ascii?Q?IxPyc9FcpTM7gL7Xc5rHqnhIcm4oX7x/yCfeLmB8nstjnGEuEXp0SwE1TdNx?=
 =?us-ascii?Q?QV/6Doklym8CS4XgwOpOtYetlX6o3tRs/vL2e2vlTpvd+qe0vw6euVHIL5AX?=
 =?us-ascii?Q?egcaqlOYcw5IR23qlNZI2bBJf0WfQ6wS5qGN4mRy9K0vUtVxH5eJwh5oao0F?=
 =?us-ascii?Q?eBiEXjctAmm4+jL6aS4m0VcbwqyAFpynTGusZ6Xhfqhw1w+QIi+B421Epx63?=
 =?us-ascii?Q?HKbuP88eMEn8M2EEFGMuCFIVv21CNfDwyPpXDulptKGwxZyxwTrPGe6+NFXD?=
 =?us-ascii?Q?REX6Ww5PhPHIrp1xWD58ugIgUVJKUk4O3aYqvNXEH6n0qx0bND5gfTR26hP0?=
 =?us-ascii?Q?kyBqpLagIiiKK+hzQabx1USL1T62Uw6XbmehFmApkZYE49D4eD9jq9+MZt6C?=
 =?us-ascii?Q?4yDQvpqTIeVcGpn++BjT9ouIL9HwrWifzOxw3+pK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a3fc7a2-dd77-4764-5007-08db4c385c60
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2023 00:41:55.4144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FDnfyoBj71tMINChuBAOObG9nCyXQX7CrxWz5jhPceoGzmCA3Sz7q3n9jWog0Y6xNJTaTwQ0h5oPnSW02SWZrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8083
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks Alex, comments inline.

> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, April 20, 2023 4:17 PM
> To: Ankit Agrawal <ankita@nvidia.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>; Aniket Agashe
> <aniketa@nvidia.com>; Neo Jia <cjia@nvidia.com>; Kirti Wankhede
> <kwankhede@nvidia.com>; Tarun Gupta (SW-GPU) <targupta@nvidia.com>;
> Vikram Sethi <vsethi@nvidia.com>; Andy Currid <acurrid@nvidia.com>;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v1 1/1] vfio/nvgpu: Add vfio pci variant module for g=
race
> hopper device
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Wed, 19 Apr 2023 15:28:36 -0700
> <ankita@nvidia.com> wrote:
>=20
> > From: Ankit Agrawal <ankita@nvidia.com>
> >
> > NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
> > for the on-chip GPU that is the logical OS representation of the
> > internal propritary cache coherent interconnect.
> >
> > This representation has a number of limitations compared to a real PCI
> > device, in particular, it does not model the coherent GPU memory
> > aperture as a PCI config space BAR, and PCI doesn't know anything
> > about cacheable memory types.
> >
> > Provide a VFIO PCI variant driver that adapts the unique PCI
> > representation into a more standard PCI representation facing
> > userspace. The GPU memory aperture is obtained from ACPI using
> > device_property_read_u64(), according to the FW specification, and
> > exported to userspace as the VFIO_REGION that covers the first PCI
> > BAR. qemu will naturally generate a PCI device in the VM where the
> > cacheable aperture is reported in BAR1.
> >
> > Since this memory region is actually cache coherent with the CPU, the
> > VFIO variant driver will mmap it into VMA using a cacheable mapping.
> > The mapping is done using remap_pfn_range().
> >
> > This goes along with a qemu series to provides the necessary
> > implementation of the Grace Hopper Superchip firmware specification so
> > that the guest operating system can see the correct ACPI modeling for
> > the coherent GPU device.
> > https://github.com/qemu/qemu/compare/master...ankita-nv:qemu:dev-
> ankit
> > /cohmem-0330
> >
> > This patch is split from a patch series being pursued separately:
> > https://lore.kernel.org/lkml/20230405180134.16932-2-
> ankita@nvidia.com/
> >
> > Applied and tested over v6.3-rc4.
> >
> > Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> > ---
> >  MAINTAINERS                     |   6 +
> >  drivers/vfio/pci/Kconfig        |   2 +
> >  drivers/vfio/pci/Makefile       |   2 +
> >  drivers/vfio/pci/nvgpu/Kconfig  |  10 ++
> >  drivers/vfio/pci/nvgpu/Makefile |   3 +
> >  drivers/vfio/pci/nvgpu/main.c   | 255
> ++++++++++++++++++++++++++++++++
> >  6 files changed, 278 insertions(+)
> >  create mode 100644 drivers/vfio/pci/nvgpu/Kconfig  create mode 100644
> > drivers/vfio/pci/nvgpu/Makefile  create mode 100644
> > drivers/vfio/pci/nvgpu/main.c
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS index
> > 1dc8bd26b6cf..6b48756c30d3 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -21954,6 +21954,12 @@ L:   kvm@vger.kernel.org
> >  S:   Maintained
> >  F:   drivers/vfio/pci/mlx5/
> >
> > +VFIO NVIDIA PCI DRIVER
> > +M:   Ankit Agrawal <ankita@nvidia.com>
> > +L:   kvm@vger.kernel.org
> > +S:   Maintained
> > +F:   drivers/vfio/pci/nvgpu/
> > +
> >  VGA_SWITCHEROO
> >  R:   Lukas Wunner <lukas@wunner.de>
> >  S:   Maintained
> > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig index
> > f9d0c908e738..ade18b0ffb7b 100644
> > --- a/drivers/vfio/pci/Kconfig
> > +++ b/drivers/vfio/pci/Kconfig
> > @@ -59,4 +59,6 @@ source "drivers/vfio/pci/mlx5/Kconfig"
> >
> >  source "drivers/vfio/pci/hisilicon/Kconfig"
> >
> > +source "drivers/vfio/pci/nvgpu/Kconfig"
> > +
> >  endif
> > diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> > index 24c524224da5..0c93d452d0da 100644
> > --- a/drivers/vfio/pci/Makefile
> > +++ b/drivers/vfio/pci/Makefile
> > @@ -11,3 +11,5 @@ obj-$(CONFIG_VFIO_PCI) +=3D vfio-pci.o
> >  obj-$(CONFIG_MLX5_VFIO_PCI)           +=3D mlx5/
> >
> >  obj-$(CONFIG_HISI_ACC_VFIO_PCI) +=3D hisilicon/
> > +
> > +obj-$(CONFIG_NVGPU_VFIO_PCI) +=3D nvgpu/
> > diff --git a/drivers/vfio/pci/nvgpu/Kconfig
> > b/drivers/vfio/pci/nvgpu/Kconfig new file mode 100644 index
> > 000000000000..066f764f7c5f
> > --- /dev/null
> > +++ b/drivers/vfio/pci/nvgpu/Kconfig
> > @@ -0,0 +1,10 @@
> > +# SPDX-License-Identifier: GPL-2.0-only config NVGPU_VFIO_PCI
> > +     tristate "VFIO support for the GPU in the NVIDIA Grace Hopper
> Superchip"
> > +     depends on ARM64 || (COMPILE_TEST && 64BIT)
> > +     select VFIO_PCI_CORE
> > +     help
> > +       VFIO support for the GPU in the NVIDIA Grace Hopper Superchip i=
s
> > +       required to assign the GPU device to a VM using KVM/qemu/etc.
> > +
> > +       If you don't know what to do here, say N.
> > diff --git a/drivers/vfio/pci/nvgpu/Makefile
> > b/drivers/vfio/pci/nvgpu/Makefile new file mode 100644 index
> > 000000000000..00fd3a078218
> > --- /dev/null
> > +++ b/drivers/vfio/pci/nvgpu/Makefile
> > @@ -0,0 +1,3 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +obj-$(CONFIG_NVGPU_VFIO_PCI) +=3D nvgpu-vfio-pci.o nvgpu-vfio-pci-y :=
=3D
> > +main.o
> > diff --git a/drivers/vfio/pci/nvgpu/main.c
> > b/drivers/vfio/pci/nvgpu/main.c new file mode 100644 index
> > 000000000000..9e08e8cf4606
> > --- /dev/null
> > +++ b/drivers/vfio/pci/nvgpu/main.c
> > @@ -0,0 +1,255 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights
> > +reserved  */
> > +
> > +#include <linux/pci.h>
> > +#include <linux/vfio_pci_core.h>
> > +
> > +#define DUMMY_PFN \
> > +     (((nvdev->mem_prop.hpa + nvdev->mem_prop.mem_length) >>
> > +PAGE_SHIFT) - 1)
> > +
> > +struct dev_mem_properties {
> > +     uint64_t hpa;
> > +     uint64_t mem_length;
> > +     int bar1_start_offset;
> > +};
> > +
> > +struct nvgpu_vfio_pci_core_device {
> > +     struct vfio_pci_core_device core_device;
> > +     struct dev_mem_properties mem_prop; };
> > +
> > +static int vfio_get_bar1_start_offset(struct vfio_pci_core_device
> > +*vdev) {
> > +     u8 val =3D 0;
> > +
> > +     pci_read_config_byte(vdev->pdev, 0x10, &val);
> > +     /*
> > +      * The BAR1 start offset in the PCI config space depends on the B=
AR0size.
> > +      * Check if the BAR0 is 64b and return the approproiate BAR1 offs=
et.
> > +      */
> > +     if (val & PCI_BASE_ADDRESS_MEM_TYPE_64)
> > +             return VFIO_PCI_BAR2_REGION_INDEX;
> > +
> > +     return VFIO_PCI_BAR1_REGION_INDEX; }
>=20
> This is really confusing offsets vs indexes, it's clearly returning a reg=
ion index,
> not offset.  Also we already have resources setup for BAR0, so rather tha=
n
> working on the raw BAR value, how about:
>=20
>         return pci_resource_flags(vdev->pdev, 0) & IORESOURCE_MEM_64 ?
>                         VFIO_PCI_BAR2_REGION_INDEX :
> VFIO_PCI_BAR1_REGION_INDEX;
>=20
> OTOH, why are we trying to pack the BARs, couldn't we always put it at BA=
R2?
>=20

Right, it should have said region index. And yes, I think we can put it at =
index 2.

> > +
> > +static int nvgpu_vfio_pci_open_device(struct vfio_device *core_vdev)
> > +{
> > +     struct nvgpu_vfio_pci_core_device *nvdev =3D container_of(
> > +             core_vdev, struct nvgpu_vfio_pci_core_device, core_device=
.vdev);
> > +     struct vfio_pci_core_device *vdev =3D
> > +             container_of(core_vdev, struct vfio_pci_core_device, vdev=
);
> > +     int ret;
> > +
> > +     ret =3D vfio_pci_core_enable(vdev);
> > +     if (ret)
> > +             return ret;
> > +
> > +     vfio_pci_core_finish_enable(vdev);
> > +
> > +     nvdev->mem_prop.bar1_start_offset =3D
> > + vfio_get_bar1_start_offset(vdev);
> > +
> > +     return ret;
> > +}
> > +
> > +static int nvgpu_vfio_pci_mmap(struct vfio_device *core_vdev,
> > +                     struct vm_area_struct *vma) {
> > +     struct nvgpu_vfio_pci_core_device *nvdev =3D container_of(
> > +             core_vdev, struct nvgpu_vfio_pci_core_device,
> > +core_device.vdev);
> > +
> > +     unsigned long start_pfn;
> > +     unsigned int index;
> > +     u64 req_len, pgoff;
> > +     int ret =3D 0;
> > +
> > +     index =3D vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> > +     if (index !=3D nvdev->mem_prop.bar1_start_offset)
>=20
> offset vs index...=20

Ack, will name the variable appropriately at this and other places.

>=20
> > +             return vfio_pci_core_mmap(core_vdev, vma);
> > +
> > +     /*
> > +      * Request to mmap the BAR1. Map to the CPU accessible memory on
> > + the
>=20
> But it might be BAR2...
>=20
> > +      * GPU using the memory information gathered from the system ACPI
> > +      * tables.
> > +      */
> > +     start_pfn =3D nvdev->mem_prop.hpa >> PAGE_SHIFT;
> > +     req_len =3D vma->vm_end - vma->vm_start;
> > +     pgoff =3D vma->vm_pgoff &
> > +             ((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> > +     if (pgoff >=3D (nvdev->mem_prop.mem_length >> PAGE_SHIFT))
> > +             return -EINVAL;
> > +
> > +     /*
> > +      * Perform a PFN map to the memory. The device BAR1 is backed by =
the
> > +      * GPU memory now. Check that the mapping does not overflow out o=
f
> > +      * the GPU memory size.
> > +      */
> > +     ret =3D remap_pfn_range(vma, vma->vm_start, start_pfn + pgoff,
> > +                           min(req_len, nvdev->mem_prop.mem_length - p=
goff),
> > +                           vma->vm_page_prot);
>=20
> What's the behavior of this "BAR" relative to things like
> PCI_COMMAND_MEMORY or reset?  If the user generates a secondary bus
> reset on the parent bridge in one thread, while accessing the device in a=
nother
> thread, isn't that susceptible to platform error handling just like any o=
ther PCI
> device?  This is why vfio-pci-core has all the zapping and faulting of mm=
aps to
> real BARs.
>=20
> > +     if (ret)
> > +             return ret;
> > +
> > +     vma->vm_pgoff =3D start_pfn + pgoff;
> > +
> > +     return 0;
> > +}
> > +
> > +static long nvgpu_vfio_pci_ioctl(struct vfio_device *core_vdev,
> > +                     unsigned int cmd, unsigned long arg) {
> > +     struct nvgpu_vfio_pci_core_device *nvdev =3D container_of(
> > +             core_vdev, struct nvgpu_vfio_pci_core_device,
> > +core_device.vdev);
> > +
> > +     unsigned long minsz =3D offsetofend(struct vfio_region_info, offs=
et);
> > +     struct vfio_region_info info;
> > +
> > +     switch (cmd) {
> > +     case VFIO_DEVICE_GET_REGION_INFO:
> > +             if (copy_from_user(&info, (void __user *)arg, minsz))
> > +                     return -EFAULT;
> > +
> > +             if (info.argsz < minsz)
> > +                     return -EINVAL;
> > +
> > +             if (info.index =3D=3D nvdev->mem_prop.bar1_start_offset) =
{
>=20
> index vs offset...
>=20
> > +                     /*
> > +                      * Request to determine the BAR1 region informati=
on. Send the
> > +                      * GPU memory information.
> > +                      */
> > +                     info.offset =3D VFIO_PCI_INDEX_TO_OFFSET(info.ind=
ex);
> > +                     info.size =3D nvdev->mem_prop.mem_length;
> > +                     info.flags =3D VFIO_REGION_INFO_FLAG_READ |
> > +                                  VFIO_REGION_INFO_FLAG_WRITE |
> > +                                  VFIO_REGION_INFO_FLAG_MMAP;
> > +                     return copy_to_user((void __user *)arg, &info, mi=
nsz) ?
> > +                                    -EFAULT : 0;
> > +             }
> > +
> > +             if (info.index =3D=3D nvdev->mem_prop.bar1_start_offset +=
 1) {
> > +                     /*
> > +                      * The BAR1 region is 64b. Ignore this access.
> > +                      */
> > +                     info.offset =3D VFIO_PCI_INDEX_TO_OFFSET(info.ind=
ex);
> > +                     info.size =3D 0;
> > +                     info.flags =3D 0;
> > +                     return copy_to_user((void __user *)arg, &info, mi=
nsz) ?
> > +                             -EFAULT : 0;
> > +             }
>=20
> Not sure why the core code doesn't handle BAR+1
>=20
> > +
> > +             return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> > +
> > +     default:
> > +             return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> > +     }
>=20
> This might work better as simply:
>=20
>         if (cmd =3D=3D VFIO_DEVICE_GET_REGION_INFO) {
>                 /* virtual BAR returns... */
>         }
>=20
>         return vfio_pci_core_ioctl(...);
>=20
> It at least avoids the duplication.
>=20

Right, that looks better.

> > +}
> > +
> > +static const struct vfio_device_ops nvgpu_vfio_pci_ops =3D {
> > +     .name =3D "nvgpu-vfio-pci",
> > +     .init =3D vfio_pci_core_init_dev,
> > +     .release =3D vfio_pci_core_release_dev,
> > +     .open_device =3D nvgpu_vfio_pci_open_device,
> > +     .close_device =3D vfio_pci_core_close_device,
> > +     .ioctl =3D nvgpu_vfio_pci_ioctl,
> > +     .read =3D vfio_pci_core_read,
> > +     .write =3D vfio_pci_core_write,
> > +     .mmap =3D nvgpu_vfio_pci_mmap,
> > +     .request =3D vfio_pci_core_request,
> > +     .match =3D vfio_pci_core_match,
> > +     .bind_iommufd =3D vfio_iommufd_physical_bind,
> > +     .unbind_iommufd =3D vfio_iommufd_physical_unbind,
> > +     .attach_ioas =3D vfio_iommufd_physical_attach_ioas,
> > +};
> > +
> > +static struct nvgpu_vfio_pci_core_device *nvgpu_drvdata(struct
> > +pci_dev *pdev) {
> > +     struct vfio_pci_core_device *core_device =3D
> > +dev_get_drvdata(&pdev->dev);
> > +
> > +     return container_of(core_device, struct nvgpu_vfio_pci_core_devic=
e,
> > +                         core_device); }
> > +
> > +static int
> > +nvgpu_vfio_pci_fetch_memory_property(struct pci_dev *pdev,
> > +                                  struct nvgpu_vfio_pci_core_device
> > +*nvdev) {
> > +     int ret =3D 0;
>=20
> Unnecessary initialization.  Thanks

Ack, will fix in the next version.

>=20
> Alex
>=20
> > +
> > +     /*
> > +      * The memory information is present in the system ACPI tables as=
 DSD
> > +      * properties nvidia,gpu-mem-base-pa and nvidia,gpu-mem-size.
> > +      */
> > +     ret =3D device_property_read_u64(&(pdev->dev), "nvidia,gpu-mem-ba=
se-
> pa",
> > +                                    &(nvdev->mem_prop.hpa));
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret =3D device_property_read_u64(&(pdev->dev), "nvidia,gpu-mem-si=
ze",
> > +                                    &(nvdev->mem_prop.mem_length));
> > +     return ret;
> > +}
> > +
> > +static int nvgpu_vfio_pci_probe(struct pci_dev *pdev,
> > +                             const struct pci_device_id *id) {
> > +     struct nvgpu_vfio_pci_core_device *nvdev;
> > +     int ret;
> > +
> > +     nvdev =3D vfio_alloc_device(nvgpu_vfio_pci_core_device,
> core_device.vdev,
> > +                               &pdev->dev, &nvgpu_vfio_pci_ops);
> > +     if (IS_ERR(nvdev))
> > +             return PTR_ERR(nvdev);
> > +
> > +     dev_set_drvdata(&pdev->dev, nvdev);
> > +
> > +     ret =3D nvgpu_vfio_pci_fetch_memory_property(pdev, nvdev);
> > +     if (ret)
> > +             goto out_put_vdev;
> > +
> > +     ret =3D vfio_pci_core_register_device(&nvdev->core_device);
> > +     if (ret)
> > +             goto out_put_vdev;
> > +
> > +     return ret;
> > +
> > +out_put_vdev:
> > +     vfio_put_device(&nvdev->core_device.vdev);
> > +     return ret;
> > +}
> > +
> > +static void nvgpu_vfio_pci_remove(struct pci_dev *pdev) {
> > +     struct nvgpu_vfio_pci_core_device *nvdev =3D nvgpu_drvdata(pdev);
> > +     struct vfio_pci_core_device *vdev =3D &nvdev->core_device;
> > +
> > +     vfio_pci_core_unregister_device(vdev);
> > +     vfio_put_device(&vdev->vdev);
> > +}
> > +
> > +static const struct pci_device_id nvgpu_vfio_pci_table[] =3D {
> > +     { PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA,
> 0x2342) },
> > +     { PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA,
> 0x2343) },
> > +     { PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA,
> 0x2345) },
> > +     {}
> > +};
> > +
> > +MODULE_DEVICE_TABLE(pci, nvgpu_vfio_pci_table);
> > +
> > +static struct pci_driver nvgpu_vfio_pci_driver =3D {
> > +     .name =3D KBUILD_MODNAME,
> > +     .id_table =3D nvgpu_vfio_pci_table,
> > +     .probe =3D nvgpu_vfio_pci_probe,
> > +     .remove =3D nvgpu_vfio_pci_remove,
> > +     .err_handler =3D &vfio_pci_core_err_handlers,
> > +     .driver_managed_dma =3D true,
> > +};
> > +
> > +module_pci_driver(nvgpu_vfio_pci_driver);
> > +
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
> > +MODULE_AUTHOR("Aniket Agashe <aniketa@nvidia.com>");
> > +MODULE_DESCRIPTION(
> > +     "VFIO NVGPU PF - User Level driver for NVIDIA devices with CPU
> coherently accessible device memory");

