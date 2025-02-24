Return-Path: <kvm+bounces-39052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89A79A42F74
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 22:48:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C90C23B1E31
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 21:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF5431DF994;
	Mon, 24 Feb 2025 21:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="faE9GClZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2085.outbound.protection.outlook.com [40.107.212.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722EB1A2397;
	Mon, 24 Feb 2025 21:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740433704; cv=fail; b=fAN9JU5XGukoThKZ7OPB3uUKOWnT9Tnv2CNmwqAO8t3qVvz49GvwsJUgEYlFaB/2bpeNxAVOGVUtDEbwn2xR8IiBcqStg26ReLDrNTAWBxC4xRFyMLcB8bPSwmWvFXTCrOQ2cFO0Bvbw0mEMujIHr/vnOSxeDsyZVycxBoLixwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740433704; c=relaxed/simple;
	bh=mNUavKXpHk3hSGglNdgKGh6bL73GUNpOrA0/di8a5eI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=URWmIzCfNfWWbE+IaPOJVxEbjQ8SjfzOx1d5C3UfbxyojmNGmys13qwFdkQ0gEe3WaHhwLUwIPfnqMZd2Fw+HDVpqqElPGXuXowgAm4HPzHxzlN9A1LNSYjobeVUg/jM9xGjLoC31uyJXu9E4qtZNLIi4wfir96JSyqvXjdqQXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=faE9GClZ; arc=fail smtp.client-ip=40.107.212.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=inP2DytXIHV1xEePOkpK/ex2ftlYLLk+dfn0nndfFFMimuyI3F6Kn2HMvIPZrbCVa4nZ0m+5sZLniMGH2pyThwD+w9nkMCPcvFNn9jSz8f8hPTrfwDhs1kHGToZD9FXAIaj9FU8zGQ4qY9ylEfvwg01h0rnO9VBzktCEjvA5MoWimKKlz9T3h1MZu294GzNUMGzOHI0JkC7DkDEtUGPnq+8B63Nv66rC++zs+T+sKAe/h+HxQfj9gPnknuaW5gRdfGIskokCRFLnvlNnG8CXXxdzNq3mKYyTBpRfUuxMSiWUgpf7piQNMyhMQScdCmeOhuqacjq+SPoIftits2oGIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=baxbYjnNJsWB9uo0386+HtxY095TMhSUwxR5AkozRoQ=;
 b=ZSOa2NKlxonDDkEkjTQxG65jsEMGXP8+M2k5NXgXyiB1yiD2THXZbOFqBuNlpufc2DmXeoSTK4XLqCCLOowIU828e3lEpVz2KSPWh842CJO9kRaTw6CsxxJSaQT5LmacoUUuNutuwifhl6QUp6dxgFRrzOWJWSN3FFfsRpDVAXEFL9nABYwXglE1ivj+yV1xU1b1uRfmvBuVlVjPNZ2I11tXDqmbdsdRrzMrC0qaBHg6EhwBBebMaT8V60qyONyUCF/p0RqkGeVSiymRX5XrZWIu2v14UJwRZUkNU/1zvRRI1U5N+Wg6bPyixbNwz8nDyc6pEZHRDcxWQ5/x3zTMKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=baxbYjnNJsWB9uo0386+HtxY095TMhSUwxR5AkozRoQ=;
 b=faE9GClZnyVvL+fXmPLs4fRUoHn7jkonIFH3H2l4KGeuOxU8PjszoOqN7zNmrYdqoKjFQ/6+hpDW1u19T643x2jFNqds6BVvePAJW97lWanyCbIbxF4nQrHHavtjBsxEpicu5cGhwCECxSP4Fs3pQ07jYQ4m1tx9ALHuMYYv+1Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY8PR12MB7265.namprd12.prod.outlook.com (2603:10b6:930:57::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 21:48:13 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 21:48:13 +0000
Message-ID: <d0b40cac-ba91-9e6b-7108-6a1e29f317c8@amd.com>
Date: Mon, 24 Feb 2025 15:48:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 06/10] KVM: SVM: Simplify request+kick logic in SNP AP
 Creation handling
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>,
 Alexey Kardashevskiy <aik@amd.com>
References: <20250219012705.1495231-1-seanjc@google.com>
 <20250219012705.1495231-7-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250219012705.1495231-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0179.namprd13.prod.outlook.com
 (2603:10b6:806:28::34) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY8PR12MB7265:EE_
