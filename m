Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C7F24C41F
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 19:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730377AbgHTRHo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 13:07:44 -0400
Received: from mail-dm6nam12on2067.outbound.protection.outlook.com ([40.107.243.67]:43968
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730382AbgHTRFT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 13:05:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fW31UH0coKHoOcPIiNnOfhoj76HJcoXkbc7p5Ap4TmuZzk+/UJUm9s2YpM1fxchFgVbM1Pnxo4ECXsDs6lqVTJ4AtOEESrLJ5s/if/cjIusvJokbiXes0us5tO2MzlaC8n+U/WsO5wpPCxAWDQAsrVAg/yUc9mtbBZAbqS4MBFNW1Tibn7Rn/K7KE3RmYgMna0mnufTACe6PuYR0HYjSd8p0fa1cX5fqxFGL2Ls+PSGFpkN3lEiO3ryrWmL6M7QerQA2hiqa/yWC4neyeieTIkn+s4fVxa78vp5aTS4NhbqciL0n+zRHSvjh5Up6MUSSI+JDt6XAKe9e+aOl3p4zTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CoeY/GboGWKCsHunrEUtSd9ub/wbBmgfIzO4v7MvKi0=;
 b=JSHxDqbbVxADN+lab7mAsqWKA2vOL6kiRZsChsGqsCadQ9v4JKF+Vhom0lu/L9G9Hz3c4k+yonD4+SW0KDIxezqQExnTOpU17Qv/ZP87nla2OtCS8nQaQhsxWT9TGFGJSHvmI/3OJX+wQd9cmkXxmXJWWT9eunORoZ9B4yAhQICR/w4CjiryMH3HaqbYbNBXdqSkPqmjMW+DqoZS2fbv0exXQqC8wILLS/oUlRxFof5Da5RcBWhUpdB6eQX4PrsSUBPfwonfUFfapqjN4SxkUe08Bkbz5kyeFXfjEPtq4xzgD/vlzWERQyD3ma5ElsXSgi0YPGA//ihuFpXgeHrn0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CoeY/GboGWKCsHunrEUtSd9ub/wbBmgfIzO4v7MvKi0=;
 b=CYeCpn3antaIXqIaEsN16mHwos6LMgo9pyUh1UUftUx28l7cssynNSmV2d7GyR4ZLhv23vspMVy6WSc2hN0s1MK/23xUJ4BX3xDrVoRM92D/f2hc2xuh4hfvnCv1mBqdDKkFgR0Zvl16xeiM98Zr5JTZc4dWtSfdMlPXNNI3HrU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM5PR12MB2424.namprd12.prod.outlook.com (2603:10b6:4:b7::34) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3283.16; Thu, 20 Aug 2020 17:05:08 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162%11]) with mapi id 15.20.3283.028; Thu, 20 Aug
 2020 17:05:08 +0000
Subject: Re: [Patch 2/4] KVM:SVM: Introduce set_spte_notify support
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     eric van tassell <Eric.VanTassell@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Singh, Brijesh" <Brijesh.Singh@amd.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>, kvm@vger.kernel.org,
        bp@alien8.de, hpa@zytor.com, mingo@redhat.com, jmattson@google.com,
        joro@8bytes.org, pbonzini@redhat.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
References: <20200724235448.106142-1-Eric.VanTassell@amd.com>
 <20200724235448.106142-3-Eric.VanTassell@amd.com>
 <20200731202502.GG31451@linux.intel.com>
 <3dbf468e-2573-be5b-9160-9bb51d56882c@amd.com>
 <20200803162730.GB3151@linux.intel.com>
 <775a71bb-bd1d-ff34-a740-e10a88cc668c@amd.com>
 <20200819160557.GD20459@linux.intel.com>
