Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C632DA04B
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 20:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441089AbgLNTWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 14:22:12 -0500
Received: from mail-bn8nam11on2040.outbound.protection.outlook.com ([40.107.236.40]:48993
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2441023AbgLNTWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 14:22:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S29KHAkpB/3V3PsxIHxkPygbAt6zyyKedBAZ3bFMu1tILvzkaCFip/fZczA3o5HpRvUwf0AJfINaPedBvINEYl0OdeU5Dx6foO3P5ZfjVFE9ji5gCQ8xK32DXG/rxCZkVWMbJnnoY3jTW3GZcmz0vkZPgHHEaBTjRnYs+4/BNN+OiArMVpQ/KMeLKXl+rFe4u188fniXV3QXWR5tShP6yOCE8d/mRtwrtYL8wcMcnYRLTYn7JBOj4V2QR50cyRSi4Rn+C5caolSDG+CvrG03pK/9RJk1qce5Pj5OU9KGFDjK9LqW34oy6DDE6yQFjGxBJcK8gqa6rAfT0G4Msrru+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKkTO5RKvbbZ3h1ihgrGCrEDQtYiRgTypGzREklGShk=;
 b=OrE7vfaH5hlXL917WU4DRoA6HgKSER/Ojzsx2kMhoyXVaWi/Xoo842dMbFF57t2kPdLYs+BdlowgcYU96ikJAwk2TXn+XmCg50vzI8aFN4MtB3F8pWbB4T1h+8SMR1c4/49NLkITGZtSFY8Iw1kyF6pDMdBc/f7rKDfm3wqm6UFd1v04q4PsC3mi+Mo/USKSFZnzhWC+WYk2hVcr2J94TH/XjQaKuCOscNSXC+xsoj8GX3qxRyONp/80N79VnIJ8TD2ps21CSjf80zXhGVCec/MQql+VpQAJWc+nc6NTr+VX3Qu/O600zoyKVFPkZFE1ellHbqjhb0c6CNLho/bHeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKkTO5RKvbbZ3h1ihgrGCrEDQtYiRgTypGzREklGShk=;
 b=vK8SMfCW9VeSALpaQ/PibM1U+wJ4WV41t/cLzAI+ddyfB7zmnKUNfJO/WmnEwAqdXo0S+SVFDoCcRBsi/4JGYdS9zQegfZT2BLJfaTd+StBSjsVLXsJXov4hC7g+jSBpxkwcmjgGbf7GTao/3uZBaeTRplCsMMd7NQyxevKfVUQ=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0121.namprd12.prod.outlook.com (2603:10b6:4:56::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.12; Mon, 14 Dec 2020 19:21:10 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3654.024; Mon, 14 Dec 2020
 19:21:10 +0000
Subject: Re: [PATCH v5 12/34] KVM: SVM: Add initial support for a VMGEXIT
 VMEXIT
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
 <c6a4ed4294a369bd75c44d03bd7ce0f0c3840e50.1607620209.git.thomas.lendacky@amd.com>
 <7bac31c8-a008-8223-0ed5-9c25012e380a@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <33e98d2d-93b5-acd6-4608-f30c709019ad@amd.com>
Date:   Mon, 14 Dec 2020 13:21:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <7bac31c8-a008-8223-0ed5-9c25012e380a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR18CA0037.namprd18.prod.outlook.com
 (2603:10b6:610:55::17) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by CH2PR18CA0037.namprd18.prod.outlook.com (2603:10b6:610:55::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 19:21:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed476deb-4028-411b-e63d-08d8a0656a06
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0121:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0121667B0F4CE19158BEB0CBECC70@DM5PR1201MB0121.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dddytKTJITvPyEI6Y/E284WSiORxqF4+VlBSiM1NUzZoVSdHSuRgaxhTCKC6xb8GkkXOx6Ngd6gFp5nXlhw4x6anhe9K/lJPQ2c8WIW6XjPILjtPnSZd2Xeaz8EH+fpayvEvXyolUS97dZ5eImF5yxvPCKt82uPgrIuuHtRpmqmxbwlhfeb8KV8OsbXnN36yE25+GYSBgraNu+XS1DmP+SiQZJAf6hstOP3OYE9FpRVX75cJoiVwNSJYJjp1ke9r3DDFSFRgBdcbW6VHEFkxSrzJvF2N0ZLJab7RrPHJC71d/9Q9hjq27q6uvDnLBIE7OCsAcZ7LKHjy4iYPDQ7RkF5yoVdpbIhNmzlilIh6QA9nn+/CEiLB6+S1uUXT/HB8CaFvDgmLhuElgUo0Psyq3mqEHnBqk5C3cChZgu/6fPIgEex+9USjPdgcxvN7w3ZZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(26005)(53546011)(508600001)(6486002)(4326008)(2616005)(956004)(4744005)(54906003)(186003)(16526019)(7416002)(5660300002)(2906002)(31686004)(8676002)(66946007)(66476007)(8936002)(86362001)(16576012)(66556008)(34490700003)(52116002)(36756003)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NThyTnd1VTJjQ0hDaG5VbUcrRlFkU2EzQ0xweHAyN0Rid1hmanNCbXVCOGRM?=
 =?utf-8?B?Wi9CdTVVYXFtcFVlY2hDNXdYbHZxVVJ2MjMxa01YMFc4c0taSWRocE5sR05D?=
 =?utf-8?B?cjJaS2lHNStMNUxwQk1OZjAzRmN1WCtpSFh3Z0FmSFRqL29BbzladTllN1BM?=
 =?utf-8?B?VnNjTUUrMWlXY3Y4aGtYeVdTMGJ1TVR4L25zeHVOb21YMFpEWGlQYXI0VExx?=
 =?utf-8?B?QVl5anF5aGtIdjZGOS96Y1VLbjBpSVo3MFVLZExoZ2N2cWJlZG9kR2EwMzBH?=
 =?utf-8?B?Y1ltM0R1ZktIZ2FyWU1TT0Mxd2ZRcGVVQUMyeW1GbHgwd2RZMjZJSkFrSEU4?=
 =?utf-8?B?VEhDd2ErVERYNGliSGgvN1IrOGs0Z20zSFJ4bzNmSnFlOHJJMW1tUlpjV004?=
 =?utf-8?B?RFhwTzFjNlpJOVNnUzNYSDVibzV0WDkxSFlEOXRHdjEraFJhSGlMZ0hnOC9X?=
 =?utf-8?B?RVVHenFLaW0rQXdld0h6aHY3THFab0hyeEZLY0Nqa3U1WEJ3VHNpd0JNQ3By?=
 =?utf-8?B?bFNaVlViRTFXL3hiYk5JTnRTWlVBL1VmbHJ5a2ZiRGtlSW1zY2dSUFlxWVpY?=
 =?utf-8?B?RCs0T2o2bWgvdmxGOTIxNEQ3K2x5QWNJdXhpVFBad1RpSVo1N3QzMUhnczNl?=
 =?utf-8?B?NE82dm5jNVVkdjR0VTNhYmNHemp1UEdVVFAyN2FBeTJudW9EbHhFbFNsRm91?=
 =?utf-8?B?NnA3bHFvdE1nVzYvOHQxaEZxdE00Y0c3aXQ2OVpkU2xjK1kydWtFK3pFQ3Nz?=
 =?utf-8?B?OFRVK1Fvb21Wc2NuQUdUTmpLRDJDSGRpVWp0UGxJRTRESUY1N1NOenRXcHgy?=
 =?utf-8?B?OUtUWFZQVENMbFFmcmpoMitMb25FVDNTT3NGbXdjU0t5M3d0Vm03VE5COWVD?=
 =?utf-8?B?S3I0dHNDSDBadEI1ekxqdnAxTjJEN1crWlFuL0p1ZzJ0MjViWG5tRkdEVEd0?=
 =?utf-8?B?MjB3eVhLYjRrOHpUd3c0K1ZORXZUcERxNGpscFc2aU9QbXE4UzIyNjRXMi8y?=
 =?utf-8?B?UmdvelVuTjlHYnJ0amFtdy9JNWRFdEdQVkFyZ1FPWjA3VjB6Q3lSbmZYRlVY?=
 =?utf-8?B?djFITFNLRXpwdHE1eGxXVnhQQno2SWl1SGRXdCtQOHRoQzFHblRDOW90VGJW?=
 =?utf-8?B?bU12dW1kTUZEN0t1VW1NNTBOZlU5MEt6dHJFZnZjSXMzKzA2SldWVnRqRTha?=
 =?utf-8?B?TlZtODhvQ0NqQ2dXTXA4QjV5dDEweFpVM1FxbUZ6b2hnMlRDY2x3OGhLcUpD?=
 =?utf-8?B?dllFZkZrOFQ2YlZRNDlPU1JCMHMrWjZXaTA0VHpIR25LcmpyVE82STk1M1cx?=
 =?utf-8?Q?Qf8EWE9nnZbhNfIWmf1Au1IIl7fv7ugfuK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 19:21:10.3413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: ed476deb-4028-411b-e63d-08d8a0656a06
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U/EYIUrAnewGHQ75IN0Msm/oD4RJAjEfh7pFWnIECZI57YZiX5kJVzogRgslNjagj2DnlWupwN/25H1bY8M0oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0121
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 9:45 AM, Paolo Bonzini wrote:
> On 10/12/20 18:09, Tom Lendacky wrote:
>> @@ -3184,6 +3186,8 @@ static int svm_invoke_exit_handler(struct vcpu_svm
>> *svm, u64 exit_code)
>>           return halt_interception(svm);
>>       else if (exit_code == SVM_EXIT_NPF)
>>           return npf_interception(svm);
>> +    else if (exit_code == SVM_EXIT_VMGEXIT)
>> +        return sev_handle_vmgexit(svm);
> 
> Are these common enough to warrant putting them in this short list?

A VMGEXIT exit occurs for any of the listed NAE events in the GHCB
specification (e.g. CPUID, RDMSR/WRMSR, MMIO, port IO, etc.) if those
events are being intercepted (or triggered in the case of MMIO). It will
depend on what is considered common. Since SVM_EXIT_MSR was already in the
list, I figured I should add VMGEXIT.

Thanks,
Tom

> 
> Paolo
> 
>>   #endif
>>       return svm_exit_handlers[exit_code](svm);
>>   }
> 
