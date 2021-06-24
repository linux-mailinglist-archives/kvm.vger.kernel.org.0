Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F203B391F
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 00:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhFXWVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 18:21:35 -0400
Received: from mail-co1nam11on2063.outbound.protection.outlook.com ([40.107.220.63]:62177
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229712AbhFXWVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 18:21:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKG36TNsF/EEsS5KXvNdo3ACyWy/LfQmgPPy2mlKzdgxIAKXyG8Kfp1p0QPFOhEL8Cfqhr1xnnUpKExEab7taYx+uyPVJK09yXoJxqCe3SbN6X3FlqmwXaobthCUEcwUe/JwunXIT0m0t/4XicmQudLAUKFUL3phcAIA+hPjk8bf+/mLZciwj8+6rxQYs1lR/dY/EmpPR8KWb0Me17R2aHlCfT8++WzqusmfXD7WBo/v3fUnC7Na1yyS7Yjd1OuZfbrK7EJ3fM+HAMCngNczIWoI9eX7Kaow4xhPwVCktYQVOENGBtysHE3hBMLyi4/rjpn1Z9T9Y7FgMRbl6yitCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/PjKAo7UK609mgb9Xr9VgYsYB+Yhq1VHWI50jJOH24=;
 b=fM+dUgXgzAHdAvNDunM2z5pvrGVP1W5hsvksrPBvABeY6T5sCn6rH/5+J+yyjfLAW7DWu4exTp2UoGdFrYc3O2bdbg5LFrk82kF5NSii7qpAF/NR78Z9IyoaKM6Nmobf3qMQzzSaBq02f0huQRJ0mXm5EZQmEn6ueji2UhUeeMWpgl7i40O2StpCay8SVMZrko3DoMiBfIEGGoQxgkPQU1RhhBh2ilF0mtmrHjrEGXmJISFdZKaEKYjg4wUta3f5B5e2ei6FgjGvlTqCp+xwIVuDo5HlBNdSbHs3siZ+eXhRVYq8QkQYSf0NlCOnyghne6MRADt+0Y9y/FTACjm6Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/PjKAo7UK609mgb9Xr9VgYsYB+Yhq1VHWI50jJOH24=;
 b=NpLtelCWa9hdd1rOXSK2bWVsQAEpvNwOQOmsCSeGxa1A9pn29XPo1IvbxojnvYsJ1d0Twm3qIJwZ+MMfh4QpxTQLpjuziqisrmee9uqgqxSNst0oXT591wdv4m4M3MynuZIUBsPc7b9ThfZUaIyVIUTWeY6QI5+8c4DG2pcaz+0=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4942.namprd12.prod.outlook.com (2603:10b6:5:1be::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4264.19; Thu, 24 Jun 2021 22:19:13 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686%12]) with mapi id 15.20.4242.024; Thu, 24 Jun
 2021 22:19:13 +0000
Subject: Re: [PATCH 0/7] KVM: x86: guest MAXPHYADDR and C-bit fixes
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210623230552.4027702-1-seanjc@google.com>
 <324a95ee-b962-acdf-9bd7-b8b23b9fb991@amd.com>
 <c2d7a69a-386e-6f44-71c2-eb9a243c3a78@amd.com> <YNTBdvWxwyx3T+Cs@google.com>
 <2b79e962-b7de-4617-000d-f85890b7ea2c@amd.com>
 <7e3a90c0-75a1-b8fe-dbcf-bda16502ace9@amd.com> <YNUEA8n61WO89voW@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <3b82ae79-a32d-a20f-e2d2-c3bf470555d7@amd.com>
