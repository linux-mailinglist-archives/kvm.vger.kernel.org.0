Return-Path: <kvm+bounces-49035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E166AD53EA
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 13:29:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8B9B17BF9E
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 11:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C39F82E610C;
	Wed, 11 Jun 2025 11:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="EAkVc/gy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEFF273D6A
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 11:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749641345; cv=none; b=r3a7jyHqxqLqmOcyyQQ+zneoxnAmUiCNL3d33C27Pgsktbo4Q5XoZV8FLm6FGqHf68wMgo6YqjmlwBKxhjo5vheUb3xGoX/TuIE8OY+y627zUvj0WmfzY+hxhw4Pr+Gbwpkek7vef699qsjyGsJ2quDWtIY63GTbEhDvMzxJ0qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749641345; c=relaxed/simple;
	bh=1JqugHdq4Phks00PXJ0yxUsUoqF+17XSnAexnueU1vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8ku8QOrIuj3wiT70P2yzbBNs/7Y6HOSXKSRTgyw4bRu9f4R/z6cQ/5mfPdNnuOQZb38TfA9lbrpfLKHbe1QMW+WuFhOlmgZ6dDFlSRb6T7z8Kjp1+swvfL4XlNl4gbwrbEa5VrGD8PKSeBbIy6o4d7Pjfg22s4KjTJ77SNpvyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=EAkVc/gy; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3a4f71831abso6050289f8f.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 04:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749641342; x=1750246142; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a5eBwBbTQUmE/jg9qxOQzcw7gsljfjr3T8EkpVA+lR8=;
        b=EAkVc/gy8iN+P3mKkRQwpT9Cn1+kDc1FbLb8ZCblYb5glJRLclg/hfyYmWyrNEVRJo
         RDUsCaTOWI+7IXpDB29p0IM5HK7f9wNkA1Lr/N5PkLQOyTdiIAmAAsBE049dUm8PxKCh
         kPJWrJU8UgS3J346xmA2o11VwG2seV8mA27vC77iNBKWzJnaugFRvnvXOwYahkkxkt05
         i7YlY/vIlhzNDbB/nnd2HrhBlrWjeYclamjBh5r/mWFM0ldV94jr8OMrEKDyMBTWQ06x
         CMg1bRvfUUfxEokBXJN1qqmcwc6JPl0RfSMddCMtJ1lE85OpinO8Qy+q3AQ3knyqY5j2
         /Fpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749641342; x=1750246142;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a5eBwBbTQUmE/jg9qxOQzcw7gsljfjr3T8EkpVA+lR8=;
        b=Rh7Z9+JtMUZV8MJ7uIvJHJVo9e3Vo3jZ4GceuoZROoDEdHPa68ca57htNmiIVzph92
         yyIYf7qoFhDQ9Gnulu3y5KLAFbYonKnvHDg55R2xoMssQcMS4dT8O7P+X+WOqDwRd8Tm
         08lZrQ3FsjCun3okNoPT8KTm56t/uUHj3u8+HLDGeAcS5agoXNcA3r0ISpA3w4An5qs8
         U3/V0Fci/bDmTu7zhxEs7rSnQw2ZB30EP7CFq14PJIJOhkSuBy+acHJnm7EXAYZTPpFS
         avO5b8Lepy7s+D7u/Dy1vBfbPMZRb3dY00z/MrivBKKx4eNmu8lpYhI1+L9/GC5kWvRm
         SZZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpl1lISuCQWOIuzKK/Xo1zNjfILMt6lhgHfktqO4xniqd8rtqeUlUNptn4mnRMKFxc13E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFTHJO2UAwBx1G2Urm3d3wPt9MG2dVGOe/gwHEtU/gXz0CywQl
	o/0jHVtnnBteMeF2od+YBzOeJ0fBe0mCwhg0Rd4ZqO705SMTwJ2BiMoyvavpqnPua4DQwNalpDr
	mhBuxgUw=
