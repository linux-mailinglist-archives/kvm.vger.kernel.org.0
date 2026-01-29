Return-Path: <kvm+bounces-69571-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ICFWJ26Te2nOGAIAu9opvQ
	(envelope-from <kvm+bounces-69571-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:05:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 48F2EB29FB
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:05:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3659F304D265
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 283FC346AF0;
	Thu, 29 Jan 2026 17:02:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A823009C1;
	Thu, 29 Jan 2026 17:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769706177; cv=none; b=LFwON2AqtG1DbsGNo/NHPM7ww4Ia2fCKvSx42CMTmMOtnIN8bChO6Za3IbTkl90jes6eGmSHrmSgk2LO6+BUD4hQxvP7mIX3OO8nxEJbL6zBw/wdpc9QFkjH2jXcpCUiGJVXK0tZjWJ2iXdC+N95xkjKIzPVixbuC+hSv8KXEC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769706177; c=relaxed/simple;
	bh=q1gQCviJCAe+AZSj756VfNj4A1hZWH1AR6+aLsFTsRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=cTdhVAFTYvBARfNlcMwcgNDtJevA2jpsrIOLnk53XNP7lYjiVX7Gr9oFN5oeZG374p9Eq13Vzi1ls+vQ0ay+JrpL8ESu0QYptxSUSIW2XOOHbpsxKNarbN9lFyVS+5gsREXkg/U6VnmZisZuw738+qgkMYiLJPnXKrigNnA3PeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E7529153B;
	Thu, 29 Jan 2026 09:02:46 -0800 (PST)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 070FB3F73F;
	Thu, 29 Jan 2026 09:02:50 -0800 (PST)
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oliver.upton@linux.dev,
	catalin.marinas@arm.com,
	corbet@lwn.net,
	pbonzini@redhat.com,
	will@kernel.org,
	linux-kernel@vger.kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yezhenyu2@huawei.com,
	xiexiangyou@huawei.com,
	zhengchuan@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v2 2/5] KVM: arm64: Support set the DBM attr during memory abort
Date: Thu, 29 Jan 2026 17:02:41 +0000
Message-ID: <aXuSsVKtXBcffzo2@devkitleo>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121092342.3393318-3-zhengtian10@huawei.com>
References: <20251121092342.3393318-1-zhengtian10@huawei.com> <20251121092342.3393318-3-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.86 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	R_DKIM_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leo.bras@arm.com,kvm@vger.kernel.org];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69571-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[]
X-Rspamd-Queue-Id: 48F2EB29FB
X-Rspamd-Action: no action

On Fri, Nov 21, 2025 at 05:23:39PM +0800, Tian Zheng wrote:
> From: eillon <yezhenyu2@huawei.com>
> 
> Add DBM support to automatically promote write-clean pages to
> write-dirty, preventing users from being trapped in EL2 due to
> missing write permissions.
> 
> Since the DBM attribute was introduced in ARMv8.1 and remains
> optional in later architecture revisions, including ARMv9.5.
> 
> Support set the DBM attr during user_mem_abort().
> 
> Signed-off-by: eillon <yezhenyu2@huawei.com>
> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 4 ++++
>  arch/arm64/kvm/hyp/pgtable.c         | 6 ++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 2888b5d03757..2fa24953d1a6 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -91,6 +91,8 @@ typedef u64 kvm_pte_t;
> 
>  #define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
> 
> +#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
> +
>  #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
> 
>  #define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
> @@ -245,6 +247,7 @@ enum kvm_pgtable_stage2_flags {
>   * @KVM_PGTABLE_PROT_R:		Read permission.
>   * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
>   * @KVM_PGTABLE_PROT_NORMAL_NC:	Normal noncacheable attributes.
> + * @KVM_PGTABLE_PROT_DBM:	Dirty bit management attribute.
>   * @KVM_PGTABLE_PROT_SW0:	Software bit 0.
>   * @KVM_PGTABLE_PROT_SW1:	Software bit 1.
>   * @KVM_PGTABLE_PROT_SW2:	Software bit 2.
> @@ -257,6 +260,7 @@ enum kvm_pgtable_prot {
> 
>  	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
>  	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(4),
> +	KVM_PGTABLE_PROT_DBM			= BIT(5),
> 
>  	KVM_PGTABLE_PROT_SW0			= BIT(55),
>  	KVM_PGTABLE_PROT_SW1			= BIT(56),
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index c351b4abd5db..ce41c6924ebe 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -694,6 +694,9 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
>  	if (prot & KVM_PGTABLE_PROT_W)
>  		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> 
> +	if (prot & KVM_PGTABLE_PROT_DBM)
> +		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> +
>  	if (!kvm_lpa2_is_enabled())
>  		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
> 
> @@ -1303,6 +1306,9 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>  	if (prot & KVM_PGTABLE_PROT_W)
>  		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> 
> +	if (prot & KVM_PGTABLE_PROT_DBM)
> +		set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> +
>  	if (prot & KVM_PGTABLE_PROT_X)
>  		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
> 


Hi Tian,

I was re-reading this series while planning the other feature I am working 
on top of this one.

This patch, IMHO, is unrelated to the HDBSS feature.
I get that HDBSS feature needs this bit being set in the page descriptor
but it was not introduced in this feature.

It was actually introduced in HAFDBS.

So maybe it's worth to split this series in:
- Enable HAFDBS for KVM, and
- Enable HDBSS

I have something here that could serve as a base for that, will clean that 
up and send as an example.

Thanks!
Leo

