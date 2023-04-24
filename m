Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464176ED44B
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 20:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbjDXSW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 14:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjDXSW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 14:22:57 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EDB4EE8;
        Mon, 24 Apr 2023 11:22:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eI1geyxcVkYkzf7Xw+DG2NOtUrphS/3tDysn5d9yqqrnGLTNiZHVJvAgRT9KgA/1Qa4CZcUHOYXjLJfAWvNxkKdabcByXp9WiaRaS/SSUuZOUTlj+y6P0OaFDdAhQiqeeqix3h/oyV+jHnTOEa43y/XzQPWecobW62Xy9rQO+/9xxTOJkDS89K7z2didhbDumc+OW25uPN5bOB+DjxupTKMMhhYqpsvmm/ydI4WfiFq4JaO02xhFbon8S2CarUb6duenVgB89wSvlg+EAi1iE8hvPMApB5bN+PiMCPRIfUflDYEU7egMUGfLIvQfKOKnCQyfp6FJ98ZJDdSUdekM1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g4cbIvr79cNQw4VdpbcunliWZ9QRxZpNTC/us65jfVA=;
 b=kdcCB/ObMhDjGfGJAgAMM/ATKEOvqOUPWK5FtQRsNQNdnNUEcPQ0VpzhMexEy4fCQ5Q0jCsJKpuOcCnDk7YPRlXH/ucE8QAuTzlLzPLfyTitBgkQwAH9ES7p1Fj28eHPdsuB/jrvxP/2FsLFCosImSoThkIkBhsXWTA6vx8o2ClVdtgGODqwQ1T5jehp8vGfch3emJ4CWM3Oni8H9u0bbBWRb2XbUYkhAXpa9NPlYqeUtFGXH5gCZ5uxYCRMnQd0/p/KMoowSOhKm3SHVA4OAI+y5KbvCkuKFd6I85cPU3daniH9pTLJGeX/xy73d3BEIp98zuVhuIJ5RQ4QoRDYUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g4cbIvr79cNQw4VdpbcunliWZ9QRxZpNTC/us65jfVA=;
 b=eJbGjQSGKGpBTRTKot49MWCFGy4MxJTtWqSgV7MdH79uAyUBtexSph+vrlU2SfQVNQszCKLzO8i1bZX+m5UipVLGpNfzoiZ1t8M3ZhG5C7veYKsb/ZJgUfWmsvnjVtGvHpbSQC64/Uov8RgtGhVG8ZzPVzVmtSgLR3GJQcFruds=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by PH7PR12MB5618.namprd12.prod.outlook.com (2603:10b6:510:134::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Mon, 24 Apr
 2023 18:22:52 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::38dc:9789:e0:aef6]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::38dc:9789:e0:aef6%7]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 18:22:51 +0000
Date:   Mon, 24 Apr 2023 13:22:38 -0500
From:   John Allen <john.allen@amd.com>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com,
        pbonzini@redhat.com, peterz@infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com
