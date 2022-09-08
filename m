Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956BA5B1F33
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 15:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbiIHNbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 09:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbiIHNbU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 09:31:20 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A306D69F46;
        Thu,  8 Sep 2022 06:29:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lre2Yke0ndyD/FriF9XJWGzEC9rKH/rdIvLcUtb9xe0teF9v/cY0vo2NegyDuxCrt5L6yYd3hUa/SgGzsASSO/F4Q+bCUzAsN9XY1M7FZQtJUOEnEWToB5bWZUFOtecuVVhadF2RF6bq67CXHWFBeKUqb32wzABXUWAVBbhteKwWxnWwMXH3uIW8wh0obz8yqGsiBBw0Z3dV8jU/fsQ+0e+iRCLzjua60HMTOl99jhEwIUhCNOVCUfiwiiKSSLRavhMFY6lFVs48M3rkd8rAy3dyiPOXa0wsh2qFhTalMOhWUlM8yhtrCQrfNJXlEFGak+S/am5Iv4nzxSUzyhHKcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=On6tddASMKgSAbNA4p5ExerEvCCidf7tSe0XtIJ5XTU=;
 b=gGSsV6Ir/WoF7v0Jm/Ve8+hLDQzWLrIimSuQLT27UEvrzF+Z33xd4SYwD9cobSslJDQzw0iv5LpzAYnL3adKrfbitJ9sb6IDpkCrjJ/Qrf5qilL41nXYz3vItgsXzienTOg3JX9Jaj8TLvstA4CMPEcwIAb/moOJ3iHfAtxm12Cl1d5YqumdA/AYt6vVLlgi5if2Mcow5ZacwiU55mq+5TqcistExCTIh1NpP3r7fcHhFVqNjPO6tc2LTOkryZ96fKiVVtxn8KO2+4gzfuQ/o5UCLCDfiyCGdsK6TQwEckM8Ic4Bl2oVPROn0OuTrWoHdAxWiqo0wWzyKegbbXG8WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=On6tddASMKgSAbNA4p5ExerEvCCidf7tSe0XtIJ5XTU=;
 b=Rmt3LFyXKXpU1SUE1cYUZKX4S6ef1hMM5JBAc/DMWG+DpT0XzOwgslEDelaoQD8SRJK8xZabz0pm+vWjeqyQc5PvUkMgIkojgZ3gZNjQz5F8tbJvHyjyUq8+EqRtlb3f3NZ5AyJymeddlPr6zRdHESU+45Px27VRpYaqPLrQTUk=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by MN2PR12MB4253.namprd12.prod.outlook.com (2603:10b6:208:1de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Thu, 8 Sep
 2022 13:29:49 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74%3]) with mapi id 15.20.5612.019; Thu, 8 Sep 2022
 13:29:49 +0000
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
Subject: RE: [RFC PATCH v3 2/7] bus/cdx: add the cdx bus driver
Thread-Topic: [RFC PATCH v3 2/7] bus/cdx: add the cdx bus driver
Thread-Index: AQHYwfdnuK4g9RrQ0UOsd8xplYieE63T5/oAgAGZ8/A=
Date:   Thu, 8 Sep 2022 13:29:49 +0000
Message-ID: <DM6PR12MB3082DB67D74BE728C681D327E8409@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-3-nipun.gupta@amd.com> <YxiPeOwo5tWrQuSE@kroah.com>
In-Reply-To: <YxiPeOwo5tWrQuSE@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-08T13:29:46Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=e0b333f6-e717-4b78-920a-bb2bf5c1efe7;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3082:EE_|MN2PR12MB4253:EE_
x-ms-office365-filtering-correlation-id: 71a820d9-e554-4c6a-ec3c-08da919e3422
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5ioGvp/5y8IMK2xShz3OOq7NFCpX1B7MZMTg3QCl58udtWodh8sdGlxC+sAr6Ed6WoQ8ErZ6cn1JRt+MsSoxFk+uNLJMwK+yKCq03rEB0C8BxquEV56cptovfzqGBdQhjM0sJUO6rb3XkeFIH7T7KUxmv17SSYZ8uLmxf8N7Omny1rmJQnNNG/xe4WZV3SzlsyLob/Sa7PhX5/X7cCeurpJ3xnRwiXJzLfNL5Ok6PXTnib5K6VkjcTdtObWjEtMBZtzsPrp4xtpTNRcjxcve/jSS2aB5aV8bXGpOLQyfhAwWLd5mp2l9s1tHiz09cW2wFzip2IyIIMYRb8Kii2NOXVd1F/48MLGbylTzBXjzt5kObicqDKDGQ2LnMKQ9ujTo9p/czDfkRsJLzsl1uHacokWg4VaUSeS7Boq5qYhqkydXCD+iyjjLca4x8EN9Z1O/B8LwmnK1xKqZ8Po7WeU/Pn5eDlfbErZWbc2YCR5lzfdk/V0fHoc62/kM4rXTcMQzYPgXmEx8yHuzTm/ZJKoBJ4Qq7T0Hd16saoVcMMM+3qIYyvMGx91FVONN9y3NUdb9qUeqvH72lgoLw+EHIrut+wpO8TaP/5crPbDvbF7W9dvkx91Q/CeVTG/aW7SlRRiHyqEP66bgUFRXRKWOicB9Og7gWDnUJfjv8cwaps1CwfYEUgCcD4vTXU3qwd2uPp19sc67SI1oacbqU5wPEaaPyLPU/s4+VrOcBFMVWYmjUOPrf+i33v3j8G6D7tre91Vuhn2kWFY+IPIWcivqRZn0dQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(136003)(366004)(39860400002)(71200400001)(6916009)(316002)(54906003)(86362001)(122000001)(83380400001)(186003)(478600001)(41300700001)(55236004)(6506007)(53546011)(9686003)(38100700002)(26005)(38070700005)(7696005)(7406005)(7416002)(33656002)(2906002)(8936002)(55016003)(5660300002)(52536014)(4326008)(66446008)(64756008)(66556008)(76116006)(66476007)(66946007)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xoVq40U6MlBXw0r5Y8P/OJIRYGisYsHKSMSxAgvf6XmF2nUv0FqKIMJNnaT0?=
 =?us-ascii?Q?b2+iW1e9Z0iMxnWoCOGTJ54WsjkX2K2mGbUkyw6Os27tXJ//ZtVnDbu6uTau?=
 =?us-ascii?Q?EB/bwpcWcehTj6ZRGZaxt/h3g+zzkwK1qoV1ECPCz6X4Qda4imk0O2n/xsgi?=
 =?us-ascii?Q?3rcrNbm2PbjNHfQuIdA5BozRzwm4/zXWCzFy83jGLDyXxe2i662IOyKDobf1?=
 =?us-ascii?Q?qLz3m85gIlHntw8S6mNEQvW8AYpFkaFW7MHXZTcNu4F/66ppzYMk/7N00Fjp?=
 =?us-ascii?Q?VQezoaJZgCc6r0xEyFxf6+tykSTT+LpzP0W4B02xWGVJmVV/9+1v1RozAgyK?=
 =?us-ascii?Q?zOncVQ4FjlUZpKfmScsJWKyJptuVOfgX9iB/hAW0YC9kZfpp6McY240k68YE?=
 =?us-ascii?Q?eLfz7O3cxAW3enn1GN+Q6jrKEEYJdcMi9bP2WUX4qTL/ZcImzVFGksn2jT6r?=
 =?us-ascii?Q?Ass73gNytkL2JASFZ+KcclZbP3DQm2VP5YaodM2kd09DdFERS56KxHEkjxNt?=
 =?us-ascii?Q?m16U90W8JWH8FlXVj8mrDylHUHaZ+uFMk/LqF9+9kf6AQt0G8nOxxZXkkz5r?=
 =?us-ascii?Q?gavVi02ro9d6hD7uMLk8FZa2uuht29rMMlf/9yvnYokBtHydHoG1U/g/0SLA?=
 =?us-ascii?Q?gfHeFv6kKV3GND5aO9BO7UmEK3aVn+Xj7QzQM0/nl7Hz6TbuI4sY+yy52FFB?=
 =?us-ascii?Q?N46gt3PfEdT+L8i94kAJpgykGj3ESt+fAO2y5wM3Dlle/0J8Unij5twBQh/b?=
 =?us-ascii?Q?ghZo+kY2CKW1Hm6WMX2xq1EAX6dV2J6f+/Vbbfn9dzu7bLUjGaGc6FCzu1pa?=
 =?us-ascii?Q?KTcZ0GNQRdwAy0Tn6ZvaK6hCcGY4otzkB6Fo4ZUd7SztA118muOgeO5W63ZP?=
 =?us-ascii?Q?FaL/fxI7AkxYJiC7mZHS8JDmEaUWoBowr/2FA4NbmZRkkqWiOYABsmi9mrfU?=
 =?us-ascii?Q?5cCWpfkPa/abnthW43Em6QwMyxrWoldo1xnKNPE6eBACdnRVIRiukO0GiPfS?=
 =?us-ascii?Q?tFpobuQtx5NpPUSuVR33ueECDNh/+oP3dV5bMOlt1/gRhsDYJEvLeJgpxFye?=
 =?us-ascii?Q?JlISiJdLoyYufD+cz+gwgb4/Pcyq10FxCkbQ3de5//GGKtRZlzslYIEX7RXH?=
 =?us-ascii?Q?2LpuoIFh0bj/vvzqHuTCNKs3XbU9GKexQQEkCsD+lHRWERVUlgWz1fyLo7Td?=
 =?us-ascii?Q?Ea5glLoLXBJjQuLLpz6FwujYH5b/APa12ubFsQ5hMroFfqmcnZ6b1m0I4acm?=
 =?us-ascii?Q?1R0rvADopL9u1evinhECEU3O/AdFkNvdgSRsni3oYSTfS3m7h6J2lT7g8v98?=
 =?us-ascii?Q?QDC1LPhWz0S39pv6smg2wGhcAzPma/lGTK/wOy/lB9Ll2eVs6WfjiZeBvFSb?=
 =?us-ascii?Q?XZk8rv1piikymaRtw2+Wgd+Lai0gQ4ojl/uRSjHYBVX8AouFbONmxc71IAi2?=
 =?us-ascii?Q?6K1f5OniPGQ6DsDZGhnSseAswQxQlImJPP4Bdo6tChsVlsifTFw6XGkxEd9K?=
 =?us-ascii?Q?+dLILuey9E8BySTkfJRVy5LfAixCD7v5Ul3cCsRCspFF+MW1lsWeLCjOUTct?=
 =?us-ascii?Q?mMmR3nf3K+MOE3jr6oM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a820d9-e554-4c6a-ec3c-08da919e3422
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2022 13:29:49.1598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Eubxjf1Nd2FVZ4wlurilPGlANvu7dQmYmloayMHr6ME0WH1Mw1AT2WdW5tAHEe4W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4253
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
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Wednesday, September 7, 2022 6:03 PM
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
> Subject: Re: [RFC PATCH v3 2/7] bus/cdx: add the cdx bus driver
>=20
> [CAUTION: External Email]
>=20
> On Tue, Sep 06, 2022 at 07:17:56PM +0530, Nipun Gupta wrote:
> > CDX bus supports the scanning and probing of FPGA based
> > devices. These devices are registers as CDX devices.
> >
> > The bus driver sets up the basic infrastructure and fetches
> > the device related information from the firmware.
> >
> > CDX bus is capable of scanning devices dynamically,
> > supporting rescanning of dynamically added, removed or
> > updated devices.
>=20
> Really?  Then why is the platform driver mess still in here?
>=20
>=20
> > --- /dev/null
> > +++ b/drivers/bus/cdx/cdx.c
> > @@ -0,0 +1,437 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Platform driver for CDX bus.
>=20
> Again, this should not be a platform driver.
>=20
> Now you can have a CDX "bus" driver, that is a platform driver, but that
> needs to be in a separate file and as a separate module and totally
> independant of the CDX bus code entirely.
>=20
> Otherwise this is a mess to try to sift through and determine what is,
> and is not, going on.  Please split that up and get rid of all of the
> platform driver stuff here and put it in a separate patch that happens
> after the CDX bus logic is added.

Platform device/driver is essentially the CDX bus controller here and there=
 are
existing busses like fsl-mc and rsb bus which are having similar bus and pl=
atform
driver in same file.

As you mention to make things cleaner (and which seems more appropriate) we
will segregate the bus code and platform bus controller into different patc=
hes
and files. We will include the change in the next RFC.

Thanks,
Nipun

>=20
> thanks,
>=20
> greg k-h
