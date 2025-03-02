Return-Path: <kvm+bounces-39834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B344A4B58B
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 00:52:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9504316C28B
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 23:52:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9DB21EF0A1;
	Sun,  2 Mar 2025 23:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZuJnZxu3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F2A23F396
	for <kvm@vger.kernel.org>; Sun,  2 Mar 2025 23:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740959555; cv=none; b=bghtYgiOlehBL7AHqs2ZhZnwknSYSlayWD0ViLz+HAh7u3BXyNgX8gcMNiqsqusnBo+ASLsXTWDa/DzA9A8lGtrIQG4rN/eC5Xw+F3AowC6dkQ6OxyacJexgytwxQR1ulkA1p+ey+N8CKJQnrOWz2k7Yw0gC7DQvtCCvMgA3aiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740959555; c=relaxed/simple;
	bh=ZCHiDYAhlovsWxCqC+x+dRnRzJjE1HzBfBSQe8cnIkU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XuAmJAy3yc2ffr4h44h1UMMNfzRRPCQCVNa78tl++Tz6xW20Uxuxcv3hIpWrN8DBm3E+8+oXIgzJSrxg8SqXUs8Gr0gWOZ109KoXlmF9VqsqGvx7ejF6E2xf8nUbFQhVl/YakASWTEuvfX1WB/yV/ACm01o+5CdzdEF7PPFtUkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZuJnZxu3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740959552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nYg5YEi6qBDiPq4yW7kt5bdYtpCwTDMo82ocwV6poUo=;
	b=ZuJnZxu3QzCgxjmoevbKosm/A6TIFU58Gu0Ow+qFqfoIfFYFMwRda+cest+OdXjpHGmow2
	hZgZ2kzdCbeLRxIBau5uLNNxIPI0yb74BjR/lW0b0nrsAaea+Hg7L7mTCHnKBhvDSguOdf
	LaW/vu06qCP7CJSMJDZydmzmcBLrn0w=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-r4hCoMldOdyiiYZvMTTYVg-1; Sun, 02 Mar 2025 18:52:15 -0500
X-MC-Unique: r4hCoMldOdyiiYZvMTTYVg-1
X-Mimecast-MFC-AGG-ID: r4hCoMldOdyiiYZvMTTYVg_1740959534
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2fecf10e559so6302548a91.2
        for <kvm@vger.kernel.org>; Sun, 02 Mar 2025 15:52:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740959534; x=1741564334;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nYg5YEi6qBDiPq4yW7kt5bdYtpCwTDMo82ocwV6poUo=;
        b=JVfeGJVnHS21MG6vpTVwXtfiOzVwhqypunbYxkH9LAKIaLljb+9xsKInR9Zx6lgNi8
         A5UDYj5l2QDUgpVNJFeInQRFHZ06MoWJrSABikxH+cplovsDFlpuYXWKZNZ/k4kEGF4t
         IMcruo6WEKjR9zOvanUgP4Mt0BRGxrE2rWKvO4B+eFg27+y60v78jqT8J5hmfpk3kcAr
         mz+eKTESG/CjyaG+g5ZmHzMf55c02y3BLsyllktm3mLWSlOrndx1hWRzafSJtYFzGDl3
         vt1wO1hXKcOSh1JQU15MU0VI4Xb2jPofTbYio2q2klmQTi3gZRCRY3Q0+o448fMvS+hw
         Oe/w==
X-Forwarded-Encrypted: i=1; AJvYcCVYqA5Av0pL5IkfBJGUDy8zOjC+vrnuoAWG+h+rWL45Tys8qXuD/s1WpVB5JtSTav8XIbI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyqs+QS7Or0upYVztO9MaEnXsRAF1vnAcx1ZekuXaKUMjwT9Ywk
	+76KjbIZbOmXdvRQbabCZ2rwwPDFO505XhqYm0Mi7GoKVfY9AHv5ApMLLX/3O+JspU0Ia0mqwbu
	PbgCWV8F1tbIoch92K44rzH6A4olkf7xBf5wwWHzT09VqFzKfSw==
