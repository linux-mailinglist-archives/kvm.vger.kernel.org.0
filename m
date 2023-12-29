Return-Path: <kvm+bounces-5353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A3C79820743
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:26:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22ED11F211FF
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:26:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55037BE5D;
	Sat, 30 Dec 2023 16:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NnAClNgM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DF7B677;
	Sat, 30 Dec 2023 16:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YPOf6fMAShQ2Fs8outixyzMxVlCvBH8YFf2EKJK5qPCDvw2Ad1Yj0ATxhuFKYUq/Iq6zwhibslcfIjdsQ9cqkuIpbt93xdAq8mlUyZBzYR7XSAOAox0ReGzV1w1QhEv15xlJFa2QUArwcDj/VgorWgi3QhfyAR7pv8PAJ0Hft2T003TdGB/gdQ6gIoyStDOFAoF8qgY9H+dz+wOoUXWaAkcyO8d38egp2g2Ryu8dJ0/CuRn5zOzx7k6Gmv2w0zZxnQFC2e6xGBOIHDwsxnt09IPu9HS/0UEqq6aopKr+iOdPaMbFOWPqVjkqqKeHXkiB/qJ3yijvQp/YuqwaVHRGBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z35AkOsqk07RoliVu+UAgy3IR31M0OkEZ+CYlbdsl+c=;
 b=NjYomt+urky1qad+S18t7tAeIdNL1O46FoNeVuvgP3rLgsb/upWuyZFvFscL5DVTGOVkvEJTT5IrhHUQ7A35OPS7ifDSwZxTxdaVwddUbqEzSv7yz56d2ZkxZP5RRTwouq2+K7YR14Gy1aripkpkbcBtQPbazrQaPHDymF14caz/zkZdm6uvDhNEC9pmOUOZb2+YQwTKBszy7bYQR/sHw1WbamLqsMwdcAF5vJy6d90s6O7Gi4LfjTABB/XRK4UQxs1zHXq8U78UOSom/mHCYkz850uxYb6N8/8D1KlZZLC6m6WYXyrsdLl9zZT+lStlHX0TCHqXUfNtJ2zNaSH/xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z35AkOsqk07RoliVu+UAgy3IR31M0OkEZ+CYlbdsl+c=;
 b=NnAClNgM0qlpyGx/48hxkzUCWe0XM19WqScQAmyC3SPEfK6PfMm8CBxUo38nCYPMQsSSOIztxo9uXUbw9Qd2mRViCwxVtPeQIciSsSgpCjGzv31tyY9pbCgD+IQD/qHSKaA1rsqLXbwBtsNb6kJv5AnAqRJCqES9Q9grklYbWzE=
