Return-Path: <kvm+bounces-54890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CFF41B2AB25
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 16:43:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 185981BA735A
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 14:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74B60320399;
	Mon, 18 Aug 2025 14:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="oLVCclbF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5F135A2B5
	for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 14:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755527128; cv=none; b=KgLctHLs2m6Dbz7ErX/2lZ/L2IRJLeoqV4DJI9SbPQbjRTCQURO7sEwufX+saJRznuXnGZw3P8Y5djlcNS6yJDTcHtVU+Z/Mm1iCDlD4VDqzHbhM0u1sKWYkqjNqNsASNMZ8zwlqJRoCKKU4Z/Ol/45h0YFNz0VBcj1NZwvcD2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755527128; c=relaxed/simple;
	bh=eAzCytEyJip7F9/ujfFz6fHx6PhzFC86Nee1Y1YCmFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BHphDRf4abYY9cnRHS2EkW4OwqxhugJamwinlR9yNk65tuYiA0H+d8ZW6KAMsKe7GzQIAJvvYI9y5hACEiGQnhXJJBFzM80vAXrwXP1i8jp6GwDNASa4F6CP4BNczV8PDEuQICY+BWPUN7DbsyAHuXzSb4kiiWeIO8KEvoCUC8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=oLVCclbF; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-88432e60eebso93868639f.3
        for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 07:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755527125; x=1756131925; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FyQYJ8E1IoELk0qTlvKHUstdV7nwQIqLjOnOuTovC8w=;
        b=oLVCclbF8hbD2k8HOXgSdYpAVvUfX0vTHN35X5ws+CbWapXMfkP7hiVyGicGYERjvB
         XZN5vG/F71xsO0ryhJRUx9WN4DDFDmXKkpdX6AzfnjiON89Zc1nCvZgg29Tv6M1ovz5u
         iQMK2lLeN0zYXdRu/3LVG2Sew0f0oErCx6m93Jwz6HhBu0+QYv0NSSD0w/XoCHQ44u8i
         NF0WSGQ1o/g3w6jD2tbL7SFHy95fAKCcgAVkvTS0zxkav16OP9jmDvE1opzBGlrRl+27
         Xoq2KAfbaEtogLnPoX24HCN3D5+9jMrf0Ru9VAMmc+QjHIYKQvLP3pSwbKH/opG1ofXz
         /FOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755527125; x=1756131925;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FyQYJ8E1IoELk0qTlvKHUstdV7nwQIqLjOnOuTovC8w=;
        b=ivOWCF41bZ3aQF0ZEruHScZ/lxeNrfcxnkqHEX5L5F1IjlF9/+nO+6uUfBzLlHZi4d
         0D/D9DhyuO2Ux8pa8nMLK0OnAX0PfeELWDxmLfvzn0cKADaeDR0cRTml4s/uStdh/xfa
         9IWPsWmfF5pH1lkQnythZ938LSSJrMOyyCE8jRNNnmG31xhXKguCeSnNt5FhsDE3e7Xq
         ProLvQMMylsiZ1r+MDzhC56Tik76AjybBE88t6hNECYDCSQWAIKCzo3bZu/2qlh0f8pt
         GYtmQ+oSRk1DAjfBs8FLCEcGzMB2fDgPZwU5mNbMH28S34wVhQXMoACH0hVqGWpwAjws
         qOpg==
X-Forwarded-Encrypted: i=1; AJvYcCUTkb1n3/dXfOj1Sw1OCeB6oLBzbd4f6dZKBztlzsFSCb54l2WQkaRJfmKNMVdVfvCea4Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNhCjXjL/YV2NcpQ7KXBjW+g+WMS2Z8LFdEaNpsIU3CrkjcViT
	9iNQ5rjKazVRgnmoK9H02Swxi76DNyXpQY/BmFO7l7Cp4hv3gxizELT1pBC8OawRIng=
X-Gm-Gg: ASbGncsarE6p0VTAOGYCjBI3HtHpdDNnobMQz7yv1L3j70nb4hMGvuhxcMSb6SR/Ij1
	xe+43eBoatQT6PWZ3xuf/WIm5oVr6I+jRpDAN2rpwDHrS7GMhPVE9SvXsIslpo3ZehcNrXuL/g+
	KF9P02cPpTiPqCmOdH4l6tPNJpFT5g6cWR21/dbq+Hwy8x3ZIz4KBPPwar/5qBCBwDr42EoCUQp
	Z2b9tgDSOYouA4nsRwZF0jFAtqe0G+tXh38Ke+572dNKgUvnhxj+3X755J1nvQ3M0kqn7NRzIl9
	m8BlnWU7DFt7tr7D+eW0759O6BT+/EAQFdfXWZQdYjStb+97Lt4rxBz/jM3vGeO7ewU2PKNhzu+
	hZQfIHuUANu4uNdI37T/9xTyS
X-Google-Smtp-Source: AGHT+IE64bGylTNTCod6VJPB6Kdqx/YvIcxD3l3x6WiSKJyPUG0tS+DbyXFafnmRow5N9BI1j9Ev6A==
X-Received: by 2002:a05:6602:1687:b0:881:8a24:55c3 with SMTP id ca18e2360f4ac-8843e36de4bmr2011895139f.1.1755527124401;
        Mon, 18 Aug 2025 07:25:24 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c94999fe0sm2564173173.57.2025.08.18.07.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 07:25:23 -0700 (PDT)
Date: Mon, 18 Aug 2025 09:25:23 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH] RISC-V: KVM: Correct kvm_riscv_check_vcpu_requests()
 comment
Message-ID: <20250818-3808a778aca8606ddd126ebf@orel>
References: <49680363098c45516ec4b305283d662d26fa9386.1754326285.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49680363098c45516ec4b305283d662d26fa9386.1754326285.git.zhouquan@iscas.ac.cn>

On Mon, Aug 11, 2025 at 10:18:29AM +0800, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> Correct `check_vcpu_requests` to `kvm_riscv_check_vcpu_requests`.
> 
> Fixes: f55ffaf89636 ("RISC-V: KVM: Enable ring-based dirty memory tracking")
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>  arch/riscv/kvm/vcpu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index f001e56403f9..3ebcfffaa978 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -683,7 +683,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  }
>  
>  /**
> - * check_vcpu_requests - check and handle pending vCPU requests
> + * kvm_riscv_check_vcpu_requests - check and handle pending vCPU requests
>   * @vcpu:	the VCPU pointer
>   *
>   * Return: 1 if we should enter the guest
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

