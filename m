Return-Path: <kvm+bounces-40754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0D7DA5BBCC
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 10:13:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 349863A979A
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 09:13:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ACD4238169;
	Tue, 11 Mar 2025 09:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QRSsn3zv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5437236457
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 09:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741684286; cv=fail; b=nGEKTQuAtQuMF9/NJJjBKtsNqZitHQ5vyQReVMamgelwAMV+Ix1PVPMZwSKBekd0IFLs48+jTvOG2B1pEr/jWS1eZjy4pLzJMFc0X3sSB6iLjs3VqDyjCft5JyQl0zR45P7Eg7UrJrDFE33S2ArF178AX2hED0hQH4nE+nRC9QU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741684286; c=relaxed/simple;
	bh=xJPL+3TddTjgv4MxM4A35eE0GdCTI3fQZb89hFjOIlE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=skdqTrfOxqiKy80dvs3pxJsytestDWXoBwErnwzZPUJnB063JEwEhxSyxzSVjZC7E9UOEN7cnPVxd5GYPR8dYKdnoNDnkAT6AWtwBNrLLC6yBNixCV5ozeeFaxvZoyYL/uYDqx/RgVnThCdRA7h6423UIP5UkfMsae0AESBoC8E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QRSsn3zv; arc=fail smtp.client-ip=40.107.92.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ITW4WdDGrTcJZm8hKPS80MJ96TlRrx5bXkYV9O6TPRUUgF3fLj33jBL8tC6LIc8Qlga0T9q8PSIlIPOziFtUfKctF8h2zc8nJpq/yuTKP7vV4ndhy7c/dBWSnIpeywmH43/uvIj9mslVVTAwFqAuk+9wJpkdUjyR/1Md8+YgR+CiVgU41qxBKhZxfDvl6++1J1oagUQpLTwGPfnjub0sTAOrrDXei1nBVF6kXPBU0/RPuj40j557Z0jNm+AtpCaGJMNZvQf/3fL+tMII5DBMFChaNcUg+luWR0nxAKZMX6bkK9ImX7Nq/8VnPHQaq/wp6N2T2SoOlJ9LRAydEO/oUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KaVykDkeEI8Q8vkAqO8WvDdrDJEKMiPRSW/Mir9JlBc=;
 b=nNRKsVdJk6PBfWU1Kp1Trq0PEg0huDvRCbiyaKc99Od5oE/3Mm4AvkSZ8QClI3vztojMVARe6XxMwG8DcMcZnmEH8Fxbngo+L3A9I11yz2xBm+d8EKX9zb6nTFsMJ07Vl9oOKSsfhsVXkLKwnzniOr9BwtsM7F5Hptf9ZEgtykZy0SMpoE98q2JjtYOJJhsi9PFmsxnv/fo5o2jTamLMjSVnxg8MG0doghoJJvN29z0k4lzL9Uyf/bLTfrxyWjxgf4+3ho5NBA2WriqOBRioABu0u59gyxUgBELT63NPOYxjO8/DcWj/iGQUCiZd4aRdZJVhWtB4JQhRlh1qPdvZTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaVykDkeEI8Q8vkAqO8WvDdrDJEKMiPRSW/Mir9JlBc=;
 b=QRSsn3zvLO+cxOt6v3lr7uPbszQKQ7ZjVUSoPEYLiJRNdzUWzHvrt7zVZkKvonuI40eEWzpMl3z03mpAoaiVbWqkKX+tfY6KHFRO7UIoi0f94DWh2qs/M1NRtUphYuSyElhdpz3VF3eBUeQRbkRERLEyMQHrbzBFIwrZlljfuIY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by SN7PR12MB7154.namprd12.prod.outlook.com (2603:10b6:806:2a5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 09:11:21 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%5]) with mapi id 15.20.8511.025; Tue, 11 Mar 2025
 09:11:21 +0000
