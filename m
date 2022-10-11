Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F045FB419
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 16:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiJKOF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 10:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiJKOFz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 10:05:55 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B129081F;
        Tue, 11 Oct 2022 07:05:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHyC84jtDM8wcaBsdzQ8LHNlN41Xf7+MzV18vaZrlOipyorRZacdOGx7aMELo8KBSevQcUHoXq5GZktIY+cKp9wsctwu0O1ApyBKSKnesMMsgSeiiW9m0+J4MiXGZPreQURebCWqSdQxAV+LpYs8S/tOefmqYL4YO1XDQRtp108hi5eFj6iKKyxiSEqkmpeDHTRoaj9wyOyfYTRYu06FH/cpuXDTTnkVuXGADfMCt0jgsryJ6vKs7ZRsVVLal9ujNT/WaR/v2VYep+gadGk9/kn3O5ICx5PUBn1V8zCzAIUjGFAsxevup6fNWeGHjqE4sd08avfxWCMAN8OFYyzqRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JkLEuNk3VzV9sW2V73dmkuYgAOs0nCQwhXGyPDPt9KI=;
 b=Pd3SFVoVWOgIQWSxz8WdmbG2fI3e2fAWlUJJc49Z390hw7dZN51r1MkT8K4Xz2GFgAOf3uHmonRkeIs7RfjyBwDf5AwCpDUxNGgEJmSwxn0wRawVCF+NVDanqPZoMpbP4hjtkMV/ZBz4sw5VxMNEwUOvNf8l3lJzcdRj+thPW1Lmpqu7l72U/rOVk6+3C6NYD5wi9RIAFHMbvY4qd3hOYPji70pZLpUixLF76z1llbK/Zntxra9d0P7mrj5McONBcqjIlQUWefYoMwkY1qlgAxajf+L5jFCsVdj9lsCwU3U4+gOPEJ/zXS52pTJr6CawbP138s3qE/LGmObF4YvtYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JkLEuNk3VzV9sW2V73dmkuYgAOs0nCQwhXGyPDPt9KI=;
 b=1qJd+v4hGAhA8XKXhCrhliFOiDNlpzAjZpVFDXtQsMV5UNQ5SHsvu+fb0Wc9XUZecEiOR/Y5EISlPM5a+0OId7TF5HasrSRG07ChRFTGADjmBJ6c+nQdB0YC/cpapFniVn7y2pqG3zYtEKbfp4hxDSzJrrEEYJQ2E3GU8ICZkzE=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by MN0PR12MB6053.namprd12.prod.outlook.com (2603:10b6:208:3cf::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.36; Tue, 11 Oct
 2022 14:05:51 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::f5f8:4688:2e04:4769]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::f5f8:4688:2e04:4769%3]) with mapi id 15.20.5709.019; Tue, 11 Oct 2022
 14:05:51 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     "Ma, Rui" <Rui.Ma@amd.com>, Bjorn Helgaas <helgaas@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
Subject: RE: [PATCH] PCI/IOV: Decrease VF memory BAR size to save host memory
 occupied by PTEs
Thread-Topic: [PATCH] PCI/IOV: Decrease VF memory BAR size to save host memory
 occupied by PTEs
Thread-Index: AQHY0X7RCECvmc6ZJ0OnxWUUfOu4763z19kAgBU3eRCAAEFiwA==
Date:   Tue, 11 Oct 2022 14:05:51 +0000
Message-ID: <BL1PR12MB51446437265DD1E8AA0794E9F7239@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20220926080542.920427-1-Rui.Ma@amd.com>
 <20220927220640.GA1728095@bhelgaas>
 <CH2PR12MB4838B7571D40D0CEDF30600D91239@CH2PR12MB4838.namprd12.prod.outlook.com>
