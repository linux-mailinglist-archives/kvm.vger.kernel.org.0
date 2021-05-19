Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7033894A4
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 19:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347785AbhESRcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 13:32:13 -0400
Received: from mail-mw2nam10on2052.outbound.protection.outlook.com ([40.107.94.52]:53728
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232363AbhESRaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 13:30:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZ8PFTtDvw1rx+GPy9VHG2xqz3DN4hy6ZQKXFOjDXpO457IGGH/TxeuT4kZNdXZ2QxvJLIiYJWZPoO7X5heax/I3pja+8jiQ8XBg0sL+lX5Iz50B+hRvqf7xc2ArqHI02QhpvgF4TtHE4mJRudf960ztsEwlW/Le8nbnuXf2NfKnxaXcL9iVxUHeLPMii/TVXoIoLbKFwmwvbp5OCe+5u2dizsbc6cStxmKqQSkaREZriefv4OyqDlLoVsQQEoocUVGyJoAhMVYbPOeUkxaqVHfoEjPmZJlI+/xrLCpzfLtrC3pfSxlatARJFmPJDrEE0Tf3BfCdTPp+2KRG6N814w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e/Asv2DMReTj3AhzZlM/yuqhEXR6kMVqszxGTPjPOUk=;
 b=DllMpUNsVvyT8hmvsrOahshz+A1r8HwUqXYwiaRTV4cGn3DXaE7fu+BYOOFsS8Qan2keVCjcthSb7zEwFjHSvcGWURle6gLZpH+ccHDqwIJ78QY0zpoVDnFv2LKUuUG1pIlR1ODjT56whQANfEM/6xiPK0H6bNiBjLmTjHGEo20bCBc/FidYHKcJfG+O+8ICRK8l61LxmaBPvZ3SN8Lzur6qUxtdNmUKKC9loDGEB/2ZBBl/sS/deLKXMSK2YaQuk8AlUI/C0QLDnweNapHPLV1Ucxr45Doncn9LTH/B+6EsGApdNRaP9G6OCTQthhVA0hLf7EAMGeYgrnISJ8f9ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e/Asv2DMReTj3AhzZlM/yuqhEXR6kMVqszxGTPjPOUk=;
 b=gD/seHTXG5wxmrbq3X+Kl2cG0G5d1b7ZbUJzpApAS58OatHrP/SPsBnVpR0DRY/Km/QDA1+lesU45JPzsz75KZx5J3VuY3YdejdfUfZAn+BfQG5/IN/f4p+D92rG2x/BUCXu9u6DTQ35OoSY5sIE4cg3SKHiDfhpob43VO8zzZM=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2512.namprd12.prod.outlook.com (2603:10b6:802:31::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Wed, 19 May
 2021 17:28:53 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4129.032; Wed, 19 May 2021
 17:28:53 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 08/20] x86/mm: Add sev_snp_active() helper
To:     Borislav Petkov <bp@alien8.de>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-9-brijesh.singh@amd.com> <YKQDNg3keYJGnEwg@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <82338258-a0b0-c67d-5ec3-87f1483b76a9@amd.com>
Date:   Wed, 19 May 2021 12:28:50 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YKQDNg3keYJGnEwg@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA9PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:806:a7::20) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA9PR10CA0015.namprd10.prod.outlook.com (2603:10b6:806:a7::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend Transport; Wed, 19 May 2021 17:28:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 102cc31a-96df-4b7e-0c2f-08d91aeb92e6
X-MS-TrafficTypeDiagnostic: SN1PR12MB2512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25120669EAA36AA8794B8D67E52B9@SN1PR12MB2512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YztGZ5pnRXlLiO1gOVHbie3CRvHgBiNcUUS2Lm80r0gpuBjoX/7aKS3wjTOjFBC8c9JN2BNb2EXdTq8UiQutKAM5tx0eqowpQOzSH7kQ42fqvtlgNZbZUi4qwLcGjfqccjNJZWCp3FsX9Rj5f4LTtFmA52Qb1gTWtwVae1pW5GQrf27ry1E03QnbcKL9/ltEjRZEKDGkiidvXZZ6FZaLaGZUiZip7Z0lD/l/WnD9eypHtIf6cU2I4MmjxtfL7/NIdEChXB6AcZFXWVC76tUbyO7fLhq0PUo5eYGtHnGtHrS1CR0FgqwoiPrwyzcFHlb1NXaIk+Nz3t6Nks2DUHNzbk95ST/PAR656QVWqE7H1AlBvuMiA/uFj09ECn8BjVP7y8tGElstZjZ7j/jkqP0opCU5ADYpw4+RDi7KtbRk14PEbbfCcJeQexPnmYtC7w/XDlFg4vr6Z3WAV4EJEjWutYhXcLWZuRkLZAh9no9xV6Q9aPxVCL6B/m/6XCKTtwdj2RUxT7SJ7huiOCJoEsMB0Y2dB/ZZLG7dJ6pL7A7hetwOa4JLtbLtBMd/+28arwLuSX42Vwdaoxtfaub80XYvgLMjey6I4nrl5PG118zK/mxGfu06EqOFW1GyaSLa95+Qmv8/NsrR7TMF3CKdFAtCUlHQ0W9IK/G0LTePFzbxUFzC/XaZllhcxE0zhucfUuqkNafF86Qv4n3DKd5rKJNCz3TcVGXvx/zNy4u9/932gy5sK/TonV5uwMy6khPX+oP1YFsPgZegoLJxIE9Hq2HWC6vXe5Ue0sLYE7ROWGvcj8o7m+nOb5pDZUXppTSiwPtH75GdPy/5TYw2VWLIcNwYgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(7416002)(6512007)(52116002)(53546011)(38350700002)(6506007)(38100700002)(5660300002)(8936002)(316002)(31686004)(8676002)(6486002)(66476007)(2616005)(478600001)(66556008)(44832011)(36756003)(86362001)(966005)(186003)(16526019)(4326008)(6916009)(2906002)(66946007)(31696002)(26005)(956004)(45080400002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eU52cVRJcHNaVVU0TGhDQTIwWVd0NGVSTHZMbUxuSm54akErQVhVbjNwMTIr?=
 =?utf-8?B?L0NxU3EwVE1TaHdxS00zVk1vc21YakkrenVucUJRdklXTmUzUlptL3Uwbi91?=
 =?utf-8?B?Sk5FWEVTaXFSRWYzb2prRlFnc1R1RGF5SUlNWWhycThKemRHcFpkUHErUWNn?=
 =?utf-8?B?YTFMa1gySG14b1pIQ1NCeWw5KzdZWGJnaFpFUHlnNjZ6eWpQNTkxS3ExWm00?=
 =?utf-8?B?UXZ0WUxWVmU1MjJzU3hSRyt2WlAzTTdIYW9Tc0lQd2RhY1dVSXNUU2F1bmhL?=
 =?utf-8?B?S3JLQ0NpNmdWWGJCaUN2Lzg1ZWluSmpOK0JWQ1RudTBCOXRFeVFtNk1ka2ZG?=
 =?utf-8?B?Z1J6WktPUEF4M0Rsb1lhTVZUR0IrVnVRK2E1Y01UdVpTZEJ1Q1p1dG56TE8v?=
 =?utf-8?B?bXl3dzRTeHc3blU5MGJtNC82aDJYd1lIMWthKzlnL0cxclhCSHppNDFyMVBG?=
 =?utf-8?B?UDhzcWJFZlBubHNwcW8rdk1ZSTNXL2N6UGw5TVpyRG9vMzZNaUk2b2EzNTNp?=
 =?utf-8?B?RlRPVWg2OVNXYTF0ZzRoeVlXL1UrUDBDVEdOeXlYK1NzaDhkdnhlY2c1NVhC?=
 =?utf-8?B?Vi9jdGdNc0NsbnBRSk03bkV0OFg1QzBtb1RPQ3JVck13QlpIb0hxQ2NpZVZM?=
 =?utf-8?B?ay9yU0hYOW5pbHdXclBMeG9CY2c1WFFRckI1OVIzYjJkTkM1aXNNbExrUHQr?=
 =?utf-8?B?Zzl0d01DUkRaTW11eWRaQVRNcyt2VmhhVlRhVlVMNE9RaWFmWGQzcVNWVk5C?=
 =?utf-8?B?cGpJZURPNndGUTNPUDExMkFBZ21lcmhJejlpQTlwVmUwcU5pMExQanN6b2xW?=
 =?utf-8?B?cXloLzNtZ0lCOHdDVWNsY2hFV3BKT0Vqak5BdHlJNm1jeXN0WGtBN3dURFdD?=
 =?utf-8?B?OHNEQ3RGWmp6SEw3aXpIRUNPczNycC9uWDV0QU01SFB0eGs3b0Q2WE52b0dQ?=
 =?utf-8?B?QmxSNkJiWHh0aFJMbGdGdE5DZUN4cWNTbGJldlJxOXFZQ1JsTE1vclJCdU5M?=
 =?utf-8?B?UURqYk5vMXVQdmFyQlplRkIwblRWNXJHc3lremtQaVR6UWYySkdtblo1eDVs?=
 =?utf-8?B?UERYeVU4OUh6cXA4MFcvaDlPZWdyQ21UZHZQVzJkV1ZKcmZqVDJEMGJFck11?=
 =?utf-8?B?cHYvV1Y4Y3pmekV3ZVNoalh4N212YVRCSFNIMHNaSk1ST2FyK1Z6OEUzaEhE?=
 =?utf-8?B?VGRNaDhtVS9jeVh2VGR6SVk2TmJ3NjlEZklyb1RmUWthSU9SSnJGYkVEakdp?=
 =?utf-8?B?dmxVbXlFUXhnV2Y1eEx0ZGFWMmMxU2d6c3dvdGcvU2NTNmZlczF6VmhkSzl0?=
 =?utf-8?B?ZHV1cERDVmNMejRBMEVQdDJMQ2FjOVNEbnNvTkZnU3cvSWF6ZkNxZ3ZmTTZk?=
 =?utf-8?B?b0ZVNVQ4YmplOHdJZUNNcFJjL0VWZzIwU2FlcTNtdmpyTXVFd1lDMzdOZzBk?=
 =?utf-8?B?aXhNRjFnRDJqUUNrNEV4UnBZc0Z6K3ZzL2tKZVBSaW4wTkNYTG1GbVF4NUlF?=
 =?utf-8?B?d3NTMm54Y3AxZ05jVE54R2hhbENONnZjaDdaMUZVL1pjTjJJQWFTcXZibUd4?=
 =?utf-8?B?b2p5ZWhHZEpvM0loK2xYby9tUTdVTzBxempQZ2NDZUdDNUVTTE92R25WcG9t?=
 =?utf-8?B?T3lMcE1FcmpMQ3N0a2ptVW1zclJ1M3NBaUhYQ1FOaS9aZWIyWnM0a3ROWkc1?=
 =?utf-8?B?NTF4YmhWUDJhK3Jocm5MT1BFWlZvT1EvQVljcWtjL0hXZXRYYjFMTXB2YXFx?=
 =?utf-8?Q?Tsd0y8XPf/6PLNmVyaRVepIck/0IqlBlbyR/Emi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 102cc31a-96df-4b7e-0c2f-08d91aeb92e6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 17:28:53.7160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 89rvQwaGh6ZcjydTST+ea+sH9IZ2rVs1TkGm8L0MyHuv2uJ6ABZN8q4lj12EL/9jU9XFL1l4XhUyqLYzRla34Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2512
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/18/21 1:11 PM, Borislav Petkov wrote:
> On Fri, Apr 30, 2021 at 07:16:04AM -0500, Brijesh Singh wrote:
>> The sev_snp_active() helper can be used by the guest to query whether the
>> SNP - Secure Nested Paging feature is active.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  arch/x86/include/asm/mem_encrypt.h | 2 ++
>>  arch/x86/include/asm/msr-index.h   | 2 ++
>>  arch/x86/mm/mem_encrypt.c          | 9 +++++++++
>>  3 files changed, 13 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
>> index 31c4df123aa0..d99aa260d328 100644
>> --- a/arch/x86/include/asm/mem_encrypt.h
>> +++ b/arch/x86/include/asm/mem_encrypt.h
>> @@ -54,6 +54,7 @@ void __init sev_es_init_vc_handling(void);
>>  bool sme_active(void);
>>  bool sev_active(void);
>>  bool sev_es_active(void);
>> +bool sev_snp_active(void);
>>  
>>  #define __bss_decrypted __section(".bss..decrypted")
>>  
>> @@ -79,6 +80,7 @@ static inline void sev_es_init_vc_handling(void) { }
>>  static inline bool sme_active(void) { return false; }
>>  static inline bool sev_active(void) { return false; }
>>  static inline bool sev_es_active(void) { return false; }
>> +static inline bool sev_snp_active(void) { return false; }
> Uff, yet another sev-something helper. So I already had this idea:
>
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2F20210421144402.GB5004%40zn.tnic%2F&amp;data=04%7C01%7Cbrijesh.singh%40amd.com%7C363870693b07482681da08d91a284ce4%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637569582675957160%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=Ebk6MT2jKDfyPwwzYb3D5%2BGopUU3VWudgeAUxcsc74c%3D&amp;reserved=0
>
> How about you add the sev_feature_enabled() thing
>
> which will return a boolean value depending on which SEV feature has
> been queried and instead of having yet another helper, do
>
> 	if (sev_feature_enabled(SEV_SNP))
>
> or so?

Sure, I will introduce it in next rev.


> I.e., just add the facility and the SNP bit - we will convert the rest
> in time.
>
> So that we can redesign this cleanly...
>
> Thx.
>
