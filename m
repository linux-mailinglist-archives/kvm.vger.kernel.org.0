Return-Path: <kvm+bounces-26102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 451CC9713BF
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 11:32:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77248B21C4B
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 09:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B77D01B78E9;
	Mon,  9 Sep 2024 09:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Up0FovtO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0677D1B5EAC;
	Mon,  9 Sep 2024 09:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725874232; cv=fail; b=h8UOFjmxNsv7l/jVvyd5/dDn7B0FxsH95PI8unoxj7w9mgdthcDM0EIAXV5bYlHJNWM5DlVG1PqsSJpiXacSfL7qxVygNzgq0mDCh3Ayhkz0PH9Db/SZFVp/L2lVBkAZM6CC/YPeU6R+ujalYvH+2QpVqHxM9XS9nZ2YNljJuIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725874232; c=relaxed/simple;
	bh=bP6YCOAsPYE4h1Aa7lH++DdMn4BYf6ENEqqdcvtGJDU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QDrphODiW31BgULg1WyDThOL5KsLl6x1ncUUNCIBSQiv0AnFdEot/ECEf5R5fF++MDL/vjLP6egQkMfXhKPzVimUyIbzdF6bdUhH45y1F4mz5+yFPkXkFPkuQV43k+YPUgDDQpFciJ2P+bR58mu/9uCq/KEb4yHjP5tJe7kGU2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Up0FovtO; arc=fail smtp.client-ip=40.107.223.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QT1k19LOmcJ6yP6AElIykW0k1YcFM8rseucMlxqFr7skvC4R7Ft3e8j9Z2kdLetJ3rAd2Jj7lgOU88LXOGxNiq6N5zxEvK/zC7yHqJzrbCwGkv/MjGsq4IECnh9BDoAczSypeYhZkRPC/tD13aFV/zgiZ6vzAvyuQa2qzTJXSZFKZEuZcYTlA4Rt5xZohBIWYUMZ7+0VgQk6i6ZES7whtjJTMBeCVluyGQzJcHTqOx6hUHpg3llrH6UlqPn9EE2El84VzGZbuKiDG2vvm5ZnZsimddFdS6H9MFAF/zppmLqzG5nDLm4IXCTAolegG9jRoivMejEkWguoMI1r7K01tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XpSTtGFKVHszoY32cW8uaxmAuGvtJgcPXMAcv+2jsPo=;
 b=cmJ3/ehuoMEd5Egy8gKStWkOv8hSHaJNvfph0SRmwde8uGcwZHl5tyvWDo/9GfR6O3Jkk7DQrRV1H/5ss2olB7Z56erTuvfS4oYiIuqmyHbJ1w/nClLN4JMKvLKE7aldjHAaUyck+HrDXCtJy0LMdaoTzK+IQUDXCAPVklS4MFyxF/CZlT4XF0qAACv8b+gaS1VciFKADJ/TrZBOx6zpmOMGyueLi+q/J6aT944lQ0X44KQxQroRmGpOh4AKm7v218r4jSLHjRjynqx3DDWi1Grka/hkhNDsvvOhB5QF1n0urp2Ep042+SyvvpZGarx7Jx3lVH7ph49/fS4C9k8Lfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpSTtGFKVHszoY32cW8uaxmAuGvtJgcPXMAcv+2jsPo=;
 b=Up0FovtO3YXZGozQ67j9V2gyljhSlQsRLVKP/kstF4w9K0ho9x2RtlXfJ+13fXbzzptbbyOPKrStHL3PIw4E2kS6aLeOlVOWBG/gy/L2gKy21DB5PUEls8X981ArprIZhERqhOJUL7MmHZj3VghSHApUhRG3kNd3a3pWurwCcpHpCt8urbc8DYCqdRmEeh81nkfDYPs8DJQpzkhGEfAvSuDxgYrCFVMJxO+vmYNtx/deZZRFf1jBrcw2PirKxYMUL3HA0euPe9W46Pt7hh6661JUt668L4lqsG0pd+pYhA/RUeowzmITh464asTr7GaS3BeWKLm+ZkTk5nV89//awA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by PH7PR12MB7428.namprd12.prod.outlook.com (2603:10b6:510:203::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Mon, 9 Sep
 2024 09:30:27 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%5]) with mapi id 15.20.7918.024; Mon, 9 Sep 2024
 09:30:27 +0000
Message-ID: <fb6b1d3d-c200-479a-941e-1b994757b049@nvidia.com>
Date: Mon, 9 Sep 2024 11:30:22 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vhost v2 0/7] vdpa/mlx5: Optimze MKEY operations
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Eugenio Perez Martin <eperezma@redhat.com>,
 Si-Wei Liu <si-wei.liu@oracle.com>, virtualization@lists.linux.dev,
 Gal Pressman <gal@nvidia.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20240830105838.2666587-2-dtatulea@nvidia.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20240830105838.2666587-2-dtatulea@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0203.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:6a::28) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|PH7PR12MB7428:EE_
