Return-Path: <kvm+bounces-8720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 258218558AD
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 02:21:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1534CB2748D
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 01:21:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F7021C15;
	Thu, 15 Feb 2024 01:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HtNJLZdW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B6B1C01;
	Thu, 15 Feb 2024 01:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707960055; cv=fail; b=oyanHdxoAeg+NqPWJyUnTti2jpK+RapMfNE6d7Y8LDnTzzyDOEcCxIpv8QQR8/n9FZdA1A5dGQ9VWeXvCWbn4j4r5Ljld5wJPVZuIx395x6GgFMHAexnyu8deJTYzfGSOwyH/cVg5CqAaQ6KE6Hlk5CnGfDjZlntf1dsIt7PHs0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707960055; c=relaxed/simple;
	bh=57AwmmEoJZBGTiDOVABJJTkVrdN9c6Ct2T9k0jK/SNg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=guBzhFeTNN8js7g+AWfDU4SsDqhbeHbm8nGU7ztMcoFMKhXqpHbg76XrbuUOXBcJ79EPl6qVayONcHG5L2oVHN/oN9MAC9yWuxquNjjS8gq3BCiOV74lDNNFHm0iovtuWPHH8zJ7BQ51OnXLIpGqTy5rmdq/zNOdrJ9QHEkz6Sk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HtNJLZdW; arc=fail smtp.client-ip=40.107.92.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iR6PuuJhk0JX9n3lI+We9ilBW+S49vhBBeLCAaVbLpFzqwvK0KnO+wBFG27/OhYO/tfkPrCHwoQRUTMiLsMqZbwL5OboKc0TD/8QrYdqBNvj+/Cki9UhmO7P4fg64NVrJuRKIB6UWbObUu25YU2QxXE6zZRA8DLLQsi059/QN6IiXG73V5WiUYTmJqiahjGB8pQHKA8gTegxb96oVjcb6HfpeQ59WRDypFzoZKcWh0jl8FJtnLOUmyQmtJs+RK26JbyaMPDiGJ/pa9Y6Txswj33WewlOH5cyf86oZyBkbbIWIxvUugUoAKkmqBXnIUB5TxzKwwPlam3N476518Bt1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ioSwUM9zhYK+LVfnX+bTCqwdjoOzCbADuvGg4OMYPqY=;
 b=YBgfmbFxHOAmVo2NXRv2O7Bzpl66gCkXFSLWapfHNlTShvsVmXRRY8HeQmlNRYVffCZlx31oLHUqvrq7WUhWVI7qQKFXFDkXeViUgcazpDWfO/Yxl8glgajEXT6GSoUX2fTVFwNOjBXp0nGgAf0Qk7TFtpf+/2Ir1oARe98jsUvGCjtTtToxvUa/elXEH4PPQ98REEkwak3X0XptwpKEbwbJvTXJ2vqBnVuMwV0bodrbOfEcS1AzxV93OIL3S9zPhqA9nyVwBHpT34hQ5HrKt+FHn9lwS8yC4iSOytCXv34v1ITo+tVMiXCclRDNZTmr2n0fdQJI/PwpmgCIsT7Pjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioSwUM9zhYK+LVfnX+bTCqwdjoOzCbADuvGg4OMYPqY=;
 b=HtNJLZdWx0yll8BYLW8v/SSd/+jptozZ2qyC11PHlzzz+xklSgcOQXx7Epv4ZnSz8OG6/YeKdbyXC2uc5d1vfibikNL0WcPYcjwe/Z5MVDJCzFkFKW0mh2sk7BzGjcjK9lu4MPENrrOPq//SJiWPuryZ0vOGHwM8erutBT/VEo4=
Received: from CH2PR11CA0012.namprd11.prod.outlook.com (2603:10b6:610:54::22)
 by SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Thu, 15 Feb
 2024 01:20:49 +0000
