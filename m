Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC94257E68
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 18:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgHaQOx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 12:14:53 -0400
Received: from mail-bn8nam12on2089.outbound.protection.outlook.com ([40.107.237.89]:40248
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726249AbgHaQOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 12:14:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+lnerySDbiAkfZDeLsatFXMGPCZv7NJ7Se35LybLSvw9ZRf8iADPEeqTc19bF27AeUlWfdz0SIMt9RKQ7MCQLn8kw0FWHHyTyZh6BPI5ADkEWFCOXw7KQ41AL9ZGm1iUnGApfyI5h8aY+X7Cstb2i/OUttIPOEKK+rDz6a9mkYeneqPFSyxrjMIjgrtKQALPpY9efldVaewvmLjRbhW78l592SciMbAFqLn4ahAR81RGiJReinimXFsH+u2iTrsMqsajhXkQBIa0h2ZB4vIGGpI6dFmfOe6n9XdF2L5ch9aDjzsDyqW3ocVwkxMd1jUOS1t7fiHztUhQzAE6zPW4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iS3zHGoFsDQ5I2P2002+yENliBKjn2sXrycXirXgzSQ=;
 b=LOIIeDdtCQ/prIlFKq3xnhpFtElAfc+OcQgEVchbDOP9DkIMqv9aFuEC8/xY6WTF+FcBh1zFCNKppoutguAi6V/fwARDMAmgf7gJ3mScyh+41WNaNN6J4Y1Cfj+OtASakjS+a7ZfOoKTS2zjCEA1VQ5e/C9Dzt/Nr+K2tLoHHkrWnaGCnlj4j6ujmRvET4BQ6mlZTVoL7o4yt9hfOU4WGH9eZ9O+SbZA4CJQ9JdCwp190Kwo1OIKBwmW0DEvnyqKfsvXqgGk7isFu6a2w5K2G/e1jSTk0KPFYE2nuyR8BK/7rCNOfvMBAWdCbmIjiAY5Q1DJsmtBlcZe9gmlaebCoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iS3zHGoFsDQ5I2P2002+yENliBKjn2sXrycXirXgzSQ=;
 b=FnGZLGAFgSDaSuTXekZ9RD0KU47MSRLiFoazc4vDrKPs57TkaIsUzTMxoKQGap2sB54g00c3eqioCr61bQ8e5cuKu7kSJn294qeEJUPO98gMx+K49oRE/fnKTsj34NOHKQApltfS3SejozuDaXZ7TCoeaFOxaaZwtR8a3HvG/6Q=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4155.namprd12.prod.outlook.com (2603:10b6:5:221::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3326.23; Mon, 31 Aug 2020 16:14:50 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 16:14:49 +0000
Subject: Re: [PATCH 2/2] KVM: SVM: Don't flush cache of SEV-encrypted pages if
 hardware enforces cache coherency across encryption domains
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
References: <20200829005926.5477-1-krish.sadhukhan@oracle.com>
 <20200829005926.5477-2-krish.sadhukhan@oracle.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <ecf8a23a-8d7b-ed8d-e528-8298079d2df7@amd.com>
Date:   Mon, 31 Aug 2020 11:14:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200829005926.5477-2-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0091.namprd04.prod.outlook.com
 (2603:10b6:805:f2::32) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by SN6PR04CA0091.namprd04.prod.outlook.com (2603:10b6:805:f2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 16:14:49 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c131adde-dcfd-414b-6f6e-08d84dc8fc43
X-MS-TrafficTypeDiagnostic: DM6PR12MB4155:
X-Microsoft-Antispam-PRVS: <DM6PR12MB415581A3916AF1B482CD1815EC510@DM6PR12MB4155.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7lhJXPyQUY+sjZbSrH4iktSU0kYT4AY1QzxrZYouAnXOew5geFj9Pyand37t+nOLluJbDpBK3YDvvbdRS2ldWrNBlpJ9xjnbQs9fPMQUqlNOQyK/aGU5qZQ8P0wygRgmknxcoDO/Kf/BZ1ZTaPslzLh9s1ing05oCBTAod5BkzHb9HlROmnWOGbfoGsoXVDdoOSJBtx6SlFoDxGvucefdhY03CXXKschZdDXX2EHayFG5YUkFi9uzpfDYOS1uqf7xxQLWs7S+WHulVnEfY2gyw/3Lfn5kgxaLHu5F/dQSXHP5F95eYXrcHUpS4cZKLA1EqX3Bod6PJ7WWMOXWSN/JIeyCeMEREf8Im2unCKIVji+flmtYsX+kRFnUUFQXJWV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(366004)(396003)(186003)(4326008)(8936002)(2906002)(36756003)(8676002)(478600001)(16576012)(66556008)(66476007)(5660300002)(26005)(83380400001)(52116002)(956004)(2616005)(66946007)(6486002)(86362001)(53546011)(316002)(31696002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SHFo6XJl0K+pnVlXHcGGqgZeOrXqzE4rdXX8Fq8Z+v4okcJiwEei1hPUD7foHn37PheCcOAS+mD2CvWx3nEuTY0veKxmLNHK4HIe+6FuQ41TDecesZSQs/hXDzZQ/lAHc6ViZ0uwxD7Lgre6lG7gsamdsUq6pQcC8oCxplUTw/ExaoUQqYqBnflbbfBtLVUk+RIEwz1GXsC34jv/ECvv7qFYORpKnjqtQQdMAIN91+ImT3k0pAeiMFsaK2WZikAz0zC7PGjvnV5njD0iMHmq6G70/AaHkuaookzUdoPrzpWU8iK7BdJ/Mzse/o4IARzVSmHUfd1c5371SWcio7N5nGrwINsofza//ksz2oxOuF3+fSck3xUtn82zniRKjK6iybKyH1/rPIkxqXtil4EKQ/zZv3t9EFySe6M5/V5OEftoitU+9OSBtc+fiWzGjnP8iuLLKxH1Z7RsCUtNzyGOGXdNTGOcIlgvhsDQLKqlg9I3ZUAUoud4Ukd0+z44SMz//7yLBt169F1EXE6fSf6D9+O5YqmcH21HjHtNlLy6izZdomi2vWTBeqo/9dTdbksweO1RWm2lyIbHVA0EES1rCSkfX/De0DG11nBWvk+J0ppnr3b89ug22KvznZxVq3KUnms5A445I06r3CuHHvdrDQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c131adde-dcfd-414b-6f6e-08d84dc8fc43
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 16:14:49.6999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FM1Kokw67zk/ldqVQqShAv2FJqD4Jdbvn2SWF1LWteNn8I+ffMiQzKy1RdSS5IIAzp1wDSki2YLWzbTwjAaF4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4155
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/28/20 7:59 PM, Krish Sadhukhan wrote:
> Some hardware implementations may enforce cache coherency across encryption
> domains. In such cases, it's not required to flush SEV-encrypted pages off
> cache lines.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>   arch/x86/kvm/svm/sev.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 402dc4234e39..c8ed8a62d5ef 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -384,7 +384,8 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
>   	uint8_t *page_virtual;
>   	unsigned long i;
>   
> -	if (npages == 0 || pages == NULL)
> +	if ((cpuid_eax(SVM_SME_CPUID_FUNC) & (1u << 10)) || npages == 0 ||

Thanks for the patch. This should really be added as an X86_FEATURE bit, 
and then check that feature here, as opposed to calling CPUID every time. 
Also, there are other places in the kernel that this may be relevant, are 
you investigating those areas, also (e.g. set_memory_encrypted() / 
set_memory_decrypted())?

Thanks,
Tom

> +	    pages == NULL)
>   		return;
>   
>   	for (i = 0; i < npages; i++) {
> 
