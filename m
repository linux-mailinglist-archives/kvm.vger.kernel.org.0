Return-Path: <kvm+bounces-51765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BF6DAFCCE9
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 16:03:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8929B48171E
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 14:03:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBECA2DEA86;
	Tue,  8 Jul 2025 14:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V8s3JA9Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC3B2DECB3
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 14:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751983407; cv=none; b=tl4ix6XDXXsTA8MQpO4Q64kZ5jlVYrfT4aGi0ECfx3dG6JALrxcCE2oJxmnBcs7E1l0Hg6/Lt5do4pfkqqLNIMk6fcvWDWpUYiXHFDhgkwrLIAK3xNZTwv3/KfCnh/RIMt8EPpUNYVV1+i3g2BXnJWABdTLmsRrC8rmhTzclm0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751983407; c=relaxed/simple;
	bh=9mN3j5w/WhanXLJmPGv99RuH5uBAok/NIpeDA4C68WM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SxPoyhTB8DAgw1qtAGySBmAdT+yt/d0gHDL6OwiDgDV7RfH3TitTc8vdUxsirpRO6zMfwPy4AmB8NVikAymNF1P87DONb4ZGOt5ikcoAwC1JmOCCfI42yWfL3oQYDALi7Bmu8iVY0KREMu5igDwR9vMKKviUNSoyQ46HkbN4dME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V8s3JA9Q; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7489ac848f3so6660663b3a.1
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 07:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751983405; x=1752588205; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o4TP3MVwCYsQfm63LlH4AY1HFy9SyPnOqHfyHcIbkRw=;
        b=V8s3JA9QTYFKMzELGuDsjLQTND4ZVkh5mFel6t6dMNwCRHZKL3MMCLB+OzFQ8n7OfP
         zrgaVEWAyG8RdZY3FL1uppEIldLiadtTRIV58LtWjb3ZP8vgCTvy2CeM0WxhJWq1qdLA
         Peiq/Q1rTE6en3oH54qqG70OgtQYG9weC9Wn2zcTg44IKNEumNB89Ig5/zvRkURpVX2g
         fWvlxRcngvYF+KR6Ws9pwaI93E9tgn7uNVPtlavbjlD8qo/0jd30BRRyCWtgrwKz0eY+
         FZ4cf60waI7K2eeQJ4udZ6HQJ2RrqDG5QN9R1w7SXzOAsYCV+rZnZI8vf84R8BqmDQ9+
         iAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751983405; x=1752588205;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o4TP3MVwCYsQfm63LlH4AY1HFy9SyPnOqHfyHcIbkRw=;
        b=IIKb9+elTQny3Qh4pB5vJ9mcFi5n5v625f4omHJjF7xBkux0tN8TUkxXmjmt19O5f1
         Ny56LC/hLdgk00e/j7ZcMfgnxIzp6VBBBFSzvgprvahGoVn0n88JG1NJKWdqN04nFpRe
         MWlBvKbCjwqvB5ETvI89VI0brz4FmBGRXZmwDuyJ/7zP/3cul0ZZ22PmchIjZLNJf7VT
         cnUwG3xaO9dfAZCYusFM0wWzfl9YVInhiZX4Js7mmhaF3MDCquXSTeZvEfctYQVOlLRN
         Pf7l4ewTT1+Gja/PFR+bo71/XHOzKAw7l2P/g3wTTU+98I02CxMMLQ0/HTsRN4DeFPQn
         S6XA==
X-Forwarded-Encrypted: i=1; AJvYcCXm+OWT+0ViDyB60h4PGJiwdb5LUmPG72AtmwRmfxX7AqVXFvlq+ZjlJJ0V7wyuVwDSHZo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqBYahfOBMgsmlQmgCGw/Cj0U9eN0YUpvpKW+aIaidvBEff+qq
	9ZYouYPluu9q24cpzKvKGP4Va8GhJjX1AEllJQbks8uCgZoqFPidUKU4E0Cxl9mIP3vjfaDe+Pi
	9QZprJQ==
X-Google-Smtp-Source: AGHT+IHhf0HkxE+LtVIJ0wBjztLgVPk4SPAUyF3xH4hkIz8GrWIpjiNNDpNUIoTg8aYD8/s35/AvSLaSUEA=
X-Received: from pfbce13.prod.google.com ([2002:a05:6a00:2a0d:b0:746:1eb5:7f3e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3a20:b0:740:b5f9:287b
 with SMTP id d2e1a72fcca58-74ce8834008mr21999888b3a.1.1751983404793; Tue, 08
 Jul 2025 07:03:24 -0700 (PDT)
Date: Tue, 8 Jul 2025 07:03:23 -0700
In-Reply-To: <20250708080314.43081-3-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250708080314.43081-1-xiaoyao.li@intel.com> <20250708080314.43081-3-xiaoyao.li@intel.com>
Message-ID: <aG0lK5MiufiTCi9x@google.com>
Subject: Re: [PATCH 2/2] KVM: TDX: Remove redundant definitions of TDX_TD_ATTR_*
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, rick.p.edgecombe@intel.com, Kai Huang <kai.huang@intel.com>, 
	binbin.wu@linux.intel.com, yan.y.zhao@intel.com, reinette.chatre@intel.com, 
	isaku.yamahata@intel.com, adrian.hunter@intel.com, tony.lindgren@intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 08, 2025, Xiaoyao Li wrote:
> There are definitions of TD attributes bits inside asm/shared/tdx.h as
> TDX_ATTR_*.
> 
> Remove KVM's definitions and use the ones in asm/shared/tdx.h
> 
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/kvm/vmx/tdx.c      | 4 ++--
>  arch/x86/kvm/vmx/tdx_arch.h | 6 ------
>  2 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index c539c2e6109f..efb7d589b672 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -62,7 +62,7 @@ void tdh_vp_wr_failed(struct vcpu_tdx *tdx, char *uclass, char *op, u32 field,
>  	pr_err("TDH_VP_WR[%s.0x%x]%s0x%llx failed: 0x%llx\n", uclass, field, op, val, err);
>  }
>  
> -#define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
> +#define KVM_SUPPORTED_TD_ATTRS (TDX_ATTR_SEPT_VE_DISABLE)

Would it make sense to rename KVM_SUPPORTED_TD_ATTRS to KVM_SUPPORTED_TDX_ATTRS?
The names from common code lack the TD qualifier, and I think it'd be helpful for
readers to have have TDX in the name (even though I agree "TD" is more precise).

