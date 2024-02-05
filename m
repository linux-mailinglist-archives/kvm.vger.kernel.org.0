Return-Path: <kvm+bounces-7959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A2E258492D6
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 04:47:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14ADE1F22C14
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 03:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8970DAD35;
	Mon,  5 Feb 2024 03:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bMZ7BbZE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D157F8F44;
	Mon,  5 Feb 2024 03:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707104826; cv=fail; b=a9X/Ac6mO5SF2tOB0KacfRdFuk4Sr1ehtiAx1hs3voQAStTeWXrrRJxovok1dCoIfvuEv5AKTtOa8lZLPmXjHtzcjXUfzrN2DXUrsBZwgjwKIomMgH/tEVgklNXSbjOp+4Lit8veIVEJtFauYUgEXcxyHS2rxqQp+UFsICrR4Sc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707104826; c=relaxed/simple;
	bh=avqDGisFce63KRlmQHvZoLVbq3fcyCvruGar4O2wxAc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QQRvun43PqA1hTcVSaAo3dr6chnMaVH3fnLQYfqhtMIV+wMxPFV4GlMfZUupmjNy1B69pskj3pKsD0tKp5pQ3ji9YdPcMl4krL47RX55X8pRti7EflmnAA/WDjkeM/CatnMe2rwLRpHXl/SZNyLKxxqND1n/QyeeA303ZWKuyLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bMZ7BbZE; arc=fail smtp.client-ip=40.107.244.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kl6IDSEuORZENEJ7+Mz+wqEVci+YMPXkYwnjAl5Ol+SPZRfr8ljE9ieXPhZFKRk7SKqrPXKOjH7D3obqXD7mPwiaubKQz52dm7rQ9TMOaJXvacPdKMRBpSKCK+SVI5vBnEvemZUKpqrJbfMhhQ4SVTuyb9IlNrzWBG71Ktos/OifCEDHphlTCGYVyFaAXdtMXj9hkvyiXN2Cs3a6WhJT/S1M4u0eH80LtT1i4lVIqq04VfPrTt673B3i9ccT9YR/QH7wawhGiYC1KJTft2wz/0ifoeQM3LU4FLvv3XjAz7dAY/AIaiZwxdXVDt7bJhZ2a3yU+0h90JrkdXKrf6fdSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TogeLJwY7aTJwGMl4krqMlCtkKHY35TYdxq67sXZJBE=;
 b=XutfM8k3Ns2s/18YRIPUkVVbeTAWHG4LcUpLtv6xTdXCI627X8YVNdIEqOysiWidWJPkN++GMq0fro0PUOBjKyzKZi5+tPCh/jdbEY8eZJn1xbTL0SiiPgnkyg01opL+JcgZxOZFhASdzmz2/fUD2xVEHiuROkLXx9OG5/O7nWPUo8E+KKL4c9kleCN1868bW4UgU9T0fZXPFqZjQSse2+uMmsYK8sRq4HmOwLXg8RyLuV2y9OaU8QKs+pTF4cRJPN0DkOFksgK8xFRXROh3so2TnupVCZ975jh83JymH98JxIgDZ1mWQYqd3ks4tAYyGv1NAfsz6AWdmaDqMzQtnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TogeLJwY7aTJwGMl4krqMlCtkKHY35TYdxq67sXZJBE=;
 b=bMZ7BbZEjH1Hn4WLqpLBybjc6L1wR0vbvIcktj5myupuiFElXCknYHPttDrR6/1i0US4UHYFZwvauTjGAUVX5NDaHmTPxMB1bJLc4tnYupzXxsSLtrL2EDkvDmvHLbC0H/Ioumx6IO6RSBtyS3K34eqf52nt/abiAaOVFQQfeQ4=
