Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2345B204A
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 16:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbiIHONj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 10:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbiIHONf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 10:13:35 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C36AB4D0;
        Thu,  8 Sep 2022 07:13:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axatNDzKq8Xdjmm/ZNXRSaAGaA/t0FKhEQv8RHq2ra4KwyN90GPgNPe2176t2jrKL0nzn5qD97YAmdDadRsuuAtyVhEUZZQgXuZNsQuTKCVeFz+GH/jn5rSupmLA2vKc9gE3HXLUptMxVymPO31gy5qUR+hX0qPMlj+T6xEiO33sAA4Av6I1qpWnxpthul5/dUvOlHy7SzbiFPplJ2bG+XmuGy2ZFoZHOu/3zXsh2vZlZACpdY0pMET1IBN70QzqT8FIqXQXYIHr5QsdHFcASKmVd6gGSujdZ+TkEd/KQrmcNd/UjrbDocW6l3bRhB1U0G/NFbbCiN8yoHmewCBjCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zEuvOnVWAQU/WDQtgnFmJxkCnkNwGoe646hR06CqGG0=;
 b=G21CaMb51qmBtN05ZklLeKayUpAbydNyNay5Kwz9+omtwOOC04/uhSKI1fu7yJQGN7aUzReNuBeiAbxvIApNOSEwp3LE+qKl+6dG7jzRL0SmHDgpQgiP0Aj/PnRPHNPRXh5PVb/09BEYeGgWCig751aA5jcET+1WaXSRpNHWzeiMBEejoywhVopt35PRjrF2+yFHOEfSimB7b7qWZSHy8paiNPf/kLXOb93TKEBfWqvsfeoeKvtbcPejZYlhho5/WtHWV7mREC0xhS5L+6czYW2mwHrEQhlSibM3OgO6wyGQggNobRK1Hw6Do2oNeMHV/58Av1nD53F/ldrPUhcLBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zEuvOnVWAQU/WDQtgnFmJxkCnkNwGoe646hR06CqGG0=;
 b=FLwjFtNBScIvGR05JvrepUdrIZsBkItqeJdO+eZMnomTNbyJpS7MkV7wVDIU4Ri7/kziNq56AHhr8wiydFazb+aBXSSx1oNunwacUncFcXSAxg47sCYDepvtpYGMLdQqxeJZ8cYvM2BQCwCa/lN82I1K+T3s/IiJ21byAl4/nXc=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by BY5PR12MB5510.namprd12.prod.outlook.com (2603:10b6:a03:1d2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Thu, 8 Sep
 2022 14:13:31 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74%3]) with mapi id 15.20.5612.019; Thu, 8 Sep 2022
 14:13:31 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Marc Zyngier <maz@kernel.org>
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
Subject: RE: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Thread-Topic: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Thread-Index: AQHYwfd0JTWjzcxYd0KhDb1ncGWS4a3T9LKAgAFC20A=
Date:   Thu, 8 Sep 2022 14:13:31 +0000
Message-ID: <DM6PR12MB30821367EC37FDE33DC47A25E8409@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
        <20220906134801.4079497-1-nipun.gupta@amd.com>
        <20220906134801.4079497-5-nipun.gupta@amd.com> <87h71juxuk.wl-maz@kernel.org>
