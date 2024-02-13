Return-Path: <kvm+bounces-8618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F17CF852EDF
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 12:15:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67CAC1F26FD4
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 11:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDA8E364B6;
	Tue, 13 Feb 2024 11:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="roHUmk7o"
X-Original-To: kvm@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A7833CD2
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 11:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707822883; cv=none; b=E/g5xRs22nnB9lxIJC8zVtPBhruY4Jg/tOJZ9chp4+raGpqEVBVS3ZpKHlrrxY17BN/BWs4j+102tCVFTPHcQH1ro0N9ra2s8lF1H68ikw55KumipYvPRh8IG7WMeJi/nfeBvkMSRLpZm+UIa0Oi5q6fW7ZX3A9gz1xEP4jz6Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707822883; c=relaxed/simple;
	bh=YvDdIjtBl1xRPij1eJggRa9vZ44OFLNug4Fl60nUGQw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=qNIyacRmvypF/Gz+ZWKstOG1qrZyzVHPi1G9MEVFPIMu51w7L8D39peD7EyPyRXXej81VGIByTv5/Wgsgyw1xd0Q5w8/xYJ8IkCqqJ/FPYwiUiBqN36xd6xsuFNXYeNkDl03wElFYyHqtxZgPjWoG/pD1btuT3LrCnWZ6oQlY9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=roHUmk7o; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240213111439euoutp02acc181728db69ece35ff585dadfaafb9~zZ9w1uzX91895418954euoutp02W
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 11:14:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240213111439euoutp02acc181728db69ece35ff585dadfaafb9~zZ9w1uzX91895418954euoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707822879;
	bh=JR0PkD7vN0S2u5oYVHNJ2+NXefBzmZZ86e5RWc8Zdjg=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=roHUmk7oMGRDWkJAGxOZzOJ+9e/jdiDnnCJ69HEjRB8y59i1O8QM1MtQrsQ/DItmr
	 oA1poGSELPzSn8cZNgYnVIrmjXxm+up2dRWY18xhknQA9H5oahMSZPrhwF+hMNUBbq
	 zLsxxGSpN1A07Isl/lfAHSUFUIBo4MiItbTc2Tw0=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240213111438eucas1p1b9b33ba0d17d84dd16cad2d56ad751cc~zZ9wdeq5Y3046730467eucas1p1M;
	Tue, 13 Feb 2024 11:14:38 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id 1A.36.09552.E1F4BC56; Tue, 13
	Feb 2024 11:14:38 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240213111438eucas1p2a98c23ee227dbb956dd07e7bd05798d5~zZ9wCDZks0418404184eucas1p29;
	Tue, 13 Feb 2024 11:14:38 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240213111438eusmtrp18d26e72e3ba5d91eaa360d6f7a6bc8ea~zZ9wBYMkM1666016660eusmtrp1k;
	Tue, 13 Feb 2024 11:14:38 +0000 (GMT)
X-AuditID: cbfec7f5-83dff70000002550-e8-65cb4f1e5cb4
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 95.0A.10702.E1F4BC56; Tue, 13
	Feb 2024 11:14:38 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240213111437eusmtip276cd474e1d4d3d635e59b0b7e7840c13~zZ9vdlxgY0826408264eusmtip2C;
	Tue, 13 Feb 2024 11:14:37 +0000 (GMT)
