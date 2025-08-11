Return-Path: <kvm+bounces-54459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D762B21775
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 23:32:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57B66175A35
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 21:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023791459F6;
	Mon, 11 Aug 2025 21:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UbZuVtRy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEB12E5410;
	Mon, 11 Aug 2025 21:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754947908; cv=none; b=tyIujTDWKDGzOEBzm/ZA7+enfJl5hD6YhjKhv6dVFC/Fb/AzYQeTOQWrBa+Kw69Wag7GwmKR3x17uuDwkkNtfMNpWGi7lgsfceFDBXCGqoNGROrYZz+mQxXjUyR/oGrBOhcrb0zg4CEuej1TTEED3Tuub4mcHoniG1vJaOYirY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754947908; c=relaxed/simple;
	bh=U8gxMiryNtRw7XbzRz2WUWc3yNrPO404wjpPtTYpKys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OgTCBI+5E7eyqDAV1agP4Z8VnY7i+9x0Qs965uhhw5wcEE49iR1sY/t8eh5kt50Ge9j8fNNs3ACne5hG4UgWQEn9TjqCkdFa0bd4DE32sOzbJKp2/Tm+Z1rtc4i2t/mDf6Yz5a5kp3YVWc7R3c3JQYp6+GhNY0IMXUp1WOQ+74s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UbZuVtRy; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-24063eac495so37258485ad.0;
        Mon, 11 Aug 2025 14:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754947906; x=1755552706; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+CBSY7pEcoY7IT6fAW9X86821l0k+h/uSbg7K5TUGX8=;
        b=UbZuVtRyYkkY3g8dsryoomRXFjuD0byxPhSRzhQ5XO4PrG/yuhIxq5Yr3ucrDbg4YH
         PXhc30hSkB+0mm3wdqWkvBdOaGsqanI3WcBhkeBEKqvwJ5azhjtOlHIzldUoEILYEX0L
         Yk7UKeuSMip+M6Fpkgig9zLJ5e8cpIzTDc/IjW582Fidq7ZRKDJZBfXpSjTsr5RLh04J
         4I5ybf0QyqZE9wFBDZWkAioSZVhAKJGqdbR2ipOiDlNMtA2/gqrSgSI9AdzztOhc6/Bp
         YHXBS2fp4+grCpJxZoPlVzVkjRn2z/oT45lTSOe11xSeA8ilJJhiiDjGeezDFQsytDMq
         sjtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754947906; x=1755552706;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+CBSY7pEcoY7IT6fAW9X86821l0k+h/uSbg7K5TUGX8=;
        b=TG05A8iY9clHtO4fNhsHidjVS/6IPSUmzOOuq9E4rRVPHb3/cdVnLMHVZTEwCemegv
         J0FtD0kvkqldA8eq3LbKjSXf5U+7vWuABQSqXj21MucQ+AQtB1gCD2KoiozvoJmkbIT/
         PpQcQsxAqBAN/pj47+4v5qyTrjgmo1tcssvZMm66xk+WT3gU03QgvR5xauaU78gNdfHT
         SgfNP6ZtB8DGIgM1Prn0Xqj0hVIHdoQpllsZoesVRhvVeTs5dsNspKhmDo/gBySP3MmI
         qbo7zJ24BzLvbH7f6+7TbHpyuaG0eY+Odx18p70Kve2PhWPIdiUelYwonMZqQXy/sjCX
         cI3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVwpTdhyn8zDKyxcos27FxFqNj0Jiv3RVgE3HcsvhLXfLsY2pZiAl7ucNk8nB1cjIyqMAps7ZxV3Yc8Qgbx@vger.kernel.org, AJvYcCW36NQjN2O7kZ5G8o6LolO4aVWZXqZlpcNyWzWS8vThgMs6WxaRU8HHmIZpsV1ZXEVZBDE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCNyDJ+X+SvCjvRpCJrVyPnlD49szLx6IX0jovDjaGlUB4bu/0
	3iKDh5EXyMXMQ+wkT3oixSTZfaE4Sssykeec9mk7djFaktT05JLBGTg8
X-Gm-Gg: ASbGncvGRGvb4dGz1A74p1YnLybc7OiqLPP683bPjg7sx7zuI1ILLL/0ZcNghHUqR3e
	H6c/FmgglTFlk97wdbY8iJd41t/n6GJYNHEbJL0hvnFkcA2LFl6S4r0y2TlYK3LilIjvhCMvk7M
	QcpIxgYBsiXLObkYAWfBKkjAjZ5GiBKqtIy9lthg7tQk1RMOUkTvMO+tsrwKMFJifOFTZQ8o0vQ
	AMCDiwItFwcH4cV9ab1OxQK/EhusaqItPlqWpC1iRlFXZ/XLIfZpBQZlIrAjdd4fiVONT7CcFjs
	23k3jjiX6DZSXvGkfr6sjXp0eLv4CwZ/J3cUvpFjMYb90fGR3FwYlt17bAfP/QXWD3xfVjKZPgy
	OA8FnLtPVrdNoIudTVQ/Yvw==