In-Reply-To: <87h71juxuk.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-08T14:13:29Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=13e2f544-7020-4de8-b5f3-a4cb86c87fca;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3082:EE_|BY5PR12MB5510:EE_
x-ms-office365-filtering-correlation-id: b0ca8124-4d76-41ef-70a7-08da91a44f09
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n8/qacXaYFsCbT7LOQ4nFX5Z52ejvvIRIXp7DxVz8UNcabl9kcHujo4GMX53TnqVXw94nf/idtw5RJ+wqXDOmkHMoZ8QT6eNbGKG7GxbYEpAEvKj8OO0USBVlYePJDkmKdbT1K9CF36V2otODg+t/tMpefsc9z7uPfVxyxIdB41q39JVOk5VbdsZ9xxRCnZG5vcCtl7fA4KFpTbqWnkDsunpV6BX/DMOSAjj3WYICUQK8XdwUV2IglPoOzS7FxbsrCDjXrKjbDteEgZExwUjTVKiQsK2yJgkOg/swnlxEqr43nE+LukneOKXtHeW5smW8w2um2JRJDvYG5eoprXYKRLqI8VMpC5OQFBwtbmaLX3x4FO0ICusgcriVUnZcwpbht2+zJf3Vd0+0Hfr36vxuIRvhbIAKIUw78zU8NaKAVcGHjTFtp8JDIGLnbuROz8T7lgIfjrB7QfaIzuEpQqc5kiroM0IkkWlFH5d6zYGbD1Kp4IK62VN4TsyLFol3lSBivNq7UewSqbkQfoiLpT7Ci/pHE15XZLcCSORUDZE1M2XqtQRgpLEnP4PSHsfL/Eti1RuvYcxzCOE/5iwposcFcHU5/yDZ3c8lk593MkaTlP/VoLuiIpP+A8R6Tq8dT7ojKKLj8UEw1hZijnmWBOK2DRYT1FmWgPaED/a8QaFLQ9Ik0PUHFrVkNHm1NAlic+lsE5cer6+lm4rFCQzeqEZsSa6CP5usZTn+YDNKqH7+BnS3tHND5wmaExs1zuYLsTWtTD2YQcijKDDxiToE/jnjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(66446008)(66946007)(86362001)(64756008)(66476007)(76116006)(4326008)(71200400001)(478600001)(8676002)(6916009)(54906003)(38100700002)(38070700005)(316002)(122000001)(66556008)(5660300002)(33656002)(83380400001)(7406005)(55236004)(7416002)(2906002)(41300700001)(8936002)(52536014)(7696005)(6506007)(26005)(53546011)(9686003)(55016003)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NVgoSRQWfZu1ozg3yucK6LTGICYoHNn40OBmuhbl3TpO+xYIy6IqZtMhtp4+?=
 =?us-ascii?Q?6kkmcCLM6SaF89v56roBT6T1bECQA6T2jME2L13OXIWmyGTu2aV/QmZ3VNY7?=
 =?us-ascii?Q?XT6XQVYyA72hn4JdU4yEs89WB1wd5PmXccezv/Jau/zf9XXwXjB1/VwUjTP2?=
 =?us-ascii?Q?1TKQzb/sgPfgiUiGcnapT41jRgTNqtwhSHOalQnaY0eKl4c//lC77H2uyBes?=
 =?us-ascii?Q?gYLxZ0brAGeA3tALZn65yaMvPTW8FuoyY3V+D+Of1QhBbb8POcFV8fhxsbjw?=
 =?us-ascii?Q?XROXrIH+fidNbpd9xeP0LbsenqrJmg8eydYtSnmGAWKaS0Q0+N96Uy8j0Rty?=
 =?us-ascii?Q?Udaq22TAbeWCpWUwu5USGIrWBiry+xBsdfoQEKu4Z0vBheqvQRvuOn8PeJBZ?=
 =?us-ascii?Q?skFrJj+9TldU3MvK8ZDqbhpdn/BbmzwYOTU+tP1P0jF4SNTlYvq4xoWf53na?=
 =?us-ascii?Q?K5vvcVw5f9ZYLoZb7vSRzZWpD0TLIbZf9AKbFx6rvSuRBmEonPlMII2ptfJS?=
 =?us-ascii?Q?P31++MCHFqwJmZNLJKF3t5LPnsVVVfY/dHT3IIk2nuAXnFvO9KbKrDgfxgbv?=
 =?us-ascii?Q?n5CWxsTFgOlQJ7luObOfhkz4C42Zkhs57uBzAic90A1kouAvCAPfAFyquEYy?=
 =?us-ascii?Q?oan2npgVDGO1M0uehP1vMYPIEbbMnyKzhz+hby9JAjQ3XPAM5D9BqUwtQ6rw?=
 =?us-ascii?Q?OzwXy1v3gUTny/2+01XzbFBveMB4rQpu9Z7rpdKMftjMlg3ylTjY+KOBItQz?=
 =?us-ascii?Q?FciL04oXqj9Bgh63vHeu+08y6XP2ddGzb8Ugo22ekS/avC5M8SPJ6y8wJiU7?=
 =?us-ascii?Q?BxkxyGabzipYcM9wkdWtnq8PzXlQwxW40sRmkWOVI4ZbGgEGxAhm3Rrqv4Jy?=
 =?us-ascii?Q?7Ext4wqiXJP9Qwi/wsIoD+DQEQLYpy/rNSWdJFQBSvKMH24vqPAakDLmiY4I?=
 =?us-ascii?Q?KnV+Ez6QQwZjkdPXPwYhUAY2eegPNIoGBpRtnJGE8eedarMFtTyUFdIdBOCP?=
 =?us-ascii?Q?Jtp8EdEwJxozWCFhNFhCg76od2M37/9bqxTg6Yza5YBHICX4XuklaNfFZdWP?=
 =?us-ascii?Q?oFpmaJalMTaFM0l7SlW+gm42+MgmyFiz2/R499JY/X5p0YftdxrVSIfCii1D?=
 =?us-ascii?Q?wGLYPo86ZlLJ7Wg3Moik+a1640Wp6FjkPpNDCfgg/7FU2SCZ9ZwiWjhS0O0t?=
 =?us-ascii?Q?6c2YyxSSWQek2fSAemYRpEf7OCDExOHNYOL4QlJrfHp2FRkTKnmhbUBcuQx/?=
 =?us-ascii?Q?ICVKkRx403NPf4pI9GRtJut5+wmhC7bK8/4pQc7JxGsZ86XoRcyrGvHjI8qo?=
 =?us-ascii?Q?aKo47jdAYby5O387+kZHFz44I8a/gaIKq2yLh6xWR21OE1RN5chFRRIeqHAD?=
 =?us-ascii?Q?qe/bh/B2ijITaQqLwCfaor/RH00WmcNkbafJqc02Zg+Z1/FG06UhwygtQ9/T?=
 =?us-ascii?Q?8VRu20VtSAcTbIEkD8zp/BCDLSWXtUEe+loLZl0MqPqtDiIVW5z/oR5jImKg?=
 =?us-ascii?Q?J4dfvf13LXeXYgg1SOMUNBuGqsY0QyYW6r8Hpzz+9qcilOCURIrtMUbAo8+c?=
 =?us-ascii?Q?iCLtxuPwQlILGThLAWI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0ca8124-4d76-41ef-70a7-08da91a44f09
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2022 14:13:31.2873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DVM41FTMasiKpE24sjZTRelXuVDMNbBiBnYEPBm3pLcVoxN5XAY6TIxAyDhO4VQY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5510
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
> Sent: Wednesday, September 7, 2022 6:48 PM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>
> Cc: robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
> gregkh@linuxfoundation.org; rafael@kernel.org; eric.auger@redhat.com;
> alex.williamson@redhat.com; cohuck@redhat.com; Gupta, Puneet (DCG-
> ENG) <puneet.gupta@amd.com>; song.bao.hua@hisilicon.com;
> mchehab+huawei@kernel.org; f.fainelli@gmail.com;
> jeffrey.l.hugo@gmail.com; saravanak@google.com;
> Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
> jgg@ziepe.ca; jgg@nvidia.com; robin.murphy@arm.com; will@kernel.org;
> joro@8bytes.org; masahiroy@kernel.org; ndesaulniers@google.com; linux-
> arm-kernel@lists.infradead.org; linux-kbuild@vger.kernel.org; linux-
> kernel@vger.kernel.org; devicetree@vger.kernel.org; kvm@vger.kernel.org;
> okaya@kernel.org; Anand, Harpreet <harpreet.anand@amd.com>; Agarwal,
> Nikhil <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
> Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>; git (AMD-
> Xilinx) <git@amd.com>
> Subject: Re: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
> domain as parent
>=20
> [CAUTION: External Email]
>=20
> On Tue, 06 Sep 2022 14:47:58 +0100,
> Nipun Gupta <nipun.gupta@amd.com> wrote:
> >
> > Devices on cdx bus are dynamically detected and registered using
> > platform_device_register API. As these devices are not linked to
> > of node they need a separate MSI domain for handling device ID
> > to be provided to the GIC ITS domain.
> >
> > This also introduces APIs to alloc and free IRQs for CDX domain.
> >
> > Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> > Signed-off-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
> > ---
> >  drivers/bus/cdx/cdx.c        |  18 +++
> >  drivers/bus/cdx/cdx.h        |  19 +++
> >  drivers/bus/cdx/cdx_msi.c    | 236
> +++++++++++++++++++++++++++++++++++
> >  drivers/bus/cdx/mcdi_stubs.c |   1 +
> >  include/linux/cdx/cdx_bus.h  |  19 +++
> >  5 files changed, 293 insertions(+)
> >  create mode 100644 drivers/bus/cdx/cdx_msi.c
> >

