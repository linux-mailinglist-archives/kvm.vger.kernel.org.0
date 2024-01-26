Return-Path: <kvm+bounces-7143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 715FC83DB1D
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:40:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27E7B286EBC
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 13:40:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10F951BDE4;
	Fri, 26 Jan 2024 13:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Vkp8ebJL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994291BDC6;
	Fri, 26 Jan 2024 13:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706276410; cv=fail; b=NkacR5Qpe0zYGpzbM9Hh/r2B7u4PzLrttQZGFx/ltfN4HNBUNqMG07idQElbqnslFhjckUDrPx1yy/gHJ6kuE7kS94kIxB4NrECL4yxhQcQA7FlN7RouDKI7GmbY5mpUUtDP8LDV3/kRaJoWXU+OCcGaOoWrx9qCfJ6pvwgt0mw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706276410; c=relaxed/simple;
	bh=AwXi+mlub++Iu26+Id1stlbXhEq0G7wKbevcN0XhWAk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uajWXGQFZeUppWCC9ytzyR2xrMCULXu2cjhr8co4EZZNdzy1r0PZNy4VM5Isy1qM2fklg72UNNae2qY0T8SY1gRLZueIIBWwLMOZ7gE3Cxje/GLXgCvBNf+ugvCv9egyzQDLs6fNh/F4arI7ajL9LtVvD6qDpLuiTZnEFz7rhMs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Vkp8ebJL; arc=fail smtp.client-ip=40.107.243.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0YErVlVrelsdPhGmFkw8QsI689HC00vA20BElzNsTkHqa3jjKOhYb/VMbB2nkYZeW7ZRwE8V9FH+D9wc73HyPEnT0AXc2YHzzEeoy4d6U69rYls1/64/SWoibg8jQkQke1BdW5gvlkducNzexk3L+lq9Lyrf5g/rI36YNuKKbm+HQ/30wtkxmnjb3aMmCEmAlwFLe6Ldp3DeLvH8XWpJjXwVCMlF0n5NKEGBdSOsWoqay1khoWIXvom9T47OUTajgOr3sJePmNvfvESTuWMNpRNKZlikh2NEhdxcWyTEG2UyVo0/IXUPWIPX/CbRD32lTXSC4NgaR/uvBYATCxIYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LlcHzIQWz/0eKoy4EoCOMQ5SAXWAI7gq3pqhJQBubZc=;
 b=L2LOiV5TM85b9XLcoJs/XpX1FngOjtT/AkM+9RqED2LB0xcSMWyxb3QriWIy8bqmXDsfDuCpggxCjx1m4kb17YDgU8gJcnizdp/ZwamdRmO3AjEXKQQy4UDXC6fGzlojOEacnjH3ejc61BTkdsW1WSosayUqhPfBwtcBdkq2+Vct2U/YE+L9reLms8EHyu65IaWqEvFxwB3dQZ1RY7fp8QMxP72n/8ET3baPFMFarNDC+Z0M/kBQaq/JC3aDk4Wtr00Xp2gezBbLjoo0Wvoc5oxSr8FixQhbtr/6+yLYLEWUER5LIuaXcb1BgBU0kcqIrO8QBqHTaxU3Vrpr/WJEvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LlcHzIQWz/0eKoy4EoCOMQ5SAXWAI7gq3pqhJQBubZc=;
 b=Vkp8ebJLdRMUTSTx/Rfad8qO+yv1dPNZzbGQBTWPERM8/uTSY4oB11rMJfpS4FS1Fl4tn2pCGSXpksEMRC1AQZ3FvHScSgjEdTd1Z/9c8BSWOHdBLtydJb0Rl+/6wRCTbPFgSvbb1mf/acyAz2EzjCkPvAOKGZ/VtoN/mwtfe1E=
