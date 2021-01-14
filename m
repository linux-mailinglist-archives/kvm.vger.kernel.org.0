Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72EC2F6CB9
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 21:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbhANU5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 15:57:09 -0500
Received: from mail-dm6nam11on2040.outbound.protection.outlook.com ([40.107.223.40]:26465
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbhANU5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 15:57:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q66HFrStxK1jlZ8thPzOKw49/OQqnIfjpFb/7NkP9GYkigML/lYeak/fmHn57J3seAaUiw1rkn21iG9KM4oNRQ/JpSCXfAxTQ+tlv4OZFDagd3+5DvJFkNHvfyi7vU6qAVREaHIhvENl7PCN9IAh834+PFIytjTPzbFYEKDgvWk59ZG4VmIO1bNUK2h5JmSFDSeeFckM8thV37+KjmhjmTQ4DBvkJ1oT+OWNBg+WAQKPZbBfo0WFpfJpYOqsse/SZVf2AP66C7IhAKeMBI4MiwX12LxdiUkBc+5cfjqdm76obRQLhYciHxxF9UaWKbQeoq4uJU2nJcy+fe5Ozk5/aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QD9W2qSr+yrnxIpRAVLjopcihwjWQ+QVOzhhZONrBeU=;
 b=UEpQKyjC2Oe79B8SzDQmall57ZXPdXip0D7Xg4Lm2on42c4Ph5ENgEYfWuyz8y+YHLThG1lJU65hUidQ+vXOI6jMappO/XKIIk6A7ZDS1olf54veW/bs9d5qZ7Yq+YOFNAjs7Rav7dHGSijh2dRxejrctnHIPsu8XTckbHGbLDJpxgTm6kvE2hZff2sVvOq/UWrpQqWrZqMoumFOTaXgophg755aYmS8fJu/u1GDN+ZCXkeCu/kolgBhjr0qzG1f5vV6BznEFL038mBBJYIGbFix1HMC0d9vpfpggkyf4+wd/0ScvdxeRIq9PQ9+R4LZ0XU//Yd7N6/z8yK/wrq++w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QD9W2qSr+yrnxIpRAVLjopcihwjWQ+QVOzhhZONrBeU=;
 b=YfwN0FDcCP4TXUhV9NZkkeeTJHXrk40ZUj7gaN9tbAJcLuwnxQmHRpA+tDiEUHCpboHZXzfk54LAyKy2xi5XA1EUM+imvXeNz4gIdroFF0nfIsvlGF3zupMNR6p9rXWTbR27MI9Tdm6hVfcyW74l3Oo6ZxvClf6BV/ylaIxFfMM=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3772.namprd12.prod.outlook.com (2603:10b6:5:1c3::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.9; Thu, 14 Jan 2021 20:56:13 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 20:56:13 +0000
Subject: Re: [PATCH v2 08/14] KVM: SVM: Condition sev_enabled and
 sev_es_enabled on CONFIG_KVM_AMD_SEV=y
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-9-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <5a2ff56d-0e06-fb1d-89f7-b4011b58792f@amd.com>
Date:   Thu, 14 Jan 2021 14:56:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210114003708.3798992-9-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR13CA0192.namprd13.prod.outlook.com
 (2603:10b6:806:26::17) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR13CA0192.namprd13.prod.outlook.com (2603:10b6:806:26::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.5 via Frontend Transport; Thu, 14 Jan 2021 20:56:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: da578db4-4f63-4c3c-a413-08d8b8ced3dc
X-MS-TrafficTypeDiagnostic: DM6PR12MB3772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3772459E3D46824ABF46D8DBECA80@DM6PR12MB3772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:139;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5VsJxlxlQNYgN+ulA0K4aOcqVaL8xui7nFfAqdUd0HCEx3bYD4q2XY068nDHp6FxpXW0g2zi9cdgoWaW3EWtAmEigKgIlLwjiOuQLgzgXPbeVENccirrAQ83dCjh/0GPIY5C2skdWTtOniIEDAp8Qkzx+e8EY/cZC96YUEIdJ8mVMRbcxFm+vtAwrkWdbJRCIL73Al2J/LBIoWDC2FaX43GXY9KIDuq+SaW+p4vBU+r5K3KnG1qTygh1Yj/24zyOG/eWYKB56MUrjk71f4mZomk+lbB+Xv0qEVaJpwkXHVfXiN/6+db/DGzBMUW8eaW2dLNFLD2qVOfQLVvImOPyQ2rGu54PfOvD/BqP51f4N8GeuXpPLgtoZH3URppwIYK+tP2K5xNuld0nD8vFsd7Q8kQKV2OExtW7spgWhGCLGiCkiU6Y9BA6wj+OxzDUEf06unFOPAd2fdNeaGvLhWjqPLyFdPWCqXiLSjit+mptZtA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(376002)(366004)(7416002)(52116002)(86362001)(36756003)(53546011)(2616005)(66556008)(26005)(4326008)(66476007)(31696002)(956004)(6512007)(83380400001)(110136005)(478600001)(6486002)(186003)(316002)(54906003)(31686004)(8936002)(5660300002)(16526019)(66946007)(6506007)(2906002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UUFyTG9WSjJVdE9aenB4b1RxcFIrZUlPUlVBS0l5TEM1ZmQ2Zkc3bkdBMTIz?=
 =?utf-8?B?a3lCd08vaUxsQ3IvcFBCcWR4Rk5ZK2tsYklBMUZsM3A0ZlIzWk40aG1CTjM0?=
 =?utf-8?B?MW1EbldORFc1Q2FKZSs4VEdwRDlYVTVyRW1zNjlSU0JHYWhaK3ZvSzZIcUd5?=
 =?utf-8?B?THYzRXYreDBYNklnREliM1B0SGVRT1BZejRxdE03NnVQOVl1SmV4bHNvUHlB?=
 =?utf-8?B?bzJuY1FqLzRlb05ndUdBYWQ1eGtWNXJiZUlJcnVLMXZZY0I0NW1QV1Z5ZlVj?=
 =?utf-8?B?MU16T0FIUDIyMGgzVGNJYWRhREtrS1kvYkc1WlV2ZDQyMTYxdlVLdjFER05Y?=
 =?utf-8?B?bEY2MXQvbzZhY1JxbkIwbjk2ZzVDSTBiWnBtQVpsS0FhOFl3UmtwUmhnMHdN?=
 =?utf-8?B?V0E0ZHRHbktFVWYwSDZSODhuSkt5MzNKWE0rNFlVM3k5aTNOYWpOUGJVdlVn?=
 =?utf-8?B?TVpTN2t3bFFaYVI3RDZhb21RRGtwMmRFV2RUNWpxTE1FY1pjOVJmREFQMWFh?=
 =?utf-8?B?cDJmWTRHbE9jWjlHcnBPa0hyV1NaNnZJMktwNnRJb0lVTmk3RjY3OW1DNW82?=
 =?utf-8?B?cEdzTG03TTFIUWgwcDVnVmdlWDN1OXllQUJITmpNR0I5ZXY5VmkxMlJjczN1?=
 =?utf-8?B?ZmhUMVR5Q2hGbThZdjlXclI5SUN6cjMxNDhSYlNGSGZLc2xMZklYeVl5NXZO?=
 =?utf-8?B?NnZUUXA2aG5mVVRFaVZBTW9GWWNoYXI1eExtNVdvemVrWE9XbllMRUQ4ODQ4?=
 =?utf-8?B?WjRCWUk5eXBybnByWjhpZHRXSXJlNDZSNnZtTVJIbFZzTlZzMEFMZzNWVFhq?=
 =?utf-8?B?blpISlpvZy90UWI5STBSK2hzOWlXMXRkM1RhN1B3T2NnQUZaWmxPeWI3d3ZN?=
 =?utf-8?B?OUVoS05jSng4T3ljQUk4cElEMWxBR0QrYm1FYWlibTZqZ0txZ05iUmpsTjZt?=
 =?utf-8?B?ZVN6RkpxSTBSTjgvV1lZTXQ1Q3hPd01xVnlWdUppOXViUUl3MS9RY0FNSmxR?=
 =?utf-8?B?TDdUK1J3Y3ZXY1NBRjlXVTk2K0doazFNTG5vZjY3Y2VRdXdDemNJT3QxQWlQ?=
 =?utf-8?B?Q1MvSTNaVEM1a3JuK2dFYVE2RjVFV0V0cVBzZmc3alcwc0o1OElUNVpLOVZj?=
 =?utf-8?B?M21EelRFd3RXWm50Nms4UGNyOE5tRnJ5WEV6S1hzTXRKTUo0b3lNOEFQaDRW?=
 =?utf-8?B?ckY0aFNPdjRJNUlha1VZZlFJOU9LVU50M0JVdUNkRXpqWVh3RUpBN0FvSXlr?=
 =?utf-8?B?OUt0UHNXK2R4MURpQ2IwbjFRQWhHaGZzKzBkam00U0RKZ3hQRWtTa0pyOUNv?=
 =?utf-8?Q?uyc+9Yox7k8KQqpgncyzCrAxxnt8C3PyAv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 20:56:12.8752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: da578db4-4f63-4c3c-a413-08d8b8ced3dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YCOOMMdsKgJR3O+HMzsgwwDpDE6dBewcmQDWu8I5Y5Bs0OSAfrQD1ZvKM/yWAHmggmGMDBvJFuZkZHQ0xmqvmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3772
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/21 6:37 PM, Sean Christopherson wrote:
> Define sev_enabled and sev_es_enabled as 'false' and explicitly #ifdef
> out all of sev_hardware_setup() if CONFIG_KVM_AMD_SEV=n.  This kills
> three birds at once:
> 
>    - Makes sev_enabled and sev_es_enabled off by default if
>      CONFIG_KVM_AMD_SEV=n.  Previously, they could be on by default if
>      CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT=y, regardless of KVM SEV
>      support.
> 
>    - Hides the sev and sev_es module params when CONFIG_KVM_AMD_SEV=n.
> 
>    - Resolves a false positive -Wnonnull in __sev_recycle_asids() that is
>      currently masked by the equivalent IS_ENABLED(CONFIG_KVM_AMD_SEV)
>      check in svm_sev_enabled(), which will be dropped in a future patch.
> 
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a024edabaca5..02a66008e9b9 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -28,12 +28,17 @@
>   #define __ex(x) __kvm_handle_fault_on_reboot(x)
>   
>   /* enable/disable SEV support */
> +#ifdef CONFIG_KVM_AMD_SEV
>   static bool sev_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
>   module_param_named(sev, sev_enabled, bool, 0444);
>   
>   /* enable/disable SEV-ES support */
>   static bool sev_es_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
>   module_param_named(sev_es, sev_es_enabled, bool, 0444);
> +#else
> +#define sev_enabled false
> +#define sev_es_enabled false
> +#endif /* CONFIG_KVM_AMD_SEV */
>   
>   static u8 sev_enc_bit;
>   static int sev_flush_asids(void);
> @@ -1253,11 +1258,12 @@ void sev_vm_destroy(struct kvm *kvm)
>   
>   void __init sev_hardware_setup(void)
>   {
> +#ifdef CONFIG_KVM_AMD_SEV
>   	unsigned int eax, ebx, ecx, edx;
>   	bool sev_es_supported = false;
>   	bool sev_supported = false;
>   
> -	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev_enabled)
> +	if (!sev_enabled)
>   		goto out;
>   
>   	/* Does the CPU support SEV? */
> @@ -1311,6 +1317,7 @@ void __init sev_hardware_setup(void)
>   out:
>   	sev_enabled = sev_supported;
>   	sev_es_enabled = sev_es_supported;
> +#endif
>   }
>   
>   void sev_hardware_teardown(void)
> 
