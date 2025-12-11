Return-Path: <kvm+bounces-65770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 22196CB60F5
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 14:40:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A98AE3059680
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 13:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EBDA238C08;
	Thu, 11 Dec 2025 13:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v1aFeruq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF26930F955
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 13:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765460320; cv=pass; b=ezL3UsUjZmrBmindt58M1RCJYS3Q3DIiH9V3gm8L19oCK2YBbXaTBdw7kKXJFQ/fD21KL6py+SrUNA6/HgQPkKXPVFmhzTWEBypV21zxITQbm8787V7jHQlQVV0A0PENim7YNqZ4ZyLJqnn6TSDcdIr6Z1rY8fH85j1Vi9Db8rs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765460320; c=relaxed/simple;
	bh=ZULG/eXPL1bxQuNNmFxDZle54SOquDAYpzZEieN3rko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kCRG2Ek3D/nj5vMkHEiy21RO8JlMHlMcXzPn5WuP0IhEsloCtwRAKVlGzEaVE8QLjT0Vfa2SX2oyLrBswZ3Sr+WptWqEU10xOx0/vsgMjn8GEzFkVxbx12+xwJ6Oo2Z5tOFhG4IgzE3aGV7jeNiVyCxB7fw/CtJlKqdfbfs5t8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v1aFeruq; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ee147baf7bso408561cf.1
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:38:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765460318; cv=none;
        d=google.com; s=arc-20240605;
        b=NdpjxoBjaDwqEzR5OO738np89J8RqvcBPmcvCLkrx1ek98leSwJEmZ7LowAMkl9P5s
         Tx32Eu1ElthNFxZYx0Kv1uGXNPXCVISFfw4BPZwGYldf5Rry8kgNbEnI86hf0NBuVXaX
         8VRiXEOgd5081tiQSUUm7FzZwmyCkKr8viO7Q/nYqC5mmPu1raA7nddEFE8nMyKnEBhM
         yiXVc+n+A2oS9jm3JphbYaH6c5WBLSdcNYKawDU8wLKUN4ZZU0+csX7NtkKijQBuAyQU
         6+BwAa9pT7iTdC7zbpj+zxg5Lqa/+Vka3lhuzNQk+9W80/XhgEPD7Wr1cez24Ylet4wE
         5ZXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=i666Zwd4elC4IZ8NbSZ0mun/x9mHfJ63jUqZOhfWrkA=;
        fh=FnEYhytFBjw2LUsvPJPz6g+niaT0cO918Syq3gPYBuY=;
        b=F4JQguNIN1GBKAwMEW8bA0dFAYlZr3fkVtOa5B40kqDTJqFYgWK173bYcoLoDkU1Se
         wEoDL4ztN5KtjxcEshTLJRJuyJaNN55fdrY7oYVvxA2q6YhNeruONpfXGvlSEPs5f4BC
         tp0Woz1Mn+joOSSrJfmpuAXU8+SPdmSK84RfaX9AvgHsDeiVrzAKEKD2XS0hMkkLbVT4
         gRR4LJDQfeHMnEwVBPFkhvfDpjH4lJyOnnhIr7RMm6KjLA85NT4MPkHomtaSv019jsmH
         c2z4+CL8T+o+Mmi8NEWCwGmdSl2Jq7kmI51woWcy9JO1SI84mAjtfI55f1MG1wYGpuJF
         Szsg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765460318; x=1766065118; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=i666Zwd4elC4IZ8NbSZ0mun/x9mHfJ63jUqZOhfWrkA=;
        b=v1aFeruqcHZatJue4EOzsAlA4ILCNJAR3jvKXE1iQoj1FIju0U6MahxWZEbYNbhonQ
         namgbdcqFdc8Oqa0ezKDd7rotkr8nz9dleGgyc3qWHugiGrImow5z+SKiE2hTDJcQYbz
         FRKjr1+oNbFvvbmCtmFglUw/5By5Ijw5DRM06W0OxLUFAzUW97t7CDGydwlCBgCB6XYY
         Kui1AHYCIo2AChboHCq/tjF3KEIaGXAswOU4n5z7TS0Q0awisqsOnJkQI/ea5w/3VpOl
         pkgjrE3ooQE9mSGO5/N1qZMLWWtfVW1YaocGC+e3JTqgLzvOXRndSSE6Qc2oxPDSQGb6
         //GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765460318; x=1766065118;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i666Zwd4elC4IZ8NbSZ0mun/x9mHfJ63jUqZOhfWrkA=;
        b=EBNkp4pkusBnszKNRCAYwvqLUWhKCZFsTPlZxHPVBdj5pNUV0OazJXCO+zvK4eY4P9
         pdkGxhqcqA8h8YbaKRCAHXpkOw1MwbjE8zcuYpS9zkw0WeuZSwj9I1AqrKCLwA2E8Aze
         fjD389VzHOVYnT7Q6Ey/MxY9L1mlVuZdVBy0T7DaUsZGRh/JGFlET+vDBMEoc645lHf+
         TEfUFQLRqHNGfxW/YeNarCov4GPe3n3nacH67KD+11g+P4PjUNj8mNgf6vbZlo2qexcg
         JwW1dhY8stg9x69uCDgJAPTGEQbQ0IaNe0GlbSVVAimiKGwbh/ftYhmv9R6nN0fdS0RP
         NvuQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRCvejA4Lu22DI+f0w54kjItGf1dKHxkf+efuKR9RXFfkflIoaknD7keneNTHD1EeIyEQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfcxJy/H5I4aoj0LiMRcqne06yEQcHKoBEfa8jE6H+z+BXC/3J
	jbZ8yPP1x8nzwQSy7J1QQRuce+sc9D29JrwVo7b56t3jxSXRR75anH+ZppjfXuYV9P0KFNdHZZR
	y0y/En/e1Uxjt6e9NjaquIr0PLD/jB+L0DkTw7Aql
