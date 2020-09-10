Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E650E2651BC
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 23:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgIJVAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 17:00:34 -0400
Received: from mail-bn8nam12on2045.outbound.protection.outlook.com ([40.107.237.45]:35649
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731019AbgIJOpf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 10:45:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1wiZdiXh3fyX6J/wG2ej98k+fnrDD1UaSYSoKVdw3po4UtDSXNictseI7m/ZVl4i9vut0qt+gck7puk3cE01KKcUnAKALYtDHyaYAePZ571s8ALYnOlWqfez7yzoVBVTzsB5wo/ZVD4EXpqAGPCcoKvS/CKhgIB/orHze5/U3ksrwBQ1OZwEJcXutGKdzgE2Es2sc82hQR0eyMTa/rk6VvEfhtQaY05l43H8wPzGrOYvgXkgHk3RJFO+XZZeopdqoDXu7kfG7tPekwwITZa0QyvrfobKzBPJEMa051QckWZkhhntdfgHsZnR0BHyMNqiByn7nBJbXwNqVtJTqVa2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbb/7cPSO0Tp7P0bpKDA1ilO7X7OeXlQHnsCjauXgF0=;
 b=AM6sHazKQZM2LGy0zE8GyHpIYCLZhohzpXmpMByfiBTvIMmP7vQfWYnN2fckgJbTKPK7nInXKb3h6dVdYGp+ofRE48TLwtje2Uj+IdbPGzrjUTWEJFVxQlbWjZLWqE1aUVkOTrbV0SVtLHATnxh3JDO0d1aUI+d3GMgdn7XqrXatPsDWF3ET3HrqvAK3E4tYQj+ZPzeKGmIxNMg30+iO8tbfvishwrm+T5GNYBFO1mydU+XL6YJpEoA9IURvStoFaNdyjJ2K+h+G4IMnBZDTnOsrSjA4cfy4uNW9dgWQES5eJjCQMLC2gE1dNoLd1sJ6luxL8YB2MUONlREpEQYo+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbb/7cPSO0Tp7P0bpKDA1ilO7X7OeXlQHnsCjauXgF0=;
 b=kjuZeKdjMozZXwLiDP8dLSkt0EA6cBk5mC3MYuFln+7wfrcXToAjOytLYWaOZ0KBe6ASuxaPCHRRZzS0454yayvRLY4nu8W7nGBRMmom6lH65o1CRQYm9FV4nQsr2wbQ05+je2HQ3Hacrqthy76qlOvFELboBtsAFUiVuoyue3A=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (10.168.234.7) by
 DM5PR12MB1354.namprd12.prod.outlook.com (10.168.240.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Thu, 10 Sep 2020 14:45:29 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.016; Thu, 10 Sep 2020
 14:45:28 +0000
Subject: Re: [PATCH 2/3 v2] KVM: SVM: Add hardware-enforced cache coherency as
 a CPUID feature
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
References: <20200910022211.5417-1-krish.sadhukhan@oracle.com>
 <20200910022211.5417-3-krish.sadhukhan@oracle.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <fdf8b289-1e6d-9f3e-3d76-f48fcee2b236@amd.com>
Date:   Thu, 10 Sep 2020 09:45:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200910022211.5417-3-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0049.prod.exchangelabs.com (2603:10b6:800::17) To
 DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN2PR01CA0049.prod.exchangelabs.com (2603:10b6:800::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Thu, 10 Sep 2020 14:45:28 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dc64f917-a0a8-4803-8d3a-08d85598290c
X-MS-TrafficTypeDiagnostic: DM5PR12MB1354:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1354211B5F2058BA9226A5B5EC270@DM5PR12MB1354.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WeqQM2jslT+b44HwbD7rApR0tujqQyLYLZ+mqc17aO10z267tVir6vUkbvtLnkeB2yJdadVhV7khMw21pCRSaMBUI6DUuhBrzziHInu1m6kQiiXEGoOSgG90ZH7zq9i4C/lztds4fNYWJdK/6pRnzupMkPV6xMEw/Db7n9Knu4rTJiPpKRQJM+jOTqrnlVFOdugPNkoWGut1IKy1xyehVpDjmb2CWcM/a9Z6PXTNVi/QDEJfI5siMebeQElaGpMvNBvZ2Lo1iukQ3lN6yroaRB9/EuIIVw6DNwyLrOa58jv48MXUhrRyL3GlEbFWBM2EUNLgKd3oEHRb2lUQ6GaXN/p/N1srjp/fLFMH8Trf7pbEkpME22H2tOoFe6zYA9CW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(66556008)(53546011)(316002)(6506007)(66476007)(5660300002)(8936002)(31696002)(956004)(36756003)(2906002)(2616005)(16526019)(6512007)(8676002)(186003)(31686004)(4326008)(66946007)(6486002)(478600001)(86362001)(26005)(52116002)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VN/TWdvLov0/ul1VEQ3c+sm9H1D8a8k94ppM3zCHwuxHh9EEsAUcUdPV0kQ80RXsB+a3RJX0IbwEAn/Tx9u3GZHQ1aNr5c00SAM3pgQThj1heWcP8mrK9tBqmPZDrtq4EHTramb7ThaHRPTO/yFBluswofaPhdIK4NoyDTaniAIl6iql/t7ty5EGlSfB7ejaRmXCHwdwe5wXaAiExPmi3ms0mGDzIiJgLkDd2CiXNLS6cuU5ZXt6aUvQ8GFxJA4jbhd83YhT3Ux9Ux8mUzlPunmdRrEw5ezh/33LwWREW0yf4sKSGOkZMpHhE7SVqIpqWZYsLrK4cO9LmGMePwN/8lMoeZQ9XllrpkwKhBwCk35ng0hYA9xMYjOWUsY1oeE+h8SwtCY/sUBOQr74TRZRCbYmQe2Yyoth4Mg7IAt/S0TcPOz80HJ5HjyRt5DLlh9m5Qgdo++GIGc9n3VRLYZb8dmyunsdOkCJEEbx8sRuLD55qW+h5xb2W7lSviKHtwBZ2iQni/DIpgbNSew483e0prdhT/UCn6pCaM9ag2hOzx5gkTK4QGGx+nYbYQAM9uOPjkis9zt0rCuJg6rbZLzRV2bGioXfM7i7ElnqsozUqHRx9DH4frLWTvP0eDDP52UfVIzJE+/IGhtX2F4vP2yx1Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc64f917-a0a8-4803-8d3a-08d85598290c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2020 14:45:28.8911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yZcV+h/fvORvOBay7l8rDUVO3ACMQj8Y+HgJrPcC95omYLVhKbZzKnrUTfmHlAFKIg1pKO8LJxe00a2/UgiM6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1354
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/9/20 9:22 PM, Krish Sadhukhan wrote:
> Some AMD hardware platforms enforce cache coherency across encryption domains.
> Add this hardware feature as a CPUID feature to the kernel.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>   arch/x86/include/asm/cpufeatures.h | 1 +
>   arch/x86/kernel/cpu/amd.c          | 3 +++
>   2 files changed, 4 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 81335e6fe47d..0e5b27ee5931 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -293,6 +293,7 @@
>   #define X86_FEATURE_FENCE_SWAPGS_USER	(11*32+ 4) /* "" LFENCE in user entry SWAPGS path */
>   #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
>   #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
> +#define X86_FEATURE_HW_CACHE_COHERENCY (11*32+ 7) /* AMD hardware-enforced cache coherency */
>   
>   /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
>   #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 4507ededb978..698884812989 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -632,6 +632,9 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>   		 */
>   		c->x86_phys_bits -= (cpuid_ebx(CPUID_AMD_SME) >> 6) & 0x3f;
>   
> +		if (cpuid_eax(CPUID_AMD_SME) & 0x400)
> +			set_cpu_cap(c, X86_FEATURE_HW_CACHE_COHERENCY);

Why not add this to arch/x86/kernel/cpu/scattered.c?

Thanks,
Tom

> +
>   		if (IS_ENABLED(CONFIG_X86_32))
>   			goto clear_all;
>   
> 
