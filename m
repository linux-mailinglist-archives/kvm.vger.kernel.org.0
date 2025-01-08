Return-Path: <kvm+bounces-34742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A1AFBA05291
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 06:20:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EF94188787D
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 05:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 800341A08A0;
	Wed,  8 Jan 2025 05:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ifFlkB8d"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3001185939;
	Wed,  8 Jan 2025 05:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736313629; cv=fail; b=sjhVVISvTYv9Cn7lqGh6RkuKUeg39usQHvdCkKJcDVlgfLjNqNxbunTVrobOA1aZ28HZzhswTuXlHmxTqQ1GwOTfbI9xlnIwS8OBZ7pBsFS88/Qd4LgwM6Z5CD/wICwIHVMdbDUDYBd991HVSiyoy2TBjHSQEjFRuiE0G7L5QFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736313629; c=relaxed/simple;
	bh=3CC/rsbXtgaxO3gPwA/LykintwoToUQWfM02af6IwYA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F97ZaIM0VV5a/Mpj/E/SRDShmbzZTUINhFab9PJhU9LGLlyZy8muQu0E1EWCRVqgXH1NjB1JdKZsB2IrM0BHcTIwMHa/UrqsnttcYct+0DCR13eCpndjpp5h4uMyXfPEEAYtrnMVp5DXYYvf48FLpYWKL5/SFj7HO8Zd/CfFgjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ifFlkB8d; arc=fail smtp.client-ip=40.107.243.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FrNSzDwtEeMlrcpL24vkKNeruAdYGTWUQnPChdxnOywCWg7Tct+b3qED9xuNUBiWGyZzgcd432Rwt73kiLvzcTxbrqLLWsN7d+gu7Br5H6pZ0RRHBagE4S1wP0AGGzIBOtWHIvDPloU3XP25CPVeyHrb60dBvYpicYWsXZ/AzMu0r1+ClFPwdXNRT5axw2Z/oQSsUCFa62rJGH+t6LHudoLEurD9VndSdrYErM49p5tH+1RJDH7hjzLTh+lzT6Due8YiZ2B/HT/lV3xyftniUMNaj9mM7NUry52kY0+DTcx9nmxB3lnTEbTVCBV9YY8NI9xx5yBvYOQPb6PgbVnp3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VROUWhTbgjezeNaHXQv7SgAu+v2w7/QduPe2KF+qmss=;
 b=TIEa+xp+rtzQsyY/K1kxW22wt8Ftgss34t/rV2YXKlY7ACxSpWvljHLs+c+wsgzGhvvb4PM/HcT6/30Re61GIjE4+T1hdYCt+GPO66NQOr1YtOpqqYr2ELVaOm2T3XGnisqudJ2Fz+JYTlottvVW+MiMm2mf8hLLXtHdENbvfiNA+EOjbj4AE3hBfcNAUTgk78AD2q8gqsvD9gz/FVo8lGEiy7mVIWnTBliLKVZPRzX/JalI7Stz0t+ccjccV+5Nx51cMkvNkPTpgruIJ4umjp/Me5RjrC3Xl3F1ZcLILvlB+PDPdvcZiV40eOjsbdWrw9oVwFIr3vng7gL1EOOtcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VROUWhTbgjezeNaHXQv7SgAu+v2w7/QduPe2KF+qmss=;
 b=ifFlkB8dgyLsuviM9aZGaqu7+isIKud527PqtcFYiPgDV/UuSlt/nrNto+hLLurvcjjWKFCwTHY5t4LTSIEKxdZAEqqtJmS5mcUGYDLD7TD5CKypnzzrGiiK+CmZ3zcnJsR7mTr8eXlJdAjICswclFMygAMBDQmaG6m5LcKtHkk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SJ1PR12MB6217.namprd12.prod.outlook.com (2603:10b6:a03:458::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.10; Wed, 8 Jan 2025 05:20:25 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8335.011; Wed, 8 Jan 2025
 05:20:23 +0000
Message-ID: <3acfbef7-8786-4033-ab99-a97e971f5bd9@amd.com>
Date: Wed, 8 Jan 2025 10:50:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 12/13] x86/tsc: Switch to native sched clock
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com, francescolavra.fl@gmail.com,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-13-nikunj@amd.com>
 <20250107193752.GHZ32CkNhBJkx45Ug4@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250107193752.GHZ32CkNhBJkx45Ug4@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0089.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9a::7) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SJ1PR12MB6217:EE_
