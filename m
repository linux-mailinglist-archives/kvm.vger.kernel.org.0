Return-Path: <kvm+bounces-26104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 33FEC9713E3
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 11:35:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABCF91F2759A
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 09:35:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61A861B6556;
	Mon,  9 Sep 2024 09:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZwEY+RFb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2076.outbound.protection.outlook.com [40.107.236.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D071B6543;
	Mon,  9 Sep 2024 09:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725874390; cv=fail; b=gF8UONaL0dhGkRb2xIKTKu3MGo5wAh8C0jA/J74e+iDrdCjt75xCrzJiERgF3bEgXDzLaJnyp79CBf6Zzug5AWMRbwoQPZ6QHKMg/C27V8quJXY+5f9mn/Y1fD4ootyGDSrMym/1jbRZLNVZyEvOdCd4+jvoZmUavMRhIE51IV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725874390; c=relaxed/simple;
	bh=vKjrSnI+AWTIqOug4pjZuHzm1B/fhycm9nPBH9nPo0k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b5Fu6K4fiTCdI8EDamuETg6MteFl5oQeTaob0nQD7eUu871ee6jCsoIGH4UWf9JN7VnqqfraROhaXRG3bcGDW/a6czSv7EnVrDET8VB6qR6AVCk9H1JamllOi1PlmhHPpDuaEqY4Cb08ijiY4jsY2oUCnf/7+AuQsphxGcIi9NM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZwEY+RFb; arc=fail smtp.client-ip=40.107.236.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r937HFXvvtUACR1Kf7Apzu6L2fd1bb5GXfx5qSIfltaHQO9a9hUOHlxqU2Rly9wL5ZYlHDvYZa4UsuKJuIUJGOyEA5MAq0bwhRswOoc1bpw8/1idR3SnMRAfTHKF202+c/ZGduNazIrqsU+5nakrSZigCp8iLnsarCwSQqxksRgmNOZTQ4zlV7xQtUJZUGr8SIuXrkzoNiVyIGo1zjZRZqyHInKGIqhi8wgRuKXc1uXJrdoBW/nRJQrmrs4NVdHyMMBkS6hI7NY/qo/xABhIkStR9N65um2Rjwo3nVmP7thML/D9KOmigBhvbJeOubvAstFlmnswiGp06MawUjy/Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fmCMmTQdtRITrzQgK6/1e5EI04qzV/kOb9yGpNAA5lE=;
 b=EHBmUVVMApgkmoA4I31csZRb23CiKGrngaHeh0+Dmx9diTXDIpaOlU1bLg0a6P2b+hgTivzmpXQua5VzT7Jo8qn0f68QvzGcBDGd9vyw69aXsnyxkV/oeepePaxiP0qsKNminHLaRjPSbBpTXkRhMXX7VxngL3m7gtEj7cWU4rvds3t+3+UvlJL+GrEU2mgoEqYFnRwDCXaIhTmtMFu+zlUBPz2HbRUp4OYLvGv1MZPN/92x2oGWvvubkixdIq0nBRrlXxzGXd6JXKmrL73OdCo7oOUS6vEy7KIWJCA97hT7nfIt4ZSY8d0t8u2aBTsk8iHKAWWI3zwGa+lr4duQQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmCMmTQdtRITrzQgK6/1e5EI04qzV/kOb9yGpNAA5lE=;
 b=ZwEY+RFbMS6o9z4c2wRKcaojdNZlys5ZIG3FTPC5neQjMdGVrndLchoaWtYvprMLbWVJXPxtYD2imAwXe9v7wJZZOFBCr0bjMQNHZds6LH+sC1tWaeLddq0IiTSyJbkkLvk1fAbCaIQe6eUCiyHrhfqMPogH/ZLGwm3gC7MwSqDrV5cPJtrSQmeIL1NTozQ9y/rTVNHFoIgfLp47WRTDnpdOFE/JO5X83cQ6pCaAOnieWi9oQduTBHlcYG6IQp3xuG1hSUYLAUtRbgWjuObagY1mzLjKqG5ChZSyqCIfKpi7ZkieFiRHQe0u8FIf9f3n1ydAkhaFvSmDADmNpr6STA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by PH7PR12MB7428.namprd12.prod.outlook.com (2603:10b6:510:203::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Mon, 9 Sep
 2024 09:33:05 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%5]) with mapi id 15.20.7918.024; Mon, 9 Sep 2024
 09:33:05 +0000
