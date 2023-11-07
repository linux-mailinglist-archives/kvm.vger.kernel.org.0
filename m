Return-Path: <kvm+bounces-1091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B14727E4BC6
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 23:33:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8AE9CB20F0C
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 22:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 674AA2A8D4;
	Tue,  7 Nov 2023 22:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xJWE8wZX"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A1E2A8DE;
	Tue,  7 Nov 2023 22:33:47 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2089.outbound.protection.outlook.com [40.107.101.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FA611C;
	Tue,  7 Nov 2023 14:33:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FbPL8t2m5o0QZV3hVk3iH05F4IY1gMuyQz0JHCwytQjkbgu8U/7C+QXN5mfilVNPKcpy/RJMrPLtWi6D2gZym/FDYV1kVCHBYa5cNxrEpk8I81qG/8IQaOrmzPjmC6Qo3SoNdGaCYrgOr/5OjBwlSKNZmOk5gD8NbLeeo2Dmq7863vFwPM7Dyjxr+RmhLCPqLNtnhxfV85/iXnAJpfcJVPjM9YeNYyyxeBK/ofW4VI7YT5asejFavGliJGdKUZ4mxUXbLyES6gFWiLLlio7it5S8+RQxhs7IYK+JFzVVxBR6kmE/1FY/h4KT4bx3PAmGkzv4eq0VvaJSYBC03x9Xjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UMGrDPQak/zX4s/hDB/w4mO2t2Wb65hda8lIHXbTjOY=;
 b=HkgTKhhssgS84ytH1sdsnz0Q6YV1QnOoITYCRx4hR7M0O5hibLQrWUrq8nC3EqTK3JRcF9GWlYc/eB9kI4MWbntCGdXGP36QChvRlRm2Kr82i3ZjsoOXEyFQGGXUQhgBnmxgyX+il7tu6RpiKnyd4LU0pl4vLQTVC8s5E00mDA/qhWPIg0YM2B1HZnNpSlafpJgVmzV4kgCscuBIu944VI+CNR1Drhp1qyph1jyzE4e7aUFIUL1tU/wBSOX0O6VRyGNNsO6wlkq/BPBP8dQK5QwRnVxFpbd6nydbPrcmH/m40X6P1gZAYJ/aLKvDS/aswpT7LrXlz6DY5WSJPSfOrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMGrDPQak/zX4s/hDB/w4mO2t2Wb65hda8lIHXbTjOY=;
 b=xJWE8wZX6Wck8f+3komwd+m+BnRq1SUe6HaJ5tlVUTBVY0+IJbw0890NzTIpuDyNfuBk46G6kQx2vxC/7ZcKVabJ4Q8xO8tKuT4sDhnmV1Z8tBf7nSeuYqMq4xtw/6i3eX5bh+jQL/Nixgjqql+v2yBYlnO5bP/F/WRiVdYEs9Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SJ0PR12MB8614.namprd12.prod.outlook.com (2603:10b6:a03:47d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Tue, 7 Nov
 2023 22:33:44 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152%6]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 22:33:44 +0000
Message-ID: <4b68fd05-5d21-0472-42c3-6cf6f1f9f967@amd.com>
Date: Tue, 7 Nov 2023 16:33:41 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v10 06/50] x86/sev: Add the host SEV-SNP initialization
 support
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com,
 dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz, kirill@shutemov.name,
 ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
 liam.merwick@oracle.com, zhi.a.wang@intel.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-7-michael.roth@amd.com>
 <20231107163142.GAZUpmbt/i3himIf+E@fat_crate.local>
 <4a2016d6-dc1f-ff68-9827-0b72b7c8eac2@amd.com>
 <20231107191931.GCZUqNwxP8JcSbjZ0/@fat_crate.local>
 <20231107202757.GEZUqdzYyzVBHTBhZX@fat_crate.local>
 <250f5513-91c0-d0b5-cb59-439e26ba16dc@amd.com>
 <20231107212740.GFZUqrzK7yzy41dRKp@fat_crate.local>
 <20231107220852.GGZUq1dHJ2q9LYV2oG@fat_crate.local>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20231107220852.GGZUq1dHJ2q9LYV2oG@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0095.namprd13.prod.outlook.com
 (2603:10b6:806:24::10) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SJ0PR12MB8614:EE_
