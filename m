Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283712F1A65
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 17:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387721AbhAKQD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 11:03:58 -0500
Received: from mail-bn8nam08on2081.outbound.protection.outlook.com ([40.107.100.81]:28256
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727180AbhAKQD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 11:03:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUGsdSXLSVp71oZrUQuhl65GhyF+F6AAcRx7aZhWqPyGvdQPU8Ju1D0w5B4sFWcP+7zSio7Yo7MyarXqZaEYkP2SNvJvsvNK71R/J+KV3bRFZ5gJwrLtr5hZVH5SwaUP5T+LonMO98EhakTi5ln0wZmjiUkPQxg2YaJV2Vb6yWMI+LPNsUPlOy1UGOfLu+sbSmlBiaCAb3q77gJKEhRe3zymSVpj8Oycxq1uWj3jptnF4xV4aDfBdk6pINu8nOOpGVK6UX2EVDqRpK/e9KNsNPBGe82Es5N1OGSz9lNCncbOZhkhgS38r/eXfaf1/PxXQA57NXGG0tRs02EdjtCNAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MEKICUam3tOSG7QKtgRGA56O5Ux7YmKcN6DRzSTI6sk=;
 b=GIaPuNnbo71fS/AM6HgDzn7Jk8qIpJGJ4Zljey/7NfCzrXiwiJGa//GOd7PGndBjXKSGXdCsc9NoToob5w54XOiIDyLDTTE9jPslJhOtvxzdqDewH3bbn47xL0Gq2Geb/b62Sczr1/vbAUkb7Kfdir9rAg+R/WfWHqzLKm8bBHShEuBtA8hPnwcZcgkjyLFsB91Yp2AjPyT+TRSkl66BwUTi6LEN028Iedk50VHIPoftHiS+ob2JD8FfZIMokbUbc0p37rMWxeYca1w9XacnyU0lJ+PJoQWixjwb2CjhDyqirJLJCzR4a5fepddcZO3Na4WnqiXEefCKp0ugjMAz/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MEKICUam3tOSG7QKtgRGA56O5Ux7YmKcN6DRzSTI6sk=;
 b=dTWDH8qx6amYeaXrFVih7xWqBlaUFIoLmv5S63zi9CC7+ou1D0IOEIJpoTwXW4FoBf6vpkadnEzgtUxNjwVYy4wJ6ePPv9JI93eAtKXrAQAa4r/gJqDwHbXftZZzOkygJiCYWl7Ov1+0GKf4Ayav1x/R8gkIu9tqu6iVO3L8mCQ=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3370.namprd12.prod.outlook.com (2603:10b6:5:38::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.9; Mon, 11 Jan 2021 16:03:18 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 16:03:18 +0000
Subject: Re: [PATCH 07/13] KVM: SVM: Append "_enabled" to module-scoped
 SEV/SEV-ES control variables
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
References: <20210109004714.1341275-1-seanjc@google.com>
 <20210109004714.1341275-8-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <c47f3771-7877-96b3-81ab-d4997dd4017c@amd.com>
Date:   Mon, 11 Jan 2021 10:03:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210109004714.1341275-8-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN1PR12CA0097.namprd12.prod.outlook.com
 (2603:10b6:802:21::32) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN1PR12CA0097.namprd12.prod.outlook.com (2603:10b6:802:21::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 16:03:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c98a7a1a-0f75-4f3e-2041-08d8b64a6950
X-MS-TrafficTypeDiagnostic: DM6PR12MB3370:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3370D2FF5ADD669E64C62C30ECAB0@DM6PR12MB3370.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A1yyNybrvLZ+kOLuT3J+gUSoS7Fc6LSWY4XzEPc18FKcz+CEBX2c28rx+bsrg48u00LdaOeIKp0YF20Nzdg0lm+3vXu3YHam4PHBfvJs0bKn65b/0lLMb0ub+6RsWgq6uwV/6GxhiXbmlrSeZ7+AetYSfWUkMwvaMUnaPGfg6X/gfmkV2m84GiIqBDppTwJXwn3gq3RP/Sv9WMcTetV9T8j1qV7722FAturQkZ8kuLohCZXc6363SWCsb8qSP/Q6YyKjenytoxIkIUmoeD0FaRwHRBI1KHmM5KWhZXywUvxrLW4GE2xkxSAVP74j5KyQp2cudDh55IWpYR1l40BSe4aop2TUAsq0j4UnkxxHzu15C+lJ4qKw0eJ7CTwCkBv1PiBXatoAL56YgcRZhCVzPUpM3VjZcYc1ezaL6ROIG5dTBGe9ytPmCoAXBfX6rV7dr62od+oOOgF1SU7d+sW92c6yqfCcPcou9ifwYzYNxnI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(52116002)(83380400001)(66946007)(86362001)(36756003)(6506007)(4326008)(6512007)(54906003)(5660300002)(8936002)(31686004)(2616005)(498600001)(110136005)(31696002)(8676002)(53546011)(7416002)(2906002)(16526019)(66476007)(956004)(6486002)(186003)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SitZbDBZM2g1K21JSmJGNjlVYXZWUUNoN0NDaTNOT0lwbU9kRDhQbnQxeFJ1?=
 =?utf-8?B?aGhlQ0lHZnZmNWdiOGY1K0RMTS9DUXR6L3E2SmxtTEZ0MFlZR3BheGhFMDdP?=
 =?utf-8?B?WkFvYmNDM1dUaDR1ckFQS3A5c1FuVnMwc2w1aFdBNWlBcmNycWZhRXFoZjZC?=
 =?utf-8?B?azk3SHcwbENHa3ZLdFpET285OTNoWElHYWo2cTdxQU05MnZFZ1lmQTdlMjMw?=
 =?utf-8?B?UDNZMjRQY3I0MlhQVkNFNEpGbndKM1hzVmYzbmRRNytUemoycGRmenprQ1d6?=
 =?utf-8?B?V1VwVE1WM1lJOTBSM0RIVFl3V3pnWjlBNDRCK1NxOTlpRFRYM2FtNzFDOUc5?=
 =?utf-8?B?cXQvOHYzT1ZEZkhEZGpnRWxsSWFpaFI1VXZvMXdOOXVla1VFL0RCWXNCelJj?=
 =?utf-8?B?RXY0U0ZMdDVDcmlYYmpSdGxiUzNKR0xqU1VqTnpMR0ZUQUEzODc4VGlhSWw2?=
 =?utf-8?B?NVgzVzVjOFZ3UE1ldGFjNUcwNjBqVHo0aldLeEJKRWRMTzdVMDAwc1VTZmtN?=
 =?utf-8?B?aGg1SEVnYllJWkVBL29lSW5STC9GUnJDQTFTZk1UcVYydFBiajJkbUJLNTJp?=
 =?utf-8?B?bk1WM2RsUy9tQ3FOTHVUL0dmcUpFVEhDR3NuSU9TaG9YN255VHRLN3AyVTBq?=
 =?utf-8?B?MEdEbkNXSGNHYm1LRzJucFNCb2lPNnBtY2pJNzRLTHRjUVZhcmNncE10ZDdm?=
 =?utf-8?B?eW4yRDRueDZVUTJBcjFWT2IrdW5BNS8wNnQ4bE9TNjdCUndGSmQrQ0lZeTBB?=
 =?utf-8?B?Z3Q4bDY3VHJiem1LVzhQTUwwcU5PcGgycEpHcjJjNkJuamV4cExnYmlDZXN2?=
 =?utf-8?B?eVo0cnF0Z0lPMnlYVXJiWUU1WXZ4TDNSVmV1UlpUNTlRY3owZnU3eFNmRUl3?=
 =?utf-8?B?bWEwOHVyNGNNejlNU2M4b0JUUTFjZFlnVWtXQjNrdVk0R1lseGUyWmtKN0Jr?=
 =?utf-8?B?RHRzV1pLVFFQTVg1UEY2ZGxqTGhKNkhMK2pIUUpyUnV5WHhPQ3FPNldSWEVW?=
 =?utf-8?B?UHliK0dSMUVCRmpIZFhubW9jc3ZmVUdObHZMR3ZZdmFIaDUvNVNZNjU5WWRG?=
 =?utf-8?B?TGo0TkdvZHloVFlsNGFKMlR4KzB3bHhtUzdaYThqdW85RnFRNjVleFQvZGg4?=
 =?utf-8?B?c0VKNFhXcW1wbG5rNlJZRFd2MVRjYnd6T3Z5M3JZeC8wTkN1c0drNUFtazEy?=
 =?utf-8?B?M1d1VXUzMFRqMjFKTTF5Mi9tNVBQcGk5NFdyWDc5OU1OUFkrQ2hSdEcrdDAz?=
 =?utf-8?B?bjkvMkVqOUtvOGhWMUtaWkN3bnRKT2NvOG5Zd2pON0FlZjR6RkhNNUNOSy9w?=
 =?utf-8?Q?PHGKKyCah1Tv2MWt8T63uL1J//Cz4iVTLK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 16:03:18.2719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: c98a7a1a-0f75-4f3e-2041-08d8b64a6950
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WtuGlG+7UidhUsqzLyFuk3AV2Ft0Hyuj9gITqWIhLLgl4hZnXXgLl41Yn3CABQ8aLU7XokTfsO5ZXY/NHBO+Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3370
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/21 6:47 PM, Sean Christopherson wrote:
> Rename sev and sev_es to sev_enabled and sev_es_enabled respectively to
> better align with other KVM terminology, and to avoid pseudo-shadowing
> when the variables are moved to sev.c in a future patch ('sev' is often
> used for local struct kvm_sev_info pointers).
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 8ba93b8fa435..a024edabaca5 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -28,12 +28,12 @@
>   #define __ex(x) __kvm_handle_fault_on_reboot(x)
>   
>   /* enable/disable SEV support */
> -static int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> -module_param(sev, int, 0444);
> +static bool sev_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> +module_param_named(sev, sev_enabled, bool, 0444);
>   
>   /* enable/disable SEV-ES support */
> -static int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> -module_param(sev_es, int, 0444);
> +static bool sev_es_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> +module_param_named(sev_es, sev_es_enabled, bool, 0444);
>   
>   static u8 sev_enc_bit;
>   static int sev_flush_asids(void);
> @@ -213,7 +213,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   static int sev_es_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
> -	if (!sev_es)
> +	if (!sev_es_enabled)
>   		return -ENOTTY;
>   
>   	to_kvm_svm(kvm)->sev_info.es_active = true;
> @@ -1052,7 +1052,7 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   	struct kvm_sev_cmd sev_cmd;
>   	int r;
>   
> -	if (!svm_sev_enabled() || !sev)
> +	if (!svm_sev_enabled() || !sev_enabled)
>   		return -ENOTTY;
>   
>   	if (!argp)
> @@ -1257,7 +1257,7 @@ void __init sev_hardware_setup(void)
>   	bool sev_es_supported = false;
>   	bool sev_supported = false;
>   
> -	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev)
> +	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev_enabled)
>   		goto out;
>   
>   	/* Does the CPU support SEV? */
> @@ -1294,7 +1294,7 @@ void __init sev_hardware_setup(void)
>   	sev_supported = true;
>   
>   	/* SEV-ES support requested? */
> -	if (!sev_es)
> +	if (!sev_es_enabled)
>   		goto out;
>   
>   	/* Does the CPU support SEV-ES? */
> @@ -1309,8 +1309,8 @@ void __init sev_hardware_setup(void)
>   	sev_es_supported = true;
>   
>   out:
> -	sev = sev_supported;
> -	sev_es = sev_es_supported;
> +	sev_enabled = sev_supported;
> +	sev_es_enabled = sev_es_supported;
>   }
>   
>   void sev_hardware_teardown(void)
> 
