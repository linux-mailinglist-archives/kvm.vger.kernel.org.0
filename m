Return-Path: <kvm+bounces-49259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F400AD6EF2
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 13:25:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 783201895A70
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 11:25:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A0523C8A1;
	Thu, 12 Jun 2025 11:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fBQDkjG9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF041229B38
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 11:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749727509; cv=none; b=ReSyyKQiX9+a8Rbl0nOhnHyQrxWcy9MwzCbUEHGkaX7fYArlCrHX9c5TrR+IsCarZHFH32bXB27so5PH8QaavWjs0Qa8GplcwHfuKfgNsCY4UPLLIsqjsJSp8XLLJRFtLilPjWc9DNyXWlTidvCkSVV6fXdCozEJqWSQjoEZckQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749727509; c=relaxed/simple;
	bh=RbS4ZKDnvE31XgDmp4nfObFBJ2jz3h0yh4h4K+Mw0kE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=afP+ufLRYzFOFUuV9lCUZknM2r6UYUa/q4r/p/MAcAI0Sr9SxUJ/E3wEykP0wr0dsQfTunrrSHiMreNeSfIaNtaN4CVU/6/6hY16wF4Hf3JuGmeQpEt+rbUcs6TpBEx0BV/kpHe/v4UCfX4GEp3ZIw5tyTbfR0yw+HeCjCwVj74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fBQDkjG9; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-607ec30df2bso1687140a12.1
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 04:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1749727505; x=1750332305; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pIj8IHtKqXDoSV7RqqEU+hPFyfW0yTCMwK0/QeKPMsc=;
        b=fBQDkjG9e+vG1QD2TehiZFaYs3gNXPfL/7qi46ZYvyfZNStsBdNyiPFb9n5kf+x8yG
         h4nEyZULBwCALvFqikPXP+gYYb63uRg1iIb3h0pHI0O8CIDKDkJL8IKLG/CyGOCLrhgL
         P2C/5t8214sgaMZXTfiHMMIguiFGDnzITnQLYOOLQ9tF8IBOR7sASSVzV/4MeZrhetlq
         M9jYwJyG1Ej9a+ybutnOKGHYR0EkGUvZL1SoBmOKLJXvsLQdZEuIy7HI46AzWDzmZC1l
         pz7+F8DRa970MLZn9l5H+QOFEwgnxYWABd9Q8zYvaQzRDSZ+zjxrv24a+mXn55hIfZUB
         iRLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749727505; x=1750332305;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pIj8IHtKqXDoSV7RqqEU+hPFyfW0yTCMwK0/QeKPMsc=;
        b=sM85CK9eJS+ZQLXcUI0zH6RSo5D1y5AnANDTQo075XdnLWDwt05lrhlCvKLjb2cy2e
         c7SihWmR2BkhjH5AsKXVQdxz1pLjLpVuSI+iR3k1SpuwsiROlgDbd5xURO4M3852X/14
         rBftCack6b35v4uwfxnqsRnmMxEQF6XQJT77WyPVi2dcBwJLGa218ub8ZGeqpXBhj4kN
         cK3vv8pUr4xFCqzysHwDnAXr9DkPMARJgOg+hKOaa0/daRp5jYcU6plpoPEYAcio308m
         mKgd1TMEXC37UtwwZmwGtrQA6cwc0wTDgG/3RvmL1+yzEX6hBM/f7ot6vuz7HLXkjdj9
         USOg==
X-Forwarded-Encrypted: i=1; AJvYcCVWRbpMPcds1zquDF3yppwaVZjFEg/mdbrQmJ7m1nT+CMHt1kS8C3x95Z0afm6G8lachn8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlM4KvC0zRDyABcV+X+aGAsy+QfQKeZGaAZRcs9H56ZKTU5A4J
	Nq40FsBAIXW7WDv6tlDEF7oJQzBxVZGcpZCDHgsZELOZxpuKPVByWmHKmQf9TzKvFY8=
X-Gm-Gg: ASbGncuySqZJx6lvo4oGHpbJEmJY/CRx6xTzyhy25dcthaB02T1DRwwYMA+XRRiqAxA
	gP95J8hoQS37hm7hukIIh1ea/3MpaJsbYJGL95iblwAfpCnpuUSBxapxlLAVMHkWozVfS/lW3cC
	DKNhXrZVJ29WVuYeTeptbvvKjiQgEKFsodgdXOCfljFwTOu/yq02xN9bgoAfgKZHCUOAYJLFIBM
	b0HCPCVIgPoYEm6KlSwcYTDvRIiDwzGfTxUQ0hwfxF9NzoUsx30pn4Kc6l5McZU8yZTGxKgisPN
	MkTsOHuYKEzvaMtO1recwX4/bkNXagOgahgpcVG08Cx0vsE7MsEYhiOJ95jeXRV85HnKqtKTYrJ
	KY4LT6izTM5hh
X-Google-Smtp-Source: AGHT+IF+vAVMBvtfci95n6Tv1oY41jgX0c/sjmQXnpnK+od2hyac12ir4pt5adwc3OXI4vX8N7E9Ig==
X-Received: by 2002:a05:6402:2792:b0:607:20d0:4e99 with SMTP id 4fb4d7f45d1cf-60846b1fe4bmr5326317a12.21.1749727505368;
        Thu, 12 Jun 2025 04:25:05 -0700 (PDT)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [109.121.142.22])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6086b22ab35sm1034244a12.60.2025.06.12.04.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 04:25:05 -0700 (PDT)
Message-ID: <37aaaff2-2519-43b3-b388-eb0185e03c41@suse.com>
Date: Thu, 12 Jun 2025 14:25:04 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86: Deduplicate MSR interception enabling and
 disabling
To: Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, dapeng1.mi@linux.intel.com
References: <20250612081947.94081-1-chao.gao@intel.com>
 <20250612081947.94081-2-chao.gao@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20250612081947.94081-2-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/12/25 11:19, Chao Gao wrote:
> Extract a common function from MSR interception disabling logic and create
> disabling and enabling functions based on it. This removes most of the
> duplicated code for MSR interception disabling/enabling.
> 
> No functional change intended.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>

I believe similar change is already part of Sean's series on MSR 
intercept overhaul.

