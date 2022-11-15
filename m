Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E47629759
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiKOL2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKOL2B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:28:01 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D7E23E9B
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:27:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PT5YE3pXFgS4l4RIxrHbTj/EZjHuIXghIfaYzozO8Q8EFboq5sMth/ewnD5yM+2HPoHVtoHLattYVZuwkITL3X8uUp4x9o/QxaCUHrv3ErSOb8C85uN94yJ/X9q75msKEShbk8k3JVhulRW97Fjy1h6gKrCgxEF+F7Z92ZFtnJvhhccI9oG/wStr2Urkw4fchRBzM27ljFVktMLxBc/w2Eqykj1J4+iF1uCcCcHRYNwn8ycnuSOWvCtdfQc8yl1gAYFTAV0CnSzidg5I+5zv47R0D5kWL0qvqzL9CqjNDO5WxeOid279/bmNNXCbRuT5FNvb46foOUctZmTd+H425g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6o38+sIf/GqUg8OeRHlpv3D1sUUxdxYGq+4P7zu0QQU=;
 b=AAnST8Uo2QJc3WBbS9SyQmG6kYdQSlYs0dtXZXjrrWQsqkemRGFXBsTBAmiIddXSoedi7PQIZaS3g/7iAMEF3w2GOyVEpjtkUqLc6qRK0FBA/Lfqa2jOHzOeqV5dOy22TxDDqzC0+vig+P+6P+vJxthsSRiwLGrUgQk3KJ080ZdYDSLRSs+olM1AD90RjxIb3oujEH+6sbG+waQdXJfE3bFWNVv1darO4VuUobRQ1etaa8cOgesnG4pq8H9YV28bPrjdUrfJOZ48Ac5Ho1MBqdkGfjEUR0hSeSZtduUUozQE/YZlJyJek5Y/6Nzcxre81zgIHXi/XsLUUf8Qsu9vzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6o38+sIf/GqUg8OeRHlpv3D1sUUxdxYGq+4P7zu0QQU=;
 b=HgQsJ6lZTvUYd3Lft04Z5Sw/JoJR9nwAnIjb3MjjScf2xBXFsze8MUCQPf7wldbM3RHkEl2H7l6UFg5Fx8aEewBOizBhieZbI84W03QGJYmoL22YvkDY5l7YQTHNSdkVLZD7+luHqmO6xH/HoASCf2OClSLevouJZBlD/FWcfsY=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by DS0PR12MB7509.namprd12.prod.outlook.com (2603:10b6:8:137::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Tue, 15 Nov
 2022 11:27:57 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4838:942a:8267:5ec0]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4838:942a:8267:5ec0%7]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 11:27:56 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Anand, Harpreet" <harpreet.anand@amd.com>
Subject: RE: IRQ affinity from VFIO API interface
Thread-Topic: IRQ affinity from VFIO API interface
Thread-Index: Adj4E4QdRzmK2kWOR2ytM0xkrT5X3gAKxusAACmcM5A=
Date:   Tue, 15 Nov 2022 11:27:56 +0000
Message-ID: <DM6PR12MB308232371114A287E8C3CB49E8049@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <DM6PR12MB3082B79FA197958F10F61205E8059@DM6PR12MB3082.namprd12.prod.outlook.com>
 <20221114083446.5a1cba71.alex.williamson@redhat.com>
