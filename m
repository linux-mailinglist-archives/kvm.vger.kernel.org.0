Return-Path: <kvm+bounces-44316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E51CA9C9A2
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 14:56:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 764CE7B8D3E
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 12:55:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A14C251783;
	Fri, 25 Apr 2025 12:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="RuzOCjuB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED6924EF8B
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 12:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745585804; cv=none; b=l3NSfsjeyZS6b3OFyK75A7QBIDOpkbMnPEM+F4eeuMnvT5kQ1vPoyyLAEaMHGLcRz3SpLzjji7BT/gYEeBHkhgYl+mQayuEYtx/2uRoMdHYGeEE9FvpJdTT3bfG/S+Yoa8WewI6kDofebnKq9nKE5VCqXUWkteSp96FIsDbW/bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745585804; c=relaxed/simple;
	bh=B9XUlnCct8tc/29FDG3VFh/1rTnHbWfKF94pbOeTBio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GW5UnRoEsUOI7ajthFIiHB4hNNkFGlXmKqVJDD45yLaEnLFWtjkMbCZw7v1ChA+3wfsxrTtikMIcBNoBrhA2qoTBQnD415hMRNMpV9P+MWDXdxosWQCOFjoel4Y3pb96P3ps+ygrgN9lqY6wvhwIHYdHUwYNiFJrUqpqtUmtTnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=RuzOCjuB; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43cf05f0c3eso14859285e9.0
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 05:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745585801; x=1746190601; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jnvk1TG+dC2zLHnzaIEEd7gpPfBIDKi94FxYK6yvPdY=;
        b=RuzOCjuBbx4ES1urHWJHwvUofERtoDHLxYAk3SKi7t0gpB4NNOWhUqxXtzdDc9WCOp
         bWRCJr4IxO86ibONXnw7HwbG2wiRiz/EflpxSyVFesd/i4rSG7MRKFtMaABOpwnu94f1
         VW70nFGpqI4bm8bvnNNDWnvGobDJdkD9g8zFZ6Wp8U7WCT4CnHwVCGy9tC9HIY1HrfTl
         XNw4WTmmqZZVRuCfypClCNMm7HpZcYhhYtMjnzDLIKcNqRHsa/DYyRauKRzDy6z5MAqb
         Rb5qShfhVMjpYiXwPkUQH0ySirO6QpmWDJwxZewn2xPVDsHyEYzjsT1WztFPgMMGK+Rn
         EJig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745585801; x=1746190601;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jnvk1TG+dC2zLHnzaIEEd7gpPfBIDKi94FxYK6yvPdY=;
        b=sgFPLlOWz5naxK20NYWCAvuj/pUDTcqx38wyHXuK68OA+Uw3VoJ6E2VKILCFu6xoXx
         p7obaSLhHUZ72fhRIKlN9PJHVC7Z/kAIiBi3PEHvNq0Iu7VwalQ4++GJh6FNmpSPRjni
         9+00Ddl3A0Qpx9aDYAtjGLgcD2dK8OLAK32c0UBsVYAP/75efkJnIbUWDqMgAz0FNsXj
         uqHJC+GlDSVHibwI2X58y3FnJX9556Pj1/cUUHu0FiuvTTTwu2g3X3rWaY9Yj+8lBh3X
         VVsoBSyHc+NX/o0u6EcYPFfaMV/VjjBxXEeXmNhFFi9rdBBpX+heNZ+C3kFvWtEexr46
         wO1A==
X-Forwarded-Encrypted: i=1; AJvYcCWHTp6VbdhRSaQmIEcOzllq/jSdC09CMqd+AgGz2Q7s1nL+8jFtFGbMj30xzYtQJUa8z0g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi+S9WmdpuLZSxaULMjng203jH265E2PrSsOWTT7546/U11NXj
	mkvq9w156c2DkEXUSDJVld7kr13zcSfqHyE9aMHSIYYmPQ4mYlkSEEazXeVmc2M=
X-Gm-Gg: ASbGncuwwK/xG+/iZnDaZvJOMRm4Cg0KWQuzmJWDMHXsXHjH3w6bTRMQQMjMFjMwUV6
	cYyKbxEX2pdYWrFKpQhp7FJ8Wl2zJWhEIs0cg2GuIjJAEOauhke57Mv62/6KC/PXTz+0NmafmdE
	oa4bLdRQdLPVl+qu9fnpRhg+gZCrErz6StuLsPlB4FpGvHvmVwWcY7Ep/mey7hNXbtymwrTQgRq
	s9/mix+8kY8WKeWCR2o0JFGzQrfEfn9NUeXHXUC4c6AAMCtka/nmVpPb4VELgczM1972VNjL6qX
	3RLDRFmEKXHpnvFVGR5f8+XTrZrKfBMpggKsJNw=
X-Google-Smtp-Source: AGHT+IFmUXNw7ABwk1AMQuio7wlOtcBFgvt+8iHk6nXh+9b35mkhblHJxA2ykHiHusAsYgEzWN0GCQ==
X-Received: by 2002:a05:600c:1c1a:b0:43c:fd72:f028 with SMTP id 5b1f17b1804b1-440a66aca3fmr17281115e9.29.1745585800956;
        Fri, 25 Apr 2025 05:56:40 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d2aab65sm55907865e9.17.2025.04.25.05.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 05:56:39 -0700 (PDT)
Date: Fri, 25 Apr 2025 14:56:39 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Mayuresh Chitale <mchitale@ventanamicro.com>
Subject: Re: [PATCH 1/5] KVM: RISC-V: refactor vector state reset
Message-ID: <20250425-657823a94b7228b742cbe122@orel>
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-4-rkrcmar@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250403112522.1566629-4-rkrcmar@ventanamicro.com>

On Thu, Apr 03, 2025 at 01:25:20PM +0200, Radim Krčmář wrote:
> Do not depend on the reset structures.
> 
> vector.datap is a kernel memory pointer that needs to be preserved as it
> is not a part of the guest vector data.
> 
> Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_vector.h |  6 ++----
>  arch/riscv/kvm/vcpu.c                    |  5 ++++-
>  arch/riscv/kvm/vcpu_vector.c             | 13 +++++++------
>  3 files changed, 13 insertions(+), 11 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

