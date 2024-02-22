Return-Path: <kvm+bounces-9370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DCDC485F56F
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 11:15:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 549D01F227F0
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 10:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ED213BB46;
	Thu, 22 Feb 2024 10:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iKdkqw6b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00443717C;
	Thu, 22 Feb 2024 10:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708596893; cv=none; b=SBVtw9nGBc0rshgmrLfanJxGdQgen8Wpz1rZJ9crJpU6DaLIOpXV6nTpouTrXSDXxklyKepzxyal//4SnG/0m0OxAUppH54qs/QE5b7KdKTDyjd4o2BeNxb5/CjzPXNe3GsAsv4tR3azGMIbnrm8vvv3or95BrkWQ8UQjpw9g98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708596893; c=relaxed/simple;
	bh=eDm1MSEtuuwQgeMt9pxKV0QXXCrHnsB3Vj90LImQKZY=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=GLPNDB/bpiaQYeAHggQguoOAu6Pil32xGP4ILuF/fGBnR/PM6V/uJMA73/SnOAbdvY+cu0pwhDxJuHUYqVc4JwGKQbZpVuNqkXVxsDPnO5CTkgeEkAJ4PRVIofS7bVumfDwmMXNVgQbpjTxwWRj4e7o3+NqvV6LTXBUmG5ZDmN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iKdkqw6b; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-41241f64c6bso11714995e9.0;
        Thu, 22 Feb 2024 02:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708596881; x=1709201681; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dwr3ZK/EESU5ItyIiPXNdclroS1RFnr41MH5ydWu9Go=;
        b=iKdkqw6b0SLKPuWfm/or4L0pjrfzzUewqFP+/eHGUcZ64LodTeOeL4InLPrzgF6qPk
         sNGbSdqLvS8d4qS7lJAbwos8kGK7qwgKGTJL8Enwy6OWFGUgUH8eAqvE3vI7ZBTeepPi
         mnxN9fIrneM7vWBZUJFVD6bA7UXn+UU/SlC5mFgI+POIlxN/dDpTqoK5nkyQ9sXcWhRd
         n6IyeaFJLha9akzjNapG7CebOQMJlh+44TIzPthrp8OraDOgB8+V2fhsyVFGzsVNfeEo
         RTx/IgPT3yCzxtmJrks4J6WNMDKqrpOT3IhYLt+8uxFZ9vVoSkcIhEsLg1IZkoQHWH4t
         XXTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708596881; x=1709201681;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dwr3ZK/EESU5ItyIiPXNdclroS1RFnr41MH5ydWu9Go=;
        b=PEqstR+jcwksz6adzG+4SN1+7vNHQmslfcQ1Zg2kNZmYB9Uoxam5QwHCbjfwjGuaa9
         Seke0FHmggvfxVNo2/jj0+ILNjElNYnm5oFWig8pj24EXDvANj8NppLC0MPswQBD7TGh
         1AKgsJstNKuvJ1OMUQYZMXPWxBUzjkzXt8xnM6uHF6RJZN/SmfgRGW/MDqGpOANHhVo1
         RquYUh9RDTo0wNUflkyINFHmjuuXanQd0RbhQBf9DZykMgCbkcN7V0sX9CNDfgw/3ZWi
         yQLTfyCAKywutnEg7kfFGFMd8souv1S9LiGXDHRJIkf1dl1Z6cjstJLAh2MX+gfxbK0h
         29bg==
X-Forwarded-Encrypted: i=1; AJvYcCWXevhzWyKAfllReqPWqvT+2RwG7CtUjgb/ZMTAmPLVfP5xWWUCk7eCdgtSOoD9HhZKWReFT/oIt/LpbGzHd7qt+lpTyqArS1OPMSz90KslxyHSMcE8i8mzeIJ9FMX1u7rw
X-Gm-Message-State: AOJu0Yw30M+tvdWyNWhShhhz1pMVkWeCZeGKyQEmrT+L6Za7gh5VRxNO
	9M1x73LrG20lRaiB0JwRxF3uxVqzLijv3ZRThfh220/m2K1mxKgP
X-Google-Smtp-Source: AGHT+IGmYqPIuifxsNn0duFZDK9nAddGhKmLx/XhInUz1D2R7lXfIk0qXutLrqqc3lxcDxXlaNWrXg==
X-Received: by 2002:a05:600c:a39d:b0:40f:df17:f0ce with SMTP id hn29-20020a05600ca39d00b0040fdf17f0cemr15064203wmb.28.1708596880778;
        Thu, 22 Feb 2024 02:14:40 -0800 (PST)
Received: from [192.168.13.104] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id s7-20020a05600c45c700b0041279707ffbsm3654301wmo.15.2024.02.22.02.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Feb 2024 02:14:40 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <c8c37018-8681-458f-96b7-82bae88ebcd3@xen.org>
Date: Thu, 22 Feb 2024 10:14:38 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH] KVM: x86/xen: fix 32-bit pointer cast
Content-Language: en-US
To: Arnd Bergmann <arnd@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>,
 Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240222100412.560961-1-arnd@kernel.org>
Organization: Xen Project
In-Reply-To: <20240222100412.560961-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/02/2024 10:03, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> shared_info.hva is a 64-bit variable, so casting to a pointer causes
> a warning in 32-bit builds:
> 
> arch/x86/kvm/xen.c: In function 'kvm_xen_hvm_set_attr':
> arch/x86/kvm/xen.c:660:45: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>    660 |                         void __user * hva = (void *)data->u.shared_info.hva;
> 
> Replace the cast with a u64_to_user_ptr() call that does the right thing.

Thanks Arnd. I'd just got a ping from kernel test robot for lack of 
__user qualifier in the cast 
(https://lore.kernel.org/oe-kbuild-all/202402221721.mhF8MNVh-lkp@intel.com/), 
which this should also fix.

> 
> Fixes: 01a871852b11 ("KVM: x86/xen: allow shared_info to be mapped by fixed HVA")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   arch/x86/kvm/xen.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 01c0fd138d2f..8a04e0ae9245 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -657,7 +657,7 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>   						     gfn_to_gpa(gfn), PAGE_SIZE);
>   			}
>   		} else {
> -			void __user * hva = (void *)data->u.shared_info.hva;
> +			void __user * hva = u64_to_user_ptr(data->u.shared_info.hva);
>   
>   			if (!PAGE_ALIGNED(hva) || !access_ok(hva, PAGE_SIZE)) {
>   				r = -EINVAL;


