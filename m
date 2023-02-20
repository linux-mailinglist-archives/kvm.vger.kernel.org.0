Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E83669D180
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 17:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbjBTQlk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 11:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbjBTQl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 11:41:29 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9676206AB;
        Mon, 20 Feb 2023 08:41:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6USKytXKZLfOSxuOyBGl4SlkJOOpDtJ+15DBLKVxCpWrFD4KrXwKzQMnIa6xNbo/GDBKgYxPcuEDXGEoqNny0Tid6lqW4wdywF3wpVFDB5ciHqWqEiapFMmtKtauLHv3WO7Q/uyxdpiSOVHzgLm4Fovv9PcyZQ+STaUef0LMsGv4P0xfECjVdbmd7jlv/gBUX/4VDsqmoqv3GgfpegZ3R1HkduXx04Pow57fR6KidmYlGcKNSz6chvmxiutgMNR9Sx6YP1oNHzAkf5ApuggQNe2ptKnFGuZ+mH6mjXzRqreL/brG7vMsuvRcaRm6Q//sMqrIsKrlf3YQYP7kKrHLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CXcfaW3dWUbugSefHUtpb/s4DncZt1qaRcxfgd64UDA=;
 b=eoZU274HplIlRrdVUMXupVP6PPU6BPo7EyTx6PV7JLP3v571AJY1JQoaaoxDN3PygwhCbI4a2GwFs4h2uSPR7toTGtR7i66eLVb6hnDLM6dqu/ajRqXnH4FBIT201n4w0FZABdaNK27wDuP2QxH+sordFiu8S9nv0huTKlbQWhcco8IPMKZs9VNP6PDzA9d42sORx21DgBfS8FlXMLF9V4ozHh60ZC5jN783gl8yPUxle2bhRfbCyCiiz5wXWhqvKM7IEl36nX4O3or4qcVxDIyURvLOvWaNYKLYc9y75tovmMRFWZKn9g9KGhbU/rTlbpqkCGMVKGh0IyzBmTv+3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXcfaW3dWUbugSefHUtpb/s4DncZt1qaRcxfgd64UDA=;
 b=3yNZeBhBLEqNN2wRpF3uZjuHkWKeejd0339LHvc6919JBrUXCsQWsgAhmH08P77m295+2qesaIr6MwLFESzER8UQIn6uN9YgMcOIhCArR4OSqG2XW5YfCm2QfYy+UezFsSSvpIs5xGwJu8xbfsTTN1/93rNP9KPBtx+ndNOS54E=
