Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F383959F5B8
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 10:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbiHXIuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 04:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236159AbiHXIuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 04:50:24 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24C912D38;
        Wed, 24 Aug 2022 01:50:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z03srZGZJ432auZvjTUzoe1YjlJNp4p0LeAks4nCt3vOk76vIgL0QzlKeBoyrYUncxUgXPdAYJMD0xVlgXfKsJcBuU6gpaAy8V9++jZr/UqTTaSkJMg9YFTRoYiLQ5N9UXNSBcesZGqgBdEgDjtAnJuZKmkfoMNIQUdqMgYkYysmy+rLUzml6LMXqMRiSZGJU4ggPXfM3jFsnfjLCbynMsO9COG/mrTO+37Y+Fkdf7ud8WoCq4WojydOElY9pe/rIKStUKime5hSnJ+vPonT2eBu/0pereGx6ReZipzUVBXabs85JD+nqkLTvf6fkABF//aQBslPScAHVl4gV4X+dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7AvFz3ZUn6KHlOGYxl++qjd+HFpGsuYlwNqDYLn0DQ4=;
 b=ikRJr0ck3permSOUCoXayNEGwhFRvM91XLORAwOdcQNs+jts42aqcm/NGdLtFc3j18edrpe12pcDVaF1u5I2nEnFURLAVIbXZpSZYIexbfQBk8Duv7wyeZAV9YkI0X4lSBwbIFGW/WD4n/VYAR0EX8A2XINN1yCGSMK6fGRNOL4hMffL+YQ9h8X68djLR5PiP147UL/iGAw9oMNC8fk+MdWv1J5w9yBQ/YMoaUbZ1XpfLBGcuANfm7dBOKgI4fcCeV8lNlCK3rxs81qQM6M/Vqqfqrtdr6KQCr0nCeMU62wg9kRq/8+3wmakv9qWMUWXl+knowzAbDjwwJw0g1MqxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7AvFz3ZUn6KHlOGYxl++qjd+HFpGsuYlwNqDYLn0DQ4=;
 b=tqVszvACVKwn0NMYIKkKr1W7wgXokDKkPspovCF4nb//Z5/bq37Uf9tPs6dvUeVyUtBw4BMRli3sBEy53u4jc/FKfcPp5ue2ITgBJ+9N9btIGHboOQ0BU01N4ZGMgawynnHS2lk+RXD24IGBOj3yE7be9NKJOQVahQDjP2bMVZw=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by DM6PR12MB3801.namprd12.prod.outlook.com (2603:10b6:5:1cc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.20; Wed, 24 Aug
 2022 08:50:20 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74%3]) with mapi id 15.20.5566.014; Wed, 24 Aug 2022
 08:50:19 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
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
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
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
Thread-Index: AQHYskryPWbD9sL0uUGy0CZ+78RqoK2zOJuAgAeq3xCAAA5ggIACkHJA
Date:   Wed, 24 Aug 2022 08:50:19 +0000
Message-ID: <DM6PR12MB3082B4BDD39632264E7532B8E8739@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
 <20220817150542.483291-3-nipun.gupta@amd.com> <Yv0KHROjESUI59Pd@kroah.com>
 <DM6PR12MB3082D966CFC0FA1C2148D8FAE8719@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwOEv6107RfU5p+H@kroah.com>
