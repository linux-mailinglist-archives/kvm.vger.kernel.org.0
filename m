Return-Path: <kvm+bounces-28359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ADAC997BE2
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 06:38:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3B86B21D23
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 04:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6D9919EEC7;
	Thu, 10 Oct 2024 04:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="therNLnn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FE3321D;
	Thu, 10 Oct 2024 04:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728535068; cv=fail; b=NhYyc6gWPCUbkiDUQHmTcEfOC3DiyS8N0wzUk3O6jJLRYi53kAdhr6fJZSiKLCKAzE6LwYTJ2qBZaq2EfixlvXoa9Q7xl/EimXZqkDVuFXNAVMalUGeJcJccG/mR2GcBj5/57C0qDKxHZH9iRFuwEEIbk5L0HnZHZdKe6LH3qTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728535068; c=relaxed/simple;
	bh=2Ju2iA5LDB653EdfcM2z2mxcxXhlnlHdL5LDEHRar1w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MXZbR48BFpQFhd7NdldDK1GxOAO4VpGBs34A9NcF9SR9xE5cVsDZDAqfVZcF7V133IEX7J4nc4ObfFXrDoToQJ2Jg5hHA1Ax946ISVGoU+CnqFlhvA2O2CylbYiivhGzYu5lFBXRl5EES4whTD7whjyo2lTgQ1AEtUvdAFuIDZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=therNLnn; arc=fail smtp.client-ip=40.107.220.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wt+sTFgdvI5tvSL6o83xiWXZhdM/CyiYwDHlczpxwJJUsSM9FISfc2vQQBdDrc1NTv+aS5mYmwiFmaw+d6KqUmMGWdsd1TRHtJ2hne+czfIulzKUHN7c1LydjT0jvx9dpYymNpvS2Zl3/nXDNquQZ4R3m4so8qSgPjLAoJrEVEZ0M2NK/NzSKR1JEkWWhHurHnRIfo9NTxuTDxu5e5R+Mk4xwaFypSaECXLiLvwRVVUJia0AbZziTtj4LKh14U9iL9BndDewpkHeKOLaeGb3SeIAGnNrmyB2ZLKi75qW8n/lbS0TPdWurdD0MXqkR8x2FptN5NEfsL57SlLU7sJZUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Klvl+0k+IcZY28S/d1xTQ0dsUop0L+0uOzjkH7sZpdg=;
 b=JPGiWNAIVU52g+9AVEZKlSxjHV5OA0eMgJrvTM2s3WlhGeKt6TMyAMz/p4lEAhs+YO4J8bG6dbEwF9DnwnhxwuHUtcuEKZHzv3yW+NuDO8Vuz9TOnR8ko54RwiM3HmORjbfxbL6j05magh/TC5P4KoYyYsMLyuPxlhQk3JzIBEX5grE9Fm+VtgQzopQJ8E2MokWUliRiH77u3s4lkI6Jh0qGyoOWgrrYmObKwDAijhQK3K/Hu+Q95Qm/8aWrgdxMwIiNaBc+0MbF4WDarFzce6JGMSJTulvnhZH4Mq3ismnwd33/9cd+tvC+RrNiMG2mzGiWSDty/Tc6hSSfsTG3zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Klvl+0k+IcZY28S/d1xTQ0dsUop0L+0uOzjkH7sZpdg=;
 b=therNLnnQJoWAWU3GwEq8PHji3denVcw3rzffbsga/UXhBfUvNFvZ1Oa0mHWPjBZ560aecw057udqs6U8SezIGobiu+4l8SU4USBoN/J5Veg8gBVzgrJtaCdmXcp43is72mymh0oUgBlfdvh+rx0dUoqBEMKeGhH1t8eNZ3ASt4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19)
 by CY8PR12MB8300.namprd12.prod.outlook.com (2603:10b6:930:7d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Thu, 10 Oct
 2024 04:37:43 +0000
Received: from BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::ed5b:dd2f:995a:bcf4]) by BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::ed5b:dd2f:995a:bcf4%4]) with mapi id 15.20.8048.017; Thu, 10 Oct 2024
 04:37:42 +0000