Received: from PH0PR12MB5417.namprd12.prod.outlook.com (2603:10b6:510:e1::10)
 by CYXPR12MB9443.namprd12.prod.outlook.com (2603:10b6:930:db::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.14; Mon, 5 Feb
 2024 03:47:03 +0000
Received: from PH0PR12MB5417.namprd12.prod.outlook.com
 ([fe80::653a:d381:dc93:d690]) by PH0PR12MB5417.namprd12.prod.outlook.com
 ([fe80::653a:d381:dc93:d690%4]) with mapi id 15.20.7270.015; Mon, 5 Feb 2024
 03:47:02 +0000
From: "Deng, Emily" <Emily.Deng@amd.com>
To: Leon Romanovsky <leon@kernel.org>
CC: "bhelgaas@google.com" <bhelgaas@google.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] PCI: Add vf reset notification for pf
Thread-Topic: [PATCH] PCI: Add vf reset notification for pf
Thread-Index: AQHaVzFPJS4FqX9EC0KTmNBs3b7rorD6CgAAgAES9YA=
Date: Mon, 5 Feb 2024 03:47:02 +0000
Message-ID:
 <PH0PR12MB5417A9E79D51D2D21AB695178F472@PH0PR12MB5417.namprd12.prod.outlook.com>
References: <20240204061257.1408243-1-Emily.Deng@amd.com>
 <20240204112044.GC5400@unreal>
