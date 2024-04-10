Return-Path: <kvm+bounces-14170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C0538A0337
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:21:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DC8A1F21D5A
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 22:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDD371836CB;
	Wed, 10 Apr 2024 22:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BxpdQXbk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2109.outbound.protection.outlook.com [40.107.236.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A212181CE4;
	Wed, 10 Apr 2024 22:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.109
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712787665; cv=fail; b=DM5Y1K5i+gOHqRtelD5/WSNheT1WdoBkfA1mB0m2g/0Tc1JHizasPyy5Dt9Vg1dsLn+XwSAphkQbhRaPs6o74phtIcKR7Fn6oF4EwLZwpfQd2CsrFFGzbyQkgeTC+5SsumXTgLnqmOz5YnC/V8ehUP62SH4Eh+njNmF+mXy1nFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712787665; c=relaxed/simple;
	bh=mVdiK/lMPSZMt1DQCIdV3S3L8+LwPX1z8VOU/45JSBI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dCPwTIC2rIrvHxTv5vAYo4s5/2jE7pLaZIDha7taUPQ2jvsofvYhpyvRbjTOLq1wWj1UyYzv14+CTZyH7Gadi4koyiADpqpYWsXO3fnAKMRfnG9p4x7JlOhl/6gYQ8WtG6vcreQpcO5jHjpZVUxDH1lIlv86S00lSMsbkR7XuKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BxpdQXbk; arc=fail smtp.client-ip=40.107.236.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNzlyUbfRgyK08akfOu5SCXPZp6oTZJawzaIuDowA7JRORyMSU4jNbVqnBrOd+HnZ+2VyaKRo25f1ZeBtGdb8R0E+1TfRAj3SAvoFaop+eRejRqhoyMx0vBZwOz7M9Aw8c+69PiRTHr9Z9jByJ0+WRMx4uCueDi8fnPbSpWSkKevRYsMx+hoGriNKHLgqFk58KZ4ON6Ltn6rgCME5LDnNZ3HBKU9Vf5PH+Qk+tcsI9YVXDPhukYZL5y7QFCFLUMf2e5XChnyFxf44brDtX85BqwGZTlVu0SL84XGUlc9WByBfjs9OL9AVOG7fPQFnnvIR8RjYyFmb3JZd7HooJtb6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bo4p8uIULOAidvNWZBr6RWtqf5QaJ9yfTg3Z8PV7aeY=;
 b=KZ2tzDmt6xB7yz5q0B3LmSk+x0Jvgmzme/OLjghAin9J/zO9j2yv5j9KA3nH6cPwFG3nXxvx4wyLnvGBTeoBfdVPVKrRM9+k0274RQMVRoxGfZIGasvM+3GrGFHWSFulKDSOYTeY9oEVk7pVlBUNbgWHUwNMsnbzwOv++7EA0TdamZ3Be7abempzt32f2DIrFZ28VfuTpUhdUYIImAvGF09MIKzphTZ6tyT0LA1mqN5Y4WUSmwYp0gqZaQughB4Mo/QeFE5qDbrtFKdzno9+VcKh3HAQAB7RIll+PeMcXSQlL7vuMvoXyVHkpGuITrw4WmyPOcZJMev+u5dE2RT+Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bo4p8uIULOAidvNWZBr6RWtqf5QaJ9yfTg3Z8PV7aeY=;
 b=BxpdQXbkMT00i0L99PdrTwiGiAgMdif67sc3tva1gGlR8+aPaOsW0XISVhzw5lrJpK6+GyYKMscSxKaBwMuiNC7fTY6RghwFrO4vsWpjZZl0PfgGmKp8adx8sNiP0HkXfBtyWslg47aVpWke2EHblAG6TX6dq0izIguEZpUL5gQ=
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by DS7PR12MB5934.namprd12.prod.outlook.com (2603:10b6:8:7d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Wed, 10 Apr
 2024 22:20:59 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508%6]) with mapi id 15.20.7409.042; Wed, 10 Apr 2024
 22:20:59 +0000
