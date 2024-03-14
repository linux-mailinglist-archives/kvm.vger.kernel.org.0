Return-Path: <kvm+bounces-11790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35BCF87BB74
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 11:40:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E059D284C63
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 10:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C67416EB57;
	Thu, 14 Mar 2024 10:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XFnCUCQX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8589257330;
	Thu, 14 Mar 2024 10:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710412802; cv=fail; b=l7jHp5w32+DmfDuOuwyqwYHNZMlE8rUhCWozR9OWP97f5gvKfeA2KzLycV2bQunDqWJ3yCrVzlKhaebzqqC28w62qEcm/iCmPYSu+1aTgcTFuRkd95aoDCoO4x/QHkKlueRkwppLBhTcZ9zLB86cqPfqOwboWNBSJ/GeNH4dObk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710412802; c=relaxed/simple;
	bh=L8GgdpQ4rXlI1W9aNz8/R4GLknPwhGh9WJpRyJmBL+g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aF5ZTJywg6lvLDps+AqY+NgTx0jyPFk5OUuIAmiDLpwBnqOdWFKS87qEM8dlsvcqGiJ80Oi2DD9C3yDY9Ijb9gWP+iGgO1SPmBE3tOLaVMaU+NrwYKTq18FBKqL9yJTpryBGFy9B//db4tvAQrSr+AvwHsm6ZB5vZCA12PDo5AE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XFnCUCQX; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710412800; x=1741948800;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=L8GgdpQ4rXlI1W9aNz8/R4GLknPwhGh9WJpRyJmBL+g=;
  b=XFnCUCQX0281p0zUwrlaIu1FgNzng+x68FupMVrI4jI2eZFjeSwGpIBe
   LiAD1a72JV0nXyh8MqIPkTmCzb/j/Z6ua7LhzHaJvvFproRJ8lNfghx8P
   fx7KGz20Qck+DqivOwJ7aUKKJzLb355UNIDUiWzm5zWk0mMIZRgxmCJjo
   xKx9niwBOyNIVCPFNUbH4ekZSZbhBuFvgzI9LomBHxoj/1O6UidG+Vyzk
   2VJzhTVyXCXuHb28B8FwUzD9ymP4RNWVvcqrI4F7ET+g7t+ouYXjewUVV
   ucOUfpDleq2/AZPY2LCbmLskQXHNXt/z5wefVxlmg+cYB7Wpj3ONRVBBz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="5346952"
X-IronPort-AV: E=Sophos;i="6.07,125,1708416000"; 
   d="scan'208";a="5346952"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 03:39:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,125,1708416000"; 
   d="scan'208";a="43285183"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2024 03:39:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 03:39:41 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 03:39:41 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Mar 2024 03:39:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Mar 2024 03:39:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dxU13qOZI9l09vSIpEio7y8va0b0r4DIIT65q0DvsIdbZiQRFTNVGC86fLA9skNsDo3vso5XSQNTSIcRM1NJkumIbsMkhxhXqrD747SGkfHuyWOE6hPl5mPYgHYbEgAf9RosJbd9ACaKSxHlGuly9W9ISd5eU0vgwsOEGDa0kPil/DstMMC122ICowbejx0nrf20wBHMP1Qg7oM95WNrXozNPHNrfZVv1bnPbOTtFoiHU1EyQ+65xb2EtQ9f5lLVNZCnly2w4m+KwJqeDBUsXlKShAqOWy42rJIdXHu+fUnYgteJRdTi1hDWGaVF4f3YfAmEMcL62B+hsLaoA2YJ0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCBs7T66uaQc6/i4sAcoVBHqn6S2JztLEELYIA8Iyz0=;
 b=Po5bu12sw/dzFji4pA/s/5AJLGVzo6Z5PlIOImIpqxTBY6jKbDSQwm6ulHReKio0IlWQpFj9Huoi3sFcgYs2blad1NOS4x7w2DKCMWr9MyskJMY+32lvNV4fSH3IEQPI/kXy9eFh1cnXYiu6ZOpumnkxWn3+NJ/2qsJ84+30NnzuKpkl76T3X77z/IV7Fdp1ZhNRUZ0qSvvIjpqPPWPvPHxB63oWux+q6GEUzCkF3o63AXb1E4WGbE9Kz5mB3TRchbeDVSwJbnNAPVN6LhSi8UQD6+Ges63hoWvAxse/Toywfx+6i10qAnRPCF95iMzpEMcn/38Y1gq2bG7bQx2JBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW4PR11MB6982.namprd11.prod.outlook.com (2603:10b6:303:228::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.17; Thu, 14 Mar
 2024 10:39:38 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%6]) with mapi id 15.20.7386.017; Thu, 14 Mar 2024
 10:39:38 +0000
Date: Thu, 14 Mar 2024 18:39:28 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v18 023/121] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Message-ID: <ZfLT4AwkhGUQGPxD@chao-email>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <ed33ebe29b231e8e657cd610a983fa603b10f530.1705965634.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ed33ebe29b231e8e657cd610a983fa603b10f530.1705965634.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI2PR02CA0026.apcprd02.prod.outlook.com
 (2603:1096:4:195::19) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW4PR11MB6982:EE_
