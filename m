Return-Path: <kvm+bounces-9993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A288681AA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 21:02:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D72E1F27AC5
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DF7F130AFF;
	Mon, 26 Feb 2024 20:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Vp6W6Xn+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2080.outbound.protection.outlook.com [40.107.96.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A597130ADC;
	Mon, 26 Feb 2024 20:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708977762; cv=fail; b=MmVIuB6MQym2vqBwS3AdqwwHlRkiDjzdfHik0xO/WVGPdXcPqvHIx5/WhNkJxJIowi9kyaXK2SD6AhTAl6qls0QyjZIzF1vTorNMFBGkkhEcfvyR6TQPH0YN8GrAmfTLIqWNtE0ovgtp/a/6JLpmIIvYNU2bifM4RGnogEjXjUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708977762; c=relaxed/simple;
	bh=QkBfjtBsBBOAbaWvx6PzXkPtRUdevrfGAoCiSrhI50E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kuXNWApSb12zzfH1sc3gI/A2pwfd10Y/Ibzl5GttCLvb7f5rPABz/UAGx0QsiGXEa3QZB5v72usPBdkXzOtB16liWXyMw4xfB2TGD3h64Zjfw5e7ePVZEXB/RStdahT2/f9wdHwTRX6pIwmrg/d7rpYQeJ4hJli7KSbx9LY6WpM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Vp6W6Xn+; arc=fail smtp.client-ip=40.107.96.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+JQ+T+CTfyPOzu4sXEY4B0uN0Cnmj869TEwuCSRswq2NFSouZtUAIYC+kMcnXGn9BuyFEv+5XZoh5ERDPqFAcZu2cUrURMNQY4Eaw3EkJnidBuY/4vlmWzblOyGZ0VtVaVVZzLSGnhPRmdnggIzV48EwbEu9r7FPND4s/iaZmBZLwcRMUnWB+OiXqwHEwpVNxsb95PHz4Yj7o9mcTFvHuL+ab17rSmRhzi5q/e2ysaV2M25MsZedybmGTiMBtq33PUOzTPKbK4QkbpJxlcvbC3XeVeH2SAL9jKc7u0FEjRGjgACjcVjgvW5ZW8oHft9c5CbWonlWqTvmyRddP9VMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DIl0SnOTXKNyds5jppIOooD3wEgE8C5aqNbfNsBztQA=;
 b=eIfoOhMvBTkJpMp6SLVIktwmv8BTlJ+KA9eeWlYKInf3RHzCHlzARWXhzBuyjeuPzjC6UyhGPX8trP+uiCbEVJ9xZzcRPPeGiwYBHveNuFwO184apRw0KyDz1KKv63u1m8rXEcnknydT5kkcWq6YEoWRy0QGgky9X1bzc2/rQ0iTmHCkDrFARpcGHJVbgUyu+N6KV3+lwVv2cJYyqB7N4VlK26xnVhgSbsMCeF1o4m8hokTZevgciEM2IGkIjTdS4/4juij0u5d4PbPiqrEOvPaWCzhO+tgjluWTXUHAnADdSVv/p+BjJlSUUNIvsSj/6zic13MAWtI3AeM3Wv/QNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIl0SnOTXKNyds5jppIOooD3wEgE8C5aqNbfNsBztQA=;
 b=Vp6W6Xn+Cga80CGMt0Xscu4++wGlYadreQFbHk27pQ6ghunbSQ0mhLukmaN4JOxeeWIQZKgBzP867EYExe/xASuEs3cIuJSxZZZjy3Lb2cPl4C1/eTVMKnEq2qYPf2eXP6f+g3HvNiixzx01o0+qkuurkC+/XfWP5PBhWOgoEUQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by PH7PR12MB6882.namprd12.prod.outlook.com (2603:10b6:510:1b8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.31; Mon, 26 Feb
 2024 20:02:34 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::db9b:a5f:5d0a:2a42]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::db9b:a5f:5d0a:2a42%4]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 20:02:34 +0000