Message-ID: <621e4304-d089-282e-0e67-2a4fe75fa3d9@amd.com>
Date: Wed, 10 Apr 2024 17:20:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v12 27/29] crypto: ccp: Add the SNP_VLEK_LOAD command
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, hpa@zytor.com,
 ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-28-michael.roth@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240329225835.400662-28-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0047.namprd04.prod.outlook.com
 (2603:10b6:806:120::22) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|DS7PR12MB5934:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zGJPYFa7gXsz2vQxNqUe/ssVb+lxHQO455dDpxsx2+v3tJeXuZBLa5DhtkPsE3o8roHUGHJjnm9mIgt4D64U4rLa2LjHcMEWe1pGxcPTpIQ6KsBfoaAaZ6ZokcwwApyPZeWMEB0sVv9wcfXBE9LVsP6EhBRZvxeJ5zNdDD9BJav4f/vQ4atpW4HeBJ3kGxBzxcnm0CH2dt1+XVO4fX74ERDaxgYqGnRDaOe10dXqjCi2GqM4kDb+vKvQkk+exzBULBOkMqfQDJZ43zp/Lhk4PCAkJ+aDV8z+nL31XYPVPxNnGGX99KEJwyEUTSzjG1+NNnqHdx4osJNVyG+71tsWVl3lwnHMtawekBg7v2cnh57Mh1j+CZYjOOya1BuChSirNapWiBHrCazf/uvHmSvqnrnklJmTiLfBQeB/jP4jF/ExqXfG8+a8OGdbrRCWXUtuYVUXxAjoLb7uoMU8ydROKDtUC8CKAqj59BtJ36pfyXjYhzVCOEjK6xDMJRFTvCQh8k1DPgVRhRoLhUoDwhmWHtNd5+oKgk8YbXnSgZZdYIpZPOuE/70MLzQGiOrVNMd04u1b/GXWpfFUA2ioPx++PwybB3sApd/Aj/ejG+BM58D6Y/oa6n3RUJ1Q/rNMDtNk/8LEI32cHr6nZvFgV4vtwCZINtOXepjFBGjlM1xWGwQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QmpRNnM1YjdURUJIVExQcTN1cGEzRzE4ZFB0dk0xaHlSRUgzM2FNdE5MWjA2?=
 =?utf-8?B?Tlp6UVpFRHpxRnd1K2xOd0NkUnpPT0FMVVp4SnVoak5uMEpYK3dqU0lQNTNq?=
 =?utf-8?B?aEVkWjZBRTBzM1Nobyttb2tGQ2wvVmllRU5HdlJhbC8rWmJVSUNuNjJxVGpV?=
 =?utf-8?B?ajl0Wm0rSXF5OTFFNDBwUWZncjZaVGNhMUVBd0F4N3prOUtpc3lBdHIrMnRx?=
 =?utf-8?B?WlpWYWlqVXRadzJKb2ZDUHlZYUJMNVc1VEdFWWNUQ0NqNjNldlZKcEYzb282?=
 =?utf-8?B?eHc2RTBQcGZiZ25wWitTTUJhTzViY3F0ZU1qWXNKVVcyREFZZ1JLS2k4QkdV?=
 =?utf-8?B?MXNYYlFoamY5WEhwRWFzRzU2U0FsOGNON2k0K2tHcThyQzFvT3FjOWJ6VUhU?=
 =?utf-8?B?REoyV3pVdFdHVGp2MDlmR1dlZUlqMFhXME5TV0dEMXVZUk4zWEpsdHQ0RFd1?=
 =?utf-8?B?RnFHMUpEbkZpVnErWnZXSEluMnFLRTRMaFFzRk1SK29INVBoR280WEtPbTBl?=
 =?utf-8?B?TjNtNW9naFE2MS9XRUwvUHFuSWM5UEdGSW9HL0Nid0U1aTlwL2tRQVRVcDFI?=
 =?utf-8?B?U3ArY01YUVFPQUVSSGFHeDJSb2xCTmwrQWloQWhOclFFQjNYd09oeFlPdk5l?=
 =?utf-8?B?eTY4TjliL0NpNmxqNTU0Y1k2ekhrK3c1UFFpQ0QrcUw4NHZCQlNFVDFXVDlh?=
 =?utf-8?B?Y0ZJSGp6aHc2R2lnWTJCUnk0bHh4U20zZXZFNDg3R0NwY1BTemVGeXFPblhH?=
 =?utf-8?B?OHRCNnNtd2FiSXRnYnJsVHhodXJsVzdkczcvRVVySzZNditrdDE3WnJ4b1pE?=
 =?utf-8?B?ZFJXN3hQcUZqZE9ub3lqQmtRYTRuVnVQVXd1SG1qTXJUVFBnOFY2cEQ1bXdr?=
 =?utf-8?B?Y1Yway9sckwzcTVYOU5CR0wvTE9JcXhHa0ZsS1BsVlJCM3RJVDRVQzAxMzFz?=
 =?utf-8?B?NGNIWVNMWkh2b2k5MFdzODFCS3hESHlNSEZwSkVzR1UvTlhtWGtnYWEzQ3Rz?=
 =?utf-8?B?TmlzUVltbnljV3JEN01tblVkWGlheVo5ZktITHE0TFU5czd1R2Q3QXNpeHp1?=
 =?utf-8?B?L25vMk9DRTlNUU56RUxlUFVaUkoyMDFQZm5rL2pQYmd3OUwrSDdTZ1lJL1hD?=
 =?utf-8?B?UU1SWUdyWlc4VnBkMDVLcmNZeWppWG1GaXY5WVZIMFdzWFZwTWRHMjRHYUFn?=
 =?utf-8?B?YzcvK2hKNUdNa1dYL0tsbE8rMUh3SkVuMUkrWFJJOWsrRFJJb2FpVFdWWWNp?=
 =?utf-8?B?TDJWWmdsVVNoWnAwNThJRlQwd3FRczVnMXYrU0Jja1JPSTZ1V0k1S24vUFA4?=
 =?utf-8?B?dXdOOUlzQnE2RmFQVlEvaFBsMzViWTNNYWhJZDNwa0QrRmVwRWw0Q2JDVGp3?=
 =?utf-8?B?ajZWSEJKY2tBaU5oMENGNTFwcThTSzdVZEdlN21mZjJzcmRKcVduYk1HcHIw?=
 =?utf-8?B?SGRtTlFoSXVrU052Zjc3Qm1FaTJUZjRWRmJlQUF5bXNpR0hDK0VZUTBuK1Vi?=
 =?utf-8?B?V0ZRcGJxblhvaWUvaTBNRnVlYWk5K3FmNlR3RkV3RzJtcVFMOGJoS1VhNlVK?=
 =?utf-8?B?RVc5cXN0WGw2dHd4K1hrWFg4dlRYTHRPK09QelJLLzhOSmFqTTUyOWtkRmkr?=
 =?utf-8?B?YktJZHN0NEowbkx2TDZqcm96am5DOE16L0FIb2VYUEUycExYNUZueHVmQVAx?=
 =?utf-8?B?MGtRcy9XdXRNYjE4MDVEM2tXdXdUTU5wNmJvTm5mbnIwVTBRMmVnL0hnc0Q5?=
 =?utf-8?B?cnhRRGpnelFoUWJqYWRCNDQ0akVsSWpLeStFVDc2RHZmaUZLOXRqb1p1U0x3?=
 =?utf-8?B?QXdRTVN4MDcxMDVFY3JRSGZqQmtldlUvUGJRSUZJek05S2p4ek9qVmhKMDVx?=
 =?utf-8?B?T0ZkbTZGM0wrMkFUN25oRUlHUDlaN3pRSUZiWGoyR3ptMDJ4Qk8zbm9sQVkz?=
 =?utf-8?B?bC9ieG5ZZENxZXcyVEpsVnI2VzBoQnhEeEI0UThvWm9XWk9nbGVqVzQ5UXk0?=
 =?utf-8?B?YVozaWJaa2NnYUphTE90N0p3MUlxMTEzYlZRNzhpd1luZzQ2VXNNMWZKc3Z2?=
 =?utf-8?B?TVVvMjZ1MXkxV3FlcnZiT0RLczJJR0NveHdyZ2RYNFJtWFFKaE1IRElPMnZt?=
 =?utf-8?Q?u1mxvO/s/OazjZP/bK1c1Yc8z?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5cc8fc-6aaa-4750-e77f-08dc59ac800c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2024 22:20:59.8990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWwvEa+c69ehrxOq1M1e387XSRspBwICziOPGgWSG41dxSGlgL4yvtd9GuKWMZ1SYfE/ov+5pynJGw9Cq3j4Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5934

On 3/29/24 17:58, Michael Roth wrote:
> When requesting an attestation report a guest is able to specify whether
> it wants SNP firmware to sign the report using either a Versioned Chip
> Endorsement Key (VCEK), which is derived from chip-unique secrets, or a
> Versioned Loaded Endorsement Key (VLEK) which is obtained from an AMD
> Key Derivation Service (KDS) and derived from seeds allocated to
> enrolled cloud service providers (CSPs).
> 
> For VLEK keys, an SNP_VLEK_LOAD SNP firmware command is used to load
> them into the system after obtaining them from the KDS. Add a
> corresponding userspace interface so to allow the loading of VLEK keys
> into the system.
> 
> See SEV-SNP Firmware ABI 1.54, SNP_VLEK_LOAD for more details.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>