In-Reply-To: <YwOEv6107RfU5p+H@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-24T08:52:03Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=2dfebfc1-8a9d-4212-843a-e7fd9d54d6ad;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 750ef5d3-b0b3-489b-a78d-08da85adac9b
x-ms-traffictypediagnostic: DM6PR12MB3801:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KwCe7x6hzgeCyzAJ6CqM6dV060j+iwaZkL/yRH1KQrA0sBB5hRp3EAk8ZooUt/GORfsqlMFq97nE84MFN3V4Zg7GSNgeD7k2GC8/J77ZxBdRAw8kxm4LGd4fEYNXnTaluuibGFq/N52/DA6ArL3UUjQmY8wjXtv4UmROQr9nZ9NDyWjc/v068mMP1+vYphB9CPwM7doHuptVQVmozqtbBWjZbZn2lhKDTSvOX3N2KWGYQwHLMGQIwdacL7P/AOBLq/ru2lfxj/y5aqvzl/TJhJbm0l97mdUqTQoazoUNou/ONMPD3+hSQsxU2VbeS2n8ZEW6oFk5cGSF8DykuiQ89mZDd4tZxQuijhcHJqiRcHoyOsrqBq3I1AZDSiMVQVoI13kDiLIbt6oEcfRuSI7KKH2vb0SajmsOG2RrAf5VU0dFoZM40GKXkbVJU9vfd6prhhtttujess2u4K+PCLQoIAzHY5Dn5TfZhTT7Se/VPo3S1Ub6vWbEBeh/o34rBSLyX3dhXvLNyCYmcfROFJHguJxawCZijoDF9XbHTY3juuu51PsvJiLBaHjpcw3+WD6/9M1tZMXUDdK06md++jUJXQezRXXv6O+qW8ONKvpB5mMM4FuByh5ViTT5+0GrJVDDWCX6ge/FybyZajnvuqpTt13kx7chD7dAZ3bcE9j/o1KGAGAGNTQtRRO7yboXzIuMX+pjrPhVpcy2wYOMRfQiCPZyI34ulx6bsSu/mRttcZFADZxxjkx96+RjRdgJjC4ldcMhBM7tBXrw2nyzn/nc6B3gmBc/wSuJr85TTttV2hU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(83380400001)(26005)(53546011)(9686003)(33656002)(2906002)(6506007)(186003)(7696005)(38070700005)(86362001)(316002)(55016003)(38100700002)(122000001)(7416002)(66556008)(66446008)(66946007)(76116006)(5660300002)(41300700001)(966005)(71200400001)(54906003)(8676002)(52536014)(110136005)(8936002)(66476007)(478600001)(64756008)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QuoeJR9+dbq0z06EV1JtEwmjkV+fe1E+nDK+QGrdbKqNMnqa1eLmGpPx+WMW?=
 =?us-ascii?Q?L9lRecAvCSVwSEd4mGzcBVnO9X/nq+zKYaSJT+Tvm0+7BQa+/04K5NvmXLlF?=
 =?us-ascii?Q?3lN855TErbqrx4Dvb49DnUQLtxIHhO48gSVKLTKzgoNy7BH9onfpYMPRK7XF?=
 =?us-ascii?Q?FhC6YX5iCOhBlhBEiVe04ZQbJ2+Yt5E/yC4Af5YhuUwxn4+9zlaSqfmpnBme?=
 =?us-ascii?Q?he+BR/uvL+urhb74J7RkYjEeZpBFz2tg4BMiTgsS8wO8G2wrXHQ0wvKg4AUe?=
 =?us-ascii?Q?8GCqdM8kkBwuHfG45UV8x6RYVHUPVpGITuMJyJBLNAUVYZ01lx5ynsT4+7U3?=
 =?us-ascii?Q?/FuHMmUxEID+rzN32eYDKAbxSnffcpvxW2AQWwcDPXswNXXV4BwW9FQe9LzV?=
 =?us-ascii?Q?I6A8a/4iYShnqGNECOUPPMADqMHqJHa/xzwkc7v+vJEZEB1RJG7Y1zU01Ofl?=
 =?us-ascii?Q?ajZnUiAM30L02qFjySaZVkCfd65/PB0yR/4c45USPNoVtZUydOkSA8VWE3VT?=
 =?us-ascii?Q?QBY2M5n8vSgQETTyEex941YxLdCuWn+MYR4D88JbXtFmFZ3L/koUgGQKWt8T?=
 =?us-ascii?Q?rrae2yynHuTjerQsmCV7AU9PBN95J0FupoRtNZ0hU1HaVTtvnlw5NHP2fK5v?=
 =?us-ascii?Q?PZmd6gdNj6FdYCtOI9fzbieEvE3a1WOObN4EydU4h8GziJV+uCk9MzHZd3sY?=
 =?us-ascii?Q?Gg9rgvR+Q1ptVSit01RpcCKZd9hmAoNatgVHdEsCJuAjZvVccoZj1eme+uRo?=
 =?us-ascii?Q?WNYSd5CRkFBxLNuTvl1rVCLpB9UjZmdih8NSov3OfhdOhPYnI84AITauCKhS?=
 =?us-ascii?Q?hI8TD2SJPKv0zZLFkP7UksUMUino2SavksZ6kX67iAZXivP830oqKQEjOWCN?=
 =?us-ascii?Q?5E2VsIWJTv7SXyz96XegR9wyDZWMcAJqTjVyc2XTEEc6LuCbt8DG7eNiQbt9?=
 =?us-ascii?Q?50ElwVoIb2RPGwoBeKeQf18/z2uOnwh9DeJ0GCT5lfEPbxsfoGCUBnG7EGC+?=
 =?us-ascii?Q?KtzzK7AoidRATIu9fVKRzYiHZN5XjHojI/eyJwdpN+aFTa601d++UmTu5lg+?=
 =?us-ascii?Q?TJH3q8RmFmFDmbYxDmOCGvBrNV4GBFHZ1cyZtjWkbcqRrEr3LifVXE+tTxLh?=
 =?us-ascii?Q?c+5yAhWFmJSN2foxP6OesliRjezv73rxpi0h7aniftW0NPQAqJL2jnCmvEXh?=
 =?us-ascii?Q?OwpzIwIHRHZ2i6I/8B9BpGGbQ4Y9g8WEW1/6a4bCe+NOP5RCNoZ1qlvMHynR?=
 =?us-ascii?Q?iYbBLPlgVqCNviH4I9WPNjxmjsaIkb7ZppCG6/98xVg1IOZSDZbJV+NF07MN?=
 =?us-ascii?Q?Sj3ZKU4Jo9OLNIVTikIhUBdPoIn25ZXNPQmwG3Zi6EOTcoXR6X7EXgA5uVYN?=
 =?us-ascii?Q?biDSSp1j5IXtBh21QuPWi/Io2SFdKOw3LLX1zGLeSQ36TIG6M4xVzVHkEcsX?=
 =?us-ascii?Q?ITJUezp+F0WmixG/IoM4C7Pfzk0N3qgU+wus846Z2phfOoncOFiDVmwija4E?=
 =?us-ascii?Q?vfGx83DfZqRnG2ER+jsZ7A53L3RGhgFMI5pU5N2sPB+E9oaFjR/sCwj88qDW?=
 =?us-ascii?Q?SU0GHqxC1oXky6Uu24k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 750ef5d3-b0b3-489b-a78d-08da85adac9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 08:50:19.7908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2X7NJ9DHLWpL8rIiGUDSNwUvGfpro9v28L1JC11/nGUq3s6w8SXrhhPD2P8gOPOR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3801
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]



> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Monday, August 22, 2022 7:00 PM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>
> Cc: robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
> rafael@kernel.org; eric.auger@redhat.com; alex.williamson@redhat.com;
> cohuck@redhat.com; Gupta, Puneet (DCG-ENG)
> <puneet.gupta@amd.com>; song.bao.hua@hisilicon.com;
> mchehab+huawei@kernel.org; maz@kernel.org; f.fainelli@gmail.com;
> jeffrey.l.hugo@gmail.com; saravanak@google.com;
> Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
> jgg@ziepe.ca; linux-kernel@vger.kernel.org; devicetree@vger.kernel.org;
> kvm@vger.kernel.org; okaya@kernel.org; Anand, Harpreet
> <harpreet.anand@amd.com>; Agarwal, Nikhil <nikhil.agarwal@amd.com>;
> Simek, Michal <michal.simek@amd.com>; git (AMD-Xilinx) <git@amd.com>;
> jgg@nvidia.com; Robin Murphy <robin.murphy@arm.com>
> Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
>=20
> [CAUTION: External Email]
>=20
> On Mon, Aug 22, 2022 at 01:21:47PM +0000, Gupta, Nipun wrote:
> > [AMD Official Use Only - General]
> >
> >
> >
> > > -----Original Message-----
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > > Sent: Wednesday, August 17, 2022 9:03 PM
> > > To: Gupta, Nipun <Nipun.Gupta@amd.com>
> > > Cc: robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
> rafael@kernel.org;
> > > eric.auger@redhat.com; alex.williamson@redhat.com;
> cohuck@redhat.com;
> > > Gupta, Puneet (DCG-ENG) <puneet.gupta@amd.com>;
> > > song.bao.hua@hisilicon.com; mchehab+huawei@kernel.org;
> maz@kernel.org;
> > > f.fainelli@gmail.com; jeffrey.l.hugo@gmail.com; saravanak@google.com;
> > > Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
> > > jgg@ziepe.ca; linux-kernel@vger.kernel.org;
> devicetree@vger.kernel.org;
> > > kvm@vger.kernel.org; okaya@kernel.org; Anand, Harpreet
> > > <harpreet.anand@amd.com>; Agarwal, Nikhil
> <nikhil.agarwal@amd.com>;
> > > Simek, Michal <michal.simek@amd.com>; git (AMD-Xilinx)
> <git@amd.com>
> > > Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
> > >
> > > [CAUTION: External Email]
> > >
> > > On Wed, Aug 17, 2022 at 08:35:38PM +0530, Nipun Gupta wrote:
> > > > CDX bus driver manages the scanning and populating FPGA
> > > > based devices present on the CDX bus.
> > > >
> > > > The bus driver sets up the basic infrastructure and fetches
> > > > the device related information from the firmware. These
> > > > devices are registered as platform devices.
> > >
> > > Ick, why?  These aren't platform devices, they are CDX devices.  Make
> > > them real devices here, don't abuse the platform device interface for
> > > things that are not actually on the platform bus.
> >
> > CDX is a virtual bus (FW based) which discovers FPGA based platform
> > devices based on communication with FW.
>=20
> virtual busses are fine to have as a real bus in the kernel, no problem
> there.
>=20
> > These devices are essentially platform devices as these are memory
> mapped
> > on system bus, but having a property that they are dynamically discover=
ed
> > via FW and are rescannable.
>=20
> If they are dynamically discoverable and rescannable, then great, it's a
> bus in the kernel and NOT a platform device.
>=20
> > I think your point is correct in the sense that CDX bus is not an actua=
l bus,
> > but a FW based mechanism to discover FPGA based platform devices.
> >
> > Can you kindly suggest us if we should have the CDX platform device
> scanning
> > code as a CDX bus in "drivers/bus/" folder OR have it in "drivers/fpga/=
" or
> > "drivers/platform/" or which other suitable location?
>=20
> drivers/cdx/ ?

I agree that the approach, which is correct should be used, just wanted
to reconfirm as adding a new bus would lead to change in other areas
like SMMU, MSI and VFIO too and we will need vfio-cdx interface for CDX
bus, similar to vfio-platform.

On another mail Robin and Jason have suggested to use OF_DYNAMIC.
Can you please also let us know in case that is a suited option where we
use OF_DYNAMIC and have our code as part of "drivers/fpga" instead of
using the bus. (something like pseries CPU hotplug is using to add new
CPU platform devices on runtime:
https://elixir.bootlin.com/linux/v5.19.3/source/arch/powerpc/platforms/pser=
ies/hotplug-cpu.c#L534).
We can share the RFC in case you are interested in looking at code flow
using the of_dynamic approach.

The reason we were inclined towards the platform bus is due to
existing SMMU. MSI and VFIO support available for platform, though
would work on the bus if adding to the bus is correct thing to move
ahead.

Robin/Jason,
Your comments are also kindly welcomed regarding the suitable
approach.

Thanks,
Nipun

>=20
> thanks,
>=20
> greg k-h=