Message-ID: <5b2d8fee-9d0f-48f7-b9ec-b86e95387a61@samsung.com>
Date: Tue, 13 Feb 2024 12:14:37 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: cpufeatures: Only check for NV1 if NV is
 present
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu
	<yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
	Deacon <will@kernel.org>
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20240212144736.1933112-3-maz@kernel.org>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SaUwTYRDNt7st28biUopMUIs2QIKJCB5kVVIVian+UCBo4hG1kQ2gLWAL
	iEa0KEGpckQt0HoAQblEhZZDDaKAWglIFCIBRPAWK1QIXkiCsq4o/96bmffezJePxMVmnhsZ
	FR3HaKKVKhlfSNQ8HGtbKN3UwvieyvamPxedRnR/fTFGXzDsp21VTQRtftPJo29daObRhrFB
	Pm18/hzRKb3L6O4rFQ6rhYryS+VIkXJ/iKcwl6XxFQU6A66wXD6qGLAYkWLULA122CYMCGdU
	UQmMZpF8tzDyTWolL9YmScwpHMd06LGTHglIoJZCh/4YpkdCUkyVILg6XIVz5AuCuqIfPI6M
	ImgwWNCUJKPXjrhGMYIJwwSfIyMIqgfsk3qSFFFysJfOZQUE5QnGExkYi0WUEzQb3xIsdqHc
	ob8n14HFzlQo3CtjowUkTrlCz9u8P/MSKgEsHy8SrD9O2RA0Fxbz2Aaf8gP9kJ7PYgHlD8aL
	DwlO7A7Hq8/j3KYnBFBQsojdB6ggqH6wgSs7g81a5cDhOdBy9vQf/8lxBPnj/RhHshDoPvT8
	PXkl9Lb95LNGOOUNN27/9VwDxjQVBx2ha8iJ28ARztTk4FxZBCdTxZyHF5is1/+lNjxpx7OQ
	zDTtUUzTjjdNu8X0PzYfEWXIlYnXqiMY7ZJo5oCPVqnWxkdH+OyJUZvR5LdqmbB+vYlKbCM+
	jQgjUSMCEpdJRO25jxixKFx58BCjidmliVcx2kY0myRkriLPcHdGTEUo45h9DBPLaKa6GClw
	02EF27tezErK9ldq1Oc+Ehkvj8jmC5/5j3bkdqY1793amfytJS4zjCHen5X3rFORKR4Wx/KK
	OImkritnWGEN6qgfqeje9ypQHNyHvO1ex7f8Sk+11slvxrskZh9UA71CtLhGfiO2NKAs865k
	+VpysSw7BI8Vq6RD4x6tds0y38japHfzvu+45uJLpuxRabuyBhNH+mfWjj39GebfLYw6sF26
	ttx38NxyXWub+0JLyMCdvMOvV11Pn+B1rB+WnezdHRjwva00tKg9Yk79kswEbBCFSDf+So5Z
	c6hy6bYtSfIvM2qH+zb/ECdurs7zav2Ehzh77jw861nh7cp1j2qcmuaPFcsIbaTSbwGu0Sp/
	A43j7SPFAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t/xe7py/qdTDR728lm8X9bDaHF/33Im
	izlTCy1ebTnMYrHp8TVWi51zTrJaTP35hs1i5u3bjBYtd0wtbi7dwO7A5bFm3hpGj5Yjb1k9
	Nq3qZPNY2DCV2WPzknqPF5tnMnp83iQXwB6lZ1OUX1qSqpCRX1xiqxRtaGGkZ2hpoWdkYqln
	aGwea2VkqqRvZ5OSmpNZllqkb5egl/G4bSNrwSuRiumLfzM1MJ4V7GLk5JAQMJHou/OOsYuR
	i0NIYCmjxL9Pv5ghEjISJ6c1sELYwhJ/rnWxQRS9Z5Q4vXgVUBEHB6+AncS7lbIgNSwCqhIz
	2/uYQGxeAUGJkzOfsIDYogLyEvdvzWAHsYUFgiQOrNoCNp9ZQFzi1pP5YPUiAmUSL84dAzuC
	WeAVo0TLiyvsEMu2Mkp0fwfJcHKwCRhKdL0FuYKTg1PATGLm3GMsEJPMJLq2djFC2PISzVtn
	M09gFJqF5JBZSBbOQtIyC0nLAkaWVYwiqaXFuem5xUZ6xYm5xaV56XrJ+bmbGIExuu3Yzy07
	GFe++qh3iJGJg/EQowQHs5II76UZJ1KFeFMSK6tSi/Lji0pzUosPMZoCQ2Mis5Rocj4wSeSV
	xBuaGZgamphZGphamhkrifN6FnQkCgmkJ5akZqemFqQWwfQxcXBKNTDN3+i2f7rBg6ZS0c+n
	Ux+bVWbc6hPWiN+brPb7lPG91/mKTHcLRZat1mgKufFqqXyvdfGR8zMjp6a5d9m3nFj2O2OH
	z36vzp7VuvJZcZqJsx4tDmKK0Erzt+ibkWHCJ2quuNbp2iOnW2z9jjVXHoubfN3wQqWyL6LS
	/cc2h49bVth8KvmUJPJs0vxEQfMXbByfVbTM6gINep78fGvhWRI2539HuPYj27tCG9sveJQ8
	S9khdf3qvgt/VtoelwkwV4icx2Xzp3XtiZf/vwtkLPxUu956UsefO1eNjkns3r8mvjllerzN
	+aWqx8oyerJ5k84c+/msdV3wltYWPsugOZfldT02Z1/ev1x6H9Nj9i1KLMUZiYZazEXFiQDc
	yv0uWgMAAA==