X-MS-Office365-Filtering-Correlation-Id: 11ae9375-7abd-4560-c3a3-08dcd0b20a2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dVJBNFZhbFNzVUdna2xRd3hsT2J5anllZlJCc0lzVWpBN3JjdE1uenJOdWJU?=
 =?utf-8?B?cWc0YTVBdGd0Z2p2MlMvZWg3WkFBVHozc3hwUHRaVXBKVmRIdUZkOWdFUDBW?=
 =?utf-8?B?REJDWjJvRWdndk9CTTRxR2dQSHdubnFmTHo1OVhWd2FSKzZVS0ZVaTBJNnc2?=
 =?utf-8?B?U2ZUeEdqUXNRZXVEQUpwcWR0dGgwTWhUYW14bEhTMnFvbjVhdkN3RUx2SWNS?=
 =?utf-8?B?a2FmZmcwS2VvM3g0QTV1Tk52by94SVFyTmlTdFZ0a2VYMGdwUk0wc01COXVK?=
 =?utf-8?B?Y29NVWdmSVloa0dGMXAxamtjNkJQMTV0endBT3RBQ1NXRWFPMHowTGRrVzJi?=
 =?utf-8?B?Nm1mUGpzbVNXdlk3MEhmOFdraXJWakVSMkZRWXlsck1tbU9PNUpMZGZDYTQ4?=
 =?utf-8?B?dHNFenE5d3VGMXBhdTZBNUJYN0x6cWJ6WDg5cXhoMDkyTm50K3dWT1U1TnZq?=
 =?utf-8?B?Y21pTm9qR0VyYkhDTlJqWkRSdVBlYmNVSGgrbGJyT2RlOURwa2pxTU9ORUpq?=
 =?utf-8?B?WHBjSm1pSHdTRnpRUXhRMVlUU1JnZFlzejhxcjJjUW81YnZFbDNrM3lhcjg4?=
 =?utf-8?B?UzlueGNpN1p6WUNWaXVPRjlnaitqMlNwNWtZZ1BwMkZUT3Y5eGZrMll0TWs4?=
 =?utf-8?B?NmdEQ1U5ZnNNRnEzelFSaDJtOWRmRXFwRWZYaGJ4eEhMdEpEZW1rTklvRExq?=
 =?utf-8?B?NGpYcVBYc3YzTnJ4TFNGU21oQnJ2U0hFZTR1ZjlKaEdjcEVEdEpKQi9TL2wy?=
 =?utf-8?B?WFpZY0VPTjJXdElrU21lQjBZWHJmQ2YycDV3aWJUbk5RMVYrZ2hrRjZLMGlU?=
 =?utf-8?B?M3JlckVBNWxPK3VmeHNndHVCRU9pNGh2cmZuQVlvM09OcThCNUVDSk84QWVy?=
 =?utf-8?B?NW5obVdBeDV3SGZETlNUSnpINEs5WHMxNEdhUnd3bzJsR1hlZlFkcC8rMStB?=
 =?utf-8?B?TDlpakRyeDBmQ0E2VkJGbEZOeGwxZkNJVVh5aHV2SW43N2dlVzJtQjFNWlpL?=
 =?utf-8?B?enJ6NTlwY2FrQlk2NFFIQzFoQUV0M1paRWtFVi9wT0FTL2JMZ1g0RHdramlM?=
 =?utf-8?B?VWFUTzNWZkVxYnQyRGo5YnpCbE9kc01tRmRFeTF1RWFNRGU3WExyUVEwS3NK?=
 =?utf-8?B?UVh5d1VLQnpxUGRoVkJlbzNRSHRJbWdnd21RdGpRVnZiQnp6TWVoTnNuZlR2?=
 =?utf-8?B?OHVIOUMvaEtYTzREaFd1YWNmRzJFR3FxQk9ITEE5Zm5HQnErVE5XODh6d0Ra?=
 =?utf-8?B?ZVdSSytVaEFKdWpFc3ZTZUp1ZDZvVXBZaGh4RFYreCswUEZqYWZ3ODZRWWNJ?=
 =?utf-8?B?UDlVWk1HZzBHVFNmNXd2UmNOY3hJYmN4bk9lNE8xdW14c0VTdU43YzdOSVh1?=
 =?utf-8?B?QWMxbUEwM0R5ZXVtRDFmWnRtMGswelk5eExVYXNJeHI1R0FlQWlRUzBvVTBh?=
 =?utf-8?B?Slk1ZTg3R0orSGpuM0c4U0ErTUF4VjNHaWw1ZU85b0Y0QTU2MjNxbTZzOWpJ?=
 =?utf-8?B?M1dOYVF3cmJJNVloYzdPWmpMZytURW0wYnhzMWdXakdOcGprZ2d0dThyT01r?=
 =?utf-8?B?UFk1amt5azZGLy9UbzBvZXRjckdjN2xCQ3JGeWtVUFdCeHg0MkZLQ0RORkU3?=
 =?utf-8?B?Kzd4RUJHb3pmanRmMm1UT2hzeFgrVG0xOERQbWh6QnlwWGVVK1k3YlFlVEY5?=
 =?utf-8?B?K3NlcHVZN1YvTmFQRUV2RUNuK3FHYXRRcS8yQlF3UllaVWt6TG5Za0s1YUV3?=
 =?utf-8?B?SERVYWo3RFgxMzBxa2hxMFJ4TjVEQVVVTXpxc3N5VkIwZVVVVXNpMTVBdFBi?=
 =?utf-8?B?RnE3LzNTWUMwYVNjNStIdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1hHZUVaUFpmMTNtWWl0WnNZbkh1SVAycmNWQU83bUdUNTdOcFhiaXN1NTdZ?=
 =?utf-8?B?REU3VlVTVS9GV1krVHpvak1zdEtCN3NZZENDVFREMU1TYkhaNFpUdWVtd1VR?=
 =?utf-8?B?MS9MOXV3Rm9JUnpYYzJQRWluaXpqd0Jnd2Zkay9xTHI4KzdjRjVNMzkwNU1Q?=
 =?utf-8?B?eWNmVmJ2OTlRaEV1NzJuYnhZT01UVWFGS0Z6Uk9PTmVZMmNpVjdZSkhWajhp?=
 =?utf-8?B?SHl0RHFhQlJIZS9oSHVVcDNFSnhERXBmNTFDTnphbjI0THpkRUttNk1pU3FW?=
 =?utf-8?B?WGJzaXNkQmdUWGxVUDJRU0ZUMkNwbFg3UU1qWHJtdUNha2hVMm52VEJKNHBl?=
 =?utf-8?B?dnRjZXFsZnNZaTN1K05OVEtmSmEvd0NZL0RrQjc3M2ZmbzBwZGVxUEl6cUls?=
 =?utf-8?B?SEVxRlowTXdGR01jQXlOZnMrVjdMMXpoSjVnSkRhL1hHeVJHTDU2VlVzT3F0?=
 =?utf-8?B?YmhqQVI4N2xRQmx2SjNjT0F2WHdFVG96Sk9UWnA1cDVwVnUreHpqV3lhcHdv?=
 =?utf-8?B?NlhFSnhOWnQ5aWN3YXFVQzRzUWpkS1pyemlWY2VDUnlncjQ0UUoyUzR3cDIw?=
 =?utf-8?B?VUFYY1NrVmREbWRXTnA5bjc1OFBNUkRkUXExRTBNWWFtdnBrNzZRTG53cjRP?=
 =?utf-8?B?ZUE3MVdRRXNmOUZ2NmdUd2pCSmVPeXh2b2NyMm45dU9mKzFRUEdIUGUrUG5Z?=
 =?utf-8?B?eUsxL1R1UllXSXRrZndMYUZCQXhiRkh4Y2c0dmExVGswVEZuOUVuSmt0am1x?=
 =?utf-8?B?eWlpeWFQZjRLWVZLR2VOSm41WTNoSUtpNklLc2Rib0NJcW9zYzlhRHhqMlRp?=
 =?utf-8?B?T1lTS0ZuUmdvUllOUXd4SVl0Tm5FSTYrN0xMLzhrbzM4L04yTVE2WVNSUDg4?=
 =?utf-8?B?ZVlhcFA5eWZDRWRibTBNQ21YRGE3WEE2L05zbHlCaVkzUFlhM0M3ODJmODcy?=
 =?utf-8?B?MXg0UEpEK0pQZmlHdGlscWsxSnhobEJ0MHg3S0JTL1MwSERUZU94aXhObnpx?=
 =?utf-8?B?YUZTcGU4VE5OV2FOa0dJbFQvZHFIWnNMZGxuQTA3akhERnIrK3ZKQ3doQjF4?=
 =?utf-8?B?TWhIbDJpVnVTaXNieHY0dFVrVEZWc2JPL3ByUVd0N1pHVzBHaDB0NUliZ0pz?=
 =?utf-8?B?MUlVcTBDOWZnS0hIU3lGRENnQU0wRXRuVnJtTEVzZEdGRmlsTXdGcTQwcTFG?=
 =?utf-8?B?SFNqdHNVRjlKOEtrMTlJZDhZc21kWlhKNXFoc0F6OVRJc1k1ZVpDUTEyNkZ0?=
 =?utf-8?B?TnRzTm1pVi82TkRwelBjWUZ3WlZtVkF4UXBFYWlybXZ6cmRsbTBpNTNNK3Ix?=
 =?utf-8?B?U2ZMYlZCcWF3dGJrQnZDRElOTEtjaFRlSFZneVBqQTNkZEI4SWw1RDJvUDdV?=
 =?utf-8?B?NXA0Q0Q2cW5ISjlwRmhTeGVVNWZTckMySlhBYVhQeWF2ejQzeG5CM2NWSHM4?=
 =?utf-8?B?UTVCSS9qZlk1NnE0SG1ySVVtd0FmTThxbFJWTWVjekpqdTQxZXVxVHM4TjBh?=
 =?utf-8?B?dWpxRXJkdjVHdElLK1NsUFUreTJJOXRtNFZmV1crclFzM2wwZEx0TGs5dG5Z?=
 =?utf-8?B?SFdpL3NxK2JZR1ZySGRlVHJqVjRHVGxBeTJvYUNtZ0RsOWprU1VGWXNiRWQ4?=
 =?utf-8?B?ejhWbEViVTVxdS9aMzAxMVl6TU1PTmpFdzJEUmcrblVJNkI3Z3NYQkRKRVZ2?=
 =?utf-8?B?K0pZak5uaUhMSnBxLzdIRGkzUGRUU0kvclMxYjdmZDVVMG1NQzVBRDNkTWN3?=
 =?utf-8?B?Q2FBZ2d3UTN5V2NwUlluMk16TitIai9EelpJR251T25HbUF6ZVZRQi9zSFoz?=
 =?utf-8?B?cjN1VWJyS3RPU1I0bjlRSkxud1dmV0Q2aFZIQzBuT2l3Nm4wbDFyZGhvMFRL?=
 =?utf-8?B?dk1MOTRlek4vbXpNbTJHQXVXek1JaUJXM3MzZXBsbkhhWlNtV1gzVnRMaTUz?=
 =?utf-8?B?TlY2SzZrUXFhMUNKSmxtajdlRGpRVm14dXQxV1VJTWRvSTBFeExPcTBPdFNE?=
 =?utf-8?B?bVRCcmM1dXVuUXhXejNjSDRoSU1BeVNtWi93VzhMOGdWK2NzMzFMRkVTVG42?=
 =?utf-8?B?YXVreDlEVzNCbHp6UkM1Z3VUK2xCRXRRS2w3elMvY1hITFlyU044V3JkUGNa?=
 =?utf-8?Q?HlJOqymZnsLhHopfjzC6SFxSF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11ae9375-7abd-4560-c3a3-08dcd0b20a2e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2024 09:30:27.5632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b5liJmVe7oLWC9/NK0lwfzj3jdm1FjDHd9mywELb9A0L+nX93Fgw9TQetw1/7NzZas0UXaYvkRHz2sj/rP6YTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7428



