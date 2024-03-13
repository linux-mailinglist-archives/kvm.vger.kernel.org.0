Return-Path: <kvm+bounces-11739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B639187A979
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 15:32:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4167B2356F
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 14:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4E9015A4;
	Wed, 13 Mar 2024 14:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aRlFN6SE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF22F17C8;
	Wed, 13 Mar 2024 14:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710340334; cv=fail; b=iHZzzXIawS4CZpxDcrabOUfJoxKmlJ8GBmpPNyIzRlcdNIWAP0og2uxFiHlUwylBIDmyJqIxszjt3tjD8ntrns4g2hZ3+h+73LpNMejlxXBgudUDTs+WUAWcMzXfmsQdMPbzirp2EYx/oGVpL+ILTNmNRsBSqaOf3YVWZe7VEug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710340334; c=relaxed/simple;
	bh=ja1xLTXdQT6Bq8Zy77CF7IeiPxpIPFesIK75tw/bgNA=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oCun68zbSYmp/pXRw6U+9jafVsCSZay4XNdbHx2TrB3fx93PW2L4RNYvlauZ5GG8M1pF9Pf+CtMFZvsIrLVKDzmoeeGfzRA8qLt4H48f4iJjYdnSMa9GXorlprRNDJzANsEEBMWCAQ5wXXS+HUU0PfilpkVMwMgOhX721SQRs5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aRlFN6SE; arc=fail smtp.client-ip=40.107.237.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZfX44BVkWVcAlWh7Er38j/cBThPdZESIy7YTlmgrRn54xCkJVR7gkmZPxAMeZyWdDo6rAlTuXRO54sQx2QvcXVStAU8EJpcksIp5HdXYqzI9b9i5hUiqTsoGWhYjtvdkFaTvOzeBMoH1rFhVoV4df5Cwf4o/Y5zNPxG0ReK5r5FEB9QaBHfY1x6E2s6Gl1WSDol56rHKkWzszqAlf45LXKjiylYcjmCjjzhvonu7r+WVYCoF4aiE9u2EKUBQC89rb3C8b497Zfj2B1QyE07wmNFRWL9fg66NgaMezVfllbF8nYwfg1LweiDEBxr6Pv062xysgqIcXE6ru6jXk544A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e1faW6ViDPneo1U3vvF72N4b8EclEcyfH8ZTIwgY/LM=;
 b=d+Upk/CUYg0sDlY+uks1gBGn6THVpbo0FTFg6ggovz9sSSrtszA36HaC15Yz5ux/OO9s1H47azkLyNFzU0BbTp2DmDIbCYCP1Exl0viLemzdWjvZ9Jy7hPSlB/8W1ggmuJrWdivrZvDiRgWVEJXTeRnARV+3c5nJNvKE4PP+sfzFIELndJ99xS53O1NUsIRAMN+yNjuj0gzjrq86d8euaoMHd/EvQ8C74FYaeEwuVoLF8NhSjWen0L8p6xcroS359ILY2E2SocDU1PaOONb7IfzO4MyUSmkueUlkOb0Sm0WnxBzGLViTDyHxzfcKavkIELxXVsceftWJvIka84MktQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1faW6ViDPneo1U3vvF72N4b8EclEcyfH8ZTIwgY/LM=;
 b=aRlFN6SEegRdKYP0//J93m1fRANf/kzYoeriIqcSkRQlwkSruDdVcmhyBrKHWEyT1+ipaDlEC/H7MEyIV2dm/0g6xW9EPEinHsvGEghdp8DzsBZuyKb1h8Ju9auxaQPNGl6AD98+N7c4lDusE6oXqAqorT6XSSx1HWmCBZqzKIA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by DS7PR12MB5813.namprd12.prod.outlook.com (2603:10b6:8:75::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.18; Wed, 13 Mar
 2024 14:32:08 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508%5]) with mapi id 15.20.7386.017; Wed, 13 Mar 2024
 14:32:08 +0000
Message-ID: <fd2a75f0-4baa-4d2b-b350-4f38da32c670@amd.com>
Date: Wed, 13 Mar 2024 09:32:06 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM:SVM: Flush cache only on CPUs running SEV guest
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Zheyun Shen <szy0127@sjtu.edu.cn>, Sean Christopherson
 <seanjc@google.com>, pbonzini <pbonzini@redhat.com>,
 tglx <tglx@linutronix.de>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
References: <980607740.5109383.1709777666996.JavaMail.zimbra@sjtu.edu.cn>
 <90e5bdac-3b13-41bd-b1c1-981c35891f34@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <90e5bdac-3b13-41bd-b1c1-981c35891f34@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0177.namprd04.prod.outlook.com
 (2603:10b6:806:125::32) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|DS7PR12MB5813:EE_
