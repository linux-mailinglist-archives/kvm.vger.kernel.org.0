Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4175A646A
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiH3NMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiH3NMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:12:23 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE0CB2CD0;
        Tue, 30 Aug 2022 06:12:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1pAuCpTkXvNIUR2FITIJPP2oIlzGfe7rfpWdLECKfHJGOw4ePyTLrK4h+qb2tPZ9Q44yyltdYoQd5CpwpaZyJMo7CLT4hYqcRlaYWCWN2hlwGLj2UT9FZJeRPGpqPUmnQnK3lttvp793RoBqHnyUlpY6krn6LhJQRjaBUEHsfcavhFy6Ov9VCXWkkVkvKGkdNC0FPToBv0+VTwyZhtSciaKzwm2UP7SM8vfubBlN/XB+zIkkz50k4EEL+KAfi5nuscCu1uJ9xj8B/3WYekj5fRwh8unNXbrQhM7+IZ9aWL8h0W6GKl8A2gU9hXexqZdVHIaTEVunYhx9izWyLtEYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kpk4BPi7UpQ6wvewujiryzq7jteWM5fhEarDHDI46L4=;
 b=nNRxL5KzNTd17VUAotUwH7+tjaTi1x/yZ/Rbt2R6aCpPYSZ20nSGExzMA6KAFggqOBSm5JAbF+/vOhcoTpMkmzW/f1RLGr42b2d/qMNhtA9okpqSSJMyiH1NtRwFQVKbIy+LMyJdWp1Y9XIkh70g5K/e7ZAstYZwdGTzAPcavaPWMJTPZ8eZPSecPnAamUNmMBCWhlppWe6Ak939GiS3sw6WLR1X93MvNsRQ9pDZkUqIZtBZ4mqLeaBOU6P56uBsj09m4tCDnCir5qDDJMPS2S/ipoJ4d98NHLY3/1WheAMnOiZdLpPLtZXJGOMChmZGyQH+5mBStxAkXqVqs5hDyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpk4BPi7UpQ6wvewujiryzq7jteWM5fhEarDHDI46L4=;
 b=jNvPFDOGK3JwudACruoSKP7l06JImpauSEKpgDIKQ7VegDSxsaNrv2Rb8T749mYIfHFHT1xOUixeyfB28X/oFv1M2XZkI+r6rFVlJfu3bNpzROHlAz0kVT5piKSHUeT7FFoKsj1ywmYma3ddeLpFSMU0GXxTn/U3No3tr+z/RZ8=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by PH7PR12MB6882.namprd12.prod.outlook.com (2603:10b6:510:1b8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Tue, 30 Aug
 2022 13:12:18 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74%3]) with mapi id 15.20.5588.010; Tue, 30 Aug 2022
 13:12:16 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Robin Murphy <robin.murphy@arm.com>,
        Saravana Kannan <saravanak@google.com>,
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
Thread-Index: AQHYskryPWbD9sL0uUGy0CZ+78RqoK2zOJuAgAeq3xCAAA5ggIACkHJAgAB+fACAAL3fAIABQH2AgAAWLYCAAMjUQIAFNimAgADvfjCAAHjbgIAAAkPw
Date:   Tue, 30 Aug 2022 13:12:15 +0000
Message-ID: <DM6PR12MB30827577D50AB1B877458923E8799@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <DM6PR12MB3082D966CFC0FA1C2148D8FAE8719@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwOEv6107RfU5p+H@kroah.com>
 <DM6PR12MB3082B4BDD39632264E7532B8E8739@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwYVhJCSAuYcgj1/@kroah.com> <20220824233122.GA4068@nvidia.com>
 <CAGETcx846Pomh_DUToncbaOivHMhHrdt-MTVYqkfLUKvM8b=6w@mail.gmail.com>
 <a6ca5a5a-8424-c953-6f76-c9212db88485@arm.com>
 <DM6PR12MB30824C5129A7251C589F1461E8769@DM6PR12MB3082.namprd12.prod.outlook.com>
 <Ywzb4RmbgbnQYTIl@nvidia.com>
 <MN2PR12MB30870CE2759A9ABE652FAFD8E8799@MN2PR12MB3087.namprd12.prod.outlook.com>
 <Yw4KKWIGsR8MKa1j@nvidia.com>
