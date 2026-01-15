Return-Path: <kvm+bounces-68263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 65B63D291CB
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 23:50:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BE1103076743
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 22:50:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A2D932ABC1;
	Thu, 15 Jan 2026 22:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ihLcShTb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EC12EBDDE
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 22:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768517402; cv=none; b=fN0oUJ8c+aC2+n6feZJACxXm2v+9zrTtab9vA/RH+SYySaI1pkoY7WdMXk4Ncco1lm6bHBJRq3pTjPvCCJ7vZBCf6ewYoq0wSbFRvetoKrNY8tQ9yDc9lumQnTZQ4C+ICTcFoAq/kQTR5BCnrZI1W7IB7XMGkYNiKm7Ar+zNHBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768517402; c=relaxed/simple;
	bh=eKWUSRezhgQUKR6mjWtdzsS8Ic9ONFbPugk0AUNtUz0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S8jnPXYkaydLQ73fvQp7BGXttjtZ7jdoLO4ICXB8y7QTz1/VAmIOzmUYMpI45fx1hgMJj1mh9h9rKqQaXc/D2Dws6Y+4eZNQeQ6bI3oAfaj90VHfOqWET+Wv6tLmiZP8WtRs68+rnATA3REjpl3Eq/vPPSZTjx8lRfmCqI58kb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ihLcShTb; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c43f8ef9bso2370476a91.1
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 14:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768517400; x=1769122200; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3lvuC8n2hoqVbi+jpXkhnYGqcRXSY0sCfjwBRIoz6LU=;
        b=ihLcShTbsiJrgtiLxIJ3g88DJbjLKl7B7KGY1NSH1nNf9gKJYNrNoMHdTg69XVpsu7
         jDWhOB3wgA+f9Okm8MHuMI3eZjvmigJiYz7WfsEgolFS7Xuk3avWedT8JbPX86bXgvRO
         pJyCk9TjBJ4wc20f0OAwHNUKoftc3cDt5wo4mdIGNJyH6q9rxjlTQ8Ogl/B4P5vQjXgj
         raWfacNx+DRzYpsMjksBf0Xc/OuW7angyLPMyzMb6rJ8hfPkUjlGnLirCzy1Upn8RV2k
         KFMMIn5WGuOVNOwrdKhazvXng05nwUtV7WaoMljzxgIQEPpnQzp1/koXRfpuy6KAr+Da
         a6AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768517400; x=1769122200;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3lvuC8n2hoqVbi+jpXkhnYGqcRXSY0sCfjwBRIoz6LU=;
        b=DVu4GwMrIOsFgmql/C90Zf4NNulmE0ck6tPmdwngsAtTlYAtI9TofXQvoPxUOc/TiV
         +j8gOUlA9GlCn2JZd5OnduUWgf3espNbBGL5sDfJNyd00HF34rRVKl36Zy6Iy+6PxwHX
         RUO7zjr++cVrVNdGMpyIWXfPPwnjEq3mRb4TebyFHpTwOo6u0y87Eruzprwd6xeQe1dW
         RCBj5jpqzdh/8kC5tulUlrIedgTAeuCElVC4WuXSwp5MLN/tjAjOOuptVqqZ1tL8PL0u
         k+MTyKr0a6FauZIr+VXMFTm7cEd9rnfAX4GN0f5Fha2dfRdK8hen/MGwRkT4sM8c0BIL
         pICg==
X-Forwarded-Encrypted: i=1; AJvYcCX/XDcbP40fNsbKknO6BQE1lkx5IT/m0Y6lYgJoj0bHoG0tOmnIPS592GRpw8qflTmrgUc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3nNjWR6F7DQd0ktOniiC1i2yLDpk+J654UtUpqWAwdi4/mCPX
	cKEqJNkUDU+vozkB2Xp5ISqbG+hPuCHhXB0jobX3YUakUSxsopXNH5adZSol+igx4hvnEobNe2E
	VPrJZpQ==
X-Received: from pjbnc12.prod.google.com ([2002:a17:90b:37cc:b0:34c:d212:cb7f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:570f:b0:32e:72bd:6d5a
 with SMTP id 98e67ed59e1d1-35272bcba8cmr975439a91.1.1768517400490; Thu, 15
 Jan 2026 14:50:00 -0800 (PST)
Date: Thu, 15 Jan 2026 14:49:59 -0800
In-Reply-To: <20260106102024.25023-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <20260106102024.25023-1-yan.y.zhao@intel.com>
Message-ID: <aWlvF2rld0Nz3nRz@google.com>
Subject: Re: [PATCH v3 06/24] KVM: x86/mmu: Disallow page merging (huge page
 adjustment) for mirror root
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	x86@kernel.org, rick.p.edgecombe@intel.com, dave.hansen@intel.com, 
	kas@kernel.org, tabba@google.com, ackerleytng@google.com, 
	michael.roth@amd.com, david@kernel.org, vannapurve@google.com, 
	sagis@google.com, vbabka@suse.cz, thomas.lendacky@amd.com, 
	nik.borisov@suse.com, pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 06, 2026, Yan Zhao wrote:
> From: Rick P Edgecombe <rick.p.edgecombe@intel.com>
> 
> Disallow page merging (huge page adjustment) for the mirror root by
> utilizing disallowed_hugepage_adjust().

Why?  What is this actually doing?  The below explains "how" but I'm baffled as
to the purpose.  I'm guessing there are hints in the surrounding patches, but I
haven't read them in depth, and shouldn't need to in order to understand the
primary reason behind a change.

