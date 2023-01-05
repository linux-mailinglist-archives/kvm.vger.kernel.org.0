Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEB165E32E
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 04:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjAEDAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 22:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbjAEC7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 21:59:40 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000DB48813;
        Wed,  4 Jan 2023 18:59:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bfNUnakWROW2uXP4b7sizt9YLTSQa7tp2JoN/r0GnoO+8hIWen3+QMyARbEaBhuMKAEALNI+5yxoB7lU0n22QJxwOhNXLPd0AQQFkKGr4RQlDbcm5gOHHwxDRM0sWP266aaaOa42ipSVrHv75dJ7VWhruBaQLYMFKIqQc/iATHNApjIxwyvYlrQ/7M6F4l1PBWfhIA+B0m8O96upipLozD0g361o1ljgLzIilWnQXC0rMFcwQhYuiuWoOg9qq8kp0jBfnkv3CvUHF/nYnPTzgku8j2QE8CYVBdrdkr8S7rfJg6cwcVXpHChCLhTHbp5d9tkU+HK+noPNnJHWIGllVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Etiha6mrY5MobFODUeDigkOVapbr19a5Ddw/wk1ET9M=;
 b=HZ7Q0MNU4DRAzOy+5QV92WqTPkC5msoEUS09+7qF6/6mg3sF0T9zSDcSon7M2eApgWnPFhfdWCOaNH/CzIDHMTw/a4YXfxdPzNsVPxppJhwf7z+L3OnIbLEV4MiZybK+beYw3XwRbmy3vIJDdkGPGgZYZfMF5gDv3LusnQtYLh0ZGtQuVUqV7F8I8HZwiMLxBJO5ByzK6byoIrQRBhZMKxxP6D147vqcdjHTdF6bJeurpI1iFd37r8BtLoVl9opEuGJwm4yUPefhbsSArP6CSN35ds+j9ecnkzp0YMm46oBHcsaGJhYMQSZyAUi1MehCQfj92bW8y36o05hnuju7Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Etiha6mrY5MobFODUeDigkOVapbr19a5Ddw/wk1ET9M=;
 b=NZc8Jf6rKyX0+U9b4JlgpjGCpr9IasxMEkEne3ujF2NpPD+Y7nHQWVl3RIJddDZLX89W8OrcEKKmswynQfI9yNCxHNH/YU89+Dg4Sge/68rSRSP7wx2p4kNvBl4B8CXDCih95k0GNr8Ym3kg1ssKi8kHYs5mYqmOV02cFQb6eO8=
