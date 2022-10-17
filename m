Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F40600C2F
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 12:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiJQKTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 06:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbiJQKSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 06:18:55 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AEC55F9B1;
        Mon, 17 Oct 2022 03:18:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XVjFo/W6lmm0qJUoa2ZOCZKlngko/beH3+w3BvYdjqnXbTRULh5PbWwxDKOyESLVrItmLk05EWrMir7dhJ1O4QTBnoi5x4b5eMafNs17PAN5L5Z0WetOx1Mi1335b7Oj+/ippTTeNlz3/bcDP08h5l97FfF2P/OoMr5vdR+wk9Z41s+PWFc0RVaFdY7uv8fIusg9Ecxr/rLxYX0Os7i+MLmEkpTmeXPtqKazZhXHiVV3/C+gjOG4AReEvpMYRHfykt9Ga3kyM6/dVVkB/l4QJOnazqHT1brYXZarS44caLRdsewraMUVCYbOUBShRfcZH2o9s/7++85jtULpKBapGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dvw62haEvEm7PwGkEGkITGhYHy+PYe7l7i7Uj6SNZjw=;
 b=PwxG2G+JJHZYQbIUDzn+WRGnwGlBKLpwVhbd2oWeEGNl9/ZFerL2JXsxnHLqGI9Mysi2bI6mPzb4xJA5xaNVo5YuORMdtjybRO/VWpyR+aw2oAywvLaWBpxjM9BsBPuGWAmbhw9YtXpeNcUEWS24KUjsYqRuKDoC6IJhVXCKf2OZ5uJeCwwxyDk80BpDyx1qZLO3QRlX93AqV4KFem2LvoBI4XVq6HgbU3K9hPx3hAYiQm7okiYrmolygJBgWNEDSGW/b1hkEWWWazDeq5Rlr0G14t5NU5rsfz68seD9b6yHrD00WeqGEAMr/F/kj353XDXtWolmPSTdW2IPq6e1AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dvw62haEvEm7PwGkEGkITGhYHy+PYe7l7i7Uj6SNZjw=;
 b=m77ctg6GtP1JUByaEPpqDwNJHGcEXYP3wJ2N5K1RqAx8jKL5ai5aLsobcGQQiZEphPYqs3kEM2fJBttEGhQ28fKikizqwHt9NRmdUIq6ZMXlR25By5W5/CEfT0DIAwf2/N9siViqFqY/VkmcVgLPvqPLDkKepmbVZh5jni2HJn4=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by CY8PR12MB7657.namprd12.prod.outlook.com (2603:10b6:930:9d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Mon, 17 Oct
 2022 10:18:48 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::377f:69eb:dcb:3ea8]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::377f:69eb:dcb:3ea8%6]) with mapi id 15.20.5723.026; Mon, 17 Oct 2022
 10:18:48 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Rob Herring <robh@kernel.org>
CC:     "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
Subject: RE: [RFC PATCH v4 1/8] dt-bindings: bus: add CDX bus device tree
 bindings
Thread-Topic: [RFC PATCH v4 1/8] dt-bindings: bus: add CDX bus device tree
 bindings
Thread-Index: AQHY34c5Cs6Z3QFBAEavcy1n9c9+Qa4N8EWAgARxhtA=
Date:   Mon, 17 Oct 2022 10:18:48 +0000
Message-ID: <DM6PR12MB308201A2C43733E80E7F218CE8299@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20221014044049.2557085-1-nipun.gupta@amd.com>
 <20221014044049.2557085-2-nipun.gupta@amd.com>
 <20221014141717.GB1862711-robh@kernel.org>
