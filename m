Return-Path: <kvm+bounces-14777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DCC218A6E2E
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 16:28:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 948FC281B55
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 14:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CC7F12DD95;
	Tue, 16 Apr 2024 14:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hN9U4pEL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2068.outbound.protection.outlook.com [40.107.212.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7E0132C36;
	Tue, 16 Apr 2024 14:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713277537; cv=fail; b=VaYIjwxDJGvQvQIT/DqojIM2JFCcGkxrccM+NjTVjwhvThoj2bHLQrEmMHvY+HWxZJHxepmxQRXU3yV+MpRvntlhpVg8ZDPNlE00gNAPoz/XdCzWXCyDUVczsEMpRDYAYELO3S/fMisUQOxkNBISpB7brYAyLhSSjHPMoFkwgrY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713277537; c=relaxed/simple;
	bh=SINcn+IWiUapG/JuKjRSFB3ciWs6abn1FmX9SC8WA5I=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=AYUc1Qr+UGF8NtYNYIYNVyjROP1P8EXhpFqwtJyONIDP47mZd5B69jGB1YrgGayepRy8wVytBba3AyVCKvm1ilq6EDcSyt8IC2rPddfcD2FuRcxJTE7+ItX+hsRxKkvq5yS3TJzkszAhbQAaTxtvwAvqb/8y11Pimnrz56DnBu0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hN9U4pEL; arc=fail smtp.client-ip=40.107.212.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CaMyHmr08roor3pp7WUljX8WZ0BPuOn+l5hTX+IANcORxnV8q86Jhw0Pmt4594b0qhfvnRh6sn9bzseNbR/sBthO29CuRekJj0lGNKeZux5MHBP9rA+7bhcC2FQYwNRK20Tk8J0uHhfI1ySiC7bV4MyA8lsP3SQB+k1JYGI48jP52xxO63BjCOhik8lFYpZJAiQQoFQoAvyGCF+4UQbr8704ENtjjl94+ZggSc4BFCYjOD0amEP3yAwy/8Y3vL25ta45jytRNDpoPwx4dJx9ZHyzv2q1gyCHHqcp/G4psLO9xxzH+prtIDI1ImpJYYRHDKBKylsPasePa5rB1P2Gwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wOeFlxviTMUT/VW2LboJqvhxAs+bBmfWBhWo79jkbq8=;
 b=VMJoCXK6+hKnlkYgImUyLcDUjD1dbPrmciRZLRXLgADXvRpr9PR2qgEdVtCGlYhjKc0k24ow/PdQhNixwjNvbfiUBideazyttN+cKJveU9z4MrkSe8FEgK8P2URMa8cb71fQcTFsyQDFrqXHgzfwo8zPYAfY8yV3UlXFLYmWik8RTFwql15LS30NS8oxh4dZjMDIqqfvZkUEKPc66FX/jZDRLYRG7umfLtl7PwlR2GGxjiv+NbOxf75Et/JMdAYnbV/2m2WwYHuCz4IZWAPg1akfHia4yl0xsnobD03qoNtP132surfRhJDRrs10dfkaEZZkjpTMXDBGEKNQqfYAzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wOeFlxviTMUT/VW2LboJqvhxAs+bBmfWBhWo79jkbq8=;
 b=hN9U4pELANIFKqV5yjkI2WmeS0gfz+kDtP4/lky3MrN2kd3Vkj84+QSST13PLltQ2mMqVz8xMJfiOBcgO7fA6uECn9wT03FDjF8A3qLNOwfOFfedU2T30Yqlui8UqF7Z+NtLt8yaJxIcDwcnwVHYmKT2kDqqhpa21QKj3en2GbU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by CY8PR12MB7706.namprd12.prod.outlook.com (2603:10b6:930:85::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 14:25:13 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%6]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 14:25:13 +0000
Message-ID: <758c876d-ff77-0633-7b3e-965d863d5a93@amd.com>
Date: Tue, 16 Apr 2024 09:25:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, Michael Roth <michael.roth@amd.com>,
 kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, hpa@zytor.com,
 ardb@kernel.org, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com,
 dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz,
 kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
 pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-19-michael.roth@amd.com>
 <67685ec7-ca61-43f1-8ecd-120ec137e93a@redhat.com>
 <CABgObfZNVR-VKst8dDFZ4gs_zSWE8NE2gj5-Y4TNh0AnBfti7w@mail.gmail.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v12 18/29] KVM: SEV: Use a VMSA physical address variable
 for populating VMCB
