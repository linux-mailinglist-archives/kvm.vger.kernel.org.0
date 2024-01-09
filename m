Return-Path: <kvm+bounces-5917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 33992828FE9
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:27:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DBCED1F26354
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 22:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 149E33DBA8;
	Tue,  9 Jan 2024 22:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jGqcWJl4"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF4F3DB85
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 22:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 10 Jan 2024 07:27:28 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1704839258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=//byNdyH4DaDg6zka9544r4yink0BmDgeQDdstjvKWQ=;
	b=jGqcWJl4jdGTPDn20roC5JC6AemYhbYP9SdCADzwkGkWluW/slwz3mykj9KVcYMMTI0DiQ
	lCsV/MXA4sqHcTPt1mPqjeCa5hnposboQVW0EtivSq0Ao2hMcm/slKPehGYem0LasrwYwW
	6WEEdDMSRATkiwt2WQimd2K2SpChJMA=
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
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v1] KVM: arm64: selftests: Handle feature fields with
 nonzero minimum value correctly
Message-ID: <ZZ3IUPwhLKNv98QZ@vm3>
References: <20240109165622.4104387-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240109165622.4104387-1-jingzhangos@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 09, 2024 at 08:56:21AM -0800, Jing Zhang wrote:
> There are some feature fields with nonzero minimum valid value. Make
> sure get_safe_value() won't return invalid field values for them.
> Also fix a bug that wrongly uses the feature bits type as the feature
> bits sign causing all fields as signed in the get_safe_value() and
> get_invalid_value().
> 
> Fixes: 54a9ea73527d ("KVM: arm64: selftests: Test for setting ID register from usersapce")
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Reported-by: Itaru Kitayama <itaru.kitayama@linux.dev>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  .../selftests/kvm/aarch64/set_id_regs.c       | 20 +++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> index bac05210b539..f17454dc6d9e 100644
> --- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> @@ -224,13 +224,20 @@ uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
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
> +			uint64_t min_safe = 0;
> +
> +			if (!strcmp(ftr_bits->name, "ID_AA64DFR0_EL1_DebugVer"))
> +				min_safe = ID_AA64DFR0_EL1_DebugVer_IMP;
> +			else if (!strcmp(ftr_bits->name, "ID_DFR0_EL1_CopDbg"))
> +				min_safe = ID_DFR0_EL1_CopDbg_Armv8;
> +
> +			if (ftr > min_safe)
>  				ftr--;
>  			break;
>  		case FTR_HIGHER_SAFE:
> @@ -252,7 +259,12 @@ uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
>  			ftr = ftr_bits->safe_val;
>  			break;
>  		case FTR_LOWER_SAFE:
> -			if (ftr > 0)
> +			uint64_t min_safe = 0;
> +
> +			if (!strcmp(ftr_bits->name, "ID_DFR0_EL1_PerfMon"))
> +				min_safe = ID_DFR0_EL1_PerfMon_PMUv3;
> +
> +			if (ftr > min_safe)
>  				ftr--;
>  			break;
>  		case FTR_HIGHER_SAFE:
> @@ -276,7 +288,7 @@ uint64_t get_invalid_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
>  {
>  	uint64_t ftr_max = GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);
>  
> -	if (ftr_bits->type == FTR_UNSIGNED) {
> +	if (ftr_bits->sign == FTR_UNSIGNED) {
>  		switch (ftr_bits->type) {
>  		case FTR_EXACT:
>  			ftr = max((uint64_t)ftr_bits->safe_val + 1, ftr + 1);
> 

This fixes the issue seen on an AEM RevC FVP launched via the shrinkwrap
ns-edk2.yaml config.

[...]
# ok 79 ID_AA64ZFR0_EL1_SVEver
# # Totals: pass:79 fail:0 xfail:0 xpass:0 skip:0 error:0
ok 1 selftests: kvm: set_id_regs

Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>

Thanks,
Itaru.

> base-commit: 0dd3ee31125508cd67f7e7172247f05b7fd1753a
> -- 
> 2.43.0.472.g3155946c3a-goog
> 

