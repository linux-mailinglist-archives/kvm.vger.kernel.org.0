Return-Path: <kvm+bounces-61591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 33175C22721
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 22:42:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F28EE1889748
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 21:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8159329E63;
	Thu, 30 Oct 2025 21:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jkBrdBPj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EDD314D24
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 21:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761860490; cv=none; b=rBh0BkebYX6+oA8pkItWMJOedCeim7tliYzp0Ep3NTcpxooeNhIKmEL6uGmexLJCPx16cXRfwSZCCThGbs0f0iltUcXj/JS8gLOYrwOBy71NjBfBOWqNCSY/qF1XkLas2mdLc5jCY6qI/FqUlb5C+cYFlahkFoMMdYU7l7cRqE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761860490; c=relaxed/simple;
	bh=5AQCSF/N5fYZh1DKG8zQeN+QbCB3F/STERKQmGHnv+U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ckOrFBk+6m8PojmWp1nuqs4cU/AgvZCEjs0KWCBwEmFZh//vFZfebOaX7K5wv8SlK+PvruXN588segBc0E2IBxp7bKIPyMNievqz6bW5y367Kdhz1Jvrw6INY8Knz3wwcnUaQpohwo1B2BuBvNvxiy/ot3csbqdeBxvPwmDAlZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jkBrdBPj; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47112edf9f7so12806485e9.0
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 14:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761860487; x=1762465287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2XBvCSEn0ZeigCB7NPjyaiTdYT+8OHxru1xjOb5u250=;
        b=jkBrdBPjhFq4qnHNWQDqOoUR62ROVRh6gLbxo71ZpSnE4/Tj5++SnjHBSyHiC7o1IS
         44Sfc4pH34i0RrLOpyjrw0BMz3yCbWFIY7AWuEYKN7Y74zU+3UCcw38jKqMi/E05vxSS
         yI5MZ3kngDwAu/OL97fV/sHQqa5k+tagY/TJy2w+gykm7qFktbByFzLbdCUDAShXZjv9
         ig8fOdaE4eI11TOBaozVZyzlKrt+1Dp1VARSiROdsALCmz9lh0OpnUx1L4XR33+0/Rl7
         cje58JxoepufmmemzCZLrYZJAe8A4/sRJ6658DvMwqo7UDIjsQnFXx2/azvj/iF0epm3
         W6OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761860487; x=1762465287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2XBvCSEn0ZeigCB7NPjyaiTdYT+8OHxru1xjOb5u250=;
        b=QwS+fyaxFna/xAdGG942UG62BlETlkzlGVSQJ9fNNOtrtyUH9PNVBy53BP5x/2MgIO
         vi3PdUlyybZZ37l1S/hcXWQ6A7IVy+pdXHu1o8W1OWuu0TYKmNBICmftfviEj2FNRfjp
         SKdu/Nq9H+mlWdjb171mOpMCunZl/7ASbbt6OOVoD38dPZf96uVLWxnG7ok+QNqvnZPy
         lXh59jRwnrWiV9FJ4ke+rIhC+8brEmDFIZnt3bZsXx27YZVTfjdR8dwVjdbd8j4JBgm5
         ORr56D7ti6VmsEp/Gy+vTQqkaaJzjfOSA6whyo15KkOIxTGeY0JbuXr+ocy+Y9AgvzSd
         yTlw==
X-Forwarded-Encrypted: i=1; AJvYcCXNcZLLsdZSubIDbS4JkUH2Lzzvrn9G2MZrNrWYOrRq0GfDtpnd87q+M50c3y+ZYtc6Om4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGRU9sK5eR8QWs0o1xAIUhfty5SZgFVNZS17MeS0iUtxg+qqhU
	gotuuyl3bsAPNh1J47tUtq38VzB8dU7UlV8EZGtTHs5cdBscLSJG4Zps
X-Gm-Gg: ASbGncujo3LCqZQVTcpYqCFfUYKjrmtBdeQa+No7tMX8HV+B3lmqs053iENmlbtm8bX
	626phulCiUk4A01m7D+YtKItBsVIw5bH/xpJ3kAMCv3w4/yngKCqHVxnfvQcxpDzvnUqsTdgZAg
	FCUv4gyRM5Key5dRRyw158e1Z5erY9f0bWeH8aBkTlDlZ6JF5rFUUBqehj+9fbK6CTGOYgOt0QH
	KMmt8eFikQKuM5PjGIJGYne11f3Hd3RxsBqgh+9XuPXEnd1Uy7jpUJWWIaU5s6Fce0nyuWi2DXt
	j7nwcnCIEqXLN2lCj//IL3tRdeKMfuYyXxcAhp9uVLC4K0ETVJWDAPZg+xrofwZ88li6Xs+hcwL
	x2/pCofNuzh1HQ92HkRzGZLzBoisIF9pmHEjGDpZZInaQ+eNpkI4DK20cGz1hylqz/apaklkOlE
	1u4AOcPHYw12JXNcWWS9SkG8epURewrAQ90VU154YtAQ==
X-Google-Smtp-Source: AGHT+IF2+gC67dgVdnAW7HO5oobqLFRQy+U6kHEZPTDvGE8zU4sHMYcN9fuccg5Lwqg5j25NgQTe4w==
X-Received: by 2002:a05:600c:6215:b0:477:f1f:5c65 with SMTP id 5b1f17b1804b1-477308abf3dmr11142745e9.23.1761860486746;
        Thu, 30 Oct 2025 14:41:26 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952b79cbsm34210623f8f.4.2025.10.30.14.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 14:41:26 -0700 (PDT)
Date: Thu, 30 Oct 2025 21:41:25 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Alexander Graf
 <agraf@suse.de>, Christophe Leroy <christophe.leroy@csgroup.eu>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
 kernel-janitors@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Use pointer from memcpy() call for assignment
 in kvmppc_kvm_pv()
Message-ID: <20251030214125.33379ed2@pumpkin>
In-Reply-To: <ad42871b-22a6-4819-b5db-835e7044b3f1@web.de>
References: <ad42871b-22a6-4819-b5db-835e7044b3f1@web.de>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 30 Oct 2025 21:51:00 +0100
Markus Elfring <Markus.Elfring@web.de> wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 30 Oct 2025 21:43:20 +0100
> Subject: [PATCH] KVM: PPC: Use pointer from memcpy() call for assignment in kvmppc_kvm_pv()
> 
> A pointer was assigned to a variable. The same pointer was used for
> the destination parameter of a memcpy() call.
> This function is documented in the way that the same value is returned.
> Thus convert two separate statements into a direct variable assignment for
> the return value from a memory copy action.
> 
> The source code was transformed by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  arch/powerpc/kvm/powerpc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 2ba057171ebe..ae28447b3e04 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -216,8 +216,7 @@ int kvmppc_kvm_pv(struct kvm_vcpu *vcpu)
>  
>  			shared &= PAGE_MASK;
>  			shared |= vcpu->arch.magic_page_pa & 0xf000;
> -			new_shared = (void*)shared;
> -			memcpy(new_shared, old_shared, 0x1000);
> +			new_shared = memcpy(shared, old_shared, 0x1000);

Did you even try to compile this??

>  			vcpu->arch.shared = new_shared;
>  		}
>  #endif