Message-ID: <79ba9c9b-984d-41c7-be01-c6a8e7f7ebd2@amd.com>
Date: Thu, 10 Oct 2024 10:07:18 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 05/13] net/ntb: Use never-managed version of
 pci_intx()
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
 Sanjay R Mehta <sanju.mehta@amd.com>, Jon Mason <jdmason@kudzu.us>,
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
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Mostafa Saleh <smostafa@google.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Hannes Reinecke <hare@suse.de>, John Garry <john.g.garry@oracle.com>,
 Soumya Negi <soumya.negi97@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Yi Liu <yi.l.liu@intel.com>, "Dr. David Alan Gilbert" <linux@treblig.org>,
 Christian Brauner <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Eric Auger <eric.auger@redhat.com>, Ye Bin <yebin10@huawei.com>,
 =?UTF-8?Q?Marek_Marczykowski-G=C3=B3recki?=
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
 <20241009083519.10088-6-pstanner@redhat.com>
Content-Language: en-US
From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
In-Reply-To: <20241009083519.10088-6-pstanner@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0006.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::10) To BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_|CY8PR12MB8300:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c1b8c51-260f-4a03-6870-08dce8e54718
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S2xHMWc1WlVvbTVwWGt0QzVLY056QjVBSUpVZWV4WERRRHBoTlJLN3BIQ2xI?=
 =?utf-8?B?bXFlbnJsd2F5ekxBVnk4bUg5cWZ4T25KY1owQzgwcEZRN1J4dit1bDIwRnN1?=
 =?utf-8?B?SWtRL2VCTCtoRGw1RUwzbEpKRW93SDlzdnhsMktoMkZQQ2xIUjE1UGpuNjkw?=
 =?utf-8?B?cXlmeVJUNVpyai9UaHRpOU1IOWc4b0tNeXc5NVJRRWxxRjlXNlpjOEw3RjBP?=
 =?utf-8?B?azNZMi9xREs1UmFLc3NRRERFbVVGMWFEckNyd1JxampSLzNoM1hTem8wWTlW?=
 =?utf-8?B?UTJvMmdTTWI2eGVlOFhWRm5qSHd3dWdhN0MreXRrQnlLTHpwaDVKYWRMSlJk?=
 =?utf-8?B?L3NNQmQzUkovVDk0RURsYWNaNGpiaUZvV0JuWTdhTTFmMWRRZWxma0JRbzVX?=
 =?utf-8?B?amlVSi9malo2SVI0UlBDOXIrNnA4RE1Ta3lrbUhoLzVVK3VzNXVWM05sdGhp?=
 =?utf-8?B?Z0F5eG5uZ0xtcWNQZDI3eGUxUjlTQmZMT0dYaDRObERSWHpNajU1SWVRTHp2?=
 =?utf-8?B?MWU0OVFiaGsyRFowUGNzcWdHZS9ia09NSUhPcnhLeHV0ZlhFeWNyd3VkZ295?=
 =?utf-8?B?Wm50RGt6aVhtcGxTa1RVbEJmWUZlVXdvU0p5d3pMYnhvL0dSZER5U1gvWGpa?=
 =?utf-8?B?eEE5MTBQVHV6MTZzZGJlOXllQVg0QlBITlBLcG9IRXNZMXVxZlZkR1BkSkc2?=
 =?utf-8?B?UzBIclA1d0dNVklZaXg5WmxMVWYvaGMwMGlUOTJTZXBGZnRRbFNoaTdJeG9n?=
 =?utf-8?B?WVg4RFp2RW1WeWtTdVh5ekJNVGJ2MmlOVXM4UEl6R1hEc2ttS1M3dUliNUFR?=
 =?utf-8?B?TyttNDJSemFxL3dOMlp2Q3Q1ZXUwRUdXWHdnak8yQ1dKaVlURzBGNW5iR1FG?=
 =?utf-8?B?MGlTaEtSdFl0VTROUFhuNmxOS1dHcGFpVWFtNkRHQUZBZU0vUUxEc3g3eVFU?=
 =?utf-8?B?YTUvZkFGSTBPc0JkaHlFUmpCVjlIRGs1Nk1TbTVITzRwTjlRd3lvdlBLRDR3?=
 =?utf-8?B?bEFqOXFaMDg2enIxUGlwVTF3bVBkOW1lN0pQWElBSDBaZjZpdTlKYjc2OEVp?=
 =?utf-8?B?RkQra3hzZy9ucmh5WFZMRkRtY21mYzRra0RYaThHT2dsUkc0aEhJbmJkc1hB?=
 =?utf-8?B?Z0hMQ3lFZnF1WUpVaG00WjZWUk9vNC9iQ1FldlZKWDluK0xuZ0hYY3psRVZK?=
 =?utf-8?B?TkJOeFBhdmg0cllMWDBGUVpaKzF4bXpUVWVseU1BeFVlWWtQaDRzUlFtZU04?=
 =?utf-8?B?RVdXUVEzUGpRWGR6WlpSQmUxWVRlRm1HQU1FQTEySUFJa21FQm9aWTJXN1Bz?=
 =?utf-8?B?WGg2cmd2UmFYTzdlbG5oekhibkttR1NEbStnT2pEMDhWSlEyMkVjY3hXUUdN?=
 =?utf-8?B?ZUVRaXdtYjhsL1lGRi9xdDZXaVBMRy91b1lBVkRIWHBGSzNnN1J6WHRUYjY4?=
 =?utf-8?B?WXpVSXBGT0g4R1lVMFkvdS93K0NoQzJOVGp5Y1Vxdkx5SndscEwzM0hNY2FF?=
 =?utf-8?B?VWtrR2JKcHlXWHpXSS8rd1IvK1IzVEtCM1dHcHBPVGpjWUI5ZGtOTStBTGhv?=
 =?utf-8?B?Q2lJS2hTblFnNWwyUHZ2aGNTTU9Ram5wTHhDazhZeFovaFJQNzY1WDFWNllj?=
 =?utf-8?B?VklpaERqa1B4VTR0QkM3N3lPUUlkWEozUVVHRkxPUk5vd1BnMGpEVWUxNEdq?=
 =?utf-8?B?WWRZYnJmSjBaY2x4THNDcDFDNkY1VE5rTTBZSmNVU1lJVFBVbTkxc1FMbmIy?=
 =?utf-8?Q?fQxbUSn8voWg9m72DR7CD+eGOfL+bKZKv4gl32N?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dG9hUkhsZHBuK2JnNEFHa3V2VFdaVWw1Unh1cXVwWExaRkEvVWhUL01Wbk5y?=
 =?utf-8?B?UjJ3bDliaXpuckw2aTNla2ZuV0U2eFNyM2h5Wk1Pa0E4eEFpVnhwekpaaU5K?=
 =?utf-8?B?MCtZWEMxaFdKSXdWbEEwWWZyUzJrTVRiUFRTUVNZL095TWZDRTVHVzhCNG1J?=
 =?utf-8?B?YkpNc2xMTUYwcTJnRENZaVJvMHdoTGVSbDNUek1YeGJKaHdtNWpqL0tFb0hz?=
 =?utf-8?B?ZG9hdW5KRUxZek11UkxxMWV5MXpnZXY2UGQyVkdRU1l1WG9mNDlHVmlmL2c3?=
 =?utf-8?B?dTErS05kckpkQkxBM2oyakJtQmpaemFlaGxtM3BZMExraGFVcW4xdVBoNE9I?=
 =?utf-8?B?NFZRcjh2NllaUHZTS2J2NWpEUDd5aE9Xb0hwbnpsUGR2N3haOGRKc2t6allK?=
 =?utf-8?B?NDcxN2R2TWt5RUcwWng4SVF6U1JHZ01MVHhTQjVIZ0F6YVNhQzNTSHJEN3U1?=
 =?utf-8?B?Zm05ZTI3ZHVUYnRDNmxteVN3S1ZhTk9JZE5PZXJZblBVMXhhUGNSWm1SUkxW?=
 =?utf-8?B?dnhZdkZEQ3BGTE5tdnZkck9pdTgwcmdYQ0FaWHVGVTN0YVYyamEwd0JiUzhZ?=
 =?utf-8?B?V0xqVXNublJ0QmVHZ0FSM3JNbTlpYjJnTVc5QTFrY3BvWjE5dXZveWlzaUZv?=
 =?utf-8?B?SU5uY0JVd0JjQzdCeU9IdUIwRFNtV0pUaGxreEVEQVZrVnBiczIyV3ExQ0tE?=
 =?utf-8?B?OUhwaXpNOERSenBTTEEvK0FJVnQ2bWsyTmJtKzFOeWp6a3pBenMvTmVJdXpm?=
 =?utf-8?B?MWZseTY5YUhkMmdaTGNKQU1CbGdLejRVYjhQWm45Sm1IbGpVaGtGUXVvTXZD?=
 =?utf-8?B?eDF4TjBPQzFMRXo4U2dpcjQrTnlYc1h2RTA4VHFPc1pLSExoTExTczg0RTM5?=
 =?utf-8?B?a2pBSG45V3VmS0hIWGM4TEpHSjdyemVFcnVPUjVqcm5TSGRQSDdXNzFZZ09w?=
 =?utf-8?B?Q0xZemtUaTRwSzZheUY0N0tQZ2I0R1NWWEl6TUQ4bXhNVWdtbGUwck84czdB?=
 =?utf-8?B?QU1zcm5QZVcycDh2azJBdU1BK3RoVFF2Z1RIUnRaY1VKT08ram9SWEY2TitN?=
 =?utf-8?B?MDJaKy90YURzd1RHd1Q5ZkQzaTBKVTVnZ2JLYXpKOXBXeDRqV1pqNG1LN09p?=
 =?utf-8?B?OVllMnpBYzJTU01qZU0zd28yY21sckJXWXJPdVBwRDdCclV1dkhwQkpMWmtj?=
 =?utf-8?B?aFdrNWlkS1FDL1RyTVMzdnFpc0hoaTJTbWNmdllXaGJxVU4xYXVCTXFWYWZC?=
 =?utf-8?B?Und0R1g3MFpDb01OMEhTNVpsRldlQk9CS2Y0aW1BT3lzeG85c2ZyamcwVTQy?=
 =?utf-8?B?SWtPdTExSlBLVGdueitCYWVSZzlxWWlSdXFONDNZRm8rNTVmYS9EUDFXaXpX?=
 =?utf-8?B?bFU4NHRRNFpnZWc5R1o5ZkE3T28zR3ZOVFI5ZWZXREdpUkZCbW4yblNKWmEr?=
 =?utf-8?B?Z29zUWZJYTZmYytHbmF2U2dpV3ltNkYramlKeGNWbGtsNEVzUlJ4R3p6cDQ3?=
 =?utf-8?B?UG9PNWpqeFhTTk1KNVQ3NHg1MS9KYzFQTVNJem5qbWhCMlk2QXNtb3RFUkJH?=
 =?utf-8?B?TzRoUnhiVVloRElVTENEK3RYVjRXYVRDYnZBaG04SGlmWDZuMXlmTmU0S2pP?=
 =?utf-8?B?d2NnUDVuY2QxS2VqMUg3WWVSb292UVFueVlwTGMrVlAvdEdUZlJ1YmI2aTZE?=
 =?utf-8?B?Y05nZVhzaDZmZWRFMmdtc0FKVHFIS3dUSTB5eTRtdTBTdkFlenIvT0lGN3Qw?=
 =?utf-8?B?OTQvVHhlTjlXMnRnamFzZmdvV0hDbFNsQkJFTFZlRmpwMmdRVUxPQy9ESVZm?=
 =?utf-8?B?czF6ZXFDN3JmY0lIemlmY3A3NXRrZHpIUW9qNnB3QnFramNhM3JpLy9SVy9G?=
 =?utf-8?B?QmUrVXFtUzR2MDNTOVVFTDFYNitqcjRkcnZ5bUlDT3FZei9xdjBvRHVCSENT?=
 =?utf-8?B?OGMxaDFWRm9xY3NBYkk5aGFLNGpJbS9mSWtpbTF6RlFOci84ajV1cEJ5ZmpD?=
 =?utf-8?B?NWVyZ3JtcUlwQytvYjcrTnlJYmJJWElGS0JacTI0RVl2dGcwVDZkOFA4VnQy?=
 =?utf-8?B?NVlDY3dpOE9zc1Bmdkxnd3pMZ1VLWkhxRFRwdDlwOUh2by9NamVERWswbWxn?=
 =?utf-8?Q?aNz1Ck4pRRLj+rsSsnFZlgFFQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c1b8c51-260f-4a03-6870-08dce8e54718
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 04:37:42.2623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m0qLPNHieptuXDE6QrWF4k80opazgWD0GToi3pf7VL4bTVZyBi0AGjqiZRu4iTS4nLBvzm+aG7oGgdARyHAgXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8300



