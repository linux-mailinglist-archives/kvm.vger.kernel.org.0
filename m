Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085285AFA78
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 05:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiIGDNV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 23:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiIGDNT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 23:13:19 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDF897B00;
        Tue,  6 Sep 2022 20:13:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJiUZ7O4BfJHfCvPeW+AILzMzM1nrVEtV7l/ZTOY2Q+EL6T+bsZADjLKZmbu5G4H5StYkEAmo94kx34b2rQw56fbeqyTGxoQSrtfAfwfD12N3TL4ZDNYZ04V5sa3XN59o00qeHolyW8NraXGPbZ8ytHY18H4b1Pm4ebZMXB9ynUPW5cPCGcP3/PrE65v+rvC2LvToF/hSK+VpBHr3s+h9ip53iRF6E90WtkEDzJBxQ5RUvYsgXr8C4NsRbMSwIjtpcfF2L8hnaelXZwfkhv2Fdq1jb+OiKh7SBlf8NKPi4+8tGqgFU3kYK4BHvM8RGhDLQrY/CEAegvuMo5IIOAtnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bbU29ondGo5t8B1Bgn25HOsvlGlgwcciQmnXTlVItko=;
 b=gmzz+xsRdRfOb1zXd2i8U68M9wFUkALbNZuG/FuCN3bWDj/OH9/J+XRSIEON2wbMQ2p/8OLpJChHS4gX3tUBQnsIfD94lXjgjDQoaXdloWdhWUeQ4ClMNzm7FE4V9gzplFQiH71AgUGJIWS7FdObKb0xWUYgnCARcBcOHLYs8mzihV30q0Hmnz3FgLArPHQ89kasinjzMk36Br+JBd1umgFq6ystjt0KsdktBzTWtUww830x/kGtBieiRDY1DRaOVARJaNeVR668B6jwPm4DHUktnF/cp1DRxy1CkdPXfxJv2+b2bmwgVEjcSH5bsx0pF+79Nr/ZAFIp3ipMuEyAqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbU29ondGo5t8B1Bgn25HOsvlGlgwcciQmnXTlVItko=;
 b=HCiTfOm9f8+K/u0YWkbAaSBGujRNGoDXp1LwNRqM7QarEH7/UB2oCpEK5q0fqUR8TX8Inpt+1dShMsG7Yyp5fmjiSFdjpW8l3IDe6l0Eq+TF8K2/sQfcSVqURXxhsolGRuH0K4mXj9OV3h2OHGwRUmUqdBsqhvdPFwvYf+CBW08=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by CY8PR12MB7540.namprd12.prod.outlook.com (2603:10b6:930:97::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Wed, 7 Sep
 2022 03:13:13 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74%3]) with mapi id 15.20.5588.014; Wed, 7 Sep 2022
 03:13:13 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Rob Herring <robh@kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "mani@kernel.org" <mani@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "git (AMD-Xilinx)" <git@amd.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>
Subject: RE: [RFC PATCH v3 1/7] dt-bindings: bus: add CDX bus device tree
 bindings
Thread-Topic: [RFC PATCH v3 1/7] dt-bindings: bus: add CDX bus device tree
 bindings
Thread-Index: AQHYwfdggyJkuQrhpUeHNGqW5h+6Mq3SrVAAgACd+QA=
Date:   Wed, 7 Sep 2022 03:13:12 +0000
Message-ID: <DM6PR12MB3082B9C670B5F58215259A76E8419@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-2-nipun.gupta@amd.com>
 <1662486402.681939.780022.nullmailer@robh.at.kernel.org>
