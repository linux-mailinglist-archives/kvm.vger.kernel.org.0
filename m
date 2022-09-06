Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C8C5AF2A1
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 19:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239294AbiIFRaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 13:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238803AbiIFR3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 13:29:52 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2052.outbound.protection.outlook.com [40.107.101.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0980EDF1E;
        Tue,  6 Sep 2022 10:23:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nadMS6gw3igJJZp5S3ZJnaRsksCJvHSPKtdYj3MDbcqEqIMrq4kkX3wkYqX1YaNKFo/yAI0zBQjjw277X4eEQaFfIdEu3hkLCncCOyR2ALHUsfsCpWAXABTIh+PQDXrq5LKwv4pNvsBNQhW9rIpuyq/4JfhjocreA9U/X9i2zCGzdO68n9F56H5N0J8vVMJ2Vx/8ZfV+z0o9jkzMIXitolZIGB1QKrIJz/ILh6K5mGZyl5vXPCkaiDRaNa6zqCAsQP3W5H/ANS9fBBRt5C0npWPDTwDSEIt5eC3RbQvP8wijaljvmqz8i1VuEsJJbuYWA0gho7k9EGAmpFVp7z4/rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NoRb27zS57HbG4mIszcdWHkwnQQiS1N8Nfr2qj8xm4E=;
 b=DdBqIDJ9Pv/mBSM7qfNt6bkDeN82S9adB3yWLZnrVyK45pls9nwer+i97T8YEn18LSqHnts7CT2rBO+jBLOQogZrjJ50d6u8Kn83158fyTr5cE4O1alS0f4sgmjo33QGy+Q5Ly8GFxMi8pLCFJReujbj7ARNNAsO+vW/Wa6PS8ISTySyEU8Mscl96BjADDjtAr4ev6p3MyMOF7a252lPzb9ah8A4eRH3lEat/1ZlTeST6MpDqte7f6dON44m6u1E9aI77ct1cb9v9XMepDLfk9Fdl5+8AeV1oxg4vivRqn26HQeeZynkTfXj8IIRuyErlGqJN+d5GWx5w27w9T1hFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NoRb27zS57HbG4mIszcdWHkwnQQiS1N8Nfr2qj8xm4E=;
 b=CmNihAt5NRx5PXmGQDMYDbPlOLL5tZFQASGYWGOLwlSJxxmTg2IB/c/wrtxBA8Dh7VDXnzkolLnB30k8YNDi9m/8huPQOZ2LIyS8bH1J2WCQsWehgmH/VuaX0Gw2WUDMmVIuMcPh1KuDwAbGMA9ilWgFrthut1mkbFKvc/MUXaQ=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by IA1PR12MB6330.namprd12.prod.outlook.com (2603:10b6:208:3e4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Tue, 6 Sep
 2022 17:23:39 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74%3]) with mapi id 15.20.5588.014; Tue, 6 Sep 2022
 17:23:39 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
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
        "maz@kernel.org" <maz@kernel.org>,
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
        "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC PATCH v3 6/7] vfio/cdx: add support for CDX bus
