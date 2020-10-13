Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD93928D54F
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 22:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731976AbgJMU1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 16:27:05 -0400
Received: from mail-dm6nam12on2060.outbound.protection.outlook.com ([40.107.243.60]:59745
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726137AbgJMU1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 16:27:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wxizz8aaruAodDMuviCs+E1GkViasQ8v+nfMyh7NxTw2bqCMRdDiEPfJB9TPd+E28KNIgF2JhLuUTOuhFApnYKOuIzJkf6mpdzIKGygRr+xBvlcAWeNi8EBX9It5TICV9C0QxoblXqaLxCb5StOdnjh+teMTO2nzO5fLPh/gckMz1OLF0Ng8IYE9bpky7rA1+5tYZ5aMgRvlxPgiFOP5s+z+3lv1v26aBpa+qaXmWkp/nNhZYze/gRx9svNTFBf80lfW+KU5Rwz8lL0d1TBz7So4A6k3kJDJfVEhOeiSZndNUsFTA6/D69h3pt+RtD/NE12YY6KvS2m1smZLQQgwog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNINq4pSALVYeSkR4yi1ZpsoBQNGras6vtV/CWpAOkA=;
 b=KSs0GyRTL6K1ATurbrCs8jlKDzZXLKg58bFMM3C/I/1NcY/I0W3dLtPP6S+751jmMnwUBQXJZ2ZPPwXI+I1UUipKKjRG4gu0RPtWfUy9t5O1FIrgWO59EZm5yDGpUAQrhQhv7WKSGH1HpqcOKVx6Bq/qHrmwP1rfvFW8udxtnS35hjVXGW6Zl6tLA21aWkY48FqYbbFWUUssHQmPtmYDMzfBwjdfTiIOJEi/Q4u0bF5vcfyuOgk28v5rXhJM/NsZ0h0VwQGrVcIlf9NqSsNheG/CQFcavXKnLKBUGg9eDmBfUL2ERDV8IsQzq7g6i/Be6RiGLPCRGsfxj5GjfusMDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNINq4pSALVYeSkR4yi1ZpsoBQNGras6vtV/CWpAOkA=;
 b=TcdscM7G1mlR8ac3ejTm8bk9pTAWC9moyQklBJBKjyRK6mFvdJHoHbjrpVCS1AVlrSaN1Mst5jyNfN0A/wpByLbiyKMX9lx/Cnffs9ZMuytB6Ld+1ZRhjTUWNi9pmvn9z8TG6FLfoOJvYvPIKoLz0vivP88xSyFAaTs0Xt7TSew=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.20; Tue, 13 Oct 2020 20:27:01 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3455.030; Tue, 13 Oct 2020
 20:27:01 +0000
Subject: Re: [RFC PATCH 00/35] SEV-ES hypervisor support
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
 <20200914225951.GM7192@sjchrist-ice>
 <bee6fdda-d548-8af5-f029-25c22165bf84@amd.com>
 <20200916001925.GL8420@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <6832b8c8-2969-cb48-9af7-3539ff68d3fe@amd.com>
Date:   Tue, 13 Oct 2020 15:26:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200916001925.GL8420@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR14CA0052.namprd14.prod.outlook.com
 (2603:10b6:5:18f::29) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM6PR14CA0052.namprd14.prod.outlook.com (2603:10b6:5:18f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22 via Frontend Transport; Tue, 13 Oct 2020 20:27:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d3567863-4d1f-4361-e287-08d86fb65752
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB42185030DFE1CFC5FC1BC429EC040@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vjxOt45+2dxEG7/k0bWoslaQedzRSa+yx4LFA86OXiy0tMfpwt6TfVHnrxb8o++//AxUt3zxPbeaqyfjEKfDirj+4YnQdQELsmEuk3PbWxnh7HTjBmF/kqBT7iKqSvLJ1ZWMW6h74LHQIeDNaCMIUVJ51VIdxrM/narzjEGJ16oJnjb7IM9qB0J1qp2RkvqPG6O6HRqTRveGE/0FuHecXVaXrogpgKH8Act6LQJMlMhjCABcJhj8vO91CyP7cl8eTNfBuoHvlXxBOwCYjaiYz9aYZYHCrPLMxOYMxDk55yxMCKxAK4aHoG3V4o7aPLgZuQE+7imFM6fCYdJGqkgtUKnKixGPMGQmdJxFd1M/HCFXM72SZThwAi+zzOlZUwM9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(31686004)(36756003)(31696002)(316002)(478600001)(54906003)(6666004)(83380400001)(4326008)(16576012)(16526019)(53546011)(26005)(86362001)(66946007)(52116002)(8936002)(8676002)(66476007)(66556008)(7416002)(5660300002)(2906002)(6486002)(956004)(6916009)(2616005)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kEW/Hy7TIDe+FG1JmBS/k5IikIgshm/FB7UCrMWjrZ9UXCRNKwB6FGY36fRInkRZLp8hriPtwX9Fo4/drq+KQ5D7TVwDekrHu1wY0G4gffkOF4DCO0AfZbHtqood1N63BohtdUgQE6IXhwhWiTA/gKmz31ODH0qiJCXfM1cTH0SfHFowCcNLgv6Gn7no7Gf1ANtBzYx4RR4rD6vEECoNQ4557V5xO9Dzh6f0UMo/ylaZFsTFQwAld5H7q55xQhkIrFWGn2bxgh8JLAqPzJAv6Afv+Gr6mgKNEqhGtejNfuGlqE11AKCFTrVQEO/MyqG4SEdTlSDK5S+7NFH1ns6lk0S06J9XnoHYeGuOzovIQ3XH4mNeJoMAMV0YqsoKikHz3ZLYQTcMD9/cYfsGf/d0zJjAT1YdIPknX0VwJ54MH8Uo+jh0bC2RJzN+dyon3UuGsuT099UFeYzN74POf8cg0Yfc/10i6Xdm3K+NVwLMGSBP0L093FeSjI7jSb4y5U4gVbH6YR2EmHBqMBsz69bUIUgaYAXauTWDsRyfEaRtoA/iE8sZ0oE0DN9FUVx3mIyF0q9mO4AL2PKMQS314zF9nXSWyR5l6cJQ9nhFXsEi/oGV1XYZUbMkk63pEiY2avoofwjCQJyQaaUF+quoT6awhQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3567863-4d1f-4361-e287-08d86fb65752
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 20:27:01.5804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gzDZc0K+mzIl1mA2mdOQO4eLjKjqOo6mlJF503DDLyyEjgYd81XMVUUGKLfTjOLq7IrVVrG9BCxiUXzgGJ9r6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Apologies, Sean.

I thought I had replied to this but found it instead in my drafts folder...

I've taken much of your feedback and incorporated that into the next
version of the patches that I submitted and updated this response based on
that, too.

On 9/15/20 7:19 PM, Sean Christopherson wrote:
> On Tue, Sep 15, 2020 at 12:22:05PM -0500, Tom Lendacky wrote:
>> On 9/14/20 5:59 PM, Sean Christopherson wrote:
>>> Given that we don't yet have publicly available KVM code for TDX, what if I
>>> generate and post a list of ioctls() that are denied by either SEV-ES or TDX,
>>> organized by the denier(s)?  Then for the ioctls() that are denied by one and
>>> not the other, we add a brief explanation of why it's denied?
>>>
>>> If that sounds ok, I'll get the list and the TDX side of things posted
>>> tomorrow.
>>
>> That sounds good.
> 
> TDX completely blocks the following ioctl()s:

SEV-ES doesn't need to completely block these ioctls. SEV-SNP is likely to
do more of that. SEV-ES will still allow interrupts to be injected, or
registers to be retrieved (which will only contain what was provided in
the GHCB exchange), etc.

> 
>   kvm_vcpu_ioctl_interrupt
>   kvm_vcpu_ioctl_smi
>   kvm_vcpu_ioctl_x86_setup_mce
>   kvm_vcpu_ioctl_x86_set_mce
>   kvm_vcpu_ioctl_x86_get_debugregs
>   kvm_vcpu_ioctl_x86_set_debugregs
>   kvm_vcpu_ioctl_x86_get_xsave
>   kvm_vcpu_ioctl_x86_set_xsave
>   kvm_vcpu_ioctl_x86_get_xcrs
>   kvm_vcpu_ioctl_x86_set_xcrs
>   kvm_arch_vcpu_ioctl_get_regs
>   kvm_arch_vcpu_ioctl_set_regs
>   kvm_arch_vcpu_ioctl_get_sregs
>   kvm_arch_vcpu_ioctl_set_sregs
>   kvm_arch_vcpu_ioctl_set_guest_debug
>   kvm_arch_vcpu_ioctl_get_fpu
>   kvm_arch_vcpu_ioctl_set_fpu

Of the listed ioctls, really the only ones I've updated are:

  kvm_vcpu_ioctl_x86_get_xsave
  kvm_vcpu_ioctl_x86_set_xsave

  kvm_arch_vcpu_ioctl_get_sregs
    This allows reading of the tracking value registers
  kvm_arch_vcpu_ioctl_set_sregs
    This prevents setting of register values

  kvm_arch_vcpu_ioctl_set_guest_debug

  kvm_arch_vcpu_ioctl_get_fpu
  kvm_arch_vcpu_ioctl_set_fpu

> 
> Looking through the code, I think kvm_arch_vcpu_ioctl_get_mpstate() and
> kvm_arch_vcpu_ioctl_set_mpstate() should also be disallowed, we just haven't
> actually done so.

I haven't done anything with these either.

> 
> There are also two helper functions that are "blocked".
> dm_request_for_irq_injection() returns false if guest_state_protected, and
> post_kvm_run_save() shoves dummy state.

... and these.

> 
> TDX also selectively blocks/skips portions of other ioctl()s so that the
> TDX code itself can yell loudly if e.g. .get_cpl() is invoked.  The event
> injection restrictions are due to direct injection not being allowed (except
> for NMIs); all IRQs have to be routed through APICv (posted interrupts) and
> exception injection is completely disallowed.

For SEV-ES, we don't have those restrictions.

> 
>   kvm_vcpu_ioctl_x86_get_vcpu_events:
> 	if (!vcpu->kvm->arch.guest_state_protected)
>         	events->interrupt.shadow = kvm_x86_ops.get_interrupt_shadow(vcpu);
> 
>   kvm_arch_vcpu_put:
>         if (vcpu->preempted && !vcpu->kvm->arch.guest_state_protected)
>                 vcpu->arch.preempted_in_kernel = !kvm_x86_ops.get_cpl(vcpu);
> 
>   kvm_vcpu_ioctl_x86_set_vcpu_events:
> 	u32 allowed_flags = KVM_VCPUEVENT_VALID_NMI_PENDING |
> 			    KVM_VCPUEVENT_VALID_SIPI_VECTOR |
> 			    KVM_VCPUEVENT_VALID_SHADOW |
> 			    KVM_VCPUEVENT_VALID_SMM |
> 			    KVM_VCPUEVENT_VALID_PAYLOAD;
> 
> 	if (vcpu->kvm->arch.guest_state_protected)
> 		allowed_flags = KVM_VCPUEVENT_VALID_NMI_PENDING;
> 
> 
>   kvm_arch_vcpu_ioctl_run:
> 	if (vcpu->kvm->arch.guest_state_protected)
> 		kvm_sync_valid_fields = KVM_SYNC_X86_EVENTS;
> 	else
> 		kvm_sync_valid_fields = KVM_SYNC_X86_VALID_FIELDS;
> 
> 
> In addition to the more generic guest_state_protected, we also (obviously
> tentatively) have a few other flags to deal with aspects of TDX that I'm
> fairly certain don't apply to SEV-ES:
> 
>   tsc_immutable - KVM doesn't have write access to the TSC offset of the
>                   guest.
> 
>   eoi_intercept_unsupported - KVM can't intercept EOIs (doesn't have access
>                               to EOI bitmaps) and so can't support level
>                               triggered interrupts, at least not without
>                               extra pain.
> 
>   readonly_mem_unsupported - Secure EPT (analagous to SNP) requires RWX
>                              permissions for all private/encrypted memory.
>                              S-EPT isn't optional, so we get the joy of
>                              adding this right off the bat...

Yes, most of the above stuff doesn't apply to SEV-ES.

Thanks,
Tom

> 
