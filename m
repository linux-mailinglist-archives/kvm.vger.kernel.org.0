Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8977E5B193A
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 11:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiIHJvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 05:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiIHJvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 05:51:06 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C728D112E4F;
        Thu,  8 Sep 2022 02:51:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zb/1tTcar9csLBASRrhekwOmTrO5iZjJUNsFQ2jvqREoR26D3y3PTFUsKlwcggiI432mzWt4byvKFYLd8zYaVL2fnQkCgeDHScJhQQQKU/XOJi6B+UJwMglDU+41O+hHeMxphI2x0f8imG6dLCdW4+cxxlCT0D80gzuRaJYAZGf52X8zByjL2voP/nj4QyDOraSm8bFYabzmgFm2kb3nyhGPcNg4g8UmXdF6JDwR2LVt3ejLeiEE6x3T0W21KwuGawNXRQi5kVm0X3ieiyXv4iidAT1xrgquaHwyjW6bsLEKmLjW0jgFAn1nxlv8g9BceVvaD5d9vtvk8u7Rx7AqOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FRzcL2YdO8eswqfs8I7TxcYA1ay3b9JJl1YIc5lRndU=;
 b=NvsdsH0iRAXt8idini0DXWbaiX2R2aarbE65My3dLmyGGCMxE6MYQvyPv6wSxEAbI6rUtBzTyXsWPhUBEkVPu+MUXVpFX/6AzZkgrhp+ydCergMVJxca9/inJMwSuQGZv88e+tZpTFlgmiYr1HCgRd5QRMoLyEZMW74O7lrF88Dzk8DKeG634b/YPPubJiUqqIto3+Fn77Jw9hhGAOnFHcH/S1Vpzqoy+xfbMV9jIpVBnaQODo/r3CI8Pr9dQmdGTtzCguYu9BFrh0J8PGOw6HI+DY55IiUu6/p6UXkwd+vGANmpIjKQRqp3ymPpoP0aiUHlMzf6qeTaUTI0SRuxMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRzcL2YdO8eswqfs8I7TxcYA1ay3b9JJl1YIc5lRndU=;
 b=lcW7Y8zSYh38AgZVC5ljMKR1BRk7ziKPdN33kK43aWgV0DuyVgEsXJkQGFnqlYwphGOKrwpbhk8EtZcOTuFMs2jm3+pVlkorXhfzYRppQQErlHbiQcdYm7WfQDZuqbJaXKMJQmFvQC+R/ViOB3tqIKDZXN1N40eKbhJ64NgZxEQ=
