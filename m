Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3AB2F6D44
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 22:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbhANVdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 16:33:05 -0500
Received: from mail-bn8nam12on2041.outbound.protection.outlook.com ([40.107.237.41]:15136
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727960AbhANVdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 16:33:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+PsR0/eFJp4yRcVn4f6HUE2T4tOyKIiVFKpfuGNumRdbJnYTdRi+O6qe3bFbkZVBJayyCNnlqRws8C5Df9rwhL6RXMmS60eN6OArVOdWJqtlPw76FMws8/AbxKOXDcYBK5o/THZhdc+rUxRjuoCNrpiDrpE+riM5R0mPQ4tSvsUyIkmM2mlAw/VcZtlizGeXd84GWa4HlpSd5+OAc+/HcQTTwNxqRUYMjx9xI7H9hlocE2r1V5U6wPiU0IiuSymZs2dVP/Znxxt83JJXoXaGFUKNnWodN1DEkVLlrjL5F7yISior0hlswAHhm2ajnTx0kYoE4ckGv1YV5euiQzzGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sM0Mxm19fFkao+GFw93YvmMwD9c8V1yvK4pstu07JU=;
 b=JvE79D2Ufs3qcrteq63Auo5W8wSDciyPR84r30aLWeBQhmz7MN0IJ3lp9gOM9QxaabVqR0NTKOlKy1v8QBRbtG9m+te09suUQUb1VDRyRYYs185j4p9TNX4ufLX+LMaPgBP0l/jP1DzeaE8HSG2KG7t8kfAOVzznWAVbnrNHmFxvuPTSKJk08VP3XHbtDVW5LP18XXs2MW/Qzv+WdeJStt9x+UjqoUKHkUO5WLV+cyWXdDZFN0qN9HCnoi/2SzXbNCsLhu4vFY509aVMi7qQ9a6gQ9DVaQdb9t2yEmvSGh0Kxdh9JlLNyGBSTiMAX1r2j/0eBckid/jKXnLPEeSJCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sM0Mxm19fFkao+GFw93YvmMwD9c8V1yvK4pstu07JU=;
 b=zvTdtN0iQW+af5pa8SM4Iyd53it3GZ1GgVApM2JAYHgkm/BfyqWDUj4MLWedP1ESN3/Yrvy1kCuKS7N1kOvmCxgjoroVkT+JF8dSlhioR3kFQWkqCrP0bL5wY/46VrXreGx7na1Ob6zwoDS3VLXXIiHausrliBA/x8w1gPRIAmU=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2831.namprd12.prod.outlook.com (2603:10b6:805:ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Thu, 14 Jan
 2021 21:32:05 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 21:32:05 +0000
Cc:     brijesh.singh@amd.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 09/14] KVM: SVM: Unconditionally invoke
 sev_hardware_teardown()
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-10-seanjc@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <d58b1f09-29f2-8b24-511a-42f322978c89@amd.com>
Date:   Thu, 14 Jan 2021 15:32:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210114003708.3798992-10-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA9PR11CA0027.namprd11.prod.outlook.com
 (2603:10b6:806:6e::32) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA9PR11CA0027.namprd11.prod.outlook.com (2603:10b6:806:6e::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11 via Frontend Transport; Thu, 14 Jan 2021 21:32:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 863fbfdd-f3f6-4fa3-bbb8-08d8b8d3d6fb
X-MS-TrafficTypeDiagnostic: SN6PR12MB2831:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2831029A32D9D3C788D289A3E5A80@SN6PR12MB2831.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HByoCcHaCWlWCCmvM6RMLi3l+kEuO2jvAsiaikvw/qPYpuyEXFdQaNhoj7N2jaWF3+jDt1k8wvYv3vZgTcvY5tcEKaVjQX4A3fZY4KMMIolo4UIXiQ+gC4B81GS7W6GsWEzkFJdZv8FIlTslWUHArUTh43tWMD5jU/YN3ADnnh7vUpITx+UhQ4Kf3lK+bJdbp4BOpUTjWqe8pr1Dgll3TZFv4vlTYVz/5UZlDko5CCHdBqitPw/AeIXEnw+YT/EdMxD/W9urB3v7qzcbB+7V5Aup2MkT//WeNpLbOLBdwh1JeS6V1RJe1YmP5tzS0CbBbVLvqxcLJWHFXk2iLuyWcdCiq5fEUeJ6exjKR4P1lQa3ZyFv6Qv2FCEn9EZbHLwHH1X2/GLZqAL0Am3YVKAKKb0/gmym+veWRz1Eqdc3Jscq2uIry7kVcbM/sxUDw436SUNs6au5weomvZ3By8Aoeb37JXTO6Qf81zQ9td6x09s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(376002)(39860400002)(346002)(6506007)(52116002)(4326008)(86362001)(2616005)(8936002)(26005)(478600001)(53546011)(2906002)(8676002)(31696002)(956004)(66556008)(6512007)(54906003)(4744005)(16526019)(36756003)(7416002)(5660300002)(83380400001)(316002)(110136005)(186003)(44832011)(31686004)(66946007)(6486002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TUR3WGlJQ1NCVlBrTmxWNjZ2Y0VqbEtzZC9pN2VtT2pnZ3pOanZvQXRuYm1O?=
 =?utf-8?B?Q2c4WHEvb0dhaGhtWnJUMkM2aXg3dVArQXMxS2E1S1JKOU1JbTNFbVlHRWFE?=
 =?utf-8?B?VUpodThqaS9NTldqRUcveWNFK0htSkFsMUNIKzNQUExNaWxUeHFPaVlkbHp0?=
 =?utf-8?B?alg2ZHJrUWhldVIxOXVOWEJNcFl3VExNeVY2ZzEyYWZ1WVhxaWxEWWk3dXdo?=
 =?utf-8?B?S1hxeVNSaXp5SkRIamEyWllBSTE4Ti9RSWwzc2ozazhNY0M3L0lLbDFTOXM5?=
 =?utf-8?B?OWphMWF0QnpsWWZRTUNWSnlueDQ3cml2RlYxN0laMjdFcTVlZWVwWkZNcFEz?=
 =?utf-8?B?WTZ4QkpVR1RzU1JyaDNONXI0dnhCeGJNbWNMTnF0OURya1ZiZHhhZVJRL1ZU?=
 =?utf-8?B?VWtQYjVvYmNkeUpNNWFlOHVCcmpwcmxJbEhpQ2JLUzBJcVhubGgvWTl2UHo1?=
 =?utf-8?B?VmRLQUQzTzBQM0dsWTBQZFFEQW1xQjUvTi93c0J2YjVoaVlNa0p1WSszalND?=
 =?utf-8?B?RmVrL3AvQ0tFcW5BNWk4Q1FSeXhGMEtqM2VXaE1VNllLb2pkbklpa2xPOFo1?=
 =?utf-8?B?c2tYeExPbGVYZ2N6cnR2S0VoRFY5MEduckJRNGViZ0xlWE9TZmtHcjhKM1dw?=
 =?utf-8?B?cDdpSERtRXo4aTVNLytobGJGSCt6c0ZpRDcvcUx2VW1VSWhRbVNnaEwvOXYz?=
 =?utf-8?B?Mm5TOHZEY3liL1Rha21RRzlpQW5JVlhJNjFHQXhOdFJtOVBwQU1vT2VZeExX?=
 =?utf-8?B?ZGhLd0EyUE5VZDRWb3RxRVdDN2pDak9EYWY4US8xMDQvUmZJdXJyY2tGTXZi?=
 =?utf-8?B?aU82aE5pTGdwOUNVdG1UTlVNdUluV0hJa2JUdnc4a1dxYkdyTUlBTWFGT01r?=
 =?utf-8?B?TGYvV1R6cm5sU25sYWVTZVhyUXpadWZsMlNiVXFzdEs2dWNQRWxIaGFXc2g5?=
 =?utf-8?B?Z2ZpMzBYWTJscVZQQlZTUnhhK0l4bjZnL3E2cTBOQ2p4R3F1Z3VVWklqQUJE?=
 =?utf-8?B?dUhVczlZSHZnV2RuNHE4U3o1NXNhQWg1ZTRSTFlSdkpYamFJYURhWkRKWEhh?=
 =?utf-8?B?QnY1bFZRZ05rTUNMZFRyTWMzV3VJSkJXQnhBMW5jUTBBU0xUWUJJRWFIT0xw?=
 =?utf-8?B?MCtrS1llcWwvczFDdWVQelZZVVZGcFcxUGdPbXFJNlVoUXljaEQ4N0ZEdnRI?=
 =?utf-8?B?MUJnL0pIKzU0WkRvclNDeUpkMC9XYUpEeGhsVXh1a0dLUXRzSDBQT1hCSVJn?=
 =?utf-8?B?TW5Od0MzbzVVU2FKZG1EemxyK2JvNzNtNjJNTzgxSUNiY1Vkdi9BNHRkUjN4?=
 =?utf-8?Q?SNyEQ9gfzwFyswmC8JQJDSfqlZVj0c+XZ0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 21:32:05.6237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 863fbfdd-f3f6-4fa3-bbb8-08d8b8d3d6fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6q1fbJm3HhWO9Um3WJJ8QWD8XnXj56HQ/4uUN3bwDp14E+sVKZYdt4J7Z+OJUFDAvmVz5z02BSgpVjo1/5lDHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2831
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/13/21 6:37 PM, Sean Christopherson wrote:
> Remove the redundant svm_sev_enabled() check when calling
> sev_hardware_teardown(), the teardown helper itself does the check.
> Removing the check from svm.c will eventually allow dropping
> svm_sev_enabled() entirely.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)


Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>


>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f89f702b2a58..bb7b99743bea 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -887,8 +887,7 @@ static void svm_hardware_teardown(void)
>  {
>  	int cpu;
>  
> -	if (svm_sev_enabled())
> -		sev_hardware_teardown();
> +	sev_hardware_teardown();
>  
>  	for_each_possible_cpu(cpu)
>  		svm_cpu_uninit(cpu);