Subject: Re: [PATCH v2 00/21] Enable CET Virtualization
Message-ID: <ZEbI7iyH1H0wnK5g@johallen-workstation>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <ZEMGA2uUfpJL4rMH@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEMGA2uUfpJL4rMH@kernel.org>
X-ClientProxiedBy: YT4PR01CA0161.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::11) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|PH7PR12MB5618:EE_
X-MS-Office365-Filtering-Correlation-Id: 67b91c4c-0d62-44cf-932d-08db44f0ea2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nmFV8k0hUVT+rzDuna7ecDLWm3nbwhXXDBLQW/HStmT6rXQpvLG1Db+P6rmwow72L1kydv52rv3hM4D909fmopAJZUxALN/wZKIaTpK3PaEpHFsL6ZJwa4st5Xsa266KNld+jbr3k1h/xnBr/j6ZJ15j4m/UuwdNAVtCn/8DDqxLmKTC7T/FQmiJt980R9MQF/aJFAsewYtUxJkUF2ZSdyoMuuHhjBHCeh4w8ZNVPyCRFlrlA525sOmKa96mJOh4DleK/aTcrHEP5o0TB7Itxotc8fv6SvIPssn6psi8ncYHkjMemWnr508duhInGwTc3cdvVZ/25r2zdnio5yIx/gO5gfa2g/5AIpIgKDpKg1SP0FFGM0Y05eDNXspL2SNsn3zpDW7vwnf32zqXADmEQ8HeFDMWtw1kO9BgZ6ZNY/HRJ9vjup8Bm5zMsjG6gyeBjme6w7d72X/t8WpUwtKXf0dOSYYRfc4FadvPcFGO9D8CVfxHt+u9lWWnR3TWiEooD6MMfxORMmPQ2VLiQdcvJlFAMRxv8ckbk+Rgg8iKaACrB4roEg2zwXHLm8UzHTfhI9R9j8/6qVcNtKDEVBIPbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199021)(66556008)(8936002)(66476007)(8676002)(478600001)(66946007)(44832011)(38100700002)(6916009)(86362001)(2906002)(41300700001)(316002)(4326008)(6666004)(5660300002)(6486002)(9686003)(966005)(6506007)(26005)(6512007)(33716001)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GvIcr5VBvypnwqRh3ZEUuPrc6xXx+DR08Zxtv4t7A3TjjKj8Btvw5fIQZeD3?=
 =?us-ascii?Q?pNCVcHUwthGIwcio4QSLTcMgWb/+9SVLRXw/SEmEg/5mcMJ60cGtnwQomx3s?=
 =?us-ascii?Q?gMHW+4nlPg70knMbSUWb4GYAGkJql8lmL0uUJ9Hch3iHEYan5oJboUtSSPrf?=
 =?us-ascii?Q?DYUnwkTwtmAL07aNMJ6vVMjX7CtxSHPb/Jl3i+0GU8XCX/fyd67+tj9Vwlty?=
 =?us-ascii?Q?5GswPLrgKdvc6lOk3+aZLQXJcDM9t8cd/X7Ztil3HEBqJiY15KimHi13l2Gq?=
 =?us-ascii?Q?zzeHegLKyTukQzzUx9itvM/yfSCjjL3YDlInaFdFyr2Hmgyo8k0C97zxMs5C?=
 =?us-ascii?Q?eSHelUIf0tm4EDiw2LCsxkYEPy2pGhLkz2JlWN8VsZtHsgl95pwYc4AbS9J2?=
 =?us-ascii?Q?7yPmPQ9SP6oARMqUbmA0B576YHcNuc3n2aEknU5aeg+FnJyYPNGADHUkXzLe?=
 =?us-ascii?Q?KlM/iou3NTidkofFgkuHp2VeseNUz/JqbWOS0QrD9+ef9J9jOGdTylkbiymQ?=
 =?us-ascii?Q?tclbJFP0eJ6i+ux18e+Xk+tFF8kg/QMnwPUwPTuaJUgXxUljGNcKkNy8ppf7?=
 =?us-ascii?Q?NX4nAYGvcdwHGE251v9dsnyAiarEraPKRHVV9lsRmD+yAdzsqRoeuGOndfts?=
 =?us-ascii?Q?zmWlpf8KMzOP4hNN2oQhZMCW9d5enroiT3XoOi3l8HPWNe6AYUOLlKc1BXpN?=
 =?us-ascii?Q?hBmSVYw2BMe5k1LMqoFJYq95bTZDuKTqHoX8wfWjH/zF9T0/A1A7t4WiJ1UI?=
 =?us-ascii?Q?Axbow+qey0kuDKIEnmmb/HcFG1ojRLtOI3PQMcX5WFJw2aaGtG2YFhSa8u1A?=
 =?us-ascii?Q?0l23hVlA+wZrOgJ9gaEM7MezZ3Duml2WW42EdHL+WzzoIItvMIHBcwcASXpg?=
 =?us-ascii?Q?pVYs4+Yg3uxaMgyZU9EvLXVtR0US8qKsFF+LmV8SfC/VDYm4NJ4Ogvw7Ks5+?=
 =?us-ascii?Q?krGrDJsbiixdU+W07Iq+z8Lt1gEKrpoEdt0MDVOJh+4mLNb+2Im5AUr3eJSM?=
 =?us-ascii?Q?56oFFpm0PsEyqb7jSSPS7kSpLATu7TPcsFNvbyE9LC1XZrBHGl/BBS+9RlYN?=
 =?us-ascii?Q?m4lLCvsTCoYOGA0hWuqrvmXGDw4LfU4VpdfESDiWZzzJKnPXwe1WOawzozUs?=
 =?us-ascii?Q?69qWNFwNtwXL15f2KzUIgEp9ub5nji4p6+Lgt3kzjtpxsWpCPwvqw+1Dci/e?=
 =?us-ascii?Q?jv4nGg3b8hjozHcXpEfAWvRL7cNbfcZkrWmhXLc/HPQFpmEwk6ddH3rNpfme?=
 =?us-ascii?Q?3gthU4cLonCfK9sqaBB17uwWmkYVVLaYLNQXOOE+kIhDAA4JhDKWQqQNfqJ+?=
 =?us-ascii?Q?YrrSgBH66psAC0OtWD99OL5pMOYVTr+vJCwjVp3QvIge3ndxRG7eCuY4RUO6?=
 =?us-ascii?Q?1cMyZvYA5IcwRBwzx2sFRI5QTke6f7vSegapKSfRLhfzhA9WNNV0oYBBnxc7?=
 =?us-ascii?Q?mr1/j6DMxhWnmfyBlTtqciTEelwXVWPWlM0ErN+wmD0A/dH0ohDolAE6aEjG?=
 =?us-ascii?Q?ygbRJ/Rnub82OHHKv8hgy8bF5fUj7/Swr9trghGSetISl283EYdBUTruMcku?=
 =?us-ascii?Q?B1f1YpDeWEHgJ/HC/GCJN0AguGge7wj0Qa14J8Wd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67b91c4c-0d62-44cf-932d-08db44f0ea2c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 18:22:51.7805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qOwtEAIgQzn5PgZjaGMzYrMqz+avM5SaqoPCbrhXLmVlTdiQrOLKdmJvRM8VBEJQ97z3QZ55gWVVN+1WZGM0Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5618
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 22, 2023 at 12:54:11AM +0300, Mike Rapoport wrote:
> Hi,
> 
> On Fri, Apr 21, 2023 at 09:45:54AM -0400, Yang Weijiang wrote:
> >
> > Tests:
> > --------------------------------------------------------------------------
> > This series passed basic CET user shadow stack test and kernel IBT test in
> > L1 and L2 guest. It also passed CET KUT test which has been merged there.
> > 
> > Executed all KUT tests and KVM selftests against this series, all test cases
> > passes except the vmx test, the failure is due to CR4_CET bit testing in
> > test_vmxon_bad_cr(). After add CR4_CET bit to skip list, the test passed.
> > I'll send a patch to fix this issue later.
> > 
> > 
> > To run user shadow stack test and kernel IBT test in VM, you need an CET
> > capable platform, e.g., Sapphire Rapids server, and follow below steps to
> > build host/guest kernel properly:
> > 
> > 1. Buld host kernel. Patch this series to kernel tree and build kernel
> > with CET capable gcc version(e.g., >=8.5.0).
> > 
> > 2. Build guest kernel. Patch CET native series to kernel tree and opt-in
> > CONFIG_X86_KERNEL_IBT and CONFIG_X86_USER_SHADOW_STACK options.
> > 
> > 3. Launch a VM with QEMU built with CET enabling patches [2].
> > 
> > Check kernel selftest test_shadow_stack_64 output:
> > [INFO]  new_ssp = 7f8c82100ff8, *new_ssp = 7f8c82101001
> > [INFO]  changing ssp from 7f8c82900ff0 to 7f8c82100ff8
> > [INFO]  ssp is now 7f8c82101000
> > [OK]    Shadow stack pivot
> > [OK]    Shadow stack faults
> > [INFO]  Corrupting shadow stack
> > [INFO]  Generated shadow stack violation successfully
> > [OK]    Shadow stack violation test
> > [INFO]  Gup read -> shstk access success
> > [INFO]  Gup write -> shstk access success
> > [INFO]  Violation from normal write
> > [INFO]  Gup read -> write access success
> > [INFO]  Violation from normal write
> > [INFO]  Gup write -> write access success
> > [INFO]  Cow gup write -> write access success
> > [OK]    Shadow gup test
> > [INFO]  Violation from shstk access
> > [OK]    mprotect() test
> > [SKIP]  Userfaultfd unavailable.
> > [OK]    32 bit test
> > 
> > Check kernel IBT with dmesg | grep CET:
> > CET detected: Indirect Branch Tracking enabled
> > 
> > --------------------------------------------------------------------------
> > Changes in v2:
> > 1. Remove excessive checks on host CET Kconfig options in v1 patchset [3].
> > 2. Make CET CPUIDs, MSRs and control flags enabling independent to host CET status.
> > 3. Introduce supervisor SHSTK support to make the patch set complete.
> > 4. Refactor patches to accommodate above changes.
> > 5. Rebase on kvm-x86/next [4].
> > 
> > 
> > [1]: linux-next: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/?h=next-20230420
> > [2]: QEMU patch: https://lore.kernel.org/all/20230421041227.90915-1-weijiang.yang@intel.com/
> > [3]: v1 patchset: https://lore.kernel.org/all/20220616084643.19564-1-weijiang.yang@intel.com/
> > [4]: Rebase branch: https://github.com/kvm-x86/linux.git, commit: 7b632f72528d (tag: kvm-x86-next-2023.04.14)
>  
> I played a bit with KVM support for shadow stacks on AMD machines and I
> rebased v1 patches along with John's SVM series 
> 
> https://lore.kernel.org/kvm/20221012203910.204793-1-john.allen@amd.com/
> 
> on top of v6.3-rc4 and Rick's series for host shadow stack support. I've
> put this at
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=shstk/kvm
> 
> if anybody is interested. With this I could successfully run shadow stack
> self test in a guest on an AMD Zen3 machine.