X-MS-Office365-Filtering-Correlation-Id: f9e5c201-9c55-4c6e-6983-08dd551cf03b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QVFrTnZrMnFSUDlENWFnQmlMYU9DSGVBOXZhU2xEUE5GS0FvRHhPempHNjMv?=
 =?utf-8?B?QlN0V1c0NG1UM2UwTmt0MkxpSXJoZHdnS0FhUXBuTnhpbDQ4NjQwYjVpaURC?=
 =?utf-8?B?V2hMOU9Xd1gwZ1RzaC9wZVdxVGQyMEM3dG5XSjNqNDY3SW9GUGNiMlAzcDY0?=
 =?utf-8?B?a2l1bkQ4YStqY3BCcFFEUURnVm1HNzAzQ0JYbkRTWmpudEN2TzUvdTNJeFlG?=
 =?utf-8?B?VXN6OERoblFjTUF3cVBKazh3QndpbmlGRHZBakViaEE0Y3d3QWNIUy9MK2o4?=
 =?utf-8?B?NTUxdnFMVzR4dDJRbWNXbWZtSlhmWW1CUEl6cEIwREFTOU13OExmL0hNUnVx?=
 =?utf-8?B?aUh3a2J3dm9XVXpRVjJ6Y2VwRWN5S29nb09XKzlDSkFUcVBqTFhpcGNxbnFq?=
 =?utf-8?B?SVluMkFYYXc2QWMrZlpEb2ttNnF3SG1BcVVlRUc1YW02Nmx6WUZJYnUxdURQ?=
 =?utf-8?B?R21nakpVWjRHUW4yZUh4K0pIdW9wdlR3UStHYUMvNE1IQVpRZCtXMWg4aitT?=
 =?utf-8?B?K3RtazdnZHJEMTNldS9DbkZVZlN5Y0RpZVBTbjFGSkJwU1l4Vm1GZFNZRDND?=
 =?utf-8?B?RmZHUjhTM1VEZVFMdmFoT0VFN0RHWUF1a2tBcHMyN2x2ZlBTZjNrUWhzbHdh?=
 =?utf-8?B?Vi9XV1huRzVFeDJ4RjV2bXJzNzMzR3B2Z0NITkt6QmJrVmhJeVowemdlZkM4?=
 =?utf-8?B?TjhROFc5TG9DOVcxY2loZU1oYThHZmsxZWY4eDQyL0xrZEhuR29QeVdqM09w?=
 =?utf-8?B?ZzZ5OTZCUUVIaFE2WVUzd3Vtb2svbnk3WFpOQlA5aTkrbmdIZ1RWK3JxT0FN?=
 =?utf-8?B?SGJxYkNsRDZpaHVqUVJlK3Zhek5FM3ZsYllkTm83RnY2T0FUemlVdGowNjJl?=
 =?utf-8?B?eXZGSlVsVDhCM3VpMTFPcHVRWEtXdHNKaTl6TWZtK0JVRi8yblQxc1VXYnlP?=
 =?utf-8?B?ZGFtaUJRdFptRlJhOTRyRnEwd0oxOWxJaFNsdDA1RTRiM0t1eGpFU0RjdXF2?=
 =?utf-8?B?cFFucnJvWEhhTnRpWEZDRmlhRmVpL1JiWjZTSnZUYlliY0xjbzdaVzFvQ2th?=
 =?utf-8?B?MEZaSUorM3c5QkFLYkwwaGxYcEc1YTFHTWxDM05WV3JGNWE3MXI0WXhIaFVR?=
 =?utf-8?B?TGdxQitGS0pSRUFKa09SenZuYlg2SExTc09nUGpKT3VWYVlTRHpUT0dJWFJM?=
 =?utf-8?B?NC9wZnFyb0dZUlpFNy9QSXJDRE54WXlReXBUY3RMYjJ2N2laWmJVME1BenpG?=
 =?utf-8?B?NWlHNHRyT1IwbHRHZGlVYi9ENnhPVGdJeTBNaGtIVDJ2bm1BWUcreWdac01D?=
 =?utf-8?B?SEs1azQyTmdMd3Fad2Y0S2o0OVlQQnhab3FuMmlnYVpkWk9xcndTS0pROS9k?=
 =?utf-8?B?NzA4bGZIeDdJNkhVWUExTENWTnhreUVTUU84YW8vTkIrNnBDUE4rVVdjdDQz?=
 =?utf-8?B?bG52Q08rcWJUUW9lZGNHUmdFdXc5aEFyOURUcFhIQ2locFE1c0Y1dHhCYlJ1?=
 =?utf-8?B?cmdjZG1vZ1lQVkI5Rkt4R0lSakpIZC9DdkpOWnRHVlRNVmJ6V2RvTVFTZEpJ?=
 =?utf-8?B?QmxWNk1RWjhSNnZtdStjS3pwTU5PTEZnVWY2T1hvT0pDSjNVR01SVkhac3dQ?=
 =?utf-8?B?djhlMm1xSnJGVGhscFRzazc2MVd1RXFZU0gzMGZybEtlUWlqNFNiV1pQb2Vl?=
 =?utf-8?B?UG9pamJ0ckdteUJmRWRHdHA0cjhoSlFlbm1hM0dJK1hDQkY2RU9lVVdKWUtE?=
 =?utf-8?B?ejlOdFFWbmhoSHljaU5na0NMeENkUjZ1RWt1cDNianR1U0xTWmVWem1JTU12?=
 =?utf-8?B?L0d0cEFxbGZkYnUya1E1c21KVXQyOVNpTTEwNzhyUWtWRi9tOHZPaVVtY3BD?=
 =?utf-8?Q?fo1ackCvAW5dR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UFVkSjFRNkF0NFJnaW5pbzh4bHpRUmNBMEFyOXNGNmVTK1BBWmNGVUxOendG?=
 =?utf-8?B?TXRUQjJ5UlppUTBpZk90Ymd3cFlJWkZ6NXVFVE9GN2FZMm9lKzM0U2YzMy9s?=
 =?utf-8?B?RHpQZ1VRc2U1cEMveCs2MGt3VEJsNmtTbUhQS1ZTQnBiNEoxdnQvZFh5TkhN?=
 =?utf-8?B?Q1k5cUtxL2JmUVZoeHpzQXZySGF6TnhQLzE3VzNuV0F3L0RDeTNpV05UajNR?=
 =?utf-8?B?enoyVkdsLzFnZkZNNXFPdU0vYnh1eEVzUW51UnkxSFc1eDdya2pUckt0RDBs?=
 =?utf-8?B?d3U5blRvVmg0Rk1XcEV1UndlSUZZcENicDRrTXZPSDVRaUNWOHBiM2hmRVJE?=
 =?utf-8?B?aVlwbEVxcUJ3VkRkZ1BCb0JCekV4ZmFvN1RKMEFndHFpeTF5bnRtOVh4Skha?=
 =?utf-8?B?LzRDaEdXMkhXTm5STWJUbWg4bHdNeFlMZDdyeUVCYjBMYUJXTitFMVhPbWhx?=
 =?utf-8?B?V0tPMFBYTGErN0FaSThGQ1hjQ29BZC9vcWZQUFVJbWNnL2NOaUFmdDJNRCtp?=
 =?utf-8?B?MjZYSEJjVGppa0dXYlBaeUwwZjZmR0JKMThVSmttTWYyMDlCQjBFZVh4Qng5?=
 =?utf-8?B?VGZlMkQ1UExXeWFqM0dFellidHBZTTBKeUp0cXlFMDZ5NzJuLzhwakRsaDE3?=
 =?utf-8?B?bXhIT2p4ekgrZ1JGWFNCUjJaYVRJS3JjUWlVMENIdHNIY1dWRjNjZjJzeFYx?=
 =?utf-8?B?MzZwK3FYSlNGOC80aHRmblBYTWRtRHBZWGd6L2JSc1ZRSitESGp0SHVQWGdT?=
 =?utf-8?B?cFlqaUpFVnY1a3RpczNCakg0Z0s2c2txMmlzTjlVUFg4dTZSZmVZUWp0anpN?=
 =?utf-8?B?cGo1RlJZamo5THdlZWlCWnlJV1JJTmZadjNrNmsyNThkY0prZll1b0txY1Uz?=
 =?utf-8?B?YlNtNjhSMitGWUZmVE9yWGNsS0tXOVhVbFVzYmNacU9Xc0FrL0RJS0pyeWpn?=
 =?utf-8?B?c1RzdHZYTnQxRlQ5WTRUQ2VNSDViOEY0NE1nVG9icXVIbEFibkprVkFQU2gz?=
 =?utf-8?B?RVlIRlBGOG9IeTNSRXNsbll5c2Z5cmRDd3N0emh0c1NOdDhleGY3Tmh1T1ox?=
 =?utf-8?B?Y2ZONTF2UXlkYTZXVFVuampCcGxQMW9FdUlPbldLbFk5REtXWWFWMjBiQmo3?=
 =?utf-8?B?M09NNDhHRFZHTDJRei9Zb2twbEJ6bmx3cnZJSWhBTWtraUZpSEhBeGU5dGZu?=
 =?utf-8?B?dTZ2eXpOYldWQ21CTU92blJMSm91TEVvTUdNcVc3N3U4by9vUmpxUnJ0UWlv?=
 =?utf-8?B?bTZscEw1QWhtc1V4ZDB5R2ZqRmZjbDdwK0N4Y1hKL0FQN3ArK0RKL09BWFNI?=
 =?utf-8?B?bmJSdE81TklVL0J6SFpRZStpRk9qUHJkdnh4ZFBjZ3RxTnVNSC84VHJ1azJh?=
 =?utf-8?B?dXEyL2FxY29odjJ3dDhrY0lpa3lMUk50cHVCdkZVZXJzSUI0UHBSUER2cStW?=
 =?utf-8?B?bGl0M1FFeGs4OFhmMkFoVzRHcE5pUmNINmpEeENBTlhEbUhKb1UxbFNXVnAy?=
 =?utf-8?B?TEhaVEdNd3NHcVFEdk5GZGpwNm5JWEJ2OUhKNmlBZDA1S21IaXZ1bkVCRXRs?=
 =?utf-8?B?S3NHU0FTeGdwVjBPVlY2aXNhVXpQUHVkRStmNlBIWnZ3ZWxOUkljOUZ1RjFv?=
 =?utf-8?B?dmw0eFVjUlIxeU81UDF0Ym04TldxVjU1ckZEL1NCaVhyOGZocXdsa3RGbmZq?=
 =?utf-8?B?RnZ0Q2k3dUJSbG5vaVNGbHBEc1JqNE5jQUZ4cnAweU5uQ0hpc1pXL1gyS2ZY?=
 =?utf-8?B?cjYrLzVKaWNjS2Z1NEJJdy8rWTJaMTk4UnNQalB4dkNnQ0YzWUwzTTVSbUp2?=
 =?utf-8?B?R2QyUVd2RVZjUHBQem9iUFJIb3F4VWR6dGFJcW53WE1xdDQxNzRWWHV6ZUtC?=
 =?utf-8?B?UGlwM2MwOG1JUk5CdXRSbnFkZm5zekZuWkdOajRKVVlUR2dFQlR3K1B3c002?=
 =?utf-8?B?VVp5QVFnam1IRzYzUFdQemFTdGNuM3IvUmhOMHVLWWRIUmxOUEpyak1aUkky?=
 =?utf-8?B?YnV0QVpZeFJETkovenRwUmdLa2VVdHg3bDZZOWlqejArMXhUNXBIRXFzcERP?=
 =?utf-8?B?cmJNRkZ4bi9PNGxPYjh2NG50bWJkMzBKdytJaTl1RTFucEl1NGpoeENQNkRJ?=
 =?utf-8?Q?aIJIb+hY337ouSETN1WqG/9oq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9e5c201-9c55-4c6e-6983-08dd551cf03b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 21:48:13.5679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0aYiXqRGrybVKD/4YglygycX6IFpsszAj0r1hk8ctdZIaiYCCOq5jxW66NzFp05A5eQhTxS489Y77TrQCpCKPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7265

