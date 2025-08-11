Return-Path: <kvm+bounces-54452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B1173B216EE
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 23:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C91E47A9B38
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 21:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D13412E3AF3;
	Mon, 11 Aug 2025 21:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nUiUgcc2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23742E2832;
	Mon, 11 Aug 2025 21:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754946354; cv=none; b=p11wjPRDGBb7acVFDHRFao1KY5z6MqGHYk7XDrX71c+jhj4gjR05MACwojvaPWYsaYr9z+QD81SXdageCzhn/RblJyFQO6NSNsZ5/HRQtxW8VRDivjI7Lsmf/qUx6m19igdouPTkXBmcSX0MrAcwcSINonblIAlZlV/2Fo40dY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754946354; c=relaxed/simple;
	bh=1Nk1N11Mf4isi3ccvxVhmmggqekUWYZz++yNa4E+52I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HuYB1J5cpuGBwGtZF5fs0eknMhsKVkO235s/WCYfEAtO/Q+wlcAH59kA1GETa0qHcI3h1bjKgbyCo0vsbBNeil2Sm85YgYxnqbxzfIW41/+9Ca8WfhWlK7F4H6J+upSfbEV3UoKtM0JVRGqd+VbyR6IEvcha+StXQxcL1c2mxO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nUiUgcc2; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-76b8d289f73so4502192b3a.1;
        Mon, 11 Aug 2025 14:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754946352; x=1755551152; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pucYViOMBgtcD0obTb6QOAskbVEKILYR6hTM07nkFnA=;
        b=nUiUgcc2LZnjnwetKhPMTJdw4U1AymTLB+cw/+h3ZIBfOzcoMAV/+sLUBLqN4GEWtg
         l2iueRSa06sUErlGgQ+OXzV64Q/dwHPxBIEee8eSKT9RFiad3BnNh29hj7yb9ndNL0cf
         EmCCtVx4YKGMT5AmLsXQQGQbQe2PC6pYEzKuD3ubKvElfoZD5qthYlbMNmF1SkZkMNiD
         OMRX+IKIG2d37l9LNLgViuV2oX8IKp0wcUM6ccsO2EnC11liDuJIRDJN+xJ/UjSaxWoy
         RsKbqj4JpUta/XIuygrydQp8qGUrhf4fCBy1yqVIBAoMrp/7NEl56VaXsOrT7ol1L8X3
         dSsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754946352; x=1755551152;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pucYViOMBgtcD0obTb6QOAskbVEKILYR6hTM07nkFnA=;
        b=b+iZPz7G9tRHLju2SPWDfEccCMz+8Tpxiw6g5W+7SQ4mQW1jRYrNWw5/U0+onQBIgi
         qIPa5+sxkX1CQXz+fId5jzkQOJ2FfcMLglPyZs53Gcfh+AhHHuHFn7Ai1PunuQxXQ/d1
         ltqU5v/bV7b74Pa47vVSstUsyOWu3DLf145i9WwSqMvfCd6xu71NBbvwPdeXGhVLMcs5
         yHE08xLUdhKNqe6cIcB9+3kYmjIm/n6v+IS5pqr1X2IKQZEuUVUSJmZFGNWdIx04ZGMx
         w0LrgALGAyFKeCZmM5M/o3+ZNSE0NBp1ZdXuFHaNNmEsWye9K3NveEV81o8KJdjc9QLW
         1d8g==
X-Forwarded-Encrypted: i=1; AJvYcCU9RtNT595OTE8IJZob13AawlXCGXiCK6ydZ82R6ghDB+JGfhmsBYVjE69Smei3c+YKARk=@vger.kernel.org, AJvYcCVU5OtYWFgV4HiYr06TQuA5lFaVuGB7JzJzA6xzEROvGmL4P3eS6PBfC7tE8OEWR2d1t8Gugh9pDqsi46v5@vger.kernel.org
X-Gm-Message-State: AOJu0YztRYVrtSxuy3YsobRbv61cy3g/9uu262y0ztiI98YvwD1m+u4m
	5dQjmpNXM/N0RfdtSTz5lI+YHi5JshrA+qZLujNKPHIGFlfPUPaviWk9
X-Gm-Gg: ASbGncsqY7jIVOcrBe0OoPYgKZ9SJY1e1cYEMMg7IbIJ75UgSQg3QASzBTXdEE0p6k/
	OcHkF4oxxw25HIX6YBab001lGTmBQVgzXI33pQAm5dmqjUZOcQ5Tyglk9HNK328Xy7Ysjs6UP1W
	kYHv8Tsq8GyfhB1yU9fWsEbB2PQkPpeg5p6Vvko8uWARlqGI8Ib64GNrd5WF5RBLGtrY7fCKF1U
	KRLGz5lu2APQuPCjL5ZfDkwHJIw7YPjYoszpqcDVIQUSgUSJ9qRs7ODRB2A5tGcCqSrsqLqbQNU
	OwgNJxl+ucp/XGYBj7S+PvjYW2hCbIl6Vkj0EJIsN+7TGAnKR4OaFkhNyZm0kFAAYDZuX3ttnz6
	BuUqmV87BPveAARi4b9oacg==
X-Google-Smtp-Source: AGHT+IG/yIxsGyAGBIYKxJnQLPWhqKtrrcMjEUCyUUUzIRM1qMq4Ch61mKXUViyhJ+EvYBk8PciDjQ==
X-Received: by 2002:a05:6a20:2447:b0:240:168b:31b with SMTP id adf61e73a8af0-2409a8be38dmr1363082637.16.1754946351849;
        Mon, 11 Aug 2025 14:05:51 -0700 (PDT)
Received: from localhost ([216.228.127.130])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bfc270514sm20681059b3a.12.2025.08.11.14.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 14:05:51 -0700 (PDT)
Date: Mon, 11 Aug 2025 17:05:49 -0400
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
Message-ID: <aJpbLX_0WP5jXn7o@yury>
References: <20250811203041.61622-1-yury.norov@gmail.com>
 <20250811203041.61622-2-yury.norov@gmail.com>
 <aJpXh3dQNZpmUlHL@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJpXh3dQNZpmUlHL@google.com>

On Mon, Aug 11, 2025 at 01:50:15PM -0700, Sean Christopherson wrote:
> On Mon, Aug 11, 2025, Yury Norov wrote:
> > From: Yury Norov (NVIDIA) <yury.norov@gmail.com>
> > 
> > Before calling wbnoinvd_on_cpus_mask(), the function checks the cpumask
> > for emptiness. It's useless, as the following wbnoinvd_on_cpus_mask()
> > ends up with smp_call_function_many_cond(), which handles empty cpumask
> > correctly.
> 
> I don't agree that it's useless.  The early check avoids disabling/enabling
> preemption (which is cheap, but still), and IMO it makes the KVM code more obviously
> correct.  E.g. it takes quite a bit of digging to understand that invoking
> wbnoinvd_on_cpus_mask() with an empty mask is ok/fine.
> 
> I'm not completely opposed to this change, but I also don't see the point.

So, there's a tradeoff between useless preemption cycling, which is
O(1) and cpumask_empty(), which is O(N).

I have no measurements that can support one vs another. But the
original patch doesn't discuss it anyhow, as well. So, with the
lack of any information on performance impact, I'd stick with the 
version that brings less code.

Agree?