In-Reply-To: <CH2PR12MB4838B7571D40D0CEDF30600D91239@CH2PR12MB4838.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-10-11T11:19:13Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=bae527d0-9544-4c72-ac95-fc57c150fa09;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-10-11T14:05:48Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 8b7ec263-f7a5-4b54-bc97-0f054e9d0bd0
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|MN0PR12MB6053:EE_
x-ms-office365-filtering-correlation-id: 91cae50a-cac1-4d32-abfa-08daab91b47f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kQ/sAORr3C27cdwLms5ua8Kf2UuCCgMVZxaR37e8EJSGBXYhfvbaYDdhDYODIQBRa3g4Xo1t7kDkkfoXWbGBEPrk61sACzBQEEPwH5OjQYZ9WbF2eDXpSrQV6BP476tVxPuy6tLHSty2zGzIji1Ty6qBjeea7tqX85OXb04OpelV8XTmbGGn4PBVsX0aWjQ3HfO0IGzdVtia1tRla2pVxTsTuD5KwYt3seR/++F3jReWJmZxAJ6X+QrF+IxerRH7PY4VL4t03AH1BkdBuGLQp72/YJmahQ1z93u+q9B7ev9jtmusCeFup9kTsGcmxZn5SsatHIczgyo6SPWWcE5EsEeg7wH7vRmctxQSI3/lzaijDYl5qEuOAoCLFu8m8a3FGmcu0hQHSAyAXAm8A0MWOVt/bEtaX/4taSkHDzfJHqGGDAFRL+ygeR09WYU/g+N16fuzTCS6pqtTNOW+tn+nSex3QrrSRugtBSXygkt170poB0IdfEEx4QQUsFZceKzZfH0I+Ymo9rxQfSApbfgnj81jj0ma84RdBHt6bsFvRQ+HDgR98QufMn8GnK6tPel+3UffezlKvWqaFcnJGp4jlgehY/GC8F5OmZ3o6Q7eQ3RUeXoFP9SdCKSY9JzpCVuAJSDlfK9AmO0QMxBkUGXyKr7PyuGNqnlsmxvez4gqc9mvpVlfP09j5qH6tB4twXAAbKSE4thrKzP5orJvGEceRQtG6uPklW6sZDatqNRijyPqXKlkJHxrCiwuIPpgffu/G/5tKdwCRG8HeoK8W8hp1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(366004)(136003)(346002)(451199015)(71200400001)(66946007)(76116006)(4326008)(6506007)(66556008)(8676002)(7696005)(54906003)(110136005)(53546011)(64756008)(38100700002)(66446008)(66476007)(316002)(33656002)(122000001)(478600001)(55016003)(26005)(9686003)(38070700005)(83380400001)(86362001)(41300700001)(8936002)(52536014)(186003)(5660300002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Yn4qwC9NkuH0aC7YNYoF0soJK+T8aDrBtkIDpWDzQIqXwsr2IXVa84Q2csYs?=
 =?us-ascii?Q?23hCaJzYEHVHY+EKK28I50lqzxmxy8dBLyKp6OH79wLgGW+4WOf4q/2JRYDu?=
 =?us-ascii?Q?7mK6FrS3AMrp9rhY/bf+nn6Nsm9uh+ynQRon50F52OuIPC/VjcFU3VtYkXo/?=
 =?us-ascii?Q?hXGq9DPgHzG2w8AQPHydbbsTDXvZZk68uvxjBgYSscA73LXUz9WwpmBROXlH?=
 =?us-ascii?Q?v/md20dF41rQVA8HM2DYV6oMx+y//l3Lgmeql40EF6aCqGzgWZeu2MN28reg?=
 =?us-ascii?Q?olgocGApNZjZJkOVslgjeMbVe3qKwPwjRlieY3lEOWp3poy6/8GxsmfTFTGq?=
 =?us-ascii?Q?auh62ITwihX9bitDW2cg2C4mY401PCQatHBaM29SAlsNU/vKM6pUkgKioNLM?=
 =?us-ascii?Q?P1/bUfF4imnbBM94wuAhnfFUM7u8yaGo0w2BRfUSWdGgsrXsEQjv1bqlFGVR?=
 =?us-ascii?Q?j4qTpx9bTsOIddciJACVQfolTS7PmDHdD5ZVInfQ0D0tSHbkFcxQ4KbEAvU1?=
 =?us-ascii?Q?GH3KbbSpMF+sRu0ILrvPVxZWgahcaidHgk3cP3kDFlDFLJgerf66+kZ4frlA?=
 =?us-ascii?Q?Kj7t0kYTKXQq59z5bMIVbqTbfqBP+dtWl1drs4e3yLsICcuvbqiH4koRjfMM?=
 =?us-ascii?Q?o/UnBMfcj2gKNzdhirvUSb+DckkDE1dTIen6LWCz7Es/AXoWIA8RWFw0fRYG?=
 =?us-ascii?Q?ewyMlQEEW4cpM1OsWZE9duXoD8NkIEovIt8an9toK/URIVquaSD2MDBsrR2c?=
 =?us-ascii?Q?IXM4h8T62DA55vYxI3pymbu96gI4QYXzwR8Zg9bWamdS7YtyhYiAdbcUGuHe?=
 =?us-ascii?Q?j1p34uBOCSvwe8w+fQv6XGkHr7XpMyVqqXhRl4s+3/wv1l7LwyuWYVjVrJxM?=
 =?us-ascii?Q?NpnzuwyiA8soTkNLjZjZ/NI+/lhRTQCctFHMpQ6t8V69c30zqwW1HfKpX/Gg?=
 =?us-ascii?Q?sebSNT0D7tbirFaib8tXytzBWvN6Y4fyRH5YuVevMHife2uexTgDgcbtFePo?=
 =?us-ascii?Q?7VtdDzyOWQh2TqI2E0eKpop+rPtY0D5kEGDZsF5cpNknKnUn6amedKxxmTzH?=
 =?us-ascii?Q?TWTuxCExG+mgvMZNJpCs45mr4jv7ZVYamjGdiC4aJp/TuKrhbvoiBoE5eDx+?=
 =?us-ascii?Q?oAzT5vhBVHRwC2tRFfNv8QNQF23ULeeezjYceMlOedQcbjx1nlltZDJSGxJ6?=
 =?us-ascii?Q?5rHG2RSK3ECQEE9n5yKWv+C9bglsIcUGgqwK3UUCTFCD0U/8n1XuAO1x39k+?=
 =?us-ascii?Q?/wKrt63Buh74VKmEp7/6CPhppU/3uzOi3LAg8ycQh8gMdyctrGEaycTP+5ro?=
 =?us-ascii?Q?Oe2LYQ3ZGhnJFcSM3rUOmJOHowZwGJjBuS927er3g7Uug7b4OqhoGaptfpK4?=
 =?us-ascii?Q?MnC6gRLqTwHlgVSFjVGgVTfjiqQLpz2n+JFyCvOcTqSzC1+8giqZ/LxKUXOs?=
 =?us-ascii?Q?LV2Z+cpzuevVM2TI/0J5cCUp1dEOKqSaPCFR8qP86UQsiWnbrdypoCBLa/Yn?=
 =?us-ascii?Q?vaOBjFFgOBqzH+O/oq/ESMf5eMyVxJcoY0VYV4+Dl+zYC3X91LFvUMnMwmZ+?=
 =?us-ascii?Q?npwLogi1evFL4AA55TfyZssQXSr94KROMLW6X6VB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91cae50a-cac1-4d32-abfa-08daab91b47f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2022 14:05:51.3063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eparh8fdmbaV9NcvhBJxsxZhvltqyS2mmG49RPAtTkJg1N71WGD9v6Bk29waQ22BU1ERWV7F+sKY25DOlmRAsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6053
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
> From: Ma, Rui <Rui.Ma@amd.com>
> Sent: Tuesday, October 11, 2022 7:19 AM
> To: Bjorn Helgaas <helgaas@kernel.org>
> Cc: bhelgaas@google.com; linux-pci@vger.kernel.org; linux-
> kernel@vger.kernel.org; Deucher, Alexander
> <Alexander.Deucher@amd.com>
> Subject: RE: [PATCH] PCI/IOV: Decrease VF memory BAR size to save host
> memory occupied by PTEs
>=20
> [AMD Official Use Only - General]
>=20
> Hi Helgass:
> 	Thank you very much for your suggestions on my patch!
>=20
> 	The patch is a device-specific behavior. In our AMD device SR-IOV,
> the actual VF BAR size is dependent on NumVFs too. If only one VF is
> created, the VF BAR size will depend on BAR probing algorithm as describe=
d
> in Section 9.3.3.14, but when several VFs created our own driver will
> decrease BAR0 memory size  according to NumVFs. So I want to add this
> quirk to keep Linux code and certain driver code consistent.
>=20
> > Except that this doesn't affect the *starting* address of each VF BAR,
> which I guess is what you mean by "BAR memory mapping is always based on
> the initial device physical device."
> Yes we should not change the starting address or the device cannot load
> well.
>=20
> > Well, I guess the device still describes its worst-case BAR size; the q=
uirk
> basically just optimizes space usage.  Right?
> Yes.
>=20
> > Aren't both virt and phys contiguous and nicely aligned for this case? =
 It
> seems like the perfect application for huge pages.
> It cannot use huge page though address aligned.

+ KVM, Christian

I think this is just working around a bug in KVM.  This is to avoid wasting=
 huge amounts of memory for page tables due to KVM using 4K pages for some =
reason.  I think we should figure out why KVM is not using huge pages for t=
his rather than working around this in the PCI layer.

Alex

>=20
> >> +		shift =3D 1;
> >> +		shift =3D virtfn_get_shift(dev, iov->num_VFs, i);
> >Maybe more of the fiddling could be hidden in the quirk, e.g.,
> >  size =3D quirk_vf_bar_size(dev, iov->num_VFs, i);
> >  if (!size)
> >    size =3D pci_iov_resource_size(dev, i + PCI_IOV_RESOURCES);
> If I hide get-shift func in the quirk is it concise to call pci_iov_resou=
rce_size()
> in quirk?
>=20
> 	And I solved other issues in the patch sent later. Thank you for your
> patience!
>=20
>=20
> Regards,
> Rui
>=20
> -----Original Message-----
> From: Bjorn Helgaas <helgaas@kernel.org>
> Sent: Wednesday, September 28, 2022 6:07 AM
> To: Ma, Rui <Rui.Ma@amd.com>
> Cc: bhelgaas@google.com; linux-pci@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] PCI/IOV: Decrease VF memory BAR size to save host
> memory occupied by PTEs
>=20
> On Mon, Sep 26, 2022 at 04:05:42PM +0800, Rui Ma wrote:
> > In SR_IOV scene, when the device physical space(such as Video RAM)is
> > fixed, as the number of VFs increases, the actual BAR memory space
> > used by each VF decreases.
>=20
> s/SR_IOV/SR-IOV/ to match spec usage.
>=20
> I think this is device-specific behavior, right?  I don't see anything in=
 the PCIe