X-Gm-Gg: ASbGncuPRYO0rESOpYmD6pZoOO5GiyF+6IdIhSxyjD7J6rqnvv3CQqr4bJatDnHHAdY
	qWdW2y0G2kWpN+RORQMlQhvEVWRFDv4qHJ2vBzidqU0cv1tfrcD9yOUTdz5Tz8j3Vv1oXlkx8U8
	VSfikuS/b3rRdbBDSHXJQuaVYPiFjDxeZuimJvoSOQniwZLGMUnCSQgnpySTuFvoOyn5UbPvslr
	jj/ePphi2A/bsYPYDE0CCj28JdMOxYC5JH+x7D1YJAbrahdJvEvXlBftGgINL/1J5D6jq0Jm9GR
	E8VjwHfGKuvfV6c91GK7w12qd0Ym85w+HM1gnjqbk1SuAiWlZg==
X-Google-Smtp-Source: AGHT+IGR2AIUE7a4nEZNX6K/UcpKOCr7ODBk7la16aB9kHn6bvTqIQ8QJX5Tm6kGkYsyX0BXvJw49w==
X-Received: by 2002:a5d:64e2:0:b0:3a0:b940:d479 with SMTP id ffacd0b85a97d-3a558af780fmr2434572f8f.53.1749641342318;
        Wed, 11 Jun 2025 04:29:02 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::5485])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a5323c08fasm14761939f8f.44.2025.06.11.04.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jun 2025 04:29:01 -0700 (PDT)
Date: Wed, 11 Jun 2025 13:29:01 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH] RISC-V: KVM: Avoid re-acquiring memslot in
 kvm_riscv_gstage_map()
Message-ID: <20250611-352bef23df9a4ec55fe5cb68@orel>
References: <50989f0a02790f9d7dc804c2ade6387c4e7fbdbc.1749634392.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50989f0a02790f9d7dc804c2ade6387c4e7fbdbc.1749634392.git.zhouquan@iscas.ac.cn>

On Wed, Jun 11, 2025 at 05:51:40PM +0800, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> The caller has already passed in the memslot, and there are
> two instances `{kvm_faultin_pfn/mark_page_dirty}` of retrieving
> the memslot again in `kvm_riscv_gstage_map`, we can replace them
> with `{__kvm_faultin_pfn/mark_page_dirty_in_slot}`.
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>  arch/riscv/kvm/mmu.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 1087ea74567b..f9059dac3ba3 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -648,7 +648,8 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>  		return -EFAULT;
>  	}
>  
> -	hfn = kvm_faultin_pfn(vcpu, gfn, is_write, &writable, &page);
> +	hfn = __kvm_faultin_pfn(memslot, gfn, is_write ? FOLL_WRITE : 0,
> +				&writable, &page);

I think introducing another function with the following diff would be
better than duplicating the is_write to foll translation.

Thanks,
drew

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 291d49b9bf05..6c80ad5c7e89 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1288,12 +1288,20 @@ kvm_pfn_t __kvm_faultin_pfn(const struct kvm_memory_slot *slot, gfn_t gfn,
                            unsigned int foll, bool *writable,
                            struct page **refcounted_page);

+static inline kvm_pfn_t kvm_faultin_pfn_in_slot(const struct kvm_memory_slot *slot,
+                                               gfn_t gfn,
+                                               unsigned int foll, bool *writable,
+                                               struct page **refcounted_page)
+{
+       return __kvm_faultin_pfn(slot, gfn, write ? FOLL_WRITE : 0, writable, refcounted_page);
+}
+
 static inline kvm_pfn_t kvm_faultin_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
                                        bool write, bool *writable,
                                        struct page **refcounted_page)
 {
-       return __kvm_faultin_pfn(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn,
-                                write ? FOLL_WRITE : 0, writable, refcounted_page);
+       return kvm_faultin_pfn_in_slot(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn,
+                                      write, writable, refcounted_page);
 }

>  	if (hfn == KVM_PFN_ERR_HWPOISON) {
>  		send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
>  				vma_pageshift, current);
> @@ -670,7 +671,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>  		goto out_unlock;
>  
>  	if (writable) {
> -		mark_page_dirty(kvm, gfn);
> +		mark_page_dirty_in_slot(kvm, memslot, gfn);
>  		ret = gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
>  				      vma_pagesize, false, true);
>  	} else {
> -- 
> 2.34.1
> 

