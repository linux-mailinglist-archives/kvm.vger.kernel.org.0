Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605E8372A15
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 14:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhEDMcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 08:32:24 -0400
Received: from mail-bn8nam11on2055.outbound.protection.outlook.com ([40.107.236.55]:59873
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230110AbhEDMcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 08:32:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dg3TjigmuCMKEJgwjXdlSIDkaxkjtXawTetjiEs+kNxuyzBC7Ev2sUXfoXCvONrd+vvJjzY3GDqAyF1AvjOVkKUBPy5BPpEAduEM3WDKSiJr7z4hj5rNMQIWfL1Y9CnIYCG4JTJJIOQKj5UpWtTFhNcdRE6ON8f1smW5zIE3dwrW4ASXIHSl56McTRgfuGWPrSKpqv+1bTTD9+SGr5yqIQxtwsX4nOlzEKsjDvx8XZI0IDdVL3VgWhzFY45/jqWYnPoB4ddokzcjnlbe6bZ4OtaUQXJjKbJxI+riPPVwVvEWEBVz0/NFExWP7HdUEzXFggE0BODyzU3DE2fSK8WSmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIlzGTav3GLhxBGcpxSPJ++agiMiWeTmtpK4OrY2QTs=;
 b=GJxWCr9ZuEVs5uDwTW8x4DWkGguTnwexAMrWoI85G0VUqvA4WQ4F7s83e2rQc0FOmwdF09Ip9Jtb9whOxeU0jrBKeHj+/3ZqxtCJtSttc8O7KApp0H0DWo+U7l9AsenhgvUn/ER04/pUrQcMJHGyoUZu82kDqbpjVT6sJJ+jsUKWrb0+MD+6TKUI1pcr+V447Gw9kK45VYOQUjB6GBakE3Yi28h1+s1pYAScJq61TdKbuDZyTW9a/hAQBg+eiULOra/4YG57p6Pwe+mHT2LKQ4HXhc7l3LbboHdB2x4UFJB5anb39jIACIQgpaij+V47A3OzgSD8gVF7idy2VeJyEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIlzGTav3GLhxBGcpxSPJ++agiMiWeTmtpK4OrY2QTs=;
 b=2rXXHr+HMSqxCKBpdhl1yjl3eccIKHMM+gudGZarfk+8/ag6qNrJSWiyNlhxj0/ft6ziSW9JW/vjc0SeHW9d+AtVVAY3BvEGnMhKSlzAMk9dOYL1MmYUdv5eDjvMWY8ZHNwZy5r9hgyLREjw95ho5XKLWCBOig1mgeFV5efV/Jw=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.40; Tue, 4 May
 2021 12:31:25 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4108.025; Tue, 4 May 2021
 12:31:24 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        Thomas.Lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part2 RFC v2 10/37] x86/fault: Add support to handle the
 RMP fault for kernel address
To:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@amacapital.net>
References: <9e3e4331-2933-7ae6-31d9-5fb73fce4353@amd.com>
 <40C2457E-C2A3-4DF7-BD16-829D927CC17C@amacapital.net>
 <1c98a55a-d4d5-866e-dcad-81caa09a495d@amd.com>
 <b723e0dd-7af1-37b3-6553-e9ef4802dac8@intel.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <af581395-1322-a668-d5f3-3784bbfd6c9b@amd.com>
