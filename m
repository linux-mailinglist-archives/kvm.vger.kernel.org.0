Return-Path: <kvm+bounces-14044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 682F689E65A
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 01:47:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF478B23248
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 23:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E95EA1591E3;
	Tue,  9 Apr 2024 23:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Lkm0hxga"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBCB15820C;
	Tue,  9 Apr 2024 23:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712706433; cv=fail; b=mlDW4E3FEGrO/lGKkKTEWWVj9OfJlmTV06USanCfRIOHSd8gne5sMl/fOQ5SbAT93EJsXgpmql15Dd3aEEz4+C+m7F6ZU26QDZPAMZqjoe1OMDEy89LKEFx4MRy6McOHvfngPQziAz0uKsux9E/IPYVinZPYZjElqhImsiKu7s0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712706433; c=relaxed/simple;
	bh=NKVXcD3pzOg7SzRoaXkI3bzBz2Dy40+l085n0jUhtDI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ojvb2aBWve9J1p648fpqC714XqQ8p8WrLiSa/wAe1I9kNZioh8D91DRrS+9J4ZqLnqtPG7nUdJ7zBiiKl0SrcqWrOZSNYdJswVuBsZWRy+2S5bVZHtTL5KChpW2f+dupfeI7m66LrjFfOGsC/oBgUpsfDoJ1/crB3FxhOKW0ITs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Lkm0hxga; arc=fail smtp.client-ip=40.107.236.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3jyAxul+BknLLRYC/0Dbr7F8t42UcpF7ns9wFZ1rpbebxq2JR/kanvuhBDM1ULjgRg6mMRfDQsnQVL4cBVnhZsrX1niqMAGDkRYPWTze/P9N2VLutoXvyydwD3LdTMThQo9aSL2b3HesJSPfCVKm6SmZmpJ+pkouBm/qTesD6gJLak7QrD2qkBJJDJ2Y+V09IwhIouhkjeDoVSG+IRwWTud0k7y6fOl7XdR4tqjrEidKG7AOEw+WmjF4a7tit4Q1F/9UBTanZTBoQOIlUdekcLnn4mxG8pCcQDF7snsMo8OSfcjOzZAn/h6/UiEWi4eqd7v5xYpj7fTA8SnJq//uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aLmLMDd/ZBF4z4vIsDVzM0Igu0BKn1nlfnml4Y/f2H4=;
 b=grv+Z0FQTsbVZrxxvvMfkWg+wG7XnwtnvrmRzV0+SL4voWy+Ti2MqDr+BgegqWbSKnL60JDKJnxS9DUoavb9f7AmexgDUUp3KFoQ5yUb0GiaGc06zm1QDj1HczhPIS1vWZ9st5qXYlsCYb0pkVhDPQSufRBKlGxrRLdZtnQrIdsYSHw9bewe2flIrzlYCSF7hfEOpQiWgj0mp+HYzruVukHljuNy5qHujQ9kjWyxEk+Sj8gBfg6VKBqVOm/Bg0HMI9cK2BZi/Ztd5L5fmtuLvycSWHtvGOfjpAhVYIHtjv/t6uAINlALe3n7yt6Pi/fse0VIUb9IND+w1tZ3BH5Jqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLmLMDd/ZBF4z4vIsDVzM0Igu0BKn1nlfnml4Y/f2H4=;
 b=Lkm0hxgaKk1y/26wKuWl4/M5YCvKecc4YQWcxuHB3tizHYlJbT5ego/dWLDyxFVgSdi1va4GWGz1CJWhfmINouRjqkmoitS6j6vaPSGosTXJ04NmKtcKYmKYaKsOuer0iuMs6qACzdQdTM/4dcq/eSLoJdhhObvs8bqh0VHFNtM=
