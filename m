Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6AF24A3BA
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 18:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgHSQD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 12:03:58 -0400
Received: from mail-bn7nam10on2088.outbound.protection.outlook.com ([40.107.92.88]:58721
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726685AbgHSQD4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 12:03:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5Sum6fMTVGWnsEx6kQYsrY+txctDbxo3Fioq8E5ru8twuMYervm+1RXggEJ/dvd308UX4bW5IntTOJJIqROXaMelwZMDEne4VtiKEpgONd+1mjCbbmh+6SyELVfnkFPBqtR6wtqYZWZelquxU6eUzzN2iVzYC4dKVFTtnszmKvymXh5BpbpbmuOfeHIhscKPsxErX2WOyI23LED7FZ+kh6XEiKnNDc/tBXVfSM52XEzjwI0dQ3S7GwyPKqgqGtbuN/23UczWeimkZ0XdxE0krcSSqGqY4ynILFyWheuzCUFEcFI7bJqIzqgQGxoX06Yn/GPOnFovtlWtAJshx9pWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mN65PxJppCCGzHW8mwd5wIZKnDX0ohhtCUjGOoN5wHk=;
 b=TFipYvrQfuX9pdBtDfbn7thveOwSJOCmfYCrdooX6uc5OTAgGdhjHiP6XUH0Ny5BvJb7uQfbfD3rF5o2JXNrLw+PkVSSBL0nGz505zJ6N+jKzcMjJJnbEUoXVnQnL0Hoc+kXLZGSPUedwBnpEFbjkipbPnwGKkg6q7XMn6XKIlkxOfVoJtkXwuAbncKupG4xo2Z5kNduxKcbOtOhnuGtjGwrW7U9IndthbIZ6pa5x8NezkbUc+fhQQSVaDRSWyGMtKaB5zFxHqr+oiS59cf1iDB0N/wW7Huooa5oAi/KESsBR9ECY0gN1OXw1USxEfQ6m9HxnolT9OqLA6kGlMO7Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mN65PxJppCCGzHW8mwd5wIZKnDX0ohhtCUjGOoN5wHk=;
 b=KK2Xe791yWmpJLqwguukX8FZCaForriTMVsxu64sf1RdeLy6CCgw9ggaucVAvHryS66QFPpTDiZ2j/He39f/RmdgAtShWDIB3swzfz4hF5M3PZA2sX64/Rm9fpf3CAH1EierwVafOOd3DFsSlrbk1BJvldqCg1BoMOYm2h1Xb60=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM5PR1201MB0267.namprd12.prod.outlook.com (2603:10b6:4:55::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3283.22; Wed, 19 Aug 2020 16:03:53 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162%11]) with mapi id 15.20.3283.028; Wed, 19 Aug
 2020 16:03:53 +0000
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
From:   Eric van Tassell <evantass@amd.com>
Message-ID: <775a71bb-bd1d-ff34-a740-e10a88cc668c@amd.com>
Date:   Wed, 19 Aug 2020 11:03:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
In-Reply-To: <20200803162730.GB3151@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0061.namprd02.prod.outlook.com
 (2603:10b6:803:20::23) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.31.128.53] (165.204.78.25) by SN4PR0201CA0061.namprd02.prod.outlook.com (2603:10b6:803:20::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Wed, 19 Aug 2020 16:03:50 +0000
X-Originating-IP: [165.204.78.25]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ac144cc9-a2da-4dfe-ec74-08d844597800
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0267DB2AC8317454274B3677E75D0@DM5PR1201MB0267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VwhOxfAV6sTreNDDt8jccAqmqxscwQlbI6ocuTpLYhl6Qgn42F0I8Y9W/tGaJXyOOtiK/QLchKjccevoKoT09NBN3wx2iaGwKvkoF1Qn5IB0cbMjVXzZzRMZdU6wn172AlduwtGOn7ZclO1XLo5L4zuYcZp88V0q4zlXP6k5eva8+kMkHR7Jv6OZ/06FpgdumsAHqu7QssarPVOFkOU2TZfhEb3dXHIKYsQEJtPGqJRjrZFTO8MsrX4FkqUNSQxrdbrQ0dISisgSF26uVoE0hJRALe81wWVOJgO0MjNr3gLEIMwkF2TUZSWEQD1vAQJyxDR/072kxxJnFyy+AuZjCPkzxmKfZHzRktD7gkFQBZP7cO+PTgrr2C2I6MWGw65K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(36756003)(8936002)(7416002)(6916009)(8676002)(478600001)(4326008)(53546011)(66946007)(66556008)(66476007)(6486002)(2906002)(2616005)(31686004)(83380400001)(316002)(16576012)(186003)(31696002)(52116002)(54906003)(26005)(5660300002)(16526019)(956004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: O3E83g3pApmnSLE8rxZ++bDIbaWMU68c2cDm0Y+kwPf2OY1FRDIpWUzrduUnibk5nfVPd8vjbEaqXZy4cwjld+Zu9Tyz27S7ntTxljqzJCT0DvsoUpiPbxeG8gICaRW7d289ApnT7rF0yalYy6Q0JICr8T6qrLiFjYbAk4e0E2VFBLBrBTXBBuQmnPK4SatggrQ3HbGClAXEIWMgzC0nuXqXsC1O4BrRF19CFEWbWkzIu3glUzlz+JCzDdNWHGIrAUgO50CK2BFJm1vHbzx6tjPGAJHvSmfQSn5gcYOxzvmgiMIvTbNSSaO3qKZdMfJv65lsQqI76SKoAUcevhHwBGNqyEFRbwWF3o4L+zgnzN2WchN5smt6i0dFvlTqXca48ywyP4enCBzcjTLzCdqyhLLHL4hrNycCIQSfTFycdT368mnYZVYejEHy6NxhihTjhk8S2jIaqj6kpNUCzxmTxlbfOeLpdsawpK4UdmNIvq0obnstYEYvx+pVmkwSakQ+dqYTNw+C9QF27qA/Siw1VjGZ6UhSzRWA3bvTp8F438Emw7SzSVpNyrriJZuPodHPdqqcqWvw3gMXmIlCo1YOsdIEhlCO16qrTW4weP1K/46Z4PBwrLpC6UC85O8JrCPs0G7euoDRk27K0K2rSGXJNQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac144cc9-a2da-4dfe-ec74-08d844597800
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 16:03:53.3117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7dMom8C+61/GrwOPglXNWibQjQPHLIquZEEnJ7POEd7IqRxHHzqtiBVelvT3n69wiISzDTynint2xnHPj0Jc8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0267
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/3/20 11:27 AM, Sean Christopherson wrote:
> On Sun, Aug 02, 2020 at 03:53:54PM -0500, Eric van Tassell wrote:
>>
>> On 7/31/20 3:25 PM, Sean Christopherson wrote:
>>> On Fri, Jul 24, 2020 at 06:54:46PM -0500, eric van tassell wrote:
>>>> Improve SEV guest startup time from O(n) to a constant by deferring
>>>> guest page pinning until the pages are used to satisfy nested page faults.
>>>>
>>>> Implement the code to do the pinning (sev_get_page) and the notifier
>>>> sev_set_spte_notify().
>>>>
>>>> Track the pinned pages with xarray so they can be released during guest
>>>> termination.
>>>
>>> I like that SEV is trying to be a better citizen, but this is trading one
>>> hack for another.
>>>
>>>    - KVM goes through a lot of effort to ensure page faults don't need to
>>>      allocate memory, and this throws all that effort out the window.
>>>
>> can you elaborate on that?
> 
> mmu_topup_memory_caches() is called from the page fault handlers before
> acquiring mmu_lock to pre-allocate shadow pages, PTE list descriptors, GFN
> arrays, etc... that may be needed to handle the page fault.  This allows
> using standard GFP flags for the allocation and obviates the need for error
> handling in the consumers.
> 

I see what you meant. The issue that causes us to use this approach is 
that we need to be able to unpin the pages when the VM exits.

>>>> +int sev_set_spte_notify(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn,
>>>> +			int level, bool mmio, u64 *spte)
>>>> +{
>>>> +	int rc;
>>>> +
>>>> +	if (!sev_guest(vcpu->kvm))
>>>> +		return 0;
>>>> +
>>>> +	/* MMIO page contains the unencrypted data, no need to lock this page */
>>>> +	if (mmio)
>>>
>>> Rather than make this a generic set_spte() notify hook, I think it makes
>>> more sense to specifying have it be a "pin_spte" style hook.  That way the
>>> caller can skip mmio PFNs as well as flows that can't possibly be relevant
>>> to SEV, e.g. the sync_page() flow.
>> Not sure i understand. We do ignore mmio here.
> 
> I'm saying we can have the caller, i.e. set_spte(), skip the hook for MMIO.
> If the kvm_x86_ops hook is specifically designed to allow pinning pages (and
> to support related features), then set_spte() can filter out MMIO PFNs.  It's
> a minor detail, but it's one less thing to have to check in the vendor code.
> 

The check is moved to the caller.

>> Can you detail a bit more what you see as problematic with the sync_page() flow?
> 
> There's no problem per se.  But, assuming TDP/NPT is required to enable SEV,
> then sync_page() simply isn't relevant for pinning a host PFN as pages can't
> become unsynchronized when TDP is enabled, e.g. ->sync_page() is a nop when
> TDP is enabled.  If the hook is completely generic, then we need to think
> about how it interacts with changing existing SPTEs via ->sync_page().  Giving
> the hook more narrowly focused semantics means we can again filter out that
> path and not have to worry about testing it.
> 
> The above doesn't hold true for nested TDP/NPT, but AIUI SEV doesn't yet
> support nested virtualization, i.e. it's a future problem.
> 
