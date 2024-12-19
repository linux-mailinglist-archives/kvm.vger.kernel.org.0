Return-Path: <kvm+bounces-34179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 909879F8779
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 23:05:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1C96F7A04AB
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 22:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C088C1D0143;
	Thu, 19 Dec 2024 22:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tkKaBPB7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2051.outbound.protection.outlook.com [40.107.96.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398575FDA7;
	Thu, 19 Dec 2024 22:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734645892; cv=fail; b=ZrdViva9ligxm9WMZwpG4LdW3ZPHDMh+yx3SsmqBCF/A+aBDfgsLLPCmv/6ZtHKs1fg88GAiY4AOzZhOFjaaGeXF3GTxBuv2hffSHIMu3AWXAjN0KWmg5tA/cHCV6fSs3jYgdpJtkUm8rv4a9d/cG9uwsn42hlkQI5IIoBBs67w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734645892; c=relaxed/simple;
	bh=Q3tJFh4W2uPOKpr/I9UgFt6IcNmHJn5ksqcyIrGwbk0=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jbbYDE8ls5D1PnOvHGHTLLvQ6BAhtU530GahLe7Kip5vYv+8OE82Sn3Psn5HTkmOatg5yvzHXXBpNc3Gm8T5b+Ibqo4F6XjBcyDU9C2AuQr4PIXjlDDpqigrxwYbUb+uSkaE1MfVPvstGLFD5lkIlO465/2fthUZ8KMfnewh4OI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tkKaBPB7; arc=fail smtp.client-ip=40.107.96.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cpIKrhfQdAp2aIFgtAXHfk5Lh7fLIda2J4Ga7FICrMkEYDTYUOKfOB/w7oNjA9/sZLsMLzv2aiHs5xRLQ7FxSKmX1bptNqFzceD98hqnkGoo9G1t7i548rx2ggTYMvNOPure9NnP4RTLompNANrG0nVLEE/QP+KLsZVjIob7/YeS9focmtxAN3EDYFXOxZ1LdLM0xhjHj6RI/bGwEyYHcX/CU2I3zNLkW6YvoiYYNgnDfEE8BhjDQ1jqtocbhsToNtQUyrmag2ubTU11eXmFjPd6XvaO29tdD7vL1GADUkBAMjBKi00pbLJ5+8WVQU1lo+egVdkq4MSPt0ND2f3jLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DDmTX9EBuuzgfr8qQDBcMAMWH4fv7D1GELImvGc35vQ=;
 b=aiVN9Ab60tiK30iCaCcWJeNxQUNAVr3PUE4S9Y/oLXfAzhMkchaZ4TtZErhJYMcv/vwjAY3VnNFDgF4XPo3+h1rDc2thw/4fn8SMTKhzoD/v748ReWiHbWyND6/VA8fWeNoV3jp49W507JVtzopLYKUf+sB03+l/oHgWKaXNxPuceuUFoQ46bXNi4w1NuQAzmENwRqP1RgqFWSOj6xIHIVX2w3n1IfUS46HyNpIIJdw00kBHwwovFrzIKavOw3n/+70bqKY5e38MZ6dAryNp/An3LVh5B65v/NYLGEq0ZBzfPWhow9um6tHnKdMDEMLAvZqNmI4c/jq4j6lTqpthfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDmTX9EBuuzgfr8qQDBcMAMWH4fv7D1GELImvGc35vQ=;
 b=tkKaBPB7AIjZa0cq9u3knz0gfloc3Xiiwb/v/TL+sq4gB553yIVjk/RIFAVgzD6TZbsRDTRTby1dTcQp2vxz/SDv5CJEd0aRHHXymWehH+1pjx4sMMeO13l8RJVANaVS5gXoJBnfP6HFs4wLAXJj9+YowzTVbkiEZ+56w567URE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS0PR12MB7801.namprd12.prod.outlook.com (2603:10b6:8:140::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.13; Thu, 19 Dec
 2024 22:04:48 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%7]) with mapi id 15.20.8272.005; Thu, 19 Dec 2024
 22:04:48 +0000
Message-ID: <d0ba5153-3d52-4481-82af-d5c7ee18725f@amd.com>
Date: Thu, 19 Dec 2024 16:04:45 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/9] Move initializing SEV/SNP functionality to KVM
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Dionna Amalie Glaze <dionnaglaze@google.com>, pbonzini@redhat.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, michael.roth@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1734392473.git.ashish.kalra@amd.com>
 <CAAH4kHa2msL_gvk12h_qv9h2M43hVKQQaaYeEXV14=R3VtqsPg@mail.gmail.com>
 <cc27bfe2-de7c-4038-86e3-58da65f84e50@amd.com> <Z2HvJESqpc7Gd-dG@google.com>
 <57d43fae-ab5e-4686-9fed-82cd3c0e0a3c@amd.com> <Z2MeN9z69ul3oGiN@google.com>
 <3ef3f54c-c55f-482d-9c1f-0d40508e2002@amd.com>
