Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1034441BAF3
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 01:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243267AbhI1XXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 19:23:14 -0400
Received: from mail-mw2nam08on2071.outbound.protection.outlook.com ([40.107.101.71]:30049
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243241AbhI1XXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 19:23:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbXczw0Wg8bOuOax2Cu9JbkKxrNH29JG0v3WCrYcg0rISqf5yp2hhU6A4FL8TINatith98C6DjucvtLVNv4zzaCeM4Q8/ePas+sHtm3Oh3UyjgZn5ASIYHTCUtiVdR1wfWTiq+a8mDzME21rKPo4l4FkwjE7tnPP91DfrpfYfTi3kaw2064wAkrzGA9LkLO41QVNlnAPveGSe8Q7PkmgATSPO0FqzsLLYFAtbHNe1WsWIf+po9F+rYo/XbRZDa2mPV/vmzhVOQ8qEYtgVBPERCGj+WapFxEKm826gLwtmT0dXiG8cQmOEfVy5XeytlD8DCC9Oui1kh73QN3zlck24Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SqgvvHDv72zBwxwQ5icsMurcABlk7In9P56JZUzf9t4=;
 b=ZvqVcni5KKcAZu1JWY/GrLrN8obPOmAzBuOivzJ4RsRQrlimjIB5uIxDd20i20uwRQcYWLDWH7NQzltjtObWbQc5v5TdSMbbJCmziF7iTyHM4JVDiV+PSI4f6gopluYbrTicNavGooiUs63Ubf8Nm0q0DLeLv7H1AvZuHRiORG/3defTLFlfmccPi8ZM8pCA7TIqzMX96oGKFVYmEIQtSilcqhI9d3ZtxaPmwwdszD1qG+Xn3TdjUUsoeXIAoXtNqM7OzxJXzloO2ewdrvQ64RyIIUnHOxZkZ37AhkzqKqXCSpIxsAXQOiC8ssk4W/HNJtoYovJGbK1pf15yi3LksQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqgvvHDv72zBwxwQ5icsMurcABlk7In9P56JZUzf9t4=;
 b=gG2jMqZbVK8+0H0Y5PqOY0k+xWCkwleLKqgp4Bn7xAGAB7f0vxc725ZTJ3G138vO7crP3FAdeFpzjACkIswXY/sPmnM3FbxqEEUdeigmP7GMyDoS3JfmcsBE8zMPi7dhz1pcQLZlkgJc7GqH1jnpa7mj7AbnyF9A2TDw4ri8R+k=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4511.namprd12.prod.outlook.com (2603:10b6:806:95::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13; Tue, 28 Sep
 2021 23:21:31 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 23:21:31 +0000
Subject: Re: [PATCH Part2 v5 38/45] KVM: SVM: Add support to handle Page State
 Change VMGEXIT
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-39-brijesh.singh@amd.com> <YVLro9lWPguN7Wkv@work-vm>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <061b8a79-6530-6d3f-6a15-48e676e9ac71@amd.com>
Date:   Tue, 28 Sep 2021 18:20:51 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <YVLro9lWPguN7Wkv@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: CH2PR05CA0001.namprd05.prod.outlook.com (2603:10b6:610::14)
 To SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (8.46.75.75) by CH2PR05CA0001.namprd05.prod.outlook.com (2603:10b6:610::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 28 Sep 2021 23:21:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ccaf3d6-6c8e-4c10-0236-08d982d6b42b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB451167C7FE261F11CE7C1867E5A89@SA0PR12MB4511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZvWH3xMbMBpx+boVSKXMaB4uAgW2AQIneEw/RS6z4lkqLx2dFUZY2y3Xs87TY+wFJNSSJ/WdavnCItiqtngHUOkBFXWfRwVvu01fuyNtnga5pPz1N8/qZUHodzTCg5j+1q8/9BUELaFle0PALh13TnDi5B9lT9q4fAgiFOosEEcBIpmzHtEquO+FHcPhjRuSBc+TDWI9IBUahFrx6tVXxohW2x71gvhhN+WTh/M2tp5tp8HiVt2CL3QF/jFA3lK/xst1I2zN5vERZ3Kvf96Uch/ZDmSh9MF82oh6bwPjVNoePNuei5P/4BewK9frfmjiRv1Rlw3YXVacTUx61lwMFItCLA1IHSU2ixkJPSN0i6Oc1qQFqyZkLmVEfLEos9AiaHOMNgPsZnhOR9jFU0EhXbFpOD4LQ0D6YZDKNh1ZhikQj66e3QI2GjnUFQ1Jawh24gbEfosHOUSXSQBqIVGau4niCItkRKQgJ+Vzu3aG6kiRMd/Vlvx6y+g6ge1KxEVgHKzbd+s7vTs2GDI4UlpHb6HIwgClDW+rLy1DAEtA2sgJ70ilbh7QoXmunr7WJ5Zt37tcQkj0t6/qDjyD3MZsQra7PA6A6IFscYR8yUFaExP1MnzmjHOpln0trQm/qWRBPmXlZVzwW4CdQxE5fCk354UCoiqzlJBL6LOViJvefoJjWl0s8XWF7IMS12CAZplNbFS/9RFhHv0lfsrZY2lFzWTqdsVXin6DyjY5dw8Lz78lCSqeWlGUTj4DfNoGBBpSXPX7wNPgyM7l+hSmfxgF8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(6666004)(6916009)(86362001)(26005)(6506007)(6486002)(186003)(4326008)(2616005)(53546011)(36756003)(44832011)(7416002)(7406005)(956004)(5660300002)(38100700002)(83380400001)(508600001)(2906002)(6512007)(31696002)(38350700002)(8936002)(54906003)(52116002)(8676002)(66556008)(66476007)(66946007)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDFtdElyZHd5NG9ZODVYNllzOWVkT1FQNm9jZWc2b01OZHdEdWh4eFFjT2E5?=
 =?utf-8?B?N1VtVnphc2NHd0FJM2lkeGZLMW5vdFRpQlFPYlV6K0tLQk5OMm5SV3FER1pU?=
 =?utf-8?B?UmJHV0FUOHV4QzRxZEIxY3hHbm1pQWJiUzQyL0twQ3hMZGwzWlN2Z2p1b2Qv?=
 =?utf-8?B?MFJGSzVtZnFXZVZzMGZYbnhseTdUYU1sTkRad0FxRDI1bW1ZYlRaUFg2ZVBk?=
 =?utf-8?B?UjFUZy82b0VGcHZzT2NDVm5TNklWa2VhWHlXZVFINUhJUTRncW9ZSitLSHQz?=
 =?utf-8?B?b3loNGdpL05INWZIancwYzNNUXFmK3plY2U4eWU0blV6dEhvU3IyRG5xNDlL?=
 =?utf-8?B?ZlF2ellsdnFJOHdsWElqNEJhR0JyUXBEK3lOVjdVVGxjVW9Vbk1XRjBvMUMx?=
 =?utf-8?B?cFdlVUU5MFBIU2RYU3NGc1ZKakRHR2grbEl4UHd0Q0x5RUVNVDMyMjUxN2xF?=
 =?utf-8?B?eGhuajJtZU93Vlp1THMyYW9iK3M5MVcwV0hWVDFhRWg5eCtRbENJd1l1UUJl?=
 =?utf-8?B?Z0N1Zk83NmZ2VGwzMkRDTUhLT212aWRMblFUdGtTR1p4ejNlYURsSjBDWEdZ?=
 =?utf-8?B?cG8zWXMvT0Y4U1gvVFNHTEpPQTF2ZlZZYWRCL1BTaHVYMmxXWHBSQmxFV1R0?=
 =?utf-8?B?QnZvdTNCaHVXT0ZoLzFkakNvZmtIYUxIcStwK3JzMjN5aDAzcHNmTDA4UGhp?=
 =?utf-8?B?cXBDenJDUUxPOVdDamRLTWp0S1NybEZhYTY1RldyekNhS3ZucE1KcGlFOFNv?=
 =?utf-8?B?TGdwNGhxRzNBaFFnUDdOaEZwSklZT1d5NDliR1JYbENZb0FYYkU0UVl6T2Vi?=
 =?utf-8?B?ekp3ZmJFN2lpcXpaQU5GaWM0ZlgrckNSOUVoYyt1SlJRVzFtcFppdkIzbnF4?=
 =?utf-8?B?Y1pVdkhmajdwZlJXVis2am1rTFFkemdVWVVFWWNGUFhYNDJZbWg1MTIybGh6?=
 =?utf-8?B?TTJWUHp2L3JaeFVVcjdleGNzbVFuT0ViOGJsOVVTZmFPRWJaSmpsV3hrakJw?=
 =?utf-8?B?dTVlWDZnUWZOdXRLZmkyNGV6UVF5MitqRUk1RytNUDhIL0VEZHBjaUJyOFhV?=
 =?utf-8?B?OUhGK0dSS2V1OG0xUHEvV1hZTG10UzJYMGJxdnVDQWt3OHlRRHhIT0JZMHVU?=
 =?utf-8?B?SUtpS2lyZVo0enF0Y2FRQW55SVhOYW1KUVBhQSt5SzRKL0lpaTB1b1V4N1M4?=
 =?utf-8?B?dkpYYXhyR21SOUoyY0k0cHNYYWZJMTRCZjMvaGg1eE1QOFZLZmdEdzZLZjJQ?=
 =?utf-8?B?THFaUGFHQTJXeFphMzR2TzlmU20vb3oxT1NJNkVWNnZUdVY3SDduMHZ0cGxi?=
 =?utf-8?B?eXBCSCtmdUFYMmsvbWpVZHovc2U2c1VyUjFCVDJleUhtRlpDZ2hyaG9GTElR?=
 =?utf-8?B?NTZMa3hOL29ycEV1aWlobkhsVktYTjJxdDZtS3o1WTBvbDVHV1A1YzRjRzNO?=
 =?utf-8?B?Q2JBVnNGZHVCek85ek1mZG1zejhNeHVkTHJOd0ZNdzBOSVhyMGVPTHdFdUZ0?=
 =?utf-8?B?TlNyMVE1Ky9ONUFtUGRGdlA2ZWpibnQzdXhFd1ZtYmZRWUZZWjdaTXJEQ3h0?=
 =?utf-8?B?SlhFY3M3ZVpsKzl4THdoZVpiMTI4WG9hckVxUXdNaS9BS3pLTW5FRFh1S3dk?=
 =?utf-8?B?SkliWkdjZDJzOUtWcEh4bS9qeHB4UHZBdUxadjFmQmFLTm5ZL2k4ZnViMzB4?=
 =?utf-8?B?bDAxWHlnb1lodHlIY1hrSk5ueVQzcDh5Z2FVbHd1a1lKSWdzUTNEeGhmbzlt?=
 =?utf-8?Q?PDGmlxp6BdYvPYRndxKhit9gG48Vbt/d/3mCeUt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ccaf3d6-6c8e-4c10-0236-08d982d6b42b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 23:21:30.9204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sEQz2w6TeMNjF9dUucIgfvLSjecz+EC5n8QpxbLNQ2i5q+Wl9aMotfyHDtkt60wYekmn2PiZbzdFIJqnvRDYbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/28/21 5:17 AM, Dr. David Alan Gilbert wrote:
> * Brijesh Singh (brijesh.singh@amd.com) wrote:
>> SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
>> table to be private or shared using the Page State Change NAE event
>> as defined in the GHCB specification version 2.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  arch/x86/include/asm/sev-common.h |  7 +++
>>  arch/x86/kvm/svm/sev.c            | 82 +++++++++++++++++++++++++++++--
>>  2 files changed, 84 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
>> index 4980f77aa1d5..5ee30bb2cdb8 100644
>> --- a/arch/x86/include/asm/sev-common.h
>> +++ b/arch/x86/include/asm/sev-common.h
>> @@ -126,6 +126,13 @@ enum psc_op {
>>  /* SNP Page State Change NAE event */
>>  #define VMGEXIT_PSC_MAX_ENTRY		253
>>  
>> +/* The page state change hdr structure in not valid */
>> +#define PSC_INVALID_HDR			1
>> +/* The hdr.cur_entry or hdr.end_entry is not valid */
>> +#define PSC_INVALID_ENTRY		2
>> +/* Page state change encountered undefined error */
>> +#define PSC_UNDEF_ERR			3
>> +
>>  struct psc_hdr {
>>  	u16 cur_entry;
>>  	u16 end_entry;
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 6d9483ec91ab..0de85ed63e9b 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -2731,6 +2731,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm, u64 *exit_code)
>>  	case SVM_VMGEXIT_AP_JUMP_TABLE:
>>  	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>>  	case SVM_VMGEXIT_HV_FEATURES:
>> +	case SVM_VMGEXIT_PSC:
>>  		break;
>>  	default:
>>  		goto vmgexit_err;
>> @@ -3004,13 +3005,13 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
>>  		 */
>>  		rc = snp_check_and_build_npt(vcpu, gpa, level);
>>  		if (rc)
>> -			return -EINVAL;
>> +			return PSC_UNDEF_ERR;
>>  
>>  		if (op == SNP_PAGE_STATE_PRIVATE) {
>>  			hva_t hva;
>>  
>>  			if (snp_gpa_to_hva(kvm, gpa, &hva))
>> -				return -EINVAL;
>> +				return PSC_UNDEF_ERR;
>>  
>>  			/*
>>  			 * Verify that the hva range is registered. This enforcement is
>> @@ -3022,7 +3023,7 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
>>  			rc = is_hva_registered(kvm, hva, page_level_size(level));
>>  			mutex_unlock(&kvm->lock);
>>  			if (!rc)
>> -				return -EINVAL;
>> +				return PSC_UNDEF_ERR;
>>  
>>  			/*
>>  			 * Mark the userspace range unmerable before adding the pages
>> @@ -3032,7 +3033,7 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
>>  			rc = snp_mark_unmergable(kvm, hva, page_level_size(level));
>>  			mmap_write_unlock(kvm->mm);
>>  			if (rc)
>> -				return -EINVAL;
>> +				return PSC_UNDEF_ERR;
>>  		}
>>  
>>  		write_lock(&kvm->mmu_lock);
>> @@ -3062,8 +3063,11 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
>>  		case SNP_PAGE_STATE_PRIVATE:
>>  			rc = rmp_make_private(pfn, gpa, level, sev->asid, false);
>>  			break;
>> +		case SNP_PAGE_STATE_PSMASH:
>> +		case SNP_PAGE_STATE_UNSMASH:
>> +			/* TODO: Add support to handle it */
>>  		default:
>> -			rc = -EINVAL;
>> +			rc = PSC_INVALID_ENTRY;
>>  			break;
>>  		}
>>  
>> @@ -3081,6 +3085,65 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
>>  	return 0;
>>  }
>>  
>> +static inline unsigned long map_to_psc_vmgexit_code(int rc)
>> +{
>> +	switch (rc) {
>> +	case PSC_INVALID_HDR:
>> +		return ((1ul << 32) | 1);
>> +	case PSC_INVALID_ENTRY:
>> +		return ((1ul << 32) | 2);
>> +	case RMPUPDATE_FAIL_OVERLAP:
>> +		return ((3ul << 32) | 2);
>> +	default: return (4ul << 32);
>> +	}
> Are these the values defined in 56421 section 4.1.6 ?
> If so, that says:
>   SW_EXITINFO2[63:32] == 0x00000100
>       The hypervisor encountered some other error situation and was not able to complete the
>       request identified by page_state_change_header.cur_entry. It is left to the guest to decide how
>       to proceed in this situation.
>
> so it looks like the default should be 0x100 rather than 4?

Ah good catch, it should be 0x100. I will fix it.


> (It's a shame they're all magical constants, it would be nice if the
> standard have them names)

In early RFC's I had a macros to build the error code but based on
feedback's went with this function with open coded values.

thanks


