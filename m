Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E072F6530
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 16:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbhANPu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 10:50:57 -0500
Received: from mail-eopbgr770045.outbound.protection.outlook.com ([40.107.77.45]:3299
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726499AbhANPu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 10:50:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9c5DEEdTn4PJsHAgtdzjqaV/NHT052CtNxoS8GebpdB+pCAp3ktod/YZrX+VTJEyoomP0Ya3N4fzqWMzza5cfyvs/b3UYZ9f2otVW6OmXeukKMMmhvlWzW7yl9imbB/xtNqjZqE6FFStRcV3zqnGcRF+hE91T5IcLDXfJuTCx37T0r2paJqUtsmangjDQH8CWzrnEbzKWlLO/j08tb4g/MXN/XjebxGDktddGB6g9amVsoj8fjvXjSHCpRrmOf1ra4UyZ5jTwnSg4pAfDAIdcTZ0ImEhyQCq905VKxvc2WJEp8cj729v1vZpOEnCGoyekKP1Ktf6XjZvhzfFIgA1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+y//rysm7yH1m7yHEYvBgwve9rFDejww0miYcSnK0wk=;
 b=CFf3yHSIw57GCozutb1cEVMbSpClt4cjplbUHsUp8TiSbV3luNavWp3guheGfUZbGHMCPsJeSQIMqziRXjarFRmXA7z9Msz4geDECxl50JE97FBuI6+BbjeFivrVdFcCgQE6UFJK6d73XdWGKkzZMqDu21XtnMK3GhL4e3Aitdo9F7yrCPYSNWTJoKWmEzfSkspAnkc7d9qRHtAhKNpkAOXcSI8oxMm+VCeNsr8YnaDyTDu3O60HOJn9BcnCBF1cnYFjSQLU+GNbOfZEyR2HzlqIC2Fz60TUhZR1B9q0CMcTlh4oBmkGDPpGYZ/EdzlH9YfBTqOf8fk940+Ge91b1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+y//rysm7yH1m7yHEYvBgwve9rFDejww0miYcSnK0wk=;
 b=pVedTfC0v+HHPbNeHfg+GmxRJKKNKP2nnhV/PemT+BVGlaoe8Hy3AuftTL2sZpxSpzhTDKvnNFyN67cXaHcTEYNDDAUUeGlDIPbzqvwzsZMbevhtuWzXWYy67aEKM1dukjuFRRkqWoDLApnEJFK18rlfjM6zEd1QA2i/GKNuC/0=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0220.namprd12.prod.outlook.com (2603:10b6:4:4e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.9; Thu, 14 Jan 2021 15:49:25 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 15:49:25 +0000
Subject: Re: [PATCH v2 02/14] KVM: SVM: Free sev_asid_bitmap during init if
 SEV setup fails
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
 <20210114003708.3798992-3-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <b1a6403b-249d-9e98-3a2d-7117ed03f392@amd.com>
Date:   Thu, 14 Jan 2021 09:49:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210114003708.3798992-3-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN6PR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:805:de::46) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN6PR05CA0033.namprd05.prod.outlook.com (2603:10b6:805:de::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.6 via Frontend Transport; Thu, 14 Jan 2021 15:49:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c3c2a410-4c0a-4df4-4bf6-08d8b8a3f828
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0220:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0220F4FA4257A00AA7EF9BB1ECA80@DM5PR1201MB0220.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hdTEFVfnZdRnLb/hmUYopJTLZnp/aYWgAMPWvPCety8i8+gBohd6y1w7M5aNmrmr60wGIPBw3ElQx19TS/m6OimMYCUADMYK6XUUg6RHl9igSD2SULRkBH1zfsc3qWviNNmm9B+2dJtGLSxmStNbrRLLdiqDBvV6tSXvyM3VNsqEHJh6GqEx6ejm7khyvOY7Ek/Ww4QTvjqsgYuJPvB2y2FlKSyXB2u8ID7PHwwr8NvvEo4MCSf1oq7zNZZt9mQOBR9qirayB79mKd3Fg2xXaN+x4+kUQf8cutltzsaURvJNtXaseZogFPlsU5Ni5rhQwNQJjFnUxbztWA2sDlBdPduY91acHs4Vx1DQNcEEYvuZzWlq4RFCMfmI8Q8WXjuqI/b7D3cmOa1pR/1ar5H6xhYll/4QfkMFH1ZWEbld1Kj8wYnIIFXes24/QQMLncKav92QCLq6y07poYH3eVFk5VrOESBG5zQ++Ns+RR0Fq44=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(86362001)(31696002)(8936002)(83380400001)(498600001)(8676002)(2906002)(186003)(6506007)(6512007)(31686004)(26005)(16526019)(110136005)(54906003)(36756003)(66476007)(2616005)(956004)(5660300002)(7416002)(53546011)(4326008)(66556008)(66946007)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Myt2NlhtTzRjMW41ZFdHenUwbGhvNG81aUs3d0NrY3p4dE9nWm5zSkd4eEtE?=
 =?utf-8?B?djVQR1VxWmk4cGdyenYweGRKVkJLc0F4UVcwMDkxSysrVzgxY0E4U2F6dTVQ?=
 =?utf-8?B?OEczMFdIMGdHbitoODNWemVUdmlXVlo3TXQycXlrQTJvaHR4VVpDNnpZcHRG?=
 =?utf-8?B?TlFBM1phSjBBdFdUV0RxUlpObGhlZXMwMFZWRFh6UjVWQ2ttdkFXd0lPRDNn?=
 =?utf-8?B?RmZva0FvRWJrb2Rtdy90RWl3NzNOemltSjlUTUphalVvWDk2aHVqWk9iTjJR?=
 =?utf-8?B?bUxzcGx3MkhYeTJFS01lekp5Wkx6NnFZbWx0L1owY3VaQzRzTDM1QlUvMzlh?=
 =?utf-8?B?cDVVSzZsN1IzVWl3a3NMcVpNaDR4WTE2TVlwbmNvUlkvL3dPM2ZLaWdlVHJh?=
 =?utf-8?B?UUIyVHBpaG9BaG1BcVAvZVBVY0txczZ0TDVYVFpqTlRtcEQ5S3AvbTVxb0NF?=
 =?utf-8?B?czBxTXFxSmZLVFo5b1oweGkwaWZFaGU1NTRvcEdvdHlNRXBXUG5sVlNjTXVz?=
 =?utf-8?B?UXMvbTJ2dVhWS0JheWZBK1FMQW84enEyZG1wMlhkQ0xIZiswekNiSmc4NWlQ?=
 =?utf-8?B?NkVEbkZheFBRQm9kYnBacitSV3NjOU9LWkJWeFJXUDJ4N2tjREs2RkJOTERD?=
 =?utf-8?B?cEJvbUIxbEMyTm4xV0pNdEtBcXRNV0k5b0lPS1pHVUdEK1VlejJEcjl5MnRq?=
 =?utf-8?B?dWNBdGZTVHhrUWt0UTZ1VUpYWFJvZVF3dXlMNHdyN3RJZm5vS3ZSWHIzT3BH?=
 =?utf-8?B?ZG1MLzdVT2hSdXFCVDlmblY1RGFYZndSZ1ZlaFRzM2liM2xtRzlPZVpHQXFJ?=
 =?utf-8?B?WUZDR3ZLVkpkTDFMZGZuV2JvU0lmOUVaSkE0WEl4TnB5TlJCTUtnUEVEQ0R2?=
 =?utf-8?B?cDRhVm5rN3krT2JVaEtGTkFEa205TUcvSGlGYmxyUzBWaGtrdyt2WGRZbTFh?=
 =?utf-8?B?aUVJaStoaWtCNHFyMWxMZEVUZXpENE1oMktLSy9nQm5RWjNWNUxwa3k5Q3lN?=
 =?utf-8?B?clVQaDMxbW9SUXNVbGlZSy9mY2RWMXpab3hWaWMzU0FEZm5vUExMTlYyRWg3?=
 =?utf-8?B?NmMyYkxmcEZqUTJYRjJNU1pwTldlb2o2QjVwLzFJbEp1ckF5VzNPNHJIdGor?=
 =?utf-8?B?ZWpQc2F5RVFKYUttMkc0VHFRK2luWXcwcFVRN1pCejVCc0YxZ3F2anBJU1Np?=
 =?utf-8?B?ZlRlWUs1VFRMalZ4QlpkbTFjRTFDR1JyL3VtQlI3RDRsY2FSeTl3TlBUWnI3?=
 =?utf-8?B?ZXI2NmFHak0rWkMzRkJsTFB4US9KQUhzcEI4eXU0MWNWWEFsMENiK09xem0w?=
 =?utf-8?Q?unwspN8/1/i6LIK5noerb/lWptDKYTQGv1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 15:49:25.3946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: c3c2a410-4c0a-4df4-4bf6-08d8b8a3f828
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G9ZKXVvOC/IgcYiCogvSAvp/WTL4ZtAeCEC0CNGrCKx8dkyG6LN2IRz+/H/78+Lbpixy+WS/6GO7nmPlLX24IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0220
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/21 6:36 PM, Sean Christopherson wrote:
> Free sev_asid_bitmap if the reclaim bitmap allocation fails, othwerise
> KVM will unnecessarily keep the bitmap when SEV is not fully enabled.
> 
> Freeing the page is also necessary to avoid introducing a bug when a
> future patch eliminates svm_sev_enabled() in favor of using the global
> 'sev' flag directly.  While sev_hardware_enabled() checks max_sev_asid,
> which is true even if KVM setup fails, 'sev' will be true if and only
> if KVM setup fully succeeds.
> 
> Fixes: 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations")
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/sev.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c8ffdbc81709..0eeb6e1b803d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1274,8 +1274,10 @@ void __init sev_hardware_setup(void)
>   		goto out;
>   
>   	sev_reclaim_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
> -	if (!sev_reclaim_asid_bitmap)
> +	if (!sev_reclaim_asid_bitmap) {
> +		bitmap_free(sev_asid_bitmap);

Until that future change, you probably need to do sev_asid_bitmap = NULL 
here to avoid an issue in sev_hardware_teardown() when it tries to free it 
again.

Thanks,
Tom

>   		goto out;
> +	}
>   
>   	pr_info("SEV supported: %u ASIDs\n", max_sev_asid - min_sev_asid + 1);
>   	sev_supported = true;
> 
