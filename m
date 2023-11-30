Return-Path: <kvm+bounces-2827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CE1987FE5FA
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 02:24:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A064B211A6
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 01:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AB166FA4;
	Thu, 30 Nov 2023 01:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DAu88USZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852EB10C3
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 17:24:40 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cfc42c748eso4679205ad.0
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 17:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701307480; x=1701912280; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FijcW7Tw2HqDQY+nVc3aasjWLlfqxmExsIveTz02HjQ=;
        b=DAu88USZFrzw4PSECulnLd2jUUwFwZwOsCY4pcGqtfspPfpDHNumJFt+idmYSn7FZp
         yJSXFY0tmuNm7JaHTP/Iblxtntfq/RR34MC2uY2E8yXx8fFI+kFN30fA+uLyY+ENL0fs
         Zmd+PTV6TSazIcdRxmsYql0iUTGbdPDwBTG37uMwuolQwwn2SuMuEyAe1uxzO/S0X/VV
         0VFQwOITblsf9DEifX3jXUimear9er80RKBd+1FwEmizr+abr9FTgCIkVlyMmVkDGrcW
         t7fJqdCMtI74myGF6JXCWIIIO+K8zqFwG1oGtsvTnmn5SkW205QO6VO1jH/oeQESTiuc
         mduA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701307480; x=1701912280;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FijcW7Tw2HqDQY+nVc3aasjWLlfqxmExsIveTz02HjQ=;
        b=PD57CiJuZ6oYFIQgoaBPGxMBieBQ38VCQE81r6Ch9QwneJ2t8RKAHaEp3vZlvGcJYl
         d3OA3ntPvNLv5Rse2Rc7Bnmf9s+QMWYHLZmhluY0djdgQG4n2zJqbzfcXoZFi64kAfVG
         AXspzXgmLwncUrgEl922L0jc4YXdhm7Y7SkjfAC3PBW1so/5KFqUnoixJlYuxItMpVkp
         hdbqonJdD6j2vojln9/QByjdO0jeeorHswid2edtAoJg2HJzEWTkFNdqmX7Wp30F5h/C
         2iwS6dx8MQZGlsqHNCKncQ6Bv2iH9CQu+EKktBo/z8G2970+Rs+A3sgAE7iKA4sY1wxO
         OTYg==
X-Gm-Message-State: AOJu0Yzjmg/IMViFp0VNsg483z8vLe+amvafcf4YkcHODa7mCZbAcvNq
	XcdS/B8rfYeco1FpDTTdqZtJ6DFhWM0=
X-Google-Smtp-Source: AGHT+IErsuc0JAxSV9mVa1KKUxzvdkHcwJKTQOB5cSVR+6B7NH/uRbY1BOT56iziJwTSivAzPdqEhwldt1A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:25cf:b0:1cf:d52a:2255 with SMTP id
 jc15-20020a17090325cf00b001cfd52a2255mr2256433plb.11.1701307480068; Wed, 29
 Nov 2023 17:24:40 -0800 (PST)
Date: Wed, 29 Nov 2023 17:24:38 -0800
In-Reply-To: <20231025152406.1879274-12-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231025152406.1879274-1-vkuznets@redhat.com> <20231025152406.1879274-12-vkuznets@redhat.com>
Message-ID: <ZWfkVnsYytDeeaDL@google.com>
Subject: Re: [PATCH 11/14] KVM: nVMX: hyper-v: Introduce nested_vmx_evmptr12()
 and nested_vmx_is_evmptr12_valid() helpers
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 25, 2023, Vitaly Kuznetsov wrote:
> 'vmx->nested.hv_evmcs_vmptr' accesses are all over the place so hiding
> 'hv_evmcs_vmptr' under 'ifdef CONFIG_KVM_HYPERV' would take a lot of
> ifdefs. Introduce 'nested_vmx_evmptr12()' accessor and
> 'nested_vmx_is_evmptr12_valid()' checker instead. Note, several explicit
> 
>   nested_vmx_evmptr12(vmx) != EVMPTR_INVALID
> 
> comparisons exist for a reson: 'nested_vmx_is_evmptr12_valid()' also checks
> against 'EVMPTR_MAP_PENDING' and in these places this is undesireable. It
> is possible to e.g. introduce 'nested_vmx_is_evmptr12_invalid()' and turn
> these sites into
> 
>   !nested_vmx_is_evmptr12_invalid(vmx)
> 
> eliminating the need for 'nested_vmx_evmptr12()' but this seems to create
> even more confusion.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/hyperv.h | 10 +++++++++
>  arch/x86/kvm/vmx/nested.c | 44 +++++++++++++++++++--------------------
>  arch/x86/kvm/vmx/nested.h |  2 +-
>  3 files changed, 33 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
> index 933ef6cad5e6..ba1a95ea72b7 100644
> --- a/arch/x86/kvm/vmx/hyperv.h
> +++ b/arch/x86/kvm/vmx/hyperv.h
> @@ -4,6 +4,7 @@
>  
>  #include <linux/kvm_host.h>
>  #include "vmcs12.h"
> +#include "vmx.h"
>  
>  #define EVMPTR_INVALID (-1ULL)
>  #define EVMPTR_MAP_PENDING (-2ULL)
> @@ -20,7 +21,14 @@ enum nested_evmptrld_status {
>  	EVMPTRLD_ERROR,
>  };
>  
> +struct vcpu_vmx;

This forward declaration should be unnecessary as it's defined by vmx.h, which
is included above.  