In-Reply-To: <20221114083446.5a1cba71.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-11-15T11:27:54Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=2c0095db-53b6-4cc2-8059-bf8d89b8d32b;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3082:EE_|DS0PR12MB7509:EE_
x-ms-office365-filtering-correlation-id: 8b28168d-39f4-4fc0-c4a7-08dac6fc71bb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0qXtJc6W0XtUT4Vz3uEmvANqW6HeVQblM91icjvichmoPWKCbyZbvMusGpRAMom2119XLLwZAneeyyhg1uMRMrFGpm3TMV+8QE4MnI9Avb1ZN2b9OvkwVipRo69H9UxdgX/hDgPKI0iM+YYFb8lZYwu5iF0TIVR4E6WfJGoj8cxC+Li0hQ1VNBM/PrLmbzmpB0JnaCdk2UqemCaj89/KDLGY48yXDGf95WcFSRwvx/ctU5beel/5eSdCmVqHB4aJHkM74Bwt9v0yNb/MU0Y3NHaxxD+x3gWBV0zzbhkL6LJSFvyt3iwjOPiBnZMhbQleyTI6SPzJZc791ZzOj+EIHhNXIcTr3ekerCYX0/mEKPsZZUhiLPNQGPSqRkBIZQSLrODa5ScZ5OY1YihRTVgVywsLf1kCHehc32+See8BeXHSiF/W5HlOGXfA9oGYgoQ+2YjX+BpVCFe5+OenTkagKdL8X9jcFFdbHuluZIGGXsSxrZGQmjH/oRYIqIs/VJHt0Prw2qcVGQyq1sh6tKjRR2vkiN/SFUgX1p684ezZSTiFiwzfaX6olf/cDBB5UIBTZFbnk0iHeG3Er87mT9MRKJ1c7fbmxIXdbbqtMFCTIH5xPojcH/I3OpP+T2ANYyD3+IRnq1UdJBnJnc1sZ68tpKby6CzXt5zaGxp+xHZUxTFD9UdvM7XKoAYEF0yZ5zPHDwjwtyD70Xq0U5X6CDBp4qbTtRKi1uvXgpygdhWY7kKIU7RP2q2BkfIe52NiNi+106owRKJV04M5VNzRWwElIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(366004)(376002)(136003)(396003)(451199015)(122000001)(83380400001)(478600001)(38070700005)(33656002)(86362001)(38100700002)(55016003)(71200400001)(64756008)(5660300002)(8936002)(6916009)(54906003)(66556008)(66946007)(8676002)(41300700001)(186003)(76116006)(316002)(66446008)(66476007)(9686003)(26005)(7696005)(6506007)(55236004)(2906002)(52536014)(53546011)(4326008)(66899015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TPYrIVucCFei07kUbEad9nbpPBD6d4Yk7/PB9dZ4Gs3KAgU4dPFa2J8eN8UW?=
 =?us-ascii?Q?iv+OkoisIo8zzN9yBXMkGHQyiQPHKDtpZscTfJXHo994rOvES4ZjEb/MBuVH?=
 =?us-ascii?Q?Kxs0s2CyR52I2CQGTIMfEGaSnqWcdAIfSc4lRKPRIJEjB5FQPGXtc+63kajl?=
 =?us-ascii?Q?hHkr33EHmcXsefJa7AzsirUc+jM5rQRRT8vrT8sBm/KNvduFKyxCUc1Wsfoy?=
 =?us-ascii?Q?49T7P09PnpF7Ay3Pexe99Hjn5ryjRJerzpFYazo8WV5AnOcsJpQX+7dnXnHs?=
 =?us-ascii?Q?izbD8f2AcEBEWewTMRGzCf14+Nn/lP5oOglYMvQJ1pisGMbTBMHSHMB6Si2G?=
 =?us-ascii?Q?btiUDVk/NJTpv6jaO5GEoxSMhiA9H+bEWL4iHWBdf90YCZN8NgCd+DBVx5Yu?=
 =?us-ascii?Q?YbbSfjSv000vl3sxxb9MkG6fPXVa56XldjHGtgtL1JLttzObScQHVPJ+JxDz?=
 =?us-ascii?Q?Goy0qHaKCZvwnP/glBs/ZEQ62L6/Aaa9DkdCrTjD/S9QRX9oLPr04djVBiz/?=
 =?us-ascii?Q?WW/OEcXT8NILCxoCkr55rKe9gCLIO0vLRCTHd1HC0q2Ep0RAWXQVDXKzRwaI?=
 =?us-ascii?Q?bMrVWKS9qG9XvQAn6gMLLIPpNjnxmpU9xFunL9f74JOawBVe02d1xuqp91TL?=
 =?us-ascii?Q?z+lBZyHeGHohOjiEo1Jlo0L7Qy610oiHcBOB4EGum5+FewdXCxWvBFnGvsxV?=
 =?us-ascii?Q?RObkKPhR+3ClR+8q+vvLb9KxxXXakQmOTdm64wJaPeoZrp+T679qHq+T4ggC?=
 =?us-ascii?Q?qKjHdndGGa3n7zwL17StqRHpfctWNTCph8NTyjylAskexP+KEJf6Ib/hoWnI?=
 =?us-ascii?Q?dolC5esL6j1DDifDQo09bplfko4dlZ3QsVQwjT5wkCsWazRPNPcuk35t5hJD?=
 =?us-ascii?Q?peeiZwxFyPpkU5cngPiHuvH/BZbuyvYGtYxtTOPhmEacP8FWwyGkbD/0sfZK?=
 =?us-ascii?Q?KrbCw0nILFIEpKrBEyKvJtG3iR8Of3wXF6aP9ClxZPbXjFLaVLTCdy788gxM?=
 =?us-ascii?Q?YvVkYH390dnhabNxvFqDgl8JC9OTeaY09LyGXoaODHauwGY5YXSinPeJPha4?=
 =?us-ascii?Q?8jjYUsTIeLPEiTBNm7ccU/NrW8OTSIaedSpLZ0nCjXxT/9EjSpjnShdHiax0?=
 =?us-ascii?Q?fY77bW37XihP+JoKpP9icVFKAnQxFRW4QdotLDU0Wvsauffk1JFMHtQW0uQi?=
 =?us-ascii?Q?olyOvqVMZogXt6e8Kv+g1monAgMf8U1s7ntdUcnXlXJejM4tCjfoNGmduVDJ?=
 =?us-ascii?Q?5Mi79Sr/vO4oz3cx0KlVdmgmkjhPaIxQ9QO9rDGzovA7ThAx14BjJ/SHM9fN?=
 =?us-ascii?Q?yrFAbwNfPun+PxfHdlatbKMiYKeidBRzjewXsJylXmS+i4FE6p4boC4vwkue?=
 =?us-ascii?Q?Byn8pq2M+0CR3wPETT1Cf81oub36+iAvrbdzj3+O30rlkaEc7mD2Y1bmpXQP?=
 =?us-ascii?Q?52TD/4IOtt9r11lni+YTgFFNNWUKFY+EvSGAC3Z+8KNZ0VpxZR9RKu1fUMrO?=
 =?us-ascii?Q?chslijRPHvsVPkXUOi5EvIKoTucqPtIb2Z5eRYDiJKjRHxhnlmevTpDPWGSp?=
 =?us-ascii?Q?DvF2DiOhCkEc45Sfb3Y=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b28168d-39f4-4fc0-c4a7-08dac6fc71bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2022 11:27:56.8223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jw5ce3Km5uHjCW0JjEPpABCp1UQ0NAf/ZV/wl0c0GsgurVDDMNamZOCp2YvXY7IN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7509
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
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Monday, November 14, 2022 9:05 PM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>
> Cc: cohuck@redhat.com; kvm@vger.kernel.org; Agarwal, Nikhil
> <nikhil.agarwal@amd.com>; Anand, Harpreet <harpreet.anand@amd.com>
> Subject: Re: IRQ affinity from VFIO API interface
>=20
> Caution: This message originated from an External Source. Use proper caut=
ion
> when opening attachments, clicking links, or responding.
>=20
>=20
> On Mon, 14 Nov 2022 10:29:14 +0000
> "Gupta, Nipun" <Nipun.Gupta@amd.com> wrote:
>=20
> > [AMD Official Use Only - General]
> >
> > Hi Alex, Cornelia and other VFIO experts,
> >
> > We are using VFIO for the user-space applications (like DPDK) and need
> > control to affine MSI interrupts to a particular CPU. One of the ways t=
o
> > affine interrupts are to use /proc/interrupts interface and set the smp=
_affinity,
> > but we could not locate any API interface in VFIO from where this can b=
e done.
> >
> > Can you please let me know if there is any other way to provide the CPU
> > affinity, or does it seem legitimate to update "struct vfio_irq_set" to=
 support
> > the above said functionality.
>=20
> There is currently no way to set interrupt affinity via the vfio API.
> You're welcome to propose something.  Thanks,

Thanks for the information.
We shall then come up with something on this soon.

Regards,
Nipun

>=20
> Alex
