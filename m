Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BBD2F437A
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 06:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbhAMFEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 00:04:55 -0500
Received: from mail-mw2nam10on2062.outbound.protection.outlook.com ([40.107.94.62]:50657
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725809AbhAMFEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 00:04:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNV/22nyFNCPVugLwsUrIypNfo39m0HjJ9JgVZjifb/eo2STH/65a0YZWYpywzZ6p+py9H04lY51vO+HcvtJoh/U+Q2vQocxOosszWC6Wv6+6Py/ol9cVEsH8DhN3xDDbzfic/YlAjrZHzoX4Aq5RH+TN80poRSS55hPTAdkxCWxIZ33LihfN42tEHs8IhfE8eE5DI/5L5UY2p5eZFpli+FsX7FRxaH9XUjJfpRGmtwD/Q6lTYwbF0OHhNQc52/zKpFV2oOZdTQwywFuxPTTF33f3seC+v1RFu/3Xk3jjahG9NoQN5V92H8iWvdvg2UbqyO5pFn0935BztU5E827Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rDE3gQRhySAVUtf0fPRDmewRuMA55VqSghvbGBp7iXU=;
 b=nNTQ2POlIX/3VeZismYsMyFrUrCb4XTbKruXjMk/7J6Tz7J9mdeklCIHzAsRoHDpYajZ8AyzRsNDTnAmhqmvdKL7sB6O3UEOc/5T9s6/asfh3GzKFuUBiFvSBJGxOMqXpugEql9uvlpL1lC+dGvTs999Lqxtr5GbZy1EbS8f+w9gvDKBhms9l2OTIWIdPs4fHYwMBk1H0qk1DSAXnB3zfyeVBoMI7jew/mu1V2dOypiFVRo+uow8LvECyknSUeLw0cu730vDPR+rULHXxsPNXMak1Wf8R735/3R/K0TqGqAPgX7wynkJFGpGhHLjuMjhKGqVMzmzrpg8Zh7aUwUMoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rDE3gQRhySAVUtf0fPRDmewRuMA55VqSghvbGBp7iXU=;
 b=ZBWzN9ycpsaVibfGntbYLVcob+tGCCjLlCR+eFotEpx2XZ1NK5AgDsebrruAP3NnNRmBa2FlAcuFFKTHaBLsBYOB+pSretht+txJmDpB+RkKioZbDvJwO2yobRY+j8hLKfyPLm1gyGauwvUor+wQ8C9vWGWBJo3Umi+BJN1jb8s=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1494.namprd12.prod.outlook.com (2603:10b6:910:f::22)
 by CY4PR1201MB2487.namprd12.prod.outlook.com (2603:10b6:903:d0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.11; Wed, 13 Jan
 2021 05:04:01 +0000
Received: from CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819]) by CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819%11]) with mapi id 15.20.3763.010; Wed, 13 Jan 2021
 05:04:01 +0000
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by
 VM instructions
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, mlevitsk@redhat.com
References: <20210112063703.539893-1-wei.huang2@amd.com>
 <X/3eAX4ZyqwCmyFi@google.com> <X/3jap249oBJ/a6s@google.com>