X-CMS-MailID: 20240213111438eucas1p2a98c23ee227dbb956dd07e7bd05798d5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20240212144758eucas1p1345ba6f2000c10a4b33f8575f0a8d22b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240212144758eucas1p1345ba6f2000c10a4b33f8575f0a8d22b
References: <20240212144736.1933112-1-maz@kernel.org>
	<CGME20240212144758eucas1p1345ba6f2000c10a4b33f8575f0a8d22b@eucas1p1.samsung.com>
	<20240212144736.1933112-3-maz@kernel.org>

Hi

On 12.02.2024 15:47, Marc Zyngier wrote:
> We handle ID_AA64MMFR4_EL1.E2H0 being 0 as NV1 being present.
> However, this is only true if FEAT_NV is implemented.
>
> Add the required check to has_nv1(), avoiding spuriously advertising
> NV1 on HW that doesn't have NV at all.
>
> Fixes: da9af5071b25 ("arm64: cpufeature: Detect HCR_EL2.NV1 being RES0")
> Signed-off-by: Marc Zyngier <maz@kernel.org>

This patch in turn introduces the following warning during boot 
(observed on today's linux-next):

CPU: All CPU(s) started at EL2
CPU features: detected: 32-bit EL0 Support
CPU features: detected: 32-bit EL1 Support
CPU features: detected: CRC32 instructions
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at arch/arm64/kernel/cpufeature.c:3369 
this_cpu_has_cap+0x18/0x70
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.8.0-rc4-next-20240213 #8014
Hardware name: Khadas VIM3 (DT)
pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : this_cpu_has_cap+0x18/0x70
lr : has_nv1+0x24/0xcc
...
Call trace:
  this_cpu_has_cap+0x18/0x70
  update_cpu_capabilities+0x50/0x134
  setup_system_features+0x30/0x120
  smp_cpus_done+0x48/0xb4
  smp_init+0x7c/0x8c
  kernel_init_freeable+0x18c/0x4e4
  kernel_init+0x20/0x1d8
  ret_from_fork+0x10/0x20
irq event stamp: 2846
hardirqs last  enabled at (2845): [<ffff80008012cf5c>] 
console_unlock+0x164/0x190
hardirqs last disabled at (2846): [<ffff80008123a078>] el1_dbg+0x24/0x8c
softirqs last  enabled at (2842): [<ffff800080010a60>] 
__do_softirq+0x4a0/0x4e8
softirqs last disabled at (2827): [<ffff8000800169b0>] 
____do_softirq+0x10/0x1c
---[ end trace 0000000000000000 ]---
alternatives: applying system-wide alternatives


> ---
>   arch/arm64/kernel/cpufeature.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 2f8958f27e9e..3421b684d340 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1812,8 +1812,9 @@ static bool has_nv1(const struct arm64_cpu_capabilities *entry, int scope)
>   		{}
>   	};
>   
> -	return !(has_cpuid_feature(entry, scope) ||
> -		 is_midr_in_range_list(read_cpuid_id(), nv1_ni_list));
> +	return (this_cpu_has_cap(ARM64_HAS_NESTED_VIRT) &&
> +		!(has_cpuid_feature(entry, scope) ||
> +		  is_midr_in_range_list(read_cpuid_id(), nv1_ni_list)));
>   }
>   
>   #if defined(ID_AA64MMFR0_EL1_TGRAN_LPA2) && defined(ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_LPA2)

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


