Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12CF26C9C5
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 21:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgIPTXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 15:23:19 -0400
Received: from mail-bn8nam11on2056.outbound.protection.outlook.com ([40.107.236.56]:10942
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727384AbgIPTWo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 15:22:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZFSTJcrUaEDi+Lgw2NFFdDAd8+xBoXsT8ubfPcaOdnQ8bsu3VbGbncOFn8R7x5f2Z+As9kexHkCgR6VPT7xdRjkWKYNPXvphOzw+4pGf+ykUAB3WwXoqEbhN1MOjFn3f7rKuuCLuZFtQpJ/FmhPW0Gy7H4XIYunpI6zcugAKeK4vQ4eFORCod+YZIZlrvRWBfecbSkGDPX4O3o38OXRQ1EcTxgZEOhFH9Av59uhSyRt74ye+FtBK8h/KAZTjfcrsDGJzKbbxeBePk1ixlCJAx4ZJcHdUG5xFMZgooKRicDWQ8x6Qm1T/ADR7IjR05cEDW0boLDfx1CgKEh936LcZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zEZni2IPxBY7jDkdqDKG0TpFH4qJYhwowLrM+ncNqKM=;
 b=g+PFjS4zViVMWGU8d+XjUouksUWiKLKK9stauq82twaZYxv1b9EkTnJXuGLYUbTZcKwwA9jiJQ+76FxPb54YUPWDnv78umYbMxWRGPFHv0DG8ClyK0D4pOy/a4WOZP7gdYk1X+Dp02YXOElsub6oRNOrXPxAdAk6dgU+aaWEk4nfbdkcTRUGxBfReXKbMOy4SnOE8cFLa2YvSo6pDOkyL7z38VvJnfXQrYW2h6Ff8neZQYV5ePcaW8LtFqXeG/kgaBRWBT8H7JYnubrqOXp3Rp2xJjn+Uj+WoVOILDkjJHHWqg7pSMfoVmMz0LS5w5Vr0hysF8CRl6aOStkraR+nLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zEZni2IPxBY7jDkdqDKG0TpFH4qJYhwowLrM+ncNqKM=;
 b=3YcYb8cMuSB12pQgo6Tx9yPu3LViVh5xWcq/txKiLwtcKdU5dV7xzpDpNCqnYyyu6thJe6aF3I9NhN+P8/OQua57Gp0C0aZ429AY2elgfuVhQ1scQE3YZ1cv9Y9CxmO3MYh/CDU2vurEiyjKY4ggpk+c3bqM5ISOetTR2k7lJcc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1494.namprd12.prod.outlook.com (2603:10b6:910:f::22)
 by CY4PR12MB1925.namprd12.prod.outlook.com (2603:10b6:903:120::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Wed, 16 Sep
 2020 19:22:40 +0000
Received: from CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::9067:e60d:5698:51d8]) by CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::9067:e60d:5698:51d8%12]) with mapi id 15.20.3391.011; Wed, 16 Sep
 2020 19:22:40 +0000
Date:   Wed, 16 Sep 2020 14:22:36 -0500
From:   Wei Huang <wei.huang2@amd.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, Wei Huang <whuang2@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/2] KVM: x86: allow for more CPUID entries
Message-ID: <20200916192236.GA623906@weilap>
References: <20200915154306.724953-1-vkuznets@redhat.com>
 <20200915165131.GC2922@work-vm>
 <20200916034905.GA508748@weilap>
 <20200916083351.GA2833@work-vm>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916083351.GA2833@work-vm>
X-ClientProxiedBy: BL0PR01CA0024.prod.exchangelabs.com (2603:10b6:208:71::37)
 To CY4PR12MB1494.namprd12.prod.outlook.com (2603:10b6:910:f::22)