In-Reply-To: <20221014141717.GB1862711-robh@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-10-17T10:18:46Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=7ec0e9d4-d5a0-4a3f-a018-726b75a54627;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3082:EE_|CY8PR12MB7657:EE_
x-ms-office365-filtering-correlation-id: 0b06de06-7ee1-4707-5811-08dab028fb22
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XCNgJLIrRVoU/ewLzNjnRi0IRQBwKsUPjjUfWwX+fut6jUDG5eMwBUXHWEPFD0MnCSO6of1nkJaB0/+AHz5GL68m+llj0jzHW29Ho7Qu8UffqFF1j0YBH0XddRAhZjLn0VO27Zrt9MTDEOYHtPm8PCHM+Ztbv3weS74daatJSrAYJwWTngKui0tdoHNXetAshUL8t8UW2s1uwTIZ486wRNPVb3dgm1VAxW50CFd6aq+WvaVgO3fVO4BrS4Kv7qbN1JoxoWfqKYQT9zuTcQ/UjdWbNkzcaf4iLGKq0ktLMwE0giRih55XFfXL5jbh5/9eSz/S+ldtdxtpJHUkPJnVAg+jvr341lhomjTbMwqN49xWfsLxjnNU8khYzO6cOp6MrJAfgCgL7AFCJIMiL42qXxN3Jozr7GL8Nbfgp/oN0Ji+GTTXq2Wx700Tff930n8L1xhcqbumrPvlEcKp/vibyBVj5GCiB0f9u8GVIFs05EyvLiqaQ7HhdGp4amPcFYJDQzOkxRlzvT3AckS08bRJ/aRxCp6mG5Qbj5+96TiAqTWdvacAkYRTConX8RPGaUE2INfDdkGngGWFK/XnInnohqt8g0qQsT6pof4UMdniQSKyI3tHGjJt03fVaSBp0Fx6Ay+0fC0D4K0pTrWi9pPMyVBZrtVIGsMAScEvdtKT6rEb/0L+IMrmtHMk84O+bzyEzNQwOZnyjHmMx91vjqZNTWENqe94R1sUIxMTJbb2t5R3RXzHAo1W3j3jQgnSxxOE0UC7RPNUi8RPLCxlnVyQK/EbnXrVJ2uh3wWMjpiqO/M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199015)(6506007)(7696005)(2906002)(33656002)(8936002)(5660300002)(7406005)(53546011)(86362001)(52536014)(7416002)(9686003)(26005)(41300700001)(38070700005)(186003)(478600001)(4326008)(8676002)(64756008)(66446008)(966005)(71200400001)(45080400002)(66946007)(76116006)(66476007)(55016003)(66556008)(83380400001)(38100700002)(6916009)(54906003)(122000001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MDxHAo3iEXNgaX3isT15GNwEYhsvwkmWOi2JbJw10SE1aoMkK8rJwvwR3Q1n?=
 =?us-ascii?Q?O2dRvw3Ed0+XLv8R9SeyKcpAzfj+GfG2vvz0e6fAGm8pXmdKxQRXVsxoRT/q?=
 =?us-ascii?Q?zep19/YwuXKz3WheUGZXFVCYEzxkTRmCcH/5J8ZBqsHQayl6+pGpRUGB20u4?=
 =?us-ascii?Q?7TkvNbn+MtUwxPGwPV3ChNKVEpqidRYoN72uGzF1yF05PaNlk36xxxi2StpR?=
 =?us-ascii?Q?jjY1Vi4isytQZ1S6X9CGfk4Q6wV6dKYOJpG+zURC9sPc0/ekA1KElFsdhzyg?=
 =?us-ascii?Q?oCjhBym/N6vefGA6Tk75fnQtlIZyZWwOcC0aF0WIdD3Zbxrgfcr6EHIpQO1g?=
 =?us-ascii?Q?STZ8iOpQsXcXD+EmpsyUjaleWqjuLtqDAtUKxMDHG75yiYei1IbmbGxS929D?=
 =?us-ascii?Q?IDLwLerIHn3v6zAsOQTTzPSruR5rkVuXdibQGCqPsjRvv9TcnYtyID+KpaQ6?=
 =?us-ascii?Q?qDTX1xxf8cqlIK7KSLcEpUVRUHfK0lHa1Fggfdzu5TJgNKzRRVFIMDw70EaH?=
 =?us-ascii?Q?JEpvbbLtg2+j0Jn6slnwMy5bK/lDnXUXoqK7k/SEliBD6kl0D+dTd21HVJpB?=
 =?us-ascii?Q?6rIoampYFFH4n4WPJHKTMqcKv0Mfzd5s9aUmbM/+ZSiAN4Trls8YEk343gLc?=
 =?us-ascii?Q?kDG+o+dcLfI38LrHaCMo9ukDCUx9wbUZzG3eVyVH469NWtBzzNLvL28YTQW2?=
 =?us-ascii?Q?mmoxl0zWGPThGPUC3+avy8sHl+tw/kjmnBKFHg7+qR9NHJ/C6eLa9iOsRytD?=
 =?us-ascii?Q?ObywfHldNJR3hCDTvJTY6CE+lnEqnuYRoXm8/TXJba5ZCIbdQa2wOQKWzt5F?=
 =?us-ascii?Q?qT5PvNvSQuRGT69tMTppEMWeNlXCCGYk5l2vgNJdm/Wjm+Td9QoplTbis85g?=
 =?us-ascii?Q?+0LxM4eehJrQw+N3lmvvgk9kz5YEoU2OFOVKNdoiulIzglh5Uv3X7e1PTxfT?=
 =?us-ascii?Q?7k/SINKgvuGq6EbcjZl/WKIcsvJ8sOiFuGwCOnkJh2xlej9NLujzMWAGS1Bz?=
 =?us-ascii?Q?QfK36D0w4/ckEsJd8IElIG6iBIefOb2Q+YaUl8cCVTnmTVySK2oclUCrlzKO?=
 =?us-ascii?Q?Ui11wfkNq7rcNchD14J7B/5e0O3bbl6H45lu628YiJfYe3RYS/dxS7Zkxtl4?=
 =?us-ascii?Q?AfmW+f/cZMgwUoY8o/yGLbKsWzW8YzD+xnLnfmf2iTxD3svkUhkc9itclWSm?=
 =?us-ascii?Q?0C8SwWbHmdTuzW1lqI3FP8XYCkxM24em7E0cKyr9v2bgLoshVppk6HGvzRIw?=
 =?us-ascii?Q?AyLGv3fazXAiYVsTluHetO4ExLIjEUdmZAErJc/NeV4mJs0s47VsNpBU3y+C?=
 =?us-ascii?Q?nwfQVcJDayMalPgj8K9iDxgHToLQ3lvxA9L62C7GBzkKw+PNmYFwoD6z35wp?=
 =?us-ascii?Q?oN42Et5Om3gUVA1RJuhVQxbn2DoM2nLm90P0GtqdKfKhZjOweH3msMNMW7CK?=
 =?us-ascii?Q?6lm+GoCwR9+UAtUDX8vPvwS43PRwAvbHAfRbDUtYmrD/stgC8/EdwcVPuiRQ?=
 =?us-ascii?Q?5mmQA5NM72eR72h6Ny40NLvgOxTb7bUFZ9H8YjREjh17riTQuKnEzxya2cnf?=
 =?us-ascii?Q?skUmEoDqcOBEXKDv+KI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b06de06-7ee1-4707-5811-08dab028fb22
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2022 10:18:48.4233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QGLLnhmUGN8p0e4gA/DabetNaZO74MBOXhl00Oi5I0RpBJ0jPn4bXLx8soSn1h6y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7657
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
> From: Rob Herring <robh@kernel.org>
> Sent: Friday, October 14, 2022 7:47 PM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>
> Cc: krzysztof.kozlowski+dt@linaro.org; gregkh@linuxfoundation.org;
> rafael@kernel.org; eric.auger@redhat.com; alex.williamson@redhat.com;
> cohuck@redhat.com; Gupta, Puneet (DCG-ENG) <puneet.gupta@amd.com>;
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
> Subject: Re: [RFC PATCH v4 1/8] dt-bindings: bus: add CDX bus device tree
> bindings
>=20
> Caution: This message originated from an External Source. Use proper caut=
ion
> when opening attachments, clicking links, or responding.
>=20
>=20
> On Fri, Oct 14, 2022 at 10:10:42AM +0530, Nipun Gupta wrote:
> > This patch adds a devicetree binding documentation for CDX
> > bus.
>=20
> Please read submitting-patches.rst and what it says about commit
> messages.

Thanks for pointing. I had a look at the file and will update accordingly

>=20
> >
> > Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> > ---
> >  .../devicetree/bindings/bus/xlnx,cdx.yaml     | 65 +++++++++++++++++++
> >  MAINTAINERS                                   |  6 ++
> >  2 files changed, 71 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
> b/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
> > new file mode 100644
> > index 000000000000..984ff65b668a
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
> > @@ -0,0 +1,65 @@
> > +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fdevice=
tre
> e.org%2Fschemas%2Fbus%2Fxlnx%2Ccdx.yaml%23&amp;data=3D05%7C01%7Cnip
> un.gupta%40amd.com%7C16a836a178fa4e373c9308daadeecd32%7C3dd8961f
> e4884e608e11a82d994e183d%7C0%7C0%7C638013538406495866%7CUnknow
> n%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haW
> wiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3D44F%2Bw51YMeCyE78g
> 3EmevxqYx%2FybbeKdlkDv1X6XDcM%3D&amp;reserved=3D0
> > +$schema:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fdevice=
tre
> e.org%2Fmeta-
> schemas%2Fcore.yaml%23&amp;data=3D05%7C01%7Cnipun.gupta%40amd.com%
> 7C16a836a178fa4e373c9308daadeecd32%7C3dd8961fe4884e608e11a82d994e
> 183d%7C0%7C0%7C638013538406495866%7CUnknown%7CTWFpbGZsb3d8eyJ
> WIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C
> 3000%7C%7C%7C&amp;sdata=3DFPADx3bdmJg%2BfnEs%2BUtNTMPo3U1aiX3wv
> w57EQvleK4%3D&amp;reserved=3D0
> > +
> > +title: AMD CDX bus controller
> > +
> > +description: |
> > +  CDX bus controller detects CDX devices using CDX firmware and
> > +  add those to cdx bus. The CDX bus manages multiple FPGA based
> > +  hardware devices, which can support network, crypto or any other
> > +  specialized type of devices. These FPGA based devices can be
> > +  added/modified dynamically on run-time.
> > +
> > +  All devices on the CDX bus will have a unique streamid (for IOMMU)
> > +  and a unique device ID (for MSI) corresponding to a requestor ID
> > +  (one to one associated with the device). The streamid and deviceid
> > +  are used to configure SMMU and GIC-ITS respectively.
> > +
> > +  iommu-map property is used to define the set of stream ids
> > +  corresponding to each device and the associated IOMMU.
> > +
> > +  The MSI writes are accompanied by sideband data (Device ID).
> > +  The msi-map property is used to associate the devices with the
> > +  device ID as well as the associated ITS controller.
> > +
> > +maintainers:
> > +  - Nipun Gupta <nipun.gupta@amd.com>
> > +  - Nikhil Agarwal <nikhil.agarwal@amd.com>
> > +
> > +properties:
> > +  compatible:
> > +    const: xlnx,cdxbus-controller-1.0
>=20
> Where does 1.0 come from?

This came up in internal review comment, but seems that there is no need fo=
r
having the controller versioning. We will remove in the next set of patches=
.

>=20
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  iommu-map: true
> > +
> > +  msi-map: true
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - iommu-map
> > +  - msi-map
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    soc {
> > +        #address-cells =3D <2>;
> > +        #size-cells =3D <2>;
> > +
> > +        cdx: cdx@4000000 {
>=20
> bus@...

Sure. Will update.

Thanks,
Nipun

>=20
> > +            compatible =3D "xlnx,cdxbus-controller-1.0";
> > +            reg =3D <0x00000000 0x04000000 0 0x1000>;
> > +            /* define map for RIDs 250-259 */
> > +            iommu-map =3D <250 &smmu 250 10>;
> > +            /* define msi map for RIDs 250-259 */
> > +            msi-map =3D <250 &its 250 10>;
> > +        };
> > +    };
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index f5ca4aefd184..5f48f11fe0c3 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -935,6 +935,12 @@ S:       Supported
> >  F:   drivers/crypto/ccp/
> >  F:   include/linux/ccp.h
> >
> > +AMD CDX BUS DRIVER
> > +M:   Nipun Gupta <nipun.gupta@amd.com>
> > +M:   Nikhil Agarwal <nikhil.agarwal@amd.com>
> > +S:   Maintained
> > +F:   Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
> > +
> >  AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SEV SUPPORT
> >  M:   Brijesh Singh <brijesh.singh@amd.com>
> >  M:   Tom Lendacky <thomas.lendacky@amd.com>
> > --
> > 2.25.1
> >
> >
