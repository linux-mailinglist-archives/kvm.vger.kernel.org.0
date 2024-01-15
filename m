Return-Path: <kvm+bounces-6214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19E9182D60B
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 10:34:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCE33281EDC
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 09:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30098F4F8;
	Mon, 15 Jan 2024 09:34:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED38F4E7
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 09:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 316782F4;
	Mon, 15 Jan 2024 01:35:14 -0800 (PST)
Received: from [10.57.46.55] (unknown [10.57.46.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 58FCD3F6C4;
	Mon, 15 Jan 2024 01:34:26 -0800 (PST)
Message-ID: <4e3c051b-ccdb-47d4-9a29-5c92f5101a06@arm.com>
Date: Mon, 15 Jan 2024 09:34:24 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] KVM: arm64: selftests: Handle feature fields with
 nonzero minimum value correctly
Content-Language: en-GB
To: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
 KVMARM <kvmarm@lists.linux.dev>,
 ARMLinux <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Itaru Kitayama <itaru.kitayama@linux.dev>
References: <20240109165622.4104387-1-jingzhangos@google.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240109165622.4104387-1-jingzhangos@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/01/2024 16:56, Jing Zhang wrote:
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
>   .../selftests/kvm/aarch64/set_id_regs.c       | 20 +++++++++++++++----
>   1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> index bac05210b539..f17454dc6d9e 100644
> --- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> @@ -224,13 +224,20 @@ uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
>   {
>   	uint64_t ftr_max = GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);
>   
> -	if (ftr_bits->type == FTR_UNSIGNED) {
> +	if (ftr_bits->sign == FTR_UNSIGNED) {
>   		switch (ftr_bits->type) {
>   		case FTR_EXACT:
>   			ftr = ftr_bits->safe_val;
>   			break;
>   		case FTR_LOWER_SAFE:
> -			if (ftr > 0)
> +			uint64_t min_safe = 0;
> +
> +			if (!strcmp(ftr_bits->name, "ID_AA64DFR0_EL1_DebugVer"))
> +				min_safe = ID_AA64DFR0_EL1_DebugVer_IMP;
> +			else if (!strcmp(ftr_bits->name, "ID_DFR0_EL1_CopDbg"))
> +				min_safe = ID_DFR0_EL1_CopDbg_Armv8;

Instead of hardcoding the safe value here in the code, why not "fix" the 
safe value in the ftr_id table and use ftr_bits->safe_val for both the
above cases ?

> +
> +			if (ftr > min_safe)
>   				ftr--;
>   			break;
>   		case FTR_HIGHER_SAFE:
> @@ -252,7 +259,12 @@ uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
>   			ftr = ftr_bits->safe_val;
>   			break;
>   		case FTR_LOWER_SAFE:
> -			if (ftr > 0)
> +			uint64_t min_safe = 0;
> +
> +			if (!strcmp(ftr_bits->name, "ID_DFR0_EL1_PerfMon"))
> +				min_safe = ID_DFR0_EL1_PerfMon_PMUv3;
> +
> +			if (ftr > min_safe)
>   				ftr--;

Also, here, don't we need to type case both "ftr" and min_safe to 
int64_t for signed features ?

Suzuki

>   			break;
>   		case FTR_HIGHER_SAFE:
> @@ -276,7 +288,7 @@ uint64_t get_invalid_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
>   {
>   	uint64_t ftr_max = GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);
>   
> -	if (ftr_bits->type == FTR_UNSIGNED) {
> +	if (ftr_bits->sign == FTR_UNSIGNED) {
>   		switch (ftr_bits->type) {
>   		case FTR_EXACT:
>   			ftr = max((uint64_t)ftr_bits->safe_val + 1, ftr + 1);
> 
> base-commit: 0dd3ee31125508cd67f7e7172247f05b7fd1753a


