Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8AF22D6A1B
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 22:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404955AbgLJV15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 16:27:57 -0500
Received: from mail-dm6nam12on2049.outbound.protection.outlook.com ([40.107.243.49]:35553
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404919AbgLJV1m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 16:27:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWPSULep3cBTlhD7zSUTVq+1R6HMYILc8eLknegShMWR9b55fL7rts7Nu0GyLaMRUTgh5vZYs8fUw7a+jCqpHvdUKIHLBxq6DrxYlcJHpcLqdZ4jKUMBnsyjEkuIuUHliST78vS1912lv8Fwk+JqJPE51QGkn1jIoDoF/N4kgUGc1p1RvA2aQxP2T25+fUN800grhMBKU2R/JaKwRXLb196CuZ34UZNbdWQJd2rUV8RHFmOMrb3xz8CjxHTQuIQ0ckG0QQ6ZBmelfRvdDxOqeT9MTmW3Q+vpFxSlHB3C4xD8wGgIdkEnR6d7c07i3MR8wiIa8CUhDQ3MxhBtBwAGKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xbpBzI+NNPnrwzrdtXZVhaFy8FItTndKtqjKLZVjuUo=;
 b=eZ+P9YTLO5DauTIxZq5izVh6j5G3+HxuOn2O3SRDc71PkdV2DbSKAVZBg/c85dpjNXrahAAvq7qXTLW6kA+1S5WTtKoWmVu0wsjiPqzb7NM3diLtfXgfRXQROoszpcOjKXz7eH4r1oNFkEQ2DKe3z3Zrq58QK2oBaU+jpkJyY0sHEmGKBQASkxzn3cE1n0q+RBjJz4iEfNakcgmc2RV+BvVhZFKmukr+Qucs8Ztw2Lkb4EQU1CxnCZWZ6T87ZgpSWf23L1hPel9qWDvi45D2JdTQZtpzGbdrZPBtqhs8ZnS2n9dt7EpZaD8jwe6vb3oiktpRJb8+Zn56qQww7gFAcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xbpBzI+NNPnrwzrdtXZVhaFy8FItTndKtqjKLZVjuUo=;
 b=3/9mTwm82NkSmbdMoBP2U500zeeT19g03CG5p9AX0nrTAhaLwK9zMWJNEdzWPLnP0cl9qFEOhd4Qo1rRloBt5S2zG/Qn/nNz6rCZbkER9/Z9SoQqj5J6E1UPdNZJVyPDW9k+JjerAa2wDQirPtaBPt29C5BJyzj8wAkGCCiKAhM=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4477.namprd12.prod.outlook.com (2603:10b6:806:92::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Thu, 10 Dec
 2020 21:26:47 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece%3]) with mapi id 15.20.3654.017; Thu, 10 Dec 2020
 21:26:47 +0000