That's great news! Thanks for testing!

Thanks,
John

> 
> One thing I've noticed while rebasing is that John's patches move
> cet_is_msr_accessible() from vmx/ to x86.c and I also had to make such move
> for cet_is_ssp_msr_accessible().
> 
> Would make sense to have them available for both VMX and SVM from the
> start.
> 
> > Rick Edgecombe (5):
> >   x86/shstk: Add Kconfig option for shadow stack
> >   x86/cpufeatures: Add CPU feature flags for shadow stacks
> >   x86/cpufeatures: Enable CET CR4 bit for shadow stack
> >   x86/fpu/xstate: Introduce CET MSR and XSAVES supervisor states
> >   x86/fpu: Add helper for modifying xstate
> > 
> > Sean Christopherson (2):
> >   KVM:x86: Report XSS as to-be-saved if there are supported features
> >   KVM:x86: Load guest FPU state when accessing xsaves-managed MSRs
> > 
> > Yang Weijiang (14):
> >   KVM:x86: Refresh CPUID on write to guest MSR_IA32_XSS
> >   KVM:x86: Init kvm_caps.supported_xss with supported feature bits
> >   KVM:x86: Add #CP support in guest exception classification
> >   KVM:VMX: Introduce CET VMCS fields and control bits
> >   KVM:x86: Add fault checks for guest CR4.CET setting
> >   KVM:VMX: Emulate reads and writes to CET MSRs
> >   KVM:VMX: Add a synthetic MSR to allow userspace VMM to access
> >     GUEST_SSP
> >   KVM:x86: Report CET MSRs as to-be-saved if CET is supported
> >   KVM:x86: Save/Restore GUEST_SSP to/from SMM state save area
> >   KVM:VMX: Pass through user CET MSRs to the guest
> >   KVM:x86: Enable CET virtualization for VMX and advertise to userspace
> >   KVM:nVMX: Enable user CET support for nested VMX
> >   KVM:x86: Enable supervisor IBT support for guest
> >   KVM:x86: Support CET supervisor shadow stack MSR access
> > 
> >  arch/x86/Kconfig                         |  24 ++++
> >  arch/x86/Kconfig.assembler               |   5 +
> >  arch/x86/include/asm/cpufeatures.h       |   2 +
> >  arch/x86/include/asm/disabled-features.h |   8 +-
> >  arch/x86/include/asm/fpu/api.h           |   9 ++
> >  arch/x86/include/asm/fpu/types.h         |  16 ++-
> >  arch/x86/include/asm/fpu/xstate.h        |   6 +-
> >  arch/x86/include/asm/kvm_host.h          |   3 +-
> >  arch/x86/include/asm/vmx.h               |   8 ++
> >  arch/x86/include/uapi/asm/kvm.h          |   1 +
> >  arch/x86/include/uapi/asm/kvm_para.h     |   1 +
> >  arch/x86/kernel/cpu/common.c             |  35 ++++--
> >  arch/x86/kernel/cpu/cpuid-deps.c         |   1 +
> >  arch/x86/kernel/fpu/core.c               |  19 +++
> >  arch/x86/kernel/fpu/xstate.c             |  90 +++++++-------
> >  arch/x86/kvm/cpuid.c                     |  23 +++-
> >  arch/x86/kvm/cpuid.h                     |   6 +
> >  arch/x86/kvm/smm.c                       |  20 +++
> >  arch/x86/kvm/vmx/capabilities.h          |   4 +
> >  arch/x86/kvm/vmx/nested.c                |  29 ++++-
> >  arch/x86/kvm/vmx/vmcs12.c                |   6 +
> >  arch/x86/kvm/vmx/vmcs12.h                |  14 ++-
> >  arch/x86/kvm/vmx/vmx.c                   | 150 ++++++++++++++++++++++-
> >  arch/x86/kvm/vmx/vmx.h                   |   6 +-
> >  arch/x86/kvm/x86.c                       |  79 ++++++++++--
> >  arch/x86/kvm/x86.h                       |  46 ++++++-
> >  26 files changed, 528 insertions(+), 83 deletions(-)
> > 
> > 
> > base-commit: 7b632f72528d5fa3f0265358a393f534da47d9dd
> > -- 
> > 2.27.0
> > 
> 
> -- 
> Sincerely yours,
> Mike.
