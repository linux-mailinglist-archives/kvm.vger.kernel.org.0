Return-Path: <kvm+bounces-50050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA04FAE1858
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:57:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 502083AB37D
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6EA0280A5A;
	Fri, 20 Jun 2025 09:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uJg2owKg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2043.outbound.protection.outlook.com [40.107.212.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F9D23AB8F
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750413425; cv=fail; b=utFhllMul0rLLO2PLsSWRHt4hxg0QtDSPj4Nodf8HvS2CykR2d4OoCE9U0AP9pYUz3oMqvz9anX7KOaCQSHeCCajJhZ9pW5Fu3Abtnn2gQ2SSLGQrwC0IZEU075pDktvZmJV1VkoRdZmj7+WY0lbqxC2iEtSfSePxcBNUaf0VeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750413425; c=relaxed/simple;
	bh=CYa7zKr4wvQBwr7OtxiEe1EY696KysjSrV396kuevEY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VaU0+l9Y3Rhl8WrzeIemvB2nZN278nNwOPHM80v//8UzYNV4HIaU6Me9jNT2eHMUI99xD0q/j7wdYbndAJY6mABiG3T1C0B5SESNZlOGjgWmhFITWE8FPQ2TSwyGNVYc9g2PH5qT+AMmcKIFR4KsNPGpFyP/EA8+FIs7xw8s+jQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uJg2owKg; arc=fail smtp.client-ip=40.107.212.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fVI+172jnKpL0rfkKSeNYAdRgmr1CYfsgS/SlAagE8itk7XUhInFrBqND/BZZ2/Vz7s1McjYq+gQ7WoeYHSEpP4mvsM2KPCS16CAxc/kDwcILdyVbsC+C6oow2kGV/R+8pVypDtax+WsQhjX3TumyPMjLzJluopUatJho+H4hdu9mHS5lmgJc9Ov4cpeGJLYrk6nVlbTLaUfDavaJVXSHVthlbJBGrQKdOeDxfAQe3G39+38GrpyzZRVSwH/iKhic9CQikmeY9x/gOSAOvucpLFKkDc0J4pu9GvrfAYYMapSRn7XAqPoNeabYkVy/fqteAAd+jcGg0ZMK8mUMlH6kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Z4/YAX+ZJjOB/KHXZ5bB/ATNyrjjsRw3Vx3CL3KzEI=;
 b=zTdvpU+QaFC4Gvg0d4wwhWybd7uLR8smlhIgxPqBu2BfyIoYTAxsbNkfi38mp9BqR/Y9jTI2HgW+KqmI0SXh3Kljw/GzHfeg43RoqfQhgVxj7afum56lns9NtZorPkOzF4RYQoceWtzyNNqBnlBwcLRZSTNP/99BxK8Izh/vPt1nyFURBvZoT9egDN09WpzFa7vmDKtqh1/KCpbg77Afoqx8IkbalA8m59Mk9KPg0Odsq27/aFfnsKL5pzjUNEVbc5XAj+VZCQVHWzNrMR4GkrxyDjWvDOsNK1DqtJr4tDB7Rr+NRC4fAyeZq5fQOB+dmTIJxb1kzFrNPsGKLhO4ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Z4/YAX+ZJjOB/KHXZ5bB/ATNyrjjsRw3Vx3CL3KzEI=;
 b=uJg2owKgYJyaBJs21s9OGwzbhhZXEvteg8YyoLZaRHb7sIAd9hjXiDi2q4SWjGCaziTVG6neYGme+sbSYnhrzRgIEGxMMTgj0GDWdR1xZuv8lomco2KfQ11VgUpDPn9STK29cVrvvY/GwzMN8HCuczcF8cufvfX7R3HSkQp8/Y8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by CY8PR12MB7220.namprd12.prod.outlook.com (2603:10b6:930:58::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.19; Fri, 20 Jun
 2025 09:57:01 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%4]) with mapi id 15.20.8835.027; Fri, 20 Jun 2025
 09:57:01 +0000
Message-ID: <dae7e196-3aaa-4962-89c4-39e8a6090066@amd.com>
Date: Fri, 20 Jun 2025 11:56:52 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] SEV-SNP fix for cpu soft lockup on 1TB+ guests
To: Liam Merwick <liam.merwick@oracle.com>, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, thomas.lendacky@amd.com,
 michael.roth@amd.com, tabba@google.com, ackerleytng@google.com
