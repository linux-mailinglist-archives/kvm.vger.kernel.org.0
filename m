Return-Path: <kvm+bounces-10541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E31D86D22F
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 19:26:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13CC41F265F8
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 18:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F359E13441B;
	Thu, 29 Feb 2024 18:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GWtPP+Gs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B53A7D081
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 18:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709231168; cv=none; b=ZMw+VPjhbNYgInzFPZp1mm3QNuFJUfNCbccEztTtqdfdoeQWPx71Ud30QdLM/r5Uvq05m8KuBVcA7o/0aGVio2mZ0IZBlJqWCA5OxPcbM7d+zS33XmoCRMR34yX2CkRCQUc5gvHc+imtU0FkYqJ2JP/0hO9/Ka2dldP5iBTXlrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709231168; c=relaxed/simple;
	bh=GMRN6SUrrHoEIDYQZaXbYank+mE4jIYwZGljGX8JzRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kMawmzOFQrgdXKGWrDi0xyTn53OAPGDQcnCKwD4PQP/fxWdR5ESJMxJDmpGAfDQOkVeQr6NWvRheH75Tcmus69P5x/pFEAflAVsbUfPB4+R7Jj/YSBfpxgWppOPM6oIwfK7M/0lNrnBc2fDD9+rI52pYY45CvB2ZPWShn88cWN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=GWtPP+Gs; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1dcce5e84bcso11456815ad.1
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 10:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709231165; x=1709835965; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=onsMWwzpvtENple3SFlR2LMD09MQgc6sYAmAsDrNdvU=;
        b=GWtPP+Gsy8M3uLFQ3Bn8eCkaLfwMSCXbCoiwv7X9D6CXKax2kNaR0Yit3mNLBqIftB
         UBUbEj3tonKTijg/2l0GXZlW1Y1C5l4OuQ6c7+OlA8nofTANoAHX5RPdp3PVZcuzyOP8
         oK8vndSURR2ikGP6Tv+IZmb/ahraIVLlxtEwI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709231165; x=1709835965;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=onsMWwzpvtENple3SFlR2LMD09MQgc6sYAmAsDrNdvU=;
        b=L0rszM2apEEfQjzvtU5gv1R46gjW4uWQt8PESKl0BGr/2s0wS9gBtxqwzyRnR8KZgH
         xR2YNreUlTIg98AEwYQGeGU4NKtzv1PrXd4tUpUoHbudTEZiJZOIPyqD+1vH3fRzpCtj
         KNnHe66WA4jfUxbJCN+owPh27MfdCEMZLGMqlDcZL6Ph45lmoGyRWqpbeLMa3UCBgH1J
         ZXKA+zLjdmdbJQQk4Ez3cGer0imQRoNhmlrwgw3skePspokk/OxWvWl4GF9/3Dc7ieXk
         +KrB1EARhb3vSwGqoyqHtFxoUA8Nh/HB1o5hMKndc7M+YM3QDyCIspXIguj4En89Bleu
         aixw==
X-Forwarded-Encrypted: i=1; AJvYcCXRF9+83JHB93n6C41NL16CoTfLAALcgBYYV4ypPXuRYnpONB2RHvK/LRshZOxcSBQ/UCzg1pv3dfpKh+C4WtB7LoFB
X-Gm-Message-State: AOJu0YyW88zqz8WUl0HQ3L+SBWH45dR9w4RQk8fDw4Kxz2tQpB5JenFG
	+b+wony9b+4jUqLsee4CDZKByORy0CiGcgapvMIikGHZQasySFfYOabrvnGYqQ==
X-Google-Smtp-Source: AGHT+IFaOyXib1ZvD8HKP8qWNtoqD6PNUUwUwDcIGpR6CELmVt23qtsOEdbZ9mepYl+BYt4oLI9EwA==
X-Received: by 2002:a17:902:a3c7:b0:1db:c6ff:664a with SMTP id q7-20020a170902a3c700b001dbc6ff664amr2752373plb.53.1709231165470;
        Thu, 29 Feb 2024 10:26:05 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id o8-20020a170902d4c800b001da1fae8a73sm1821003plg.12.2024.02.29.10.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 10:26:05 -0800 (PST)
Date: Thu, 29 Feb 2024 10:26:04 -0800
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
Subject: Re: [PATCH v1 7/8] kunit: Print last test location on fault
Message-ID: <202402291025.0BAEBC1@keescook>
References: <20240229170409.365386-1-mic@digikod.net>
 <20240229170409.365386-8-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240229170409.365386-8-mic@digikod.net>

On Thu, Feb 29, 2024 at 06:04:08PM +0100, Mickaël Salaün wrote:
> This helps identify the location of test faults.
> 
> Cc: Brendan Higgins <brendanhiggins@google.com>
> Cc: David Gow <davidgow@google.com>
> Cc: Rae Moar <rmoar@google.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Mickaël Salaün <mic@digikod.net>

Much more detailed error!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

