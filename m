Return-Path: <kvm+bounces-24190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD3999521EE
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 20:21:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A7911F22A33
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 18:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72B1C1BD4FB;
	Wed, 14 Aug 2024 18:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cbH/KAqy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD2D1B32A6
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 18:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723659661; cv=none; b=gQ/c8X3SiR2GrnD4J7QwQ+w8hyVbEmvMIHOmOm1CgiJuqiOuf9kUfJRmCcRwxSMJaYukcdXtJ2ZBluC4i1VrZduLE6ZsSp6ey0K+rUNqtaiWzhJn0MQyGCisp+Us5n1Mj+v1JvE92T8wJaTw84096dwcYJBz6TIKNQwJP7Cmj18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723659661; c=relaxed/simple;
	bh=bHDECcYDp19s24S92USoh/2+lUH+B0wiz5SudmVmwDY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fvGQ78Ht7WKNrNBQfZDl89RkFGl3HadMWXwU7de/0Yh0eq3el59RpYbW9mApgkbkDPF6/fHgZ6Hp7Fj5p7gy5dxrYNJ4gE2EYtsbymwGDY6xKZdbkefB0CUF1uyHZQvfZvuoNivngiSh7wRchYI7mxldEN9NHYbeCubqLJ/i5Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cbH/KAqy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723659659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+MjWVAAwhnNERCURST++cb8Cda152SeJC1iT5p1BEFo=;
	b=cbH/KAqyCTX5uxkN3KePDrkQvcKSgGZTtDDY4EAxBtnzyscrVN/RatPpYrRg0rTsGeYG6D
	Ce2z/6pB2jWXzVlezUjndF6CylTrsvchGNmLXiiaWiSoJY0Wz2dSREQdnnjO6isLyooCSN
	g1l8RZGuhONMQ0L0UGTn4QKxG9ZwA1M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-q11tAgskPmePi-ESWvIeMA-1; Wed, 14 Aug 2024 14:20:57 -0400
X-MC-Unique: q11tAgskPmePi-ESWvIeMA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42816096cb8so810175e9.0
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 11:20:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723659656; x=1724264456;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+MjWVAAwhnNERCURST++cb8Cda152SeJC1iT5p1BEFo=;
        b=e0AZaP4dALMj99xfg7Inh1xO+yM/hEo9bV/XH8h/r6VHw5+ZlKsSMWvvauZj4ybgqS
         d88+BVrLDlMi4CkP8WyS7i3VNIEQ1iOjLHkpQmtnqeh7KHTrgVaucAriM8+SBa2zYC/c
         2hJ4I7qlisnxMcNMn+CFbom1CKbjqEuJHG4UUccoVXqi1XXbe/+TyQoyfLG9ZqUPPbnZ
         TxaQegDQZe7y6RLsovBkA8RaHO2w7Yrbxz/2l0axVB4/o0NKjxmwmjbUGfsJrgSPpuBX
         T3wppDpdRcEq50AxXDVXS1d8dzTepB+OfWwZyRmb7s5NB0kOzrRdMGxn5bucu0kc6few
         9XyA==
X-Gm-Message-State: AOJu0Yy899UCOYA6+h8SGvLiUXCHZ7TAAAYaCo4B0LiFV72FYlGD79ny
	O2Pvr9aoIRW1KkXTp0MY5Ev+F30AKuNlqu3nOyzMMu4yXtceBxsSXjUT4cmtIbAEEuYLr3fJSwT
	fY9KFHJHqcYOs0tWQZN+E1OU8VQjiOzbO3j+dUCOq07l+4AakDw==
X-Received: by 2002:a05:600c:4e4d:b0:426:59fe:ac27 with SMTP id 5b1f17b1804b1-429dd25f730mr31815005e9.26.1723659656378;
        Wed, 14 Aug 2024 11:20:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGz3KdZ+hT/xudOLocHBKfqm0syJCiNBfzo5Wx1XSl+fmJNsfepKFF8yyxqa5f0vgg3nSVZgA==
X-Received: by 2002:a05:600c:4e4d:b0:426:59fe:ac27 with SMTP id 5b1f17b1804b1-429dd25f730mr31814835e9.26.1723659655883;
        Wed, 14 Aug 2024 11:20:55 -0700 (PDT)
Received: from [192.168.10.47] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-429d877e066sm62720955e9.1.2024.08.14.11.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2024 11:20:54 -0700 (PDT)
Message-ID: <5de9e883-e93b-4f50-b926-ac25613fe0c4@redhat.com>
Date: Wed, 14 Aug 2024 20:20:53 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/8] KVM: Enable virtualization at load/initialization
 by default
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>
References: <20240608000639.3295768-1-seanjc@google.com>
 <20240608000639.3295768-9-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240608000639.3295768-9-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/8/24 02:06, Sean Christopherson wrote:
> Enable virtualization when KVM loads by default, as doing so avoids the
> potential runtime overhead associated with using the cpuhp framework to
> enabling virtualization on each CPU.

Hah, should have read ahead to this point of the series.  Just squash 
this in the earlier patch and call it a day; and place all the worrisome 
remarks about possible latency along with documentation for the parameter.

Oops, there's no documentation, :) please add it to 
Documentation/admin-guide/kernel-parameters.txt in v2.

Thanks,

Paolo

> Prior to commit 10474ae8945c ("KVM: Activate Virtualization On Demand"),
> KVM _unconditionally_ enabled virtualization during load, i.e. there's no
> fundamental reason KVM needs to dynamically toggle virtualization.  These
> days, the only known argument for not enabling virtualization is to allow
> KVM to be autoloaded without blocking other out-of-tree hypervisors, and
> such use cases can simply change the module param, e.g. via command line.
> 
> Note, the aforementioned commit also mentioned that enabling SVM (AMD's
> virtualization extensions) can result in "using invalid TLB entries".
> It's not clear whether the changelog was referring to a KVM bug, a CPU
> bug, or something else entirely.  Regardless, leaving virtualization off
> by default is not a robust "fix", as any protection provided is lost the
> instant userspace creates the first VM.
> 
> Suggested-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/kvm_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e20189a89a64..1440c0a7c3c3 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5495,7 +5495,7 @@ static struct miscdevice kvm_dev = {
>   };
>   
>   #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
> -static bool enable_virt_at_load;
> +static bool enable_virt_at_load = true;
>   module_param(enable_virt_at_load, bool, 0444);
>   
>   __visible bool kvm_rebooting;