On 10/9/2024 14:05, Philipp Stanner wrote:
> pci_intx() is a hybrid function which can sometimes be managed through
> devres. To remove this hybrid nature from pci_intx(), it is necessary to
> port users to either an always-managed or a never-managed version.
> 
> hw/amd and how/intel enable their PCI-Device with pci_enable_device().
> Thus, they need the never-managed version.
> 
> Replace pci_intx() with pci_intx_unmanaged().
> 
> Signed-off-by: Philipp Stanner <pstanner@redhat.com>

Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com> #for ntb_hw_amd.c

> ---
>  drivers/ntb/hw/amd/ntb_hw_amd.c    | 4 ++--
>  drivers/ntb/hw/intel/ntb_hw_gen1.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ntb/hw/amd/ntb_hw_amd.c b/drivers/ntb/hw/amd/ntb_hw_amd.c
> index d687e8c2cc78..b146f170e839 100644
> --- a/drivers/ntb/hw/amd/ntb_hw_amd.c
> +++ b/drivers/ntb/hw/amd/ntb_hw_amd.c
> @@ -791,7 +791,7 @@ static int ndev_init_isr(struct amd_ntb_dev *ndev,
>  err_msi_enable:
>  
>  	/* Try to set up intx irq */
> -	pci_intx(pdev, 1);
> +	pci_intx_unmanaged(pdev, 1);
>  
>  	rc = request_irq(pdev->irq, ndev_irq_isr, IRQF_SHARED,
>  			 "ndev_irq_isr", ndev);
> @@ -831,7 +831,7 @@ static void ndev_deinit_isr(struct amd_ntb_dev *ndev)
>  		if (pci_dev_msi_enabled(pdev))
>  			pci_disable_msi(pdev);
>  		else
> -			pci_intx(pdev, 0);
> +			pci_intx_unmanaged(pdev, 0);
>  	}
>  }
>  
> diff --git a/drivers/ntb/hw/intel/ntb_hw_gen1.c b/drivers/ntb/hw/intel/ntb_hw_gen1.c
> index 079b8cd79785..9ad9d7fe227e 100644
> --- a/drivers/ntb/hw/intel/ntb_hw_gen1.c
> +++ b/drivers/ntb/hw/intel/ntb_hw_gen1.c
> @@ -445,7 +445,7 @@ int ndev_init_isr(struct intel_ntb_dev *ndev,
>  
>  	/* Try to set up intx irq */
>  
> -	pci_intx(pdev, 1);
> +	pci_intx_unmanaged(pdev, 1);
>  
>  	rc = request_irq(pdev->irq, ndev_irq_isr, IRQF_SHARED,
>  			 "ndev_irq_isr", ndev);

