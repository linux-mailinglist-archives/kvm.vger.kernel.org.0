Return-Path: <kvm+bounces-28370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A23E997F49
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:19:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E2A51F22EDB
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 08:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 657481D014F;
	Thu, 10 Oct 2024 07:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gcNfwOG5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF39933E1;
	Thu, 10 Oct 2024 07:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728544877; cv=fail; b=Jw0zzL5WtV6bsKZUr5/z48uXEzWgRX0NjMCinZrtbY17Zn6TzPelePB3OnPZG9H7gcj+exyNUPIQ9m46RKc2wPiewctEkIt4nHsAdI6zomZ/UKH4dwKT4B33GQhH9X5xQ9ypDDSIYS2t3mtNmeQwvwOQC64qA+bIPcutldea3B8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728544877; c=relaxed/simple;
	bh=9E0gFUuSK9b70XWQVY9GyTyLgEntgqNG9MR1buxWHJM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dEKgSD7LHYqOPRnMiFRTAK01WRR/5t+f7dUC0+DHCQ1PkEY7JsktLv7aYtvGtp4odYlgS7/nheKyAmuXchvLLWGUkH6HpeuxNLKTjQzyfDD95o5OOs4/9eKz1LCHJ6YSD3c+V9p/1M6+NXK6p0340GeCe1WrWAA0QH0UrXnjN4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gcNfwOG5; arc=fail smtp.client-ip=40.107.244.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yAyqsh9YTDBR6ZcP+oMdSAG9ku8Rl/GBejocvQjCW6Zi6xXypie891ohxqmhzBvqt+r4t0TmvCKlfA13qMckLcBnKTZoB0/cMWH0GjdE1mz6nVtu0uMqA4RkL738FFTkmzzYJ+FflKbrRFmuulhUjUN23WiHz2d2LC1C0IPNKsvpysWLrW75lTvZDjB8mJlteHD/hCWqRFNVqc1wZZ4MlBOUmKbPdFD5E8gTQ+QWi8NKbPgwwP+WinSCUP/6K1PhNn/+KGC/tpkGezcUBiGOTFMbYVClI+Zm/Z8+QIsb0AH9yXYCEj9XTFHb2eZqaGwNT6awVpNgjF8faULAP+ScmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5gql8I0ZYim7nFHQSGwxiJ3GfafgB16EOhhTpoC0OI=;
 b=Mh5mVSc07CmOL1qAmVN9EtMSzOH+rZY4cRhn69TWOmjvx9v5+7CpJTlSOQAb5QSUzRGQyj+Qt4F8+CrjJ8WMw+OR3U9OBDXiyHAbzuDdlzos/uF+8SvRhSEN7DZwgpDzA4mcEy7TJ+BxTrhGbU/FK08sU2T+f4XcKdZB3vnGPHbRBvzlEqt1nHz8m4y7qTIHjnNhDkVxBTWcI4IfkbaX4Mi27HS59H10QxEBWQGuFvtM+cLEklOqkSuyGWpUMV2cc/qVglh2nngFNM+2OkvEnTkLfFcgfxPW6wS5KmfuweSYzkBLA0KSG/Ryx+ToOY4AoDdvuRSRia7L2EVe45dX9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q5gql8I0ZYim7nFHQSGwxiJ3GfafgB16EOhhTpoC0OI=;
 b=gcNfwOG51d/lXjtp85kHgtnAoNZCEzJ2gR7yyrAKOHpP17As6WPgRudiZmDcrJ/4mgDv+6jVCWHfrqDp6AeVMnAQhgwV9CkXXY6gpwdiVo9WwH7j61XfY5X49ZKlHe4vfa1H6BkwbRW3ny3XI9SzEc6VrJfOJwfKfg4Zbj59gWc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19)
 by DS7PR12MB6240.namprd12.prod.outlook.com (2603:10b6:8:94::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.22; Thu, 10 Oct
 2024 07:21:13 +0000
Received: from DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::a3dc:7ea1:9cc7:ce0f]) by DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::a3dc:7ea1:9cc7:ce0f%6]) with mapi id 15.20.8048.013; Thu, 10 Oct 2024
 07:21:13 +0000