X-MS-Office365-Filtering-Correlation-Id: 394e5fa2-37ae-4dea-237b-08dc436a5cd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+35ijdTZOyL0ags7P6E+TPCTdjjR6GD2aoDDd7+//wYsL/VA2MOrDyIT/GA3GT+TtDo+Vb9QBTDxOGd3OO34uavBFk6rsWiiYFR6hx+dGVpoRZkJeORNp32jc84qV+K+OQ4PDDyLYw3CZK4KsqOa1QAZVTp20EenGQYVBX3VubprSF9qipl82y6mxU+ujXkC5wfUoRc/zC2smVQnD0iX010HmQ3WLr4ZpEU8l0/+zdKCkqqREIQHe/zIVfNsG7ZXQFycJDM8Dbd5OeAk7GzjIcwXN3cfaTJNT7IXN6b86tN2ZloVpcFZdGjrqrk1AmejEZA6098Wxk+4KSJpr37Chp57hunlNUFLqNaBgCpdcIqtT1YBlPTc9sJzeCVqGz5CKcCLq5ZBsNbjxj3DzrpiHpe8OZLalTVGYwq1mr/7ThI0baTX2lmESnp/enVMkjZvC3BIWfok8T0CmCt5ejr2LoTXlxqm4WOsI1/McsxopG/ZJVpteuebqFfjMQAsvSNo2SgRnbc3KwyayvlE0ixrFa4+hAlLFfd+yzlPjEzGSFVquLJoLDCc3N/TDv7wf8Zb1I/mnW5ADjdtdLUHqTwnPQVNLLQy5mUqhGUgl0BdYE68iS8D1cThIMzgPEW1yW/f/fhKNQlWSIjmZc0eiuttWvqCT+8/bX223vSiOxO0N7g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEk5M1hsR2JXUStySkh1cEcvVGk5M0haZE93ZlQxaTZhdHNhMko4SEM4M2x5?=
 =?utf-8?B?VnpGbmZqWmU0cW1uc2I4UE5lRVBSRVZJbk9PS3FqVVRveWdUWU9BdTlmTjZ6?=
 =?utf-8?B?Sko0L21rMXArV1piNGM0UkYxTmZ6ZmkwSDNETnovSGpqci9wVGgzTVJaN2M3?=
 =?utf-8?B?dy90L3YvSjhDVG9acGpGYmRJczRnMXp5QnRlbGdTL2VGdVpaRlZ2QW1VcFR3?=
 =?utf-8?B?N1RkWVduVXhuM0t1RHg0aUFDeTVFcEN5eTJldjVRQjdaMnlBb2tJTGhBaVhx?=
 =?utf-8?B?alBQb1ZVdytJRHlPUnJFd3B0V1EwVUZnQzNWMFJ1eFg5NzM4YlVEYzJVajZU?=
 =?utf-8?B?WUJSWTNLZU9yS2d3UzV2RUV5ckFybnVGd0JMY3ZCMlVlRmU2bTkvdU9CenRa?=
 =?utf-8?B?c3UxVlRZYWpPUWlaZkUrVVpvSTFxZmphMnNCcDRyS0VqV20yM3V5T05vSjNy?=
 =?utf-8?B?bTlWUjUvQmg0enByOTd4bTNzdlRjMzBhY2NQZHZ3dnhYMEFpbzI5VDBDMS8y?=
 =?utf-8?B?VTFTa2sxbFg5SU5LK0pBenh5V0loajNsVFJoOTVOSnQxazNuUzFJVmFQb1hB?=
 =?utf-8?B?ZUJ3YmdQdUt6bUl5dm1uRVBQN243L1ZtRHl4UW1vem1aRG9GQm8xMTdpNTFv?=
 =?utf-8?B?K2JBdDQyUUJDRHZCUlpRVmUrc1E5dm54UDRxMUdYTGN1VzYvRUxxODVzcnU0?=
 =?utf-8?B?YzNXWDNwc1crSVNIeFlibmU3eUsxM1F4Zi9tSEVlZGhXeU5RWHBtdlBscTVR?=
 =?utf-8?B?aUtIcCtYYkQwd2tVL1dyTGZ2M2lyUmFYNW5uUFBSMys1bEd0eCs2NkEyc0g1?=
 =?utf-8?B?S3h3allyWEdxdFlVaWlmOVphVGhrelI1Mnc2bFN5RjgzT2E1USszalZUWXFt?=
 =?utf-8?B?bUZqS0YwYWtjdVgyS1RZQUhITU9MRUlSWDBuQmhGa2NXUHBZNi8vUVg4ZFAv?=
 =?utf-8?B?NzU5WWlidVV1QStMYUlIeEtldGtGckx6R2FFY25Xd3orYWMxT1AzQ2hiQytx?=
 =?utf-8?B?aUxLREpYdHFJRGRVcnFUNXNTT05lSDBLN1BmOTErWFNRWE8zR3NRMGNyOFBW?=
 =?utf-8?B?WDc1T0dDcnd5b05ZSExYU0J5anNENGZRbGlyd0pMNVRrTkw5eGFXWWlEcjc5?=
 =?utf-8?B?OUtENzZ1R0kwTUZSbkc2QzJGQU5MZE5jbm0yZDliY0NsRTJaZUdOWjdwNTNa?=
 =?utf-8?B?UkswV0FrdUVLZndBa2N6clRiN2JLakhtVXN4YXhBS3JyT1pFb2FJV3F0SzNj?=
 =?utf-8?B?eFRHbVJ1MjV5ZnJmTjJONGhnOHk0Y0NzQm1HQ0pxanBkNWdtdkwxRm9hMS8v?=
 =?utf-8?B?aDA2Y0c0K21CRSs5bENSUEd4aFNvam9OTkYvc0RiMTNPSjN2UzVnUUp2L09k?=
 =?utf-8?B?SnFja2NTMmRWNHJFV0xZMDlLbUJjRS8vYmhadEY3Q0t6OGxlb3AwTGpQczlj?=
 =?utf-8?B?YkhsQzJVYm54VjNNaWgzTnJTWG1nL3lZMUJvZlU1ejcyNC8zTVd0elZZWk5K?=
 =?utf-8?B?czJpQ2xRUmFMZG1pYnlsSVVNeHd4S1J2MTZ4cjQwRVAyZEM2TG1KZFJNczdO?=
 =?utf-8?B?RFg2SnQvRXhTUVdSS0I2c1Yzem5QakhQRGRFUGVmTDRIWWZLU1ZIRnJUNmdq?=
 =?utf-8?B?c0JKOTlBZlZYVkNBSzNlaHp1VDI5MzZydlRvWTk4YkhtbWNBRmE1YWEwSDUx?=
 =?utf-8?B?WGthRWZCSXhoeFZadTcrWlFiYVhMWlpGV09EYkdXWWZ4S3d2T3ROejh3TlZo?=
 =?utf-8?B?cmhCVlNzMmh2RGRlNWxFUm1Rb1dyQ2JjNUxxNkFnOXFhQ3RSQjQ0UXd1R0FS?=
 =?utf-8?B?ODdPWU5YY295d1Z0U0w3RUxUNStzNFM5R0hNTnh5VjNLYzFZY0R6K3lCcnQ0?=
 =?utf-8?B?THFOdCtmYWhvL1NyaHhoVTR2NWF4RElZOXpDRlNKZk1pY1R4SW15NlQxVERu?=
 =?utf-8?B?czdjcmJOUVhrc2FvWFdkVDJLN1hjNVc5REZmV3JhK2FabnE5RXJVN1pOYWpF?=
 =?utf-8?B?Z1NlNEx2TUFDc0R3dlZHR1NQQTlpM0xmeGYwR2MwQVA4aDRyUm1DT1MweHJ5?=
 =?utf-8?B?L1VDdzV4NDAycko5V2dmdkpjK1YzZ3ZhTjdNV3lnVUxlSHV2VTF4RUJBcFZ6?=
 =?utf-8?Q?5KQKTs7q5e3jOBTJ6JfkNtb6V?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 394e5fa2-37ae-4dea-237b-08dc436a5cd0
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2024 14:32:08.4110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 94oXA4gLmPJt4QWR9pxhpzLmGmoL+yUL8duHlG7Xe9CF+oEJOur/pvZMzJvhg1KMjlibPgabijwx5FcVqgIgow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5813