Message-ID: <4f2d0790-fcd5-48cd-b299-ba90307ef103@amd.com>
Date: Mon, 26 Feb 2024 14:02:32 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] KVM: SVM: Clean up VMRUN=>#VMEXIT assembly
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>, Alexey Kardashevskiy <aik@amd.com>
References: <20240223204233.3337324-1-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20240223204233.3337324-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0062.namprd07.prod.outlook.com
 (2603:10b6:4:ad::27) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|PH7PR12MB6882:EE_
X-MS-Office365-Filtering-Correlation-Id: 66ddae2f-6107-431a-9e32-08dc3705df6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gGI/wIZCa+5e2ZellYKv7CTYUcqGKlebF5JCIsveFDrhyWDvCEA2pL9oeLq46WC70n9yQumfS8FuYrp/tRyyOL4xtWdx5pPaLbVnHJbMzyC8F00QsMEWXddlRng8n4lCIRnfyV996KAdX+vUZFoBASG2+POH4FegtkS/6ZXJtPMoEYp2vqwH8BpGb2puOPL9leYNqZK2hWFX7tZBcXsAdDb8GLnYCvJihg3YPjfV9UncBFKjvKlytx5CN+ctd3mXVbQguwC60ZsJ2ebINhkgVOba6qfwpdLDevz1eNoK2iH/K2zLWyEH8m1RZAJ4ou6sxfVxy94Yx1wcj+PeCOeaA6gO86UV8XAvHc12NLjGp5nvIXbxe3Ef5CTGiGgknYh3RtN+CLOpVaK1hS+w0nER+HOiJOi6+AOCfQqHza4fhT0q6FTvrP1BaOMtfNZ1JyuRgXzVkLhv8fRZEhDUcnW1WvBZYfcuRD/7+gNxJuIS9DtXTsyIF72dXeU191GDB2PdO/059UEHpu43O8Po+EhtGCxnBFeSUg8a2kS+6Z15mEtlFDpU/B7dJ+CztXMVyb+RlRwz5Q3xa06COJFtWBNHF1u/AFmCEnuOnezO7D3J8xPNAF5G+YrXRYakdeQFz0bzMwlNjfUp504UkwTJfYOvtA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z0pQTzd3SW5zY0tSQkhYTFR5WWFWdUMxb0dadSttdHBOS05jcU9uVWF2ZU5w?=
 =?utf-8?B?bXh2cnNWTC9JVzl5cXcrL2NsTXY1L1RNRWozeGd4UnE3L3NsdEVtd3hxRmEv?=
 =?utf-8?B?UndHMmVBb1N2eXAwNzBZdnpORFdPUVlOYWpQWCsyajB6czdxZll2Z3JaZ0o2?=
 =?utf-8?B?eHlBYkpIUE9XV1JocHhkV25VWGFuTlVwZVl3TzRLaFNMeXFQa1ZCNTRJVG5F?=
 =?utf-8?B?VVE0RDRRSm9qVG1xZWdJVjBaQzY3czY4TGdpWVo1Ujc2NGdSQ2taRzMyOTBD?=
 =?utf-8?B?cmNUUTMxYXZXNjgvSkNVd0ViMVh2NEZ5Wm91YXdVYnJTN2U5SE5BTDlQd1Na?=
 =?utf-8?B?RERTWmRGNWpWNC9nZ0NldGZtU2E5cVQzWngyWG5CUmRQeWFVWktxd2ZoZDE1?=
 =?utf-8?B?TzVUM0drVUN6R1d5RnBFdHl5ZlVmLzVhazBVN2dLemVka0ZXN3lsMzFIajZQ?=
 =?utf-8?B?dDdvMUdTSStWS2FNY2U1UkVFaW9LOHFGMVJKa1p5QlhEd2RhTW9UWStqSzcx?=
 =?utf-8?B?VDcvWnhFRStraWxWR3hSWkQyTFRZK0dPWG55OGFZamprakh1N0R6NVlHM0s0?=
 =?utf-8?B?Z3NxUGVMN0VOUGtEeU9NT0FjUWFxRnhYSU1TRkpObHlURFkzVTlQYVFzOGxU?=
 =?utf-8?B?bGh0UGE4MU1OR2k4ckNHVTFUNU9CTTUxUFhtdTdUcG5YeHRVTThmYXd1SHdh?=
 =?utf-8?B?eElQVzd0ODNsU2FaQVFmRlpMWjRRLzgwTHU2Rzk5dTlXdis2ekFjOUtxYVFx?=
 =?utf-8?B?S0UwSW9xQ0ZPZ3JpbDlUVkNlNC84K29aZ3lhMHcwNjBweDl2RzhvK2JKaE9I?=
 =?utf-8?B?Nmc5eGdoOWNDSkxreUZmMFNJOGt2cW9kcFhSeVZicGdTcXdzUWQ1S0NoQ2tK?=
 =?utf-8?B?bTZiTS91eEpwVnFPN3E5dUw5a0lmYkdWcjRlNXk0cnRrRGhodkczVTVCS0I0?=
 =?utf-8?B?ZUhZUFlOck8wY3YrL3dWdytNMWhXNGI3ZzhVOFp1MDlXdjJwQ1BZQUZHODJw?=
 =?utf-8?B?dkN1d2w4cGRPVG5DclBCOXNFWXQzWnpZR3kzOFRxeENaQVlBSnhMTzNrZjZ0?=
 =?utf-8?B?TFJ1Ymk0eUlQYldWVmlzTi85VDB0dTdHa2UvYnZyRGV1dUIzMFZBZ0RxeDdY?=
 =?utf-8?B?clJXdG96MzlwWHBZOWNGY05NdE9DWW9ZRHVYazYwNDJLZ3BWaDVrbkJaVmg3?=
 =?utf-8?B?dERtc1BROGRIdnRVRW82ZEdyQVdjMW9kZEI4cDk2M1pQOXBQQjFSait5UGxX?=
 =?utf-8?B?Z1VSS05RZTgzNXhuSkZqUXhJUXdreklqK2JCWm9YbTJRTG1UdVd5akI4ZzVx?=
 =?utf-8?B?SmxuRnNuZ0lKb0N5b05wb3hzbTUyQzAvSHBuSGNCSVVCM0hxQTYyNy9vazdr?=
 =?utf-8?B?M0F4VVRTMWo3SnF4TkRPTksrMDNvRmM2cXYxUHF3aHl2UXlnbUdkd1dzTm93?=
 =?utf-8?B?MEFpUGlRcHVJTm00enl2U2EzdllPdmxzMGo5aEhMREhucmpYUmVEWVIyU1Zy?=
 =?utf-8?B?aFU3OFRBS3BHYU45K0FSRlpCbGxROVd5enAvVUJwNnc4OFBSclY4VTJXOHBC?=
 =?utf-8?B?cFNNYnpsdVptOFFkS2ZqTjJYSXJ4NFY1akdTNW5nQjFxeXZiR2RvVXVBbFB2?=
 =?utf-8?B?QncvWlZhZmlJQ3BmaTJIQnRZNncvZnIwb25HamdxNXR2RWdsek42U2RKSTZO?=
 =?utf-8?B?S2pSKy9NMjNaOHNNU3BOTlNCbmJleGNnU25PNTlLNUdmYUgxTVpxejY3NTRt?=
 =?utf-8?B?WG4wMDU0SHZKRG1kQzdCbzkzZmpRV3JUcU1pcDh1M0M0bW10c3I2eFAyd3FX?=
 =?utf-8?B?dEd4ZCtqMllDSmJBTEhkc0RiVHp2ZUYzVVZJaC9qODMzSU94TGpwUXowM3JO?=
 =?utf-8?B?YkkvN0lGQ3Q1NlN4Ykd5L1lLL0hxNWU0VFZxUDMrOXIyQlgyVlVuOFV0Z0Ew?=
 =?utf-8?B?eW5zSG1xajAwbHBMUTdrNUZ5ejBQaGkwT3hyTGFITWlJY2I1YXhyQmw2VXd3?=
 =?utf-8?B?ZDFZYWNpN2JTOVlJUlhrRmQ3RzZuWXdZY3Q3RVpHOS9QMGwwdnZmNmR4OHlG?=
 =?utf-8?B?dGkxbDUzc1VxdFYwdUY3TkJtNEVwZHZQMUNPQStSNDk2UllWaWxnNDRUTWlT?=
 =?utf-8?Q?w5GbMRZ9r3Afm+zxr7TDx9oeq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66ddae2f-6107-431a-9e32-08dc3705df6a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 20:02:34.4701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ZovB5iWE3U4qkbuYqNDEMqTrkARDdWrvA51GQ/y6556t6LA55gG5wFEAhReLEnrdx+z46S+9j6fVrmVEJCokg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6882

