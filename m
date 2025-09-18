Return-Path: <kvm+bounces-58001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1B6BB8436A
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 12:47:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA5E03A5D67
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 10:45:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9081F2F5A3C;
	Thu, 18 Sep 2025 10:44:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6761D2EF646
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 10:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758192287; cv=none; b=H+9n+FnxFpKd+6djWXpzI/nqsm3LOAI2Qvsyz3LlE1VhYAwCfMdW0eW/rOMpYvMPL8NU5RdkHXo2dNMv7fFIHiMF1pQauLa8USXkt08nU/M/Jpa6LaqbtieUHQ8t3nOE5dXP9jnmxjWgbJbWyQX4QrXF/GZGa3B21P7x/Ho8sBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758192287; c=relaxed/simple;
	bh=XIxTdkZQwNuo+iT3HG+kNIz8D2sUUCn5eb1mwOYl7c4=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=jLwIlhrxFSfbvNIUIW8H6/Uk+2b/IdXxonGEJwbEc6c88FFXUQsRx+GbFVOl6j2zdjwJha1LsXndESIcdRgnQsT76OjRJvG3VDS+Ed+cD8dvcu/pU1KNzD4OIOiFaD/fwBihefM58Z2XDbgP9uT5Nkj0fPgwz1Qls1C+6Sqd/Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cSC1h4Y5cz14N7R;
	Thu, 18 Sep 2025 18:44:24 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id 7EBA0180B57;
	Thu, 18 Sep 2025 18:44:41 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Sep 2025 18:44:40 +0800
Subject: Re: [PATCH 02/13] KVM: arm64: selftests: Initialize VGICv3 only once
To: Oliver Upton <oliver.upton@linux.dev>
CC: <kvmarm@lists.linux.dev>, Marc Zyngier <maz@kernel.org>, Joey Gouly
	<joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank
	<frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, David
 Hildenbrand <david@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
	<kvm@vger.kernel.org>
References: <20250917212044.294760-1-oliver.upton@linux.dev>
 <20250917212044.294760-3-oliver.upton@linux.dev>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <2a381e6c-2167-eb90-c90b-64253b51c6ce@huawei.com>
Date: Thu, 18 Sep 2025 18:44:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250917212044.294760-3-oliver.upton@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200017.china.huawei.com (7.202.194.83)

On 2025/9/18 5:20, Oliver Upton wrote:
> vgic_v3_setup() unnecessarily initializes the vgic twice. Keep the
> initialization after configuring MMIO frames and get rid of the other.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  tools/testing/selftests/kvm/lib/arm64/vgic.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/arm64/vgic.c b/tools/testing/selftests/kvm/lib/arm64/vgic.c
> index 4427f43f73ea..64e793795563 100644
> --- a/tools/testing/selftests/kvm/lib/arm64/vgic.c
> +++ b/tools/testing/selftests/kvm/lib/arm64/vgic.c
> @@ -56,9 +56,6 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs)
>  
>  	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS, 0, &nr_irqs);
>  
> -	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> -			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
> -

.. which was added by commit e5410ee2806d ("KVM: selftests: aarch64:
Cmdline arg to set number of IRQs in vgic_irq test").

>  	attr = GICD_BASE_GPA;
>  	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>  			    KVM_VGIC_V3_ADDR_TYPE_DIST, &attr);

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

Thanks,
Zenghui