Subject: RE: [PATCH 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "kyung.min.park@intel.com" <kyung.min.park@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "mgross@linux.intel.com" <mgross@linux.intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Phillips, Kim" <kim.phillips@amd.com>,
        "Huang2, Wei" <Wei.Huang2@amd.com>
References: <160738054169.28590.5171339079028237631.stgit@bmoger-ubuntu>
 <160738067970.28590.1275116532320186155.stgit@bmoger-ubuntu>
 <CALMp9eRSvWemdiBygMJ18yP9T0UzL0nNbpD__bRis7M5LqOK+g@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <737ec565-ec4f-1d9e-a7f8-dfa7976e64e6@amd.com>
Date:   Thu, 10 Dec 2020 15:26:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALMp9eRSvWemdiBygMJ18yP9T0UzL0nNbpD__bRis7M5LqOK+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0042.namprd02.prod.outlook.com
 (2603:10b6:803:2e::28) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SN4PR0201CA0042.namprd02.prod.outlook.com (2603:10b6:803:2e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 21:26:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f28ebd02-4630-45a7-138f-08d89d524d1d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4477:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4477A196EC72DD8E8131493895CB0@SA0PR12MB4477.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /gQRHMSOoU0MjcqONp7/BtCujDOaK59fKCwQSqgcPjoPfCVzqRDyWaYS5BFd7Tjx9nuH4eOWOy9YRhzt1U9qKU00cqe+YNt+GUOQh9XF8B6jGQxkwN6QZ8fx07E2pw+t9LYSjAGFVFc/zOGI/QxZWx5XqKzzbVvxps1uGVoXkpQJ1XXyZUYrt/6fqSBz0I2bnDgub3HTBhjftaYY2kBTAAiIHOYCVADiwZPvdxFnD67Jsy2RHOY91jOPQN18IMw3Fwz9NYahR3RrE7pCDEBE3VnpqTHidVmy/ukZP6zZ2uPL+Us2rD0L2g/mPuk4GfA8S7BbrNHDAEz8T2RzVjDM6kMhq974uhY5O9Yat81OknqleaMZIxkKGM3K9vraOWyaiG/dPLpBPp7qR1qhGYODkqWhTW+MfhwC8F5cKvZe5vGsGHbc33oQG3VVsZH0z+Iu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(2616005)(66556008)(86362001)(7416002)(54906003)(16576012)(44832011)(34490700003)(16526019)(6486002)(4326008)(83380400001)(2906002)(66476007)(186003)(508600001)(5660300002)(36756003)(53546011)(31686004)(31696002)(8676002)(6916009)(52116002)(26005)(66946007)(8936002)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RnRTYmFoTkVYU0VGTFQzQnhIK1FVYjRuMUV3eTkrNFExUFB6Uk10RHR1aEha?=
 =?utf-8?B?dzVjTkRrY3I4Y1F5b2R5Q0lzbW9vWC84M0dVNHFSOWYzYTVWRFl1VzV2UmU3?=
 =?utf-8?B?OTRQZDNOTnBoNHJ6dEF6NE5SSThDbTRtMFc2Wm5HdmhRTDRSSlpIVEJOK1dl?=
 =?utf-8?B?dWlUWlFtWUJjRlRCMzhnVFcra3luWmZNalR5cXN0b05mTWpSalgrcFhRRzhO?=
 =?utf-8?B?emVHeEVJSkNlUDQ3NHNNWnlnaFg3cTRjNlQycHpBK0Eyc2ZZeWpiUEExUFVB?=
 =?utf-8?B?RHRyeDNSYmR0d2V6K3V0RXRCWkI0K1c0NVFSMzQyQjJtS1lKM3RLa2hUSlVp?=
 =?utf-8?B?WXBJdGtxMXpyaXpkLzFNTHQwYldPTmpTV2hFTFVMNkx2MjArcXpZMjFwMFhT?=
 =?utf-8?B?S3VURG50RExxZ0xOc0Z6d0VIOEJKQXp6WUswMklueWkzKzFFWUN1dnFrQ1dS?=
 =?utf-8?B?eVl1dXRtTk5vMytsdzBJa2pWQ2RLZnVySDZYcXIvYXZXYW4xSVFMRlF3Q1dJ?=
 =?utf-8?B?Z1hHZ2o3dXpuUnIvSk9Id2l3QmZDOTBoKzVHRFlUSFJmNU5LWXI0RXRNMGI1?=
 =?utf-8?B?NEZzQ1pHRWdBSW81MFhST3djWmtkVmhmbmRCV2RTbFJHNGR0bk1vWnZOQ1ZW?=
 =?utf-8?B?c2xQLy9ZQnFSaGhBOXpnS3ltaEVGSU5oS1BkaHFZUmwrMFVoOXN6TDBnRm9q?=
 =?utf-8?B?UzRscGhnME5CNkh5WFZsTEVsMlc3SkxDa0Z5QndlTmpGV1p4T3JZc3VSYWZh?=
 =?utf-8?B?SWlpSjFBSDVSK3YyUmg0R0t1WkhoNlQ5S3lDVm5pRW5PQkVRZnI4MndDMzkw?=
 =?utf-8?B?U2dHWEFaRG82Z1Z0cEplZEJOQnZ6Lzdsb0dXd2tDdkp4b1ZMUkc5NWdEZ2o2?=
 =?utf-8?B?cEN2VXR2MUZVVTRYa3RpWnczb1QwTlhackJlYjlTUUNrWW1IZWdEK3NHR0lB?=
 =?utf-8?B?ZThiUnZxZVZaNVVXTnBIbjR4VGJOVHVrZ2VQVWt1VVVLb3VpQ29SMFZ0aEoy?=
 =?utf-8?B?dVBpYXlpWlBNNHNzdnA1V2xxU1l1TEVpVlFqanFZRXNha0lKUnFubDNweXM5?=
 =?utf-8?B?OUI1NkJwYzJPWkt3cVRSdVZnN293ekxOdDZYaEMrSnpOS2lObEpYNEU5TWFD?=
 =?utf-8?B?RWd4Y2wzb2pFeWwweXB5WGQwUTFaL3dMbkF6Z280UW1GdmlVR1V0V1prMEc3?=
 =?utf-8?B?UzZPZzdoN0RhU1dibjZ0cmNZc0gyVDU0Nmpxbmw5c1BVK1EzQUpUMFhVcUti?=
 =?utf-8?B?c2ltNzZUSlpMSmlsRnZ3VU1sb1FPNElZQzIwMnRCRkc0VzRQY3NTUXBlZjRh?=
 =?utf-8?Q?5JORqWdQ/XWk6Ge9GYx4rz21dhSx2z5w9/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 21:26:47.8855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: f28ebd02-4630-45a7-138f-08d89d524d1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mO9XIGISbKdhkNldc2fBy0GgbGTf/JjZUnVygZVNn7sYG9LU6JWQ92i5+ulxJQ+K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4477
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jim,

> -----Original Message-----
> From: Jim Mattson <jmattson@google.com>
> Sent: Monday, December 7, 2020 5:06 PM
> To: Moger, Babu <Babu.Moger@amd.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>; Thomas Gleixner
> <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>; Borislav Petkov
> <bp@alien8.de>; Yu, Fenghua <fenghua.yu@intel.com>; Tony Luck
> <tony.luck@intel.com>; Wanpeng Li <wanpengli@tencent.com>; kvm list
> <kvm@vger.kernel.org>; Lendacky, Thomas <Thomas.Lendacky@amd.com>;
> Peter Zijlstra <peterz@infradead.org>; Sean Christopherson
> <seanjc@google.com>; Joerg Roedel <joro@8bytes.org>; the arch/x86
> maintainers <x86@kernel.org>; kyung.min.park@intel.com; LKML <linux-
> kernel@vger.kernel.org>; Krish Sadhukhan <krish.sadhukhan@oracle.com>; H .
> Peter Anvin <hpa@zytor.com>; mgross@linux.intel.com; Vitaly Kuznetsov
> <vkuznets@redhat.com>; Phillips, Kim <kim.phillips@amd.com>; Huang2, Wei
> <Wei.Huang2@amd.com>
> Subject: Re: [PATCH 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
> 
> On Mon, Dec 7, 2020 at 2:38 PM Babu Moger <babu.moger@amd.com> wrote:
> >
> > Newer AMD processors have a feature to virtualize the use of the
> > SPEC_CTRL MSR. When supported, the SPEC_CTRL MSR is automatically
> > virtualized and no longer requires hypervisor intervention.
> >
> > This feature is detected via CPUID function 0x8000000A_EDX[20]:
> > GuestSpecCtrl.
> >
> > Hypervisors are not required to enable this feature since it is
> > automatically enabled on processors that support it.
> >
> > When this feature is enabled, the hypervisor no longer has to
> > intercept the usage of the SPEC_CTRL MSR and no longer is required to
> > save and restore the guest SPEC_CTRL setting when switching
> > hypervisor/guest modes.  The effective SPEC_CTRL setting is the guest
> > SPEC_CTRL setting or'ed with the hypervisor SPEC_CTRL setting. This
> > allows the hypervisor to ensure a minimum SPEC_CTRL if desired.
> >
> > This support also fixes an issue where a guest may sometimes see an
> > inconsistent value for the SPEC_CTRL MSR on processors that support
> > this feature. With the current SPEC_CTRL support, the first write to
> > SPEC_CTRL is intercepted and the virtualized version of the SPEC_CTRL
> > MSR is not updated. When the guest reads back the SPEC_CTRL MSR, it
> > will be 0x0, instead of the actual expected value. There isn’t a
> > security concern here, because the host SPEC_CTRL value is or’ed with
> > the Guest SPEC_CTRL value to generate the effective SPEC_CTRL value.
> > KVM writes with the guest's virtualized SPEC_CTRL value to SPEC_CTRL
> > MSR just before the VMRUN, so it will always have the actual value
> > even though it doesn’t appear that way in the guest. The guest will
> > only see the proper value for the SPEC_CTRL register if the guest was
> > to write to the SPEC_CTRL register again. With Virtual SPEC_CTRL
> > support, the MSR interception of SPEC_CTRL is disabled during
> > vmcb_init, so this will no longer be an issue.
> >
> > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > ---
> 
> Shouldn't there be some code to initialize a new "guest SPEC_CTRL"
> value in the VMCB, both at vCPU creation, and at virtual processor reset?

Yes, I think so. I will check on this.

> 
> >  arch/x86/kvm/svm/svm.c |   17 ++++++++++++++---
> >  1 file changed, 14 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c index
> > 79b3a564f1c9..3d73ec0cdb87 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1230,6 +1230,14 @@ static void init_vmcb(struct vcpu_svm *svm)
> >
> >         svm_check_invpcid(svm);
> >
> > +       /*
> > +        * If the host supports V_SPEC_CTRL then disable the interception
> > +        * of MSR_IA32_SPEC_CTRL.
> > +        */
> > +       if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> > +               set_msr_interception(&svm->vcpu, svm->msrpm,
> MSR_IA32_SPEC_CTRL,
> > +                                    1, 1);
> > +
> >         if (kvm_vcpu_apicv_active(&svm->vcpu))
> >                 avic_init_vmcb(svm);
> >
> > @@ -3590,7 +3598,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct
> kvm_vcpu *vcpu)
> >          * is no need to worry about the conditional branch over the wrmsr
> >          * being speculatively taken.
> >          */
> > -       x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
> > +       if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> > +               x86_spec_ctrl_set_guest(svm->spec_ctrl,
> > + svm->virt_spec_ctrl);
> 
> Is this correct for the nested case? Presumably, there is now a "guest
> SPEC_CTRL" value somewhere in the VMCB. If L1 does not intercept this MSR,
> then we need to transfer the "guest SPEC_CTRL" value from the
> vmcb01 to the vmcb02, don't we?

Here is the text from to be published documentation.
"When in host mode, the host SPEC_CTRL value is in effect and writes
update only the host version of SPEC_CTRL. On a VMRUN, the processor loads
the guest version of SPEC_CTRL from the VMCB. For non- SNP enabled guests,
processor behavior is controlled by the logical OR of the two registers.
When the guest writes SPEC_CTRL, only the guest version is updated. On a
VMEXIT, the guest version is saved into the VMCB and the processor returns
to only using the host SPEC_CTRL for speculation control. The guest
SPEC_CTRL is located at offset 0x2E0 in the VMCB."  This offset is into
the save area of the VMCB (i.e. 0x400 + 0x2E0).

The feature X86_FEATURE_V_SPEC_CTRL will not be advertised to guests.
So, the guest will use the same mechanism as today where it will save and
restore the value into/from svm->spec_ctrl. If the value saved in the VMSA
is left untouched, both an L1 and L2 guest will get the proper value.
Thing that matters is the initial setup of vmcb01 and vmcb02 when this
feature is available in host(bare metal). I am going to investigate that
part. Do you still think I am missing something here?


> 
> >         svm_vcpu_enter_exit(vcpu, svm);
> >
> > @@ -3609,12 +3618,14 @@ static __no_kcsan fastpath_t
> svm_vcpu_run(struct kvm_vcpu *vcpu)
> >          * If the L02 MSR bitmap does not intercept the MSR, then we need to
> >          * save it.
> >          */
> > -       if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
> > +       if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL) &&
> > +           unlikely(!msr_write_intercepted(vcpu,
> > + MSR_IA32_SPEC_CTRL)))
> >                 svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
> 
> Is this correct for the nested case? If L1 does not intercept this MSR, then it
> might have changed while L2 is running. Presumably, the hardware has stored
> the new value somewhere in the vmcb02 at #VMEXIT, but now we need to move
> that value into the vmcb01, don't we?
> 
> >         reload_tss(vcpu);
> >
> > -       x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
> > +       if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> > +               x86_spec_ctrl_restore_host(svm->spec_ctrl,
> > + svm->virt_spec_ctrl);
> >
> >         vcpu->arch.cr2 = svm->vmcb->save.cr2;
> >         vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
> >
> 
> It would be great if you could add some tests to kvm-unit-tests.

Yes. I will check on this part.

Thanks
Babu
