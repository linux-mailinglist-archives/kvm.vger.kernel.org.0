Return-Path: <kvm+bounces-10537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6784786D20B
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 19:23:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08175B25399
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 18:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14DF67A15C;
	Thu, 29 Feb 2024 18:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NHD3BP2H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80F57A124
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 18:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709230972; cv=none; b=uM3niZx19cqO0GdlKG63q4LGlwH1oLxMZ1U21sP1P/gqOpzfXStJakHtfRIRhENq5Y/smnS5JemZrhfSHJo2Nj7R0vgn5pyQCzg9qvnxwT0gC1j1dW64C9JqkqeOMohXs3LzelC4ASxPsSOsnjwraFA0Ba7SgYYpNm9bJ0o0PQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709230972; c=relaxed/simple;
	bh=g80ZHMfkap5e1XvdbqJdFJDCZAoVlfr93qwV4iryYMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hvd9l6uQrshPm0SKZl5mKyKqhKclerhKbVVyg2cm48SwPDLHLMYx2KT77VHOqGBhnsbeQyZeZGDU5GlbefOROy+Zv4PgZFIEeW08qbbyF9yEVfPMmc9vtkftLutzkRyJk+OKDvM1kDYEM4TJeoysD6oJHTR5CynhE99xJbup6Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=NHD3BP2H; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5e152c757a5so867628a12.2
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 10:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709230969; x=1709835769; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SME3hkkQyGOJtg72h1VtA8SKZ4fgYrx6Seh5LXcBQ8Y=;
        b=NHD3BP2HmpZYqK4Q5E35+nXruIJPzrSQyLpUi4XNguSxfkVoOmJsSl1BEQf0TBLCX+
         TbH3MdWSFEWkq8D4u25f0Ljh7+ycO3DD5CTc93Sl6RUuc75jXzLNdXE7iaE+9Q+v8pJY
         7CyO4t8HdmhowkEtiYNEp54rP4rGvMHgdcpS4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709230969; x=1709835769;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SME3hkkQyGOJtg72h1VtA8SKZ4fgYrx6Seh5LXcBQ8Y=;
        b=szhNsTkABVdeIKct2/jWtwJcVB5nPNgChVYkBsrMoXDddgwwTGxk7nwmsRbx0D54hu
         JwV2k34kh0+Lpmax3V7hF/Dk4/ZPbpuYgpcIYkJ2crnaIvzTC/rhysbsG3TCpnpBn1Jz
         wtgcKCAZJSAVwrYIOVB2m+kWEPfUeJCsLp04M37qhEfmKpUb9zGGVyBKFa0D9+uXeJQa
         vSfg/4JJlOlARCq0T47uN/H2AUYyfAU6zIjZx/gd3ZfK6siKrBXnCMAlIfWaGUII70Di
         UlwjvLuhCzop/HjN2pGOO/+H+9FWCVsYmOVI1o/ZEoo2f//qHEEVfyAWUKbyIjmMDUFj
         P4iw==
X-Forwarded-Encrypted: i=1; AJvYcCXgn7U58Xmso2MjiZpk43lh40/kBUtYpzbJUU1s1AnBv+We2fqE6NX9mJFsn8QjHTwQvZRo53mVoRxP3MtF0r8DLa15
X-Gm-Message-State: AOJu0YyoZnBx7V84o9/bi5hBz39NsEaBpt1sX09wPLL9AE3V4QKReOEc
	edOfv3e5kOmNioXLgx/C9ACaAe3nY66Px3xejg7anh6pBk4wrnlqdDDClGX9qg==
X-Google-Smtp-Source: AGHT+IGYdlTHCZzP2Rg0F0nElhv750jePTpguZzrPB+4WF7VZs5zNJs7UO3cl1UWFqPeurqTqikR6A==
X-Received: by 2002:a17:90a:4a02:b0:29a:f233:2882 with SMTP id e2-20020a17090a4a0200b0029af2332882mr2856150pjh.12.1709230969105;
        Thu, 29 Feb 2024 10:22:49 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id c88-20020a17090a496100b0029a7a2fbb25sm1930138pjh.57.2024.02.29.10.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 10:22:48 -0800 (PST)
Date: Thu, 29 Feb 2024 10:22:48 -0800
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Brendan Higgins <brendanhiggins@google.com>,
	David Gow <davidgow@google.com>, Rae Moar <rmoar@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Alan Maguire <alan.maguire@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Marco Pagani <marpagan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-um@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH v1 4/8] kunit: Fix timeout message
Message-ID: <202402291022.E3529BD@keescook>
References: <20240229170409.365386-1-mic@digikod.net>
 <20240229170409.365386-5-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240229170409.365386-5-mic@digikod.net>

On Thu, Feb 29, 2024 at 06:04:05PM +0100, Mickaël Salaün wrote:
> The exit code is always checked, so let's properly handle the -ETIMEDOUT
> error code.
> 
> Cc: Brendan Higgins <brendanhiggins@google.com>
> Cc: David Gow <davidgow@google.com>
> Cc: Rae Moar <rmoar@google.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Mickaël Salaün <mic@digikod.net>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

