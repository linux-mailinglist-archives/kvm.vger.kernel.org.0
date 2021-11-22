Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6556E45961D
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 21:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbhKVUgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 15:36:49 -0500
Received: from mail-sn1anam02on2088.outbound.protection.outlook.com ([40.107.96.88]:6118
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231663AbhKVUgs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 15:36:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDAzmTxBiUxv8ABICHKuq9KoEGWHl8Tl4ba9CsMNuRPsj0OOE3LCxYXcZMk+snnZZuV1C+qr2WkuK7GNH0hzZAey9VVYVqLMkk94our9Rgs+mwcOXD+jAG/08zg1hYZPIC4dFEepVAoNztyE8g0w9RZ/Chwr+qo6tum69KNKcXKC0UCY/7MZttCdBVHY/KMJJ1FoBHZEex2Fye2sjuQqhYcHw/yepOl85EBrLfqJGQDSQY66FHRThp2N5g0Gkjr7n+2JECyJ0hBqRCDVNB0NwvYxeNj4yfWuPJsT35dDJewihcrvRx8TgUNgLhYe5S2TYmuMbSZpApRkeznV1yiXrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=POb1Xr98VFIYhdrfJSluj7O7JS0tiSg6bzLIaPnRq2E=;
 b=PVyqc9RRcYmOK6l2f5ALc4QP2Mt77pyXpwCg8E9mO6EyfJb0a6mI69KKyXNjMaw8SXhv7c5G74nH+PQ9wbKbdPYV7YqUNhQdP/2L7s6f2nqvBbfMy6fzFGsapj8QdU7agPKSSAaK6J2WbG/HaO+tVhRAUZA66CKCyKxmzSeZvNtH18D5oEmdCHgwd1MRvA5ncmv3PB50Mn3is04HWRs0NPckFdOZ/YclNAXfk29T6GXkm8QtGPntINAwq++1AqC0aD80xRiqhKUehOmAEWG60NkpLkr2PLGpSxyShqijRnnMDMZYPo9cqeRT9LCdx9jPohh9Xfhyr3O3TwYzwhng7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POb1Xr98VFIYhdrfJSluj7O7JS0tiSg6bzLIaPnRq2E=;
 b=lQd4ROOKd8zTJuzqKhHYFKLtKxHjYkBNMVrdzblCCd/owf7G03k6TM9TbuIcwG7SvmPSyj1FHUVj+HfuQsgZcSEiQo1s1gEJLXv1jSNZKEnqwPO2MIawKXjUsL8YK4vjrxZQFDwEc0aJPlDttTasmwyFwdWWcT22NsYPQv9RWjA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Mon, 22 Nov
 2021 20:33:39 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c%7]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 20:33:39 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To:     Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <daf5066b-e89b-d377-ed8a-9338f1a04c0d@amd.com>
 <d673f082-9023-dafb-e42e-eab32a3ddd0c@intel.com>
 <f15597a0-e7e0-0a57-39fd-20715abddc7f@amd.com>
 <5f3b3aab-9ec2-c489-eefd-9136874762ee@intel.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <d83e6668-bec4-8d1f-7f8a-085829146846@amd.com>
