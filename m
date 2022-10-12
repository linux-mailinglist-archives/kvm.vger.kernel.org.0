Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204805FC698
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 15:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiJLNiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 09:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJLNh6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 09:37:58 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4B0AC397;
        Wed, 12 Oct 2022 06:37:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HY+KCgizKu8SjAW3xSEUEMWcevzmsSR5wibCNDLFToxZAcSc4JJOIwc10DD2qrPGJcp9ulpMiE5fWS2UsrqF55BSyq9gsSUPPEJRStv1VoFD17KmXZCLjvwjuFQmvUK2Z5bPSGkwjZWtNozD5lsfxcVpkc8dxoENS5KGwYPtImnhULcroet/gEQbyY0YGyhiq+6q4Oldz+7xYBNhWEXq1AZNnrLlGVdscN7E9ijkr+K58g7sx99Ngv/xm2nYEw5GhjGtr/0JRyQa5xfe02SElK1ca85b0y4xipx8vwHoX61XUd1RGMFE9s/cHdgk5S4XiZpGiW8CtvfLZGJys9BV4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HkQB7ik1NPjjMUgy2wzjPqnXBe+TXKf+KNUss4JV60Q=;
 b=J3N5ulCkcGQeVhBerUMdHPH8YhTbsjjShA+RytyXRhzcp71mpEMuaF5shCe/GY0JF54ekUmXED3nGoFc3AlhHXawnEpTsMZAUBUA5HQZFwEBY7SEguFxbtZAPk4q3YnAy8qMlsYANW+NpeRfcgWru8FRlwbkg0wG5EQkq18QBFZUTRJ92nk2qXdN21rkcAL7xSDgJVusk2ykXZfWnr/g9rwdw9Gii1Wde4dUEexkzYOg6QSedmUgy+WRzTkzueVYKSsnpTkh1zeph2lrqZCbFJImjmIrNIf/P8ETetybFIFgEj47dUWD7KsrmIbfO/gOYA3ya93L5L9dYIcipYUnpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HkQB7ik1NPjjMUgy2wzjPqnXBe+TXKf+KNUss4JV60Q=;
 b=KjtrbS5kU2JAzoelIH+ak5Tz4pavXmWppRbh+xDysGfKDidK3gpeyrNOrUMxaA2ztSWlwXlR3sy8JypIZyqm41eRwGCNGC34h3igEahhXJJ3ALMJTqy3jxCWyR1W8LtkZgFto+kP1o+VeTzba6ToJkMoB1yLLTGfubzErVj3q6E=