From:   Wei Huang <wei.huang2@amd.com>
Message-ID: <94312672-3ad2-7cb5-9b03-c3a2fbf34a8f@amd.com>
Date:   Tue, 12 Jan 2021 23:03:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <X/3jap249oBJ/a6s@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.113.46.183]
X-ClientProxiedBy: SA9PR13CA0211.namprd13.prod.outlook.com
 (2603:10b6:806:25::6) To CY4PR12MB1494.namprd12.prod.outlook.com
 (2603:10b6:910:f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.38] (70.113.46.183) by SA9PR13CA0211.namprd13.prod.outlook.com (2603:10b6:806:25::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.3 via Frontend Transport; Wed, 13 Jan 2021 05:04:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 260b6ebf-2c78-4f21-542e-08d8b780a490
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2487:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB24873F28502147976DD0971ECFA90@CY4PR1201MB2487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n/E5P0zfaIBqqaUNl9J1g8NWg+QWs+2jJKN1i8xxv1V03LQcYqd6CriA2obn01Gk9qhNtANgdO2MgV/GFb/Pp0X3nwcW6qTNSToRkTTleLEDV0lJCWU1RheTmtz4f2xtcwYfxSIUM5DeOJCFKfOT80w5J/V6TkzaVP+/Xd0jaiswoFE07ODiX3b6FAZAD7NFuk1JnZWSRKg1NQ+VaPk6/JPYQM8sbOmeIvfEQM7F093QWvzzjcbMRqaiu0WZlSMvPGvRA6NIac5yu0f35bhsamWycDgECgKB+lrSFxAMMNkN9p3IpWZlot/A2IOK9rTV6bw4rhZwRerlMNiFKLtSsOpkdAJjMB27sTG9NzSaIyHNYOAXAYfjWPxxTDlJbJDr+ZxksW0NzacmpBuQA/htOznshKKVNvkmXddW/xhwGpJqYPd/5FiN6En163eX+ycvcoef2GGxj2zeJOOhJqb/P3tJEIiCZ3jEH8R/a9uhNQc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1494.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(6916009)(5660300002)(8936002)(66556008)(36756003)(66946007)(31686004)(7416002)(31696002)(956004)(66476007)(86362001)(4326008)(186003)(6486002)(53546011)(26005)(16526019)(2906002)(478600001)(316002)(16576012)(52116002)(8676002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K3Rhcm1YRUV6MUpIRXhaYXZwMVl6VkRJR1duMUVRY0JvQnBob3VER0hXaFlO?=
 =?utf-8?B?MmRNMXFkNVdNei83dnFiVXhNYWZtbGdtanJDKzhUMWRha1RqcU9HdktNWHRN?=
 =?utf-8?B?dTcvNlZDQW03WGZMdVhTU3d6RitNTzAyVmswZmlHaW5XQVh3b25PUHJ1eWNa?=
 =?utf-8?B?UTRpcytJaStkS2w2UUF3bWNjRkFFL1djYWZ4NGJDaHlsZUVwNnVyeDZvUFhY?=
 =?utf-8?B?V0FNZ3VlWDN5TjkxZHZDSnpEUUpraitKNnFOTjRWYWpxUkhUUDFIWlV6SG5z?=
 =?utf-8?B?aWZrVEJ0elUvdWFUQ3laU1BrcTJ1L20vV0lUdnNVSW1HaVJ6VU00MVQydHpG?=
 =?utf-8?B?RVF0a1llSDRtQkNiY3R0VkduWmJtZjY3YmR6M1hsKy84VkEvS3J4NXdKc3lj?=
 =?utf-8?B?TkpzT0F3eFhOZjFJaC9NWGZwanFnbUlPMERDbXYvUWhjVDhEaGRjUTVxUlNN?=
 =?utf-8?B?R01CbEhWb1dSYTZiZVU3RE0rSENOWkpZaFh4bktMZThldGlDazhiMEg2TktS?=
 =?utf-8?B?cERvT3YySjZIb0tXSURIR2IwcVdULytnYUhwVlRnaHYxTCtzbnh6bHhncHFF?=
 =?utf-8?B?MzJGVUduMWlEbjNwVXZLSU1aUVROcms5V0gycnBjQjVxTlRDcjd4dXJFK2ZS?=
 =?utf-8?B?QVBTSjVlVnRFcGJXL1UwQ2oya3hDS04rNGY3THdZMGNhaDU2OGlmZnd2ZnZu?=
 =?utf-8?B?OURCOGhNTnZMTDJRcmM5VkZSb3Vja2VQV2tMTk53MWNnK3BSVlllYk52bzRH?=
 =?utf-8?B?R0U0b01FOTN2bGU3ZG0rSjRtN3BaaVFPTlk4YUhuR2d5RmpQaTFhY2RtcENT?=
 =?utf-8?B?aFpZeDZlMXh4SmZtbjlFZFVWNzRSTENTN2xYemN4aVFWVHlsK2c0L2dsOGlZ?=
 =?utf-8?B?NHI1UlpHOHFLT2pkU29YVGZLRC82aFFJbHBkY08yeEtKR3F3Z3FlY3FGZU1O?=
 =?utf-8?B?ZEZZRTA3RDlrRmpqRHlneVEvazBCc0hycnlnTzVYUEJwSHBySFJHbVowVy9M?=
 =?utf-8?B?STFkUHJzdXpPbUxFaTFTbkR2MWRMY3JzbWtiQ0VYRHJGQUtqVkdRUVpjSE0y?=
 =?utf-8?B?R2tsK3M4Y1lZQm1MdG96NnM0dmF4bG1MVDVCbGsySjMrSkhheisrT2ZTd2pC?=
 =?utf-8?B?RkdOYktNQmRyMkU4dzhBUlRreW5DakZsenlDOUJxeWEwSmsyNUxqWkcvOUIx?=
 =?utf-8?B?SDFwN3pkaDBPU3UyYm9NbGJMaXAwU0hjZ1RhQ05mcVFhMU4zTUVVSmdBeEVs?=
 =?utf-8?B?eTYybnNnMlVFZjRVektxbDBaUUc4bmhoTkkwYnRCOTRIdklIeG53Z29TZUF6?=
 =?utf-8?Q?/+r0XgUB8aeFm/K2GpiOE56DXLThyZUcxa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1494.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 05:04:01.6954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 260b6ebf-2c78-4f21-542e-08d8b780a490
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h82luHNfxX7uHYJvPxxQSD6odIwb01Tm1dzmspm6OdqRXRb1bDXrRuqDkU0Utio/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2487
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/12/21 11:59 AM, Sean Christopherson wrote:
> On Tue, Jan 12, 2021, Sean Christopherson wrote:
>> On Tue, Jan 12, 2021, Wei Huang wrote:
>>> From: Bandan Das <bsd@redhat.com>
>>>
>>> While running VM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
>>> CPUs check EAX against reserved memory regions (e.g. SMM memory on host)
>>> before checking VMCB's instruction intercept.
>>
>> It would be very helpful to list exactly which CPUs are/aren't affected, even if
>> that just means stating something like "all CPUs before XYZ".  Given patch 2/2,
>> I assume it's all CPUs without the new CPUID flag?

This behavior was dated back to fairly old CPUs. It is fair to assume 
that _most_ CPUs without this CPUID bit can demonstrate such behavior.

> 
> Ah, despite calling this an 'errata', the bad behavior is explicitly documented
> in the APM, i.e. it's an architecture bug, not a silicon bug.
> 
> Can you reword the changelog to make it clear that the premature #GP is the
> correct architectural behavior for CPUs without the new CPUID flag?

Sure, will do in the next version.

> 