Date:   Mon, 22 Nov 2021 14:33:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <5f3b3aab-9ec2-c489-eefd-9136874762ee@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0111.namprd03.prod.outlook.com
 (2603:10b6:208:32a::26) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.236.30.107] (165.204.77.1) by BLAPR03CA0111.namprd03.prod.outlook.com (2603:10b6:208:32a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Mon, 22 Nov 2021 20:33:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82e49468-1be7-42fd-0004-08d9adf75d8f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-Microsoft-Antispam-PRVS: <SA0PR12MB43847E748DE479357CC7DDF6E59F9@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WCFYp3WFd+x7dZJiea4QxoAsPpTZ0/9Nqnof2eVcpPjgSlDwSwUmr7fhKH671bPpx6OecjLijbx4VUBjPwHcgQKMkPliFD73sTXRTb5xPnwTfTMWe959rmcb+JV6DD6BgMnIBQ7l3WePjjU+62UtMAWZzlg8KtkalSY3bckYyh2SySKqion+fItSO3ZeGpuvyZmIzRh3vzw0jl94T+eOVOm9xoDGwRAaZTCT1bfEuztgxoXqwD05r8h09ofxctwZU+jxuCbetKMPGG5VdbNJID1dpRQor3mAuFsOdXPTsoxE3b6A35g776hU4qt7eb1pGxZYkurr17rI7MJzw2LRWYXR8Lip9vdjKOZbHJdcW3dyXZ3vGEAYMvjaQ7cMH9nY9Z40rLzSVUeV0gunAueFhrVfoGzc4wbg/wviDgUkclYhfEp6p7Rsoknx07ymFavUadLNZS/sVE/udrINihiG0dONdOE3slchBiDYVHHamdAoTFaFwKMzW5/x3UfXeo/zpGJ9Y+IKArgUIW9FVBnsV52azrL+7xBhpm0j3WD61QY8bvmGXNwgC4xDyqs++Pjtw5UsmXXO6PjVSzXSIWd3xbGxv1vcT+8N8ZDePyGfMBplNXG7MGuCSwoK1U3HtOYCMhPnlIrxXOJ/ErffxoilGhcxQmmbx+yYbNaAw/zkTV7QkweGzzoSfKs9/WOct13EapeM4DMd5opdQqVVNL4Yg6N5r0iCWam+kz79Svldp8I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(54906003)(38100700002)(31696002)(2616005)(7416002)(110136005)(8936002)(6486002)(8676002)(956004)(36756003)(66476007)(66946007)(4326008)(16576012)(66556008)(83380400001)(508600001)(2906002)(186003)(7406005)(5660300002)(86362001)(44832011)(26005)(31686004)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTlBYTBNTjF1UGsreXBrQlI0ZkVGd2lyRTUwSDhIaytNV1ZYdXY4enlnSXBr?=
 =?utf-8?B?amxEUUJWbWptYkFaNm1aU1pTRkYrRHQ3eldRM1hhc1RUU2hpL0FFTWtyVHpM?=
 =?utf-8?B?dGFmcUpQSkxhT0RaWDloc3Nxak1xU2o4YlRGeW5uajFNS2RTbGR6dDU2MjMx?=
 =?utf-8?B?elo0Q2huR1dCd2oyWnVKRXlwVFNoRG9iUXF3ZlovTTdhRHRUaDNzTElMUy9a?=
 =?utf-8?B?QUVhb2ZxWnh3eHRWdVRnU1NqdU53RHhsMHlRVVlzNlQrdGM4OS9PNi9Fditj?=
 =?utf-8?B?d2VkQnYxYjFpMG9EMWpxV0JmUFZhMElxQkNMWTk1SStjRysyb0xUckF6M1U2?=
 =?utf-8?B?RzZpbjRLTWxYbmcrTCt3dCs1TmtiOFBvY2lZVTFhbGpMRS9tQTZyOUsxb0Zt?=
 =?utf-8?B?WmJ5dnkzTVJIYUtQRnZmVCtNQUtKY0xNc0o2a1M1d0JaMklJSWVHWTdZUUlj?=
 =?utf-8?B?VnV2a2Qzcms0cUViZll3cmVHUlJLVlVjenBYNVBZUG9HQWpIYldXdThyTFhy?=
 =?utf-8?B?ejVwR2ZnYzRScy9qT2pzWWdBaHFua0hGTWc2blNZWkpKMmFkYkE3eUhJMFVu?=
 =?utf-8?B?NEk3aENDRnFMeWJFZXV1N2sram85cUhBNkxod2pFMFFuTmdPN0xlaVZvbHl2?=
 =?utf-8?B?UFlUdjNVR0JQYUljZm1jSXd4anp4ZW9tRFI0TFRxUE1YRVVrNnBpZUZ0WE1T?=
 =?utf-8?B?UCtiY3dpSTdFTU9YcDNOZFlCV1oveE1xSzlVWkF1czc0RzloMlVDV3YrcWxW?=
 =?utf-8?B?bit3aEVwVXg5UCtvbXViSWR0SjNPamJPYlI3NW13Qm40Y20zZ2pKcXhBV2Uv?=
 =?utf-8?B?VE1ML2FVTzFrUXVCdkZVajBWdmFSd1hmUnRDL2szRWhGM3c2S0kxclVLSDcx?=
 =?utf-8?B?ZXZIZEhOaFFCbG5xNlZVS1NnTW45ZUljeEVrbkF3b282bk1USklLK3l2QjJ6?=
 =?utf-8?B?MWgzeEppSFoxd21oWUVkZFduamFBMW13QWdkTEp2NFk1U3FKQUgvaXdFWnhw?=
 =?utf-8?B?MVhheElyYVpYM1lkcUdMUDB2MHc4TGRxZ0lZMWJqR0hFZmhsYTZ6c09jQjZl?=
 =?utf-8?B?VHNnMUptdnQ0UWJSR0RYbk1XT1VqandPVWxVSi9HeUpwRVZMMnV5V1dxMGZq?=
 =?utf-8?B?OE1aYWx6VWNwMlBDQlc1STVrU2RSeVQ5QUpZWGJOdFYvM3VUbDZyTTVFeWNu?=
 =?utf-8?B?ejRwek9OajdyRkUzVE1yMFB0U1RPOWFta05PUEtBTDg2WXhUZ2p1aks2bW0y?=
 =?utf-8?B?VFlCM2NqejFCc3Uxb0ZsenRndngvTUZpODdRSnlWVEVVSHNZYVdvTmYrYzI4?=
 =?utf-8?B?UTlIY3REdDVzbEp2OXB3aTJTSW56bmptVHBlQW05OVZFZ0dYU0Z6WnJZMStv?=
 =?utf-8?B?MHQrTE5kaUlPcnF4K2xUY3pmeUxFYTgyUEdXNjVWVVVuTGszRFptSFhWWjY0?=
 =?utf-8?B?eVROUFNNRkFOVnc1Wm8vQ3ZzMUNtY0M3ODdFeVhFZDVUbE8xUDEyaUd1dk8w?=
 =?utf-8?B?Y2NvL05VdTByOVlmUG93bjNwaTZjRXJZT2k5cW9aVWU4aTc2Z0VYclpHei9I?=
 =?utf-8?B?ejB0UE1qTWpDb093K09tRzNVdmNjTjJWTWdiMWljdnljZlZNeDZHbUhkQ3Vl?=
 =?utf-8?B?VVZURzNjdG83emp1ZUpKeTRqa2tOU1VGMjFSL25qOTNQUklRbTl5b0JUdGp6?=
 =?utf-8?B?T3JXZEpZdlhkcUZXOTA0ZWpnVFVoRkR6RkJUOFVWTWNIY3A4NzZHTjEzRitx?=
 =?utf-8?B?Rjg3bnpjU3k5aDhDazduU3RXSUtMUzh6bG1NS3pNQm1KdTBiL3RmTGo3eWFM?=
 =?utf-8?B?ZGFEcVlrSy9WcVpVTms4VmxsZmVjemlNT2pRaTVKMGU0ZVJpZVltWWlORVVO?=
 =?utf-8?B?a3FwRUtBMmxWMmZDcmFWb2tMS3FMY1NGZFhzVHNKMDVsYjlPWHdhZVErZkpi?=
 =?utf-8?B?dmRYck4xL0YxZ1JEeUhnZHdoR25nS0VWbmR6TEZsTEhlazA1RzZWeDdkdEpK?=
 =?utf-8?B?TVg0bUo3Ym9hb3JuTFloVnV4bGlITjMzeTJMcjkycEluWGtOdTUyZitaT3VZ?=
 =?utf-8?B?S3ZweTRCOU1jN1RRckd4clJuSEgxazZoMFVIcm5XcnNPeUJ1TUZmK2R1VTR5?=
 =?utf-8?B?elhwU2pvcHNUOVExSDNsbXplTVRSbktQSHdpaXhNRGdycldBcXV4M2plUGNu?=
 =?utf-8?Q?PzRhxKNSrsr/7bIoFSZ+IcE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82e49468-1be7-42fd-0004-08d9adf75d8f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 20:33:39.1453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ztblwpyKANCJKX+CGfVGvh0Ux/isTTt5CjBUN0jvYvTHsxhuKxe4lom0gT9gqvfyI7lCVDgcaR1pfuyn5JPQEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/22/21 1:14 PM, Dave Hansen wrote:
> On 11/22/21 11:06 AM, Brijesh Singh wrote:
>>> 3. Kernel accesses guest private memory via a kernel mapping.  This one
>>>     is tricky.  These probably *do* result in a panic() today, but
>>>     ideally shouldn't.
>> KVM has defined some helper functions to maps and unmap the guest pages.
>> Those helper functions do the GPA to PFN lookup before calling the
>> kmap(). Those helpers are enhanced such that it check the RMP table
>> before the kmap() and acquire a lock to prevent a page state change
>> until the kunmap() is called. So, in the current implementation, we
>> should *not* see a panic() unless there is a KVM driver bug that didn't
>> use the helper functions or a bug in the helper function itself.
> 
> I don't think this is really KVM specific.
> 
> Think of a remote process doing ptrace(PTRACE_POKEUSER) or pretty much
> any generic get_user_pages() instance.  As long as the memory is mapped
> into the page tables, you're exposed to users that walk the page tables.
> 
> How do we, for example, prevent ptrace() from inducing a panic()?
> 

In the current approach, this access will induce a panic(). In general, 
supporting the ptrace() for the encrypted VM region is going to be 
difficult. The upcoming TDX work to unmap the guest memory region from 
the current process page table can easily extend for the SNP to cover 
the current limitations.

thanks
