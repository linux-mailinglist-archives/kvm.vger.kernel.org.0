Return-Path: <kvm+bounces-28301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 234C79973CC
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:53:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC723284206
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 17:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 725E31D318A;
	Wed,  9 Oct 2024 17:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fS2Dibui"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2063.outbound.protection.outlook.com [40.107.96.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C25E152E1C;
	Wed,  9 Oct 2024 17:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728496398; cv=fail; b=HjcW2kQh+f4G9W7SLtbVGGf37ufa7If0eWjOOV+E7+3PgGH/97nhLNWpv0hyesvsKR5+jsPxjHsuH2e+JtC6Dbh7qdoifdmn8Y+GqDJ6XM40HUdaviTHfLBDPeXfYgCiHqJ/q4m98R4O5e9kiPuEyr1OscUrqR8eINvdsaELYyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728496398; c=relaxed/simple;
	bh=ui0WIBoFuqmSPxXi78EuGUJVhvTMy596TiyzA7wrPsI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=L/Cka+ynqGcUotXJnZvqRwjj2yFmgaLrKHjiahXOoibWXqos7GPhvRnzuJmXi2wzdQmc4ymCY2GoW3zFNub+WnfqI6NYNgj59S2SeB+uTk3n+9O0tKcm+ejwnRBqPdSXUb9Bbggde64TDUcs/ihxwFXRFWVpgZ5B14TK6SPyWJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fS2Dibui; arc=fail smtp.client-ip=40.107.96.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a7gMIsqW2E/8K97TOKSuYj5Otr/HReIArRzzej7K6wA9u0NLer1eGO/ZfooMlbNG5Wbl3Jn1MWg+CnjXw6AVAt76I/WbzLf0Y4jxAKZANW2h+YyqVDJrg+M11Vg/pSu7vZ2v0tOV1CBwb8qgKFSlGhzH7hARw2t6eZXksi6twuRWialPsEQcHsflWXBoe1BaJPTtqqYT4vvL86aD3JxhQeldRBi494+ShKA5mfui/kJizJu4sXDZtlUruucRKXrIN+AD8yzYz8DeJYcs1snRrjhsfnmjebnC0MGQMQFRPYZxVtFpT2UITeNgOOazhDTjg93MbNr0l6gA3RCyd4PqXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdOrgSfcAZ2GbwE+j6S1DfF2YjsqcsVIbgE2AYhNNxw=;
 b=khHhtnTvGm/4eFI5wDrl5LFaGDsDCwcDn0vrmgUgmMmdq8R3L8/+b/QrNuo24dlf1RzyBsyhf7SQbY0IoeGBUp6KHWWtxN53A5iY2FJ8dCRtiAmI/KuCfmJb49GxGRQZnu7JHKLM1coUcxH0HS9AGZaQF0yjIfZWWO/IhAoGd5ndXd9+zLb89kR8tAJ9p8jmB5P9+QvJp2CBUuc1cYpqcLA4NpBXvmQllRqBLEp2XMvjDG4jD4hhi+f7jGuYDpY0i9Fspd1dmdYK+P4IcBeeBjL9NxNzKCUVIvg2LYj90Gpk8kJkCGg2SXzeTSk56BQdC+R0P49gZY9330IuQn0uUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdOrgSfcAZ2GbwE+j6S1DfF2YjsqcsVIbgE2AYhNNxw=;
 b=fS2DibuiXHWvGTqtRjw6iGuTMLv6OkFQQ+h/CkZ1DKTIzeKsOed5HtEWTlx42of8r6yav7kCNzKVThLM2tU+TVea3Em7ZZBFpPC0LK6PvXY+vyuxnVgIOMJIbLpWNd/H32jFHNxS/VpcnuGarpYFPav4UkvsndGEuKY9R0AmlYI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 CH3PR12MB8727.namprd12.prod.outlook.com (2603:10b6:610:173::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Wed, 9 Oct
 2024 17:53:10 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8026.024; Wed, 9 Oct 2024
 17:53:10 +0000
Message-ID: <e4568d3d-f115-4931-bbc6-9a32eb04ee1c@amd.com>
Date: Wed, 9 Oct 2024 23:22:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 02/14] x86/apic: Initialize Secure AVIC APIC backing page
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-3-Neeraj.Upadhyay@amd.com>
 <9b943722-c722-4a38-ab17-f07ef6d5c8c6@intel.com>
 <4298b9e1-b60f-4b1c-876d-7ac71ca14f70@amd.com>
 <2436d521-aa4c-45ac-9ccc-be9a4b5cb391@intel.com>
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <2436d521-aa4c-45ac-9ccc-be9a4b5cb391@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0246.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:21a::16) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|CH3PR12MB8727:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f56b949-34cf-44e0-d27b-08dce88b3cc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UXZNb3BRWUh5empLL2Z3QngydEtoOGYxcjkwMzZrSEYzSTQ0Zk8zMVZibGRD?=
 =?utf-8?B?TGw4RWFIZXNIdE96MnVUUnQ1MkdEckQ4dGN4cmFBdmNVbGZHa00xdExkQlhz?=
 =?utf-8?B?akRGNWRyZCtSQVdraHlZbXpZOEpiNTBKL1NFb052c2x3SE8xaC8zcUxnb1ps?=
 =?utf-8?B?ejcrZFcrNk11aVl5NENGRmh3OWhnVWpzRk4zMS84aDlLM3NtL3piOFE0Q2Ri?=
 =?utf-8?B?MXhMMGRHTnNla1pQTHFZU0pLb05YT09VMzBVM1plcWFROG1CVUtZMlkwRUVt?=
 =?utf-8?B?NXNFSVh1TFVHQzY1SElhbUlkQlBZU08zU0ppdTBHdU5IQ0loeHZyblRKVEpT?=
 =?utf-8?B?OHJzNkVOL1hPYlhzakpRSHNKWERXUW9RQ2ZIVEt4WVUxTU11MGtPOGJ4K0lR?=
 =?utf-8?B?cm9NY00ra0U5Wlh0Z0pMdDNlTTQ1VDZ5a3d5anNtaG10azBScjlNNUQvT3Za?=
 =?utf-8?B?cFhwdmsyclpwZ29veXU1OEdzSm4zUzk2bFFUVCtRdkNvb3E4MjBDN1FBSUJx?=
 =?utf-8?B?ZU9YOFFHNlIvREZLVDNzMWF1ZDNIQWV1QXhNaFN0UmxmQ2RGRldwT3BBRWpx?=
 =?utf-8?B?akJ3T1Y1dVIwWnBWSCtaQ2padWJ1V2VqY0MwbnZzTlNzbzNPYzZwU0RINkFG?=
 =?utf-8?B?bE9wQmU5TEZBY3EydzlUM1JIZktuWnlZczBKTnZJTGVza05DQklPSElEQ0Jw?=
 =?utf-8?B?Qis5dW5RczZtVlRNaG9RZXNoaytVWlg0a0p5VTgyYVJtUEFzWWp2SXVybjgz?=
 =?utf-8?B?dWdYN0pvRk1FalJsMUVkcmxQcnVoM3cybHhBczdHL2pEOXNjOUlTSXV1MDFq?=
 =?utf-8?B?blBvSXl4N3lSUzFNMEVTdnZyZnhOdDVBN1VkQXB0TEFYWkMwVHBtSlJWUVlV?=
 =?utf-8?B?Q3hjYXlzWmtlTTl5VlFpUFpUTGY0eFJMTlVrQ0xWTG0yNVFvVjNIRFcvSjVZ?=
 =?utf-8?B?S0ZzTUtLWnI2aHpJKzhaczZJN3Q2bER5WVduVE9ZKzkza01LRjBvQWZjRGt6?=
 =?utf-8?B?c0hPV3NKQWhYVmIyQUR6bFlUSExXRDF4L3RKaVdwQTM2NzgzTFhKUXJqc3k1?=
 =?utf-8?B?NUFaZkZOK1JkVlVLS0psZ3FEenpUQTJ1V3BpMkNGT0xzSlNXWlUxV2RhVEl5?=
 =?utf-8?B?SnZNMHZEQnJaaWUvRjdTcFRBTjRFSWNTelpCb0tDbUxLN2hMUFg0bWtGVTMv?=
 =?utf-8?B?ZUJDckNLMG9BOVdlbG1QV0xES05ybkNCcDlrSllJSHJEZmU5cjBsTGNDK1lx?=
 =?utf-8?B?NXNNT1krQUs5MEpBR3NlakU4cmwyU0FSMi9TQXIrMUVtbjRDcGNQSllVOUwy?=
 =?utf-8?B?ZjFmQmp1VVdSTEEram1XU244Y3l5eFg4SjZlOGFnRk94YUxEaWtpSGIyVFpW?=
 =?utf-8?B?RENuWmdra1ZiZWkrZUpRem1mbGZ0cUh6eVE4MUJmS2xUV1ZNQjZCTFBzMmMz?=
 =?utf-8?B?L043cnZ4U1h0MXY5R3ZxQU8xTEVuTnVEMFpCOTdkc3hFNldsR1F0ZVFtUGh3?=
 =?utf-8?B?TnJvUGRSY2tzRng0aVRkanRlNTF0Q3FVKzJHQ0wyUjZ1SW9HakRoUnNwa3Ju?=
 =?utf-8?B?VEM5bTlzZVJZNlNBdFZpVEFkaVpRMmNaSXFQcHAyMEZOZTBrM0pXR2ZSamhH?=
 =?utf-8?B?M3l2blFzZ2hyVGJieVlpc2VyUGtINmsrelppU3NjM25GM0RYV0gyVE9EQXM2?=
 =?utf-8?B?dXc2c0x0UHdzOFRIWFhqcDk4Y2RqTkZJdE1aVnUrM3YwalFmSFREemZnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2ZoYW8rSG1lT1VBRTBCOGpEd2RLQ05tRTdERnhvbGk1SkhueVhRMUM2TU9B?=
 =?utf-8?B?TzEwY0lpRTFscUJmS3VBV1Z1NkxXYWJ5b05yTW9kVVFGWndlK3UrWHEzY1dy?=
 =?utf-8?B?RXZBclM0WHhjOTRWcm5nU1lwQ214MFZ0M3l0SXFsYUc2cVNYWnpnbmJwMkU0?=
 =?utf-8?B?ZmhQMFg0cTBYWVcxWnFsOE9tVkxQTjM1T2FYb1dYbDVENGtMQjFnekhjL2tG?=
 =?utf-8?B?RmJ2VGgyOVRnWm1oRUF3bnpxSU93YksraUFqZnlKZFczblBzYU9CQ3pyRGRq?=
 =?utf-8?B?YmxqWFhqQk0zQWVuTTBWWGxzaEtrUVZBR2pkTTZweTlTbkF1N0lhRkRWWjZm?=
 =?utf-8?B?NzlNcFZOK0dBUWV4Mi9RM2d5TGZ2RWtxWXgzY2M0NXJ3cXorcUtMQm9NMDRM?=
 =?utf-8?B?eU5sSDVrOGZORVJVMEN6RXZFUHBjc1NWWndEVzZFcGJyekhhelA3dUZqYi9W?=
 =?utf-8?B?UDRjbGRBVW9Hc0ZQYzU3Q3BJNEtIYXJHN2J4TDhkNVVqRE9pcnpCT2xlbS84?=
 =?utf-8?B?YkovWm00cG1aempIL0VoQUowZDhXZ0RyRE9xRTN5UzhhUE9Cd2g3RXZtTlFV?=
 =?utf-8?B?WittUmUvT0NZOVdHSFlpL3VGQUZNQW5NWURaeVV5a2I1VWhHSVUyMjEyZlpI?=
 =?utf-8?B?YWZNTktNam5xbzQySFg0N1V5ZUxLS2tFYWo1RDZvaC84RWhtYm43NzJJZ1BH?=
 =?utf-8?B?NjAraFFyRzNyZHh1WHhyaTEzR250UkVoQnBFZytwMlN3QW9TQlRRNGF2ODB5?=
 =?utf-8?B?Q2oxVHNvNXNCODlzY1UvUEdtbHVPVTMySnZGU0prUjd3T1Z5aTI4ZnZ6NDVI?=
 =?utf-8?B?WkV5YTMxQjduUXhMWGFHODlSVWpGdExOY1RWb2s1eEJMZTg4WmlPcTZrWG40?=
 =?utf-8?B?QUM2OWoyY3NHNEFsWE5lcHRIUDFDZ1ptTytMdmZWZTNNbzAvQysxVTlpalph?=
 =?utf-8?B?a1R0NXA1c2V6ZGNaek9RcDRRaGxQbE4xTjN5SWxISHFkS2NqamtVamIzTG1a?=
 =?utf-8?B?dmtrWjFsdUVVN0lwWEJsMVAwZ2FRVjFuWDgzaFhLTG9mMkVpR3I4emNUVjFo?=
 =?utf-8?B?QnJvcEdDRXhCR1NBM05scDd1RzhOQ1FQNE5qV3RWSGppNmZwOWkyQmJwM3l4?=
 =?utf-8?B?d0VvOHNQVTJCcXhNQ3FWUmg5WVZPRXc1ZldDbHlsWThSaldHUjkvVmZlM3FJ?=
 =?utf-8?B?aW9wRVlPTVd2K1F3bUFKdTl0dXorN0NnRE9Sckd3NS9vTU1UTmxOUHZkdHh6?=
 =?utf-8?B?dkRUWnNBbXEwM0dPcTVaUmIwNWZwZDNmOEN6eHhJZHNBSnJGTHlCYUM5ekZ3?=
 =?utf-8?B?WjRWN2Jvdit1aEdZNUcvQmk2eENaem9KZkJVcnBGOUpVL3RXSjRUdDlGeUUx?=
 =?utf-8?B?WmR4Wmw0M2Vla2tqcks1bXRTTWcraDR6MmRvNFJ0S3RyYnV3am5uL21WVS90?=
 =?utf-8?B?ZEJuN3lnc0RRTTlFeDJPbWFtcXJMR2p1dXZodHNrYVJ3dWNmeUd5MlhDLzM2?=
 =?utf-8?B?aE5QM2JubkZhb2tMQ2pHVDY0R0dYbVE1YnlYblBIK25xL0ZtZmZ4aCtJUExz?=
 =?utf-8?B?R3ZOQSt3dlNMZlZWVG82cFk1Si9EZXlrMkpqczVGdnByRTE2QjFGSTYxaFpM?=
 =?utf-8?B?b1pCSTR5RmJjWXdwUWdkRTFPdGJ6eHd2WGlUMHBTU3kyakhSYm1HNE5jVzUv?=
 =?utf-8?B?dmpFVVRxWkh6OVhmOW9ScnNEZHRWNWxEclVQMnRvZzljcnFPUytSSGlmMjdB?=
 =?utf-8?B?WUlSMVp5MkJVNVpiSXNwZWVnY2RaTUNwZkVDdW9ucGxvNlI4WGV2bHdrMHFM?=
 =?utf-8?B?OE5hQXN2enc1U2FLOWdtckRQcnBVZEFZU29Db2tjM2ZWNXRDVjhPZzFmNWtm?=
 =?utf-8?B?a3phMlkzSUQ0VDErcVpUcERGVnU4WmltemZYZTBPL1JjS1hvRVB3QzI5RTVV?=
 =?utf-8?B?N3haQU1LZDVHc0I5NnpScTFBQXl3U05CQ1d4a2dveGNVTGdkT2J5Qk1yL25s?=
 =?utf-8?B?YkRFOXhWRVo3N1ExeWtaeFB4c05NN0YzUUNYOW9KcDBGbW1ONXgzOXJQUWFt?=
 =?utf-8?B?ME9iR2NDamNsUE5XUURvL2lIcXBwRWk2YzhSeXlpWFBEay9JTGtjZlhRTU9H?=
 =?utf-8?Q?AU81NRUioFtOi+RvWpJIB00TU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f56b949-34cf-44e0-d27b-08dce88b3cc0
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 17:53:10.0629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cBSKTgnCWrX/jo5dW5Ytjgh0hgVll9+hF2pDjEaZHDpCv6RzWsF/ZAg0dpVqeJa2O/i3/756IWhq/50lxBpQCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8727



