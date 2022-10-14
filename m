Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 694CA5FEA65
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 10:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiJNIVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 04:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiJNIUq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 04:20:46 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2047.outbound.protection.outlook.com [40.107.102.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A25EA379;
        Fri, 14 Oct 2022 01:20:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Daqhz2OlHLu8jF8bIE7MuzHVaOmymIScQYiy6Heqw1B+XGSbqkKx5YpqnNF9Yc28o/WXkF5NDz0LL5iWUxHD9B4SOOdp0LCXiNO/XfajK1lYdmRa/+Qgx2Pq3ahHl7nYi1G2EZ6U5NAY/+5Amda4qOMqppFf9EKkDXBqMEC/bODqHLJMjjFqxwXyOLl91VgU+wbM1AlhjDPuTn/FPJF9vnVufEZBwBAwrWebY5T06wVXqpAVCy78SPRuX5Ofk4G9HBGZES6qxPe+Fl0tBNZSBfMbeGEZ2E3EPFRaDwtmDaOTOQV2x0/aaxkY/5WhyOmWb0SsTSU9s1ps8aHXJuwz3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JPEqc9DT78ziYepuGVpF4+esdMaTRHukCB1CaXWibjg=;
 b=Lx+CxTO6hyaxqoCGWHVWafhHPFxO5BPlu17sZFVct1w/8caIo6NqmLUC3MR5aeBJ6RVjo6lqmNFciT49WfBsV1SkGCgdmxS4BFrs3pKzUVVAIBPxYR71TnQS0kPnvqi4rnGzlx1YCw3l1C4fl8ROKofFnqXBFiylvtIk55nsbSyE/wx9KjmVt2Kijt4oLLvfwkfbDL07t9aOY/xHN1ILljFGgEUGHBRKhy6OVR5BN5hTPLoNs0k85hu0r+31TPbTBUcwNUHJD0fF6RBqeyY0b52tSZY4x51z4jRngGPjK5gSDzgVxDnfefMHBqBG6xKxFdtGoUh6X/CYx2qGDw6shQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPEqc9DT78ziYepuGVpF4+esdMaTRHukCB1CaXWibjg=;
 b=pW/BGYxZPr6c92wV0mkzO6OhAr8bZpn2Huc3NWqh/KW68yX2CzvQCgrEgowS3F8DqAedLQroFD8wdMBfTQ8zFhBYtCJO/bjgrcZYukWpkt0QQEL1w4PwQxnH2b/4kwxgBxVtLaWJF99/WxI4PX6c/sS86wt5za801NI9N55I6GE=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by SA1PR12MB7128.namprd12.prod.outlook.com (2603:10b6:806:29c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.34; Fri, 14 Oct
 2022 08:20:31 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::377f:69eb:dcb:3ea8]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::377f:69eb:dcb:3ea8%6]) with mapi id 15.20.5723.026; Fri, 14 Oct 2022
 08:20:31 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "jgg@nvidia.com" <jgg@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC PATCH v4 2/8] bus/cdx: add the cdx bus driver
Thread-Topic: [RFC PATCH v4 2/8] bus/cdx: add the cdx bus driver
Thread-Index: AQHY34c9oJTijdnoe06lrbXMMQfUFq4NezcAgAAA92A=
Date:   Fri, 14 Oct 2022 08:20:31 +0000
Message-ID: <DM6PR12MB3082BB5B7E5756450BBC0DEBE8249@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20221014044049.2557085-1-nipun.gupta@amd.com>
 <20221014044049.2557085-3-nipun.gupta@amd.com> <Y0kNPHOjKiQ3XfqI@kroah.com>
