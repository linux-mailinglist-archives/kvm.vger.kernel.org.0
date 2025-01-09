Return-Path: <kvm+bounces-34866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7211A06E4E
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 07:32:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48FF01888718
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 06:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC9321421B;
	Thu,  9 Jan 2025 06:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RQk2TX5U"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29662AF11;
	Thu,  9 Jan 2025 06:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736404349; cv=fail; b=CKEWJclNKj+rbOQthc6YXLyXfHrd9azbDfHMiQTn64lIA4GeOHsUkmjhEpRvbraai0bEByaLiwZlAUu/Ce0yckCjFRNutF7iBQcTKBTGbwtPMsLMYziZBXrT/q4Cr+WLx8QYuSKmAQcO7/foGi4k4HysKNJwzLWo3tIlaaRCRV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736404349; c=relaxed/simple;
	bh=gmsa64LmBqeLSHzERNoWJ6V1WwerDxQbkbD7E7khBFE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PfuIC3VQ1+b52hFJTApdXvwL7KaAv4quFaRlQilVpZuD9dsmw2sdOG54iHanodRT/0iR/VlWqtF6P0af++43ECZeTRypwkeDHr3YdCMtS/M8WCGU8hKD+sAJhIJ9kvLMhVbEo5dTEJHf3cx7TYf4cWZBjhAdkBlwXYX9LZ91BcQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RQk2TX5U; arc=fail smtp.client-ip=40.107.94.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vZCgvRhAtVynKugNHS4ff+NwYtKFY8KZZaxxF0/7t8T/qtKMZD7Q7xqxVz9nzGFrgURiPZn9MjLXSLrpUDT2GxkZ2MRNA8TJRx4MCkOH41b8wfNWUZEEFghTrcLZgwqxco/zHSjjCGoqoFUpfZC7qZc2HxhmUUOuc54DVmYZLujVTd1QV1SxB5Ha7R3d6mYS1ddU1LHjZLxuzM6FgEvPjlgRNWGu6Tx9HMNSW1VUIa/mjCH/rZ3iGSzrW9t21vamjqXRESNMW0Qai4aT1gKq41PlcgAGyon5MnsJ6xoXKiQtuEt0baxwaZ8yAdkzAT1b5pNSLF5j2AMHNnOimUivwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6om25eoXIFlhpnBTcBl95EQav2l2IsXubQDC7P8SqTc=;
 b=CT72LNUm7gKde4eNHokGnc9CnyXQiiFwB3VBc7Da9WLEUckBEMbBUGEWcgq8S3tmCizCWIX0qT1jtIBMrLhNRPR8duZA2a1Wm81RsO+x2MDYLiDC3q7LywvkiBcj3uX9KLHiV4NZyfZdiA7zXN0pjem1xC94fREmsb3buKCA8MMyRugYUdi+LOnXh/2HpP6doLW+ugtFMrWhFtHC1HHIe94Fh/eTSg55m9AlXcoM0twSIWV0ThTF9/M4Q4bL6nON1WeBIjoRxiwzuIfVKDNdZBICCRbl35c7JSUbsgiL2AwZQYAMjJ8OldzG6ayg661Kzjw+INyBM/MI/z/VtCTsMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6om25eoXIFlhpnBTcBl95EQav2l2IsXubQDC7P8SqTc=;
 b=RQk2TX5UE9HR4wlQaSwUpwblvsMiEsE2pIna6a9lvvWMK/eTNfCw1hWlfRfdvu69Doa5T1rJfG4U5VeCrh0KFFQTP18EXhjycmKFbWQSKaM4TfwV3CfXD83nPU2F2/ZMu31TekJNVD3dqL40ZoYPH9Wn1x/YqYj7VtxXdXjhFXg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB6978.namprd12.prod.outlook.com (2603:10b6:510:1b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Thu, 9 Jan
 2025 06:32:25 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8335.011; Thu, 9 Jan 2025
 06:32:25 +0000
Message-ID: <4ab9dc76-4556-4a96-be0d-2c8ee942b113@amd.com>
Date: Thu, 9 Jan 2025 12:02:14 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 12/13] x86/tsc: Switch to native sched clock
To: Sean Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com,
 francescolavra.fl@gmail.com, Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-13-nikunj@amd.com>
 <20250107193752.GHZ32CkNhBJkx45Ug4@fat_crate.local>
 <3acfbef7-8786-4033-ab99-a97e971f5bd9@amd.com>
 <20250108082221.GBZ341vUyxrBPHgTg3@fat_crate.local>
 <4b68ee6e-a6b2-4d41-b58f-edcceae3c689@amd.com>
 <cd6c18f3-538a-494e-9e60-2caedb1f53c2@amd.com> <Z36FG1nfiT5kKsBr@google.com>
 <20250108153420.GEZ36a_IqnzlHpmh6K@fat_crate.local>
 <Z36vqqTgrZp5Y3ab@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <Z36vqqTgrZp5Y3ab@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0064.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::21) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB6978:EE_
