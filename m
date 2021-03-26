Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9ED34AFBC
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 21:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhCZUCA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 16:02:00 -0400
Received: from mail-co1nam11on2078.outbound.protection.outlook.com ([40.107.220.78]:35617
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230337AbhCZUBe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 16:01:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RA/m+KkCZcrGZ6PsTBeN0z3PFovWQlhJ6lYBpgV2ZB9VtOIAHhbtzycMN8HS69x5wnGfKO4z8lewwI+vBo7GPjn5rKOpfHZJimSLzkXH90Sm+GSWc5Tomdz6RqGDm/1LRjaaYZDKnMedXp7VSEZEkyddyGeTpcW44tiJcfjxs1oWPfA7+XmhX4XVlDA0MFAgX1OwhWq/WK2EoWO/71YLKcesrF6pTCYVY1lPidv2qoD89X70o32D28AJ6RuI/0cZpjQSv0lj69kXPygJrlJn6Da385x8R4e/TKFy7TK+xonjXlAfAigxUYvkPn71Fxll9VXU6SUqO0Vp26iqO95pOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3fPdvwQjaudddbhEMS/Qm4ajG9ibQ/VaB45+RWaAfqA=;
 b=VDOepq/RYacAH7hbSlBIjkTNZk4Am3cwYCqqHV5+mM+iMKlc+o7zDUNnVfKxIsY44SBjlR1NN/sIJUNFez/ox3CLfRCsAyjIqJ1c+Ub/rFkUhxmA4JA4sQg+nJfdwLViWG4YV6OIm42KlAjWCTeSpkOov9mjUOlv87TvQU1QKI+rwGQvL9Pow8GsalDgPRIcupqU3g4UUmPuMefTpWJI9Qd0dwl13bhFrN4MwQlqWPSDx7ZYQw6whC1CSktrzb0aGiwH+b6oUlNcXE9+1gjEMCh51UBzE3TuxDZozPPShmEkLldJF4CZPs6JzPNQ/2o98MP99AWF75cyIh9P6Qsrlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3fPdvwQjaudddbhEMS/Qm4ajG9ibQ/VaB45+RWaAfqA=;
 b=LotDSENJPq3oU+eScsRJufx3XeJcXEQTf18SSz8zAe1AJRohswMTQZwb4Rgt5BY3yxyd/GUrwp0diH9U25DbPgtgv0N798TG/fyNNq4TPbI7NoU/7Ii/SK7DWfQRt8hSQ2ELDchLkNWBnk7NdtvzUno+ucN/0+2r+IK5lASMPq4=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2416.namprd12.prod.outlook.com (2603:10b6:802:2f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 20:01:30 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Fri, 26 Mar 2021
 20:01:30 +0000
Cc:     brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, ak@linux.intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 03/13] x86: add a helper routine for the
 PVALIDATE instruction
To:     Borislav Petkov <bp@alien8.de>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-4-brijesh.singh@amd.com>
 <20210326143026.GB27507@zn.tnic>
 <9c9773d1-c494-2dfe-cd2a-95e3cfdfa09f@amd.com>
 <20210326192214.GK25229@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <17a1d149-5536-0fb7-e441-cdf9cf7fa78e@amd.com>
Date:   Fri, 26 Mar 2021 15:01:27 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <20210326192214.GK25229@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA9PR13CA0133.namprd13.prod.outlook.com
 (2603:10b6:806:27::18) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA9PR13CA0133.namprd13.prod.outlook.com (2603:10b6:806:27::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.16 via Frontend Transport; Fri, 26 Mar 2021 20:01:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4da2ab46-9f30-4494-bc9d-08d8f091f284
X-MS-TrafficTypeDiagnostic: SN1PR12MB2416:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2416BD7BADF0C3B9AE3712B5E5619@SN1PR12MB2416.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8rK7Gut0IKWRbmQdrkWMoAMYoldF8S2tnPCKryACxt6WmkWHRtlb84L931OhvozKmdMD5sLwlhpCxCem6EIBL9lgZNkp9BCpG7JTPX5UPNxkfxJJ9Xa/c/NFZgygCk2mhPgQ+bJ6IjfhYrK0WB1A3KbnEjMDKB0TK0sPGgUPzFWdK3/ruw727ARBIkFgJiKhUYkNUeamRKcslY7JhVRhc9KzjWqW/5eiV4Q6s6TVr9OyJ2nyx7QmR01LcpfnkbT2e3cRxAcr4PFqWOwKvzCjzky8OXPb/djYL7plOYsGpJlpgPcFlS1VeETPkMsvrmWlw9yBDJ6QLXC8gCAxkmf1fzKMVHYviCxWeGH9lYJYTiwg9AMaPd4oHkrHLX8GhUDz76g7owDOvp58rtp69E2RI+c6bNaij8aULCL82+4sNzuLVSkFXNraHXkgrhEcquG1DOLYyGENs6v4tzTxeaZpT4RJGUHPOgsINmxzveQD8RwXkU4yFFnmmIeRML++yWcfWVHyzpJZZ4YzCqNjOZJqv5561sQEDt5VAtoa3xYa2Vjpyle7IsW04AxeCRslPPHKu4ybhvTFq1V6C62MORtIdSMgpAipQKA6b8ny6NKrUdNUeO3u/KH8v5rjCIaXVnkrvLgem4PwZmbmqxHbcTYE2Zzf4mblTxsBzf1NGy60iVdvqffHInWuQUa7AbfaGopV219oNar4I6nGdHbY/Us+fp1yNCGIEYnSZFgvqUPnLBA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(478600001)(6512007)(956004)(8936002)(6486002)(2616005)(7416002)(54906003)(4326008)(5660300002)(31686004)(2906002)(38100700001)(8676002)(316002)(44832011)(6916009)(186003)(66556008)(26005)(36756003)(86362001)(31696002)(52116002)(83380400001)(6506007)(66476007)(53546011)(66946007)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QzVOWW1jVjBPdHRxZGpCbS9XQmk3cmlBMHFiUEFKb2U4Q2hUcWRqVGZJZURY?=
 =?utf-8?B?endZakovNFNOWHpPVXNrYkJ3UEg4RVQrUkFGT1NNckwydW0wRWsxem9iK2RG?=
 =?utf-8?B?VHlhcTkyK2JlVDdJd2Z0cHdMQkRXbG96enIwOE50NTBGeWw5VXVyOS9BVVBn?=
 =?utf-8?B?ZVE3YmFkRzlzNnYrREZCY3c3RHQ0dktsYUJOWjMyZldpSjNKNSs0TFhUa3Zy?=
 =?utf-8?B?UkFQTDNLQ280cmp4dUpSdmZkRVJoVzRwczlFdmpBOEtabHNpOW1yblFESFN2?=
 =?utf-8?B?bld3T00vL2kxWlRoVStwdDF1M0pYYXc0UEExdkkranZVeHhUKzVLSzNDSUx4?=
 =?utf-8?B?NkdtL3pUK0ZqYjd0SEQ4MXFVeFJyN0lSeDlTU3IrNHdmNloweWNZdFppS3gz?=
 =?utf-8?B?dXN6T0F5M3FCcndBSktSWXk2dkNMdC9qK0tpa1hvTkMyTE5wYjM1WGFQNmxE?=
 =?utf-8?B?cUtwY3ZVbWpKcGE3S2hSV01EdTJLd3I5ajZlYlNCT3lIbWh2ME9wYWxMeVdL?=
 =?utf-8?B?NklqajZ6Z3hwZ012Wmt1Nkx5TDdlRGJPaEsxOTh6b3o1Y1NtK0Zia2pOajVX?=
 =?utf-8?B?blhtS3BQeHIwZDhxUW1VMVZhaWVpL01DZG5za25ERzVLRGtxdlFwR2s1SjNx?=
 =?utf-8?B?RTNlMUF6RFkvWmYrQUR0U2RqU0QzY0lJb0RlWlBzaHU3aGhIVVVtNHQvNnlu?=
 =?utf-8?B?ekM3UEJVRXZrVGJhSUJGVUttSTdGNmFNOXgwSGFXN0tQdVUwdzVGb0lqaHZl?=
 =?utf-8?B?QnJBVkRiaklLQmp5czJhYnB0QkRCWTU2dnpXdXhoTU1mZHF3ZkJ3MVJtQ2ZY?=
 =?utf-8?B?OVA3V2FWWlBZYWNlaG1HZlNNRS9GNEptZVVhY2F4cjZ4ZUt0bjN6S2RmYURm?=
 =?utf-8?B?azcrNUpXVVBaSVJlZ25tYTVKa01EZWpSS1lEWHdBblBzcXVsU2tLRkVjeit6?=
 =?utf-8?B?Y2N4RFlFODVYclNHTjhDZVJMV3p0YllIRXNCRktqczMxeDQyc1liZ2hrdWZm?=
 =?utf-8?B?b3UrWlhFeThSeW1WY3Bud0xYSlBTZ3VrZ0pVVnlCSjd0VkpjZ3Jud0FlT2g2?=
 =?utf-8?B?STllbmNPbDQyNVhLdndpSGExVEl6VjcvVXJnR21DS280YTZ3SmFOaDRFOXdy?=
 =?utf-8?B?NG1EbUhVaVRXOE9UY0JTL25wMlU3SW56cXJjdlBKQy9LQ1NUM2VjdVRZWTN6?=
 =?utf-8?B?TFBjU0Z6b2JDUEVnSXhXS202QXdCSFRrbGV0dDVOeUFScGgyRXlXdGhRL0pN?=
 =?utf-8?B?VmtKMVY3eXpCcjBybWROWTRJaTdnVjczeE9ta2ZOQ2ZmcG5POFAwejhZVVdL?=
 =?utf-8?B?aGFwOGtxNzcwRDNiQ21YVDEwaFlhNjZTb2RNMHlDcjg2Zk5GQzBQbFExZ0ZS?=
 =?utf-8?B?Wk5PV1A1OUhzY08wMW9rekRJTERnZUczQjZ1eE5IZFNGQ3ZBamNPZnE4VjBl?=
 =?utf-8?B?c09VRmhTSjlMTW5tRk83Y3pLdnpwbEJnSEtMT1lmd1NERGNkenA1WG9NZDY4?=
 =?utf-8?B?MlFmZ1NtdDUyMjlHRDdiUnVkU3BaRzJPNnNOblFHWGJOSFpUajVFeG82V096?=
 =?utf-8?B?b0dJS04xOTVqaXpZRFdwRm54QndFbmVYaU9MSU0wdlV5SDNDdGZZQWFPQ3pE?=
 =?utf-8?B?RVBkVEtreldiMm9EcHc1V2NnelRUd09CTGVWZXhRWFV1NUl6eVRVRnBtbita?=
 =?utf-8?B?bUVYK0FtdXBiOG5Od3NHMUo2bmdJV1JRc1hWY1JDU0JNa0RHUHdqNkloeFkz?=
 =?utf-8?Q?Elo9vNcx44CJC0frchngwim49Ks3krsEsuRSUJL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4da2ab46-9f30-4494-bc9d-08d8f091f284
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 20:01:30.6672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EafeBVuVi0gueSIxoxlGKK5tjQPYLeTZG6mMOatj/OUTJyDsYCUhuZy1TQjsoamumbamPnUgTUHk4u3gvvEJyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2416
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/26/21 2:22 PM, Borislav Petkov wrote:
> On Fri, Mar 26, 2021 at 10:42:56AM -0500, Brijesh Singh wrote:
>> There is no strong reason for a separate sev-snp.h. I will add a
>> pre-patch to rename sev-es.h to sev.h and add SNP stuff to it.
> Thx.
>
>> I was trying to adhere to existing functions which uses a direct
>> instruction opcode.
> That's not really always the case:
>
> arch/x86/include/asm/special_insns.h
>
> The "__" prefixed things should mean lower abstraction level helpers and
> we drop the ball on those sometimes.
>
>> It's not duplicate error code. The EAX returns an actual error code. The
>> rFlags contains additional information. We want both the codes available
>> to the caller so that it can make a proper decision.
>>
>> e.g.
>>
>> 1. A callers validate an address 0x1000. The instruction validated it
>> and return success.
> Your function returns PVALIDATE_SUCCESS.
>
>> 2. Caller asked to validate the same address again. The instruction will
>> return success but since the address was validated before hence
>> rFlags.CF will be set to indicate that PVALIDATE instruction did not
>> made any change in the RMP table.
> Your function returns PVALIDATE_VALIDATED_ALREADY or so.
>
>> You are correct that currently I am using only carry flag. So far we
>> don't need other flags. What do you think about something like this:
>>
>> * Add a new user defined error code
>>
>>  #define PVALIDATE_FAIL_NOUPDATE        255 /* The error is returned if
>> rFlags.CF set */
> Or that.
>
>> * Remove the rFlags parameters from the __pvalidate()
> Yes, it seems unnecessary at the moment. And I/O function arguments are
> always yuck.
>
>> * Update the __pvalidate to check the rFlags.CF and if set then return
>> the new user-defined error code.
> Yap, you can convert all that to pvalidate() return values, methinks,
> and then make that function simpler for callers because they should
> not have to deal with rFLAGS - only return values to denote what the
> function did.


Ack. I will made the required changes in next version.

>
> Thx.
>
