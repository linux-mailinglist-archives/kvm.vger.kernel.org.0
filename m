Return-Path: <kvm+bounces-41038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D0F86A60E42
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 11:09:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B30D5189ED35
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 10:09:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C283C225D6;
	Fri, 14 Mar 2025 10:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="UlsunLp0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF15C1F1927
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741946982; cv=none; b=uDk9NV9qyk5oGPdp/ieiAbS0LrYh5H/Eg3QKCbzjhvm5lw223WJWokVusyzKqeLKpha1geNVDvZCvtk/orQ25CGZ5x1TlV2sSabLFayfCGlawAwVSFNvO2pP1bBqvjEU5OGvL4GVIHs/57l9I1OnDaxH+jygHswRvGXPjWtKHpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741946982; c=relaxed/simple;
	bh=YKg9ptTco1sw1YHd5yOiK+gjHBlOZ6NH3FYdSSj1NHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rW2yJPU5kctqNa8eWAmPr2gPQLYsFHrS6wNVEfH2P3lvx3wTqoHzYgLKBoIoR4RiLBCoruxiDs4pY+m+OoHVa9Tf9zfBzjFZwJnBB5dDL1wBxF7mXK/i5HP/W39G+ay0rDxCF+dgAzv2fvdAe+FyReTgrQNLYum94t4iMApvvSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=UlsunLp0; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3914bc3e01aso1222858f8f.2
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 03:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1741946979; x=1742551779; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rHvQM0hWNFzQwTnnid4W2JR0bXSJztqu82kqIMQGNho=;
        b=UlsunLp0SzVlIddu1as0T8tGuXj+BJlC910qYnMbjFb+njwkjnUBZl3w/G0nnNRXnq
         QJIpYnBpbdWjJeFeM5XFeNuU9ud+6FjhinMwAES+/ZHj9b5GRHfdQkwmYYmHaiVGvHsk
         zOvNHvtwHrXavipkOWnS8Ql8VmWyMF4QUM1DJSUDEBONyFPdCofbXGI65im9uxbXjtdi
         2bMBizKC3krVNrPz1DHjZQ6Z4pSFkpZ3jsA6qKeD9Tcp/ODujT8SLNqIMVMckTCbYlkQ
         IB2KxZIyuFdlMDk9XSoVe2YvHfexj5edzrXqDr9Qb7UeNwtRAcTDzLpqd1DKqtxpROHA
         vHqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741946979; x=1742551779;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rHvQM0hWNFzQwTnnid4W2JR0bXSJztqu82kqIMQGNho=;
        b=HKQCWShLObPqV8bfTbU+vN/F7Y3sPJZIn72ng0POG7Wt8e81Ss7X+dSIJfJMf2Xq+b
         zjCuXCo8ORstCqFiac3+YrFEOUyQl6eeeMwsfRfhu6MBhKlEE51Enk2pasJcUG1T31ui
         fbcICVrCqCKWUe95bbWk3sV5pI5taazzXplJppipD3fDr6zSBcVWHqgq/4GUhPCF+Pc1
         kZUoAcdViUe+JSEe67SzdzRsMkvKfJkzw6+RZ3wXOBk63Kus26CadNj8OxKw0RFD+kXi
         rIbB9mi3m9HvAtuthJo2fBWXYUunMvh8B22nT+WMMtR4BkroAHDT+ZydUd9A9RgJJ+zc
         g2gg==
X-Gm-Message-State: AOJu0Yxs4ifj+X0DbmbJSStZXf5SLTuJRBY4za/X5oxS69T8SzOlzFNN
	ul7fadDRi5SSCGwXN5GzGge4lWq+TXG5yfKCg8L967oxNl6gnCSF/3TTrc2mH44=
X-Gm-Gg: ASbGncv7rZkeiQrqXPRIY1Opfp/2K0IcIkRPzbnk9s5OXsbjRtrAvPTx1WjFhwM8liD
	PgxmGgp/n3Sh1/FerUDxb4dU4zITpuKn19CQTAnzvNLPfVQGGpkSPi1Ax+Oq4Xho/dDZBFwN0Kn
	NDEFoSnr4L93LTiTdCtO89bOc2WtoTelkDsyuMy3UCD8S0jagmufxbgzHHcC+aHJQlkadhud3QY
	Lp3QLOuqtuLEvn7xBgx7jBdXEUhn6GkMHLu6cnHhKF+uqSGiuk4xrGhbZxkaQxJg8CmAbtcPnXf
	zAyQCObv+SWoL+kf32mzYEm/cZGMkn4T
X-Google-Smtp-Source: AGHT+IGkqV7WhiiGQeYcWXpDhWoriw3YE3T0bLfWDTH81lluu82OdgpWnVLXxH1IZF9JIpyRO6KI9Q==
X-Received: by 2002:a05:6000:2ad:b0:391:3aab:a7d0 with SMTP id ffacd0b85a97d-3971d8fc84bmr2759198f8f.19.1741946979038;
        Fri, 14 Mar 2025 03:09:39 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::59a5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c83b7656sm4945455f8f.40.2025.03.14.03.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 03:09:38 -0700 (PDT)
Date: Fri, 14 Mar 2025 11:09:37 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Anup Patel <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v8 6/6] riscv: sbi: Add SSE extension tests
Message-ID: <20250314-427187c2f57975472e8082e0@orel>
References: <20250307161549.1873770-1-cleger@rivosinc.com>
 <20250307161549.1873770-7-cleger@rivosinc.com>
 <20250312-fa9b1889ef5f422be2e20cf4@orel>
 <ba21e0e0-d262-41f1-a71b-b7de31cbbbce@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ba21e0e0-d262-41f1-a71b-b7de31cbbbce@rivosinc.com>

On Fri, Mar 14, 2025 at 10:29:04AM +0100, Clément Léger wrote:
> 
> 
> On 12/03/2025 18:51, Andrew Jones wrote:
...
> >> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid flags bit 0x%lx value error",
> >> +			    flags);
> >> +
> > 
> > no need to wrap
> 
> That's actually > 100 columns if unwrap.

True, even more than just 1 or 2 chars, so we can leave it wrapped. But,
I'd still merge it sticking it out too :-)

Thanks,
drew

