Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E0E26514F
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 22:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgIJUvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 16:51:21 -0400
Received: from mail-co1nam11on2088.outbound.protection.outlook.com ([40.107.220.88]:40032
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730585AbgIJO6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 10:58:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZAwyfHbvBfT/xss8A5YPE+oQMkAhBWJxPy2Nd1kAu+20TJmpxYtvW8dUx9QqyX4MvaCXv+uUZkrcClBY8nCbHafl/ei1gqh1cxHQoVNJpVx+K1E1GJO66epFHTH5f7T27zDcVcFQ+Ym6q1kxiYbpp/VPxV7w4xFRj3QyIaK5nIusGJ9bKYGfM+tSvIkLa/zShWdeWLzyYEeMzmqhTj0ZczYRdqE6PXNMwQGjUlQcX9A6phOw3PMQ/kpgezouRM5WOjrloKXhMqxFocWX1KOYNX0sQbFWbCqn9FfQ2UvqAJ1v7sZIYoAr9eoPR1C6bHLVcXkY7hJAj/P19Y+MlH10+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VatVKnLwZWzZjVGFn++44LU1OqukvqvM2EVWqgCl2/E=;
 b=OAstNOJmsHpRHhhhHCOeIa1XbcIcqM31rgd1YIhD+jPul+7m2h4jgR/nIAdQBJwfQbMEqrrI6aEuIoKv32ow52ipO5MgixykO1LAxhWNBf8FfOrYl+/AO9oS1r97k/LMSh3t88p8NwT7aE9Sv+0gV7BibsR/7FR6hvc1PLG/jrpeNx3uyl6I7BZLmU3fqzCVb60jQPzY/eP7e/Jcbuk5Xs7w380GVaAvseFgH9bSYt2g2Y3GI5pvDKilDHLEbhG/2lYY5azOxhquoNqlP98XtrAUMvodZYAyj6KktLSNdGY40mlth8Y33zZukbmyJWtUpi7TmTT1AV8hGapKjBjAhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VatVKnLwZWzZjVGFn++44LU1OqukvqvM2EVWqgCl2/E=;
 b=VSqC9dgnCRnw8ROxU6oVH/rJ65FFCRyQVKpFTrDhg/v3ltXgpe0qljp09z2Pdbicpa6r7TiF1tLE8mn/mZktnZn3uxp4UOaRFfVCC23FnY+tBH32lTcAknK+21V2cyZdCuxyR6Mwt7mojQPeghlB3SEEL97VEG2OkFsfCESGqJ8=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1644.namprd12.prod.outlook.com (2603:10b6:4:f::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3326.19; Thu, 10 Sep 2020 14:43:20 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.016; Thu, 10 Sep 2020
 14:43:20 +0000
Subject: Re: [PATCH 3/3 v2] KVM: SVM: Don't flush cache of encrypted pages if
 hardware enforces cache coherenc
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
References: <20200910022211.5417-1-krish.sadhukhan@oracle.com>
 <20200910022211.5417-4-krish.sadhukhan@oracle.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <743d5a76-4ae6-7692-70ad-eaae12edac46@amd.com>
Date:   Thu, 10 Sep 2020 09:43:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200910022211.5417-4-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR16CA0038.namprd16.prod.outlook.com
 (2603:10b6:805:ca::15) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN6PR16CA0038.namprd16.prod.outlook.com (2603:10b6:805:ca::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Thu, 10 Sep 2020 14:43:20 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ee70664b-ab8c-493e-9571-08d85597dcb9
X-MS-TrafficTypeDiagnostic: DM5PR12MB1644:
X-Microsoft-Antispam-PRVS: <DM5PR12MB16443435FD51615DDD227845EC270@DM5PR12MB1644.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mbo/UYnAtP2B+/4dxIINrLDABbLJolXTz2rkD7PILj8OHDlyp2xdJ3zDVmT0gmx5kJUIfOTa08xdcBRFNHiWMRluUaeK/mrCW6y6vG+d7QSNKqbi23gWWwOKtSDcOnWp3tqnlVrd2mcoKcJHyf0QoQpHEy2LxZmEvenX9S5riiebU6rBIRd+t0cVRhZAW1mBjbEL0yLcruMEkC5B/eyakzomX5D3HrMZjPR3fufxnn4pbbHFFzzgYjzAhxxuSgRFGrf5uHtAfgzfk0sQ3FTtZpiyaGXe1KrK5PhWebM0+/ZU2FVFqcXXw/8evoxzHQM+qEVUCGcYCK6MS1i+9MQRKVupyjyG4eUPzkHrsUDUYk/d6izf/SleTokxLDRg1q2J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(2616005)(52116002)(53546011)(31686004)(86362001)(5660300002)(6512007)(478600001)(6506007)(2906002)(26005)(31696002)(6486002)(66946007)(36756003)(186003)(8936002)(316002)(16526019)(4326008)(83380400001)(8676002)(66556008)(66476007)(956004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XWwYQuPCiOrKWCXXYEVuRbI/JFt2sZYNXRXzZkRMNa8IlDxgYcgOKNBAhCxCIOE+dUqi3Bkyi1X0KaGUywFKzV7ZGGVSh+xNCCnJvux5LGihbh5Skc6QOHacfRfmqqB4RZdJd9A80sJdQt7fprJrSif3fPAiwT1E29HtlngEzIu9VeYInIlq/vFcfGHIbewpkB4cZ7biJHj60fXl1gkrSUxLlPelQ3acqe3Vbe8BUb0AeFNeR8lA/8z70xam3JMT2+3Ukl9kqaGfwd7jOYhLib4Y/NXIQN0s+4C8Emm09+SeLQ6ehSwHQjkkD1rO2zLKVrL1Riwt1NbR6Fk+VeCaLSycQS0Coa53OKDat9LCh1HpDAArG4Q/6RbpQhEGEtskj/JW/7YF/1cW57cI1DARvrOqcWjzrqIkXuU7WEiYfNV3Uca4K2c9u450dhXNreAigq9uc9uk4YuYLC2mUTP5KwRDhKJ2pTux2JKnI5tKd/YTizGPY+Wq5SCprdhsnzV+jjUNzW8vHO+m23KbDN/B2oxVexYrhNRJKgz0r6DMu9TtkDBnWxia+5sHGldSN8LfxMMBWpdDZyyzIlI1xUrd17FZyJY8Y1ltQPE125rJPKRmmKRy4hhApfnGjuOQNtKC76BVMMb0gxwVtJjRkhXLFA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee70664b-ab8c-493e-9571-08d85597dcb9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2020 14:43:20.7646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DaeV6a7IM2WLSkhXfkvBjXxBsx6TuxiCvRenu5n+xMF3/Q0Io5e6CgD0CHdAZ9g3G8MLHKPuUtzjVcwtL2HNqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1644
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/9/20 9:22 PM, Krish Sadhukhan wrote:
> Some hardware implementations may enforce cache coherency across encryption
> domains. In such cases, it's not required to flush encrypted pages off
> cache lines.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>   arch/x86/kvm/svm/sev.c       | 3 ++-
>   arch/x86/mm/pat/set_memory.c | 6 ++++--
>   2 files changed, 6 insertions(+), 3 deletions(-)

You should probably split this patch into two patches, one for the KVM 
usage and one for the MM usage with appropriate subjects prefixes at that 
point. Also, you need to then copy the proper people. Did you run these 
patches through get_maintainer.pl?

> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 402dc4234e39..8aa2209f2637 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -384,7 +384,8 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
>   	uint8_t *page_virtual;
>   	unsigned long i;
>   
> -	if (npages == 0 || pages == NULL)
> +	if (this_cpu_has(X86_FEATURE_HW_CACHE_COHERENCY) || npages == 0 ||
> +	    pages == NULL)
>   		return;
>   
>   	for (i = 0; i < npages; i++) {
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index d1b2a889f035..5e2c618cbe84 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -1999,7 +1999,8 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>   	/*
>   	 * Before changing the encryption attribute, we need to flush caches.
>   	 */
> -	cpa_flush(&cpa, 1);
> +	if (!this_cpu_has(X86_FEATURE_HW_CACHE_COHERENCY))
> +		cpa_flush(&cpa, 1);

This bit is only about cache coherency, so the TLB flush is still needed, 
so this should be something like:

	cpa_flush(&cpa, !this_cpu_has(X86_FEATURE_HW_CACHE_COHERENCY));

>   
>   	ret = __change_page_attr_set_clr(&cpa, 1);
>   
> @@ -2010,7 +2011,8 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>   	 * flushing gets optimized in the cpa_flush() path use the same logic
>   	 * as above.
>   	 */
> -	cpa_flush(&cpa, 0);
> +	if (!this_cpu_has(X86_FEATURE_HW_CACHE_COHERENCY))
> +		cpa_flush(&cpa, 0);

This should not be changed, still need the call to do the TLB flush.

Thanks,
Tom

>   
>   	return ret;
>   }
> 
