Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391073573A8
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 19:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbhDGRy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 13:54:58 -0400
Received: from mail-bn8nam12on2081.outbound.protection.outlook.com ([40.107.237.81]:59873
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229769AbhDGRy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 13:54:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGclawDSZ4F/A5G02oloN8L29dqoCPzvdV4bko8vYN4VD917tGzplnNJHVv4CaDp1Ec+SASiEn418lgrjGz4sB+asEGI5/qn/rUbHbvy86IZrXe16WjK7hfEBVg/k4R+CxS70xWVQaVCEkiu1u6I/PocbbJ4Rzo3j4PTgaLCyDtNJMSs1pOw/Pi9nj9XY5r4uIS9pK8cOEA623EvHyxLL9RnSx6fzY9f5N9AL9aFnjwgsgxBnST+mdsWYAIWuu8PwZs0a15H7nCVNBwziJY2vfBoaPlfuwYCjVktFW4656qLmbkiEp7PLXtuAiMBQOQDJCTLCinAb4QwA7T9F+HxEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMseP361WD3mbbFFbmAhGSCyA5MWA8aV6GN7wjN88ew=;
 b=KHQhG9DC56OncamfgIs+/O4jZqlfuWdSwnRvJUZEzVHu21y+iQ8o8p6jUMKd7XYnA2thMEa+i2Iw9CYAB8otl69moinUC6cXdchCrJRohTB1JnByCGJ/YHYON5MUm6ciA/d5HkkGJsRWcKFJU8m+8YMN3MAqWsU4nqhBznGT8PP8bnyfkE39b9Mml5PWbG/xg2MZIkub65MzTVwsbPddPA2PuaxE1hES6G7L8sTbzc1345sMzS5qXmHTjabktU2fEh/SLjT/ysDWxPX9xShnxF1sGytfUid0medBzv4HEhKNghCarv2BH9LNY6Fdl+MLvOGupFHZPvDVp48nRUUIsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMseP361WD3mbbFFbmAhGSCyA5MWA8aV6GN7wjN88ew=;
 b=cwzY79KkK0+fmWeZAyCqiDW3RJMXFC/OqlQ0fzIHCE1RmUxGTTRY1KYAu0IsmxKfc8o5n/ag+J49ZGav+z2s893orn/8GBxbjNayZLIX1KztYj0fivAzFX8nh09/Y+CScdjbO6uF+SMcxVCLCd0GuKqXpV3RaX2vfPh8OTJGwYg=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB2469.namprd12.prod.outlook.com (2603:10b6:4:af::38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.28; Wed, 7 Apr 2021 17:54:44 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3999.034; Wed, 7 Apr 2021
 17:54:44 +0000
Subject: Re: [RFC Part1 PATCH 07/13] x86/compressed: register GHCB memory when
 SNP is active
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-8-brijesh.singh@amd.com>
 <20210407115959.GC25319@zn.tnic>
 <2453bacb-dce3-a9c2-f506-7dae7796ab7e@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <9a1c3de2-dce1-4b26-c91a-222e60ef599c@amd.com>
Date:   Wed, 7 Apr 2021 12:54:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <2453bacb-dce3-a9c2-f506-7dae7796ab7e@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0040.namprd11.prod.outlook.com
 (2603:10b6:806:d0::15) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0040.namprd11.prod.outlook.com (2603:10b6:806:d0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 17:54:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c793057b-cd20-4464-ecdc-08d8f9ee39f2
X-MS-TrafficTypeDiagnostic: DM5PR12MB2469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2469275C15CF47DC89993592EC759@DM5PR12MB2469.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I71xRg8lSlUTkc7Ez0IJFkaTrx+279XD2hLiGVvCwW6KZ1Y8DhVEnbBMgLETDFhNDpl/LiOkORb9XHT1plBPP0VwClSQbvkQWN+5RBgpc/LQIEAthHQSkOyEy8S15/+kpD7SS1XzEcoXt6jkYQAWbvvWk6cbBwaAPx0uxh45Q/B4+mQ+N9j0mUbcnHMFxCTeHw+YjzIYEA4X4J0gnnUcTLiC2Vghkku51ZsfeQNv1ia2GU9eROam0pMOPG1vNXWGfEd3KSJwNt4XisgJ5OavjuFgGi03dQSCxdWmvtP6DChvD6gBi1BW9VNzy5OG3tOUzbe7WzjRWuldyy4XSmx+181+ktzMseFUmGwnxeUZFt6YQxopA6J+GD8lRcz2IbtsHyrzq+7XfKDMwrtCXgL8ou8SptuFk74+RzXaCMtGP5FVVweukpuMnYE+Jr9ae66aDc/klx2/FSgeXB0EpcsetuPtmDBE94q8YKhmwsQx2Xpet2pmHivHKc7JgTWnHxPCbNsOiIaYRKOzPKrsrvUYrHck8Pl8gGs3ZAMuk0hF2BJ/9qXJlPUK0zaFyyliYNWCCqtYIcDGxNv0PUZWSgf94NyZP5IuYjQk4TGnXzcV1HmkvleGM7LtjvLA/E+lG+RA9lRytLpdAD//AN9AT5FSw90fHXGD87j4tTUcZ22gVLStsejoIMDSLvYe9Ee8/4kCLETlyiE8iWDEj3qRNlIMWCtUq0WPP/4NNdkmtcqunMigeRbl5L+QdXe0/GWtpvt5/eZaqmEGeByIr5ydwWZcWkDlF5dp67z+1sR9l3GPO6U70IiyEtRfTAjz/IdE+nhX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(54906003)(966005)(66556008)(66476007)(66946007)(7416002)(26005)(38100700001)(36756003)(45080400002)(6506007)(53546011)(31696002)(956004)(2616005)(110136005)(8936002)(5660300002)(186003)(6486002)(83380400001)(6512007)(478600001)(86362001)(31686004)(316002)(8676002)(2906002)(16526019)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NXpiYjA1cys5V2htcUIyWEh1YVdIcHhuUGFaT1BEb0pBVGFrMUx2My90dWlN?=
 =?utf-8?B?cHNveDJUUmhsWVNHakxpOWR3Mm1vZmdyeEd2NTMvMnRwMEJqaS9hbFFsc3JX?=
 =?utf-8?B?WGUxek01U1FpN1Y1UDNaeExhVjQ3TFd1dnhDV09IMkZqeEhKbDZkUklFaVVr?=
 =?utf-8?B?WUV6OFU0Tjh3bGZieUMyQWpxQTYrTDdLVy9EK1pSbU5vUTVEYzlSUlh1V2Zj?=
 =?utf-8?B?N3RZMGdoamp1ODJadWtmZm1UQTc3QVR4U2szR1AwUEtVek1PUDBVWXBuRHJw?=
 =?utf-8?B?bEh4TGY2WnYvMVB2L2JmZUJKdW9nUHR3QktGWS8xWWdNQlpSbzR4eFR3cHJZ?=
 =?utf-8?B?WVR2SWFIdFc5SjVGcEZPd1ZOZEhMcnVZNkxXVlV5YUtMcmdhdUxiR3MzRDFV?=
 =?utf-8?B?TjlsWGg5dEZTTW53bEZvaVJCQ2d1eGVnTXQxaWJwdjlBeWllSS9KdkJmVmhV?=
 =?utf-8?B?SVhRVS9JS3M1d2x1SkQvZlkxVGEzSVVYV09rYTl2ek43UjVteCs1K1E1NXd2?=
 =?utf-8?B?dTluY3JwL0dMZUxQSmsrQzVOVWoza3kzMENPVlVhbStxdURPazdFQUFad1Bq?=
 =?utf-8?B?QldUcS9zSkQ2UkJvWlN4QzRqL1hqenc5RXkyOE5FS2xvTVRZUWFQbHQ4Wm5J?=
 =?utf-8?B?eS9VWWVxbDFJWGhvbkE2UTJReXRBQWVPQWZ0RlJUeTk5K2xQTnhyV3gxSllV?=
 =?utf-8?B?dlpmeVQrWlhGaU00LzY2SFJvMHA2d21pbmo1RUlPa2lMOGx1c05EQzIyNisr?=
 =?utf-8?B?d0F2ZE8rK0JHbDJFRU8zNUc4ZkdHVTlCM2JjR2E1bjNIUndjclZpNWRrQnZX?=
 =?utf-8?B?aHlTTFhSWkZTcW9VYWt2OFA0eHlCbEJOS24zbTl0dDBrQytiSnFseU1mTG5i?=
 =?utf-8?B?QnM3eElWU3ZHdUVMOGpxNXVsVEMyalpCZXBqSE92MzdmZnFyUWdDTWppRU9W?=
 =?utf-8?B?OURWLzR2L1FLWmo0KzFMRElsL2VxVDZRSHNzQU1CcFY4TU0vSnpPWDVKRDRt?=
 =?utf-8?B?L2xQQjRtbDJoT1FGZWpIUGhUd3hRL2VxOVdSSE5FbmFOR2VjMWVFU0ppN2Rt?=
 =?utf-8?B?VUsrTndDNFduSzdaL2RwbTRJVktWVmVXNUdPTDNBazNGMWZRd0hjQ0tJa0FH?=
 =?utf-8?B?VW5rSXdWSTFVejBNNWxKY2VIQzRXNnJxTEZQSkUvVWpReGEyWW5aazZZZTBC?=
 =?utf-8?B?ZkkrM3ZYd3h0azgrbmJKRHp5Q0VMUkV2SDJaUzFWVjNiWnh3MG5DZ2QybXM3?=
 =?utf-8?B?SmVYczVTRnBLdzVUenpkdExBaWdKMTFaK2VYYjgwazJndno4MHBrdlhscUE2?=
 =?utf-8?B?a3FOR05IYm4xUFZ1aWdLa0FYR2VRdUcyQVRzblA2SUdwemJjNFNnUlBrNWFT?=
 =?utf-8?B?L1ZWbHF0L3NBM0p0NWJIb01QbDJLMUtraTgwV0xONGh6T2paUWhPbHo0Qnd0?=
 =?utf-8?B?NGJKSXdHMHhyZi9CaVdCUTBTeWR2N1k4SmdMR1hEQW1UcXREQ0ovd3Fnbk9p?=
 =?utf-8?B?ZWNXQnNhdXo2UlJoWUJkL0pZQ3F0Z2RaVUdqRFM0cGI3V1lsaWZDRUNNQm1p?=
 =?utf-8?B?ZkxKK1dxQUZNL0J6WGRHMkFEd2x4OWx1ZGhEV2RaRnJ1SGVEYUV5c1BWenl0?=
 =?utf-8?B?UkdKZUdjQUJYalEvZFFtVUZKYnQ4VEloSVdOMldnQjN0NVpXQVdKNWhwVGJj?=
 =?utf-8?B?a3MvTHFEQjZJN3g0TndRbU1USUpKRWJZdHExMlhHNjFjbWFvNVlaV1FQQ0Fv?=
 =?utf-8?Q?JmNuCm5sJYG6IAtUK6252ktPTCGJkUP8Sus2DOC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c793057b-cd20-4464-ecdc-08d8f9ee39f2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 17:54:44.5168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m+EEQaDR9dj/DWNwsgsMX4YLIrZ8ybd4uomcd9ZrU4qPGaKBoXXpENAffALuTZajiV31ahzGX4NvsRbE41l6xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2469
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/21 12:34 PM, Brijesh Singh wrote:
> 
> On 4/7/21 6:59 AM, Borislav Petkov wrote:
>> On Wed, Mar 24, 2021 at 11:44:18AM -0500, Brijesh Singh wrote:
>>> The SEV-SNP guest is required to perform GHCB GPA registration. This is
>> Why does it need to do that? Some additional security so as to not allow
>> changing the GHCB once it is established?
>>
>> I'm guessing that's enforced by the SNP fw and we cannot do that
>> retroactively for SEV...? Because it sounds like a nice little thing we
>> could do additionally.
> 
> The feature is part of the GHCB version 2 and is enforced by the
> hypervisor. I guess it can be extended for the ES. Since this feature
> was not available in GHCB version 1 (base ES) so it should be presented
> as an optional for the ES ?

GHCB GPA registration is only supported and required for SEV-SNP guests.
The final version of the spec documents that and should be published
within the next few days.

Thanks,
Tom

> 
> 
>>
>>> because the hypervisor may prefer that a guest use a consistent and/or
>>> specific GPA for the GHCB associated with a vCPU. For more information,
>>> see the GHCB specification section 2.5.2.
>> I think you mean
>>
>> "2.3.2 GHCB GPA Registration"
>>
>> Please use the section name too because that doc changes from time to
>> time.
>>
>> Also, you probably should update it here:
>>
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D206537&amp;data=04%7C01%7Cbrijesh.singh%40amd.com%7Ce8ae7574ecc742be6c1a08d8f9bcac94%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637533936070042328%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=NaHJ5R9Dfo%2FPnci%2B%2B6xK9ecpV0%2F%2FYbsdGl25%2BFj3TaU%3D&amp;reserved=0
>>
> 
> Yes, the section may have changed since I wrote the description. Noted.
> I will refer the section name.
> 
> 
>>> diff --git a/arch/x86/boot/compressed/sev-snp.c b/arch/x86/boot/compressed/sev-snp.c
>>> index 5c25103b0df1..a4c5e85699a7 100644
>>> --- a/arch/x86/boot/compressed/sev-snp.c
>>> +++ b/arch/x86/boot/compressed/sev-snp.c
>>> @@ -113,3 +113,29 @@ void sev_snp_set_page_shared(unsigned long paddr)
>>>  {
>>>  	sev_snp_set_page_private_shared(paddr, SNP_PAGE_STATE_SHARED);
>>>  }
>>> +
>>> +void sev_snp_register_ghcb(unsigned long paddr)
>> Right and let's prefix SNP-specific functions with "snp_" only so that
>> it is clear which is wcich when looking at the code.
>>
>>> +{
>>> +	u64 pfn = paddr >> PAGE_SHIFT;
>>> +	u64 old, val;
>>> +
>>> +	if (!sev_snp_enabled())
>>> +		return;
>>> +
>>> +	/* save the old GHCB MSR */
>>> +	old = sev_es_rd_ghcb_msr();
>>> +
>>> +	/* Issue VMGEXIT */
>> No need for that comment.
>>
>>> +	sev_es_wr_ghcb_msr(GHCB_REGISTER_GPA_REQ_VAL(pfn));
>>> +	VMGEXIT();
>>> +
>>> +	val = sev_es_rd_ghcb_msr();
>>> +
>>> +	/* If the response GPA is not ours then abort the guest */
>>> +	if ((GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_REGISTER_GPA_RESP) ||
>>> +	    (GHCB_REGISTER_GPA_RESP_VAL(val) != pfn))
>>> +		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
>> Yet another example where using a specific termination reason could help
>> with debugging guests. Looking at the GHCB spec, I hope GHCBData[23:16]
>> is big enough for all reasons. I'm sure it can be extended ofc ...
> 
> 
> Maybe we can request the GHCB version 3 to add the extended error code.
> 
> 
>> :-)
>>
>>> +	/* Restore the GHCB MSR value */
>>> +	sev_es_wr_ghcb_msr(old);
>>> +}
>>> diff --git a/arch/x86/include/asm/sev-snp.h b/arch/x86/include/asm/sev-snp.h
>>> index f514dad276f2..0523eb21abd7 100644
>>> --- a/arch/x86/include/asm/sev-snp.h
>>> +++ b/arch/x86/include/asm/sev-snp.h
>>> @@ -56,6 +56,13 @@ struct __packed snp_page_state_change {
>>>  	struct snp_page_state_entry entry[SNP_PAGE_STATE_CHANGE_MAX_ENTRY];
>>>  };
>>>  
>>> +/* GHCB GPA register */
>>> +#define GHCB_REGISTER_GPA_REQ	0x012UL
>>> +#define		GHCB_REGISTER_GPA_REQ_VAL(v)		(GHCB_REGISTER_GPA_REQ | ((v) << 12))
>>> +
>>> +#define GHCB_REGISTER_GPA_RESP	0x013UL
>> Let's append "UL" to the other request numbers for consistency.
>>
>> Thx.
>>