On 2/23/24 14:42, Sean Christopherson wrote:
> Clean up SVM's enter/exit assembly code so that it can be compiled
> without OBJECT_FILES_NON_STANDARD.  The "standard" __svm_vcpu_run() can't
> be made 100% bulletproof, as RBP isn't restored on #VMEXIT, but that's
> also the case for __vmx_vcpu_run(), and getting "close enough" is better
> than not even trying.
> 
> As for SEV-ES, after yet another refresher on swap types, I realized KVM
> can simply let the hardware restore registers after #VMEXIT, all that's
> missing is storing the current values to the host save area (I learned the
> hard way that they are swap Type B, *sigh*).  Unless I'm missing something,
> this provides 100% accuracy when using stack frames for unwinding, and
> requires less assembly (though probably not fewer code bytes; I didn't check).
> 
> In between, build the SEV-ES code iff CONFIG_KVM_AMD_SEV=y, and yank out
> "support" for 32-bit kernels, which was unncessarily polluting the code.
> 
> I'm pretty sure I actually managed to test all of this, thanks to the SEV-ES
> smoke selftests, and a bit of hacking to disable V_SPEC_CTRL, passthrough
> SPEC_CTRL unconditionally, and have the selftests W/R SPEC_CTRL from its
> guest.
> 
> Sean Christopherson (8):
>    KVM: SVM: Create a stack frame in __svm_vcpu_run() for unwinding
>    KVM: SVM: Wrap __svm_sev_es_vcpu_run() with #ifdef CONFIG_KVM_AMD_SEV
>    KVM: SVM: Drop 32-bit "support" from __svm_sev_es_vcpu_run()
>    KVM: SVM: Clobber RAX instead of RBX when discarding
>      spec_ctrl_intercepted
>    KVM: SVM: Save/restore non-volatile GPRs in SEV-ES VMRUN via host save
>      area
>    KVM: SVM: Save/restore args across SEV-ES VMRUN via host save area
>    KVM: SVM: Create a stack frame in __svm_sev_es_vcpu_run()
>    KVM: x86: Stop compiling vmenter.S with OBJECT_FILES_NON_STANDARD
> 
>   arch/x86/kvm/Makefile      |  4 --
>   arch/x86/kvm/svm/svm.c     | 17 ++++---
>   arch/x86/kvm/svm/svm.h     |  3 +-
>   arch/x86/kvm/svm/vmenter.S | 97 +++++++++++++++++---------------------
>   4 files changed, 56 insertions(+), 65 deletions(-)

Nice cleanup, thanks!

For the series:
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> 
> base-commit: ec1e3d33557babed2c2c2c7da6e84293c2f56f58