Message-ID: <cc076754-f465-426b-b404-1892d26e8f23@amd.com>
Date: Tue, 11 Mar 2025 14:41:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] KVM: SVM: Enable Secure TSC for SNP guests
To: Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
References: <20250310063938.13790-1-nikunj@amd.com>
 <20250310064522.14100-1-nikunj@amd.com>
 <20250310064522.14100-4-nikunj@amd.com>
 <5ac9fdb6-cbc5-2669-28fa-f178556449ca@amd.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <5ac9fdb6-cbc5-2669-28fa-f178556449ca@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0090.apcprd02.prod.outlook.com
 (2603:1096:4:90::30) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|SN7PR12MB7154:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c20ba08-20ef-4235-05b6-08dd607cb057
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUdLQWQ0eE41NUZXSXVtYm05aVNDTzVtT0x5Wnh0VnY0MFBIbzFPbXpMRXZk?=
 =?utf-8?B?RWluRTR1U1JvRjhtc2RyTjZMcitiR0FLb0JNeUExWFVIcHRIQnEzbDExZFVW?=
 =?utf-8?B?UUVtdG1yZ0tDMWZlNkgreHd4UEJFM1M3Zk9WSU1zKzFJNTdxa1hPbzdJOTV6?=
 =?utf-8?B?MCtqQzdob1M1U2tHZk5PSERVRUw3NVRHaGdDQXd1azFza2lWd3puSG1hTm1C?=
 =?utf-8?B?YncxSTF3RHk2alJnbzRsdXNrbEFMNWw0b1FkQjEvY0Uvd3U3MGNMTEtjMEVk?=
 =?utf-8?B?MEl5cG93Rk5YOXhvYW5jZmJZeTRxR0ZVcjFvQy9maGdsa3FSZHRiOUUxdThL?=
 =?utf-8?B?aWZFeVhtajNQYnE3Q1QyRzhqT3hLMXdsdHh4NjczWVd4bmdobk0vaEwyclBL?=
 =?utf-8?B?bkFBd0hKQXlFVFVQak5FcWZWUGJEZnd6RmNrN3U4U2FqeDM0RW1mWTlhMFlG?=
 =?utf-8?B?NHViWnNGd0ZMUE9FQ2cxVCtiVHZZcHNTcUhHRXF6Zm1WRXJoYTNrK05FTnVK?=
 =?utf-8?B?M3FqNW1FUmJlWXlPSTFBd1VuN3BzbzZCOXJja3k4dXc4eDZWZVpjK0pJWDAw?=
 =?utf-8?B?cVVWS3lSK1dOZWlZWkVLR0tJS3VVSVBnTFZsbzJNakFoOU8zM3hUTXF0Q3dM?=
 =?utf-8?B?aEIzbGV6b3FtUUNGcFJRcjVuVHdqUFVDQTJNVzgxMTRpWU1iZDFFbyt6cWJm?=
 =?utf-8?B?K0U0dXJicWJQQ09CWXFiM05ZUDhIdjYvQzJRWFdKdW16TkJLbkxGNjFkbnAw?=
 =?utf-8?B?djZoc3kwMUlHTVlkYUpLa0x6aGYrMkhkRVk5N3NUYkthYzB0VmtVRzQ1ZC80?=
 =?utf-8?B?Y0hpdHZjNWRkOXhReHd3OWRxU05Obi9HTExwTUxsYVplT3pVRURkdTA2QXFD?=
 =?utf-8?B?QjFTMURGa2ppME04UWNPQlN2d04waHNUMFgxQ2tqT0YyWGpxZE83RnlDWlpu?=
 =?utf-8?B?a2NpM1RBVHBUMy9EOC9yTzVGZTZ2Vzd2clp1cjZzNW9OZ0c0ZzNDdExZYncw?=
 =?utf-8?B?dnk1d3M3VlRiYTNtakNvVjdETUlFclhaV2V0cFhzWE91TjdYR3lJTkkzNDBi?=
 =?utf-8?B?aVlKZjNpRk1zZVhJaUFjRnVVbFNlZG1iSExBOENNSnRVZWd3bnJOMzhuMFlP?=
 =?utf-8?B?Wm0xSHFicGJzekF1bkU5M0g4ZXFlR1FUVzhZSmZRTU90QXlxOVkxUE8wUzly?=
 =?utf-8?B?MEZoWERMNVViN2hjVWRuTkw4N0Y1TGdBS0RKN080ODhDOEU0cjhEYVVzc2lt?=
 =?utf-8?B?UmtMTUFUY1RVNWFING9lUlhpTGRZdkVDMURqN2Q4cmdjU0lWSzgrMFppQ3p5?=
 =?utf-8?B?TkhmZE9wamZ5UUxvY2laRitlMytad2pVUTZGN2M5eWduK3Fya3A4VlRjRFdY?=
 =?utf-8?B?MEEreFJSMTFXNUlJVXZmektpaHlEVTdSRVdId2MwQ3MzTFlDamZ5VkwvdDl5?=
 =?utf-8?B?dXJ1WUJNc1gvQlFzNVhrN05qbWZKempzYkdwaWxYNnpyU0RrZzN5LzhjSUp0?=
 =?utf-8?B?MEQzUTlTcVdhbFlzaFM2bWhzWXNoaFN5WWVpc1U1WXRNb3hvZ0gwcWo1cHBi?=
 =?utf-8?B?bThIVmF6MVgyZUFQN042Y3RuYnhWTWJNVkd3UVZKZ0JBMnRFWmEvV1hOQTFw?=
 =?utf-8?B?d1JFVTMyZkd5ckEzdjlaQkVoRU5tdnpGVWZoWXR0bGcyQnpEQVNxMytCWHdD?=
 =?utf-8?B?aU56S2VxUE82UjI2UUc1MUxONUk3TVlkZnB2TnhnMVZuVnE1SHZYZk1BbGRE?=
 =?utf-8?B?SE95SjZwaUd3NGl5c0FMRjFnNWFucWdzY3hkUHA3TDZlRlo4QkNnM3BzVm56?=
 =?utf-8?B?K2xNTkVqR0IxeTV3MnhkRXZHNmMrWEVtT0xzdUVLS3REeWJtS1RRUGk2REFB?=
 =?utf-8?Q?5WPbn8Kk2l22s?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L1owT3hKcDRCYnRieC9vSCs0bXJja1IwL1IyVTV2Z2RSNFdlSnZaK2lMY1dJ?=
 =?utf-8?B?MDF0MmkyRFlKWjR5MlpDNm5oYzdjeUpUYXVBM1BMcHp0N2tVRi9LNSt4Zm82?=
 =?utf-8?B?UWpyM3BocVVOeHRIa0NYckE5aTE4TUQ0bjVENUh4N2s2ZFdJd2tGdmxManpR?=
 =?utf-8?B?TzdGSm5qc0FFSjh0OUROTFRMS214VElXVXBrSSs5ZTAxZS9VWHZuY1Y4NTVt?=
 =?utf-8?B?QkQ4Zm5oMWtsUGR6ZWhMZ056cllSVC9wcmpEUzJnMDRTNlduME5qcVJnNTJw?=
 =?utf-8?B?YmZ4YTR5ZE9LaFNzeXZYSjJHd1h0WnhhYnBGVnZiekFOc1BTdWlzWWhSR09i?=
 =?utf-8?B?VzBHYm5hMFdEYlBBN1ZIb2NBNW1DSlVrVFdsZjNxcFdTZEgxWlRWbnJlVjdi?=
 =?utf-8?B?bHY1RXlpdDNqWm1nSS9CK2tiYjlBKzdVeDhieTZwUmUzTmo2RXB6VCs0S3Rh?=
 =?utf-8?B?WkFaSU5ZQTZiT1BsR2c5eWUvVFVxdGxPdjZTdzh1cWNpUzlseHV0eDRXQWRY?=
 =?utf-8?B?cE9MMVNqT1RvMW9xcUFCN0poNTV3NjJiQWxuSUtZQjNqSEZ4cFV2bFprdmxJ?=
 =?utf-8?B?Tk9sNnVNK2hnV2FtazNaQk9CWVA5dTFtQ3JNNkwzWjRScktYaHlERE1Fa1Va?=
 =?utf-8?B?dUFpWkVoYVJTNWJiUTAxK3U3SmRSbGdRUXpaY3BNdlMvL2V1VVVaeGU5VHcx?=
 =?utf-8?B?VFdsMFpGelFQbExlMGQ2WjZ5QnJrN0JqbGY1LzZFazFscHZEaFNrL1N1d3Jq?=
 =?utf-8?B?ekhGUXhRSzdMN0dQUFpaWDRyU3hIYVFoMEx6Y2ZCRnovVS9jbHlySThtNG1r?=
 =?utf-8?B?Nlc4TUFPd21wN2xZa0pXc2loZGZCSUtYWW5obVUzVFdZVUhrTXR5VkNnYnRR?=
 =?utf-8?B?UmJobjNSejRUNGZ3ejNKYTVIUC9VOFpFa0VkazRPNmdSMmx4WWFzR2hheU40?=
 =?utf-8?B?N1QxelNsRktpNTU0MjlUVC8vSUQvdWwwSzM2cWkyK2Znd1FpRWpEQ2RqUmhG?=
 =?utf-8?B?MjR0dnMyOFduRStEaGF3NGxJcmhFVzN0QUVJOG5hT29wYnZJa2FsTzBVZHdo?=
 =?utf-8?B?MHpycGQrN1ErRmZTY25uaUJhVElLUHF3MUJZc2w2bHpNMWJXV3B3UTcrNHJ6?=
 =?utf-8?B?WHZwV0t3bVVVbStYc2pCZ0Uxby9jZjZvQUsxTmM1QXd2eFJpUVdUS1c5aXZT?=
 =?utf-8?B?Vk1leW1RMVpsWGx0TnV2Vkl2UGtqRXZ5bmpUNzJaWFYweG44RDNPOFliVWNU?=
 =?utf-8?B?a29UbnlWZDBMQnJCc3RMT0xGdFNUYmEyNXl0THBUNVZLYkhyL2t1MkhhZXNk?=
 =?utf-8?B?NnZrRmIxWWViQTlmUnFQc0dHVlhFSWkwc2o5bE9vMllmVmhVUTR1amVNc2dV?=
 =?utf-8?B?NjdZZmhnWXVwVnVRdkZqTmFjSEdldDdyUzU1YjNodllRdStGN3NsNGllbTFD?=
 =?utf-8?B?Uk91ekxGMzRWbzVRV2k0dnpaamJGYzBSZThMcndnLzNzb1M3TWVBVHZ2cTVi?=
 =?utf-8?B?dVNEYjVDQkFCWFRxUzJxV3lGR0VzMGRTbk1GWFlYaUVFMENHWjFYd1l5Y211?=
 =?utf-8?B?OEx0N0lHamV6amszOEJoeHQreTBDK3l2eVE4Mk5hYUlrdEFraDkxTktNN3Zu?=
 =?utf-8?B?ZTFnbHlNcEdzNC9POW40aU5MVkdUN0h3NDZLYVZSZ2phNCtreS8zUnZoYTVX?=
 =?utf-8?B?RlR5d1B2LytmWHJveWF0TU04YnpVMHFSUFRpbFF3eEgyMnhZVEplbVZIeVUr?=
 =?utf-8?B?cDhCZ2pLVVkxZzNZMGhQWVdpT0FnM2VTaGJsemJWUXdzdS9oRGsreDJHMEw4?=
 =?utf-8?B?WVJNdDVZN3BHcy9KRVlPUVFSS1Bna0R3RVJGK2YydUNucWE1VFFscDRVNFJY?=
 =?utf-8?B?cFNrYU5xTDdVYnZvYlFzSko3eGo0SnVZS01pWU0xU1ZMVTk2Y05pTjYxd3ZP?=
 =?utf-8?B?bFh1U0ZNZEdpNzQ1UXJ2bGw1dHlRd2NucmRRWHY2K2FCMFNaZlhnU3YvSkxH?=
 =?utf-8?B?QTlGTFppYVVrZkMxUnZ5ekZvNkdNdWhVSGg3azZVdjIwSGV5M2ZSOFlTQytL?=
 =?utf-8?B?cEFwRnp2Q0FwSVdibCtqeE1HVU85a0dUZ2RVaURzRlV5Tm9NZW5RRlVEYjVY?=
 =?utf-8?Q?y2sv3qIMvXKm6PLEHKXoDIrxW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c20ba08-20ef-4235-05b6-08dd607cb057
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 09:11:21.1767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oGaXISZ7nGqnMw1eHW+T7OFVte0nqw3K1KAVcAz/X22zhBozmIJII7z87LgIvawVMykvsWb2wtym7FyoytLbFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7154