X-Gm-Gg: ASbGncvQ8FN7t8Vw//p7ABsSuTQebtKD3PXuC3gu3OgHz1iMWd5ZepFRxtbV3GHWinI
	0AyARKWBqbtJ0KDg4qf4hoXwAOz6VeiRhul53stk6DzHEMFoHjG0HRjNEXzFiePjpxjQ4mR9nLs
	iEXN3rL90cEMwqydOyDg7o81SrVHyg1+WWsPf3TxpY3Tr17oo+PkokaEC7FPmT/p/MDwUhau7xY
	Is2kogGnTimsXkce34JQfu+swl2csLfunXGXwR0gWg+fwEiWnab1v0GErTsv/xcZkU0MbHEC3g0
	tfZePUi0puFz8dqFOA==
X-Received: by 2002:aa7:8589:0:b0:736:2f20:9d1 with SMTP id d2e1a72fcca58-7362f200c33mr9917269b3a.23.1740959534558;
        Sun, 02 Mar 2025 15:52:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGKlHkk3X/xMjFSbabboBMi1iDhPso9R9B1xGAoC3vDIC/hJIAYOgl7Zpu+TUw2ZN+RUI7UGA==
X-Received: by 2002:aa7:8589:0:b0:736:2f20:9d1 with SMTP id d2e1a72fcca58-7362f200c33mr9917245b3a.23.1740959534256;
        Sun, 02 Mar 2025 15:52:14 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-734a003ec7esm7554622b3a.153.2025.03.02.15.52.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 15:52:13 -0800 (PST)
Message-ID: <7c217ce9-588e-4e4a-b395-2cd5d014487e@redhat.com>
Date: Mon, 3 Mar 2025 09:52:05 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 04/45] arm64: RME: Add SMC definitions for calling the
 RMM
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-5-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-5-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> The RMM (Realm Management Monitor) provides functionality that can be
> accessed by SMC calls from the host.
> 
> The SMC definitions are based on DEN0137[1] version 1.0-rel0
> 
> [1] https://developer.arm.com/documentation/den0137/1-0rel0/
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v6:
>   * Renamed REC_ENTER_xxx defines to include 'FLAG' to make it obvious
>     these are flag values.
> Changes since v5:
>   * Sorted the SMC #defines by value.
>   * Renamed SMI_RxI_CALL to SMI_RMI_CALL since the macro is only used for
>     RMI calls.
>   * Renamed REC_GIC_NUM_LRS to REC_MAX_GIC_NUM_LRS since the actual
>     number of available list registers could be lower.
>   * Provided a define for the reserved fields of FeatureRegister0.
>   * Fix inconsistent names for padding fields.
> Changes since v4:
>   * Update to point to final released RMM spec.
>   * Minor rearrangements.
> Changes since v3:
>   * Update to match RMM spec v1.0-rel0-rc1.
> Changes since v2:
>   * Fix specification link.
>   * Rename rec_entry->rec_enter to match spec.
>   * Fix size of pmu_ovf_status to match spec.
> ---
>   arch/arm64/include/asm/rmi_smc.h | 259 +++++++++++++++++++++++++++++++
>   1 file changed, 259 insertions(+)
>   create mode 100644 arch/arm64/include/asm/rmi_smc.h
> 

One nitpick below, with it addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
> new file mode 100644
> index 000000000000..f85a82072337
> --- /dev/null
> +++ b/arch/arm64/include/asm/rmi_smc.h
> @@ -0,0 +1,259 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023-2024 ARM Ltd.
> + *
> + * The values and structures in this file are from the Realm Management Monitor
> + * specification (DEN0137) version 1.0-rel0:
> + * https://developer.arm.com/documentation/den0137/1-0rel0/
> + */
> +
> +#ifndef __ASM_RME_SMC_H
> +#define __ASM_RME_SMC_H
> +

#ifndef __ASM_RMI_SMC_H
#define __ASM_RMI_SMC_H


[...]

> +
> +struct rec_run {
> +	struct rec_enter enter;
> +	struct rec_exit exit;
> +};
> +
> +#endif

#endif /* __ASM_RMI_SMC_H */


