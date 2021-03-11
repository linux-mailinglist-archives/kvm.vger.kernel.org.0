Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FC1336993
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 02:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhCKBVr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 20:21:47 -0500
Received: from mail-bn7nam10on2048.outbound.protection.outlook.com ([40.107.92.48]:13814
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229520AbhCKBV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 20:21:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hmsVVOJEsws588K6D2TMgUB1tVQDl/2aFWze5EJfkpml9bTo7rztY189jE7Pa/X/WYS1KbsdGmc9VksGL8gAiZ51UrcA5SLhI+rK81haQ594Gy/rL5R9lrtO+DiOZi8RfwQhEuEAGf1SgRXWrtxCAoTxqIsyXSPsgPZByb2bha8b+7iwUSgqdsIJQtYpc86/cgUIZmV3baS68bp4bA0tqJNElb9tj4gCRYR8JQr0t0aPhWbDv/OZ/fuiZeEMuBnX2Nh0bsoBcbJoO430IDPh+mdVfWRuKVt8jeizMApuqzuBsEgdhYy8n+n+34m3tCZJDvn9BjCiJrSZ34zoZDszEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u3PapiBDQkIUy6BMdze68B8yG4EMmkdlJty9PEDMkSA=;
 b=c6L+FNWzgYM+tBHvmoK23gWIr2n/NKvLMUhZ3xXVdZQjh5gHw7VSuVV+af+RwO6rliAbFByBNGMrl/rF5gLq6iAgDbt5kkuhnAuwPaxKlwQWaBJXCqZlFlGb1n2v8gWA5RoMZqD4bLDqc1fCIgSxcRTfvbU+jkjkcsLVXctx2Gpsdpb4BdQuSy3CgDfMXXXX+nVFrYrqVKucSMFU+jsF9Mq+OQQBBqP9jrOXKGrvWK7FHJdbKH/6yWJlbOIJesyrDye8+d+1YYAAI9eYakNEhUe6mFkjm/jloJlcSMDyg+zYlEzBpJTfHOn7a9r9XrKfG4O8rGjtvRiNdcZI/jsUsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u3PapiBDQkIUy6BMdze68B8yG4EMmkdlJty9PEDMkSA=;
 b=qBiHjkY7Kq5mMKksIOCsDLTAftyXmlxI2vDRpRXg9ekrJt96FFhqtXtIpKCrjH13pBLdcL702ffHc6CDCxXZlbuHeHcYOtS1rV536fSZhOP7DPDAYR4vxhlp6CdVgDsbZUKopaGmR/9QmNyMgqlrlh2LhMgT3OCj4J7L0hCeUe8=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4558.namprd12.prod.outlook.com (2603:10b6:806:72::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 01:21:25 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::20cf:9ae4:26fb:47b7]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::20cf:9ae4:26fb:47b7%7]) with mapi id 15.20.3912.030; Thu, 11 Mar 2021
 01:21:25 +0000
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
 <83a96ca9-0810-6c07-2e45-5aa2da9b1ab0@redhat.com>
 <5df9b517-448f-d631-2222-6e78d6395ed9@amd.com>
 <CALMp9eRDSW66+XvbHVF4ohL7XhThoPoT0BrB0TcS0cgk=dkcBg@mail.gmail.com>
 <bb2315e3-1c24-c5ae-3947-27c5169a9d47@amd.com>
 <CALMp9eQBY50kZT6WdM-D2gmUgDZmCYTn+kxcxk8EQTg=SygLKA@mail.gmail.com>
 <21ee28c6-f693-e7c0-6d83-92daa9a46880@amd.com>
 <01cf2fd7-626e-c084-5a6a-1a53d111d9fa@amd.com>
 <84f42bad-9fb0-8a76-7f9b-580898b634b9@amd.com>
 <032386c6-4b4c-2d3f-0f6a-3d6350363b3c@amd.com>
 <CALMp9eTTBcdADUYizO-ADXUfkydVGqRm0CSQUO92UHNnfQ-qFw@mail.gmail.com>
 <0ebda5c6-097e-20bb-d695-f444761fbb79@amd.com>
 <0d8f6573-f7f6-d355-966a-9086a00ef56c@amd.com>
 <1451b13e-c67f-8948-64ff-5c01cfb47ea7@redhat.com>
 <3929a987-5d09-6a0c-5131-ff6ffe2ae425@amd.com>
 <7a7428f4-26b3-f704-d00b-16bcf399fd1b@amd.com>
 <78cc2dc7-a2ee-35ac-dd47-8f3f8b62f261@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <d7c6211b-05d3-ec3f-111a-f69f09201681@amd.com>