In-Reply-To: <CABgObfZNVR-VKst8dDFZ4gs_zSWE8NE2gj5-Y4TNh0AnBfti7w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::28) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|CY8PR12MB7706:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b11a470-3eaa-42dd-606a-08dc5e210752
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	bFr7YG6nJ4r5KgDaKBGuMHlVeBX4FytK6XOTsNaHPSLd+/uZaSVNJ6EBycadnYyyKsCweBzMX+7p0dToZVrgDkSgW8Q9xHX4Uh2/5EjbEJN88DAIKF/+BN2YkHXA026QegjX/53kjG1yZ5Ap+zbpO70+m28ISn/L8FPMnGgHSztMi9MH28gu0T6CpiL2gpI/6QF2HdZCM3slQleRwfvejXt95H/op44ZllRK0q5K0jzmBfh/hZmd4sbKgvtxMWPFQHZ1RqMNhaZBEmVoLeXfYEWj6DV/XlFNqLWiEgIeFacHmkTAUvhHsREsdGKZgQAd04BRnffAeAmjci4lB2Ot0T0Fx1/pyqosgqu4x4LwDQ6YR4gPOKoAvvYArtLPvHL8yn6lpuSnQvQq9ajmU5MjyrOKpKih4SOLkpaTP2sF0Ca4JpzFxYs+hc9Z8TiGYcDFLg65UPkN2woSjfj6W6TuC1ZAMJbnEqVkhPNdehBqw5EdbkB1UZKV0d1dsRUaXli3guVbZi3yhI2tG1LnjSJlIC9m55UkgHt7NfkQy0ak03Jl6RFWmbqJ9dLIVsDeMywJbf4k1dawQIb+P4mpEPq6lZ5DXVHXmRwCCAkut0Fs2c3a3xzkRmCI1AABMbH7Pf6E7mXNsukb9huI1YgSkt6jSFCp8hZQXSWXcUZpHXbaKbI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T2gwdHc1QXplbW1kUVVjNk5kNm1hSTNqTlp3dTF2WDR6bmNoTjNXZFVpZDdQ?=
 =?utf-8?B?TVlKcG5FaFlMN3NQSjJXNmFrbnRhazZmcXRHOU5xY0tmVXhXRWtxazVjby9q?=
 =?utf-8?B?N3dNRUpyVHRsOVhHd3FpbW5HcmVpdlFxL3p5a1UvbTlMY0tFUnIwVG1JL2Er?=
 =?utf-8?B?WUFOanBYUU55aFU0RlIrY0FZM1pxTU1GcVlwcW1wOHlkcllFQW4xaFBZV2sx?=
 =?utf-8?B?UmtvRk9wMHI5a1czRGs0WDNYbGdYWGpmemsxVDllUTdtRDVqUjIvdkMvdDNn?=
 =?utf-8?B?dFJVMXI0ZW9jOWZodUZmbVdoNVdHQVVKWVROaFpQWHl2S0tZa205RWNKS3RH?=
 =?utf-8?B?NjJUM0xCR0podi94YkVGdjhsYjI0ZFQ5NmtOUFlpSnFCdkl5NUZwaGxiYm1K?=
 =?utf-8?B?WUNNU1g3T2Q4bmlrUDd6VTYrTmJIbzVtbXgrdE1vQlNQSWpHK3FPK1kxd0R3?=
 =?utf-8?B?UGJIVGlRNXNDcllCNzRZSHBiL0JUWTM5TnFYZHFtMnNFSGlaNjJjaXQvcnlG?=
 =?utf-8?B?VGxqNW9JeUVXNmNsZTlEYU56Zm9jaktCTXRmUDY5UjY1Zi9xY09zck1HVThH?=
 =?utf-8?B?N1JuM0lYRm5tZldkMVVzWi9PS2o5UFhFbHhYT1hPeEpqWkxnV1h5cTUyVUNK?=
 =?utf-8?B?S1FqNWQ4bnJXU1dwOUxiYk41azB0LzYrUEc1UG1VR2ZoRnZYNml1SGowbmp4?=
 =?utf-8?B?bjVwbnJOQnA4WWtUWWlvZTJ4V1h4c2llbkFKRzd5SGh5L1VMb0I2cVdkOEVm?=
 =?utf-8?B?clNXTzBKYmttMGQvU3lBdFBwcDdYUGwzVGVzYWtDdWFGakdFZWVPMzZxL21n?=
 =?utf-8?B?c2NkRHdzMksvWGpMRk8zU1JpYnJoL2FvL1diSDR6TC9DS2Z1bSsxQllROU1s?=
 =?utf-8?B?cHpWNkk1UUhycHY3S1VZNmpVd1hpR29CRHV0eXRXSlFzekRzUDByVDNCRm1Y?=
 =?utf-8?B?RzR5V3JaSjhkZ2hXTFZIY3lFNjE3NU5vVlp6RG9EQVZkME40WkpVOUU3eFJk?=
 =?utf-8?B?YTIvbzJoaG1samhkV0hmOXB5MmpHZEZJNmFJMFA2NHVVVmkzKytDdGdWT2pH?=
 =?utf-8?B?d3dQaHM0UFJBWXBQd1lFdGp6c3JYR3MvNHdYUGJxZXRxZzZ2S2g2dldOMU94?=
 =?utf-8?B?V29OTEViNjI4MFpYMVp3dlBURXRRSUd6d3g2bW50NW9qTFRzQVNlbTl6Qk1j?=
 =?utf-8?B?Ykx4b3VOdllFclQ0bkhicDdVcU9GSnIxcFBRcHNXMk4zK0FpUXhjVmtxZDFj?=
 =?utf-8?B?WHRXL2htc004a3NtbU91dkJpWkpmeXR1NU0vN3JsRmpKNEZLVU8zQ3VMdHU0?=
 =?utf-8?B?VGlRSEFwd1VxZEVqYktVNVZxZ1FSblJIV1NQZU1LUDJTVFRmbFNKRytHWmZZ?=
 =?utf-8?B?SlB6U3J4ZTRoM2tpT29RejkxOVBtWlFlb2QySVpJVkVzampXeWZ5TGc1T0pC?=
 =?utf-8?B?TWl4S2dyN1FDa1FVRlpqUGlCTUk1Z1o5WSt3WmlUc1BSVllESTI4ZVU2SG9K?=
 =?utf-8?B?WG1NWVEvanNYQ280M2hFaEJhTTM4Q3B1dW5hYm1yTXJzZVhsbGFiNHg5bDRa?=
 =?utf-8?B?VkFiREh2WGtvVTIxOE5lQm5TMzU0WHU0WTNJQ3RJREU1a1NTeklwaEUzbXh6?=
 =?utf-8?B?R0F2NjIvM1dkOTg1R2VmZDhtZGtSUWxsN1REOENVREtlV0hvdnVja1l4MHVk?=
 =?utf-8?B?TTg2RGQwVXlOSlFCb1kyZEZIU09QVXBTWWR5NVVDTDhNRVdBeTkvUTdFMmRp?=
 =?utf-8?B?K3NQWEdpWHh2M2k5RlQ4MGU3T2JGYXR3RmgzV2kxNUN2NllrNFNKVmNhSHpP?=
 =?utf-8?B?ek14TDFoL01OaVZJUERiTW5xcXZyL1ZKd0ZDV1ltWVNBOUY3bDQyQStnV3VH?=
 =?utf-8?B?ZmVzZzEvd3Jxc0tWMEUzcVZiMHc0d2lwdXlPS1FSVVJRbXI0TWRnemJuYnhn?=
 =?utf-8?B?a3cyVmpobGtEdlV3a0xlQ1dJa010dklzMXJGbXBvRFlhcmFNY2NXQ1p6aDFF?=
 =?utf-8?B?b0htU0NydWVvSW50WXdobTVtMXhrMXZvT0d0emFzb2hVOFZjdW5RcHV3dnIy?=
 =?utf-8?B?VFhZVkhEQmdTazQwL2tnU0dtU2VZY3JXWm9DUW9ndVpybEdMajEyd01jRklW?=
 =?utf-8?Q?ecgwpSGOlUD0UYW+DfE5021do?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b11a470-3eaa-42dd-606a-08dc5e210752
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 14:25:13.0948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2kQI/y5vz/idGOLiBkB+EkKeiXbdEPOSDoCL41hiB1N5HpAkoTNHHyv0ggouHoO71MkASvYCh6s5fvtkaFbpZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7706

