Return-Path: <kvm+bounces-44585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BEA7A9F4F5
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 17:53:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 220C43A9342
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 15:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9153B26B2D8;
	Mon, 28 Apr 2025 15:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OhM0NRIB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274CD78F54
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 15:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745855614; cv=none; b=FmjvMKBJvX+Zp1wWjZHwpBoMzJCLPKkkpnb4YgOPO1tqC43rEej0jeZYdMlSZOV2ZNH8uoBOlptJZrDhWO0oVBWcdTVwlkdhbTDYqRS6YX8k6WPWRpLs2k9xHHy9LLA3QHjeBSYK1zo1P+BgP8aBzL9kvvUb/xRvUrSaS0cmEKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745855614; c=relaxed/simple;
	bh=tpEniJXHyC499Gtti9xSHTpYk39Jm/IdUxsTW80V3LA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WQNPU0+vg4wyK8+yKqelXtSFMOjbtalYBET7I5G36rXFVd9fJRgfpDtW7HUb1GKF3SrFWqLLR+483YnNmePZk4MChny2CqE1iQ4m+bsX32n9Z2lH+7YRnjXM4QVi62MtSGXtpDbwwz906sjqCftmxzAWygkc1LC5sUJdRZ9xtxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OhM0NRIB; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-227cf12df27so47554795ad.0
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 08:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745855610; x=1746460410; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eQlBJdnxtxpKDLustuiX22zJ2ky2yazku7Tu+xOCF/0=;
        b=OhM0NRIBrNrvJD1fKOZrYZIYSSxhQfMppEa5hgXZvhacKjZXA2FhsE//hvYPlxsUUN
         nBKx1tkRqmTH7i+p1hWqt3sPScAcFP2ONBbw9Zi7tr+NQ2KXmiCVVZUl/mP5+Yexp8Ej
         E3g77lSGPLgSgtInAIMEpSp9IqvR1+zL69ViRM0HOJ52N+pf8VPiLtmH7gH/B/e3pRQV
         53891DuojB+mx6QlMOUhNQZ3k0FjnB+xZ7GA13m9JlIWYwAJscDtO+i0rBYI7aCtFQ4q
         h+GqdFrELgnKUSh1F/gvLIwIaM3BgEQJaMyyHUaVvaaXbdWw7+V9st6/OgByskOA8Plp
         f/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745855610; x=1746460410;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eQlBJdnxtxpKDLustuiX22zJ2ky2yazku7Tu+xOCF/0=;
        b=jkdTSn2Eg6o0UAOjrAB2noFK6xoWFphPTin7BdynlpgrOsEAooogXW+c60YEc0fJVu
         t+hEzwEovvz0lBxNU/1EwdE4BtQHZkm3TUn1pFkj/pb2izRriCZ2HaNo5vL2FnbmVBZA
         0+TWGRTvVklBlpyfVazFArPrfsQLtOx2iOLF6eL7tDfmgp4EKcJT+QxEB+heUJlxnzkR
         tdZrcOJZ49l557t4aguOPVxim8YjX8AB+xiYYLs1Cuj/8LQhDvTJpsOdySlZXSo8APcu
         MwOLCkYO0cyHPKimdw6YL0akeqlxqYsuxEPbyznVC8w/WQBIWwRv/5rmY+Sg53Oxwdqy
         6yoA==
X-Forwarded-Encrypted: i=1; AJvYcCWH0wbp1K8K++ULVULShWSHgoWjkexEwi+kOccM1pSLR0968O7s//fGEz9j8JUMwLxAESo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+ZyP+lAHIzJTXfiFNf6QV+XvBz+ScXUrT1GCRPSu/eQ7J2IBX
	j0Ks6fbPpxG++1zo0cCgbTDVUAJIXl06hyehXbTpEhW6q+ZE7M1ZcF+Moda00qMbJNQtGsLUBrU
	v
X-Gm-Gg: ASbGncvu8MdFf3RZ/suzv4khS4aUvy/8wCXkYYg+vygkUZZcORmvBkr3oyjdtzlgLxh
	EABkUwsVab13meD5OrE3CSdgFI8YyYRZ+Xd92Y949MzYtjV8EU5OZxdgfe+TfZ74pjx5Kmn8IzZ
	nm3iTl9ldQNbx8lEqEmwI47dOnJG4rJWcovXlQyq2d4AexqoKjtDUTZoV12CTHRUkohcT9qBAGg
	hlpafGDyWLI2FNlElp0bm/9QJyvodZGV/zKgSu+9JUMTkKwveFQva1Yd4D7yA/PrcMbweDU5+t5
	gkhqEsLH54BJEjDwPtO2ZpGOKNw5bgcm3m/ly4lUz//WytGjQyvWcPTMd2D4lpk6J78abVSGGqE
	EC9mEZXU=
X-Google-Smtp-Source: AGHT+IG5R5YrVbhsBygDbTJW3RBFNhnxwZ5J7uRjEbmzF/HsFCfqXXh/EKX24bZJlDtE6Lar9+c7CQ==
X-Received: by 2002:a17:902:f68a:b0:223:fbbe:599c with SMTP id d9443c01a7336-22db4981ef9mr225411165ad.19.1745855610370;
        Mon, 28 Apr 2025 08:53:30 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dda40fsm84483705ad.104.2025.04.28.08.53.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Apr 2025 08:53:29 -0700 (PDT)
Message-ID: <e6d50cb4-bdd9-48d5-8bc3-d8280f09baa2@linaro.org>
Date: Mon, 28 Apr 2025 08:53:28 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/8] include/system: make functions accessible from
 common code
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, alex.bennee@linaro.org,
 kvm@vger.kernel.org, philmd@linaro.org, manos.pitsidianakis@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
References: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
 <20250424232829.141163-8-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250424232829.141163-8-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/25 16:28, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/system/kvm.h | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

