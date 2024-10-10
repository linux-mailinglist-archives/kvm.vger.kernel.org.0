Return-Path: <kvm+bounces-28360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1A80997BF2
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 06:43:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1DF1DB2291C
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 04:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE17819F416;
	Thu, 10 Oct 2024 04:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Gg1fFpsd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2044.outbound.protection.outlook.com [40.107.236.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8700A19AD73;
	Thu, 10 Oct 2024 04:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728535380; cv=fail; b=SLhBkPDZzvxvlOzHCgGSTRmMsooP4sI7PEEnuVwr14KJBFv5nyUh50PS7WKmxx6r9uyirQZgox0qJNxJKBlciRNAy1jWz6UCV9s7axXYQxjZt5fC1E+ba1PtMGH9/nJqqsPHBgId82931BZVpapo+tncl1fFNtmpdj+Ja7Ybya4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728535380; c=relaxed/simple;
	bh=2Ju2iA5LDB653EdfcM2z2mxcxXhlnlHdL5LDEHRar1w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HhrR+y/OCeDm/QCCHZ/+rFtBLGE/oH6kIXLdOWvETvls9XO9J5GiB0Fc7ucnoKOMYA+vdoWGzix3SQbJjODhrwNlpkExuLFsIg9aFvR+N/WTVf1sjGP19LFDLVxigNbpnCKJfY8hr7I4WmkPCs2R1PhsNPmZq/U343yrZmQJpsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Gg1fFpsd; arc=fail smtp.client-ip=40.107.236.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LM2RQTywtsDvhV+D7HUhGtmhYRzc8D1v7tTf7FzjzwBQViyBFkhwAGit4zugaHZ6WqDS5+DI9/XQQDpdtIsZYTz1BUQXd2sXt7jjsySpsaurNCHwmgXqvLtQWGy6hoKE2lxIAB2UUa2jgN8iP/SaD+69FTHIiPvraaiTBVQ7H7/3xeDClXKIz8qeHwvioiwjya0VAbs5AOPJibBDAf8FZpa8R9yM1lnEr/xQrOlZ92fUOGdQorn5shSGFW3gnw8FJDKlzMIGcEwz19Zc/Guy/lR/F66SISYRoGdTjuuCPbP5n0YbDZksrN0bQPWDsRzFUr4tzmSyg1c1qryaNHkuWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Klvl+0k+IcZY28S/d1xTQ0dsUop0L+0uOzjkH7sZpdg=;
 b=vX7awtTupLUr/F/VVJsANxdlBNuuS/E5oKdp7xBtjbDfF5WLqPhOwEvc34Lm5AAf7BGLarEMOKJrXTuxludph8OX+YAkRyPDNHfGwN2bQzS5IdfVF4ElfJQW0n+0x/Vse7JJ72V4gi86lHbgcemJ6HQkdoc6TLw4sGZ2Khi5dcxj92FR2DeVlJfGbsHvEpx/w690H3+HTrrS8pmVG0w65vAYCsiX8g9kY27eSVpP83CHigrZtH8JZePucXZJwuKPtBNxXPW0hYr8Urq8oKW8RIOeRju/C9pP66qmvxNH/LrOjBy8JWa6F0110zOJEPmrw/yWlJu1rWrvrPiOIEdIVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Klvl+0k+IcZY28S/d1xTQ0dsUop0L+0uOzjkH7sZpdg=;
 b=Gg1fFpsdZxlj5mQe+zmxmJOlNSGcblhtvU1V4/kBdsFu74muSNBX/QP70z60M8Ay0WEooAo0kKBcarTCHIAqEoKVWhVfJhSl9jswaTpU7i4k4GrfH0b78BiubDWJ0z3y0mSfkNw3OJVAhYp57o8AOekfn3QlVycdE0Zq4AwO4QQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19)
 by CY8PR12MB8300.namprd12.prod.outlook.com (2603:10b6:930:7d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Thu, 10 Oct
 2024 04:42:55 +0000
Received: from BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::ed5b:dd2f:995a:bcf4]) by BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::ed5b:dd2f:995a:bcf4%4]) with mapi id 15.20.8048.017; Thu, 10 Oct 2024
 04:42:55 +0000
Message-ID: <c6473440-7369-4333-8263-1f5ddc6d736d@amd.com>
Date: Thu, 10 Oct 2024 10:12:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 05/13] net/ntb: Use never-managed version of
 pci_intx()