Content-Language: en-US
In-Reply-To: <3ef3f54c-c55f-482d-9c1f-0d40508e2002@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::14) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS0PR12MB7801:EE_
X-MS-Office365-Filtering-Correlation-Id: acbfc95d-71d4-4823-ca40-08dd2079278b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VWpKalJNM0xKRlNiRjRpUFJqQVhrcVpmbFZuTWNiRXVOK1I5QmxmY2Mrakh0?=
 =?utf-8?B?YzN0ZUlGMVNFY1g5TzlNNk5TaU9uaWV4ZkZNWThYMFVNdy9QMFN0RWQ2VnNT?=
 =?utf-8?B?K0w1VlovUnRkRGJUT2xmZW1LTWZSSXNSV3ZHWlA4OGE5WDh6aDVuWXR2V2hy?=
 =?utf-8?B?T21QeFBUUENSZCt2Z1dhNzR4ZzVkNGRjcTN3N09nL2lVMkdTdGdJN2NTdnE1?=
 =?utf-8?B?akFBaStGSnBMOWd3cUJnSEk3QjFXdC9peEw4YjdaaEtKV2xYeWxRTnF6cXhz?=
 =?utf-8?B?Mk9xekMzUlc2eXEyU1ZFLy9mNE5JVm96WHMveXdvSmtZRWV1VUFWTjEydEwy?=
 =?utf-8?B?Tmprbit3YUo0aEVzcGtERlAvZDRiejF5citzM0thYmUvdkJPdmJCdUx6dDhm?=
 =?utf-8?B?b09MZXVvdlRBeFQ0bCtFWmNCUlRHUmNwNlo3Um90ajVmMWp2TXh6aGFoMXRY?=
 =?utf-8?B?WGpzK0d2SXpWTE91Q1RmWC9aK1c1Z2pyMmowY1kyV1JEbDZxSTZZL2thejJw?=
 =?utf-8?B?dHN1L0N4d0NPcTVqbTlYNzllYWJLaVJLenEvT1IzWVpQZ0t5VUFkamFzWFdZ?=
 =?utf-8?B?N0QyWWlwN1NpSHc5SzVwR1dKbGV5QjM0VDNwbk9WQWNVOVJXaEppN2pwbExP?=
 =?utf-8?B?T210UW1DZ0FQb1VJR01teW1hcXpibWYrSkl0dFBid2Q3OFdKN3hCQ1lNb3V1?=
 =?utf-8?B?aXVSa2daL1BtS2dtZndGb2d0akJiYkphU0x4MTdFYlRmbG5tV3VIcmR0bHhM?=
 =?utf-8?B?Mkt3ZGNkNWxYUTJWVkI3akZHdFd0Q1dHSnQwMDBxSUZDRTE4N0puZHB5NTZt?=
 =?utf-8?B?RVZWUGJ1elJxeHBUakMycnJMUzRFL2lKcjh1VHo4OHFFWVZkRzVjMSt0bjM5?=
 =?utf-8?B?L1BBR1RONitkQU5EWmdJd2Z1SDZ2c1k2cDBjODJsN3hKUTBDc1MwTHluMzRZ?=
 =?utf-8?B?KzZ1YWFkTEM5NWJHekQ0YTBiQzBPUTdSQmcyVk1jVForN0dJYTZZNG10Tmlk?=
 =?utf-8?B?SGo2UWdRUDlvdTZNNUc1Y1FSdityai9od2tLWFJmYTVPZTEvZTF2UmNxQjVQ?=
 =?utf-8?B?TExXUkJiMk1aakI5Y1RyMk4yRmovbDNCVWEweHplekMzMnVmUlUxNVN1K0wx?=
 =?utf-8?B?eVlJT3pwbjZxOU81VlpnUytLV3h2emppZ1RhS0gyNDVOMGlGa25Ca2dnY1Zl?=
 =?utf-8?B?T0xIWkxjWWk1dU51NUlMd1BIbG5IWW5kU1l3cmdlcHMxUzc2MGs5OWRjUWYx?=
 =?utf-8?B?T3NEd0d2dHRWUEI2U1JjRzVxd24wNGVEeTZ4Mi9TR3ozQVVIOTVKbWs0OWRD?=
 =?utf-8?B?VjloMGtncndhNmZiYjZyU3U1TUpBR2lKeE42dm9UcmJ0VUR3TVEwdElkWHpZ?=
 =?utf-8?B?R0xqck5jQSttZDcrZktPVnRURVU2YWdYYTkzOTAxWHF5MVNzTGJJUDRjTURY?=
 =?utf-8?B?TjZzZ2JvZ0ViclgxcEVvVllSRmVsWmJMb3QzU1NsOEJGd1lLSFZUcDBwanVO?=
 =?utf-8?B?Uk02YXQ3NDdNZkdIdHczdXZNZlJVdmcxOFdTVmp4RHd1dHdSSTl5VU5FU1Vt?=
 =?utf-8?B?ekNFNUdteWJaT2lEUEw1b3RHcUVMcCtGOUJLdHBPWkRGajlsMEJJMUZ2RnFu?=
 =?utf-8?B?bWFtVTdEUW9Tc2ZPZ1J1dlcra3J4T3FBUFFGdzRHNlhmU2FjMEJJaEVXWk9w?=
 =?utf-8?B?Y3M5cHdBaWt3VW1pdk9Id1Q0bnRWTWlMUTF3S2dvaklDLzBkQmpnV1lJcGJ0?=
 =?utf-8?B?dVVVUDlkOVVOL1FtMktWTUN0NFhKQnYwb2RVK0huNm1TSkQzZWNlNFVLTkRZ?=
 =?utf-8?B?VkpFOFpNRU5mYVdIdWNqYWpFS3N1cTg1cmcvRmE2ZTg3aHAyU1BJRVRhUlBI?=
 =?utf-8?Q?MLylWG0SeI2wN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?anQ1alpQampNN2tqWnI3cmUrNVQza0xZSEFWYTBmY1FIeUl3cjJIcDEyVGNI?=
 =?utf-8?B?N2RJdStFYW5oSlNoSTZPWnVINmpxL1NUUERGeHFKTjRwUTkvNkJuNFNGQ09G?=
 =?utf-8?B?NytrRDVLRWZYYWE0ZDBORHRoaks5TzZNckp3Z2x4UlBJdnRpY0NJUGxKRWZB?=
 =?utf-8?B?YWdKMkJ5L2xORHFGUUhPcnF4V3dWUFNHS0VLYW5JZUM2YVNEbStLUmJvdklO?=
 =?utf-8?B?bmE5OHZzOEl4NFhXRkdPeXg5bWdKNzBoRm9vQk11eHNUR2UzSDErUm9QY1NQ?=
 =?utf-8?B?R3g4WkFpSWtTT3RWMWlGRDNZTG9lenpNWVZTTGQ3ZXN6Tm5jUEhrd2hDTGhk?=
 =?utf-8?B?U0VKcVBYRFUyU0JWNk5RUjc2Nk50aS9ZUkwvUWhGN2lBcEw1VzhCNkE0djQ1?=
 =?utf-8?B?YndnQXpEUE5jVGpQWElYaVI4TWM1MzRaeG9ibFZWaTNHRW9XbHJFNU83ejJZ?=
 =?utf-8?B?UXVlY0VtV1VXL0JCeC81SWhvN0hKcjFMR0pkdEhoUERGbGd3cGkwT3NuK3NX?=
 =?utf-8?B?RUQ3clNvb1lPL3pKenA1NW9kREo1VkhZbEs1YlNhbzlPaGpPeEN3SlBPd1VI?=
 =?utf-8?B?aXdYR0V5aFhGeXdhVWxUV0tZL2V0b0FwYjl1UDlkL1J2TXk5ZlVpQkZsZU9j?=
 =?utf-8?B?OEFyQVdvRlhUOElEZEtBa1RiU1RCdFpQUHJHaEk5bnhEUlJVcm9VUGJxTmxn?=
 =?utf-8?B?V0FjSG1CYVlWNTRrQ1JXVGlibytVT2hLZGpoQi8ycFAvb1lNZ292NVVpN0kv?=
 =?utf-8?B?YnVRbzJMQzBHblVncHJUb0p2c3FoQU1TdzNVOXU5Q1d2eXVQeU9GNmJ0M1F0?=
 =?utf-8?B?dFYzVmU5VFA2bVBpZzRCa3Z0UWFmODZhSDV3NVArQkxFUGdXV2VMb2t2YjY3?=
 =?utf-8?B?Z1lHenVaRDAvdWI2NkNaNUg3RjBSWUIyeHZwQVZGTGlpN3AyakRwSWtiYUVP?=
 =?utf-8?B?ZG9PcjZobkd0M3R4ZTZrN3dIZFI0UGVPWWgyU0MvRDBxVms1aklZcVAxcVd1?=
 =?utf-8?B?UjdPV3FUckJJbTZoUDhXbytpRHJ6bkJTdTdKYnRBN29UOFdYWmUwKzdXYy85?=
 =?utf-8?B?QUNZYmdCYm1zNEdOVHdqVE4xZno4Q0lvaU5TcmMwQm5rYS9zbEtQSTduSjU5?=
 =?utf-8?B?MjRHazBpM2xsR2QzYXhUVkFCV1lxTzR5WHNmS0swRGVZdEpyYVA2cGY1TzFU?=
 =?utf-8?B?QzRRQlVJbExlQ29nRFJNeCsxRzkyRi93aXVUYllpblV4anczZFhCYzRFaEJp?=
 =?utf-8?B?RVhzTFdVQWVkNlk5Z0FHRHM2SFF5alFhSW1Ja2taVGp6bzIwRDk3dSsxWDg0?=
 =?utf-8?B?czIyeHB3T3FhOWN2M2ZCakZGbzI2b0xaZkhYSlVlOUFjSG5BZzZKMU1ON0ZN?=
 =?utf-8?B?cnJvRTIrcFR6VFU5UW5sVFJxMFRjREN3Nkl0ZXdqUjNLWE9XaTZJa3FrdTFv?=
 =?utf-8?B?YWkyZnIvY2RpNXl3cDVQVm9BOUdaZmFxanZFdFBVbU9nZWZmRVllK01mK1Y1?=
 =?utf-8?B?Qnhqc2w4SDd0L0JRTmpsRlcvK1psNEV2OXZZUVQ2TlVadG5xK1U0ejVNN2xz?=
 =?utf-8?B?Ym5CTCtEeFJ4OU4raTZOMnBwM3dDYURZM09kcUdxNHRwTFdEVUgrZEIyOGFt?=
 =?utf-8?B?b2JUTW92aGdIS3ZxRC9aWU9CMVRuaXVRSThBN3l5RGtlREQvQ2xPWDM5M2s0?=
 =?utf-8?B?K01kdkpacURCeFhkc0FVYmRFV1lGTnl0QzBLNGJCOUQ2RmRGY0ZtY1Mrc1VH?=
 =?utf-8?B?ZVZhUEJoWGluaXJOUUc5NVJYSEhtYStLaU1wMkRhT3p1blBpRCthR0gvQStk?=
 =?utf-8?B?alRYV21jSllIdTRLQVR0RmhPWHUvWGRiN3U2STg4Z1orNXdMeFR3WW5TUEk2?=
 =?utf-8?B?YTF3SmdDeDVCK2JDNm5jaktxbVNYbC9mRzZoT2VmZFJBNkdHMlF4eDgyUWtL?=
 =?utf-8?B?Ni9VanhaaTNvYitRVDZqZzgvVk0zK2U3blp4c01NK3Y5VWplczY1aW5KbWtX?=
 =?utf-8?B?d3ZUNkZBYUwxSzYxL0wvK001Y21FTVJxeFVLZjBtdG8rK1BxU3hkVTdWUU9l?=
 =?utf-8?B?ckd0ODJ4d3p5TTZsa09YNTk2S3VuTDIrelNEd3NVRUovYzVrR1E4S0h1MDB4?=
 =?utf-8?Q?r/SIQjSGUp/iz8FrqYNmto8GK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acbfc95d-71d4-4823-ca40-08dd2079278b
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2024 22:04:48.4787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +RtRxU04rB68iC+32kfcltGKop4ETLnpTIucrle6HMu1UX6TAj2BFYHUOnx+9D+G33fXHwik61n1tLcpjwSKHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7801



