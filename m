Return-Path: <kvm+bounces-33420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E770B9EB275
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 15:00:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06D6E16CE4B
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 13:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577791AAA2D;
	Tue, 10 Dec 2024 13:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Okfmp4cu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE8A1AA7B7
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 13:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733839117; cv=none; b=T7caXRoMRvL0w2NyKC602ycPob2C7vFevoIhSdtCT0R2wEj6UJO4+UWj1+2jm8xvPhbK7Xaoznks7YqgTxhXSnP6RzdTEz8wSg2cqy7tE77KRYlwPPaYCowXM4x/N+zFOL/ifs3TmYg2Yry3hX3xLbfK/SZAgNPNHW1wGLERYEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733839117; c=relaxed/simple;
	bh=DHJ34O6tA4LOOtYgFN02Ltn/bPdHyRs8ir8PIQH+FNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oFpAkkTEbhWB2YUP3w7Sw4kakHtfWyw35VoxWlXs+54+9bSg4v4RFDaPAxR0UHl/rJCN/VWERxL+48XWqz4IiLYxK/AutXG140/IJ4KmmYhRXNQwvb5BEoGEhgkh+CcD7Te2vitEGDkkRN4Oc3bRYjCT30lmqqFIqPIgou57QA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Okfmp4cu; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6d8f544d227so21804386d6.1
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 05:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1733839115; x=1734443915; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Op5k9cIfee8mTNZ6ww1D/cCgU9OjLDVfUohPno+zGRQ=;
        b=Okfmp4cu6JzR3dSeF8L2Tvrg+Lqk0R9X1I5Bu73W3jzN7o16pteLTOniSoNObeE4O7
         V8wP6QBpadNTu6f7KV/IdEingHmPcY6zqb9ysKWuWO3tlPrXnOKkIsP8ogW8Q2xMVMkr
         azELBTPkh9VG8v2pm7Dc9SLaSvKRfEEeEA8lLPQ6QVdF442OflW0ERhkQzHpyFzdbfD/
         sxDAo9d+MZGkBPMFsXIGVpXIiH622pyuNljkbWBYRi9ngCWUxpp7UVNZ4odwOw1tIg06
         ZlmfwqNG50bmvBWQpnTEwP/rk4FmiOxccV8Tkr067yPpMQIy4aMRLIb6JFuL0eVzY4Ml
         lRFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733839115; x=1734443915;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Op5k9cIfee8mTNZ6ww1D/cCgU9OjLDVfUohPno+zGRQ=;
        b=r6+8m+UeV0i/ID2Z2yY757zCAAun+wbEirQeWEq6BCQiT7KYJ559BKjQ0FXiY0MA8Z
         NPB/i48rEqPZ0wdqSzMkOG+SUVbnd+ud5fzsfMDh+3PeKXx0sL3dAcNK5QlfTE3+FC4C
         /8PD1+ZQOWgbhW9IdnXXP4Tx3YBJSWKMsR/NfcaNwJZrM+eo1ZSlWG5fkK0ciOvP/F+g
         D22+iRVam7ZLCW8TL5Xn4B0KE0uH89zRi4JK94I+OgbRuFHKUv3cp8onOXW5mx11UPVe
         EdiEofySajLLmbagw/lR1xaH8iMxcCJ2W2bUE5jNOHpnrSgNvEqjP6S43Sl7cQyGCi+X
         aUlA==
X-Forwarded-Encrypted: i=1; AJvYcCVI+ojk43prmcdTA3+Gm1AuzOlYt81fpaavtaRTG1zkm9JsEy5K0SKlwyC5ONMBbTztVAA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0PvFUEc4kwbBFedjsMH+lqr/G8Je38DJ+xxUe+t2UoEgq/XCn
	0xYNMaq/e7T9QkBoLD/jJ4WKgKNt/M2k0eSkpJrVcu5wL0PiEGWJboXQWQAeQuE=
X-Gm-Gg: ASbGnctMKo9PhtxZtoUzXKF3RNABH0Xu0ce9RJs1L1sT4zKFSfxxNvVoXKSJkiXVvPn
	3GF4QXJ/x8ysDeFuLc+uo7TQ9C2jTANj6CJsLWn3NFd4x/ZLla1qTO5TbnITujiur6k2aBshCcv
	BLPWUtoZYWmBSU6EZVo9CC6eNdKuaR0+HYR69bvK3juWoAXZpBneVkzC3JDzpWSEL1XhTePHHuE
	uojXFUGyAJ4+zrQcSmtNzB3vmcKKLyvu/oFPwf6C5daiSnzmUAdpoAnxi/qibcQKZDC/n2pPMg6
	iS1kGupVt8An/JQ1/QuChAhlPEc=
X-Google-Smtp-Source: AGHT+IHpTqT1S6WJM8vTz4ylyK7m6T8KA6cFAW4HJenV0Rc06med5VImzU02pIJH9bup4AGtd7z7pA==
X-Received: by 2002:a05:6214:27c6:b0:6d8:9f61:de81 with SMTP id 6a1803df08f44-6d8e7149116mr228338566d6.24.1733839114701;
        Tue, 10 Dec 2024 05:58:34 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d8da9fdeeasm60916456d6.78.2024.12.10.05.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 05:58:34 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tL0kz-0000000A2DO-2OIm;
	Tue, 10 Dec 2024 09:58:33 -0400
Date: Tue, 10 Dec 2024 09:58:33 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Ramesh Thomas <ramesh.thomas@intel.com>
Cc: alex.williamson@redhat.com, schnelle@linux.ibm.com,
	gbayer@linux.ibm.com, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, ankita@nvidia.com, yishaih@nvidia.com,
	pasic@linux.ibm.com, julianr@linux.ibm.com, bpsegal@us.ibm.com,
	kevin.tian@intel.com, cho@microsoft.com
Subject: Re: [PATCH v3 2/2] vfio/pci: Remove #ifdef iowrite64 and #ifdef
 ioread64
Message-ID: <20241210135833.GF1888283@ziepe.ca>
References: <20241210131938.303500-1-ramesh.thomas@intel.com>
 <20241210131938.303500-3-ramesh.thomas@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241210131938.303500-3-ramesh.thomas@intel.com>

On Tue, Dec 10, 2024 at 05:19:38AM -0800, Ramesh Thomas wrote:
> Remove the #ifdef iowrite64 and #ifdef ioread64 checks around calls to
> 64 bit IO access. Since default implementations have been enabled, the
> checks are not required.
> 
> Signed-off-by: Ramesh Thomas <ramesh.thomas@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_rdwr.c | 12 ------------
>  1 file changed, 12 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