X-MS-Office365-Filtering-Correlation-Id: ca741c5d-55a6-4a13-352b-08dd2fa426fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eHFxR1lkQ0dvbEpKRnVkdXplaFZ6VnVYWU41R24rMll2NE5NZXVLenBBb25v?=
 =?utf-8?B?MUtjSkIxSFFUWGl5LzlEdW4vaEZiVlZrSDFOWWowdllibDhyWjZNbDlkTjFz?=
 =?utf-8?B?YjlGb0Fyc1ZtQW51QXpzWEZRSXhDam5hZXZYTFBzZkFIeENDcDU2VFd3UW00?=
 =?utf-8?B?L1Z6bVFtcWg5eFBBNWloYWhXTUtJYmh4eXpqYmJYQVhlY0l5WG4ydU5VRHNM?=
 =?utf-8?B?YTFzTUxsS3RaQ3NlZTNKQjRWcCthRnVoTngyMW9EbXN1YjBEc2E3YUxzejFN?=
 =?utf-8?B?TGFXQkJKbUhlMXg1YzlrR2htWHR0bzA4M2xwdm9hOWV3a0hkQWZXSEJTZ0Y3?=
 =?utf-8?B?aXM5MEV5UGZUZlkzNHFSVEVTWUdpYkVNOUtvUTN3Qy85TzZPUERRQjlEYVo4?=
 =?utf-8?B?dVdFb3NzVnVlRkdmN0VsWjVETkxLY1QwMnZvM1Nsa0hEbGswNURocTh2OHFj?=
 =?utf-8?B?cnFEa1I0SENPdDM5MXVaNnRSWjRoTzZwbUdUdytpQkpDbVlNZkdGT2hMV1h0?=
 =?utf-8?B?Tkp0S0xnSEh4MmdYQVNnTG01bTZqdGJXaHcvYlNEN1BLejFXSVh1K0JiNGVN?=
 =?utf-8?B?THVvMXZ0K1M4Ti9CdHFrd0FCYS83blRKQm9OZmVYbVF3bXd6bTRMY0dKelRR?=
 =?utf-8?B?WUhwUytGVFBEVW5WQWRKdXBaL2tkcXRRSW9lSzdVcVdsa0pkYkRGblVXdXJ2?=
 =?utf-8?B?QnpZTVdYNmNTbFNqd2YrMnkrL2k5V250WEtMRHM5eEExWVhiYjdBMzB3RExy?=
 =?utf-8?B?Rjl1TFM5RWNUaXRHUzhQaWhuaUNjdHZrcjhqbXRxRHJSRml0Z21IRndYYWw5?=
 =?utf-8?B?dEFhNGJ1ckZ4UGc4NXFBNzlVNHQxcG9FMXFMTGEzYVBNSU1kdVlIZjdrSlcy?=
 =?utf-8?B?TFN2WGNGdFhYMTE4V3BIOHc3KzFsblBPSWh3Zkk2R1Rpbis0TEk2UFg3OEUx?=
 =?utf-8?B?d1Rpb2QycmQwSEFZTFVtWnF2ZnBZUXlzSjM0VHdnRDVRakZwWE8wQzF3bFpD?=
 =?utf-8?B?N3orbkZqMGExTFZoSlZtMU9MY1RMYVBieWVMTnRMMjdPSHhCQ3M3aVR6dnMx?=
 =?utf-8?B?ZjZScVdsY0puSDdXU1MwYVZ2bEdRdkdrb2l2WGgxQ2lmN0tZWVNSQk9vRTNE?=
 =?utf-8?B?bk5Mak5Bcml1bTVHMThhaWdqWExCc1FDY1JoSVFiTHkrU0lzMldLWEVtYkxX?=
 =?utf-8?B?ZWRzcDg1RzZQMVJ1aHFXYXdXbHBuMDNlZjg3K0JlUVZHeEhhSzFJUWVYOVZm?=
 =?utf-8?B?bVRKRk5pdm1xK3JjcjNRMkxldkhXc0VCSC9pOEF6YVNQWWQyVkhGVzRkM1BO?=
 =?utf-8?B?cDUyZi8zdzdVY2ZHVUFvNUpMNzFZVUFFMFhYMXIxWURZb3o0U1NKV0l3U2g0?=
 =?utf-8?B?aWtERTNvYk5YelN2MS94anhBVDVhbnNwZEJFNUJmc1ZOczRIbFlPMWVSaExV?=
 =?utf-8?B?Rk9oWUUrOE5vTTJ6bkZhRWdOSEpWenppcVZCaXcwUTJCbDdKeVM4Nk1VY2p2?=
 =?utf-8?B?OWkwREw5SHVjZC9wTzZtWWVXQVF0aUNsMFE0MmNHOGJ6MGNhTlptaHA2czd2?=
 =?utf-8?B?eGk5QTZHOE5GTlFWL01JMDcySjNuWWFIankwNDNqQldQbk9vbW9QbWV3eGFY?=
 =?utf-8?B?QmtwY1h6d3d6aE1tcUNVZjJQMURDVDV1dFMralpVeUVNQWVLWDRmQ3JNVkVW?=
 =?utf-8?B?b05JN2xobTZKTGJhYk5WY2Jnb3FDb0p1dTFLVERyR0NjMUwxQThHdUs5aVVp?=
 =?utf-8?B?TlJpb0Zva3NrZmp0cWkwRmtvRDlMZWgzdkVNVFNhdTdtRERVbVFxNjlrS0tD?=
 =?utf-8?B?bi90OWdFT3ZFbkI0Qmg2YVFxV0llVzJGL0lIM1FBd1BtbXVJOXpOdmxqMUZs?=
 =?utf-8?B?b25SYXZjc2NTQ21ocURkNlNaWU1qL2sxL2dNdllpMXR1TXc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WGhVMzdIY09idmpJQWVuNFhyNmpkcWplUjhPZjBEVXQ5Q0RmOFBUSEdUeitH?=
 =?utf-8?B?K3kwZXFJT1d1Z00yVFFqT2FyTEdjeCs3aWtRcnJYV3FNTGxXTS9xRlV0czZj?=
 =?utf-8?B?UVB6SnMwS2g2OGZBWWVvclVBd3dPZHhpWk56RjBQZzBwNFhidUNndjl6TDlu?=
 =?utf-8?B?UEhZVGVPRmhCVUo5QnVpakY0Yk5uQnRRZzRwS3o3emR5WUwwRXNFODdnMGEx?=
 =?utf-8?B?c2FSNllIbGdNb0xxa3QrUmtCQTYxcEFkbjFmMTI2ZmNTanhnOHhFRUlQUDF2?=
 =?utf-8?B?Znk3NGRTWEpKSkdIKzFpa1pkYW1LdHBtblprcnlxUWRkQWhhcTBkeFBjQXdI?=
 =?utf-8?B?Rm1rTTZOdlBtMER6QzhLWnRKUjB0R0xzTGNjZzU0L3NFUUg4OHl5eWpieXl0?=
 =?utf-8?B?TUhCRU9GeElmRjlacHhxQ2dqYVhXNUxUQkFkZGlZMGYyRm5IY3RNcGcrYVcv?=
 =?utf-8?B?WXpqVE4yaHRMcVlGU1dsN0F5RHhxZXpXNzRFUGsyNEhZc3FJTndOMzg3ZzNL?=
 =?utf-8?B?emh2Ylo3elVvZ1l0NWhtWFB6T3lXUmdhNktwZzFUQlA5STlvaWwwMEhRQVFv?=
 =?utf-8?B?cVBsaXF0cC8zblZjUU45a0QzaE5mOElub2tLL0lQS3pxQTRBaGJsS1Z1eXVJ?=
 =?utf-8?B?V3prcGhhTkx2aVBMb1YrRUU3d3daM0NsKzFhcU53bi9tbVVPNnJXUnEyU3BM?=
 =?utf-8?B?MjlaQ0RJQVNNcDNZdGNjdmJBZWJBTkVBNEhjV0xpcjZlWTlkVWx4SzVUNkw1?=
 =?utf-8?B?WXh2SWt3cDdzOEM2cVk4Q2I2UHlTSzNZU1ErbVBxUmF6ODhPb1RZYWdvK3A3?=
 =?utf-8?B?OXpvNUo2K09IdkZZSlZ1Vmp4MS9RTGVSa0t1dWYwUERPbTVSSkVoS0M0ZEc0?=
 =?utf-8?B?N1ZlcTN0NXhxRU1wdXVVNnd0Q0RlUlZ5dU9OOHJveXdNWlRKc0dHZzhtY2Vo?=
 =?utf-8?B?TjR4RU5nd0w5QjVKN3Zxa1RNNkcxYVZ0ZkwrTzI4Ymc2TVJCb3FlcjU4R3I0?=
 =?utf-8?B?T3JLZmVGaGs5T0lvUjJTaUpEcDhvTHJqN0ZUZHR2eXp2bXd1NHI1VmlEV1U4?=
 =?utf-8?B?ci8zVmFjaUV3OXRtMDc1Z2NtbUtXZTNmdTBFK3FHQW44em1LZC9NUVZXc292?=
 =?utf-8?B?WFV6bEJ1S2VJNXF4ZGJFMGZyZW54czFPQ2F1V2dETERTWlJ5aXdMRS84bkZT?=
 =?utf-8?B?cUpzMFJzSThzcktZQllqMnRFRXZnNUhJYnVDekUvVzF5N1FTS2ZNc1BOR2JP?=
 =?utf-8?B?b3VmOFdOaVNPalhzbTZpU3RoYTVULzNOcVNKSExkQmw1VjE0RVVYdWRxbHcz?=
 =?utf-8?B?RWVNbnlhNWM0Zy9vZ3pPa2VnUFJsRzJKeWtqVzUxYUx5UkxLc1hMSVNXaWho?=
 =?utf-8?B?bTJjc1VGZnA4WlRUTnkyTjExNkdJelVoelFzenhUYnNaRXdjVFVjYjNNSmZ5?=
 =?utf-8?B?cElDVWk3SEJCR0ZRYkFORGhPamNBRVgrZ3h4V2kxcE9CcUprWHliNmE5WVFU?=
 =?utf-8?B?aXZUZWZBbzFabDNXcEpzNlR0VFEvZVprZzRJS3dSWnEwTFQ3MjVqb0NqZ0lZ?=
 =?utf-8?B?Sjl0NHhORnFaTms5RGtKbEF1akJDK2dpcG9kbEJycTFRTW9hYU5VYkh0KzdZ?=
 =?utf-8?B?RnIwL01JTXh1STNwakRTaURkcW9kT3pwTS8yczQ2aU5nRVN3Q0NQRzZtRVR3?=
 =?utf-8?B?a2JHbGJLM0hid1pkUHRJRS9oWlBBYnJPRitkZDhYbUR1aC9jQlVCSmJVbG92?=
 =?utf-8?B?MFVMZjNMeVlQS0FVOXh4NHdLRVFYRFRURDQ1NjlwcjBVUVg4ZWxuR0Vsdk83?=
 =?utf-8?B?THRmRUM4eDd4YXNGS2Vud25CdS9QVzBPdEp2RFpGVGpRVWI1aW0zT1ptcmhI?=
 =?utf-8?B?aGNTQzBtZm42ZXlQNXM3dEREbjhoWmZBYW9JN0IvN2E0TE5tUWlseitlM0xH?=
 =?utf-8?B?ejgvVjNwM0REbHlaMVppT2NDczZVMTdmODkrdUlxeUhXdm5nNzdUTzlTeXZl?=
 =?utf-8?B?SHZlSjJFL0NEZkh2TW16aVBaeU1CM2JBWkFVMUx4bFd4VGcwa1I4MDZKR2NS?=
 =?utf-8?B?Q1RWSHZvZXNJVDl1clo2VXhQdjZsZG9XN0JmWWpqNjhlVy9vNW5XRU8xUDVt?=
 =?utf-8?Q?WU2h02zLaTnGcgau5raI+kGWT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca741c5d-55a6-4a13-352b-08dd2fa426fe
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 05:20:23.5572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UKuY/R3E/cx9pZCi9aafc1drodks0A33HrBWqm5HD1y5Fmkq0jQU7p/SFKaDCgr1E9aeDvHaf1l/Xu/0aW5cXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6217



