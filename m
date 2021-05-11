Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D4437AE87
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 20:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbhEKSgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 14:36:00 -0400
Received: from mail-mw2nam12on2080.outbound.protection.outlook.com ([40.107.244.80]:45793
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231956AbhEKSf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 14:35:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GUDmjpha5x0X/LUm7fBpjqcvrauYBZmarqKy8GSw7FWWyee6OyRFEaYNJS4pAJUUxG+Ijoe5tSnV3XjtuKDomEmk0+DaU/QTqRRt1+2elYbIb5SQgqP2eelN4IPaVbqHQ8t0+1udRPVOUFM0gRus2fTJSHoIKgZPu9uTowc8rTSotvTFr4PQ95puWUHtg8/FjSgzgrqbQ9uiLsfouKXOiWlVR4lrLwPifYE9Hd/mj7VY9pMf/iW0fVuAVwEBsWuppSqCaG8IbAicRLm7CRqcViEfwJsRLBgN0FEQBRhYc+QFt4hb5xgJzt305Tfu8HrzPdzVF2euHu7+pyXxDCFgUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzyJkmuEPuXbHr47JkJZe09ERFsolCCVdGAei7/KWxg=;
 b=SRLkHV9tIy/cdj0+GfMFtlzcPEeZ+PnkXLh9L73g5jc+VsAx0K93MS0lnvDub+YMOcAq6Rb1WDPdHlWL/sScTLXHC4TnIyp/jkfkm+E09HCf0hQaOhDNM6hZlq13vfd8Tv0M13J/Rtq3kO43XAVLnIv7FmA/f74Kap2htGgfFsZt9nrBherDEgvM0JhEE9lFRueb93CiHmiX/pAduz+K/6xQNkfPo4QyqbOQwxTIKLjMGu2epok55oh4B4Nvree+PYiZQX6/+AqG9VA/5SXY1rPmSv4J4gvXUsXE14rnCSnLYpguCboSGR0cpzy2m6gXTRm4c3f01YDDiYOsA3AjIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzyJkmuEPuXbHr47JkJZe09ERFsolCCVdGAei7/KWxg=;
 b=gbnDtpCZTEbDtD0sRB6RRD/DJ05Mhv6ASbdcoZihpULFrXxMVyu4NaPFgn/Y09FfrNqLL/p2NEUxmA53AEoYD0ZgZlEZvk+DHf+5YXHUGXkNRH9QBUa7qJcEcf+z2xOaMAQzubXZ6u2WjEZs7RVvthfrwEeTcJnE/f8ZHqYDv8Q=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2512.namprd12.prod.outlook.com (2603:10b6:802:31::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24; Tue, 11 May
 2021 18:34:51 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4129.025; Tue, 11 May 2021
 18:34:51 +0000
Cc:     brijesh.singh@amd.com, Peter Gonda <pgonda@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kvm list <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, jroedel@suse.de,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>, peterz@infradead.org,
        "H. Peter Anvin" <hpa@zytor.com>, tony.luck@intel.com
Subject: Re: [PATCH Part2 RFC v2 36/37] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
To:     Sean Christopherson <seanjc@google.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
 <20210430123822.13825-37-brijesh.singh@amd.com>
 <CAMkAt6ottZkx02-ykazkG-5Tu5URv-xwOjWOZ=XMAXv98_HOYA@mail.gmail.com>
 <f357d874-a369-93b6-ffa1-75c643596c81@amd.com> <YJmjAaogWeFgCEmb@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <07ce14c1-d9b2-2a88-9297-cae4e8dbea1f@amd.com>
Date:   Tue, 11 May 2021 13:34:48 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YJmjAaogWeFgCEmb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN6PR16CA0066.namprd16.prod.outlook.com
 (2603:10b6:805:ca::43) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN6PR16CA0066.namprd16.prod.outlook.com (2603:10b6:805:ca::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 11 May 2021 18:34:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 770ac873-dafe-4d55-cde4-08d914ab7686
X-MS-TrafficTypeDiagnostic: SN1PR12MB2512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2512DA1187C702DE45C27F53E5539@SN1PR12MB2512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UgZHGSWMT5tt2iXCnCEyktH3FAu41LDRSK9tU+XeZQNrqKq3PaApSksbpQtcS+LowlM2HBa8rlHZTGYDJ7TeUEStyOWMxsbdLjTTLRR9Sdb39PQvzkIizb5nEeA3KIo6HBqbp8EWdlXKNgmDyMGlJzSEQFjaLdTViV4T5WTB/O/btOBBNkARJv/40pPhszMWQ6t+BGZTuUG8R+8hfwWtYmGPVF5d8No7CuCLcXDZVzDPTPuJRh7QRshb60I+RYUhqmQ3/LR51ZXi2V03EYpTmjx5ltB/qi5oQKEREkVkZsV3viu/kIxAUmHVK24881ro6sBh8dXs/h9o0o+CPAvWH1J41Nj5R8y3zqLa0u1zgnHoJTpF/vreBGyzd+qH5WTsBWZSSX8Sq9VehkBU27q5NDsjygp3mnr7RfetuBa17SJM1IdvinZfrDbCepb6yXzsbrM2f1j5TZ2zdsFNsKKJVn2sLqGBA6g07zrx9Jz2yvC+/+6ZGLHoLLpHjVkGaB5lOwCs4sHAoxK+/wq7HwRbvXyWddRUNUhGSQlxDBWWLm+2Hn5bn2wZyojHQUJ0zIZYHjXhZ/+DIBxF22xU0LqTVS0U5QN+K0xLTCMJlztjD+hBBUnPF6F+X6vvs4hyJCiQAH4MWx56uY8UIJ/VeUG6urx1Kl+nefFoEV6zvjI7GicEMUXYPCqWIja8pS0pkeSG4KbBaWMVEOw5SAQIkxUQmvNDiK2HPXmuVrVOL+v2rm4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(66476007)(186003)(5660300002)(83380400001)(16526019)(6506007)(36756003)(956004)(6486002)(66556008)(31686004)(44832011)(86362001)(6512007)(31696002)(54906003)(7416002)(6916009)(316002)(52116002)(8936002)(2906002)(53546011)(4326008)(38100700002)(26005)(8676002)(2616005)(66946007)(38350700002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TldISFVjamk4K3dTQmdHUWtHWWFXV1Z2aFlMQ1AwTUczNTNxS0VST3R3WG5w?=
 =?utf-8?B?RVJBZ21zSXEybDh2anhtUlFQeVFxZW9yalA2WTd3RGhVSkZtM1Uyd09CWkl1?=
 =?utf-8?B?TTBuNkZIYkx5b2hmVFpvUUxqbWZYQ1RmZHJoQUZGNlR0NzhuNEpoZDN3MVpX?=
 =?utf-8?B?SDJUUG8zZkxiMzgrNWVqaTJheE5ybmpSZ1VxNEJQMVppTU5SQ1RnSHY1Uk8v?=
 =?utf-8?B?RDQvYTRmdTdXb0JXM0hVTmcybGNYNXVWZ0hRRlo1aEx6ZzB3NWFnZU9sNGxX?=
 =?utf-8?B?cUFaR3hpc2I0V2Z2S05mN1hKTGFGVlhENzl3WlZTTjZMcjJaR09jcStrZkhR?=
 =?utf-8?B?SFZKQStIaUF4dGtwTDB4TDRtQU5xWTd6cy9UUGFZU1BxaFNvTVBHRGh4T1Yy?=
 =?utf-8?B?MHdua0JGUGtjeHpKUDVEU3g3MitIcWphYmx3eFFPR3B2dkV6N0ZqYUk5Q2Vs?=
 =?utf-8?B?bWtzcDVlWitqcWtOcytHbXBVS1VDM2kyblkydnpHWG4zWmlLRVh5Nk8rT29z?=
 =?utf-8?B?bHJsMWhxMXpZdDBXbVphM0tyeldUd21vREN0a2hyNXkyMHovclJPZ2xMbmpE?=
 =?utf-8?B?Z2NCd0ZlS1NJbXNmNk1mOU9vc01DNy9RSUc2bTI2K2dGUUZHRHkwQ3VVcDQ2?=
 =?utf-8?B?M3lXTlZOWkpBQXd1UWUxYy9tazNKU2tOS3pGNWFJUzJzNWdUci9tQVY5L0pk?=
 =?utf-8?B?WktVYlV3S1ZVdjV1SUZtZHJQd2F4Y0VHRFRLQlJXODJoc1kwTHdWcUZsd3BP?=
 =?utf-8?B?WGwzRkhmVTVDcTloWmF3YkdFSVNKcG1lMVF3ZjU1MmhPZGw1RVlic21CdFZ1?=
 =?utf-8?B?aDhwVVl1d3hVclZhdlF2Y0Q2Qk1zMHBYazdyVmRtV2l6dFlnNU1jT1VZdGtK?=
 =?utf-8?B?VERReHpnUUFhN0hhNnZPQ2hNTjdTeHNsdnc4WHVTRmJPb25YRDMwOHlIbHl0?=
 =?utf-8?B?QUdoOTNmeHdYUTNxUEpTNU5xN3FEOSs0bUhJdEpHYTBDeTJIbWlTakN1QVIz?=
 =?utf-8?B?TkVtenk4SjgzOHdDMk1MTjRhdUZNVUo4S3BFaXdNeWNXZ2VsdzNnTDRaZHlk?=
 =?utf-8?B?Y3RrNW8xQlFBWGkrZ0F5NWowb3E0YlhwNjRlVDBBU2pwNlNZUVh3a2FGUEF5?=
 =?utf-8?B?VkJ6VlJ3L3lUNHR1akpINVhxRXd4VTI0a2lONCtBUTc5RzkwdVRKSXFuajc3?=
 =?utf-8?B?Sk5NT01vV3lMTGpxekhVSG53b093YkgvMEFVS2hINzJacTBBWE5IL3dSM0w5?=
 =?utf-8?B?Z0VpVHlROC9kNG1NTi9xRTY4TGIycmFoR0xESWUxanE0WGtLaEdSQUFNbGNl?=
 =?utf-8?B?a2o3TU5NbFpYalByQXlvd1hWWHpWc2hJOG1CSCtGaEwyVUxEMWhXUFd4dnNK?=
 =?utf-8?B?NUNMMXMwbW1wRUdXd0pGWjJLK0E1a0ZlSDl4cUQvdG83RlhEN1dnb1A1VlZi?=
 =?utf-8?B?MSsrK3BNTjB6TnN2L0FGTFZ0dFFMS0loOWplbFhXTk1ZYXZ1bHBwOTZVYU90?=
 =?utf-8?B?a3FkY0J1c2VSQW1vamhqd0luKzkwT2ZGMFgzU0xsM21aeFJ0MUw5NUlyOWxY?=
 =?utf-8?B?VXdnaGExcm9NK2JFUUFCTUtJRDQ3R2V2S3ltWXNRaVVFSzcxcnVZOFVySTkv?=
 =?utf-8?B?VnlKS1YwUjc3RkpNVnJpNk0xYkp4ZS9lck5taHVDY3o2NlBUS3owcUtmamdh?=
 =?utf-8?B?eS9zNk92S2xtZFNXdjRVNFc3RzZyNm51ZWRIZnl4djV1bXlxMHM0UGUxUnk2?=
 =?utf-8?Q?PCnGvlTtGspnLlCWKMv+9KuvhR8uLfHZxXDkKwK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 770ac873-dafe-4d55-cde4-08d914ab7686
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 18:34:51.1784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mwaMS4C7jsj+iZwDr38VsmViuBnM4xWA6HbgbLG+jUArCZgC3UWXZssPmt2cQiqSBvuIidOTakRF3XI9koPGmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2512
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/10/21 4:17 PM, Sean Christopherson wrote:
> On Mon, May 10, 2021, Brijesh Singh wrote:
>> On 5/10/21 1:57 PM, Peter Gonda wrote:
>>>> +e_fail:
>>>> +       ghcb_set_sw_exit_info_2(ghcb, rc);
>>>> +       return;
>>>> +
>>>> +e_term:
>>>> +       ghcb_set_sw_exit_info_1(ghcb, 1);
>>>> +       ghcb_set_sw_exit_info_2(ghcb,
>>>> +                               X86_TRAP_GP |
>>>> +                               SVM_EVTINJ_TYPE_EXEPT |
>>>> +                               SVM_EVTINJ_VALID);
>>>> +}
>>> I am probably missing something in the spec but I don't see any
>>> references to #GP in the '4.1.7 SNP Guest Request' section. Why is
>>> this different from e_fail?
>> The spec does not say to inject the #GP, I chose this because guest is
>> not adhering to the spec and there was a not a good error code in the
>> GHCB spec to communicate this condition. Per the spec, both the request
>> and response page must be a valid GPA. If we detect that guest is not
>> following the spec then its a guest BUG. IIRC, other places in the KVM
>> does something similar when guest is trying invalid operation.
> The GHCB spec should be updated to define an error code, even if it's a blanket
> statement for all VMGEXITs that fail to adhere to the spec.  Arbitrarily choosing
> an error code and/or exception number makes the information useless to the guest
> because the guest can't take specific action for those failures.  E.g. if there
> is a return code specifically for GHCB spec violation, then the guest can panic,
> WARN, etc... knowing that it done messed up.

The GHCB is finalized and released so I don't think it will be covered
in v2. But I will go ahead and file the report so that it is considered
in the next updates. Having said that, I do see that for other commands
(e.g, HV door bell page) the spec spell out that if guest provides an
invalid GPA then inject a #GP. I guess we need to move that statement
and apply to all the commands. Until then I am fine with not injecting
#GP to not divert from the spec.


> "Injecting" an exception is particularly bad, because if the guest kernel takes
> that request literally and emulates a #GP, then we can end up in a situation
> where someone files a bug report because VMGEXIT is hitting a #GP and confusion
> ensues.
