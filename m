Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C27D5B0330
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 13:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiIGLhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 07:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiIGLgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 07:36:42 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB52A167EA;
        Wed,  7 Sep 2022 04:35:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CsrrCj5N3TyNVoglasKHXGb58xylG8IJbs9zHk8LWL8Jnl+//MG8GTuutKyxe9L3/Mmsd4FxxbJ01S4BiDtcBm9Y1BSc4LX+ee/pKmNNcPx8INeMEJKCoIkf9/CDzTqlNdECx6Knvo0I/icVJuCH3x2Sjk9eiv+mutwhIfsdguSUpl7+Xp4giwNhVKgaBPyEBmoVx5SSfnbH0/SJ25P4wlDzbGhJK4cItXkFJw3bu93MFZHtJkMfCZ8VlfpTPVRoSIsOLQxf6GxCbUIj7i+YtlxqLMCVHvJAqpkAFV18GjJVKhhryE5ysw8RiNcxGN8I++Vsn0oOL947LeBvfee1ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4NFXsHTklCdCdJdn7LJIPEvwJVgph4ZqUT0tKNBcC8Q=;
 b=kcLISDcvo5z+FDx6IKVPplFXWMBQT0oBLUmAXJm+zUw5S6a4q1B3mYwuBAYA5lvCDOBh7/+5GfAg4VmLLGoV1Dq/9gwMFZLvYBfQMmH/Tk4Mfh8wfaRvNaTuJxbF3EJ8gcO7QNVXGowiybcpK64EOzdrZxqDX1R3yTPWwjhxYF65MJwsORTSRDdve2WcaaB+EoJdeYtzfQnG41iiHwXwAR0PibCirerEjaRdxHndD8YoQFpmczFUVQbFKk1kGqeLxM0LVVUcIRLm/DsEOjgBsykObDk5aVruWsYRDnAcbC1HxCheo7FyACjV++ISqe9Jbru+3j75eExcYgRdcVYX9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4NFXsHTklCdCdJdn7LJIPEvwJVgph4ZqUT0tKNBcC8Q=;
 b=ufj0seAO66XlukP8DEV41PgliOCJ6JmX+Ho2YR5duKD2N+eIXxxqgPkz0tBf+1PajP57jkE0ePsku6v1YGiRTYxF5VA0Yfww8RpaAH/56elXmbuvZ1ytJUyvovsSj47nOZevptKlRaDDtCHHU3XdOfV737DJCO9jErpuFvYHoQU=