In-Reply-To: <Y0kNPHOjKiQ3XfqI@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-10-14T08:20:28Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=f67c3e1d-6eaa-4538-ac51-0a25775f45d5;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3082:EE_|SA1PR12MB7128:EE_
x-ms-office365-filtering-correlation-id: 23e9ee0c-3e99-42ac-08e4-08daadbcf5ba
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6apLarf/ZXOqNw4qHrK+6UDDUXNDiLgkyxiKwGQfO0yG3p/8O7KljqURTdfXEjhgct5cs33PXcut3JfQJnscwIvjKruIN1n94gd+XCV1n0shE/wPia4DY6RjO6uKPhHUAMf9mXowoBLCnroA08NBmmsVVmsda1pYDkgR0ZERAhTUzVSlWXvLABSjZ7CrtQD3i1JC+kH+yJsOxfbuLl1pkIWURap8cO8tXWDTfvKRKwZ4wXpPxE63s9L0iFFRCfRGs+dtajDzf6zki/VIVzsjMcCCPsrZbpjABP+2QgdYDdYvuEJdfJ/XUQU4gUK1bQCyApL9pNvwqPC0Q24NakuXEwn9T5HC+mGg22th8aCgNyyIdqMF5elR4ejrwzPMyBiKswy51F8OyKK0EfkK3xy3wL8xzXKYuxHkdiLxVYoBqmebrAy/6CkjqRNMdZjuGvFLl+3kqSL8FcZ5e2eAhR/ATSpv7GvKOMgroa04if2gtmW9I9OcrLCbUTrY7f0S2Itpp4P1oYNudOjvMwvCKRnrZ3Xr679q5T9HmRqBg/gbCh+YkLfHpX57/5WG9EKVy4Ie4owXeYqzLwFu/05amHE1/YL1a7mC8FE3mkw8g/Em7gxd2OHnQ5tRm/G/bABYeW+snsrIl6qHXyiTuhiwR8TR6E4rOaF/fgdIF2/+6pGtmKoiSg+GtSqlViaPQuUSA094SmWMObA+Dd0bat7wbL5jwUOWgiX7z44zhtnOkIHBvczKdxP/6lYdHgDQP62UNkAOaXqonKbaGJGnBgWcQqvNPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199015)(7406005)(52536014)(8936002)(5660300002)(7416002)(41300700001)(8676002)(53546011)(66476007)(9686003)(66556008)(76116006)(7696005)(64756008)(4326008)(66446008)(33656002)(2906002)(122000001)(26005)(66946007)(71200400001)(86362001)(6916009)(83380400001)(38100700002)(55016003)(38070700005)(6506007)(478600001)(186003)(316002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XSRIzmo2FTwsVurnG28Tvg0bWujAeRit1xxoJFzI9VvoJenJpzYc/R5ngftC?=
 =?us-ascii?Q?yTCFcU5KwE2GKu+hkFtCilcWNcBBA6YiTe5mETHIvNdGwSq8Enki4l/w1v9V?=
 =?us-ascii?Q?xZpupQw0YkyzKo6vYG3AZhQXNPaY0JHhE7cJ2osT+zDk2W/X0AxkbT0F0e5y?=
 =?us-ascii?Q?mqsWF9/cUGLUUApTXYTN6/RKNUqSAxn4rmA5AD1UVU4UMHghdnw4ZQje4Ftz?=
 =?us-ascii?Q?KdPt77LDKCz4J/EJg8TBsTgfQwST3LNbnwGNMC5hpNqfO6nGAO7XiSh/VnbP?=
 =?us-ascii?Q?ZhMPc1uLtkKbX4RDk1gSGbuhlAKfzvr3erkV9b7Fju4ZhfYO0PRfvLZOoJSi?=
 =?us-ascii?Q?wiTud9tlhPhYW56he6SU25evfRhLMfd/QbDMq9twleQUD1mhLb7P+xsgqzwB?=
 =?us-ascii?Q?SAr/WawOUGjrLzs0I3DDXwiT6q3ZTPEiWLn5XlXtIveUekxVeQ9IRAUXeMAv?=
 =?us-ascii?Q?LMarQQ2oj9PnKgaL2SOJmdEHOuZwScmLs6oI1R1ptF8YSkyPTIPbaoCzw8Ei?=
 =?us-ascii?Q?iIFDb6BSCGVwRvB57iSa5tfa8ZbOIrJk7X05SHEaA3crsObb7YPdO8Mqj+sX?=
 =?us-ascii?Q?8TSanTlUq50MxD2NTK2DNGwEhpo4uiPRs8e5wPQzs52ziNeW0+TlCoKSllpZ?=
 =?us-ascii?Q?g/R1Hk/+iFEeNJeef2Ijatdh1Fmt1GtQss4St9Tnz1cQGC6YhHLxfch7WWH7?=
 =?us-ascii?Q?Rjme0N/XR2c8M6yeiG6iwbN3joaTubw+kKYJw4QbFJa1NpUO5MzOBjVgXdRw?=
 =?us-ascii?Q?6rQef8fatlfP75sh3Nx9qOdpRYyjLYax2I3Pc33AiFF1ZFn3+9+2OFfYahUw?=
 =?us-ascii?Q?PmdGFr8E8izqa29DgWQ/iy2ehJ270YmeYaIQ7kgh3elZD9bRh+W9wC/wZJlt?=
 =?us-ascii?Q?V5i9CE/xpm8LmNHo4FArS1IZDx6w1n+eE+Xn7H2fcf/4liPWiVGXn7jlBecN?=
 =?us-ascii?Q?C1JhvOmnQqs/1K2Kf7An9Z/rXq5Hp0V5LpnevOJQA7oxE6CrTPooFQZg1G+v?=
 =?us-ascii?Q?/TdPpZfs8Qcjr4K7YvwW91mO9QMAlHez5peQeQhvTDvmEBiWOk9HptBKMOgf?=
 =?us-ascii?Q?CzQDJHIOmbI+8MT0fl5Ycp4J44XtCnDKl2Sg1PuTC+IC4Bwak1bcJqNW/SPx?=
 =?us-ascii?Q?kGlC7+m5Cd9HifNptIG3NCu40zFUQ7D/iUB5UMtk/itZP0ZbRofiwTsnPiq4?=
 =?us-ascii?Q?pXKrOPQ83iX4Acq3DMhgpfhUV7c1P2ZNbb8isI+ytJnaAiqUyAUUsR09suW6?=
 =?us-ascii?Q?qDBg+Ft3r1PRkvllwgLaKdLTWlfgDEUVoYTp39utgBXs9kCgaDuZ7nIqq+V+?=
 =?us-ascii?Q?duN7W+l1WimmZOL0HT8XdTE1X7XnSua8VpRQGdN2z1Tt8VzUPOf9TjsdIyBE?=
 =?us-ascii?Q?zp2yAk+XdMXSjbG0gc4i+1H3AIKeeVaU/zuxdVbb3OQOkc3DybMYA18m7eKM?=
 =?us-ascii?Q?yPTcvaQOE7rv7fK9g4CupqIjybha15bkUmjvlWJxmFG+qomT3w4rWH/+wbTl?=
 =?us-ascii?Q?vLTePg/36Ev7K1zKOMEKme/TYkj3LaKg/rcEk4BNNvtBJqFzXJnQP+cRLt8S?=
 =?us-ascii?Q?vypP9UXPuTJUZIYZXp4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e9ee0c-3e99-42ac-08e4-08daadbcf5ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2022 08:20:31.3788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VeLax0/RUIYVY2l2ZnFC40FZidGZyfjF7cvYssEL8ilNlTi4SB/dzH/pKDMMfj+M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7128
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]



> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Friday, October 14, 2022 12:48 PM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>
> Cc: robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org; rafael@kernel.=
org;
> eric.auger@redhat.com; alex.williamson@redhat.com; cohuck@redhat.com;
> Gupta, Puneet (DCG-ENG) <puneet.gupta@amd.com>;
> song.bao.hua@hisilicon.com; mchehab+huawei@kernel.org; maz@kernel.org;
> f.fainelli@gmail.com; jeffrey.l.hugo@gmail.com; saravanak@google.com;
> Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
> jgg@ziepe.ca; jgg@nvidia.com; robin.murphy@arm.com; will@kernel.org;
> joro@8bytes.org; masahiroy@kernel.org; ndesaulniers@google.com; linux-arm=
-
> kernel@lists.infradead.org; linux-kbuild@vger.kernel.org; linux-
> kernel@vger.kernel.org; devicetree@vger.kernel.org; kvm@vger.kernel.org;
> okaya@kernel.org; Anand, Harpreet <harpreet.anand@amd.com>; Agarwal,
> Nikhil <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
> Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>; git (AMD-Xilinx=
)
> <git@amd.com>
> Subject: Re: [RFC PATCH v4 2/8] bus/cdx: add the cdx bus driver
>=20
> Caution: This message originated from an External Source. Use proper caut=
ion
> when opening attachments, clicking links, or responding.
>=20
>=20
> On Fri, Oct 14, 2022 at 10:10:43AM +0530, Nipun Gupta wrote:
> > --- a/drivers/bus/Makefile
> > +++ b/drivers/bus/Makefile
> > @@ -20,6 +20,9 @@ obj-$(CONFIG_INTEL_IXP4XX_EB)       +=3D intel-ixp4xx=
-
> eb.o
> >  obj-$(CONFIG_MIPS_CDMM)              +=3D mips_cdmm.o
> >  obj-$(CONFIG_MVEBU_MBUS)     +=3D mvebu-mbus.o
> >
> > +#CDX bus
>=20
> No need for a comment like this :)

Sure, will remove.

>=20
> > +obj-$(CONFIG_CDX_BUS)                +=3D cdx/
> > +
> >  # Interconnect bus driver for OMAP SoCs.
> >  obj-$(CONFIG_OMAP_INTERCONNECT)      +=3D omap_l3_smx.o omap_l3_noc.o
> >
> > diff --git a/drivers/bus/cdx/Kconfig b/drivers/bus/cdx/Kconfig
> > new file mode 100644
> > index 000000000000..98ec05ad708d
> > --- /dev/null
> > +++ b/drivers/bus/cdx/Kconfig
> > @@ -0,0 +1,13 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# CDX bus configuration
> > +#
> > +# Copyright (C) 2022, Advanced Micro Devices, Inc.
> > +#
> > +
> > +config CDX_BUS
> > +     bool "CDX Bus driver"
> > +     help
> > +             Driver to enable CDX Bus infrastructure. CDX bus uses
> > +             CDX controller and firmware to scan the FPGA based
> > +             devices.
>=20
> Why bool?  Not as a module?  That's broken.

