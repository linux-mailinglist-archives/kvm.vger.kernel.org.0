Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290CA37AED8
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 20:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbhEKSzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 14:55:05 -0400
Received: from mail-mw2nam10on2082.outbound.protection.outlook.com ([40.107.94.82]:8576
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231561AbhEKSzE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 14:55:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aq9YPViisIQ0dhVmbbDovHXjYBBzq+8OU8VuctUmHzTLxJFmG3Hzqcf2xQwbMlDXowcY0Nh+gldFAyoS7ft/qrg01Xk+a9hocv/EqCpvsYDDjuZgSWVwNkD1xWwyyC+3U4zF01nfHB6GS464GUWsQGXNwBroxJOapd0j85EF2PQftR0la0tA+SRVOztavofNy1Va0DWrB0KjbE9lZi39RmKvwF8E2gLuDtP3moGNT5rTtuBuOymbuWSyTTyWSSrjtlPVF40rtgVkegqKWuKQE3KqLOQleqBmhzAPw00SENApdRktiM21BgMPY7dcAjhha6tBFzxlAr1LWBp5/+/ZIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GeKG0xAhxhWsHEINP989ZIDGD+Vj5jiBChnnZosbOTM=;
 b=bGag2gI6cEkN2S4BS1GSyZczYPQNKU5P7IFr8s0VcDyT37+1xd9u8Z/fKY609wiZiR4SKIbj7SqFANTRwkLtx9yNTP9opOPgqxnoqZZHjHHsUVB+klExR2+tWW2PW+YYFH1XpYO/7SDJbaDExKAdfPCc39mpr5SG/HC0BT6aUyQ8jmoKkUOZggZ3jhizcBpGvVVcqLIYpq80mBbTHAkQw9pUqeKBJjcuQg7wKolrVA83f7Lpo6A5tBJeFNuIh2jr3WM93Vu/H2jmgIImz85fRaFW6WP7YF4ZJpVN8VNyBQ72z9Lls23oQKVh+rUEz86pkFeEVhDLuCVEVMw7UlAJ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GeKG0xAhxhWsHEINP989ZIDGD+Vj5jiBChnnZosbOTM=;
 b=UEGtDjfBXinvkY5CkvEX4rsdPkYohOTVH65ezh7/294FuFxwAemmVUD5YVNbk6smznQDEYasfs/eU3FCO0fei+eqsU6IdKkDRhh/8GzZNpm0JJEu2BL9Co0KF3RhmZAYcPTdRrlK8fPs6wJL54Q6l37DIpKKwPed2ql0f5CzhvQ=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4429.namprd12.prod.outlook.com (2603:10b6:806:73::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Tue, 11 May
 2021 18:53:55 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4129.025; Tue, 11 May 2021
 18:53:55 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 03/20] x86/sev: Add support for hypervisor
 feature VMGEXIT
To:     Borislav Petkov <bp@alien8.de>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-4-brijesh.singh@amd.com> <YJpWAY+ayATSn6nN@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <bb512f58-be1d-d6ae-41e3-0fc95a01a95d@amd.com>
Date:   Tue, 11 May 2021 13:53:53 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YJpWAY+ayATSn6nN@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0401CA0015.namprd04.prod.outlook.com
 (2603:10b6:803:21::25) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0401CA0015.namprd04.prod.outlook.com (2603:10b6:803:21::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 11 May 2021 18:53:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 552524f4-301c-456a-9b91-08d914ae2098
X-MS-TrafficTypeDiagnostic: SA0PR12MB4429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4429F20E6CF2DB1AE1AB1192E5539@SA0PR12MB4429.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VIyHrH2dPwCIrIkAPVaijB4o31cb1KlzH7lhR2M8bsLwCKC3EIi6LojttUO5MxBx47kFdlZKkb+4AGq4XdSDMQwYUWcLyegyr4fXUCc9RoBadA332RNY664HeDvbWbHJ5rPL6m+NX9k+v6WfhoUNt6GuG0mAddVBAbcD972eCRmUIVrPcbuALOIvkdjJkZrT6TuufXs4DMgLM40b5fLHoTf0ZfbNBxZdAdpHFL95TJNQeAKvz59LWjmvRWXGEH8W+f1bltnlC0Wk6/RzDsMLnoAIvPmHlI8dBno3KY79GqUtWM6/bMr9p1MMJVwhh1C19YWkwiz3xvD1v4vBqHJi5dsQxWVlUiDWk5uINzpxQplZKW7CSj+oj/3kOzcKaxxEyLFtkTfDto9RkN/7VzvWEFhPfPOlPdVPr6H12j+I/Fa24Xv0ov25amDhXwjkWjpYwSBg25aIpa3B4x5SO7160nwlEjSKPdRklsWznqrQrP+H856jWjySzPvTkS7Dd4BJI5fvrl12qH9Jf6ruykXAn2Knp8Gn3SStRGIKRXlLJtnmPywU3UpRlmFpwnBe2hBM9VU3mW3agxKbx7yl4Ad7KobujOmztkf/m19uOX22LPXMIc+PFiKlDv1XQXJVTmmi20B6WlldKjGGV4FwSbbr5w90bIv2yslgavfxSNeNJelOLmt+j4UW2bhPK2J4a7/Jwy4ex/LAr1++wioqdMW6ATBRwji2SzxoqvHzXVi2bQw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(8676002)(16526019)(186003)(8936002)(6506007)(53546011)(6486002)(36756003)(31696002)(478600001)(52116002)(66476007)(38100700002)(44832011)(6512007)(66556008)(6916009)(26005)(5660300002)(956004)(4326008)(38350700002)(31686004)(7416002)(2616005)(86362001)(2906002)(83380400001)(316002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d1NhYVUvZmgyOVJRSDRhd2RCajNvOEtTYkRmRTNBZ2p5Ylg2RlNPMGs2eWQ2?=
 =?utf-8?B?SEtadk03dVFsQmdaVXQ5Tm5rM0JLQUdGcGNZUTcwUndVZjdNd0NKNUdyNmVa?=
 =?utf-8?B?MVd6N3BzUmZScms3dUhpZUd4dEVUS0VzNURCak1scTlRUE8rdHJUSDkraXU3?=
 =?utf-8?B?V1ZUdUJqZUUxSXlHVzBwbVo0a1FqT09DY04wM3B1aENGSG0wRCtwUGl5Z0dy?=
 =?utf-8?B?ZU04cTlzUUxaNlZrK3k5SHprSHRadG5scE9hNytlcE5EbGZITWVhSFFLODEz?=
 =?utf-8?B?UktCdXdGczZsWDNadnpkaS8veUJsbVhpWTNDL2E0Q2h4cFNMbzZvUjBlU1k4?=
 =?utf-8?B?TUhOVlJTeHo2K2dKTnVZK0tyU0cvdjBWc0lxdmVZUnpLS2hiMm1raXJEcjk3?=
 =?utf-8?B?RHJuSjRBK3JiWmhSa2VQamtJclYyZm1BM29KelJRYTRkQ3cvYlM5YmMrc2RD?=
 =?utf-8?B?MEhabWlBc29kbDcxS1dteUUvOHhrRXYyZ0h6b0FmQTZVZUFDbENxTG52WjZn?=
 =?utf-8?B?NUxHbWduMGNiZVdsbmpHMTlJc0RveGM4Vld4aUFGUWR6UEJRSE0rWlByN3Rw?=
 =?utf-8?B?UTFvWGN3UHJHenFqUk0rc3NDcWVwVjU1bTkxcU9QZ2JtWHdsSmxEb0wzVDNK?=
 =?utf-8?B?V2ZpS3hRM3J4Q1ZXdUVTZExPS1FXUHZoZEJRVk9kdHRzQW1zN0JoaGZndXE3?=
 =?utf-8?B?dG1SSGdKMzZIclJWeTV0OEsrVDhPVExKVmNJRHRkVjZMK1NadlJxbmsvR0ox?=
 =?utf-8?B?a2lLOVVsVG1CTkZLWEh0d2YwdmJlNVcvOFV6SitGb3hpc3V5VUg3OU1tRWhD?=
 =?utf-8?B?R296Sy9JR1YyaE0yeVNFVkdRdk9MSHZrL2ExS2ZPMytnRGV3QzhabklKRHlC?=
 =?utf-8?B?NXBCNmJhMmFuY2RtcDlGTmxhbXBCU1lvN3JTMG92ZmhTdm85WmgrTG1CTnoy?=
 =?utf-8?B?c1BnRkJFZVJicWt1N1NnaGJqcWw4Z3JyVjlTell0YkNsdDdyUkRwWVVFMVVs?=
 =?utf-8?B?emh0VlBnQktIL2F3enI2ZHRTNmV1VGFUSnEyS0VaVklEdlN6dVVVWG0rMzZv?=
 =?utf-8?B?NmZNd2xpdXpCMXhmaW90SVo2WThqdjhUMHh2RGp3NE1nbHdvQjluUmNGd1lD?=
 =?utf-8?B?QUtHTEZrdXNLYTl2N05PbkxGRzE5Y1JSeFRlQlQ2dHREWGg2TDZLNWU0Q0xS?=
 =?utf-8?B?ekljVTRxZmE5bmxRMUVrakxRblFzTW5JSFlSTURCaG92Qm5nMFprVndkLzA0?=
 =?utf-8?B?WWFOSk1OdGZHcUkrVHlzV0YwRjZOOFBMNUdySVRzRDhsaHFodjZidmRGaksw?=
 =?utf-8?B?OE9YTGRReUJIaGQvcTdOK0habzdta04wc2Z4amRNQVEyWHRNSndNSzhBZzZZ?=
 =?utf-8?B?YnE2SEczNjRzVjB5K1lra3RKMVVHcytERUtoZXJ0NnpaaHR6NEdVbUdXVC9D?=
 =?utf-8?B?bS8vTzNpQ0ozNHZGdUxWQ3A3eDBLcU9EYmR3QWV3Nk5tNHN0WFlMenBUMjJJ?=
 =?utf-8?B?eDBIYUNRNjZya0Q2RlFhaFlVT1ZkQldMSjRHM21CbkZTbXl0QzdSdC93a01P?=
 =?utf-8?B?TDI1aXM3K1ZSS0JvbThwQlYweisraTA0VitRc1pCUXpoVkJmRXlFcWxBV3lJ?=
 =?utf-8?B?aTlSakN5UDNMOG9xNWREN29zS0RPSEtQMm5yTlF6WWpwdFVDNFNTT2dIMkpY?=
 =?utf-8?B?dWZEZFhVVmpQb3RJTjJNZmJsT0dyRThYMmdsSk5ER1JyVEZhZDFVRWRnT0dD?=
 =?utf-8?Q?aBBczQ5cV5lZ7kIXOr0HBC3njNtc8DBOuCp7WGe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 552524f4-301c-456a-9b91-08d914ae2098
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 18:53:55.4882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mIxRG/C8GsjU2z+d0QWZq6BoiFkn4kLHlbi/9nszO3y5g5ewYongLsXI/vVTTTDcE0/WC2EyF492X1yLulw4vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4429
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/11/21 5:01 AM, Borislav Petkov wrote:
> On Fri, Apr 30, 2021 at 07:15:59AM -0500, Brijesh Singh wrote:
>> Version 2 of GHCB specification introduced advertisement of a features
>> that are supported by the hypervisor. Define the GHCB MSR protocol and NAE
>> for the hypervisor feature request and query the feature during the GHCB
>> protocol negotitation. See the GHCB specification for more details.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  arch/x86/include/asm/sev-common.h | 17 +++++++++++++++++
>>  arch/x86/include/uapi/asm/svm.h   |  2 ++
>>  arch/x86/kernel/sev-shared.c      | 24 ++++++++++++++++++++++++
>>  3 files changed, 43 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
>> index 9f1b66090a4c..8142e247d8da 100644
>> --- a/arch/x86/include/asm/sev-common.h
>> +++ b/arch/x86/include/asm/sev-common.h
>> @@ -51,6 +51,22 @@
>>  #define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
>>  #define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	0xfffffffffffff
>>  
>> +/* GHCB Hypervisor Feature Request */
>> +#define GHCB_MSR_HV_FEATURES_REQ	0x080
>> +#define GHCB_MSR_HV_FEATURES_RESP	0x081
>> +#define GHCB_MSR_HV_FEATURES_POS	12
>> +#define GHCB_MSR_HV_FEATURES_MASK	0xfffffffffffffUL
>> +#define GHCB_MSR_HV_FEATURES_RESP_VAL(v)	\
>> +	(((v) >> GHCB_MSR_HV_FEATURES_POS) & GHCB_MSR_HV_FEATURES_MASK)
>> +
>> +#define GHCB_HV_FEATURES_SNP		BIT_ULL(0)
>> +#define GHCB_HV_FEATURES_SNP_AP_CREATION			\
>> +		(BIT_ULL(1) | GHCB_HV_FEATURES_SNP)
>> +#define GHCB_HV_FEATURES_SNP_RESTRICTED_INJECTION		\
>> +		(BIT_ULL(2) | GHCB_HV_FEATURES_SNP_AP_CREATION)
>> +#define GHCB_HV_FEATURES_SNP_RESTRICTED_INJECTION_TIMER		\
>> +		(BIT_ULL(3) | GHCB_HV_FEATURES_SNP_RESTRICTED_INJECTION)
> Please add those in the patches which use them - not in bulk here.
>
> And GHCB_HV_FEATURES_SNP_RESTRICTED_INJECTION_TIMER is a mouthfull and
> looks like BIOS code to me. But this is still the kernel, remember? :-)
>
> So let's do
>
> GHCB_MSR_HV_FT_*
>
> GHCB_SNP_AP_CREATION
> GHCB_SNP_RESTRICTED_INJ
> GHCB_SNP_RESTRICTED_INJ_TMR
>
> and so on so that we can all keep our sanity when reading that code.

I am fine with the reduced name, I just hope that "TMR" does not create
confusion with "Trusted Memory Region" documented in  SEV-ES firmware
specification. Since I am working on both guest and OVMF patches
simultaneously so its possible that I just worked on this code after
OVMF and used the same mouthful name ;)  I apologies for those nits.


>> +
>>  #define GHCB_MSR_TERM_REQ		0x100
>>  #define GHCB_MSR_TERM_REASON_SET_POS	12
>>  #define GHCB_MSR_TERM_REASON_SET_MASK	0xf
>> @@ -62,6 +78,7 @@
>>  
>>  #define GHCB_SEV_ES_REASON_GENERAL_REQUEST	0
>>  #define GHCB_SEV_ES_REASON_PROTOCOL_UNSUPPORTED	1
>> +#define GHCB_SEV_ES_REASON_SNP_UNSUPPORTED	2
> I remember asking for those to get shortened too
>
> GHCB_SEV_ES_GEN_REQ
> GHCB_SEV_ES_PROT_UNSUPPORTED
> GHCB_SEV_ES_SNP_UNSUPPORTED
>
> Perhaps in a prepatch?

Sure, I will send prepatch.


>>  #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>>  
>> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
>> index 554f75fe013c..7fbc311e2de1 100644
>> --- a/arch/x86/include/uapi/asm/svm.h
>> +++ b/arch/x86/include/uapi/asm/svm.h
>> @@ -108,6 +108,7 @@
>>  #define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
>>  #define SVM_VMGEXIT_SET_AP_JUMP_TABLE		0
>>  #define SVM_VMGEXIT_GET_AP_JUMP_TABLE		1
>> +#define SVM_VMGEXIT_HYPERVISOR_FEATURES		0x8000fffd
> SVM_VMGEXIT_HV_FT
>
> you get the idea.
>
>>  #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
>>  
>>  #define SVM_EXIT_ERR           -1
>> @@ -215,6 +216,7 @@
>>  	{ SVM_VMGEXIT_NMI_COMPLETE,	"vmgexit_nmi_complete" }, \
>>  	{ SVM_VMGEXIT_AP_HLT_LOOP,	"vmgexit_ap_hlt_loop" }, \
>>  	{ SVM_VMGEXIT_AP_JUMP_TABLE,	"vmgexit_ap_jump_table" }, \
>> +	{ SVM_VMGEXIT_HYPERVISOR_FEATURES,	"vmgexit_hypervisor_feature" }, \
>>  	{ SVM_EXIT_ERR,         "invalid_guest_state" }
>>  
>>  
>> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
>> index 48a47540b85f..874f911837db 100644
>> --- a/arch/x86/kernel/sev-shared.c
>> +++ b/arch/x86/kernel/sev-shared.c
>> @@ -20,6 +20,7 @@
>>   * out when the .bss section is later cleared.
>>   */
>>  static u16 ghcb_version __section(".data") = 0;
>> +static u64 hv_features __section(".data") = 0;
> ERROR: do not initialise statics to 0
> #181: FILE: arch/x86/kernel/sev-shared.c:23:
> +static u64 hv_features __section(".data") = 0;
>
>>  static bool __init sev_es_check_cpu_features(void)
>>  {
>> @@ -49,6 +50,26 @@ static void __noreturn sev_es_terminate(unsigned int reason)
>>  		asm volatile("hlt\n" : : : "memory");
>>  }
>>  
>> +static bool ghcb_get_hv_features(void)
> Used only once here - no need for the ghcb_ prefix.
Noted.
>
>> +{
>> +	u64 val;
>> +
>> +	/* The hypervisor features are available from version 2 onward. */
>> +	if (ghcb_version < 2)
>> +		return true;
> 		return false;
> no?
>
> Also, this should be done differently:
>
> 	if (ghcb_version >= 2)
> 		get_hv_features();
>
> at the call site.

I can go with the change in the call site itself.


>
> Thx.
>