On 1/8/2025 1:07 AM, Borislav Petkov wrote:
> On Mon, Jan 06, 2025 at 06:16:32PM +0530, Nikunj A Dadhania wrote:
>> Although the kernel switches over to stable TSC clocksource instead of
>> PV clocksource, the scheduler still keeps on using PV clocks as the
>> sched clock source. This is because KVM, Xen and VMWare, switch the
>> paravirt sched clock handler in their init routines. HyperV is the
>> only PV clock source that checks if the platform provides an invariant
>> TSC and does not switch to PV sched clock.
>
> So this below looks like some desperate hackery. Are you doing this because
> kvm_sched_clock_init() does
>
> 	paravirt_set_sched_clock(kvm_sched_clock_read);
>
> ?

All guests(including STSC) running on KVM or other hypervisors like Xen/VMWare
uses the regular TSC when the guest is booted with TscInvariant bit set. But it
doesn't switch the sched clock to use TSC which it should have, pointed here[1]
by Sean:

    No, I'm saying that the guest should prefer the raw TSC over kvmclock if the
    TSC is stable, irrespective of SNP or TDX. This is effectively already done
    for the timekeeping base (see commit 7539b174aef4 ("x86: kvmguest: use TSC
    clocksource if invariant TSC is exposed")), but the scheduler still uses
    kvmclock thanks to the kvm_sched_clock_init() code.

> If so, why don't you simply prevent that on STSC guests?

This is for all guests running on different hypervisor with stable TSC. And I
did try to limit this to KVM here [2], here is Sean's comment to that
implementation:

    > Although the kernel switches over to stable TSC clocksource instead of
    > kvmclock, the scheduler still keeps on using kvmclock as the sched clock.
    > This is due to kvm_sched_clock_init() updating the pv_sched_clock()
    > unconditionally.

    All PV clocks are affected by this, no? This seems like something that
    should be handled in common code, which is the point I was trying to make in
    v11.

Regards
Nikunj

1. https://lore.kernel.org/kvm/ZurCbP7MesWXQbqZ@google.com/
2. https://lore.kernel.org/kvm/20241009092850.197575-17-nikunj@amd.com/