On 4/16/24 06:53, Paolo Bonzini wrote:
> On Sat, Mar 30, 2024 at 10:01 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 3/29/24 23:58, Michael Roth wrote:
>>> From: Tom Lendacky<thomas.lendacky@amd.com>
>>>
>>> In preparation to support SEV-SNP AP Creation, use a variable that holds
>>> the VMSA physical address rather than converting the virtual address.
>>> This will allow SEV-SNP AP Creation to set the new physical address that
>>> will be used should the vCPU reset path be taken.
>>>
>>> Signed-off-by: Tom Lendacky<thomas.lendacky@amd.com>
>>> Signed-off-by: Ashish Kalra<ashish.kalra@amd.com>
>>> Signed-off-by: Michael Roth<michael.roth@amd.com>
>>> ---
>>
>> I'll get back to this one after Easter, but it looks like Sean had some
>> objections at https://lore.kernel.org/lkml/ZeCqnq7dLcJI41O9@google.com/.
> 

Note that AP create is called multiple times per vCPU under OVMF with 
and added call by the kernel when booting the APs.

> So IIUC the gist of the solution here would be to replace
> 
>     /* Use the new VMSA */
>     svm->sev_es.vmsa_pa = pfn_to_hpa(pfn);
>     svm->vmcb->control.vmsa_pa = svm->sev_es.vmsa_pa;
> 
> with something like
> 
>     /* Use the new VMSA */
>     __free_page(virt_to_page(svm->sev_es.vmsa));

