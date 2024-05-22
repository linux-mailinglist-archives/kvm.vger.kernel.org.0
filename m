Return-Path: <kvm+bounces-17924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E21338CBB06
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 08:12:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D9831F225E7
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 06:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 610EB78B4E;
	Wed, 22 May 2024 06:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QwrUg0t0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C981C6B4;
	Wed, 22 May 2024 06:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716358336; cv=fail; b=tZlBLanGfTZsSuvBkRIeoKGDNYV37SPcNlQSA6eiRX08pFgqO+ADw1axs+8GW2MpgIvnOwStfPAcMrRStPFOEVThnRmGkn2pP8bT/RUllyCNKb2gQTfzQ2IOZpSPXeFoCfHXgHM8aVrMoWlk0g2mYWVmo6ggJDendcS5+5m+x5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716358336; c=relaxed/simple;
	bh=zGuSVw3mYcG8TfxLU0bsgM4WkeklL67AZMF1aBJUQSo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kTqoChabe1Oc/NJRy3XjKRnI733uZ+V2FR6eXwgFmv5ZKeBcl7F2Jd8u4x8ErCXNl5l4jLSBaLn/AyGH+gl/z6VRnoKRsnd4jgjlLPqmDd/bNdjSG9ZBmj6wuY/DRlx22l3DX+nqrFtQlFWlU1Rv6JiVjYVQRyaG8Nc8S2pI+WU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QwrUg0t0; arc=fail smtp.client-ip=40.107.244.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UILAYXHkkkPT84Bw7egzgeZrOwv9buplKWTPqdhlk6HCAQuSuMUqdZmqRFcyqDM48LXXBYPoFmYey8xxY22d7tHFEl3XwYKqZIxEwrZGaXMpwW4WaGz0IpaCZLKDOGUOrJEEMRTDMd9mq0/b1GRNdg8NQG7aPGHg3aMKqDz5CN00WbliNUTM5WdrtnFy20AlQnM3OmbVSExNFT1/HqK00Yo3yY3s2C394g4U2ZQ1JUppXrERdUXO4rdTB5/sFDZO828pB1apT1BltDxqmv8IWb+m5pkjJbtu1Qc+hwIKfBUb/QQ9vGe+QOtyAnf9PNtpWuWdMWXDsqyNeWPHuH3yZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cx6BMfu8SDxWDdjuyMxw2BRfJk0iUUTNlbdnhCWXidE=;
 b=WN90FfeLRgt9QZIWAXFbC4VC+zgOuP04tlszbYryetd2OLrL348EfofFfPKjJIZE1B9sZhwTTGPCCy5WIQS0DdHIS9MHiq5iDchRGpkJD67VHQtuW9pbFgeXCWzjR9vMrGb5QvROqvWV+6OQJVhnUoF/Y8mjxgFiDhv2Y3Kgvu2Cnfvrjyv0xQ0PVnkiYkfEuomxDJvAqgwsfYfPgDlOdXhlH1SaxsnePoUAo98E3z+g2T1Yq5aIdL4C6OoPwdWgoa1QYxHtWEJpBMcL4ir6xJGatU8QU1KR/4Wt1szGxdpmGY1UBXy5jVkG8wH5A+CdqN9p8voPnG5kMqdLpRxkyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cx6BMfu8SDxWDdjuyMxw2BRfJk0iUUTNlbdnhCWXidE=;
 b=QwrUg0t0OJGqRhjLA77Yt8hjT2lB5gLf8sbwVnmdkalkqiRx91XVSSLI7ubF+ovSfDGC+IoSVJ1bbCeSCO7Ocj+PsW/GeNylfSsvTPG/FN3+EUPIEHmSLle5Nu71hAmbqq4b8+Msql2XGwlqL/0JqDqge+ddnDAAmsRHaWjZCAE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by CY5PR12MB6177.namprd12.prod.outlook.com (2603:10b6:930:26::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Wed, 22 May
 2024 06:12:13 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%6]) with mapi id 15.20.7587.035; Wed, 22 May 2024
 06:12:13 +0000
