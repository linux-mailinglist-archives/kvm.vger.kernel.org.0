Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6374365E322
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 03:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjAEC7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 21:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjAEC7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 21:59:08 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A050479D8;
        Wed,  4 Jan 2023 18:58:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqXHJCvYK0IWgEGW4Io9DESnUMtQcZAG65qZsplRBeZLZhCvMGcgrBkaDP4nI5vD17rI3yKRfq/XJyZi+O9ruhkqpRHEsp6PJNv8Tbq1UP+XhDEFIEog3NxfZMUFSWAlcnWwtwOZWiLeEg9t5IPTd3C5h8HLEEHnVvW3sdy4ByrcYvfxOJIkl4XDIF2EMaKjJgCS+CkrTJ76DMbABgMw4/ZZS7TJBO/+M4IxiNWZDbH1zPhGmrMGU6AYsZ9YwmPAm2lLnqX4eUIiUxuBepa5G8ISfFolHbm+IcA6yxBh8qCXBTjkfzzYBzdZm25CpKyyORSWWa/3n38iw8B/YpCYDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vzQWUHh4OMpPiGUZLEMyNhc3Ivspnwyi2XUfByRKCtI=;
 b=LrM1cgu5i8d6iIoZc7r21hrS+3rn6MQWuH/WFjJLRR5fyhgCulxyW7rmt/r7CXFhh6zAtSoAYLEpHbd3sU5OonSsZgqvOwRVUwXiEqpAQqRMM1eJhYOPgPp+NZI7nw1M0/Vt21EYIJiIGC6wpHElOr9WCGSZR0j6p7HQfA0GM96OPNOvkUxPzTc/gXrWRkvoZ7BOVS5RXHBb50PaL+qgw1ldAJWxhfO9a47m/edNGGN51SE6A5+fefdiyD/NLlXS3abU6y6UBnzKfePpkskS96WIxv0h8tkRLeqqrZ5RuUU4bwFbZU8uJ04CGvwA3i4AssHtN1u13+ja+GmCahQkEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzQWUHh4OMpPiGUZLEMyNhc3Ivspnwyi2XUfByRKCtI=;
 b=btsPE/tLHBymOZExD+HruuWk8ItQ7lyTI8/hkosmnoKTO3V+B5YjtR6lgxdGJFTVyP277g96I824ISJ56n8+2mviw2wNayukj/ax7p2XNqtZuZMW1192S6OOKXVWMjTfhhIMhytspzec9vr5/UO9pmN+P3GIS0i+m8igTRzyBJ8=
Received: from DS7PR03CA0283.namprd03.prod.outlook.com (2603:10b6:5:3ad::18)
 by PH7PR12MB6659.namprd12.prod.outlook.com (2603:10b6:510:210::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 5 Jan
 2023 02:58:50 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::55) by DS7PR03CA0283.outlook.office365.com
 (2603:10b6:5:3ad::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.14 via Frontend
 Transport; Thu, 5 Jan 2023 02:58:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5944.10 via Frontend Transport; Thu, 5 Jan 2023 02:58:48 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 4 Jan
 2023 20:58:47 -0600
Date:   Wed, 4 Jan 2023 20:14:19 -0600
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
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        <chao.p.peng@linux.intel.com>
Subject: Re: [PATCH RFC v7 03/64] KVM: SVM: Advertise private memory support
 to KVM
Message-ID: <20230105021419.rs23nfq44rv64tsd@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-4-michael.roth@amd.com>
 <Y6Xd0ruz3kMij/5F@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y6Xd0ruz3kMij/5F@zn.tnic>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT047:EE_|PH7PR12MB6659:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e2bb015-12a1-4e11-80f6-08daeec8c4a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K0q9mepyHcg3Sa9ZpgDZAicgPI799VHeqjwWIzlqSdOpdCttPhcUQcHavoOMH+cqhNtGm8MZmNHRyBP8YMdBfe3JcQYsI9V/f5uc9Lwi3p8OrV6eo6ce+qROIJjhS+rRZOf7Lw8l+CnlCwlCpPa3jK5mDSjChQCSEQc1lV4erW8EaM3eK5ehvTj2E+MpDfHmj83WAPQ3XPJXWYE7lZ1qZslXwwOYRCXI5ymT5cxMaXX3u0Dxph0O7tNyBO2yPHL1DO55rLMachlpCSbhWLnBbS2MbbQWT4bBQoViahH+WSOMCVYd8rcsJAF2mgmSE8upRZT8MnreRmKuG2p4uyhdR/V0liwtu9YvbsjfBcTRTQJd/QVMtetCnz5TfdfO94Jf8By77W+B8Eks1hBfRwAl/oYm4lTwhI5D7x5x0GNMI538hZ9MfShjHbVQrBISBRG3VHhdkX0ovcv75Ge4z9ZgVduWIdRejRxTFDxggWsRtOaHv7z70acNgLJDHOYm+xh2lNG2z2HGEPHxN0y5fwXalb2i12/6CRtI4izggpk8vkvbT4YTul5jw1fgHBkh+5+ILPdGemwIJbeAnDAwF1Qzhugjb6cZVE+fLzQfAz+IZiH3ccQoywi9IdnmS1KZQXYthWN8mr9WtvNgGC7SiFLGsYb45s/0zUgLBl3B/dCz+VXbW0WDhQZ3QphQig/EP2tf49G1zOaJx05/cUB8dpW18dQRzTxOXzWS+TUvHMUhlklB6+SexDFnBu98EaDNGbZGRTZ+70JT1ru8+ftFcBBiMg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39860400002)(376002)(451199015)(40470700004)(46966006)(36840700001)(40480700001)(41300700001)(316002)(82740400003)(8936002)(70206006)(70586007)(356005)(5660300002)(7406005)(4326008)(86362001)(81166007)(6916009)(54906003)(7416002)(44832011)(8676002)(2906002)(2616005)(26005)(40460700003)(47076005)(16526019)(1076003)(336012)(45080400002)(426003)(36756003)(186003)(36860700001)(966005)(82310400005)(478600001)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 02:58:48.5353
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e2bb015-12a1-4e11-80f6-08daeec8c4a1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6659
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 23, 2022 at 05:56:50PM +0100, Borislav Petkov wrote:
> On Wed, Dec 14, 2022 at 01:39:55PM -0600, Michael Roth wrote:
> > +       bool (*private_mem_enabled)(struct kvm *kvm);
> 
> This looks like a function returning boolean to me. IOW, you can
> simplify this to:

