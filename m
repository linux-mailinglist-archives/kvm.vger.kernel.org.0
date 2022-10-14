Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C0F5FEDE0
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 14:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiJNMNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 08:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiJNMNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 08:13:52 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AEA1C7D6E;
        Fri, 14 Oct 2022 05:13:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NrbMq4kyM/FW9XvNBTt/WN7uJISsEX9MUqFhEu0HLcd0t04DMM/G2idpe7toJLA1et4ZMh6m3zSyLCw8Vl7PQMT4I8SJxGaKy8HkmCEB3T+HcyMvxqmPGH4DZ9yPOvkg8M3iWWA00o+/iF/vzmw7pLexyGygjZppGCx9Lo2nRO6xlrSEMRGTu0CzVMcIxkyCppwxxPQKz62XLWNIMY9TegxN4sxSlECVXtm/nqaIqfJI8zIehDEao1giaJ1o3sxkdzf4GqS1lWefXN2oiF/pNIiSU8riAVaoU9WqJEP07HZxGFk5S9lGBxE9femc+IQxQm8hFZsq3dnsjqBm33leOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O3WgIjNoP03N5abmIAbn9wL1wakIn8HiIvCS4gRDGH8=;
 b=G9Fcfc1BnOA+iCu202bbL/j4cPCLhfc98pKSxRjLb23EMV2yfj2T3Q5PbB3eaOcvn9i6stlRZiDbAgG/TFFBklhgNPUsccZjocZ1a/IKN5FacVwRVfhbaf4wzcDeVT+XrDtqbv5Ny4mfGO8g4K7aMGPx8dlrI8I+NTIU1gIW4480FkAYkP2VFZMIPRcOHdqKTb/Psd8O4qf8c4p+CCEMi0aeMxwwB5EMtNk8icNE+gDjZEZhmBjJhiz36wnxgBvAnyDyPUtiYis1YdOuia7y/RxxA2JS+isM1nnATxOMZ3GQ6vU3lqQCqRLKhp6kzIbzJDIPoTzF5ZtY0Ntxc3lJbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3WgIjNoP03N5abmIAbn9wL1wakIn8HiIvCS4gRDGH8=;
 b=Gmg456n/VjOUky8+SRoNXHcJEilUxEcFjqtgwbd0v7w1DAMFOyfAnmAe0WomL94oDbQwpen18XJa+UQ/dGckK567TX1LmMR20fi4hFSrSn8sakyYg38qwTY5rwwK6qgEVNxto1Yk4S/8GeslBHygAWh12NXyUWLtr2/ylZKRsrw=
