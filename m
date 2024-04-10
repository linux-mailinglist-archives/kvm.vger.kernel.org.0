Return-Path: <kvm+bounces-14172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BED928A0352
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:28:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29BF41F24798
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 22:28:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2EC3190670;
	Wed, 10 Apr 2024 22:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ol9zF6j8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2090.outbound.protection.outlook.com [40.107.236.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BC3184119;
	Wed, 10 Apr 2024 22:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712788058; cv=fail; b=PcgERLcQ/GUCO99EksB2UCesTqwkNwmR44GOMxDjedZNf/GP5qvQyEIpLAFk8bmSyvNAvC68zus12mvvGjilG7C1IVZeKUZKJIBtYVw1nZJELHlEyd/UnOVV8uk8KjXBgdiVcbRNwTL4ycfxuUbGC1KaDE31nN2lgl4VQ50qVgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712788058; c=relaxed/simple;
	bh=Ca60QUxrNqJ8iQhICfg5JbaKQO/MO0L4IG7qX43Hor0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XGVH9o5AaSyqUsie9JbQL75aFMUWiRlCSlyQRollNJ9dVH8oGJJ2XnLZMjKxBGL1gKLSwJH2W010I4pY1O5+cA+mIhlnFGu8q+jxEBEUSEsRxBrPiB6i4fMGhYYZotBr9Hs0DoJSEotqEmetxh0uGBbxh7Z1jCNq4qOfcaQu1l0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ol9zF6j8; arc=fail smtp.client-ip=40.107.236.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8H3twUeSsF4/C3WuLbanKHvYNBScX5EfNL7am8HVNbABloFk4LWx2fJdRbwA/dfoPYBiBfl4BOYMj6e09nLN8f/MTyKXf5e5p7CJbQZhi1cmaCfmkZNfkzj6dQ7cU7ydAQ84la0V7+C5BwtwPwRl5VQogOPPNpOH/v4g1oByPLROeGGxA4m3YSgW1bUvbmZpoNtgvCjY9/kmvw3ZO6dP6ULZ4A5nM2qkXXS1rAurV2qlu+G2bLubE2iQRjVuhMb110YE2tvY/GM3gUkN4F23dbycbHRufCXVJ1kxn3ArP01GnDXuodJ/aSwByVHvvjhCBHP42Pmp/VjfOM3cEaqZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WexGFk06xrVYbL2+xke+5W+/6/DWshicySwm/UQwIdg=;
 b=etaOvjibSYNbIp/4mq+br2gTn4976TWRfs9L/Qm4+ZKuE5xNdu06ToF8OVRg9Cp+NtH4jFJBcFXUW069ikRUwA5EDJEZ7rFF76mTIaR+7BCeZczYDYE2WodTiKgJDYoAQPqTp49PsnoEDBsiOQHROoJ6zZN23fW+JOeG138SUZilC886PdYSxKFPD/8Qq4j6VSHopDG9eu3hJTEMctfdScpVXIVWFpEqJ7+atNWCzvy2BrzDLxyJARICOi49+hF6wx7cWJg1crLWCvfXglzN+76cp8rZqhR1VtHxsRFqNjrH8A8GV7jFYZ/TwcopQuu4oibdylpHpPpWIdNrZFnepw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WexGFk06xrVYbL2+xke+5W+/6/DWshicySwm/UQwIdg=;
 b=Ol9zF6j8010bISzA351eU/2jnNuwSla3/c+XAJ/+AUuqLMZYKoLk0mAdshO6ecvZNqRO3yVww1ZbfOnNOvnR9XH9RT5ulB5kvbWvW3B/+A7we6mYM41I+3x3UYwbEFvw6oO6f5fQP4x2vsL/KXbwth0K9rDInUs0uB9OGCaOfkM=
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by MW3PR12MB4379.namprd12.prod.outlook.com (2603:10b6:303:5e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Wed, 10 Apr
 2024 22:27:32 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508%6]) with mapi id 15.20.7409.042; Wed, 10 Apr 2024
 22:27:32 +0000