On 3/10/2025 9:09 PM, Tom Lendacky wrote:
> On 3/10/25 01:45, Nikunj A Dadhania wrote:

>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 50263b473f95..b61d6bd75b37 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -2205,6 +2205,20 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  
>>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>>  	start.policy = params.policy;
>> +
>> +	if (snp_secure_tsc_enabled(kvm)) {
>> +		u32 user_tsc_khz = params.desired_tsc_khz;
>> +
>> +		/* Use tsc_khz if the VMM has not provided the TSC frequency */
>> +		if (!user_tsc_khz)
>> +			user_tsc_khz = tsc_khz;
>> +
>> +		start.desired_tsc_khz = user_tsc_khz;
> 
> Do we need to perform any sanity checking against this value?

On the higher side, sev-snp-guest.stsc-freq is u32, a Secure TSC guest boots fine with
TSC frequency set to the highest value (stsc-freq=0xFFFFFFFF).

On the lower side as MSR_AMD64_GUEST_TSC_FREQ is in MHz, TSC clock should at least be 1Mhz. 
Any values below would either triggers a splat or crashes the guest kernel

For stsc-freq=1000 (1Khz), guest crash with the below:

  kvm-clock: using sched offset of 4782335885 cycles
  CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.14.0-rc5-00537-gcecc16fa7fac #254
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
  RIP: 0010:pvclock_tsc_khz+0x13/0x40

For stsc-freq=500000 (500KHz), boots but with the below warning: basically tsc_khz is 
zero as we are reading zero from MSR_AMD64_GUEST_TSC_FREQ.

  WARNING: CPU: 0 PID: 0 at arch/x86/kernel/tsc.c:1463 determine_cpu_tsc_frequencies+0x11b/0x120

Regards
Nikunj