In-Reply-To: <1662486402.681939.780022.nullmailer@robh.at.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-07T03:13:11Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=e19e0cd7-69fd-4d28-ad3b-57d7b537e70e;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2abbe31-6aec-49f9-cb1b-08da907ee646
x-ms-traffictypediagnostic: CY8PR12MB7540:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i6rsYvdUPmcbWpWio2rXxQy5eiRXt1pW890oy0bqJAyyHtyNRO5cLdfJJXBMV4Y7eYc3OSl7KldAdhwVCJd32i7XAqIGkDk2rSd/SQc/CfGqEpzHs689jid8JLHAeIVEa+7P5Insq1i+94YDkPTPjvz4uIefX2QUts3FJgtW/OQfthN0cKSdw8Ben1WC9cEkXMve7vyzPf6zdmKxL6+b6NpLB5P2qbTARvcmiSDAk6cNqz+IiNb0wBUJ5gFQ5MvRvDk7ELq7fCatKR4BkSzJc37Ttnmb4thM8YaxTjdhdLrHaDNOyURvgRWkw+lkFkio0nifh1fZKxcU85JK+RtvM1cElC4g7YIZ7TNCozqCbqzjatUSS6/4Th79TNpyuBXxdMsZ7DmJEKq012Q7ChdUxE+qAVQWsfYsZNdWGDiYbY8936iqWhrCcmhGMav9Xo2ptAohwlaK1mciymVvCH5U9e72dQK+ZUAB6XkmCtF093rdYHk1UZ8YsO6Xom7LAMft8459uJ0uaVyZlcU77L4v5S86hJOdRukxUq9NTWn8PTe6iIQ/IsodZ7mUewva76LrTehCRsrPZ0u9wtjoUjIUFFWyZ5uqpfmz+roItP7/hjcYTKvpHqa+GrMOGYWZp2nzwXbRdZNpfFAcMx/vSuhfGtDSZGVayUj0EMzCKiBncJqL75qaBrLK9mFXVTeFq97qF4GyatyTN70IcXSsnBCAMPPcZHaCqdhWYstqfLrRbEDhZ2MDD1oUS4N3ZoTriIcfoFcbMbVjftSSDU5fl4ptykzuROhHJSK8VN1n9aqEvlw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(33656002)(186003)(2906002)(7406005)(5660300002)(4326008)(8936002)(66946007)(52536014)(8676002)(66446008)(66476007)(66556008)(64756008)(45080400002)(316002)(7416002)(6916009)(54906003)(76116006)(6506007)(41300700001)(26005)(7696005)(55016003)(55236004)(53546011)(9686003)(86362001)(71200400001)(966005)(38100700002)(38070700005)(83380400001)(478600001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?f4VY5RpoY81ke5bFIf27FHn6GDdhloTydKZ4lSrIQMuuW8GDsNiVkig68Y0t?=
 =?us-ascii?Q?NbuJJ2fhp55tNUcP3xN+ATRS0xUzajT0JOD27xU4nGPPD14UcnXAUWXNRm7H?=
 =?us-ascii?Q?Q429nV/tUMWFlTkO/T8/lT7pKm6TxdMLQOrORPNOleV6HcQRZN3DHkJRBZKb?=
 =?us-ascii?Q?bdorL71W8K+b5WwJ2TwdSotZ1VhqxcaCsvL9P/ns/dJ4ituXyKThIwKP8fTm?=
 =?us-ascii?Q?rmepB1vwkly9PPm25p7e/uaLOSjSPka0MG6fbzzfx7wpRcrjFnWnWN15iRRP?=
 =?us-ascii?Q?srE0H+EE9eejNI0xT68bbFhw8Y3bwNukf0aBcy/K8qDblu+qTi2deQSV+CHt?=
 =?us-ascii?Q?4TsPAci0L8WwlFupcQf7+e4jD1Lb/+vuzR0YpYKziP0hGZYU9gFG5bpbVnLc?=
 =?us-ascii?Q?DXRgYQ4FHAe45HCDHPiSMa20T3MYCVHlWg0YyJ6/XSB4dIz92oZSjXIaOqgl?=
 =?us-ascii?Q?YRNrvD0JF4SgxHPXBwZhsR2guolN8UtjGvbXVWld4ncPgbzAX8NgBVStkuTO?=
 =?us-ascii?Q?iJkO2I83SK7FaM8R9DEAM9C2hjmFnpOgqXiWC6N+4Lig5OArMtR1xv90u15D?=
 =?us-ascii?Q?uHGMJq6ZYnRlm1f7IcC+WQk2bcHR9agcsA4DKejVfbg1euPGkqLn40untDuz?=
 =?us-ascii?Q?lAQc8L8nLoPV/aQp2RXIlaUWKIHymNZu7SyWeDtHROJj8/iFZ79bzBVFjFmv?=
 =?us-ascii?Q?rmHAAd3+qfsiWniO827ezzc5O5QtGGY/A2GDgMCiTlamp8JztflRs8zowYYr?=
 =?us-ascii?Q?a6ZfMQXh0uCaROBnvs15fugog676kGuNJsSQnrFclu3+wnyWmhgs+N8np12Y?=
 =?us-ascii?Q?PA16yZ6eVHldLu81IYMckYn97uimTTaup0TUhTzITLr65uebOOBjIbFp0mbi?=
 =?us-ascii?Q?smrtSZDEPy/Z1ni2xtyrGqzi5Bl84ETwYAJmWyDrcxoU2vGEufMEJuR1oNsx?=
 =?us-ascii?Q?me5MXvGwE3Pu2++EHOtZ1Pnn2bI1suF4cRZkbvnfrqcG1RysCGZbHr///Bzj?=
 =?us-ascii?Q?pyU4hgUfhJ+6D4r0Su/MjVoctNXXgBH5fumCKN4VcJU9E2vlzg20zkw1FE10?=
 =?us-ascii?Q?JWaZlNWuyC7qa9LaKqdiT4847pjtqItrgMmFBlNGEMoHcSYPSVg2grG8jJ1m?=
 =?us-ascii?Q?5XCWHwXrKDdrefZWqZogEheiD9AcKxoKeVXAj9kwbE5VxHyNsVeTbbXlJD93?=
 =?us-ascii?Q?cRfOvsMJ45tt5vf+jfI2wSxNSfURofxLB4BI5HgqAj/DwcSY7blZHBfcKLBJ?=
 =?us-ascii?Q?t3iBvewB6nn7F6J2+AyPb/5qxuBgVQ/WSm9iovnPBDp9UzbAtBbqcD8cOaxY?=
 =?us-ascii?Q?knuNCNkIL37/ufk0/T6gRHJFXV/7PldE4lzqK1u8y46qyPNSndXTwmvIXKb7?=
 =?us-ascii?Q?HEI1Qwq0ZFy5QtwF16mYXA2SkUd6TyyZinotsGH9XaLL+2M2VO6d2Pk9M6ZT?=
 =?us-ascii?Q?Et3fnvRkRvKBu27TRf852ADxosmhAvo253wDQVTGMyR9j9V5IV5poUJVVR79?=
 =?us-ascii?Q?1YvPxdoFwDdXVr7IsBGbjEyDHMxWhx1bQH0eKD9Jv1drLqqsY37RZ2kvjG/U?=
 =?us-ascii?Q?62Cjvx43coRwFwMiDxw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2abbe31-6aec-49f9-cb1b-08da907ee646
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 03:13:12.9399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wwGpmh/ie0NdcJDqamp6R8jhhadvJ02hAgUMDF8IPjcsvh7kZ5ntGrPOg7+ZRcBK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7540
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]



