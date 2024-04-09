Return-Path: <kvm+bounces-14043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E22D589E659
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 01:47:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 39254B22EA7
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 23:47:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08CA61591FC;
	Tue,  9 Apr 2024 23:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xVuQzfCE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2064.outbound.protection.outlook.com [40.107.101.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597D9158DAA;
	Tue,  9 Apr 2024 23:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712706412; cv=fail; b=YOwG1suzvteZqo8aQK6y7NzShk9g7mKfzLTnlpgdkepLIvNzmwwdlAwHNEe6NRyAlQHKIqTPQ0GjyBPX0WMVqDCnZUl8P9czK3/7a9cUIxQJJtvrJmqP9z9/tuDqnjSQwQLSoLibGKMlCOsru3GuKMrnLDff3XO1WPEOLqmQbyc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712706412; c=relaxed/simple;
	bh=uij4znCTQR9kMW4quQQZ2MHqAUIDszgrxafUxYVpQLI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JsTB0rHVSHDceTfQMTL+7o85jbNnFYx/odTxcpz7d2NnSs2FKr13enTV2U0tqRIJWTdgPx0ZT4o/Bm1mzU6qIO8Sn0wAP2Qg53s3zWnDzrCJxfQEMWGZP1uIcZTncUjRQ/650UZFKX57rOLY1XDP+NxFAVyvyaC02gX2QT3WwRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xVuQzfCE; arc=fail smtp.client-ip=40.107.101.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2wf2cPT4yP27gLHWEMVuJ9tgjOtFqQCSIjCbabqcUiqdjhRY0WenSIFZCu8XLIJGsdnSjOVXvtem+7/XOQi1YudWqHebtvKL997WcdDbVrSznCbAR1cIzmYbddkLNm34W5zpVX9zSBgZgOgS0Vjt5fFRzwnyb8KG1s5W2DNVZKxeDwI9m3oScSeTpF+9CdAAB4H4OkbXYKX4qqwTyiSkJyFdoACWedWosNjcnaCVaZbaA9QPzuoAA5MGW2c4yNW850JhounmH3+GviENwTC8spLno/Lp/0FN0864c6/PZvzhoN6TkK8FXrMIYLJCkaumJwHfZzkasCEyW17NVJ4Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WN/BJdzXy76+BDeOTlQn2RuppyJHceidGxubrrPPX8U=;
 b=b4XCliZ32bc4py0UhU+9EV4nBg0On+3CUQh9hTWD00f+zPoSpXEVuKWVEyk1mMGmvc7AIh7gfyXOthWOc9Sn8FswDZikaX4OC0WS0Rry2Kl9aAZhuzefRxMboK9tt7OWS0HH961bE2OlM8FXqgrrGnciEVOjWjXtcDm+oluMVtrtcDHtVgrg+oE4OtWV0oYVNsQhzPSpY0fzPszMRNs5zDRWIde4o2WjgKk0XP959X2kEh1nSUr95tjj9zBFfnDc2rRR2Wulm39/59fvn05PEggJGeders/dcESI2yDB+canU2eyURFeZKvPdHTK/uKpvtcx/NjgwaYcDSxt4fg7Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WN/BJdzXy76+BDeOTlQn2RuppyJHceidGxubrrPPX8U=;
 b=xVuQzfCEQM795GL+wasW4EQngYjljbA4YjhQm0aGFyn4qDNR5yZjMuukBRw72mGANclCo4vHK9x48KztW7F0RN6ZrFyTIQf7rOwxi9bh7x+iGngNythR9qbZMC8BIJqs8S6k3Ci4mTw1RtVx7vEOp0Ua2hlgKyw0Gxd+8clcMCY=
Received: from MN2PR20CA0037.namprd20.prod.outlook.com (2603:10b6:208:235::6)
 by CY8PR12MB7753.namprd12.prod.outlook.com (2603:10b6:930:93::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 9 Apr
 2024 23:46:48 +0000
Received: from BL6PEPF0001AB55.namprd02.prod.outlook.com
 (2603:10b6:208:235:cafe::e6) by MN2PR20CA0037.outlook.office365.com
 (2603:10b6:208:235::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.34 via Frontend
 Transport; Tue, 9 Apr 2024 23:46:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB55.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Tue, 9 Apr 2024 23:46:47 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 9 Apr
 2024 18:46:47 -0500
Date: Tue, 9 Apr 2024 18:35:42 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <isaku.yamahata@intel.com>
Subject: Re: [PATCH 07/11] KVM: guest_memfd: extract __kvm_gmem_get_pfn()
Message-ID: <20240409233542.aapmef7mkztgbnv2@amd.com>
References: <20240404185034.3184582-1-pbonzini@redhat.com>
 <20240404185034.3184582-8-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240404185034.3184582-8-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB55:EE_|CY8PR12MB7753:EE_
X-MS-Office365-Filtering-Correlation-Id: debaadf2-6467-44fa-9acd-08dc58ef5243
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cNlry1k166MXclMw8RLqn62jsMKQc3QZ1TmFmcI6o3NO1YkKsl4Wq61KXcXz6qb3mUCZzAXulLnUDt7pMYReuTcdoo0wHaJzxhkBz+0PFQLHm7TghssvIC/+neRTcpQscOUMYmC70CELhAK8MY6etz5hORCEuS/RWwvW8xgoJTXGoyDS9MY1DSWD2M81SNaCPdUTm+hRtI9HkBX9lr5RWF8sfmOdd9tuXyR07wvsLFvzswEPVYYHwmJxg6iQ0gkt5nz30mLPfk2AZu9MIay2DuQx0HhtoAhczeosLOyZUpGwUBjnVfvpQXvPls5Z7aR3iQBJuCSt86CbidCR2FkZNmbNY85Hz8EjX7tEMRyMY+59pItXtP17a9hcIGJP/dgD8FD8B+PZjFMGi+eKr79CAMgDhNzLfWski9W4X+t3mnAtfMMjiVWanW3SDtLtGBQQwqMLJJkZ7zf+iCKfBq1HhIkmpix/Kdn81LxgLcVVwflXDiejzNv7Qn7kH8am5hXz5MFFDPaid8jgji41R0ehsmLVpSQkduuecV0dHQeGnTFp3aepxfXsEg5ya96lt+4eaYGh83ByGaIgvLFuOlMMmryq2NCvPMq1u9FHGW24foCdZsKcPyIxN5Q6a198aNoDZ0fYH/+bY/1/e5NBOFCMwhvrvHunuQ2QBnSKLncwEVvPgIWPg3+56FRaPwtXkiWio4Yu69ztFnKrx/BXfj36Yfv1CRVDx3nDzNzzevUfYjMcg3qkbskv+KEl9IOOhVN2
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2024 23:46:47.9889
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: debaadf2-6467-44fa-9acd-08dc58ef5243
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB55.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7753

On Thu, Apr 04, 2024 at 02:50:29PM -0400, Paolo Bonzini wrote:
> In preparation for adding a function that walks a set of pages
> provided by userspace and populates them in a guest_memfd,
> add a version of kvm_gmem_get_pfn() that has a "bool prepare"
> argument and passes it down to kvm_gmem_get_folio().
> 
> Populating guest memory has to call repeatedly __kvm_gmem_get_pfn()
> on the same file, so make the new function take struct file*.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/guest_memfd.c | 38 +++++++++++++++++++++++---------------
>  1 file changed, 23 insertions(+), 15 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 486748e65f36..a537a7e63ab5 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -540,33 +540,29 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
>  	fput(file);
>  }
>  
> -int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> -		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
> +static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
> +		       gfn_t gfn, kvm_pfn_t *pfn, int *max_order, bool prepare)
>  {
>  	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
> -	struct kvm_gmem *gmem;
> +	struct kvm_gmem *gmem = file->private_data;
>  	struct folio *folio;
>  	struct page *page;
> -	struct file *file;
>  	int r;
>  
> -	file = kvm_gmem_get_file(slot);
> -	if (!file)
> +	if (file != slot->gmem.file) {
> +		WARN_ON_ONCE(slot->gmem.file);
>  		return -EFAULT;
> +	}
>  
>  	gmem = file->private_data;
> -
>  	if (xa_load(&gmem->bindings, index) != slot) {
>  		WARN_ON_ONCE(xa_load(&gmem->bindings, index));
> -		r = -EIO;
> -		goto out_fput;
> +		return -EIO;
>  	}
>  
>  	folio = kvm_gmem_get_folio(file_inode(file), index, true);

This should be:

  folio = kvm_gmem_get_folio(file_inode(file), index, prepare);

Otherwise:

Reviewed-by: Michael Roth <michael.roth@amd.com>

-Mike

> -	if (!folio) {
> -		r = -ENOMEM;
> -		goto out_fput;
> -	}
> +	if (!folio)
> +		return -ENOMEM;
>  
>  	if (folio_test_hwpoison(folio)) {
>  		r = -EHWPOISON;
> @@ -583,9 +579,21 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  
>  out_unlock:
>  	folio_unlock(folio);
> -out_fput:
> -	fput(file);
>  
>  	return r;
>  }
> +
> +int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> +		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
> +{
> +	struct file *file = kvm_gmem_get_file(slot);
> +	int r;
> +
> +	if (!file)
> +		return -EFAULT;
> +
> +	r = __kvm_gmem_get_pfn(file, slot, gfn, pfn, max_order, true);
> +	fput(file);
> +	return r;
> +}
>  EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
> -- 
> 2.43.0
> 
> 