On 10/9/2024 10:33 PM, Dave Hansen wrote:
> On 10/9/24 09:31, Neeraj Upadhyay wrote:
>>> Second, this looks to be allocating a potentially large physically
>>> contiguous chunk of memory, then handing it out 4k at a time.  The loop is:
>>>
>>> 	buf = alloc(NR_CPUS * PAGE_SIZE);
>>> 	for (i = 0; i < NR_CPUS; i++)
>>> 		foo[i] = buf + i * PAGE_SIZE;
>>>
>>> but could be:
>>>
>>> 	for (i = 0; i < NR_CPUS; i++)
>>> 		foo[i] = alloc(PAGE_SIZE);
>>>
>>> right?
>>
>> Single contiguous allocation is done here to avoid TLB impact due to backing page
>> accesses (e.g. sending ipi requires writing to target CPU's backing page).
>> I can change it to allocation in chunks of size 2M instead of one big allocation.
>> Is that fine? Also, as described in commit message, reserving entire 2M chunk
>> for backing pages also prevents splitting of NPT entries into individual 4K entries.
>> This can happen if part of a 2M page is not allocated for backing pages by guest
>> and page state change (from private to shared) is done for that part.
> 
> Ick.
> 
> First, this needs to be thoroughly commented, not in the changelogs.
> 

Ok.

> Second, this is premature optimization at its finest.  Just imagine if
> _every_ site that needed 16k or 32k of shared memory decided to allocate
> a 2M chunk for this _and_ used it sparsely.  What's the average number
> of vCPUs in a guest.  4?  8?
> 

Got it.

> The absolute minimum that we can do here is some stupid infrastructure
> that you call for allocating shared pages, or for things that _will_ be
> converted to shared so they get packed.
> 
> But hacking uncommented 2M allocations into every site seems like
> insanity to me.
> 
> IMNHO, you can either invest the time to put the infrastructure in place
> and get 2M pages, or you can live with the suboptimal performance of 4k.

I will start with 4K. For later, I will get the performance numbers to propose
a change in allocation scheme  - for ex, allocating a bigger contiguous
batch from the total allocation required for backing pages (num_possible_cpus() * 4K)
without doing 2M reservation.


- Neeraj