Importance: high
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (24.55.15.93) by BL0PR01CA0024.prod.exchangelabs.com (2603:10b6:208:71::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Wed, 16 Sep 2020 19:22:39 +0000
X-Priority: 1 (Highest)
X-MSMail-Priority: High
X-Originating-IP: [24.55.15.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c142b2e8-9e00-4aaf-c49c-08d85a75e0b6
X-MS-TrafficTypeDiagnostic: CY4PR12MB1925:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1925CDB14B82D5D6A30DEBABCF210@CY4PR12MB1925.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AFMQVTw7SyB8KcaAxGwWyGyxKoOdKmWzpwOSOErGqQUdQBB+AYxJLNIqaMt58RLUctVC+96fionxmKlkp3HGgSLb+edvnF+907LRLWueA1crt5SpD/11TRxC/86xIaUuQzYD3JbDRgMj0n0KXAx+QfI01e1IvfEUsBQxX5AuR96t3Cx9HYVvG+F4H3J8Ku6PQD7tNuGYQh0xXcvTXb1orcPz3VNiRAESIcDRlx7D2ez9Q+FCp9QXBcbp5ieE0WnSW7bk2YENZAZS/IxurWQKlTwwbs/HYqTijJl2LOyKJ8eqxAs0xEbWoAwbGkVbq7JioXx8IoTj4GtqKjk+cgYd/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1494.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(396003)(366004)(346002)(376002)(39860400002)(16526019)(5660300002)(6496006)(2906002)(8936002)(186003)(83380400001)(33656002)(66476007)(8676002)(86362001)(54906003)(6916009)(6666004)(66556008)(66946007)(52116002)(316002)(33716001)(4326008)(478600001)(956004)(26005)(9686003)(6486002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GSik7Z01MMOA4QkghMVs7B0L0bS43du6Lk/TIQsPX7TjI5oX1l/6++/PCDVjUvYgbuoKsPSDuMobxelxWCQQqasUv8sLjFNa/LV+iNtxPY5VA/GcbH92UEOfeJlfNISr/sCa2vju2KGZZQHipvPU8V7VYjVA9vHGhFFkP6YPSTxiUwaeGm6Mk+7sM/RO33p7woqRLNjwBJBD6fhyjGgX3gk27nBs4lCMiX+XHwowo5ii8n3QC4dcHcaS3krd7SKkiUbukgmFR4OiGMrhnDmt9FewX3xUh0A2V/OGTsKKOl1DUlqreMsM85IYbW3mBQ1TajyMlB00zgtUTlGQmQ9iFMHOYiKTEZfLYLkH18n13VsBM9zr9JzrvPeWBiKV9kn1JQWB2Ahdej3fPE01gYQ/U7d+MGmLWzWj8+VQT7kA80U8IutG8PcLuLyO4lLwspXz/QEGuaHeSWGsE+KjXGycZCm7Ln7uwq3aLD1HdPq2VYVsRCkVJpjpormeHSExZZomUskJTCjn8J4tOBB4sFezPH6hKj3G9hxaY/aZTW4kO8YAWt7grsbg7s6LO9AbGlaWhdo+jeSjot9jLURklrBmbcQvVFT7zSqV5Gx1nrqejOf+mLMZVTsX5cPLHVzAx9RtVupRRt8Hko5Cl6hF4kPuYQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c142b2e8-9e00-4aaf-c49c-08d85a75e0b6
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1494.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 19:22:40.5160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5tvCRj19Y0kGe3Itfrjk64X+0cVmRgTA1GAW89i1SfTJjapzAnjPCumdhZLb1gmM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1925
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/16 09:33, Dr. David Alan Gilbert wrote:
> * Wei Huang (wei.huang2@amd.com) wrote:
> > On 09/15 05:51, Dr. David Alan Gilbert wrote:
> > > * Vitaly Kuznetsov (vkuznets@redhat.com) wrote:
> > > > With QEMU and newer AMD CPUs (namely: Epyc 'Rome') the current limit for
> > 
> > Could you elaborate on this limit? On Rome, I counted ~35 CPUID functions which
> > include Fn0000_xxxx, Fn4000_xxxx and Fn8000_xxxx.
> 
> On my 7302P the output of:
>     cpuid -1 -r | wc -l
> 
> is 61, there is one line of header in there.
> 
> However in a guest I see more; and I think that's because KVM  tends to
> list the CPUID entries for a lot of disabled Intel features, even on
> AMD, e.g. 0x11-0x1f which AMD doesn't have, are listed in a KVM guest.
> Then you add the KVM CPUIDs at 4...0 and 4....1.
>

It is indeed a mixing bag. Some are added even though AMD CPU doesn't define
them. BTW I also believe that cpuid command lists more CPUIDs than the real
value of cpuid->nent in kvm_vcpu_ioctl_set_cpuid(2).

Anyway I don't have objection to this patchset.

> IMHO we should be filtering those out for at least two reasons:
>   a) They're wrong
>   b) We're probably not keeping the set of visible CPUID fields the same
>     when we move between host kernels, and that can't be good for
> migration.
> 
> Still, those are separate problems.
> 
> Dave
> 
> > > > KVM_MAX_CPUID_ENTRIES(80) is reported to be hit. Last time it was raised
> > > > from '40' in 2010. We can, of course, just bump it a little bit to fix
> > > > the immediate issue but the report made me wonder why we need to pre-
> > > > allocate vcpu->arch.cpuid_entries array instead of sizing it dynamically.
> > > > This RFC is intended to feed my curiosity.
> > > > 
> > > > Very mildly tested with selftests/kvm-unit-tests and nothing seems to
> > > > break. I also don't have access to the system where the original issue
> > > > was reported but chances we're fixing it are very good IMO as just the
> > > > second patch alone was reported to be sufficient.
> > > > 
> > > > Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > > 
> > > Oh nice, I was just going to bump the magic number :-)
> > > 
> > > Anyway, this seems to work for me, so:
> > > 
> > > Tested-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > > 
> > 
> > I tested on two platforms and the patches worked fine. So no objection on the
> > design.
> > 
> > Tested-by: Wei Huang <wei.huang2@amd.com>
> > 
> > > > Vitaly Kuznetsov (2):
> > > >   KVM: x86: allocate vcpu->arch.cpuid_entries dynamically
> > > >   KVM: x86: bump KVM_MAX_CPUID_ENTRIES
> > > > 
> > > >  arch/x86/include/asm/kvm_host.h |  4 +--
> > > >  arch/x86/kvm/cpuid.c            | 55 ++++++++++++++++++++++++---------
> > > >  arch/x86/kvm/x86.c              |  1 +
> > > >  3 files changed, 43 insertions(+), 17 deletions(-)
> > > > 
> > > > -- 
> > > > 2.25.4
> > > > 
> > > -- 
> > > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> > > 
> > 
> -- 
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
