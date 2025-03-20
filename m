Return-Path: <kvm+bounces-41596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C72F6A6AE2C
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 20:09:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 127164A1917
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 19:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C21222B8CD;
	Thu, 20 Mar 2025 19:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OiZNM9IM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBE0227EBD
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 19:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742497243; cv=none; b=WApD9YaGtAo++y0brL5Mmz/4fw/u3MvwX4wxaMRGZ4SDcacVDmPEX1DtTWyAx77E9/tgT1ppY9C9B8hwJoM9bGjy4Vi29b4qONBMT2/+RWrr4Foi7pG34ReJa2I5HZHy6FcLfn0k/t3pEKtdYfD2JcBCmF7XUs5VmaUwt3on/DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742497243; c=relaxed/simple;
	bh=Ke2sAOf9NryAkew3g0U5wgxrfipfdN6+LjpIWxFt9zU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dDrilz3wFKB+ZXkoJaruQNkOjI/esgj/JjdPJTtt+OJXAAc0EvL5S9sEvUCQbg1Nu247woAgrL5i4AGuIR6kgcVxM1WisoIXmGvLRxBc2QixDJv+Gc4AUwxHLXUkDXibfXN2oAtewkXaR/RnAMFRgdoycRYFBIg7q+HSQp1Xc00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OiZNM9IM; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-223fb0f619dso24916005ad.1
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 12:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742497241; x=1743102041; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=weHsotjSjln9MgHLKOIKUdAUmOsOwzultrmV4EVkHwc=;
        b=OiZNM9IMIrgm0g/07D5iAeVAwn/9/FAir5gBdcm14la6cFEBUVC/ZmOIvbboB94Mdz
         nTMVK/CEUybV5LQxuD+pQnMny1wntLLbT03WtbmqHboZvha80weA1iW4DfNA86H2Spld
         hJEUPkJCpWfNLAYhIHOKU7fiULjuUiyZ4sNUlk53/7nEyX6iUYifReA8mE2nBFSdKDm9
         rfT7W5JvMIwKcqJY2W/cwUfsEywrEOCNjpm0KegKfjIq3GrgnH7F0RQWe5pXw7+nDDn/
         IwT/WjVEzhXf+CTcYI5PrD828zawSxlTL0HWES0zDh+9KuDu+aMInfrl9qBpq6zAd4Ma
         ajvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742497241; x=1743102041;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=weHsotjSjln9MgHLKOIKUdAUmOsOwzultrmV4EVkHwc=;
        b=gj9pA6yDA+WJehOx6Ruv8bZg3QQTj+cg8JQb5DQ2FL1qMx4O3knPA0snCDwjx42WLv
         0a29r85Ou97DXN7/FcaaR434OIWi6b73KtuZ4gEgsn1RRUDKcp7eByRn45tV5u3LZ5Es
         XQKIdsHKYKD0YfZGJpO4OfZXm/rlZtETucKcyQwu9JBUj2uq4b2N9RORatUtBXNthhcr
         6TPhwxpcNO3yuIESpD2MIcVVL1Gl8AM0bA9/JYUGqN8QO+Wk+S81jXK7WVRqgk9rYhYe
         veinPjLUwPduTPKjRRWu1BcHMLz6WcN6dl3wWnfIQg85QBpp2/FfZMNKChG+3e2VyQpk
         Iw4A==
X-Forwarded-Encrypted: i=1; AJvYcCVkvuC5LxpTN61/y5L241yLBdyDDEgN9WUihicXMIdeRYaNqGwHeT3jo6gsTQRIdPEuLAY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzSAkyTDAm+eJ0yVkbf+ULYWFTlnSha8PQYcLV8PBND6eGJpAn
	AJMYuQAr2c572bxu5s1Rjz0jDQqqS+mSMuj4zoXwaRiIGnag25uvsc6SbKd/zyDz56eqO+P8xip
	f
X-Gm-Gg: ASbGncvEI5ddElrf8JR1L9YZgN7z7PVTYEzfYUV0Ch0UUIJ4M7E8Saqtz2k8cLIHGmT
	pn0pNeWWvdv2S1fiRWMsw9k1pHS+zO7ekz/Q0oRuMfBNJQtp404K3nu4mB9MllTqy8Z6GaDb0JA
	GKFYeFoK0zc2PPe3myuGwhiZBWBXasEWpfYtm2i55A26oxRAB3/eklPTBNaWAwwMb1RnOif7dG8
	GqzQc91aE6W1MP17IHiVBAO+GoMK+z6aFSGWme1v7G99cQzbywJaVL1iN63rmmzmFBNHdKCZTM5
	lW6ob+eNhRdR0rezILPptcyGyy7jwL2lO1ljBNs6GiaO95GrMAcKEBJEbc70blnww2Dn
X-Google-Smtp-Source: AGHT+IEDts3benM6NmGItX5fga4Aa+CyXqI9YpnoThtJBcl6IK/cPPeYhxJyUZDqG2wUkSMleZOB0A==
X-Received: by 2002:a17:903:8c4:b0:224:76f:9e4a with SMTP id d9443c01a7336-22780c74ad2mr8405635ad.14.1742497241060;
        Thu, 20 Mar 2025 12:00:41 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f3964bsm1511655ad.32.2025.03.20.12.00.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 12:00:40 -0700 (PDT)
Message-ID: <5a97e6c4-72aa-492b-8e7f-c0f874ffaf23@linaro.org>
Date: Thu, 20 Mar 2025 12:00:39 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/7] hw/hyperv: remove duplication compilation units
To: qemu-devel@nongnu.org
Cc: philmd@linaro.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, alex.bennee@linaro.org,
 Marcelo Tosatti <mtosatti@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 richard.henderson@linaro.org, manos.pitsidianakis@linaro.org
References: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/7/25 13:56, Pierrick Bouvier wrote:
> Work towards having a single binary, by removing duplicated object files.
> 
> hw/hyperv/hyperv.c was excluded at this time, because it depends on target
> dependent symbols:
> - from system/kvm.h
>      - kvm_check_extension
>      - kvm_vm_ioctl
> - from exec/cpu-all.h | memory_ldst_phys.h.inc
>      - ldq_phys
> 
> v2
> - remove osdep from header
> - use hardcoded buffer size for syndbg, assuming page size is always 4Kb.
> 
> v3
> - fix assert for page size.
> 
> v4
> - use KiB unit
> 
> Pierrick Bouvier (7):
>    hw/hyperv/hv-balloon-stub: common compilation unit
>    hw/hyperv/hyperv.h: header cleanup
>    hw/hyperv/vmbus: common compilation unit
>    hw/hyperv/hyperv-proto: move SYNDBG definition from target/i386
>    hw/hyperv/syndbg: common compilation unit
>    hw/hyperv/balloon: common balloon compilation units
>    hw/hyperv/hyperv_testdev: common compilation unit
> 
>   include/hw/hyperv/hyperv-proto.h | 12 ++++++++
>   include/hw/hyperv/hyperv.h       |  3 +-
>   target/i386/kvm/hyperv-proto.h   | 12 --------
>   hw/hyperv/syndbg.c               | 11 +++++--
>   hw/hyperv/vmbus.c                | 50 ++++++++++++++++----------------
>   hw/hyperv/meson.build            |  9 +++---
>   6 files changed, 52 insertions(+), 45 deletions(-)
> 

I've been able to address comments and conver last compilation unit 
missing (hw/hyperv/hyperv.c).

However, another series is needed to make this compile.
Thus, I'll wait for this to be merged before sending the v5 here.