Message-ID: <c59afb55-78b1-48b3-bafa-646b8499bf1c@nvidia.com>
Date: Mon, 9 Sep 2024 11:32:58 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mlx5-vhost v2 01/10] net/mlx5: Support throttled commands
 from async API
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Eugenio Perez Martin <eperezma@redhat.com>,
 virtualization@lists.linux-foundation.org
Cc: Si-Wei Liu <si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
 Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Leon Romanovsky <leonro@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
References: <20240816090159.1967650-1-dtatulea@nvidia.com>
 <20240816090159.1967650-2-dtatulea@nvidia.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20240816090159.1967650-2-dtatulea@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0017.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::27) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|PH7PR12MB7428:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f16af8f-7084-4700-8a75-08dcd0b26815
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHk2MHArMkFTSTRsdmxxNUVack1jVFh5aG4zb00yL0t1a1lCc2w0QWdRamtv?=
 =?utf-8?B?WkxnZVA1T0IzWEF1L0Z2NGNSZFdhZndmTitqc1orSXZHK3ZtbEhUMUZ0eUhH?=
 =?utf-8?B?R1VMRmdNMFZoNWFPbTZCQlUwZ0NYTU16VXc4ZkNOZDNiWHdKVTNzZUN3SXRi?=
 =?utf-8?B?ekROMVZPNEdXUFFUbmVGaHpjUzN5ZmJtSVpJcmhoVU9SWUlJM1NCZWlTM3Nk?=
 =?utf-8?B?VkdBYjIyWkFZTm9KYmdqMjNENHhLTTZVOENubFE1dE9EVUVmOERXZmpzYkxW?=
 =?utf-8?B?VU9wSE5FNnZzaUxWSGQzMk9HYnZBR1ZPSGV5UjVQYm1HZmtJaXZoVFBadUhB?=
 =?utf-8?B?UFdaL0ZHRmdCUWMrbm1jclZqakVVWVVsNTFhMXlOOVV0ZnAwWXVOUkNjT1Zp?=
 =?utf-8?B?WlNYRDlYMUVoeHAvZFNxKzRHdmY1VFFNbFRMekY4KzF2NldTQnp0SWVTSmNR?=
 =?utf-8?B?ZVBGOUZVY2VKMk9hSW8ybTRsZ1JwNC83TXpobEFiVmNlVDF2MmF0N29va3Nq?=
 =?utf-8?B?RUxEc2ZEVlRCRlZtVDFkWjBCVE5kdWh2c3FYTmRGVi9xM1FyQ0txM0J3SWtj?=
 =?utf-8?B?ekRmRGpmUUxGazRhUkxsRDUrTDdVQkRIdld0cGlmUk04TU9OL2Z3VitRWHpR?=
 =?utf-8?B?TnQxdUcyVVMvbEZvZ1QwdFpaa2R2OHZJWG9IS2xVbUV3MHlYTzkzZjVUV01C?=
 =?utf-8?B?Y1U3WXJubU82VHRKQk0rNUNZa0duL1o3YnpJbzRIR2IvWGdVYlZSbXZGSGhB?=
 =?utf-8?B?azdzYW5mcDd6WmFaRisyODVtYmRJVHRubDFTT2JUL2FhZWpURi82Q1ZXQVlB?=
 =?utf-8?B?SW5FQi9vOEZNdmw2ZUlUY3kyKzVmYXJFbW82VTJoQUdRZjQ0M0hsOWkybnJI?=
 =?utf-8?B?RjZhUldWL2ZOck1nVFhSK3pKNnV3OVo0S3FHLzNvN3FTeGRvc1kzaFB6Tm5t?=
 =?utf-8?B?UGw5V0ZocTQ2MGNXdDdaMXdhYzBrOUhVVnRReWduaG9nUiszVjFKc0V0Z3ZZ?=
 =?utf-8?B?YzRxcnJZZ0h6alJmVWNFVmwwN3BYTVZjeGdsTmxWTTJINTltWVlTOUJ1TWVS?=
 =?utf-8?B?TnNFdTlvWjgzRVhNY3BSWTRVd2xFVVRLVkFMaFpiR0tHay9UU29IbnRRcG45?=
 =?utf-8?B?OUxPRUhUM1NjU09UZDk0NGpldDJmLzRLN04zWjZUVGNjYjJNa1JmSmNmMkk0?=
 =?utf-8?B?QU9nVVNXS1p4MThRVWFXUWhoY0NlL2E4RUdYWW02RTExZWRPQ2hjYXN6OHpa?=
 =?utf-8?B?VkhNK0Y1UUlNaEE4ODRPemVRejE1KzdIK2dRUXZoeWtyemVycWplU0JKT1pz?=
 =?utf-8?B?a0lxZGFxczFjME5uYWRiQjJRYURKZzVDQUh6eXB1V0NNemtRMTVOOUx0Q21H?=
 =?utf-8?B?QUhmS2RSMUJzdGhGVysveFIySktTaDFwWlJmUFRoMXZlNWsrMlZvc3hPV1lM?=
 =?utf-8?B?eEVsV0lCUXZXcGJkdElWYUJ1UjJGZ2tuUmtDTE5SQ05zaXJzYVRxeEx1RXdW?=
 =?utf-8?B?dVN6N3ZhZ1BOZnF2R2dCNFNtczZCNUgvWnpCakJlcUZCU0x4b0p3UklOaE9s?=
 =?utf-8?B?d0o1RzBZK2gwL3Z5RHp2RzB4TWdBUWJoUTZGejdibFlJOXR5c1RydlY4VGM0?=
 =?utf-8?B?OFQrb25HOCt2YVdodk42T0tQamgwZmlONjRRL0pXTFZPK0J4Z0NLZEF4TUxL?=
 =?utf-8?B?bUtzNjM0ZTNZVklVWDltTW1QQUt3MGUzTmd6RUxJRGJTeFlNNGYxcklRNStp?=
 =?utf-8?B?c2VJUGxjWTFsUXpZUUZsUGZUcERXZGZVK0d5d0hsNzBpRTAwS0VtY1h2blQ1?=
 =?utf-8?B?ZDBnNUpNQ2NOWENDaG1rQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bW5OdU9KUzlKdDFFUGhhSDh1eTFsbE4ybWhPRUFvREVxcVo2b1lJUFBZeFY4?=
 =?utf-8?B?WEdiQnNIN05IVkNoUVkyaEg0Szg3VndYSExTL1dKS1VtWEE3RXlPNlovQXZZ?=
 =?utf-8?B?UVpUbmRaRkZ0bm93eENvSFE2TG1HNGU1eUxXWk0wNTBkcU0vTGdUOHUrNEh4?=
 =?utf-8?B?Z1BYei9aRGlScXZrSndSU1BtS3JpME1KdWlrOUZESSs1YVR5RlJHQk5XTzA1?=
 =?utf-8?B?Qk5tNUpWcmdYNmdPcTNyWmdXT0FXMlBnaURtdUtXSU50ZWxYTVBLeENyMEUz?=
 =?utf-8?B?bDNSMk5mVkRxeWJja0ttVEViYUxCRDIzZ3d0V2hJcmQ2S3Q3ZUJ5VVhDZU5t?=
 =?utf-8?B?RW9wbGxQOEs4ZGxES1gvWDQ5WlhPVVZoQ3FUeWUwS1dQdC9pemZhaTJhVUsx?=
 =?utf-8?B?VlZyUEtYQ2RBM0FwN3ovNVlsaURCcGJuVG1IVTRrUWMxaEk1RXRhcWxoMmpv?=
 =?utf-8?B?RmxGM3JkQ0szN1g4Y1doNEt0ajRoZHIycXp1UGRYYXh0YnBEOVBMdU9ZRWpq?=
 =?utf-8?B?R0JrREo3UzgwSzhYUUxGdksvQ3hZbHF5Z2JxdVNXbGRBci9CT0lQelh3WWR6?=
 =?utf-8?B?eTg4VTBkeGRaczNVa2FvUFVxTENKOURFckh0YUk1N0J6d2FJMVVGNlkySDFE?=
 =?utf-8?B?OGljVkVmSHdJbTcraGNycUdUcEhnY3Fudy9lbU50OTBDeitOdG01aG8wN3VT?=
 =?utf-8?B?RW5ncHlHOTVBdW9WMjMzdXZGL0Zob1ZjZHlFRHJ4QjNGN3I4Ni9Kc1NGemFY?=
 =?utf-8?B?cVVQSWNHQkxyMnpVMkRuNmxlSVFEMUNmaCttblcwd2RZUk5QN1hNcDNRM2h1?=
 =?utf-8?B?TUJFVkJnRnBkR2NkSjFhMStrd040Wk0xaWpFTlBULzdrbjBic2FqRUpjQy9U?=
 =?utf-8?B?anZqWDdkbXFEanhRVFllU00rUE13dnpuMms0d3lVVTN4eml1N2M2V0d2OE5s?=
 =?utf-8?B?VTgyakE1TWVyM00wYlgrUjkxRGRZZEtUbW9SRFNCUlNOM3pDbjE4S3F0MTRD?=
 =?utf-8?B?UXFoVWtsOVF5N2tJbHRObXUwKzA3cWozTEhTMU9xWUtGTUw0REh4dlNKTWZ4?=
 =?utf-8?B?c2lyY2hSYkI0OEIxMWdqa2dUTkUyaDBsaTNjVVVkZlAzbWcrQzZjZ0FIejd2?=
 =?utf-8?B?UUJKQjVsUy9vZktjS0M1bzFaVGVkSVgwSEw0bStoQ05BMVM0MDArNGhqek0z?=
 =?utf-8?B?c3oxL0tvb01YemFzY09ON25xdGRhbHJZQnRRQmJtb20zUFNFcU0walJ3QmJm?=
 =?utf-8?B?TlZlZHJUSGlialphbXhmQWk2b21uRUlJenR5ejgzMEZYVWJxOGREZGVLWE9R?=
 =?utf-8?B?aGR5T1pOUFdmejhWM3RrUllqRzd6OXNUU1ljUkxwNVl6cG1QV0craDlUaUxh?=
 =?utf-8?B?bHdhM2ZmMFloSmJUYTNNQzBwclcyK0Zub3ZEWERTU0xPMFRVb3lzRVpVN3dP?=
 =?utf-8?B?eHF5R2tzV2ZaeGhFSHQrc0ROaG00K09mdTkwQkpUYjdWZWttNStmM09KS1RB?=
 =?utf-8?B?VVJJL3RrRHRWUGRXd21sSjBNOUJ5VU8zNEtubmF5ZE1DZkhndFh6Vzh3d2pZ?=
 =?utf-8?B?S3JPdkRncHo3bk92a0ZaYi9zUy8yVVRnL3U1ZGxMWm84VWJNbENUNld4Q3lz?=
 =?utf-8?B?SjJ5blVOQzNSSWs4OFplMlhYNVg1M2lLSExUWEVxdGZFZE9acVpBNE50VmVO?=
 =?utf-8?B?Y1hkTHBIaTdVZFRkd3NtYjJmWiszaVBDNHFZVHNaek5vY2pDcWU2N2ZDODlJ?=
 =?utf-8?B?Yk5yL0pibVB6QkhlWllrQmpLY0l0SCtTVDhCenphMFU0dWlPWW9OeDVLeWg4?=
 =?utf-8?B?eUVxekpLY0cvL2lVUmxITW9iNmN1UWJ4YnZzaVFmekVnZnJibnpNZHF5aXox?=
 =?utf-8?B?UDlzU3c5dXlhZzdLaVZ5ODloNUo4eSsvMTNwR0hraFBWUUYxaDNIZTMvb2Zv?=
 =?utf-8?B?L0lGSE1ZVDNBU2RuWFM3WnFSa3ZicDNyMEtrS21pVVdzZzBodjdkY1BacEVE?=
 =?utf-8?B?VEh0bHFrVGw0amsrR3Y2SzF3S08zM290YjRUbjhFdWdwN3NETHJnaFVXUmFO?=
 =?utf-8?B?aVNId1REcjNqdU1iaTI5SUw1NWpRd0hiWGZuaTNQcklNY0pSWVVaZWlEanhy?=
 =?utf-8?Q?0+OD0lSsW8i4knFVK2bf4J1jk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f16af8f-7084-4700-8a75-08dcd0b26815
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2024 09:33:05.1130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HnVDAvL2Hfp0lTPUjtUmavW7/NO74OqCaA+bLx2L1wZn58RNNSF+TVh8R8skMUMeWEQCPE7Yjm7/0fH9QGAa5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7428