On 3/12/24 09:45, Tom Lendacky wrote:
> On 3/6/24 20:14, Zheyun Shen wrote:
>> On AMD CPUs without ensuring cache consistency, each memory page
>> reclamation in an SEV guest triggers a call to wbinvd_on_all_cpus(),
>> thereby affecting the performance of other programs on the host.
>>
>> Typically, an AMD server may have 128 cores or more, while the SEV guest
>> might only utilize 8 of these cores. Meanwhile, host can use qemu-affinity
>> to bind these 8 vCPUs to specific physical CPUs.
>>
>> Therefore, keeping a record of the physical core numbers each time a vCPU
>> runs can help avoid flushing the cache for all CPUs every time.
>>
>> Since the usage of sev_flush_asids() isn't tied to a single VM, we just
>> replace all wbinvd_on_all_cpus() with sev_do_wbinvd() except for that
>> in sev_flush_asids().
>>
>> Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
> 
> I'm unable to launch my SEV or SEV-ES guests with this patch (haven't 
> tried an SEV-SNP guest, yet). Qemu segfaults at launch.
> 
> I'll try to dig into what is happening, but not sure when I'll be able to 
> do that at the moment.

Looks like it's the use of get_cpu() without an associated put_cpu() when 
setting the cpumask. I think what you really want to use is just the cpu 
parameter that is passed into pre_sev_run().


> 

>>   void sev_free_vcpu(struct kvm_vcpu *vcpu)
>> @@ -2648,6 +2666,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
>>       sd->sev_vmcbs[asid] = svm->vmcb;
>>       svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
>>       vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
>> +    cpumask_set_cpu(get_cpu(), sev_get_wbinvd_dirty_mask(svm->vcpu.kvm));

Just use 'cpu' here....  ^

When I do that I'm able to boot an SEV and SEV-ES guest.

I'll wait for the next version, in case there are other changes, before 
running through our CI for more thorough testing than just a single boot.

Thanks,
Tom

>>   }
>>   #define GHCB_SCRATCH_AREA_LIMIT        (16ULL * PAGE_SIZE)