X-MS-Office365-Filtering-Correlation-Id: 880c81f9-5883-4883-f275-08dbdfe19993
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RXzeH2pNwmOSO4kiam4rc8KNAvLxCQu3lM1evY8qclXPF9nBnEK4EEZJecp7MhKkeWzjYFWwG4DO31oR2FjokdhZVt8k8lWMa2N5MJPnrLDn8TwxToYPnzInHt3jmKjA7rgl5Za0xChqLr5Q0Uk/RJZWriGBeQvOqoOsfmFxDIDOJvEA9zYLuj9kyQnSnK8UxITlSQ+X5hVr/fQ/e15/0E2sLxqZIuhbWfA52DtslIka9F6B9zTa8gOWJFigixGrk3OsuCLSNf6DMNwcEzIYz6rrASjP96acwy1pwZXNXieTdZdyG4T4PeMQ5EgsFkabHkzvDIY9+9VjT2upywQkXMMLOh4OUe/b28ApNjYZhq1+5VTTNGVvmRm7OV/lRSrsRXRAjswmlfmunVwtdWOIet+KrsXfqQKhdX29vzt7Br4+LJhoMd1/nVCy/ZaMLxmV/SUi3K/2AdU6P8mcFyjnsLE+72dS3Fq9vH+9bSnVkrvKX+oa2qck+gsSkmHODO6B/igizj4dLfWeErCNqLffxF3UkZXPiGUbLDEs8Z63cSXYxxpKD2qKs49mkfyeqKvrYmA0Uu330z/rnUYSRliN20aNC6yAJY7nVgvzKFgFYd3HYMEEEtM4Wk6Acl73LRiQDlRzHD2RU2mNubUK3yIevQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(376002)(136003)(346002)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(54906003)(66476007)(66556008)(66946007)(6666004)(36756003)(6512007)(38100700002)(6506007)(26005)(2616005)(53546011)(316002)(31696002)(83380400001)(6916009)(86362001)(478600001)(8676002)(4326008)(2906002)(6486002)(8936002)(7406005)(41300700001)(7416002)(5660300002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUU0Sm14UDdQTnZxYmZDVWlaalBwYWU4T0VOR3MyWnlYVHpkTlFSeXc2a2pH?=
 =?utf-8?B?QXQweUpDNE16Mk4rRlZKUVRsa1ZubXdLekp2c3FIOWVJS2lvMzhEOUh4MFVH?=
 =?utf-8?B?bStkRGp1eUpvcEJRQ2xRTUtlRjFpcGhhbmpuZnZyOUVRV3orRlcyL1pYQmtL?=
 =?utf-8?B?RU1mbnRJaFRJR3hKbms3bE41ZFQ3Q2hWaWZ2OGhtd1FQVEFWeGVmMFBnQXd5?=
 =?utf-8?B?WnUzUTJUdWxSREVQOHJYY3NsVXkwb3NCUWhGUmpVNU1WV0tOaEJudHVkdGNH?=
 =?utf-8?B?dTVNMXNjZHVYWllRSXdZTG9GVldvbkZ2NDZYMmtzUHc1SHV0WmNPU3VXQ1VU?=
 =?utf-8?B?a3hkQk9NMFNhNW1Lb0pIL0tZWEFUK0dQdUF5aCtDNXdBNmdWcXYwZ1BXQkNH?=
 =?utf-8?B?NURGbEczc0s5cFlLSWs4dEJDZEJMMGtadlZ3Tm1lUW0yb0s2VFFpTnB3WkJM?=
 =?utf-8?B?TGtUbk12eWU5L3RtallhUUVBNlYzQS90cnU4RnVoWmxIczJtYUc3aWdsd0Z5?=
 =?utf-8?B?NDZ4bFVZLzIwYnc5TVVWUUNMaW5rTHBUTmFsTCsxeHN4VHFDZFl6bno4c1dt?=
 =?utf-8?B?L3cxdWdCNWx5VTVET0p2ZEhVbEx2cTdvbmpqM1ZoUGlSeTEvcGhub3hTblJu?=
 =?utf-8?B?cklDbkhpNzFEN2VZbzhsRWtBYVlGTlZ0K3NiTUk2RnYwZHFhNmpxNHE5amFX?=
 =?utf-8?B?Uk1ZNjVyK1hSS2tPSXEyM05BbWMwemZOSTBKUWRSY1VFOEo3ZHdyaTR4bWtD?=
 =?utf-8?B?ZXk0SVkwSmYzQSt6c1I2dGh0NExVQURycXdvZHNnL3Q2NjBZK0k0VUpZVGtp?=
 =?utf-8?B?STl6cS9lQjJQb0o1YkRCdGZrV3FpcjliTzlGQWdkcWpWMUtwQkVCQk9MSHg5?=
 =?utf-8?B?b3kzUitmK1R3ZjFIOWNrU3ZVQUJSbWxxUXhsOWxQajU4VnAvZ2k1ZWJ2RGpC?=
 =?utf-8?B?aGdNWWw0L0JnS3h2dXcrMEZuaHRqdTIwaGNHc1VqeTIvdUcvK092NHp1NEVO?=
 =?utf-8?B?K281VGE4R0pFN01rWnhWN2hoQTlrNmdxSTFCd3RocXRXVGJER01ocjEyWFBy?=
 =?utf-8?B?SEFNUm9DVHFWYjRuZlFsbko2R0V3SGY5eDRQQVFtSFhNK2FJMFhaa0lJa0lO?=
 =?utf-8?B?Zng0eGpSRWI2dGRIQnNXQm9hYk9DWjB1bFpHWTM0c05oS3lVMWx5ejFvWmRx?=
 =?utf-8?B?R0M0bzEyS1lvRGN1eHhQNmFTamNEd0lrVkFUUXdZcmdmeDR5QWRIZ1dBekhp?=
 =?utf-8?B?emlGSWdKL2pNMEQrOEY2S3ZzVUx5REtNZGM5TWhzYUZmamt4U2NYTDM0MFBr?=
 =?utf-8?B?ZVptTEJkVUFoSlVzRnlNRjg1c2luTEJ5V3JhSVgrc29TOUtTU0JBcjJUc25w?=
 =?utf-8?B?dDRPN2xHMG1RTmNrM0dpNmpTTXJXOW5Sdjd2RmpMeG4rWGw2V0RxSDc0SDVq?=
 =?utf-8?B?aGtnQ3pMVnFjRUFwZGZ3R000L0ROTU04RVFqWDV0S3g0VDhkSWx0OFNGdFJq?=
 =?utf-8?B?eXE1dmhBVzdNUGgzZHZTTFRVZk5kS1dGNWVLOTkxRkZDVGNobUNSWnFrQ3hs?=
 =?utf-8?B?TlVkVGs3cndhMStvaG5SREdwcTdGTE9FNk54cEVFOWlpOUovRFNYSUtkY0c1?=
 =?utf-8?B?UjZDTnd0RFhQbHlTTnVFVExMZnRPSCtyQnczM3h5YVg4UDkzMmNyZU1BRDc2?=
 =?utf-8?B?SEUvR2x1T1d6RWY3c2hvNnd1dmxMcko3Wno0SmdaZEd3RTMxc1pTYVNjR2x6?=
 =?utf-8?B?cVNOZlZPWGFJRGZxZXhQUVIvMnIxRTJmREVMdE5xRml2TEJHc0czeFpKcE4y?=
 =?utf-8?B?RmxaN1ArcXkvWTJ6Zlg5R0pJcUZFQ3NGVFB1SVkwK2VCZGh4TVZZK2FVUERr?=
 =?utf-8?B?aHZ2SlBsQmdaZm5KRmIvYysvWWhWUzdyTWRTUEtabTNNRHc5eCsraFZ2bWNX?=
 =?utf-8?B?TjJ2bFlHM0llenorWTVCSWlVRkpQOCtOL3MxMUNJOVQyMlZnRVBPVmxTbkti?=
 =?utf-8?B?QmF5VXorakNRcWFsVUVRakxGNnF4Z1d5TytoMFlWTCtrWXBGbmlCbEkwRnk1?=
 =?utf-8?B?NURlaXBJNlU4R3daVTNyaXBPc28yUXVHM1R1Z0wyUG1sU0NnMDh0d1MvTWJG?=
 =?utf-8?Q?WY4TZAaX7ZoUjvTknxuOxNtRV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 880c81f9-5883-4883-f275-08dbdfe19993
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 22:33:44.1927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZKUwm0R7YU9P0kpfCWza7QfxQw7H/OLMrJ5T+8ofozleLF2/jOtG3rJSWqEExnkpRZOXXktYmLgdq/kPQQiJ7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8614

On 11/7/2023 4:08 PM, Borislav Petkov wrote:
>   static int __init snp_rmptable_init(void)
>   {
> -	int family, model;
> -
> -	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +	if (!amd_iommu_snp_en)
>   		return 0;
> 

We will still need some method to tell the IOMMU driver if SNP 
support/feature is disabled by this function, for example, when CPU 
family and model is not supported by SNP and we jump to no_snp label.

The reliable way for this to work is to ensure snp_rmptable_init() is 
called before IOMMU initialization and then IOMMU initialization depends 
on SNP feature flag setup by snp_rmptable_init() to enable SNP support 
on IOMMU or not.

If snp_rmptable_init() is called after IOMMU initialization and it 
detects an issue with SNP support it will clear the SNP feature but the 
IOMMU driver does not get notified about it, therefore, 
snp_rmptable_init() should get called before IOMMU initialization or as 
part of IOMMU initialization, for example, amd_iommu_enable() calling 
snp_rmptable_init() before calling iommu_snp_enable().

Thanks,
Ashish