On 16.08.24 11:01, Dragos Tatulea wrote:
> Currently, commands that qualify as throttled can't be used via the
> async API. That's due to the fact that the throttle semaphore can sleep
> but the async API can't.
> 
> This patch allows throttling in the async API by using the tentative
> variant of the semaphore and upon failure (semaphore at 0) returns EBUSY
> to signal to the caller that they need to wait for the completion of
> previously issued commands.
> 
> Furthermore, make sure that the semaphore is released in the callback.
> 
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Same reminder as in v1: Tariq is the maintainer for mlx5 so his review
also counts as Acked-by.

Thanks,
Dragos

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 21 ++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> index 20768ef2e9d2..f69c977c1569 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> @@ -1882,10 +1882,12 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
>  
>  	throttle_op = mlx5_cmd_is_throttle_opcode(opcode);
>  	if (throttle_op) {
> -		/* atomic context may not sleep */
> -		if (callback)
> -			return -EINVAL;
> -		down(&dev->cmd.vars.throttle_sem);
> +		if (callback) {
> +			if (down_trylock(&dev->cmd.vars.throttle_sem))
> +				return -EBUSY;
> +		} else {
> +			down(&dev->cmd.vars.throttle_sem);
> +		}
>  	}
>  
>  	pages_queue = is_manage_pages(in);
> @@ -2091,10 +2093,19 @@ static void mlx5_cmd_exec_cb_handler(int status, void *_work)
>  {
>  	struct mlx5_async_work *work = _work;
>  	struct mlx5_async_ctx *ctx;
> +	struct mlx5_core_dev *dev;
> +	u16 opcode;
>  
>  	ctx = work->ctx;
> -	status = cmd_status_err(ctx->dev, status, work->opcode, work->op_mod, work->out);
> +	dev = ctx->dev;
> +	opcode = work->opcode;
> +	status = cmd_status_err(dev, status, work->opcode, work->op_mod, work->out);
>  	work->user_callback(status, work);
> +	/* Can't access "work" from this point on. It could have been freed in
> +	 * the callback.
> +	 */
> +	if (mlx5_cmd_is_throttle_opcode(opcode))
> +		up(&dev->cmd.vars.throttle_sem);
>  	if (atomic_dec_and_test(&ctx->num_inflight))
>  		complete(&ctx->inflight_done);
>  }


