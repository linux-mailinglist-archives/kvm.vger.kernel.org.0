Return-Path: <kvm+bounces-26567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 331919758FF
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 19:05:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A3E4FB25F72
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 17:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EB461B1D60;
	Wed, 11 Sep 2024 17:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fdhbE9bo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C4F1AE87E;
	Wed, 11 Sep 2024 17:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726074329; cv=fail; b=qrtb2+n1+GkYxJ7n3MJtFVat+RKhvad0heZulf9pqOMgAkbS7x+sOwszK3bs7oAkLh4nz6UxNde+T5mbnzJnhmMlQpqJvizWuQ6No5iHrEkAFoz5w+NeXmYGuZmpIDykZR4K1kcky9eCr0yDffLVUTCXD0ZA3og806FfanMQEzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726074329; c=relaxed/simple;
	bh=Ll+IHpaGkFsjemiqm8txySLpzD3PLeO8zyO0wSifqbo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=msfNWi0/x7SZuQJh+e1BWcbIysthOxe6LNjCCe77VBfCWwch54RJpDwBVo529imMEiY4OjfVlqviB9Au6R2o6MhimLEG+dwaq6gwjvOrLu8uFlGc2gbdgD0nn+uQ++JLauZiDXE2aYix0kxDhotnefAp8TlgLE56vrcBp09Sm3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fdhbE9bo; arc=fail smtp.client-ip=40.107.243.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wjhVw6A0hufVNl/RBDENoP60WZx8hLe2f3iUlj6MX8+5kxFYp6tPfmqKp/RYQUJmosYsEOSMZytYNWw6oxltKXJLvtO71AtddbkK35MyKsjsoeXzdIVppwNfoxAtxecWQ4IQE26/RfcDxjkL0Ie8OXXXh2+i6Q5Fg6MqilX288MyQIEFEyXk29O6yZLwQNUcx/M7toHSTDYrfq/wMhQ/eem62c2CKY4Z7WBI2ihcbqRCNGopLTA/FC/ci5ULXI+G88CAYzuj3qEM32OFZhnJ7BIxr2GAOc30u0sQ34hVc0oACgkSKiGAYCbASzZrTHCZztWVKO6T8Q6Y1EN/5ac5yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AMKsfchu2+tWxQyD4RGkqjDD0FUXY0JtK9E/LxqvFrI=;
 b=Wv0QkIzqrSHzj9HwL/81gMi46pxWpvIVBXKsBdkj13oZEhXRpaqb8EmIdSJ5soD/YRY7NvYUUk6BBj+kTGUf3jhJZtDP8weULDb95o5wW4JygjM/N57Wk4iTBc74nEIZnf8S+qVO86uozUpOvJgJAF56M/ko4nGGJinU3FdXZJXYxx1LeEBls2KOOrvTU3brdkvawCmdkfm/PVMheaXg2TSW937EuPfY/xVE1jfKReGYYwd3qnoslToEQ0HCikG4S3ybRrbcTOkwwnR5A9RFZ8X8uYBGFSfi6ul3X486iFiORDekobll0UYq0IC4B1/m2sUgVQGBSVs128wFBqGCaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMKsfchu2+tWxQyD4RGkqjDD0FUXY0JtK9E/LxqvFrI=;
 b=fdhbE9boPX3MysARkyLyHWa2mMPWPquCcLO4RAzAqnCaydJT9P5dkkVNp5fPvbh50GeUujUGp+zpgSY/SsjU3XwZ8J7kda7ZiTadPYRJZDo0UIx3hZO4asOB2pbxOwc7KX/SvaS58A6crwVUof/CMdluwVyU+tpp/EsK/ZUMlTO1aky+37PQYbhA3A7o+W901K1H44MdR1GR3QGsOlVUEIvlwHPgfsUqGmEPTAekYQJxL2/Pc0Ag2yGGah/hGCrwT7y2f62w++cwNfwhNSjKH7Rp1/sJDtjrTNbVzI00CkWxyGIcVR4nFwoPpk5MGcgxZcfKzw7TQPZeWKFA9Q6CaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by IA0PR12MB8976.namprd12.prod.outlook.com (2603:10b6:208:485::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Wed, 11 Sep
 2024 17:05:22 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%5]) with mapi id 15.20.7939.022; Wed, 11 Sep 2024
 17:05:22 +0000
Message-ID: <43aef8b7-1cba-4b7d-9b4b-00a6572d81d5@nvidia.com>
Date: Wed, 11 Sep 2024 19:05:17 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mlx5-vhost v2 01/10] net/mlx5: Support throttled commands
 from async API
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 virtualization@lists.linux-foundation.org, Si-Wei Liu
 <si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
 Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Leon Romanovsky <leonro@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