<..>

> > +             return;
> > +
> > +     msi_domain_free_irqs(msi_domain, dev);
> > +}
> > +EXPORT_SYMBOL(cdx_msi_domain_free_irqs);
>=20
> This feels like a very pointless helper, and again a copy/paste from
> the FSL code. I'd rather you change msi_domain_free_irqs() to only
> take a device and use the implicit MSI domain.

I agree with other comments except this one.

In current implementation we have an API "cdx_msi_domain_alloc_irqs()",
so having "cdx_msi_domain_free_irqs()" seems legitimate, as the caller
would allocate and free MSI's using a similar APIs (cdx_msi_domain*).

Changing msi_domain_free_irqs() to use implicit msi domain in case
msi_domain is not provided by the caller seems appropriate, Ill change the
same for "msi_domain_alloc_irqs()" too.

<..>

> > diff --git a/drivers/bus/cdx/mcdi_stubs.c b/drivers/bus/cdx/mcdi_stubs.=
c
> > index cc9d30fa02f8..2c8db1f5a057 100644
> > --- a/drivers/bus/cdx/mcdi_stubs.c
> > +++ b/drivers/bus/cdx/mcdi_stubs.c
> > @@ -45,6 +45,7 @@ int cdx_mcdi_get_func_config(struct cdx_mcdi_t
> *cdx_mcdi,
> >       dev_params->res_count =3D 2;
> >
> >       dev_params->req_id =3D 0x250;
> > +     dev_params->num_msi =3D 4;
>=20
> Why the hardcoded 4? Is that part of the firmware emulation stuff?

Yes, this is currently part of emulation, and would change with proper
emulation support.

>=20
>         M.
>=20
> --
> Without deviation from the norm, progress is not possible.
