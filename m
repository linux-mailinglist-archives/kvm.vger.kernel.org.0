Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E89358337
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 14:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhDHMZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 08:25:57 -0400
Received: from mail-mw2nam12on2071.outbound.protection.outlook.com ([40.107.244.71]:30432
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229741AbhDHMZ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 08:25:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qnv80uftBEnubCxLNbIQeRKfbaqA3Z7xTZ4BVjSFIxSft6coCXzHtsCRNrFdGEEU3hS+C2vtw8iPSlnCTrIQx9yt6Hx8nZIonSYQxCoYyHAHii5BpTBJnUY2m2O+Su6D1hl/LAUj9eiQVrRwt5HdOJxitHPYlqaWi+Ajw7Y7JrXopwEzHwu+n0D4yGuUqD2X2KEB9Qf+E2kZM2/E31lIreqOe1Ek5CQAoaEH6HwGoPpTq7OBHzz37CahihouZ5VEqw4mAh5c32kfjFpygfCF52QvU2cFWDD6Hp8fi5KWMNaSfZu8Qxe8MFoL4ba30VLB08EpGE5w1FvYMECpJZct1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FL5eegDxuH5BDDXiqv5TzljkOyayJPej5r8Wd6cAfTk=;
 b=M1H+s8/2o63QbfG+SzSZ0KIcChhh6SuKDArj+t1jZOX9hpfmT7JDmAqRL6ZO+P+f+mp+OaOmdjFodi4GgjXDcTpKgjcunE3SZ65PhNbyBcpVRvLka9QJXQkLSn0yzzs58YkB2n6In8vRdsDacQKuvD7T77t/NLn7EhAYB1LtgIJBCF8TqjcXtH7w647vnVGiYJQrNHSvBy4S7Wt9h5+R+3+lCIJYdIrAlVNvV9knrrHZsPoHJ0/POoo16oXLwj4tHjEQbe+boGPlOkd7o7j12bpk/4GLeI0wOF0s70QnMP+Lzyh72845xqi743GWKkC8T8VYsEQydLjHDDzsfcFPXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FL5eegDxuH5BDDXiqv5TzljkOyayJPej5r8Wd6cAfTk=;
 b=j8ku/v7bVlKSZQMlqJGS/s3sd2IIbYeYxEhZx2rffrOv2P3tQNoHiZ+eDG5S47vsA4diqSIPQzZKKO0F4Tb53OqI2Kh9MGUGgfaX7srXh2LpPnnYIxxvQpp/VLuZXjmINqgwnEI/mAvRDxJ7zY8McLNH7iNNGJAfDiSIMb7J5LE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB4672.namprd12.prod.outlook.com (2603:10b6:805:12::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.20; Thu, 8 Apr
 2021 12:25:40 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4020.017; Thu, 8 Apr 2021
 12:25:40 +0000
Cc:     brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, ak@linux.intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 09/13] x86/kernel: add support to validate
 memory in early enc attribute change
To:     Borislav Petkov <bp@alien8.de>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-10-brijesh.singh@amd.com>
 <20210408114049.GI10192@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <d1031153-4d66-e464-1be7-f7d4f9a61e3d@amd.com>
Date:   Thu, 8 Apr 2021 07:25:37 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <20210408114049.GI10192@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN6PR16CA0041.namprd16.prod.outlook.com
 (2603:10b6:805:ca::18) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN6PR16CA0041.namprd16.prod.outlook.com (2603:10b6:805:ca::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Thu, 8 Apr 2021 12:25:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 587f1b52-6b74-457c-98da-08d8fa896bdf
X-MS-TrafficTypeDiagnostic: SN6PR12MB4672:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4672BCE14A5C26E6FC2F5DABE5749@SN6PR12MB4672.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W4sU5J191LVxOZJVoa6DfuREmmmGFcjFtHMsyrTXFLdasefj9AwG2eUl1jsQsvdmVOcGrDfCt9c7Pf56o70NgWKrj/T1ozU5ZzqZs6sOP4jYOjcJ2GMXEpyXFY29Mq0+1xB7QpkSPkNvsutlEgeHjxgA+V7WuCbb9jKVAEg0AP6AhIQoKiHP6ea7f6WVKVJmqV48xlvaJWnGg054V/lSWuQMPFGnnGRy9o1HAV+GFtsK4/fGGU6TiBf3Cdzm5Awi8W8C6WkbhFRPv2euwuTP/jJV+/2wA40gU7/t4FUJbmsynj+BgpdobbSbFRVsFL5wME9t5PvoNpfHqvAQS5uCGyOllWgWWycPIDkZOEyIYj9T12PIxqnWjNUWAeWK82gK6MMKMaQy2lNs/LaZglczJh7dja/RDUcKKvAOWNi1M5JVBD9FAq1jQNgp7U2bvpamNzD/VsIdjtGZC7UO66kmBGwMi6bEkmuCWgT45Kr7b4S4oVnArY8FdvM0JPdvxqHVbbyW2Uv5cI1+EJiajq9yzk6c+2lHKEeyqq5xWiMre3HWRIVQJKuTG0pssjJAbJXg3yiaGvCcfjNXfajzct0sVOiwN3PE20O0EcAUgmpIMq3RL5F1/E7Eg4Kz5HrzdMff/W74wqk9nPNwANXP9J+dGHLyzR0WJVAQHNpE3YM4eEyaPuTVAcMJ05WSEAl7u5KF807wo4k8FOyxaSJrnzJtcR8EPC1x+SPPL8jktpxoTvNsXpU6f1/G1Dcz29LSvf6m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(8676002)(2616005)(38350700001)(31696002)(15650500001)(316002)(83380400001)(86362001)(44832011)(54906003)(6916009)(52116002)(26005)(7416002)(4326008)(16526019)(186003)(6506007)(8936002)(53546011)(66476007)(66556008)(66946007)(956004)(6512007)(36756003)(478600001)(2906002)(6486002)(31686004)(5660300002)(38100700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K1JMZVZWaWxoVnlZSXBNT1NwUVlSc24yL24yY1EzNUJNRnVtd3Jna2Z2MXVw?=
 =?utf-8?B?RjJqdWloWXdYTXVIR3VMK1J2UjlUYjczblJrMmR5OEY0MmJBWVY4Q3ZtTGhk?=
 =?utf-8?B?SnEzSXBPS1A1TnlVbitMV25nN2NCcFdGclRJY2xHWlNpak9lbGVEakxzSGgz?=
 =?utf-8?B?clovcnZOVDN4RFV3SW16OHRJUW1RcUVMcUUxL3ViZGpwU1h0eFVIQ0RDUWJ1?=
 =?utf-8?B?UkZnUkhhZ1NBUC9DRDU3ZjVCSlN2UHZIWVljWFRXeWppQ3VUeFgvNGtyVjVr?=
 =?utf-8?B?Q1pYOWVLSnNEdVgrUjJoMWZlcm92eDJIYm00d0svN0JtcVJzUFlYT1RBeU5O?=
 =?utf-8?B?UlVudUE4VUErS1JkZFVlMnhmYnlEamVRT2lRRW1JWEJZM2szdGJmYjQxRFov?=
 =?utf-8?B?NlpsVEtlWm40alJWbHE0SG1sTExCYXpKQUZYSEtYWXFTRk1aUXlrbDJaR1pL?=
 =?utf-8?B?RjkyZ1NScGlpRStPOVRndldFKzlkWHhxV1pFeHRrbU8wYlhpdkhuOGlUTDBD?=
 =?utf-8?B?ZGJRbEROKzBSbUdLVms3ZlFsaE1QdDhHSzlucFVrQXh2YVB2dm9rcndRRUZN?=
 =?utf-8?B?QTFIY1M4Nm1zUVlxRmFpR0xaSXRWZ2ZMK21ZajNtVXFFeDcxMFM0MDlyRDUr?=
 =?utf-8?B?aEcxbzBzNkZHRVRHdFcyMjFsd3hSTk94THc4RHVTcHMrdFVia3RxcnpZQStL?=
 =?utf-8?B?Y0NyQlVDbDJ3QUh1dnhMN2ZKTXZPREw1SlJ5dmk0aUJUellQQmxOL2J2VGx6?=
 =?utf-8?B?bXNjMHZTcTNlb1hBYmY5cnpTT2UrQkIwemRkUno5UUJvM0ZYbENzQWJCRHZv?=
 =?utf-8?B?dVZUNTN5SzlwMDQrd1dSTkNiamkyOU03U3NKeTlRSUNDMThUNWF6czFBV0gy?=
 =?utf-8?B?aERBbm5sMEFaSE9zZmdBUVpxSjRrdmNHdVk2L0dFZWlBMDlEL0RrMVNmME5B?=
 =?utf-8?B?ZmpzaE5MR3hINWdaSzJBVUJQWFhSSjczanlIcFdtbzdEVGkxVEl3SkhveGhN?=
 =?utf-8?B?aDhOZGs5ME5xZldUZW5EY2JheW9LbWlFTUg0QWRsVWlzbDRHcmsxWk9oVU8w?=
 =?utf-8?B?UjRzbmdIVzRscHduVWdmMjNCRi91Y1l1dDF5WFVXL08zbTEyMDZ5N0pLcUEr?=
 =?utf-8?B?bHlqeDZhZDZSVmVWLzhjMzNkcWNteDBCSnFDeVhpbUNJWFkyQUp2UGRrczdJ?=
 =?utf-8?B?YWVDQk8vV3pDalpwRUJqbzNOaU4vVjVJdFF5ekhlRTVqR3ZvK1o3aUdpbW1J?=
 =?utf-8?B?cDRLa0dwU3laMGlpOTh4VnFIR2VzTHJLNVFETnFkU21MVGhCVXRZb095SmQv?=
 =?utf-8?B?MXRUd00vMExpMnVhWUtVbHRGd2laaHJrbFBRSXdLWllvcHRWd0xkUTV5YzR6?=
 =?utf-8?B?L1gyVXR4KzVsYlU1MlBHYlhSaTFMcWdVa08zRVBISWE5UjBLTXNYYUxKU09o?=
 =?utf-8?B?VFdPNmtYZzV0TnF0ZE5hanJGa1prdWJVVnVpSUJvUkJPM28rVXFHejlwTWRw?=
 =?utf-8?B?Q29IU1Y1Vy9ka0ZkZEFkdzN6THVaODZlODdDVlJ5QlNrUEs4N0ZBdkZiUzVW?=
 =?utf-8?B?dHJIWXRsMHJpWGJNUzZicDRJSm1vYWIzamdiZlNPT2ZueXdyU1BVZDFOd2Ji?=
 =?utf-8?B?d1lqRk5ncjhMMHJzZ3VvSWN1OGl0UHZtM2lacWlUQ2prb0tTdUZkM0g4TmFa?=
 =?utf-8?B?OEVOV3BYMVk1L2k3d2kxY3U0dkxac21kenNJbGhDZFU4NFR4Um1nSm9ld0Ux?=
 =?utf-8?Q?vuW5mi8XjnKgFn2z8gi6Nzer5wgujFa3d8wfDWW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 587f1b52-6b74-457c-98da-08d8fa896bdf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 12:25:40.1993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c9IwDI4/QsFK55jGS4hBAEe2PJZ70hNSleWyaVuZ4r7nygduG+dr8eedlpLX/4L/20DNNpBNpFxzQnzB1FHaiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4672
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/8/21 6:40 AM, Borislav Petkov wrote:
> On Wed, Mar 24, 2021 at 11:44:20AM -0500, Brijesh Singh wrote:
>> @@ -63,6 +63,10 @@ struct __packed snp_page_state_change {
>>  #define GHCB_REGISTER_GPA_RESP	0x013UL
>>  #define		GHCB_REGISTER_GPA_RESP_VAL(val)		((val) >> 12)
>>  
>> +/* Macro to convert the x86 page level to the RMP level and vice versa */
>> +#define X86_RMP_PG_LEVEL(level)	(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
>> +#define RMP_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
> Please add those with the patch which uses them for the first time.
>
> Also, it seems to me the names should be
>
> X86_TO_RMP_PG_LEVEL
> RMP_TO_X86_PG_LEVEL
>
> ...

Noted.

>> @@ -56,3 +56,108 @@ void sev_snp_register_ghcb(unsigned long paddr)
>>  	/* Restore the GHCB MSR value */
>>  	sev_es_wr_ghcb_msr(old);
>>  }
>> +
>> +static void sev_snp_issue_pvalidate(unsigned long vaddr, unsigned int npages, bool validate)
> pvalidate_pages() I guess.

Noted.

>
>> +{
>> +	unsigned long eflags, vaddr_end, vaddr_next;
>> +	int rc;
>> +
>> +	vaddr = vaddr & PAGE_MASK;
>> +	vaddr_end = vaddr + (npages << PAGE_SHIFT);
>> +
>> +	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
> Yuck, that vaddr_next gets initialized at the end of the loop. How about
> using a while loop here instead?
>
> 	while (vaddr < vaddr_end) {
>
> 		...
>
> 		vaddr += PAGE_SIZE;
> 	}
>
> then you don't need vaddr_next at all. Ditto for all the other loops in
> this patch which iterate over pages.
Yes, I will switch to use a while loop() in next rev.
>
>> +		rc = __pvalidate(vaddr, RMP_PG_SIZE_4K, validate, &eflags);
> So this function gets only 4K pages to pvalidate?

The early routines uses the GHCB MSR protocol for the validation. The
GHCB MSR protocol supports 4K only. The early routine can be called
before the GHCB is established.


>
>> +
> ^ Superfluous newline.
Noted.
>> +		if (rc) {
>> +			pr_err("Failed to validate address 0x%lx ret %d\n", vaddr, rc);
> You can combine the pr_err and dump_stack() below into a WARN() here:
>
> 		WARN(rc, ...);
Noted.
>> +			goto e_fail;
>> +		}
>> +
>> +		/* Check for the double validation condition */
>> +		if (eflags & X86_EFLAGS_CF) {
>> +			pr_err("Double %salidation detected (address 0x%lx)\n",
>> +					validate ? "v" : "inv", vaddr);
>> +			goto e_fail;
>> +		}
> As before - this should be communicated by a special retval from
> __pvalidate().
Yes.
>
>> +
>> +		vaddr_next = vaddr + PAGE_SIZE;
>> +	}
>> +
>> +	return;
>> +
>> +e_fail:
>> +	/* Dump stack for the debugging purpose */
>> +	dump_stack();
>> +
>> +	/* Ask to terminate the guest */
>> +	sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
> Another termination reason to #define.
>
>> +}
>> +
>> +static void __init early_snp_set_page_state(unsigned long paddr, unsigned int npages, int op)
>> +{
>> +	unsigned long paddr_end, paddr_next;
>> +	u64 old, val;
>> +
>> +	paddr = paddr & PAGE_MASK;
>> +	paddr_end = paddr + (npages << PAGE_SHIFT);
>> +
>> +	/* save the old GHCB MSR */
>> +	old = sev_es_rd_ghcb_msr();
>> +
>> +	for (; paddr < paddr_end; paddr = paddr_next) {
>> +
>> +		/*
>> +		 * Use the MSR protocol VMGEXIT to request the page state change. We use the MSR
>> +		 * protocol VMGEXIT because in early boot we may not have the full GHCB setup
>> +		 * yet.
>> +		 */
>> +		sev_es_wr_ghcb_msr(GHCB_SNP_PAGE_STATE_REQ_GFN(paddr >> PAGE_SHIFT, op));
>> +		VMGEXIT();
> Yeah, I know we don't always strictly adhere to 80 columns but there's
> no real need not to fit that in 80 cols here so please shorten names and
> comments. Ditto for the rest.
Noted.
>
>> +
>> +		val = sev_es_rd_ghcb_msr();
>> +
>> +		/* Read the response, if the page state change failed then terminate the guest. */
>> +		if (GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SNP_PAGE_STATE_CHANGE_RESP)
>> +			sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
> if (...)
> 	goto fail;
>
> and add that fail label at the end so that all the error handling path
> is out of the way.
Noted.
>
>> +
>> +		if (GHCB_SNP_PAGE_STATE_RESP_VAL(val) != 0) {
> s/!= 0//
Noted.
>
>> +			pr_err("Failed to change page state to '%s' paddr 0x%lx error 0x%llx\n",
>> +					op == SNP_PAGE_STATE_PRIVATE ? "private" : "shared",
>> +					paddr, GHCB_SNP_PAGE_STATE_RESP_VAL(val));
>> +
>> +			/* Dump stack for the debugging purpose */
>> +			dump_stack();
> WARN as above.
Noted.
>
>> @@ -49,6 +50,27 @@ bool sev_enabled __section(".data");
>>  /* Buffer used for early in-place encryption by BSP, no locking needed */
>>  static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
>>  
>> +/*
>> + * When SNP is active, this routine changes the page state from private to shared before
>> + * copying the data from the source to destination and restore after the copy. This is required
>> + * because the source address is mapped as decrypted by the caller of the routine.
>> + */
>> +static inline void __init snp_aware_memcpy(void *dst, void *src, size_t sz,
>> +					   unsigned long paddr, bool dec)
> snp_memcpy() simply.
Noted.
>
>> +{
>> +	unsigned long npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
>> +
>> +	/* If the paddr need to accessed decrypted, make the page shared before memcpy. */
> *needs*
>
>> +	if (sev_snp_active() && dec)
> Flip that test so that you don't have it twice in the code:
>
> 	if (!sev_snp_active()) {
> 		memcpy(dst, src, sz);
> 	} else {
> 		...
> 	}
>
>
I will look into it. thanks