References: <20240816090159.1967650-1-dtatulea@nvidia.com>
 <20240816090159.1967650-2-dtatulea@nvidia.com>
 <c59afb55-78b1-48b3-bafa-646b8499bf1c@nvidia.com>
 <CAJaqyWcEt7=3j2uoToZH=no-gPvRsXwW7RLtFcbD7_-nQ0Dqyw@mail.gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <CAJaqyWcEt7=3j2uoToZH=no-gPvRsXwW7RLtFcbD7_-nQ0Dqyw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MI2P293CA0014.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:45::13) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|IA0PR12MB8976:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f664c94-556d-4782-427e-08dcd283ebed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dXpvZDdSU3F5bEdmazNvajk3M1VhYWZhUEgwdGVCa2hDbEJNaXhWVnh4L0xQ?=
 =?utf-8?B?S3lBWG1aWVVUWG9reDVrRjM0NS9SUWlIVGk4eWY5OS9tclJHdVJiTk1ZSDhw?=
 =?utf-8?B?cFlFUkZadmxGN1VzNWlyVEJMN1hBeEVMNngzRkh2Y1E3YnZwNDE4czdHRGlF?=
 =?utf-8?B?NFdhRHhKRUo4MG9Yd0pLMXdIdkplakhJRjBoUnVLVkdaV1orbFI0dVpDbGJk?=
 =?utf-8?B?UmpTckExNFNCSEdUTUpHUmxrcWJDU1VQTUJzUXVMVitMWDhaWWgxTGo5NGFB?=
 =?utf-8?B?MERSSU5NV1BVbUN1RUhXRktFVzg5Mk82WDV4WFVYWVdjcm5Zc1hSL1JPcHd5?=
 =?utf-8?B?NFJ0dmFlNW1kWmQ3bGM0dXBIdWdDSXNkWGlVdU1BOW1PUTRlR0VieVBvVVRr?=
 =?utf-8?B?c2huWHBZdWpLYmpUM0syL3l3Mk4vOUpqcTFSKzV0MlgzR2g5dGx6TlprYjlr?=
 =?utf-8?B?eGJodjdnYkpCSzF5bVpiWGNoWVV5Q3QvQnMxa0psdFZzNy8wZ0tCSXpIbktW?=
 =?utf-8?B?NUtVRkpJYWF5ZDlTNWRnOHVIL2Q4eHJybU1iS3Y2ZHIrNTRXTkN3c0oxVjNE?=
 =?utf-8?B?VlVBMHVadlNhUDlDWXBIQndqclpqSXlpbHZKK3ZWeUE4dGxMSU9oVExxeUdl?=
 =?utf-8?B?amhTNGd0Ny83UzRvM0FvVWlzWGsyYlordGk0cTVacVFObTE1clhScHdwK3Bj?=
 =?utf-8?B?Sm1YZmswK0tqZ2JTSkVQdGJwN1dUbTNDWThPRWt0d3ZQM1Nzckt6cndEUzAx?=
 =?utf-8?B?Nm9jK1VScUtHZXdiNno4Z243MCt0NEhKRVMvYkVjM3lGNUZzcURoMCtrV1Nt?=
 =?utf-8?B?TzNRVUliWHNGQUdsd2V3bHU2bUZOUzhmRkYzQi9tZ3doRzRWNUlsRUtVazZC?=
 =?utf-8?B?RHNjRng5WVMwUkM5WHZjSEdjRzQwYjdwaFZvZDdvaUlYVFdDMytrUWl4Ukph?=
 =?utf-8?B?Ym9PSGJwd0Zxd2JhU1JkL25ZY3I1OHR1VStSWGM4dGRzVFlvb2hvSlFuV1hS?=
 =?utf-8?B?bGZkamxXSDlLR3BMQjRVS1hyKzl3RWVTVFFDcVNjYm1yNzJMZDBOUWYrcEoy?=
 =?utf-8?B?QlJiM2NJamJaVzJhd1BWNWIxT1phZm5IaU9IZ2dtT1RzWGFGUnBaazNvTGdJ?=
 =?utf-8?B?YysyYkFpRE9pZTJvVUg5cVFScHk1MjRRajZ2SW54UG11Q2g5ZTdsc2hKZG13?=
 =?utf-8?B?WFA0VXlsK0g1d2gvTFFHSEFZSHJuam5mcFFlV0o3Zk5tSVoxNE1JTmZTWlZt?=
 =?utf-8?B?MEhta0VURFllZHQ5bFFhZGVXeE1YTE0vemx6YW4yZ1ZCazN3Tmd2REVFcFBs?=
 =?utf-8?B?N2YwSC8vMk4ySUNKSU1FYXpLY1I3WDFqbDVKTzVMTWQzR256SkViNy9zQk1C?=
 =?utf-8?B?MGNldlZoemM4cXNVYmZ3clBDeC9IeUx2UUhqekhKR1c5WjlGMmN5THg0VHBi?=
 =?utf-8?B?MUkwOVo2L1hCaHRhZDM1cDRWTXgwYWg3Zm9UV1JxQ1dqdVVFRlFZRmhqa2Y2?=
 =?utf-8?B?U01hN1hQSFZFWTFWSFNrRndDU3AyV3BYZ0lCTnBSK2h0QWVaZVlDQkZkQlNQ?=
 =?utf-8?B?RCs5NmNENVdlWndGU2lrdjFyZ3JEeTNzZFhnTkdaRkZNaWZ4Zkc4eGQ4b2Yr?=
 =?utf-8?B?KytpTXh4OUgwNGJRN1BZYmR6dDRESXMxNEFvZEF0d1V2Qm5mTFNPM1VvcW5W?=
 =?utf-8?B?M3VnQlhSYzkrMnlOcXRYZFRLN0JIb1IreW1oeXJ0SkVuRVVrR0JGeGhyUktr?=
 =?utf-8?B?K0FTMTFkZCt1VmtlVzhwekFQZzdYSHVCcHJhd2RXYUNLbHlPWThwdU8xbjZr?=
 =?utf-8?Q?2mpJ2sUlqaeh0t9BHqWBjD3NgSpteT/GatIh0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YVZ5cG12U0g0M2FIbmJKc001eHE1RFRxT284TkdpRUFvWWxpQ21iQlYyN2xQ?=
 =?utf-8?B?T2o5aEpucDBBVU9aQkpMUEhFQThSRUdpUGJkZ3dTV1RNTlJTRDNwM09EUk5X?=
 =?utf-8?B?Q1ZuekhISXV3Y3FaUmpFWkloTlRFMUVSSUhBZ3dsQWZSR2JseEdwWVNOcWFI?=
 =?utf-8?B?V05IRFFqNW1OWURONkJ5VWJqZFIvTUVSYUJzTlZxWE9MT0JGMWNHTkdFdCtX?=
 =?utf-8?B?WFF0ZldFdkFaNEZ6ekFvR3VqdU41NGpEZm9SRmgxTWlGTU5ZSndabkNEdzBq?=
 =?utf-8?B?aUFXRnlXOFhSQVB2UWVHcFBIT2tZaDczL1VheCtkMUJ0MTRNZ01jbzhEbkRY?=
 =?utf-8?B?WVo3bGw2UzUyQjEwVmIrYnB2MXd5N0VjNHFxNzVaSUR3b0JwdDhpRDVUTHlT?=
 =?utf-8?B?NWdoa2RQb1A3Vy9WOWhPNTcyZ2ZQSzdvSFZNWjlHRUpRR2ZDUDhHd2pxTDJB?=
 =?utf-8?B?dE9ndWtxa1NGbno5enZpa1ZJRlYrU3RIVUdqa0NnanZnSURRWlptdDRhMEwx?=
 =?utf-8?B?SzdscmZWaUdlS3ljdHRVZVlLeTFERGs2Z0x3Ykw4djZkTkIzamVLVGlOL29U?=
 =?utf-8?B?ZGpIL3VPWStHMTNRQlVEUXZsNEpBR2NNNk8zQUtJbENjY1ViZVlVMEtpN1VB?=
 =?utf-8?B?Z29MZE1hNnRuZnFZYytPSFBONkN3L0t4R1pPVkU1YUNNN1FMQm5BczNjRGM0?=
 =?utf-8?B?NnR4aFhqZkZFdnJXNFgwK2dnNEFtTittZ2MydHdwdzdkemhPMitDYTgxeHp5?=
 =?utf-8?B?L3ptYkNrNGdOLzN1Y0w0TGxURzhLVUxHYTUwSFd6aHVkaVRGaE9YQnFWZGJF?=
 =?utf-8?B?eXMzM1BwMWJYQmlnWjJqbFU5Z2lqTDhIbUEwZGthbTZxVGgxd1QrdlNTSmNy?=
 =?utf-8?B?bnlMTS9GQWFnRXN4YW82NWtMa1FXcEppcnU1aEMzUGxYY01LaVpaODhjYWhF?=
 =?utf-8?B?bG0vbERBSnF2bXV3RnBzZEljMWdRZnZpMUdnM1V0dUkvY2p5QXUxUVBiUE4r?=
 =?utf-8?B?Ry9rYzdZZVNhVjBqNUUzZnBCM0o2Z0lTSGNOVFR2UFVIUFlQOG9hTnM0N2RB?=
 =?utf-8?B?bU10MCsvaUhYVkdMdFVtY1pMYUdiK211OFVWL2lTaHhTZHFRZlladmFMbW4r?=
 =?utf-8?B?WTk4eWNFeTdXZDhTSnNGWnBlOUVHc2VTS2VFTDNBUTJ0ZUZ0aVQvTDJ3UDBE?=
 =?utf-8?B?WVhvQmFqeExabG1YZHFPU2xjd3JHdFRBSkFaYVR1cEJnYkZrSEY2aUM0Q0lF?=
 =?utf-8?B?ejhSMzJPazFuVEJCeUh6c2NwbUVhLzg2VlFVakJnQkF4SUJKTzZxbGZZRUdC?=
 =?utf-8?B?RC9HRWlWMERHS2RaYXUvdkxtdGRUbjlGcUVwZ2FFMUpHV0V2UmRPN204ekhj?=
 =?utf-8?B?NUZ5YmhkVGlEU2wzK2lHa1cwSW9kbXFLYmFVdGp5b0FDWk5kalU5YTdCYkV4?=
 =?utf-8?B?WklwUWNxLzFyRG84VEJyT0picmNrVTRnSGhiN3dUblIxZVlEV2NTQnd4cEw4?=
 =?utf-8?B?cGlBdWNTMmxOeWZzRWtKb2NzUXExUVNKTVQwcE9BN3BDd0FwMmh3Z3BzdUk5?=
 =?utf-8?B?N01yMG9adktJRWY4aXBud1ZLa2RKeUJaNHk1d1hjNU5xT3RDZm40bXkvaTlq?=
 =?utf-8?B?SHRzK0JuSmJ5Zm1kc0lmUERkS3M4ekhhVU01MXRVdG9vaUhnVitjb0F3U2VT?=
 =?utf-8?B?Z3B4eEYzbDg0WWgzTTBZVEVEK3dGcDJaU0VDcktWSWZBWnNxSStsY0l6K1BO?=
 =?utf-8?B?VmJybmM4bW5vTytsYTNJWlk4bDMwbUtrdXNmZnJPa2twbEZzaXR2OGxib0Q1?=
 =?utf-8?B?V0RaVzY3MzIyZDNxVERXeWp3SGN4dUk5bGo3NG9WRk8rV2k1YUpQVXNvYmZ1?=
 =?utf-8?B?emg4L1JobDdFQnBOZnRYdDhnaWp4elBwMGZwMW5HOGRxNFRDV0xNSUY5bmRv?=
 =?utf-8?B?OFExaFdieGxkV29HL3Q0ZkV6Yk5DeDNwUjczS29BL0VhV3pHVWExUzZJa3VP?=
 =?utf-8?B?SmFUUlFLY29MdWRCM3prMEdZb213dy84djRLNGU3ZWF6Q01KTno4TzVCcEhL?=
 =?utf-8?B?eFNwTHk3R1hMemg0ZlVpdlRNZVVkUEwyZitDRlVseXRNKzBvaWdpRkRFZUpk?=
 =?utf-8?Q?+JWQ8WlP5BKo1yer4ajTIyELX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f664c94-556d-4782-427e-08dcd283ebed
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2024 17:05:22.3303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pa2oPDMC6anKz6NtNO/sGD/XAUZsVborW3OO0/KbEBAtX6KjI385coxbgan6tDehKTZPB/mhMIICWFpoHWj5ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8976



On 11.09.24 10:00, Eugenio Perez Martin wrote:
> On Mon, Sep 9, 2024 at 11:33 AM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>
>>
>>
>> On 16.08.24 11:01, Dragos Tatulea wrote:
>>> Currently, commands that qualify as throttled can't be used via the
>>> async API. That's due to the fact that the throttle semaphore can sleep
>>> but the async API can't.
>>>
>>> This patch allows throttling in the async API by using the tentative
>>> variant of the semaphore and upon failure (semaphore at 0) returns EBUSY
>>> to signal to the caller that they need to wait for the completion of
>>> previously issued commands.
>>>
>>> Furthermore, make sure that the semaphore is released in the callback.
>>>
>>> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
>>> Cc: Leon Romanovsky <leonro@nvidia.com>
>>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>> Same reminder as in v1: Tariq is the maintainer for mlx5 so his review
>> also counts as Acked-by.
>>
> 
> Not sure if it was the case when you send the mail, but this series is
> already in the maintainer's branch:
> * https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/
> * https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?h=vhost&id=691fd851e1bc8ec043798e1ab337305e6291cd6b
It wasn't. Thanks for the notice!

Thanks,
Dragos