X-MS-Office365-Filtering-Correlation-Id: a6ab4872-5270-43ee-f783-08dc44130c65
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sYsqPhJNz/chca1HKT1jWRjv7o/u3OEbqFDhO+ZXZSy85MW9PApVxeNuiy2t0AHeysoJo3M8VSaNQlBxB6ERwR8PH9ufHPRh18CiBhRmza1V1bQ6xrI7RFu2FLlqqibHenPEOJDB8lXsPlD/PXyOtSW0aFn9e1YZzkGS0kqrnaAuM6XugfQPmy7KP4vpWi2xMmD/0drpbnogd5Fx9cw/K+ejw+Ao3nLR8lRV3f/or+GTdUuImSv7k8OIMuR/kqGUyu2MFStobWJ2NV9nSVJ5rwGzggZof5/O9JiwKnRctSaHbT2/sZjtgcLg2qLZSCAt3ASCstg2a4Zxjgc/FU6O9ctqsBc2oN6L9/QQZ7EU1n4Cd3IibkiMnJTwEtOUcQFjRvXA9fVlxmjZcO4+AR0aI4ntuBCmM89b8D2KKMWmRMiIFwk2SegNzY7u7aa2w9QAMzHh/BjKmXo091rEVE9YtQsy0YOnKSFePNIvbJRZCbDVsNhfc++2PrQOa9wEFyhZyci2iX7GPPbqAAkodKKWKy2A+k++JIkuhmTTZoqmqFZ4KH4CANWGZBc7tmJiPuQnHLH8RYNx9/Kjtj6zFj+dAoMw9sejVuv5ZOVj35c3d8vk62KXXOUkMXaq8+gJuaoY7RamJt9AfKKnfdYO5J7ZsFRlCNdte32ZpL7Nwch9gJo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PF9auE3XJBdsOv3R/ttv3O0hSjC4EDxjJ9tdLuSSM4cPuy1WaSdYcr+Bp8wp?=
 =?us-ascii?Q?+nCVVex6i56qESrBrdMXGy9ODBsJL5IHnjiwQMrkDYxnKTVbuv53PPIAwTG+?=
 =?us-ascii?Q?AMORsfqohflR0oG1/6rg2OV4cPLJlhACMgurZ2N3bU8f8UaaLZ1T8D2dx49R?=
 =?us-ascii?Q?PHOoxCxn7xSeyvlddg7tkxmlFNV9LA52hIN0VcBqNiWHcj8278QK76hIUZIh?=
 =?us-ascii?Q?H68sRpGSuD/VwwEaVPcmZxkLMJLq4qUWokh2WL4oQ6UOyRRuziRsdNMjnfr6?=
 =?us-ascii?Q?mmXi/10UV5rHT64GcTeDMbghHsxwLw+4K3FrC8Luk0smOe7Ru5CI/75gXkIU?=
 =?us-ascii?Q?Ql5Sqom8YtY3ik7iIdJcS0xChO7e56MvwZMLYu22LX3uxLLQtUY7KdrwPMVj?=
 =?us-ascii?Q?wKGBmWB7fm6ZRj3RmBzCy9g3xwbPCJUdPp2/Z0mSl3CtzjkDXG0Mmq3mJbxP?=
 =?us-ascii?Q?IhZI5qbq8NP443R4s4G4nHUmkAlyc3jOpbSZRU7dXmvTVi6cVxIFoJHjSVj/?=
 =?us-ascii?Q?zMfUlmgP2CL4dGaiAF+jaaFwJ+dJUe+59fXaHVfnWBy5jdW5EeSvdkedGMno?=
 =?us-ascii?Q?AC1AJ/GMz184HgZHxNe9TmwPAzKGpvDDQLqN2G5lq84G3/cXAW8I+v3DSZJU?=
 =?us-ascii?Q?WRXQMUd51RSI/ZGfSDzjVOw7wiUTyIYaErZ2d1reNu9PB0RQqbHLLgtgOKbY?=
 =?us-ascii?Q?Y2nUQog8t/K1UQOLprgftletTq+EHQD0MmH/M/SwOWbT5QN4cY95wTyz6WLt?=
 =?us-ascii?Q?hoUarYbDxgaRt41atW29jl0cG5PSBRAEn5s4k72oUFw2hnUWwVDtHuztapT/?=
 =?us-ascii?Q?P2eWHM3dfXNHMSaHeigvAM79OCHwzuAmTG1WQPWa3KF6/1cY9r5DVSDGH2dn?=
 =?us-ascii?Q?ehjTSzBJEs78Hkz0pZI6eMtl9eTwrfbvSkof9V0ndRi002UP0bS4gtoHiOWM?=
 =?us-ascii?Q?XNFtRiC8K/rMgvA6aqC/kooOrov5ZXGW108pgXXTydxcoZiyFZaLu+12yGGO?=
 =?us-ascii?Q?asmSCz2QRM6p+JqAxJRmJEVsfudR+gvXZks9N8tH7qGXbvontmRXyLM4hNCW?=
 =?us-ascii?Q?buJAhYIDhr0eEp3PjhHkC6rHwpUzNVcIS+d4T/eADOse4NbQ39jcau5EHfIQ?=
 =?us-ascii?Q?WOs2qIFF4Eh13pEbCT00hBqFXYKJbgJsUU3UjLtR5PBC4OOEO0DBMDIdeHdP?=
 =?us-ascii?Q?f2RliUi0sh4JH6oYET9TRYL7GPyHz9nmTQ7Pspe+YJAJHPv9fc8wPj1BfDZH?=
 =?us-ascii?Q?6vOxV7aw1zWrmQN0AlsomROoBPCoGC7ehog+PSlgvsOTO/WfruBkAQ15Nfxd?=
 =?us-ascii?Q?/jevnAWpN8bD6mkX7hUU6peogofQZuKFRAG0GF/fSVDCgkjy7/Fzxfpc1V4+?=
 =?us-ascii?Q?RvI2B4mhDfEflViDbULyVY5Mqhaiejjep8QDC+9bG4njGQJKSqcmp+KX+SGe?=
 =?us-ascii?Q?5xA4jj1Ss9h/AjXiTIhX3FmxAZHYYIEpZjQz6Rc8eskCHrb45W0naoRdjKd8?=
 =?us-ascii?Q?SqGzJtuNlEGWKIJ3l6tNKCw1UUs6PIx8Z4dhO64NBru7E6AijbvRI5v74prt?=
 =?us-ascii?Q?+r27Wy+GEOQGjgALC67IcoXp7BJ9yW7JLA1V5xWW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a6ab4872-5270-43ee-f783-08dc44130c65
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 10:39:38.6984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /VY27ytSNxIO+KWgf62LpK+FilVqxSha+5xVAPila1OyYmmC1R1lyumJksF8c7PpKEkdn3LBl8bfjV2mHFAgpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6982
X-OriginatorOrg: intel.com