Message-ID: <8f0de41f-8add-de50-fc59-fceff30b9e38@amd.com>
Date: Thu, 10 Oct 2024 12:50:48 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [RFC PATCH 12/13] HID: amd_sfh: Use always-managed version of
 pcim_intx()
To: Philipp Stanner <pstanner@redhat.com>, Damien Le Moal
 <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 Sergey Shtylyov <s.shtylyov@omp.ru>,
 Basavaraj Natikar <basavaraj.natikar@amd.com>, Jiri Kosina
 <jikos@kernel.org>, Benjamin Tissoires <bentiss@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alex Dubov
 <oakad@yahoo.com>, Sudarsana Kalluru <skalluru@marvell.com>,
 Manish Chopra <manishc@marvell.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
 Igor Mitsyanko <imitsyanko@quantenna.com>,
 Sergey Matyukevich <geomatsi@gmail.com>, Kalle Valo <kvalo@kernel.org>,
 Sanjay R Mehta <sanju.mehta@amd.com>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>, Jon Mason <jdmason@kudzu.us>,
 Dave Jiang <dave.jiang@intel.com>, Allen Hubbe <allenbh@gmail.com>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Alex Williamson <alex.williamson@redhat.com>, Juergen Gross
 <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Mario Limonciello <mario.limonciello@amd.com>, Chen Ni <nichen@iscas.ac.cn>,
 Ricky Wu <ricky_wu@realtek.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Breno Leitao <leitao@debian.org>, Kevin Tian <kevin.tian@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Mostafa Saleh <smostafa@google.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Hannes Reinecke <hare@suse.de>, John Garry <john.g.garry@oracle.com>,
 Soumya Negi <soumya.negi97@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Yi Liu <yi.l.liu@intel.com>, "Dr. David Alan Gilbert" <linux@treblig.org>,
 Christian Brauner <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Eric Auger <eric.auger@redhat.com>, Ye Bin <yebin10@huawei.com>,
 =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?=
 <marmarek@invisiblethingslab.com>,
 Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Kai Vehmanen <kai.vehmanen@linux.intel.com>,
 Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
 Rui Salvaterra <rsalvaterra@gmail.com>, Marc Zyngier <maz@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-input@vger.kernel.org, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, ntb@lists.linux.dev,
 linux-pci@vger.kernel.org, linux-staging@lists.linux.dev,
 kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-sound@vger.kernel.org
References: <20241009083519.10088-1-pstanner@redhat.com>
 <20241009083519.10088-13-pstanner@redhat.com>