Received: from MN2PR12MB4358.namprd12.prod.outlook.com (2603:10b6:208:24f::12)
 by LV2PR12MB5800.namprd12.prod.outlook.com (2603:10b6:408:178::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Fri, 14 Oct
 2022 12:13:46 +0000
Received: from MN2PR12MB4358.namprd12.prod.outlook.com
 ([fe80::a094:c6b2:d306:d7bf]) by MN2PR12MB4358.namprd12.prod.outlook.com
 ([fe80::a094:c6b2:d306:d7bf%3]) with mapi id 15.20.5723.029; Fri, 14 Oct 2022
 12:13:46 +0000
From:   "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
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
Thread-Index: AQHYwfdzMPgE56itm0GRwc9i4G18eq3T9LKAgDbLT4CAAAON8IAALkeAgAACWFCAABh6gIAABiXQgAFsD4CAAWkgkIAAG6CAgAAAUpA=
Date:   Fri, 14 Oct 2022 12:13:45 +0000
Message-ID: <MN2PR12MB43583BB73731986D15B3620789249@MN2PR12MB4358.namprd12.prod.outlook.com>
References: <20220906134801.4079497-5-nipun.gupta@amd.com>
 <87h71juxuk.wl-maz@kernel.org>
 <DM6PR12MB30820EE430405FF50C7F856BE8229@DM6PR12MB3082.namprd12.prod.outlook.com>
 <MN2PR12MB43586084670E14691920952889229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0a65a9leWXpKfTo@ziepe.ca>
 <MN2PR12MB4358A871519748CD7A6DB7A089229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0bRZTP9Kc6mdCiu@ziepe.ca>
 <MN2PR12MB4358277977C1B7E0BC214AC789229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0gH8R8tEqn6sqZ5@ziepe.ca>
 <MN2PR12MB4358CF6B6D2576B35E39328A89249@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0lODVFsp4KMfPdu@kroah.com>
In-Reply-To: <Y0lODVFsp4KMfPdu@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-10-14T12:13:43Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=516bd93f-5001-4a03-9556-c86713f583bb;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR12MB4358:EE_|LV2PR12MB5800:EE_
x-ms-office365-filtering-correlation-id: a5d513cf-8926-4b4f-42f9-08daaddd8b10
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CCaavpIwvApa39oHs7zFWrzf4LpAHb5pBAcytsDsjMCLuluVqM61xEtAVD/PH0BBiqGJ2FnmvBorikbMK6CZ4rZREG7e6tAtl68yePyRqTH3ik29wmfyZmsjJ7Z702x8rrMH+6w7/eNYvPaKwDK5Nsm9uTdcyj9i7/ytH2JUMxC6aWQLYF9YzKYPhJe+6lAYIcWVY6wmVRsRgs9PW+zy/+5vqaBewaGWdwknDI9S7V2dDQwFt2vUrNS/XDphdz4T9+EITVt7pSCfI95VANfpX7JPD96ZwMcJ66mNUWjBm/iXbhA/SyY0cjdDTW5dEWwc39WjKOYZMRvVOejfzomv1hT+Op824kVkz9VDg5QXdKNeVj+lK5N+fDgMSpmMP4RMceTgUtq1q8SemSJTeO8rSFotpRmm50Y09aaWBgNnz4DF9tLy74GTo813B5pcAAo4vDXeafdur7wZs75dlncZ1zlSpwmeJ0Vql9tBpdKdBCdrnIb+KLIVWU2OZ6WQza46FpRAvVHCnSBppB3Am2b6D3SgX3zSM3Xi9TGA+RfgFAucswOvV5uHf2zr3CIFkZaq+562VmE8JjO8eH4DlqJylUsx3FyE8g10LYmzXzAur0aU+dUgzA/w5FAE1VO/BUizVePBWNoqaQ+DYg2jREE9fHTjWJjtQIY5WxncaaBi3nSA/ugFnxPu0P/OukDWZY5FJSnaqqxrKb+KGzyblEWqKjiDA2B2egE/d4YFNSWXfe//Q1gmiFf9BQL8xkpBbo8eabGXUPFMKylwmgLxWsrOAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4358.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(396003)(346002)(366004)(451199015)(6916009)(55016003)(86362001)(33656002)(122000001)(66556008)(8936002)(5660300002)(66476007)(2906002)(64756008)(66446008)(9686003)(38070700005)(26005)(8676002)(4326008)(52536014)(66946007)(76116006)(7416002)(54906003)(71200400001)(38100700002)(41300700001)(83380400001)(316002)(53546011)(186003)(6506007)(7696005)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BUNtru8zoXJjG8aTqgqr4pjywAfU41UCmyT7iUnPvxUpRTBtYomQQ7gODx51?=
 =?us-ascii?Q?abrDopZiyXDywtiNNjPBJWgr1l3l7YgCFVnHqbNsB9xjWMl4KhEJ+nDCfBbw?=
 =?us-ascii?Q?uckqNenhpqFtd+aRyP3s9/+jgDzddG1v7gDK4ftVtEMcaNoBeQWSIvQK7uJL?=
 =?us-ascii?Q?GxPQjyl3C/EvTf43adFmpOXaHucdH811i9z5LLCQsiW3TsF7Byspfh0dUvZs?=
 =?us-ascii?Q?whYeDLl/jiS/Ll5i2MAoMNLZaE28PSdWq4F6Wq2q4GSxxFTWdTvFgOLsUJ2B?=
 =?us-ascii?Q?c2yvVeyJBTPGnX+6PE3jR4JBJwrfWOi8+otlXzuAGyNBUiGe56FETo+xoHVZ?=
 =?us-ascii?Q?e7l55za4HYTa7Ec0stN8eSP06pfpjoiD8ko2as8G7hFGQNDzs11Lu+Y1aBN/?=
 =?us-ascii?Q?J63SxKxDnGaAztXZd2adsVCsY9+bjjNZYgesvyTljRwpaYCMcj+F3ZptKCj+?=
 =?us-ascii?Q?d6XRMBAsnRmTX5yuapqcSOyFMbpZ5CCgOd4Z+aAm8iJlqBrio1CCsrIizRIu?=
 =?us-ascii?Q?X6Bne460xpY0Qf4sxEWnpOcnMP1JP7DrFjvjL4pqQYG4agQL9IMUwDgQiKFn?=
 =?us-ascii?Q?jt+fVw78n3T5sYJ1ZZabHL4xKKAXEFHwne/CMDFkSBRoJdvVXoEXMNflCKyW?=
 =?us-ascii?Q?NoYKRdS6KI59dlsdx56UGb4YrqnNkpjaueW6qjANQjxNKbD4gSOXBqYkR+OV?=
 =?us-ascii?Q?erDwAowJGLyFoaAG0TMDhpC0FJxnxqX0QLAiaDFoR4tmY26Owk3oTznFzLIR?=
 =?us-ascii?Q?OXH3wdN/8GBR91vxq54gr2tZMnBQUIAoNOxe3211IlonyTtXa5TqJc+AVTF/?=
 =?us-ascii?Q?Rs6FqXjoEqcTFJ1Zn/5lznXIEnUlKUgB9FVPtZMJn+caqRKfY5IGKgqAz7bK?=
 =?us-ascii?Q?ZX+ri/CYeOWtkRQRnrXM9ylknLfjGFg3tP+GJ65kn9Hg8cXk3D8yircM1VuI?=
 =?us-ascii?Q?Ab24s7AR4e7NvZHX5wqMCRnoL3A/6RNm1Vdc/zbj2ljxRdotvnRf2RCkS8De?=
 =?us-ascii?Q?/axjA9NgJ7ljoyFjTTDQcT7uJJYTI32mo4+kMmJOMr9TOJTqfNzxaSLWRVrE?=
 =?us-ascii?Q?i9Uy33FAwE1H8Jw8x6A68A5oWm6+grKTmWJZr0YV6S0p7l6UcBIYqRSh5bBV?=
 =?us-ascii?Q?Cs9eLqtlY2tWsdY0rkk6oyMvf4xp/34KELoXaiEPGXcuYBCZwLPOu84KZaQh?=
 =?us-ascii?Q?TUWTv70yigojk1JMzaBPj8wl/S1fAATksAMYGzSo73ItyQ96acwaKjTQJDH/?=
 =?us-ascii?Q?scLRv/fbiCX/07uqZQ6ozQBGepG8pJ6LqGqCOECtkE0VJXKXTjHAEQebgMIn?=
 =?us-ascii?Q?Ty9eZLlbLMcBBQubJZszXBqqejp6HwLH0pImB5R6Z920GO+2/FaF0R+ff8za?=
 =?us-ascii?Q?Emvfi+U9dWALnAovd+inao801/xViyGHHieCwNnEQTpquogYvHQVc+SOgBrO?=
 =?us-ascii?Q?/EbrKAlDV+aV9Bg2J/lJI8+Q7IRJTZ/mOwA0QT7x8FWclbGTMQi4/MFzF0Ul?=
 =?us-ascii?Q?XMP7TZicOWA5qVHxAfLr+eHcbwzHV7eyrVFXsz+Cl3nZ8cPc2tynLmHO+94g?=
 =?us-ascii?Q?qPMEMuxjJxGfRWLEWqg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4358.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d513cf-8926-4b4f-42f9-08daaddd8b10
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2022 12:13:45.8666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QsK7VlS+eMNk63EQMWv9oMbuudoEDKcTSp1dx4npS3NNcT8/UwUvWicPBfDc39Vsc94Flz8xTLsMSKyK7vz1+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5800
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
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: 14 October 2022 12:55
> To: Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>; Gupta, Nipun
> <Nipun.Gupta@amd.com>; Marc Zyngier <maz@kernel.org>; Robin Murphy
> <robin.murphy@arm.com>; robh+dt@kernel.org;
> krzysztof.kozlowski+dt@linaro.org; rafael@kernel.org;
> eric.auger@redhat.com; alex.williamson@redhat.com; cohuck@redhat.com;
> Gupta, Puneet (DCG-ENG) <puneet.gupta@amd.com>;
> song.bao.hua@hisilicon.com; mchehab+huawei@kernel.org;
> f.fainelli@gmail.com; jeffrey.l.hugo@gmail.com; saravanak@google.com;
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
> On Fri, Oct 14, 2022 at 11:18:36AM +0000, Radovanovic, Aleksandar wrote:
> > Anyway, I think we're straying off topic here, none of this is visible =
to the
> kernel anyway. The question that we still need to answer is, are you OK w=
ith
> the limitations I listed originally?
>=20
> What original limitations? =20

Limitations with regards to MSI message configuration of a CDX device:

1) MSI write value is at most 16 useable bits

2) MSI address value must be the same across all vectors of a single CDX de=
vice
This would be the (potentially IOMMU translated) I/O address of
GITS_TRANSLATER. As long as that IOMMU translation is consistent across a=20
single device, I think we should be OK.

> This thread is crazy and complex and you need to
> use your \n key more :)

I do try, but the corporate mail client that we're stuck with seems to just=
 merge
everything back together. Sigh.

> thanks,
>=20
> greg k-h
