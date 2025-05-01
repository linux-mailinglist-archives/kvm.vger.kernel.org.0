Return-Path: <kvm+bounces-45176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7C2FAA650F
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 23:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B2333AC421
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 21:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAE5C2609E3;
	Thu,  1 May 2025 21:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a1+VL7nK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B5F22541F
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 21:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746133430; cv=none; b=XyEsymrtVTegv+8hPIK0pJA4/Y825FQc5zpmvbvntU+XT2wn9ELzV8Xaqk7kjK+tbWflmzuVSOxA/Uh1OAwVXpxUdiNcOaNbFiE6c1Zg93ZvMpcp8lpHm/RTOXgDcB59ff51oQGH0mEunuv8XLyepn+v/Big9E9meadxZegaTj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746133430; c=relaxed/simple;
	bh=KnH5VvYqnintjP9wB50Y6q1JFqTDQJjI2skX7DvCHiQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rRVPalPEW8BSYb29ZWMjPU6c5K3oiYRhKrD/Dnz6vhK2ZtLKtAtFzXgcHyo7pfx4z1KXgnIK1Uf9DxwK4aaFzlorHswH7pOnTJhC4E1HLgB3bdF4Kbt/apjB+xS41w2LyKeDZGbupTWb/YWS8f3QyPk0hM4Obe9fyjR2xtTGvVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a1+VL7nK; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff798e8c90so1395640a91.1
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 14:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746133429; x=1746738229; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K3LgD3RsHy0idAPG24WJvE7joJXrg8YFB/6s4D5IWPE=;
        b=a1+VL7nKTIDGRLqpMUrkQqEUIizoIS42HzdIlhu6kpmzsniVO26XAXscjuM7UaAQDu
         w5vuP9LFZUo28NB5dGm2CGt+ifO6qjAJTPWDeO6S8iEuIa8VgsyY19XYR0zw7G/TxhMX
         Vl4rB+k2AKwYE1OUo5sumxQus1dbNsOX7Dp7AH1ZL+seaTKhlFA73R10LWCGr76UOtO3
         n4OmGTRo6gDXlaoCWCDESouRfXD+w4MNv0YH35NIITK34BWMzKMkOmY1ojo0A62FH/iI
         saWXGuNLqnmzTFG069yygxaZu2RcOj1iE00J2i8swCtFdP9eYA2cpUeUGqlgSTmB9xQn
         amOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746133429; x=1746738229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K3LgD3RsHy0idAPG24WJvE7joJXrg8YFB/6s4D5IWPE=;
        b=HtQK37aNB8pG/3TzmFfAcsw4wPociQjEWT7fzK8p/ij80cZ4q4ckWT+90n1Y8YEvdq
         jp0Xpg6URVhJqIqlnN7MmxWvC9FZgidCp4OZV6t/ltKm55b6xjz48cZFP+uVDN+vCaRv
         C2d1sJsOL+lb1XlgMHEwhlcP4WNRrCOGUCd14WcOjr94pEzDaVpIfM4Rwg0FAwxympQW
         h610igBAnoSN9GV/GY5BkuVIbUlowFNSJE5jyY9Hp6h0OICtT9dMF16u34P0s3RbeYHD
         XncetB7vn1metK5WqQLKAIuaZwiKK0WcoslGTGkNI/OeHLE1rRFwTjH0aXTYPRggoCjt
         pgQg==
X-Forwarded-Encrypted: i=1; AJvYcCV4BpBqw2XxXJfeNtkcp+4migUMSl/nWMEep5lAdRvCOkW4XIIGiekmmN+LeEHuWSSyi9o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDCscT3uFi1fxB6EdHT/IXoR4HYDREgzVEnx1my1fiqIXQOfww
	/uNYvX95wIKH7K26lqQRvb20y28pJogj3HzutXipQ/tJVi6YYE1nb54uzdBgZKsSb8v61YY83jp
	VKA==
X-Google-Smtp-Source: AGHT+IFsKbxWNYniktZ+08WA6b0CsvxaU/dos+kZKMRCn6iD7Ks6A9wZ87nfSSI8jfHEMe/wZJjzetRtCUk=
X-Received: from pjbnw14.prod.google.com ([2002:a17:90b:254e:b0:2ef:7af4:5e8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4fc2:b0:2ff:4f04:4266
 with SMTP id 98e67ed59e1d1-30a4e6949aemr658697a91.23.1746133428792; Thu, 01
 May 2025 14:03:48 -0700 (PDT)
Date: Thu, 1 May 2025 14:03:47 -0700
In-Reply-To: <20250501183304.2433192-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com>
Message-ID: <aBPhs39MJz-rt_Ob@google.com>
Subject: Re: [PATCH 00/10] KVM: selftests: Convert to kernel-style types
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Eric Auger <eric.auger@redhat.com>, 
	James Houghton <jthoughton@google.com>, Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"

On Thu, May 01, 2025, David Matlack wrote:
> This series renames types across all KVM selftests to more align with
> types used in the kernel:
> 
>   vm_vaddr_t -> gva_t
>   vm_paddr_t -> gpa_t

10000% on these.

>   uint64_t -> u64
>   uint32_t -> u32
>   uint16_t -> u16
>   uint8_t  -> u8
> 
>   int64_t -> s64
>   int32_t -> s32
>   int16_t -> s16
>   int8_t  -> s8

I'm definitely in favor of these renames.  I thought I was the only one that
tripped over the uintNN_t stuff; at this point, I've probably lost hours of my
life trying to type those things out.