Content-Language: en-US
From: Basavaraj Natikar <bnatikar@amd.com>
In-Reply-To: <20241009083519.10088-13-pstanner@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0185.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::12) To DM4PR12MB5040.namprd12.prod.outlook.com
 (2603:10b6:5:38b::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:EE_|DS7PR12MB6240:EE_
X-MS-Office365-Filtering-Correlation-Id: 15c72fc0-62d3-409a-6ebe-08dce8fc1eb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T0FIdElJSzVXZlM1SDdVcW9xUHNGVEV0KzRSc3d3Q09RRm5LejNyVzFuMWpm?=
 =?utf-8?B?TyttQ0U3dzVnbzZNVFU4UUZQMzk2K05jZ0NoUW8zdG96NWNlbnBFU0hZQ2lV?=
 =?utf-8?B?Y1dsZHo5RUFvalUyT3EwUHRnYXpNMEdXS1daRU01YW9FSzdVU1dyMW1ORkpS?=
 =?utf-8?B?RnBBd2hNZVZsY3JtZjlqQU5XNjcyUHN5cVFyQVR2cEU4TXJJRGY0OWRaL1ly?=
 =?utf-8?B?K1NPa2hsU1l6azc5V2lyZ1ZKQU1USVVYaVFveTlSWHVPTXltMHBjYkVoai9T?=
 =?utf-8?B?UzlEeWx4aVNtV0Z0R3l0enRLQVFiUHpnT1haMkwvU3JxN041OGZJUHp0OVVK?=
 =?utf-8?B?MFhmM3NZRDJMZHpveHFVTTJ4SWQzaHAyTnBPTk1Ydzdjc3V1UjlqZk9VRE9U?=
 =?utf-8?B?SjdsNFNtQko1MmRBR0hRVDBuWWQ2RXVtOEVoQzlpT3UyQkNwekl5NWVIWE9K?=
 =?utf-8?B?V1prTTNmT1dpNDJBTXlmSXJGUWtOMjBsUEl0cTBJSFR0WW1mTGF4d2hac2VX?=
 =?utf-8?B?NFMzMUF4OFNkL2xTRnlNaTdYTm5YeTZxQ0psUkoxN1JsYitpVldyNFVVRnZH?=
 =?utf-8?B?ZEJZYUVvWDBxY0pCWVF5T0d2Q2ZYMlM0OThaMDkzOS9FMmdFN3dIUTVvMSsz?=
 =?utf-8?B?WVE4NHd1NThGQW4xSC9QbE5uOHNuUm54cWxwTmp6K3Npb2NuUkFQV3h0R3hW?=
 =?utf-8?B?NFRQNXhWalJoMVpyYkgwdm1ubmtVSGNoZmJxRm0zelR3VXZod01HaE5rUjJS?=
 =?utf-8?B?bGUrNUZvNGxPR2loWEhTTXVQQmdIbHpRQksvK2hIT2UwTmlOanliRnF6MDg1?=
 =?utf-8?B?aVNIdm1IcTk3OEVRV05yQkNlczJiVlRnZG1YM3ZBOFNlSkNGek5LSjVhWll5?=
 =?utf-8?B?bTRJRmw2OFNjZTMxZlF1ZnplVmZIUnVGU29CUjN1QTFBRTYwcG1LK1l5OUZB?=
 =?utf-8?B?aVpJTGVzUXAwZU14eEZiK0ZwcndHejh5a3M4T2FuemNCVGhNSkZoVFhwMkt5?=
 =?utf-8?B?bXpQdlpEMldIaWZVeXlMSVBkRkFHVWZGZExsaXVPR2tPYmNhbWs1T0g0V3JW?=
 =?utf-8?B?YzNua2V5NXpnWUdtaDVqS0cveUc2SW1pZVNkZWNGUXhrZjB2N050OWMxT0lP?=
 =?utf-8?B?ckpVN1Y2dkQ5Z1cxQmhjQkxwTVZzdzlHazZrcHB0WnFJVGVNdC92b08wWFpQ?=
 =?utf-8?B?VDBEeXZxdHplM0NCalhWNlJLVkdLbHpJaXA4S2JzS2xtcUdoMjVjalp6UExh?=
 =?utf-8?B?R28yUytsempHQjIrdHJmbGc2ZGFLM0ZCenZkdVR0OTN0OHVSY2xVVG1NR3Vi?=
 =?utf-8?B?TnZiMHRxWWNPTzUzdmhXVnErYlRBQWxOa3Jta0cvbHowU0UxTTZVSk5ScmpY?=
 =?utf-8?B?UGlOUWd2UEdzb0ZPNHdza1lEcG9KTkZPVjdmbnVSYnFWcENIZmJmMy9KYkhU?=
 =?utf-8?B?YTdTVlhUTVRPd25JdnovY0lVc1o0RU52ejRjTU9VZ3IyV1ovckZ6NGZjVUw5?=
 =?utf-8?B?a2hKRk9OUFc0bU03MWxYUTUwc1pHUytxcnEyaVgyNVo3MWNyRnFoR0JidjRG?=
 =?utf-8?B?K0VERjgxMnRvQ2VsWWpaUG5SMVFTaENXWm80cy9jNW84aUdEb0EzaXhhWGV2?=
 =?utf-8?B?U2hCSm1ZTlNCYVZDQzBzRFE5TVRDVC91VndsVVVtSzZQTW5EMHhNRWRMbVVl?=
 =?utf-8?B?WlhKT1F5MUMxTk9qWmJnenN2NU1QSWM4d1E3SmovVmdvS0RUam9Uc2ZRbVoz?=
 =?utf-8?Q?w96hM57Pd9ZE7qYoOPmR2yJ/T6t1IUhoELZFvY/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5040.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MTBIZkQ4dTArdkhVQjRXazRzSXpZWFR0eTFoZG1XZnRUNWkwRWFUTzRIeVJK?=
 =?utf-8?B?Q1h1a0JwVmRmaFM4UmZZN01KN2djV05PVWJsM0RnTUVWYjJiVWk2dEFVODM2?=
 =?utf-8?B?R2FkSGZaRTBBZWZYcWIyeTRJdDhNQ0FlNmErdUtNckU3K2Y3bmJQNmdKeCtF?=
 =?utf-8?B?cHA3eWNqazJkdmJKZGJaOVFtREVvajVWa0NlYUdvSzhvcWdJWC9hdExvY1o4?=
 =?utf-8?B?QUk1c0lTUy9PYUxHWmx3cmo4QUUzUVZNNUdRYUl2NGlYYVhhQWpWTVp0MEdm?=
 =?utf-8?B?dEVUc1paM2ZYcXlmdmFrVVVSY0dBalVabXl5MFNCTldXZElTd0R0QUdRUjlt?=
 =?utf-8?B?cVNINEVyaWV3b2xnYVlkRitEdW0ydUV3SHVybXZKaGl5Q2Q4UGZSZVJRcTds?=
 =?utf-8?B?MHVpY2dRTy9YU2RFbWMrYTNVbU5nYTRpUklyaFJJR01OWGxKSnovd250eEVs?=
 =?utf-8?B?TGJmaTg0MDE4QlQ2SWhELzhQTk9FemcwamErTkdUWjhtZlFDcDQ0cGNTT3Ri?=
 =?utf-8?B?WkFsdlVURW1DMm81amM2VEdZdVJCTEdxM01mTWs3Vml4SDlFVEhxUmF1Wmtq?=
 =?utf-8?B?NFVFSVp3WFZiS0ZydXMwOEZ1V0JFS1dDcmRwVjU0VloxVW8xMGZaVUoxOW51?=
 =?utf-8?B?RmllcjA4NGNHYjlJR2ZONmZRbWN0ODhwcUFUaWIwV2FnWEIwa085aUZ5aDN2?=
 =?utf-8?B?QzBreEh4VFFOaEFVL2FydmV1Qmg2NDA3ZHVab05qUlVJdWJrWFZQcDlXVnEx?=
 =?utf-8?B?VklVYlpTZTNLaU81LzNwUHBYQTU0TnpvWVp1QmRqSEU4QStsZEovVkxJczRG?=
 =?utf-8?B?cVFyb2JKWXdDZ0JPWVdyUjFZZHVOWjM1MEl4MUcyMk9BUVAvdUxid2ZlNDE4?=
 =?utf-8?B?M1Q3VlJITHp2V0grQ0Y5anl4WFZ2UU9uYkRJc2d2R0JRSERwbkFTODdBdE5u?=
 =?utf-8?B?RXZtdTJSaitIS20yeHBSOXlQTEczamQxd2xKM0k2Y3lwMmZoTHVyaGhCMk5t?=
 =?utf-8?B?VVhnNFVZNWcrVDdRbWFNNTVrUlNIL01vUm9iQmFDbXAwUkhYcDA2NDQyMzBQ?=
 =?utf-8?B?clMrZjFXWTR2OWJhOTVCd1BkMmtpREdZVDJJU0FuS1prUlRWdDBMNXQxenRt?=
 =?utf-8?B?aWxCY1BiWWV3QnUrZ2lGbVFpZmRWK1VuRXpSN2NiMjZHWUNmRVZ4U21uUGIv?=
 =?utf-8?B?T25IbWlRRVJXcENFYTVEc1ZDTzdaZ3NPTFpTVTBPMlIwM3FwMlJ5bGVKY25V?=
 =?utf-8?B?MVB3b1lZQUkrVEZJeTh6TEUyRzA5WW5STzFMNEQ3TkxKejZobWFDVHE3RzdE?=
 =?utf-8?B?aUQ5d2hHa0R5bUFkSGdhMDVsV0JYTmtmTGFDd0d4RTRyN0REZXJPR0luS1c1?=
 =?utf-8?B?VVJCNkVoNDJvbGRmaDRJZlN3Tk9XQi9BYjBCb2NKOHhmL0VpZVFKekQxUURR?=
 =?utf-8?B?N0tIdWp5Z0VIcXBDMXlGdU5GSzNyQnY3TUo1TEhRTWRpOUFRSHJIVVR6Rjlp?=
 =?utf-8?B?blNSQ3RKRmd4TUJSeGhVTGk1ZWlDT2xoVWdtNEhtRDd3QkhHaVhKZWxTUlRV?=
 =?utf-8?B?TW1TSUpVYmwrOWpqMklqZDUydHQ1YVhJZnFTc1dxM2IwamtkQ2FvSDgycE1i?=
 =?utf-8?B?Nitqd3I1eEoySHB4NFYzUVlBSWFDdVdhaXhvR29DNTJnS1hiQzUyQlNZSFQr?=
 =?utf-8?B?Rk9vMWphSUQvaE85OW4xZHNYay81KzZ5MmRJREYvRzlxVlk3dlRiT1JUSEkv?=
 =?utf-8?B?WlVGMVgvVk5TQ3JQczIvbmcwYlpIc05PWXBURUpBM2luSG52Mk5xeTFFZ05v?=
 =?utf-8?B?bmZ1ZXVzbDU5b1Q4ckNoZ0RhQ1Y0WkVpdklraFJVUzZ5QnUyUkowSlYxamZH?=
 =?utf-8?B?K01LekNxSEVPdUprN29rc1AxbGUzbVhwNUVudXRpQVdyMHptT2ppejJTS2N0?=
 =?utf-8?B?M1JsQW5JVnNLUHdqK0pFemVuV1pHRm5YUjd3QVlpNitjbithUnpZdUg0SEpp?=
 =?utf-8?B?NXFnYlJ4MW1NU3lJWVd1c2J3bXFrR285TW5UZ1NXaGp1UUxQNHAwbXdSUGVF?=
 =?utf-8?B?Y21PSnJVaEJTbkltdUtZY2dKVFZIMGsySFRYMy9wSzJiemtMSTltNFpJMjZF?=
 =?utf-8?Q?KAjM/sLwRVzi5qSJwfywjdo5u?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c72fc0-62d3-409a-6ebe-08dce8fc1eb9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5040.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 07:21:12.9064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ClxSJbMypjwSgVNXE+ayKv16uEk8DwlwCohpEbKZJ5sfusyFiE3sCLj3f37cgUNKq4JuxS3ST++tOH1qsE/kgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6240


On 10/9/2024 2:05 PM, Philipp Stanner wrote:
> pci_intx() is a hybrid function which can sometimes be managed through
> devres. To remove this hybrid nature from pci_intx(), it is necessary to
> port users to either an always-managed or a never-managed version.
>
> All users of amd_mp2_pci_remove(), where pci_intx() is used, call
> pcim_enable_device(), which is why the driver needs the always-managed
> version.
>
> Replace pci_intx() with pcim_intx().
>
> Signed-off-by: Philipp Stanner <pstanner@redhat.com>
> ---
>   drivers/hid/amd-sfh-hid/amd_sfh_pcie.c        | 4 ++--
>   drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c | 2 +-
>   2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
> index 0c28ca349bcd..48cfd0c58241 100644
> --- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
> +++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
> @@ -122,7 +122,7 @@ int amd_sfh_irq_init_v2(struct amd_mp2_dev *privdata)
>   {
>   	int rc;
>   
> -	pci_intx(privdata->pdev, true);
> +	pcim_intx(privdata->pdev, true);
>   
>   	rc = devm_request_irq(&privdata->pdev->dev, privdata->pdev->irq,
>   			      amd_sfh_irq_handler, 0, DRIVER_NAME, privdata);
> @@ -248,7 +248,7 @@ static void amd_mp2_pci_remove(void *privdata)
>   	struct amd_mp2_dev *mp2 = privdata;
>   	amd_sfh_hid_client_deinit(privdata);
>   	mp2->mp2_ops->stop_all(mp2);
> -	pci_intx(mp2->pdev, false);
> +	pcim_intx(mp2->pdev, false);
>   	amd_sfh_clear_intr(mp2);
>   }
>   
> diff --git a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
> index db36d87d5634..ec9feb8e023b 100644
> --- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
> +++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
> @@ -289,7 +289,7 @@ static void amd_mp2_pci_remove(void *privdata)
>   	sfh_deinit_emp2();
>   	amd_sfh_hid_client_deinit(privdata);
>   	mp2->mp2_ops->stop_all(mp2);
> -	pci_intx(mp2->pdev, false);
> +	pcim_intx(mp2->pdev, false);
>   	amd_sfh_clear_intr(mp2);
>   }
>   

Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

Thanks,
--
Basavaraj



