Return-Path: <kvm+bounces-3794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 261BF808080
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 07:06:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC2B1B20E58
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 06:06:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FC9012B95;
	Thu,  7 Dec 2023 06:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lEZOSqEu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02421AD;
	Wed,  6 Dec 2023 22:06:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxuVeeveYIm8GNki25eh1lAHMs0keNIygni1KUrjIRD30Zc5RTbpY1Jew6jSqtOHjQznVuhx4DI6gRR6zBZQyVCdIue389Tj8gPu38lsxEV9Dbz41fRMb/03znTvEkcr2rudInt/3GX+ZECk3LX5Bq8HDFze+yC/BfhjfTEqU93/2ifNpqscxDxJsMfTFIROzm4HFn8BgrlZNboTdJMbpitU8hb9jnR6PS80WBhqwc88kmf/JoulpLrSH/mY/NfPL3IFaxduXDXcsnflL8kGbhGdNNl3JnM5NUEhZ9DRAfGRSqQIqeBL+g/z9LtxiufAWZld6U5flph9Y0Jo7mqIbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRKfZqTM5nNA2lVeFHu8ps5Of7rdnQMOLUvuWvkuRLM=;
 b=gudHAXTtEFfnq02Ag4Tbws9nqLbzqzkhf3lew19qGV7mCxol0F9TDFLhL951hO10qRbvaTpKbCpnRb//q344v//QRubmV0PZChauMt2h29nuzPNIAKvKLAOHB1GgcXNICiZq8IFSrlGvfQuWP3e+j28b/HfHllJjV/DTfNLwaYln9ju4KcAxiwJ/5AjSJHCFAM+LsTXSdXscuhsm6F7fVtNfDFclxFdRJyiZd2zsYHuZPxluq1+2XYl1M/EwmWhVCUX0zoSnA1Rb8pPMluHbpMFZg1zqamqTnuV2wn3MGq32vs8KioS5ovCOHQOHqB4ZeX4OzKzd09Fect/geXBudA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRKfZqTM5nNA2lVeFHu8ps5Of7rdnQMOLUvuWvkuRLM=;
 b=lEZOSqEuhFmWK/YR3LMord9pUm5KsEzjtB+lBF8F2xj2UWyu2pMEF4rWAELIBgBhrk73on0bgi76Y8B+S5LiuL3ZGt1cGnHa+ymKjmLaZXEGpg0Rytgvt0LL1d7EXf3ukhmhy8JvhsHCDH12NtSWTWhr7bgpgP6K7fWMju25tMM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SN7PR12MB8172.namprd12.prod.outlook.com (2603:10b6:806:352::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Thu, 7 Dec
 2023 06:06:29 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::d320:6e6c:d4c4:7fda]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::d320:6e6c:d4c4:7fda%3]) with mapi id 15.20.7068.027; Thu, 7 Dec 2023
 06:06:29 +0000
