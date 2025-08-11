Return-Path: <kvm+bounces-54458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 24C9DB21759
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 23:28:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 109041A203F1
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 21:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 383CF2E3AFE;
	Mon, 11 Aug 2025 21:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BpcijQyU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B9B2E3386;
	Mon, 11 Aug 2025 21:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754947690; cv=none; b=BAbfVWEXOBLDT932YPis7UrgXjAgLG1CcqTFmt/tXz7bvJNV0SwBcEn/KqpWjbSI6lbqtK/pmfLFlGG1bLrlq3OdxfXIzqk3FPZZ9UMDgzmu7y9+4Ff/UpPXJ50LBpJX1dl8tyQQtfPBe/y6/UkZDFzWGnLugG/XguqiVuhiBfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754947690; c=relaxed/simple;
	bh=L0V+18VZj9f9E28eiffc/LJ/GJjfSKf91z+57LsNvkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l1xRm6bFquUrLI7hapezGiJAJjhzz522TDJSqUTvIzVl8QqF1bybW3Qfd3/WyXoPRilz2gI/JM9iqgaUcQfV2SInLZX3SgiOBRqNAC0F78eL3JqCW9Xw1FaiUlaG8adoRwt4vmrRKJIDGZKsdzg4/moxB8tKmX1T3mf/j9P/5R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BpcijQyU; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-76aea119891so5611480b3a.1;
        Mon, 11 Aug 2025 14:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754947688; x=1755552488; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FJnsytFmX5G5RPCbOFQMa1jkRjOsZOuTcmkVgBgoqlg=;
        b=BpcijQyUrGODxAPoA5j5CQSy23oP4pBHnhVAobup0F5rYizPQCMocMzniMoy+EVhOj
         4L9F0L8ZoOWkhkh412pdKfmY2GyOxsiUo6h6pFn0j3WBC1VA2YOWErVTkRJOrtF6d431
         FSbBPlCe3PkEOHaWJYG/WHXFoP0yIO4iOaFKr7D5IAK6W9etyG2FLWWhgrk0DtkWbKwW
         pxi3jlGbmyp3sBBg7iNDd9RSAC0JuxzIBw97zg1vNdl8HKiuEDduiX/CE42qKBFf00L3
         SlBeyrrUmY4SaR2mUNJfNOn91k/KKkuJ/l3+mK4IK371Xkj9E5dcf9zWSmGeqQpZtN7g
         2D4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754947688; x=1755552488;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FJnsytFmX5G5RPCbOFQMa1jkRjOsZOuTcmkVgBgoqlg=;
        b=evdTm9XFcPWIHp2T98Z3TMrG6MhaX2350H2Ln4r+qRQeWg1dhgUN6MHEgkdqYxvhR6
         c9QpK3OwhLACwtN6CyazoFo7KYhZh/A2i54Z80O4EBZScJjoUi2vDmEQ7qz/dihZ4WbC
         Op7mHZH8QmpwCW504o2oBrFc4KsPoGhSalO47BRIxMcPXExmvhJXaJ8fD6y+fZI7zt7N
         E2GTULUn5XmnepuVwRFP7DvWhWNdBTPMea1d9BLWSUCMC1iwdMLtVzZeOpBIJowxItAf
         ez8yMJ8bdAFLO/Evxg4zThsbAVC5hrFrvAUtYPkRrBIPMlJsKb+npyvcIhfJme6EipGT
         O6Tg==
X-Forwarded-Encrypted: i=1; AJvYcCWXLbwp+z8r+2+H0grNawXSNkx9StKHrgvHoQHPmy/hdY0Bz2jFlsxwEg3+avSkh56POiaFTMavMNbjCOc+@vger.kernel.org, AJvYcCXGeKrpshjrNKguO479mlaH2OB07Mn3jJYtB/Kpr9d4B2M9V5AUiRV8TQwC3Hwnwtqo29o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFiwqQWlA3lZGTYN+75PvYqxYk3eYAGgoKg/1ITakyhRkSsrYw
	2MYq/bfKry/xGSVkBWqVN0DxLRV6NdxkTw6VEjmg4XTOE5wGy5cW/wr73KiQRg==
