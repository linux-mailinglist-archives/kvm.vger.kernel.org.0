Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839155A4206
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 06:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiH2Eta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 00:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiH2Et2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 00:49:28 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3644142AF5;
        Sun, 28 Aug 2022 21:49:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLLZg3Q8GIUlyzpDCwBx7qZgOtkqcqy9qUHwd7E1T9Cp79FE0HjHnvwAxZbQJNg7FW2JS3uI19BDYZT/XdkrQYfquTn5qyCd8q8yaT7gfa2zv8EfOimtBa1gHX2BO8j31HEzVQQNt19KmUmifUmlZSX+SXKbHPp94BdN6o1i3yFzBxfxSxY4/xMEsgXAOLrt7eKDreQPVuRO2L27jnRnXLv70Mcj0yawQ8xOazv1gEowVV8Aa+TfCoSApGCVxoCQBcVlt8T7M5f8hPUlomWZNhIzn96snofro1mNLvkTN68GcKFiH+Jl9GvPidITjV/zeq4Giq38fvOYveDzhsfEbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATS5cyDuCURjN2UwYtZ60AD6HueY6fEt2Y9LTSEdJI0=;
 b=BX2jyALe7OECcVVe4OGu7MytnMdEh+B9AHlOluzhygta6jy1y+UCbHvNp0QIgtXOi6F8V2JlPaQv6QhggwLK8Th7aB+hxbPBuVoM7Us7SKyKDr8Vvak02fL9x7gETv+AxoOXBGpQIYGVc5FnOYjMNPKV7Xcy1KQnvUr94BIlap3lu6CkWChoQGlZelF2UNX4wcCjx/zjDViQoHJ+ZnZNA8Yo5qb7Sq4Cctwlodu979xCSacy5TKo3Qracu/VN3r9RQfq5IuyITzqKadF4AB3Q+Fs9JEcblqzmETJMjiz8p7e1GNvxU77yz30pr0DDOyGQyIIziZCxgYhysSthYxQIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATS5cyDuCURjN2UwYtZ60AD6HueY6fEt2Y9LTSEdJI0=;
 b=b1vb+NzpP/TVXu6LSErGSjp8Hhumzc2y8DAu0vPHXMTjtAWLREeIR0YCwH10wYf6N4ax2BQUQrLAg0tbhvcFW188jQiwlvZvm9SMgK3u27VHR5IeWUWQxtDJKDX0Hc4oFPphmpalmWVkNOlO4DyG4JYt2612QsU5SeiMEmTqsHg=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by DM6PR12MB5567.namprd12.prod.outlook.com (2603:10b6:5:1ba::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 04:49:22 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74%3]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 04:49:22 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
CC:     Saravana Kannan <saravanak@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
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
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
Thread-Topic: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
Thread-Index: AQHYskryPWbD9sL0uUGy0CZ+78RqoK2zOJuAgAeq3xCAAA5ggIACkHJAgAB+fACAAL3fAIABQH2AgAAWLYCAAEX8AIAAemdA
Date:   Mon, 29 Aug 2022 04:49:21 +0000
Message-ID: <DM6PR12MB3082BFC7C6D26A29B1440946E8769@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220817150542.483291-1-nipun.gupta@amd.com>
 <20220817150542.483291-3-nipun.gupta@amd.com> <Yv0KHROjESUI59Pd@kroah.com>
 <DM6PR12MB3082D966CFC0FA1C2148D8FAE8719@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwOEv6107RfU5p+H@kroah.com>
 <DM6PR12MB3082B4BDD39632264E7532B8E8739@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwYVhJCSAuYcgj1/@kroah.com> <20220824233122.GA4068@nvidia.com>
 <CAGETcx846Pomh_DUToncbaOivHMhHrdt-MTVYqkfLUKvM8b=6w@mail.gmail.com>
 <a6ca5a5a-8424-c953-6f76-c9212db88485@arm.com> <YwgO8oCNn/QFM76V@nvidia.com>