In-Reply-To: <20240204112044.GC5400@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=fde1eb36-7dc6-4627-9e0d-07d278d5db91;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=0;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2024-02-05T03:44:50Z;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5417:EE_|CYXPR12MB9443:EE_
x-ms-office365-filtering-correlation-id: 9df5757e-89ac-4f67-0281-08dc25fd1d4c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 dtP1zlzOHti0M8i9iwIZzeBYEjrmTMV4csI/lzrO4xx4Qe/k55Xu4149Oa54dhFosBgMEd7N5l+ylTRUDSr6Y3hGdYe1v0zNw8JGSwCFQ4DRCc+VUWrb9YkvcBJm8r84pboy1RHfpDjiKu9mdkAbxsMblVXMXfLTbiIibUsV6jYXvpsscpXqqc9cyIby3KpifgLEgcj3Ge2ZeRWwzKeY3fYMc4yFUNNyYy7sbd5tFzr+Cx2JJdSdGfm6+wj9aMjc9LSp7pwhZROBBeOeZJO116A4LHSVuKUyo4NDF+FojfrLVd0R6tRW1FQDEXmWgtRCgdH/muQ8TEIvQnlTj2UwYj/eg2v/WpSq1Or8uDV5O7LuoKliMOVhVTJIj9TQm4KRh5YLxdr6RzyqcVtpYYsKeix4U/YvW48gyVg4XkxMUkYlHPDRc0WOU40balpa9uafrXmi7Bd1rCdcSNWtzTVJd2qdHujn1JSIcLZcq+ZwbDJTmtyujaELJKHD0AIJz9iw131j7DurbnQ2AD1qq253K5pIgpb4s35pnGOivZDnYCugJwevirG5GB0N4K8u/QUA2kRGV7uGRdfR/NoU22soPOocEC4Mh+VYOzv4Z0DSsEiTOuzQFsi/T23iwCapXptt
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5417.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(346002)(136003)(396003)(39860400002)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(55016003)(33656002)(478600001)(9686003)(86362001)(38070700009)(41300700001)(83380400001)(26005)(66946007)(6916009)(76116006)(5660300002)(66476007)(4326008)(54906003)(7696005)(6506007)(52536014)(66556008)(66446008)(64756008)(38100700002)(316002)(15650500001)(71200400001)(2906002)(8936002)(122000001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?HWfVflDRqEQ2PbAZ892jpIhtWl9s/Zek4Vjg1wtORwJGdzpH3doLb3S4gA17?=
 =?us-ascii?Q?aBzRc/855Eja8IDhk3vdf5bHjas1xoeXb5D2RUz8n8RsGAtvCqSP1SICMrdQ?=
 =?us-ascii?Q?6EhbNEtthJq1w/5K6ohoAWipesyzlt0PVOkOLHMvOBuS7Jq6vHCJEbXANrGe?=
 =?us-ascii?Q?ysqBJRd9Nqv7VqS+AjW+23oeeL/F/+ZP3ba1FVwXou3xcp/GWMqm3zINSTZk?=
 =?us-ascii?Q?PUT8TM6oDZs9B6YDOR2Ge2tSstA+sEx5kXzMO+1g9QSIESUpAjcfsMie9m8E?=
 =?us-ascii?Q?SQvsC99DxqfcRwMdforNUhPO2WDXRvg2Oin4gAPob7STVMYEluS5ze4PWEn3?=
 =?us-ascii?Q?wlFHAUtFbIVuz+B3bRz8GbxvbGsQRqC3P4Al93OmV0O+nRCna7F9lvSzWECS?=
 =?us-ascii?Q?LpJkmDalYpHf4aRQ/2w/4pzgucauFKcrf2LREbzhW0Ur6CgXGWmwWyeFG9eQ?=
 =?us-ascii?Q?mNqO8riUer2886QxhNFuVvJE5WdwHTn4Y4bREyICv761mC+kGZ5coe+3kBRh?=
 =?us-ascii?Q?4cDQ+bz3TqZvKN274HGtpx1Egkq1s3yoQl2Y1+Z6xdOYGER67XnqnCIYrz7X?=
 =?us-ascii?Q?kvmg4Ab7mKI28dAeDCL5u7R5yS3C1ZlEquIeFaRtb1bNkP/irrmFV6lc1hXQ?=
 =?us-ascii?Q?qWy909UGxnL8YfqjpufzS3hi8hNg0bbUvEWDJzaOx84oeLOUTPRhYez+JlU/?=
 =?us-ascii?Q?JBMN+3s8YL/XhEOLaIG5X6eItOlA7WIersTekntEBNBugwRFsaN9Eec8jcKw?=
 =?us-ascii?Q?ftZGLfpU55NAkBIxBQP+JGCVAzNr2PWVKk4cOUj6PUYgIdFdyudb2hlwec2s?=
 =?us-ascii?Q?SD97o/raK2UPGEJ9Fyecfhh/U34Iw1lLE/aAj9Ma3UESopsxLxfUVHuLTKnm?=
 =?us-ascii?Q?ktI1C1ujYSyScP+nVzQk6dYGIbJLgKuiv9+jL695e2RNDYDrcI0e8lAiayrP?=
 =?us-ascii?Q?IIwWJYCBLRLpRlb4g/lg8TJuN3ohQkNuCZU5AHx9V4cwn5YS1jjNMFTod7lJ?=
 =?us-ascii?Q?FF0F03Fpu8JqZV4A4ckF3Bf3DyiDz0+Y/hHAsDzDsXrBF8auSaGr74yqE3gV?=
 =?us-ascii?Q?rZ2edpRjbBMOl13eDIWu6sHDxi9fRMaSWB/psVMunkVpj73GeJpvgEnXav20?=
 =?us-ascii?Q?ghCGwJuY/3GdXWOoprycURv+vAtXRodVNRATou6Umx7aFbEH+o+EX4mYylgo?=
 =?us-ascii?Q?r4/+Kt+OMGr7ZBttFEKh5UjJ3bJl6ZyhfSP4j+46ATKBfFJn6mtcIL+1l3+X?=
 =?us-ascii?Q?sb7CdmcqeGo2foRDvbeRFqzDkogRO3dcOATGMMWfk4eJ/hJRxxCQO0iuECod?=
 =?us-ascii?Q?h1R3iqtoNrvPzldGELZzUvpgkg2TthMD6eM2DaS/jkt/Anluv+y72py7sr6A?=
 =?us-ascii?Q?V923wFiDngpLbj/YdLOYMWMGo+gUrRPLnKp/zOQRRMX07ntBu+RZkRTThFWI?=
 =?us-ascii?Q?oVPZUbWdIzDDUrx8n8Y3BvQ1hNcpUqSTcXXSC7uNxeI/zR/C4N05J2U39AAY?=
 =?us-ascii?Q?KvUH/qPoCnEbva8WOBtoBq0xu0oP5qWjW/KrmdIIx+vRoi2RGaYmBDWR2Lzf?=
 =?us-ascii?Q?rEgkxyEGIWUMQeZOge8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5417.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df5757e-89ac-4f67-0281-08dc25fd1d4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2024 03:47:02.7898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rHRa1KBhck/1HCsZk69YNQcWXdidtRFOIX9khwnYzK11YrSvJqYXA+AcXdNkq6zY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9443

[AMD Official Use Only - General]

The use case is the vfio-pci driver, which is used to support a user mode P=
F driver. Will also sent out the vfio-pci driver patch. And add more commen=
ts in the patch. Thanks.

Emily Deng
Best Wishes



>-----Original Message-----
>From: Leon Romanovsky <leon@kernel.org>
>Sent: Sunday, February 4, 2024 7:21 PM
>To: Deng, Emily <Emily.Deng@amd.com>
>Cc: amd-gfx@lists.freedesktop.org; bhelgaas@google.com;
>alex.williamson@redhat.com; linux-pci@vger.kernel.org; linux-
>kernel@vger.kernel.org; kvm@vger.kernel.org
>Subject: Re: [PATCH] PCI: Add vf reset notification for pf
>
>On Sun, Feb 04, 2024 at 02:12:57PM +0800, Emily Deng wrote:
>> When a vf has been reset, the pf wants to get notification to remove
>> the vf out of schedule.
>
>It is very questionable if this is right thing to do. The idea of SR-IOV i=
s that
>VFs represent a physical device and they should be treated separately from
>the PF.
>
>In addition to that Keith said, this patch needs better justification.
>
>Thanks
>
>>
>> Solution:
>> Add the callback function in pci_driver sriov_vf_reset_notification.
>> When vf reset happens, then call this callback function.
>>
>> Signed-off-by: Emily Deng <Emily.Deng@amd.com>
>> ---
>>  drivers/pci/pci.c   | 8 ++++++++
>>  include/linux/pci.h | 1 +
>>  2 files changed, 9 insertions(+)
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c index
>> 60230da957e0..aca937b05531 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -4780,6 +4780,14 @@ EXPORT_SYMBOL_GPL(pcie_flr);
>>   */
>>  int pcie_reset_flr(struct pci_dev *dev, bool probe)  {
>> +    struct pci_dev *pf_dev;
>> +
>> +    if (dev->is_virtfn) {
>> +            pf_dev =3D dev->physfn;
>> +            if (pf_dev->driver->sriov_vf_reset_notification)
>> +                    pf_dev->driver->sriov_vf_reset_notification(pf_dev,
>dev);
>> +    }
>> +
>>      if (dev->dev_flags & PCI_DEV_FLAGS_NO_FLR_RESET)
>>              return -ENOTTY;
>>
>> diff --git a/include/linux/pci.h b/include/linux/pci.h index
>> c69a2cc1f412..4fa31d9b0aa7 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -926,6 +926,7 @@ struct pci_driver {
>>      int  (*sriov_configure)(struct pci_dev *dev, int num_vfs); /* On PF=
 */
>>      int  (*sriov_set_msix_vec_count)(struct pci_dev *vf, int
>msix_vec_count); /* On PF */
>>      u32  (*sriov_get_vf_total_msix)(struct pci_dev *pf);
>> +    void  (*sriov_vf_reset_notification)(struct pci_dev *pf, struct
>> +pci_dev *vf);
>>      const struct pci_error_handlers *err_handler;
>>      const struct attribute_group **groups;
>>      const struct attribute_group **dev_groups;
>> --
>> 2.36.1
>>
>>