Message-ID: <c82cf4b8-fd4a-4288-b642-3a17e3f29579@amd.com>
Date: Thu, 7 Dec 2023 11:36:19 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v6 06/16] x86/sev: Cache the secrets page address
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20231128125959.1810039-1-nikunj@amd.com>
 <20231128125959.1810039-7-nikunj@amd.com>
 <CAAH4kHZ0fQJDiZaAhVQ31KXths5n3g1dYdfivyR-HEXcOFOY5g@mail.gmail.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <CAAH4kHZ0fQJDiZaAhVQ31KXths5n3g1dYdfivyR-HEXcOFOY5g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0009.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::17) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SN7PR12MB8172:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f6c5058-06ae-49fc-9f32-08dbf6eaa733
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pIfuMHrOXUi1f7ovr04zJWNQmYbAMpyZ3RV9vOQe7QhisvNtAv9JrWnGSSvDqk/RCxEF8lDFX78+Fn+veSg9NN9Ze+NfKvNUQd6fBKlCSQwrXSOAbxyG5h0te5U9EoGoJp2M6ETJ6AQkdOcxsrXB1oTAQkL+QM7+upUJQogzcgFvxOlHFykrilM4aA8a+ByTcZvElt4GaHA4dTob+W5OuRJmHTD7y0yMO8rV7mu1Dr+aZNUbVI4tyxOfgQD4ELr77//+n4lwzGbL8xPjCNNSXk3S1NlQR31HCmKPm/GaSSO+DR9wxAp9UO5Zk/lwQK4STqFklFINDVHexHeG4meFcMLFIJx1KUdDn2P8W/JFknZwlBOneJqNIPgohoeNIV636rBnr+88CsyaLUIPHoh8KR9ni8V4fAhXoiOoq8dEbY4H21vGnGc19Cq8daGChmIiuP9gPjyRsbbyPUgZKwKYOWH7+dC1tyLrMVUlluugN9rVriZWYRYEkk2hcy5DJLmLObakIXm6xyHHe81T+SZruB21gjSOhHRCVNBYsN4uR7kqVpQ/Rl32hkdChk5yuST0xM5864A8jwC6ntdO5lLzWMaFQAwpCn2klMstBgCpaRem1P+3yUKEp2o99cR1T23GDG3SZT8BloQpJryGBOl9uA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(366004)(376002)(346002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(3450700001)(4744005)(7416002)(31696002)(2906002)(316002)(36756003)(6916009)(66556008)(66476007)(66946007)(4326008)(8936002)(41300700001)(38100700002)(31686004)(5660300002)(83380400001)(478600001)(6486002)(26005)(8676002)(6666004)(6512007)(2616005)(6506007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RUwzWHJXdGxEQkJrSUJweWo0R1A4TmoxTTdrcnBKc094bEgwdkFRQnZzNUJh?=
 =?utf-8?B?ckQ3UWF3aUlRVXdHYjJNT3VRVzhtRmI1MWhsSGI0LzdFSk1PZ0xmdC9IUGw2?=
 =?utf-8?B?dXd3RkFEaW9OSG91VTRPUCtQeHRQWTY2VUtoM2FqaW1VOFJ3WFNJemw1SDBD?=
 =?utf-8?B?TTJNZzh6OEx6clUxSGE3b0lmSDZzaGlQVWVjS1EvR3lVelIzOElFUDdHeEtR?=
 =?utf-8?B?YlZIMjZ0T2VxWFlNMEwxWVNZb0tuWjQzSlJIOEtPOVpGR3Nzb1pvNkxEN3ND?=
 =?utf-8?B?YTgzYVkxODVPSlNNc2x2Rk5tWGMvWGsxTjliZ2o0b1YxdHE5WjZTd1AzdC9i?=
 =?utf-8?B?K3hvbWZJQlpOSlRFL3dFSDM5bitiZUYveUd0bEswSlpSbnNSN0lNSXR5TGNC?=
 =?utf-8?B?Mmg5UHF2WjJLQUthZGVGQi92SEd1eXJFNWJCR3h4bDBSQ1l6UnMvWkxqQjBG?=
 =?utf-8?B?ZnFwS1pGNGZMdGVpT3NmWDVXS29EbHZldjI4RkUzOTA4K1dETTVtMTJPMjN1?=
 =?utf-8?B?OENWcyszL09EK3dLVDRscWdnVjd2UEMrMStmR0VGSUNCR3pZTUJrZENwNkpF?=
 =?utf-8?B?cE9qdWMwSWh3ay8zNk1LeHJaMWFjazJZZjJEYjdFNlBueGdBVk9EWWJWKzEw?=
 =?utf-8?B?MXRRVElSdzYyRVI5OWJOMExvZEZXb3I4aXVKR01kVXdJYkR3REdXalB2OWRB?=
 =?utf-8?B?Q2F1N1puKy9LdVhNejdyU1lhQ1dYbnJtaWErNTBmOG5ESm5TNzNSc25Nb2Jm?=
 =?utf-8?B?UUlwbkQ0WWprSDhNc3EzbTRaRjlUeFdKYjJTT0h3dVltZ1lQbEpBWlFqMmMr?=
 =?utf-8?B?Y1M1RmZza3oxcUltUExFVEVGT0NiRWl0SUdzZzlST1VqZzhMNTFWd1M1aWVQ?=
 =?utf-8?B?MEJZVHdjQ0VvanJIZ2hINS9OQnZWVWZ0dThraXc1eU1yVjdJT21YUVRjM0Rq?=
 =?utf-8?B?Tk1NTEFkTWVUaVp4TXNrb1lqVWpNZjdCcUdPQVZEYlprSjNBNGI0UExLYzl4?=
 =?utf-8?B?ZHNMakpnMlBUaWVhY0FNc3g3TWtuWTIzTUVMaHUrL1U0ZUVnTXVrRk1uL251?=
 =?utf-8?B?Y1lvSG5OdHpWTmRnOG9hdndmTUxoYThqeCtLRDZqa0J3djlFZGlySEhjb1Uv?=
 =?utf-8?B?TU5VTVNOM2RjdW9FaVl2S09SMTV5V2ljMlRMeTI5MktyemZXMEM3OERoR1Fi?=
 =?utf-8?B?YnZrYlhuYXhmMmxqc3N1RnBSZ21xaEVqTCtDQVhHT1krMzlGckVoOW9DNnFS?=
 =?utf-8?B?ZjUvaFhmc0RmS1lpZjlMeTFVSXZOT0puMUFReUUvNUd2R2ptVk9Ja1JTYXdo?=
 =?utf-8?B?dGltbGhRaEtnZXQxZ0FETi9xU2FUVXRBL2hoamh3UmpqeGdncVdIUng1VEV0?=
 =?utf-8?B?STRQems5U0Z4ZllVbS9lb2ZkQzJKSG9uSHRmWDBnMWcvT2t0U05PK0FQRWNY?=
 =?utf-8?B?MzYrVnJISTZIVm1SRVpuR1dXeDRTUGVTT25ibXhLUi83eDJOM2daOEpwSWZi?=
 =?utf-8?B?KzZlMEZGTUVlSTh4K1g3OTdxWFhhYTV6bnlrbERyWjFicE81ZDNlNDNudTFB?=
 =?utf-8?B?R211c01lT2VEbit3dCtnZ0RiYUVCYzFHaEF6ZVdFVmg1YW5JdzNzOEFmZm8x?=
 =?utf-8?B?V0tiM09wWWk2cmZsNHh0MVhHZ1ZoeXJuWTlTNWdvRk53NmxTK09qSjFGZXpn?=
 =?utf-8?B?SUQ5Qm1RbG9vdUxiSk5tWnZlaTdsTTBHWGJhd3RNMkpOTnBBVnYrVVpXczhZ?=
 =?utf-8?B?SG04NkZQUkxqWS8xcFpqZXdRazlUZGZVUGtUankySFNQNm5qM0xNMmtnb2VV?=
 =?utf-8?B?bVVUTy9Jc0JXSFpIZXF4M1FKeGxNSlZ6SlYyTVVHSGNTOHZEQnN3UnA0NFdO?=
 =?utf-8?B?SEx3T0JOZzlGV2JqcGFuaURKMmFPN0ZKdG5EMjJ3UDJEMHYwUXJWYzlWcnlT?=
 =?utf-8?B?UERiY2RBNUttU0FVT0RtYkdwNHNaU2RjWU9BODV4bUJOQlpqZ0NkSUFWVjhD?=
 =?utf-8?B?U2pTR3ZHelVqc2MyVWNWOWpuUUFWUGVPYk5mUnlBOFlYRDZidGh0QTZkangy?=
 =?utf-8?B?RmI2TmNSRlozcjZ2WWJ3YXBjeXhUZVViOFhXbUJMc2oxcnZFajEvbDRIcGtX?=
 =?utf-8?Q?DX8IieSUwS2ls7EUA8fnYShWU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f6c5058-06ae-49fc-9f32-08dbf6eaa733
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2023 06:06:29.4551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tUK74Pe5QDWL7GPtc3Lsm/TMjpvMKuA/uCNVfaR4rRTYzccT1AvidmkPyVQfNRjNCii96vZegGY1hPI6uz1q5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8172

On 12/7/2023 3:51 AM, Dionna Amalie Glaze wrote:
>>
>> +static void __init set_secrets_pa(const struct cc_blob_sev_info *cc_info)
>> +{
>> +       if (cc_info && cc_info->secrets_phys && cc_info->secrets_len == PAGE_SIZE)
>> +               secrets_pa = cc_info->secrets_phys;
>> +}
> 
> I know failure leads to an -ENODEV later on init_platform, but a
> missing secrets page as a symptom seems like a good thing to log,
> right?

Added in the next patch.

+	if (!secrets_pa) {
+		pr_err("SNP secrets page not found\n");
 		return -ENODEV;
+	}

> 
>> -       if (!gpa)
>> +       if (!secrets_pa)
>>                 return -ENODEV;
>>
> 
> 

Regards
Nikunj