X-Google-Smtp-Source: AGHT+IH/f82qcbcfQL6Obdl01P5hIeRbTnRnm/2Zreema/TlKTCggGjlx0JPBjHtFDcjDFoMdKc3NQ==
X-Received: by 2002:a17:902:ecc1:b0:23d:fa76:5c3b with SMTP id d9443c01a7336-242c2003cebmr258699075ad.22.1754947905738;
        Mon, 11 Aug 2025 14:31:45 -0700 (PDT)
Received: from localhost ([216.228.127.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e89768fcsm282167795ad.82.2025.08.11.14.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 14:31:45 -0700 (PDT)
Date: Mon, 11 Aug 2025 17:31:43 -0400
From: Yury Norov <yury.norov@gmail.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Zheyun Shen <szy0127@sjtu.edu.cn>
Subject: Re: [PATCH 1/2] KVM: SVM: don't check have_run_cpus in
 sev_writeback_caches()
Message-ID: <aJphP1UPVs9qVe_0@yury>
References: <20250811203041.61622-1-yury.norov@gmail.com>
 <20250811203041.61622-2-yury.norov@gmail.com>
 <aJpXh3dQNZpmUlHL@google.com>
 <aJpbLX_0WP5jXn7o@yury>
 <aJpe6GM_3edwJXuX@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJpe6GM_3edwJXuX@google.com>

On Mon, Aug 11, 2025 at 02:21:44PM -0700, Sean Christopherson wrote:
> On Mon, Aug 11, 2025, Yury Norov wrote:
> > On Mon, Aug 11, 2025 at 01:50:15PM -0700, Sean Christopherson wrote:
> > > On Mon, Aug 11, 2025, Yury Norov wrote:
> > > > From: Yury Norov (NVIDIA) <yury.norov@gmail.com>
> > > > 
> > > > Before calling wbnoinvd_on_cpus_mask(), the function checks the cpumask
> > > > for emptiness. It's useless, as the following wbnoinvd_on_cpus_mask()
> > > > ends up with smp_call_function_many_cond(), which handles empty cpumask
> > > > correctly.
> > > 
> > > I don't agree that it's useless.  The early check avoids disabling/enabling
> > > preemption (which is cheap, but still), and IMO it makes the KVM code more obviously
> > > correct.  E.g. it takes quite a bit of digging to understand that invoking
> > > wbnoinvd_on_cpus_mask() with an empty mask is ok/fine.
> > > 
> > > I'm not completely opposed to this change, but I also don't see the point.
> > 
> > So, there's a tradeoff between useless preemption cycling, which is
> > O(1) and cpumask_empty(), which is O(N).
> 
> Oh, that argument I buy.  I had it in my head that the check is going to be O(1)
> in practice, because never running vCPU0 would be all kinds of bizarre.  But the
> mask tracks physical CPUs, not virtual CPUs.  E.g. a 2-vCPU VM that's pinned to
> the last 2 pCPUs in the system could indeed trigger several superfluous loads and
> checks.
> 
> > I have no measurements that can support one vs another. But the
> > original patch doesn't discuss it anyhow, as well. So, with the
> > lack of any information on performance impact, I'd stick with the 
> > version that brings less code.
> > 
> > Agree?
> 
> Not sure I agree that less code is always better, but I do agree that dropping
> the check makes sense.  :-)
> 
> How about this?  No need for a v2 (unless you disagree on the tweaks), I'll happily
> fixup when applying.

Sure deal! Thanks.

> --
> From: Yury Norov <yury.norov@gmail.com>
> Date: Mon, 11 Aug 2025 16:30:39 -0400
> Subject: [PATCH] KVM: SEV: don't check have_run_cpus in sev_writeback_caches()
> 
> Drop KVM's check on an empty cpumask when flushing caches when memory is
> being reclaimed from an SEV VM, as smp_call_function_many_cond() naturally
> (and correctly) handles and empty cpumask.  This avoids an extra O(n)
> lookup in the common case where at least one pCPU has enterred the guest,
> which could be noticeable in some setups, e.g. if a small VM is pinned to
> the last few pCPUs in the system.
> 
> Fixes: 6f38f8c57464 ("KVM: SVM: Flush cache only on CPUs running SEV guest")
> Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
> [sean: rewrite changelog to capture performance angle]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 2fbdebf79fbb..0635bd71c10e 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -718,13 +718,6 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
>  
>  static void sev_writeback_caches(struct kvm *kvm)
>  {
> -	/*
> -	 * Note, the caller is responsible for ensuring correctness if the mask
> -	 * can be modified, e.g. if a CPU could be doing VMRUN.
> -	 */
> -	if (cpumask_empty(to_kvm_sev_info(kvm)->have_run_cpus))
> -		return;
> -
>  	/*
>  	 * Ensure that all dirty guest tagged cache entries are written back
>  	 * before releasing the pages back to the system for use.  CLFLUSH will
> @@ -739,6 +732,9 @@ static void sev_writeback_caches(struct kvm *kvm)
>  	 * serializing multiple calls and having responding CPUs (to the IPI)
>  	 * mark themselves as still running if they are running (or about to
>  	 * run) a vCPU for the VM.
> +	 *
> +	 * Note, the caller is responsible for ensuring correctness if the mask
> +	 * can be modified, e.g. if a CPU could be doing VMRUN.
>  	 */
>  	wbnoinvd_on_cpus_mask(to_kvm_sev_info(kvm)->have_run_cpus);
>  }
> 
> base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
> --

