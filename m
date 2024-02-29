Return-Path: <kvm+bounces-10540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B58786D222
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 19:25:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCBBD1C235A6
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 18:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83BCF134414;
	Thu, 29 Feb 2024 18:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ENGQZjPM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543D87A149
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 18:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709231099; cv=none; b=aqIMw+fW3fyiC9e/1yoKHs35NRwr6s1Jxyx3UMib4NlErRhRmRJf2Vs9NZIMy1UAbN+XFvN4HnOPMD4iD8ghY1uE9jMLT0ChMjAEaOV/XSBOe3gwTSCKIsLdmOAzAjn2HlaFeMOsctSDiKlA35Jt+4dHtx5bDLMqIue4oCBXI10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709231099; c=relaxed/simple;
	bh=Ce5pyQnb9GRcPSheUoJZhjpUrjGnCB77xYc5gcYNlxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YKaH9GSww5CUvFyCWJXo2D8oOtgvMvdL6jfzioIfYD6VaN5uoHqmI52lGbtENG5LM+n8eU50g2+7JTRBDylA//dbTrFJGEK3ULw6g/yYCD5eTDdFob0KxPcACwEeNbeHU2W3kFEiRfhpwYz4AXcyd9tkoyHjdvuQLjratBCHD4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ENGQZjPM; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e56787e691so1550870b3a.0
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 10:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709231098; x=1709835898; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vqInfZ8mOq8nYZAY0kAdxi4SUGFvyqMPNmMOUUeoyfg=;
        b=ENGQZjPMfEh2sAf36guydCaOXrhzFaPN4I3K5F3QN2g7nWsuX9IC1WQj2/cLxkTHdi
         Qo5DZpoRSvdZZ7OuoVu0wrLcKPFz6BMXzeCZhehz9AbQaFwUOvTLl5YX7GMzj4yrJXJZ
         N8m53e6FL/rmWDTyAqgK+cvAkxUMAA5y2bUUk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709231098; x=1709835898;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vqInfZ8mOq8nYZAY0kAdxi4SUGFvyqMPNmMOUUeoyfg=;
        b=W3As9b6m5l43abBGkmdGXLhHE40p3xH3LHK8Tp4Ga/etGzzxjLPkuTvFtPThl+fhfO
         n+EEIvZpvJLir73SSbQk7O8/XRFLgrlMCYoiaW23BWvI8JIsCwEasKIlCB90OqFQ8zc9
         U1GhHvlmPoQcWPJQQo5TOnZ7ZdAPUOFLXzv9/B+hAvLxzaWpWtmDzWanAsXNFWogEL5u
         CofFBTuVXsDTV8lYndW331ukTWquK4ZDTe45mMmhSPeQyffIL426Sfw8l1Z4eIypuYda
         Xp2wp5EiDdHiFVip0H93+p1IiWeVWfPkKTqWntgxoIjcm8dWKzVCarOZOrThzPuUJlUf
         DzNA==
X-Forwarded-Encrypted: i=1; AJvYcCVPmHDgHrRITBgtJzhPzOp8YODMyL9RfNeu6iksCh2VC8Ax8Pm6TAStoqBlLeI45Ve+Nf91yrmAFkU+UebTDxST577c
X-Gm-Message-State: AOJu0YwGisB/Nuh8WLHvbQNS2zF3+sJ7OTS6bd3LKBxZU14pApWXdwdj
	tzxzuATnWoyNZAWDlrDpFq0k6TKRCQs9NNNcSQnfLVBPs6S8s2zRZe0YV3njxA==
X-Google-Smtp-Source: AGHT+IExuEVVJmKP2BNOyB+LtexDDJxYmvvXcikwCbgKNASK/A5xRah0QTnX1g4AE8/nsBFkMxCoNQ==
X-Received: by 2002:a17:90b:343:b0:29a:c992:198e with SMTP id fh3-20020a17090b034300b0029ac992198emr3923483pjb.15.1709231097697;
        Thu, 29 Feb 2024 10:24:57 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id pl4-20020a17090b268400b0029af4116662sm3911274pjb.21.2024.02.29.10.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 10:24:57 -0800 (PST)
Date: Thu, 29 Feb 2024 10:24:56 -0800
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
Subject: Re: [PATCH v1 6/8] kunit: Fix KUNIT_SUCCESS() calls in iov_iter tests
Message-ID: <202402291024.CE0082115@keescook>
References: <20240229170409.365386-1-mic@digikod.net>
 <20240229170409.365386-7-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240229170409.365386-7-mic@digikod.net>

On Thu, Feb 29, 2024 at 06:04:07PM +0100, Mickaël Salaün wrote:
> Fix KUNIT_SUCCESS() calls to pass a test argument.
> 
> This is a no-op for now because this macro does nothing, but it will be
> required for the next commit.
> 
> Cc: Brendan Higgins <brendanhiggins@google.com>
> Cc: David Gow <davidgow@google.com>
> Cc: Rae Moar <rmoar@google.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Mickaël Salaün <mic@digikod.net>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

