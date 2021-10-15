Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8B542F83E
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 18:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241409AbhJOQeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 12:34:21 -0400
Received: from mail-mw2nam12on2055.outbound.protection.outlook.com ([40.107.244.55]:19168
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237115AbhJOQeL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 12:34:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUsHC+UcCsztXkl8d4mvq7LhPaYyDp6mge+D8iJ1D5g+IO6UCd6HA1rrF4G+E5KhZCsSlGYk/C3IYQTwWL8RhH35CMNcuvmtY2sldG72MaFanZM++p68BuQZsLFjkq3cO63lfICMm24lbq0NVRrVds84La0kUDW61qZ/L6HCKqXsvwpt3isruV0gFLD+V30A2LOlMXSOPF/iDlsTl1K46ZNNXvNP7qU8DKHQNCTN7DREnEvelRv9xeSS52cLJlTsPe/Od5nNkeyrIln9nz1BvmHgwxRowtcNt41GzhlzwIE7JXU1yj2GCcknVRkzCQEBIJ5GvOSujshpVok728etWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vxuCOtAcfaFHPEaVOWMvA4jCBawetXspOGQUlNNhASc=;
 b=a/CAeJWBFCd10EC0sO3/gOeTwvYDHvwHH9ntagOwW56UN8JIJF+BvG2IoWnMu3PvcYdLPHv10g7Sszx3z53FNJwrXnH0Wq6K0Wh4rpZxt0zGbvy9oiOsOWURqMj5U4UqPEfWs6p2WwkQZhur6VurefyK0me7C4IK311x3+xACVsMWVbZHWy6xQic6rGOj3+16TLwIiMKfz3rwAAFffG0hPLGEQY4cRGTAhb26WGL8mDs7daWEHfNjnZrwLt/y9IPmKbeSTyriFjAyrVkGlZFMjbrazWFBiJX1l5MMisvGP6/DbysLjVlaod5bRBfsX5jzer7KZBQtngfafUABOiPFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vxuCOtAcfaFHPEaVOWMvA4jCBawetXspOGQUlNNhASc=;
 b=gGu0H0rlFO7noUWWg81DzpMUWPLmFRrnAoEB4+6WbvrLdE7HduuCGnlyBjSxbogV3Vi7pEQ5nRRxY+oznRXZskQ7elNgkYqlwp07O2499gJfHQZl8MCHmQ948IvKnUDtbjpJEJK4K3IMFzfB0Am+ue/GLpW43nOTarkEcZg8yLM=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2782.namprd12.prod.outlook.com (2603:10b6:805:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Fri, 15 Oct
 2021 16:31:58 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4587.032; Fri, 15 Oct 2021
 16:31:58 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
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
Subject: Re: [PATCH Part2 v5 39/45] KVM: SVM: Introduce ops for the post gfn
 map and unmap
To:     Sean Christopherson <seanjc@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-40-brijesh.singh@amd.com> <YWYm/Gw8PbaAKBF0@google.com>
 <YWc+sRwHxEmcZZxB@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <4e41dcff-7c7b-cf36-434a-c7732e7e8ff2@amd.com>
Date:   Fri, 15 Oct 2021 11:31:51 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <YWc+sRwHxEmcZZxB@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: BN9PR03CA0660.namprd03.prod.outlook.com
 (2603:10b6:408:13b::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (165.204.84.11) by BN9PR03CA0660.namprd03.prod.outlook.com (2603:10b6:408:13b::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Fri, 15 Oct 2021 16:31:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 738e1d62-2503-403f-b1f0-08d98ff94eb2
X-MS-TrafficTypeDiagnostic: SN6PR12MB2782:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2782EDCA7BF32E73F2432BA0E5B99@SN6PR12MB2782.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cIGnpq3C0+igaAlZYESG6AIwkMhnssUsSOvp/CX8zkj6s/k881KuvgK9qzxce+qTL3tenrOXHIxf5pyr86noSqQ44ZrgKJ6sPYfsfEKt6Lo5s+5XckPyrAcmK2tQoziZRpyox4OcBJNNcKSF9k5a11jNvh0VgiaClAsqUmWCWXk9m1EXzlscLcSeQpkKFLcVnEyS1T6i+DSuSqd8MMjsbRo2GuAFQWuu9OK3DCihlrsogbeb8cUWjvCzf0JZs60XL9On0mmaX+FaKDpHXGE95bg/6jXCqw3GpgZxl4cuQCH//zAqvlcFwoLQVlExKIYctTRW5smDALlzFBEunhkOXJPhiXWgmt2kejnpwBwKMmwI0CKdg/Rw1fewpJxY0dc/sTioxhpTdCaVlyR+1jOaSOIy30xySKkIxec2FqFdpVJxJeuWFDNB9Vq9WvYx2YZl/b/DZnutVgFxS4s0rj0tsUNJ/0RSAOjxM+hJAMkp1sxBcexQbzK8scA2SLYPcQg/oY/FWS4o0TC+P4AKnbuUJR1gSrRS314YN+ypIAmnR4UQtVy6KxPkLK9fHrJWeWq0DdDXHXskcfc8DONlVfHppXehMLxogR72rstpLSkabbi191Ei04OpLGH/kCqhC9/JGVTjUYJqXblIODqoC9+VRYErNTJtZOBwJ2fbN1RuUJs7U1Mkl87UHGxW9UaHB13O05MQky6nEV/l/pQoH+191dYLnZNUtQb+OADcu4IH3R0gWAN1oNUxmKkciiCLhMidYjNqQpPTeJjJx0ZBwd93Y/jUZOu/fHydJdVzZgV5iNRCb3eIreB7CZI5u+qpvR0nQyM3czf8zMXg8/zb5lGaXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6486002)(26005)(2616005)(66476007)(8676002)(6506007)(53546011)(31686004)(4326008)(966005)(956004)(44832011)(508600001)(5660300002)(2906002)(36756003)(6512007)(54906003)(316002)(83380400001)(31696002)(86362001)(6916009)(66556008)(66946007)(8936002)(7406005)(7416002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RlF1Y1F4RUM0aWIrcFVxYldxNk84SDU5emtZQ1hXVHlyTGU1N0NFUUJMWmtm?=
 =?utf-8?B?bHUrZk8zck00aWFHU2wyNHhrbjcyQUN5WWVJOURHSm9WQXZlZXBxMC9waGg0?=
 =?utf-8?B?RWFkODFOa0lEVXg5MmFTM2JZUWUxdE82cXNoSG5acDVJV2YzMmJPS0ErV1lO?=
 =?utf-8?B?SXRpSHgySTgzc0tabzI3ZTBDenVtYWY3bHhMZkpwZTlaR2Q2WVBySEVldi82?=
 =?utf-8?B?c1VwYmNScS8xa09qTnROdzdKYzk4T2oyQlp3L09od1U5Q21BNWZzOVltY2px?=
 =?utf-8?B?ZGJoSzlPcG5YOU83YkQ0Y2dtd0Y5QXdpZThEZjdSaGNHYURIcnEwRzJ6cnlN?=
 =?utf-8?B?OHdqK2pRRkFNTk9yYTNPLzhGY1dRNUJydEIvbkNIeERSSGZtRGp0MUZQVk85?=
 =?utf-8?B?NHYxNWM0QVNoTjZmdlB2akU2YlQrWk5kRFhyUTVMQ2hNTWgrRmVGbmlaak8x?=
 =?utf-8?B?cUVlVkUrNEI4aG4zZVNyZlNIRTFHTDFEenlzZ1h2WWk3RGNHOFpOYnc5akNj?=
 =?utf-8?B?S2RGUGw1emd4aTFMSGNSQ0oyWEh5RmxBanhQMFR2VzZxcFU0Y012Q3g4L2Mw?=
 =?utf-8?B?L2FLOFdZZGdSaWlpMUt5WnBMRUdIUk5FczhRSXZERzJlSTZsYThDSVVOenRO?=
 =?utf-8?B?QWFpc1VyMTVneGxkallzSDUwV01kMmd6NXUxM09JQnVSd2F6VnE4Mlg2OFhR?=
 =?utf-8?B?QldoUHN4cW05WmlOelRmeUZmdlM1RDQvKzNnYlJrdk00Y01sVldMemV1UG1m?=
 =?utf-8?B?RVFMbWpKY2g5UjhSTFl2blBMcVR0NE90WHlzUjZackE2NU5xUjdvdG9leE1y?=
 =?utf-8?B?SWw3ZVY2Y0RzVUg4TTBIb1kzOS9VU3JrL2FNM0djdldmNkhMdE5yZFlYZENP?=
 =?utf-8?B?V1liWFExZDRCLzkzMHpObm9YSTNZeENUTmJkNUZydXUxZTJva1lOd0Q4d2VB?=
 =?utf-8?B?dU9xYlkzbERBVkJReXdxYmJPV0Q4WUI5VnpKOGFYZDEyVlhmZTNJdFdCbHE2?=
 =?utf-8?B?SHBKTytXQUkrVEc5RmFLOUpjUDFpMHAzT1lnb0FCSzNoR1RXMlgxRTJXZzNp?=
 =?utf-8?B?dVpycCtJQS9jU1MzYk5LU3ExZitBb0Q3K1JFWlV0V0o1cEpyVllEVzFqcys5?=
 =?utf-8?B?VE5YbUIybjcxQ25LN1ZsUVVOK3VNMnA5N200NHZuSnVWUUg5MjZRYm51RXlP?=
 =?utf-8?B?ZzZreWNjWUhDZithZ0x3ODdGR3poOG5Zb0JCa0ZSdTVRZDNIaHltWUViVFg4?=
 =?utf-8?B?NUl1L01kR0k5RStjcGRIMDkzbVUrRi96SVkzWUo3d09BUG14QlpVM2cxU28w?=
 =?utf-8?B?WWV6KzVLVTdBNEwvZTR6Q1p6bzV5bmEzaEpsM092YWJHbG1kRzA0UlJXNTVz?=
 =?utf-8?B?UWpOcE9ZVFZucmJBbVVVWWhUbkhxWURUbWs3V1J5d3hlVVh1aHdPSjZvOHNv?=
 =?utf-8?B?OUxpeFZ2ZWtnQnoyTEQ5TFRNS1JUZnVVS3Z0d3FwbHNIcndlUDJYemlDeTdX?=
 =?utf-8?B?Q3lxM0xNR0JBR3FMK2hMU3BraDZPZmF6dXNoUmF3dEZCUDlpaDRJWjFhMk9L?=
 =?utf-8?B?dFpWYWdXWTJhLzI1MWRpMUp6amg1SGRqOHRCRjhhd1JQRVdXQnFOOHdvOWts?=
 =?utf-8?B?SXlZWGRJZ0lWMk04UWdHdEpQcDNIanlITEZFcmJ0ZCtObWdDQWNnVWo3Yk1J?=
 =?utf-8?B?M1ppMmpZMHgyMnlqUFNLQXNpblg2YTRONktqOXUrdGtRZUw5aCs4cE5UVE1B?=
 =?utf-8?Q?oKPDUmP7olodOG6X3n023jsPylYEvDwm8Zql7gV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 738e1d62-2503-403f-b1f0-08d98ff94eb2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 16:31:58.1797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5obGJbQUraNXgcT74FCk02Tl84SzgJtTIGh82pPEZiyRHE51jelhyLvBcqYaul+QpvA7ipugsrv77CWyBBOuDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2782
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/13/21 1:16 PM, Sean Christopherson wrote:
> On Wed, Oct 13, 2021, Sean Christopherson wrote:
>> On Fri, Aug 20, 2021, Brijesh Singh wrote:
>>> When SEV-SNP is enabled in the guest VM, the guest memory pages can
>>> either be a private or shared. A write from the hypervisor goes through
>>> the RMP checks. If hardware sees that hypervisor is attempting to write
>>> to a guest private page, then it triggers an RMP violation #PF.
>>>
>>> To avoid the RMP violation, add post_{map,unmap}_gfn() ops that can be
>>> used to verify that its safe to map a given guest page. Use the SRCU to
>>> protect against the page state change for existing mapped pages.
>> SRCU isn't protecting anything.  The synchronize_srcu_expedited() in the PSC code
>> forces it to wait for existing maps to go away, but it doesn't prevent new maps
>> from being created while the actual RMP updates are in-flight.  Most telling is
>> that the RMP updates happen _after_ the synchronize_srcu_expedited() call.
> Argh, another goof on my part.  Rereading prior feedback, I see that I loosely
> suggested SRCU as a possible solution.  That was a bad, bad suggestion.  I think
> (hope) I made it offhand without really thinking it through.  SRCU can't work in
> this case, because the whole premise of Read-Copy-Update is that there can be
> multiple copies of the data.  That simply can't be true for the RMP as hardware
> operates on a single table.
>
> In the future, please don't hesitate to push back on and/or question suggestions,
> especially those that are made without concrete examples, i.e. are likely off the
> cuff.  My goal isn't to set you up for failure :-/

What do you think about going back to my initial proposal of per-gfn
tracking [1] ? We can limit the changes to just for the kvm_vcpu_map()
and let the copy_to_user() take a fault and return an error (if it
attempt to write to guest private). If PSC happen while lock is held
then simplify return and let the guest retry PSC.

[1]
https://lore.kernel.org/lkml/20210707183616.5620-36-brijesh.singh@amd.com/