> spec about the BAR size being dependent on NumVFs.  If it's device-specif=
ic,
> it shouldn't be presented as "for all SR-IOV devices, the actual BAR memo=
ry
> space decreases as number of VFs increases."
>=20
> > However, the BAR memory mapping is always based on the initial device
> > physical device. So do not map this unneeded memory can save host
> > memory occupied by PTEs. Although each PTE only occupies a few bytes
> > of space on its own, a large number of PTEs can still take up a lot of =
space.
>=20
> So IIUC this is basically a quirk to override the "VF BAR aperture"
> size, which PCIe r6.0, sec 9.2.1.1.1 says is "determined by the usual BAR
> probing algorithm as described in Section 9.3.3.14."
>=20
> Except that this doesn't affect the *starting* address of each VF BAR, wh=
ich I
> guess is what you mean by "BAR memory mapping is always based on the
> initial device physical device."
>=20
> Hmm.  This kind of breaks the "plug and play" model of PCI because the
> device is no longer self-describing.  Well, I guess the device still desc=
ribes its
> worst-case BAR size; the quirk basically just optimizes space usage.  Rig=
ht?
>=20
> It's a shame if we can't reduce PTE usage by using hugeTLB pages for this=
.
> Aren't both virt and phys contiguous and nicely aligned for this case?  I=
t
> seems like the perfect application for huge pages.
>=20
> > Signed-off-by: Rui Ma <Rui.Ma@amd.com>
> > ---
> >  drivers/pci/iov.c    | 14 ++++++++++++--
> >  drivers/pci/pci.h    | 15 +++++++++++++++
> >  drivers/pci/quirks.c | 37 +++++++++++++++++++++++++++++++++++++
> >  3 files changed, 64 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c index
> > 952217572113..6b9f9b6b9be1 100644
> > --- a/drivers/pci/iov.c
> > +++ b/drivers/pci/iov.c
> > @@ -296,6 +296,14 @@ int pci_iov_add_virtfn(struct pci_dev *dev, int id=
)
> >  	struct pci_sriov *iov =3D dev->sriov;
> >  	struct pci_bus *bus;
> >
> > +    /*
> > +     * Some SR-IOV device's BAR map range is larger than they can actu=
ally
> use.
> > +     * This extra BAR space occupy too much reverse mapping size(physi=
cal
> page
> > +     * back to the PTEs). So add a divisor shift parameter to resize t=
he
> > +     * request resource of VF.
> > +     */
> > +	u16 shift =3D 1;
> > +
> >  	bus =3D virtfn_add_bus(dev->bus, pci_iov_virtfn_bus(dev, id));
> >  	if (!bus)
> >  		goto failed;
> > @@ -328,8 +336,10 @@ int pci_iov_add_virtfn(struct pci_dev *dev, int id=
)
> >  		virtfn->resource[i].name =3D pci_name(virtfn);
> >  		virtfn->resource[i].flags =3D res->flags;
> >  		size =3D pci_iov_resource_size(dev, i + PCI_IOV_RESOURCES);
> > +		shift =3D 1;
> > +		shift =3D virtfn_get_shift(dev, iov->num_VFs, i);
>=20
> Maybe more of the fiddling could be hidden in the quirk, e.g.,
>=20
>   size =3D quirk_vf_bar_size(dev, iov->num_VFs, i);
>   if (!size)
>     size =3D pci_iov_resource_size(dev, i + PCI_IOV_RESOURCES);
>=20
> >  		virtfn->resource[i].start =3D res->start + size * id;
> > -		virtfn->resource[i].end =3D virtfn->resource[i].start + size - 1;
> > +		virtfn->resource[i].end =3D virtfn->resource[i].start + (size >>
> > +(shift - 1)) - 1;
> >  		rc =3D request_resource(res, &virtfn->resource[i]);
> >  		BUG_ON(rc);
> >  	}
> > @@ -680,12 +690,12 @@ static int sriov_enable(struct pci_dev *dev, int
> nr_virtfn)
> >  	msleep(100);
> >  	pci_cfg_access_unlock(dev);
> >
> > +	iov->num_VFs =3D nr_virtfn;
> >  	rc =3D sriov_add_vfs(dev, initial);
> >  	if (rc)
> >  		goto err_pcibios;
> >
> >  	kobject_uevent(&dev->dev.kobj, KOBJ_CHANGE);
> > -	iov->num_VFs =3D nr_virtfn;
> >
> >  	return 0;
> >
> > diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h index
> > 3d60cabde1a1..befc67a280eb 100644
> > --- a/drivers/pci/pci.h
> > +++ b/drivers/pci/pci.h
> > @@ -603,6 +603,21 @@ static inline int pci_dev_specific_reset(struct
> > pci_dev *dev, bool probe)  }  #endif
> >
> > +struct virtfn_get_shift_methods {
> > +	u16 vendor;
> > +	u16 device;
> > +	u16 (*get_shift)(struct pci_dev *dev, u16 arg, int arg2); };
> > +
> > +#ifdef CONFIG_PCI_QUIRKS
> > +u16 virtfn_get_shift(struct pci_dev *dev, u16 arg1, int arg2); #else
> > +static inline u16 virtfn_get_shift(struct pci_dev *dev, u16 arg1, int
> > +arg2) {
> > +	return (u16)1;
> > +}
> > +#endif
> > +
> >  #if defined(CONFIG_PCI_QUIRKS) && defined(CONFIG_ARM64)  int
> > acpi_get_rc_resources(struct device *dev, const char *hid, u16 segment,
> >  			  struct resource *res);
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c index
> > da829274fc66..add587919705 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -4085,6 +4085,43 @@ int pci_dev_specific_reset(struct pci_dev *dev,
> bool probe)
> >  	return -ENOTTY;
> >  }
> >
> > +static u16 divided_by_VF(struct pci_dev *dev, u16 num_VFs, int
> > +bar_num)
>=20
> This is clearly ATI specific or at the very least specific to devices tha=
t divvy up
> BAR0 in special ways, so the name is a bit too generic.
>=20
> > +{
> > +	u16 shift =3D 1;
> > +
> > +	if (bar_num =3D=3D 0) {
> > +		while ((1 << shift) <=3D num_VFs)
> > +			shift +=3D 1;
> > +	}
> > +	pci_info(dev, "BAR %d get shift: %d.\n", bar_num, shift);
>=20
> Drop the period at end.  If we're changing the size, I think it would be =
useful
> to know num_VFs, BAR #, and the new size.  IIUC, "dev" here is the PF, so
> this is the "VF BAR", not the BAR 0 of the PF.
>=20
> > +	return shift;
> > +}
> > +
> > +static const struct virtfn_get_shift_methods virtfn_get_shift_methods[=
] =3D
> {
> > +	{ PCI_VENDOR_ID_ATI, 0x73a1, divided_by_VF},
> > +	{ 0 }
> > +};
> > +
> > +/*
> > + * Get shift num to calculate SR-IOV device BAR. Sometimes the BAR
> > +size for
> > + * SR-IOV device is too large and we want to calculate the size to
> > +define
> > + * the end of virtfn.
> > + */
> > +u16 virtfn_get_shift(struct pci_dev *dev, u16 arg1, int arg2) {
> > +	const struct virtfn_get_shift_methods *i;
> > +
> > +	for (i =3D virtfn_get_shift_methods; i->get_shift; i++) {
> > +		if ((i->vendor =3D=3D dev->vendor ||
> > +		     i->vendor =3D=3D (u16)PCI_ANY_ID) &&
> > +		    (i->device =3D=3D dev->device ||
> > +		     i->device =3D=3D (u16)PCI_ANY_ID))
> > +			return i->get_shift(dev, arg1, arg2);
> > +	}
> > +
> > +	return (u16)1;
> > +}
> > +
> >  static void quirk_dma_func0_alias(struct pci_dev *dev)  {
> >  	if (PCI_FUNC(dev->devfn) !=3D 0)
> > --
> > 2.25.1
> >