Received: from CH2PEPF00000099.namprd02.prod.outlook.com
 (2603:10b6:610:54:cafe::78) by CH2PR11CA0012.outlook.office365.com
 (2603:10b6:610:54::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.38 via Frontend
 Transport; Thu, 15 Feb 2024 01:20:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000099.mail.protection.outlook.com (10.167.244.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 01:20:49 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 14 Feb
 2024 19:20:46 -0600
Date: Wed, 14 Feb 2024 16:57:49 -0600
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <aik@amd.com>, <isaku.yamahata@intel.com>
Subject: Re: [PATCH 02/10] KVM: introduce new vendor op for
 KVM_GET_DEVICE_ATTR
Message-ID: <20240214225749.nwhuypw3tzm6cyo3@amd.com>
References: <20240209183743.22030-1-pbonzini@redhat.com>
 <20240209183743.22030-3-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240209183743.22030-3-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000099:EE_|SN7PR12MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eed3aec-ad9a-4041-1068-08dc2dc4581e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yoNa7bDZ+djp58H6daJt7maGbPyWKRlWE/ytEYbsojiEIQuzRfOfp3KHfiMF68LqKFCYAISzt8q/EvfZhXkCA7CnkHCuZZ09ktuiZZELmXCuV+kVXzdP70MJ6IooxGHAI3c7frmS6YJPC6Q0Re0eYM3ZAoTPuQZbTqSX8GYnwKUqOJlpoXfmSrqYXDXAJ6ySpwaiqWBb1UB6fDvfIbM4OQF9ykOBmtO42BLez1WbhPflVnGiSr5teSTnljO9eqFedWhHTeeovklC1t502+E+CmKvIeEEgpDCnnUKik9o5zajzebKLpM8hUFpiWhjm31KCvslpxgOTq3vRKl7Ssdp8YqFBCM87N1YFNv2+bnbO4ffQhVa8YLKDhXUxTk42Kuy1Lc0fMdsa/PkgquB0aTlV8Fj53PzKu32xk9vqJJxZyXp6XvwFnB1LqWpTmcmrwvpUYOYzsXy285+SjlMVSOj8tnKjLN8hMPm6d1hxOhQ1hMdo7kDUY8XyMby+eELJ195ozuuV2f+78zTOt9vYatmatOMeMKbsv1R9tYaPwAtpJRGObUuOk8SMlTS2WZuexs7qAQMedeUULbsmh8kFfIsEZ/7SIf+cOb93mILiFFczs9ZoL912mVc157DfpHaI1YpALf9vZEcyNav+TaWcG08+auZcGS/tZk4SfoOKBEmnc8=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(376002)(346002)(136003)(230922051799003)(186009)(82310400011)(451199024)(1800799012)(64100799003)(36860700004)(46966006)(40470700004)(26005)(36756003)(336012)(478600001)(426003)(2616005)(16526019)(1076003)(44832011)(2906002)(70586007)(5660300002)(54906003)(83380400001)(70206006)(4326008)(8936002)(81166007)(316002)(8676002)(86362001)(6916009)(356005)(82740400003)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 01:20:49.4348
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eed3aec-ad9a-4041-1068-08dc2dc4581e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000099.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813

On Fri, Feb 09, 2024 at 01:37:34PM -0500, Paolo Bonzini wrote:
> Allow vendor modules to provide their own attributes on /dev/kvm.
> To avoid proliferation of vendor ops, implement KVM_HAS_DEVICE_ATTR
> and KVM_GET_DEVICE_ATTR in terms of the same function.  You're not
> supposed to use KVM_GET_DEVICE_ATTR to do complicated computations,
> especially on /dev/kvm.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Michael Roth <michael.roth@amd.com>

> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/x86.c                 | 52 +++++++++++++++++++-----------
>  3 files changed, 36 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 378ed944b849..ac8b7614e79d 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -122,6 +122,7 @@ KVM_X86_OP(enter_smm)
>  KVM_X86_OP(leave_smm)
>  KVM_X86_OP(enable_smi_window)
>  #endif
> +KVM_X86_OP_OPTIONAL(dev_get_attr)
>  KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
>  KVM_X86_OP_OPTIONAL(mem_enc_register_region)
>  KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d271ba20a0b2..0bcd9ae16097 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1769,6 +1769,7 @@ struct kvm_x86_ops {
>  	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
>  #endif
>  
> +	int (*dev_get_attr)(u64 attr, u64 *val);
>  	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
>  	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>  	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bf10a9073a09..8746530930d5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4804,37 +4804,53 @@ static inline void __user *kvm_get_attr_addr(struct kvm_device_attr *attr)
>  	return uaddr;
>  }
>  
> -static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
> +static int __kvm_x86_dev_get_attr(struct kvm_device_attr *attr, u64 *val)
>  {
> -	u64 __user *uaddr = kvm_get_attr_addr(attr);
> +	int r;
>  
>  	if (attr->group)
>  		return -ENXIO;
>  
> +	switch (attr->attr) {
> +	case KVM_X86_XCOMP_GUEST_SUPP:
> +		r = 0;
> +		*val = kvm_caps.supported_xcr0;
> +		break;
> +	default:
> +		r = -ENXIO;
> +		if (kvm_x86_ops.dev_get_attr)
> +			r = kvm_x86_ops.dev_get_attr(attr->attr, val);
> +		break;
> +	}
> +
> +	return r;
> +}
> +
> +static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
> +{
> +	u64 __user *uaddr;
> +	int r;
> +	u64 val;
> +
> +	r = __kvm_x86_dev_get_attr(attr, &val);
> +	if (r < 0)
> +		return r;
> +
> +	uaddr = kvm_get_attr_addr(attr);
>  	if (IS_ERR(uaddr))
>  		return PTR_ERR(uaddr);
>  
> -	switch (attr->attr) {
> -	case KVM_X86_XCOMP_GUEST_SUPP:
> -		if (put_user(kvm_caps.supported_xcr0, uaddr))
> -			return -EFAULT;
> -		return 0;
> -	default:
> -		return -ENXIO;
> -	}
> +	if (put_user(val, uaddr))
> +		return -EFAULT;
> +
> +	return 0;
>  }
>  
>  static int kvm_x86_dev_has_attr(struct kvm_device_attr *attr)
>  {
> -	if (attr->group)
> -		return -ENXIO;
> +	u64 val;
>  
> -	switch (attr->attr) {
> -	case KVM_X86_XCOMP_GUEST_SUPP:
> -		return 0;
> -	default:
> -		return -ENXIO;
> -	}
> +	return __kvm_x86_dev_get_attr(attr, &val);
>  }
>  
>  long kvm_arch_dev_ioctl(struct file *filp,
> -- 
> 2.39.0
> 
> 