X-MS-Office365-Filtering-Correlation-Id: 718c86d5-cded-47a3-e547-08dd3077614a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZlR1YzRQTjFBdi8xY0lpWkkzTlQrMTk3RnpwaTMwNWNMOTRVUHcvM1RHeWVY?=
 =?utf-8?B?RlVUUDRKZHd6WEEyVis2SHV6VC9tc2dpeWttaStjNjhTN3dSL1d0SVVwZ2tD?=
 =?utf-8?B?ZjR6WkROVVBNckxEV3pSK2FweXZtb1Zjek9BR2RBeDcwVnlaSmQ0azVhQmpH?=
 =?utf-8?B?dnVrUWRPQW0xNGJTVXRVWDUyRC8wejFkVFRCOWlHTUR2YUVUb0dDQUFweTg5?=
 =?utf-8?B?UUZ3cGxtOVNvSkI1U3l2cTk2MUJ3VzViUHRRRm16R3JPaDg4MExWWkVnMTdR?=
 =?utf-8?B?bk1meXZvVGduVmJ5QXpLRmlJVnZXS2dwbllxR0Mxdm1WUTZQcjBya3I4aEFo?=
 =?utf-8?B?bXBITHBvVzM4SXNKNXAybC9lRlJLeTBvYzc0L040Q0o3akRzcDUwZEwyZTNH?=
 =?utf-8?B?UDZpVk9aajdoOXNiYmk1VU9hSTVlc2JkVmxmZEc2NWdrRkx4WUVxTVdIcFNC?=
 =?utf-8?B?QnorOENZdlc0TTdmUUdKdUhZcUVXSytnSnFha3JvRTZQL3B4R1Z3THJrQjVT?=
 =?utf-8?B?bXl4TlFiM2VaSmFPYWVKRVJOVWkvd1VRTDlBZmtZQUZVMGZvaFpVTjRJYlNR?=
 =?utf-8?B?V1dtUlR0alMrN0pnTmxtMDFYL25jaFNoNEsyREVnVnhkN2dvWTVjTVNEWHlV?=
 =?utf-8?B?TzhUL2cvZWZ4ZHhCeTZTMlZOdzlzbXVJYmNYTFZJTC9OZE9vK0l1VDFKU3hK?=
 =?utf-8?B?U0lTbjlJSnJtbGUxTll1WVNEWVNnYWM1WnRjRTVsTk44NFlHTUd2clUxaTlX?=
 =?utf-8?B?dFh4Z0w5b0M4SW5GeTcyYVNyQjdXVzZrSGZSYVZiUysvVEJpZ0Jyd3NNamR6?=
 =?utf-8?B?Qmx4ZXYvV05sZ0MxWGViUFBEY0pCbVkrbHA0S1pJZjlnRHBwZTFBRDYxcDVJ?=
 =?utf-8?B?ZVBuNmcrTXgzVFBtQjRYL2YwWmpqc056WnhmemRycVY4bVdyR0J6WDNFU1Uv?=
 =?utf-8?B?ajVETVhrZVJucUhBWHZtWFllNHNFSXlHTTVFV2tkS29FbFoxNDY2cTUweDBC?=
 =?utf-8?B?MmMwdEJYa0pHQWtTSVluelRWYWpWeEVxLzhORDBqVHhSQW04ZEw5QnpXeHo4?=
 =?utf-8?B?UE9ibUh4L09JdXdUcTdMRDR2NU5kS0Y2Yng1ZElHemtaaHdSQkxpY2FMSGlZ?=
 =?utf-8?B?cUF2TkVRKzFneG5sYVFjTmRGZ1ZLVm55c1FZdENaNWRvbDlIc1ZhTHVrdHB6?=
 =?utf-8?B?WDdPK3Y1ZW4vSXZGS09YOWJoTGV6bWRiQkVhdTc4bCtiUEVwOFZuNVpNSHR0?=
 =?utf-8?B?cGlOVDNIYXdNUU4wYlAvbVR2VHB1eGpkTTRQSkhoUkJqbTlPNGtqQ1hWbmxu?=
 =?utf-8?B?Wk5XTnJPWlZ5STFtT2lDbFlwcE1lRmptbG9CR2pRNWs5cXJld1BQMEN1RzZ5?=
 =?utf-8?B?V2ZNcTlEL050STQvaGUrdVVma2cvSjJPdHNFVEtJcml1Y3A3bUhSa2xlbERV?=
 =?utf-8?B?ZGtKSjRTZFlYUUZZTnNqMERTRCszRmlpMzE3Wk9JcXRvaGRDTWxyd2g4ZFY0?=
 =?utf-8?B?aXRrSFptQ2dqRE9RZlpMd0xRRTZINk1QZlUrKzA0SlFuVUNIQThNMG9KeTlS?=
 =?utf-8?B?RXVoTnFTQkQzVjJLWHgxeVRHZFM1L3Qwa3RMdFlrbTQ3TGlSYWU5dHNRaGxJ?=
 =?utf-8?B?NndraXpLRzZMRU5RVC9sVFZSM0dlK042NXpPUjdTSE1aR0JWM3cyTW5yUVNU?=
 =?utf-8?B?RFIwRFNhSWtoYWVwNkpsdkxYUXp6NytkM2YzT1ZXKzlGckN3OUN2bG54VmlZ?=
 =?utf-8?B?cjExekpHOXhVVExuNGdVS3JRaWtHVFEwK2FQUlp6RGVZZ1lFYkI4b1EwNk5j?=
 =?utf-8?B?U1dJV2dTaE9LaHdhdGFmdGRSMXViV01iSmxLN2lYWFpjdXA5K3hPWjMvWVNy?=
 =?utf-8?B?UkYrajlhcyt2SHhLTGloV1Yrc1UrNDNHMWN5T2czV0srM1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWZKdWZidE4zSXdGRlpjT2dERzgxekpZZzgya0VUcnR5Nk51NUhXRVB6Nm43?=
 =?utf-8?B?UHFoa0ZJZkVPaSsvRXBuVmF4Y3JIZXAyRVdJNmRiZkc4SWpNRzdhR2JBQ2xj?=
 =?utf-8?B?ZEI0Vkw2UFZzMUZKQTdEN25OeXViYm9NVmdVUm9mck5obTNVYkFYS2R4Nm5q?=
 =?utf-8?B?TG5XQXFPSXlobkRXTzNSSFlnNWM3TFVaU3UvR1RXczVkSGhSMXNTV29YVUw5?=
 =?utf-8?B?SitHY0hlZlhJVEZrVXN4ckNzdWVEMkZkNCt4eVlTZEZNT3laL1BMZ0V3bmtw?=
 =?utf-8?B?TFJMV3dSODc1L3FVUHh3VTRqK0pLTytDRE05d3hpdHdhMWZyUU5rZ3JyYXl2?=
 =?utf-8?B?eTR0ZTNnakNpN3h5OHNZVndoM01ET2dNTjhiVXh5dXNrWUIzMGk4YVZ5Uyt6?=
 =?utf-8?B?dXI1YklIYUhNWjgwVEEzcmFTeDQ5MzZ6RFJCNmRHK2hnMXp6QksyYkVNTlp6?=
 =?utf-8?B?a285QW9ZUWtlODk5aFUzMUc3enphK1FrSEp2enk5MkJSWGovcjNNeDFJZ0NX?=
 =?utf-8?B?S3dNU2pFZE1oaGZZb1JZaXV4aitWOGZDQzd0cVpnQkt3Y3hEMkcxZWRSYkFp?=
 =?utf-8?B?WWg1OE9oRTR4ajZxTFZUZ2d4MUlIT0krNW5FN1JwQWxaemhGV1B6aXVhOGlt?=
 =?utf-8?B?Y25NYlpEaTFoMXUxY2JjdjNDWHJVSTRRNURGS2kzTTIwYXNvVlI0T2U0QnNp?=
 =?utf-8?B?Z05GbzVGQXNUMnFqUTZLelN4cW5XWlZkR3FpRnJPSDg3ZEpZL3pWb05KS2gz?=
 =?utf-8?B?SWFVZzk0RWZXdWg3bXNjRS9LMnpzdlh6WlFvVWFCMS9ha0NPbDVoS3BCOGxz?=
 =?utf-8?B?VXFlRTF2ZzFTSE5pZmVNQnVVU3F2REtWNE5JdlQwdjdUSlNhajRkaXJPOGc3?=
 =?utf-8?B?TUhsMGRiR0JwODd0S2xxVy9GKzR1MDFIYnVTazd2L0kxT3FKK0htckVaNkhs?=
 =?utf-8?B?c1FndGtuTzlSRVB4VEZJdFB5V09hblhJeEJmbHJyNjR3dnFmMTJiL1p3emUw?=
 =?utf-8?B?YXlCQ3M1ck5GNXFkeUlHcmJXMlU5Q0o0enpLa2tZMDRRUGlmWHh2cXVaUFBF?=
 =?utf-8?B?Tm8zZDNwQlBxaGdIelZ1dEJIOVNMYWxOVVJ4SWtYdjBwN0ZHRDNmRFZnN2VY?=
 =?utf-8?B?MWx3MFN3RHA1M0JqKzRvMkxLelBMS1dtL1hmYmR4UUNkSXBHeUhDMElZeER3?=
 =?utf-8?B?ZzVQRU1Ea0pUU2NOSWJ3K0lkOVNpUlFYV3hNTXFCR2xkeWQ0K2VmZXlYOGRs?=
 =?utf-8?B?NXhpSHpXL1dmN0VhZjN5eit6bS9SM2RXRVIxQ3I3UElvUUcwSkROZi9oajRq?=
 =?utf-8?B?Wi9maEZ4SC90eE5icUZIckMyN25IZ2JmR2VYc2xFUUxjVUNoQmVSZ3dwTUpW?=
 =?utf-8?B?NW9HbElvRW9sTXk4SGNGT2tpQkdYbVloazRnd1VtR1hTU0o0MjVOS2E0c3I5?=
 =?utf-8?B?SjhUL1MxOEg1RUQyUnpidWdqY09Lb0NOd3RuMTNzaXEwdU5lQjVyL28yS1J3?=
 =?utf-8?B?SE9oRWE5T0Y5WW5EUEtpYjl2Q1VXZHhqZlZHTGZSMDQ2REo1WmV2MlAyRi9G?=
 =?utf-8?B?QytJd2hwcGlmQTJ4ODJjWjQ1Nk1SRGQzeGsreGlsMUNKNGtwQ3pFZXllcWNW?=
 =?utf-8?B?R2lXVzlCMVBCV3U4VU5TQmZ4Mnhac24yWmlJL3FOajJyMlRWYTdtR3llS2RE?=
 =?utf-8?B?aVN1V1FuZ3lBZDQ4UENBeXFEbElYQnVIVklxRExGb2tTc3J6VXk1b1o0eTJR?=
 =?utf-8?B?N0lYQ1B6RHdEYThBMXgzMHdqT1AzR2FOQU10YWM0dnpDeE8xaUZvclNud3pm?=
 =?utf-8?B?UGVjaUljemVFQkhlcDdiUnRTM3lsMDliVEs2M21Lc0s2c0ZHS0sxNWF4Rll3?=
 =?utf-8?B?RkN4SVdCeWdoUnNxbWFTemZBLytobjlhbTMzNEFMbE1sMXNKRGV1OVV4L1gr?=
 =?utf-8?B?bGt6NEk0UGI3anc3QXVKeWRPZkkwOGVYeFhFeXYrUXp4T25pQ3pFKy9sRGVu?=
 =?utf-8?B?MVJGZ0Z2UkRYQktwTmJmcDlKemloK3hMUFFwZ3VIendzWVBEdWt6R1FtMk4w?=
 =?utf-8?B?K2U2emQyVXZJQ1ZEZExZNWtwWmxqeDNHQlM4NEtjVzNDMzE1SEIvaG1CMVZm?=
 =?utf-8?Q?MJXsjS3v2D6P31fCCIEUfUGtF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 718c86d5-cded-47a3-e547-08dd3077614a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 06:32:25.1703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7QPrxVhX07anTNQtS1aSJY3i6HpdBXfibGaHvkDC/d245cMuLuVUjRxzCqFcq2WsDxju2tstflWM2cUYoYQS8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6978



On 1/8/2025 10:32 PM, Sean Christopherson wrote:
> On Wed, Jan 08, 2025, Borislav Petkov wrote:
>> On Wed, Jan 08, 2025 at 06:00:59AM -0800, Sean Christopherson wrote:

> For TDX guests, the TSC is _always_ "secure".  So similar to singling out kvmclock,
> handling SNP's STSC but not the TDX case again leaves the kernel in an inconsistent
> state.  Which is why I originally suggested[*] fixing the sched_clock mess in a
> generically; 
> doing so would avoid the need to special case SNP or TDX in code> that doesn't/shouldn't care about SNP or TDX.

That is what I have attempted in this patch[1] where irrespective of SNP/TDX, whenever
TSC is picked up as a clock source, sched-clock will start using TSC instead of any
PV sched clock. This does not have any special case for STSC/SNP/TDX. 

> [*] https://lore.kernel.org/all/ZurCbP7MesWXQbqZ@google.com

Regards
Nikunj

1. https://lore.kernel.org/kvm/20250106124633.1418972-13-nikunj@amd.com/