Thread-Topic: [RFC PATCH v3 6/7] vfio/cdx: add support for CDX bus
Thread-Index: AQHYwfd+6WpLgEu670uI7mK3gsgeSq3SpgMAgAAAlaA=
Date:   Tue, 6 Sep 2022 17:23:39 +0000
Message-ID: <DM6PR12MB3082B5227E5A81B35536AE0CE87E9@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-7-nipun.gupta@amd.com> <YxeBYiBXMLvIIRAX@nvidia.com>
In-Reply-To: <YxeBYiBXMLvIIRAX@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-06T17:23:36Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=9e0afe19-99d4-4341-b888-e7700f3212d8;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37c94338-8fe1-4805-15b8-08da902c8a11
x-ms-traffictypediagnostic: IA1PR12MB6330:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jUPiSh6opgXeoMTLEoeJMbbiQD7SGdwxQTqqrJFZPhkTcuegdQsf3v4QNFqcUH0mWThlESeuFhDRzg9T5hxJ+VmyqU+4WM3/DkVU+qdkLQTvUeBJ0d6bMVnoofleOmUc1UggX0TFUAW1qJOY9uo8pV//GBOlVE6mloBDOA48Jc71pw0+Yu/emWmEl56GNbqr3qvTu4RBUNP9bj6gjFgnuZJjMRjzh5K/yqu8fPVYH52J2/c0JkPOrEDFg2yX4RbJeqrRE2B9Y4+PRZOarBeK90t1YC/N4A0qmXGSQpm4FmuV4GjlewzEsY856/77kYNm+hLthBpimiiKmVmB0V12uj0OFz581N2bR2xmd4X9bt7u7IKo4krs6GKhVy8oOKQ/eSs9PDGhqqUhHI4co14uEZ/h+Kdmr951ISl/a+FNOLDOf5bnany3cKfAbHzrtm6UZ6xxUPYH1j/68Pip9oyNX5Uf0ja3sViZJTlQxC+DDXwH3J7W/fM/N/TTxmkkDqQ0pY/ZPCrkPPYIdlLj/JXYgq+p3qAoNQbgVwa6H5RKDGsLZplnKzU1cC0lkYCyCYQvT8rI6xrVwZBJGQiTw4Cfefx9wA8kbN05jguQpWjkMHh0nSsgZ+QDWNwlEsXE852OII+jqUANOFGhS2qwldd6ANPiWmza4s4YV/f2VhnQtaVlGSzOc/wIPVa0MGfqcnBpO6adONtH+SlViFyqo+OelyEtcBIrgi8xWIpgPvVVj0fQjdlV2p3XW2y4G87xydCdL3TCuWJLEQ1dBdJ61T8b1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(54906003)(6916009)(186003)(38070700005)(55016003)(83380400001)(71200400001)(316002)(8936002)(26005)(122000001)(2906002)(41300700001)(52536014)(9686003)(4326008)(8676002)(53546011)(55236004)(5660300002)(6506007)(7696005)(33656002)(38100700002)(478600001)(76116006)(66946007)(66446008)(64756008)(86362001)(66476007)(7416002)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1I4sL48YgDOXi8HC57dICMCwYYh1OEnZFfrNLW/JGmBzHoVlLFZDq/IVgqWn?=
 =?us-ascii?Q?Kn73ly5SArxRUz2SWeyQ1ROwEyptbDTBuHI8tOmq2k7cDuS3sO4EA5ROc9L+?=
 =?us-ascii?Q?eODKSYbsw5Qmvc+UiwO/MT/96gAlHaCpuAjqy+e3ietVSsSy6mVxqmd8hqnr?=
 =?us-ascii?Q?npbps78N5TLevbBFXuahGeKYO4zClKG2n1bE10X7E0nU8CbZEFJo663gHTDg?=
 =?us-ascii?Q?CVZBourVLrnXh6rOYj7sR53jr27r9Bhri5SFG6FSgjIXEtOjeRdyPInrPAeY?=
 =?us-ascii?Q?rIJi8zMtVaoB1QB586rxrEUhZmV5nBgu9Ubf+JfUvqp4AMTtA7nBtsTOBb60?=
 =?us-ascii?Q?QgwnbCHnS3vad25XIe6/V0q6NxifJqcge9nI0R7KMU1tIVKCqANXxQInLwKq?=
 =?us-ascii?Q?XR+qd1np4TECmTaFN8+vBhpi9Svh4Jp5eWvG29dhF39oVerkjQDMQkYrPyBu?=
 =?us-ascii?Q?Fvf4Vy31S6zLdKzoWx8h6nf5hmtoj4VPmb6tuBXBCu1loj5qqNQc9MZKVMxx?=
 =?us-ascii?Q?9R6ukUMTCThXDhSQc8AM3tHGS5UhOjKs8NVLYAF+yePyDdWjPlda5/pRRp5S?=
 =?us-ascii?Q?B+qW298orBgn0/1JzTHJs4vHNPEo8j1fNqcEJo0lpjxS8LZnSM3pMfOuIOP+?=
 =?us-ascii?Q?B+FtyAJkFfbvnO9ZfaZdK0xUv28jfBUoVdLE1uLQZ2zfDpxOKsnAWeumF4qa?=
 =?us-ascii?Q?K2fqzli/VdeIRs7+uUEMkwtgwDHo/A1zVCPV82W78x6aYXv34p+iF23OFrFD?=
 =?us-ascii?Q?IDxocq8A0lnUXB8wq5dYsOu4ovvhQZkEUVOJ6lX9BuBGnG7KWt4HD1SndT89?=
 =?us-ascii?Q?2A73mmhtWPeb6xSRBnYhr6GAcygbwjISwDlI7seLWPWapFfhqDCMhSFAYZZE?=
 =?us-ascii?Q?zdahrhFWzwvaa3MzoqDJCr3X+LVaT63Yt6FcFqgdCmBJeIHHMqV6Sn76gf6U?=
 =?us-ascii?Q?mlOJdlRKZOoxs7JizgCjyVOuDhJ4B/F/nx8O+DtlxXtPpoOD74Qr5EedwiyW?=
 =?us-ascii?Q?7KvCfGJTO/Lf+384rePrHyqk/oYUa8septWOgyuQdO5JlMYSqDTUseVG0hbQ?=
 =?us-ascii?Q?dsAigvP6dkYu31lYZc80y+47DahcxL9nVFEv8afRbNPhbXDTnGhQvGZgPR0x?=
 =?us-ascii?Q?qK3lj4KeGFXO+jxcFkrKWRN7A3QjPudrywqNaGkqNK7czpDwHaPIrZmu87Re?=
 =?us-ascii?Q?hrk/708jzT4bQAMI0TrxwuTgHyQuuiW9NAhOp4eAWxia6oJ1SP39ARL7HZPJ?=
 =?us-ascii?Q?seBhwPYPq85CKdUTGWdz3GFF3A2lBI37yTWEoDN5U1gqX/bbe4AkcJjHY28K?=
 =?us-ascii?Q?EJsuzhMbTM6TyJJ5vPQ0u7AcrVH8DDTZNT7hKH3T2CO0/vgt/kUpJKcUkOtA?=
 =?us-ascii?Q?ROKvMpysAfHSn0qvMboET9YeuN/LBHCXXPMg7tIJ1RnCQXlj4tpUE6QNkYAt?=
 =?us-ascii?Q?Qr40lniIqCN5+biQPO8AW0vSPNzZ8X0m6FR+NwfnGVI00j5XopFelxBBgdTU?=
 =?us-ascii?Q?TgV+1NG7hLUj8Ak7isKqmwK0Ff5ihrCqdO4xQnWC7vdRQxUqocuD45iLQo1V?=
 =?us-ascii?Q?+8rotFvPFC8avCeTn/U=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37c94338-8fe1-4805-15b8-08da902c8a11
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 17:23:39.5370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FuFRX16iOMcmHYjuimnmSN8nvjxvfqjyYrAOa1Oysig+7bm8ObOXt+zM6vTe8jxC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6330
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
> Sent: Tuesday, September 6, 2022 10:51 PM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>
> Cc: robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
> gregkh@linuxfoundation.org; rafael@kernel.org; eric.auger@redhat.com;
> alex.williamson@redhat.com; cohuck@redhat.com; Gupta, Puneet (DCG-ENG)
> <puneet.gupta@amd.com>; song.bao.hua@hisilicon.com;
> mchehab+huawei@kernel.org; maz@kernel.org; f.fainelli@gmail.com;
> jeffrey.l.hugo@gmail.com; saravanak@google.com; Michael.Srba@seznam.cz;
> mani@kernel.org; yishaih@nvidia.com; robin.murphy@arm.com;
> will@kernel.org; joro@8bytes.org; masahiroy@kernel.org;
> ndesaulniers@google.com; linux-arm-kernel@lists.infradead.org; linux-
> kbuild@vger.kernel.org; linux-kernel@vger.kernel.org;
> devicetree@vger.kernel.org; kvm@vger.kernel.org; okaya@kernel.org; Anand,
> Harpreet <harpreet.anand@amd.com>; Agarwal, Nikhil
> <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
> Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>; git (AMD-Xilinx=
)
> <git@amd.com>
> Subject: Re: [RFC PATCH v3 6/7] vfio/cdx: add support for CDX bus
>=20
> [CAUTION: External Email]
>=20
> On Tue, Sep 06, 2022 at 07:18:00PM +0530, Nipun Gupta wrote:
> > vfio-cdx driver enables IOCTLs for user space to query
> > MMIO regions for CDX devices and mmap them. This change
> > also adds support for reset of CDX devices.
> >
> > This change adds the VFIO CDX driver and enables the following
> > ioctls for CDX devices:
> >  - VFIO_DEVICE_GET_INFO:
> >  - VFIO_DEVICE_GET_REGION_INFO
> >  - VFIO_DEVICE_RESET
>=20
> For non-RFC posting please post VFIO separately after getting the base
> bus merged.

Agree, with non-RFC changes we will get bus merged first and then
have the vfio patches as a separate set.

Thanks,
Nipun

>=20
> I think you will need to get some work done to consolidate some of
> this duplicated code that was cut & pasted here..
>=20
> Jason