Received: from BN9PR03CA0282.namprd03.prod.outlook.com (2603:10b6:408:f5::17)
 by IA1PR12MB8496.namprd12.prod.outlook.com (2603:10b6:208:446::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 13:40:04 +0000
Received: from BN1PEPF0000468A.namprd05.prod.outlook.com
 (2603:10b6:408:f5:cafe::c) by BN9PR03CA0282.outlook.office365.com
 (2603:10b6:408:f5::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27 via Frontend
 Transport; Fri, 26 Jan 2024 13:40:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF0000468A.mail.protection.outlook.com (10.167.243.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 13:40:04 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Fri, 26 Jan
 2024 07:40:03 -0600
Date: Fri, 26 Jan 2024 07:38:10 -0600
From: Michael Roth <michael.roth@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: Re: [PATCH v1 21/26] crypto: ccp: Add panic notifier for SEV/SNP
 firmware shutdown on kdump
Message-ID: <20240126133810.whjr3wxinwyxzfgt@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-22-michael.roth@amd.com>
 <20240121114900.GLZa0ErBHIqvook5zK@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240121114900.GLZa0ErBHIqvook5zK@fat_crate.local>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468A:EE_|IA1PR12MB8496:EE_
X-MS-Office365-Filtering-Correlation-Id: 78aed9d4-f3cf-45bf-f12e-08dc1e744d47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CVkXabAfi3or5k0wQLNHvMlyWPAlkDQLOkIDwpq1Xl9assWEqA37soOcka1kZMEJoGygWar3VWCGGWLpQzM6oMhZndrdLnAMdVXsPKHFZxOkNT/PcIaE+f4Zm60Ie9EyfkyGUNjoUbuQDBpeERHQGjx/lB926v2FEyY4EJfABqiFT2CB0fixPeurXZlbfMAMlwuuq+dZyt9eWs5yUzRfCbJ9kyY1q0RxuKgj6DXrpOYyizOi6eHae/M6uCNdRDM6xURBpyr8tblKmtcYTCUv5YQpYR3C21pyTlrIrt5IPXqePKZaFvMjUTVWxkM+ZUFINHRSH0ghmTGN/UEIiza9yM7k9X7VNIOEBlsgzgjcXJqlxzhQZqgrm1QPZXjLMAR13KNocEIgnoy3WzUaLRUg6bLKgkvm8hcidmJGQ+WghgCKGj6jmSukATbVFIU/6xjjpN1y0g+Bw8mfryyhHxp311TGyngMPBA5G+5cNPDuAUdBTVJQ4eXhwaqmHkGnKpU0WcD60B6Z6CYVpMT7Hu0XWyb/lLIkHm3U5HcYXvpLDd2hXUjFVVo0ljLNnDUycldn832gw/aEnOc1VmwHGoQqyfZ/LSSdn/tMCwIG5sRqttn5d5u1A3N3D8CBZA2TBWH0WoWlck6erCWmIfdbu85sDpSoiRdSLEsenDrZBjRFaws7lIfvcSYfeW7pA1P95xF1VSk3ALPrc4K9Q4pAndYrNvU8fClE3Ax81HI74khJId/lG6itZNVX2YrqHoUU1GD9cRp1YugrYx4owC4mGhwQqp0kHvc25HW2sc+s7DsNaifw17pKHpKE9lC525CgceLz
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(396003)(136003)(346002)(230922051799003)(230173577357003)(230273577357003)(64100799003)(186009)(1800799012)(82310400011)(451199024)(46966006)(40470700004)(36840700001)(966005)(82740400003)(7406005)(356005)(2906002)(7416002)(36860700001)(81166007)(5660300002)(44832011)(41300700001)(36756003)(426003)(336012)(26005)(16526019)(478600001)(1076003)(2616005)(6666004)(83380400001)(8676002)(4326008)(47076005)(8936002)(6916009)(54906003)(316002)(70206006)(70586007)(86362001)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 13:40:04.0742
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78aed9d4-f3cf-45bf-f12e-08dc1e744d47
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8496

On Sun, Jan 21, 2024 at 12:49:00PM +0100, Borislav Petkov wrote:
> On Sat, Dec 30, 2023 at 10:19:49AM -0600, Michael Roth wrote:
> > From: Ashish Kalra <ashish.kalra@amd.com>
> > 
> > Add a kdump safe version of sev_firmware_shutdown() registered as a
> > crash_kexec_post_notifier, which is invoked during panic/crash to do
> > SEV/SNP shutdown. This is required for transitioning all IOMMU pages
> > to reclaim/hypervisor state, otherwise re-init of IOMMU pages during
> > crashdump kernel boot fails and panics the crashdump kernel. This
> > panic notifier runs in atomic context, hence it ensures not to
> > acquire any locks/mutexes and polls for PSP command completion
> > instead of depending on PSP command completion interrupt.
> > 
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > [mdr: remove use of "we" in comments]
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> 
> Cleanups ontop, see if the below works too. Especially:
> 
> * I've zapped the WBINVD before the TMR pages are freed because
> __sev_snp_shutdown_locked() will WBINVD anyway.

As Ashish mentioned the wbinvd_on_all_cpus() is still needed for general
TMR handling even outside of panic/SNP, but I think you're right about
the panic==true where the handling is SNP-specific and so the wbinvd()
that gets called later during SNP shutdown will take care of it, so I've
adjusted things accordingly.

> 
> * The mutex_is_locked() check in snp_shutdown_on_panic() is silly
> because the panic notifier runs on one CPU anyway.

Based on discussion with Ashish I've updated the comments in v2
regarding this to make it a little clearer why it might still be a good
idea to keep that in to avoid weird unexpected behavior if we try to
issue PSP commands while another one was already in-flight by another
task before the panic.

But I squashed in all the other changes here as-is.

-Mike

> 
> Thx.
> 
> ---
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 435ba9bc4510..27323203e593 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -227,6 +227,7 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
>  void snp_accept_memory(phys_addr_t start, phys_addr_t end);
>  u64 snp_get_unsupported_features(u64 status);
>  u64 sev_get_status(void);
> +void kdump_sev_callback(void);
>  #else
>  static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>  static inline void sev_es_ist_exit(void) { }
> @@ -255,6 +256,7 @@ static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *in
>  static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
>  static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
>  static inline u64 sev_get_status(void) { return 0; }
> +static inline void kdump_sev_callback(void) {  }
>  #endif
>  
>  #ifdef CONFIG_KVM_AMD_SEV
> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index 23ede774d31b..64ae3a1e5c30 100644
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -40,6 +40,7 @@
>  #include <asm/intel_pt.h>
>  #include <asm/crash.h>
>  #include <asm/cmdline.h>
> +#include <asm/sev.h>
>  
>  /* Used while preparing memory map entries for second kernel */
>  struct crash_memmap_data {
> @@ -59,12 +60,7 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
>  	 */
>  	cpu_emergency_stop_pt();
>  
> -	/*
> -	 * for SNP do wbinvd() on remote CPUs to
> -	 * safely do SNP_SHUTDOWN on the local CPU.
> -	 */
> -	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> -		wbinvd();
> +	kdump_sev_callback();
>  
>  	disable_local_APIC();
>  }
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index c67285824e82..dbb2cc6b5666 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -2262,3 +2262,13 @@ static int __init snp_init_platform_device(void)
>  	return 0;
>  }
>  device_initcall(snp_init_platform_device);
> +
> +void kdump_sev_callback(void)
> +{
> +	/*
> +	 * Do wbinvd() on remote CPUs when SNP is enabled in order to
> +	 * safely do SNP_SHUTDOWN on the the local CPU.
> +	 */
> +	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		wbinvd();
> +}
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 598878e760bc..c342e5e54e45 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -161,7 +161,6 @@ static int sev_wait_cmd_ioc(struct sev_device *sev,
>  
>  			udelay(10);
>  		}
> -
>  		return -ETIMEDOUT;
>  	}
>  
> @@ -1654,7 +1653,7 @@ static int sev_update_firmware(struct device *dev)
>  	return ret;
>  }
>  
> -static int __sev_snp_shutdown_locked(int *error, bool in_panic)
> +static int __sev_snp_shutdown_locked(int *error, bool panic)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_data_snp_shutdown_ex data;
> @@ -1673,7 +1672,7 @@ static int __sev_snp_shutdown_locked(int *error, bool in_panic)
>  	 * In that case, a wbinvd() is done on remote CPUs via the NMI
>  	 * callback, so only a local wbinvd() is needed here.
>  	 */
> -	if (!in_panic)
> +	if (!panic)
>  		wbinvd_on_all_cpus();
>  	else
>  		wbinvd();
> @@ -2199,26 +2198,13 @@ int sev_dev_init(struct psp_device *psp)
>  	return ret;
>  }
>  
> -static void __sev_firmware_shutdown(struct sev_device *sev, bool in_panic)
> +static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
>  {
>  	int error;
>  
>  	__sev_platform_shutdown_locked(NULL);
>  
>  	if (sev_es_tmr) {
> -		/*
> -		 * The TMR area was encrypted, flush it from the cache
> -		 *
> -		 * If invoked during panic handling, local interrupts are
> -		 * disabled and all CPUs are stopped, so wbinvd_on_all_cpus()
> -		 * can't be used. In that case, wbinvd() is done on remote CPUs
> -		 * via the NMI callback, so a local wbinvd() is sufficient here.
> -		 */
> -		if (!in_panic)
> -			wbinvd_on_all_cpus();
> -		else
> -			wbinvd();
> -
>  		__snp_free_firmware_pages(virt_to_page(sev_es_tmr),
>  					  get_order(sev_es_tmr_size),
>  					  true);
> @@ -2237,7 +2223,7 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool in_panic)
>  		snp_range_list = NULL;
>  	}
>  
> -	__sev_snp_shutdown_locked(&error, in_panic);
> +	__sev_snp_shutdown_locked(&error, panic);
>  }
>  
>  static void sev_firmware_shutdown(struct sev_device *sev)
> @@ -2262,26 +2248,18 @@ void sev_dev_destroy(struct psp_device *psp)
>  	psp_clear_sev_irq_handler(psp);
>  }
>  
> -static int sev_snp_shutdown_on_panic(struct notifier_block *nb,
> -				     unsigned long reason, void *arg)
> +static int snp_shutdown_on_panic(struct notifier_block *nb,
> +				 unsigned long reason, void *arg)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  
> -	/*
> -	 * Panic callbacks are executed with all other CPUs stopped,
> -	 * so don't wait for sev_cmd_mutex to be released since it
> -	 * would block here forever.
> -	 */
> -	if (mutex_is_locked(&sev_cmd_mutex))
> -		return NOTIFY_DONE;
> -
>  	__sev_firmware_shutdown(sev, true);
>  
>  	return NOTIFY_DONE;
>  }
>  
> -static struct notifier_block sev_snp_panic_notifier = {
> -	.notifier_call = sev_snp_shutdown_on_panic,
> +static struct notifier_block snp_panic_notifier = {
> +	.notifier_call = snp_shutdown_on_panic,
>  };
>  
>  int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
> @@ -2322,7 +2300,7 @@ void sev_pci_init(void)
>  		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
>  
>  	atomic_notifier_chain_register(&panic_notifier_list,
> -				       &sev_snp_panic_notifier);
> +				       &snp_panic_notifier);
>  	return;
>  
>  err:
> @@ -2339,5 +2317,5 @@ void sev_pci_exit(void)
>  	sev_firmware_shutdown(sev);
>  
>  	atomic_notifier_chain_unregister(&panic_notifier_list,
> -					 &sev_snp_panic_notifier);
> +					 &snp_panic_notifier);
>  }
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 