The semantics and existing uses of KVM_X86_OP_OPTIONAL_RET0() gave me the
impression it needed to return an integer value, since by default if a
platform doesn't implement the op it would "return 0", and so could
still be called unconditionally.

Maybe that's not actually enforced, by it seems awkward to try to use a
bool return instead. At least for KVM_X86_OP_OPTIONAL_RET0().

However, we could just use KVM_X86_OP() to declare it so we can cleanly
use a function that returns bool, and then we just need to do:

  bool kvm_arch_has_private_mem(struct kvm *kvm)
  {
          if (kvm_x86_ops.private_mem_enabled)
                  return static_call(kvm_x86_private_mem_enabled)(kvm);
  }
    
instead of relying on default return value. So I'll take that approach
and adopt your other suggested changes.

...

On a separate topic though, at a high level, this hook is basically a way
for platform-specific code to tell generic KVM code that private memslots
are supported by overriding the kvm_arch_has_private_mem() weak
reference. In this case the AMD platform is using using kvm->arch.upm_mode
flag to convey that, which is in turn set by the
KVM_CAP_UNMAPPED_PRIVATE_MEMORY introduced in this series.

But if, as I suggested in response to your PATCH 2 comments, we drop
KVM_CAP_UNAMMPED_PRIVATE_MEMORY in favor of
KVM_SET_SUPPORTED_MEMORY_ATTRIBUTES ioctl to enable "UPM mode" in SEV/SNP
code, then we need to rethink things a bit, since KVM_SET_MEMORY_ATTRIBUTES
in-part relies on kvm_arch_has_private_mem() to determine what flags are
supported, whereas SEV/SNP code would be using what was set by
KVM_SET_MEMORY_ATTRIBUTES to determine the return value in
kvm_arch_has_private_mem().

So, for AMD, the return value of kvm_arch_has_private_mem() needs to rely
on something else. Maybe the logic can just be:

  bool svm_private_mem_enabled(struct kvm *kvm)
  {
    return sev_enabled(kvm) || sev_snp_enabled(kvm)
  }

(at least in the context of this patchset where UPM support is added for
both SEV and SNP).

So I'll plan to make that change as well.

-Mike

> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 82ba4a564e58..4449aeff0dff 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -129,6 +129,7 @@ KVM_X86_OP(msr_filter_changed)
>  KVM_X86_OP(complete_emulated_msr)
>  KVM_X86_OP(vcpu_deliver_sipi_vector)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> +KVM_X86_OP_OPTIONAL_RET0(private_mem_enabled);
>  
>  #undef KVM_X86_OP
>  #undef KVM_X86_OP_OPTIONAL
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1da0474edb2d..1b4b89ddeb55 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1574,6 +1574,7 @@ struct kvm_x86_ops {
>  
>  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  			     int root_level);
> +	bool (*private_mem_enabled)(struct kvm *kvm);
>  
>  	bool (*has_wbinvd_exit)(void);
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ce362e88a567..73b780fa4653 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4680,6 +4680,14 @@ static int svm_vm_init(struct kvm *kvm)
>  	return 0;
>  }
>  
> +static bool svm_private_mem_enabled(struct kvm *kvm)
> +{
> +	if (sev_guest(kvm))
> +		return kvm->arch.upm_mode;
> +
> +	return IS_ENABLED(CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING);
> +}
> +
>  static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.name = "kvm_amd",
>  
> @@ -4760,6 +4768,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  
>  	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
>  
> +	.private_mem_enabled = svm_private_mem_enabled,
> +
>  	.has_wbinvd_exit = svm_has_wbinvd_exit,
>  
>  	.get_l2_tsc_offset = svm_get_l2_tsc_offset,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 823646d601db..9a1ca59d36a4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12556,6 +12556,11 @@ void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
>  }
>  EXPORT_SYMBOL_GPL(__x86_set_memory_region);
>  
> +bool kvm_arch_has_private_mem(struct kvm *kvm)
> +{
> +	return static_call(kvm_x86_private_mem_enabled)(kvm);
> +}
> +
>  void kvm_arch_pre_destroy_vm(struct kvm *kvm)
>  {
>  	kvm_mmu_pre_destroy_vm(kvm);
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpeople.kernel.org%2Ftglx%2Fnotes-about-netiquette&data=05%7C01%7Cmichael.roth%40amd.com%7C319e89ce555a46eace4d08dae506b51a%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638074114318137471%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=aG11K7va1BhemwlKCKKdcIXEwXGUzImYL%2BZ9%2FQ7XToI%3D&reserved=0