Received: from BN9PR03CA0070.namprd03.prod.outlook.com (2603:10b6:408:fc::15)
 by MW4PR12MB7438.namprd12.prod.outlook.com (2603:10b6:303:219::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 16:41:16 +0000
Received: from BN8NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::da) by BN9PR03CA0070.outlook.office365.com
 (2603:10b6:408:fc::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 16:41:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT082.mail.protection.outlook.com (10.13.176.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.20 via Frontend Transport; Mon, 20 Feb 2023 16:41:15 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 10:41:14 -0600
Date:   Mon, 20 Feb 2023 10:18:42 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     Borislav Petkov <bp@alien8.de>, <kvm@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
        <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        <chao.p.peng@linux.intel.com>
Subject: Re: [PATCH RFC v7 03/64] KVM: SVM: Advertise private memory support
 to KVM
Message-ID: <20230220161842.ou73dqulryed3k75@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-4-michael.roth@amd.com>
 <Y6Xd0ruz3kMij/5F@zn.tnic>
 <20230105021419.rs23nfq44rv64tsd@amd.com>
 <Y8sFnsk2GvnUCVFI@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y8sFnsk2GvnUCVFI@kernel.org>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT082:EE_|MW4PR12MB7438:EE_
X-MS-Office365-Filtering-Correlation-Id: 7be97b1f-4a5b-41c9-739e-08db1361486d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S3AtAncVSVRoe8/daDhhirQecZhqEvjg99rERb4jH6F7V/Qx+0HN5IduQaj4WTs6UhW7Xyfp3eMXlELE7EPqduV95lGqX9NOrrjK+V8tQ5WvCLrVOhTXyZOcX68QKrg9BQw79cPSbcpp6C+x6TQydfTWUanKpcL1Gq6sLm0sRgo/hWyvW7qZQMp986spLG1BzvXeqHvEq2qwhOAVRhnxMpzQN8/CiEeNszFTSBiv1BriXrUBkh07WWulVMiBwX6r4yzHeevA7kFZ1rBJepm8ztc5KrqYXMpWhveZKUm5d1HQ8YWtxNtM7u4QGpEa0eEil0NHa7IWidowFyfw+GDEGDmqctG1KzNs9FUlAnRQWunVWyW1ulmpg5zpDY7VY4izeJlbcS7Xd2KX1CZkTOlAsog2hEmk+mCsM/KMmRHIkZcKWClk/Yd4ScnG1U+PFE/QFqItbk2+EEt6awn98PAwkbLh26hBFUpuF5W8oMsLVimqTZBmOQIQusG4rx2w3IJVyiX4q7lxl3TYob6PmkMQP9FWRxNwc+wZNYdFMP+0kWxrLkjed9soracPcl+l6yZpA5VoCBPTk5tvzYIkZjfOJRFY3lsp2R0vjbrGCwsEYJ2sUVc8SEix6u2GjCX7vq8VPjbYtcn/WMfRy4VgoHSlUTRR4Vo7He4DHM9DXWzl4MGmGzcWn6oyqIFbA7kTs3TEEauWwamhoegUt27kj3spuSH42ev9uKfybdbIswfIBTU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199018)(36840700001)(46966006)(40470700004)(8936002)(2616005)(7406005)(7416002)(36860700001)(5660300002)(336012)(6916009)(4326008)(82310400005)(8676002)(70206006)(86362001)(70586007)(36756003)(83380400001)(54906003)(45080400002)(426003)(40480700001)(47076005)(316002)(478600001)(966005)(40460700003)(41300700001)(26005)(186003)(16526019)(82740400003)(356005)(2906002)(81166007)(1076003)(66899018)(6666004)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 16:41:15.0320
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7be97b1f-4a5b-41c9-739e-08db1361486d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7438
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 20, 2023 at 09:20:30PM +0000, Jarkko Sakkinen wrote:
> On Wed, Jan 04, 2023 at 08:14:19PM -0600, Michael Roth wrote:
> > On Fri, Dec 23, 2022 at 05:56:50PM +0100, Borislav Petkov wrote:
> > > On Wed, Dec 14, 2022 at 01:39:55PM -0600, Michael Roth wrote:
> > > > +       bool (*private_mem_enabled)(struct kvm *kvm);
> > > 
> > > This looks like a function returning boolean to me. IOW, you can
> > > simplify this to:
> > 
> > The semantics and existing uses of KVM_X86_OP_OPTIONAL_RET0() gave me the
> > impression it needed to return an integer value, since by default if a
> > platform doesn't implement the op it would "return 0", and so could
> > still be called unconditionally.
> > 
> > Maybe that's not actually enforced, by it seems awkward to try to use a
> > bool return instead. At least for KVM_X86_OP_OPTIONAL_RET0().
> > 
> > However, we could just use KVM_X86_OP() to declare it so we can cleanly
> > use a function that returns bool, and then we just need to do:
> > 
> >   bool kvm_arch_has_private_mem(struct kvm *kvm)
> >   {
> >           if (kvm_x86_ops.private_mem_enabled)
> >                   return static_call(kvm_x86_private_mem_enabled)(kvm);
> 
> I guess this is missing:
> 
>         return false;
> 
> >   }
> >     
> > instead of relying on default return value. So I'll take that approach
> > and adopt your other suggested changes.
> > 
> > ...
> > 
> > On a separate topic though, at a high level, this hook is basically a way
> > for platform-specific code to tell generic KVM code that private memslots
> > are supported by overriding the kvm_arch_has_private_mem() weak
> > reference. In this case the AMD platform is using using kvm->arch.upm_mode
> > flag to convey that, which is in turn set by the
> > KVM_CAP_UNMAPPED_PRIVATE_MEMORY introduced in this series.
> > 
> > But if, as I suggested in response to your PATCH 2 comments, we drop
> > KVM_CAP_UNAMMPED_PRIVATE_MEMORY in favor of
> > KVM_SET_SUPPORTED_MEMORY_ATTRIBUTES ioctl to enable "UPM mode" in SEV/SNP
> > code, then we need to rethink things a bit, since KVM_SET_MEMORY_ATTRIBUTES
> > in-part relies on kvm_arch_has_private_mem() to determine what flags are
> > supported, whereas SEV/SNP code would be using what was set by
> > KVM_SET_MEMORY_ATTRIBUTES to determine the return value in
> > kvm_arch_has_private_mem().
> 
> Does this mean that internal calls to  kvm_vm_set_region_attr() will
> cease to exist, and it will rely for user space to use the ioctl
> properly instead?

Patches 1-3 are no longer needed and have been dropped for v8, instead
"UPM mode" is set via KVM_VM_CREATE vm_type arg, and SEV/SNP can simply
call kvm_arch_has_private_mem() to query whether userspace has enabled
UPM mode or not.

But even still, we call kvm_vm_set_region_attr() in
sev_launch_update_data() and snp_launch_update() after copying initial
payload into private memory.

I don't think there's much worth in having userspace have to do it via
KVM_SET_MEMORY_ATTRIBUTES afterward. It could be done that way I suppose,
but generally RMP update from shared->private happens as part of
KVM_SET_MEMORY_ATTRIBUTES, whereas in this case it would necessarily
happen *after* the RMP updates, since SNP_LAUNCH_UPDATE expects the pages
to be marked private beforehand.

Just seems like more corner cases to deal with and more boilerplate code
for userspace, which already needed to operate under the assumption that
pages will be private after SNP_LAUNCH_UPDATE, so seems to make sense to
just have the memory attributes also updated accordingly.

-Mike
> 
> > So, for AMD, the return value of kvm_arch_has_private_mem() needs to rely
> > on something else. Maybe the logic can just be:
> > 
> >   bool svm_private_mem_enabled(struct kvm *kvm)
> >   {
> >     return sev_enabled(kvm) || sev_snp_enabled(kvm)
> >   }
> > 
> > (at least in the context of this patchset where UPM support is added for
> > both SEV and SNP).
> > 
> > So I'll plan to make that change as well.
> > 
> > -Mike
> > 
> > > 
> > > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > > index 82ba4a564e58..4449aeff0dff 100644
> > > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > > @@ -129,6 +129,7 @@ KVM_X86_OP(msr_filter_changed)
> > >  KVM_X86_OP(complete_emulated_msr)
> > >  KVM_X86_OP(vcpu_deliver_sipi_vector)
> > >  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> > > +KVM_X86_OP_OPTIONAL_RET0(private_mem_enabled);
> > >  
> > >  #undef KVM_X86_OP
> > >  #undef KVM_X86_OP_OPTIONAL
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 1da0474edb2d..1b4b89ddeb55 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1574,6 +1574,7 @@ struct kvm_x86_ops {
> > >  
> > >  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> > >  			     int root_level);
> > > +	bool (*private_mem_enabled)(struct kvm *kvm);
> > >  
> > >  	bool (*has_wbinvd_exit)(void);
> > >  
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index ce362e88a567..73b780fa4653 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -4680,6 +4680,14 @@ static int svm_vm_init(struct kvm *kvm)
> > >  	return 0;
> > >  }
> > >  
> > > +static bool svm_private_mem_enabled(struct kvm *kvm)
> > > +{
> > > +	if (sev_guest(kvm))
> > > +		return kvm->arch.upm_mode;
> > > +
> > > +	return IS_ENABLED(CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING);
> > > +}
> > > +
> > >  static struct kvm_x86_ops svm_x86_ops __initdata = {
> > >  	.name = "kvm_amd",
> > >  
> > > @@ -4760,6 +4768,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> > >  
> > >  	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
> > >  
> > > +	.private_mem_enabled = svm_private_mem_enabled,
> > > +
> > >  	.has_wbinvd_exit = svm_has_wbinvd_exit,
> > >  
> > >  	.get_l2_tsc_offset = svm_get_l2_tsc_offset,
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 823646d601db..9a1ca59d36a4 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -12556,6 +12556,11 @@ void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
> > >  }
> > >  EXPORT_SYMBOL_GPL(__x86_set_memory_region);
> > >  
> > > +bool kvm_arch_has_private_mem(struct kvm *kvm)
> > > +{
> > > +	return static_call(kvm_x86_private_mem_enabled)(kvm);
> > > +}
> > > +
> > >  void kvm_arch_pre_destroy_vm(struct kvm *kvm)
> > >  {
> > >  	kvm_mmu_pre_destroy_vm(kvm);
> > > 
> > > -- 
> > > Regards/Gruss,
> > >     Boris.
> > > 
> > > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpeople.kernel.org%2Ftglx%2Fnotes-about-netiquette&data=05%7C01%7Cmichael.roth%40amd.com%7C319e89ce555a46eace4d08dae506b51a%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638074114318137471%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=aG11K7va1BhemwlKCKKdcIXEwXGUzImYL%2BZ9%2FQ7XToI%3D&reserved=0
> 
> BR, Jarkko