On 12/18/2024 7:11 PM, Kalra, Ashish wrote:
> 
> On 12/18/2024 1:10 PM, Sean Christopherson wrote:
>> On Tue, Dec 17, 2024, Ashish Kalra wrote:
>>> On 12/17/2024 3:37 PM, Sean Christopherson wrote:
>>>> On Tue, Dec 17, 2024, Ashish Kalra wrote:
>>>>> On 12/17/2024 10:00 AM, Dionna Amalie Glaze wrote:
>>>>>> On Mon, Dec 16, 2024 at 3:57 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>>>>>>
>>>>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>>>
>>>>>>> The on-demand SEV initialization support requires a fix in QEMU to
>>>>>>> remove check for SEV initialization to be done prior to launching
>>>>>>> SEV/SEV-ES VMs.
>>>>>>> NOTE: With the above fix for QEMU, older QEMU versions will be broken
>>>>>>> with respect to launching SEV/SEV-ES VMs with the newer kernel/KVM as
>>>>>>> older QEMU versions require SEV initialization to be done before
>>>>>>> launching SEV/SEV-ES VMs.
>>>>>>>
>>>>>>
>>>>>> I don't think this is okay. I think you need to introduce a KVM
>>>>>> capability to switch over to the new way of initializing SEV VMs and
>>>>>> deprecate the old way so it doesn't need to be supported for any new
>>>>>> additions to the interface.
>>>>>>
>>>>>
>>>>> But that means KVM will need to support both mechanisms of doing SEV
>>>>> initialization - during KVM module load time and the deferred/lazy
>>>>> (on-demand) SEV INIT during VM launch.
>>>>
>>>> What's the QEMU change?  Dionna is right, we can't break userspace, but maybe
>>>> there's an alternative to supporting both models.
>>>
>>> Here is the QEMU fix : (makes a SEV PLATFORM STATUS firmware call via PSP
>>> driver ioctl to check if SEV is in INIT state)
>>>  
>>> diff --git a/target/i386/sev.c b/target/i386/sev.c
>>> index 1a4eb1ada6..4fa8665395 100644
>>> --- a/target/i386/sev.c
>>> +++ b/target/i386/sev.c
>>> @@ -1503,15 +1503,6 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>>>          }
>>>      }
>>>
>>> -    if (sev_es_enabled() && !sev_snp_enabled()) {
>>> -        if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
>>> -            error_setg(errp, "%s: guest policy requires SEV-ES, but "
>>> -                         "host SEV-ES support unavailable",
>>> -                         __func__);
>>> -            return -1;
>>> -        }
>>> -    }
>>
>> Aside from breaking userspace, removing a sanity check is not a "fix".
> 
> Actually this sanity check is not really required, if SEV INIT is not done before 
> launching a SEV/SEV-ES VM, then LAUNCH_START will fail with invalid platform state
> error as below:
> 
> ...
> qemu-system-x86_64: sev_launch_start: LAUNCH_START ret=1 fw_error=1 'Platform state is invalid'
> ...
> 
> So we can safely remove this check without causing a SEV/SEV-ES VM to blow up or something.
> 
>>
>> Can't we simply have the kernel do __sev_platform_init_locked() on-demand for
>> SEV_PLATFORM_STATUS?  The goal with lazy initialization is defer initialization
>> until it's necessary so that userspace can do firmware updates.  And it's quite
>> clearly necessary in this case, so...
> 
> I don't think we want to do that, probably want to return "raw" status back to userspace,
> if SEV INIT has not been done we probably need to return back that status, otherwise
> it may break some other userspace tool.
> 
> Now, looking at this qemu check we will always have issues launching SEV/SEV-ES VMs
> with SEV INIT on demand as this check enforces SEV INIT to be done before launching
> the VMs. And then this causes issues with SEV firmware hotloading as the check 
> enforces SEV INIT before launching VMs and once SEV INIT is done we can't do 
> firmware  hotloading.
> 
> But, i believe there is another alternative approach : 
> 
> - PSP driver can call SEV Shutdown right before calling DLFW_EX and then do
> a SEV INIT after successful DLFW_EX, in other words, we wrap DLFW_EX with 
> SEV_SHUTDOWN prior to it and SEV INIT post it. This approach will also allow
> us to do both SNP and SEV INIT at KVM module load time, there is no need to
> do SEV INIT lazily or on demand before SEV/SEV-ES VM launch.
> 
> This approach should work without any changes in qemu and also allow 
> SEV firmware hotloading without having any concerns about SEV INIT state.
> 

And to add here that SEV Shutdown will succeed with active SEV and SNP guests. 

SEV Shutdown (internally) marks all SEV asids as invalid and decommission all
SEV guests and does not affect SNP guests. 

So any active SEV guests will be implicitly shutdown and SNP guests will not be 
affected after SEV Shutdown right before doing SEV firmware hotloading and
calling DLFW_EX command. 

It should be fine to expect that there are no active SEV guests or any active
SEV guests will be shutdown as part of SEV firmware hotloading while keeping 
SNP guests running. 

Thanks,
Ashish