From:   Eric van Tassell <evantass@amd.com>
Message-ID: <fdead941-6dec-ec97-5eea-9461b7e5d89a@amd.com>
Date:   Thu, 20 Aug 2020 12:05:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
In-Reply-To: <20200819160557.GD20459@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR11CA0007.namprd11.prod.outlook.com
 (2603:10b6:3:115::17) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.7] (71.221.162.120) by DM5PR11CA0007.namprd11.prod.outlook.com (2603:10b6:3:115::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 17:05:06 +0000
X-Originating-IP: [71.221.162.120]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c59c650a-8f9a-44c0-a05f-08d8452b3100
X-MS-TrafficTypeDiagnostic: DM5PR12MB2424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2424F6990694DE107C311411E75A0@DM5PR12MB2424.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: apOSlQVZQz2RTSFygUtpfXr+knpZIh4LmUIpPSNNLeQv3UolkP+9LWySEv8iT8rg/jqcDlpP9Ip2We7vZgsM5wS1JcZzJYCjIbzfF9GnjGnpoiKsQIGEYKelQBa5W/2bYXEznf4nXk1FhPu08GD8noONMcUI6guiCcWABwtqCaYAfgeCRJ0r4Z1ivahGq4+FXKnQS4sW6hytbq32YKaLWmWr1L8H+5EivjXE8wFnbN6fF89IJU92zMT30SQtDl/tCiNl/NndBmjjApTD9CPiPLE8JPQZGjWoa9qAg6A8IpKFWYabKA1iHp56etc7Z7p0w8e6pJRC9HnP4LvpAM2kY0qCp9XBe+FtdMRAVSCqxcR8CIOa+7F/jY1b7AzJFLSA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(31696002)(16576012)(66946007)(2616005)(8936002)(53546011)(31686004)(8676002)(4326008)(2906002)(66556008)(54906003)(6666004)(36756003)(52116002)(7416002)(83380400001)(5660300002)(66476007)(6486002)(16526019)(186003)(316002)(956004)(26005)(478600001)(6916009)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: P9KpSAqD0JOrlFLlvMl6fYBUiD3yoXQE0eP3sYVxd3yp5pnTO88IRvBMYMFoUU3UWLkgYAOa3pOBmwcv8AKDL7FyEwXiF2CzP1vZG3+K9ovb7XBc71rEfUCeubQLgv5HLzB+YgPWzM0HGAwQ6B02mdy/62iR84V8LDP4RWFc1fBZPLvdAO8zo4O9kToJKiXIKRVDERqDPUMQ0hS1GEcZ8nylm1t/tt2SCC5vUx6XKYjCzSRMdoWzF7aIxc0YzwrEiHd+kOcsj4scYfA3cUS2J+jMUkUgxmwI8EsSsKGx5WZp2gkvxKYeuRUFD2euTNiYSOMQdSqeymcBut/+nvhhhNMAqd0mOz0FcoarXzsyMbPG20NWMULde0DlfdGH1EsA4kl5ChWZfKsTjSDmsRyS7R84US2mbtsD0zU5kHOAXM57dlaTgEyGndQTQt8fheA8a6CutFKfT16Xz++j6VQ0L3otSxtRgxyyZ65fXsMWWun/r8gEn2SukP5tV3XocfTo7piipRboiB0TvDBwySYkO6A6xlrYjvW+j2iAfi3xu2C7FCkzWl6dovA3GuSa3wroBjWYg2YCkPbfYCxoUphuGWBWACb1PAYLCrxPhf0hIRcVpnYu8nzgnt7pZ4+C6PN/ZSVjkRSugqhSUiuh0LOI7w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c59c650a-8f9a-44c0-a05f-08d8452b3100
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 17:05:08.4698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DL/bZ67Tgcypf1kYK5QvZVraTVZm3p9ZCcua49dodUDjZsiztlS7vDleTH201erU8cN7gFlAHOvIbj0A2RguRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2424
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/19/20 11:05 AM, Sean Christopherson wrote:
> On Wed, Aug 19, 2020 at 11:03:48AM -0500, Eric van Tassell wrote:
>>
>>
>> On 8/3/20 11:27 AM, Sean Christopherson wrote:
>>> On Sun, Aug 02, 2020 at 03:53:54PM -0500, Eric van Tassell wrote:
>>>>
>>>> On 7/31/20 3:25 PM, Sean Christopherson wrote:
>>>>> On Fri, Jul 24, 2020 at 06:54:46PM -0500, eric van tassell wrote:
>>>>>> Improve SEV guest startup time from O(n) to a constant by deferring
>>>>>> guest page pinning until the pages are used to satisfy nested page faults.
>>>>>>
>>>>>> Implement the code to do the pinning (sev_get_page) and the notifier
>>>>>> sev_set_spte_notify().
>>>>>>
>>>>>> Track the pinned pages with xarray so they can be released during guest
>>>>>> termination.
>>>>>
>>>>> I like that SEV is trying to be a better citizen, but this is trading one
>>>>> hack for another.
>>>>>
>>>>>    - KVM goes through a lot of effort to ensure page faults don't need to
>>>>>      allocate memory, and this throws all that effort out the window.
>>>>>
>>>> can you elaborate on that?
>>>
>>> mmu_topup_memory_caches() is called from the page fault handlers before
>>> acquiring mmu_lock to pre-allocate shadow pages, PTE list descriptors, GFN
>>> arrays, etc... that may be needed to handle the page fault.  This allows
>>> using standard GFP flags for the allocation and obviates the need for error
>>> handling in the consumers.
>>>
>>
>> I see what you meant. The issue that causes us to use this approach is that
>> we need to be able to unpin the pages when the VM exits.
> 
> Yes, but using a software available flag in the SPTE to track pinned pages
> should be very doable.
> 

The issue, as I understand it, is that when spte(s) get zapped/unzapped, 
the flags are lost so we'd have to have some mechanism to, before 
zapping, cache the pfn <-> spte mapping