In-Reply-To: <Yw4KKWIGsR8MKa1j@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-30T13:14:07Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=279e516a-b50c-4711-9a41-5e9229e01947;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ed47137-b7d5-4877-ad69-08da8a89429f
x-ms-traffictypediagnostic: PH7PR12MB6882:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AtO0RVNx30bAf0UP7RY++/GSYl1nCP7JnP4SOXS1N6Y2t8ZHkA7yByCk0V2Kjs2CyVISazHaSG5Pb3h/YxlE9Mkk1N46u2jPYQwx2fnz7d2cF0L+R4WWAWwjn3VeOJ3j+AExc6Oc36mNNmqPPebD7kLucyxY4/EcNseUZ1cyitC+16Qa+cFev8OjemlEi15W6csI7YrJGsZGjx9dEfZ9pLDy9q8Z/61Oq7w6zZWRCHWxkOaAaFvDxI84JkGkSvAqcAAkqUALaKHXCeOtyZhVFKgUtLEFh1a6biHlsz/nKSeJCsWu1+ULCPC8fZW0UkkdEsAuj7I0PCRwqBzWodndDBh72xSANWXKfz0OBVM4vv1LTfEOKvMRn0ZL6x3KuMGbvtmTFyC+3WHD5ipfvzRQnIpiIYRBWjN/TFJ0wnXjtcdpKB5Rc4UxPLKA095WyXvZsr3XtGxrzmbSqOYQdTVGZ7se107VDMpTdAqLFjSNFe625yiJ7CTQRhegcTpNs71mJKV0urFi8WorqRMok62/NlnWG76DyJ/Uc5GoEYA8wJJxX4g/RihDDoi6EVNR3NdN/4mB1pJFySMoDXvRauBqOYkHqrYm6sFVL+UDpRk/qCw2LxsS0k2EK0mMOG8ZssfyRYqAA6JF+Z2Y9opyly8GLJUDkASqKHJw0jEPViBX2zjFOYbWVBzZD7aJ1ZYKXOJrSu2dy+AkZ1QxeAdjZZOerSwS415nBqcQ003c46zDT1yoX/3Gg7Acl/iPl+OlPB+Pd5O2yl4JcdkxpC8MPVI8JA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(122000001)(38070700005)(86362001)(186003)(52536014)(38100700002)(5660300002)(7416002)(8676002)(66556008)(66476007)(76116006)(64756008)(66946007)(83380400001)(4326008)(55016003)(66446008)(2906002)(478600001)(71200400001)(6916009)(6506007)(8936002)(53546011)(7696005)(41300700001)(55236004)(54906003)(26005)(33656002)(9686003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?11YAe413kkaaYsTw3+N7AxJBaj+FGRsOJRvMU3NkBxaQKpiEEd1dZ2O2290w?=
 =?us-ascii?Q?lftSKU6X6piLZhQoWzcPonrzERogCmGuGbQoAfQJTElIqptgH8y4lTEt3Jwe?=
 =?us-ascii?Q?YWpwgEe6rbWsSEz6ix7wEdDgNDwflIsVXfkgvA3e17N+MaFOCfmCgBArf/et?=
 =?us-ascii?Q?hD/ET7Cek7X3TmB/Q/stjuIkBvGJqoexbtUfB1J68N6LA3vzPpNQPetJIQAH?=
 =?us-ascii?Q?MEuv7YPEKe/MF+eHUuxT4SZhBn81GdRS15W6LwJCcOtrq7jJejITuQGCKBRJ?=
 =?us-ascii?Q?EWubUtrj9+iS2U73GIqAbCxTc5Th88qLEY4rrAbpHmaaAl3b3LiLCqmFRPms?=
 =?us-ascii?Q?HCPFWBJqE/QJJyUGvytehRQfoUHK3CcIB5nwmuSawl2scSy1zqlImGgu6aw4?=
 =?us-ascii?Q?KozlOQpd/q0TX4Nv3tqnL1oucLjNGkKlvAeS4k8mYHBNS3nhUsXSNb+UOg68?=
 =?us-ascii?Q?rWNv8UN4dR99RuByqgT45z7rzzZO9qbZUO4aOHzfTDT2Qike7a3J2vzoyjvB?=
 =?us-ascii?Q?bHvnr5T2vyZmxSinlfjBO/aLps/Q7ZUcBn7XwzaZV7PrI13HpKrZEguCERgv?=
 =?us-ascii?Q?935UKSFXo1QIKtRV7KtU4jo6vQ4u1XVPanUVriwEqhQ34X9QDn6+jpQ5tLOM?=
 =?us-ascii?Q?jhwF2ngQ/XOUYva/B8Ljbt6RLU2G7HRmg7A8wPG3zgGqmWOFV36QIpOtZ8jV?=
 =?us-ascii?Q?P/kq85QGu4I8QEFR1sa5xPiR+32iRN4aKvn+PRnTh59s5OjMlIiDf9WcI+sJ?=
 =?us-ascii?Q?HRoVgY0Q4/Y5aEbJlcpiDxrMpSeu7LUm46WRmk03TyQkN+sIY9yavV+4iFO/?=
 =?us-ascii?Q?O3FtdO04uLsCjRDC2Fq3x/i8QOndI+dPwal0BE2qF9nlL/0NzLBpNRVxBPBr?=
 =?us-ascii?Q?H1TPixbKPAgUJKt7MuZ1y+WYEZ0qDmR5GZzLXIV38RssWKDc1OS8CKu8U0Xo?=
 =?us-ascii?Q?hEX5hYPhln1QKkMdPDGiXXDgvhaItw3Oa+96i69OTmZeGrEGGmziuyp/FTAW?=
 =?us-ascii?Q?bMbKzuScbFt8pO449/0m9rUBugarN+GrwChUhZCrer7xk//tXgzWfoXqeq8o?=
 =?us-ascii?Q?Jc83xQkQPmRLVwV1oFd85snq0D3yKXMikPvcZQm07aYZIcAsRWWW+6fXl7cT?=
 =?us-ascii?Q?cEii1yvbc23/ZsQ58p9+bq550cwKVEN+mbv2djWr0B0pevBfY01/eYiQOxwu?=
 =?us-ascii?Q?xzLlgASUTEe5KyDL6DQSKxv/MIKDgGHGPBV8r5cHLvlJhbJCEki+gjaBm6nN?=
 =?us-ascii?Q?Mjsotf8fXfTusJMTuC2ZTUpxi2HXpEkk1dyDTMrBhxf3ytHUr5JN0JLm4RZE?=
 =?us-ascii?Q?kFc5W2grLI9pn6HjQooxjk5sXhw0Fc++Zx4Q52/xZMrfQ5J+dHLiM+BE+Lre?=
 =?us-ascii?Q?tYEZu+RQZ1v74d9DzPnuh5s+gHQ9KZQZLmmGWTBA3M6oIESoAkZa4C0opbxd?=
 =?us-ascii?Q?88BwqyufDi8e025tuA5RI7pVmB4IDAe0X6lomwllRdqK5GgWkn27CZH5666z?=
 =?us-ascii?Q?NRBoq7ra+ki6X+a9+xKWZOe0Bqt3Fa51lw9L/4q9nCUz2mSi72m27hQ1AkvU?=
 =?us-ascii?Q?algN+XDUf6FQ5BJthAE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ed47137-b7d5-4877-ad69-08da8a89429f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 13:12:15.8791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VOprEkFOHmsPLJV+eSfMCXA18Dwcn9DmxkcXdKGSRtdUxqTRvBHfPN2/cXbKeb5Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6882
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
> Sent: Tuesday, August 30, 2022 6:31 PM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>
> Cc: Robin Murphy <robin.murphy@arm.com>; Saravana Kannan
> <saravanak@google.com>; Greg KH <gregkh@linuxfoundation.org>;
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
> On Tue, Aug 30, 2022 at 07:06:12AM +0000, Gupta, Nipun wrote:
> > [AMD Official Use Only - General]
> >
> >
> >
> > > -----Original Message-----
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Monday, August 29, 2022 9:02 PM
> > > To: Gupta, Nipun <Nipun.Gupta@amd.com>
> > > Cc: Robin Murphy <robin.murphy@arm.com>; Saravana Kannan
> > > <saravanak@google.com>; Greg KH <gregkh@linuxfoundation.org>;
> > > robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org; rafael@kernel.=
org;
> > > eric.auger@redhat.com; alex.williamson@redhat.com;
> cohuck@redhat.com;
> > > Gupta, Puneet (DCG-ENG) <puneet.gupta@amd.com>;
> > > song.bao.hua@hisilicon.com; mchehab+huawei@kernel.org;
> > > maz@kernel.org; f.fainelli@gmail.com; jeffrey.l.hugo@gmail.com;
> > > Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com; linux-
> > > kernel@vger.kernel.org; devicetree@vger.kernel.org; kvm@vger.kernel.o=
rg;
> > > okaya@kernel.org; Anand, Harpreet <harpreet.anand@amd.com>; Agarwal,
> > > Nikhil <nikhil.agarwal@amd.com>; Simek, Michal
> <michal.simek@amd.com>;
> > > git (AMD-Xilinx) <git@amd.com>
> > > Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
> > >
> > > [CAUTION: External Email]
> > >
> > > On Mon, Aug 29, 2022 at 04:49:02AM +0000, Gupta, Nipun wrote:
> > >
> > > > Devices are created in FPFGA with a CDX wrapper, and CDX
> > > controller(firmware)
> > > > reads that CDX wrapper to find out new devices. Host driver then in=
teracts
> > > with
> > > > firmware to find newly discovered devices. This bus aligns with PCI
> > > infrastructure.
> > > > It happens to be an embedded interface as opposed to off-chip
> > > connection.
> > >
> > > Why do you need an FW in all of this?
> > >
> > > And why do you need DT at all?
> >
> > We need DT to describe the CDX controller only, similar to
> > how PCI controller is described in DT. PCI devices are
> > never enumerated in DT. All children are to be dynamically
> > discovered.
> >
> > Children devices do not require DT as they will be discovered
> > by the bus driver.
> >
> > Like PCI controller talks to PCI device over PCI spec defined channel,
> > we need CDX controller to talk to CDX device over a custom
> > defined (FW managed) channel.
>=20
> It would be alot clearer to see a rfc cdx driver that doesn't have all
> the dt,fwnode,of stuff in it and works like PCI does, with a custom
> matcher and custom properies instead of trying to co-opt the DT things:
>=20
> Eg stuff like this make it look like you are building DT nodes:
>=20
> +       struct property_entry port_props[] =3D {
> +               PROPERTY_ENTRY_STRING("compatible",
> +                       dev_types[dev_params->dev_type_idx].compat),
> +               { }
>=20
> +                       ret =3D of_map_id(np, req_id, "iommu-map", "iommu=
-map-mask",
> +                                       NULL, &dev_params.stream_id);

This would be removed with the CDX bus model. It is currently here because
we were deliberately trying to use platform bus.

We will be sending out v3 with CDX bus next week.

Thanks,
Nipun

>=20
> I still don't understand why FW would be involved, we usually don't
> involve FW for PCI..
>=20
> Jason