Received: from MN2PR13CA0006.namprd13.prod.outlook.com (2603:10b6:208:160::19)
 by IA1PR12MB8192.namprd12.prod.outlook.com (2603:10b6:208:3f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Tue, 9 Apr
 2024 23:47:08 +0000
Received: from BL6PEPF0001AB56.namprd02.prod.outlook.com
 (2603:10b6:208:160:cafe::7c) by MN2PR13CA0006.outlook.office365.com
 (2603:10b6:208:160::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.18 via Frontend
 Transport; Tue, 9 Apr 2024 23:47:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB56.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Tue, 9 Apr 2024 23:47:08 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 9 Apr
 2024 18:47:08 -0500
Date: Tue, 9 Apr 2024 18:46:32 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <isaku.yamahata@intel.com>
Subject: Re: [PATCH 11/11] KVM: x86: Add gmem hook for determining max NPT
 mapping level
Message-ID: <20240409234632.fb5mly7mkgvzbtqo@amd.com>
References: <20240404185034.3184582-1-pbonzini@redhat.com>
 <20240404185034.3184582-12-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240404185034.3184582-12-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB56:EE_|IA1PR12MB8192:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f22f1e9-7db5-4327-39c8-08dc58ef5e9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	P05tP6Uu6q1oxvgu9q3MojmO8skA5yIXDiRnFyuYk1qkSD3UfTLPZRHVib1EGtSwdn1qYenHGB3sW68AkmUpOxeupABNL83NaE8uik0p4RqNrnjQ2yAkPeZBjn6p+2gmyuDJMEnIv6MwybzhwXDOrlYm0Nke2Ukh59G07z7jQbxnrUvLzkcehCeEFXKemADQqp0VMKLurc9vIA2JwgsZnKBTXKQNHJvdOYx/QftuXA9aA4Wpwgl6B2932EJUFR5xJMoAGIMFjSmPMCod0HkmFCDYvgLurtUnwSntcdIP5PxIdrEdwZbKH5gwCZD/0OLGGHwPeK7m4uLKkHnN6NbJn+aA7PC3UIAX7VWlvmDnbXrMjF/3/9j2hsia/LiZr3Ojmf3fziwFnE1lK0g38ucFDcvSKznuxYeiuD8MQ3kPYnrxx/80bXhKA0RwN0NQjz4XcNmzThNqGa+YXq5AP2z0Dnal+djXaHZqg3L9Wa+FRwQTBoUjgIUCRzseGHrAtqM7B0V+qjxB4qGx0ymd/SwIIMBK3UYZfTlBp2LqIH15tS5J+mLysQ//rmv1LwyONCB+MYsc6b6Sgn+FU+9gmwvtNnASG0jXPieDdgok3ZtXwddvd4Y/Ea+JjOondJ2V4NG5qzeDddT/BatBroubmP4+fBOXbxsyBHZJmZMadKcQ+ksGq9Slg+XGXdn1WxXsrFeK2drygpOaernd5nsZQb4mDi/pPMvxQMgmU+pCaZAOgWEbv61mY+/psNVcnX1kfjoT
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2024 23:47:08.7023
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f22f1e9-7db5-4327-39c8-08dc58ef5e9c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB56.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8192

On Thu, Apr 04, 2024 at 02:50:33PM -0400, Paolo Bonzini wrote:
> From: Michael Roth <michael.roth@amd.com>
> 
> In the case of SEV-SNP, whether or not a 2MB page can be mapped via a
> 2MB mapping in the guest's nested page table depends on whether or not
> any subpages within the range have already been initialized as private
> in the RMP table. The existing mixed-attribute tracking in KVM is
> insufficient here, for instance:
> 
>   - gmem allocates 2MB page
>   - guest issues PVALIDATE on 2MB page
>   - guest later converts a subpage to shared
>   - SNP host code issues PSMASH to split 2MB RMP mapping to 4K
>   - KVM MMU splits NPT mapping to 4K

Binbin caught that I'd neglected to document the last step in the
theoretical sequence here. It should state something to the effect
of:

  - guest later converts that shared page back to private

-Mike

> 
> At this point there are no mixed attributes, and KVM would normally
> allow for 2MB NPT mappings again, but this is actually not allowed
> because the RMP table mappings are 4K and cannot be promoted on the
> hypervisor side, so the NPT mappings must still be limited to 4K to
> match this.
> 
> Add a hook to determine the max NPT mapping size in situations like
> this.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Message-Id: <20231230172351.574091-31-michael.roth@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h | 1 +
>  arch/x86/include/asm/kvm_host.h    | 2 ++
>  arch/x86/kvm/mmu/mmu.c             | 8 ++++++++
>  3 files changed, 11 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index c81990937ab4..2db87a6fd52a 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -140,6 +140,7 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>  KVM_X86_OP_OPTIONAL(get_untagged_addr)
>  KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
>  KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
> +KVM_X86_OP_OPTIONAL_RET0(gmem_validate_fault)
>  KVM_X86_OP_OPTIONAL(gmem_invalidate)
>  
>  #undef KVM_X86_OP
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 59c7b95034fc..67dc108dd366 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1811,6 +1811,8 @@ struct kvm_x86_ops {
>  	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
>  	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>  	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
> +	int (*gmem_validate_fault)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, bool is_private,
> +				   u8 *max_level);
>  };
>  
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 992e651540e8..13dd367b8af1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4338,6 +4338,14 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
>  			       fault->max_level);
>  	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
>  
> +	r = static_call(kvm_x86_gmem_validate_fault)(vcpu->kvm, fault->pfn,
> +						     fault->gfn, fault->is_private,
> +						     &fault->max_level);
> +	if (r) {
> +		kvm_release_pfn_clean(fault->pfn);
> +		return r;
> +	}
> +
>  	return RET_PF_CONTINUE;
>  }
>  
> -- 
> 2.43.0
> 

