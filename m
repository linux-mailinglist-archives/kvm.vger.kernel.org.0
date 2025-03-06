Return-Path: <kvm+bounces-40257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ADB2FA550E7
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 17:31:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F776173197
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 16:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D55AA22D4FF;
	Thu,  6 Mar 2025 16:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z9zB2bJx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E8422A817
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 16:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741278403; cv=none; b=Y5VOiXaBnfnm/OjoRAxiBei1IXLOrKoWTH+alxvaEr54m1gGp8k+QSQiAQiEjspkOmgXvfn6Bi4yLbvOINFB3PBjq9YJo/f8ftl6MvaLVL4Rdxwd7EmNSMNF0hktEKV47/alATWptQHkuKn4FbBBh5qCvQ7E8e6GGakltJ3eqFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741278403; c=relaxed/simple;
	bh=mWxu7LqOrGwLBbBN1ZHOUxEmdmbiDmG3wz74UtGGd7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tMLYpKfbgvqchSRXQAl2tnVT2vRlxSLRcEvr2m6UyLUVyvOgkxa1rgmMTVD9v57cw2Qd8ywn6Rvgf1bpub7gBnBqMYrhBFnGxqOd42JreCcyqG+VdWOx3uGLmdOcorIASrHh2Aq7WD6HOJeOrMhtX8NdTsR8AdGtErx0a+Kb07M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Z9zB2bJx; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-219f8263ae0so17475995ad.0
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 08:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741278401; x=1741883201; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P88s8ijDyDl014pRNdvWiHhjjv/J6gaml3H1P6W98Lw=;
        b=Z9zB2bJxpgoEACF0HCyTqz7aGwbAOSXssQuZCqn0B/bdM5y4DnYLdVjWH71G8eQXuC
         fQdayJNOu+VKvVGMmVpTs8GVpcjo2LxdK763ZzshcsBt6C583MDtSPSNnrLZ95MUcy+d
         f/4XfF1miOwXdNG6Z1s12faosyP/sS8HkBIo+QKECpZ8016SiS7S2yI+hlX1pcTCQJv3
         kL2dFJ7N+MUJRN4SqQNUY0Nq2usGM1f8h4lOWsfA6VMRPHlR0y+oE82pFPD7egWG+cGn
         Sl1ebkUy4CLujEHLzInWpG522VixGgS4QYvX2mMYNWlPmjPNT4IXA6pWl15bK6MfAYRD
         o7Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741278401; x=1741883201;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P88s8ijDyDl014pRNdvWiHhjjv/J6gaml3H1P6W98Lw=;
        b=WU87838HPjtivHnZ6Miz6Z6pqZs9It9fSpCUhyzUDWC+K6XK+uQPnvK4zYGBWuje8R
         SEGSFu/u1ftEXkT6dFkWAtad3yXuntXuhzXzCbb+s541+aelqbxBj5uqKbESqevmNNQF
         cGaAw7ar5ItXPZZ1pBIHJs7YmWRd491AN2twPm9MO9YNsew2alqTCJ5e3/B13GGp2r4Q
         5zvCV553Ve5bacsQGEgLBAuU7WJluYCqhBUClZ8nS7TSv2SPiSB+YT+DSz3wNA/YFgqm
         rl7cLF3cCaKaeJtl/iXO7jrB7/UFs5x24OJovP2uqg7qvaNWiOMYq9b1uKZ0Pdf9IUYx
         3iNw==
X-Gm-Message-State: AOJu0YxmzgQTbML3/cN8WzE3CqVKBd3mEdX+kAwshi/XgbNIYLFkaUH6
	I5n5CS+CKtTWweJApZCPxo0MROW65ufPC1ytW/nEq/YyZKgTHYF9bx1CLE9Q70w=
X-Gm-Gg: ASbGncv5R+MufIoky5a/e2fofdkkfU77VK0ZatZ17U+S1lh2/XFoMCvRM6AMBJJ516N
	TAPRYJRZIThkHYfzqR/3wMFmNa0oNfFSIwNveYdzGTZvwXjYPqQz5Ezp4KfMhZ/Mxy26W2Q6KK9
	eSP2kKdjv2c8pVpIoSYT+Di4UMGidJSbPG3w7OJo0C2XGCYCT1L7syrNe/+4XPuAmS/nxfnX7J3
	lx+9Zv1DKwSw63s+7ObzhXO/LNrAF9kA5VmfTnmEVrD0yg6ZPZLGx3bPkMRzhcRm7EC06X5isz7
	t+fK2Pqie4M3XfpC+ArS8c/KoutgmtdLRb+RdOl/JeVklYLxy/RPT4ILE2tBQ1H4yTQ8ib/Gtun
	XOKSrJOQE
X-Google-Smtp-Source: AGHT+IF2L/lKg15OIAaCMIYLxQaKbWT7sQWPJ+xEc0jfrMHwXQV6p9m7lMIUPUnEh8yf9K51D9tM2w==
X-Received: by 2002:a17:902:e5c4:b0:223:58ff:c722 with SMTP id d9443c01a7336-223f1c989fdmr142423325ad.28.1741278401547;
        Thu, 06 Mar 2025 08:26:41 -0800 (PST)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af281288790sm1247442a12.63.2025.03.06.08.26.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 08:26:41 -0800 (PST)
Message-ID: <0226e9d5-edbc-417a-8cf0-8c752f52b7ed@linaro.org>
Date: Thu, 6 Mar 2025 08:26:39 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] hw/hyperv: remove duplication compilation units
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, philmd@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, manos.pitsidianakis@linaro.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, alex.bennee@linaro.org
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/25 22:41, Pierrick Bouvier wrote:
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
>   include/hw/hyperv/hyperv.h       |  4 ++-
>   target/i386/kvm/hyperv-proto.h   | 12 --------
>   hw/hyperv/syndbg.c               |  7 +++--
>   hw/hyperv/vmbus.c                | 50 ++++++++++++++++----------------
>   hw/hyperv/meson.build            |  9 +++---
>   6 files changed, 49 insertions(+), 45 deletions(-)
> 

I'm reasonably certain that hyperv is specific to x86.
Are these only "duplicated" because of qemu-system-{i386,x86_64}?


r~

