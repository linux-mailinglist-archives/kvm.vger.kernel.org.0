Return-Path: <kvm+bounces-40419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9FADA571DF
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:33:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C4B81893F70
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB3624887E;
	Fri,  7 Mar 2025 19:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QFu0VWAd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01A8224242
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741376022; cv=none; b=mMStBxNJCVMVvKCNT5tuez5f5V2Ax+QWUxKBLcCgN1hV/UhJKLSOsch1fNtsjn6lDrjcN4JyNV+6yrfzlCZkmvYvA6d1W9b1PhhAuSXT+juiTymmDUMwiw345/oHbkr0/V9kV2xUW5ze8TdICP7GR3s0OYBq4EwSmntevOrdY+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741376022; c=relaxed/simple;
	bh=eQs62AGhdAvPuCC+/Ig+eijptKL1f5OD1hSUbdfKHSQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F+wLJnPsUz4MCcXrJcF8bBduL302m5ciEr9/jZCC8xgc3JImi27Fdv32MEUiinTNMa1yGPyyHfLSiSZQXYKth1N7Pff28sd6s8juLHgCJlIVG2cO3XVJBk43hzSBm1jjRJGRuJVmAvpY1+7RQvrvYujk5BI+tQ/92sVOdMVfFoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QFu0VWAd; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22185cddbffso64224205ad.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741376020; x=1741980820; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kQtKwscGA1Fc77I5lFPC6Ac6M98cGe5gyWtKXlb/MhM=;
        b=QFu0VWAdiqcSCr08OzuS0mifZXFajVP5D4PzwG4teE7P4lIV7iKu6bPy4E1ko5kVND
         NO8k9C8OSa3LYQ3q7urGq6h7ptO83p+0fj+vhKTCO1eXn0GWGuelYcDER/0zOKW/ip/u
         +wCfrp+XBTOVJjK+KFHt6c0gD4kpyyY5ayq1+HWV2dEGG/Ys76RKrzr9R2uXDILuAPAN
         WSW3fHZ4OxrXK31eNTCDFhiMqvq+vovHObXlVFNx7m5g1mSPu8dmHLhHclM1/NPKEszj
         z1yfDELfkYRVzGGO85WuvZraS7CRWT4s48pWOXrq/oH7D4RapA01UX5/HNk2+3qB43Lr
         Bwzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741376020; x=1741980820;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kQtKwscGA1Fc77I5lFPC6Ac6M98cGe5gyWtKXlb/MhM=;
        b=rH3yedVIhQnOcf/qVX9eCSo57s4vwryHXPmnunr+N2QZMSx2nidZ6dGVbMr9CKfpyq
         UL8kmosFE2OTnEsQXnnkNnPkFrytYlhD2krbbGl78Q969uLg1WlN+h1MQB0PFXCQPDIl
         qCDmgbBaf93hicOCCSIyoYiRRL0RU3HuH94jVG/Qs49X+l4GQ+dKeOLlJNjl4CPe/Fjl
         f0R0Lky7jo62RB/sOSvT8UgmGpBaU+va3NEebkybi51KTKMsy1c5/f5qz6ndAZs7cq1C
         sii/3B4+WtpXxdW7m0teaq0q6FzAqjRUIvvxSr56XWy85DaR+ujnUdL7RmJjUCOxvaHh
         VUmA==
X-Forwarded-Encrypted: i=1; AJvYcCXFLxtHOrj6aDGt+UmNxYRj2iEPLP/PElFuJTyEvXwyhAuEJr3FgXGSkfMByWm7VlZ1P0g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEJIwpacyAQQKzXdEJMxCVzXfXNqUInrKQCsVpwdRxVUtjUOn6
	U43RsBsa+6XU1rX7GnFg/MttFFPTNgmJNfU3I8FwAqVCcTZJTTM2mxdYqNF6FDjwhyeu/xFJeIx
	C
X-Gm-Gg: ASbGncu6tIfdUWp9BkrRq+WKiBy4ev/CGE7rtCoEk7e4AVoqOed0zgPjmij/2dqkIOY
	xczxR+Ac5cdlEprl6IlTtPihAusCfKlLd9UkOHx1R3HB5bS76/5UwtpmmtRsTQuv5gDr90dF6QU
	qeqsi1mODlLB1mx5YAVXjY3rWfXPpdjJtVcuBZZ5bkttMhPU5M15Kwm4uSYqRrs5RdEss4fe2Ic
	DGqo8e20d39OmR43cpnK6PkKv2Bq87YNzSHl7ABBjYAcDv6pvbwKS1R3JRy07yMABh4Iz4wj8x+
	xLCOKmetghDRRBg8KduJzmy1WMl1OYw+JgXKamww/JnE0O/l/khofJiJVllEFx2VLMuh+lNdTJT
	NePxPe8Sp
X-Google-Smtp-Source: AGHT+IFnRH/M1Fyd9n+8/LrvLU+Y5MRCT/ZlZtrgAy0yqYLSdoH1av40nIgKflPPMbD+gK08sTp4Tw==
X-Received: by 2002:a05:6a00:1302:b0:734:ded8:77aa with SMTP id d2e1a72fcca58-736bc09a3f5mr1117498b3a.9.1741376020123;
        Fri, 07 Mar 2025 11:33:40 -0800 (PST)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736ad0f7eaasm1847564b3a.76.2025.03.07.11.33.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:33:39 -0800 (PST)
Message-ID: <49257778-4133-451b-b6d4-d2e9db36c3ab@linaro.org>
Date: Fri, 7 Mar 2025 11:33:38 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] hw/hyperv/hyperv_testdev: common compilation unit
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: philmd@linaro.org, "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 manos.pitsidianakis@linaro.org
References: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
 <20250307191003.248950-8-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250307191003.248950-8-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/7/25 11:10, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/hyperv/meson.build | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
> index 5acd709bdd5..ef5a596c8ab 100644
> --- a/hw/hyperv/meson.build
> +++ b/hw/hyperv/meson.build
> @@ -1,5 +1,5 @@
>   specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
> -specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
> +system_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
>   system_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
>   system_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
>   system_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