To: Philipp Stanner <pstanner@redhat.com>, Damien Le Moal
 <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 Sergey Shtylyov <s.shtylyov@omp.ru>, Jiri Kosina <jikos@kernel.org>,
 Benjamin Tissoires <bentiss@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alex Dubov
 <oakad@yahoo.com>, Sudarsana Kalluru <skalluru@marvell.com>,
 Manish Chopra <manishc@marvell.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
 Igor Mitsyanko <imitsyanko@quantenna.com>,
 Sergey Matyukevich <geomatsi@gmail.com>, Kalle Valo <kvalo@kernel.org>,
 Jon Mason <jdmason@kudzu.us>, Dave Jiang <dave.jiang@intel.com>,
 Allen Hubbe <allenbh@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Alex Williamson <alex.williamson@redhat.com>, Juergen Gross
 <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Chen Ni <nichen@iscas.ac.cn>, Ricky Wu <ricky_wu@realtek.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Breno Leitao <leitao@debian.org>,
 Kevin Tian <kevin.tian@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
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
X-ClientProxiedBy: PN2PR01CA0182.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::6) To BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_|CY8PR12MB8300:EE_
X-MS-Office365-Filtering-Correlation-Id: 56b14fd6-a590-4721-4187-08dce8e601b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZXVNcStjdUNzWlBrNTF5T0dJUlVZZWJuMzZCUC9TWCszU1FmWTFNaUMwS3NU?=
 =?utf-8?B?VS9RZGdZK0lhVlNkSEhXenZNbXB5Z1BVMzRmTGE0dWhuaVZuajhIS0FPU0hR?=
 =?utf-8?B?TlFzNXVuNStzamxGUG1ETlBIYWNIM2ZCREFUWCtVL0pBc3FYVnF3SjNJNElD?=
 =?utf-8?B?Wld4U2IzQWw0Zi9HUk5oalRrKzhuVTFqT2ZZcTBXanJuZFJYK2NPeVBjUS8v?=
 =?utf-8?B?MTNucTgvK0k4azY1Y2tMMklSOW1FNWR5SnFIR2g4a2swQjBzeFNQTkg3Ym9s?=
 =?utf-8?B?K3lIMVFUbENwc0pOcFlqdXNkRTZUcnErbS9WVzFtN29USGJWRDRxaFQ0eWVG?=
 =?utf-8?B?WTZJdEVrQXFOZmU1UHIxWDVsWGVZancvZ1NaZWJZY2JpOC9wcVcxZG42VlRa?=
 =?utf-8?B?aEMweVc0WktpSk1rUzZPaU5oS3hIODZFaWl5N09DTDFSajdnYmxGZC9FMjNQ?=
 =?utf-8?B?dnRMRFFSWWt1UFk3cExUWVRXR0JuRWVKSmN0QlV3THR2ek9JRFVyZngvMEZZ?=
 =?utf-8?B?U2t5UWRpdkJyd0ZMUEdLZGcvMkpVTWZBRytTb1FwNXMxUCtibzE3d2pVS2x6?=
 =?utf-8?B?WFVHVlo4bHE2RXVzcWN1NnFzUnVEVkVsS28zcWdXM0hNYjVWNDZaYTlCNUt5?=
 =?utf-8?B?OHZrQnlhMlMwQy9Xc1diMUZwSHhQMzZsVHpnaldObUhWRHlDTWtzalkya0Vn?=
 =?utf-8?B?cVZPSUZ1aG1BR09VQnFvSHRhTGVyWGNXbDVaNlRVNDFMUkhTM3NQTGZQdDYw?=
 =?utf-8?B?VEloQU4zcWVBci9tYlpEVjQ3S0RkaUs4MjdQODYrSzNDWTFoUEY0SVBkUlJy?=
 =?utf-8?B?UzdIM2M5ZVIzNks3ODVuZmdCRmJsaFdha0xURmcxUloxZFMvSTFOYWo0akNY?=
 =?utf-8?B?L0RNd2Y1ZDRTWm9EY2c4cDJUYXFYTU93V3RBZUZFdTUvQVNlWVhvUEZiWDg4?=
 =?utf-8?B?Y1lrelNYaWxlbjJlMWZvZjBrc283RzA2VnNEei9oV0hRTTF6ZGliT1M0MDYy?=
 =?utf-8?B?LzVBaXJlVDd6Z3M0dmRaNHVYbHFIMU8wWks5L0hVNDAxM0t3Vlo4aW1mbU1F?=
 =?utf-8?B?ejVEWTRmTVRUOUxjdEphbkNPdllJYjIxd0JxenQrWFY3eWFiSUY1b3ZPcTVu?=
 =?utf-8?B?RXFuaWJYZDRQMUo3cUZjeHI5cHArRitQSmlhc0RLMndmcUo3OU5vME42TUdm?=
 =?utf-8?B?dzNDbzlRYmJoTHdOeDlzR01jVUk5cU8vTjZ1WDF4bWVucTBjRjh2ZU1vYVRB?=
 =?utf-8?B?SUU3d0tVZ3NUMUwvckIrVnpaZmtJV3NoQ0N3QjZCYUxwK0drbFRPZXpUYUI5?=
 =?utf-8?B?dUF4UGJMcWQ1akFodVphTjFndEhncjJ6b0wyejgzd1BFandOTU81ekpWUWxR?=
 =?utf-8?B?dWl5a1o2ZVlYd0x0STBCalV2MWlta2Z6Q2xSRDdxa2IrajBrMit6QVBNSExF?=
 =?utf-8?B?bGh0d1Rlb0ZuWmQwY3VXN0ttNWlWMmJOTFhHeGZlUk1FWC9DV003anhubXQr?=
 =?utf-8?B?WFVVMllzR3MyR1ovZFRoV3drR2U5YUgvbDNLKzlnaCszVVRwbm56ZnRZT2FV?=
 =?utf-8?B?Nm5wMjF3c1NpRkZkSmd2NjU4QlJjNnFHd201UElVYnpwMmlhbTNvU2VDT0RR?=
 =?utf-8?B?VGFmV0lKcmtlM3BOOThrQ1I0NGJMUUd2U2JGN0FuMWRreWtVems5Y1RYbERV?=
 =?utf-8?B?ZDZaaWlMeWRPdDg5elRJU2ZZRnluamJyOXgzdzhCSzR5V2hpQmJSbHpPY3Zz?=
 =?utf-8?Q?rxQMJgOU3ZZO7kgKlCRoXb9YWqqRE2mkfUJgNJF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TStvV1JCTG9YRzBlWmZEdWFiaC9YVzRVVnU5ZU9tRUZTTkFyYk9vaG1NM3Rs?=
 =?utf-8?B?WWcxSW0zaXdTS3pQL2dOeFBqZk9ySzFOSnBHbGxOWWFKa2U2M2x1Q0tCRndJ?=
 =?utf-8?B?YzZCdjFTangvd3BOd0VVTkRERDVDVVhGU0Jhc3FITnlhRlpiSUJKQ0Vyc1VV?=
 =?utf-8?B?aFRjbWRNSE1VZUJrcjNvT3JhVWhhU1JDVWpwUVF2R3RENHNQN0JMUWpTMy8r?=
 =?utf-8?B?Y1MwbkVlc2NmUzB6MTFwd0o1S210NW5DTnliYklNT1c4YWtKdGdLckdIdkhu?=
 =?utf-8?B?Kzk4KzVwQm1nUDdmZytiai93amxrSW9LVWJ3VnBDbjhqUUZoOGxObm90a0RZ?=
 =?utf-8?B?MXNzeUYySlRTc094a1VyZHlxckQ5SlJ5RUxYamZBc0t1V0h5ZWI3T2Fad3N6?=
 =?utf-8?B?Q2NqcGdLQmJMTUpqWVpZR2w0cTJta0Q2LzVTSTBqTDR3bDl4M1NjUG55bTd0?=
 =?utf-8?B?dExubC90by9mY3lJT3RMMWw1aHVRdlYzRDZaSy81dVVpMjlVK3Nlb2pSUTZ1?=
 =?utf-8?B?dnI4bDZNU1pTS01EclhqL1JrTEoyVS9nRjFvaDRCR3Z0bjV5QWpKRkhPNVhF?=
 =?utf-8?B?RnhZN0ZMYVFWMDBBMlJIM0xvSDhVS29KV3d6L203SXdRTEFzVURkOXB6TC8z?=
 =?utf-8?B?bEV4b2lRc2ZyOXhHclNvVjErU2JJbE9lU0RmOVZBM0p0Uzh5K1VBdyttTlhS?=
 =?utf-8?B?WnBWWk5LZzJnOEdsOGtZSm1ON09UcmxpYktjNjlBQU5JVVlMREVkRTZJaTlF?=
 =?utf-8?B?c29KK3hDdTA1bHlIeDV1SEErOVhEdThvdWVtSkYzYkxFeGRPMnYvZFRPcWNo?=
 =?utf-8?B?K3dybXNIMnpCL1RiQkZlZHNvM3ZpYTVtOHMvNVJ5TTBsMThrVWovNXNYR2pp?=
 =?utf-8?B?ZXd4ZFlJVnJmSDNTbDJsVVN5ZXRZdEdjSEJxcitOaXh1VXpyaFlNMTFXdVp2?=
 =?utf-8?B?VXk3YlpraUJiWGd6enNxM2FqSHVyb0dUQ2xKcVJ3ZSt3ZjhZTVAwSDV6QkUz?=
 =?utf-8?B?eU54OEtJV2VoaWt1aXZoUSt4KzlqL1ZMbm5VSFUvcE93NmJHbEVuekFnSGJN?=
 =?utf-8?B?aStXYlF0TXp2aVRiM0tjYzZTVzZmd0M2LytFY2JCWXlpdW5keXZLVzUwb1Q0?=
 =?utf-8?B?ZTdlSEJVZXc4YS9GaHB4NFkwU2IvOHNIeEp1T0p5NzZoRWdKQzZPZUpLWDFw?=
 =?utf-8?B?QWFRSnJtZEMwTURmM2Z0VmJHUG9XR3dNWGtPSWJIYXdYcDJ5Uk1Od25ZaE1T?=
 =?utf-8?B?eGFrZEU1aFhNU0tLejIyclFSU2xqZWthYW5yWnBXQkZ5YmJNY2x1MGFDV0gy?=
 =?utf-8?B?bFF2TjNabW96T2NPQ3c4NlFYSTZ2b1RDNVhtd25oZFNOVE0vWFJlT2JCd1Jz?=
 =?utf-8?B?bHZIZmgyUW5lNlpHenE5WHU2WEFwc1Z0UFQrWlpNMC9RVm5sU3grSFZmODh5?=
 =?utf-8?B?djEvME1XT2FTUEtXZzhnZGxoK1FjTjdidFJZZGp5SE9uTTYvOXkzdFMvSTJE?=
 =?utf-8?B?YUdPUmRLdk5LOTNGQTFpSUcrS2RGcW5lU3RsVndsRWJFN280NThoRkxLUXdj?=
 =?utf-8?B?clNBWUV4SkV4T3FDOE5Jc3lONGE1YjI4d3AwaDR5VW9FY090c3hKcjRNcSth?=
 =?utf-8?B?THhoN0FPcU4zenVjcXIxMytVcURqQkFlTXl4R3UvdWxndVNzYWJqa1ZsTTV2?=
 =?utf-8?B?SnFHT00xY1MzenJQWDZ2Y2l0VUlMWWtzTFY2UGp1UFVYMU9hdnBpdmFLY2I0?=
 =?utf-8?B?bjFzUWptQi9MdGUvZjJjWnExMm1tOUNJSVAydEx5N1dhQnhBTXh3bkd3R2Zm?=
 =?utf-8?B?Vjk1UFVka2dhSWJHQ0VvekJ3cWJFNzdlS1NrTS82TlNidVIyREF3SkFucS9p?=
 =?utf-8?B?c2I5V2dqUWlvSTVCWHZTR1pDbTBJaGlJYmpTQ0dXSDB4RFBsRnhudmRvc2NV?=
 =?utf-8?B?UEpKeEV6QTkwVUt6disrcmdlMHcvb0dSdHlhd2tBaUlieWxnTFBURE8rK0JS?=
 =?utf-8?B?M0UyaGFZOFduQzlra243Ti91N3l2dkVCQkwrbG11UWs4UnNlTVpRQzZtOWhE?=
 =?utf-8?B?T2hpOVdqV0RmTkNpOTZrV1RqaE9vcXdKUTFWMVZzcnp6a05BaVNKWkdOaXRa?=
 =?utf-8?Q?0v0jQ3ynUGKIn3FYaA46mdkKF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b14fd6-a590-4721-4187-08dce8e601b2
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 04:42:55.2645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ymbM2IHiKJartZzGgfvQ7aDLnSEZjkozqe4rn30S7U/62MtRuZafVIxxF4u3Z5FMF6H2+8W89m0LyBEP/AEE9A==
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

