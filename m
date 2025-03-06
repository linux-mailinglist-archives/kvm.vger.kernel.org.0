Return-Path: <kvm+bounces-40243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 121A6A54AAE
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 13:27:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12A3D188E252
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 12:27:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8949720B7F3;
	Thu,  6 Mar 2025 12:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iqPrBtvF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DB520B1E4
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 12:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741264034; cv=none; b=mhxLOk0HIVbo0NIMbPIxU3Wnce1F/SUVB+v3NGOfv3TC8aWSrUL2ib9fi+or9C93rp1Jc2gMDMzPUcHAa3yNFX5O9YIcJszqsfUKnSfW1k8jDAWXYtum8TmRiAWpJlBu7yvjY/qm/9a0muNPQKJvwCQpC5Lo+EQqYXCF5hU8K0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741264034; c=relaxed/simple;
	bh=pVa13x0eznMFlFJgevA/3V4fX8oausWJfyL+2avm+sQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BVzhe4a/zY5/+czPjfT4q85XWw0vwLFWB029TDJyizi23d4D4SDtW+MvesvrZICv5otiBLxDmrtIfII1Tn4Y+Iy7AopUtpf1ifBxc7oASt2jrKPxmyuQfOqYdLBW/LL1LpugWxr6SqkYKMy9EIXuZGmsHFD8s74RRVVdfQ+emXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iqPrBtvF; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-abfe7b5fbe8so85106666b.0
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 04:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741264031; x=1741868831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uywctsa4YD0Q6N59/rve/Yt7Zjyk6Nhk26U0WfvFJPM=;
        b=iqPrBtvFVNamS16E2vSCQMX5Ccij/UXeWHmw9UyYYGQ9Qk4FxZbGcPCLKMgJm3QTVw
         3DS+zJDbOpc6xg3uC9MMglCASxzQizMWHZrO12GJLQwsdxATSJXrc1My7mMwAnCia2wY
         oXbiV6a5AEDJMHjhI84vNW9kE/sH8PSzLVSwTebRCRkeWnv/26bcuenYvNBf0QKwMPq+
         Q6ExZcgVf+zdKoM7+c8cAKffdZgqtgbE2z2zgV7WKKR+PMNwFJApEzbUGxH0t+iUwPCF
         cuwtu38R8QNxGPTa24YQvkQlLdAuSMwCLei5Z7LY304Os1t5fi0kof4BnX9B33fHLi1I
         DjJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741264031; x=1741868831;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Uywctsa4YD0Q6N59/rve/Yt7Zjyk6Nhk26U0WfvFJPM=;
        b=QiV4da0cvuMcWeiQ8N18OPb+vMHvwxdHma2mabIT6vTYOTGip101I9DulZNR9/zH0u
         RGocyN3BpC86mTYpLakeg1eDPdxThrsBrqUk1wIv+J80TKslF00F/gLG1U4ibduo7ZSS
         1dbXzVUHSey0S66txIPa4p8gPjjQ11+vzPQMr/FTDis1CfjSOaIoOzW6Ww0wkRHbuFK8
         gv8GlqAoiFR4JhGOHQnuYWdY7TQAg9XwRch5Sn05RgDY9fHwsbeFaeqZhJwyBlOR7wfl
         XnGPforIwR4KEaVcYGSgMgwd5VY+Cx+9gKcQBswl+u378nQGbQNLmaBAjA29JXjFLoLV
         gpVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNqH66vD/7VCoiDlUK5pT14ogP2DasVbWYoV0AR/VKBHlhltOhIoYfcbM3DJQrOz5W51A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTRBzQoGre3kzk+Rv3nT7dO2CweJ9vbJWjkZxUt+s6LMGOaaIy
	j+kK9sttOPHyGPJF9hEP6Om6lzShs0WVNDU/QJg5YTQcspP1re2EwOfBZJYnA4Y=
X-Gm-Gg: ASbGnct1udAd8fR/pMn01LUriuhtmVjjDCDxw1YAqC90d90vy0jH03El8AuuIzufjt1
	bp2S2YsRq+tCZXlSrArm85Nt3bT0gEDFoVyDhEUtxqpP72vMl5zIwCRvNOsCsIQWNDdRiO0wGAO
	Gqfu7OARyioIIDWJdlnjAwnPgivsr6BPpAHBKJcOpkGJRSynP9/Id/IuMpW1AECXIRsyw7HOtDd
	5eSYdsVmOGtye9kDtEbux2/2u6r2dLEuB2ECKFS4dUWkamChkKCI3UbsG68chKcEzq2x1GEjOew
	7K4FwPgfljnQPxjraUvdM3OAjbP29qJGaYhWXaAlxQQ1+EQ=
X-Google-Smtp-Source: AGHT+IFpscY/rWMvlVBbyX7isuNDnwxpP05cG0XH/ClvjNHRmnzxornZo7dhMEptxV7deOMEZqJ6eg==
X-Received: by 2002:a05:6402:13cd:b0:5dc:74fd:abf1 with SMTP id 4fb4d7f45d1cf-5e59f3ee29amr16513660a12.15.1741264029258;
        Thu, 06 Mar 2025 04:27:09 -0800 (PST)
Received: from draig.lan ([185.126.160.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac239488be1sm89025766b.74.2025.03.06.04.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 04:27:08 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id AF6E85F9CF;
	Thu,  6 Mar 2025 12:27:07 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org,  kvm@vger.kernel.org,  philmd@linaro.org,  Paolo
 Bonzini <pbonzini@redhat.com>,  manos.pitsidianakis@linaro.org,  "Maciej
 S. Szmigiero" <maciej.szmigiero@oracle.com>,
  richard.henderson@linaro.org,  Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 2/7] hw/hyperv/hyperv.h: header cleanup
In-Reply-To: <20250306064118.3879213-3-pierrick.bouvier@linaro.org> (Pierrick
	Bouvier's message of "Wed, 5 Mar 2025 22:41:13 -0800")
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
	<20250306064118.3879213-3-pierrick.bouvier@linaro.org>
User-Agent: mu4e 1.12.9; emacs 30.1
Date: Thu, 06 Mar 2025 12:27:07 +0000
Message-ID: <871pva4a5g.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pierrick Bouvier <pierrick.bouvier@linaro.org> writes:

> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>  include/hw/hyperv/hyperv.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/include/hw/hyperv/hyperv.h b/include/hw/hyperv/hyperv.h
> index d717b4e13d4..c6f7039447f 100644
> --- a/include/hw/hyperv/hyperv.h
> +++ b/include/hw/hyperv/hyperv.h
> @@ -10,7 +10,9 @@
>  #ifndef HW_HYPERV_HYPERV_H
>  #define HW_HYPERV_HYPERV_H
>=20=20
> -#include "cpu-qom.h"
> +#include "qemu/osdep.h"

We shouldn't need to include osdep.h in headers, indeed style says:

  Do not include "qemu/osdep.h" from header files since the .c file will ha=
ve
  already included it.

> +#include "exec/hwaddr.h"
> +#include "hw/core/cpu.h"
>  #include "hw/hyperv/hyperv-proto.h"
>=20=20
>  typedef struct HvSintRoute HvSintRoute;

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

