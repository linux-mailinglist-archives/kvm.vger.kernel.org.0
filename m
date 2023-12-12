Return-Path: <kvm+bounces-4191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E01480F0E9
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 16:30:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE3D7281D0F
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 15:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5867178E9C;
	Tue, 12 Dec 2023 15:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NtYTEJvp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAB4137
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 07:27:47 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1d05f027846so26620245ad.2
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 07:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702394867; x=1702999667; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZZ6xyLlDqP2HzhoisoMpXYUdm7Lsr0C0A2wp2zF5kO8=;
        b=NtYTEJvpIInPuiK1P400P2OKYM+/1HhFnmXNfTUUD0LTOXR3EcXW2q/VF/2xSx8PHl
         +MBHA1nCt+twQcr0oP9/k/fIp9AAJdABnxTFEK2i8JSYPvylqEd9wYiUmJxajGOdw7ZX
         pGeqCKsB6Fb5z4+XWvJemeYGCcnsfBKTztyq0S2CLvGVJ4PFUBrBFTVSrN1JX2kLidw6
         0YMLRYfDr5JCUmC72XU922oHvEliODPFxOdVhSc8mk2F60E4ADTopm+fh6e6UMeWdYn4
         LnAITHss40shGX4VC5sN/SV91r/sinQ8fJvWy5/3IUwwqAkaMv6GTNDSzfnRxuhbJmZ0
         CToQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702394867; x=1702999667;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZZ6xyLlDqP2HzhoisoMpXYUdm7Lsr0C0A2wp2zF5kO8=;
        b=uuzDlRaD/COZxOpzBLbiMSYqq6nj9KW5H41VwuBkX4ddGiyZj39rgy43pktLAKVBpE
         ZqjENLW/vDZHzJSqud+kV/fgdDG7KQJhYZSfoU5pQtk2osDDuPQSXKi4WQZPo5htXGiC
         T6VZGZkbLWCPJt9McUMfUlARV3jF29I45qboDGGrZ9LVofhSqqYQjurMe5fo2II2yekB
         9fYu0AfeRZkPOYrkah1VuCjbPDqb3hSyP8Yw5otI4bfUsChGpc9efWdbhSzUheCB7mIv
         whKvt6w4eWynyowQ+hrsJCiCkg/bEhE1df9nAa6P/qLROPJXfe3LqsFdR+1IqQo2pZ+s
         wFjA==
X-Gm-Message-State: AOJu0YzMiGD1/Kfiy9hhiFcsV8s/AtFfqeKTRM8DAf3wgj7hiGgSkN1g
	bKAfs3UeWLFfm7oFx/VaW4gnzzNsG7I=
X-Google-Smtp-Source: AGHT+IF4zAbXwYb4+IXMcu495kEYZwrX7tw6+iGcHG9KiTeZyGMfQkHxjPCXE4yUrFFiRWQdoFDwM2Qpflw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ecc2:b0:1d0:53f6:b590 with SMTP id
 a2-20020a170902ecc200b001d053f6b590mr51464plh.8.1702394866819; Tue, 12 Dec
 2023 07:27:46 -0800 (PST)
Date: Tue, 12 Dec 2023 07:27:45 -0800
In-Reply-To: <20231207001142.3617856-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231207001142.3617856-1-dionnaglaze@google.com>
Message-ID: <ZXh78TApz80DAWUb@google.com>
Subject: Re: [PATCH] kvm: x86: use a uapi-friendly macro for BIT
From: Sean Christopherson <seanjc@google.com>
To: Dionna Glaze <dionnaglaze@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 07, 2023, Dionna Glaze wrote:
> Change uapi header uses of BIT to instead use the uapi/linux/const.h bit
> macros, since BIT is not defined in uapi headers.
> 
> The PMU mask uses _BITUL since it targets a 32 bit flag field, whereas
> the longmode definition is meant for a 64 bit flag field.
> 
> Cc: Sean Christophersen <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> 
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 1a6a1f987949..a8955efeef09 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -7,6 +7,7 @@
>   *
>   */
>  
> +#include <linux/const.h>
>  #include <linux/types.h>
>  #include <linux/ioctl.h>
>  #include <linux/stddef.h>
> @@ -526,7 +527,7 @@ struct kvm_pmu_event_filter {
>  #define KVM_PMU_EVENT_ALLOW 0
>  #define KVM_PMU_EVENT_DENY 1
>  
> -#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS BIT(0)
> +#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS _BITUL(0)

It's not just BIT(), won't BIT_ULL() and GENMASK_ULL() also be problematic?  And
sadly, I don't see an existing equivalent for GENMASK_ULL().

