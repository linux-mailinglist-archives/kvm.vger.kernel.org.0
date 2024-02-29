Return-Path: <kvm+bounces-10535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3143186D1FF
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 19:22:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91817B2501C
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 18:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 854F2134421;
	Thu, 29 Feb 2024 18:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="oPn0oM3h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11536134410
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 18:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709230912; cv=none; b=TMoIGV6y2fP3kg0Erm++5TCxU9qaA+yalxQdBAd5aX3+YRHj+DQiJma+euCIJrxNMFvt9jNUCo5IltxuKx5G1jaaeFwW27Q5ALTgg5I/RHqym2NysCxIac4d89JQMG+pQYKpEDPfrZbb6BOlcLVTbaa0iim/fnHqk3oFF1bDYBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709230912; c=relaxed/simple;
	bh=YL/SyMq50QLHRa6w1uhHS9ErDLnXGftgcw+i2diIQZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eLE0X/xPOn6AGKlQ8qI/Q6MEOeGC9LPsLHBddt0RE7F/mLl5NaauElI6gsXYpoD6hunHhBU1cqXvrwO04o7WY42bYpJyXCZiyf0nYuN17eb5JjUY3z+KbKToGnUL0GAS9r5IET2bCi1a+Pz95y0K3dBHrZsknNgUopNnRLNtEvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=oPn0oM3h; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3c1a1e1e539so1226896b6e.1
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 10:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709230909; x=1709835709; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yXpj2r2UG5nknOxqJR2jUPNqVqUgtdngKnqrB/4KOeU=;
        b=oPn0oM3hBHX9yRPVgDCgyYl2WY/6iqVSv2StMCNrJZbuvSi4gLCNH+QHd79HZUn63f
         fQEFhH1iYT2xdKneqnl65Mk1Ik0sgiwA8ImV1/8C/KrEgwgSDIvpweNIEwv1thPMcRZR
         gwhRwumWhubt/uiwxs9eMbRkeu+4CJ2jRsAqs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709230909; x=1709835709;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yXpj2r2UG5nknOxqJR2jUPNqVqUgtdngKnqrB/4KOeU=;
        b=qu3WE8FFCack91imUnD38LfloeLwYC31eZzqjsa5PSXCob51FGEgQp/iJ05n8qcLAV
         eA2BPgZMDlJ8byBq2BPa3CyNQ1sTHoWLCT3nz0JSJGEy5txU17YTFfslaVJTcdp8qtk9
         jvUZkr2d+Qs/fnCdmaZ5eaAFyJ8hXuR6LBgUoOPDOAUaOD8CSE1uOePGbD1KHj9SFUAH
         9CJZGOg2NCypMV3Vk2LGVNzIyj8KkgyoY1WmvGZayFA1JtnzJf2w8m5h8AFEueyAFgSn
         NnLUtrYbwbwk2URl/A+xlaEheAYqDxhlTY0U3oxZY3n990/igEaLWBE54UkfTQf0vTiL
         0qeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhs1ISMiDYOGnceEaK//yaL3PWP8gsen8PmgRg8P7jBhswLRdITr2aRkTG+dAKeS9bLnDfmv7sP6fNMUMWPMPe0Isv
X-Gm-Message-State: AOJu0YxqiE9u5vhRBxKVzsoLe9+SpIOj0IUS3QnO6RA5xQGb0xpeUwYE
	FnYOnJ2bHo5gnwEHjx1Wz1FmGG6mgVcs3Q8iMR2yFBxQJnPjo0urBQVP3QTcTQ==
X-Google-Smtp-Source: AGHT+IERpkPQz2QB9IYFYaYwAdfGdaisE77tDyny+LVcbAZefwDQDU4gXxLqYhBKqHQ71m4zzv55/g==
X-Received: by 2002:a05:6808:3089:b0:3c1:cc65:5737 with SMTP id bl9-20020a056808308900b003c1cc655737mr1233505oib.16.1709230909255;
        Thu, 29 Feb 2024 10:21:49 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id j2-20020a056a00234200b006e56e5abc0bsm1556931pfj.51.2024.02.29.10.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 10:21:48 -0800 (PST)
Date: Thu, 29 Feb 2024 10:21:48 -0800
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
Subject: Re: [PATCH v1 2/8] kunit: Handle thread creation error
Message-ID: <202402291021.43ED7D2@keescook>
References: <20240229170409.365386-1-mic@digikod.net>
 <20240229170409.365386-3-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240229170409.365386-3-mic@digikod.net>

On Thu, Feb 29, 2024 at 06:04:03PM +0100, Mickaël Salaün wrote:
> Previously, if a thread creation failed (e.g. -ENOMEM), the function was
> called (kunit_catch_run_case or kunit_catch_run_case_cleanup) without
> marking the test as failed.  Instead, fill try_result with the error
> code returned by kthread_run(), which will mark the test as failed and
> print "internal error occurred...".
> 
> Cc: Brendan Higgins <brendanhiggins@google.com>
> Cc: David Gow <davidgow@google.com>
> Cc: Rae Moar <rmoar@google.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Mickaël Salaün <mic@digikod.net>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

