Return-Path: <kvm+bounces-10536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DB6586D203
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 19:22:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D27051F21752
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 18:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FDF812C520;
	Thu, 29 Feb 2024 18:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="B9KciT6Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93007828D
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 18:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709230937; cv=none; b=Cs6tAs/fGtDT0c0JsPanRxBmVta3JD8FB/xn5E6mdKbBHekZQQjafMQkplho79T9WmMRLuaiEP30NadsMny8hIsI7uJXhYS36QBwzwKhTu8tfzX/kKX3bpetTRtBT2IsgzLh1InXrH+Avlbyu+k16a/jQLRGaPjdcaEPetc6X7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709230937; c=relaxed/simple;
	bh=fDc9Uwhm++z7zUnn73jE8m6PTGMIZXn9lNaCfrSaFKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O0wabmRw9vb5vjgPqhvwXdn/lJgc6CXdl51LL5XsMoY2CqxJXDDtnDUoBW1sbHQwm7oc2nKhOT9Rtm6h5PE8LtCNuuhiSR3X5TE0UCIOMj+LgWsKkHwsgRwdIXsvKTUCf23x5TUu6bLnfGoNBF+Lk6ZPMdK5XjbJMnflAokb4sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=B9KciT6Z; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dc9222b337so13176145ad.2
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 10:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709230935; x=1709835735; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d0x4aOlew+ChlnlW593MwGC8/uLA2yAII6jDpil+AZo=;
        b=B9KciT6ZaaZF4rRQhqyiILzLdNkpla2QbXXkNeuCqrChpu0qtMIaDWenDbQ8rrSIFh
         9XynGDga/vimj3ueeTB3rdqIRVOjTHTM95CYqqb8qeQr22gNsndvohB4T8KofRerc6rN
         48/S2kHkaGM+eNJMxTNvKpqQO0LME4EEwFUmE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709230935; x=1709835735;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d0x4aOlew+ChlnlW593MwGC8/uLA2yAII6jDpil+AZo=;
        b=iANOSqrOxc9MOpopop2OkAjuP+VvIu+MiUf8fSK0yM5NZbeM7QFRHXfrGMjdyhGlln
         5S53C74MM1eHNGzFNMjjoCnLvwEo3quzKY5YiCo+jWCi4kOCr5mGXt9+yNGykQzlUaRG
         4cYimllWcn1NB7K53CmoLR3s7RTzPSNcslzOJCYG+3D9wCdSFAZNqMrLGmY5eXK9yGvC
         AiPD77ii+t9fIHLenXvzfmVZNLg2I18s3kKLB0Zba421AaUd9zqRISqUNfbqnRfq07Aw
         W41CMNwX+IhgzTh2qHpWxWg0izs10sqHBZgfd9iH02T2C2eA0K6qR0gtnRb3/y1TnocE
         mrCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqMfti4z/+3+oMFFcvtEyfDw7DxQLvFIdtEhr3/yh6mZq8LDi6R6LLjkLSZrxV4N+Dn+r6ormCi7VfHFlPG7J5RcSO
X-Gm-Message-State: AOJu0YzsmYtvv6eJcRC2UPYxUZ+M/Tck3dM9Wci+D62Mjlhb67ZhRQtg
	D0MP1DAQh0gAynwAoWETS+xkcRa+7513+AuP4fT2nTza5uRdPyJoKlrNc7jEIw==
X-Google-Smtp-Source: AGHT+IFHZRhftFXgpyhoht+oIaLzwS0XuiJOF7tco0dVyJI5zhbRvtaKiuO5uiLkXREbQDVyDJP6vw==
X-Received: by 2002:a17:902:6547:b0:1db:e7a4:90a5 with SMTP id d7-20020a170902654700b001dbe7a490a5mr2736748pln.12.1709230935335;
        Thu, 29 Feb 2024 10:22:15 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id u5-20020a170902e5c500b001dcc158df20sm1813098plf.97.2024.02.29.10.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 10:22:14 -0800 (PST)
Date: Thu, 29 Feb 2024 10:22:14 -0800
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
Subject: Re: [PATCH v1 3/8] kunit: Fix kthread reference
Message-ID: <202402291022.A8E2AB8A@keescook>
References: <20240229170409.365386-1-mic@digikod.net>
 <20240229170409.365386-4-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240229170409.365386-4-mic@digikod.net>

On Thu, Feb 29, 2024 at 06:04:04PM +0100, Mickaël Salaün wrote:
> There is a race condition when a kthread finishes after the deadline and
> before the call to kthread_stop(), which may lead to use after free.
> 
> Cc: Brendan Higgins <brendanhiggins@google.com>
> Cc: David Gow <davidgow@google.com>
> Cc: Rae Moar <rmoar@google.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Mickaël Salaün <mic@digikod.net>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

