Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9BA2F6D2F
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 22:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbhANV1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 16:27:45 -0500
Received: from mail-bn8nam12on2042.outbound.protection.outlook.com ([40.107.237.42]:60001
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726712AbhANV1o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 16:27:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a9k64SuNyf6dPIXV4iGWmadDyh5pqAbf2kK+kHLnH0tfZzWnFUCyY8g+NFjZO3puAVEK/xsYYL/SCS9eqxgSkgEq+bCwq+EVEmr6LwcUaZfNmXSgaJ78vGs3+zO37+AAcfzY7MP2bAY17L1+3JnAYTPL7XG5Vylt+K5zWHNfm8WAvGq0SneuO56Wri31oKVZmXEH8+XPhrFVb4M+wEyRnX5zE9cGhEOqJxMQlmr1QWi9RLldXZCS99ygcAZMMLsEEhOgYyVeau19NPX8xJ74VGOSIzISjOAem/+VDs/VpOL117FerZh1HezU8M78GYyJay3eAuYScWdztDRKwlOpGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCh5SHdAKMaVAXDQvmdDfsXhToif4rP8HXDLqTLXpEI=;
 b=hU9GV+2mxl+5Hbf/G5HduLdTc/Cc2iZTqmwErtPfZqXoNgb7hw/tTlYQ2oj0mI3jfJKiNDo0YB/0NEdlskCrUQkA1+LnOVHcoLBRppbVemDcM3qeHgbSRVxEXpLtxrwMxj95F0xle1Vv2YPjB9GxqicDzf3ROHX71ED5hmAYEHLb5o/Q+oYSZyN8J/c690LdY1gbrdxHIfPIyjiwScJzJRzsQZke5cAQIuhwnSic3bXBK3LhZ3pR1trgaKq42dr0g4xORHy4Cc3f/mcj+HinMb03Yy/sGz1f0tpadT8zT5RSmMa6KVkY3S67vNS5+E8TqvYkHDJNRznw3gx4V95U0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCh5SHdAKMaVAXDQvmdDfsXhToif4rP8HXDLqTLXpEI=;
 b=3o6CTZAq+XJs2pDYvYvA7h38C5RpGiUhuq9NsaqraPZ9V5kmLHQtBodjChOlyUDfyDbIA/e+W44jWK73kd/vuf9Z1HXMvf7gi5YRj3yzRnph5VZNUsthmjFrGOug6cNqe6AH5TlwgwIFJAyja8De8w9zd2MnbTmJc3x5bgJdUPk=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.10; Thu, 14 Jan 2021 21:26:48 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 21:26:48 +0000
Subject: Re: [PATCH v2 09/14] KVM: SVM: Unconditionally invoke
 sev_hardware_teardown()
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
 <20210114003708.3798992-10-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <a0ce54d2-7fc1-0357-26a4-e2bbba417699@amd.com>
Date:   Thu, 14 Jan 2021 15:26:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210114003708.3798992-10-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN2PR01CA0038.prod.exchangelabs.com (2603:10b6:804:2::48)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN2PR01CA0038.prod.exchangelabs.com (2603:10b6:804:2::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Thu, 14 Jan 2021 21:26:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f153b77a-14a3-49ce-7784-08d8b8d319b1
X-MS-TrafficTypeDiagnostic: DM5PR12MB1355:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB135567D196B49CE190D0E10AECA80@DM5PR12MB1355.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ix2xZ63GJvbON2YAR3SgPbOcI+vx5TkXvLa4+YepoDxJRe4cMuUmllL44a5zr7fSTzUiE6pmchabRswsu5D4Os0i+e98rc+A53CsnTNXbAaVU9072zA7wHdRuvTzTEVr7fkSb5/o5sFOPJLhFTn5Yxj03CAGIY6ErLC+3E+eS5F6snqkzziWvTg9O7bK/mHmeMmwbq4eLGsXEHSN8Yzij/KRhMlr+JuwSAYmT+iOL0owAOYwZrgdcPR/fxX1mPJM5wcIHW091rxiXZUqS8lMoCnCggEDi+xu81DjkXfXmyoP1r6Nn/x5At1LqbKAzVQC/M40gW53935aaKdOD+JXvK6YrAonJdVqV3IxfCn8Fim13OMX9J5MDO1uy3Wu9igCKTf8R61TIdAmPGj0C45mNXDTO2pbunNEoTNv5yqLbfXoQSsH7LWISyNvA268RDz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(31686004)(83380400001)(54906003)(6486002)(5660300002)(6506007)(16526019)(53546011)(66946007)(8676002)(26005)(4744005)(110136005)(478600001)(186003)(52116002)(2906002)(66476007)(2616005)(6512007)(7416002)(86362001)(66556008)(956004)(36756003)(31696002)(4326008)(8936002)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MHExZ0gydlFFZlF3UXl4cVdnSi94UVkrMEE0MVF4Wld0ZnlJMi9jU0pxZTEv?=
 =?utf-8?B?c2YxVFFWL3VzSGhXajRpelRFdmYxR2xaM0Z5c3h1aFlabWdZNGdPY1NKY1lG?=
 =?utf-8?B?eDZmVUlwWCtlSjhDb0paWE1raVB1Y2JxbUpLVWVuVElzL0FML1pKdFIvRUl6?=
 =?utf-8?B?Yk1qQW5jaEVCM284ZXZDUXA4WGFtUFJOUnV6ZXc1NUsxTkZHMnZsN0tVQXdG?=
 =?utf-8?B?aVY1NnY5UDVvQXZTRExwWG9LWERFTm9VdUJ0NGhHTmZyTkdwSFA2MGt3Y05C?=
 =?utf-8?B?TXQrRi9XdlplL3M2anFGTGwrNkR3Wm5hWHlrNDNoKzBoSEgrbW1sd3VpTUI5?=
 =?utf-8?B?c0kwQTgxaUtUR3dubGhialFxaHphZTRBa0xHY0x3eEMyeHl6di9ITG5EdVh0?=
 =?utf-8?B?eC90akRJdThiRThlZHB5cGcySjJEeTJJdEZYelIzMHpVYm9UU0p2NUt0VTRJ?=
 =?utf-8?B?ZG9tcVRPSXFsUXN0U3FBTlVITTgzTHBtR1V0UVg5cXdwMzNMT1FTYlRxajJ0?=
 =?utf-8?B?alJjZmhmc1Y0OXVpd0ZzbDdTQW5INkZxQ3U0NWJnU1A5OUh6ZFlXUTVJSG5r?=
 =?utf-8?B?Y3I4SjBCSkJIVUNHWW9DMk5MbUdFMUJraFFzVHV5Zlk4Rld4QzZBc1NOTEhv?=
 =?utf-8?B?cnR5M1dZSGFvWFpra0poMFRkQ1BjWlloalQ0ZkFHTG4vL3Rnd09YVUdsRXg3?=
 =?utf-8?B?cnpCN1NaSnVnb001cVd0ODNsQVhyM01zMm5jTzZTdHlZL2hNTHZsWmpOalpO?=
 =?utf-8?B?UkZFd2lNZ3BYZlRGM3BHVE85UU9oTVl2dnV1Sk5OZVJEck9RSFpxL2dSU2xI?=
 =?utf-8?B?cmRNcVo3YjJ1OUx1QzhhM09qM1lJajV6WnIrWlFBL05idjRSbGFhOGhzaUhQ?=
 =?utf-8?B?YXhPeEVKTlBzQTNYcnM4N3hzSkJwSzNwTTZ3b3V5NHV3UGd0YVRNekVEZXNl?=
 =?utf-8?B?eHlpUnVoaGtVUWtldEFpL1R5cStQSVFPdDBnRVF0dHYrZ2hXUkc5Mlh6YUdN?=
 =?utf-8?B?VUdQSTY4YWFkMDJrRHJCbUxZMUJBWmRUMEZvdjBoa2FNMTBUWThtSDYyaThN?=
 =?utf-8?B?SE5Xd3N2UzBDbkxueG5KZjdGNGZuY0tLdGhScy9HMkVmRDRkS0lNOENOTFJN?=
 =?utf-8?B?UTZkQUd4YmJsT0JucGFVMHVFRG16aklGeW82ei93SjNDdEpEZXpKVFB2Q3Fs?=
 =?utf-8?B?ZjZrdzV1SldLVVJFVjVaN1hNaTVZYTlJMnhNdGhjSU1IMVhwZU5VNnd6M2FJ?=
 =?utf-8?B?aFlsSTVWd0NwdnMwQ0RFLzA2MHhzRmNQWE5rTm1lY2FydTdvMXBZMS8wLzE2?=
 =?utf-8?Q?gdn9L1U1cLylpH87dQFL8ne/D5o7cUqnbM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 21:26:48.0146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: f153b77a-14a3-49ce-7784-08d8b8d319b1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N1yeBO9cja/DAjrTK8BUSTsSQtWm11go+2iL8agQPMCAgdaYr+pKjkG+Y9XmD+IfmCBQuq13FJ42YMliHaM9TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1355
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

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/svm.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f89f702b2a58..bb7b99743bea 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -887,8 +887,7 @@ static void svm_hardware_teardown(void)
>   {
>   	int cpu;
>   
> -	if (svm_sev_enabled())
> -		sev_hardware_teardown();
> +	sev_hardware_teardown();
>   
>   	for_each_possible_cpu(cpu)
>   		svm_cpu_uninit(cpu);
> 