References: <20250609091121.2497429-1-liam.merwick@oracle.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250609091121.2497429-1-liam.merwick@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO2P289CA0012.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:6::16) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|CY8PR12MB7220:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ef0a911-db02-4e83-f5c4-08ddafe0cd45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dUhNcjEvK096Z1BwTHFjRlViYkZ2MDdhNjBNMkpVcU0wQlNzSzBkeXZLZzVV?=
 =?utf-8?B?aUtKU3gvKzdGSWphRUlvVEZqSU9BdUUwVktYYW12WjN2OGxlcVJkdkhzMHhT?=
 =?utf-8?B?NlF1dDFhUjh0VWNaRDNZRUM2TnJIdHV6amZxSm1rQTlvc2FhSm9OVCsyWTha?=
 =?utf-8?B?Nm52R1RXa1h5aXRLZE4yV2FDZ2M4UXFHTHNMMGF5clVxaE85MlFWdjcyWnV2?=
 =?utf-8?B?Qk14Vms2QlFCNGM3MFFwOG56SnF3SExKK0dKVmtMN1U5NFZwRHVQRUhsWTVj?=
 =?utf-8?B?ZmJZc3Z0dHJZZTFFSW5EMkVHQ1BBbnAwV3FtZElDVVkzU280NGNDSmFvWTdE?=
 =?utf-8?B?TFh3bFo0eHIzUkpGUHcrOStiRzFBbzNwanRxZk9tTUJKNzE1NTdJbHZ4elFw?=
 =?utf-8?B?NkplcEFwMThWN0t5YUhsWGRNc1lpNXNRV2JHL3BmbW9qMUpTMFlCQ2RIenpQ?=
 =?utf-8?B?ekZYNU5qY0FPOW1TODFPYUo1L1V0cWZjS1ZZV0tVTTdSWXFFSHh4RFdHTkF6?=
 =?utf-8?B?Q3VrV1hqdEhNT0xPd2UwajlJYVJ4VVk1OEdpOEl2RTFTYW9yV0RacUdpZWJQ?=
 =?utf-8?B?Mm5zL1EwcjExVzdqR2FvT0doYm9PTWx6a2NDc0p4TStsZFBGRHJGdExCRHIy?=
 =?utf-8?B?UUwvSUVjaXRDNnZtM3QzMmJLUUNzbnRoSmlralFzVTFuSWJqbUhOVzljcERE?=
 =?utf-8?B?Q202RHo5VzJRRlJqWWNnblM5UVB2NWYwNGtYeGV6SmtMa1g1S2V6Qnl1U2Jn?=
 =?utf-8?B?Vmx5d1NnNFZtWGYrb0VrVmNQcThsb0RKQksvZ0tFaHhEanpaTEtVZVlHbWZs?=
 =?utf-8?B?c1Y2SjRNd0w5NHFta0g5Vm04dHorNGlLRmFXR240VzdoOEdqd0phNEY1anY3?=
 =?utf-8?B?ck1QcDhUZmozMnB1WDlTK2JlZlRiS0xLTGxJcjJXMHBCb29jZEhGbTYwYi9J?=
 =?utf-8?B?L0xsQ0FmUTMvcEpoc3pCTGN4M2ZIc2pOTm5aWEk2WXZtNWM3Nk1Nc3NwRGpD?=
 =?utf-8?B?aXlvQ1c1bEtrL1RCYXVoMStvZVdaTUxHWUdQY3VLbThyeTU4UmI5MC8xTUFP?=
 =?utf-8?B?UGdKUVBBaGtzZVZ5NjNyZUlDVWZ1Q1VUVUpZdmlsWnNGK1JaNDN5TzFrNE8v?=
 =?utf-8?B?bW9JQVlCTktmd2RhVmxWRkZSNWZyZVFvdkZDZFByNTBtY1NHUWQvU3d4Nmhw?=
 =?utf-8?B?b2VGdk80aW5pQm85VUh0ajYvTURhclhQUFpBeC9QUWlQZDVrSjh6WS84MFY3?=
 =?utf-8?B?dFdWMjJMRTg2MTA0ckozMlFFVEVkVVY2ZnJOWStOakdiSytWVExESlZNRHhB?=
 =?utf-8?B?RHNOaWhZRVFyOHpzSVVuWXV3ckpYbFdKdlY4d2pRN09CZW51R01mSzQ2VEhZ?=
 =?utf-8?B?ZVhvbDE0NVYxS2FMTHhJYTJEcjFUdkNtWnVuNnNQZ2YyTDNFdERjR252YjJl?=
 =?utf-8?B?aFlWRFBjSFZRK1ZYbC8vV29QbDQ1OTloa0x5UmVrNXVYUk5vc2ZvYlFpK3Vi?=
 =?utf-8?B?UFp2cjJ3Z0R4UjJCQkc3VGpRNVMrVjhSc2xXeUZ0TVBQUFZ6SGdsR0pTbENZ?=
 =?utf-8?B?cmJWWVBxa0ZlVVZqbVEyNWNhYzkvQjEwOVBDZTZIVFA5VXRsS1kyM0VaRzkz?=
 =?utf-8?B?NHJjMzBrb3gyY0VYcWhXOFZpQzBxMDJTUDFiVmdSWU5KYlBaSE1XQmNaZG8r?=
 =?utf-8?B?U0w0RW1PUm9WejJXeE80RytlYWplcW9LWVBadUlYSUpKS29xaG1ldVQ4cXN2?=
 =?utf-8?B?SklZeTRaZDBkcStnQzVDdWdHeUp4Mi81OHlKMzF2TjVLM2hqNEhIUE5kUUt2?=
 =?utf-8?B?b2VtS1lnMjhVQU1wTEpML3ZWVjd1RURjTGUzSWxwQjNyMHM0aVJqNDZCZHBk?=
 =?utf-8?B?c1FzTjlWTEFta2Izelh3U1FnVlp2bXV1RENVQU8yMkZicC9yRmtJbGRkRUxE?=
 =?utf-8?Q?tMHhx9yapsM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEdvZEtjempqTHNhdmd1NGtkY2hHL2VvcDBRdFNuUlBsUmhHbWRSSHFKTzJ3?=
 =?utf-8?B?V3N1ZExsZldZS0tPUkpmaFE1YjB1eXltQUpVRVVUeTBpRXdVZHIrL1ZMS1p6?=
 =?utf-8?B?TVRTbS9kZWZVYnB3RlBxb2pueWN6cEJpbi96bytySUJBNFkwOGdrZi9kdk5v?=
 =?utf-8?B?WW03dzM1NXZMMUNZOXRMWWFFVk1XR0lITGQ5cTRkNXRBZjhONzB4dGdGbWph?=
 =?utf-8?B?dy9YaTlyZHVadzJjL0pwZld0QkNxVENNNENsbU9rTjFmaTdLYmFUbXkwejdK?=
 =?utf-8?B?VXZpNWJlcWlqa3Jhbmd5NExvd1QvZHFqbENZZnhJOTExZkNqYkpXM1ZKMlJV?=
 =?utf-8?B?UUJ2OFh1eC9xVk8xdHdQOEdOaEJrZmxyWmdjQnUzN2UvMGdOUUM0WUpQTERh?=
 =?utf-8?B?M3pVWElFWlNaUUw0NXhVdldiVkExbk9GMFFSbGhHcTM3VDNuZ0wxOUxRUlNV?=
 =?utf-8?B?eVIwRVFMdUxsdi9LT2g1Vjl0N25pczI5aXE3TkdlMmx5K2hJRzJRU0FneXpa?=
 =?utf-8?B?cU1ndm9TMUYrbDB3ZWVUL0RSRGdBc3lFMXRSVkl4RkQ5QUpnMk40cG1XamJv?=
 =?utf-8?B?WUc0aFVuZWpkYzE0RXkxMjUyR3ZsblVPZHAyd0prbFpCd3JSK0g3b2N1Ty9k?=
 =?utf-8?B?TXlHOXhrbWJXbGxiNFVyblV1T2tUWXNjSTUwMXVNb1BWZytJa0VXT1FDSk95?=
 =?utf-8?B?M3BXSVdad2srRXdtL21VNkxESlJPSGxkU1VJS3k5c2Nlb1BrMkloVDU3aG9S?=
 =?utf-8?B?Y09iRnNxVXA0VmZBYlV4VENTUU5rTG1hYkp1Y3c3cWd6ajY2YTU3ZE5RdWVG?=
 =?utf-8?B?UzNFZ1hmK0V6WWR3aWQzWmVxRDZINUdUM1MrNXE0Q3JtYkNOZTBSeXVkV2lm?=
 =?utf-8?B?ZmtLcWVIY092UU10UUp3R2krZ2xiMUJFSjJQUU14c0JFeEJoK2VFRnFiMStn?=
 =?utf-8?B?RnlSYnJzdWc4NEwrMGFtcHJEVUlsa3B1dWNOcEVJSTJBaXRYTEk1NVpsTjFE?=
 =?utf-8?B?RUNncUV6YmM5L1E3WUowK0Z0WEFlRDVZUjc5TkFFNzdxVjJacC9DYm1taUJ0?=
 =?utf-8?B?VHo4ZmZiL0lwdTR5eGhjMmtNL2hiM0Q2cWJVY3dkUytJbms0QzBBZFJFbGdO?=
 =?utf-8?B?NWs3bTlvMWN0OHdodHJOUmRwc1dXNEZVbHhDZ2RUQ3EzV2l0Qi9oa0xRTW9S?=
 =?utf-8?B?TVhkTlFqVFpTTWRaMXlwT3pVSjVKYVcyenNJNHdqQ3kyT2RkcjZmK2xzU0cx?=
 =?utf-8?B?NWY3YjdYWGh4SGVaOVpSTitjY0lrUkx2YWhYOGNpRnhFdFJQUjA3Q21ueFcv?=
 =?utf-8?B?YWFYb0RNZG1pZVZ0bmRHaU9ZaEw0UFZCV1RNRzh0R0tQRVdaS0hoMWRLcjJY?=
 =?utf-8?B?QlBOQ2RhRDRlY1BaM2huU1YrQ2tyaFlZU1RxZWZSampyMUJNcXZZKzc3eHAw?=
 =?utf-8?B?ZUU3TXZlYXA4RDY3UGN3czJQMkRTU0oyNDlyZGdGWVdGTWlWM25DQ1dlSTBv?=
 =?utf-8?B?L1BBNWZXL3hhOUlQenVhU1Rua2EvMkNkc1lzTzVkMjQvUFZRYzFFQ1FqM2VN?=
 =?utf-8?B?WUtTZ0ExN29kT0tDTmVsUy9rZVM3T2pwek1aZzV0eEVNb29YRi9QaDdZRE9Z?=
 =?utf-8?B?Qk1nRGFTUnB6aFp5eFhRRUxtTjl4UmlCOU9TV3RDVU1DWldxT0FjclB5STBu?=
 =?utf-8?B?UHJBaTVkOTR4VWQvNEhPNE55N0ZBV1JZR25hU3U0MkRveFBjUzNubS9uSXd2?=
 =?utf-8?B?WTBFYVRoK2RDTFFERjg5STZjejdRcnl3eHlmeFk5YXhvYklMU0Jvenh4QmNl?=
 =?utf-8?B?dXpHczVrQ0FjbmI2UzNhTHNvTTVjZ2hCTlNLdEFITlh6cGhUU0syRFZrQ2ll?=
 =?utf-8?B?THZPc2VZazh3cXNJOUZsaXdWN3ltSTZIbkRPQWxUQ3dHNzZMc1VIaHNwbWd4?=
 =?utf-8?B?NUtFQzFjVGg3VGpmcFNqdHNNcEZ1VWR6MVNLaTEydk00L2xxaU8xbDJPVnRt?=
 =?utf-8?B?SHN3Tk5KVmJDZTZmbmJueEdvbU9WMCtVL3laVUovZzFCR0owYXpCUE9DY0dY?=
 =?utf-8?B?cmpvVWhXZytjWUI3UXhWRUU1VGFDYnN1ekhJMmthT2xUWHJUNjl1ZHV3T085?=
 =?utf-8?Q?nPArODcUqKysHJQTrvdxojkDQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ef0a911-db02-4e83-f5c4-08ddafe0cd45
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 09:57:01.1172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0u5dLDimjXZyDH0YUtjaXezmehQz/ZVNQC7W5VEQ+JB4npPs7soOzgTLTmfbuaSDrTxcu253MX8Gjyjz6tJ67g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7220