> -----Original Message-----
> From: Rob Herring <robh@kernel.org>
> Sent: Tuesday, September 6, 2022 11:17 PM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>
> Cc: gregkh@linuxfoundation.org; eric.auger@redhat.com;
> devicetree@vger.kernel.org; linux-kbuild@vger.kernel.org;
> jeffrey.l.hugo@gmail.com; maz@kernel.org; Gupta, Puneet (DCG-ENG)
> <puneet.gupta@amd.com>; Michael.Srba@seznam.cz; cohuck@redhat.com;
> will@kernel.org; masahiroy@kernel.org; mchehab+huawei@kernel.org;
> joro@8bytes.org; okaya@kernel.org; alex.williamson@redhat.com;
> song.bao.hua@hisilicon.com; jgg@nvidia.com; mani@kernel.org; linux-
> kernel@vger.kernel.org; robin.murphy@arm.com; robh+dt@kernel.org;
> krzysztof.kozlowski+dt@linaro.org; rafael@kernel.org; f.fainelli@gmail.co=
m;
> jgg@ziepe.ca; kvm@vger.kernel.org; Agarwal, Nikhil
> <nikhil.agarwal@amd.com>; Anand, Harpreet <harpreet.anand@amd.com>;
> yishaih@nvidia.com; linux-arm-kernel@lists.infradead.org; git (AMD-Xilinx=
)
> <git@amd.com>; saravanak@google.com; Radovanovic, Aleksandar
> <aleksandar.radovanovic@amd.com>; Simek, Michal
> <michal.simek@amd.com>; ndesaulniers@google.com
> Subject: Re: [RFC PATCH v3 1/7] dt-bindings: bus: add CDX bus device tree
> bindings
>=20
> [CAUTION: External Email]
>=20
> On Tue, 06 Sep 2022 19:17:55 +0530, Nipun Gupta wrote:
> > This patch adds a devicetree binding documentation for CDX
> > bus.
> >
> > CDX bus controller dynamically detects CDX bus and the
> > devices on these bus using CDX firmware.
> >
> > Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> > ---
> >  .../devicetree/bindings/bus/xlnx,cdx.yaml     | 75 +++++++++++++++++++
> >  MAINTAINERS                                   |  6 ++
> >  2 files changed, 81 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
> >
>=20
> My bot found errors running 'make DT_CHECKER_FLAGS=3D-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
>=20
> yamllint warnings/errors:
>=20
> dtschema/dtc warnings/errors:
> Documentation/devicetree/bindings/bus/xlnx,cdx.example.dts:18.23-21.11:
> Warning (unit_address_vs_reg): /example-0/smmu@ec000000: node has a unit
> name, but no reg or ranges property
> Documentation/devicetree/bindings/bus/xlnx,cdx.example.dts:23.22-30.11:
> Warning (unit_address_vs_reg): /example-0/gic@e2000000: node has a unit
> name, but no reg or ranges property
> Documentation/devicetree/bindings/bus/xlnx,cdx.example.dts:26.35-29.15:
> Warning (unit_address_vs_reg): /example-0/gic@e2000000/gic-its@e2040000:
> node has a unit name, but no reg or ranges property
> /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb:
> smmu@ec000000: $nodename:0: 'smmu@ec000000' does not match
> '^iommu@[0-9a-f]*'
>         From schema: /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/iommu/arm,smmu-v3.yaml
> /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb:
> smmu@ec000000: 'reg' is a required property
>         From schema: /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/iommu/arm,smmu-v3.yaml
> /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb:
> gic@e2000000: $nodename:0: 'gic@e2000000' does not match '^interrupt-
> controller(@[0-9a-f,]+)*$'
>         From schema: /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/interrupt-controller/arm,gic-
> v3.yaml
> /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb:
> gic@e2000000: '#interrupt-cells' is a dependency of 'interrupt-controller=
'
>         From schema: /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/interrupt-controller/arm,gic-
> v3.yaml
> /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb:
> gic@e2000000: 'reg' is a required property
>         From schema: /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/interrupt-controller/arm,gic-
> v3.yaml
> /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb:
> gic@e2000000: gic-its@e2040000: False schema does not allow {'compatible'=
:
> ['arm,gic-v3-its'], 'msi-controller': True, 'phandle': [[1]]}
>         From schema: /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/interrupt-controller/arm,gic-
> v3.yaml
> /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb:
> gic@e2000000: gic-its@e2040000: '#msi-cells' is a required property
>         From schema: /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/interrupt-controller/arm,gic-
> v3.yaml
> /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb:
> gic@e2000000: gic-its@e2040000: 'reg' is a required property
>         From schema: /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/interrupt-controller/arm,gic-
> v3.yaml
> /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb:
> gic@e2000000: 'oneOf' conditional failed, one must be fixed:
>         'interrupts' is a required property
>         'interrupts-extended' is a required property
>         From schema: /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/interrupt-controller/arm,gic-
> v3.yaml
> /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/bus/xlnx,cdx.example.dtb:
> cdx@4000000: reg: [[0, 67108864], [0, 4096]] is too long
>         From schema: /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
>=20
> doc reference errors (make refcheckdocs):
>=20
> See
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpatch=
w
> ork.ozlabs.org%2Fpatch%2F&amp;data=3D05%7C01%7Cnipun.gupta%40amd.com
> %7C47f53d11f4024ba765f408da902fc525%7C3dd8961fe4884e608e11a82d994e
> 183d%7C0%7C0%7C637980832144301226%7CUnknown%7CTWFpbGZsb3d8eyJ
> WIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C
> 3000%7C%7C%7C&amp;sdata=3DBXO1d2OWdCQ1lb%2BEDNiUvmfSPPfxfzJET%2B
> uuAL9EdEY%3D&amp;reserved=3D0
>=20
> This check can fail if there are any dependencies. The base for a patch
> series is generally the most recent rc1.
>=20
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
>=20
> pip3 install dtschema --upgrade
>=20
> Please check and re-submit.

I did run make dt_binding_check, but did not see the issue.
Will update the dtschema and fix this.

Thanks,
Nipun
