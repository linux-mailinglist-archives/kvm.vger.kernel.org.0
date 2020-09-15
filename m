Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F45F26AEC2
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 22:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgIOUie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 16:38:34 -0400
Received: from mail-dm6nam12on2072.outbound.protection.outlook.com ([40.107.243.72]:31384
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727916AbgIOUh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 16:37:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YjNQnwotzlchT8zNZxigSClDXhnqRW1llUYWEExrDV92vi/LGGb1s9ziEVP/gtAK3Oj5qk7rtc60S3Dk8cdsci3avJy6vewmEDp73BQLKeTA+dxsWTDkbnt2+IPTFRILNJPkEDmWNIGwWObZV8+gjvW1L5rdZFkqx4k+ukzYLZIoR5vjZMxP+mujgzB8XmUH6Sojcbjio6LqUkEBfm/rUWf0BGJdwHlax8CrJ6JG3KqFGtBp5Ut2JKN909IBVao9VrrnXKsam94+1taYL8WDBOeAqFLdPoUl/CC4GWIxev/Z5oBT4bcYCdOhdWWlnyJREMjcqpvYx1BB0lLn7qxxdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssN8tz6VbdtX43N4iyuWtD8BcHM9A97bVtk9Q61hXzE=;
 b=oAVoSGiSxJ15NTJY32UVpNACX6QGIyC8Gmd8EWk+yMfqhUVj99oF9SOsubHEoO+LoCx2eo2MbUA8NtJwjhqVOTmFkmR1AmWrFqNcHwIzGWVHRFJ5RhapB14qj+L6+PCgbvhNyG4/zjwjaWMsSZEyzbZVFIMv1y+/9krLh3tsR/3AG7E2q8XqVBcngksVqGHGtAI+KeXfxWtc9X1m7A6fCBWUXoERE7thkqQj/iK4V4C9gFaMzcbTHAt6e1jhOzRCkp96N5jHD+iUB6QLx5wFF2ZOuUM7EQiPyXzQOSTzfR22RhM5vctjZfThdN7CYm5huFs1/J6szub9oG+lxGQcaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssN8tz6VbdtX43N4iyuWtD8BcHM9A97bVtk9Q61hXzE=;
 b=hgw+xBF3UjOZ/vfGyZuMkujHipjeCAZYynd3rJAVKDmK8VAls/ek7bPQY/Ufm7Vz4P+B8RekG0hRFyNQSBAE9KbQaIHKterIQSk8i0kJS0UX9kDb0w9QtV6xXZhD42er+DRgNEF3Iioe6fCwFvYDosHHOeLYGdYiHIFvZSq/UjU=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1542.namprd12.prod.outlook.com (2603:10b6:910:8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Tue, 15 Sep
 2020 20:37:23 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443%10]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 20:37:23 +0000
Subject: Re: [RFC PATCH 25/35] KVM: x86: Update __get_sregs() / __set_sregs()
 to support SEV-ES
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <e08f56496a52a3a974310fbe05bb19100fd6c1d8.1600114548.git.thomas.lendacky@amd.com>
 <20200914213708.GC7192@sjchrist-ice>
 <7fa6b074-6a62-3f8e-f047-c63851ebf7c9@amd.com>
 <20200915163342.GC8420@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <6486b1f3-35e2-bcb0-9860-1df56017c85f@amd.com>
Date:   Tue, 15 Sep 2020 15:37:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200915163342.GC8420@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0140.namprd07.prod.outlook.com
 (2603:10b6:3:13e::30) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM5PR07CA0140.namprd07.prod.outlook.com (2603:10b6:3:13e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Tue, 15 Sep 2020 20:37:22 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6992c2e1-b516-4b77-42bc-08d859b72668
X-MS-TrafficTypeDiagnostic: CY4PR12MB1542:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1542D869EB04F0858ED0FCA1EC200@CY4PR12MB1542.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KIvoTT/QqhqEl1+UQ3EnsUJaN9VQNoMRIwbwAfDqxJcnwJ3XQXc6Ahwm8Ns6/OV7dknRnbIQz+MwC3u9VD466nGk3WKG1xZ/6M4lwpRLzkZTyNz/mUFs0GblS0SjdfwnrWKwRhBiymtM/4vb+NGRzeZ0qbyaHs3Ao/XbvAjrji1qFGX8KA/N2WZNBx3Eq+xRYrrgDv+ozzN+yJ8rFyA16zCjAamKSGVtggsQXwDFFDX1s09SzWmUYiduLB2tNa9FtiuCljWum4FPMjtBcEDYVJrRvvruJm9FpAkiaMrEos9Fg15ygIE023V8Tg84nAkKePAoyfD8ML2oHyorhcYU92erkN6FIwuPBe7SXDNv7iISJKyhFL+2mrXqaVSyOJ8Tz5JZrhQeLusVkQmOi4Ejf8+RdHQH84u9GDCV0QDsZ/UdUv9XJdSm26MLflV+jfoN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(8936002)(6916009)(16526019)(83380400001)(54906003)(2906002)(26005)(186003)(956004)(36756003)(31686004)(7416002)(2616005)(52116002)(5660300002)(66946007)(478600001)(6486002)(316002)(53546011)(66556008)(15650500001)(16576012)(31696002)(86362001)(66476007)(4326008)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: G/U47ZXThqqSgL8RLNa7zLP0Vsx+Uon/ySO8vYqkCWZYdiiutRpa5wyZ2/xzCeRIyk0vxL+gMBTSftiJQXdBNZ2fxydaDiIoQLT8umMdhw3eVd/wk9xn8YkK573eKJZJcqnD2xtNs1pTJnruCHKv8H7rj+odujTPTyPJ4tl4eN+iDP7QKN97XyU3OY8sbJ4cwNTCh09W6ekj3j+SQPOSu5iZK7Dbv15kpIAF83NB7fYTUJ84WrcwHS1LLPzjBgN6G7zPY4bCWOxzHOO1FI03pIXhP2Nv+TfAFEhqRAoxHXCLsSktvwNbjN6TbzGQnoy0oxeaZ37VnQhCq61S4MjkCzCgsrGFlw1r5mEg/h4+OLN/wV43USn69oZxXIE8aEVAkZ291TVsZGUnhA6dUXBz9XyTAEg0H2Oh+yZazZk9Mv7kmiJ6Wf0wzZtKcbPk8bhgY8MPwPtSXT+VCSzl+NX5DfgeiZTBJnWrOd2W/3enBUtq+W5LXk10MqrDSjnPsC51XfOTq4O7D63ivaPy87QABq/t9b5wGmqPGBDbm7AX2LPwPe1ZOb6t3/rpkSXt/54Q9FrpTeLJCzEBImk1YMrwxdTiXdXo/pw3E6GTjxNuElUDj2tKsilVdrLbBmRbvt4Vqb6pPZYlxPgcqBGOYHw9HQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6992c2e1-b516-4b77-42bc-08d859b72668
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 20:37:23.3038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6JK/H4g5xdqvw1inLby+IjPitvpLCCIwOMs52zvX36euVtbxV4G2vDDCpX0/ZHp0UhxxmADVC6sM3PCxl6+DPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1542
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/20 11:33 AM, Sean Christopherson wrote:
> On Tue, Sep 15, 2020 at 09:19:46AM -0500, Tom Lendacky wrote:
>> On 9/14/20 4:37 PM, Sean Christopherson wrote:
>>> On Mon, Sep 14, 2020 at 03:15:39PM -0500, Tom Lendacky wrote:
>>>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>>>
>>>> Since many of the registers used by the SEV-ES are encrypted and cannot
>>>> be read or written, adjust the __get_sregs() / __set_sregs() to only get
>>>> or set the registers being tracked (efer, cr0, cr4 and cr8) once the VMSA
>>>> is encrypted.
>>>
>>> Is there an actual use case for writing said registers after the VMSA is
>>> encrypted?  Assuming there's a separate "debug mode" and live migration has
>>> special logic, can KVM simply reject the ioctl() if guest state is protected?
>>
>> Yeah, I originally had it that way but one of the folks looking at live
>> migration for SEV-ES thought it would be easier given the way Qemu does
>> things. But I think it's easy enough to batch the tracking registers into
>> the VMSA state that is being transferred during live migration. Let me
>> check that out and likely the SET ioctl() could just skip all the regs.
> 
> Hmm, that would be ideal.  How are the tracked registers validated when they're
> loaded at the destination?  It seems odd/dangerous that KVM would have full
> control over efer/cr0/cr4/cr8.  I.e. why is KVM even responsibile for migrating
> that information, e.g. as opposed to migrating an opaque blob that contains
> encrypted versions of those registers?
> 

KVM doesn't have control of them. They are part of the guest's encrypted
state and that is what the guest uses. KVM can't alter the value that the
guest is using for them once the VMSA is encrypted. However, KVM makes
some decisions based on the values it thinks it knows.  For example, early
on I remember the async PF support failing because the CR0 that KVM
thought the guest had didn't have the PE bit set, even though the guest
was in protected mode. So KVM didn't include the error code in the
exception it injected (is_protmode() was false) and things failed. Without
syncing these values after live migration, things also fail (probably for
the same reason). So the idea is to just keep KVM apprised of the values
that the guest has.

Thanks,
Tom
