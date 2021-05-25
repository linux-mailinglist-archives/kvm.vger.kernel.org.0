Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A0B3903E2
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 16:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbhEYO36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 10:29:58 -0400
Received: from mail-bn8nam12on2074.outbound.protection.outlook.com ([40.107.237.74]:6817
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233406AbhEYO3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 10:29:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCvKo82zYZ46TcHioqWsKLr0lscBqfuhhpxXB+15lA1p1rbhD9D0jsEWdhUA4LPdZrdENb61BvfD/4T6ZTDVZkoocqTZPNjobERBNXitd5YC7kzOxr19dnz28Wooqx6GiI05HJyq3TM7c9QE7tv7qN3EynBBPPG82yeMZCK8k8g1KvOU4ZnaktZZxXOhe6Jje0q/Evc+V7Sx7Fet6hS5kSUH12zQDEIlPLGIi4ktizEXlCYuSJmCe//LM2Z1Mmh8yhtYoQTlm8/DgNhnGO0KpXumzlDO7/MgSTBHMNfxLIqkRELO31zJ/DUwRl95qIfsdh25BAjc2lOJryCU9k/2zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLTMvAib4a8kKEdBMGygJWhxvhdqX51lBmaK1YVZQz4=;
 b=frDB1Eu86Hgqg6XYVh51ON5wmE6HgGKvgcxj26atGnYXU4keTcDhRh7CVQLsHP7rDAxrmW+O+lT98YvEqJnE2XWbzGPQ2Zqf5outwAwgwNOHaP00Z4CeqDs+nNPfndQLhblYqhIq4wZ/WfNyyoDr7W8yUp0DnB3TuX9iJe0owJehqTWlvXmHf6XVGHCKNT3UQmeJPSE115cps9T23UzuBkCfUh99OwBsfN6iCU5XMGvGG5fDVXmfZQHGJCfWp9ozftU0IKHzre1p81MS0lXAAsxuVx/CSG+eVnWMH57oA60qRmCIIq+SEzXKGrhmXTaEerxvHm5ggkVRLm65z7aVIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLTMvAib4a8kKEdBMGygJWhxvhdqX51lBmaK1YVZQz4=;
 b=yQ9/KPzheoL6U9NnbRMoxVo8As5JD2C3BG6GLAIeWv5hHwJ1BpML+1Kx4VJuBqU/dK7DfVu7FcHk+ShLM19MXzuNiX1whO3+XYD2+H6s2fVoLevpDT2gaFO2B6pN+nrVruc3p/EvfliVIYOo4xD9JT7ULpuXPsSYbvXQ5c1q3u0=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2414.namprd12.prod.outlook.com (2603:10b6:802:2e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Tue, 25 May
 2021 14:28:18 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4150.023; Tue, 25 May 2021
 14:28:17 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 13/20] x86/sev: Register GHCB memory when
 SEV-SNP is active
To:     Borislav Petkov <bp@alien8.de>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-14-brijesh.singh@amd.com> <YKzbfwD6nHL7ChcJ@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <b15cd25b-ee69-237d-9044-84fba2cf4bb2@amd.com>
Date:   Tue, 25 May 2021 09:28:14 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YKzbfwD6nHL7ChcJ@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA0PR11CA0209.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::34) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA0PR11CA0209.namprd11.prod.outlook.com (2603:10b6:806:1bc::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 25 May 2021 14:28:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eff7b9eb-9389-4b85-f1ba-08d91f8956bf
X-MS-TrafficTypeDiagnostic: SN1PR12MB2414:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB241475FC5D328B374E006187E5259@SN1PR12MB2414.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ekntJhSH76Pq2OfNRXBs7VaKzbAHyv0/ORyj74RHXBSsH8sGkRsMenK0CevcOqkoNn8FSGeAPG4XqLYnSwci0BhXNBTZMfT4yocSX0MbzQuP4poJ3DmdP+XtINkv9GVOI7TG3DD7SIP0+XUPQqYD1hBlPGzwZZr72/0VUIwrB9vjStWEyX6e+Z0Z0lezcDxsUv9Evj8WvzUrlJrtnVwOmE+JOPD6ulO2Pv+w4bzRNXSvhQFf0SOZu/qnENKDo6jBlZu+LfeiU4D3KjHW5E3zMa/NMH74cx1dh3+xktp56WtB/quq9OkgjEa7blwXmuSrLc83L3zVxOu5+/336TqdTd+TBU3SmgCJH2udANe5jD+IT77gaZ2R4yLxZdciiQ3SReWc4P2gmRYB7pCIUIT/uVEa68AqtATUFL7gOfWH8keEmk4FWYmoDlE4T0uVdkZ5IQ6hevTiHQsFVDP30gvX4vXrsHcOV2luRlIdPCnDgO3sAnvu69RvVsPmMTj4KYM2OwlkcKkxTHJ6l/4zy1MYscUuY6NaOKdVtF1UdEReS0rIJCBWg1bXP0k1iaIazWwCFfXymeDT73w629i6o5fFt/A09A9HhHy4KyERAeULMp1EqKjUUL0X2UxKSNPMOpGWxOnoB02lKwrajGzPK04mYuthR8GrKjGcISz8xN1+eR4alMOEECjGXNwI1mvbVr6W+beUIwrdSDzCh1NVQmNIEMFwZxDYbvz8q83lVmMjxGc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(8936002)(16526019)(4326008)(186003)(6512007)(38350700002)(38100700002)(66946007)(31696002)(66476007)(66556008)(2616005)(2906002)(956004)(86362001)(8676002)(53546011)(26005)(6506007)(7416002)(6486002)(36756003)(316002)(478600001)(52116002)(44832011)(5660300002)(31686004)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cGpBWThva2didUZWcUZQSTd2b1NrZWhTbENzL1lWRC9TTFhzdzRKQmtsRml5?=
 =?utf-8?B?amM0citiTjlzcnBXQk90d2RMQjVWbHJFRUp5aDRCZ3NUeU5Xc3VkekdsUEZt?=
 =?utf-8?B?bXhwNEFZRTBkamxQZ2xFbG9RQW42aHpXU1pVS3EvRHhhNTJJSDVBOEpJUjJC?=
 =?utf-8?B?K2xiMjZ3K05DUW84NW9CVmQ5dnpPUnpFRWgycEMzb1FQK3lTTU1BVjYrRCtH?=
 =?utf-8?B?WC9UUCtDNlZ3NFlNV1g0VlVWVEd6TzBKQ2czcWFucTBvMlFYTzN2WGwxRWRS?=
 =?utf-8?B?azNuVDlpZW9YaTZteExLTmJJcC9FOHRWcGV1VTk3L3lBVUlWTFgvc0VId0lB?=
 =?utf-8?B?N1VidFRXTFBLelR0aGFyQjZTRlBxaGNmNHdkVFlDclN4MDNsNU5aNE9MWFp4?=
 =?utf-8?B?Y0tnVVhHNlY5UHFxdkpRWWpuZVFRY0hNb1N2akEyZTBFdUVza2Q1VUJtSHZp?=
 =?utf-8?B?elVWdlJnSytHSTlWY09ZZlZ6NkJJb29FTTAzSW1WZldwOHNVUUQ0Kyt2dDhI?=
 =?utf-8?B?QWV1ZlViL21YQjgwY0NSNmJaTXcrNFcwclR5ZEVNVVlUc1EwUk1lb2M4YXhG?=
 =?utf-8?B?RjcwdmhKaHNqYnMyMXY4cVhKYmlwV2dXcUdNcmZVeEZJdGllU0s3cG9sSWVp?=
 =?utf-8?B?K3ZQdW12MjVXZGp0SXFJWHZJaE15aDVuSWVtRmsvMlFRMzlLY0IwNVdtVGQ1?=
 =?utf-8?B?YW1vY0M5cm14QmYvZGlnWkVsQkx5TTQ5K0hnS3pxeS8yUEwwbVkrZFA0TW41?=
 =?utf-8?B?QnF3MGNUKzhHSGpCay9FTUhwbXhUeXlySnJNMHdWeVgzUWJLaEU0aWVPWlVB?=
 =?utf-8?B?Q25KZldzTXpFSGpZcDFpcXBYU2JNTCtnWVU1S1AycGl6dytqQ2pRNWhDU1dN?=
 =?utf-8?B?Ylkzc2dUNUhpK2w1b3RSK3FYTTRIRmlwUGI2cTBFRUZjZ29wbDBOekJZeUFC?=
 =?utf-8?B?SllVTXRtekVxT3FaUnIxRnR5bTd3K0E3UVZKZzJwZ29xZm5YZEpkNE9MaE1m?=
 =?utf-8?B?SmlPdzE0NTZZaFFKMDgxL0hMOVRrcTV3NmNiRERSWERjdWRYMG1pNU52M0tw?=
 =?utf-8?B?MURkUmhheHZMUjJ0SDRESkVWamY4WnFhUFdIeEN6NlFHQ2dlYVYyMm02Q1FQ?=
 =?utf-8?B?M0JtcHVOVThJN2xiSDV2WXNrSjhyYUtUc1BQTEJocnRod3F1amFkaGkvbEt6?=
 =?utf-8?B?aHpiVlF0SVBqR09oUEx4ZjFNQ3VGRis2NnQ0MEhHN1B5cit5WnNLamJJNjlw?=
 =?utf-8?B?R0E3dExEMWw0L2RVcTdsWDA5bU1NWGtuSkhSZHBQaTE5QXE1UkIzNytJNXQz?=
 =?utf-8?B?emZVdUJTV1UxMUZUZXZnZC9Sd2E4VUc1cUlpSG5IL3VrcE5wR2xHa3JsNzcy?=
 =?utf-8?B?NjQydGpLY29CbU1vbWk0N0lKNzdJckpkemVCdlAvZ0FwdHFoTzBsWm5ZVFRo?=
 =?utf-8?B?VGY4bnc4MTljNjRMcEUwd2czT0dSd0hRK0JIRE93NHFBRS9RZzRkUE9pdkE1?=
 =?utf-8?B?amRNemgzcTFlU04yUFgxR3FnV2JNVGxjV2ZqUkg5UFhtRCt5eHRxd3NrQmVW?=
 =?utf-8?B?djBhSnl2OGRqb1lvaWR2bmJSc2UxNDRHZkFEUFlmc0p2OVdFUU9WTG0rSDZI?=
 =?utf-8?B?VzY4QXNnRU1kcm1aNWNCWDNsc3RnNGQxZ0RVUjFDQVlzL29FRTdhUEM3TnJy?=
 =?utf-8?B?TGlld3plSy9HMHRrMmlKN21tL2dqaEowK1N0dTk5Y1pEaUlBcUtoMGZtZEJG?=
 =?utf-8?Q?xQkH2KZHXhMM4bdHf2YoLhq/RMwJU30IaQgYocE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eff7b9eb-9389-4b85-f1ba-08d91f8956bf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 14:28:17.8085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1B5TwVDfXPmIc7L4Mu+rQLreIkcvffP6xJQEOUcwnr4dIl/XFMAUxjot6Am/Fz6Dgo3tYVdgieWp+TRO7xJutA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2414
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/25/21 6:11 AM, Borislav Petkov wrote:
> On Fri, Apr 30, 2021 at 07:16:09AM -0500, Brijesh Singh wrote:
>> The SEV-SNP guest is required to perform GHCB GPA registration. This is
>> because the hypervisor may prefer that a guest use a consistent and/or
>> specific GPA for the GHCB associated with a vCPU. For more information,
>> see the GHCB specification section GHCB GPA Registration.
>>
>> During the boot, init_ghcb() allocates a per-cpu GHCB page. On very first
>> VC exception, the exception handler switch to using the per-cpu GHCB page
>> allocated during the init_ghcb(). The GHCB page must be registered in
>> the current vcpu context.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  arch/x86/kernel/sev.c | 21 +++++++++++++++++++++
>>  1 file changed, 21 insertions(+)
>>
>> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
>> index 8c8c939a1754..e6819f170ec4 100644
>> --- a/arch/x86/kernel/sev.c
>> +++ b/arch/x86/kernel/sev.c
>> @@ -88,6 +88,13 @@ struct sev_es_runtime_data {
>>  	 * is currently unsupported in SEV-ES guests.
>>  	 */
>>  	unsigned long dr7;
>> +
>> +	/*
>> +	 * SEV-SNP requires that the GHCB must be registered before using it.
>> +	 * The flag below will indicate whether the GHCB is registered, if its
>> +	 * not registered then sev_es_get_ghcb() will perform the registration.
>> +	 */
>> +	bool snp_ghcb_registered;
>>  };
>>  
>>  struct ghcb_state {
>> @@ -100,6 +107,9 @@ DEFINE_STATIC_KEY_FALSE(sev_es_enable_key);
>>  /* Needed in vc_early_forward_exception */
>>  void do_early_exception(struct pt_regs *regs, int trapnr);
>>  
>> +/* Defined in sev-shared.c */
>> +static void snp_register_ghcb(unsigned long paddr);
> Can we get rid of those forward declarations pls? Due to sev-shared.c
> this file is starting to spawn those and that's ugly.
>
> Either through a code reorg or even defining a sev-internal.h header
> which contains all those so that they don't pollute the code?

Okay, I will see what I can do to avoid the forward declarations.


> Thx.
>
>> +
>>  static void __init setup_vc_stacks(int cpu)
>>  {
>>  	struct sev_es_runtime_data *data;
>> @@ -218,6 +228,12 @@ static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
>>  		data->ghcb_active = true;
>>  	}
>>  
>> +	/* SEV-SNP guest requires that GHCB must be registered before using it. */
>> +	if (sev_snp_active() && !data->snp_ghcb_registered) {
>> +		snp_register_ghcb(__pa(ghcb));
>> +		data->snp_ghcb_registered = true;
>> +	}
> More missed review from last time:
>
> "This needs to be set to true in the function itself, in the success
> case."
>
> Can you please be more careful and go through all review comments so
> that I don't have to do the same work twice?

I am not ignoring your valuable feedback; I am sorry if I came across
like that.

In this particular case, the snp_register_ghcb() is shared between the
decompress and main kernel. The variable data->snp_ghcb_registered is
not visible in the decompressed path, so I choose not to set it to true
inside the function itself.


> Thx.
>