Message-ID: <9dd51971-9df1-48ce-8e64-b2600a7b0467@amd.com>
Date: Wed, 22 May 2024 11:42:02 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: SEV-ES: Don't intercept MSR_IA32_DEBUGCTLMSR for
 SEV-ES guests
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: thomas.lendacky@amd.com, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, santosh.shukla@amd.com, ravi.bangoria@amd.com
References: <20240416050338.517-1-ravi.bangoria@amd.com>
 <ZjQnFO9Pf4OLZdLU@google.com> <9252b68e-2b6a-6173-2e13-20154903097d@amd.com>
 <Zjp8AIorXJ-TEZP0@google.com> <305b84aa-3897-40f4-873b-dc512a2da61f@amd.com>
 <ZkdqW8JGCrUUO3RA@google.com> <b66ea07a-f57e-014c-68b4-729f893c2fbd@amd.com>
 <Zk0ErRQt3XH7xK6O@google.com>
 <CABgObfaXAERePMQrrpWg8PqM1TOq8TJT65i3WgU0n0-vePDGNg@mail.gmail.com>
 <Zk0elnvnF0n_exKt@google.com>
Content-Language: en-US
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <Zk0elnvnF0n_exKt@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0127.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::17) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|CY5PR12MB6177:EE_
X-MS-Office365-Filtering-Correlation-Id: 1847cdd7-b2de-4fee-ce37-08dc7a261eef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015|7416005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UFkwODVYNld4aDN4M3ppQi9xd093ZWNuTU9IdTk2enVWekhJVkdZcjBNelBJ?=
 =?utf-8?B?K1pQbG81ck9zaC9iTERZeHlmZFVTRW03L0hTZDlTYUN4N2Zyam04ckR1Z2c3?=
 =?utf-8?B?Ym11bjUyQXZ4bzM5dTROeW5RbC90V09yVU00ZXIxR3AzejZ0bHdlM2JzTWFa?=
 =?utf-8?B?azRjN1Q4b3JLT0txY2JDSTVYOGlIMUFjeVNOSkloUHZURXgrTEpVSHJCY0VL?=
 =?utf-8?B?Qzk4M2M3MlFEbFpxVXk2eE5vZnF2V3c3VlptQVNuNmRFQm8waWw4SnptQlI4?=
 =?utf-8?B?Tks4NndoUGpRekZsUm5SU1VMUFE4NFczZjJoVy8xSC9qVGN2QXpieitVWFVm?=
 =?utf-8?B?UHdqZXRPbGREMkFQb3ozblU5Sk1hRnd0Q0V3cFBISXNpakZWN2JNa010S212?=
 =?utf-8?B?Zi9VRGpKYnRpOERITk9JR2JRN1dudDRZekxNKzQ2c0tTd3dFRVVGNGtTVDBp?=
 =?utf-8?B?cWNmQTY1VU42RnZ6OTFEVTFidE0rUitaSnlGMTJjZmdvYnZSV3FTRWo2RDFB?=
 =?utf-8?B?NWwyKy9OczdRV1ZGaFowOXl5MUpKU2Zhb1BPVWE5MlptRkF6eWtTWk9NaFI5?=
 =?utf-8?B?eXJVb2VVTjFTZXF0bWx1ZCtIVTNHMGd3RWswaGEwSkdJNnYxV3J5RVo1Vjh6?=
 =?utf-8?B?SWhaRXFBQi9FYXJnaktaMkVZQnZnM2lBbk4rRkVINFdRa0hRWVB1b2M2TW1N?=
 =?utf-8?B?S05DeE9ZTjY5RlhmOS9kRTFJYktmMmx4R0tLNTdneDdlVDZQbHNDNk9xRlYr?=
 =?utf-8?B?YTdYNXErNWRNYTV5Vk9RN3ZFYU1DSDhWdkJKb1UwVDJuelI0eG9DMDlLMElk?=
 =?utf-8?B?RnZ6RHFnMHArUThkMVFyZDVKRUlGZFJLOTN3RjRnNWhnVzhSR3g1UFBoeUtV?=
 =?utf-8?B?OFlwWTVpcFl5c0s4STlCeUZ3dysrZktndTI4M3djcVl2M1Fzd0JwRUxRODYr?=
 =?utf-8?B?RlU2UXc5VmNLNy9wa3lxanFucU9FTzZNekl5SXcvVU0zUThSeGhWdDFDSTVa?=
 =?utf-8?B?VWM3VmNBV3ovYzBBRUZnVEhnY2NPT2Zia3lSelVkQUU4cW5tcGhBd1ptcURs?=
 =?utf-8?B?QlZXaUpPb2wzVmxXUkxVa3VJZlpJaFBzMTcvWGw2KzBoUEsyZW5Xb1Z3L1dn?=
 =?utf-8?B?UE1KL2VxcUF5WXFlSFJLaXRRZkNwemR2UUl6aEg3QWFCVVV4Z3ZiaVg0N3I4?=
 =?utf-8?B?TmlySys2cHlLejBDUURkRlNPRklmdzRpeHJNUFdXU1NseS9xUzZVNHU2UVpW?=
 =?utf-8?B?QXBqaUVRanRhc09SWU1CWEovdzQ3YXFCYjJHVk5hWW96Mjg3L2J1ZkFST2My?=
 =?utf-8?B?RVRpeEV5a0krVlkzNkduQXpCUDlaNVN5N3JTWDBwUnNxdkx4VlJ0Ry96S3NC?=
 =?utf-8?B?MGdBUFdFOGFSU2tJYmxpM0M2TnRhV05RWmJ5WnAzVmkvbWQxa29WV2hhQi95?=
 =?utf-8?B?S1VHdSs2QnpTa3l3QTdTWndoa01jcXpTN24zRlhLbysxOGlLMW5naEVWeC8z?=
 =?utf-8?B?dEtnQ1RPRXI0ZDZFdjdzSkttR1g1SUNtdjZxYjVicnNaQ0ZzS2ZONk40MmdL?=
 =?utf-8?B?Z0NRRGNNTzVjQzBkWWN1SXcvZEtkSlZuV01PSzMxTFJNVnpEaG9mV3Z2cjdN?=
 =?utf-8?B?bkxyelNscGpkc2RrbTgxdDQ0ZGNpczdCTmVQck4vWGdUT3BPdStIV2RqRHN0?=
 =?utf-8?B?bVhRN1V1blFremdSK1FnQWcrR0hzTng4NlBXa3BlLzBGQTBUVWJldVJ3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UHdTYTVvcUVSTDE4RUlidW0rZ2lWd0VrdXJmb1BDZkw3OHhkNGg3dmhIQzlk?=
 =?utf-8?B?cW1vazcybXdSS2FsWGZxZ25YZzZYcWVjSUxQWGd0L2NGMEs4blNKM0tWN28v?=
 =?utf-8?B?NzRYUnBkeVNwcTBvU21JVGxFd0o0NEE0SzJuWm1lMG0vOU1hSEtGOGs0cURY?=
 =?utf-8?B?VVNEMjQ3bHlYTFhVUS9PRmJGdjdsSm9JK0V5MkFXQmY3dVFvSzE3dUp3SS9K?=
 =?utf-8?B?ZVpKdVBtVHpwa3MxTTNaZTl2eHNuNWZuallQMm5DNjlmWCtiTHU4eXo4aVFk?=
 =?utf-8?B?Y0M5aVZVRm1ITDhvZmpYMGdnNTFGTEVZQXdhbTZPZXgvYk5QK0h6cWlTMlZK?=
 =?utf-8?B?MXVyRW1aNUZqNUU1Uk9Kd0tmaUtEV25DL3h6RmJsaXR3RVRRYlRxWERwLzhu?=
 =?utf-8?B?MU1mMEFaREx6SHBmQS9VcVB2dE1Xb3RkejNSeVpTL2c4TzBxYThxQjlOaXRK?=
 =?utf-8?B?MnNCZVRtVWo2b1dGQUZZYXd6ZUhwSjZBWjdmQkMxNCtYS2N1a2hvWmgrdkQ4?=
 =?utf-8?B?V3JzRnY5MUJrd0ZUNDRRRXdSS1NYRHpzUlNEZ0ZCWHFHSUVYN0dsVzhha0c5?=
 =?utf-8?B?UXA0K3dUQWVOTk1kWWx3YzR6VWQydTBEcTBSUkxJOGwrT2llQ0plclg5VUM4?=
 =?utf-8?B?NTlCZUxNR1lxZVNtTEszR3I4Qkt3UE1CUDc0SU5PdGhQTG9iMEE2S0piaU9B?=
 =?utf-8?B?ZUkwOFlaTDgzS0llZTZtcGRTdG12cEQyekZiSU9vZjZLeGNuNXR4bXZ4dnlh?=
 =?utf-8?B?dTFIUFZPU1YzK3I2WlVYekJ1L1ZCbnZTWmhVem1XalpXc2VqYzN5clZKcyt4?=
 =?utf-8?B?ditpQkNyNlMzQjR1V0pNTUljKzQyUWsyMllxOThqbTFpQjB0WkJ3SGgwQS9R?=
 =?utf-8?B?YUtXR1RBQjBqS0IyL2d2YWluK25aSDJuaDczMFNzTDc3M0JKdU5sUXBDUW9a?=
 =?utf-8?B?TEh4clpkSHNjaTlEOEFwc29wYTZHb1Buam9STEQramlQcGJ1VGx5Wm1MT2tK?=
 =?utf-8?B?MFB5YStydGZzYmZQZlZzeEd1VUROOHNBYzdreGI3WEppWGFmZ0tKdWRQdTF3?=
 =?utf-8?B?M3E3QzFRNkRKZ2V1YnZkaWhVQ2w4MlQ4V2Y4d1VCVUlkcGZXY1crekZYZ3Jh?=
 =?utf-8?B?L1VmWFFVVllFUHdRc0FyZkJQY0pZMGpiWURMWWZjN0E5Nlh4b0k5SHA2QUtw?=
 =?utf-8?B?TGhwT21sbWVzVmx4eFFpaUlyaUtMUWkwZXg4N3Rjcm8rdzlzdFEvMzdqd1B3?=
 =?utf-8?B?cDFvcHFzVXZUM3FOR2dDT2wvOWtKNUUvNm9TTVhMV3Bpc3U1MnlVNjBIMGlv?=
 =?utf-8?B?T0FMNDQ2ZlRSK0w1WWVRVnJSRkJ4Vm1NL3FYaFo4b1FuK0NBM2Vic3Z3aFdq?=
 =?utf-8?B?RlpMUmtIUnF6Qkh4Y0R0eTJLS0lZVFlBT2t3STlWR29YMENhOFZWenRBU28r?=
 =?utf-8?B?QVNTOWNPaDZtN000dndoekM1NzBTRmp4ZlNiZEp4VHhFZ2lveWdPZ1RGWFdL?=
 =?utf-8?B?VDF3Sk52QVBvYThham0xSmsyYWlvYlJ0WEYrbzI5WDlHblVoSDhoVVBRWjJS?=
 =?utf-8?B?cDFPdlBJZGtuMFc5TjJuUlVEMDlzbnl1bUJONms2WGViMWsvUDJtNmJWK1FM?=
 =?utf-8?B?b05wNFhESnF5UDk2c0xteTdlc3gydnFZb0JHY1pCdmR3eVNIZ2dCcVc0YlVv?=
 =?utf-8?B?OElsb1pXY3BpU1BZYUlDeWdLTVVDQU9IL0crYTcvUkhacjBPc3FiN0RVS1Q0?=
 =?utf-8?B?eXJSZjNNdGc1RmNSRkRDa0RYMFMzc1F2K0xJSTZwSkRTN3pGQ2NQeE9DMFlX?=
 =?utf-8?B?b1FVNUc5UXUrbEFBWlJCSTBZalgwNHgwYytKMVcwRE9XTEpFMGdxS0JYaC9S?=
 =?utf-8?B?QU4vRzM3USs3clhITytQRmx5N1Z0cEYyc1VhYUh2SmVRRWxndWdEalAxTTNB?=
 =?utf-8?B?TXNESUdyOFdZWU5ab1dGdU5iZDhPNkRmK21iNVFSZzVWcWNkQ1FVeVpJSjhN?=
 =?utf-8?B?YnNnMmZBcXdxdHl0aDVJbzJ5WmQxeUNZRG9PVGh5OFpvQVVsNWF4blU1dG8y?=
 =?utf-8?B?WDFUNVFrL1VIeXhGeFhVTFJQeVZZcXdPamJ2T1o3dk9CYTQ0V1U4aW5vR2lx?=
 =?utf-8?Q?EKvSqPetbAyqFGYE45YkUJQfN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1847cdd7-b2de-4fee-ce37-08dc7a261eef
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 06:12:12.9273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m7GkNLZZS1jkxk+5+s+pP0BczYIasTj3zqBGcwzXrN2sxEPDUrXJ1hhxBTEVKFGZo1H819t1c+zziS32Aw+gBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6177

