Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A073340F1
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 15:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhCJO7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 09:59:11 -0500
Received: from mail-mw2nam10on2075.outbound.protection.outlook.com ([40.107.94.75]:56161
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229476AbhCJO6y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 09:58:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZPj4fRbCj2KEhsS0RP3XfNuDsnQKyNUvHDWq4UdqVxg9elEisz4gmxthCr5Y2gV1hvYDGp3OfVtDpRIwo+oMmn7rcX7+8Gw9f+6GNO5SntX1p6nn47yIF5jf8FUJUhNxQXH5Oj6izAXjtC5DbTPGv1JLnC8L+U5p4+Q7YsD1LNMrYZOExw69qNd12vW930M6/ajHnxu8w2dyRUNOsBjqIjiO8Bqa02z6nLUXq2EFp4Yc6YVJXkdjMQk5EqKqpk+gdeY9mms0Ct2uhA2oPxZzUoeWFOG1D/IpamBI74Cj/PmgjQEpo/bHSWffzvwlBPJtLmsTagnoOLWHzqWT4PnNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcBJ6juLvvBxf4ZFte0WQLTovjH9hsNRjo7qMj+nbuE=;
 b=fsuUpiZwerkIhI4H3Q8Rxy+tDJ9eACFKlSODXz1bTPkreIL70WOc9MZ7yLd21wlRRmSW9Z8sMgwfd1dWIoMoQ1a48KNcn6T+IaMPM1JG6cUGLaTZIXD7p3YY3wQzWbSH5Izrv/vU8a/OxnrB3miu6MW13lbbXrPg9t2hZMtui1ub4336qZm+vupx+1JK0TMKeYJebKwn1v0JN9kHtQVzJMf0NO/6JwofxwJgmvOD1v9uI6MoIdHx+qQGP3wgCdNhY0T5/EIwVDk8IxmtwihIJCXffAYd7EpiDTF57aiFAsxiugBIsC6cUuekW3xEEzTQNlABstVf5c4ZT8NzEoPH8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcBJ6juLvvBxf4ZFte0WQLTovjH9hsNRjo7qMj+nbuE=;
 b=r3mqIeIthYVweXMyHOMYmp1y39koWxhWN7pXcSjcBtKRVg80qrWPhd0lS0svCCh5nPPB8H76t/77y54T9GYxOJvL4LwAKr3I44ZEyVJYg1dBmCvWDs/2Fszh20/62RE5LlvoMpIYehdrqzrOhWX+ZI917lmn5YmYo65NSBG4x/s=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4480.namprd12.prod.outlook.com (2603:10b6:806:99::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.30; Wed, 10 Mar
 2021 14:58:52 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::20cf:9ae4:26fb:47b7]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::20cf:9ae4:26fb:47b7%7]) with mapi id 15.20.3912.030; Wed, 10 Mar 2021
 14:58:52 +0000
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
From:   Babu Moger <babu.moger@amd.com>
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
Message-ID: <7a7428f4-26b3-f704-d00b-16bcf399fd1b@amd.com>
Date:   Wed, 10 Mar 2021 08:58:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <3929a987-5d09-6a0c-5131-ff6ffe2ae425@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0064.prod.exchangelabs.com (2603:10b6:800::32) To
 SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SN2PR01CA0064.prod.exchangelabs.com (2603:10b6:800::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 14:58:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1b6b33fb-dc48-4009-4612-08d8e3d504ab
X-MS-TrafficTypeDiagnostic: SA0PR12MB4480:
X-Microsoft-Antispam-PRVS: <SA0PR12MB44807A8E42327D94C1552C4795919@SA0PR12MB4480.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:330;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k2nQ8oHM/Ls9r3i1+uHcDgAKZlaG+AK2FtM6xSXTi+irhs4DWfXNf+IrRN/7uGMla1RKB6rOdUF4g8qAREgcE858fZAOzDhzsuMyVEn3BfX1wA1LbwlzPrhe4/7qDYs8jKWx2/9hNaxh+Mew8sWVFWT+aVgo/LH/cOiJlcS3YL0hYlxK5oHQ3lnq85ACcLxuRjfpFjMqrthzC0MmSsXzLrOSycFKRHjMAlaszbJ+yJ5Q3/RV01sntnym3Vktmq5ja7mnQ2ISND5FbXB5+QGQTnVJfjqNSJriLp6pVRLimP0qB9USj8lTsQ7pZ2p5vilSX/iwd2lpZRQPwOaqRsXo9mnKRox+hT9IiZPXS23Q6bIIW2d0Y1gVKd6Uv60mrL9wu1euhrb+bePKSmrD3XFz5ch4HZqaexvAt/SXvYU8W/tm41Dx6CX81FUYmm/e1rMXkS6XK6ILDu2V4fpckVcmdcYC5JIiDdNfeTRR41583mw/SLGvVFvmrYlt2EPWdja2oW0LyTHqU23VJIfLCxDwh70cjykPtNXekh8uDAPwgc4Vyys0LfHgU3DLVZvJE3mzdWcKCsP7TcJsRtVPNYeDVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(36756003)(316002)(8936002)(16526019)(6486002)(478600001)(2906002)(53546011)(54906003)(2616005)(16576012)(86362001)(956004)(31696002)(186003)(110136005)(83380400001)(8676002)(44832011)(5660300002)(26005)(31686004)(52116002)(7416002)(66556008)(66476007)(66946007)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?SzlY+nq7OM1+8sEsrXYNmD1TLerGOhkuLoQ3OL4/mJFiwEG4z8BUJIrd?=
 =?Windows-1252?Q?5jEYUn6GK79+BFiauzYEowkIzXRN4kCMYNPhplJd59hv+E/pz1Rci8Yo?=
 =?Windows-1252?Q?gcQ4ACKXKPLQepscqxn8VP8+bFsgy5KdXRpdLI4aWMJckg/X8RABkUHy?=
 =?Windows-1252?Q?cpkvFpI1mRsfWkeVWKnKJEtO9FOrItHIJMkAJVsic4zkey2+NSiO6jKr?=
 =?Windows-1252?Q?+R6agv7CiSA/+Ouqz3lXEu3K9AgCnPiKllXLEdDwz+Sl9ZIj7mJGaDVo?=
 =?Windows-1252?Q?+B+aFzFHi413iKcWEGVKeEHRTyx4J4bAefET9HEYmU4mwrtFgXtmOWSg?=
 =?Windows-1252?Q?hujqQIlbHugnrq4HPBAIIAeAODSsk0TFhEaYtrHfXzY02dlcn8MSOdQX?=
 =?Windows-1252?Q?sCmL3B05AQNUmjJKMqMbtLKViwZhcrzBX2px+BAAMyezySFIKjNyTuIg?=
 =?Windows-1252?Q?gtQylrX881Pj8pfiGlLCdnQN2uudOTCI94Z6j8/hp9m6COUpsQGgzfYh?=
 =?Windows-1252?Q?V5cK+Y3EqPh0TwgvPIuY/YF4EBNrCjlFqkWjDC9KIxL5+TyDSJ2P/MSG?=
 =?Windows-1252?Q?xCgwc9oWiEslGYYVvunx12pxMXL0xjLsbPUgSffJbFbQufHwqyfILNqC?=
 =?Windows-1252?Q?S8/eArksfmsPcrDsKCndHk/zkuFmC1plepuI0Dnp5J/o4Npj+172lejy?=
 =?Windows-1252?Q?KiAFsTpObzlpDSOyf8iBZtAv3fL4O0GujXWhfSAGE/cB9W2xhiH5Nvrh?=
 =?Windows-1252?Q?0s6ky3XYSkrdj6Z2WF4ntehhgIPgdmapW+HaCgDxihO5IvYm7AlNsTuS?=
 =?Windows-1252?Q?NVx7KFC/ZYP7Oi1xghmciF/cwUYHXOYNr8hOtWOPgxz/ycQWBgMDHptu?=
 =?Windows-1252?Q?5zY78auX5X2e2MvU/RTnz9qh2Bs5ywbLQuiXg204josYSxFCPljWnL8O?=
 =?Windows-1252?Q?0AugGGil/ALwQ6zYu8QsYvK1rBhHEJfOcZqNAHSvvvTWRGiaVS9TSaQO?=
 =?Windows-1252?Q?7muBFnb+yjWnuoLh8zaa7Sh0dhBYTtLY3jkSDE3/m2fz0CJDuH7YiVEo?=
 =?Windows-1252?Q?m3hT6+lO+7C/U7WkX4jPE6oTTDchtZu09YZaeyqO/ejDRQDBTDnvbaYQ?=
 =?Windows-1252?Q?AtC8XIs7n6lTe+ZPeCvKGzgeZplfIMllaRh8y5JDZHJoiOj/u+92lqmI?=
 =?Windows-1252?Q?2BAIZBpIrgAL7RdPoWOiU3WJn46d7QSxlB/MTf+CbdLv8JA0hxOOBVwN?=
 =?Windows-1252?Q?Zs6jyM/PvGgOmBFnLAm+nnjVTLU5bk2NAC7GhVlkiceBUntuoDYmn6mZ?=
 =?Windows-1252?Q?YTwMlpEbCXjX/tM/i5l+NdNWGTKLftvI8nBADcKXDpVRYhDEvCzNoOHF?=
 =?Windows-1252?Q?3lsoH5AuDFivuB4csR0caAxXLS+bll7Jawxw1/enWmf9TrdOMbbM8znR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b6b33fb-dc48-4009-4612-08d8e3d504ab
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 14:58:51.9937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pben4aQu5c8WSDdPIr/5XUymEZyIRDrIjQzoQ/3OiOrEb++YYE23Uujd/RyuhGv/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4480
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/10/21 8:55 AM, Babu Moger wrote:
> 
> 
>> -----Original Message-----
>> From: Paolo Bonzini <pbonzini@redhat.com>
>> Sent: Wednesday, March 10, 2021 3:09 AM
>> To: Moger, Babu <Babu.Moger@amd.com>; Jim Mattson
>> <jmattson@google.com>
>> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>; Wanpeng Li
>> <wanpengli@tencent.com>; kvm list <kvm@vger.kernel.org>; Joerg Roedel
>> <joro@8bytes.org>; the arch/x86 maintainers <x86@kernel.org>; LKML <linux-
>> kernel@vger.kernel.org>; Ingo Molnar <mingo@redhat.com>; Borislav Petkov
>> <bp@alien8.de>; H . Peter Anvin <hpa@zytor.com>; Thomas Gleixner
>> <tglx@linutronix.de>; Makarand Sonare <makarandsonare@google.com>; Sean
>> Christopherson <seanjc@google.com>
>> Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
>>
>> On 10/03/21 02:04, Babu Moger wrote:
>>> Debian kernel 4.10(tag 4.10~rc6-1~exp1) also works fine. It appears
>>> the problem is on Debian 4.9 kernel. I am not sure how to run git
>>> bisect on Debian kernel. Tried anyway. It is pointing to
>>>
>>> 47811c66356d875e76a6ca637a9d384779a659bb is the first bad commit
>>> commit 47811c66356d875e76a6ca637a9d384779a659bb
>>> Author: Ben Hutchings<benh@debian.org>
>>> Date:   Mon Mar 8 01:17:32 2021 +0100
>>>
>>>      Prepare to release linux (4.9.258-1).
>>>
>>> It does not appear to be the right commit. I am out of ideas now.
>>> hanks
>>
>> Have you tried bisecting the upstream stable kernels (from 4.9.0 to 4.9.258)?

I couldn't reproduce the issue on any of the upstream versions. I have
tried v4.9, v4.8 and even on latest v5.11. No issues there. There is no
upstream version 4.9.258.

Jim mentioned Debian 10 which is based of kernel version 4.19 is also
fine. Issue appears to be only affecting  Debian 9(kernel v4.9.0-14).

