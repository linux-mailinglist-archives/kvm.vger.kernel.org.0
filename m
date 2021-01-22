Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF84B300EC2
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 22:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbhAVVSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 16:18:49 -0500
Received: from mail-dm6nam10on2079.outbound.protection.outlook.com ([40.107.93.79]:23392
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729920AbhAVVRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 16:17:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTR6naMFa42loWis3g88GLudQnIy2Ej/b5mBQKOf2jPluCHEqSpKGhUFdgeniuKy0B0TMCP0nQOz1X042zVUV4A/esgEcf/9QLutfVaQwLWZoszUIxbod5TXtQuvnKgM3aMBZJ5h3JlnABRMrT+M6FnZ/1q4n9wwjfeLTrydBPDZq6R0TFBi9jr9H/KVYfZaEB+8wISMi8+cNWt5x4/Fvn5o/6sGOd5DGq6svtpZUCR5+e+W/cUJMRekGOtuWUsvMJVUIA5xzPOKE6hh08Z/VaFZuiEhvG95vVB4xvIIg9kCc2XKi+Hs8rfBqJ4eEgohuhtlUor3e2tGTBUU3dMneg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXy3nzjAwMEUVUiJuxb0ZhjFQxz+MTcp+BgDtlsD7Gs=;
 b=QzgPJ4zricTfrRXrpwkPMbOr8cvNyZC3Vvnabco3yNXCtMZhIT2mW9ohb6tG7o7pLnXtR7Djln0VN7zIyE68HxlApu6slZoRaS/5Wi4L2yq9pQUD0emSLhwGX2pXoffQLwHI8jBjoQlE8cWozVTDudHJaF60fnNs+FZEScBEdre0gpyC8ZdwmzQ+eGcG7hRRa7IVXAGngOiREscWPevbzreNvM7Q8HxCwIjRKyKeE4Qx/XQKYdbc2GFJpfx2yS+I/29BcaOLJecmBc+YWEgIZKw24hBQoT10cRyXuL535H65h8BgtkEvyhh/YgqElbhFYsXJF/J73Vuf5e8ScYXEhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXy3nzjAwMEUVUiJuxb0ZhjFQxz+MTcp+BgDtlsD7Gs=;
 b=bZoyJFIGq7fgEfJpRj7jbA225uKeK3w9gD9LK/N33DBLyj9+rXsBDluoXiJANxth6QM1mDP3E6QiCZW0wwvawpJEu8JXNYyT2bxAKtSKCwCf0XXFP62Q5i0onCZe27oIU6rSAg3IbUeNicf59cS7v9xJRmSAogTduXVoUijV/KY=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4700.namprd12.prod.outlook.com (2603:10b6:5:35::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.9; Fri, 22 Jan 2021 21:16:39 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.014; Fri, 22 Jan 2021
 21:16:39 +0000
Subject: Re: [PATCH v3 13/13] KVM: SVM: Skip SEV cache flush if no ASIDs have
 been used
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
References: <20210122202144.2756381-1-seanjc@google.com>
 <20210122202144.2756381-14-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <7ba2f3a7-2e8e-39fa-dbf6-b2781f244486@amd.com>
Date:   Fri, 22 Jan 2021 15:16:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210122202144.2756381-14-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR11CA0008.namprd11.prod.outlook.com
 (2603:10b6:806:6e::13) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR11CA0008.namprd11.prod.outlook.com (2603:10b6:806:6e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Fri, 22 Jan 2021 21:16:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 187c9557-2a22-480e-3929-08d8bf1b022f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4700:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB47004633814020FB3EC7D6E5ECA00@DM6PR12MB4700.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jg+hAm3qXbWJfUwfQN79O3bKSkhV5pGFt/IdK8qWOWswIOtFctchE+vMLCV7Ey9UxbPSNNu0EJ2LMrQ6a7TlNj7Lyv855b4or3pS69nFYEc68+vOB+ZrEr4wjQ3237ezeBUam1NXGhibQci/jt6+Ke5Vlz6uNEG3DaaTNd9BMd+fpEjHfxiI9m3D/BbNMkb40WeY8Tm5cqMFPR6HetywHq1JErkJS1PFqphgcvY0u5NEcXOoK2cyO6jkWNb4wFL+hn20phLt0edecFDZBo1ikZk2+BBdm8KZSbEgq8DN3Im+G3QCdlzypmusDJyjc8eERQMabRcxVcf5ND7J0NHVdQEYXasHuGrMm7n+Ei1OE/V5Wj9lqKBgpNcO0ZpYy8E2WtSQyKza779UTyMWR04lYJBJsrq8fCCQqvmZWi/XjsTj+OzZP741Kjj5W7OTDzOOkucsIA6GlZuR1yxc+dkYysaRKcFZwVvGI0HRJmeq9v4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(366004)(136003)(346002)(86362001)(66476007)(6512007)(956004)(110136005)(53546011)(54906003)(26005)(31696002)(83380400001)(8936002)(186003)(31686004)(6506007)(478600001)(2616005)(36756003)(7416002)(66556008)(6486002)(5660300002)(8676002)(16526019)(316002)(52116002)(2906002)(66946007)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QnJobVl3WjRBVnZ0VTZTUFFjRjZyc2RMRHdGN3hDQmw5VGwrZlQzNVZEaS83?=
 =?utf-8?B?OURsMVdEamJkUXlkS2NjL09LTkx3L0ltWGxvVi9XbTJEWVRYcitQMThES3hv?=
 =?utf-8?B?THNtSHJzaVBDdDZ5WVdsd0xUTzdWVi9JZzg2dmdLMnNVWG9TbzlsVUpOaUlQ?=
 =?utf-8?B?d2pscjkybEZqYUR1dnNXZ1F6MmFXVU9EVHpQODM5Yy81Umx1c0Mzb1NGVkhT?=
 =?utf-8?B?WUY1eGFXN3lOUkQxa29BOEdRYzU0dkYvWFUrUnNPQ2xUKzdRZUVqbnlRd2V6?=
 =?utf-8?B?N3owa1RmZWtuSTh5YnZrTjN2MU9XTTNMdVovNm4wVkxseGV1bm5LYzFhOXhE?=
 =?utf-8?B?ZE9TWTNld0ZmVVpMZ0Z0VFMxVll1ZEZUL2hxRUdZMjVwbXRCaVVZMW50MWNK?=
 =?utf-8?B?bzVFRngxYVdUQzZDVEV4N0VjVzRaK0J1T1g4N1ZFMmF5Wi9HUm5FOHdNK3pG?=
 =?utf-8?B?K3dvTis1OHVBeVh5UjNTM3ErMVdkWXJOV3orSEo2d3hQaE9yUHN3SDcrcVRk?=
 =?utf-8?B?VU9hVGt2SHZtNmRycGM0Um9PQjFXdnZacytwWEh4VmxtR0NFZWUyeS8wa2RV?=
 =?utf-8?B?TVluNC96ODB2RzJlQTFObi85N0FLZFk4OUxmVHhkcFNUNEVQdUZCV1dqUW5J?=
 =?utf-8?B?UXdYWVhtL09IK1ZMMFpuZlY0TVo2TXBNU3g1aWJsVXB6NXRJQjlWTHhMTFdx?=
 =?utf-8?B?T09FcXJQZ0FJNXoxalBHUHd2QXFvUkYrSE0zUG1ORm8yZXNGeUpjNGwvWXE1?=
 =?utf-8?B?bVk3dFUxY014WDJCTHpaTG9ibnhsTEtMUk9aZTIvY1RsZWlJbXJLV0w3NnFi?=
 =?utf-8?B?TGFhTjJSTk1tUldOMlJrVS93U1hFR3Z6NGRUbVp4OHlPVy9vbzI3aWJ1Nitn?=
 =?utf-8?B?dXRZNG5IR2lOY2ErcHVUY0ErZjhvbnBmSlpBam1oYWtCL3hVcGpoWVJtbGZT?=
 =?utf-8?B?bWlsT2xqNXhGR1l6SHgwKzVvVHZET0F2WXhmTHcySm96dUk2Zm1GV3pYSDlX?=
 =?utf-8?B?dXZMYTcvMVg5VjRYcEFjd1dhRU5lQml3bmtTVHhuaDlQbWpBWnJRS1czUk1u?=
 =?utf-8?B?RnJwLzlOMU4wWHZUU2c4aDl5U0tIRmFxM0hzanNoOXFESzZBYyt5WThhQlpC?=
 =?utf-8?B?TjA1REVvVGZGbzFkaVQwMGd2Ny9WOEg3SGxqeVY5WDhLdWROL3IzSHAyM24w?=
 =?utf-8?B?SzQrME56MDFLS0N4ZHlRUm1menYxRWRHamVuNTlPSkNzSVVmYmpiRGFyU0VO?=
 =?utf-8?B?WUtFTEZPd3VSdzN1OVB4M3NYRWNWdEgxeXZRdnlMZWxYYnVod05kNFRocVNF?=
 =?utf-8?Q?C/4t7xF//0dWiZVk85VwZ4CdtXEvt3tB1l?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 187c9557-2a22-480e-3929-08d8bf1b022f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 21:16:39.6305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2UYDfBsTIbXK4wCg5qmXZKxEeapBAhUsFwnAtpfdTdGeFMEdTHQZqB3QPxb8SqeDad6rQKq0fDgfzSORNouQRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4700
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/22/21 2:21 PM, Sean Christopherson wrote:
> Skip SEV's expensive WBINVD and DF_FLUSH if there are no SEV ASIDs
> waiting to be reclaimed, e.g. if SEV was never used.  This "fixes" an
> issue where the DF_FLUSH fails during hardware teardown if the original
> SEV_INIT failed.  Ideally, SEV wouldn't be marked as enabled in KVM if
> SEV_INIT fails, but that's a problem for another day.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 23 +++++++++++------------
>   1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 73da2af1e25d..0a4715e60b88 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -56,9 +56,14 @@ struct enc_region {
>   	unsigned long size;
>   };
>   
> -static int sev_flush_asids(void)
> +static int sev_flush_asids(int min_asid, int max_asid)
>   {
> -	int ret, error = 0;
> +	int ret, pos, error = 0;
> +
> +	/* Check if there are any ASIDs to reclaim before performing a flush */
> +	pos = find_next_bit(sev_reclaim_asid_bitmap, max_sev_asid, min_asid);
> +	if (pos >= max_asid)
> +		return -EBUSY;
>   
>   	/*
>   	 * DEACTIVATE will clear the WBINVD indicator causing DF_FLUSH to fail,
> @@ -80,14 +85,7 @@ static int sev_flush_asids(void)
>   /* Must be called with the sev_bitmap_lock held */
>   static bool __sev_recycle_asids(int min_asid, int max_asid)
>   {
> -	int pos;
> -
> -	/* Check if there are any ASIDs to reclaim before performing a flush */
> -	pos = find_next_bit(sev_reclaim_asid_bitmap, max_sev_asid, min_asid);
> -	if (pos >= max_asid)
> -		return false;
> -
> -	if (sev_flush_asids())
> +	if (sev_flush_asids(min_asid, max_asid))
>   		return false;
>   
>   	/* The flush process will flush all reclaimable SEV and SEV-ES ASIDs */
> @@ -1324,10 +1322,11 @@ void sev_hardware_teardown(void)
>   	if (!sev_enabled)
>   		return;
>   
> +	/* No need to take sev_bitmap_lock, all VMs have been destroyed. */
> +	sev_flush_asids(0, max_sev_asid);
> +
>   	bitmap_free(sev_asid_bitmap);
>   	bitmap_free(sev_reclaim_asid_bitmap);
> -
> -	sev_flush_asids();
>   }
>   
>   int sev_cpu_init(struct svm_cpu_data *sd)
> 
