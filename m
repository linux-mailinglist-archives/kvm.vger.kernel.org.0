Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA6136470A
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 17:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241145AbhDSPZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 11:25:37 -0400
Received: from mail-bn8nam11on2077.outbound.protection.outlook.com ([40.107.236.77]:8416
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232354AbhDSPZg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 11:25:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgIChkO0wae0wHdav234ShKqrFPFcBpTuu2BBQ3l1fw4cnYEzCxRx+uCk2jKe3UgQn/f7ahAz3+SkdGMU378NDXAtVIKQwOu5oZL7JoGFuIem1MYEj6WXvJdia2WTfh4WXBRvlw/5VTYJkl+X+8DJrG/vyoaaveJrRXsb53dXWlGkpZ1et1+RRNHPOMJMi+1zfImR7pxF0g8pJgLT87LM5XcDeqtPIVMo7ybBg4bKHbWohpAtIfwEOv1JW0UtIbk4Y7cY4DGCFunJBb6kkPOOE0JD6Z+fWmoeTBTLMbUjIvuQ8PsbDtr+D1ogySuC+aDumUczqaazMqoaSTW3pBNzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SfaebnD1ae0GOWDdsmePL28fV1PXCeFTxQkWPXN2a6c=;
 b=LQC+QsZUmXxVmSJNDxgEwfhDbFkIvfpVvKyMazAaR0W8QFeza8WSu0Cq4WRN3Z40TRh9ZfyHC3jsw3Nk1yTH4knMB0OVxd87nmBpFBlrcooJqwHVAaGGOFrqeLnL4LunJWqMOcxOkh6yPBNjhFBpIvNi8bs8fY4yVbvXFpWlOlSc9F1hgMcOWL/cZt9L/WO1L4kDi6LQqe1kTnTRPd2EdSZAM73Lb6VKDTF/93j9DK3fni+WEOqfdoF2M+U5XJSxF2EW3jp3lGDGyhsC806GldpXsr5yoS+9glHUDDwuWawrvMKG2hM4D2XhcASOrtU2LM3DGFcOfyA0khS14HUXhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SfaebnD1ae0GOWDdsmePL28fV1PXCeFTxQkWPXN2a6c=;
 b=f/D1Xx5x8XueTcLIXa2+FlUwPHT+3e/nVYx6ZgQt5wZ6CQ+6j7V+pRDdO1tPMlNBekeLfAymA8zKABYZullO+vuNPMwiYZn4ihgy93H4WBK0PfccawxWmk2IspmXYiNtwwtAemoM3pINWp+CXUvJmc2yLR87NeYQ02qr5MwZ5v0=
Authentication-Results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Mon, 19 Apr
 2021 15:25:04 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 15:25:04 +0000
Cc:     brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
        ak@linux.intel.com, herbert@gondor.apana.org.au,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [RFC Part2 PATCH 04/30] x86/mm: split the physmap when adding the
 page in RMP table
To:     Borislav Petkov <bp@alien8.de>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-5-brijesh.singh@amd.com>
 <20210419123226.GC9093@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <befbe586-1c45-ebf7-709a-00150365e7ec@amd.com>
Date:   Mon, 19 Apr 2021 10:25:01 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210419123226.GC9093@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN1PR12CA0056.namprd12.prod.outlook.com
 (2603:10b6:802:20::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN1PR12CA0056.namprd12.prod.outlook.com (2603:10b6:802:20::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Mon, 19 Apr 2021 15:25:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2d119b7-170f-4ca8-8d67-08d903474e32
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43822565F8B97FA91B5B8DA1E5499@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UjlFQnm7G6GnsxbqnE2vkW6XO3mfAafUqj7Z0POCGgq2+aJawtfOS7IDzpvD4a0GDf3lQ6HNc6ojvpQ+xdwBgUqUnKviJP16dCY+sCPgbGbCkNUNRmvxPIFpm8BCH8fI+lgBEt03PrgX2FMCL6YL17k5J/mvOkVuPYV6GT3H1YnvwRD8pN2bC+RmG7NVvBNkrMSJPdDWaQcp++w+N4OhdhRaphskfa0THF2tbu2osdTDqqHfEuo5IVVJcgKJT/iz+Zc/bNDaB7kl8m/KuBhlGv78myKR9mH8XGdk33M8GFAtX8au5jjyPfTFXYaRXxhDM4Jl5ixOSqt3KU0/GGDTxFy7FjuB78xB654qhmSsDhCXTMzp8ygIFAk2+8CW72DHI2aAYrTDDS++tC5SxipAeB/jrbi2mBrVGY0Dq6EobiBQnqLfDQVMbtPkbHuV10yQOwd/9c1HidY4pfYi0WR3utXPjK15jqCMeeu+msbkP7OZ3XJTzV/1xiFdtVn8jU5KFr9JOZE6mHZY/sx2wDrfKMbDcDgDFzQ2JOOmiRcUJCqM9nRX3380dZlzXcjm2k/yl18tia+F06ijAlT1ELD7QLl+OCYxEFZIiSY0VKsucdudyt1FjYT3N7IgHG7fUylrqWJQ9vpqYw6Wj6NEBNXM2iR8g0GY6IXjlXBJyaTbfw5fTgqXC2naFQStVhSiBPaLWq80p/Z1mhEbM1185Ctk3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39850400004)(136003)(366004)(396003)(7416002)(52116002)(54906003)(31686004)(2616005)(6506007)(53546011)(956004)(44832011)(478600001)(8936002)(6486002)(66946007)(6916009)(38350700002)(2906002)(31696002)(316002)(5660300002)(38100700002)(36756003)(26005)(83380400001)(8676002)(186003)(66476007)(16526019)(4326008)(66556008)(6512007)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UzVJNGF3cWFhMTV3RFZROGJaMmFZSFBWdGVHYldOTWdQcllZMkxTVmgzVXFv?=
 =?utf-8?B?TzcxY0dLbkRqeERtUkY2N3dnekVvL3BDZ3E2S2Y5K2NlZnV3RmtpOEhwNHVn?=
 =?utf-8?B?ZVkwMEp2anZ5K0dxYjlUZG1DSlErZkcxdnQ5UU5tTFFaeXJJdWZzQktCR0JS?=
 =?utf-8?B?QXRMMVpIdFZmN3l4L0ZGeVIweDFRT28rZHBMQ2t0VUV5UzZGVDJ5R2hLM1Qr?=
 =?utf-8?B?RUhOV3NKVFRyVEZ1OFd5TzRJSU5ObXB6Y0pSbzlYcmJBT2NDVHBoc0RKeHFx?=
 =?utf-8?B?VmR4RHZjNTM2bG1uK0RuZVpPWDFYK1BmQ1V3eU8yQld2Mm11cmJuYUwzaXlT?=
 =?utf-8?B?NHZqUTVwWGVMeFRHMDliSm5YRUlmdFdtdHRSMXUwdDl4a2UvdHFUdFNnTGMr?=
 =?utf-8?B?THZVeCtkYkVzQ05ZQUNWV3JCSUJEdHJsMHRhMFNoUms0QkFOTXFUUEFjVVd6?=
 =?utf-8?B?TGdURXhYUDRDZ3hYaWJvdEh6eFg5UVVDUEpCeXhnM3hsdDJpOHd0U28wL2pu?=
 =?utf-8?B?NHB2K0h2N2F4SkYxK293YXo1SkIzc0tkdjZUOE1DTHBzQ1FSRGpnR0xkT2NI?=
 =?utf-8?B?NEhXTndUQVF0OVI3ZkVVQjhhK3V6dk1acjdiSjVZRGlDcDRLY2VKS1RvRnR3?=
 =?utf-8?B?emFsZDNTamxKcERoT3JmR2VrMnM2akhOY2JMTk1EUzhhVEhBQnFUL05Sa25G?=
 =?utf-8?B?NUdQL2Vja0ZRaWx0QUxxdGhzTkdYOFA1RnkyOC81QVZmNFlOelk3akpaaVpC?=
 =?utf-8?B?eHNKRlEzcmNIbmpKNzlJOTl6L1RZTnlRRnpURXRIdVd2aHlDOU9YVW5LSnFL?=
 =?utf-8?B?TVI2UldSNDZZNzd6RElHZjRQeFFzb29peGNoeEIwd2gxRkl6dDBSUWNodkR3?=
 =?utf-8?B?bkZxZE1GVUM4QjMrVkowTHM1QlU4RjBXTEkyQ01ybGlTWERLdG9LTHdWb3Yw?=
 =?utf-8?B?ak9Rbk9aR0h2WDIxSmtRTjVaY25jZ1ZWakNYLzh5dmVuTHRvS2Y4QityU05k?=
 =?utf-8?B?K2dyRFRBZi9QSmtwOUFqaE5Vb2lxcGpnbk0wemdxeDQwejEyZ1VZZ0RjYXpE?=
 =?utf-8?B?U3JOSmJGc1JqWUZmM205dmRlLzFlTk9uczYvcFFrTWVYZ2RjdDR2MjZDZ0Vz?=
 =?utf-8?B?SS8xVmNZRFdZN2FOcFhRWlAwaTM0ckNWeUgraGMvbXZWTk9XY3k1QlhqSWhk?=
 =?utf-8?B?a3JRcU53SndabmsyUEwrV1NFeWZjZ3drOU5FVjh0WkdMdWcwcHZ6eWdobHBX?=
 =?utf-8?B?K3pOdzJWdk9NeW15OW1ibFNWRi90a1VDdGg0T2taZk1kS3B0MEMxZ1dLN0VC?=
 =?utf-8?B?VTVqTGZYcFFzeEw0TmZyYnpXWjRWZjJNWldxNE9WMFBoQlJFUk9QVUVTbzNo?=
 =?utf-8?B?VWZmL2FoRm55eGZNL2Y3K2NFaG5GRzlFOU0vTFBvaDA5Z28yQUVOUjFZLzIr?=
 =?utf-8?B?cHNGMEg1aDZKbkVxTG1Sa1A0SVY0K1p1KzRFeUFMQnZUMnM2d0xDaTNDSGdm?=
 =?utf-8?B?TlRRM21tZXlLNEFWcTFiQ1V1a0Ruc0hrOENyMGlWQXNCTUNKcnFWV0NWV1FI?=
 =?utf-8?B?SEw4akZKQkcrNzh5eS9Fb1JoUXdpa0RYRUZscGFRWGJQM2l5aXF5YXBuYWho?=
 =?utf-8?B?dlRYc3N4SGhmZDJkTlhSc3pYempMaDNzSTcxT2IxVkFGRVpzVGJtTzhEY0lm?=
 =?utf-8?B?b3Vaa0k2TTdmZm5iV2FSSHBqYnhKZjZXMmsyUHE2S3crTnkrcm05THZnTWhV?=
 =?utf-8?Q?UOdz/eaksbtycLS8L2ZMlDFYyb/s+XkPS2p1BCf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2d119b7-170f-4ca8-8d67-08d903474e32
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 15:25:04.1281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kn6X1ZHoMDKMVsFZ5Y8tmksPEbsyZx5KRg3EJUJSHJFAaDkiWM3aXH1af9ogX/rz1RI3koa6vGE9lv1+UeSyzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/19/21 7:32 AM, Borislav Petkov wrote:
> On Wed, Mar 24, 2021 at 12:04:10PM -0500, Brijesh Singh wrote:
>> A write from the hypervisor goes through the RMP checks. When the
>> hypervisor writes to pages, hardware checks to ensures that the assigned
>> bit in the RMP is zero (i.e page is shared). If the page table entry that
>> gives the sPA indicates that the target page size is a large page, then
>> all RMP entries for the 4KB constituting pages of the target must have the
>> assigned bit 0.
> Hmm, so this is important: I read this such that we can have a 2M
> page table entry but the RMP table can contain 4K entries for the
> corresponding 512 4K pages. Is that correct?

Yes that is correct.


>
> If so, then there's a certain discrepancy here and I'd expect that if
> the page gets split/collapsed, depending on the result, the RMP table
> should be updated too, so that it remains in sync.

Yes that is correct. For write access to succeed we need both the x86
and RMP page tables in sync.

>
> For example:
>
> * mm decides to group all 512 4K entries into a 2M entry, RMP table gets
> updated in the end to reflect that

To my understanding, we don't group 512 4K entries into a 2M for the
kernel address range. We do this for the userspace address through
khugepage daemon. If page tables get out of sync then it will cause an
RMP violation, the Patch #7 adds support to split the pages on demand.


>
> * mm decides to split a page, RMP table gets updated too, for the same
> reason.
>
> In this way, RMP table will be always in sync with the pagetables.
>
> I know, I probably am missing something but that makes most sense to
> me instead of noticing the discrepancy and getting to work then, when
> handling the RMP violation.
>
> Or?
>
> Thx.
>