Received: from SA0PR12MB4365.namprd12.prod.outlook.com (2603:10b6:806:96::22)
 by BY5PR12MB4999.namprd12.prod.outlook.com (2603:10b6:a03:1da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 8 Sep
 2022 09:51:02 +0000
Received: from SA0PR12MB4365.namprd12.prod.outlook.com
 ([fe80::2dc0:e8ec:9841:dcc]) by SA0PR12MB4365.namprd12.prod.outlook.com
 ([fe80::2dc0:e8ec:9841:dcc%3]) with mapi id 15.20.5612.016; Thu, 8 Sep 2022
 09:51:02 +0000
From:   "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Gupta, Nipun" <Nipun.Gupta@amd.com>,
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
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Thread-Topic: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Thread-Index: AQHYwfdzMPgE56itm0GRwc9i4G18eq3SpZoAgAEtSgCAAADFEIAAFD2AgAAHh6CAAUDdAIAAFjTw
Date:   Thu, 8 Sep 2022 09:51:01 +0000
Message-ID: <SA0PR12MB4365D5D2C05EAB412567D42B89409@SA0PR12MB4365.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
        <20220906134801.4079497-1-nipun.gupta@amd.com>
        <20220906134801.4079497-5-nipun.gupta@amd.com>  <YxeBCsA32jnwMjSj@nvidia.com>
        <87leqvv3g7.wl-maz@kernel.org>
        <MN2PR12MB4358E3CFD2E3ECECC14471F489419@MN2PR12MB4358.namprd12.prod.outlook.com>
        <87illzuzyw.wl-maz@kernel.org>
        <MN2PR12MB43581495197F603E901BBACA89419@MN2PR12MB4358.namprd12.prod.outlook.com>
 <87edwmuw4f.wl-maz@kernel.org>
In-Reply-To: <87edwmuw4f.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-08T09:50:51Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=273b09e0-0dae-43bb-9ec9-071b9a4e15ff;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR12MB4365:EE_|BY5PR12MB4999:EE_
x-ms-office365-filtering-correlation-id: fcc0f294-1498-4197-5004-08da917fa3b0
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lZKnXkoeX/P9w+U7JjaB9NcRBaXPSNwa+tgk+2F/2Ynybw1XQ9GL3Dm2yAwdbW4Sn2OsObqOu9bYr7Qjdbx0Qq+QQJfI6LNg9MHD8c4CwkISXaPZ859d3gKY/jknP8dBwPZM8dXKs9z4dIjYu06FT7gFQQCSMySC99cH2pV93Xm9A1YZQkp6boZnziaYBFmxI3bLGCkAi2aMXrBkRxnF5qF9HKzhZAr4iQOzZIp+1Uf2i99CQf4tTeXNij3JpXvH1TYwd7O2FkthDr4jyit2p3MLCEml8lZD5xpbYnawjPSO6dELlhVamh3mmRnJ/cGcTcM2a3FaBFo2j03oyRib4XHFfdJPzigqxbM9YnUb3qt/Uj4JcLyxdkGwKRwX89S4CPV9NklxydAK4a+4vk0CIk0SaBnJqQo6HIX4r2oTEnP8w87IZ5JXHnDwbOAQrwdPIW3C9At09c7gZywyHoK5HMUBYhxBe9tP2jf+26WwwHRSGB2oT5f/UT4+Dos7v7cQb7TEaLrVccLMAHxDifJu7jsPzk2yOEvsNf5iyjBVtIHh2ETeK5ipn4AMqwuwAjUdnZizqxcifOEwRzSLpENjML+dlMVOGqMAnl4WvnWAoHtpiNGO8GPQO7iWILlZZCqcHICVd4g8w/7vTDfg3AXQNtJRR7BS9LTXRzsZoqiv/CWorHVoqy2K32++xsPHp4u8UTJjeDyP0MZ75NEtq37SU/gZ06Q8JAT6hzmigJjsr9sxafwHxZ9k5PRcxl6WZqhdQ/KoChUsVPYDfhV682whTA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4365.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(54906003)(66446008)(8676002)(76116006)(38070700005)(4326008)(66476007)(66946007)(66556008)(64756008)(71200400001)(86362001)(8936002)(41300700001)(478600001)(6916009)(52536014)(7416002)(316002)(5660300002)(9686003)(6506007)(38100700002)(55016003)(7696005)(53546011)(2906002)(122000001)(83380400001)(186003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+NQa9bukhrhJXrvA2sjYuiBKNehGaXL5LMm8TdU8oEwQYGz7qWHul+GPQ4BX?=
 =?us-ascii?Q?TGzSJVgPIe78Df8km5ZlIol41h3Tn0spbFTp3S7Vv/D1CXmfbFf+/skQNmU5?=
 =?us-ascii?Q?/RAUgW1cOsGSgMFCoOFhUBnMZ7KO5R2zsPnPLg55Cot40SWDFQotmDJZ6BYz?=
 =?us-ascii?Q?d4UNERpdjDnWqN0tE4E4H9KnVufEACj5gNjl7V3wjC/yFIcMvO1k6+T5MdpS?=
 =?us-ascii?Q?O1fQkzYra1F4svVO6OF5ya5xd2QjfXz7fFYbDeiTKmjIx6VC2PTRmbEw2Lfv?=
 =?us-ascii?Q?su0bjk4XlvZe46laR+fuNbf7j497eL5t37dY5Yy8gmpP4uXMcP+ADEtCuXC8?=
 =?us-ascii?Q?dbTnUAYt+d+6rSS7FrneoB29sTrDSQyo4Vzfq05LJ+4z7w1bh88PzNkFEFCl?=
 =?us-ascii?Q?DlVxE7sas7yMd/Z12B3PqETLm8FVknx7OqVWlA5H/bVB7KRQJbVnSiUzdD/A?=
 =?us-ascii?Q?J6LHLt5PkTQKV4woZFqo8zHm0DsXgcYdCeY34nDQQ1NFsMkFUhYJ9efcjx+R?=
 =?us-ascii?Q?62MgoFg8nCxn0it1UaypsvvBPalUMnI/LqOvfigWVTtmn0LNu/HndfINNIIV?=
 =?us-ascii?Q?Fk2atV/SBddVaCIA4IwkjZBfdEWKCFn853pdxvd1rz7kQOaxTzJaBDL7yQ/z?=
 =?us-ascii?Q?umIx391halSWNAAzvhheOzdLBbFrnGbXogEobGJ0YBfwiJP4Jkg2svF0l/tD?=
 =?us-ascii?Q?xHkMHnKVvpMfvZivp9M9+6AT7e0/nH+7adLQUKFgING7HB0fsHILaY0+Ac9p?=
 =?us-ascii?Q?XWmnjs+YxhcEGpChsSZIqmJOkasCdi+FW1uMCSVJztOSYS0Xe5SaUN8+/eGg?=
 =?us-ascii?Q?n9DcLaiC15GZs7+Y3HXD4ag1r/6iinCMj6frC0NRVaiAhjtni0QS1bSvQ+IN?=
 =?us-ascii?Q?+CHFqvQq/kM9SxL5TyQFpVcMjjKqbDCiGDDbFry0qk25NorMXbEO0d/kYyCz?=
 =?us-ascii?Q?nnQOO6z7js7rEnLh3rkLZRLCRIftiUnNfJrtoPJfprBit877i00/BJ1JdORH?=
 =?us-ascii?Q?jSKRUAv9kv3BHAkdggB/x64mRaD4YOo2uhp4q4JmlrpeQlOTzxHU3V1i/FQO?=
 =?us-ascii?Q?UQvpAkgAbZWzM7+rLsQ7W/yHUGUi0hIdWTl7vcbsPjTZw5lY/vuOL0igNq6t?=
 =?us-ascii?Q?u0abvLni9DdyvaLnjhjo261BAc29IrizRJT2Jms45tApjycs46W1bv99qe6K?=
 =?us-ascii?Q?7YdUpJBYhq5UYnep/sabGNCJdKDHTCvt9RBFeeL5OW4V2nwegCYbYBq/eZxe?=
 =?us-ascii?Q?jF42w5tC0WM0rgWjpFIxSt+fjMlYeZY0sXHiLAhTbNEBxuuaQa45ROX9KgO2?=
 =?us-ascii?Q?KySFSGZZtuKU0DmYEtptx6cBGBgJdJ1PGsPoOajKufIhkAgZblRQTBfaI6ZD?=
 =?us-ascii?Q?fBu8R6hJbAdffv64ClvGqWTqAxxwZ4BLiB53FekckFd0UfGx/BZKpSlHlOdv?=
 =?us-ascii?Q?6Z/kaBUG7gf5l+4tAkulMLHWRaT4/+CSaSoGmPQNuCzPxqds9eZUPU68yN5v?=
 =?us-ascii?Q?5bMWDThIGmN45lb3OFUffPlt1zaneYxOudHdXvuyM9hrLfrxvk2jt1vLSeu7?=
 =?us-ascii?Q?XwmroUWSNw1qQ5KLrw8TQCh2dXWiQfhYg7ENuj+eOcWLBXZaiF2zGydjUGdO?=
 =?us-ascii?Q?6fe38eY0TBLIvNwQ5PmDE20=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4365.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcc0f294-1498-4197-5004-08da917fa3b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2022 09:51:01.9149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X0xMpV0HOB1mLEwJpyMkaI7G3ZZb9FRWgEJ6oAGQ4ITssRmAhKhz71A9L28NBl5NtYLJQ7b6RHUUcCJKRe6Tbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4999
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
> From: Marc Zyngier <maz@kernel.org>
> Sent: 08 September 2022 09:08
> To: Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>; Gupta, Nipun
> <Nipun.Gupta@amd.com>; robh+dt@kernel.org;
> krzysztof.kozlowski+dt@linaro.org; gregkh@linuxfoundation.org;
> rafael@kernel.org; eric.auger@redhat.com; alex.williamson@redhat.com;
> cohuck@redhat.com; Gupta, Puneet (DCG-ENG)
> <puneet.gupta@amd.com>; song.bao.hua@hisilicon.com;
> mchehab+huawei@kernel.org; f.fainelli@gmail.com;
> jeffrey.l.hugo@gmail.com; saravanak@google.com;
> Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
> robin.murphy@arm.com; will@kernel.org; joro@8bytes.org;
> masahiroy@kernel.org; ndesaulniers@google.com; linux-arm-
> kernel@lists.infradead.org; linux-kbuild@vger.kernel.org; linux-
> kernel@vger.kernel.org; devicetree@vger.kernel.org; kvm@vger.kernel.org;
> okaya@kernel.org; Anand, Harpreet <harpreet.anand@amd.com>; Agarwal,
> Nikhil <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
> git (AMD-Xilinx) <git@amd.com>
> Subject: Re: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
> domain as parent
>=20
> [CAUTION: External Email]
> =20
> OK, so you definitely need a mapping, but it cannot be a translation, and=
 it
> needs to be in all the possible address spaces. OMG.

Could you elaborate why it needs to be in all the possible address spaces? =
I'm in no way familiar with kernel IOVA allocation, so not sure I understan=
d this requirement. Note that each CDX device will have its own unique Stre=
amID (in general case, equal to DeviceID sent to the GIC), so, from a SMMU =
perspective, the mapping can be specific to that device. As long as that IO=
VA is not allocated to any DMA region for _that_ device, things should be O=
K? But, I appreciate it might not be that simple from a kernel perspective.

> > > > As for the data part (EventID in GIC parlance), this is always
> > > > going to be the CDX device-relative vector number - I believe this
> > > > can't be changed, it is a hardware limitation (but I need to double=
-
> check).
> > > > That should be OK, though, as I believe this is exactly what Linux
> > > > would write anyway, as each CDX device should be in its own IRQ
> > > > domain (i.e. have its own ITS device table).
> > >
> > > But that's really the worse part. You have hardcoded what is the
> > > *current* Linux behaviour. Things change. And baking SW behaviour
> > > into a piece of HW looks incredibly shortsighted...
> >
> > For posterity, I'm not an RTL designer/architect, so share your
> > sentiment to a certain extent. That said, I expect the decision was
> > not based on Linux or any other SW behaviour, but because it is the
> > most straightforward and least expensive way to do it. Having an
> > EventID register for each and every MSI source just so you can program
> > it in any random order costs flops and all the associated complexity
> > of extra RTL logic (think timing closure, etc.), so trade-offs are
> > made. The fact that it matches current Linux behaviour means we just
> > got lucky...
>=20
> Yeah, but that's not the only problem: there is no guarantee that we have
> enough LPIs to allocate for the device, so we'll perform a partial alloca=
tion (8
> instead of 32 LPIs, for example).

Why should that be a problem? The driver will know in advance the number of=
 vectors required by the device. I expect it will need to call some equival=
ent of  platform_msi_domain_alloc_irqs(), shouldn't that fail if not enough=
 IRQs are allocated (and ultimately fail the probe)? Even if not, we can st=
ill inform the firmware in write_msg, which will serve as an indication tha=
t a particular vector is enabled. The firmware can decide what to do with t=
he device if not all of the vectors are enabled.

Aleksandar=