Received: from DS7PR03CA0149.namprd03.prod.outlook.com (2603:10b6:5:3b4::34)
 by DM4PR12MB7597.namprd12.prod.outlook.com (2603:10b6:8:10b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 02:59:31 +0000
Received: from DM6NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::e5) by DS7PR03CA0149.outlook.office365.com
 (2603:10b6:5:3b4::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.14 via Frontend
 Transport; Thu, 5 Jan 2023 02:59:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT077.mail.protection.outlook.com (10.13.173.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5966.17 via Frontend Transport; Thu, 5 Jan 2023 02:59:31 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 4 Jan
 2023 20:59:30 -0600
Date:   Wed, 4 Jan 2023 20:42:56 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
        <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>
Subject: Re: [PATCH RFC v7 04/64] KVM: x86: Add 'fault_is_private' x86 op
Message-ID: <20230105024256.ptujtjgzcdmpakoa@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-5-michael.roth@amd.com>
 <Y628y6hQK38+IAev@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y628y6hQK38+IAev@zn.tnic>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT077:EE_|DM4PR12MB7597:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a75909d-1a81-49b7-a77c-08daeec8ddfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j6SErKFvRLASvtp+h7qfvib0JdrVDB51Oe8+yADXAZfcOQoRE2f9Uys++fW2zz/ISPSBgOObVWOEw3cKdm3wE3oznPjCzXqqroQq5QYkSNO4N/LgYpnd1nrDabJDS41XasKO+ZGhsCcl5K4kYx8MpzqTNXz0z/qiN+irviCLky2bdQzAYJpHNS30tWbvRjhHEfpm+cCsokuf9LTN9eLXnBli/IBSAzU2QFdrH1KkYxF1KzEvjoeJEgSxndNiqhQHHE+pilSjBLxfmqocXia2cs0OBpUc2U1u2XyN/E5lNS5PyARtVGBPa8SR7ODDeAH+V3N984V4l/2FqrFYRY8AyAim+b62dG1cOTnKHzzXZ1eawB9wa24PnBKNqrPZohmpBld6gRPjxWXVFeacXnHjWOm8mOj+2+l4BiDvDyouyOqbQf5OcpV6T6ssZK/OmBQ1qzKvY6dvBDNzQXQkca7OjR3pOTxQjtxdWmIZACZV/dV6J7R5JMwdA1KELlWjtQ9RLK7a35uCJWpJxuka6ryCR6wQVZAujMPH8exBfXlm6GK45JibscPHqx7pwgqnAaZ2xksTmkTabPT9YHDMRzzCGG5+x02i+uaZuT4MkZXTfPPCCuXxR9yhM1gXgYBH9CMACz7Yr5pmWb3o5vm4IuEg9UDGHcmhMIqQu4qSp026qQJIejsII9VjBNODZUs7SKNYJjCtQgJh/67TbYLAlN7DIYmCOFyuUxVd2yh9KUjbrme2epuo93RVNZ3f2GtUZIKyOBZMiMhWREi02NuOyC2Jfg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(136003)(346002)(451199015)(46966006)(36840700001)(40470700004)(44832011)(7416002)(41300700001)(7406005)(8676002)(70206006)(4326008)(8936002)(70586007)(54906003)(2906002)(316002)(478600001)(26005)(966005)(3716004)(186003)(6916009)(16526019)(5660300002)(6666004)(2616005)(86362001)(40480700001)(426003)(1076003)(83380400001)(47076005)(36860700001)(336012)(82740400003)(356005)(36756003)(40460700003)(82310400005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 02:59:31.0848
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a75909d-1a81-49b7-a77c-08daeec8ddfb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7597
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 29, 2022 at 05:14:03PM +0100, Borislav Petkov wrote:
> On Wed, Dec 14, 2022 at 01:39:56PM -0600, Michael Roth wrote:
> > This callback is used by the KVM MMU to check whether a #NPF was
> > or a private GPA or not.
> 
> s/or //
> 
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  arch/x86/include/asm/kvm-x86-ops.h |  1 +
> >  arch/x86/include/asm/kvm_host.h    |  1 +
> >  arch/x86/kvm/mmu/mmu.c             |  3 +--
> >  arch/x86/kvm/mmu/mmu_internal.h    | 40 +++++++++++++++++++++++++++---
> >  4 files changed, 39 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index f530a550c092..efae987cdce0 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -132,6 +132,7 @@ KVM_X86_OP(complete_emulated_msr)
> >  KVM_X86_OP(vcpu_deliver_sipi_vector)
> >  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> >  KVM_X86_OP_OPTIONAL_RET0(private_mem_enabled);
> > +KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
> >  
> >  #undef KVM_X86_OP
> >  #undef KVM_X86_OP_OPTIONAL
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 9317abffbf68..92539708f062 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1636,6 +1636,7 @@ struct kvm_x86_ops {
> >  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> >  			     int root_level);
> >  	int (*private_mem_enabled)(struct kvm *kvm);
> > +	int (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
> 
> bool
> 
> and then you don't need the silly "== 1" at the call site.

Obviously I need to add some proper documentation for this, but a 1
return basically means 'private_fault' pass-by-ref arg has been set
with the appropriate value, whereas 0 means "there's no platform-specific
handling for this, so if you have some generic way to determine this
then use that instead".

This is mainly to handle CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING, which
just parrots whatever kvm_mem_is_private() returns to support running
KVM selftests without needed hardware/platform support. If we don't
take care to skip this check where the above fault_is_private() hook
returns 1, then it ends up breaking SNP in cases where the kernel has
been compiled with CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING, since SNP
relies on the page fault flags to make this determination, not
kvm_mem_is_private(), which normally only tracks the memory attributes
set by userspace via KVM_SET_MEMORY_ATTRIBUTES ioctl.

> 
> >  
> >  	bool (*has_wbinvd_exit)(void);
> 
> ...
> 
> > @@ -261,13 +293,13 @@ enum {
> >  };
> >  
> >  static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> > -					u32 err, bool prefetch)
> > +					u64 err, bool prefetch)
> 
> The u32 -> u64 change of err could use a sentence or two of
> clarification in the commit message...

Will do.

-Mike

> 
> >  {
> >  	bool is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault);
> >  
> >  	struct kvm_page_fault fault = {
> >  		.addr = cr2_or_gpa,
> > -		.error_code = err,
> > +		.error_code = lower_32_bits(err),
> >  		.exec = err & PFERR_FETCH_MASK,
> >  		.write = err & PFERR_WRITE_MASK,
> >  		.present = err & PFERR_PRESENT_MASK,
> > @@ -281,8 +313,8 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> >  		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
> >  		.req_level = PG_LEVEL_4K,
> >  		.goal_level = PG_LEVEL_4K,
> > -		.is_private = IS_ENABLED(CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING) && is_tdp &&
> > -				kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
> > +		.is_private = is_tdp && kvm_mmu_fault_is_private(vcpu->kvm,
> > +								 cr2_or_gpa, err),
> >  	};
> >  	int r;
> >  
> > -- 
> > 2.25.1
> > 
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
