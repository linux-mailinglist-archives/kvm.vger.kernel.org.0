Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B58A2D9CED
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 17:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501984AbgLNQqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 11:46:30 -0500
Received: from mail-dm6nam11on2047.outbound.protection.outlook.com ([40.107.223.47]:3921
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389013AbgLNQqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 11:46:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=niwaKd9stWM17YFktWdqcAkYwvku7J2OSHywC6Q6g5ktZlN4VgJC51FXfAIhYl6vfdiU+vRFwxAebYOa333OztcPHTW1aKsI7MuHPLbP+T5DHiViajLYA7zBWtirToQyezujPDL006fy3m4Afqdgz9HclhMYcQVXj3JvmWrX2UR1N40Af/Y+0Ihihg8acLBdlqMX1Q0+5awJ95cA2U3DCnWottGFaIcQK1rY9OY9wPATQwhAa0Km8Mq8/k68U+UMfxyXeqaC2Tzj8Vmz6ueAtRqdLl7+2HdVCd9Bxlmpn8FihNDlPv1QsIH9l/1YvlmL7VhUe8iL9Ur4EkQQRW47LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYJs4No6CGxwoKq8YRi99aK2jQef9Ma4gF3+9OfzsaY=;
 b=nYYkFqV8Bx3ckazkyrzZNRYh1D6ZYFPKHJUZBzx9k4XfZnZwW96YrkD9bVFTbJyfaUtAAVy0R23ziMBOzPaS8TYIJoNPehi3vg/z43/aoeA4/wR4Gs0v4e8X/XomDV5yrAJdIeSOhlRcQty4R8VAYSyAgCEC3lVwUp58yXSojsG4K9qyWftNAwXL44tPB/1FfNob0LJJxv8DdpYwsn/w2x86Qr1uw9USNopMVRWq87m0P4dQwatX/4sDMbzUs5dUQU6nkxzPOfMAnwEi84zZo2fBwwgLhXLQDZohDQJFmS1aIn2QRZQ6e68WHCfZlpON+oYA/oUgPSWWzRfZB9rhNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYJs4No6CGxwoKq8YRi99aK2jQef9Ma4gF3+9OfzsaY=;
 b=KfWdNaE4r8tb5JYcNypsFIkX2Q+ubEHLt+PBtMRCWWDAMuyyFdgsgq9dpwlrYqncT3XMXYmx6ddVIrU1KPUDAN/dF4mCJDRj0L8QL6hLb0ZIkNj1d07XJtiDJ1ht+A3JzTVg0VWQEls81N02z8Pqijyi6yyWyKoOmzsHn8pobuk=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1834.namprd12.prod.outlook.com (2603:10b6:3:10a::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.12; Mon, 14 Dec 2020 16:45:22 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3654.024; Mon, 14 Dec 2020
 16:45:22 +0000
Subject: Re: [PATCH v5 02/34] KVM: SVM: Remove the call to
 sev_platform_status() during setup
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
 <618380488358b56af558f2682203786f09a49483.1607620209.git.thomas.lendacky@amd.com>
 <a1a912c7-b2f8-561b-c569-d74ff946c9f5@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <cb08bc7c-5acf-bac3-5c45-1983eda3a1b5@amd.com>
Date:   Mon, 14 Dec 2020 10:45:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <a1a912c7-b2f8-561b-c569-d74ff946c9f5@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR15CA0002.namprd15.prod.outlook.com
 (2603:10b6:610:51::12) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by CH2PR15CA0002.namprd15.prod.outlook.com (2603:10b6:610:51::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 16:45:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1e758f5c-b9b1-4f4b-655e-08d8a04fa660
X-MS-TrafficTypeDiagnostic: DM5PR12MB1834:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB18340F8202977A84B49FBFC2ECC70@DM5PR12MB1834.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 83TR4+EPRWeix9n6wPU64oIKqZETDuQX9s/zGhhfGFVQqi0sv+7qsEJsncucZ2mQW7AtGPNyRvu5R9+As8lhvvMdLPCOFK7PeN6KCrwVbPotRiIHi/hnQLp3rnGpRqRbqH6suRA+doDtX5gipWX6XgVQCGGMgx9HNjmcOhOyJrIuj3XSDCFrkPmaXymjX6TUvhyGl6vzehnDq3jafWLWGjhEZX+uKTHXtEaDt5p+OP08K8oZHCP12w7TF191F8TQjKg9ps1yVa+KHaoFxefdv7R9LMLitvXFP5goXDYwquaErxroo+HUQ60wvW4SE5nhwIqwtdhNmNKeAavtHYs2M+shd382aLOZzfu23MfpsmC1iD9Vpe9NQufmyOQJYGsQqvXM5PRO9KJG61y9mQ0Xiq6+N7p0jvpi9UO+CBdQu3y2BxLSSys53qu+JGdATnGJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(4326008)(83380400001)(6486002)(2906002)(54906003)(16576012)(34490700003)(2616005)(52116002)(186003)(53546011)(31686004)(31696002)(16526019)(956004)(86362001)(508600001)(66946007)(7416002)(26005)(66476007)(66556008)(8936002)(5660300002)(8676002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WG5WbzJjbFVtUDd3RmwrQ0daT3l0RCtIcTJTdGIyTm03UXpHeEl6ZlQyK0g0?=
 =?utf-8?B?SjEzOGk4YUh6NXc1VE96blFpY1ZMUnJ2Tk1Ha2FmUjY4WllRRVJCYXpiVDBE?=
 =?utf-8?B?d0VPMUpwSitFL1JIWGVlT2hhSlJKL3lJa2thQUFjOEhFMTFYTzA0OTFlbUdm?=
 =?utf-8?B?TGxNNmtMNU1FTmtmb0hkNm02R01UaUJYQzU1cU45VzlRSDhUd3NPVHNxVi9T?=
 =?utf-8?B?K1hDWHJtQWpITThNdnU0TzlkLzVvT2s1Zm15ellqUjFrOWV5eEozWFQyeUZh?=
 =?utf-8?B?WXJTRE1HYXRJUWU4VG9zcHBVN21iMGUrVlQ2NWdJWldSS0s3ZmlJa041YmFH?=
 =?utf-8?B?Wm5LNFhHL2xodVJ4YnhHbXBGYmlsSGxvcGQvd1BBUmZScGNxeWhnTHk0OUEr?=
 =?utf-8?B?ZXlDZldVT0p4cWlQdzdZaFRTaVFIWmExNitrcjdneDRiLyt5RGkrNGtrQ28y?=
 =?utf-8?B?RVpJaVVpTGFXRHlRcG0xekc4Tkk2OFF5cUFBUXE5SWIwcU84L3A0OXNUZWRO?=
 =?utf-8?B?N3VSZ1JhcXJBNkNBRDExc2hnSmkwdDNtcXR5Vmtjc3FLSjVvM1QxcS9KYVpK?=
 =?utf-8?B?cmRSaGJWVUtrNm0rN0pNamo0N08yc09LWE9WSEZkMmpmU3M0VHNuaDhUYisz?=
 =?utf-8?B?UkRSMEs5ZU0vZkVoMDFNSkdNWlFZV255Z1lwNjkxUXp0NzlGRkcvMjZvSUMv?=
 =?utf-8?B?UzI2TmhwR2p3c3lxaDUySUgzbWdFM2d1elF0VEZDTlNBM3FHd3l2Nll3NTMv?=
 =?utf-8?B?SzF1dXl6bFdWWG1mR0FlWU51d2dGeEdqdk9zVkJOUE9ib0tSOUR4UFZiT1pl?=
 =?utf-8?B?anZJQVA3dDdIeHg4bU5RUk5mdEp5WHFZODEwRlNHZDZBSjhzMGpJZWZabTJj?=
 =?utf-8?B?SGhHV2F5eWh3UjlLaGM4RFpLOGt3UmdkaWhVMlkxVVZmV0ZXeEVxYmhLamQ2?=
 =?utf-8?B?UmF0bk55RXhLNFE5b1E2NWl2ODdEdmpNY3JsOWdLMkJEYUlUYndFdHBBdHBh?=
 =?utf-8?B?N3lxYit3N1NTVTJnMk4wVk9sQmxyb2RPN0R6MzF3OTRNZGtDTVNIeEVmM3di?=
 =?utf-8?B?R3F4V0t2RzNSSDFmTVRBbmtPUjVPNmFiaGpGY2UrNE1pVHc1K1VvZE5lL0NP?=
 =?utf-8?B?WEkxMXNGQm1qcEphS0hTeFlWb2ZNODdsMEdqWE1jVEpNNUZ5VHQwWTlZNU8z?=
 =?utf-8?B?a2NzeGJleC85UlZDNmMzcnBiL1ZoZUxOODdzR2FZeTJlZi95ZjhDZ2tWekdD?=
 =?utf-8?B?NUdKZ2pDSmQ0SGRnS21yb1NDM2ZiZWZ2MTI3cTFadHA4eFdoZkdLNTBHZkF0?=
 =?utf-8?Q?S5li1/ydEIE0wxAJHmGUJH6G2gv+hqQrcA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 16:45:22.5541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e758f5c-b9b1-4f4b-655e-08d8a04fa660
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sICSJg4btAbMx+fLM9ZoVVk42LSJIksW8/qGts4AcOmgwHneMrX4JVVDdGu0i+Dpjkx596rYWi/l8jOUv13i1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1834
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 6:29 AM, Paolo Bonzini wrote:
> On 10/12/20 18:09, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> When both KVM support and the CCP driver are built into the kernel instead
>> of as modules, KVM initialization can happen before CCP initialization. As
>> a result, sev_platform_status() will return a failure when it is called
>> from sev_hardware_setup(), when this isn't really an error condition.
>>
>> Since sev_platform_status() doesn't need to be called at this time anyway,
>> remove the invocation from sev_hardware_setup().
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>   arch/x86/kvm/svm/sev.c | 22 +---------------------
>>   1 file changed, 1 insertion(+), 21 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index c0b14106258a..a4ba5476bf42 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -1127,9 +1127,6 @@ void sev_vm_destroy(struct kvm *kvm)
>>     int __init sev_hardware_setup(void)
>>   {
>> -    struct sev_user_data_status *status;
>> -    int rc;
>> -
>>       /* Maximum number of encrypted guests supported simultaneously */
>>       max_sev_asid = cpuid_ecx(0x8000001F);
>>   @@ -1148,26 +1145,9 @@ int __init sev_hardware_setup(void)
>>       if (!sev_reclaim_asid_bitmap)
>>           return 1;
>>   -    status = kmalloc(sizeof(*status), GFP_KERNEL);
>> -    if (!status)
>> -        return 1;
>> -
>> -    /*
>> -     * Check SEV platform status.
>> -     *
>> -     * PLATFORM_STATUS can be called in any state, if we failed to query
>> -     * the PLATFORM status then either PSP firmware does not support SEV
>> -     * feature or SEV firmware is dead.
>> -     */
>> -    rc = sev_platform_status(status, NULL);
>> -    if (rc)
>> -        goto err;
>> -
>>       pr_info("SEV supported\n");
>>   -err:
>> -    kfree(status);
>> -    return rc;
>> +    return 0;
>>   }
>>     void sev_hardware_teardown(void)
>>
> 
> Queued with Cc: stable.
> 
> Note that sev_platform_status now can become static within
> drivers/crypto/ccp/sev-dev.c.

Nice catch. I'll look at doing a follow-on patch to change that.

Thanks,
Tom

> 
> Paolo