X-Gm-Gg: ASbGncsJ9bE3PHgKWt7x8yU1B8ZOwQDP48T7gTS5cGehBdtC9TFa94M+CqMdpxUvw4r
	LbUtIHo9hOhGBuhkB2AszudgtlcgfStb+yMWg9gEBr3EHlh6dO6svyseIYqYZgGm9UmxZ6NJEd0
	RZub6wL5XC5A0dlfMVi7mvxyJNepYqgZ5jeRtnVWz1AhkPJLPxAI6aJEYKQrBtMxwsEfqiZ5qnw
	/8afPLOPPEYTz4ildcls3KkQlGel8UdWk7kMqyWApzgIPnjvUhlo9ENIDXfX+w/Wu1FHxF7GJzn
	qbmZqwoauJriNvJJvbdBIZXTAq0k8SF79dISdnMHmojpaq+fesI4cm4ccBNxhl+gMF/GqGoBPmw
	XZqxUxwemtZxCwy8N3wthIQ==
X-Google-Smtp-Source: AGHT+IEh4LNiAlTi1QN1/JAxIcTJGRXTQc1ucfP74VU9R029xY/AyJERJzIYKY1T5tT9gDc3sKo2gw==
X-Received: by 2002:a05:6a21:6da1:b0:234:4f73:e657 with SMTP id adf61e73a8af0-2409a21e9b1mr1891990637.0.1754947688253;
        Mon, 11 Aug 2025 14:28:08 -0700 (PDT)
Received: from localhost ([216.228.127.130])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4263836324sm16492503a12.10.2025.08.11.14.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 14:28:07 -0700 (PDT)
Date: Mon, 11 Aug 2025 17:28:05 -0400
From: Yury Norov <yury.norov@gmail.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Zheyun Shen <szy0127@sjtu.edu.cn>
Subject: Re: [PATCH 2/2] KVM: SVM: drop useless cpumask_test_cpu() in
 pre_sev_run()
Message-ID: <aJpgZeC8SEHfQ0EY@yury>
References: <20250811203041.61622-1-yury.norov@gmail.com>
 <20250811203041.61622-3-yury.norov@gmail.com>
 <aJpWet3USvXLWYEZ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJpWet3USvXLWYEZ@google.com>

On Mon, Aug 11, 2025 at 01:45:46PM -0700, Sean Christopherson wrote:
> On Mon, Aug 11, 2025, Yury Norov wrote:
> > Testing cpumask for a CPU to be cleared just before setting the exact
> > same CPU is useless because the end result is always the same: CPU is
> > set.
> 
> No, it is not useless.  Blindly writing to the variable will unnecessarily bounce
> the cacheline, and this is a hot path.

How hot is that path? How bad the cache contention is? Is there any evidence
that conditional cpumask_set_cpu() worth the effort? The original patch
doesn't discuss that at all, and without any comment the code looks just
buggy.

> > While there, switch CPU setter to a non-atomic version. Atomicity is
> > useless here 
> 
> No, atomicity isn't useless here either.  Dropping atomicity could result in
> CPU's bit being lost.  I.e. the atomic accesses aren't for the benefit of
> smp_call_function_many_cond(), the writes are atomic so that multiple vCPUs can
> concurrently update the mask without needing additional protection.

OK, I see. Something heavy hit my head before I decided to drop
atomicity there.

> > because sev_writeback_caches() ends up with a plain
> > for_each_cpu() loop in smp_call_function_many_cond(), which is not
> > atomic by nature.
> 
> That's fine.  As noted in sev_writeback_caches(), if vCPU could be running, then
> the caller is responsible for ensuring that all vCPUs flush caches before the
> memory being reclaimed is fully freed.  Those guarantees are provided by KVM's
> MMU.
> 
> sev_writeback_caches() => smp_call_function_many_cond() could hit false positives,
> i.e. trigger WBINVD on CPUs that couldn't possibly have accessed the memory being
> reclaimed, but such false positives are functionally benign, and are "intended"
> in the sense that we chose to prioritize simplicity over precision.

So, I don't object to drop the patch, but it would be really nice to
have this 
                        if (!cpumask_test_cpu())
                                cpumask_set_cpu()

pattern explained, and even better supported with performance numbers.


Thanks,
Yury