On 6/9/2025 11:11 AM, Liam Merwick wrote:
> When creating SEV-SNP guests with a large amount of memory (940GB or greater)
> the host experiences a soft cpu lockup while setting the per-page memory
> attributes on the whole range of memory in the guest.
> 
> The underlying issue is that the implementation of setting the
> memory attributes using an Xarray implementation is a time-consuming
> operation (e.g. a 1.9TB guest takes over 30 seconds to set the attributes)
> 
> Fix the lockup by modifying kvm_vm_set_mem_attributes() to call cond_resched()
> during the loops to reserve and store the Xarray entries to give the scheduler
> a chance to run a higher priority task on the runqueue if necessary and avoid
> staying in kernel mode long enough to trigger the lockup.
> 
> Tested with VMs up to 1900GB in size (the limit of hardware available to me)
> 
> The functionality was introduced in v6.8 but I tagged as just needing
> backporting as far as linux-6.12.y (applies cleanly)
> 
> Based on tag: kvm-6.16-1
> 
> v1 -> v2
> Implement suggestion by Sean to use cond_resched() rather than splitting operations
> into batches.
> 
> v1: https://lore.kernel.org/all/20250605152502.919385-1-liam.merwick@oracle.com
> 
> Liam Merwick (3):
>    KVM: Allow CPU to reschedule while setting per-page memory attributes
>    KVM: Add trace_kvm_vm_set_mem_attributes()
>    KVM: fix typo in kvm_vm_set_mem_attributes() comment
> 
>   include/trace/events/kvm.h | 27 +++++++++++++++++++++++++++
>   virt/kvm/kvm_main.c        |  7 ++++++-
>   2 files changed, 33 insertions(+), 1 deletion(-)
> 

For the series:
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>



