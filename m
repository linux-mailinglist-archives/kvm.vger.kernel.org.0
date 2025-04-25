Return-Path: <kvm+bounces-44318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA863A9C9B3
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 14:58:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37A9B9C00BB
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 12:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AA842512CD;
	Fri, 25 Apr 2025 12:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="CU0sm/jT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9536224C084
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 12:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745585928; cv=none; b=CGW+jDYujapFJ2A5FpD4xGaoFdxWTh0EgvgCiIJSGKknlCICRcNMhA0nRpsHxj8EPJuPDvt+VTH24CgnRewu2/SD1OLVgJyE+HqvxSjnb/dkNc0c/UcyONFQoSVrqxRWwoOA9xf7FdhY17T6/1AYYm8B4N+V3kFfppK48WcRLNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745585928; c=relaxed/simple;
	bh=SQaMsIpmceh9GBOkpwc7cGJxTk83W4BErBldzfCX5q0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RH3Wrcy9mxAtcLvNOzwr5RwyxL3CQEG1jA8F5pv7gzo2EcgvYiY2W65HuSv64MKSQKQRmpxgRqLHjHkHkN3wIh8DJ1hqowX8pSFSpS4OjMT+e3FUrrQuu8XN5IAk1rBI5a1hUhh+Rv68exxTq+iUavSJZ1FQ4Tn/4QOS1W7FadM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=CU0sm/jT; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cfebc343dso14888995e9.2
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 05:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745585925; x=1746190725; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h32MpWGnGgpxDT6AyOuIJQcbaczCBtPKdaZ9N2BrcSA=;
        b=CU0sm/jTELdeVxD8TqEGVIVHXGqQWyC5E9PIOa2Q2qjXy266rYWjz1jdCSZ0O5QJ/M
         LP3dNgzCi1NqLNjkxgguOigaEwIUaU/vmeekyUGrVTU0sjXDOcE+crVp9PYT8msnxt2W
         ip0yvKDGdbEAqqB/PtO38ZLWV9QB86Lo+PjGEbsesjPb7QvEsvz0+kWFW+9cYh/p2q76
         IQeXa5eym8MzIzG/O7aKjKTzB6vISDLXXBZk0LZk2PlrgWoAY1lhZKqzJ0PebK8dRnn8
         XYeNc4tyIick3/DHxcScxvXsVTGF53Sqe33KSWQYl/rxY5xWj6qVa7xAIJTx8TJt2nbY
         KCiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745585925; x=1746190725;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h32MpWGnGgpxDT6AyOuIJQcbaczCBtPKdaZ9N2BrcSA=;
        b=O8i5LI9HtYNHEI1YgFFfm+mPb1kDuVjTnFQ6HKe6fFJvKsAuwxGqg4g1aNeOS1EOrl
         IV7tfLNU31vrCkY8SHU2KiY7wC5o4puN8jrlBmXIBoCVn0XXkUaeCAu6LmXzC5e0LCEC
         1AyhkBf+Q1K9PqQOMtRYKdsnnaDvMvn4LT9yDYp3qTL6W0GrLbEcfsJYbmfbhPrBkY2M
         w1nkNntqndrd8elFUGIcZ7/giwTK0iL7138e0QVEm8EGJAxH1S+WCxDb7raPh9n05Rz5
         rxZtNAS9MV9LfUA+5Jod25wHXm65XURfzBJZSRkD684OfPu1x3d3K8VBUDmqgdLPg+NB
         ja4A==
X-Forwarded-Encrypted: i=1; AJvYcCU9U6Ml4TpkSFZ0E1r9aaShPcoDEKtHo0RCcauIqUbrCageOlKJTGLszqBgO5TVp20lBFY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7LK5R6EWwmAVg8TXgXKlmBEpCa6CgBRkWUTcuNlXPt7GdapqO
	f7vEF7mIwFSMD344eD4+R3bc0XOyGQdtWrYMQWZqjRgBwXXgDVnUTzuR8hprbaI=
X-Gm-Gg: ASbGncumHtuKghgxm/DfrpROax/zF2O+/iG3ijrWG3zMxqnHx8WfObLalm2TW2rg6Lb
	kNBTZMy2kr24RZPiW4pM3CyYf+jGRgr9GETeEtH/pl7+GFWQAJeoCp59GCNUKKCpc4FWfyrqF9G
	hj55iaPrH72utIRDHzek6c6cujmxJMktg+SAbHbogOGcGvsy9R71l5NuC1q2Euy1C9Wpj7dt5p0
	c9PNrMyBXSHHVNWSEDCubpZTXHpryWEQ+c4UgCgUEgvr5ewlOZ3YD/p/YtDqVPF9pZWQVxuxlTF
	I2l1RadFmjb9TBw7ZQUngGhuDY8f
X-Google-Smtp-Source: AGHT+IH1o3+pe6w45uhSEWnsxZ3kyB6TJbP2MLFTmjrjISo8GMvqrB42OloPKpF+TK2iDyjwzSvPYQ==
X-Received: by 2002:a05:600c:1e0b:b0:43c:f81d:34 with SMTP id 5b1f17b1804b1-440a65e2c51mr21114245e9.9.1745585924890;
        Fri, 25 Apr 2025 05:58:44 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-440a5369cc1sm23902615e9.32.2025.04.25.05.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 05:58:43 -0700 (PDT)
Date: Fri, 25 Apr 2025 14:58:42 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Mayuresh Chitale <mchitale@ventanamicro.com>
Subject: Re: [PATCH 2/5] KVM: RISC-V: refactor sbi reset request
Message-ID: <20250425-65f6d6913f9f621dbc8c4479@orel>
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-5-rkrcmar@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250403112522.1566629-5-rkrcmar@ventanamicro.com>

On Thu, Apr 03, 2025 at 01:25:21PM +0200, Radim Krčmář wrote:
> The same code is used twice and SBI reset sets only two variables.
> 
> Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  2 ++
>  arch/riscv/kvm/vcpu_sbi.c             | 12 ++++++++++++
>  arch/riscv/kvm/vcpu_sbi_hsm.c         | 13 +------------
>  arch/riscv/kvm/vcpu_sbi_system.c      | 10 +---------
>  4 files changed, 16 insertions(+), 21 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