Received: from DM6PR08CA0045.namprd08.prod.outlook.com (2603:10b6:5:1e0::19)
 by MW3PR12MB4396.namprd12.prod.outlook.com (2603:10b6:303:59::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 16:24:54 +0000
Received: from DS1PEPF0001709B.namprd05.prod.outlook.com
 (2603:10b6:5:1e0:cafe::e9) by DM6PR08CA0045.outlook.office365.com
 (2603:10b6:5:1e0::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.21 via Frontend
 Transport; Sat, 30 Dec 2023 16:24:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0001709B.mail.protection.outlook.com (10.167.18.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:24:54 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:24:53 -0600
Date: Fri, 29 Dec 2023 15:40:30 -0600
From: Michael Roth <michael.roth@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
	<tony.luck@intel.com>, <marcorr@google.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: Re: [PATCH v10 20/50] KVM: SEV: Select CONFIG_KVM_SW_PROTECTED_VM
 when CONFIG_KVM_AMD_SEV=y
Message-ID: <20231229214030.wkijqtvpmmkwayfk@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-21-michael.roth@amd.com>
 <20231218101350.GAZYAbXqYLXByk5Akw@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231218101350.GAZYAbXqYLXByk5Akw@fat_crate.local>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709B:EE_|MW3PR12MB4396:EE_
X-MS-Office365-Filtering-Correlation-Id: 779e08b7-acfc-46a4-93fb-08dc0953dafe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fFMzFyZJvQTnKEiGfjINvIW4+RRu96n8BgoOn6XOeBZ6FJ5yoIeJiFEu2XxImDN9lcSfVTAFCbh3VTMdtJvZpFFQouQEwF9R4sAjip2BjGYLYUDBauDFCoWLK7wYauB5vqN0bP/Zq8PrVgFvw821x3Y2iB2hQc9EPyJisu+E1PiFduY+Qgg/Pp2lW5zJvYdWNSZ5gF3wF5A0nNJKKlxIZRv+Wr+CGqo7oR1WmodNjN/iPMd9uBDe3I0D4HdLYKNLlNlp2m3dsYRvRWgbDJYtT1zt+2lTGxVDDsDe3ICuF/AMLeous9ejYUZCq+IRo94826a/nWVP/k7+AersK+X2UejROFb8eVdnINDySYk+KJnSRDreTxHyWmXSWKsF+CsODv4e/xBmgG19lcegzjMS/ojY9ZBetjC6eaf7eQbR1Ru5boP/Ln63DY6XAXvGtW7+NeId0wIaroa4T4/xEhQic3pX1rp1Zh6C4iSEL1KgAg4x/Ht7pLKOn3idLw+YoGRhjyqh5S8GIwnq/8LvDyfAeFn1+njVnXKsDLVrMAWbsT5FrPk9daX6bmbYdCr1kHqtdt4KdqbdU2FgHX/pN67yG0gvGERFoAcBK8ZF7TAPdDSc/BPIzIu1jiJMOW+WdzzpfpBIBGThoz5eBtEsTa0H4v3X37cgQ4fAHCDOQNE7JzikX54yyDPpdU/nOD9l5M6OpGi73/WZ9OXgpCcT2GbLqCVSacew0bal4LxWuO5c/mSaBnkMjNy0M80UoPc47TsqaC+qxVljbqxyaL8Ur+FwU12Vly9EaE0Y7sZMrfFPZRUG09SmN6hfMkfPNT4++5pz
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(346002)(376002)(396003)(230173577357003)(230273577357003)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(82310400011)(40470700004)(36840700001)(46966006)(40480700001)(40460700003)(426003)(336012)(2616005)(1076003)(16526019)(83380400001)(26005)(86362001)(81166007)(36756003)(356005)(82740400003)(47076005)(4326008)(44832011)(7406005)(5660300002)(7416002)(36860700001)(6666004)(54906003)(8936002)(70586007)(70206006)(8676002)(316002)(6916009)(3716004)(2906002)(41300700001)(966005)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:24:54.0195
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 779e08b7-acfc-46a4-93fb-08dc0953dafe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4396

On Mon, Dec 18, 2023 at 11:13:50AM +0100, Borislav Petkov wrote:
> On Mon, Oct 16, 2023 at 08:27:49AM -0500, Michael Roth wrote:
> > SEV-SNP relies on the restricted/protected memory support to run guests,
> > so make sure to enable that support with the
> > CONFIG_KVM_SW_PROTECTED_VM build option.
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  arch/x86/kvm/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index 8452ed0228cb..71dc506aa3fb 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -126,6 +126,7 @@ config KVM_AMD_SEV
> >  	bool "AMD Secure Encrypted Virtualization (SEV) support"
> >  	depends on KVM_AMD && X86_64
> >  	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
> > +	select KVM_SW_PROTECTED_VM
> >  	help
> >  	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
> >  	  with Encrypted State (SEV-ES) on AMD processors.
> > -- 
> 
> Kconfig doesn't like this one:
> 
> WARNING: unmet direct dependencies detected for KVM_SW_PROTECTED_VM
>   Depends on [n]: VIRTUALIZATION [=y] && EXPERT [=n] && X86_64 [=y]
>   Selected by [m]:
>   - KVM_AMD_SEV [=y] && VIRTUALIZATION [=y] && KVM_AMD [=m] && X86_64 [=y] && CRYPTO_DEV_SP_PSP [=y] && (KVM_AMD [=m]!=y || CRYPTO_DEV_CCP_DD [=m]!=m)
> 
> WARNING: unmet direct dependencies detected for KVM_SW_PROTECTED_VM
>   Depends on [n]: VIRTUALIZATION [=y] && EXPERT [=n] && X86_64 [=y]
>   Selected by [m]:
>   - KVM_AMD_SEV [=y] && VIRTUALIZATION [=y] && KVM_AMD [=m] && X86_64 [=y] && CRYPTO_DEV_SP_PSP [=y] && (KVM_AMD [=m]!=y || CRYPTO_DEV_CCP_DD [=m]!=m)

I think this is because KVM_SW_PROTECTED_VM requires EXPERT, which has
to be set explicitly. But I think Paolo is right that
KVM_GENERIC_PRIVATE_MEM is more appropriate, which does not require
EXPERT.

-Mike

> 
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 