In-Reply-To: <YwgO8oCNn/QFM76V@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-29T04:51:13Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=4a08066b-00b3-4d62-9578-ac4e04788c0c;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e8b8e6d-4816-4f36-6da2-08da8979d727
x-ms-traffictypediagnostic: DM6PR12MB5567:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: clp13wkEwwON+T3cwS3VOKeJIYYDeXL3wB3cw28+twmpTfqLfYnxzaTUfFOIwohZG7mKJF6KOndmE4F1UtqsMP9VMShoB2MLn2E+PweANDw8NaBdSICC3r3Z8moUBpsbWAjTc9eXfEc83SaO88rqqq1oQO+UtEqnetY+k1PVITTZP1glxJZkhU8ZOdseKeEze5LOnN5shYYprrJbGnk2Dgn3v9tGo6wcjjpVJ2bn3sfspdOjwt8aix51k9j/2s2r0SWfuYkj16AzPEBgkrUL2L9bo1fd6dxVlO49R3Q3/gZYEY+BaemxtqiCJHwxh8qLaLhm43ImraRuJz8IhIeNcejuLUVCFJnov3gJ2iTYTSQB+x5thFSiZXpAh+xOo6w6LKGEw+CAaRXgkQRFRvUFwYfeA0y6OOqmxilg2ojBM9x9g66K/CM5EpwPO4nEBcSSbj3Pu/MI0rOKDzScB5M3TlDqEE8LPOjPfDH8JQjnFOCjKQ4SWspyc9GHMbEwKiVSZn2aauS05u3d6rRInWz/p1+OZrvN2RCYVNNZ0Ms8nxkZQs8gqCBFR7i04Hzmf1RIQSoTMZlWRSLfVQ1qy2KQe0cG/2Iuh1GAhkH5M9f4CdpzN6zivjieFdVxmpGs7CFT+lZAkF3j9QnOMETJ+4JTAXkyEDiT/YFdF4u1GaXaoypO19rRR0mGWLeizO5IBOkaeMNKNBgrK54qDj7OnX7i7QqByibxnsB4mSE7+P5arWJpX8/QhX1DxYU569nSl7aENDUZXUCcouF5SngXOwfTKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(346002)(136003)(366004)(38070700005)(4326008)(76116006)(66946007)(66556008)(66446008)(64756008)(8676002)(122000001)(38100700002)(86362001)(33656002)(83380400001)(186003)(478600001)(55236004)(53546011)(26005)(6506007)(7696005)(41300700001)(71200400001)(9686003)(110136005)(316002)(54906003)(55016003)(2906002)(66476007)(7416002)(5660300002)(8936002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OkVs8K7psoANwjw5KQ+6Pu/vfo7tHPIvT5niP0HHSj3QxCWZe/EGZsoXzaLP?=
 =?us-ascii?Q?dhf3FABpbzq1nhsXlOFYZcmYSp3diV1zYIhAcv5GZSt0ZqgGVl9b1GNjGo71?=
 =?us-ascii?Q?fh9tfgoZSW+zgPnPanqFKSztJ8fKf69rW9xx76bCVj33OOfh9EWAAbVCJl2S?=
 =?us-ascii?Q?Y8PH9tQhrzy6V05bo4SdOWM5dcyBQQ8FKT/ygzUE72I/uCiZomaGvcv26ZFV?=
 =?us-ascii?Q?MLcqEMzowK+XW5E1QzfeKvDdhcz5f6cPBtf29gaD+4OE7oRky42/9fl5rKiQ?=
 =?us-ascii?Q?Vfu6lUWWhj0ZMKtO4ga/t5BJuf3UqZsaQp9mzZF93zpb9yGwdqS1qQpE4UfA?=
 =?us-ascii?Q?PcUmCNwue7QUIrPJwIisAzkhFMNM0ym8qHGwMqb5no4WNPJkPa0HuKUzhSIu?=
 =?us-ascii?Q?Z4B9RUc6FHqeTXJJXLoSzA7Sqr09Uqzl9qJ2SS5x4A9GMO9kCXrSQH7+Tsq9?=
 =?us-ascii?Q?emOWHcXF0olwl9jsZrdBGCxH03yRniAgCXTqztmI82yWXdb8D04WQftqYjVw?=
 =?us-ascii?Q?b4yYA6dzp0vFoQ9+jlC100EN/USfalaorSdOjZl9BJ3JakX/w0xLJZvOPeji?=
 =?us-ascii?Q?RA893/YaBoPxgmSb0jHEL8g90tp3Oyxn2CkvayEbEiY+dNuHEycbxs8RyNGP?=
 =?us-ascii?Q?MfXjRP18zJd8EFkrblGZ96y/Tp0h2I2jgGGbka+zZ6A3puoFlcWAc+PeFewe?=
 =?us-ascii?Q?iVfb+6KjIgLjaZzN6co8DZOTBKpTq8nz3eG5CDYgZPT8StJjChkoJ+S1QVBo?=
 =?us-ascii?Q?PBBkajQhrHUzcjWbilFDiVuMsEsB9w+XHBreIWPf2tV49Qbp3K3IxR3R8fFH?=
 =?us-ascii?Q?3Vdw1vw+lUAAePcRVSy+KcjdmlBe1lOI2HwaMFKpmS11AOnpxft3SHs+MlnM?=
 =?us-ascii?Q?z2YSNY5aG8LsGO/9qW9m0upPxXpVSjKTJMOzhFU7EvphZxoQzQd59x2lxkc3?=
 =?us-ascii?Q?zBrn87Edi9TmYx4O2JjMyjY89dzt/8AcF2FPRca6WOvWaamHn+LAAs56bt6O?=
 =?us-ascii?Q?p/uqyphC6L5OyJFSJeiSCfBAkv+kSH/Tbiqiu9RMqb7K3wMT9WkLhz/y3Bxg?=
 =?us-ascii?Q?W9w4a7ZYNikBOw9J2GEAONO81Wx8G28aCy41Gdxv4hdWUdDI7d3FUV28S2V6?=
 =?us-ascii?Q?tB/npo01lqeY3V04Ei3B4GnI11IrGnB/qBwZuGNEsw8PxwaRNlwaVM0ltcxv?=
 =?us-ascii?Q?8H/X//8YMMJyAdmvranRc+LrD68NsE+mO7DNEKZMRINzegNDFfd6uTS4G39x?=
 =?us-ascii?Q?In9FfJoJXVSoiuc5oqx2YIkrwvG86YMd14Ewj+W5rM3W3wVDZi7SKr7dhebZ?=
 =?us-ascii?Q?74KPXpxKcw4i/f6ViRr3zlxaclmJ7dqqLakjT/ar05v3io1ymeDSJ9InYyvf?=
 =?us-ascii?Q?kyl7rVVt0v9pqeSEVh1v7S1hHXeJHO6d/qX5GjUxG5hYbtDEdXBJSNRcBzyP?=
 =?us-ascii?Q?be5dOCt3sbGa3vnSqfEFE4tty1eNBbmyW5aUIxDzkWC8/z3/1w+oOA6jfuja?=
 =?us-ascii?Q?WJmZqTeaLqPL6h0LachOo+RjEwDg5zBYmTp2BpkogyYwDtUVrArYpiCst1bQ?=
 =?us-ascii?Q?ffPEfg8f1UGmvz23OGo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e8b8e6d-4816-4f36-6da2-08da8979d727
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 04:49:21.9455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WTU6xdEwFUOggk5vW1K/tNY016LDyYdOtIFeiVVxRkQfthCKT9ZPqvFCV8DmlkAB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5567
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]