Date:   Thu, 24 Jun 2021 17:19:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <YNUEA8n61WO89voW@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN2PR01CA0044.prod.exchangelabs.com (2603:10b6:800::12) To
 DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN2PR01CA0044.prod.exchangelabs.com (2603:10b6:800::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Thu, 24 Jun 2021 22:19:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7af45c9-bee6-4dfb-a672-08d9375e18ba
X-MS-TrafficTypeDiagnostic: DM6PR12MB4942:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4942C30416B43AC319543421EC079@DM6PR12MB4942.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I51NmxwMUG5Aza/2CXf70/5FEoS0vevydGn/2Qv/lcIf0uXreGg5BNHdXcaxGlzTDCfk3lBay/4lmRVte5hJEMRbUKxO5ZjiCClbHpcF9FjHzGsy1FU3oPZNemqaCH0klafInKYaXEVzuiFSvEHCtV/gxZ0P4c3xLpN8YPHZVou+t2+eVWPTTYRqaAqS7aA5fgv/yLWg/QXbbMBav2qJ2gfVTr8gE7TwDKN3lFdaZ/ru3mIeYGCRCY+/QTDN4HBJykWGLrH+Xad8aE0ylgx3cbgz6KfMsh0meTKUGgFlwsoBYs73y/jMlbHKvCfosje3ficuzul+b7wzWINJEGgILu/dm9Quh3DvAiKZYQmwzPG/yFiPOIHpy0pYTlY8HMehHwz7LaMLM+bpTAzB35rWYYtxvjqjpbQhmxYDqKb7hdFQw4p3jMCotRoSG84fZAQM+YVSlRezc21ZmE5IgNYKARG11odP5kpu61fCmAIV5yK9/baX/6fbdDW6jcvR2/Yzv3gW2n3tIMJ9Wa+QpYx1vdizgpV1q3168O9EQBHCv13BsXyNrdD6Kn2CBv1hRcbOdgrFDEdoYFo+5VcRkIg0hgRCuwHZVxm3COdXVrDwjH/RMjkGPvCkzmrM9BssvaT5o8JF+AL0WcVnqj2xATY0yVGW37mSB1j1uTZO95vEK2lxrFRQHc0xzS6QI/c0D2THGTUW3SMjYbWlTQVhQHHrtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(83380400001)(5660300002)(31686004)(66476007)(66946007)(478600001)(66556008)(38100700002)(4326008)(8676002)(2906002)(956004)(86362001)(2616005)(186003)(16526019)(31696002)(6916009)(54906003)(6512007)(316002)(6506007)(53546011)(6486002)(8936002)(36756003)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHNIemN0dUkxL3dqVlRrQ05nUlNGOVhPV3kraVM0N2pZSTg4cTFZTHMzU01U?=
 =?utf-8?B?R1Z0VXZVOCtvbytpTk9zY3NOTlFvbmI4d3Y0NjFuaUlSeUVML3VLR3FhaDBP?=
 =?utf-8?B?T0QrMWZMVXhwSzFCc0VjeXpjd3FscDN5RVMxN21aMk4yL3FWbWFjemNtcGRC?=
 =?utf-8?B?ZzhKYVo3cm8rZ001b1hwVVI2dVJneENyZ0xHcXBsMGwvZkNPb0VZVEk0SEds?=
 =?utf-8?B?N0VLdnhQaTcxdGVPWEZJYURXdnRnbjZSZDczUXZ1T2ZUbHFvdzloVkl2UUdT?=
 =?utf-8?B?NTZRUWN1T3pnYjZhcHVYS21iUVEzU1l1ZzM5Z2VHNGFJOGNCQ2lCMHQ1Zjdo?=
 =?utf-8?B?ODhHZGRLdmxKaC9pQXlpWDN3cDRWdWhPRnlTT0JHQUdzeDJNZFJBLzJ5azEz?=
 =?utf-8?B?dFpvaDFDczNhN1BRaFNnWVpZcUVzODNYZjkvQ2dlU3VCcmtrWVYwWWFvSEZS?=
 =?utf-8?B?TzY5bWMvSkxsNm5GQlpBc2ZSeXBIbGYrRXJqY0QwVWp2dE51N0czY3dtT1ll?=
 =?utf-8?B?N3RYUEFkRStKQnF4eXViYXF4blN1SzRrM1ZXNlZRUlhwd1FrZXRTVDVhWGg4?=
 =?utf-8?B?dGIwUCtJSDZaWktlYVJ6Rmg4L0RYM3dEWkZPdlpPeGhBUVovSTY2ZmViUUJC?=
 =?utf-8?B?L2Uva1ZOUzI5ZzcrRHR2M0d1RWlVRzJRWWdGbXNacHYreHFQQmduVkJ1Vnlw?=
 =?utf-8?B?cy9mWjhRa1pac3VZQVZOaDVuTnlrSFo0VytwaWFoNVJBSmdRaGFKckZoNXdF?=
 =?utf-8?B?TUdXYlkyTy9EMHVVTmNVRGJVU2ptUFRhSGFOblFqOVVmNGltNzdGcWtoblhj?=
 =?utf-8?B?SENyR0hGRUZqbGo2aTd4S2crdG9EaG5hU2k5YTgrV1lnTXpYMnlvNlVqZDJp?=
 =?utf-8?B?WWd1NVpDNUJGWGE3UXNyL0Nod2RQK0czaDl1bHRmdGJRNHhyYjFodm5GTmM4?=
 =?utf-8?B?b1ViSzlXREZDU0VZWjRQUnJWdGlNZHF4eW9FRmRZT2IxR2VXbXZxVXJkcU0y?=
 =?utf-8?B?ZGR6eEJmcW9BcjJ2QWF1ZVNnNGZqWUpBMHRKek16SThrWmYyeEN5UFZQTkVE?=
 =?utf-8?B?ckdMVWVsV2FSYlRGZEcwbmlXYnlWTXNwRndLR3lwbFJuclk0eTEzR1N1ZHdG?=
 =?utf-8?B?c291QXcrdGZjZk00YTNvSjBXZFRkcjBQTVc3ZWEzRDFxbklmM3YxWkp5TVUw?=
 =?utf-8?B?Sjg0a1VuQlpsVU4rUnBURzdMc1h2TnNCYWMySHZ1WWkrTnAyZkwwY3ppNkM2?=
 =?utf-8?B?anlnUE9pVkR4TEVwczdxOEhsSkhKTXRndy9rQ1NTSHM1UWovRytLK0ZXZDlE?=
 =?utf-8?B?Uy9hTytQSjN1Qm5LOGwyQWFSSUhJLzNCN0tnR09DL1dqV01LSXhoYVJKZTVn?=
 =?utf-8?B?Mm8xdThzRVpqajVJN1ZDSCtaZzhvNzFOVmxyMFBqcHFDZnV0LzBYdGYzM2ZG?=
 =?utf-8?B?bDZ1U0t4b2RxdG9hRUg0MFFYYlNqVG9WcU4yanl2T2QxRmpqbUxhTXZ1UGFT?=
 =?utf-8?B?ZXBFTThRMkY2VHk1di9aQ1lLcEd2MEY3Kzg2aEtmanREclFNRHg5ajZrdFFK?=
 =?utf-8?B?YmxvR3ZpWGZIZm1TSEdwSDRpKzlKMzZ4UE0rN3JwMjg5MHVmVnY4TmtqUjZR?=
 =?utf-8?B?ZGU5Qi9PZDhpZ3QyNitYTTRDWHpsM3ZKQ2x2RWhHL1RZb3psZk9vZVcyTks4?=
 =?utf-8?B?NDNJZ1hiWU1QMWFlQ2pleGNIWGdFbU1xM3J0MXdhcDFZRXJ1VG9lczA1Q3lL?=
 =?utf-8?Q?9eY1OQhvSw6VQ/IANnNwm3rzeEbiX8s/fTCl9kR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7af45c9-bee6-4dfb-a672-08d9375e18ba
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2021 22:19:13.2544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PCTTMcqMf4spKk7b56uM8cDyrRSZI58B4UnOxGw1losWJl0+tL2eu19bF8lL+GsoGyBlF7WuNwuZbOkNTEbfaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4942
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/24/21 5:15 PM, Sean Christopherson wrote:
> On Thu, Jun 24, 2021, Tom Lendacky wrote:
>> On 6/24/21 12:39 PM, Tom Lendacky wrote:
>>>
>>>
>>> On 6/24/21 12:31 PM, Sean Christopherson wrote:
>>>> On Thu, Jun 24, 2021, Tom Lendacky wrote:
>>>>>>
>>>>>> Here's an explanation of the physical address reduction for bare-metal and
>>>>>> guest.
>>>>>>
>>>>>> With MSR 0xC001_0010[SMEE] = 0:
>>>>>>   No reduction in host or guest max physical address.
>>>>>>
>>>>>> With MSR 0xC001_0010[SMEE] = 1:
>>>>>> - Reduction in the host is enumerated by CPUID 0x8000_001F_EBX[11:6],
>>>>>>   regardless of whether SME is enabled in the host or not. So, for example
>>>>>>   on EPYC generation 2 (Rome) you would see a reduction from 48 to 43.
>>>>>> - There is no reduction in physical address in a legacy guest (non-SEV
>>>>>>   guest), so the guest can use a 48-bit physical address
>>>>
>>>> So the behavior I'm seeing is either a CPU bug or user error.  Can you verify
>>>> the unexpected #PF behavior to make sure I'm not doing something stupid?
>>>
>>> Yeah, I saw that in patch #3. Let me see what I can find out. I could just
>>> be wrong on that myself - it wouldn't be the first time.
>>
>> From patch #3:
>>   SVM: KVM: CPU #PF @ rip = 0x409ca4, cr2 = 0xc0000000, pfec = 0xb
>>   KVM: guest PTE = 0x181023 @ GPA = 0x180000, level = 4
>>   KVM: guest PTE = 0x186023 @ GPA = 0x181000, level = 3
>>   KVM: guest PTE = 0x187023 @ GPA = 0x186000, level = 2
>>   KVM: guest PTE = 0xffffbffff003 @ GPA = 0x187000, level = 1
>>   SVM: KVM: GPA = 0x7fffbffff000
>>
>> I think you may be hitting a special HT region that is at the top 12GB of
>> the 48-bit memory range and is reserved, even for GPAs. Can you somehow
>> get the test to use an address below 0xfffd_0000_0000? That would show
>> that bit 47 is valid for the legacy guest while staying out of the HT region.
> 
> I can make that happen.
> 
> I assume "HT" is HyperTransport?

Yep.

Thanks,
Tom

> 