This should only be called for the page that KVM allocated during vCPU 
creation. After that, the VMSA page from an AP create is a guest page 
and shouldn't be freed by KVM.

>     svm->sev_es.vmsa = pfn_to_kaddr(pfn);
>     svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
> 
> and wrap the __free_page() in sev_free_vcpu() with "if
> (!svm->sev_es.snp_ap_create)".
> 
> This should remove the need for svm->sev_es.vmsa_pa. It is always
> equal to svm->vmcb->control.vmsa_pa anyway.

Yeah, a little bit of multiple VMPL support worked its way in there 
where the VMSA per VMPL level is maintained.

But I believe that Sean wants a separate KVM object per VMPL level, so 
that would disappear anyway (Joerg and I want to get on the PUCK 
schedule to talk about multi-VMPL level support soon.)

> 
> Also, it's possible to remove
> 
>     /*
>      * gmem pages aren't currently migratable, but if this ever
>      * changes then care should be taken to ensure
>      * svm->sev_es.vmsa_pa is pinned through some other means.
>      */
>     kvm_release_pfn_clean(pfn);

Removing this here will cause any previous guest VMSA page(s) to remain 
pinned, that's the reason for unpinning here. OVMF re-uses the VMSA, but 
that isn't a requirement for a firmware, and the kernel will create a 
new VMSA page.

> 
> if sev_free_vcpu() does
> 
>     if (svm->sev_es.snp_ap_create) {
>       __free_page(virt_to_page(svm->sev_es.vmsa));
>     } else {
>       put_page(virt_to_page(svm->sev_es.vmsa));
>     }
> 
> and while at it, please reverse the polarity of snp_ap_create and
> rename it to snp_ap_created.

The snp_ap_create flag gets cleared once the new VMSA is put in place, 
it doesn't remain. So the flag usage will have to be altered in order 
for this function to work properly.

Thanks,
Tom

> 
> Paolo
> 

