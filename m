Return-Path: <kvm+bounces-6294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF1BA82E327
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 00:07:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 31CBDB2218F
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 23:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCCED1B7E3;
	Mon, 15 Jan 2024 23:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZUai/ujk"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B675F1B5BA
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 23:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 16 Jan 2024 08:07:18 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705360047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BkFq3LEv+V+5jZZwFAZjydWZ/AIL0WUeLSmrK+uOJi0=;
	b=ZUai/ujkNJpzji/mDPuh90wC+DpN1Hzcyah1T04PaWoh+ix3VtC6AsatEM2IUd22Am88av
	teBCpb1xa3C+kyQ0XuWv2Rak+Ig/2GcN4GBYHiZAWihoqTpF0/vldOdVOgo7jHXmXIV2jY
	GEnaxPcbIE4NQa4KJ/YhJ3I+jWCS00U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
	ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>
Subject: Re: [PATCH v2] KVM: arm64: selftests: Handle feature fields with
 nonzero minimum value correctly
Message-ID: <ZaW6pqv1/3Pehn3u@vm3>
References: <20240115220210.3966064-1-jingzhangos@google.com>
 <20240115220210.3966064-2-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115220210.3966064-2-jingzhangos@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 15, 2024 at 02:02:09PM -0800, Jing Zhang wrote:
> There are some feature fields with nonzero minimum valid value. Make
> sure get_safe_value() won't return invalid field values for them.
> Also fix a bug that wrongly uses the feature bits type as the feature
> bits sign causing all fields as signed in the get_safe_value() and
> get_invalid_value().
> 
> Fixes: 54a9ea73527d ("KVM: arm64: selftests: Test for setting ID register from usersapce")
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Reported-by: Itaru Kitayama <itaru.kitayama@linux.dev>
> Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>

v2 works on FVP.
Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>

Thanks,
Itaru.

> 
> ---
> * v1 -> v2:
>   - Use ftr_bits->safe_val for minimal safe value for type FTR_LOWER_SAFE.
>   - Fix build error reported by Zenghui with gcc-10.3.1.
> ---
>  .../selftests/kvm/aarch64/set_id_regs.c        | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> index bac05210b539..16e2338686c1 100644
> --- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> @@ -32,6 +32,10 @@ struct reg_ftr_bits {
>  	enum ftr_type type;
>  	uint8_t shift;
>  	uint64_t mask;
> +	/*
> +	 * For FTR_EXACT, safe_val is used as the exact safe value.
> +	 * For FTR_LOWER_SAFE, safe_val is used as the minimal safe value.
> +	 */
>  	int64_t safe_val;
>  };
>  
> @@ -65,13 +69,13 @@ struct test_feature_reg {
>  
>  static const struct reg_ftr_bits ftr_id_aa64dfr0_el1[] = {
>  	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, PMUVer, 0),
> -	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, DebugVer, 0),
> +	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, DebugVer, ID_AA64DFR0_EL1_DebugVer_IMP),
>  	REG_FTR_END,
>  };
>  
>  static const struct reg_ftr_bits ftr_id_dfr0_el1[] = {
> -	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_DFR0_EL1, PerfMon, 0),
> -	REG_FTR_BITS(FTR_LOWER_SAFE, ID_DFR0_EL1, CopDbg, 0),
> +	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_DFR0_EL1, PerfMon, ID_DFR0_EL1_PerfMon_PMUv3),
> +	REG_FTR_BITS(FTR_LOWER_SAFE, ID_DFR0_EL1, CopDbg, ID_DFR0_EL1_CopDbg_Armv8),
>  	REG_FTR_END,
>  };
>  
> @@ -224,13 +228,13 @@ uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
>  {
>  	uint64_t ftr_max = GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);
>  
> -	if (ftr_bits->type == FTR_UNSIGNED) {
> +	if (ftr_bits->sign == FTR_UNSIGNED) {
>  		switch (ftr_bits->type) {
>  		case FTR_EXACT:
>  			ftr = ftr_bits->safe_val;
>  			break;
>  		case FTR_LOWER_SAFE:
> -			if (ftr > 0)
> +			if (ftr > ftr_bits->safe_val)
>  				ftr--;
>  			break;
>  		case FTR_HIGHER_SAFE:
> @@ -252,7 +256,7 @@ uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
>  			ftr = ftr_bits->safe_val;
>  			break;
>  		case FTR_LOWER_SAFE:
> -			if (ftr > 0)
> +			if (ftr > ftr_bits->safe_val)
>  				ftr--;
>  			break;
>  		case FTR_HIGHER_SAFE:
> @@ -276,7 +280,7 @@ uint64_t get_invalid_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
>  {
>  	uint64_t ftr_max = GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);
>  
> -	if (ftr_bits->type == FTR_UNSIGNED) {
> +	if (ftr_bits->sign == FTR_UNSIGNED) {
>  		switch (ftr_bits->type) {
>  		case FTR_EXACT:
>  			ftr = max((uint64_t)ftr_bits->safe_val + 1, ftr + 1);
> 
> base-commit: 0dd3ee31125508cd67f7e7172247f05b7fd1753a
> -- 
> 2.43.0.381.gb435a96ce8-goog
> 

