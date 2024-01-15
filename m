Return-Path: <kvm+bounces-6203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ACC882D4BE
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 08:56:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F5C61F217B6
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 07:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD836FAD;
	Mon, 15 Jan 2024 07:56:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AF95380
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 07:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4TD3vd5TZLz1Q7tp;
	Mon, 15 Jan 2024 15:40:13 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 71D8718006D;
	Mon, 15 Jan 2024 15:41:04 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Jan 2024 15:41:03 +0800
Subject: Re: [PATCH v1] KVM: arm64: selftests: Handle feature fields with
 nonzero minimum value correctly
To: Jing Zhang <jingzhangos@google.com>
CC: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, ARMLinux
	<linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, Oliver
 Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, James
 Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Itaru
 Kitayama <itaru.kitayama@linux.dev>
References: <20240109165622.4104387-1-jingzhangos@google.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <05e504bb-9aec-6026-1ea8-bca59ad439bf@huawei.com>
Date: Mon, 15 Jan 2024 15:41:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240109165622.4104387-1-jingzhangos@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Jing,

On 2024/1/10 0:56, Jing Zhang wrote:
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

As I mentioned in my previous reply, there is a compilation error with
gcc-10.3.1.

| aarch64/set_id_regs.c: In function 'get_safe_value':
| aarch64/set_id_regs.c:233:4: error: a label can only be part of a 
statement and a declaration is not a statement
|   233 |    uint64_t min_safe = 0;
|       |    ^~~~~~~~
| aarch64/set_id_regs.c:262:4: error: a label can only be part of a 
statement and a declaration is not a statement
|   262 |    uint64_t min_safe = 0;
|       |    ^~~~~~~~

Please fix it.

Zenghui