On 5/22/2024 3:52 AM, Sean Christopherson wrote:
> On Tue, May 21, 2024, Paolo Bonzini wrote:
>> On Tue, May 21, 2024 at 10:31 PM Sean Christopherson <seanjc@google.com> wrote:
>>>
>>> On Mon, May 20, 2024, Ravi Bangoria wrote:
>>>> On 17-May-24 8:01 PM, Sean Christopherson wrote:
>>>>> On Fri, May 17, 2024, Ravi Bangoria wrote:
>>>>>> On 08-May-24 12:37 AM, Sean Christopherson wrote:
>>>>>>> So unless I'm missing something, the only reason to ever disable LBRV would be
>>>>>>> for performance reasons.  Indeed the original commits more or less says as much:
>>>>>>>
>>>>>>>   commit 24e09cbf480a72f9c952af4ca77b159503dca44b
>>>>>>>   Author:     Joerg Roedel <joerg.roedel@amd.com>
>>>>>>>   AuthorDate: Wed Feb 13 18:58:47 2008 +0100
>>>>>>>
>>>>>>>     KVM: SVM: enable LBR virtualization
>>>>>>>
>>>>>>>     This patch implements the Last Branch Record Virtualization (LBRV) feature of
>>>>>>>     the AMD Barcelona and Phenom processors into the kvm-amd module. It will only
>>>>>>>     be enabled if the guest enables last branch recording in the DEBUG_CTL MSR. So
>>>>>>>     there is no increased world switch overhead when the guest doesn't use these
>>>>>>>     MSRs.
>>>>>>>
>>>>>>> but what it _doesn't_ say is what the world switch overhead is when LBRV is
>>>>>>> enabled.  If the overhead is small, e.g. 20 cycles?, then I see no reason to
>>>>>>> keep the dynamically toggling.
>>>>>>>
>>>>>>> And if we ditch the dynamic toggling, then this patch is unnecessary to fix the
>>>>>>> LBRV issue.  It _is_ necessary to actually let the guest use the LBRs, but that's
>>>>>>> a wildly different changelog and justification.
>>>>>>
>>>>>> The overhead might be less for legacy LBR. But upcoming hw also supports
>>>>>> LBR Stack Virtualization[1]. LBR Stack has total 34 MSRs (two control and
>>>>>> 16*2 stack). Also, Legacy and Stack LBR virtualization both are controlled
>>>>>> through the same VMCB bit. So I think I still need to keep the dynamic
>>>>>> toggling for LBR Stack virtualization.
>>>>>
>>>>> Please get performance number so that we can make an informed decision.  I don't
>>>>> want to carry complexity because we _think_ the overhead would be too high.
>>>>
>>>> LBR Virtualization overhead for guest entry + exit roundtrip is ~450 cycles* on
>>>
>>> Ouch.  Just to clearify, that's for LBR Stack Virtualization, correct?
>>
>> And they are all in the VMSA, triggered by LBR_CTL_ENABLE_MASK, for
>> non SEV-ES guests?
>>
>>> Anyways, I agree that we need to keep the dynamic toggling.
>>> But I still think we should delete the "lbrv" module param.  LBR Stack support has
>>> a CPUID feature flag, i.e. userspace can disable LBR support via CPUID in order
>>> to avoid the overhead on CPUs with LBR Stack.
>>
>> The "lbrv" module parameter is only there to test the logic for
>> processors (including nested virt) that don't have LBR virtualization.
>> But the only effect it has is to drop writes to
>> MSR_IA32_DEBUGCTL_MSR...
>>
>>>                 if (kvm_cpu_cap_has(X86_FEATURE_LBR_STACK) &&
>>>                     !guest_cpuid_has(vcpu, X86_FEATURE_LBR_STACK)) {
>>>                         kvm_pr_unimpl_wrmsr(vcpu, ecx, data);
>>>                         break;
>>>                 }
>>
>> ... and if you have this, adding an "!lbrv ||" is not a big deal, and
>> allows testing the code on machines without LBR stack.
> 
> Yeah, but keeping lbrv also requires tying KVM's X86_FEATURE_LBR_STACK capability
> to lbrv, i.e. KVM shouldn't advetise X86_FEATURE_LBR_STACK if lbrv=false.  And
> KVM needs to condition SEV-ES on lbrv=true.  Neither of those are difficult to
> handle, e.g. svm_set_cpu_caps() already checks plenty of module params, I'm just
> not convinced legacy LRB virtualization is interesting enough to warrant a module
> param.
> 
> That said, I'm ok keeping the param if folks prefer that approach.

Sure, will keep it. I'll respin with all these feedback addressed.

Thanks,
Ravi