On 2/18/25 19:27, Sean Christopherson wrote:
> Drop the local "kick" variable and the unnecessary "fallthrough" logic
> from sev_snp_ap_creation(), and simply pivot on the request when deciding
> whether or not to immediate force a state update on the target vCPU.
> 
> No functional change intended.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 8425198c5204..7f6c8fedb235 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3940,7 +3940,6 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>  	struct vcpu_svm *target_svm;
>  	unsigned int request;
>  	unsigned int apic_id;
> -	bool kick;
>  	int ret;
>  
>  	request = lower_32_bits(svm->vmcb->control.exit_info_1);
> @@ -3958,18 +3957,10 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>  
>  	target_svm = to_svm(target_vcpu);
>  
> -	/*
> -	 * The target vCPU is valid, so the vCPU will be kicked unless the
> -	 * request is for CREATE_ON_INIT.
> -	 */
> -	kick = true;
> -
>  	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
>  
>  	switch (request) {
>  	case SVM_VMGEXIT_AP_CREATE_ON_INIT:
> -		kick = false;
> -		fallthrough;
>  	case SVM_VMGEXIT_AP_CREATE:
>  		if (vcpu->arch.regs[VCPU_REGS_RAX] != sev->vmsa_features) {
>  			vcpu_unimpl(vcpu, "vmgexit: mismatched AP sev_features [%#lx] != [%#llx] from guest\n",
> @@ -4014,7 +4005,11 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>  
>  	target_svm->sev_es.snp_ap_waiting_for_reset = true;
>  
> -	if (kick) {
> +	/*
> +	 * Unless Creation is deferred until INIT, signal the vCPU to update
> +	 * its state.
> +	 */
> +	if (request != SVM_VMGEXIT_AP_CREATE_ON_INIT) {
>  		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
>  		kvm_vcpu_kick(target_vcpu);
>  	}

