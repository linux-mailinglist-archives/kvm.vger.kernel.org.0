Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE4A741602
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 18:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjF1QEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 12:04:37 -0400
Received: from mail-bn1nam02on2053.outbound.protection.outlook.com ([40.107.212.53]:46919
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230401AbjF1QEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 12:04:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kmCWI2CO1X3fGXZ0ZSpyept9LBIwnF7JC24VmdzvXGoOXO1/xGT0Tr18GTpwxSXOxMOWUSIZaXXWsBzMjv7o5/2eezL7Ygj79iVuxlO7Q+TIDOXY0gcCCv7++Xdfi88La2Qc0pDZsN8UEjP7zIiGjR5/HTAWQDI8XSXRsg1wSAGbCkxNhNtjvFW/bZKoqIfc2pOKDqFOHToM+OZjjv32WHTT/+khCXhLwoA3mh9NrBKf4VF4yoWzQycEiwrX8fXn6bh7Ng2vQUoamkgfSSXxmOWQZwJFS/ZaFga/A4mG7+kb0etsavCp/WaLX19barke9JBd78f6/MVBOVplQj/DXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZgS6kGECvPoNxMZv5WdB7ShAjP3rtPhWeqqwvlYDjTA=;
 b=mQJN+rMb5754KfaKyrN6dz4NgBYBfydnRrC6jFfSBz1elxrKmotR5jBdJ3GfK6jpz+vnK+K5wZhqInNxrIpP6yxbDeY4dNqc5Ts0SvRwKRgxK42/I88MnKDzxYmWnim58+Ie6FyyozgQgmlqfjouuNWtPEy2LWaZDkq7Lf45QcwP1WI4jrSgpqggr1d1D/BPmS7HkU0e0i+1DUG2Wc0GZc0G8TP6Wxf3XoQZwhyLbRnzc44kkycA6If7SN+gBrc13zxColpJXK0kAe16Rb7q+njVjuXNke1iZfvlMjUhb10OUdTntMWEJK3CnjdXCHUCo3hihMivPAfXZvvjSckd2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZgS6kGECvPoNxMZv5WdB7ShAjP3rtPhWeqqwvlYDjTA=;
 b=r60QjD0gMI4Le6ObpOE55W/SKOYtautB0pG47SWxmcdvjju9H7VvxB+TYeMoEqtF54IpkOdCkkAFFIs7Iav7ELWB1tw1ZPNSO5hJ16J/IRiaCTEZLByrLLejFN/AlxzeW739nfpQDTBm4AhzCJK33tFh7NLbNNqzWheRlacQaM8=
Received: from BN9PR03CA0463.namprd03.prod.outlook.com (2603:10b6:408:139::18)
 by BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Wed, 28 Jun
 2023 16:04:31 +0000
Received: from BN8NAM11FT094.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::34) by BN9PR03CA0463.outlook.office365.com
 (2603:10b6:408:139::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.34 via Frontend
 Transport; Wed, 28 Jun 2023 16:04:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT094.mail.protection.outlook.com (10.13.176.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.48 via Frontend Transport; Wed, 28 Jun 2023 16:04:31 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 28 Jun
 2023 11:04:30 -0500
Date:   Wed, 28 Jun 2023 10:21:32 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <isaku.yamahata@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        <erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, <chen.bo@intel.com>,
        <linux-coco@lists.linux.dev>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>
Subject: Re: [RFC PATCH v2 5/6] KVM: Add flags to struct kvm_gfn_range
Message-ID: <20230628152132.xyfquj67vhklsvlu@amd.com>
References: <cover.1687474039.git.isaku.yamahata@intel.com>
 <689da77417c2f4055f02a71aab51ff603bc195af.1687474039.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <689da77417c2f4055f02a71aab51ff603bc195af.1687474039.git.isaku.yamahata@intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT094:EE_|BL1PR12MB5320:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c224ae6-2195-42a6-8473-08db77f15bbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AYqOUpk6tDGC4QKxUDtextN9dLWteHmspsqwt61szAoZQ+juAR2nCk3brPMCvu6ZHpx2l157S0Holhv9Pzw1eue/Et8djXDrM7b8v2ng2Re8XW2qIz+MFz7DUaSEMpk0wwtxV+NQ+bLYaB8Ibi0uZs//hpbFuRNMd7TgEXeky8H+4xB5nRuG6m3cdA5k9JWl4kn2X4QovmV7XLQCiBbH8OktK01lhhnRkHzFpyjyXiLrE6tKZTlEyHXGQ+jyHJY5Cg4fH9cnFSjf4LwLuD3fpoOb744+LkE1/jG6TFyfJ00LMDfN+FcS5gnvm7TTkQUWMAEQjb2l083Vh1kLVsyHyNR4OMe8RUupjXJ69S5RUa1NtSwwsqcPulabqY20foDApinyTguKyIPPJK5dycepwqBn8TkmndIvzGELM51OtJMJ+UFJkF3400QVUUqdfe5m/31SOAenhHI+jBU869pCCGwa+3a7n+HuJlLItvkTFqdbnY2jO+ZlwiLaTqDwCXUpVHm02ijyz4crFRACzuGulU4GAw/pIyEtkC40oxj1hdCjUduL0unHiJx+vaDiU9oecjX6CKyEsBEUOAU1KCc6r5SJ2pTR64/HPPcaDbvpAM0vUateux1pDs48ZIsqrH1TSghppH1vCncw2MwnOqdcK9BQAME3Z2d7HDKQKseeBL5Zlt8U9Hbz+N7WM/Z6kwfWR/DglzzmKXR71Er6Vh2a+HcbYmpzR1IB9XLwkG72zvw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(451199021)(40470700004)(36840700001)(46966006)(54906003)(508600001)(83380400001)(2616005)(47076005)(36860700001)(336012)(86362001)(40460700003)(426003)(82310400005)(16526019)(1076003)(26005)(186003)(81166007)(2906002)(4326008)(36756003)(6916009)(8936002)(70206006)(70586007)(316002)(356005)(7416002)(44832011)(8676002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2023 16:04:31.2780
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c224ae6-2195-42a6-8473-08db77f15bbe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT094.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5320
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 22, 2023 at 04:16:29PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add flags to strut kvm_gfn_range to indicate who triggered the callback
> and new memory attributes.
> 
> TDX needs to know the reason for a callback by kvm_unmap_gfn_range().  mmu
> notifier, set memory attributes ioctl or KVM gmem callback.  With TDX,
> zapping a private page from the encrypted page table and adding the page
> back to the same private GPA results in zeroing the page, and the guest has
> to accept the page again.  On the change of memory attribute from private
> to shared, zapping the GPA range irrespective to private-or-shared and
> expecting the fault doesn't work for TDX.  Instead, zap shared pages only
> and keep the private pages.  Concretely
> - If it's from mmu notifier, zap shared pages.
> - If it's from KVM gmem, zap private pages.
> - If setting memory attributes to private, zap shared pages.
> - If setting memory attributes to shared, zap private pages.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> ---
> Changes v1 -> v2:
> - consolidate KVM_GFN_RANGE_FLAGS_GMEM_{PUNCH_HOLE, RELEASE} into
>   KVM_GFN_RANGE_FLAGS_GMEM.
> - Update the commit message to describe TDX more.  Drop SEV_SNP.
> ---
>  include/linux/kvm_host.h | 10 +++++++++-
>  virt/kvm/guest_mem.c     |  9 ++++++---
>  virt/kvm/kvm_main.c      |  4 +++-
>  3 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1a47cedae8a1..1fe0516fcddf 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -256,12 +256,20 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
>  #endif
>  
>  #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
> +
> +#define KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR	BIT(0)
> +#define KVM_GFN_RANGE_FLAGS_GMEM		BIT(1)
> +
>  struct kvm_gfn_range {
>  	struct kvm_memory_slot *slot;
>  	gfn_t start;
>  	gfn_t end;
> -	pte_t pte;
> +	union {
> +		pte_t pte;
> +		u64 attrs;
> +	};
>  	bool may_block;
> +	unsigned int flags;
>  };
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
>  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
> diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
> index cdf2d84683c8..387226136960 100644
> --- a/virt/kvm/guest_mem.c
> +++ b/virt/kvm/guest_mem.c
> @@ -99,7 +99,8 @@ static struct folio *kvm_gmem_get_folio(struct file *file, pgoff_t index)
>  }
>  
>  static void kvm_gmem_invalidate_begin(struct kvm *kvm, struct kvm_gmem *gmem,
> -				      pgoff_t start, pgoff_t end)
> +				      pgoff_t start, pgoff_t end,
> +				      unsigned int flags)
>  {
>  	struct kvm_memory_slot *slot;
>  	unsigned long index;
> @@ -118,6 +119,7 @@ static void kvm_gmem_invalidate_begin(struct kvm *kvm, struct kvm_gmem *gmem,
>  			.slot = slot,
>  			.pte = __pte(0),
>  			.may_block = true,
> +			.flags = flags,
>  		};
>  
>  		kvm_mmu_invalidate_range_add(kvm, gfn_range.start, gfn_range.end);
> @@ -156,7 +158,8 @@ static long kvm_gmem_punch_hole(struct file *file, loff_t offset, loff_t len)
>  	 */
>  	filemap_invalidate_lock(file->f_mapping);
>  
> -	kvm_gmem_invalidate_begin(kvm, gmem, start, end);
> +	kvm_gmem_invalidate_begin(kvm, gmem, start, end,
> +				  KVM_GFN_RANGE_FLAGS_GMEM);

Do you anticipate ever needing to pass a different flag via
kvm_gmem_invalidate_begin()? If not it might make sense to just
hard-code it rather than passing as a parameter.

-Mike
