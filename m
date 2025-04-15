Return-Path: <kvm+bounces-43360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 658FFA8A8D5
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 22:06:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C34583A9581
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 20:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F57C226534;
	Tue, 15 Apr 2025 20:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E80ppLH0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE1C19CD17
	for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 20:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744747604; cv=none; b=JG8/V1Hwm6XEIagq5tT3+z2QGlwUUvH5dOTQhIn7UOJ4PlQ2YmZpQrlDRf7dhJDR4My7WFMfgO/AsKC6p48yH/OjJS/cu7sT1jKlKX47etUJtpFoc2c1rGZ/RrnJqko2EoK7CQvu60vGdM2uOpim0Ue03gGT3GtFqAFsnmCI6fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744747604; c=relaxed/simple;
	bh=dgoGJIl+kDZZs+vuhPvPzFpoBbJLbWi7bg0+VMxJ7i8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ip5BXSj8yVw5W1ZCEH3bOPOJVEf2iezwsiy48o48p+CBKSr8oGV6rBbebtnfz+xhMgVsUTBIaj9bSUe6ZcPNmB7WA9XZw9qZDoNEA6JdU9CgY27nkipvQpi6YCyqRvZt1d6lUypdehx7hwlWDmh1mazRzT+FUjmRemmuQLp9uuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E80ppLH0; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2240aad70f2so64885ad.0
        for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 13:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744747602; x=1745352402; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D3HaMUmTHz0CCTDWNltKWF71+xXQyeA8j8iLjK2r2fA=;
        b=E80ppLH0iz0ldOXcEPzVnesbmYdv/BPwKPMUDm+tgi1qQba9KG7g0DY9DOkNb7Cjip
         FPKH8bmbo7vWp67QUseTLqUz0tYyGOBlt58y2PQ3roMItcor+QMbNhakZAgogt/uYJwd
         bMmWSvTMDhTVqu7p29iTZbEHj2y6gEl2aCSDu8nA9MI9DV+VydRyotFp5254FiolUOAs
         gYLZG/QLhti78ia39/LFR1tzemWarkMj+3BgyCH72TH3e2rD5pxaMJigtxOQ6W6KseM9
         +x9nMcs8F4s4c1sykPa2HnWsACOZu5lRThkBbRenq7cEERx+j/94l/L3xjUenkbmFcoz
         aiQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744747602; x=1745352402;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D3HaMUmTHz0CCTDWNltKWF71+xXQyeA8j8iLjK2r2fA=;
        b=QmmvRkNMnGL1UBY5YvscwYJ9h7CldflWcL/8ejkiaAWGo+HJiNV/JrUQISLFArNWay
         xqSdGqq/0c+mO+WyeSKlu3JODt1RcpHKoI5jpdOGaGOKlR/Edva+ZRvIqd+z7gyT1AYv
         4+wwOpGMtbtSjT2037/gylJHknGqgyxPaitoWiFi3Bh671Tn1S7fHTPRwLiuFFvoNcp8
         KhWMZ9nxL4M9OardZX4pBoswg7QyuImuYgTaHvBKAaJ6AMoCCdkf75fT/nqC0eOumM4w
         FO1rM0hZ6J3VIG3a5gKfZ95aVUC7b1NWkxoxkeysj3BC80Nyc6Btc53LKOaM/CCn5ioI
         TfDQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4FV+lgmNs+WxZ64rWpV8F1Ayk+Mezq4HVR4giU3y6KlCzRLDxjC6Iuw3f/nqFFPzfPi0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/aNOon26vtVZ/LlejWuJ0JHI7prSC8p5GAjcZEgV0LuRIqJOs
	1EqCIuvy19D4I6OiBL7tk4T906UOni+Rfm7+5a33JNm9PlD3+uq+mxvQCChHtg==
X-Gm-Gg: ASbGncvCxytg1+6qG33oxNFQxHrNL3nmIUSAY1M2bowCYJxRYGqXYBA/fgyxbaIq7Xz
	+C+uZbqtiG5z0lhuhjBGah3jRO2givaaaiy7rMlHwdtdttQerRq80rbrh/haR/p0ddGgCIboC+3
	k2sH1Z7ocU+oINJshw5hTqx1WOVnVnXG5DxybzdgedhVmnMz8i6ZKLTngpvK2OJa9lxfRSC4QCm
	r7JRpZfKVWoyDpesS0p5+qspB2SvUllpkPvWNPZScr6fnCtGh+5MkmiEdrQCEF58GrALM852BQg
	oQY5er003ihKtMv9wDfINmP1i4/z2Xrfsm9eTyYWGDUbQXpWC/Pzkahm1/OFsQCt15E2N1RFIMs
	1zQGF+W+zdzmn
X-Google-Smtp-Source: AGHT+IFDl2oce5DnOwllJhmUftKGTx0b849xp6MecE8YT2xG1nKWZIjIRct1geHzZgP+NzxFXOQN0Q==
X-Received: by 2002:a17:902:ef48:b0:215:7ced:9d67 with SMTP id d9443c01a7336-22c318a9ddemr627965ad.24.1744747601407;
        Tue, 15 Apr 2025 13:06:41 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22ac7ccb79esm121945215ad.243.2025.04.15.13.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 13:06:40 -0700 (PDT)
Date: Tue, 15 Apr 2025 13:06:35 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] KVM: x86/mmu: Defer allocation of shadow MMU's
 hashed page list
Message-ID: <20250415200635.GA210309.vipinsh@google.com>
References: <20250401155714.838398-1-seanjc@google.com>
 <20250401155714.838398-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250401155714.838398-4-seanjc@google.com>

On 2025-04-01 08:57:14, Sean Christopherson wrote:
> +static __ro_after_init HLIST_HEAD(empty_page_hash);
> +
> +static struct hlist_head *kvm_get_mmu_page_hash(struct kvm *kvm, gfn_t gfn)
> +{
> +	struct hlist_head *page_hash = READ_ONCE(kvm->arch.mmu_page_hash);
> +
> +	if (!page_hash)
> +		return &empty_page_hash;
> +
> +	return &page_hash[kvm_page_table_hashfn(gfn)];
> +}
> +
>  
> @@ -2357,6 +2368,7 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
>  	struct kvm_mmu_page *sp;
>  	bool created = false;
>  
> +	BUG_ON(!kvm->arch.mmu_page_hash);
>  	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];

Why do we need READ_ONCE() at kvm_get_mmu_page_hash() but not here? My
understanding is that it is in kvm_get_mmu_page_hash() to avoid compiler
doing any read tear. If yes, then the same condition is valid here,
isn't it?