Okay. We see that most of other busses like amba, fslmc, pci are bool only.
As we have MSI domain as part of this bus, we need to export multiple
symbols to make it work as a module.

>=20
> And "FPGA based devices" means nothing to me, please expand on what this
> all is as it is not descriptive at all.
>=20
> Also list the module name please.
>=20
>=20
>=20
> > diff --git a/drivers/bus/cdx/Makefile b/drivers/bus/cdx/Makefile
> > new file mode 100644
> > index 000000000000..2e8f42611dfc
> > --- /dev/null
> > +++ b/drivers/bus/cdx/Makefile
> > @@ -0,0 +1,8 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# Makefile for CDX
> > +#
> > +# Copyright (C) 2022, Advanced Micro Devices, Inc.
> > +#
> > +
> > +obj-$(CONFIG_CDX_BUS) +=3D cdx.o
> > diff --git a/drivers/bus/cdx/cdx.c b/drivers/bus/cdx/cdx.c
> > new file mode 100644
> > index 000000000000..5a366f4ae69c
> > --- /dev/null
> > +++ b/drivers/bus/cdx/cdx.c
> > @@ -0,0 +1,366 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * CDX bus driver.
> > + *
> > + * Copyright (C) 2022, Advanced Micro Devices, Inc.
> > + */
> > +
> > +/*
> > + * Architecture Overview
> > + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > + * CDX is a Hardware Architecture designed for AMD FPGA devices. It
> > + * consists of sophisticated mechanism for interaction between FPGA,
> > + * Firmware and the APUs (Application CPUs).
> > + *
> > + * Firmware resides on RPU (Realtime CPUs) which interacts with
> > + * the FPGA program manager and the APUs. The RPU provides memory-
> mapped
> > + * interface (RPU if) which is used to communicate with APUs.
> > + *
> > + * The diagram below shows an overview of the CDX architecture:
> > + *
> > + *          +--------------------------------------+
> > + *          |    Application CPUs (APU)            |
> > + *          |                                      |
> > + *          |                    CDX device drivers|
> > + *          |     Linux OS                |        |
> > + *          |                        CDX bus       |
> > + *          |                             |        |
> > + *          |                     CDX controller   |
> > + *          |                             |        |
> > + *          +-----------------------------|--------+
> > + *                                        | (discover, config,
> > + *                                        |  reset, rescan)
> > + *                                        |
> > + *          +------------------------| RPU if |----+
> > + *          |                             |        |
> > + *          |                             V        |
> > + *          |          Realtime CPUs (RPU)         |
> > + *          |                                      |
> > + *          +--------------------------------------+
> > + *                                |
> > + *          +---------------------|----------------+
> > + *          |  FPGA               |                |
> > + *          |      +-----------------------+       |
> > + *          |      |           |           |       |
> > + *          | +-------+    +-------+   +-------+   |
> > + *          | | dev 1 |    | dev 2 |   | dev 3 |   |
> > + *          | +-------+    +-------+   +-------+   |
> > + *          +--------------------------------------+
> > + *
> > + * The RPU firmware extracts the device information from the loaded FP=
GA
> > + * image and implements a mechanism that allows the APU drivers to
> > + * enumerate such devices (device personality and resource details) vi=
a
> > + * a dedicated communication channel. RPU mediates operations such as
> > + * discover, reset and rescan of the FPGA devices for the APU. This is
> > + * done using memory mapped interface provided by the RPU to APU.
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/kernel.h>
> > +#include <linux/slab.h>
> > +#include <linux/cdx/cdx_bus.h>
> > +
> > +#include "cdx.h"
> > +
> > +/*
> > + * Default DMA mask for devices on a CDX bus
> > + */
> > +#define CDX_DEFAULT_DMA_MASK (~0ULL)
> > +
> > +static struct cdx_controller_t *cdx_controller;
>=20
> You don't get a static device, sorry, everything must be dynamic or your
> design is broken.

We will remove this static device here.

>=20
> And remove the crazy "_t" from your structure name, checkpatch should
> have complained about that.

Sure. Will remove from other places too.

>=20
>=20
>=20
> > +
> > +static int reset_cdx_device(struct device *dev, void * __always_unused=
 data)
>=20
> __always_unused is never needed.
>=20
> But the funny thing is, you added that variable, why are you not using
> it?  If it's not used, then don't have it.

The 'data' parameter is here because the same reset_cdx_device() API is lat=
er used in
device attributes patch where it is passed as an argument to bus_for_each_d=
ev API,
which needs the function to have these two arguments. Agree, that this para=
meter
should be added as part of the device attribute patch, will be updated for =
next spin.

Thanks,
Nipun

>=20
> Try to get others at AMD to review your code first, before sending your
> next batch out, this is really really odd...
>=20
> greg k-h