X-Gm-Gg: AY/fxX6+C8kgnqdUveMdlG8BtwGIpJYSE8R1N1HDkGUd+Js0/ZkKidtsubh6nxb+Kmf
	FZJ9efNbpB2zRIEpwUfXxXQxJYoWneaa3nMDwbEk1IlXDqjf4+QHnm8dvCCvcNBwnCXlslGm+4L
	gKbfocG8K9JJhSc6jP3XnwrMi8CSwx2v/v1xuF5KYOFT4Hf6NZEUEniXcqCroc8DVQ8IquVxlwl
	/7fOlag2s2V3SOQySGI6q2IQaex8MWjWnEnlVhaMzlzW2ig40xH9UULV61bPaq7rskCToFM
X-Google-Smtp-Source: AGHT+IHnlXgNY3uTjr2bG8YCH2KU2DqaaN3tTWcI65GXA9wGNxK0qa5+vVM2+v18wq1/nLG4NVQGVG9Az703nd7ZxLU=
X-Received: by 2002:a05:622a:1995:b0:4b2:ecb6:e6dd with SMTP id
 d75a77b69052e-4f1bed26845mr8937541cf.1.1765460317397; Thu, 11 Dec 2025
 05:38:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210173024.561160-1-maz@kernel.org> <20251210173024.561160-3-maz@kernel.org>
In-Reply-To: <20251210173024.561160-3-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 11 Dec 2025 13:38:00 +0000
X-Gm-Features: AQt7F2oGj2WRYea77WTrAg7wjaWZvfWC-2CRFkNaisf36pfzFJ-jdbVLpncMx2c
Message-ID: <CA+EHjTwNVxPz6rZ0d59_qz1Szpe6gRCyLa094Wi6sinbzAJ8iw@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] arm64: Convert ID_AA64MMFR0_EL1.TGRAN{4,16,64}_2
 to UnsignedEnum
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Sascha Bischoff <Sascha.Bischoff@arm.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Wed, 10 Dec 2025 at 17:30, Marc Zyngier <maz@kernel.org> wrote:
>
> ID_AA64MMFR0_EL1.TGRAN{4,16,64}_2 are currently represented as unordered
> enumerations. However, the architecture treats them as Unsigned,
> as hinted to by the MRS data:
>
> (FEAT_S2TGran4K <=> (((UInt(ID_AA64MMFR0_EL1.TGran4_2) == 0) &&
>                        FEAT_TGran4K) ||
>                      (UInt(ID_AA64MMFR0_EL1.TGran4_2) >= 2))))
>
> and similar descriptions exist for 16 and 64k.
>
> This is also confirmed by D24.1.3.3 ("Alternative ID scheme used for
> ID_AA64MMFR0_EL1 stage 2 granule sizes") in the L.b revision of
> the ARM ARM.
>
> Turn these fields into UnsignedEnum so that we can use the above
> description more or less literally.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>  arch/arm64/tools/sysreg | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 1c6cdf9d54bba..9d388f87d9a13 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2098,18 +2098,18 @@ UnsignedEnum    47:44   EXS
>         0b0000  NI
>         0b0001  IMP
>  EndEnum
> -Enum   43:40   TGRAN4_2
> +UnsignedEnum   43:40   TGRAN4_2
>         0b0000  TGRAN4
>         0b0001  NI
>         0b0010  IMP
>         0b0011  52_BIT
>  EndEnum
> -Enum   39:36   TGRAN64_2
> +UnsignedEnum   39:36   TGRAN64_2
>         0b0000  TGRAN64
>         0b0001  NI
>         0b0010  IMP
>  EndEnum
> -Enum   35:32   TGRAN16_2
> +UnsignedEnum   35:32   TGRAN16_2
>         0b0000  TGRAN16
>         0b0001  NI
>         0b0010  IMP
> --
> 2.47.3
>