Date:   Wed, 10 Mar 2021 19:21:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <78cc2dc7-a2ee-35ac-dd47-8f3f8b62f261@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0701CA0009.namprd07.prod.outlook.com
 (2603:10b6:803:28::19) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SN4PR0701CA0009.namprd07.prod.outlook.com (2603:10b6:803:28::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 01:21:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8cbb8422-3500-4348-ee76-08d8e42bfcaa
X-MS-TrafficTypeDiagnostic: SA0PR12MB4558:
X-Microsoft-Antispam-PRVS: <SA0PR12MB455826C0B5E1D01B3A095B0595909@SA0PR12MB4558.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:663;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n/bahEGl0oX4shVO2raGnqWr0DWlY8s9hlVwer0/oCHoXB6+NMlRQfYlhRGxQ2xZf+ti59DfnFILMywzcgLYDDuKHIw9zdkxlhYUpmndF13XP3Z5EROZsVYhqklRmi/RYuKA9UhlzBzY6dciFd8sQOVoT20QQRyT1AdKUGaxnd8xNyWTeLvsYmp9C6VNmvkONtLNj+Ued84mL1qgS5nPsmib6xNf1umg44/RofVArvq3N3Y5PPXZtpXh6KQuyGIHtJcS0rMICvamD7eWIZsQ3l7cYxO5fZ5WHaTNtK4Kj9Zg4L8CQDI8hTtmmjplhefDdqBkTvXLLYexObjeCAP4W+3q4XuPBZR0tZL8F6SSuKEegk6R5r18P5GP3CFvyMFtUWeJHFUNuefQY3AudF0UeBE3E3WMzr0AIvbArNtcSWcspUko6C09UYDtnL8bzTFLquFPUiW5ag2t354cjcXdqpE7UFCGxb0VLpwedXJM6orx4cPayOxCYN4JQzMmAeNxXubEeZkGcVpv5r7n58+dMEe5U9MBpEKi3AODLXABQbaoQTWLuwgaY4OI7vY4TKK47LKWKynY9bydzvYq3yNK4/bIsVyyLzG9fFPkDUU3S5vYsbZzNuz8yM4Ra0Hn26vP06PhK7o2ZfOJDPd1v03s8iCWiSTq4Vab5Ef9SDmTVdwiRIT2zd4dhngf/kPpLGHI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(366004)(376002)(136003)(53546011)(31696002)(6486002)(66556008)(8936002)(2616005)(966005)(4326008)(8676002)(110136005)(16576012)(316002)(45080400002)(478600001)(5660300002)(186003)(86362001)(26005)(66476007)(956004)(7416002)(66946007)(44832011)(52116002)(54906003)(2906002)(16526019)(83380400001)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?rUEsfwihYNjPGmHXqcvMiiT1/Y+1fZ/crosmIuPBpAT4MVQ+NFNFhHxQ?=
 =?Windows-1252?Q?Wgn90QASF6O6aFm0LxTobhN99GWtWSB1S52gzZfZkNupJNmcGxMGp/eu?=
 =?Windows-1252?Q?55UwHwKX7wK6HPcdtGZjmIeAwsvnRCEeh7QasE1H15Ec6XONHyzQw+Bt?=
 =?Windows-1252?Q?ooqR2sr97miLabO9DAssw2N53BmqOhLLqyUFCGDPZTOmCXiFTzE91G6Y?=
 =?Windows-1252?Q?ZN9wYbdsHDPW41RLBiiqfUjP4X6ANjVURhRtNwS0Mq09q2lVEWqXcuJt?=
 =?Windows-1252?Q?9PcUYd2OOpH2mj7h0KmgMGgFSy+i1C2nR7mSH+mCZjLrc7PZc400mH1u?=
 =?Windows-1252?Q?8fkv/TNry0488Iq4eVUK19T8vgK3SiVJ2fggDpd7nF76Hw+C4p6a2phm?=
 =?Windows-1252?Q?mVPrtoeBrGfeSx0mIjb2SEaxSu2lwZS8rmfD1Cled54oGi6ColUIrZyX?=
 =?Windows-1252?Q?laZbV3WFwVHGhKOE6Z3ykQj/oY93Fd9FtgKF2MpjeqHY1YgBfy7yIBo5?=
 =?Windows-1252?Q?dD3ktlvaVbaREJuWEdZiRXwc4o+8q34vi/rD5gGsO5dRxZDDOqIufBJZ?=
 =?Windows-1252?Q?f8HqhCnivtNCTEBxeRAkjkXIWimqYD7WPhMLWlTxTVC0KpbPoifrky1e?=
 =?Windows-1252?Q?B1T+e/LxR5RV+KvmsX+vFILd0IwtiP2bRgneOrCILVqVe0dYhxK+goaE?=
 =?Windows-1252?Q?icC9MzWBy9rVfYZGFsscFG6fRO8kXMiY01jTy5H48lr6t96TQ1mMeN8I?=
 =?Windows-1252?Q?ALrJuNqrc5pZdN+7j5li42xGXpIra+WI/6M28ctEkCVLRkV3CpMZaBfA?=
 =?Windows-1252?Q?5/WGomZWPGtnKVpn5M+LgETYf+nmfyTUTyYTZ2a7OVzynjPTx1mrZvHx?=
 =?Windows-1252?Q?TRlwkfiqfe6SC0j5RW01Izfot8y10PkhhCbZRtlz4Gxk2NfkN5EOqEEc?=
 =?Windows-1252?Q?z7GZUCvakO9EM/0aw6EM3QW9ZkFsDWSIioPx2XfLboFfpZgzxkxh+uyt?=
 =?Windows-1252?Q?6jjPL6CXVG09zEUHI0q16m/y9YD4h/PInAmubGR8kEL/2W/Zu4dE1RwM?=
 =?Windows-1252?Q?el1G+GEnKJ64fPN44tkFXVOk6YL04BiS+76WA3Qo0CdZdDLIaW9ycrqP?=
 =?Windows-1252?Q?kAP7aoqh0BOBWFuWsHGjSlu4TcJesen23bbk5/eeNJFgs+ef2+t5pQ6W?=
 =?Windows-1252?Q?fIDPwMDgAio/i0hxIEE4gbHozyqa/naqp0EXupoi+Bc8Jl0pizu8Vy3e?=
 =?Windows-1252?Q?EBJQogJryD0BFWu3AU/E2ZwN6dtP+T4SXDlYcqnKClhJfn35HBV0Tbtl?=
 =?Windows-1252?Q?TtMh2AfcOBfI1CB7gmBIUtxhWNLEuXmGmEVqrQs0Dpa3I4/l3OVKAZVm?=
 =?Windows-1252?Q?6v6yiQeaniZ35bgrUd4CUeNH/iXCSZ5MtKqQCVE9CvqZm7fZ+A1jmuXI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cbb8422-3500-4348-ee76-08d8e42bfcaa
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 01:21:25.1659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uWl17QpklAMavzo4nBpFxeRrsj/Bf9J+77L7lJWL9i7cwgy3PRmBVw2mMYlOKrCo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4558
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/10/21 9:31 AM, Paolo Bonzini wrote:
> On 10/03/21 15:58, Babu Moger wrote:
>> There is no upstream version 4.9.258.
> 
> Sure there is, check out
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fcdn.kernel.org%2Fpub%2Flinux%2Fkernel%2Fv4.x%2F&amp;data=04%7C01%7Cbabu.moger%40amd.com%7Caeefc58416ed490faa7f08d8e3d99d72%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637509871127634618%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=re2Jj5P7IjN2UdmPTjTuKd1KIJLek84KlcnsXxgKYRc%3D&amp;reserved=0
> 
> 
> The easiest way to do it is to bisect on the linux-4.9.y branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git.
> 
Paolo, Thanks for pointing that out. Bisected linux-4.9.y branch.
It is pointing at

# git bisect good
59094faf3f618b2d2b2a45acb916437d611cede6 is the first bad commit
commit 59094faf3f618b2d2b2a45acb916437d611cede6
Author: Borislav Petkov <bp@suse.de>
Date:   Mon Dec 25 13:57:16 2017 +0100

    x86/kaiser: Move feature detection up


    ... before the first use of kaiser_enabled as otherwise funky
    things happen:

      about to get started...
      (XEN) d0v0 Unhandled page fault fault/trap [#14, ec=0000]
      (XEN) Pagetable walk from ffff88022a449090:
      (XEN)  L4[0x110] = 0000000229e0e067 0000000000001e0e
      (XEN)  L3[0x008] = 0000000000000000 ffffffffffffffff
      (XEN) domain_crash_sync called from entry.S: fault at ffff82d08033fd08
      entry.o#create_bounce_frame+0x135/0x14d
      (XEN) Domain 0 (vcpu#0) crashed on cpu#0:
      (XEN) ----[ Xen-4.9.1_02-3.21  x86_64  debug=n   Not tainted ]----
      (XEN) CPU:    0
      (XEN) RIP:    e033:[<ffffffff81007460>]
      (XEN) RFLAGS: 0000000000000286   EM: 1   CONTEXT: pv guest (d0v0)

    Signed-off-by: Borislav Petkov <bp@suse.de>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

:040000 040000 e56bbc975c3fd1a774b6cc0d6699c0c24e66be1c
e06231dccc8589b4baa0cd5759a37899b7ec71c1 M    arch

Not sure what is going on with this commit. Still looking.