Message-ID: <5f8fbdae-6c43-e332-1ddf-daaac42f381c@amd.com>
Date: Wed, 10 Apr 2024 17:27:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v12 28/29] crypto: ccp: Add the
 SNP_{PAUSE,RESUME}_ATTESTATION commands
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
 <20240329225835.400662-29-michael.roth@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240329225835.400662-29-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0217.namprd04.prod.outlook.com
 (2603:10b6:806:127::12) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|MW3PR12MB4379:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7HHqcbelOae+9p74+8WI0X5BuaJSmYBu6mK9sAaUdHlJYFMuI+PbQBpA02AkgL4FqT+Ij2scRHuERalD2Eh6mH8wYXzLtSCcpuMIvcdrJ0YCK+wTQ3r2UpyCLvUhW/yHmDUOIcrjGKJSmquK4Jnldni7OVPVW8oz4rLeibWqD8GfO0hNaCbu3cpZJlbkPiMo4hNh5wG9r2dSP/TxXpwZPb/k/5DGTKmh5tc/dgpqPcPoATP9dHAtEFpwB6qsqpZtT/vYeMdotQrz6LUDZyZFGnab+FJT6zPrmZXH19kpD2ey3OYkvfET9MMORhaQ7DxRgejpC6Nj5J1qUiyyLA/SXVmJHEktCiRQJ04S6rQfXODiYC8ZUznwDwmuTSr12j/y76nNt1GlCTf9vkLCaN8LQ75Jux23IYPBofaleOVQB3ysFF/HBUi0SoI1ddhm6I/6X4KZ6QO3hHD9oFyHDbDDFaVtShKF+ncb6eLBicNajiwVwrU5Ogg3MVSv3wTT3oPHBmGGHDv7V/fIf/26nZJtcMH7DbMY9sqlOvz74G4CyFosTJn2qf1C+W2oXw7QLMgh2+SfOc0V4JB4LdXXNHZGmYT8BPvpHvTgYNGHEQ1daXpBoWvptnnyRdAF+ZIOgZjgtFP8fSEfml0qpXvW19czPL13vIzMHYsdTHIH1LQa6ng=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cU8ybGFNNGJ5YTRWeFhkbmlvRmtGQmF0TzRuZFpoUDZ5aDJ6dXhvWldIQmNJ?=
 =?utf-8?B?UkpmWHpyV3pQV0tyVHFFYnUzZGRtNmZGN0huTldnaUNaRmFKWlZKczZtc2wv?=
 =?utf-8?B?KzVVOXh4bGtWaTNqU3lONkZZektIWEZZdVVWeS9YUzBQbUhjTVZUZ0xHdXVz?=
 =?utf-8?B?ZDM4WEtta3JFUkh3U2pVN0s3WU5ISGxzdm1MSGlMNTI1eUlSOFFxQ2l4aEhD?=
 =?utf-8?B?MHlTTEZUY0tSWmtVcC9zZFhibEVwZXFqckpJOG5BTTU0UlFNNWt6ZlErdTB1?=
 =?utf-8?B?YXFGaVY4V0NSR1FvWjkwcGJBYUhKeGRFellSVmxOdEE2dGZuOU5ZY3BvMU9n?=
 =?utf-8?B?VjBUZUtIc3Jqa2k1UEFGZzc5TStHU25rbm93LytSN3N5VnZjdjZiZnZmV3pT?=
 =?utf-8?B?bFlEbE1BNDk5eFZKRzdrTkk5ekwvKzBMSVF0d0V2aW9TYWZ3cWQrUGdyOG94?=
 =?utf-8?B?b0s4anMzVmQrU2NNT21kcUVsK2ljTCtjby9MSGNTMk9qM3J2N0xTY1lQMktx?=
 =?utf-8?B?M0Vrby9QMTNJV1NCN1pEc0hNdzJDWUVvcis2aDVIU1YyaU9JUDRTMko3SS9D?=
 =?utf-8?B?amJXQVo1MFMrQVZtZ3NOT0l2bXQ2MW5IeWdWM292Z0QrOExxOTJvaWtBWUYr?=
 =?utf-8?B?L0FsMnNjOGh6cUIrc1ZscWNucHFLcFNXYTJDUThXdHViOURYZS9KOXZiNjZr?=
 =?utf-8?B?TzA0ZE8vL0VpSjBRalRlbWNWUTd0NnUwV0xYNWRza0lXNHdxRzlMeVBYcE9n?=
 =?utf-8?B?dndPSFNvZHBQcGNEWGFiMWRseDJDRDVQSEgrN1JNenF5b292SVNVS1o5V0ZC?=
 =?utf-8?B?Ukt1N1gyZGFvdWxvQWxIbW8xajhSVndZMWFvQytBZkYyY0JXSnNCV01Yd3RF?=
 =?utf-8?B?R0sxR0R4emFLL3hxMm4weE54NEs4WVdMRVdEa1B4eGxoajIwc3hBeU9kQndI?=
 =?utf-8?B?UjNSVXltK09EM0gzb01NNHJyNjZvcERxRWRuT1h2VksrQ1pleVVGVzgyVThn?=
 =?utf-8?B?MVh2M1ZTOXo2cHRRNE9IVkZoeWNoalRkTzMyL0RoMHIwSkg3WW8waHhvUkdj?=
 =?utf-8?B?YWx5VVl6b09RamFlODJvTHVPODNqS0tYYnBzSC83YnhkMFFZNldmeWxGMC9N?=
 =?utf-8?B?U2NaK3puNTZaaFcyQ3A2N1BsU09kb2QwN29hMkNBMjFyUCsvdENhK3BhQzRO?=
 =?utf-8?B?TVpOU282bzNjc29BS2FHQm0wazU0S3RRZnVlZHNEaWN3VjRpdjVHckNzazFp?=
 =?utf-8?B?NVV4eWt1T1JhLzE0SW9KWjhhVDVpYzF4ZXNPY3dTWlNEeHVwYXduaHBlRDRs?=
 =?utf-8?B?SzhrN1ZPREMyTmZabW15Q0xQaWtaQUdQNmJJOUtydW9UTjFzRkVWVXNqOEl0?=
 =?utf-8?B?R3NjSDBRRnUwdzljY0Y1RW9LeTFaa0N2bjFSM2VSOEhmNXB4dnBibndqQkFE?=
 =?utf-8?B?Z1F2WEJjTGo0OTZwOFFPbGwrWk9QL05LdG9GUEw2S05jRStxazllS09JdFhi?=
 =?utf-8?B?ZW4zenptb3A2ay84SGZ6WFV1YUtnRTJDeDczck0zdzhwMmE3Wm1NWHl2UHNS?=
 =?utf-8?B?SjVBVHRqY0ozNkNwZDNZTHJ2dTFOS25nbzhEZkVkSTV1QjloM01MczlXZ2xy?=
 =?utf-8?B?OGdSQUd5dEFSUmFOaDV2M0JSWGZPc3Bpc1hxZVdOS0JWQXdqR1hMQ0Q3bGhx?=
 =?utf-8?B?aW5scitrWUJZNG5NbE5BTHpTMEV1NXJyWWluUHI5NEVjOXZrMWRpdWF3UE9i?=
 =?utf-8?B?c3NPWk1vaUNlbm5MVUx2TTh1WVhsaW1RUkJxeVlwOGU5U0RRaUtRV291UkpV?=
 =?utf-8?B?RFBJRktRNzFJNG1qSmpXazZ5WGx1UVNQMHhSY0ErdUxzSXl4RVdFZHdQTmR3?=
 =?utf-8?B?bjZWMjdYVjlOZEtobnBjREpvTG05YlZVK0hMblpkS2JpdUtQbVZROWhJSFpw?=
 =?utf-8?B?dHZVS1Z5SDArb2RjSExyS0hMWjlGTnpISjRNQkRVSzdIUkhaYXFReGlMRWp6?=
 =?utf-8?B?TFNTcjN4WkZNNUxHaThxd2s2NXNRQUlJVFdMcDI1RnpheU5TUC8rZzE5Z2JT?=
 =?utf-8?B?MjBzQ3JQTGpqRjNVT0JUQk1lcUZrSksvYmkxWHVnQzlxZGxwd0o2K1JBcC9R?=
 =?utf-8?Q?zc0Hf4ouC35MRBxuAxrv+tUOd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43314198-f2d1-41aa-67d5-08dc59ad6a32
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2024 22:27:32.7127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PDqwEUhPnRGay1z/OELjzknHHLGBfUTdOfIZBEKPYjDnqvwIHb8Dgeq3FNs21so/Z73Z8Q26ufyo+YKnW+Z4WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4379

On 3/29/24 17:58, Michael Roth wrote:
> These commands can be used to pause servicing of guest attestation
> requests. This useful when updating the reported TCB or signing key with
> commands such as SNP_SET_CONFIG/SNP_COMMIT/SNP_VLEK_LOAD, since they may
> in turn require updates to userspace-supplied certificates, and if an
> attestation request happens to be in-flight at the time those updates
> are occurring there is potential for a guest to receive a certificate
> blob that is out of sync with the effective signing key for the
> attestation report.
> 
> These interfaces also provide some versatility with how similar
> firmware/certificate update activities can be handled in the future.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---


