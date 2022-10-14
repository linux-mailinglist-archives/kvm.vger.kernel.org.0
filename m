Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C312B5FED1D
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 13:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiJNLSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 07:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiJNLSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 07:18:42 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2082.outbound.protection.outlook.com [40.107.212.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A5B1C6BE7;
        Fri, 14 Oct 2022 04:18:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gcQHbciZ99QZc5mlNtoFAzpGbtB40OdmZJXvhnFidJqbkOKtCGXHzv6TkE7u31J1nxmRZofZBfZU5tFjojxuinlbIz7mAGKwriswCa1GWn44SEN5fDQY8iFNGlI3PWYi+kYBUWGFqur8ISzMR4BpCdC83u3OXuu0qCuFRAYWpNCtwR8aM774aDjsU07lEpgDwXFZPAKO9+54bpgSGSAVEblw14dlgBC9LkN9UVHcBJmBf+5bQtLjUvz+XYtbNNhh0rrCKjf4fTUaWmHrdSIK3ZVmddSUIokQV4ocbJyTOnB+u8y1Y0cXEoRahQN60CEWDxyZbdbTVw3f2ZDz0MpU3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XjpH/BiRkw3E8RcVj3KkpRFkTYEzyLYgneEGbULrQdc=;
 b=NgUzsxtxCCrBDAe1pKyi08nNMnmhlo+9aMOCT/r7dcXUlOo/ZBFKFRy1HtnJ2eC8ScZS0pxUKA+3YS5uMC3Dbdrw99WrfR8joq57DwxVJZ1XSeyApxbhCsD114axlb7ZR2iBfefSxfTUA6zm+AgP3WUQYUU69Bj/zA8ovy88Cz0YIWwWcTbOMwaVXQww3G3wg6pIO5b50FXzYFB86kZG2mblvQJ1F39Mo+lloWRzSu7g9DW1gjl+tD/W5u739jF8BsS8u+QvedMBpEQ/UTnUZr+Cikz8eq0F1sztI1kar3ACjtKOVlBYdLKhe+upbKIXswbFUJk661PoRyJsSbDrTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjpH/BiRkw3E8RcVj3KkpRFkTYEzyLYgneEGbULrQdc=;
 b=0j2GTDsb07g1rMUk9JKx4jJNSKXm8Qvs1gMw+AwSPqGPio5ReuCq28QAsZGDg3KqeDtjX5yDKXyMMgMhhd6WfCVAoUx56A2Fxnu9m4IFQxsjPJwdASQ7B8Xgt1cu33R5g36j/Crp0YHol5Zz5mSrmBzQ6kzzV1nl+3/B0reYVxs=
Received: from MN2PR12MB4358.namprd12.prod.outlook.com (2603:10b6:208:24f::12)
 by BL1PR12MB5192.namprd12.prod.outlook.com (2603:10b6:208:311::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Fri, 14 Oct
 2022 11:18:37 +0000
Received: from MN2PR12MB4358.namprd12.prod.outlook.com
 ([fe80::a094:c6b2:d306:d7bf]) by MN2PR12MB4358.namprd12.prod.outlook.com
 ([fe80::a094:c6b2:d306:d7bf%3]) with mapi id 15.20.5723.029; Fri, 14 Oct 2022
 11:18:36 +0000
From:   "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
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
Thread-Index: AQHYwfdzMPgE56itm0GRwc9i4G18eq3T9LKAgDbLT4CAAAON8IAALkeAgAACWFCAABh6gIAABiXQgAFsD4CAAWkgkA==
Date:   Fri, 14 Oct 2022 11:18:36 +0000
Message-ID: <MN2PR12MB4358CF6B6D2576B35E39328A89249@MN2PR12MB4358.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-5-nipun.gupta@amd.com> <87h71juxuk.wl-maz@kernel.org>
 <DM6PR12MB30820EE430405FF50C7F856BE8229@DM6PR12MB3082.namprd12.prod.outlook.com>
 <MN2PR12MB43586084670E14691920952889229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0a65a9leWXpKfTo@ziepe.ca>
 <MN2PR12MB4358A871519748CD7A6DB7A089229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0bRZTP9Kc6mdCiu@ziepe.ca>
 <MN2PR12MB4358277977C1B7E0BC214AC789229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0gH8R8tEqn6sqZ5@ziepe.ca>
In-Reply-To: <Y0gH8R8tEqn6sqZ5@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-10-14T11:18:34Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=b09f937e-8828-466a-8cd2-d1a3be9be6da;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR12MB4358:EE_|BL1PR12MB5192:EE_
x-ms-office365-filtering-correlation-id: 9fccf871-433d-4f99-e221-08daadd5d6c6
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2Y78MBqq9uQEJntw9iEGn+kyRX5QgtvjhNcDoeTT3+efXxRtAlhZ8uyjp0SR8QZ0P+9nIhxpuROk5l2NC6K1XNbHmmnMlFfDlDAyHGFHAEdeXhRiem+SkBLLh8HaQq1jYsjj1qktSX94bjtswXre0OPyXGgkrEwIPGR1eKDqH2g8Yc5jxp0kDOip6DOqnIOzKdT8/rVosv9r86WVgJsEqwVtrkCmG3nkO1ghRrewC52CFcjCF2VoPaA9r2pp15ABoVTXiIKyhe/htF2mz257lEXo7PnIwTiSQdmxnZmYw955PQVUe8DuXGfur8JZNK0zg3w/d0zFitW56VpddKKBMT6q1ZC8uQupb2GT6lQxvSiIPIlHWd4UHafD/+OU/JrHj9dRjIdzBTuPTR6PpYzc/JCqTnxsjLruUsHJ24NlrpKIqkRj68yXqUg9BiOkqg8zu27lbWbKKGBt6Z0x2y9UFwwCBL3p5DD7sqoG3wjSX/y6y2EQLWwecygfFzgJmK+G9EDt05DHTbEJVMlQ8Ijjr+WQv/NxQ5xItaF061+kpkAtGsiKTNE3nkbZQrIAM0pXewp1QdJeRwroVFhRKCppVg558Vmo8jN4gSh8UzBEDH44MNeKRVaKdTnFGSPbJUalguBuQBQjDsJYjDxBNrRRV1LGtnyNt0n4/j3Kl8V0L1QSan+hK2pqrAT05IJYa4tzc6JNd4d0RTqjQjq7j8zBWN6fDDt/ZjpcW90iNBefpV/tbZC5333abZI00VrevsiYA6nP8ccibeMw2n1tYO5oVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4358.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(451199015)(66946007)(76116006)(38070700005)(83380400001)(71200400001)(2906002)(4326008)(8676002)(66556008)(8936002)(66476007)(64756008)(66446008)(53546011)(33656002)(7416002)(9686003)(41300700001)(5660300002)(38100700002)(52536014)(6506007)(7696005)(86362001)(55016003)(54906003)(122000001)(6916009)(186003)(316002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?svwoalLmm3J87fO+hCtYmVcCZoETsX6y9KBz7BmvCVlDy0a8wNTUioVkOt7K?=
 =?us-ascii?Q?E2tgGEi56W6q8WhCcRrC8uZEoQVe61QevsXF+uLOB+4uI5pX3rklK2LXzdT9?=
 =?us-ascii?Q?slPJ4LapH7Yrfy2Skxhy3rPS4sfS0UH6VZVQ2HvTkxn5C6Wb8qd1G5mgSNoU?=
 =?us-ascii?Q?UajpTrPkHviOprmiA5mLDvQTQhhojbM6G01cl9YFgmtOCFkl5PLXTEZA4FAI?=
 =?us-ascii?Q?QyC5xD6sx7YDTZgG+LvjquyKyaAPzPedgaFCgioo5mUPEMbH+uYUmihreuwa?=
 =?us-ascii?Q?rSDMIyXxQxsIBLXf4NXPP2TxafuGFp37o4NXIGhTBL+/2+mtzQ+utlPbA5XB?=
 =?us-ascii?Q?+biaupNIqD62IEg21fnnMGwiG6D6V9u5BHH3pVljJ/1rTBUfuA/WcGSpS7v1?=
 =?us-ascii?Q?dItRAtH57OnETHPFG9TUP4np8Jo4pV5HwL3wHOqV0TPU/lsN6x5sq+Ju/FKx?=
 =?us-ascii?Q?N/2qJwAEUBUkVqJu30VFrGFo861BK0ElKfRxaMX2JD244wc2wE9mNHMM25no?=
 =?us-ascii?Q?FshcGMU3yGe0HsK3om+D4v9KKAgw5sP0kA7HxgmaigQu+9Y6JYZTgmls3glp?=
 =?us-ascii?Q?j1H0MLm2dBmQPCXMmqmVNphOIKFZE0LcPqzojG0UuSfBwRWDvZxr281O0kZi?=
 =?us-ascii?Q?70prFLNZ6jOtLosAT18aOFPKxDFziAnFOXdlIfH5Ea8rDmMSNZoRuJ4POI+o?=
 =?us-ascii?Q?0Yy9E3cgnsrVU/5YZJ/cID6KXSCNf9pDngfBCY09msRZmvHemFnGzEUkvsrP?=
 =?us-ascii?Q?mGrj528JYMk9J+NQXSA9RCUMimjwMa2HoumfgqYKfOW9HPRLG3uQTxjqVtN4?=
 =?us-ascii?Q?TSMFMjsWFObXFh7NYU4VG/7BWsI7xgBSLkYx7K6w+N4sQSJ8bZOJlmijNb08?=
 =?us-ascii?Q?PEKlqGQD3X+NZ17a7S7SkA8V2wNVe7HkRJ7pJfKlf8VseaRCcyfPcYwosrcO?=
 =?us-ascii?Q?dVTPWVWjI1QMh5/mqMJbU3m2M1pZAurvzgKN5jX+bWjjzM5+CWKYkwDCMwdN?=
 =?us-ascii?Q?4uwq7RPG/1VjjPR4pEF0GrWQvDMtU/OEOlfMazqjJWm6CDe6YFNfFypZQF/i?=
 =?us-ascii?Q?Ra0wGg24scfphAoS97xETDJIN/X/RLQVgd0YLJMwiiQ2EfJtqxNCWWmYoXjW?=
 =?us-ascii?Q?HX9A4csSrakXaucmDCmIyRI7ThvtW5+DfnP8MlziYZnKKjTVvKvag7iFmj8P?=
 =?us-ascii?Q?jyMEVwCwXRYJRggqyfgamrpF0aNGVU+M5kv5pHMHm5a33dzm5eTP28rfOmkU?=
 =?us-ascii?Q?AoSH+maQLICBd5QyVVqnycUd1D9CczSegfk3cAsZbRCK0CdNBa11MBOjK0AP?=
 =?us-ascii?Q?JfWLUqKENCF/MMxdGITUJ+qkIjuTYwlVpFXsW6H69a9g+GkNh6T2NWzd91UL?=
 =?us-ascii?Q?sql+IkbSB3E9gbH1PGfjapybqdEc8r6K9ZnW5Kn9DtSSRXM5bydrhrbJ8vpb?=
 =?us-ascii?Q?u/+1U47t0K00P7BTO1OZ0vH1DPFaafrPH0XtQON8JPlnoFP17bpeUXuYeZV/?=
 =?us-ascii?Q?ZeovsJzMm14mreuDUATYG9kDQBqAFORtB3NgfyH5aniMD66fY83CXz9rzJiQ?=
 =?us-ascii?Q?+khAwwVK6qnlgytXNnt8F4/uzkgBbciLFKGzdr9Rc2LS1mB528UOrphpiLrE?=
 =?us-ascii?Q?JthUcc0i7dLskZaQPoFM0eM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4358.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fccf871-433d-4f99-e221-08daadd5d6c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2022 11:18:36.8875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P58BPxVa5HQX6wy8OyRsMWX6hKl6xs3VI+VtEkm6stqUw3S4AqrDuPN4UQXk13bICVzda8afFnf2v2MSFAXvIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5192
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
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: 13 October 2022 13:43
> To: Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>
> Cc: Gupta, Nipun <Nipun.Gupta@amd.com>; Marc Zyngier
> <maz@kernel.org>; Robin Murphy <robin.murphy@arm.com>;
> robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
> gregkh@linuxfoundation.org; rafael@kernel.org; eric.auger@redhat.com;
> alex.williamson@redhat.com; cohuck@redhat.com; Gupta, Puneet (DCG-
> ENG) <puneet.gupta@amd.com>; song.bao.hua@hisilicon.com;
> mchehab+huawei@kernel.org; f.fainelli@gmail.com;
> jeffrey.l.hugo@gmail.com; saravanak@google.com;
> Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
> will@kernel.org; joro@8bytes.org; masahiroy@kernel.org;
> ndesaulniers@google.com; linux-arm-kernel@lists.infradead.org; linux-
> kbuild@vger.kernel.org; linux-kernel@vger.kernel.org;
> devicetree@vger.kernel.org; kvm@vger.kernel.org; okaya@kernel.org;
> Anand, Harpreet <harpreet.anand@amd.com>; Agarwal, Nikhil
> <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>; git
> (AMD-Xilinx) <git@amd.com>
> Subject: Re: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
> domain as parent
>=20
> Caution: This message originated from an External Source. Use proper
> caution when opening attachments, clicking links, or responding.
>=20
>=20
> On Wed, Oct 12, 2022 at 03:09:26PM +0000, Radovanovic, Aleksandar wrote:
>=20
> > > On Wed, Oct 12, 2022 at 01:37:54PM +0000, Radovanovic, Aleksandar
> wrote:
> > > > > On Wed, Oct 12, 2022 at 10:34:23AM +0000, Radovanovic,
> > > > > Aleksandar
> > > wrote:
> > > > >
> > > > >
> > > > > > As for GITS_TRANSLATER, we can take up to 4 different IOVAs,
> > > > > > which limits us to 4 CDX devices (should be sufficient for
> > > > > > current HW use-cases). Also, it means that the address part
> > > > > > must be the same for all vectors within a single CDX device.
> > > > > > I'm assuming this is OK as it is going to be a single interrupt=
 and
> IOMMU domain anyway.
> > > > >
> > > > > This is not at all how MSI is supposed to work.
> > > >
> > > > In the general case, no, they're not.
> > >
> > > I don't mean that you can hack this to work - I mean that in MSI the
> > > addr/data is supposed to come from the end point itself, not from
> > > some kind of shared structure. This is important because the actual
> > > act of generating the write has to be coherent with the DMA the
> > > device is doing, as the MSI write must push any DMA data to
> > > visibility to meet the "producer / consumer" model.
> > >
> >
> > I'm not sure I follow your argument, the limitation here is that the
> > MSI address value is shared between vectors of the same device
> > (requester id or endpoint, whichever way you prefer to call it), not
> > between devices.
>=20
> That isn't what you said, you said "we can take up to 4 different IOVAs, =
which
> limits us to 4 CDX devices" - which sounds like HW being shared across
> devices??

And that still does not imply lack of ordering or sharing of MSI target add=
resses between devices.

This is a highly programmable IP block, at the core of which is an intercon=
nect interfacing to programmable logic (PL), a number of PCIe controllers (=
either endpoint or root-port), DMA engines, offload engines, the embedded p=
rocessor subsystem (PSX), etc. DMA and interrupts can be routed across it i=
n almost any (meaningful) direction. The datapath 'endpoints' request DMA a=
nd interrupts, but don't concern themselves with the mechanics of deliverin=
g that in the target domain. It is the responsibility of the egress bridges=
 to the target domains to convert the interconnect interrupt transactions t=
o whatever the interrupt delivery mechanism for that domain is. E.g. for PC=
Ie controllers in endpoint mode, that would be through PCIe MSI-X tables in=
ternal to the controller (and managed by the PCIe host), for PSX that would=
 be the PSX bridge (partially managed by the PSX OS, mediated through firmw=
are, i.e. through CDX bus driver) and so on. It is the responsibility of th=
e interconnect to maintain transaction ordering (including DMA vs. interrup=
ts). It is the responsibility of the firmware to manage the bridges accordi=
ng to the implemented use-case, so everything works as expected.=20

The CDX bus driver manages a single aspect of this and that is endpoints im=
plemented in PL/engines, targeting the PSX.

So, yes, the hardware that translates interrupt transactions to GIC AXI wri=
tes is shared between endpoints, but what I said above still applies. And t=
hat doesn't necessarily make it weird/wrong, it's just more complex than yo=
u might think.

Anyway, I think we're straying off topic here, none of this is visible to t=
he kernel anyway. The question that we still need to answer is, are you OK =
with the limitations I listed originally?

Thanks,
Aleksandar
