Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE505FC3D0
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 12:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiJLKea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 06:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJLKe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 06:34:28 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2040.outbound.protection.outlook.com [40.107.95.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15C4BBF3A;
        Wed, 12 Oct 2022 03:34:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ib66tedVGxRIYKaBLRSeka6eFIPYKI8dz2MIJcazeBXE1gqEmGXT8AqpWvBcYD6dDgrYpdDmuFhdyh90a8PMa0Dg22hpgqzYE1tsT1ZQMGDNKMeJDpEyTXYGolChI5W+IMvAx/PkIHf4SLN+jn/UL06vPPjQmcWt0TFPZu5Cf2/UTP3H3MG0cqK5DLkg+wWufvkT9sF3oMnEQQ03AurytTx3Vwwpks6HmHDveKKGuj35wh8tDN6a7V7eh2du7QxvLp8bGP0yXWDTD88taVDJAMWtrXEIM5h6/UQdVsgWaQdC1a9AE379VkWIWLmbsRS5HOgm2UfswGLdkTYhz0KEhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8H82YeQdZ65jmCLPdhwfvGTkwVlz1+X9NsJMnlrlKoU=;
 b=Y77lDrlf6nSK2VliO9AxbtZWgzN3VZOVJtaQ7zBGI99+/aoHI4yt0CMmkq4p9OrOuFoE4txGpLIN3LPf7xQSsN/j6HwA68XHoiUBnPWlREji5ROmxzCAZOkBXQV5HyfkCaP3ZsYzF17IOcxhio/8oaR2DRemX+VjZSwl9Z3hUncFsX5MGryZ4ShI5kZdio9m3YHxrbKk1r0eo5VjPZsN1H8+jlCB0/5NSH3oEyG2QftfQvpaW5eETD6utPNdXeo9KvGt8jYoOg2u1IXrlsQukKMYj4I1yR4m5ykzuUUg+AUpcOewXnTGpG0/hL5qEw12okgqFDdg7Nfmftbk55ukcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8H82YeQdZ65jmCLPdhwfvGTkwVlz1+X9NsJMnlrlKoU=;
 b=xHSqyQrnIDAXBYW5oWZouCb2nJ0xlOv3exZlRErVGqbyBHe453U4calJl3ltdIS3EOh1IyfQbD25+Z/DaCMRSZMQU/xIAKfztXLUOy+7b0dzHCx8e87EC7/Ty3Aq3Mn1BX87oI2QSFQ7kNL7hLjeCwyujO3hBmtJKW9+ncrQSgM=
Received: from MN2PR12MB4358.namprd12.prod.outlook.com (2603:10b6:208:24f::12)
 by MW6PR12MB7085.namprd12.prod.outlook.com (2603:10b6:303:238::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.19; Wed, 12 Oct
 2022 10:34:24 +0000
Received: from MN2PR12MB4358.namprd12.prod.outlook.com
 ([fe80::a094:c6b2:d306:d7bf]) by MN2PR12MB4358.namprd12.prod.outlook.com
 ([fe80::a094:c6b2:d306:d7bf%3]) with mapi id 15.20.5709.022; Wed, 12 Oct 2022
 10:34:23 +0000
From:   "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>
To:     "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Thread-Topic: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Thread-Index: AQHYwfdzMPgE56itm0GRwc9i4G18eq3T9LKAgDbLT4CAAAON8A==
Date:   Wed, 12 Oct 2022 10:34:23 +0000
Message-ID: <MN2PR12MB43586084670E14691920952889229@MN2PR12MB4358.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
        <20220906134801.4079497-1-nipun.gupta@amd.com>
        <20220906134801.4079497-5-nipun.gupta@amd.com> <87h71juxuk.wl-maz@kernel.org>
 <DM6PR12MB30820EE430405FF50C7F856BE8229@DM6PR12MB3082.namprd12.prod.outlook.com>
In-Reply-To: <DM6PR12MB30820EE430405FF50C7F856BE8229@DM6PR12MB3082.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-10-12T10:34:20Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=9eba8937-eed0-45ce-8661-54be192ea195;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR12MB4358:EE_|MW6PR12MB7085:EE_
x-ms-office365-filtering-correlation-id: 3b83d138-3afc-46e0-f359-08daac3d5474
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tGIs1GPXWNxXkDB1PLqtVQfeD0c6+OUhy4UVdmZlg2f3ZlGohzOL5tCDvzO/VEINeIu/TCl1ZDh1FXMFs3eXKe9+dP0fcGQqf5rvKbsgLGMyWwjZMPSFAlNOvVxT6bC6qN9po+SIMl9+5req6ro6hTJlZ6xjSuKGyJHZDcOqQgZ18wXPKYaDpmAlnD6uTooXZYcXMWdp7Ths4XoM/61intwa6puRLc4lzhWuM59h5AWxnmOLywOjBQ43sGzc0Dm13PTbB2TgDegRcocH5qlRnHqWKrkudvn2kvpnmz4t/pa7tt3Y5jfEYls3cIjk0VisNkjszhvXjR/orZXwPYZ22pWtZDm9ib6sB/36HdNGh5nX3to5uajjz6cyz3nxuj0jMLYFYt5/q2Oz9ChEO7GBmH4vQ1usxFQSl7JuCMIoDQ/7NgVwDVN2apLecagA/KT/UFhsxr0r+WGX/BlAG5qat8Ddm90SzwYlMhJzzkX/6sJCeY+j0Rh9dhRBuuSxWTED53FTlERsnsLow17hEuDemN6vnwpFsbQmkbhH8Yn5NxG9LaGqWhHdk0uAXm+EEmm8lpDaek/ViADCZ6z9txxk81x+xuGgruvHczA6lep8LLUf9VZxiNhhRbBfBeTKC/SBGgXwRL5NU/TRDFraD29tgAQMPX3psGgDKai38Ht+doA4EjZw4MunWQtzz478rdSTedfaz9RL/ZDnMs8ZqVmUWq7NQuRwT/NUEedOJDeVvg2U8mR0KwFgUCldBGVnC5D5zZIOA2H6Lh24N35Ye9G9qg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4358.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(451199015)(33656002)(86362001)(5660300002)(7416002)(38100700002)(122000001)(186003)(7406005)(38070700005)(2906002)(6506007)(7696005)(478600001)(76116006)(26005)(66476007)(83380400001)(64756008)(66946007)(8676002)(53546011)(316002)(66556008)(66446008)(52536014)(8936002)(9686003)(4326008)(41300700001)(110136005)(71200400001)(55016003)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2TeRKvfOr8/o5qM8NkQ3YxH7GFgxaMo+to9zGqep7/rmDem3sF25dW7pHLgL?=
 =?us-ascii?Q?vE1dhkR6AbXyPoCBdy3RLPaMbTpWrvWqDqSlZ4AUrhHcWn5/nvmQET6rEHNp?=
 =?us-ascii?Q?rbNmiRVQgaXXIhSy/FDsvXzv76ei2IlpAhYW1LJ4LgMVtJ9ttJK/dG/qAxjd?=
 =?us-ascii?Q?7SGo3bI48RmlW/fIMjbLZm/Q2Erk9cAwnqqOfBvUpRsP1CDMfQj/5glaKHud?=
 =?us-ascii?Q?+5+YMnz373BycLKfYL43jKNuboN7L4o1mQ4q3og9121IHmFdBoiqnBRQug5c?=
 =?us-ascii?Q?/ZUQXGpZqw0DNV9sTqR67xlyYrxmzC95zQH+tmfPpCcKiqDXfPWmRIrYTIJd?=
 =?us-ascii?Q?wl2mRKJSFIWuzhwR7RcFCmRryKWRhL7lD1fouiL/RZqOt0VmMb//Nh1W5zqe?=
 =?us-ascii?Q?dtyUmZD17yUth3QHc+aEE4xXbDekLcp7HiWS3jmjUZlsXhKac+ZoYRbScym+?=
 =?us-ascii?Q?jU719nueW/n7eI88VwBpOv6v9zZgpmHfkqho7QVxIeqqwZXSBxn2otUeRD9q?=
 =?us-ascii?Q?baWRQMronvnrDkzVTh3PGmQh1i3nqexSpTGFGp/vosmrKX1eo+4GVDBnOYC8?=
 =?us-ascii?Q?hiwymGfGR7ej8mprwdQ4DCbMks6hBRHgTiOc+Tg+xfynqGiE1fz8VWQWOXq1?=
 =?us-ascii?Q?tbCCNzDA2SUs4aHG+UN5BYB6YIYgemY8v+g4ZYZnNzzRzrVvzbPly1qBfVPI?=
 =?us-ascii?Q?2xtyHz2stxAv6acDWASGNwzV0XxupODYiJDoYylfa0iamT49baIuSbCvHpC+?=
 =?us-ascii?Q?ZZzfV3CWnVWkbgz2SzbALNtZoLRXZEEOvdlfn3V6bkZ7l98Y5JkXj+O6DFHH?=
 =?us-ascii?Q?7Prl2lISaQXwVLRh/1jCceKhRv8oisoVse4LtHCI93pMGTaBDheofewaFWsJ?=
 =?us-ascii?Q?c2aSE+JXXKOaR1snQO36erCZBG7tAZC1pR+1LznfYMfT7DEd3JZqzuNSDlCR?=
 =?us-ascii?Q?gzm6+mwKRVWnh7zWMfn4kWIWvfAS927y/mrq+qw8gaxcgoOJnIT6Odq8lX/n?=
 =?us-ascii?Q?N9rczlkZWd3YuNNS7rNqAbuWLezhBuL7F2Z1sV/IDnV2Z/dOmvJmx+YX3jgI?=
 =?us-ascii?Q?iA8IRCA4iEDBUYY3yR0wJUm4fbvqh8IdeVkZrpiMUZDrit38YceyvbkR09kZ?=
 =?us-ascii?Q?eiGACzkqvqP5TErotLF+3O6CVQZSFsvi9XDLPL2V5CpaamPBBuPpDZWyd02O?=
 =?us-ascii?Q?YuSndh6huR1eT4GhYOuGSbhNTyX8yujQqIKKF8bq9GxyToF8DhCYd946/kME?=
 =?us-ascii?Q?Iw4BlDMJ5Tyxnc0j1eAIs8Ikqtx0fLUqfQz2C1GniPeJ78JJjMxLwEMdII85?=
 =?us-ascii?Q?VEMICuFVbLU7gXLm02VCVLgJ5dxyaJyXKO+nmRUq6exv5zTh7ClFlDQ2x+Mb?=
 =?us-ascii?Q?RM5j4/5QINTzucq3Q+bZbXTX0BBEwBwMiqPzMBIY8IKaBeF5myKW/Tb76PCd?=
 =?us-ascii?Q?K5YGql2Mk9mZlKUy0z4IYX4GS+Fxxle1oBQX602N7aQw367MoOZdlOE8lSEU?=
 =?us-ascii?Q?T7uk4X6/O17jwZjNwClHaDvCbUuOAuczHBF+ImDFGeOYhYUnnjkY6LYyS9hd?=
 =?us-ascii?Q?59vu2MFEQXCEKzqa4MI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4358.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b83d138-3afc-46e0-f359-08daac3d5474
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2022 10:34:23.5656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ELffysMwAJdlZA241Xg/NGPlR2Fev9/lxctBBjyCLdnIHeywujRXkpyldZu+itHmEyavcuGsio1zpWQ16163Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7085
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
> From: Gupta, Nipun <Nipun.Gupta@amd.com>
> Sent: 12 October 2022 11:04
> To: Marc Zyngier <maz@kernel.org>; Robin Murphy
> <robin.murphy@arm.com>
> Cc: robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
> gregkh@linuxfoundation.org; rafael@kernel.org; eric.auger@redhat.com;
> alex.williamson@redhat.com; cohuck@redhat.com; Gupta, Puneet (DCG-
> ENG) <puneet.gupta@amd.com>; song.bao.hua@hisilicon.com;
> mchehab+huawei@kernel.org; f.fainelli@gmail.com;
> jeffrey.l.hugo@gmail.com; saravanak@google.com;
> Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
> jgg@ziepe.ca; jgg@nvidia.com; will@kernel.org; joro@8bytes.org;
> masahiroy@kernel.org; ndesaulniers@google.com; linux-arm-
> kernel@lists.infradead.org; linux-kbuild@vger.kernel.org; linux-
> kernel@vger.kernel.org; devicetree@vger.kernel.org; kvm@vger.kernel.org;
> okaya@kernel.org; Anand, Harpreet <harpreet.anand@amd.com>; Agarwal,
> Nikhil <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
> Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>; git (AMD-
> Xilinx) <git@amd.com>
> Subject: RE: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
> domain as parent
>=20
> [AMD Official Use Only - General]
>=20
>=20
> <snip>
>=20
> >
> > > +}
> > > +
> > > +static void cdx_msi_write_msg(struct irq_data *irq_data,
> > > +                           struct msi_msg *msg) {
> > > +     /*
> > > +      * Do nothing as CDX devices have these pre-populated
> > > +      * in the hardware itself.
> > > +      */
> >
> > We talked about this in a separate thread. This is a major problem.
>=20
> We discussed this further with the hardware design team and now have the
> correct and complete understanding here. As the CDX devices are FPGA
> based, they don't exist yet, so it would be possible to construct them in=
 such
> a way that the eventid is programable.
>=20
> To make it generic for CDX devices, we have added a firmware API which
> provide the mappings (MSI vector ID to eventID) to the fabric, that can b=
e
> referred by the device while generating the MSI interrupt.
>=20
> Also, there is an existing table to have GITS_TRANSLATOR iova address
> (address in
> msi_msg) for CDX devices, which can be programmed by the firmware. So,
> providing IOVA address to device would also not be a problem here.
>=20
> We would be rolling out RFC v4 with these changes soon.
>=20
> Regards,
> Nipun

Just to be clear, there will be some HW limitations with the proposed solut=
ion,
so let's just make sure that we're all OK with it.

For the MSI EventID, the HW interrupt logic assumes the MSI write value is=
=20
equal to the MSI vector number. However, the vector number is programmable
for most (all) of the interrupt sources, which isn't exactly the same as sa=
ying
EventID is programmable for a vector number, but can be used to emulate the
desired behaviour, with a translation table in firmware.=20

The limitation here is that we support at most 16 bits of EventID (and this=
 still
needs to be confirmed for all interrupt sources)

As for GITS_TRANSLATER, we can take up to 4 different IOVAs, which limits u=
s
to 4 CDX devices (should be sufficient for current HW use-cases). Also, it =
means
that the address part must be the same for all vectors within a single CDX=
=20
device. I'm assuming this is OK as it is going to be a single interrupt and=
 IOMMU
domain anyway.

Thanks,
Aleksandar=