Received: from MN2PR12MB4358.namprd12.prod.outlook.com (2603:10b6:208:24f::12)
 by CY8PR12MB7361.namprd12.prod.outlook.com (2603:10b6:930:53::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.22; Wed, 12 Oct
 2022 13:37:55 +0000
Received: from MN2PR12MB4358.namprd12.prod.outlook.com
 ([fe80::a094:c6b2:d306:d7bf]) by MN2PR12MB4358.namprd12.prod.outlook.com
 ([fe80::a094:c6b2:d306:d7bf%3]) with mapi id 15.20.5709.022; Wed, 12 Oct 2022
 13:37:54 +0000
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
Thread-Index: AQHYwfdzMPgE56itm0GRwc9i4G18eq3T9LKAgDbLT4CAAAON8IAALkeAgAACWFA=
Date:   Wed, 12 Oct 2022 13:37:54 +0000
Message-ID: <MN2PR12MB4358A871519748CD7A6DB7A089229@MN2PR12MB4358.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-5-nipun.gupta@amd.com> <87h71juxuk.wl-maz@kernel.org>
 <DM6PR12MB30820EE430405FF50C7F856BE8229@DM6PR12MB3082.namprd12.prod.outlook.com>
 <MN2PR12MB43586084670E14691920952889229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0a65a9leWXpKfTo@ziepe.ca>
In-Reply-To: <Y0a65a9leWXpKfTo@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-10-12T13:37:52Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=abcd11e1-cff1-41e6-a72a-dc11388fd433;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR12MB4358:EE_|CY8PR12MB7361:EE_
x-ms-office365-filtering-correlation-id: 5ea4e1d4-8e86-4fe2-b49d-08daac56f773
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GHuXlz1cHLvWXX3jIbIjZSYLqD9Lq6KRNse1U2sM7WRv9d8Ob8AyQBcFpR9egf5HjEsrHza5WXxsrZFaOCbby/NE8gO3b+WVbTrSuTJpYzHeLJbEpAp/X8gim9qG8BS6PJTVdTiEhQqCrTVsADq25r7p2IZK+ZZcmOIo4w96e6o/v+EbJ4gW5YrUeaYTMP9d86ynCdYYjDpyryDZT5d929zZ9aHGkSVEQpB1encDS9AdDYDAKaCFNfI4V0FAjneLRodTb8rRWaJqcEGv22cVMEsGGAijRCKYXByUVBkDXeZkkUiLxubOYUYFQRQkhyAliIU47ASOo8l0B1ea5JNpDdlK8uCUWLAMH3Zz0q0xNm0M5r4dtpK9jksYFL66wrgpOd//jTXS0j//kCOTtw55584ZxlFy2D7I1LHl9zBz66P/Uj0NRDu0A/Cbp0L+8KgzrG/yAv4hPCl/bhuSX74362AMgeM/bukTnIKiXVLiArUdaYFpSykZuwAy67aSqfQe5jbZpKUUepWTl4w366ahLZ150DS2UicbcyZR8MjBh0OPtvfiYF4iOja0UuYp1akL6CXhTqdg1eGkTr/oJ5fRei6nCpkD0yqTab6Bo0e8q2dbtGue/kBKBO4LQiGS6n7JkdwOsMIByaVEerIRLHHUNjVsjWGOPtFXblRKCWu+I38PqsN7KzrBQ6p/FeZ+F0TDPVvFgGLPrXXEUBiPzcS3OxoELSddzpOyOJGIwhxaBXAuREQv967cJ0siKKeyxpLONS1ZeI4HIAlbHnMZbBhU6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4358.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(376002)(396003)(366004)(451199015)(33656002)(38070700005)(2906002)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(55016003)(5660300002)(38100700002)(7416002)(41300700001)(86362001)(66946007)(76116006)(8936002)(52536014)(122000001)(316002)(54906003)(6916009)(83380400001)(186003)(478600001)(6506007)(26005)(53546011)(71200400001)(9686003)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aWM5lwwexeDHtuQS6DjM2JYkakBMesUB2tqESTBUkRlyQoEinHPVNd2o5fXa?=
 =?us-ascii?Q?PKLZWBQsHDEEnOCek1Fp5K+xbhiXyFAIaxXXJ7w4Daem6HFowAYEHHr6CYBy?=
 =?us-ascii?Q?0KDv3tNI3Gt++oyXFvWVgkCd7yZCG6KAYrj4tSu3fTyLR34ecYBtoZ92xG/P?=
 =?us-ascii?Q?liMcX9nzUGR3gN2Bc+Yy2Gy37lQFTkEARShaxPMC8moE/ebn98bfYRhdCubI?=
 =?us-ascii?Q?QNg1CHEyGrkz5agFodktCCcnnuNdGAANIzTvCBQ+FHU3aAfYB8PVoZXv3P61?=
 =?us-ascii?Q?onKGNX3CglfiajJgqUvRLBRuyWAxGZDNogds/DaErRP7vouYa8dti3b3JtPi?=
 =?us-ascii?Q?IpEUm5HIVSkFETkTnJZdDmugcWXLI8Yyh3GojOqSj/kOD4J/WMhCF7GY1hqz?=
 =?us-ascii?Q?Q+/Ye365U+i7tGMIdqdcC6cQ4k40wjCF6eC84RG15OMJPYzIi+788hOlH/hg?=
 =?us-ascii?Q?Sir9mKvVIRna7VSTN6FOFapxTbc5HqYvbmb9spG5QBLnWo1Xh/7ezDPfCnff?=
 =?us-ascii?Q?hO6Watk3vcMBEbo1z6nSL9bTfeTvWnMPv85v5rBxWs7S9cdGE7uSB7GQ0T44?=
 =?us-ascii?Q?wIe9E6xsmrz8+uoxwmvhg4TXHeEUP+uMQndtHw+QcTyoKBCUM4lxp9VQJWXF?=
 =?us-ascii?Q?3SnJnwxiVj/sg30DrGyBrBAQ4Uir/yDU0HlOqFLvH7jdWWMpYE4RZCKKtvjM?=
 =?us-ascii?Q?MyNS4tFA9Z7AXGekLvzinVmUHS/XrixLJ/EWkdsVL2XwkaljJag/m2iu0yEp?=
 =?us-ascii?Q?rVFu+hx4KvE61Z5jWQIn8aPaE6BwP/ru8kfCK2G6q2SYqL/slHyCZ5O6LWxE?=
 =?us-ascii?Q?EtmbRc3Ol/2ZTpFEtTR6+rgcH4zRvXuYwT2UeGIe8df6wMhDyIRwz2ZmSBPw?=
 =?us-ascii?Q?d3x384m8TpswrUCDU+2rrNb+JUmT++FN/M7Zgztkejt8j98RV8eS3ehiz18V?=
 =?us-ascii?Q?oLsMrbC+tEuTwT1tTvORTnOIo/e9FHlMwz+eeMFvQrU3xfzrBFS3Guppn16E?=
 =?us-ascii?Q?2LKBbSXLDkdqXbqfmpIu5/0zaqbVjyBoQ9n6TG5DAJnww9+7qsOtgncPm9v4?=
 =?us-ascii?Q?8Im9DBPfXgmO7K/GOL9ntkWlJteQVGfXNTO1qsp0cvpLDaTsIaQxJfP/Uc1u?=
 =?us-ascii?Q?ezQyxYkzSEcm7DVheh+gy186kAAsrwSatdg195x7nTz5wF08+t5V4lOvg+RX?=
 =?us-ascii?Q?xiHvsp3DUjb2rRoYmEaTG6GRnGdio6Qxhp768E4eQaOxy8KfULMCcGdxheJo?=
 =?us-ascii?Q?Ct5/h5hjvrS4vaRWBpkVyOxO2/zoF4QB3oEQrdz0sxxvTICDEaIPaGLQ/2YR?=
 =?us-ascii?Q?S+NcXXj0Hxdwe8Diir2dYD4NR6z5iQT8S3v3nbs6LHF2BaxROTUrJfWw8ydP?=
 =?us-ascii?Q?z2FMUaCc/yjAFLvgbpLAIImB1VMnarbv2BodNkFVu46MnZR9yA/FpXVQoJfr?=
 =?us-ascii?Q?Zz1e5smpQngcSk4QlQp2vYBWupvqt1P+jEYge4b2VetlpZLe8nH1V8RdWA1v?=
 =?us-ascii?Q?Ne0yUprwI4FKJFAYO3frZBLKOf8EJX570V4qLd8LpBh7FQZP2VEeadbjIPlP?=
 =?us-ascii?Q?1djg8xRHlX4lUJIMaXk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4358.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ea4e1d4-8e86-4fe2-b49d-08daac56f773
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2022 13:37:54.4910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jt2u7HTC27t88408hocAEV1gqNtibN58Irib/Wa7PjX5BXt5mxzHvVcS5zfBqKf/LXK6slTNIxcrJEnINuY3Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7361
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
> Sent: 12 October 2022 14:02
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
> On Wed, Oct 12, 2022 at 10:34:23AM +0000, Radovanovic, Aleksandar wrote:
>=20
>=20
> > As for GITS_TRANSLATER, we can take up to 4 different IOVAs, which
> > limits us to 4 CDX devices (should be sufficient for current HW
> > use-cases). Also, it means that the address part must be the same for
> > all vectors within a single CDX device. I'm assuming this is OK as it
> > is going to be a single interrupt and IOMMU domain anyway.
>=20
> This is not at all how MSI is supposed to work.

In the general case, no, they're not. However, this is an embedded device
with a GICv3, so the general case does not really apply. On GIC, the MSI=20
target address is always a fixed register in the ITS (GIC_TRANSLATER),=20
possibly SMMU translated. As long as the translation is consistent across
a single device (and I see no reason why or how the kernel would do it=20
otherwise, given that a single CDX device generates the same StreamID
for all MSI writes), the GIC IOVA should be the same for all vectors of=20
the device.

It is worth noting that this limitation is not going to be baked in the=20
proposed MSI configuration interface, it will still take both the address
and data parts for each vector. It is just that this particular=20
implementation will throw an error if you supply a different target
address across device MSI vectors. It does not preclude some future
device accepting different addresses per vector over the same=20
interface.

Thanks,
Aleksandar