>+static int vt_max_vcpus(struct kvm *kvm)
>+{
>+	if (!kvm)
>+		return KVM_MAX_VCPUS;
>+
>+	if (is_td(kvm))
>+		return min(kvm->max_vcpus, TDX_MAX_VCPUS);

I suppose kvm->max_vcpus should be always smaller than TDX_MAX_VCPUS, right?
if that's the case, the min() is pointless.

I don't get why kvm->max_vcpus is concerned. do you want to enable userspace to
read back the max_vcpus configured last time? this looks useless because userspace
can keep track of that value. how about:

	/*
	 * TDX module imposes additional restrictions on the maximum number of
	 * vCPUs of a TD guest.
	 */
	if (kvm && is_td(kvm))
		return min(TDX_MAX_VCPUS, KVM_MAX_VCPUS);
	else
		return KVM_MAX_VCPUS;

>+
>+	return kvm->max_vcpus;
>+}
>+
> static int vt_hardware_enable(void)
> {
> 	int ret;
>@@ -54,6 +66,14 @@ static void vt_hardware_unsetup(void)
> 	vmx_hardware_unsetup();
> }
> 
>+static int vt_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>+{
>+	if (is_td(kvm))
>+		return tdx_vm_enable_cap(kvm, cap);
>+
>+	return -EINVAL;
>+}
>+
> static int vt_vm_init(struct kvm *kvm)
> {
> 	if (is_td(kvm))
>@@ -91,7 +111,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> 	.has_emulated_msr = vmx_has_emulated_msr,
> 
> 	.is_vm_type_supported = vt_is_vm_type_supported,
>+	.max_vcpus = vt_max_vcpus,
> 	.vm_size = sizeof(struct kvm_vmx),
>+	.vm_enable_cap = vt_vm_enable_cap,
> 	.vm_init = vt_vm_init,
> 	.vm_destroy = vmx_vm_destroy,
> 
>diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>index 8c463407f8a8..876ad7895b88 100644
>--- a/arch/x86/kvm/vmx/tdx.c
>+++ b/arch/x86/kvm/vmx/tdx.c
>@@ -100,6 +100,35 @@ struct tdx_info {
> /* Info about the TDX module. */
> static struct tdx_info *tdx_info;
> 
>+int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>+{
>+	int r;
>+
>+	switch (cap->cap) {
>+	case KVM_CAP_MAX_VCPUS: {
>+		if (cap->flags || cap->args[0] == 0)
>+			return -EINVAL;
>+		if (cap->args[0] > KVM_MAX_VCPUS ||
>+		    cap->args[0] > TDX_MAX_VCPUS)
>+			return -E2BIG;
>+
>+		mutex_lock(&kvm->lock);
>+		if (kvm->created_vcpus)
>+			r = -EBUSY;

Curly brackets are missing.

And -EBUSY looks improper because it isn't a temporary error.

>+		else {
>+			kvm->max_vcpus = cap->args[0];
>+			r = 0;
>+		}
>+		mutex_unlock(&kvm->lock);
>+		break;