Received: from MN2PR12MB4358.namprd12.prod.outlook.com (2603:10b6:208:24f::12)
 by PH8PR12MB6868.namprd12.prod.outlook.com (2603:10b6:510:1cb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 7 Sep
 2022 11:35:54 +0000
Received: from MN2PR12MB4358.namprd12.prod.outlook.com
 ([fe80::e166:fa63:f50:5634]) by MN2PR12MB4358.namprd12.prod.outlook.com
 ([fe80::e166:fa63:f50:5634%9]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 11:35:54 +0000
From:   "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>
To:     Marc Zyngier <maz@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
CC:     "Gupta, Nipun" <Nipun.Gupta@amd.com>,
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
Thread-Index: AQHYwfdzMPgE56itm0GRwc9i4G18eq3SpZoAgAEtSgCAAADFEA==
Date:   Wed, 7 Sep 2022 11:35:54 +0000
Message-ID: <MN2PR12MB4358E3CFD2E3ECECC14471F489419@MN2PR12MB4358.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
        <20220906134801.4079497-1-nipun.gupta@amd.com>
        <20220906134801.4079497-5-nipun.gupta@amd.com>  <YxeBCsA32jnwMjSj@nvidia.com>
 <87leqvv3g7.wl-maz@kernel.org>
In-Reply-To: <87leqvv3g7.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-07T11:35:52Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=9a7a7129-b289-4b91-9f5f-5ec5a658a095;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26502e95-f0b4-4201-3642-08da90c51ff0
x-ms-traffictypediagnostic: PH8PR12MB6868:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UyNjzhtjFnBa+KCEKBegH0/CfRvZxpyiw2/TvaD7qbUgqGPn+wKpT6PruLMXpPTbW+Mf2bp5/1kp4masvDvABLsGy1Q1Ydj3aVpw5QlD+ZhgyvRkLY08uCRUSnQTXwu1GG6JixyMfamyLgzMUWj83z8Wi+V4sXgw/uTzKwymcXSGwL4qnvNb6CG5a4WwOB+PDTitWGoadsY1VC1Wb1DDVCdKgdE5tTeYY6DjF8zqYs9Si9PwWPg2KZu0ywBcUlClvq18SeWBPVbx1+QyHr1Amn/h6jEfodrL4RSPPNVXLGxI7IMc+cQlJmOS/5qYlOK19sjbU1ney3GBxCcfx93nDtY9MMEizgeQVR1IyhzvW+MpcEOWiN2GB1t9CWZiv6koVq89Ab9FPDUZQiw53J+s3j7x/y1S8BemTeru0ML2VH6a1dnL5hs4cPZbBR+Soj/gr7vYICvXhIRmxX7UnnHmcCV5MF1g19xQaTXXs2yZtr8/7khslKpQo6Y8FcBluDezjhZi/JEfsF6T9Ron5BQzCNuvSafb8P8nykNbSEk8DvH+wKPEYgxApYmTvbS8nlmkC/69RXnXxuopLbBJjuG3f8mD9q4SXVfUGFvIr9bmQmmVhBHQ14NmMJjokLUJFCVRN9Xi11G8UGm7AR1zMZm8UGbYd4zukCeIxt+gqyAzRTJs/JHjVQiRq0/WZrtAF2TlD9z/y4c6Eg1i6SCX4qu7CiM2kP1g+zfZkoXwW2SD1/O6333inxz2Rf5v52z0MdJ0Fs95yRoH0LtKUpPZgHzIgg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4358.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(66476007)(76116006)(64756008)(52536014)(71200400001)(7416002)(478600001)(33656002)(66556008)(8676002)(4326008)(8936002)(110136005)(316002)(66946007)(55016003)(66446008)(2906002)(41300700001)(53546011)(186003)(6506007)(86362001)(7696005)(54906003)(9686003)(83380400001)(38070700005)(5660300002)(38100700002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wQ5RsSQUCp6YTyeHOsBbZbQugifdl1WBtTS7mBga4BJlzrG3Cho7vOPdc9FE?=
 =?us-ascii?Q?bo26n7cMz+KI6xwt2vQPovXbnfU600kA0e2Ur+bSTBzW/HZiuLnyzoD3/sZH?=
 =?us-ascii?Q?lSJMMHHAPdHalfFDIbmkcF+K7+FAY14esKl6h1QfyuuCDuqNpxslQYlsoN+I?=
 =?us-ascii?Q?9G7njFxoQSFYz2ZLhPIqhC2TMDDhxCixDSRM2e3epcJc8L1XVWg0WHzWMaYL?=
 =?us-ascii?Q?A9BnrSlqbPv2v016CbrRbeY/HK/vWFdmXScqOqzuN+TFpYz6bgIpOD3iBZkh?=
 =?us-ascii?Q?ie7ygktlxkk/xznTJGvEZ2MAHpyUfaqcNiILtMTXV0wjTnBHt+xLcOSHL3gv?=
 =?us-ascii?Q?0zyUXhQUUKq/9xjFC0w4C4fVrmD4KMhI/fjAeJFqhuPFwFyCLyEUZRZnkD0z?=
 =?us-ascii?Q?AcbCVBaZTC1RUcQaWdvmbqnP2xumFQ/dd/l0iSeVfnZwzerFe+JrsNRPGQhP?=
 =?us-ascii?Q?z/EJe8bg8idDgHszwPZ3Alr5bmbKgEjDplGv38Bk6QpH+4rzYb0NlkSWKppw?=
 =?us-ascii?Q?xJhdCb7yu0W5M6imei0M16tDQ10ZJTOJV1gJcOeozgdqvZBGRPrNi0nzL4Ef?=
 =?us-ascii?Q?MQeMwJNkk7Uj1ILFlakcwuqh3RC50eYo2PmPUWgcIogbmzOYpRcggKhRGObi?=
 =?us-ascii?Q?NWZGxVxTR1scBWOHjElTmx3Uuse7Rn53SgimIkjcDTR/tZ1QPXMa66Ewh8CD?=
 =?us-ascii?Q?FnAzsTcWnewapDecmz1FLOIO3df8dA/uk59f8MCGzhZzhkIISt2vUMpX5ZSO?=
 =?us-ascii?Q?sXEcTROQbHU6gYvU5pNedVev9PMQsBJlffmXErY2n+mBE1++g4QRkWCAf00G?=
 =?us-ascii?Q?cJyCbh8/qszNivPpc/OQvW9KBexk0WiHp02uWLo9bkNV6IyskQGK2/zR/Qne?=
 =?us-ascii?Q?uUgRb4qBb4BQbfbyJpOAXr9WFmFLdo/jQy2qKcigh10MH3PPWOfUbs+ejtE9?=
 =?us-ascii?Q?r/mTclxPMy86u55iyVrbVPSmWYMuXlkixYSfmmvwcXnt9Pkhx+5KnYwsyN2i?=
 =?us-ascii?Q?duJ+3mFebj7mFVxKhwuCPbslNnU1uUUAbzijvdXHHpibBiBAuDrBikV9DMNI?=
 =?us-ascii?Q?dv61Bxe5ybehbk0IwFJl7OC5TmJM0BFJREiCLb6UkS4HrWUPyrFlwpVqA1mA?=
 =?us-ascii?Q?PFnzzljedLQwkEwzA2zFjW505YR39f5tS96+i+1+5bpCDhUIukkxE4/pAXeI?=
 =?us-ascii?Q?32bgQ2HQ4qCziIxUNwSWzyHfX6M6BYAwOJ5QW/Z5GSx+UVIyIs5cyjBcMZav?=
 =?us-ascii?Q?z5WXUmrq7lCm+9jXz8tiqw6SdSkPgo5+a/6NNBdP05sSdTprQv2tG2lF3qrF?=
 =?us-ascii?Q?VyHo5LBfbcv4aR60gZOIgGKxER7wtEZpM8sdwo3e5IapvzjPzpvZ3NqrtEFG?=
 =?us-ascii?Q?H/nE6rGQgUGiWi0++i0cmHoxl9uVMuGpzCvrMBJ7sQ79g2TkkrK+uL3NjjQ2?=
 =?us-ascii?Q?fGzxls2o4nj5bLaKTL1YEIyPGdPHrekLRtrhwiheRH43Dk26jFC8TTMijaL/?=
 =?us-ascii?Q?PkvU35p9dw2LUsYhCTnhlYY+Y0bXUSAwC5OOpqCV/IyhaXbxv+4xRI/rUMBl?=
 =?us-ascii?Q?jizVs+gORsABmXhAwUVEc5UuA5gsCQX42d6GggGTS/jYH3SoJujzWeSnCxl/?=
 =?us-ascii?Q?BnBniYQPfkIirl8u03Oqqxk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4358.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26502e95-f0b4-4201-3642-08da90c51ff0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 11:35:54.4827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OmR81az+VTzSW8nGFf3Wusl00HjjV2Nvh6+fOqz2fASx6Hq11iJSwH7x6Il4jh1grYXnQqQMPijMJmJZxOsxzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6868
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
> Sent: 07 September 2022 12:17
> To: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Gupta, Nipun <Nipun.Gupta@amd.com>; robh+dt@kernel.org;
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
> Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>; git (AMD-
> Xilinx) <git@amd.com>
> Subject: Re: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
> domain as parent
>=20
> [CAUTION: External Email]
>=20
> On Tue, 06 Sep 2022 18:19:06 +0100,
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Tue, Sep 06, 2022 at 07:17:58PM +0530, Nipun Gupta wrote:
> >
> > > +static void cdx_msi_write_msg(struct irq_data *irq_data,
> > > +                         struct msi_msg *msg) {
> > > +   /*
> > > +    * Do nothing as CDX devices have these pre-populated
> > > +    * in the hardware itself.
> > > +    */
> > > +}
> >
> > Huh?
> >
> > There is no way it can be pre-populated, the addr/data pair,
> > especially on ARM, is completely under SW control.
>=20
> There is nothing in the GIC spec that says that.
>=20
> > There is some commonly used IOVA base in Linux for the ITS page, but
> > no HW should hardwire that.
>=20
> That's not strictly true. It really depends on how this block is integrat=
ed, and
> there is a number of existing blocks that know *in HW* how to signal an L=
PI.
>=20
> See, as the canonical example, how the mbigen driver doesn't need to know
> about the address of GITS_TRANSLATER.
>=20
> Yes, this messes with translation (the access is downstream of the
> SMMU) if you relied on it to have some isolation, and it has a "black hol=
e"
> effect as nobody can have an IOVA that overlaps with the physical address=
 of
> the GITS_TRANSLATER register.
>=20
> But is it illegal as per the architecture? No. It's just stupid.
>=20
>         M.
>=20
> --
> Without deviation from the norm, progress is not possible.

To give some context, CDX devices are specific to embedded ARM CPUs on the =
FPGA and a lot of the CDX hardware core is under the control of the system =
firmware, not the application CPUs.=20

That being said, the MSI address is always going to be the GIC GITS_TRANSLA=
TER, which is known to the system firmware, as it is fixed per FPGA platfor=
m. At present, we do not allow the application CPU OS to change this - I be=
lieve this is for security reasons, but this may or may not be a good idea =
in general. As Marc mentions, CDX MSI writes are downstream of the SMMU and=
, if SMMU does not provide identity mapping for GITS_TRANSLATER, then we ha=
ve a problem and may need to allow the OS to write the address part. Howeve=
r, even if we did, the CDX hardware is limited in that it can only take one=
 GITS_TRANSLATER register target address per system, not per CDX device, no=
r per MSI vector.

As for the data part (EventID in GIC parlance), this is always going to be =
the CDX device-relative vector number - I believe this can't be changed, it=
 is a hardware limitation (but I need to double-check). That should be OK, =
though, as I believe this is exactly what Linux would write anyway, as each=
 CDX device should be in its own IRQ domain (i.e. have its own ITS device t=
able).

The best I can propose is to pass the addr/data info to firmware here, whic=
h will then decide what to do with it. At least, it can assert that the val=
ues are what the hardware expects and fail loudly if not, rather than havin=
g a silently misconfigured system.

Aleksandar