Date:   Tue, 4 May 2021 07:31:20 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <b723e0dd-7af1-37b3-6553-e9ef4802dac8@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [165.204.77.11]
X-ClientProxiedBy: SN6PR16CA0061.namprd16.prod.outlook.com
 (2603:10b6:805:ca::38) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by SN6PR16CA0061.namprd16.prod.outlook.com (2603:10b6:805:ca::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Tue, 4 May 2021 12:31:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 905c1a92-cf78-4c2e-7a2f-08d90ef887ee
X-MS-TrafficTypeDiagnostic: SA0PR12MB4432:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB443216595FE2252214643091E55A9@SA0PR12MB4432.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H0pwyNrSt56aamj7ZllAzz/eBLWtPsKedrpLUc6//lKN8O7awnhmieTefnpYSzFokXt6kLiNeqJzjQi0djecFH6yToLadKpxkob/eYJdU6viNn1pJrOV6Hpx8YZLCOJTofk/JKy5Ysv21MeQihZHrbIaAV+NsrYSIj4YS8IRA08VJyO5HwHgj3ntlhwNFdL7Nr/VwK5r5Yd0d4oN2gN96aphX0dzAKqwy1XktkZcY/yqlze7HI7ZHnbZsjSTb/zMFX5l5R/QkdGBpGUzD0mG1l9ARZhtRgELsYumVt2cVKw0MeZ//G1gbXrptqeBvIjtR2zCpE2a87wTlWevA2B0MjPwR/zfV1lQu9MqwgZTkNyyoodxl0QrE9hA6O9SjpWJQaOugkIHFOACkZpyfQ3YVRw0jfGuYAnJnSt7JUDsQJIbs+Pzhn8PM/CF3LlZhnRpTdtn40i3JXIf5LyuyVPxd5htyNKPnsh+7UJJ1EX+bQB8xNsTHg/MIL784NKDUolydT2GCKdb0DLBRM0tthoKAejGv3v5h0CM9lARzt3lM7B7E36PIFkvYIr+A090/+Fwt5+maPNOqp9f+TFN3w6b8a6KlO7MTkx6lfL5L5WWLGK8h+j/XrQmN2kjZjI5kDuGXY6auxypMadFBYinX0ER0z8TnI/+WsMOsKvCrkN2+9vETLx7Rpoc5KsbuV/khdxNd00Kp0485AY9xZmROZdIrrJo/GNy4YDi6XHUDEVK86M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(39860400002)(136003)(376002)(316002)(53546011)(86362001)(2906002)(4326008)(110136005)(6506007)(44832011)(36756003)(7416002)(52116002)(8936002)(956004)(6512007)(31696002)(186003)(478600001)(16526019)(38100700002)(26005)(38350700002)(31686004)(83380400001)(8676002)(66476007)(2616005)(66556008)(66946007)(6486002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ald0Ykdyck1xY014TkI4SThUSjFGZ3NCTnhtbCtFbkxoQkVQelNURndxQjhP?=
 =?utf-8?B?K1lkMmdHckt2ZlFmTU9Sa3BGNXJKbnh5eUdCb0IyUC95OXcwRkNDRkwvTjV2?=
 =?utf-8?B?Y1pNNnM2ZUtRT1hpdmZtQTBnY2p0QWVjR2VkcG5zUzdwYU0ySktTMkNUT2pS?=
 =?utf-8?B?LzArdTJ1UTRmZHo0QjMzVGdIbW40SUhyc2d0ZC81L3FZRCs4Rmdid2ZiVHk3?=
 =?utf-8?B?dlBMbS94dGcrUDBnOXVOamYxZ01VS2REbnB5YkptRTlHOHJFRExOWllGWFVT?=
 =?utf-8?B?UWZyTERoRy9NcTV0MUdyOHY5SnVRam9pYzhTdERJQ0tOMjZ3eFdqQWpvWEJm?=
 =?utf-8?B?encyZzRwUVhxZEZFL2MvOXNrcjM0bEJPUmdvSjJHSE5DZEZUN1Nrd1hZeGhQ?=
 =?utf-8?B?NzNmWXlDV1d0SlBUTFNWd0hnOEdSVTZrK0lzbVdERE1nbzhLS3Zockd1bzBF?=
 =?utf-8?B?OWkvRm1oTkpmNVV5YXEyYjdKaDV3c2Rpb2tlcVBNUHgrcm1GM1FHRTJxMlV5?=
 =?utf-8?B?UHB4VXpkeFoxbDJ3WmVvcDJTcUpIb0hMdy9uYTMvcFJIRFlxM0ZjdjZ3TS9S?=
 =?utf-8?B?bTg2NVJsdVBzRlEzRkNJcVFJSS93bnd1eUVvcENxeEJyYThIYUhOdUdyNnFv?=
 =?utf-8?B?MVZqd2dGR0NXMUdUcEdETVJSTzh4ZnlZbXd1U2pOSU14ZDBKVkZwZWNOcjlM?=
 =?utf-8?B?Vkg3dEZJU3JXN1U5TFRqbjByaHJQeXd2dU1ib0JMSnhJSjZvNHdjQ3JsY3hJ?=
 =?utf-8?B?dDNFallHTVNrc3BCN0R2dzZzWlR5U3luZ3IvYW9TNmo0Ti9GUEdBQUF6dkly?=
 =?utf-8?B?N04rdHRPODRqbzU1WDFxOFd3WStpbjBqajYxcWppVytoRnNyRWRWbERwczA5?=
 =?utf-8?B?aTNNeXBTTXVqMnZJUXJRWlZEUThRRUFZQUxwM0xtandrMVc5bXRxdXZiSTc0?=
 =?utf-8?B?VXVjWjF1N09KQlJvRjIwMkYwTUw4MlVGL2poOVNqUEM0TUgvaWlEeERJRE56?=
 =?utf-8?B?bEd1Mlh0akdpM25RMWZGaTFQblZzMWZ0TGoyblY3YzUrQlNreHRWcUNFdkJF?=
 =?utf-8?B?WlBCRWNoSVNsZ1NlZnFHZk9rMEViSHdObDdPV1phTzIrMTh2QTR0UWMrTXY3?=
 =?utf-8?B?TDl1WnJUU3NkSmFFVlpxc3JaTDBlOVFiWDRLVjlQKzlLNmdpbjAvSU1neUNs?=
 =?utf-8?B?cDNQbFpxNEdSWWFzNkp2R1hUKzl1M3RUb0RmVVZXK2NmdUZ1cXl0Y1Y4UGJW?=
 =?utf-8?B?NXpTMy82NmJiQjZIeXpEMDliQmJnK202R3BHbkdGTE53bEc5N3kwT1ZXdmNK?=
 =?utf-8?B?RHhuRDExdWtuaWRFMkV4SnEzNHQrOTg5SGR5czNCNm1yQjBCd1hXL0luOXJy?=
 =?utf-8?B?SDk1S0pNdmlsVjhEQit3U1FKWmN6QlI2eWVBbHM5dVdFZ2FjZXlIeS90bExG?=
 =?utf-8?B?N3ZjSGxWcDBGekFXMndEaTZtdlNLK3V4cktaeno5VmJlcUprczhCb2Z0cFZX?=
 =?utf-8?B?aGRNV2ZaNTZwYnN6MFBBbTF0NVI4ZVRYS1BZRXkyWUd4WTN2SmEzQkROaEFM?=
 =?utf-8?B?VEN0b2JLUzlKMmJrb3ljbXAyeHk5QThDUElNekNTTzZqcnY1UXRTVENKTEpO?=
 =?utf-8?B?bU56Tmtqb2ZLNDR5NE4ycnJSZ0FwY0QwNDRlQTJxeW1JOWxjdmhaNm52RjNh?=
 =?utf-8?B?aFdaMkpEZVpRS2FnZnIxMEZKTm1BK2VpMENRcWFIeXowT0NOd05uN3A1RVNn?=
 =?utf-8?Q?EBlCIlB1SgDewPiKkQYNRVMxC7jWMh5t7JtkTj+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 905c1a92-cf78-4c2e-7a2f-08d90ef887ee
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 12:31:24.7615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QafFp8LljS3X4cCwOYG932izm4EY4JzNhJfSdCcsX/nc+5kA8JWM7O2f/7fGjfgvShOpsZzqu1OhGFeLWSHNWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/3/21 2:43 PM, Dave Hansen wrote:
> On 5/3/21 12:41 PM, Brijesh Singh wrote:
>> Sure, I will look into all the drivers which do a walk plus kmap to make
>> sure that they fail instead of going into the fault path. Should I drop
>> this patch or keep it just in the case we miss something?
> I think you should drop it, and just ensure that the existing page fault
> oops code can produce a coherent, descriptive error message about what
> went wrong.

A malicious guest could still trick the host into accessing a guest
private page unless we make sure that host kernel *never* does kmap() on
GPA. The example I was thinking is:

1. Guest provides a GPA to host.

2. Host queries the RMP table and finds that GPA is shared and allows
the kmap() to happen.

3. Guest later changes the page to private.

4. Host write to mapped address will trigger a page-fault.

KVM provides kvm_map_gfn(), kvm_vcpu_map() to map a GPA; these APIs will
no longer be safe to be used. In addition, some shared pages are
registered once by the guest and KVM updates the contents of the page on
vcpu enter (e.g, CPU steal time).

IMHO, we should add the RMP table check before kmap'ing GPA but still
keep this patch to mitigate the cases where a malicious guest changes
the page state after the kmap().

-Brijesh


