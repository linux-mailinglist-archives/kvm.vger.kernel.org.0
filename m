Return-Path: <kvm+bounces-45338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 791A7AA87A9
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 18:11:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0E18176432
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 16:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E36D91DDC1B;
	Sun,  4 May 2025 16:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gdRM6MJw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BB84A24
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 16:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746375069; cv=none; b=grTTQC87bZuEVK4C1T1Si1CFffJtHzkp9ypqV3haY9ISJyWqVuGbu222+FL96xFv7eUBZqbl2c9WInuINeuTrMAQQFL33BGTUhY7XWk065Ng+0y7QZts5Y94rLccw73sTqZa8ycl4aF57F/uAzTCM7VH2tsKtxVLgXf0pQMyEJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746375069; c=relaxed/simple;
	bh=/nxYythrmYGDjQQQrGtpBKWgFTb17pinLYCwThX5YJ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LWGfgHtvTWXuUG+0Rq+q7UA2j3uoyDB7Y4a2DfJXVFGbCIkQvjA3H2m3ZvSuLFMX24CVEU9hF9I5a2V5VlzstmuPiCdIHXhpFH+eVQmPwOwrkCVm10mURYn+ddWu6u14yRh3da1LyJKkGuEN+0lkdnUF2I9f84wKOW6y52JedNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gdRM6MJw; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-223fb0f619dso42690385ad.1
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 09:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746375067; x=1746979867; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mg5H46AAeuqeTMZmfCyrih9/4ePsSGqG0Yc0d6h12cM=;
        b=gdRM6MJwHecM7fgtN7LTT1niykX46vNW48/uxNdrwcG5oLBB+lrmbMPmmeMME+//HN
         6Gsx+XAtrZi7+co9UbUruAY9oCTNxGO9L9d0MtBjapo1J7zzH+i1kdBlFkmNyWBMHXRi
         x+L1YZSZkRkPFxR0nQVLNS+QdEulICgBJmnTwSQftwan2Fg0M5rgobtDxM5sgxm38EUi
         KLWEnwjESRtNeZy09DRbJSuUS+9Z5JrGCdi3aS9iSKi7uKB3xLC2ZCIXQ9kq4WKDwjRt
         L0TbGrkn9WmtyWcAMh4A3JPIEdTL1e+vSlgXV21X479jakfjevYKLOiSPvEohrWuLEp7
         2x2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746375067; x=1746979867;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mg5H46AAeuqeTMZmfCyrih9/4ePsSGqG0Yc0d6h12cM=;
        b=dpVZpG0HhyalhTdq3/Tzi/fvJq7FbVcsFYBNEgcbpYipR41Nl4zeqx0a3aCZpJuD5d
         7SKZ7LjuyZ8NP2eHsyOTQGfzMG8jAah6pgjToiG1lWV/XkLsNemPTkjjH4ib0xmQR6CK
         wsJ3uEkHBYrunbknV6pXLnX/sAN43rs5JPF9uPZ6HZ+xtHcM3fw5FNWxNKbkusqMCXfn
         t8auu3kDsBQqqqrNHeQhDUahi76iOUJUFZk5/UDN0hrRQhvrByKNG14tGx33mz6xQdt+
         gjUKL557VuPp+SWr7wrOkviUT4xln2dJA31PMvm36mYB4S+7OrWYA12TkZ+YlFNWDul5
         KMVg==
X-Forwarded-Encrypted: i=1; AJvYcCWBK3FTuq/5P+CImQW0rxl0VH4+0ACuu24gcP2FEzFLfve9uNkYp5lR6s7iFJoH8sQz60Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywn3cFy0/o0j3g6fMQah2qmVuWdUISm0JiEXAx1FQxF5yZWagry
	j9NiUCzFLXkh/zFpK2PY7F2Wo6BPCzYeK1fUDe0XD0Sn8hoRb1+1dtI3A2zM9wA=
X-Gm-Gg: ASbGncuPTSThBdBaAvkMwZExhY9/tmEcA+PmCY4iu1i/d+YwbdiaYFIdqNZJNAQ+Ksb
	5IWn22VG70Y170IaPcL8ij31Gxeb2AqTJ4271zifQtfEZPA5wy9gZfrwg9GJGH8KDybxsHRITvf
	DgTwfFiVELyZ/GLNLgT8A8sa2kH8P7Xj+7KvAXAvzoPh6Dspp4L5RfK8joa0rKChzoYXWC9vAg/
	qnZZeD1VMgq7b07laPqK+12b/nBS1PhOPJwPqmp8slIubMRR8q0lc14FOlK3Ezg+DlhZw8hKKbR
	P3gCfuHbk17V68LdH9PAU/i0tl+1VBiIrPebyFoV67F6a8emMTE8uEeSIm+hEn4UzkVmrCyvEG2
	qdnsSZEw=
X-Google-Smtp-Source: AGHT+IFuPHwThnZ7gM50lbIZGvWCd/owSisb1zYGcYT/GUvXIiYYxIG9Y0DQtl31DC2c3pM+nqyqRw==
X-Received: by 2002:a17:903:120f:b0:220:eade:d77e with SMTP id d9443c01a7336-22e103559d3mr163818725ad.40.1746375066754;
        Sun, 04 May 2025 09:11:06 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e152291eesm39090825ad.192.2025.05.04.09.11.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 May 2025 09:11:06 -0700 (PDT)
Message-ID: <3d8b8f31-4986-4734-aad9-f73d01c735c7@linaro.org>
Date: Sun, 4 May 2025 09:11:04 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 15/40] target/arm/helper: use vaddr instead of
 target_ulong for exception_pc_alignment
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, anjo@rev.ng,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
 <20250504052914.3525365-16-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250504052914.3525365-16-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/3/25 22:28, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/helper.h            | 2 +-
>   target/arm/tcg/tlb_helper.c    | 2 +-
>   target/arm/tcg/translate-a64.c | 2 +-
>   target/arm/tcg/translate.c     | 2 +-
>   4 files changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