On 30.08.24 12:58, Dragos Tatulea wrote:
> This series improves the time of .set_map() operations by parallelizing
> the MKEY creation and deletion for direct MKEYs. Looking at the top
> level MKEY creation/deletion functions, the following improvement can be
> seen:
> 
> |-------------------+-------------|
> | operation         | improvement |
> |-------------------+-------------|
> | create_user_mr()  | 3-5x        |
> | destroy_user_mr() | 8x          |
> |-------------------+-------------|
> 
> The last part of the series introduces lazy MKEY deletion which
> postpones the MKEY deletion to a later point in a workqueue.
> 
> As this series and the previous ones were targeting live migration,
> we can also observe improvements on this front:
> 
> |-------------------+------------------+------------------|
> | Stage             | Downtime #1 (ms) | Downtime #2 (ms) |
> |-------------------+------------------+------------------|
> | Baseline          | 3140             | 3630             |
> | Parallel MKEY ops | 1200             | 2000             |
> | Deferred deletion | 1014             | 1253             |
> |-------------------+------------------+------------------|
> 
> Test configuration: 256 GB VM, 32 CPUs x 2 threads per core, 4 x mlx5
> vDPA devices x 32 VQs (16 VQPs)
> 
> This series must be applied on top of the parallel VQ suspend/resume
> series [0].
> 
> [0] https://lore.kernel.org/all/20240816090159.1967650-1-dtatulea@nvidia.com/
> 
> ---
> v2:
> - Swapped flex array usage for plain zero length array in first patch.
> - Updated code to use Scope-Based Cleanup Helpers where appropriate
>   (only second patch).
> - Added macro define for MTT alignment in first patch.
> - Improved commit messages/comments based on review comments.
> - Removed extra newlines.
Gentle ping for the remaining patches in v2.

Thanks,
Dragos

