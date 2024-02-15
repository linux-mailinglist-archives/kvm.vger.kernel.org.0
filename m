Return-Path: <kvm+bounces-8724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 001D08558BC
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 02:23:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 847FA287398
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 01:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58EB26FA9;
	Thu, 15 Feb 2024 01:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xqc0f0AU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2056.outbound.protection.outlook.com [40.107.94.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CC24691;
	Thu, 15 Feb 2024 01:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707960141; cv=fail; b=gOM/8oLg3nwzMUu7VuAZNUMEB9YdldwcyXbNwrjuVPhbZHlQipTr3pzVR2Az/sQnKMj+KKPCwy+KxLl21EAXgDU9k3BDpD8PORMEm8SFIcq6YM0HBrzpClUdVnv6T1NQmt9VOVTAo9MZ+8HEOeeElh8GtlWGKrhFSuJh4OtVe28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707960141; c=relaxed/simple;
	bh=L1DhMLCFTTzEXnBRLwLeWUh+4TB0j7/fJ3NGl3DGvLk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A1BERY6AD3kLU6QxMPa/8j8IqMg9lck20nKD5aySXzz7l+Mn5JlCSXUWr5gnHOHvp0tPNQQr8eza2Tux6v4LUgViIFDNZu9VlUzkUUR/CMRsPV4Lbslxet9aJLEneBuxI6MUfoKF0lRDtJDp8rMk2uo8YXH19rfoUCYSF4Ap0eI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xqc0f0AU; arc=fail smtp.client-ip=40.107.94.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dKfKoBEcDDrtcm+GdZtrwQPO2X+8DJfUsty4cqsujfzAsMBwQbQZIyEqSQ44ps8jyAYV3yUCu+7LG5PqKW5cW77JR+n8jlXHdoCuhS6lm87xkDIPJbnbD6Z16vsxmO3qL7y90ZMTk70q/UbHZ7UmkQ+3BfHDTPuEnrzshRdlbkS0/sWs83NrHKHQzawdd5qMdp1Jm1ZCUR4lDMn80WAAisvx11DK8FigmyHQ8zwc9ZCUxSccX7U0qid4mDnzPmWSniyaYrbFQPn8In8QL+tphdq1U/O3+Nfge9qfAmW6ZS8bD/0+qGsO5DczhZSR9l6cjOeg2aQsxs0F2yr3ukZfOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iq3tMlFEE9H/zImj7kbrKFfAI69ZPpiTNxcN8YAgaZA=;
 b=UzrSFhRcBhhjzxFR6h3SBWnkoKlhXKM0jM4u0LD5W26V0sj9aLPM1XgMG/MwPZoNqkO5goAvrG+OZHC4ck8dA7kl02MT+R7m6dwFJ95IoFX7EyjeTsGwIPkLNSEXgn/oidS2K94EBYQdBoqdhmqN53l4evVoxMyTWy7no8ZO1dBlcfrI0J3B5kzuO9h++8s/Qc2tz5BKturW0WtPN4NtLysNI42iki56a1Qea4ppA70wUsbcm8OlAxGv5Cn0GKHS/0uVNe45uaogA5OaxMbEPmB3yA2TNArW41IxcQXmzpR7dnDzT4eC+DvGsVJrdD1yXFdya88wx+tG7Bp/dfYnyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iq3tMlFEE9H/zImj7kbrKFfAI69ZPpiTNxcN8YAgaZA=;
 b=xqc0f0AUN9KmAYb3Bg4sIqtV5FL/87DIOyDtj2GYWRtH9Mj+6iqSZFuc8VAEK/o9rteVSEjetRDKtW4j1Kp2lngAy9/1sZp5OniaQReRX5yAEzSieSBdakNPW2KBpaGaynnlfRw+wCdIYwlKrqHGsI/AKvTpc2lEYsHgHjnAAjY=
Received: from CH0PR03CA0208.namprd03.prod.outlook.com (2603:10b6:610:e4::33)
 by CH3PR12MB9024.namprd12.prod.outlook.com (2603:10b6:610:176::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.12; Thu, 15 Feb
 2024 01:22:17 +0000
Received: from CH2PEPF0000009D.namprd02.prod.outlook.com
 (2603:10b6:610:e4:cafe::e7) by CH0PR03CA0208.outlook.office365.com
 (2603:10b6:610:e4::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.38 via Frontend
 Transport; Thu, 15 Feb 2024 01:22:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000009D.mail.protection.outlook.com (10.167.244.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 01:22:17 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 14 Feb
 2024 19:22:16 -0600
Date: Wed, 14 Feb 2024 18:33:58 -0600
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <aik@amd.com>, <isaku.yamahata@intel.com>
Subject: Re: [PATCH 07/10] KVM: x86: Add is_vm_type_supported callback
Message-ID: <20240215003358.pjqfz3zik3s26nwt@amd.com>
References: <20240209183743.22030-1-pbonzini@redhat.com>
 <20240209183743.22030-8-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240209183743.22030-8-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009D:EE_|CH3PR12MB9024:EE_
X-MS-Office365-Filtering-Correlation-Id: d404ec8c-2926-4ed6-df56-08dc2dc48c89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qzFspRQE5f7bX8U0YG7d9y6dezFpMw44g8e3qRrJDtW5ziJwPKLxBmhTrg6HcHeZirj9wS0bac/BiYGK0z5LkYNTVLaPV0F7Xf5i6PxVgj/H4GpZgi0VFfaZfwy3GSwNokqY+c7ZnAOv70ZtibRSsFyDARuFgnTuGFTsHXftpfYhZSnbkXGX/TFF0n3q0BLccnH7URtC5RQ2kNhzVOf+EyedhKZfbLcH3w5tkTADvzIwjjTglZ8Fr95uC3tqxvMWZVatOgk83CfVLxOJcAQwz3NkoiedYbvxW4xg7K9Lc11vHIiw+NkYQEFStScrjAED8AzmMONS7fLsDQcln9iNLOFa9dPjLzNuLKvi6alpOJfytWjdBvZXkOd2Za2hbCF2W7llI0uOfOsnyY9P7lXHr79bWgSjqPTB+c5PGrPdNGPcUiiLOil0NxJWTO4hxhZxdgZ26xmd6KHyg6J7LVi8KOlGixcol1yeyyNDXaYwXsZ2vG6iVK6N4tQpdcRLANKjpd5lpw+2BRfaeKu11WssyKs57xxaphBWhNIW+tBVDuqz390sfx44mkS8b/LBFjm+swdLoYMQyDYVgzy39LMlICrBKFX1twKC3LPVvDs3jZJgyAvWi7/fGd8ffHovU7imejq50ews79JtWC8Y9jItFEYNQB7uIph3OlA5y2eNl1M=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(376002)(39860400002)(346002)(230922051799003)(64100799003)(1800799012)(82310400011)(451199024)(36860700004)(186009)(46966006)(40470700004)(86362001)(8936002)(5660300002)(70586007)(70206006)(2616005)(41300700001)(8676002)(4326008)(6916009)(478600001)(83380400001)(2906002)(44832011)(336012)(16526019)(356005)(82740400003)(81166007)(1076003)(426003)(26005)(36756003)(54906003)(316002)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 01:22:17.3672
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d404ec8c-2926-4ed6-df56-08dc2dc48c89
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9024

On Fri, Feb 09, 2024 at 01:37:39PM -0500, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Allow the backend to specify which VM types are supported.
> 
> Based on a patch by Isaku Yamahata <isaku.yamahata@intel.com>.
> 

I think this needs Isaku's SoB since he's still listed as the author.

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h | 1 +
>  arch/x86/include/asm/kvm_host.h    | 1 +
>  arch/x86/kvm/x86.c                 | 9 ++++++++-
>  arch/x86/kvm/x86.h                 | 2 ++
>  4 files changed, 12 insertions(+), 1 deletion(-)
> 

...

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e634e5b67516..c89ddaa1e09f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4581,12 +4581,19 @@ static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
>  }
>  #endif
>  
> -static bool kvm_is_vm_type_supported(unsigned long type)
> +bool __kvm_is_vm_type_supported(unsigned long type)
>  {
>  	return type == KVM_X86_DEFAULT_VM ||
>  	       (type == KVM_X86_SW_PROTECTED_VM &&
>  		IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) && tdp_enabled);
>  }
> +EXPORT_SYMBOL_GPL(__kvm_is_vm_type_supported);

...

> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 2f7e19166658..4e40c23d66ed 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -9,6 +9,8 @@
>  #include "kvm_cache_regs.h"
>  #include "kvm_emulate.h"
>  
> +bool __kvm_is_vm_type_supported(unsigned long type);

It's not really clear from this patch/commit message why the export is
needed at this stage.

-Mike

> -- 
> 2.39.0
> 
> 