> -----Original Message-----
> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, August 26, 2022 5:38 AM
> To: Robin Murphy <robin.murphy@arm.com>
> Cc: Saravana Kannan <saravanak@google.com>; Greg KH
> <gregkh@linuxfoundation.org>; Gupta, Nipun <Nipun.Gupta@amd.com>;
> robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org; rafael@kernel.org;
> eric.auger@redhat.com; alex.williamson@redhat.com; cohuck@redhat.com;
> Gupta, Puneet (DCG-ENG) <puneet.gupta@amd.com>;
> song.bao.hua@hisilicon.com; mchehab+huawei@kernel.org; maz@kernel.org;
> f.fainelli@gmail.com; jeffrey.l.hugo@gmail.com; Michael.Srba@seznam.cz;
> mani@kernel.org; yishaih@nvidia.com; linux-kernel@vger.kernel.org;
> devicetree@vger.kernel.org; kvm@vger.kernel.org; okaya@kernel.org; Anand,
> Harpreet <harpreet.anand@amd.com>; Agarwal, Nikhil
> <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>; git
> (AMD-Xilinx) <git@amd.com>
> Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
>=20
> [CAUTION: External Email]
>=20
> On Thu, Aug 25, 2022 at 08:57:49PM +0100, Robin Murphy wrote:
>=20
> > To my mind, it would definitely help to understand if this is a *real*
> > discoverable bus in hardware, i.e. does one have to configure one's dev=
ice
> > with some sort of CDX wrapper at FPGA synthesis time, that then physica=
lly
> > communicates with some sort of CDX controller to identify itself once
> > loaded; or is it "discoverable" in the sense that there's some firmware=
 on
> > an MCU controlling what gets loaded into the FPGA, and software can que=
ry
> > that and get back whatever precompiled DTB fragment came bundled with t=
he
> > bitstream, i.e. it's really more like fpga-mgr in a fancy hat?
>=20
> So much of the IP that you might want to put in a FPGA needs DT, I
> don't thing a simplistic AMBA like discoverable thing would be that
> interesting.
>=20
> Think about things like FPGA GPIOs being configured as SPI/I2C, then
> describing the board config of SPI/I2C busses, setting up PCI bridges,
> flash storage controllers and all sorts of other typically embedded
> stuff that really relies on DT these days.
>=20
> It would be nice if Xilinx could explain more about what environment
> this is targetting. Is it Zynq-like stuff?

This solution is not targeted for GPIO/SPI or I2C like devices which rely o=
n
DT, but would have PCI like network/storage devices. It is not targeted for
Zynq platform. I have added more details on other mail. Please refer to
that mail.

Thanks,
Nipun

>=20
> Jason
